Return-Path: <linux-kernel-owner+w=401wt.eu-S1761565AbXJQTVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761565AbXJQTVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbXJQTUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:20:53 -0400
Received: from mail0.scram.de ([78.47.204.202]:49553 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbXJQTUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:20:52 -0400
X-Spam-Score: -3.896
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.5 AWL AWL: From: address is in the auto white-list
Message-ID: <47166085.1010608@scram.de>
Date: Wed, 17 Oct 2007 21:20:37 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: "linuxppc-embedded@ozlabs.org" <linuxppc-embedded@ozlabs.org>,
       linux-kernel@vger.kernel.org, i2c@lm-sensors.org,
       Carsten Juttner <carjay@gmx.net>
Subject: Re: [PATCH take2] [POWERPC] i2c: adds support for i2c bus on 8xx
References: <47134A94.60606@scram.de> <20071015183107.GA4361@loki.buserror.net>
In-Reply-To: <20071015183107.GA4361@loki.buserror.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Scott,

> Do we really need to be adding features for arch/ppc at this point?  It'll
> be going away in June.  arch/ppc-specific things outside of arch/ppc itself
> will also be more likely to be missed in the removal.
>
> Also, please post inline rather than as an attachment; attachments are
> harder to quote in a reply.
>   

OK. I'll remove the ARC=ppc parts.

>> diff --git a/arch/powerpc/boot/dts/mpc885ads.dts b/arch/powerpc/boot/dts/mpc885ads.dts
>> index 8848e63..a526c02 100644
>> --- a/arch/powerpc/boot/dts/mpc885ads.dts
>> +++ b/arch/powerpc/boot/dts/mpc885ads.dts
>> @@ -213,6 +213,15 @@
>>  				fsl,cpm-command = <0080>;
>>  				linux,network-index = <2>;
>>  			};
>> +
>> +			i2c@860 {
>> +				device_type = "i2c";
>>     
>
> No device_type.
>   

Why? Documentation/powerpc/booting-without-of.txt says for I2C interfaces
device_type is required and should be "i2c". Is this no longer true?

> Should be fsl,cpm-i2c.  Is cpm2 i2c the same?  If not, it should be
> fsl,cpm1-i2c.  It's probably best to specify it anyway, along with
> fsl,mpc885-i2c.
>   

CPM2 i2c seems to be the same. However, i have no way to test this.

>> +#ifdef CONFIG_I2C_8XX
>> +	setbits32(&mpc8xx_immr->im_cpm.cp_pbpar, 0x00000030);
>> +	setbits32(&mpc8xx_immr->im_cpm.cp_pbdir, 0x00000030);
>> +	setbits16(&mpc8xx_immr->im_cpm.cp_pbodr, 0x0030);
>> +#endif
>>     
>
> Please add this to mpc885ads_pins, rather than poking the registers
> directly.  The relevant lines are:
>
> 	{CPM_PORTB, 26, CPM_PIN_OUTPUT},
> 	{CPM_PORTB, 27, CPM_PIN_OUTPUT},
>   

I noticed cpm1_set_pin32, but this function don't seem to set the
odr register. Will this be added? Then it would be:

	{CPM_PORTB, 26, CPM_PIN_OUTPUT | CPM_PIN_OPENDRAIN},
	{CPM_PORTB, 27, CPM_PIN_OUTPUT | CPM_PIN_OPENDRAIN},


>> +	/* Select an arbitrary address.  Just make sure it is unique.
>> +	 */
>> +	out_8(&i2c->i2c_i2add, 0xfe);
>>     
>
> It's a 7-bit address...  and are you sure that 0x7e is unique?  Does this
> driver even support slave operation?
>   

It's in fact 0x7F << 1. The same value is used in the 2.4 driver and
in u-boot, as well. Slave operation is not supported.

> Why is an 8xx driver matching all i2c cpm (i.e. what about cpm2)?
>   

With the suggested change to use fsl,cpm-command, the driver should
be able to use  both cpm1 and cpm2. The operation and structs for i2c
are identical. The only difference might be the hack^wsupport for
relocation.

Thanks,
Jochen
