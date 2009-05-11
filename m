Return-Path: <linux-kernel-owner+w=401wt.eu-S1758755AbZEKTeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755AbZEKTeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754909AbZEKTeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:34:10 -0400
Received: from smtprelay08.ispgateway.de ([80.67.29.8]:35391 "EHLO
	smtprelay08.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbZEKTeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:34:08 -0400
References: <cone.1240648971.372002.7492.1000@mentalhome> <20090426172947.GB3643@liondog.tnic> <cone.1240858632.795110.5316.1000@onepiie> <20090428072519.GA12170@liondog.tnic> <1240913055.29860.14.camel@maxim-laptop> <cone.1240949852.549814.7466.1000@mentalhome> <1240950704.3781.12.camel@maxim-laptop> <cone.1241299309.265715.3948.1000@mentalhome> <20090503184617.GA3555@liondog.tnic> <cone.1241648222.299676.7476.1000@mentalhome> <20090509171432.GA31126@liondog.tnic>
Message-ID: <cone.1242065107.695268.13534.1000@onepiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: petkovbb@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH] Acer Aspire One Fan Control
Date: Mon, 11 May 2009 20:05:07 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Borislav Petkov writes:
> 
> the more I'm looking at the driver, the more I get annoyed by that
> user/kernel mode operation split. Remind me again why the driver should
> be loaded and not started automatically but the user should be required
> to activate it explicitly?

The idea of not starting the module in kernel mode was from Matthew. And he 
stated that it could harm the hardware when software controls the fan 
instead of the BIOS. It may also be possible, that the warranty gets invalid 
when you do that. Not sure about how acer would handle a defect which could 
be caused by overheating and when they detect that software was controlling 
the fan. That's why I think Matthew is right. 

> That's not so optimal, I'd say. The kernel module should _replace_
> the userspace program, not work alongside it, since the last is flaky
> and unreliable, and this was the main reason the kernel module was
> introduced in the first place - to control the fan from kernel space,
> which is the more sane choice.

The main reason to do this in kernel was the availabilty of atomic ec- read 
and write functions. But I agree with you that either kernel or BIOS 
should control the fan and not a userspace tool. I added the user mode just 
because it wasn't really much more code than just an implementation of the 
enable/disable functionality.

> What is more, if the userspace program would fail, there's no way for
> the module to get activated again and jump in instead of the userspace
> program to the rescue. Which goes more to show that you don't need
> userspace control _at_ _all_ and the only two agents controlling the fan
> should be the BIOS or the kernel module.

After reading and thinking about all this a while, I agree with you. In the 
next patch I won't allow the user to switch on/off the fan anymore.

> 
> So I think that the kernel module should take over fan control upon
> load. This way you'll be able to get rid of all that needless complexity
> around kernelmode/disable_kernelmode and have a simple clean design.

I would really like to do that, but what do you think about the hardware damage / warranty things written above?

>> +
>> +	if (!force_bios[0]) {
>> +		/* check if product is a AO - Aspire One */
>> +		if (strncmp(product, "AO", 2)) {
> 
> I suppose this check will have to be updated if Acer release newer
> Aspire One versions which product names are not AOXXXX anymore, right?
> But who knows, they might fix the fan in their A1 versions :)

This may really be updated if they release newer AO version. But the time 
being all supported Aspire One versions begin with AO.

>> +	/* search BIOS version and BIOS vendor in BIOS settings table */
>> +	for (i = 0; bios_settings[i].version[0]; ++i) {
>> +		if (!strcmp(bios_settings[i].vendor, vendor) &&
>> +				!strcmp(bios_settings[i].version, version)) {
>> +			bios_version = i;
>> +			break;
>> +		}
>> +	}
>> +	if (bios_version == -1) {
>> +		acerhdf_error("cannot find BIOS version\n");
>> +		ret_val = -ENODEV;
>> +		goto EXIT;
>> +	}
> 
> you could split this function since logically you do basic checking of hardware
> and below this line you register with the thermal core so the rest of that
> function could go into another one, something like:
> 
> static int acerhdf_register(int mode) {
> 
> 	...
> }
> 
> and then call it in the acerhdf_init() like that:
> 
> 	return acerhdf_register(kernelmode);

Good idea.

kind regards,
--peter
