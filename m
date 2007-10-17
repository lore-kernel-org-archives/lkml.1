Return-Path: <linux-kernel-owner+w=401wt.eu-S1760828AbXJQTnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760828AbXJQTnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbXJQTnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:43:09 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:45537 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbXJQTnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:43:08 -0400
Message-ID: <471663F4.9030403@freescale.com>
Date: Wed, 17 Oct 2007 14:35:16 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Jochen Friedrich <jochen@scram.de>
CC: "linuxppc-embedded@ozlabs.org" <linuxppc-embedded@ozlabs.org>,
       linux-kernel@vger.kernel.org, i2c@lm-sensors.org,
       Carsten Juttner <carjay@gmx.net>
Subject: Re: [PATCH take2] [POWERPC] i2c: adds support for i2c bus on 8xx
References: <47134A94.60606@scram.de> <20071015183107.GA4361@loki.buserror.net> <47166085.1010608@scram.de>
In-Reply-To: <47166085.1010608@scram.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jochen Friedrich wrote:
>>> diff --git a/arch/powerpc/boot/dts/mpc885ads.dts 
>>> b/arch/powerpc/boot/dts/mpc885ads.dts
>>> index 8848e63..a526c02 100644
>>> --- a/arch/powerpc/boot/dts/mpc885ads.dts
>>> +++ b/arch/powerpc/boot/dts/mpc885ads.dts
>>> @@ -213,6 +213,15 @@
>>>                  fsl,cpm-command = <0080>;
>>>                  linux,network-index = <2>;
>>>              };
>>> +
>>> +            i2c@860 {
>>> +                device_type = "i2c";
>>>     
>>
>> No device_type.
>>   
> 
> Why? Documentation/powerpc/booting-without-of.txt says for I2C interfaces
> device_type is required and should be "i2c". Is this no longer true?

booting-without-of.txt should be changed.

>> Should be fsl,cpm-i2c.  Is cpm2 i2c the same?  If not, it should be
>> fsl,cpm1-i2c.  It's probably best to specify it anyway, along with
>> fsl,mpc885-i2c.
> 
> CPM2 i2c seems to be the same. However, i have no way to test this.

OK, let's make the compatible "fsl,mpc885-i2c", "fsl,cpm1-i2c", 
"fsl,cpm-i2c".

For now, match on the last one, but if any differences pop up, we have 
the more specific ones.

> I noticed cpm1_set_pin32, but this function don't seem to set the
> odr register. Will this be added? Then it would be:
> 
>     {CPM_PORTB, 26, CPM_PIN_OUTPUT | CPM_PIN_OPENDRAIN},
>     {CPM_PORTB, 27, CPM_PIN_OUTPUT | CPM_PIN_OPENDRAIN},
> 

Ah, missed that -- there's opendrain support for port E, but I missed 
that port B had it as well.  Feel free to add it.

>> It's a 7-bit address...  and are you sure that 0x7e is unique?  Does this
>> driver even support slave operation?
> 
> It's in fact 0x7F << 1.

Gah, I hate powerpc bit numbering, especially without the 
numbered-as-if-64-bit hack.  I specifically looked at the manual before 
to see if it was shifted, saw "0-6", and concluded it wasn't. :-P

> The same value is used in the 2.4 driver and
> in u-boot, as well.

That doesn't mean that this isn't a good time to review what the code is 
doing. :-)

> Slave operation is not supported.

If slave operation isn't supported, how is this value used?

>> Why is an 8xx driver matching all i2c cpm (i.e. what about cpm2)?
> 
> With the suggested change to use fsl,cpm-command, the driver should
> be able to use  both cpm1 and cpm2. The operation and structs for i2c
> are identical. The only difference might be the hack^wsupport for
> relocation.

OK.  Would that allow it to become one driver, rather than a wrapper and 
an algorithm?

-Scott
