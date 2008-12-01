Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbYLABLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbYLABLF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 20:11:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbYLABKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 20:10:52 -0500
Received: from ik-out-1112.google.com ([66.249.90.178]:22349 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536AbYLABKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 20:10:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SGZpfj2iOCGR98m1nHfuDemJprrHGZ353JW5iMO3oUvqfnyKSXfnv2u/geGYpdu46z
         RgjvW1OQp73jKvUAEUtkK5xyWCl6BcA2Qvl7wdKZlzuPRjltBmZCPGUByJ596o7NBvNc
         pnQKT71x9Yf3gxovC2sBKtDOmjS9it7usQoH8=
Message-ID: <45a44e480811301710v78875425p75dedd850728cbec@mail.gmail.com>
Date: Mon, 1 Dec 2008 09:10:48 +0800
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
In-Reply-To: <200811300955.30180.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com>
	 <200811291454.17110.david-b@pacbell.net>
	 <45a44e480811291552i77878bcdn5fe33f48fc4236eb@mail.gmail.com>
	 <200811300955.30180.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2008 at 1:55 AM, David Brownell <david-b@pacbell.net> wrote:
>
> They wouldn't want names so easily confused with the current set
> of GPIO calls, no.
>

Okay, how does gpio_set/get_values_batch() sound?

>
>> >
>> > Then separately two more things:
>> >
>> >  - A gpio_* interface proposal for higher-level bitmask calls.
>> >   This is worth some discussion; the calls should clearly
>> >   be optional (not everything will implement them), and I
>> >   can't help but suspect <linux/bitmap.h> interfaces should
>> >   interoperate smoothly.
>
> ... including probably ganged request/free, and direction updates.
> When bitbanging a multiplexed parallel databus, you'll often need
> to change directions.

Okay, so I'll also add gpio_direction_output/input_batch and request/free_batch.

>
>
>> >
>> >  - A gpiolib based implementation, using those new gpio_chip
>> >   methods as accelerators if they're present.  This should
>> >   probably also be optional, even at the Kconfig level; many
>> >   systems won't need to spend memory on these calls.
>>
>> Understood. I will make it optional. Does
>> CONFIG_GPIOLIB_MULTIBIT_ACCESS sound okay?
>
> Kind of verbose for my taste, and it's already "multibit" (one
> at a time, but still multiple) ... let's see some more mergeable
> proposals and code first.  Different C file too, I suspect.

Ok, CONFIG_GPIOLIB_BATCH and I'll add this code in
drivers/gpio/gpiolib_batch.c. I hope I have understood that suggestion
correctly.

>
>
>> > Don't assume gpiolib when defining the interface.
>>
>> Ok, I didn't understand this part. I think you mentioned a higher
>> level interface before but I didn't fully understand, if not gpiolib,
>> then at what level do you recommend?
>
> The gpio_*() interfaces are how system glue code and drivers
> access GPIOs, unless they roll their own chip-specific calls.
>
> Whereas gpiolib (and gpio_chip) are an *optional* framework
> for implementing those calls.  Platforms can (and do!) use
> other frameworks ... maybe they don't want to pay its costs,
> and don't need the various GPIO expander drivers.
>
> So to repeat:  don't assume the interface is implemented in
> one particular way (using gpiolib).  It has to make sense
> with other implementation strategies too.  Standard split
> between interface and implementation, that's all.  (Some folk
> have been heard to talk about "gpiolib" as the interface to
> drivers ... it's not, it's a provider-only interface library.)
>

Okay, I read above several times and I read Documentation/gpio.txt.
But... I'm not confident I've understood your meanings above in terms
of how it should change the code. What I know so far is:

a)
arch/arm/mach-pxa/include/mach/gpio.h is where the pxa GPIO api
interface is defined. So that's where I will put the
gpio_get/set_values_batch functions. This will match the existing
gpio_set/get_value code there.

b)
arch/arm/mach-pxa/gpio.c is where the implementation is.
So I'll put the pxa_gpio_direction_input/output_batch and
pxa_gpio_set/get_batch there.

c)
drivers/gpio/gpiolib_batch.c

This is where I'd put the generic platform independent implementations
of __gpio_set/get_values_batch

Does this sound consistent with your recommendation? If not, I need
more help to understand what changes you are recommending.


> Doesn't necessarily need to be *you* doing that, but if it only
> works on older gumstix boards it'd not be general enough.  Which
> is part of why I say to get the lowest level proposal out there
> first.  If done right, it'll be easy to support on other chips.

Yes, I completely agree that it must work on a wide range of
architectures. But I don't understand what you mean when you say get
the lowest level proposal out there first. I see the RFC code that I
posted as being the lowest level proposal (albeit needing better name
and bitmask support) and one that is sufficiently general that it can
be implemented on other architectures. If it can't, can you help me
understand by pointing to which portion would break on other archs?

Thanks,
jaya
