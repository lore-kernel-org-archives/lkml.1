Return-Path: <linux-kernel-owner+w=401wt.eu-S1758152AbYFJJeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152AbYFJJeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 05:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbYFJJeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 05:34:09 -0400
Received: from 203-96-159-182.paradise.net.nz ([203.96.159.182]:59817 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751938AbYFJJeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 05:34:07 -0400
Message-ID: <484EF343.9090102@bluewatersys.com>
Date: Wed, 11 Jun 2008 09:33:55 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: David Brownell <david-b@pacbell.net>, Uli Luckas <u.luckas@road.de>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] Earlier I2C initialization
References: <200806091541.43899.u.luckas@road.de>	<20080609135739.GE30971@flint.arm.linux.org.uk>	<484D947D.1090900@bluewatersys.com>	<200806091359.12791.david-b@pacbell.net>	<484DA046.4010804@bluewatersys.com> <20080610085708.12c2d2a2@hyperion.delvare>
In-Reply-To: <20080610085708.12c2d2a2@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> On Tue, 10 Jun 2008 09:27:34 +1200, Ryan Mallon wrote:
>   
>> David Brownell wrote:
>>     
>>> On Monday 09 June 2008, Ryan Mallon wrote:
>>>   
>>>       
>>>>> Talk to i2c and framebuffer people about changing the link order.
>>>>>
>>>>> i2c should really be initialised before framebuffer devices because
>>>>> framebuffer devices tend to want to read DDC from monitors, which is
>>>>> basically a I2C EEPROM in the monitor.
>>>>>           
>
> This is already the case. i2c-core is initialized with
> subsys_initcall(), so it's available to all drivers initialized with
> module_init().
>
>   
>>>>> ... but there's probably some reason why it's done the way it is today,
>>>>> and changing it could well cause stuff to break.
>>>>>       
>>>>>           
>>>> We have made i2c the first driver subsystem to come up in our 2.6.20
>>>> kernel since we use i2c io expanders for power domain control. All we
>>>> did was change drivers/Makefile so that obj-$(CONFIG_I2C) += i2c/ is at
>>>> the very top of the file. We didn't have any problems with doing this.
>>>> YMMV of course.
>>>>         
>
> Why don't you simply initialize the drivers in question with
> subsys_initcall()? That's what i2c-pnx, i2c-omap, i2c-davinci and
> tps65010 are doing at the moment.
>
>   
How does this work for embedded devices where the same architecture is
used in many different configurations? For example, we have a PXA270 
setup where we need i2c early, but many other PXA setups do not, so 
making i2c-pxa subsys_initcall to support a single board is maybe the
wrong way to go?

>>> OMAP does much the same thing, for the same reason, and the I2C
>>> adapter gets initialized earlier too (so power management chips
>>> will be fully usable before driver_initcall code runs).
>>>
>>> Unless there's a downside on x86, I'd just suggest someone submit
>>> a patch moving I2C init "early" so it merges in 2.6.27 ... cc to
>>> LKML to scare out more potential problems, but I have a hard time
>>> imagining there'd really be any.
>>>       
>> Okay, heres the patch. Is untested though (other than our experience 
>> under 2.6.20), so it probably needs some people to test. I'm not 
>> subscribed to LKML, so can people CC me if necessary.
>>
>> Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
>>
>> diff --git a/drivers/Makefile b/drivers/Makefile
>> index f65deda..9eaf236 100644
>> --- a/drivers/Makefile
>> +++ b/drivers/Makefile
>> @@ -5,6 +5,7 @@
>>  # Rewritten to use lists instead of if-statements.
>>  #
>>  
>> +obj-y				+= i2c/
>>  obj-$(CONFIG_HAVE_GPIO_LIB)	+= gpio/
>>     
>
> Some i2c bus drivers bit-bang GPIO pins...
>
>   
>>  obj-$(CONFIG_PCI)		+= pci/
>>     
>
> ... and many are PCI devices, so will this work OK?
>   
Probably not :-). I didn't have hardware to test, it was just easy
to put together the patch. I figured a change like this would 
require extensive testing anyway, since it is bound to break
some obscure setup at least.

I still think that possibly a better solution is to allow the link
order for the driver subsystems to be configured somehow. At least
for the embedded space this is useful if a particular board has 
some dependency on i2c, spi or some other subsystem being available
early on, then it can be configured on a per board basis, rather
than per arch, or per driver.

I'm not sure how to accomplish this though, I don't think Kconfig
lends it self to this sort of thing very well, and I don't
understand the kernel build process well enough to attempt it
myself.

~Ryan

