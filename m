Return-Path: <linux-kernel-owner+w=401wt.eu-S1756394AbYBXSVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbYBXSVb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 13:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbYBXSVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 13:21:23 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:52269 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751022AbYBXSVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 13:21:22 -0500
Date: Sun, 24 Feb 2008 19:21:22 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Andrew Victor <linux@maxim.org.za>
Subject: Re: [patch 2.6.25-rc2-git 2/2] atmel_tc clocksource/clockevent code
Message-ID: <20080224192122.46a49216@siona>
In-Reply-To: <200802221728.37910.david-b@pacbell.net>
References: <200802221728.37910.david-b@pacbell.net>
Organization: Atmel
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again, sorry for the delay...it really sucks that I haven't been able
to look at this stuff closely until now. Hopefully a late review is
better than no review.

On Fri, 22 Feb 2008 17:28:37 -0800
David Brownell <david-b@pacbell.net> wrote:

> +static cycle_t tc_get_cycles(void)
> +{
> +	unsigned long	flags;
> +	u32		lower, upper;
> +
> +	raw_local_irq_save(flags);

Why do you need to use the raw version?

> +retry:
> +	upper = __raw_readl(tcaddr + ATMEL_TC_REG(1, CV));
> +	lower = __raw_readl(tcaddr + ATMEL_TC_REG(0, CV));
> +	if (upper != __raw_readl(tcaddr + ATMEL_TC_REG(1, CV)))
> +		goto retry;

Did you just open-code a do/while loop using goto? ;-)

> +#ifdef CONFIG_GENERIC_CLOCKEVENTS
> +#define USE_TC_CLKEVT
> +#endif
> +
> +#ifdef CONFIG_ARCH_AT91RM9200
> +/* The AT91rm9200 system timer is a oneshot-capable 32k timer that's
> + * always running ... configuring a TC channel to work the same way
> + * would just waste some power.
> + */
> +#undef USE_TC_CLKEVT
> +#endif
> +
> +#ifdef USE_TC_CLKEVT

Can't you just use #ifndef CONFIG_ARCH_AT91RM9200 and avoid the whole
ifdef/define/undef dance above?

> +	case CLOCK_EVT_MODE_ONESHOT:
> +		/* slow clock, count up to RC, then irq and stop */

Hmm. Do you really want to stop it? Won't you get better accuracy if
you let it run and program the next event as (prev_event + delta)?

> +static struct irqaction tc_irqaction = {
> +	.name		= "tc_clkevt",
> +	.flags		= IRQF_TIMER | IRQF_DISABLED,
> +	.handler	= ch2_irq,
> +};

I don't think you need to define this statically. You can call
request_irq() at arch_initcall() time.

> +static void __init setup_clkevents(struct platform_device *pdev,
> +		struct clk *t0_clk, int clk32k_divisor_idx)
> +{
> +	struct clk	*t2_clk = clk_get(&pdev->dev, "t2_clk");
> +	int		irq;
> +
> +	/* SOCs have either one IRQ and one clock for the whole
> +	 * TC block; or one each per channel.  We use channel 2.
> +	 */
> +	if (IS_ERR(t2_clk)) {
> +		t2_clk = t0_clk;
> +		irq = platform_get_irq(pdev, 0);
> +	} else {
> +		irq = platform_get_irq(pdev, 2);
> +		clk_enable(t2_clk);
> +	}

I don't think it is safe to assume that one clock per channel always
means one irq per channel as well...

What's wrong with

	irq = platform_get_irq(pdev, 2);
	if (irq < 0)
		irq = platform_get_irq(pdev, 0);

?

> +config ATMEL_TCB_CLKSRC
> +	bool "TC Block Clocksource"
> +	depends on ATMEL_TCLIB && GENERIC_TIME
> +	default y
> +	help
> +	  Select this to get a high precision clocksource based on a
> +	  TC block with a 5+ MHz base clock rate.  Two timer channels
> +	  are combined to make a single 32-bit timer.
> +
> +	  When GENERIC_CLOCKEVENTS is defined, the third timer channel
> +	  may be used as a clock event device supporting oneshot mode
> +	  (delays of up to two seconds) based on the 32 KiHz clock.
> +
> +config ATMEL_TCB_CLKSRC_BLOCK
> +	int
> +	depends on ATMEL_TCB_CLKSRC
> +	prompt "TC Block" if ARCH_AT91RM9200 || ARCH_AT91SAM9260 || CPU_AT32AP700X
> +	default 0
> +	range 0 1

Hmm...I don't like the direction this is going...

How about we make tcb_clksrc_init() global and call it from the
platform code with whatever TCB the platform thinks is appropriate?

Perhaps remove the prompt from ATMEL_TCB_CLKSRC and have the platform
select it as well? I certainly want to force this stuff on on the
AP7000...otherwise we'll just get lots of complaints that the thing is
using 4x more power than it's supposed to...

Haavard
