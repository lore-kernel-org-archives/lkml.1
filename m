Return-Path: <linux-kernel-owner+w=401wt.eu-S965158AbXDMWnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965158AbXDMWnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 18:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965277AbXDMWnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 18:43:40 -0400
Received: from smtp103.sbc.mail.mud.yahoo.com ([68.142.198.202]:45239 "HELO
	smtp103.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965158AbXDMWng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 18:43:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=oBKay8T0PJB5bVOh0Xj/RRtQ7p4RNK668IfvfFqLXoTiqND8nonxsIWookRP/G9A+FcV3j5tfHIq89utxhmK4VIEGLcRfZop3PTWPvhEEd1bgX1m+t3EWY0TY0Yomk5iEQULUKA2VnHqBMyJGeDL079IUB0VR4xNx0UPJOXYYQU=  ;
X-YMail-OSG: OUTxi.IVM1l1DYbX4U6tA4oUhTuJTRJH0lM6jW6IwpOZ5hDEKwv8pW6pMWcVsJOHJylx4EXwNQ--
From: David Brownell <david-b@pacbell.net>
To: "Francis Moreau" <francis.moro@gmail.com>
Subject: Re: question on generic gpio interface
Date: Fri, 13 Apr 2007 15:43:32 -0700
User-Agent: KMail/1.7.1
Cc: linux-kernel@vger.kernel.org
References: <38b2ab8a0704131351la5085vf0ab58e85cf49879@mail.gmail.com>
In-Reply-To: <38b2ab8a0704131351la5085vf0ab58e85cf49879@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704131543.32976.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 April 2007 1:51 pm, Francis Moreau wrote:
> Hi,
> 
> I'm trying to port my old gpio code to the generic one to see if it
> can fit my needs.

Good .. this is more like an IRQ question though.


> The gpio controller is a home made one and has a really weird
> interface. It has several registers to read the gpio status, to
> configure gpio directions, or to configure if a gpio can trigger an
> interrupt and on which event (level or edge). All gpios use the same
> IRQ and a gpio controller register allows to read which gpio has
> triggered the interrupt.

I'll trust you on "weird", but that sounds quite typical in
terms of functionality.  You'll find that most system-on-chip
GPIO controllers act the same way.

IRQ logic on that platform must do a few things, like:

 - NR_IRQS includes the N interrupts triggered from that chip,
   and their numbers probably fit right sometimes after the
   core set of IRQs (which might include SOC GPIO irqs);

 - You'll provide an irq_chip for this controller, and it will
   handle the relevant irq operations (set trigger type, mask,
   unmask etc);

 - When configuring the IRQ handler for that "same IRQ", you'll
   set it up to use a chained handler that you provide, which
   reads the register to see which gpio(s) triggered the IRQ,
   maybe acks it (if just reading that register isn't enough),
   and then calls whatever handler was instaled for that GPIO.

If that's not familiar to you, look at arch/arm/mach-at91/gpio.c
or arch/arm/mach-pxa/irq.c or arch/arm/plat-omap/gpio.c or a
number of other similar files showing how the "toplevel" IRQ
logic will demux from a "one of these N GPIOs" interrupt down
to the handler for that particular IRQ.


> Now the question is how should irq_to_gpio()  work ?

Normally irq_to_gpio() and gpio_to_irq() are simple arithmetic
operations.  If both identifiers start at zero, irq_to_gpio()
would probably subtract a constant, and gpio_to_irq() would add
the same constant.


> Is it supposed to be called only when a gpio interrupt occure ?

It's not the most commonly used operation, and exactly when
it's used would be the choice of whatever code uses it.  That
would be one common answer ... e.g. for GPIOs that only allow
"both edges" triggering, the driver may actually care about the
level so it's got to check that with gpio_get_value().

If the IRQ handler doesn't like the notion of subtracting that
constant at that time, it's easy to cache the answer ahead of
time.  (Though it might not be a net win to spend extra memory
that way.)

 
> Another question is how can I specify if a gpio interrupt trigger on
> level or on edge ?

That's handled in the irq_chip.set_type() method.  See the above
referenced source files for examples.

- Dave


> thanks
> -- 
> Francis
> 
