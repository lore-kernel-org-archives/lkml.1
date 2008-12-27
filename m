Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbYL0Ozd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbYL0Ozd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 09:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbYL0OzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 09:55:24 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:49560 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbYL0OzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 09:55:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FR3lb7YlYPoQ6Nbfm4e+RFum1J/R0jVAXXoguIYYXeVtaV+sJaBzpXFsTKvoud2iJq
         xy9YKkFc1yozfABT4S9EPvsgo473MZ7IQTbbV/ECfr56MpZVQMqgR1f16uG8UEtl4TOu
         NPvlLz3X07mc613vVKVyE9wq3FieDEWgDtckE=
Message-ID: <45a44e480812270655u10bde0d2mc7f429cf47ed7bc6@mail.gmail.com>
Date: Sat, 27 Dec 2008 22:55:20 +0800
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
Cc: "Eric Miao" <eric.y.miao@gmail.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Eric Miao" <eric.miao@marvell.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Philipp Zabel" <philipp.zabel@gmail.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Ben Gardner" <bgardner@wabtec.com>, "Greg KH" <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
In-Reply-To: <45a44e480811301710v78875425p75dedd850728cbec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com>
	 <200811291454.17110.david-b@pacbell.net>
	 <45a44e480811291552i77878bcdn5fe33f48fc4236eb@mail.gmail.com>
	 <200811300955.30180.david-b@pacbell.net>
	 <45a44e480811301710v78875425p75dedd850728cbec@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2008 at 9:10 AM, Jaya Kumar <jayakumar.lkml@gmail.com> wrote:
> On Mon, Dec 1, 2008 at 1:55 AM, David Brownell <david-b@pacbell.net> wrote:
>>
>> They wouldn't want names so easily confused with the current set
>> of GPIO calls, no.
>>
>
> Okay, how does gpio_set/get_values_batch() sound?
>
>>
>>> >
>>> > Then separately two more things:
>>> >
>>> >  - A gpio_* interface proposal for higher-level bitmask calls.
>>> >   This is worth some discussion; the calls should clearly
>>> >   be optional (not everything will implement them), and I
>>> >   can't help but suspect <linux/bitmap.h> interfaces should
>>> >   interoperate smoothly.
>>
>> ... including probably ganged request/free, and direction updates.
>> When bitbanging a multiplexed parallel databus, you'll often need
>> to change directions.
>
> Okay, so I'll also add gpio_direction_output/input_batch and request/free_batch.
>
>>
>>
>>> >
>>> >  - A gpiolib based implementation, using those new gpio_chip
>>> >   methods as accelerators if they're present.  This should
>>> >   probably also be optional, even at the Kconfig level; many
>>> >   systems won't need to spend memory on these calls.
>>>
>>> Understood. I will make it optional. Does
>>> CONFIG_GPIOLIB_MULTIBIT_ACCESS sound okay?
>>
>> Kind of verbose for my taste, and it's already "multibit" (one
>> at a time, but still multiple) ... let's see some more mergeable
>> proposals and code first.  Different C file too, I suspect.
>
> Ok, CONFIG_GPIOLIB_BATCH and I'll add this code in
> drivers/gpio/gpiolib_batch.c. I hope I have understood that suggestion
> correctly.
>
>>
>>
>>> > Don't assume gpiolib when defining the interface.
>>>
>>> Ok, I didn't understand this part. I think you mentioned a higher
>>> level interface before but I didn't fully understand, if not gpiolib,
>>> then at what level do you recommend?
>>
>> The gpio_*() interfaces are how system glue code and drivers
>> access GPIOs, unless they roll their own chip-specific calls.
>>
>> Whereas gpiolib (and gpio_chip) are an *optional* framework
>> for implementing those calls.  Platforms can (and do!) use
>> other frameworks ... maybe they don't want to pay its costs,
>> and don't need the various GPIO expander drivers.
>>
>> So to repeat:  don't assume the interface is implemented in
>> one particular way (using gpiolib).  It has to make sense
>> with other implementation strategies too.  Standard split
>> between interface and implementation, that's all.  (Some folk
>> have been heard to talk about "gpiolib" as the interface to
>> drivers ... it's not, it's a provider-only interface library.)
>>
>
> Okay, I read above several times and I read Documentation/gpio.txt.
> But... I'm not confident I've understood your meanings above in terms
> of how it should change the code. What I know so far is:
>
> a)
> arch/arm/mach-pxa/include/mach/gpio.h is where the pxa GPIO api
> interface is defined. So that's where I will put the
> gpio_get/set_values_batch functions. This will match the existing
> gpio_set/get_value code there.
>
> b)
> arch/arm/mach-pxa/gpio.c is where the implementation is.
> So I'll put the pxa_gpio_direction_input/output_batch and
> pxa_gpio_set/get_batch there.
>
> c)
> drivers/gpio/gpiolib_batch.c
>
> This is where I'd put the generic platform independent implementations
> of __gpio_set/get_values_batch
>
> Does this sound consistent with your recommendation? If not, I need
> more help to understand what changes you are recommending.
>
>
>> Doesn't necessarily need to be *you* doing that, but if it only
>> works on older gumstix boards it'd not be general enough.  Which
>> is part of why I say to get the lowest level proposal out there
>> first.  If done right, it'll be easy to support on other chips.
>
> Yes, I completely agree that it must work on a wide range of
> architectures. But I don't understand what you mean when you say get
> the lowest level proposal out there first. I see the RFC code that I
> posted as being the lowest level proposal (albeit needing better name
> and bitmask support) and one that is sufficiently general that it can
> be implemented on other architectures. If it can't, can you help me
> understand by pointing to which portion would break on other archs?
>

Oh, gosh darn it, how time has flown. My email above was to make sure
I have understood the feedback. I assume I should just get started on
implementing. Just to double check, the plan is:
- add bitmask support.
- add get_batch support
- improve naming. I think gpio_get_batch/gpio_set_batch sounds good. I
plan to have something like:

void gpio_set_batch(unsigned gpio, u32 values, u32 bitmask, int bitwidth);
u32 gpio_get_batch(unsigned gpio, u32 bitmask, int bitwidth);

I think I should explain the bitmask and bitwidth choice. The intended
use case is:
for (i=0; i < 800*600; i++) {
 gpio_set_batch(...)
}

bitwidth (needed to iterate and map to chip ngpios) could be
calculated from bitmask, but that involves iteratively counting bits
from the mask, so we would have to do 800*600 bit counts. Unless, we
do ugly things like cache the previous bitwidth/mask and compare
against the current caller arguments. Given that the bitwidth would
typically be a fixed value, I believe it is more intuitive for the
caller to provide it, eg:

gpio_set_batch(DB0, value, 0xFFFF, 16)

which has the nice performance benefit of skipping all the bit
counting in the most common use case scenario.

While we are here, I was thinking about it, and its better if I give
gpio_request/free/direction_batch a miss for now. Nothing prevents
those features being added at a later point. That way I can focus on
getting gpio_set/get_batch implemented correctly and merged as the
first step.

Thanks,
jaya
