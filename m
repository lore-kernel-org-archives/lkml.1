Return-Path: <linux-kernel-owner+w=401wt.eu-S1753595AbYL2Ufc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbYL2Ufc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 15:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbYL2Ueb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 15:34:31 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:48141 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752539AbYL2Ue1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 15:34:27 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=14MTtUXZBMTmFM8NhaBYLY92wLMMWwWAobUEXkwE6yomk3p3NK8dxHh2iDVejFiz6OtUSH/D6NyoTR3aUn67HQEFPaSyZmlvLGwKLoIouFDdNT5H6y3ZSUHrs88wG+DfjwK6S/0+NuDF0wL5LJfSLwhDgM5qsL3wK2zm0E/TTSI=  ;
X-YMail-OSG: Q9eeVvQVM1l_AhmAdpI9gfjlmS1Sl.jppqV18QABjYdDIQ8CETHUwTLOHgrSsSEI_pJ0g2mywWdRSzNaPsheW2cz6lxjp_0rJkOVbrjG_os1tuojkKUrhDMt.am5xrAhabJqj2bKUFmptnWdtPqDUVfs
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
Date: Mon, 29 Dec 2008 11:56:11 -0800
User-Agent: KMail/1.9.10
Cc: "Jaya Kumar" <jayakumar.lkml@gmail.com>,
       "Eric Miao" <eric.y.miao@gmail.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Eric Miao" <eric.miao@marvell.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Philipp Zabel" <philipp.zabel@gmail.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Ben Gardner" <bgardner@wabtec.com>, "Greg KH" <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com> <45a44e480812270655u10bde0d2mc7f429cf47ed7bc6@mail.gmail.com> <200812281346.56703.rgetz@blackfin.uclinux.org>
In-Reply-To: <200812281346.56703.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812291156.12230.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 December 2008, Robin Getz wrote:
> On Sat 27 Dec 2008 09:55, Jaya Kumar pondered:
> 
> I think that I would prefer 'group' or 'collection' to use some of the words 
> that David described things as 'ganged' or 'bus' or 'bank' or 'adjacent'. 
> (but I think 'adjacent' or 'bank' really is an implementation convention).
> 
> I think I would also prefer to name things like gpio_bus_* as a rather than 
> gpio_*_bus - so the operation always is on the end...

I'd avoid "bus"; the term has specific meanings, which aren't necessarily
relevant in these contexts.  Agreed about "adjacent" and "bank".

If it weren't for its verb usage, I'd suggest "set".  :)


> Shouldn't the write return an error code (if the data was not written)?

For these operations, I think reads/writes should have that possibility.

The reason single-bit operations don't provide error paths is twofold.
First, they started as wrappers for can't-fail register accessors.
Second, it's extremely unrealisitic to expect much code to handle any
kind of faults in the middle of bitbanging loops ... or even just in
classic "set this bit and continue" configuration code.

Those reasons don't apply well to these multi-bit cases.


> > While we are here, I was thinking about it, and its better if I give
> > gpio_request/free/direction_batch a miss for now. Nothing prevents
> > those features being added at a later point.
> 
> I don't think that request/free are optional.

Agreed.  If there's any difficulty implementing them, that would
suggest there's a significant conceptual problem to address ...


> For example - in most SoC implementations - gpios are implemented as banks of 
> 16 or 32. (a 16 or 32 bit register).
> 
> Are there facilities to span these registers? 
>  - can you request 64 gpios as a 'bank'?
>  - can you request gpio_8 -> gpio_40 as a 'bank' on a 32-bit system?
> 
> Are non-adjacent/non-contiguous gpios avaliable to be put into 
> a 'bank/batch/bus'? can you use gpio_8 -> 11 &  28 -> 31 as a 8-bit 'bus'? 
> 
> How do you know what is avaliable to be talked to as a bank/bus/batch without 
> the request/free operation?
> 
> 
> I have seen various hardware designs (both at the PCB and SoC level) require 
> all of these options, and would like to see common infrastructure which 
> handles this.

Right.  Get the interface right -- it should allow all those
complexities! -- and maybe take shortcuts in the first versions
of the implementation, by only talking to one gpio_chip at a
time.  I'd expect any shortcuts would be resolved quickly, to
the extent they cause problems.


> The issue is that on many SoC implementations - dedicated peripherals can also 
> be GPIOs - so it someone wants to use SPI (for example) GPIO's 3->7 might be 
> removed from the avaliable 'gpio' resources. This is determined by the 
> silicon designer - and even the PCB designer has little to no flexibility on 
> this. It gets worse as multiple SPI or I2C are used on the PCB (which can 
> have lots of small (less than 5) dedicated pins in the middle of the larger 
> gpio resources)....

Such pin-muxing is a different issue though.  Don't expect GPIO
calls to resolve those problems.
  

> I would think that a 'bank' / 'bus' (whatever) would be a collection of 
> random/multiple GPIOs (a struct of gpio_port_t) rather than a start/length 
> (as you described) - or better yet - the request function takes a list (of 
> individual GPIO's - defined in the platform data), and creates the struct 
> itself.

That's why I pointed to <linux/bitmask.h> as one model:  it allows
an arbitrary set of bits (GPIOs) to be specified.

I'll NAK any "gpio_port_t" name based entirely on kernel coding
conventions though.  ;)


> Something like the way gpio_keys are defined...
> 
> static struct gpio_bus bfin_gpio_bus_table[] = {
>         {BIT_0, GPIO_PB8, 1, "gpio-bus: BIT0"},
>         {BIT_1, GPIO_PB9, 1, "gpio-bus: BIT1"},
>         {BIT_2, GPIO_PB10, 1, "gpio-bus: BIT2"},
>         {BIT_3, GPIO_PB11, 1, "gpio-bus: BIT3"},
> };
> 
> static struct gpio_bus_data bfin_gpio_bus_data = {
>         .bits        = bfin_gpio_bus_table, 
>         .width       = ARRAY_SIZE(bfin_gpio_keys_table),
> };
> 
> static struct platform_device bfin_device_gpiobus = {
>         .name      = "gpio-bus",
>         .dev = {
>                 .platform_data = &bfin_gpio_bus_data,
>         },
> };
> 
> The request function builds up the bus/masks/shifts from that...

That sort of thing might be made to work.  Whatever this
multiple-GPIO-set abstraction is, I suspect you're right
about wanting the request function to be able to build
up some data structures behind it.  And that it would be
simpler to require all the GPIOs to be listed up front,
rather than support "add these to the set" requests.

- Dave


