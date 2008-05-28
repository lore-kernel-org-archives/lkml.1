Return-Path: <linux-kernel-owner+w=401wt.eu-S1752073AbYE1HSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbYE1HSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 03:18:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbYE1HRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 03:17:54 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:22911 "EHLO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbYE1HRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 03:17:53 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-12.tower-164.messagelabs.com!1211959071!19140728!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Wed, 28 May 2008 09:17:47 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: David Brownell <david-b@pacbell.net>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: configure gpio for interrupt function
Message-ID: <20080528071747.GA7599@digi.com>
References: <20080527130236.GA18546@digi.com> <200805271349.24884.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200805271349.24884.david-b@pacbell.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 28 May 2008 07:17:48.0369 (UTC) FILETIME=[EEC4C410:01C8C092]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David,

David Brownell wrote:
> On Tuesday 27 May 2008, Uwe Kleine-König wrote:
> > I want to use a driver that in turn uses the gpio API (i.e.
> > drivers/input/keyboard/gpio_keys.c).  My problem with that is, that my
> > machine[1]'s external irqs don't fit into the GPIO API model.  The main
> > problem is that gpio_direction_input isn't enough to get an irq.
> > I need to explicitly set the gpio to an EXT_IRQ function.
> 
> Let me describe your situation a bit differently:  the GPIO
> hardware on your platform doesn't support IRQs, so you want to
> overlay the EXT_IRQ functions as transparently as you can.
OK, if you want ...

> I don't happen to have come across GPIO controllers without
> IRQ support before, unless maybe you consider PXA to work
> like that.  (PXA docs write "GPIO" most places it'd be more
> clear to say "pin", so that's highly confusing.)  I've used
> systems with EXT_INT function options on pins that support
> full GPIO functionality (including pin change IRQs) though.
I think s3c2443 is similar.  For them just using the input mode for a
gpio isn't enough to get an irq, too.  (At least if I believe my
collegues who work with that processor :))

> > (I can workaround that because the EXT_IRQ function allows to read the
> > state of the gpio.  So I can use the EXT_IRQ function if input is
> > requested.)
>.
> That's part of the reason pinmux and GPIO are orthogonal!
IMHO pinmux and GPIO are not orthogonal.  The GPIO API just choosed not
to bother about pinmuxing.

> Your platforms GPIO code can treat EXT_INT pins as input
> GPIOs; it has no reason to care.
???

> So the *cleanest* way to handle this would be as an EXT_IRQ with
> an affiliated GPIO signal, instead of a single funky GPIO.  That
> mapping could be done by gpio_to_irq().
 
> > Another problem is that I cannot implement irq_to_gpio correctly,
> > because several gpio's share the same irq.
> 
> Sure, no problem.  irq_to_gpio() can't succeed for all GPIOs.
> On your platform, I might be inclined to make it fail in all
> cases to force drivers to record both IRQ and GPIO.
> 
> (And yes, that implies gpio_keys needs to generalize a bit.
> Right now it assumes a one-to-one mapping.)
OK.

> > (Note this makes the workaround above less reliable.  Consider two
> > gpios sharing the same irq.  I cannot assert that only one of them can
> > trigger the interrupt.)
> 
> This is another reason to prefer the "cleanest" solution above.
> Drivers could request_irq() the EXT_IRQ(N) signal as IRQF_SHARED,
> and the handler could check the relevant IRQ as needed.
> 
> Of course, this may require code using your platform to know
> that it needs to track two values (EXT_IRQ and GPIO) not one.
> 
> I don't see a need to extend the API.  The current APIs will do what
> you need, if you use them correctly:
> 
>   - gpio_to_irq() encapsulates your CPU's EXT_IRQ(x) pinmux logic;
>     possibly just a table lookup.
OK.

>   - irq_to_gpio() may fail in all cases
OK.  (But then a general driver cannot make use of this function.  IMHO
this should be noted in the docs.  And then you can deprecate it ;))

>   - request_irq() kicks in irq_chip logic to ensure that the pin
>     is either input GPIO (and remuxes it) or already EXT_INT ...
There isn't "the pin".  E.g. IRQ_NS9XXX_EXT0 can trigger on gpios 1, 9,
16 and 105 on ns9215.  These are four different pins.  What should I do
when two of them are in input mode?  (I can remember for which gpios
gpio_to_irq was called, but this looks messy.)

Can I rely on drivers to first call gpio_direction_input and only then
request_irq?  (Otherwise gpio_direction_input needs some addional logic,
too.)  I have no real example, but I can imagine situations where the
gpio that should interrupt the cpu is used as output from time to time.
This might need some handling, too.

As far as I understand now this won't solve the problem of two gpios
sharing the same irq where only one of them should trigger the irq.

>   - free_irq() can remux EXT_INT as GPIO, if it changed muxing in
>     the first place.  (so gpio_direction_output can work, later.)
OK.

>   - set_irq_type() configures the IRQ type via irq_chip hooks
OK.  This is a function I only found yesterday.

> Deprecating irq_to_gpio() seems a bit strong to me, but maybe that's
> because I've never worked on hardware that can't support it.  ISTR that
> Russell King disliked it a lot, but couldn't explain "why" to me.  This
> may be a good enough reason to do so:  an example showing non-portability
> (albeit because the IRQ in question is _not_ a GPIO irq).
> 
> Why don't you whip up a patch doing the right thing for irq_to_gpio(),
> and send it along.  Right now I'd be inclined to sign off on it.
irq_to_gpio() already does the right thing[5] :-)
The task for request_irq isn't clear to me (yet).  Implementing only
gpio_to_irq() isn't nice, because then gpio_key never gets an irq
(instead of just failing because gpio_to_irq() returns an error).
Another problem is that there isn't any support for ns9215 in the
vanilla kernel yet.

Other than that acking the irq is still open.  I don't really want to
bother the generic irq-ack routine to do something like:

	if (irq_is_external(irq) && extirq_is_configured_edgesensive(irq))
		ackextirq(irq)

And only for that using a 2nd chip seems overkill to me.

Best regards
Uwe

> > [1] http://www.digi.com/products/embeddedsolutions/ns9215.jsp
> >     Interesting sections are "Pinout -> General purpose I/O (GPIO)" and
> >     "I/O Control Module".  E.g. GPIO4's func1 is "Ext Int Ch 2"
> > [2] System Control Module -> External Interrupt 0­3 Control register
> > [3] drivers/mmc/host/at91_mci.c
> > [4] drivers/ata/pata_rb532_cf.c
[5]
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=include/asm-arm/arch-ns9xxx/gpio.h;hb=HEAD#l34

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
