Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbYJCJXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbYJCJXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 05:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbYJCJXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 05:23:10 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:50933 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbYJCJXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 05:23:09 -0400
Date: Fri, 3 Oct 2008 11:22:14 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <linux@maxim.org.za>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH/RFC] hardware irq debouncing support
Message-ID: <20081003112214.6c7db241@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <200809241251.32606.david-b@pacbell.net>
References: <200809241251.32606.david-b@pacbell.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Oct 2008 09:22:00.0823 (UTC) FILETIME=[7DA70070:01C92539]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell <david-b@pacbell.net> wrote:
> Hardware IRQ debouncing is common for IRQ controllers which are
> part of GPIO modules ... they often deal with mechanical switches,
> buttons, and so forth.  This patch:
> 
>  - Provides simple support for that in genirq
> 
>  - Includes sample implementations for some Linux systems
>    which already include non-generic support for this:
> 
>      * Atmel SOCs (AT91, AT32 -- the same GPIO module)
>      * OMAP2/OMAP3 (not quite as simple)
> 
> Control over how long to debounce is less common, and often applies
> to banks of GPIOs not individual signals ... not addressed here.
> 
> Drivers can request this (where available) with a new IRQF_DEBOUNCED
> flag/hint passed to request_irq():
> 
>     IF that flag is set when a handler is registered
> 	AND the relevant irq_chip supports debouncing
> 	AND the IRQ isn't already flagged as being debounced
>     THEN the irq_chip is asked to enable debouncing for this IRQ
> 	UNTIL the IRQ's last handler is unregistered.
>     ELSE
>         nothing is done ... the hint is ignored
>     FI
> 
> Comments?

Note that at least for AT91 and AVR32, the terminology used is "glitch
filtering", not "debouncing". The filtering period is very short (half
a clock cycle), so it probably won't help much when dealing with
mechanical switches and buttons.

What kind of guarantees should IRQF_DEBOUNCE provide? Filtering short
glitches may be useful, but if drivers start assuming it will do real
debouncing of badly filtered switches and buttons, I think we're in for
some trouble...

> Having this mechanism in genirq would let boards remove a bunch of
> nonportable code, and would let drivers like gpio_keys, gpio_mouse,
> and various touchscreens work more reliably.  It'd also let various
> SOC-specific MMC and CF card drivers switch over to more standard
> (and widely understandable) mechanisms.
> 
> I'd like to submit such updates for the 2.6.28 merge window, in
> part to let mainline avoid needing yet another driver-specific
> programming interface for IRQ debouncing.  (For TWL4030/TPS659x0,
> as used in most OMAP3 boards including the Gumstix Overo and the
> BeagleBoard.)

Given that the limitations of this interface are clearly documented, I'm
all for it.

What would be perhaps even more useful is generic software debouncing
support. Something like

  int request_debounced_irq(int irq, unsigned long debounce_us,
		void (*handler)(void *data), void *data);

which would set up a handler which disables the interrupt and sets up a
timer which will ack/unmask the interrupt and run the handler.

This would mean the "interrupt handler" really gets run in softirq
context, and shared interrupt would probably be impossible to support,
but I think it would be useful for certain kinds of interrupts.

What do you think?

Haavard
