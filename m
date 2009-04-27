Return-Path: <linux-kernel-owner+w=401wt.eu-S1760082AbZD0S5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082AbZD0S5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755131AbZD0S45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:56:57 -0400
Received: from smtprelay11.ispgateway.de ([80.67.29.28]:60406 "EHLO
	smtprelay11.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbZD0S45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:56:57 -0400
References: <cone.1240623959.159615.9486.1000@mentalhome> <cone.1240648971.372002.7492.1000@mentalhome> <20090426172947.GB3643@liondog.tnic>
Message-ID: <cone.1240858632.795110.5316.1000@onepiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: petkovbb@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] Acer Aspire One Fan Control
Date: Mon, 27 Apr 2009 20:57:12 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

thank you very much for your email.

Borislav Petkov writes:

> I did some testing on my Aspire One machine here and it looks pretty
> nice: while compiling a kernel watched the fan going on when the
> temperature reaches 67-68 (I don't think this is Celsius though, no?)
> and then turning itself off when temp goes below 60.

It is Celsius, the specification of the chipset and the atom core say that 
the chips are allowed to get 99 degree celsuis hot. So I think 70 degree 
Celsius are fine.

>>
>> +config ACERHDF
>> +	tristate "Acer Aspire One temperature and fan driver"
>> +	depends on THERMAL
>> +	depends on THERMAL_HWMON
> 
> depends on THERMAL && THERMAL_HWMON

What do you mean? Sorry, don't get it.

>> +/* module parameters */
>> +module_param(interval, int, 0600);
>> +MODULE_PARM_DESC(interval, "Polling interval of temperature check");
>> +module_param(fanon, int, 0600);
> 
> This allows for the user to potentially melt his CPU by entering a too high
> value. You should check that in the acerhdf_init() against the max allowed
> according to spec, I gather it is 67?

I will add a maximum temperature, I guess something about 80 degree 
Celsuis. But anyways, the user can still melt his/her cpu by switching to 
user mode and turning off the fan.

>> +struct bios_settings_t {
>> +	const char *vendor;
>> +	const char *version;
>> +	unsigned char fanreg;
>> +	unsigned char tempreg;
>> +	unsigned char cmd_off;
>> +	unsigned char cmd_auto;
>> +	unsigned char state_off;
> 
> obviously cmd_off and state_off are the same values so remove one of them.

I think it makes sense to leave it this way, because we don't know, what 
acer does for the next BIOS release :)

> let's put a prefix to all those function names, otherwise their names
> are all too generic:

Yes, will do that.

> 
> get_temp -> acerhdf_get_temp
> change_fanstate -> acerhdf_change_fanstate
> 

> you can wrap all those "if (verbose)"-checks in a macro making the code more
> readable:

Hm... I like those "if (verbose)" lines, as you can see directly, when the 
line is printed and don't have to search for the acerhdf_printk definition.

>> +	ec_write(bios_settings[bios_version].fanreg,
>> +			(state) ? bios_settings[bios_version].cmd_auto :
>> +			bios_settings[bios_version].cmd_off);
> 
> too unreadable.
> 
> how about:
> 
> 	u8 cmd = (state) ? bios_settings[bios_version].cmd_auto
> 			 : bios_settings[bios_version].cmd_off;
> 
> 	ec_write(bios_settings[bios_version].fanreg, cmd);

yes will do it your way.

>> +/* return temperature */
> 
> no need for stating the obvious.

jip :)

>> +/* set operation mode;
>> + * kernel: a kernel thread takes care about managing the
>> + *	 fan (see acerhdf_thread)
> 
> where is that acerhdf_thread? maybe stale comment from the kthread bits?

Old comment, will correct it.

> 
>> + * user: kernel thread is stopped and a userspace tool
>> + *	 should take care about managing the fan
>> + */
>> +static int set_mode(struct thermal_zone_device *thermal,
>> +		enum thermal_device_mode mode)
>> +{
>> +	if (mode == THERMAL_DEVICE_DISABLED) {
>> +		if (verbose)
>> +			printk(KERN_NOTICE "acerhdf: kernelmode OFF\n");
> 
> those printk's shouldn't depend on verbose since this is important info
> IMHO and I want to know that I've changed modes successfully and that my
> CPU doesn't get fried.

I think they should only be printed out in verbose mode, as it would flood 
the log file otherwise. Besides that the people who use this module can 
trust it as it is in the mainline kernel :)

>> +	*temperature = 89;
> 
> #define ACERHDF_TEMP_CRIT 89

jip.

>> +/* print current fan state */
>> +static int get_cur_state(struct thermal_cooling_device *cdev,
>> +		unsigned long *state)
>> +{
>> +	*state = get_fanstate();
> 
> you need error handling here:
> 
> 	if (*state < 0) {
> 		*state = 0xffff;
> 		return 1;
> 	}
> 	return 0;
> 
> or some other invalid value similar to how it's done in get_temp()
> above.

Will do it.

>> +	if (state && !old_state)
>> +		change_fanstate(1);
> 
> let's have defines for those fan states
> #define ACERHDF_FAN_OFF		0
> #define ACERHDF_FAN_AUTO	1
> 
> and then do
> 
> change_fanstate(ACERHDF_FAN_AUTO);

jip.

>> +	/* if started in user mode, prevent the kernel from switching
>> +	 * off the fan */
>> +	if (!kernelmode) {
>> +		recently_changed = 1;
>> +		printk(KERN_NOTICE
>> +			"acerhdf: kernelmode disabled\n");
>> +		printk(KERN_NOTICE
>> +			"acerhdf: to enable kernelmode:\n");
>> +		printk(KERN_NOTICE
>> +			"acerhdf: echo -n \"enabled\" > "
>> +			"/sys/class/thermal/thermal_zone0/mode\n");
> 
> maybe I'm missing something but shouldn't this be enabled by default and
> only when the user wants to have acerfand or some other uspace tool do
> the controlling, only then turn it off. I'd rather trust this is done
> in the kernel instead of some flaky uspace thread which could maybe
> segfault and we fry our nice little netbook :).

Matthew suggested to start the module in usermode, where the BIOS takes 
care about the fan as long as there is no userspace tool or the user want 
the kernel to care about the fan.

>> +	/* register platform device */
> 
> don't need those comments, function name is enough

jip

>> +	if (platform_driver_register(&acerhdf_driver)) {


best regards,
--peter
