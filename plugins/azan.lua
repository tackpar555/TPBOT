--[[
 _____ ____     ____   ___ _____ 
|_   _|  _ \   | __ ) / _ \_   _|
  | | | |_) |  |  _ \| | | || |  
  | | |  __/   | |_) | |_| || |  
  |_| |_|      |____/ \___/ |_|  
                                 
KASPER  TP (BY @kasper_dev)
 _  __    _    ____  ____  _____ ____     _____ ____  
| |/ /   / \  / ___||  _ \| ____|  _ \   |_   _|  _ \ 
| ' /   / _ \ \___ \| |_) |  _| | |_) |    | | | |_) |
| . \  / ___ \ ___) |  __/| |___|  _ <     | | |  __/ 
|_|\_\/_/   \_\____/|_|   |_____|_| \_\    |_| |_|    
                                                      
--]]
do
function run_bash(str)
    local cmd = io.popen(str)
    local result = cmd:read('*all')
    return result
end
local api_key = nil
local base_api = "https://maps.googleapis.com/maps/api"
function get_latlong(area)
  local api      = base_api .. "/geocode/json?"
  local parameters = "address=".. (URL.escape(area) or "")
  if api_key ~= nil then
    parameters = parameters .. "&key="..api_key
  end
  local res, code = https.request(api..parameters)
  if code ~=200 then return nil  end
  local data = json:decode(res)
 
  if (data.status == "ZERO_RESULTS") then
    return nil
  end
  if (data.status == "OK") then
    lat  = data.results[1].geometry.location.lat
    lng  = data.results[1].geometry.location.lng
    acc  = data.results[1].geometry.location_type
    types= data.results[1].types
    return lat,lng,acc,types
  end
end
function get_staticmap(area)
  local api        = base_api .. "/staticmap?"
  local lat,lng,acc,types = get_latlong(area)

  local scale = types[1]
  if     scale=="locality" then zoom=8
  elseif scale=="country"  then zoom=4
  else zoom = 13 end
    
  local parameters =
    "size=600x300" ..
    "&zoom="  .. zoom ..
    "&center=" .. URL.escape(area) ..
    "&markers=color:red"..URL.escape("|"..area)

  if api_key ~=nil and api_key ~= "" then
    parameters = parameters .. "&key="..api_key
  end
  return lat, lng, api..parameters
end


function run(msg, matches)
	local hash = 'usecommands:'..msg.from.id..':'..msg.to.id
	redis:incr(hash)
	local receiver	= get_receiver(msg)
	local city = matches[1]
	if matches[1] == 'azan' or matches[1] == 'اذان' then
	city = 'Baghdad'
	end
	local lat,lng,url	= get_staticmap(city)

	local dumptime = run_bash('date +%s')
	local code = http.request('http://api.aladhan.com/timings/'..dumptime..'?latitude='..lat..'&longitude='..lng..'&timezonestring=Asia/Baghdad&method=7')
	local jdat = json:decode(code)
	local data = jdat.data.timings
	local text = '⛪️مـديـنـة : '..city
	 text = text..'\n🕌آذان الـصـبـح: '..data.Fajr
   text = text..'\n🕌شـروق الـشـمـس: '..data.Sunrise
   text = text..'\n🕌آذان الـظـهـر: '..data.Dhuhr
   text = text..'\n🕌الـغـروب: '..data.Sunset
   text = text..'\n🕌آذان الـمـغـرب: '..data.Maghrib
   text = text..'\n🕌آذان الـعـشـاء : '..data.Isha
   text = text..'\n\nchannel : @dev_kasper'
	if string.match(text, '0') then text = string.gsub(text, '0', '0') end
	if string.match(text, '1') then text = string.gsub(text, '1', '1') end
	if string.match(text, '2') then text = string.gsub(text, '2', '2') end
	if string.match(text, '3') then text = string.gsub(text, '3', '3') end
	if string.match(text, '4') then text = string.gsub(text, '4', '4') end
	if string.match(text, '5') then text = string.gsub(text, '5', '5') end 
	if string.match(text, '6') then text = string.gsub(text, '6', '6') end
	if string.match(text, '7') then text = string.gsub(text, '7', '7') end
	if string.match(text, '8') then text = string.gsub(text, '8', '8') end
	if string.match(text, '9') then text = string.gsub(text, '9', '9') end
	return text
end

return {
    patterns = {"^[/!]azan (.*)$","^[/!](azan)$","^اذان (.*)$","^(اذان)$"},   

    run = run }
end
--[[
 _____ ____     ____   ___ _____ 
|_   _|  _ \   | __ ) / _ \_   _|
  | | | |_) |  |  _ \| | | || |  
  | | |  __/   | |_) | |_| || |  
  |_| |_|      |____/ \___/ |_|  
                                 
KASPER  TP (BY @kasper_dev)
 _  __    _    ____  ____  _____ ____     _____ ____  
| |/ /   / \  / ___||  _ \| ____|  _ \   |_   _|  _ \ 
| ' /   / _ \ \___ \| |_) |  _| | |_) |    | | | |_) |
| . \  / ___ \ ___) |  __/| |___|  _ <     | | |  __/ 
|_|\_\/_/   \_\____/|_|   |_____|_| \_\    |_| |_|    
                                                      
--]]