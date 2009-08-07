Return-Path: <linux-kernel-owner+w=401wt.eu-S1757470AbZHGKsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470AbZHGKsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 06:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757439AbZHGKsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 06:48:16 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:61243 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757273AbZHGKsP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 06:48:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Kabi+NI6btIHnVgGRoDj1R/lB7S8Re+rf7d4bTutxLaZ4UhvL9bXbFW8uQ4qqsIM65
         5gKq5QdKUfEuGAPaKnNLzP28wChRMWEFT1JLL22rxfXMFnTpmqet6h2k3qslQn1LPiSY
         Fm3LHrm4ZEKh0ItVRDTIl7KOSjyowhd9ltde8=
MIME-Version: 1.0
In-Reply-To: <4A792AC5.3040105@gmail.com>
References: <4A77BA45.5050208@gmail.com>
	 <20090804080658.GC610@n2100.arm.linux.org.uk>
	 <e68bb3470908040132qc9a831dq8ef0b3ab4b4f4856@mail.gmail.com>
	 <20090804090119.GA2452@n2100.arm.linux.org.uk>
	 <4A792AC5.3040105@gmail.com>
Date: Fri, 7 Aug 2009 18:48:15 +0800
Message-ID: <e68bb3470908070348g63560bf4o35e51ce7544b3cc3@mail.gmail.com>
Subject: Re: [PATCH] Add generic clock events support for w90p910 timer
From: Wan ZongShun <mcuos.com@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Russell,

When involving  the clocksource function by means of timer1, I find my
system running seems to be slow,
and the printed console information shown slowly too.

Regarding timer1 setting, I only set the counter enable bit, periodic
mode bit and fill in the timer initial count register, which is a
24bit register, I think it can work ok.

Any else setting missed regarding  linux api of clocksource ?

2009/8/5 Wan ZongShun <mcuos.com@gmail.com>:
> Dear sirs,
>
> I fixed this patch according to Russell's advice, and added
> time1 for clocksource.
>
> Either setting 'LOCK_EVT_MODE_PERIODIC' or setting 'CLOCK_EVT_FEAT_ONESHOT' can
> run in my w90p910 evaluation board. but, if I set 'future' to following:
>
> ".features      = CLOCK_EVT_MODE_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,"
>
> If so, the timer works on the periodic mode.
>
>
> Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
>
> ---
>  arch/arm/Kconfig                |    2 +
>  arch/arm/mach-w90x900/clock.c   |    6 ++
>  arch/arm/mach-w90x900/time.c    |  151 ++++++++++++++++++++++++++++++++------
>  arch/arm/mach-w90x900/w90p910.c |    2 +
>  4 files changed, 137 insertions(+), 24 deletions(-)
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index c3fed1e..8c4f03d 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -495,6 +495,8 @@ config ARCH_W90X900
>        select GENERIC_GPIO
>        select HAVE_CLK
>        select COMMON_CLKDEV
> +       select GENERIC_TIME
> +       select GENERIC_CLOCKEVENTS
>        help
>                Support for Nuvoton (Winbond logic dept.) ARM9 processor,You
>                can login www.mcuos.com or www.nuvoton.com to know more.
> diff --git a/arch/arm/mach-w90x900/clock.c b/arch/arm/mach-w90x900/clock.c
> index 49cf1fb..70b6710 100644
> --- a/arch/arm/mach-w90x900/clock.c
> +++ b/arch/arm/mach-w90x900/clock.c
> @@ -55,6 +55,12 @@ void clk_disable(struct clk *clk)
>  }
>  EXPORT_SYMBOL(clk_disable);
>
> +unsigned long clk_get_rate(struct clk *clk)
> +{
> +       return 15000000;
> +}
> +EXPORT_SYMBOL(clk_get_rate);
> +
>  void w90x900_clk_enable(struct clk *clk, int enable)
>  {
>        unsigned int clocks = clk->cken;
> diff --git a/arch/arm/mach-w90x900/time.c b/arch/arm/mach-w90x900/time.c
> index bcc838f..5e06770 100644
> --- a/arch/arm/mach-w90x900/time.c
> +++ b/arch/arm/mach-w90x900/time.c
> @@ -3,7 +3,7 @@
>  *
>  * Based on linux/arch/arm/plat-s3c24xx/time.c by Ben Dooks
>  *
> - * Copyright (c) 2008 Nuvoton technology corporation
> + * Copyright (c) 2009 Nuvoton technology corporation
>  * All rights reserved.
>  *
>  * Wan ZongShun <mcuos.com@gmail.com>
> @@ -23,6 +23,8 @@
>  #include <linux/clk.h>
>  #include <linux/io.h>
>  #include <linux/leds.h>
> +#include <linux/clocksource.h>
> +#include <linux/clockchips.h>
>
>  #include <asm/mach-types.h>
>  #include <asm/mach/irq.h>
> @@ -31,49 +33,150 @@
>  #include <mach/map.h>
>  #include <mach/regs-timer.h>
>
> -static unsigned long w90x900_gettimeoffset(void)
> +#define RESETINT       0x1f
> +#define PERIOD         (0x01 << 27)
> +#define ONESHOT                (0x00 << 27)
> +#define COUNTEN                (0x01 << 30)
> +#define INTEN          (0x01 << 29)
> +
> +#define TICKS_PER_SEC  100
> +#define PRESCALE       0x63 /* Divider = prescale + 1 */
> +
> +unsigned int timer0_load;
> +
> +static void w90p910_clockevent_setmode(enum clock_event_mode mode,
> +               struct clock_event_device *clk)
>  {
> +       unsigned int val;
> +
> +       val = __raw_readl(REG_TCSR0);
> +       val &= ~(0x03 << 27);
> +
> +       switch (mode) {
> +       case CLOCK_EVT_MODE_PERIODIC:
> +               __raw_writel(timer0_load, REG_TICR0);
> +               val |= (PERIOD | COUNTEN | INTEN | PRESCALE);
> +               break;
> +
> +       case CLOCK_EVT_MODE_ONESHOT:
> +               val |= (ONESHOT | COUNTEN | INTEN | PRESCALE);
> +               break;
> +
> +       case CLOCK_EVT_MODE_UNUSED:
> +       case CLOCK_EVT_MODE_SHUTDOWN:
> +       case CLOCK_EVT_MODE_RESUME:
> +               break;
> +       }
> +
> +       __raw_writel(val, REG_TCSR0);
> +}
> +
> +static int w90p910_clockevent_setnextevent(unsigned long evt,
> +               struct clock_event_device *clk)
> +{
> +       unsigned int val;
> +
> +       __raw_writel(evt, REG_TICR0);
> +
> +       val = __raw_readl(REG_TCSR0);
> +       val |= (COUNTEN | INTEN | PRESCALE);
> +       __raw_writel(val, REG_TCSR0);
> +
>        return 0;
>  }
>
> +static struct clock_event_device w90p910_clockevent_device = {
> +       .name           = "w90p910-timer0",
> +       .shift          = 32,
> +       .features       = CLOCK_EVT_MODE_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
> +       .set_mode       = w90p910_clockevent_setmode,
> +       .set_next_event = w90p910_clockevent_setnextevent,
> +       .rating         = 300,
> +};
> +
>  /*IRQ handler for the timer*/
>
> -static irqreturn_t
> -w90x900_timer_interrupt(int irq, void *dev_id)
> +static irqreturn_t w90p910_timer0_interrupt(int irq, void *dev_id)
>  {
> -       timer_tick();
> +       struct clock_event_device *evt = &w90p910_clockevent_device;
> +
>        __raw_writel(0x01, REG_TISR); /* clear TIF0 */
> +
> +       evt->event_handler(evt);
>        return IRQ_HANDLED;
>  }
>
> -static struct irqaction w90x900_timer_irq = {
> -       .name           = "w90x900 Timer Tick",
> +static struct irqaction w90p910_timer0_irq = {
> +       .name           = "w90p910-timer0",
>        .flags          = IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
> -       .handler        = w90x900_timer_interrupt,
> +       .handler        = w90p910_timer0_interrupt,
>  };
>
> -/*Set up timer reg.*/
> +static void __init w90p910_clockevents_init(unsigned int rate)
> +{
> +       w90p910_clockevent_device.mult = div_sc(rate, NSEC_PER_SEC,
> +                                       w90p910_clockevent_device.shift);
> +       w90p910_clockevent_device.max_delta_ns = clockevent_delta2ns(0xffffffff,
> +                                       &w90p910_clockevent_device);
> +       w90p910_clockevent_device.min_delta_ns = clockevent_delta2ns(0xf,
> +                                       &w90p910_clockevent_device);
> +       w90p910_clockevent_device.cpumask = cpumask_of(0);
>
> -static void w90x900_timer_setup(void)
> +       clockevents_register_device(&w90p910_clockevent_device);
> +}
> +
> +static cycle_t w90p910_get_cycles(struct clocksource *cs)
>  {
> -       __raw_writel(0, REG_TCSR0);
> -       __raw_writel(0, REG_TCSR1);
> -       __raw_writel(0, REG_TCSR2);
> -       __raw_writel(0, REG_TCSR3);
> -       __raw_writel(0, REG_TCSR4);
> -       __raw_writel(0x1F, REG_TISR);
> -       __raw_writel(15000000/(100 * 100), REG_TICR0);
> -       __raw_writel(0x68000063, REG_TCSR0);
> +       return ~__raw_readl(REG_TDR1);
>  }
>
> -static void __init w90x900_timer_init(void)
> +static struct clocksource clocksource_w90p910 = {
> +       .name   = "w90p910-timer1",
> +       .rating = 200,
> +       .read   = w90p910_get_cycles,
> +       .mask   = CLOCKSOURCE_MASK(32),
> +       .shift  = 20,
> +       .flags  = CLOCK_SOURCE_IS_CONTINUOUS,
> +};
> +
> +static void __init w90p910_clocksource_init(unsigned int rate)
>  {
> -       w90x900_timer_setup();
> -       setup_irq(IRQ_TIMER0, &w90x900_timer_irq);
> +       unsigned int val;
> +
> +       __raw_writel(0xffffffff, REG_TICR1);
> +
> +       val = __raw_readl(REG_TCSR1);
> +       val |= (COUNTEN | PERIOD);
> +       __raw_writel(val, REG_TCSR1);
> +
> +       clocksource_w90p910.mult =
> +               clocksource_khz2mult((rate / 1000), clocksource_w90p910.shift);
> +       clocksource_register(&clocksource_w90p910);
> +}
> +
> +static void __init w90p910_timer_init(void)
> +{
> +       struct clk *ck_ext = clk_get(NULL, "ext");
> +       unsigned int    rate;
> +
> +       BUG_ON(IS_ERR(ck_ext));
> +
> +       rate = clk_get_rate(ck_ext);
> +       clk_put(ck_ext);
> +       rate = rate / (PRESCALE + 0x01);
> +
> +        /* set a known state */
> +       __raw_writel(0x00, REG_TCSR0);
> +       __raw_writel(0x00, REG_TCSR1);
> +       __raw_writel(RESETINT, REG_TISR);
> +       timer0_load = (rate / TICKS_PER_SEC);
> +
> +       setup_irq(IRQ_TIMER0, &w90p910_timer0_irq);
> +
> +       w90p910_clocksource_init(rate);
> +       w90p910_clockevents_init(rate);
>  }
>
>  struct sys_timer w90x900_timer = {
> -       .init           = w90x900_timer_init,
> -       .offset         = w90x900_gettimeoffset,
> -       .resume         = w90x900_timer_setup
> +       .init           = w90p910_timer_init,
>  };
> diff --git a/arch/arm/mach-w90x900/w90p910.c b/arch/arm/mach-w90x900/w90p910.c
> index 8444eab..d33723b 100644
> --- a/arch/arm/mach-w90x900/w90p910.c
> +++ b/arch/arm/mach-w90x900/w90p910.c
> @@ -76,6 +76,7 @@ static DEFINE_CLK(wdt, 26);
>  static DEFINE_CLK(gdma, 27);
>  static DEFINE_CLK(adc, 28);
>  static DEFINE_CLK(usi, 29);
> +static DEFINE_CLK(ext, 0);
>
>  static struct clk_lookup w90p910_clkregs[] = {
>        DEF_CLKLOOK(&clk_lcd, "w90p910-lcd", NULL),
> @@ -97,6 +98,7 @@ static struct clk_lookup w90p910_clkregs[] = {
>        DEF_CLKLOOK(&clk_gdma, "w90p910-gdma", NULL),
>        DEF_CLKLOOK(&clk_adc, "w90p910-adc", NULL),
>        DEF_CLKLOOK(&clk_usi, "w90p910-spi", NULL),
> +       DEF_CLKLOOK(&clk_ext, NULL, "ext"),
>  };
>
>  /* Initial serial platform data */
> --
> 1.5.6.3
>



-- 
Wan z.s
