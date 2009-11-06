Return-Path: <linux-kernel-owner+w=401wt.eu-S1758099AbZKFOeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbZKFOeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 09:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbZKFOeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 09:34:19 -0500
Received: from smtp.nokia.com ([192.100.122.230]:48831 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbZKFOeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 09:34:18 -0500
Date: Fri, 6 Nov 2009 16:32:37 +0200 (EET)
From: Ilkka Koskinen <ikoskine@nokia.com>
X-X-Sender: ikoskine@tumpelo.ntc.nokia.com
To: Samuel Ortiz <sameo@linux.intel.com>
cc: "Koskinen Ilkka (Nokia-D/Tampere)" <ilkka.koskinen@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Subject: Re: [PATCH v2] TWL4030: Initial support for TWL5031
In-Reply-To: <20091104160832.GD3607@sortiz.org>
Message-ID: <alpine.DEB.2.00.0911061409200.32123@tumpelo.ntc.nokia.com>
References: <1255702360-2143-1-git-send-email-ilkka.koskinen@nokia.com> <20091104160832.GD3607@sortiz.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-OriginalArrivalTime: 06 Nov 2009 14:34:07.0997 (UTC) FILETIME=[32BD3AD0:01CA5EEE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Samuel,

Thanks for comments. I'll fix them but I'd
still have a couple of comments

On Wed, 4 Nov 2009, Samuel Ortiz wrote:

> Hi Ilkka,
>
> Some comments below:
>
> On Fri, Oct 16, 2009 at 05:12:40PM +0300, Ilkka Koskinen wrote:
>> TWL5031 introduces two new interrupts in PIH. Moreover, BCI
>> has changed remarkably and, thus, it's disabled when TWL5031
>> is in use.
>>
>> Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
>> ---
>>  drivers/mfd/twl4030-core.c  |   12 ++++-
>>  drivers/mfd/twl4030-irq.c   |  127 +++++++++++++++++++++++++++++++++++++++++--
>>  include/linux/i2c/twl4030.h |   47 ++++++++++++++--
>>  3 files changed, 173 insertions(+), 13 deletions(-)
>>
>> @@ -284,11 +367,20 @@ static int twl4030_init_sih_modules(unsigned line)
>>  	/* disable all interrupts on our line */
>>  	memset(buf, 0xff, sizeof buf);
>>  	sih = sih_modules;
>> -	for (i = 0; i < ARRAY_SIZE(sih_modules); i++, sih++) {
>> +	for (i = 0; i < nr_sih_modules; i++, sih++) {
>>
>>  		/* skip USB -- it's funky */
>> -		if (!sih->bytes_ixr)
>> +		/* But don't skip TWL5031's ACI */
>> +		if (!sih->bytes_ixr) {
>> +			if (chip_is_twl5031 && !strcmp(sih->name, "aci")) {
>> +				twl4030_i2c_write(TWL5031_MODULE_ACCESSORY,
>> +						  buf, TWL5031_ACIIMR_LSB, 1);
>> +				twl4030_i2c_write(TWL5031_MODULE_ACCESSORY,
>> +						  buf, TWL5031_ACIIMR_MSB, 1);
>> +			}
>> +
> A few comments on this:
> - Why do we have to do that for the accessory ? Some comments would be
> appropriate.
> - You could use twl4030_i2c_write_u8(), couldnt you ?
> - I'd like it to be more generic: TWL5031_MODULE_ACCESSORY should be replaced
> by sih->module, and the TWL5031_ACII* register should be somehow integrated in
> the sih struct. The idea is to get rid of this chip_is_twl5031.

Very good point. Actually, I could change it to use isr/imr offsets if I 
add another variable in sih structure describing a number of supported irq 
lines. (ACI supports just one...) I think it would be a lot cleaner 
approach that way.

>> @@ -756,3 +857,17 @@ int twl_exit_irq(void)
>>  	}
>>  	return 0;
>>  }
>> +
>> +int twl_init_chip_irq(const char *chip)
>> +{
>> +	if (!strcmp(chip, "twl5031")) {
>> +		chip_is_twl5031 = 1;
>> +		sih_modules = sih_modules_twl5031;
>> +		nr_sih_modules = ARRAY_SIZE(sih_modules_twl5031);
> I dont think you need nr_sih_modules at all. sih_modules is pointing to the
> right array, and then you can keep the ARRAY_SIZE(sih_modules) call instead of
> defining yet another static variable.

What comes to adding another static variable, I don't like it either.

But, as far as I can see ARRAY_SIZE is using sizeof operator, which is 
calculated in compilation time, right? Number of sih modules is decided in 
probing time based on the used twl chip and, thus, ARRAY_SIZE cannot be 
used. Or did I miss something?

> Talking about static variables and such, I really think the twl driver needs
> some cleanup. It should really be allocating a private device structure at
> probe time containing all those static crap. As this driver is growing and
> supporting more and more HW, it starts to be messy.

That would be great. If I only had some time... :(

> Cheers,
> Samuel.
>
>
>> +	} else {
>> +		sih_modules = sih_modules_twl4030;
>> +		nr_sih_modules = ARRAY_SIZE(sih_modules_twl4030);
>> +	}
>> +
>> +	return 0;
>> +}

Cheers, Ilkka
