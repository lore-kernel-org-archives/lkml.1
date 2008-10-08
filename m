Return-Path: <linux-kernel-owner+w=401wt.eu-S1754607AbYJHHtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbYJHHtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 03:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbYJHHtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 03:49:08 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:48823 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbYJHHtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 03:49:06 -0400
Date: Wed, 8 Oct 2008 09:48:49 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Andrew Victor <linux@maxim.org.za>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH/RFC] hardware irq debouncing support
Message-ID: <20081008094849.752a29c0@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <200810071114.03219.david-b@pacbell.net>
References: <200809241251.32606.david-b@pacbell.net>
	<20081003112214.6c7db241@hskinnemo-gx745.norway.atmel.com>
	<200810071114.03219.david-b@pacbell.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Oct 2008 07:48:34.0065 (UTC) FILETIME=[43D46010:01C9291A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell <david-b@pacbell.net> wrote:
> On Friday 03 October 2008, Haavard Skinnemoen wrote:
> > David Brownell <david-b@pacbell.net> wrote:
> > > Hardware IRQ debouncing is common for IRQ controllers which are
> > > part of GPIO modules ... they often deal with mechanical switches,
> > > buttons, and so forth.  This patch:
> > > 
> > >  - Provides simple support for that in genirq
> > > 
> > >  - Includes sample implementations for some Linux systems
> > >    which already include non-generic support for this:
> > > 
> > >      * Atmel SOCs (AT91, AT32 -- the same GPIO module)
> > >      * OMAP2/OMAP3 (not quite as simple)
> > > 
> > > 		...
> > 
> > Note that at least for AT91 and AVR32, the terminology used is "glitch
> > filtering", not "debouncing". The filtering period is very short (half
> > a clock cycle), so it probably won't help much when dealing with
> > mechanical switches and buttons.
> 
> Right re mechanical switching -- still needs more debouncing -- but it
> would at least help with some of the contact chatter.  Quoting from one
> manual (at91sam9263):
> 
>     When the glitch filter is enabled, a glitch with a duration of less
>     than 1/2 Master Clock (MCK) cycle is automatically rejected, while a
>     pulse with a duration of 1 Master Clock cycle or more is accepted.
>     For pulse durations between 1/2 Master Clock cycle and 1 Master Clock
>     cycle the pulse may or may not be taken into account, depending on
>     the precise timing of its occurrence. Thus for a pulse to be visible
>     it must exceed 1 Master Clock cycle, whereas for a glitch to be reliably
>     filtered out, its duration must not exceed 1/2 Master Clock cycle. 
> 
> The mechanism is fairly typical, except for (a) duration of "one" clock
> cycle, which is sometimes configurable and not infrequently more than
> just one cycle, and (b) "Master" clock, which on those chips is the same
> as the memory clock -- e.g. 100 MHz in normal operation, or maybe half
> that on some boards -- but on other chips is a lot slower.

Good point. I'll suggest switching this mechanism over to use a 32 kHz
clock in future designs.

> Example:  OMAP2/OMAP3 has a configurable duration of 1 to 256 in units
> of what I'll guess are really 32 KiHZ clock ticks.  The default is one
> tick (31 usec), so it can support up to almost 8 msec.
> 
> And on the chip I'm fighting with just now, the debounce is 30 msec,
> take it or leave it.

Ok, so the limitations of various chips vary a lot...which means that
it's difficult to predict what IRQF_DEBOUNCED actually does.

> > What kind of guarantees should IRQF_DEBOUNCE provide? Filtering short
> > glitches may be useful, but if drivers start assuming it will do real
> > debouncing of badly filtered switches and buttons, I think we're in for
> > some trouble...
> 
> The quality-of-service question rears its ugly head ... ;)
> 
> If QOS is exposed (e.g. "unsigned debounce_usec" in the irq_desc),
> that sort of begs the question of how to *change* that.  I had
> hoped to let someone else address the issue of such interfaces...
> 
> What would you think about advice to debounce by default on the
> order of one millisecond, where hardware allows?  Later, ways
> to query and update that QOS could be defined.

I suppose a good start would be to add a comment saying that.

On the other hand, I don't see how drivers can even tell if the
hardware supports IRQF_DEBOUNCED at all...

> > > Having this mechanism in genirq would let boards remove a bunch of
> > > nonportable code, and would let drivers like gpio_keys, gpio_mouse,
> > > and various touchscreens work more reliably.  It'd also let various
> > > SOC-specific MMC and CF card drivers switch over to more standard
> > > (and widely understandable) mechanisms.
> > > 
> > > I'd like to submit such updates for the 2.6.28 merge window, in
> > > part to let mainline avoid needing yet another driver-specific
> > > programming interface for IRQ debouncing.  (For TWL4030/TPS659x0,
> > > as used in most OMAP3 boards including the Gumstix Overo and the
> > > BeagleBoard.)
> > 
> > Given that the limitations of this interface are clearly documented, I'm
> > all for it.
> 
> What changes would you suggest in the $SUBJECT patch then?

Just a comment, really. But I realize that it's difficult to specify
any guarantees since hardware may give you anything from a few
nanoseconds to 30 ms...

> I notice that Documentation/DocBook/genericirq.tmpl doesn't
> do a pretty job of formatting the IRQF_* parameters, but
> that seems fixable.

I'm not all that concerned with cosmetics...just having the information
somewhere would be nice.

> > What would be perhaps even more useful is generic software debouncing
> > support. Something like
> > 
> >   int request_debounced_irq(int irq, unsigned long debounce_us,
> > 		void (*handler)(void *data), void *data);
> > 
> > which would set up a handler which disables the interrupt and sets up a
> > timer which will ack/unmask the interrupt and run the handler.
> 
> Why require "software debouncing" if perhaps the hardware could do
> it all for you?

Because of the "perhaps" part of your sentence.

But ok, drivers really shouldn't have to care, so let's call it
"generic debouncing support".

> > This would mean the "interrupt handler" really gets run in softirq
> > context, and shared interrupt would probably be impossible to support,
> > but I think it would be useful for certain kinds of interrupts.
> > 
> > What do you think?
> 
> Seems plausible.
> 
> I won't volunteer to write such a thing myself, but I can easily
> imagine it starting to grow users.  At least, in the embedded
> Linux space ... the server/desktop crowd seems unlikely to run
> with that sort of hardware.

Maybe we should just add this interface and drop the flag? A flag will
never be able to convey some important parameters like how long to
debounce. Then a irq chip implementation can decide to do it in
hardware if the requested debounce delay matches what the hardware can
provide.

Maybe we should let drivers provide a range of acceptable delays so
that the irq chip driver won't have to guess at how long it is
acceptable to deviate from the specified delay.

Haavard
