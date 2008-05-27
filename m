Return-Path: <linux-kernel-owner+w=401wt.eu-S1759435AbYE0Uvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbYE0Uvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 16:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758123AbYE0Uvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 16:51:35 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:38259 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757976AbYE0Uvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 16:51:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=QtfljkSb9pgfMs8psFcl0wPvL6LurlBOrKEs0RRXHHOWJWZ6Nrc1S8jdWP7vdm4GR4NyVpeMzfVFjULFhYzqIoEUm6yrNj+Bc69NoTDsb+8Eik9+z0zrl1/Jnob7q3NzEsdX+Agm/0Oy4FJzdBlbSytxJUEUgOQ5eoZWkLQAYuI=  ;
X-YMail-OSG: lzav9wYVM1lRDbg3pLAMWm9ifAm6Ga4SEuA3Dz3BVP4S_SDv0Vdc1GqUxwGWhXrZf244130UqbUQm2FIHRP6O0FwzeoDDBm.KuCelxfSk6D5ZORc5pwZA5t3295noQl9I0jLxFkOxMuIBDr3KbtqrDmc
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Uwe =?iso-8859-1?q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
Subject: Re: configure gpio for interrupt function
Date: Tue, 27 May 2008 13:49:24 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <20080527130236.GA18546@digi.com>
In-Reply-To: <20080527130236.GA18546@digi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200805271349.24884.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 May 2008, Uwe Kleine-König wrote:
> Hello David,
> 
> I want to use a driver that in turn uses the gpio API (i.e.
> drivers/input/keyboard/gpio_keys.c).  My problem with that is, that my
> machine[1]'s external irqs don't fit into the GPIO API model.  The main
> problem is that gpio_direction_input isn't enough to get an irq.
> I need to explicitly set the gpio to an EXT_IRQ function.

Let me describe your situation a bit differently:  the GPIO
hardware on your platform doesn't support IRQs, so you want to
overlay the EXT_IRQ functions as transparently as you can.

I don't happen to have come across GPIO controllers without
IRQ support before, unless maybe you consider PXA to work
like that.  (PXA docs write "GPIO" most places it'd be more
clear to say "pin", so that's highly confusing.)  I've used
systems with EXT_INT function options on pins that support
full GPIO functionality (including pin change IRQs) though.


> (I can workaround that because the EXT_IRQ function allows to read the
> state of the gpio.  So I can use the EXT_IRQ function if input is
> requested.)

That's part of the reason pinmux and GPIO are orthogonal!
Your platforms GPIO code can treat EXT_INT pins as input
GPIOs; it has no reason to care.

So the *cleanest* way to handle this would be as an EXT_IRQ with
an affiliated GPIO signal, instead of a single funky GPIO.  That
mapping could be done by gpio_to_irq().

An alternate implementation would make the irq_chip for those GPIOs
understand the GPIO-to-EXT_IRQ mappings, and use them for those
pins that are inputs *and* have request_irq() called.  It sounds
as messy as I'm sure the code would be.


> Another problem is that I cannot implement irq_to_gpio correctly,
> because several gpio's share the same irq.

Sure, no problem.  irq_to_gpio() can't succeed for all GPIOs.
On your platform, I might be inclined to make it fail in all
cases to force drivers to record both IRQ and GPIO.

(And yes, that implies gpio_keys needs to generalize a bit.
Right now it assumes a one-to-one mapping.)


> (Note this makes the workaround above less reliable.  Consider two
> gpios sharing the same irq.  I cannot assert that only one of them can
> trigger the interrupt.)

This is another reason to prefer the "cleanest" solution above.
Drivers could request_irq() the EXT_IRQ(N) signal as IRQF_SHARED,
and the handler could check the relevant IRQ as needed.

Of course, this may require code using your platform to know
that it needs to track two values (EXT_IRQ and GPIO) not one.


> So I suggest to extend the gpio API with two functions like:
> 
> 	int gpio_direction_inputirq(unsigned gpio, unsigned flags);
> 	void gpio_ackirq(unsigned gpio);
> 
> with flags being similar to the IRQF_TRIGGER_* defines in
> include/linux/interrupt.h.  I need gpio_ackirq because ns9xxx requires
> that an edge triggered irq is acknowledged separatly in the "External
> Interrupt X Control register"[2].  (If you have better names ...)
> 
> Moreover this makes the API more flexible because the irq type can be
> configured.

I don't see a need to extend the API.  The current APIs will do what
you need, if you use them correctly:

  - gpio_to_irq() encapsulates your CPU's EXT_IRQ(x) pinmux logic;
    possibly just a table lookup.

  - irq_to_gpio() may fail in all cases

  - request_irq() kicks in irq_chip logic to ensure that the pin
    is either input GPIO (and remuxes it) or already EXT_INT ...

  - free_irq() can remux EXT_INT as GPIO, if it changed muxing in
    the first place.  (so gpio_direction_output can work, later.)

  - set_irq_type() configures the IRQ type via irq_chip hooks

Right?

 
> OTOH I'd like to deprecate irq_to_gpio.  $(git grep -l irq_to_gpio
> drivers) suggests that this function is only used in two places.  One of
> them[3] is AT91 specific, the other[4] seems specific for the
> RouterBoard 532.
> (There are some other users below arch/, but I expect no breakage here.
> I expect that every arch that uses the function have it implemented
> anyhow.)

That's true for that AT91 case, for example.


> What do you think?

Deprecating irq_to_gpio() seems a bit strong to me, but maybe that's
because I've never worked on hardware that can't support it.  ISTR that
Russell King disliked it a lot, but couldn't explain "why" to me.  This
may be a good enough reason to do so:  an example showing non-portability
(albeit because the IRQ in question is _not_ a GPIO irq).

Why don't you whip up a patch doing the right thing for irq_to_gpio(),
and send it along.  Right now I'd be inclined to sign off on it.

- Dave



> Best regards
> Uwe
> 
> [1] http://www.digi.com/products/embeddedsolutions/ns9215.jsp
>     Interesting sections are "Pinout -> General purpose I/O (GPIO)" and
>     "I/O Control Module".  E.g. GPIO4's func1 is "Ext Int Ch 2"
> [2] System Control Module -> External Interrupt 0­3 Control register
> [3] drivers/mmc/host/at91_mci.c
> [4] drivers/ata/pata_rb532_cf.c
> 

