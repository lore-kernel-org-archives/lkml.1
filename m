Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab0CKLWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 06:22:11 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:33149 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757519Ab0CKLWI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 06:22:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qGuyPRE3kxir4zWsOA6Z9+YoMnUbdlKaRpq2Y2ejvcpU8goRV+7ll4lHZPX0wZz6Nj
         elhgV0K7O7NpVMTh+bgpSB6mjPAFh61OHXUVY7PiZKuoNFAGP1QgewzJpkycFIWycxrs
         dDczpIqxyvI3A1kT+fZIpp2De2Pa6m5qkneXI=
MIME-Version: 1.0
In-Reply-To: <1267592861-26911-7-git-send-email-viresh.kumar@st.com>
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-2-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-3-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-4-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-5-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-6-git-send-email-viresh.kumar@st.com>
	 <1267592861-26911-7-git-send-email-viresh.kumar@st.com>
Date: Thu, 11 Mar 2010 12:22:05 +0100
Message-ID: <63386a3d1003110322s475546f7ge8f136961382cce4@mail.gmail.com>
Subject: Re: [PATCH 06/11] ST SPEAr: Added source files for SPEAr platform
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Viresh KUMAR <viresh.kumar@st.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       armando.visconti@st.com, amit.goel@st.com, shiraz.hashim@st.com,
       vipin.kumar@st.com, rajeev-dlh.kumar@st.com, deepak.sikri@st.com,
       ashish.priyadarshi@st.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

I'm working my way through the patch set, be patient :)

2010/3/3 Viresh KUMAR <viresh.kumar@st.com>:
> (...)
> diff --git a/arch/arm/plat-spear/gpt.c b/arch/arm/plat-spear/gpt.c
> new file mode 100644
> index 0000000..3b16360
> --- /dev/null
> +++ b/arch/arm/plat-spear/gpt.c
> @@ -0,0 +1,537 @@
> +/*
> + * arch/arm/plat-spear/gpt.c

As mentioned I prefer that you merge this file into the timer.c file
and remove the extra .h interface totally. Also of course refactor to
take into account that it's one file only.

> + *
> + * ST GPT Timer driver, based on omap's dmtimer.c
> + *
> + * Copyright (C) 2009 ST Microelectronics
> + * Shiraz Hashim<shiraz.hashim@st.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/errno.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/spinlock.h>
> +#include <mach/irqs.h>
> +#include <mach/spear.h>
> +#include <plat/gpt.h>
> +
> +static const char *src_clk_con_id[] __initdata = {
> +       "pll3_48m_clk",
> +       "pll1_clk",
> +       NULL
> +};
> +
> +static struct clk *spear_source_clocks[2];
> +static struct spear_timer *spear_timers;
> +static int spear_timer_count;
> +static spinlock_t spear_timer_lock;
> +
> +/*
> + * static helper functions
> + */
> +static inline u16 spear_timer_read_reg(struct spear_timer *timer, u32 reg)
> +{
> +       return readw(timer->io_base + (reg & 0xff));
> +}
> +
> +static inline void spear_timer_write_reg(struct spear_timer *timer, u32 reg,
> +                                               u16 value)
> +{
> +       writew(value, timer->io_base + (reg & 0xff));
> +}

I usually just have raw writew() and skip all this extra abstraction in
my code, but it's a matter of taste so if you like it, keep it.

> +
> +static void spear_timer_reset(struct spear_timer *timer)
> +{
> +
> +       spear_timer_write_reg(timer, GPT_CTRL_OFF, 0x0);
> +       spear_timer_write_reg(timer, GPT_LOAD_OFF, 0x0);
> +       spear_timer_write_reg(timer, GPT_INT_OFF, GPT_STATUS_MATCH);
> +       timer->prescaler = 0;
> +}
> +
> +static void spear_timer_prepare(struct spear_timer *timer)
> +{
> +       spear_timer_enable(timer);
> +       spear_timer_reset(timer);
> +}
> +
> +/* functions exported for application */
> +
> +/**
> + * spear_timer_enable - enable a timer
> + * @timer: timer
> + *
> + * This API enables the functional clock of the timer
> + */
> +int spear_timer_enable(struct spear_timer *timer)
> +{
> +       if (!timer)
> +               return -ENODEV;
> +
> +       if (timer->enabled)
> +               return -EINVAL;
> +
> +       clk_enable(timer->fclk);
> +
> +       timer->enabled = 1;
> +
> +       return 0;
> +}
> +
> +/**
> + * spear_timer_disable - disables timer
> + * @timer: timer
> + *
> + * The API disables the functional clock of the timer
> + */
> +int spear_timer_disable(struct spear_timer *timer)
> +{
> +       if (!timer)
> +               return -ENODEV;
> +
> +       if (!timer->enabled)
> +               return -EINVAL;
> +
> +       clk_disable(timer->fclk);
> +
> +       timer->enabled = 0;
> +
> +       return 0;
> +}
> +
> +/**
> + * spear_timer_request - request for a timer
> + *
> + * This API returns a timer which is available, returns NULL if none is
> + * available
> + */
> +struct spear_timer *spear_timer_request(void)
> +{
> +       struct spear_timer *timer = NULL;
> +       unsigned long flags;
> +       int i;
> +
> +       spin_lock_irqsave(&spear_timer_lock, flags);
> +
> +       for (i = 0; i < spear_timer_count; i++) {
> +               if (spear_timers[i].reserved)
> +                       continue;
> +
> +               timer = &spear_timers[i];
> +               timer->reserved = 1;

I forgot to mention that if .reserved can only have the values 0 and 1,
the chances are big that you should turn that member of struct spear_timer
into a bool instead and use false/true as values.

> +               break;
> +       }
> +
> +       spin_unlock_irqrestore(&spear_timer_lock, flags);
> +
> +       if (timer != NULL)
> +               spear_timer_prepare(timer);
> +
> +       return timer;
> +}
> +EXPORT_SYMBOL(spear_timer_request);
> +
> +/**
> + * spear_timer_request_specific - request for a specific timer
> + * @id: timer id requested, 1 onwards
> + *
> + * This API returns specific timer which is requested, returns NULL if it is
> + * not available.
> + */
> +struct spear_timer *spear_timer_request_specific(int id)

I don't see the need for this functions. Are not all timers the same?
If the timers are hardwired for specific purposes, as in they have some
extra hardware routing of their output,, this should rather
show up in the API. Again I think moving this into timer.c will solve
the problem.

> +{
> +       struct spear_timer *timer;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&spear_timer_lock, flags);
> +
> +       if (id < 0 || id >= spear_timer_count ||
> +                       spear_timers[id].reserved) {
> +               spin_unlock_irqrestore(&spear_timer_lock, flags);
> +               printk(KERN_ERR "BUG: unable to get timer %d\n", id);
> +               dump_stack();

Is this really a bug...? You can easily see that say timer 2 can have been
taken by the generic spear_timer_request() function. In that case, the raise
of a BUG message is subject to calling order and implicit semantics, e.g.
you require that all clients that require a certain timer issue their
spear_timer_request_specific() before any calls to spear_request_timer()
is issued. That's getting messy, at least it needs to documented.

Again merging into timer.c will solve this (it will just go away).

> +               return NULL;
> +       }
> +
> +       timer = &spear_timers[id];
> +       timer->reserved = 1;
> +       spin_unlock_irqrestore(&spear_timer_lock, flags);
> +
> +       spear_timer_prepare(timer);
> +
> +       return timer;
> +}
> +EXPORT_SYMBOL(spear_timer_request_specific);
> +
> +/**
> + * spear_timer_free - free the timer
> + * @timer: timer which should be freed
> + *
> + * Applications should free the timer when not in use. The API also resets and
> + * disables the timer clock
> + */
> +int spear_timer_free(struct spear_timer *timer)
> +{
> +       if (!timer)
> +               return -ENODEV;
> +
> +       WARN_ON(!timer->reserved);

This is a bug. If spear_request_timer[_specific]() and
spear_timer_free() are supposed to be called in pairs
this warning message will always be printed.

Or are you suggesting that clients should never ever
release their clocks?

> +
> +       spear_timer_reset(timer);
> +       spear_timer_disable(timer);
> +
> +       timer->reserved = 0;
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(spear_timer_free);
> +
> +/**
> + * spear_timer_get_irq - get the irq number associated
> + * @timer: return the irq number for this timer
> + *
> + * The application may require the irq associated with a timer to register it
> + * with the OS interrupt framework.
> + */
> +int spear_timer_get_irq(struct spear_timer *timer)
> +{
> +       return (timer) ? timer->irq : -ENODEV;
> +}
> +EXPORT_SYMBOL(spear_timer_get_irq);

This is messy IMHO. If you really want to route interrupts from the
timers away from the actual timer driver (which *should* be in this
file only!) you need to register a new struct irq_chip for the timer
array and register a callback along with the
spear_request_timer[_specific]() function.

If you look for the uses of struct irq_chip in the kernel you can find
a lot of this hierarchical irq_chip:s, notice that they are used as abstract
entities, an irq_chip does NOT have to map 1-to-1 to e.g. a PL190
VIC, they can be subrouters.

> +
> +/**
> + * spear_timer_get_fclk - return the functional clock
> + * @timer: timer for which fclk is required
> + *
> + * Returns the functional clock of the timer at which it is operating.
> + * Functional clock represents the actual clock at which the timer is
> + * operating. The count period depends on this clock
> + */
> +struct clk *spear_timer_get_fclk(struct spear_timer *timer)
> +{
> +       if (!timer)
> +               return NULL;
> +
> +       return timer->fclk;
> +}
> +EXPORT_SYMBOL(spear_timer_get_fclk);
> +
> +/**
> + * spear_timer_start - start the timer operation
> + * @timer: timer to start
> + *
> + * The timer shall start operating only after calling this API
> + */
> +int spear_timer_start(struct spear_timer *timer)
> +{
> +       u16 val;
> +
> +       if (!timer)
> +               return -ENODEV;
> +
> +       val = spear_timer_read_reg(timer, GPT_CTRL_OFF);
> +       if (!(val & GPT_CTRL_ENABLE)) {
> +               val |= GPT_CTRL_ENABLE;
> +               spear_timer_write_reg(timer, GPT_CTRL_OFF, val);
> +       }
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(spear_timer_start);
> +
> +/**
> + * spear_timer_stop - stop the timer operation
> + * @timer: timer to stop
> + *
> + * This API can be used to stop the timer operation
> + */
> +int spear_timer_stop(struct spear_timer *timer)
> +{
> +       u16 val;
> +
> +       if (!timer)
> +               return -ENODEV;
> +
> +       val = spear_timer_read_reg(timer, GPT_CTRL_OFF);
> +       if (val & GPT_CTRL_ENABLE) {
> +               val &= ~GPT_CTRL_ENABLE;
> +               spear_timer_write_reg(timer, GPT_CTRL_OFF, val);
> +       }
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(spear_timer_stop);
> +
> +/**
> + * spear_timer_set_source - select the proper source clock
> + * @timer: timer
> + * @source: the clock cource
> + *
> + * source specifies the clock which has to be selected as the functional clock
> + * of timer. The available choice are 48 MHz (PLL3) output or AHB clock.
> + *
> + */
> +int spear_timer_set_source(struct spear_timer *timer, int source)
> +{
> +       if (source < 0 || source >= 3)
> +               return -EINVAL;
> +
> +       if (!timer)
> +               return -ENODEV;
> +
> +       clk_disable(timer->fclk);
> +       clk_set_parent(timer->fclk, spear_source_clocks[source]);
> +       clk_enable(timer->fclk);
> +       return 0;
> +}
> +EXPORT_SYMBOL(spear_timer_set_source);

So depending on what you want each timer can be clocked at two different
frequencies. This is actually an argument *against* merging it into the timer.c
file, because the run frequency of clock event drivers are expected to be
fixed and static. But again, this depends on whether you use it or not.

When you use it as clocksource / clock event, you should just set it
to the highest possible frequency. However when power management
comes into the picture, this becomes a more complicated question.

So, are lower frequencies really used for anything?

> +
> +/**
> + * spear_timer_set_load - program the count value of timer
> + * @timer: timer
> + * @autoreload: boolean, whether the count will be reloaded
> + * @load: the actual count deciding the time period

Append a comment satting that the value to reload will depend on
the frequency of the parent PLL, because it does, right?

> + *
> + * The timer will be programmed as per the value in load. The time period will
> + * depend on the clock and prescaler selected.
> + */
> +int spear_timer_set_load(struct spear_timer *timer, int autoreload,
> +               u16 load)
> +{
> +       u16 val;
> +
> +       if (!timer)
> +               return -ENODEV;
> +
> +       val = spear_timer_read_reg(timer, GPT_CTRL_OFF);
> +       if (autoreload)
> +               val &= ~GPT_CTRL_MODE_AR;
> +       else
> +               val |= GPT_CTRL_MODE_AR;
> +
> +       spear_timer_write_reg(timer, GPT_LOAD_OFF, load);
> +       spear_timer_write_reg(timer, GPT_CTRL_OFF, val);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(spear_timer_set_load);
> +
> +/**
> + * spear_timer_set_load_start - program the count value of timer and start
> + * @timer: timer
> + * @autoreload: boolean, whether the count will be reloaded
> + * @load: the actual count deciding the time period
> + *
> + * The timer will be programmed as per the value in load and the operation will
> + * be started.
> + */
> +int spear_timer_set_load_start(struct spear_timer *timer, int autoreload,
> +               u16 load)
> +{
> +       u16 val;
> +
> +       if (!timer)
> +               return -ENODEV;
> +
> +       val = spear_timer_read_reg(timer, GPT_CTRL_OFF);
> +       if (autoreload)
> +               val &= ~GPT_CTRL_MODE_AR;
> +       else
> +               val |= GPT_CTRL_MODE_AR;
> +
> +       val |= GPT_CTRL_ENABLE;
> +
> +       spear_timer_write_reg(timer, GPT_LOAD_OFF, load);
> +       spear_timer_write_reg(timer, GPT_CTRL_OFF, val);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(spear_timer_set_load_start);

If you merge this into timer.c it becomes obvious that autoreload will
be used for the MODE_PERIODIC and non-autoreload for the oneshot
timer, and the abstraction goes away, so the timer driver will be a lot
simpler to read.

> +
> +/**
> + * spear_timer_match_irq - enable the match interrupt
> + * @timer: timer
> + * @enable: boolean, 1 for enable
> + *
> + * If application wants to enable the interrupt on count match then this API
> + * should be called
> + */
> +int spear_timer_match_irq(struct spear_timer *timer, int enable)
> +{
> +       u16 val;
> +
> +       if (!timer)
> +               return -ENODEV;
> +
> +       val = spear_timer_read_reg(timer, GPT_CTRL_OFF);
> +       if (enable)
> +               val |= GPT_CTRL_MATCH_INT;
> +       else
> +               val &= ~GPT_CTRL_MATCH_INT;
> +       spear_timer_write_reg(timer, GPT_CTRL_OFF, val);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(spear_timer_match_irq);

Again, use an abstract struct irq_chip instead and you won't need all
these kludges.

> +
> +/**
> + * spear_timer_set_prescaler - set the prescaler for the timer
> + * @timer: timer
> + * @prescaler: the division factor to be applied on the src clk
> + *
> + * This API can be used to program the prescaler for the timer. Its value can
> + * be from 1 to 8 signifying division by 2^prescaler
> + */
> +int spear_timer_set_prescaler(struct spear_timer *timer, int prescaler)
> +{
> +       u16 val;
> +
> +       if (!timer)
> +               return -ENODEV;
> +
> +       val = spear_timer_read_reg(timer, GPT_CTRL_OFF);
> +       if (prescaler >= 0x00 && prescaler <= 0x08) {
> +               val &= 0xFFF0;
> +               val |= prescaler;
> +       } else {
> +               printk(KERN_ERR "Invalid prescaler\n");
> +       }
> +
> +       timer->prescaler = val & 0xF;
> +       spear_timer_write_reg(timer, GPT_CTRL_OFF, val);
> +       return 0;
> +}
> +EXPORT_SYMBOL(spear_timer_set_prescaler);

Same comment here as for set_source().

> +
> +/**
> + * spear_timer_read_status - read the interrupt status
> + * @timer: timer
> + *
> + * This API can be used to read the interrupt status of timer. Currently only
> + * match interrupt, at offset 0, is part of this.
> + */
> +int spear_timer_read_status(struct spear_timer *timer)
> +{
> +       u16 val;
> +
> +       if (!timer)
> +               return -ENODEV;
> +
> +       val = spear_timer_read_reg(timer, GPT_INT_OFF);
> +
> +       return val;
> +}
> +EXPORT_SYMBOL(spear_timer_read_status);

Goes away with struct irq_chip again.

> +
> +/**
> + * spear_timer_clear_status - write to the interrupt status reg to clear
> + * @timer: timer
> + * @value: value to be written
> + *
> + * The API can be used to clear the match interrupt status by writing a value
> + * 0.
> + */
> +int spear_timer_clear_status(struct spear_timer *timer, u16 value)
> +{
> +       if (!timer)
> +               return -ENODEV;
> +
> +       spear_timer_write_reg(timer, GPT_INT_OFF, value);
> +       return 0;
> +}
> +EXPORT_SYMBOL(spear_timer_clear_status);

Goes away with struct irq_chip again.

> +
> +/**
> + * spear_timer_read_counter - get the current count value
> + * @timer: timer
> + *
> + * The API returns the current count value of the timer. One has to remember
> + * that if the timer is operating on asynchronous clock source then there is a
> + * probability that the application may get some junk count value. This is due
> + * to the fact that the count register is being accessed by two independent
> + * clock, one driving the timer (48MHz) and the other on which this register is
> + * read (system AHB clock). For more details refer GPT Application note.
> + */
> +int spear_timer_read_counter(struct spear_timer *timer)
> +{
> +       u16 val;
> +
> +       if (!timer)
> +               return -ENODEV;
> +
> +       val = spear_timer_read_reg(timer, GPT_COUNT_OFF);
> +
> +       return val;
> +}
> +EXPORT_SYMBOL(spear_timer_read_counter);

Used for the clocksource right? No other in-kernel user would be interested
in this function. If you fold the driver into timer.c it goes away
naturally, the
driver for the clocksource just read and use this register.

> +
> +/**
> + * spear_timer_active - is timer active
> + * @timer: timer
> + *
> + * This API can be used to find whether a timer is already enabled and is
> + * active i.e. it is under operation
> + */
> +int spear_timer_active(struct spear_timer *timer)
> +{
> +       if (!timer)
> +               return 0;

return -EINVAL, no?

> +
> +       if (!timer->enabled)
> +               return 0;
> +
> +       if (spear_timer_read_reg(timer, GPT_CTRL_OFF) & GPT_CTRL_ENABLE)
> +               return 1;

These two if:s are counterintuitive, can't you just remove the .enabled field
in the struct spear_timer and *only* rely on the GPT_CTRL_ENABLE bit in the
GPT_CTRL register? This way there are two bits that are supposed to be either
both 00 or both 11 and any 10 or 01 is a BUG() really. The only reason of
having a shadow variable is if it takes a long time to read the register, which
appears to not be the case.

> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(spear_timer_active);
> +
> +/**
> + * spear_timer_init - initialize the set of timers
> + * @timer: list of timers to be intialized
> + * @count: number of timers supported in platform
> + *
> + * This API must not be called by user and it is called only once by the
> + * platform specific intialization code.
> + */
> +int __init spear_timer_init(struct spear_timer *timers, int count)
> +{
> +       struct spear_timer *timer;
> +       int i;
> +       int mtu; /* timer unit */
> +       char dev_id[16];
> +
> +       spin_lock_init(&spear_timer_lock);
> +
> +       spear_timers = timers;
> +       spear_timer_count = count;
> +
> +       for (i = 0; src_clk_con_id[i] != NULL; i++)
> +               spear_source_clocks[i] = clk_get(NULL, src_clk_con_id[i]);
> +
> +       for (i = 0; i < spear_timer_count; i++) {
> +               timer = &spear_timers[i];

Here, before ioremap you should
request_mem_region(timer->phys_base, timer->phys_base + SZ_1K - 1);
Make sure that call doesn't return NULL.

> +               timer->io_base = (void __iomem *)ioremap(timer->phys_base,
> +                               SZ_1K);
> +               if (!timer->io_base) {
> +                       printk(KERN_ERR "BUG:ioremap failed for timer:%d\n", i);
> +                       continue;

Um... Make a proper error path. What about goto err_ioremap; ?

> +               }
> +
> +               /* each mtu has 2 timers with same set of clocks */
> +               mtu = i >> 1;
> +
> +               sprintf(dev_id, "gpt%d", mtu);
> +               timer->fclk = clk_get_sys(dev_id, NULL);
> +       }
> +
> +       return 0;
> +}
> diff --git a/arch/arm/plat-spear/time.c b/arch/arm/plat-spear/time.c
> new file mode 100644
> index 0000000..d89ac17
> --- /dev/null
> +++ b/arch/arm/plat-spear/time.c
> @@ -0,0 +1,197 @@
> +/*
> + * arch/arm/plat-spear/time.c
> + *
> + * Copyright (C) 2009 ST Microelectronics
> + * Shiraz Hashim<shiraz.hashim@st.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/clockchips.h>
> +#include <linux/clocksource.h>
> +#include <linux/err.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/time.h>
> +#include <linux/irq.h>
> +#include <asm/mach/time.h>
> +#include <mach/irqs.h>
> +#include <mach/hardware.h>
> +#include <mach/spear.h>
> +#include <mach/generic.h>
> +#include <plat/gpt.h>
> +
> +static void clockevent_set_mode(enum clock_event_mode mode,
> +                               struct clock_event_device *clk_event_dev);
> +static int clockevent_next_event(unsigned long evt,
> +                                struct clock_event_device *clk_event_dev);
> +
> +/*
> + * Timer0 and Timer1 both belong to same mtu in cpu subbsystem. Further they
> + * share same functional clock. Any change in one's functional clock will also
> + * affect other timer.
> + */
> +static struct spear_timer *spear_timer_clkevt;
> +static struct spear_timer *spear_timer_clksrc;
> +
> +/*
> + * Clock Source
> + */
> +static cycle_t clocksource_read_cycles(struct clocksource *cs)
> +{
> +       return (cycle_t) spear_timer_read_counter(spear_timer_clksrc);
> +}
> +
> +static struct clocksource clksrc = {
> +       .name = "clock source",
> +       .rating = 200,          /* its a pretty decent clock */
> +       .read = clocksource_read_cycles,
> +       .mask = 0xFFFF,         /* 16 bits */
> +       .mult = 0,              /* to be computed */
> +       .shift = 10,

How is this number (10) decided? I ask because many people just
copy something from some other platform. One algorithm you could consider
is the clocksource_calc_mult_shift() function.

> +       .flags = CLOCK_SOURCE_IS_CONTINUOUS,
> +};
> +
> +static void spear_clocksource_init(void)
> +{
> +       static struct spear_timer *timer;
> +       u32 tick_rate;
> +
> +       timer = spear_timer_request_specific(1);

Why does this need exactly timer 1?

Atleast the argument could be an enum GPT_TIMER_1, GPT_TIMER_2 etc.

If this is some way to force the clocksource on a certain timer this also
shows that gpt should be merged in here so we don't need strange
interfaces or numbers like this.

> +       BUG_ON(timer == NULL);
> +       spear_timer_clksrc = timer;
> +
> +       spear_timer_set_source(timer, SPEAR_TIMER_SRC_PLL3_CLK);
> +       spear_timer_set_prescaler(timer, GPT_CTRL_PRESCALER256);
> +
> +       /* find out actual clock driving Timer */
> +       tick_rate = clk_get_rate(spear_timer_get_fclk(timer));
> +       tick_rate >>= timer->prescaler;
> +
> +       spear_timer_set_load_start(timer, 1, 0xFFFF); /* 16 bit maximum */
> +
> +       clksrc.mult =
> +               clocksource_khz2mult((tick_rate / 1000), clksrc.shift);
> +
> +       /* register the clocksource */
> +       clocksource_register(&clksrc);
> +}
> +
> +/*
> +* Clock Event
> +*/
> +static struct clock_event_device clkevt = {
> +       .name = "clock_event",
> +       .features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
> +       .set_mode = clockevent_set_mode,
> +       .set_next_event = clockevent_next_event,
> +       .shift = 20,

Elaborate on why you choose 20.
Comtemplate using clockevents_calc_mult_shift().

> +};
> +
> +static void clockevent_set_mode(enum clock_event_mode mode,
> +                               struct clock_event_device *clk_event_dev)
> +{
> +       u32 period;
> +       struct spear_timer *timer = spear_timer_clkevt;
> +
> +       if (timer)
> +               return;
> +
> +       spear_timer_stop(timer);
> +
> +       switch (mode) {
> +       case CLOCK_EVT_MODE_PERIODIC:
> +               period = clk_get_rate(spear_timer_get_fclk(timer)) / HZ;
> +               period >>= timer->prescaler;
> +
> +               spear_timer_match_irq(timer, 1);
> +               spear_timer_set_load_start(timer, 1, period);
> +               break;
> +
> +       case CLOCK_EVT_MODE_ONESHOT:
> +               spear_timer_match_irq(timer, 1);
> +               break;
> +
> +       case CLOCK_EVT_MODE_UNUSED:
> +       case CLOCK_EVT_MODE_SHUTDOWN:
> +       case CLOCK_EVT_MODE_RESUME:
> +               break;
> +
> +       default:
> +               printk(KERN_ERR "BUG: Invalid mode requested\n");

What about using pr_err() and also BUG()?

> +               break;
> +       }
> +}
> +
> +static int clockevent_next_event(unsigned long cycles,
> +                                struct clock_event_device *clk_event_dev)
> +{
> +       spear_timer_set_load_start(spear_timer_clkevt, 0, (u16) cycles);
> +
> +       return 0;
> +}
> +
> +static irqreturn_t spear_timer_interrupt(int irq, void *dev_id)
> +{
> +       struct clock_event_device *evt = &clkevt;
> +       struct spear_timer *timer = (struct spear_timer *)dev_id;
> +
> +       spear_timer_clear_status(timer, GPT_STATUS_MATCH);
> +
> +       evt->event_handler(evt);
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static struct irqaction spear_timer_irq = {
> +       .name = "gp_timer",
> +       .flags = IRQF_DISABLED | IRQF_TIMER,
> +       .handler = spear_timer_interrupt
> +};
> +
> +static void __init spear_clockevent_init(void)
> +{
> +       struct spear_timer *timer;
> +       u32 tick_rate;
> +
> +       timer = spear_timer_request_specific(0);
> +       BUG_ON(timer == NULL);
> +       spear_timer_clkevt = timer;
> +
> +       spear_timer_set_source(timer, SPEAR_TIMER_SRC_PLL3_CLK);
> +       spear_timer_set_prescaler(timer, GPT_CTRL_PRESCALER16);
> +
> +       tick_rate = clk_get_rate(spear_timer_get_fclk(timer));
> +       tick_rate >>= timer->prescaler;
> +
> +       clkevt.mult = div_sc(tick_rate, NSEC_PER_SEC,
> +                                       clkevt.shift);
> +       clkevt.max_delta_ns = clockevent_delta2ns(0xfff0,
> +                       &clkevt);
> +       clkevt.min_delta_ns = clockevent_delta2ns(3, &clkevt);
> +
> +       clkevt.cpumask = cpumask_of(0);
> +       clockevents_register_device(&clkevt);
> +
> +       spear_timer_irq.dev_id = (void *)timer;
> +
> +       setup_irq(spear_timer_get_irq(timer), &spear_timer_irq);
> +       spear_timer_match_irq(timer, 1);
> +}
> +
> +void __init spear_setup_timer(void)
> +{
> +       /* Initialize all General Purpose Timers */
> +       spear_gpt_init();
> +
> +       spear_clockevent_init();
> +       spear_clocksource_init();
> +}
> +
> +struct sys_timer spear_sys_timer = {
> +       .init = spear_setup_timer,
> +};

Consider also adding a simple
sched_clock() implementation or your scheduling and hrtimers will have tick
granularity only, (not very highres...) look at examples in other
archs like plat-omap.

Yours,
Linus Walleij
