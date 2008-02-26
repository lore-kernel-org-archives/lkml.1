Return-Path: <linux-kernel-owner+w=401wt.eu-S1762178AbYBZJRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762178AbYBZJRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 04:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762010AbYBZJRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 04:17:15 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:60596 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761977AbYBZJRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 04:17:10 -0500
Date: Tue, 26 Feb 2008 10:16:25 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: nicolas.ferre@rfo.atmel.com, linux@maxim.org.za,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch 2.6.25-rc2-git 2/2] atmel_tc clocksource/clockevent code
Message-ID: <20080226101625.31f6954d@hskinnemoen.norway.atmel.com>
In-Reply-To: <20080225175116.A2C071E564F@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <200802221728.37910.david-b@pacbell.net>
	<20080224192122.46a49216@siona>
	<20080224234251.18B519B7DF@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	<20080225123146.61b68a51@dhcp-252-066.norway.atmel.com>
	<20080225175116.A2C071E564F@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008 09:51:16 -0800
David Brownell <david-b@pacbell.net> wrote:

> > > > > +static cycle_t tc_get_cycles(void)
> > > > > +{
> > > > > +	unsigned long	flags;
> > > > > +	u32		lower, upper;
> > > > > +
> > > > > +	raw_local_irq_save(flags);
> > > >
> > > > Why do you need to use the raw version?
> > > 
> > > This is part of the system timer code, and it should never be a
> > > preemption point.  Plus I didn't want to waste any instruction
> > > cycles in code that runs before e.g. the DBGU IRQ handler would
> > > get called... observably, such extra cycles *do* hurt.
> >
> > I don't understand what you mean by preemption point, but I guess the
> > non-raw version may consume some extra cycles when lockdep is enabled.
> 
> A preemption point is where CONFIG_PREEMPT kicks in task switching
> logic; lockdep is different.

I know, but I dont' see how local_irq_save/restore has anything to do
with it, raw or not. There would be absolutely no point checking for
preemption on local_irq_restore() since no one would have been able to
set the TIF_NEED_RESCHED flag while interrupts were disabled...

raw_local_irq_save/restore is only different from
local_irq_save/restore when lockdep is enabled. That's why I don't
understand why you're talking about preemption.

> > If we really expect using TC as a clocksource but not as a clockevent
> > is going to be a common usage, perhaps we should move the decision into
> > Kconfig?
> 
> Maybe, but I already spent lots more time on this than I wanted.  :(

I'm not asking you to do it. I'm asking if it would be a good thing to
do. I said that I can take these patches off your back if you want, but
I want to make sure I don't do anything with them that you disagree
with.

> Another way to address that rm9200 issue would be to just rate
> the TC clockevent source lower than the one based on the system
> timer, so it's set up but never enabled ... and remember "t2_clk",
> calling clk_enable() only when that clockevent device is active.
> 
> That would address one half of the suspend/resume equation too,
> ensuring that clock is disabled during suspend...

Yes, we could probably do that. Which means we can just remove all the
ifdeffery?

> The other half being:  how to clk_disable(t0_clk) during system
> suspend?  (And t1_clk on some systems.)  There's currently no
> clocksource.set_mode() call; evidently there's an assumption that
> such counters cost no power, so they can always be left running.

Yes...that would be a clocksource core issue I guess. Better leave that
for later...

> > > > I don't think it is safe to assume that one clock per channel always
> > > > means one irq per channel as well...
> > > 
> > > On current chips, that's how it works.
> >
> > Indeed. I just don't see any fundamental reason why it has to work that
> > way, which is why I don't think we should depend on it.
> 
> AT91 chips share identifiers between clocks and interrupts; that's
> fundamental, yes?
> 
> If some future chip works differently, that's a good time to change
> things.  Otherwise I see little point in caring about such issues.

Agreed.

Haavard
