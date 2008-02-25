Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbYBYLcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbYBYLcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 06:32:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbYBYLcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 06:32:39 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:50783 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752198AbYBYLci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 06:32:38 -0500
Date: Mon, 25 Feb 2008 12:31:46 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: nicolas.ferre@rfo.atmel.com, linux@maxim.org.za,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch 2.6.25-rc2-git 2/2] atmel_tc clocksource/clockevent code
Message-ID: <20080225123146.61b68a51@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080224234251.18B519B7DF@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <200802221728.37910.david-b@pacbell.net>
	<20080224192122.46a49216@siona>
	<20080224234251.18B519B7DF@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2008 15:42:51 -0800
David Brownell <david-b@pacbell.net> wrote:

> > On Fri, 22 Feb 2008 17:28:37 -0800
> > David Brownell <david-b@pacbell.net> wrote:
> >
> > > +static cycle_t tc_get_cycles(void)
> > > +{
> > > +	unsigned long	flags;
> > > +	u32		lower, upper;
> > > +
> > > +	raw_local_irq_save(flags);
> >
> > Why do you need to use the raw version?
> 
> This is part of the system timer code, and it should never be a
> preemption point.  Plus I didn't want to waste any instruction
> cycles in code that runs before e.g. the DBGU IRQ handler would
> get called... observably, such extra cycles *do* hurt.

I don't understand what you mean by preemption point, but I guess the
non-raw version may consume some extra cycles when lockdep is enabled.

> > > +#ifdef CONFIG_GENERIC_CLOCKEVENTS
> > > +#define USE_TC_CLKEVT
> > > +#endif
> > > +
> > > +#ifdef CONFIG_ARCH_AT91RM9200
> > > +/* The AT91rm9200 system timer is a oneshot-capable 32k timer that's
> > > + * always running ... configuring a TC channel to work the same way
> > > + * would just waste some power.
> > > + */
> > > +#undef USE_TC_CLKEVT
> > > +#endif
> > > +
> > > +#ifdef USE_TC_CLKEVT
> >
> > Can't you just use #ifndef CONFIG_ARCH_AT91RM9200 and avoid the whole
> > ifdef/define/undef dance above?
> 
> I can't know that some other platform won't have a better system
> timer solution, and didn't want to assume that only that single
> venerable chip had such a solution ... it's kind of puzzling to
> me (software guy) that none of the newest Atmel SOCs have better
> timer infrastructure than they do.  ;)

Heh.

If we really expect using TC as a clocksource but not as a clockevent
is going to be a common usage, perhaps we should move the decision into
Kconfig?

Besides, I don't really see the difference between having a big #ifdef
expression around the whole clockevent block and having a big #ifdef
expression around the definition of USE_TC_CLKEVT except that the
latter is more code...

> > > +	case CLOCK_EVT_MODE_ONESHOT:
> > > +		/* slow clock, count up to RC, then irq and stop */
> >
> > Hmm. Do you really want to stop it? Won't you get better accuracy if
> > you let it run and program the next event as (prev_event + delta)?
> 
> No, ONESHOT means "stop after the IRQ I asked for".  And when
> tc_next_event() is asked to trigger that IRQ, it's relative to
> the instant it's requested, not relative to the last one that
> was requested (which may not have triggered yet, or may have
> been quite some time ago).

Right. Sounds like it might introduce some inaccuracy, but I guess it's
the clocksource's job to keep track of the actual time at the time of
the event.

> > > +static struct irqaction tc_irqaction = {
> > > +	.name		= "tc_clkevt",
> > > +	.flags		= IRQF_TIMER | IRQF_DISABLED,
> > > +	.handler	= ch2_irq,
> > > +};
> >
> > I don't think you need to define this statically. You can call
> > request_irq() at arch_initcall() time.
> 
> That could be done, yes ... and using request_irq()/free_irq()
> would also let this be linked as a module, not just statically.
> 
> On the other hand, doing it this way doesn't hurt either does it?
> Unless a modular build is important.

No, it doesn't hurt. Maybe we should keep it static so that we have the
option of initializing it earlier if we need to.

> > I don't think it is safe to assume that one clock per channel always
> > means one irq per channel as well...
> 
> On current chips, that's how it works.

Indeed. I just don't see any fundamental reason why it has to work that
way, which is why I don't think we should depend on it.

> > What's wrong with
> >
> > 	irq = platform_get_irq(pdev, 2);
> > 	if (irq < 0)
> > 		irq = platform_get_irq(pdev, 0);
> 
> Nothing much, except that I took the more concise path.  Got patch?

Not until we reach a conclusion about the tclib core.

> > How about we make tcb_clksrc_init() global and call it from the
> > platform code with whatever TCB the platform thinks is appropriate?
> 
> That could work too, but if it goes that way then there's no
> point in changes to support a modular build (e.g. the irqaction
> thing you noted above).

True.

> > Perhaps remove the prompt from ATMEL_TCB_CLKSRC and have the platform
> > select it as well? I certainly want to force this stuff on on the
> > AP7000...otherwise we'll just get lots of complaints that the thing is
> > using 4x more power than it's supposed to...
> 
> Well, "force" seems the wrong approach to me.  That should be a
> board-specific choice.  The ap700x power budget may not be the
> most important system design consideration, so making such a
> decision at the platform ("ap700x") level seems wrong.
> 
> Suppose someone has to build an AVR32 based system that uses both
> TCB modules to hook up to external hardware, so that neither one
> is available for use as a "system timer"?

Good point. Let's keep it as it is and let the board "select" it
through its defconfig.

Haavard
