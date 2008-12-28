Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbYL1S4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbYL1S4m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 13:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbYL1S4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 13:56:32 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:33138 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516AbYL1S4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 13:56:30 -0500
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Dec 2008 13:56:30 EST
X-IronPort-AV: E=Sophos;i="4.36,292,1228107600"; 
   d="scan'208";a="80428328"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
Date: Sun, 28 Dec 2008 13:46:56 -0500
User-Agent: KMail/1.9.5
Cc: "David Brownell" <david-b@pacbell.net>,
       "Eric Miao" <eric.y.miao@gmail.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Eric Miao" <eric.miao@marvell.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Philipp Zabel" <philipp.zabel@gmail.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Ben Gardner" <bgardner@wabtec.com>, "Greg KH" <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com> <45a44e480811301710v78875425p75dedd850728cbec@mail.gmail.com> <45a44e480812270655u10bde0d2mc7f429cf47ed7bc6@mail.gmail.com>
In-Reply-To: <45a44e480812270655u10bde0d2mc7f429cf47ed7bc6@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812281346.56703.rgetz@blackfin.uclinux.org>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Dec 2008 18:46:48.0942 (UTC) FILETIME=[A41218E0:01C9691C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 27 Dec 2008 09:55, Jaya Kumar pondered:
> Oh, gosh darn it, how time has flown. My email above was to make sure
> I have understood the feedback. I assume I should just get started on
> implementing. Just to double check, the plan is:
> - add bitmask support.
> - add get_batch support
> - improve naming. I think gpio_get_batch/gpio_set_batch sounds good.

for what it is worth - I don't like 'batch'.

According to wikipedia[1] - in computer science, batch typically refers to:
  * Batch (Unix), a command to queue jobs for later execution
  * Batch file, in DOS, OS/2, and Microsoft Windows, a text file containing
    a series of commands intended to be executed
  * Batch processing, execution of a series of programs on a computer 
    without human interaction
  * Batch renaming, the process of renaming multiple computer files 
    and folders in an automated fashion

None of these are really what you are talking about. Batch normally only 
refers to a group when taking about baking - A batch of cookies - at least 
where I grew up....

I think that I would prefer 'group' or 'collection' to use some of the words 
that David described things as 'ganged' or 'bus' or 'bank' or 'adjacent'. 
(but I think 'adjacent' or 'bank' really is an implementation convention).

I think I would also prefer to name things like gpio_bus_* as a rather than 
gpio_*_bus - so the operation always is on the end...

> I 
> plan to have something like:
> 
> void gpio_set_batch(unsigned gpio, u32 values, u32 bitmask, int bitwidth);

Shouldn't the write return an error code (if the data was not written)?

> u32 gpio_get_batch(unsigned gpio, u32 bitmask, int bitwidth);

Both assume specific SoC and board level impmentation details (which I ask 
below).

> I think I should explain the bitmask and bitwidth choice. The intended
> use case is:
> for (i=0; i < 800*600; i++) {
>  gpio_set_batch(...)
> }
> 
> bitwidth (needed to iterate and map to chip ngpios) could be
> calculated from bitmask, but that involves iteratively counting bits
> from the mask, so we would have to do 800*600 bit counts. Unless, we
> do ugly things like cache the previous bitwidth/mask and compare
> against the current caller arguments. Given that the bitwidth would
> typically be a fixed value, I believe it is more intuitive for the
> caller to provide it, eg:
> 
> gpio_set_batch(DB0, value, 0xFFFF, 16)
> 
> which has the nice performance benefit of skipping all the bit
> counting in the most common use case scenario.

but has the requirement that the driver know exactly the board level 
impmentation details (something that doesn't sound generic).

> While we are here, I was thinking about it, and its better if I give
> gpio_request/free/direction_batch a miss for now. Nothing prevents
> those features being added at a later point.

I don't think that request/free are optional.

For example - in most SoC implementations - gpios are implemented as banks of 
16 or 32. (a 16 or 32 bit register).

Are there facilities to span these registers? 
 - can you request 64 gpios as a 'bank'?
 - can you request gpio_8 -> gpio_40 as a 'bank' on a 32-bit system?

Are non-adjacent/non-contiguous gpios avaliable to be put into 
a 'bank/batch/bus'? can you use gpio_8 -> 11 &  28 -> 31 as a 8-bit 'bus'? 

How do you know what is avaliable to be talked to as a bank/bus/batch without 
the request/free operation?


I have seen various hardware designs (both at the PCB and SoC level) require 
all of these options, and would like to see common infrastructure which 
handles this.

The issue is that on many SoC implementations - dedicated peripherals can also 
be GPIOs - so it someone wants to use SPI (for example) GPIO's 3->7 might be 
removed from the avaliable 'gpio' resources. This is determined by the 
silicon designer - and even the PCB designer has little to no flexibility on 
this. It gets worse as multiple SPI or I2C are used on the PCB (which can 
have lots of small (less than 5) dedicated pins in the middle of the larger 
gpio resources)....

I would think that a 'bank' / 'bus' (whatever) would be a collection of 
random/multiple GPIOs (a struct of gpio_port_t) rather than a start/length 
(as you described) - or better yet - the request function takes a list (of 
individual GPIO's - defined in the platform data), and creates the struct 
itself.

Something like the way gpio_keys are defined...

static struct gpio_bus bfin_gpio_bus_table[] = {
        {BIT_0, GPIO_PB8, 1, "gpio-bus: BIT0"},
        {BIT_1, GPIO_PB9, 1, "gpio-bus: BIT1"},
        {BIT_2, GPIO_PB10, 1, "gpio-bus: BIT2"},
        {BIT_3, GPIO_PB11, 1, "gpio-bus: BIT3"},
};

static struct gpio_bus_data bfin_gpio_bus_data = {
        .bits        = bfin_gpio_bus_table, 
        .width       = ARRAY_SIZE(bfin_gpio_keys_table),
};

static struct platform_device bfin_device_gpiobus = {
        .name      = "gpio-bus",
        .dev = {
                .platform_data = &bfin_gpio_bus_data,
        },
};

The request function builds up the bus/masks/shifts from that...

-Robin

[1] http://en.wikipedia.org/wiki/Batch
