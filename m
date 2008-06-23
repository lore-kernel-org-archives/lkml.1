Return-Path: <linux-kernel-owner+w=401wt.eu-S1757624AbYFWKkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbYFWKkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 06:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbYFWKkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 06:40:23 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:59578 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbYFWKkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 06:40:22 -0400
Message-ID: <485F7DB0.2030302@keyaccess.nl>
Date: Mon, 23 Jun 2008 12:40:48 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: Hans de Goede <j.w.r.degoede@hhs.nl>, linux-acpi@vger.kernel.org,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [lm-sensors] [REGRESSION, ABI] Re:  LMSENSORS: 2.6.26-rc,	enabling
 ACPI Termal Zone support costs sensors
References: <485DA11C.7050906@keyaccess.nl> <485DFF35.6080008@hhs.nl>	 <485E505F.8010306@keyaccess.nl> <485E61DE.6020202@hhs.nl>	 <485E6F12.4010307@keyaccess.nl> <485E94ED.10602@hhs.nl>	 <485E992B.8010101@keyaccess.nl>  <485ECB23.4010305@keyaccess.nl> <1214185482.3001.45.camel@rzhang-dt.sh.intel.com>
In-Reply-To: <1214185482.3001.45.camel@rzhang-dt.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23-06-08 03:44, Zhang Rui wrote:

> On Mon, 2008-06-23 at 05:58 +0800, Rene Herman wrote:
>> On 22-06-08 20:25, Rene Herman wrote:
>>
>>> Another way to solve it _could_ be to just make up a device link if
>>> something generic is available so that sensors doesn't trip over it
>>> in the first place but I don't know if that's a good option. You
>>> might.
>> This also works for me and, if correct, is ofcourse better than the
>> CONFIG option. Wants a comment from the thermal_zone side (for which
>> Zhang Rui seems the correct CC?) though.
> Hi, Rene and Hans,
> 
> Thank you for your efforts on this issue and sorry for the late
> response, I did not check my email during the whole weekend.
> 
> About the hwmon ABI, after the device symbol link is created, are there
> any other ABIs required in the device node?

Doesn't seem to. libsensors-2.10.6 is happy with this at least.

> If no, this patch seems to work, although it might break if the first
> registered ACPI thermal zone device is unregistered, which ONLY happens
> theoretically.

Mmm. Because more thermal zones may share one hwmon interface I gather?
Do you feel this is an okay minimal fix for 2.6.26 or is there something 
else trivial enough available? We're late in the -rc stage...

>> From: Rene Herman <rene.herman@gmail.com>
>> Date: Sun, 22 Jun 2008 23:45:04 +0200
>> Subject: [PATCH] thermal: link the virtual/thermal/thermal_zoneN device for hwmon
>>
>> 2.6.26-rc gained a hwmon interface to the ACPI Thermal Zone
>> driver which unfortunately breaks lm-sensors 2 userspace and
>> renders all other (subsequent) hwmon sensors inoperable also.
>>
>> Many systems, current slackware systems among them, are still
>> using lm-sensors 2 and would be affected.
>>
>> The problem is userspace tripping over an absent "device"
>> link in the ACPI Thermal Zone sysfs /sys/class/hwmon/hwmonN
>> directory. This just adds the virtual "thermal/thermal_zoneN"
>> device as a device backlink which satisfies lm-sensors again.
>>
>> Tested and looks fairly obvious, but this wants comment from
>> a thermal_zone person, to confirm/deny that this is a proper
>> device pointer to use here for one.
>>
>> Signed-off-by: Rene Herman <rene.herman@gmail.com>
>> CC: Hans de Goede <j.w.r.degoede@hhs.nl>
>> CC: Zhang Rui <rui.zhang@intel.com>
>> CC: Mark M. Hoffman <mhoffman@lightlink.com>
>> CC: Jean Delvare <khali@linux-fr.org>
>> CC: linux-acpi@vger.kernel.org
>> CC: lm-sensors@lm-sensors.org
>> CC; linux-kernel@vger.kernal.org
>> ---
>>  drivers/thermal/thermal_sys.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
>> index 6098787..c21e03c 100644
>> --- a/drivers/thermal/thermal_sys.c
>> +++ b/drivers/thermal/thermal_sys.c
>> @@ -357,7 +357,7 @@ thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
>>  
>>  	INIT_LIST_HEAD(&hwmon->tz_list);
>>  	strlcpy(hwmon->type, tz->type, THERMAL_NAME_LENGTH);
>> -	hwmon->device = hwmon_device_register(NULL);
>> +	hwmon->device = hwmon_device_register(&tz->device);
>>  	if (IS_ERR(hwmon->device)) {
>>  		result = PTR_ERR(hwmon->device);
>>  		goto free_mem;
> 
> 

