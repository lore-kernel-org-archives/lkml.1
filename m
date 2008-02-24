Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYBXXnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYBXXnI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 18:43:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYBXXmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 18:42:55 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:34739 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751440AbYBXXmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 18:42:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=wXfJi9ZaN7x8TaXd1KOrD2dWRMkZHe7N6hK50QpicwnUQK6+RXqTBF6aK2GnQzRnjs2D7/V9vHmmGvX6WksLpyZb72gveCfCFx5aZozgEcUAG1vvtpnt3B8kWECmTqDISf1Pv+6pgyyFy5EE6Avw4Zcx2B8spgA1P1kKg7tN6gY=  ;
X-YMail-OSG: 1zIOyecVM1nKfqsZrlsO8m6s6UsTM3OUfH6O5rl3_dUcUcDjBKiDJlHgn2.DGq.0It5zc32sOg--
X-Yahoo-Newman-Property: ymail-3
Date: Sun, 24 Feb 2008 15:42:51 -0800
From: David Brownell <david-b@pacbell.net>
To: hskinnemoen@atmel.com
Subject: Re: [patch 2.6.25-rc2-git 2/2] atmel_tc clocksource/clockevent code
Cc: nicolas.ferre@rfo.atmel.com, linux@maxim.org.za,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <200802221728.37910.david-b@pacbell.net>
 <20080224192122.46a49216@siona>
In-Reply-To: <20080224192122.46a49216@siona>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080224234251.18B519B7DF@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Again, sorry for the delay...it really sucks that I haven't been able
> to look at this stuff closely until now. Hopefully a late review is
> better than no review.

Yes.  The review I've gotten so far has been of the "it works for me,
thanks" variety.

(The only issue reported to me is that NO_HZ on AT91 seems to make the
DBGU lose characters sometimes ... that one-byte "fifo" makes trouble
whenever there's the slightest delay in IRQ handling, and NO_HZ can
easily add such delays as part of ensuring that "jiffies" is current
before invoking handlers.)


> On Fri, 22 Feb 2008 17:28:37 -0800
> David Brownell <david-b@pacbell.net> wrote:
>
> > +static cycle_t tc_get_cycles(void)
> > +{
> > +	unsigned long	flags;
> > +	u32		lower, upper;
> > +
> > +	raw_local_irq_save(flags);
>
> Why do you need to use the raw version?

This is part of the system timer code, and it should never be a
preemption point.  Plus I didn't want to waste any instruction
cycles in code that runs before e.g. the DBGU IRQ handler would
get called... observably, such extra cycles *do* hurt.


> > +retry:
> > +	upper = __raw_readl(tcaddr + ATMEL_TC_REG(1, CV));
> > +	lower = __raw_readl(tcaddr + ATMEL_TC_REG(0, CV));
> > +	if (upper != __raw_readl(tcaddr + ATMEL_TC_REG(1, CV)))
> > +		goto retry;
>
> Did you just open-code a do/while loop using goto? ;-)

I take that back about late review being better than none.  ;)


> > +#ifdef CONFIG_GENERIC_CLOCKEVENTS
> > +#define USE_TC_CLKEVT
> > +#endif
> > +
> > +#ifdef CONFIG_ARCH_AT91RM9200
> > +/* The AT91rm9200 system timer is a oneshot-capable 32k timer that's
> > + * always running ... configuring a TC channel to work the same way
> > + * would just waste some power.
> > + */
> > +#undef USE_TC_CLKEVT
> > +#endif
> > +
> > +#ifdef USE_TC_CLKEVT
>
> Can't you just use #ifndef CONFIG_ARCH_AT91RM9200 and avoid the whole
> ifdef/define/undef dance above?

I can't know that some other platform won't have a better system
timer solution, and didn't want to assume that only that single
venerable chip had such a solution ... it's kind of puzzling to
me (software guy) that none of the newest Atmel SOCs have better
timer infrastructure than they do.  ;)


> > +	case CLOCK_EVT_MODE_ONESHOT:
> > +		/* slow clock, count up to RC, then irq and stop */
>
> Hmm. Do you really want to stop it? Won't you get better accuracy if
> you let it run and program the next event as (prev_event + delta)?

No, ONESHOT means "stop after the IRQ I asked for".  And when
tc_next_event() is asked to trigger that IRQ, it's relative to
the instant it's requested, not relative to the last one that
was requested (which may not have triggered yet, or may have
been quite some time ago).


> > +static struct irqaction tc_irqaction = {
> > +	.name		= "tc_clkevt",
> > +	.flags		= IRQF_TIMER | IRQF_DISABLED,
> > +	.handler	= ch2_irq,
> > +};
>
> I don't think you need to define this statically. You can call
> request_irq() at arch_initcall() time.

That could be done, yes ... and using request_irq()/free_irq()
would also let this be linked as a module, not just statically.

On the other hand, doing it this way doesn't hurt either does it?
Unless a modular build is important.


> > +static void __init setup_clkevents(struct platform_device *pdev,
> > +		struct clk *t0_clk, int clk32k_divisor_idx)
> > +{
> > +	struct clk	*t2_clk = clk_get(&pdev->dev, "t2_clk");
> > +	int		irq;
> > +
> > +	/* SOCs have either one IRQ and one clock for the whole
> > +	 * TC block; or one each per channel.  We use channel 2.
> > +	 */
> > +	if (IS_ERR(t2_clk)) {
> > +		t2_clk = t0_clk;
> > +		irq = platform_get_irq(pdev, 0);
> > +	} else {
> > +		irq = platform_get_irq(pdev, 2);
> > +		clk_enable(t2_clk);
> > +	}
>
> I don't think it is safe to assume that one clock per channel always
> means one irq per channel as well...

On current chips, that's how it works.


> What's wrong with
>
> 	irq = platform_get_irq(pdev, 2);
> 	if (irq < 0)
> 		irq = platform_get_irq(pdev, 0);

Nothing much, except that I took the more concise path.  Got patch?


> > +config ATMEL_TCB_CLKSRC
> > +	bool "TC Block Clocksource"
> > +	depends on ATMEL_TCLIB && GENERIC_TIME
> > +	default y
> > +	help
> > +	  Select this to get a high precision clocksource based on a
> > +	  TC block with a 5+ MHz base clock rate.  Two timer channels
> > +	  are combined to make a single 32-bit timer.
> > +
> > +	  When GENERIC_CLOCKEVENTS is defined, the third timer channel
> > +	  may be used as a clock event device supporting oneshot mode
> > +	  (delays of up to two seconds) based on the 32 KiHz clock.
> > +
> > +config ATMEL_TCB_CLKSRC_BLOCK
> > +	int
> > +	depends on ATMEL_TCB_CLKSRC
> > +	prompt "TC Block" if ARCH_AT91RM9200 || ARCH_AT91SAM9260 || CPU_AT32AP700X
> > +	default 0
> > +	range 0 1
>
> Hmm...I don't like the direction this is going...
>
> How about we make tcb_clksrc_init() global and call it from the
> platform code with whatever TCB the platform thinks is appropriate?

That could work too, but if it goes that way then there's no
point in changes to support a modular build (e.g. the irqaction
thing you noted above).


> Perhaps remove the prompt from ATMEL_TCB_CLKSRC and have the platform
> select it as well? I certainly want to force this stuff on on the
> AP7000...otherwise we'll just get lots of complaints that the thing is
> using 4x more power than it's supposed to...

Well, "force" seems the wrong approach to me.  That should be a
board-specific choice.  The ap700x power budget may not be the
most important system design consideration, so making such a
decision at the platform ("ap700x") level seems wrong.

Suppose someone has to build an AVR32 based system that uses both
TCB modules to hook up to external hardware, so that neither one
is available for use as a "system timer"?

- Dave

