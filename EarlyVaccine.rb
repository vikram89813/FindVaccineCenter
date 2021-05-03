

require 'json'
require 'net/http'
require 'date'

STATES_MAP = 
{"andaman and nicobar islands"=>{"state_id"=>1, "state_name"=>"Andaman and Nicobar Islands", "districts_map"=>{"nicobar"=>3, "north and middle andaman"=>1, "south andaman"=>2}, "district_ids"=>[3, 1, 2]}, "andhra pradesh"=>{"state_id"=>2, "state_name"=>"Andhra Pradesh", "districts_map"=>{"anantapur"=>9, "chittoor"=>10, "east godavari"=>11, "guntur"=>5, "krishna"=>4, "kurnool"=>7, "prakasam"=>12, "sri potti sriramulu nellore"=>13, "srikakulam"=>14, "visakhapatnam"=>8, "vizianagaram"=>15, "west godavari"=>16, "ysr district, kadapa (cuddapah)"=>6}, "district_ids"=>[9, 10, 11, 5, 4, 7, 12, 13, 14, 8, 15, 16, 6]}, "arunachal pradesh"=>{"state_id"=>3, "state_name"=>"Arunachal Pradesh", "districts_map"=>{"anjaw"=>22, "changlang"=>20, "dibang valley"=>25, "east kameng"=>23, "east siang"=>42, "itanagar capital complex"=>17, "kamle"=>24, "kra daadi"=>27, "kurung kumey"=>21, "lepa rada"=>33, "lohit"=>29, "longding"=>40, "lower dibang valley"=>31, "lower siang"=>18, "lower subansiri"=>32, "namsai"=>36, "pakke kessang"=>19, "papum pare"=>39, "shi yomi"=>35, "siang"=>37, "tawang"=>30, "tirap"=>26, "upper siang"=>34, "upper subansiri"=>41, "west kameng"=>28, "west siang"=>38}, "district_ids"=>[22, 20, 25, 23, 42, 17, 24, 27, 21, 33, 29, 40, 31, 18, 32, 36, 19, 39, 35, 37, 30, 26, 34, 41, 28, 38]}, "assam"=>{"state_id"=>4, "state_name"=>"Assam", "districts_map"=>{"baksa"=>46, "barpeta"=>47, "biswanath"=>765, "bongaigaon"=>57, "cachar"=>66, "charaideo"=>766, "chirang"=>58, "darrang"=>48, "dhemaji"=>62, "dhubri"=>59, "dibrugarh"=>43, "dima hasao"=>67, "goalpara"=>60, "golaghat"=>53, "hailakandi"=>68, "hojai"=>764, "jorhat"=>54, "kamrup metropolitan"=>49, "kamrup rural"=>50, "karbi-anglong"=>51, "karimganj"=>69, "kokrajhar"=>61, "lakhimpur"=>63, "majuli"=>767, "morigaon"=>55, "nagaon"=>56, "nalbari"=>52, "sivasagar"=>44, "sonitpur"=>64, "south salmara mankachar"=>768, "tinsukia"=>45, "udalguri"=>65, "west karbi anglong"=>769}, "district_ids"=>[46, 47, 765, 57, 66, 766, 58, 48, 62, 59, 43, 67, 60, 53, 68, 764, 54, 49, 50, 51, 69, 61, 63, 767, 55, 56, 52, 44, 64, 768, 45, 65, 769]}, "bihar"=>{"state_id"=>5, "state_name"=>"Bihar", "districts_map"=>{"araria"=>74, "arwal"=>78, "aurangabad"=>77, "banka"=>83, "begusarai"=>98, "bhagalpur"=>82, "bhojpur"=>99, "buxar"=>100, "darbhanga"=>94, "east champaran"=>105, "gaya"=>79, "gopalganj"=>104, "jamui"=>107, "jehanabad"=>91, "kaimur"=>80, "katihar"=>75, "khagaria"=>101, "kishanganj"=>76, "lakhisarai"=>84, "madhepura"=>70, "madhubani"=>95, "munger"=>85, "muzaffarpur"=>86, "nalanda"=>90, "nawada"=>92, "patna"=>97, "purnia"=>73, "rohtas"=>81, "saharsa"=>71, "samastipur"=>96, "saran"=>102, "sheikhpura"=>93, "sheohar"=>87, "sitamarhi"=>88, "siwan"=>103, "supaul"=>72, "vaishali"=>89, "west champaran"=>106}, "district_ids"=>[74, 78, 77, 83, 98, 82, 99, 100, 94, 105, 79, 104, 107, 91, 80, 75, 101, 76, 84, 70, 95, 85, 86, 90, 92, 97, 73, 81, 71, 96, 102, 93, 87, 88, 103, 72, 89, 106]}, "chandigarh"=>{"state_id"=>6, "state_name"=>"Chandigarh", "districts_map"=>{"chandigarh"=>108}, "district_ids"=>[108]}, "chhattisgarh"=>{"state_id"=>7, "state_name"=>"Chhattisgarh", "districts_map"=>{"balod"=>110, "baloda bazar"=>111, "balrampur"=>112, "bastar"=>113, "bemetara"=>114, "bijapur"=>115, "bilaspur"=>116, "dantewada"=>117, "dhamtari"=>118, "durg"=>119, "gariaband"=>120, "gaurela pendra marwahi "=>136, "janjgir-champa"=>121, "jashpur"=>122, "kanker"=>123, "kawardha"=>135, "kondagaon"=>124, "korba"=>125, "koriya"=>126, "mahasamund"=>127, "mungeli"=>128, "narayanpur"=>129, "raigarh"=>130, "raipur"=>109, "rajnandgaon"=>131, "sukma"=>132, "surajpur"=>133, "surguja"=>134}, "district_ids"=>[110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 136, 121, 122, 123, 135, 124, 125, 126, 127, 128, 129, 130, 109, 131, 132, 133, 134]}, "dadra and nagar haveli"=>{"state_id"=>8, "state_name"=>"Dadra and Nagar Haveli", "districts_map"=>{"dadra and nagar haveli"=>137}, "district_ids"=>[137]}, "daman and diu"=>{"state_id"=>37, "state_name"=>"Daman and Diu", "districts_map"=>{"daman"=>138, "diu"=>139}, "district_ids"=>[138, 139]}, "delhi"=>{"state_id"=>9, "state_name"=>"Delhi", "districts_map"=>{"central delhi"=>141, "east delhi"=>145, "new delhi"=>140, "north delhi"=>146, "north east delhi"=>147, "north west delhi"=>143, "shahdara"=>148, "south delhi"=>149, "south east delhi"=>144, "south west delhi"=>150, "west delhi"=>142}, "district_ids"=>[141, 145, 140, 146, 147, 143, 148, 149, 144, 150, 142]}, "goa"=>{"state_id"=>10, "state_name"=>"Goa", "districts_map"=>{"north goa"=>151, "south goa"=>152}, "district_ids"=>[151, 152]}, "gujarat"=>{"state_id"=>11, "state_name"=>"Gujarat", "districts_map"=>{"ahmedabad"=>154, "ahmedabad corporation"=>770, "amreli"=>174, "anand"=>179, "aravalli"=>158, "banaskantha"=>159, "bharuch"=>180, "bhavnagar"=>175, "bhavnagar corporation"=>771, "botad"=>176, "chhotaudepur"=>181, "dahod"=>182, "dang"=>163, "devbhumi dwaraka"=>168, "gandhinagar"=>153, "gandhinagar corporation"=>772, "gir somnath"=>177, "jamnagar"=>169, "jamnagar corporation"=>773, "junagadh"=>178, "junagadh corporation"=>774, "kheda"=>156, "kutch"=>170, "mahisagar"=>183, "mehsana"=>160, "morbi"=>171, "narmada"=>184, "navsari"=>164, "panchmahal"=>185, "patan"=>161, "porbandar"=>172, "rajkot"=>173, "rajkot corporation"=>775, "sabarkantha"=>162, "surat"=>165, "surat corporation"=>776, "surendranagar"=>157, "tapi"=>166, "vadodara"=>155, "vadodara corporation"=>777, "valsad"=>167}, "district_ids"=>[154, 770, 174, 179, 158, 159, 180, 175, 771, 176, 181, 182, 163, 168, 153, 772, 177, 169, 773, 178, 774, 156, 170, 183, 160, 171, 184, 164, 185, 161, 172, 173, 775, 162, 165, 776, 157, 166, 155, 777, 167]}, "haryana"=>{"state_id"=>12, "state_name"=>"Haryana", "districts_map"=>{"ambala"=>193, "bhiwani"=>200, "charkhi dadri"=>201, "faridabad"=>199, "fatehabad"=>196, "gurgaon"=>188, "hisar"=>191, "jhajjar"=>189, "jind"=>204, "kaithal"=>190, "karnal"=>203, "kurukshetra"=>186, "mahendragarh"=>206, "nuh"=>205, "palwal"=>207, "panchkula"=>187, "panipat"=>195, "rewari"=>202, "rohtak"=>192, "sirsa"=>194, "sonipat"=>198, "yamunanagar"=>197}, "district_ids"=>[193, 200, 201, 199, 196, 188, 191, 189, 204, 190, 203, 186, 206, 205, 207, 187, 195, 202, 192, 194, 198, 197]}, "himachal pradesh"=>{"state_id"=>13, "state_name"=>"Himachal Pradesh", "districts_map"=>{"bilaspur"=>219, "chamba"=>214, "hamirpur"=>217, "kangra"=>213, "kinnaur"=>216, "kullu"=>211, "lahaul spiti"=>210, "mandi"=>215, "shimla"=>208, "sirmaur"=>212, "solan"=>209, "una"=>218}, "district_ids"=>[219, 214, 217, 213, 216, 211, 210, 215, 208, 212, 209, 218]}, "jammu and kashmir"=>{"state_id"=>14, "state_name"=>"Jammu and Kashmir", "districts_map"=>{"anantnag"=>224, "bandipore"=>223, "baramulla"=>225, "budgam"=>229, "doda"=>232, "ganderbal"=>228, "jammu"=>230, "kathua"=>234, "kishtwar"=>231, "kulgam"=>221, "kupwara"=>226, "poonch"=>238, "pulwama"=>227, "rajouri"=>237, "ramban"=>235, "reasi"=>239, "samba"=>236, "shopian"=>222, "srinagar"=>220, "udhampur"=>233}, "district_ids"=>[224, 223, 225, 229, 232, 228, 230, 234, 231, 221, 226, 238, 227, 237, 235, 239, 236, 222, 220, 233]}, "jharkhand"=>{"state_id"=>15, "state_name"=>"Jharkhand", "districts_map"=>{"bokaro"=>242, "chatra"=>245, "deoghar"=>253, "dhanbad"=>257, "dumka"=>258, "east singhbhum"=>247, "garhwa"=>243, "giridih"=>256, "godda"=>262, "gumla"=>251, "hazaribagh"=>255, "jamtara"=>259, "khunti"=>252, "koderma"=>241, "latehar"=>244, "lohardaga"=>250, "pakur"=>261, "palamu"=>246, "ramgarh"=>254, "ranchi"=>240, "sahebganj"=>260, "seraikela kharsawan"=>248, "simdega"=>249, "west singhbhum"=>263}, "district_ids"=>[242, 245, 253, 257, 258, 247, 243, 256, 262, 251, 255, 259, 252, 241, 244, 250, 261, 246, 254, 240, 260, 248, 249, 263]}, "karnataka"=>{"state_id"=>16, "state_name"=>"Karnataka", "districts_map"=>{"bagalkot"=>270, "bangalore rural"=>276, "bangalore urban"=>265, "bbmp"=>294, "belgaum"=>264, "bellary"=>274, "bidar"=>272, "chamarajanagar"=>271, "chikamagalur"=>273, "chikkaballapur"=>291, "chitradurga"=>268, "dakshina kannada"=>269, "davanagere"=>275, "dharwad"=>278, "gadag"=>280, "gulbarga"=>267, "hassan"=>289, "haveri"=>279, "kodagu"=>283, "kolar"=>277, "koppal"=>282, "mandya"=>290, "mysore"=>266, "raichur"=>284, "ramanagara"=>292, "shimoga"=>287, "tumkur"=>288, "udupi"=>286, "uttar kannada"=>281, "vijayapura"=>293, "yadgir"=>285}, "district_ids"=>[270, 276, 265, 294, 264, 274, 272, 271, 273, 291, 268, 269, 275, 278, 280, 267, 289, 279, 283, 277, 282, 290, 266, 284, 292, 287, 288, 286, 281, 293, 285]}, "kerala"=>{"state_id"=>17, "state_name"=>"Kerala", "districts_map"=>{"alappuzha"=>301, "ernakulam"=>307, "idukki"=>306, "kannur"=>297, "kasaragod"=>295, "kollam"=>298, "kottayam"=>304, "kozhikode"=>305, "malappuram"=>302, "palakkad"=>308, "pathanamthitta"=>300, "thiruvananthapuram"=>296, "thrissur"=>303, "wayanad"=>299}, "district_ids"=>[301, 307, 306, 297, 295, 298, 304, 305, 302, 308, 300, 296, 303, 299]}, "ladakh"=>{"state_id"=>18, "state_name"=>"Ladakh", "districts_map"=>{"kargil"=>309, "leh"=>310}, "district_ids"=>[309, 310]}, "lakshadweep"=>{"state_id"=>19, "state_name"=>"Lakshadweep", "districts_map"=>{"agatti island"=>796, "lakshadweep"=>311}, "district_ids"=>[796, 311]}, "madhya pradesh"=>{"state_id"=>20, "state_name"=>"Madhya Pradesh", "districts_map"=>{"agar"=>320, "alirajpur"=>357, "anuppur"=>334, "ashoknagar"=>354, "balaghat"=>338, "barwani"=>343, "betul"=>362, "bhind"=>351, "bhopal"=>312, "burhanpur"=>342, "chhatarpur"=>328, "chhindwara"=>337, "damoh"=>327, "datia"=>350, "dewas"=>324, "dhar"=>341, "dindori"=>336, "guna"=>348, "gwalior"=>313, "harda"=>361, "hoshangabad"=>360, "indore"=>314, "jabalpur"=>315, "jhabua"=>340, "katni"=>353, "khandwa"=>339, "khargone"=>344, "mandla"=>335, "mandsaur"=>319, "morena"=>347, "narsinghpur"=>352, "neemuch"=>323, "panna"=>326, "raisen"=>359, "rajgarh"=>358, "ratlam"=>322, "rewa"=>316, "sagar"=>317, "satna"=>333, "sehore"=>356, "seoni"=>349, "shahdol"=>332, "shajapur"=>321, "sheopur"=>346, "shivpuri"=>345, "sidhi"=>331, "singrauli"=>330, "tikamgarh"=>325, "ujjain"=>318, "umaria"=>329, "vidisha"=>355}, "district_ids"=>[320, 357, 334, 354, 338, 343, 362, 351, 312, 342, 328, 337, 327, 350, 324, 341, 336, 348, 313, 361, 360, 314, 315, 340, 353, 339, 344, 335, 319, 347, 352, 323, 326, 359, 358, 322, 316, 317, 333, 356, 349, 332, 321, 346, 345, 331, 330, 325, 318, 329, 355]}, "maharashtra"=>{"state_id"=>21, "state_name"=>"Maharashtra", "districts_map"=>{"ahmednagar"=>391, "akola"=>364, "amravati"=>366, "aurangabad "=>397, "beed"=>384, "bhandara"=>370, "buldhana"=>367, "chandrapur"=>380, "dhule"=>388, "gadchiroli"=>379, "gondia"=>378, "hingoli"=>386, "jalgaon"=>390, "jalna"=>396, "kolhapur"=>371, "latur"=>383, "mumbai"=>395, "nagpur"=>365, "nanded"=>382, "nandurbar"=>387, "nashik"=>389, "osmanabad"=>381, "palghar"=>394, "parbhani"=>385, "pune"=>363, "raigad"=>393, "ratnagiri"=>372, "sangli"=>373, "satara"=>376, "sindhudurg"=>374, "solapur"=>375, "thane"=>392, "wardha"=>377, "washim"=>369, "yavatmal"=>368}, "district_ids"=>[391, 364, 366, 397, 384, 370, 367, 380, 388, 379, 378, 386, 390, 396, 371, 383, 395, 365, 382, 387, 389, 381, 394, 385, 363, 393, 372, 373, 376, 374, 375, 392, 377, 369, 368]}, "manipur"=>{"state_id"=>22, "state_name"=>"Manipur", "districts_map"=>{"bishnupur"=>398, "chandel"=>399, "churachandpur"=>400, "imphal east"=>401, "imphal west"=>402, "jiribam"=>410, "kakching"=>413, "kamjong"=>409, "kangpokpi"=>408, "noney"=>412, "pherzawl"=>411, "senapati"=>403, "tamenglong"=>404, "tengnoupal"=>407, "thoubal"=>405, "ukhrul"=>406}, "district_ids"=>[398, 399, 400, 401, 402, 410, 413, 409, 408, 412, 411, 403, 404, 407, 405, 406]}, "meghalaya"=>{"state_id"=>23, "state_name"=>"Meghalaya", "districts_map"=>{"east garo hills"=>424, "east jaintia hills"=>418, "east khasi hills"=>414, "north garo hills"=>423, "ri-bhoi"=>417, "south garo hills"=>421, "south west garo hills"=>422, "south west khasi hills"=>415, "west garo hills"=>420, "west jaintia hills"=>416, "west khasi hills"=>419}, "district_ids"=>[424, 418, 414, 423, 417, 421, 422, 415, 420, 416, 419]}, "mizoram"=>{"state_id"=>24, "state_name"=>"Mizoram", "districts_map"=>{"aizawl east"=>425, "aizawl west"=>426, "champhai"=>429, "kolasib"=>428, "lawngtlai"=>432, "lunglei"=>431, "mamit"=>427, "serchhip"=>430, "siaha"=>433}, "district_ids"=>[425, 426, 429, 428, 432, 431, 427, 430, 433]}, "nagaland"=>{"state_id"=>25, "state_name"=>"Nagaland", "districts_map"=>{"dimapur"=>434, "kiphire"=>444, "kohima"=>441, "longleng"=>438, "mokokchung"=>437, "mon"=>439, "peren"=>435, "phek"=>443, "tuensang"=>440, "wokha"=>436, "zunheboto"=>442}, "district_ids"=>[434, 444, 441, 438, 437, 439, 435, 443, 440, 436, 442]}, "odisha"=>{"state_id"=>26, "state_name"=>"Odisha", "districts_map"=>{"angul"=>445, "balangir"=>448, "balasore"=>447, "bargarh"=>472, "bhadrak"=>454, "boudh"=>468, "cuttack"=>457, "deogarh"=>473, "dhenkanal"=>458, "gajapati"=>467, "ganjam"=>449, "jagatsinghpur"=>459, "jajpur"=>460, "jharsuguda"=>474, "kalahandi"=>464, "kandhamal"=>450, "kendrapara"=>461, "kendujhar"=>455, "khurda"=>446, "koraput"=>451, "malkangiri"=>469, "mayurbhanj"=>456, "nabarangpur"=>470, "nayagarh"=>462, "nuapada"=>465, "puri"=>463, "rayagada"=>471, "sambalpur"=>452, "subarnapur"=>466, "sundargarh"=>453}, "district_ids"=>[445, 448, 447, 472, 454, 468, 457, 473, 458, 467, 449, 459, 460, 474, 464, 450, 461, 455, 446, 451, 469, 456, 470, 462, 465, 463, 471, 452, 466, 453]}, "puducherry"=>{"state_id"=>27, "state_name"=>"Puducherry", "districts_map"=>{"karaikal"=>476, "mahe"=>477, "puducherry"=>475, "yanam"=>478}, "district_ids"=>[476, 477, 475, 478]}, "punjab"=>{"state_id"=>28, "state_name"=>"Punjab", "districts_map"=>{"amritsar"=>485, "barnala"=>483, "bathinda"=>493, "faridkot"=>499, "fatehgarh sahib"=>484, "fazilka"=>487, "ferozpur"=>480, "gurdaspur"=>489, "hoshiarpur"=>481, "jalandhar"=>492, "kapurthala"=>479, "ludhiana"=>488, "mansa"=>482, "moga"=>491, "pathankot"=>486, "patiala"=>494, "rup nagar"=>497, "sangrur"=>498, "sas nagar"=>496, "sbs nagar"=>500, "sri muktsar sahib"=>490, "tarn taran"=>495}, "district_ids"=>[485, 483, 493, 499, 484, 487, 480, 489, 481, 492, 479, 488, 482, 491, 486, 494, 497, 498, 496, 500, 490, 495]}, "rajasthan"=>{"state_id"=>29, "state_name"=>"Rajasthan", "districts_map"=>{"ajmer"=>507, "alwar"=>512, "banswara"=>519, "baran"=>516, "barmer"=>528, "bharatpur"=>508, "bhilwara"=>523, "bikaner"=>501, "bundi"=>514, "chittorgarh"=>521, "churu"=>530, "dausa"=>511, "dholpur"=>524, "dungarpur"=>520, "hanumangarh"=>517, "jaipur i"=>505, "jaipur ii"=>506, "jaisalmer"=>527, "jalore"=>533, "jhalawar"=>515, "jhunjhunu"=>510, "jodhpur"=>502, "karauli"=>525, "kota"=>503, "nagaur"=>532, "pali"=>529, "pratapgarh"=>522, "rajsamand"=>518, "sawai madhopur"=>534, "sikar"=>513, "sirohi"=>531, "sri ganganagar"=>509, "tonk"=>526, "udaipur"=>504}, "district_ids"=>[507, 512, 519, 516, 528, 508, 523, 501, 514, 521, 530, 511, 524, 520, 517, 505, 506, 527, 533, 515, 510, 502, 525, 503, 532, 529, 522, 518, 534, 513, 531, 509, 526, 504]}, "sikkim"=>{"state_id"=>30, "state_name"=>"Sikkim", "districts_map"=>{"east sikkim"=>535, "north sikkim"=>537, "south sikkim"=>538, "west sikkim"=>536}, "district_ids"=>[535, 537, 538, 536]}, "tamil nadu"=>{"state_id"=>31, "state_name"=>"Tamil Nadu", "districts_map"=>{"aranthangi"=>779, "ariyalur"=>555, "attur"=>578, "chengalpet"=>565, "chennai"=>571, "cheyyar"=>778, "coimbatore"=>539, "cuddalore"=>547, "dharmapuri"=>566, "dindigul"=>556, "erode"=>563, "kallakurichi"=>552, "kanchipuram"=>557, "kanyakumari"=>544, "karur"=>559, "kovilpatti"=>780, "krishnagiri"=>562, "madurai"=>540, "nagapattinam"=>576, "namakkal"=>558, "nilgiris"=>577, "palani"=>564, "paramakudi"=>573, "perambalur"=>570, "poonamallee"=>575, "pudukkottai"=>546, "ramanathapuram"=>567, "ranipet"=>781, "salem"=>545, "sivaganga"=>561, "sivakasi"=>580, "tenkasi"=>551, "thanjavur"=>541, "theni"=>569, "thoothukudi (tuticorin)"=>554, "tiruchirappalli"=>560, "tirunelveli"=>548, "tirupattur"=>550, "tiruppur"=>568, "tiruvallur"=>572, "tiruvannamalai"=>553, "tiruvarur"=>574, "vellore"=>543, "viluppuram"=>542, "virudhunagar"=>549}, "district_ids"=>[779, 555, 578, 565, 571, 778, 539, 547, 566, 556, 563, 552, 557, 544, 559, 780, 562, 540, 576, 558, 577, 564, 573, 570, 575, 546, 567, 781, 545, 561, 580, 551, 541, 569, 554, 560, 548, 550, 568, 572, 553, 574, 543, 542, 549]}, "telangana"=>{"state_id"=>32, "state_name"=>"Telangana", "districts_map"=>{"adilabad"=>582, "bhadradri kothagudem"=>583, "hyderabad"=>581, "jagtial"=>584, "jangaon"=>585, "jayashankar bhupalpally"=>586, "jogulamba gadwal"=>587, "kamareddy"=>588, "karimnagar"=>589, "khammam"=>590, "kumuram bheem"=>591, "mahabubabad"=>592, "mahabubnagar"=>593, "mancherial"=>594, "medak"=>595, "medchal"=>596, "mulugu"=>612, "nagarkurnool"=>597, "nalgonda"=>598, "narayanpet"=>613, "nirmal"=>599, "nizamabad"=>600, "peddapalli"=>601, "rajanna sircilla"=>602, "rangareddy"=>603, "sangareddy"=>604, "siddipet"=>605, "suryapet"=>606, "vikarabad"=>607, "wanaparthy"=>608, "warangal(rural)"=>609, "warangal(urban)"=>610, "yadadri bhuvanagiri"=>611}, "district_ids"=>[582, 583, 581, 584, 585, 586, 587, 588, 589, 590, 591, 592, 593, 594, 595, 596, 612, 597, 598, 613, 599, 600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 610, 611]}, "tripura"=>{"state_id"=>33, "state_name"=>"Tripura", "districts_map"=>{"dhalai"=>614, "gomati"=>615, "khowai"=>616, "north tripura"=>617, "sepahijala"=>618, "south tripura"=>619, "unakoti"=>620, "west tripura"=>621}, "district_ids"=>[614, 615, 616, 617, 618, 619, 620, 621]}, "uttar pradesh"=>{"state_id"=>34, "state_name"=>"Uttar Pradesh", "districts_map"=>{"agra"=>622, "aligarh"=>623, "ambedkar nagar"=>625, "amethi"=>626, "amroha"=>627, "auraiya"=>628, "ayodhya"=>646, "azamgarh"=>629, "badaun"=>630, "baghpat"=>631, "bahraich"=>632, "balarampur"=>633, "ballia"=>634, "banda"=>635, "barabanki"=>636, "bareilly"=>637, "basti"=>638, "bhadohi"=>687, "bijnour"=>639, "bulandshahr"=>640, "chandauli"=>641, "chitrakoot"=>642, "deoria"=>643, "etah"=>644, "etawah"=>645, "farrukhabad"=>647, "fatehpur"=>648, "firozabad"=>649, "gautam buddha nagar"=>650, "ghaziabad"=>651, "ghazipur"=>652, "gonda"=>653, "gorakhpur"=>654, "hamirpur"=>655, "hapur"=>656, "hardoi"=>657, "hathras"=>658, "jalaun"=>659, "jaunpur"=>660, "jhansi"=>661, "kannauj"=>662, "kanpur dehat"=>663, "kanpur nagar"=>664, "kasganj"=>665, "kaushambi"=>666, "kushinagar"=>667, "lakhimpur kheri"=>668, "lalitpur"=>669, "lucknow"=>670, "maharajganj"=>671, "mahoba"=>672, "mainpuri"=>673, "mathura"=>674, "mau"=>675, "meerut"=>676, "mirzapur"=>677, "moradabad"=>678, "muzaffarnagar"=>679, "pilibhit"=>680, "pratapgarh"=>682, "prayagraj"=>624, "raebareli"=>681, "rampur"=>683, "saharanpur"=>684, "sambhal"=>685, "sant kabir nagar"=>686, "shahjahanpur"=>688, "shamli"=>689, "shravasti"=>690, "siddharthnagar"=>691, "sitapur"=>692, "sonbhadra"=>693, "sultanpur"=>694, "unnao"=>695, "varanasi"=>696}, "district_ids"=>[622, 623, 625, 626, 627, 628, 646, 629, 630, 631, 632, 633, 634, 635, 636, 637, 638, 687, 639, 640, 641, 642, 643, 644, 645, 647, 648, 649, 650, 651, 652, 653, 654, 655, 656, 657, 658, 659, 660, 661, 662, 663, 664, 665, 666, 667, 668, 669, 670, 671, 672, 673, 674, 675, 676, 677, 678, 679, 680, 682, 624, 681, 683, 684, 685, 686, 688, 689, 690, 691, 692, 693, 694, 695, 696]}, "uttarakhand"=>{"state_id"=>35, "state_name"=>"Uttarakhand", "districts_map"=>{"almora"=>704, "bageshwar"=>707, "chamoli"=>699, "champawat"=>708, "dehradun"=>697, "haridwar"=>702, "nainital"=>709, "pauri garhwal"=>698, "pithoragarh"=>706, "rudraprayag"=>700, "tehri garhwal"=>701, "udham singh nagar"=>705, "uttarkashi"=>703}, "district_ids"=>[704, 707, 699, 708, 697, 702, 709, 698, 706, 700, 701, 705, 703]}, "west bengal"=>{"state_id"=>36, "state_name"=>"West Bengal", "districts_map"=>{"alipurduar district"=>710, "bankura"=>711, "basirhat hd (north 24 parganas)"=>712, "birbhum"=>713, "bishnupur hd (bankura)"=>714, "cooch behar"=>715, "coochbehar"=>783, "dakshin dinajpur"=>716, "darjeeling"=>717, "diamond harbor hd (s 24 parganas)"=>718, "east bardhaman"=>719, "hoogly"=>720, "howrah"=>721, "jalpaiguri"=>722, "jhargram"=>723, "kalimpong"=>724, "kolkata"=>725, "malda"=>726, "murshidabad"=>727, "nadia"=>728, "nandigram hd (east medinipore)"=>729, "north 24 parganas"=>730, "paschim medinipore"=>731, "purba medinipore"=>732, "purulia"=>733, "rampurhat hd (birbhum)"=>734, "south 24 parganas"=>735, "uttar dinajpur"=>736, "west bardhaman"=>737}, "district_ids"=>[710, 711, 712, 713, 714, 715, 783, 716, 717, 718, 719, 720, 721, 722, 723, 724, 725, 726, 727, 728, 729, 730, 731, 732, 733, 734, 735, 736, 737]}}
DISTRICT_MAP = {}
STATES_MAP.each do |state_name,state_data|
	state_data['districts_map'].each do |district_name,district_id|
		DISTRICT_MAP[district_id.to_s] = district_name
	end		
end	
def update_results district_id,query_date
	

# uri = URI("https://cdn-api.co-vin.in/api/v2/appointment/sessions/calendarByDistrict?district_id=#{district_id}&date=#{query_date}")

# request = Net::HTTP::Get.new(uri)
# request["User-Agent"] = "#{rand(3004)}Gdozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) QAppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36#{rand(200)}"

# response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => (uri.scheme == 'https')) {|http|
#   http.request(request)
# }

# if  response.code == 200
# res =  response.body
# else
# 	puts 'failed ' + response.body
# end


command = "curl -s 'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=#{district_id}&date=#{query_date}'"

res = `#{command}`

res =  JSON.parse(res)




	if !res['centers'].nil? && res['centers'].size > 0
		res['centers'].each do  |center|

			
			if 	!center['sessions'].nil? && center['sessions'].length > 0
				sessions = center['sessions']					
				sessions.each do |session|
					
					#puts "session['min_age_limit']  == " + session['min_age_limit'].to_s
					#puts "session['available_capacity']  == " + session['available_capacity'].to_s
					if !session['min_age_limit'].nil? && session['min_age_limit'].to_i == 18	 && session['available_capacity'].to_i > 0 
						if session['vaccine'] == 'COVAXIN'
							result = {'district_name' => center['district_name'],'center_name' => center['name'],'date' => session['date'],'available_capacity' => session['available_capacity']}
					   ResultsCovaxin << result				 
						else
							result = {'district_name' => center['district_name'],'center_name' => center['name'],'date' => session['date'],'available_capacity' => session['available_capacity']}
					   ResultsOther << result				 
						end		
					   
					end
				end
			end

		end
	end

end	

#district_ids = ['141','145','140','146','147','143','148','149','144','150','142','188']
district_ids = []



state_name =  ARGV[0].to_s.downcase.strip
city_name =  ARGV[1].to_s.downcase.strip
if state_name != '' && !STATES_MAP[state_name.downcase].nil?
	if city_name != '' && !STATES_MAP[state_name.downcase]['districts_map'][city_name].nil?
		district_ids  << STATES_MAP[state_name.downcase]['districts_map'][city_name].to_s
	elsif city_name == ''
		STATES_MAP[state_name.downcase]['district_ids'].each do |district_id|
			district_ids << district_id.to_s
		end			
	else
		puts ""
		puts "---------"
		puts "Invalid district name! Possible district names in #{state_name} are #{STATES_MAP[state_name.downcase]['districts_map'].keys}"	
		puts "---------"
		puts ""
		return	
	end		
elsif state_name == ''
	puts ""
	puts "---------"
	puts "Please input state name!  Possible state names are #{STATES_MAP.keys}"		
	puts "---------"
	puts "Example command to fire ruby ~/Downloads/EarlyVaccine.rb 'haryana' to get earliest available vaccination slot  for 18+ in all of Haryana in next 6 weeks"
	puts "---------"
	puts "Example command to fire ruby ~/Downloads/EarlyVaccine.rb 'haryana' 'gurgaon' to get earliest available vaccination slot for 18+ in Gurgaon in next 6 weeks"	
	puts "---------"
	puts ""
	return
else
	puts ""
	puts "---------"
	puts "Invalid state name! Possible state names are #{STATES_MAP.keys}"		
	puts "---------"
	puts ""
	return
end	

if city_name != ''
	puts ""
	puts "---------"
	puts "Finding earliest available vaccination slot for 18+ in  #{city_name.upcase}, #{state_name.upcase} in next 6 weeks ... "
	puts ""
else
	puts ""
	puts "---------"
	puts "Finding earliest available vaccination slot for 18+ in  #{state_name.upcase} in next 6 weeks ... "
	puts ""
end	


ResultsCovaxin = []
ResultsOther = []

district_ids.each do |district_id|

	current_date  = Date.today.strftime('%d-%m-%Y')
	6.times do |i|

		query_date =  (Date.today + i*7).strftime('%d-%m-%Y').to_s
		puts "Checking for district #{DISTRICT_MAP[district_id]} week of #{query_date}"  
		update_results(district_id,query_date)
	end	
	
end	

if ResultsCovaxin.size > 0
	puts ''
	puts ''
	puts '-----------------------------------Earliest Covaxin-----------------------------------'
	puts ''
	puts ResultsCovaxin.sort {|a,b| a['date'] <=> b['date'] }
else
	puts ''
	puts ''
	puts "-----------------------------------No Covaxin Available for 18+ in next 6 weeks in  #{city_name.upcase} #{state_name.upcase}  -----------------------------------"
	puts ''	
end	

if ResultsOther.size > 0 
	puts ''
	puts '-----------------------------------Earliest Covishield-----------------------------------'
	puts ''
	puts ResultsOther.sort {|a,b| a['date'] <=> b['date'] }
	puts ''
else
	puts ''
	puts "-----------------------------------No Covishield Available for 18+ in next 6 weeks in  #{city_name.upcase} #{state_name.upcase}  -----------------------------------"
	puts ''
	puts ''
end	
# puts 'sorted result Non-Covaxin'
# puts ResultsOther.sort {|a,b| a['date'] <=> b['date'] }.sort {|b,a| a['available_capacity'] <=> b['available_capacity'] }




