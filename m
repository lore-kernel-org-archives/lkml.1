Return-Path: <linux-kernel-owner+w=401wt.eu-S1752107AbZGVJ0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbZGVJ0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 05:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbZGVJ0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 05:26:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37179 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbZGVJ0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 05:26:10 -0400
Date: Wed, 22 Jul 2009 10:25:47 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ahmed Ammar <b33fc0d3@gentoo.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Ahmed Ammar <aammar@edge-techno.com>
Subject: Re: [PATCH 1/1] [ARM] ep93xx clockevent support
Message-ID: <20090722092547.GA28648@n2100.arm.linux.org.uk>
References: <1248253786-18993-1-git-send-email-b33fc0d3@gentoo.org> <1248253786-18993-2-git-send-email-b33fc0d3@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248253786-18993-2-git-send-email-b33fc0d3@gentoo.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 12:09:46PM +0300, Ahmed Ammar wrote:
> @@ -849,6 +851,7 @@ config HZ
>  	default AT91_TIMER_HZ if ARCH_AT91
>  	default 100
>  
> +

Please don't add unrelated blank lines.

> @@ -100,55 +103,129 @@ void __init ep93xx_map_io(void)
>   * to use this timer for something else.  We also use timer 4 for keeping
>   * track of lost jiffies.
>   */
> -static unsigned int last_jiffy_time;
> -
> -#define TIMER4_TICKS_PER_JIFFY		((CLOCK_TICK_RATE + (HZ/2)) / HZ)
> +static struct clock_event_device clockevent_ep93xx;
>  
>  static irqreturn_t ep93xx_timer_interrupt(int irq, void *dev_id)
>  {
> -	__raw_writel(1, EP93XX_TIMER1_CLEAR);
> -	while ((signed long)
> -		(__raw_readl(EP93XX_TIMER4_VALUE_LOW) - last_jiffy_time)
> -						>= TIMER4_TICKS_PER_JIFFY) {
> -		last_jiffy_time += TIMER4_TICKS_PER_JIFFY;
> -		timer_tick();
> -	}
> -
> + 	__raw_writel(EP93XX_TC_CLEAR, EP93XX_TIMER1_CLEAR);
> + 	clockevent_ep93xx.event_handler(&clockevent_ep93xx);

You can avoid the forward declaration by doing:

	struct clk_event_device *evt = dev_id;

	evt->event_handler(evt);

here, and:

> +static struct clock_event_device clockevent_ep93xx = {
> +	.name		= "ep93xx-timer1",
> +	.features	= CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_PERIODIC,
> +	.shift		= 32,
> +	.set_mode	= ep93xx_set_mode,
> +	.set_next_event	= ep93xx_set_next_event,
> +};
> +
>  static struct irqaction ep93xx_timer_irq = {
>  	.name		= "ep93xx timer",
>  	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
>  	.handler	= ep93xx_timer_interrupt,

adding here:

	.dev_id		= &clockevent_ep93xx,

> diff --git a/arch/arm/mach-ep93xx/include/mach/timex.h b/arch/arm/mach-ep93xx/include/mach/timex.h
> index 6b3503b..ddf3a8a 100644
> --- a/arch/arm/mach-ep93xx/include/mach/timex.h
> +++ b/arch/arm/mach-ep93xx/include/mach/timex.h
> @@ -1,5 +1,11 @@
>  /*
>   * arch/arm/mach-ep93xx/include/mach/timex.h
>   */
> +#include <mach/ep93xx-regs.h>
> +#include <asm/io.h>
>  
>  #define CLOCK_TICK_RATE		983040
> +
> +#define mach_read_cycles() __raw_readl(EP93XX_TIMER4_VALUE_LOW)
> +#define mach_cycles_to_usecs(d) (((d) * ((1000000LL << 32) / CLOCK_TICK_RATE)) >> 32)
> +#define mach_usecs_to_cycles(d) (((d) * (((long long)CLOCK_TICK_RATE << 32) / 1000000)) >> 32)

Two points here:

1. You don't seem to use these in this patch, they're unrelated so please
   send as a separate patch.
2. Please don't pollute mach/timex.h with anything other than the
   CLOCK_TICK_RATE definition.  That's what it's there for, and it gets
   included by almost the entire kernel, so please don't pollute this
   file.
