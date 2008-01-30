Return-Path: <linux-kernel-owner+w=401wt.eu-S1759926AbYA3LtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759926AbYA3LtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 06:49:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbYA3Ls4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 06:48:56 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:61526 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752634AbYA3Lsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 06:48:55 -0500
Date: Wed, 30 Jan 2008 12:47:54 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: michael <trimarchi@gandalf.sssup.it>, linux-kernel@vger.kernel.org,
       Andrew Victor <linux@maxim.org.za>
Subject: Re: at91sam9260 wakeup on serial port
Message-ID: <20080130124754.70f5b218@dhcp-252-066.norway.atmel.com>
In-Reply-To: <200801291944.53591.david-b@pacbell.net>
References: <479DB934.6090806@gandalf.sssup.it>
	<200801281021.57317.david-b@pacbell.net>
	<20080128195114.33d7616d@dhcp-252-066.norway.atmel.com>
	<200801291944.53591.david-b@pacbell.net>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008 19:44:53 -0800
David Brownell <david-b@pacbell.net> wrote:

> On Monday 28 January 2008, Haavard Skinnemoen wrote:
> > 
> > > What will AVR32 (AP7) need to do, when it supports system sleep states?
> > 
> > Not sure. The PIOs seem to require a clock in order to detect a pin
> > change, so I don't think we can enter very deep sleep states if we want
> > to be woken up by the USART.
> 
> Right; if no DMA is pending, then the HSB matrix clock can be idled, DRAM put
> into self-refresh, and most peripherals can issue wakeups ... AP7 "Frozen"
> state, very analagous to AT91 "standby" on Linux.  UARTs and GPIOs can wake.

Yeah, although the nasty thing about UARTs is that you never know when
DMA really is idle.

> Deeper sleep states -- "standby" with clocks running, "stop" with all
> except 32K (and RTC) off, "static" with no clocks at all -- can only
> wake from WAKE_N and external interrupts; and RTC except in "static".
> I suspect "stop" and "static" might want to use the on-chip SRAMs so
> they don't need to change DRAM timings while they fiddle with clocks.

I think we can ignore "static". The power savings are minimal compared
to "stop", and you lose the RTC. Might as well power down the whole
chip and save even more power.

But yeah, I imagine we need to use some on-chip SRAM (or some locked
parts of the caches) when transitioning the SDRAM into and out of
self-refresh mode, and when changing timings.

> The closest analogue to the AT91 support would map /sys/power/state:
> 
> 	standby --> to AP7 "Frozen"
> 	mem --> to AP7 "Stop"

Yes, that looks reasonable. We can also do something in between by
stopping most peripherals and busses. For example, keep one peripheral
bus and one USART running from OSC0 with everything else stopped.

> Except that there could be no GPIO wakeups from "mem" ... so the $SUBJECT
> patch wouldn't be useful on AVR32 (just AT91), unless USARTn.RXD is wired
> up to one of those special wake-capable pins (extremely board-specific).

Right. But we could do it in one of those "something in between" states.

With all the other stuff that needs to be done when switching power
modes (running suspend() hooks, etc.) I don't think we need to limit
ourselves to what the "sleep" instruction can do, although the
predefined power states may serve as a nice starting point.

> > There's a separate WAKE_N pin that is completely asynchronous, so with
> > some external logic, we can probably wake up the CPU all the way from
> > Static mode if a given input state is present. But that's definitely
> > "board specific" territory, and starting the oscillators take a _long_
> > time on the AP7000 (especially the 32 kHz, but then again, it barely
> > consumes any power, so we might as well keep it running and keep the
> > RTC going as well.)
> 
> I'd think the support of any "deeper" state for "mem" sleep would not
> be entirely board specific ... when the RTC alarm is set, any board
> should be able to use states other than "static".  But otherwise, no
> board could enter those states unless WAKE_N or an external IRQ are
> doing something useful (like being hooked up to a button).
> 
> Matching those few "deep wake" events to a given device would imply
> board-specific glue code.

I think we need some chip- or family-specific sleep code that knows how
to enter a given power state. But the specifics about how to wake the
system up must necessarily be board-specific (or even run-time
configurable.)

> > So on AP7000, I think we'll just need to keep clocking the USART and
> > let it generate the interrupt that wakes up the rest of the system.
> 
> For "standby" sleep state, yes -- map to at most AVR32 "Frozen" state.
> That'd be a good first step for PM support.

Right. I guess it's about time we got some proper power management
implemented on avr32...I'll see if I can get started on that soon, but
you're giving me a hard time about my DMA patches :-P

Haavard
