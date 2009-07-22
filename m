Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbZGVS3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbZGVS3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 14:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbZGVS3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 14:29:20 -0400
Received: from exprod6og108.obsmtp.com ([64.18.1.21]:60469 "HELO
	exprod6og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753708AbZGVS3T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 14:29:19 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 1/1] [ARM] ep93xx clockevent support
Date: Wed, 22 Jul 2009 14:29:15 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901B1F4A2@mi8nycmail19.Mi8.com>
In-Reply-To: <1248253786-18993-2-git-send-email-b33fc0d3@gentoo.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] [ARM] ep93xx clockevent support
Thread-Index: AcoKrO+ZquJ74eeCQiSnDpo6hLNU3wASMMuA
References: <1248253786-18993-1-git-send-email-b33fc0d3@gentoo.org> <1248253786-18993-2-git-send-email-b33fc0d3@gentoo.org>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Ahmed Ammar" <b33fc0d3@gentoo.org>, <linux-kernel@vger.kernel.org>
Cc: <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Ahmed Ammar" <aammar@edge-techno.com>
X-OriginalArrivalTime: 22 Jul 2009 18:29:17.0522 (UTC) FILETIME=[5278A320:01CA0AFA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 22, 2009 2:10 AM, Ahmed Ammar wrote:
> From: Ahmed Ammar <aammar@edge-techno.com>
>
> Based on previous work by Thomas Gleixner.

Please add some sort of commit message.  And your Signed-off-by.

I still need to test this but have a couple initial comments.

> 
> ---
>  arch/arm/Kconfig                                |    3 +
>  arch/arm/mach-ep93xx/core.c                     |  129 ++++++++++++++++++-----
>  arch/arm/mach-ep93xx/include/mach/ep93xx-regs.h |    6 +
>  arch/arm/mach-ep93xx/include/mach/timex.h       |    6 +
>  4 files changed, 118 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 74713a5..90ffb1d 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -273,6 +273,8 @@ config ARCH_EP93XX
>  	select HAVE_CLK
>  	select COMMON_CLKDEV
>  	select ARCH_REQUIRE_GPIOLIB
> +	select GENERIC_TIME
> +	select GENERIC_CLOCKEVENTS
>  	help
>  	  This enables support for the Cirrus EP93xx series of CPUs.
>  
> @@ -849,6 +851,7 @@ config HZ
>  	default AT91_TIMER_HZ if ARCH_AT91
>  	default 100
>  
> +

Why this extra space?

>  config AEABI
>  	bool "Use the ARM EABI to compile the kernel"
>  	help
> diff --git a/arch/arm/mach-ep93xx/core.c b/arch/arm/mach-ep93xx/core.c
> index 7983a3b..3357df4 100644
> --- a/arch/arm/mach-ep93xx/core.c
> +++ b/arch/arm/mach-ep93xx/core.c
> @@ -33,6 +33,9 @@
>  #include <linux/termios.h>
>  #include <linux/amba/bus.h>
>  #include <linux/amba/serial.h>
> +#include <linux/clocksource.h>
> +#include <linux/clockchips.h>
> +

Unnecessary extra space.

>  #include <linux/io.h>
>  #include <linux/i2c.h>
>  #include <linux/i2c-gpio.h>
> @@ -100,55 +103,129 @@ void __init ep93xx_map_io(void)
>   * to use this timer for something else.  We also use timer 4 for keeping
>   * track of lost jiffies.
>   */

Is the comment blurb above this still valid?  Does it need any extra
information based on the clockevent support?

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
>  	return IRQ_HANDLED;
>  }
>  
> + 

Unnecessary extra space.

> +static int ep93xx_set_next_event(unsigned long evt,
> +				  struct clock_event_device *unused)

Whitespace issue here.  Maybe email related?

> +{
> +	u32 tmode = __raw_readl(EP93XX_TIMER1_CONTROL);
> +
> +	/* stop timer */
> +	__raw_writel(tmode & ~EP93XX_TC123_ENABLE, EP93XX_TIMER1_CONTROL);
> +	/* program timer */
> +	__raw_writel(evt, EP93XX_TIMER1_LOAD);
> +	/* start timer */
> +	__raw_writel(tmode | EP93XX_TC123_ENABLE, EP93XX_TIMER1_CONTROL);
> +
> +	return 0;
> +}
> +
> +static void ep93xx_set_mode(enum clock_event_mode mode,
> +			    struct clock_event_device *evt)
> +{
> +	u32 tmode = EP93XX_TC123_SEL_508KHZ;
> +	/* Disable timer */
> +	__raw_writel(tmode, EP93XX_TIMER1_CONTROL);
> +
> +	switch(mode) {
> +	case CLOCK_EVT_MODE_PERIODIC:
> +		/* Set timer period  */
> +		__raw_writel((508469 / HZ) - 1, EP93XX_TIMER1_LOAD);
> +		tmode |= EP93XX_TC123_PERIODIC;
> +
> +	case CLOCK_EVT_MODE_ONESHOT:
> +		tmode |= EP93XX_TC123_ENABLE;
> +		__raw_writel(tmode, EP93XX_TIMER1_CONTROL);
> +		break;
> +
> +	case CLOCK_EVT_MODE_SHUTDOWN:
> +	case CLOCK_EVT_MODE_UNUSED:
> +	case CLOCK_EVT_MODE_RESUME:
> +		return;
> +	}
> +}
> +
> +static struct clock_event_device clockevent_ep93xx = {
> +	.name		= "ep93xx-timer1",
> +	.features	= CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_PERIODIC,
> +	.shift		= 32,
> +	.set_mode	= ep93xx_set_mode,
> +	.set_next_event	= ep93xx_set_next_event,
> +};

With the clockevent support is it possible to add the other 2 timers?

> +
>  static struct irqaction ep93xx_timer_irq = {
>  	.name		= "ep93xx timer",
>  	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
>  	.handler	= ep93xx_timer_interrupt,
>  };
>  
> -static void __init ep93xx_timer_init(void)
> +static void __init ep93xx_clockevent_init(void)
>  {
> -	/* Enable periodic HZ timer.  */
> -	__raw_writel(0x48, EP93XX_TIMER1_CONTROL);
> -	__raw_writel((508469 / HZ) - 1, EP93XX_TIMER1_LOAD);
> -	__raw_writel(0xc8, EP93XX_TIMER1_CONTROL);
> +	setup_irq(IRQ_EP93XX_TIMER1, &ep93xx_timer_irq);
> +	clockevent_ep93xx.mult = div_sc(508469, NSEC_PER_SEC,
> +					clockevent_ep93xx.shift);
> +	clockevent_ep93xx.max_delta_ns =
> +		clockevent_delta2ns(0xfffffffe, &clockevent_ep93xx);
> +	clockevent_ep93xx.min_delta_ns =
> +		clockevent_delta2ns(0xf, &clockevent_ep93xx);
> +	clockevent_ep93xx.cpumask = cpumask_of(0);
> +	clockevents_register_device(&clockevent_ep93xx);
> +}
>  
> -	/* Enable lost jiffy timer.  */
> -	__raw_writel(0x100, EP93XX_TIMER4_VALUE_HIGH);
> +/*
> + * timer4 is a 40 Bit timer, separated in a 32bit and a 8 bit
> + * register, EP93XX_TIMER4_VALUE_LOW stores 32 bit word. The
> + * controlregister is in EP93XX_TIMER4_VALUE_HIGH
> + */
>  
> -	setup_irq(IRQ_EP93XX_TIMER1, &ep93xx_timer_irq);
> +cycle_t ep93xx_get_cycles(void)
> +{
> +	return __raw_readl(EP93XX_TIMER4_VALUE_LOW);
>  }
>  
> -static unsigned long ep93xx_gettimeoffset(void)
> +static struct clocksource clocksource_ep93xx = {
> +	.name		= "ep93xx_timer4",
> +	.rating		= 200,
> +	.read		= ep93xx_get_cycles,
> +	.mask		= 0xFFFFFFFF,
> +	.shift		= 20,
> +	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
> +};
> +
> +/*
> + * Returns current time from boot in nsecs. It's OK for this to wrap
> + * around for now, as it's just a relative time stamp.
> + */
> +unsigned long long sched_clock(void)
>  {
> -	int offset;
> +	return cyc2ns(&clocksource_ep93xx, ep93xx_get_cycles());
> +}
>  
> -	offset = __raw_readl(EP93XX_TIMER4_VALUE_LOW) - last_jiffy_time;
> +static void __init ep93xx_clocksource_init(void)
> +{
> +	/* Reset time-stamp counter */
> +	__raw_writel(0x100, EP93XX_TIMER4_VALUE_HIGH);
> +	clocksource_ep93xx.mult =
> +		clocksource_hz2mult(983040, clocksource_ep93xx.shift);
> +	clocksource_register(&clocksource_ep93xx);
> +}
>  
> -	/* Calculate (1000000 / 983040) * offset.  */
> -	return offset + (53 * offset / 3072);
> +static void __init ep93xx_timer_init(void)
> +{
> +	ep93xx_clocksource_init();
> +	ep93xx_clockevent_init();
>  }
>  
>  struct sys_timer ep93xx_timer = {
> -	.init		= ep93xx_timer_init,
> -	.offset		= ep93xx_gettimeoffset,
> + 	.init			= ep93xx_timer_init,

Please remove one of the tabs after .init.

>  };
>  
>  
> diff --git a/arch/arm/mach-ep93xx/include/mach/ep93xx-regs.h b/arch/arm/mach-ep93xx/include/mach/ep93xx-regs.h
> index 36c23fb..473cdec 100644
> --- a/arch/arm/mach-ep93xx/include/mach/ep93xx-regs.h
> +++ b/arch/arm/mach-ep93xx/include/mach/ep93xx-regs.h
> @@ -101,6 +101,12 @@
>  #define EP93XX_TIMER3_CONTROL		EP93XX_TIMER_REG(0x88)
>  #define EP93XX_TIMER3_CLEAR		EP93XX_TIMER_REG(0x8c)
>  
> +#define EP93XX_TC_CLEAR			0x00000001

This define is not needed.  Writing any value to the associated
register clears the interrupt generated by the time.  Just
change the line in core.c to write the value directly as was
previously done.

> +#define EP93XX_TC123_ENABLE		0x00000080
> +#define EP93XX_TC123_PERIODIC		0x00000040
> +#define EP93XX_TC123_SEL_508KHZ		0x00000008

I would prefer these defines be like the others in this file:

#define EP93XX_TIMER1_CONTROL		EP93XX_TIMER_REG(0x08)
+#define EP93XX_TIMER_CONTROL_ENABLE	(1<<7)
+#define EP93XX_TIMER_CONTROL_MODE	(1<<6)
+#define EP93XX_TIMER_CONTROL_CLKSEL	(1<<3)

> +#define EP93XX_TC4_ENABLE		0x00000100

And this one as:

#define EP93XX_TIMER4_VALUE_HIGH	EP93XX_TIMER_REG(0x64)
#define EP93XX_TIMER4_VALUE_HIGH_ENABLE	(1<<8)

> +
>  #define EP93XX_I2S_BASE			(EP93XX_APB_VIRT_BASE + 0x00020000)
>  
>  #define EP93XX_SECURITY_BASE		(EP93XX_APB_VIRT_BASE + 0x00030000)
> diff --git a/arch/arm/mach-ep93xx/include/mach/timex.h b/arch/arm/mach-ep93xx/include/mach/timex.h
> index 6b3503b..ddf3a8a 100644
> --- a/arch/arm/mach-ep93xx/include/mach/timex.h
> +++ b/arch/arm/mach-ep93xx/include/mach/timex.h
> @@ -1,5 +1,11 @@
>  /*
>   * arch/arm/mach-ep93xx/include/mach/timex.h
>   */
> +#include <mach/ep93xx-regs.h>

<mach/hardware.h> please

> +#include <asm/io.h>

Should be <linux/io.h> and moved before the <mach/*> include.

>  
>  #define CLOCK_TICK_RATE		983040
> +
> +#define mach_read_cycles() __raw_readl(EP93XX_TIMER4_VALUE_LOW)
> +#define mach_cycles_to_usecs(d) (((d) * ((1000000LL << 32) / CLOCK_TICK_RATE)) >> 32)
> +#define mach_usecs_to_cycles(d) (((d) * (((long long)CLOCK_TICK_RATE << 32) / 1000000)) >> 32)

Please reformat these lines to be < 80 characters.  Maybe like:

+ #define mach_read_cycles()	__raw_readl(EP93XX_TIMER4_VALUE_LOW)
+ 
+ #define mach_cycles_to_usecs(d)					\
+ 	(((d) * ((1000000LL << 32) / CLOCK_TICK_RATE)) >> 32)
+ #define mach_usecs_to_cycles(d)					\
+ 	(((d) * (((long long)CLOCK_TICK_RATE << 32) / 1000000)) >> 32)


What's the advantage of adding clockevent support?  I'm not familiar
with this yet.

Thanks,
Hartley
