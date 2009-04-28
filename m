Return-Path: <linux-kernel-owner+w=401wt.eu-S1759943AbZD1HZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943AbZD1HZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 03:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbZD1HZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 03:25:26 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:52788 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbZD1HZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 03:25:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=t7QrMOSugWeG7rw8JSCIiiW0ppNEnFxdkDCSZiOvhBULkEACwZALr1wyhowBSAuXEC
         vjGZXqWEHGn4dF/TIL3IQvlVdVmJghltW6uSyeAZ7Q6AKJKcTB4nt/S/in/Q/QCpqIYs
         wIpoS0UGwzwYp0Kh29tE2httKSMlVcEO4KpIs=
Date: Tue, 28 Apr 2009 09:25:19 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] Acer Aspire One Fan Control
Message-ID: <20090428072519.GA12170@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Peter Feuerer <peter@piie.net>,
	LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
	Matthew Garrett <mjg59@srcf.ucam.org>
References: <cone.1240623959.159615.9486.1000@mentalhome> <cone.1240648971.372002.7492.1000@mentalhome> <20090426172947.GB3643@liondog.tnic> <cone.1240858632.795110.5316.1000@onepiie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cone.1240858632.795110.5316.1000@onepiie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Mon, Apr 27, 2009 at 08:57:12PM +0200, Peter Feuerer wrote:
> Hi Boris,
>
> thank you very much for your email.
>
> Borislav Petkov writes:
>
>> I did some testing on my Aspire One machine here and it looks pretty
>> nice: while compiling a kernel watched the fan going on when the
>> temperature reaches 67-68 (I don't think this is Celsius though, no?)
>> and then turning itself off when temp goes below 60.
>
> It is Celsius, the specification of the chipset and the atom core say 
> that the chips are allowed to get 99 degree celsuis hot. So I think 70 
> degree Celsius are fine.

Their N270 datasheet
(http://download.intel.com/design/processor/datashts/320032.pdf) talks
about max Tj (junction temperature) being 90°C for a TDP of 2.5W and if
you operate below that limit "functionality and long-term reliability
can be expected." :)

There's also an internal termtrip sensor which is designed to go off at
Tj=125°C so, yeah, I guess something 70°C should be ok.

>>>
>>> +config ACERHDF
>>> +	tristate "Acer Aspire One temperature and fan driver"
>>> +	depends on THERMAL
>>> +	depends on THERMAL_HWMON
>>
>> depends on THERMAL && THERMAL_HWMON
>
> What do you mean? Sorry, don't get it.

just put the two terms on one line instead of declaring them separately.

>>> +/* module parameters */
>>> +module_param(interval, int, 0600);
>>> +MODULE_PARM_DESC(interval, "Polling interval of temperature check");
>>> +module_param(fanon, int, 0600);
>>
>> This allows for the user to potentially melt his CPU by entering a too high
>> value. You should check that in the acerhdf_init() against the max allowed
>> according to spec, I gather it is 67?
>
> I will add a maximum temperature, I guess something about 80 degree  
> Celsuis. But anyways, the user can still melt his/her cpu by switching to 
> user mode and turning off the fan.

That's true, the user can do all sorts of damages to the machine but
I think it is sensible to catch honest mistakes like mistyping the
temperature and then unwillingly killing your hardware.

And yes, you shouldn't use the max allowed temp Tj=90 according to
the spec which could turn out to be bad choice due to imprecise
measurements/latent reaction of software. Instead, a nice safety gap of
about 10° is needed so 80 sounds good.

>>> +struct bios_settings_t {
>>> +	const char *vendor;
>>> +	const char *version;
>>> +	unsigned char fanreg;
>>> +	unsigned char tempreg;
>>> +	unsigned char cmd_off;
>>> +	unsigned char cmd_auto;
>>> +	unsigned char state_off;
>>
>> obviously cmd_off and state_off are the same values so remove one of them.
>
> I think it makes sense to leave it this way, because we don't know, what  
> acer does for the next BIOS release :)

yes, however, let's do it only when they change it instead of predicting the
future :)

[..]

>>> +	/* if started in user mode, prevent the kernel from switching
>>> +	 * off the fan */
>>> +	if (!kernelmode) {
>>> +		recently_changed = 1;
>>> +		printk(KERN_NOTICE
>>> +			"acerhdf: kernelmode disabled\n");
>>> +		printk(KERN_NOTICE
>>> +			"acerhdf: to enable kernelmode:\n");
>>> +		printk(KERN_NOTICE
>>> +			"acerhdf: echo -n \"enabled\" > "
>>> +			"/sys/class/thermal/thermal_zone0/mode\n");
>>
>> maybe I'm missing something but shouldn't this be enabled by default and
>> only when the user wants to have acerfand or some other uspace tool do
>> the controlling, only then turn it off. I'd rather trust this is done
>> in the kernel instead of some flaky uspace thread which could maybe
>> segfault and we fry our nice little netbook :).
>
> Matthew suggested to start the module in usermode, where the BIOS takes  
> care about the fan as long as there is no userspace tool or the user want 
> the kernel to care about the fan.

But when the BIOS "takes care" of the fan, it boils down to the last being
always on, no? I'd rather have it when the fan is controlled by the kernel
module and gets turned on only when its trip temperature is exceeded.

Thanks.

-- 
Regards/Gruss,
    Boris.
