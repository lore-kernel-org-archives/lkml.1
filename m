Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249AbYJCNDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbYJCNDf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 09:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbYJCND2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 09:03:28 -0400
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:58440 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbYJCND1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 09:03:27 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+XyUf8YtXTq9PcBsp8KiKp
Date: Fri, 3 Oct 2008 16:06:21 +0300
From: Tony Lindgren <tony@atomide.com>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <linux@maxim.org.za>,
       Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH/RFC] hardware irq debouncing support
Message-ID: <20081003130618.GJ25482@atomide.com>
References: <200809241251.32606.david-b@pacbell.net> <20081003073816.GB25482@atomide.com> <200810030145.02779.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810030145.02779.david-b@pacbell.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Brownell <david-b@pacbell.net> [081003 11:45]:
> On Friday 03 October 2008, Tony Lindgren wrote:
> > * David Brownell <david-b@pacbell.net> [080924 22:51]:
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
> > > Comments?
> > > 
> > > Having this mechanism in genirq would let boards remove a bunch of
> > > nonportable code, and would let drivers like gpio_keys, gpio_mouse,
> > > and various touchscreens work more reliably.  It'd also let various
> > > SOC-specific MMC and CF card drivers switch over to more standard
> > > (and widely understandable) mechanisms.
> > 
> > Yeah this would nuke bunch of omap specific code for dealing with
> > battery covers, MMC slot open etc..
> 
> It would be hidden away behind IRQF_DEBOUNCE ... not so much
> making the code vanish, as making hardware-specific interfaces
> vanish in favor of what seems to be the most popular idiom.
> 
> (Regular input GPIOs could be debounced too, but every time
> I've noticed debouncing in use, it's coupled to an IRQ.)
>
> > > I'd like to submit such updates for the 2.6.28 merge window, in
> > > part to let mainline avoid needing yet another driver-specific
> > > programming interface for IRQ debouncing.  (For TWL4030/TPS659x0,
> > > as used in most OMAP3 boards including the Gumstix Overo and the
> > > BeagleBoard.)
> > 
> > What's the plan for sysfs_notify event for these switches? Are you
> > planning to add something like that to gpiolib?
> 
> I'm not sure what you mean -- which particular switches?
> If the issue is the MMC card detect switches, that seems
> more like an MMC question...
> 
> There was discussion of having the gpio_export() code
> support notification that way, triggered by interrupts
> on IRQ-capable GPIOs, but nobody seems to have wanted
> it enough to translate from talk to code.  ;)

Well in linux-omap tree we have the gpio-switch.c that is handy for
generic state switched like headset connected etc. It shows the
events also via sysfs_notify() so userspace can pop up messages.

That code should use gpiolib..  But I was wondering if we'll need it
eventually at all.

Tony



> 
> - Dave
> 
>  
> > Tony
> > 
> > 
> > > p.s. Tony and Kevin:  note the locking bugfix in the OMAP2/3 bit.
> > 
> > Here's my ack for that:
> > 
> > Acked-by: Tony Lindgren <tony@atomide.com>
> 
> For the whole patch, I'll presume, not just that locking fix.  ;)

Sure :)

> 
> > 
> > > 
> > > ---
> > >  arch/arm/mach-at91/gpio.c    |   13 +++++++++++++
> > >  arch/arm/plat-omap/gpio.c    |   15 ++++++++++++++-
> > >  arch/avr32/mach-at32ap/pio.c |   14 ++++++++++++++
> > >  include/linux/interrupt.h    |    2 ++
> > >  include/linux/irq.h          |    3 +++
> > >  kernel/irq/manage.c          |   27 +++++++++++++++++++++++++++
> > >  6 files changed, 73 insertions(+), 1 deletion(-)
> > > 
