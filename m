Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbYJGSOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbYJGSOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 14:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbYJGSOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 14:14:08 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:46080 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751671AbYJGSOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 14:14:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=j81D3QnRPqcI0kWd0oD/RRhEAWWLocOoblwvFjHyOVzGiyOzkEN72+D/0qPkhNEyGTxKWYgKsUqLKdoobC0KLEcbgTnS4OVm7xPvAQrueXO3pDTk6gvvf0PrBtVfzPu3Jb/tT9rJR3cXgHtzmP8jYxF2LPs5q4ujNbVQrBSzpkQ=  ;
X-YMail-OSG: juu37lgVM1mgiMtjTaxgfAsatGY4BvTpPaqcly4WVjf4gwii0BXFpLlmGpRdNLuMyfBhCtku.QGoOTDC_mzpgRazP5QxHfuVLjSsf7nCPw1sezxcsRAsAV4GHwL09qtWFdRu7AnbNqa9n0i.Kv0AeSYU
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH/RFC] hardware irq debouncing support
Date: Tue, 7 Oct 2008 11:14:02 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <linux@maxim.org.za>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Tony Lindgren <tony@atomide.com>
References: <200809241251.32606.david-b@pacbell.net> <20081003112214.6c7db241@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20081003112214.6c7db241@hskinnemo-gx745.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810071114.03219.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 October 2008, Haavard Skinnemoen wrote:
> David Brownell <david-b@pacbell.net> wrote:
> > Hardware IRQ debouncing is common for IRQ controllers which are
> > part of GPIO modules ... they often deal with mechanical switches,
> > buttons, and so forth.  This patch:
> > 
> >  - Provides simple support for that in genirq
> > 
> >  - Includes sample implementations for some Linux systems
> >    which already include non-generic support for this:
> > 
> >      * Atmel SOCs (AT91, AT32 -- the same GPIO module)
> >      * OMAP2/OMAP3 (not quite as simple)
> > 
> > 		...
> 
> Note that at least for AT91 and AVR32, the terminology used is "glitch
> filtering", not "debouncing". The filtering period is very short (half
> a clock cycle), so it probably won't help much when dealing with
> mechanical switches and buttons.

Right re mechanical switching -- still needs more debouncing -- but it
would at least help with some of the contact chatter.  Quoting from one
manual (at91sam9263):

    When the glitch filter is enabled, a glitch with a duration of less
    than 1/2 Master Clock (MCK) cycle is automatically rejected, while a
    pulse with a duration of 1 Master Clock cycle or more is accepted.
    For pulse durations between 1/2 Master Clock cycle and 1 Master Clock
    cycle the pulse may or may not be taken into account, depending on
    the precise timing of its occurrence. Thus for a pulse to be visible
    it must exceed 1 Master Clock cycle, whereas for a glitch to be reliably
    filtered out, its duration must not exceed 1/2 Master Clock cycle. 

The mechanism is fairly typical, except for (a) duration of "one" clock
cycle, which is sometimes configurable and not infrequently more than
just one cycle, and (b) "Master" clock, which on those chips is the same
as the memory clock -- e.g. 100 MHz in normal operation, or maybe half
that on some boards -- but on other chips is a lot slower.

Example:  OMAP2/OMAP3 has a configurable duration of 1 to 256 in units
of what I'll guess are really 32 KiHZ clock ticks.  The default is one
tick (31 usec), so it can support up to almost 8 msec.

And on the chip I'm fighting with just now, the debounce is 30 msec,
take it or leave it.


> What kind of guarantees should IRQF_DEBOUNCE provide? Filtering short
> glitches may be useful, but if drivers start assuming it will do real
> debouncing of badly filtered switches and buttons, I think we're in for
> some trouble...

The quality-of-service question rears its ugly head ... ;)

If QOS is exposed (e.g. "unsigned debounce_usec" in the irq_desc),
that sort of begs the question of how to *change* that.  I had
hoped to let someone else address the issue of such interfaces...

What would you think about advice to debounce by default on the
order of one millisecond, where hardware allows?  Later, ways
to query and update that QOS could be defined.


> > Having this mechanism in genirq would let boards remove a bunch of
> > nonportable code, and would let drivers like gpio_keys, gpio_mouse,
> > and various touchscreens work more reliably.  It'd also let various
> > SOC-specific MMC and CF card drivers switch over to more standard
> > (and widely understandable) mechanisms.
> > 
> > I'd like to submit such updates for the 2.6.28 merge window, in
> > part to let mainline avoid needing yet another driver-specific
> > programming interface for IRQ debouncing.  (For TWL4030/TPS659x0,
> > as used in most OMAP3 boards including the Gumstix Overo and the
> > BeagleBoard.)
> 
> Given that the limitations of this interface are clearly documented, I'm
> all for it.

What changes would you suggest in the $SUBJECT patch then?

I notice that Documentation/DocBook/genericirq.tmpl doesn't
do a pretty job of formatting the IRQF_* parameters, but
that seems fixable.


> What would be perhaps even more useful is generic software debouncing
> support. Something like
> 
>   int request_debounced_irq(int irq, unsigned long debounce_us,
> 		void (*handler)(void *data), void *data);
> 
> which would set up a handler which disables the interrupt and sets up a
> timer which will ack/unmask the interrupt and run the handler.

Why require "software debouncing" if perhaps the hardware could do
it all for you?


> This would mean the "interrupt handler" really gets run in softirq
> context, and shared interrupt would probably be impossible to support,
> but I think it would be useful for certain kinds of interrupts.
> 
> What do you think?

Seems plausible.

I won't volunteer to write such a thing myself, but I can easily
imagine it starting to grow users.  At least, in the embedded
Linux space ... the server/desktop crowd seems unlikely to run
with that sort of hardware.

- Dave



