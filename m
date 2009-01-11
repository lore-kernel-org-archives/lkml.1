Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbZAKTkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbZAKTkT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 14:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbZAKTkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 14:40:05 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:43496 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbZAKTkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 14:40:01 -0500
Message-ID: <496A4B08.7040506@petalogix.com>
Date: Sun, 11 Jan 2009 20:39:52 +0100
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>
Subject: Microblaze clocksource/event 
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I am doing support for clock source and clockevent to Microblaze cpu.
Could you check that code?
I am not sure if is correct.

>From hw view. -> 32bit periodic counter -> down counting from (freq/hz).
(MB(32bits cpu) freq is up to 150MHz - current 125MHz)
Then is generated interrupt. In irq hanler is incremented mb_tick_cnt
which stores number of ticks.
I had troubles with uptime and then I found implementation in
m68nommu/68328 which used similar technique.
microblaze_read function returns actual value of timer.
Is it correct or not?

And the second part is about shift and rating values. Rating is
describe(linux/clocksource.h) and seems to me that should be
corresponded with CONFIG_HZ value,right?
And I found any explanation of shift value -> max value for equation
(2-5) * freq << shift / NSEC_PER_SEC should be for my case still 32bit
number, where (2-5s) are because of NTP

The second thing which seems to me weird in comparing with others log I
have seen is .resolution value. Full (proc/timer_lists is below) My  
.resolution: 10000000 nsecs which
is 1/HZ in nsec. (On others log I saw 1nsec values). My the lowest
resolution is 1/freq = 8nsec (for 125MHz). Is that OK or not.

About CLOCK_EVT_FEAT_ONESHOT -> means that is timer generate only one
interrupt(count up/down from parameter value) and then stops. Is it
possible to use
for it the same timer? Currently I use PERIODIC setting. (Code is below)

Can someone give me a clue how to test hr_timers?

With implementation below seems to me that timing is correct of course
we will do more tests later.

Thanks for your answers,
Michal Simek

.config fragment

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y




/*
 * Copyright (C) 2007-2008 Michal Simek <monstr@monstr.eu>
 * Copyright (C) 2006 Atmark Techno, Inc.
 *
 * This file is subject to the terms and conditions of the GNU General
Public
 * License. See the file "COPYING" in the main directory of this archive
 * for more details.
 */

#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/param.h>
#include <linux/interrupt.h>
#include <linux/profile.h>
#include <linux/irq.h>
#include <linux/delay.h>
#include <linux/sched.h>
#include <linux/spinlock.h>
#include <linux/err.h>
#include <linux/clk.h>
#include <linux/clocksource.h>
#include <linux/clockchips.h>
#include <linux/io.h>
#include <asm/io.h>
#include <asm/cpuinfo.h>
#include <asm/setup.h>
#include <asm/prom.h>
#include <asm/irq.h>
#include <asm/system.h>

static unsigned int timer_baseaddr;
#define TIMER_BASE    timer_baseaddr

#define TCSR0    (0x00)
#define TLR0    (0x04)
#define TCR0    (0x08)
#define TCSR1    (0x10) /* FIXME not used */
#define TLR1    (0x14) /* FIXME not used */
#define TCR1    (0x18) /* FIXME not used */

#define TCSR_MDT    (1<<0)
#define TCSR_UDT    (1<<1)
#define TCSR_GENT    (1<<2)
#define TCSR_CAPT    (1<<3)
#define TCSR_ARHT    (1<<4)
#define TCSR_LOAD    (1<<5)
#define TCSR_ENIT    (1<<6)
#define TCSR_ENT    (1<<7)
#define TCSR_TINT    (1<<8)
#define TCSR_PWMA    (1<<9)
#define TCSR_ENALL    (1<<10)

static void timer_ack(void)
{
    iowrite32(ioread32(TIMER_BASE + TCSR0), TIMER_BASE + TCSR0);
}

static cycle_t mb_tick_cnt; /* store counter ticks */

static cycle_t microblaze_read(void)
{
    u32 val = ioread32(timer_baseaddr + TCR0); /* read from timer 0 */
    /* FIXME it will be better to setup counter to counting from zero to
max val and then generate interrupt. because we can remove substraction
-> safe time */

    u64 temp = (u64)mb_tick_cnt + (u64)(((u32)cpuinfo.cpu_clock_freq /
HZ) - (u32)val);
    return temp;
}

static struct clocksource clocksource_microblaze = {
    .name        = "microblaze_counter",
    .rating        = 200,
    .read        = microblaze_read,
    .mask        = CLOCKSOURCE_MASK(32),
    .shift        = 13, /* I can shift it */
    .flags        = CLOCK_SOURCE_IS_CONTINUOUS,
};

static int __init microblaze_clocksource_init(void)
{
    clocksource_microblaze.mult =
clocksource_hz2mult(cpuinfo.cpu_clock_freq, clocksource_microblaze.shift);
    if (clocksource_register(&clocksource_microblaze))
        panic("failed to register clocksource");

    return 0;
}

static inline void microblaze_timer_stop(void)
{
    iowrite32((ioread32(timer_baseaddr + TCSR0) | !TCSR_ENT),
timer_baseaddr + TCSR0);
}

static inline void microblaze_timer_start(unsigned long load_val)
{
    if (!load_val)
        load_val = 1;
    iowrite32(load_val, timer_baseaddr + TLR0); /* loading value to
timer reg */

    /* load the initial value */
    iowrite32(TCSR_LOAD, timer_baseaddr + TCSR0);

    /* see timer data sheet for detail
     * !ENALL - don't enable 'em all
     * !PWMA - disable pwm
     * TINT - clear interrupt status
     * ENT- enable timer itself
     * EINT - enable interrupt
     * !LOAD - clear the bit to let go
     * ARHT - auto reload
     * !CAPT - no external trigger
     * !GENT - no external signal
     * UDT - set the timer as down counter
     * !MDT0 - generate mode
     *
     */
    iowrite32(TCSR_TINT|TCSR_ENIT|TCSR_ENT|TCSR_ARHT|TCSR_UDT,
timer_baseaddr + TCSR0);
}

static int microblaze_timer_set_next_event(unsigned long delta,
                     struct clock_event_device *dev)
{
    printk("----------------next event, delta %x, %d\n",(u32)delta,(u32)
delta);
    microblaze_timer_start(delta);
    return 0;
}


static void microblaze_timer_set_mode(enum clock_event_mode mode,
                    struct clock_event_device *evt)
{
    microblaze_timer_stop();

    switch (mode) {
    case CLOCK_EVT_MODE_PERIODIC:
        printk("periodic\n");
        microblaze_timer_start(cpuinfo.cpu_clock_freq / HZ);
        break;
    case CLOCK_EVT_MODE_ONESHOT:
        printk("oneshot-----------------");
        break;
    case CLOCK_EVT_MODE_UNUSED:
        printk("unused---------------\n");
        break;
    case CLOCK_EVT_MODE_SHUTDOWN:
        printk("shutdown-----------------\n");
        microblaze_timer_stop();
        break;
    case CLOCK_EVT_MODE_RESUME:
        printk("resume-------------------\n");
        break;
    }
}

irqreturn_t timer_interrupt(int irq, void *dev_id);

static struct clock_event_device clockevent_microblaze_timer = {
    .name        = "microblaze-timer",
    .features       = CLOCK_EVT_FEAT_PERIODIC, /* |
CLOCK_EVT_FEAT_ONESHOT,*/
    .shift        = 13,
    .rating        = 200,
    .set_next_event    = microblaze_timer_set_next_event,
    .set_mode    = microblaze_timer_set_mode,
};

static struct irqaction timer_irqaction = {
    .handler = timer_interrupt,
    .flags = IRQF_DISABLED,
    .name = "timer",
    .dev_id = &clockevent_microblaze_timer,
};

irqreturn_t timer_interrupt(int irq, void *dev_id)
{
    struct clock_event_device *evt = &clockevent_microblaze_timer;
#ifdef CONFIG_HEART_BEAT
    heartbeat();
#endif
    timer_ack();

    mb_tick_cnt += cpuinfo.cpu_clock_freq / HZ;

    evt->event_handler(evt);
    return IRQ_HANDLED;
}

static __init void microblaze_clockevent_init(void)
{
    clockevent_microblaze_timer.mult = div_sc(cpuinfo.cpu_clock_freq,
NSEC_PER_SEC, clockevent_microblaze_timer.shift);
    clockevent_microblaze_timer.max_delta_ns =
clockevent_delta2ns((u32)~0, &clockevent_microblaze_timer);
    clockevent_microblaze_timer.min_delta_ns = clockevent_delta2ns(1,
&clockevent_microblaze_timer);
    clockevent_microblaze_timer.cpumask = cpumask_of(0);
    clockevents_register_device(&clockevent_microblaze_timer);
}

//void system_timer_init(void)
void __init time_init(void)
{
    int irq, j = 0;
    struct device_node *timer = NULL;
    char *timer_list[] = {
                "xlnx,xps-timer-1.00.a",
                "xlnx,opb-timer-1.00.b",
                "xlnx,opb-timer-1.00.a",
                NULL
            };

    for (j = 0; timer_list[j] != NULL; j++) {
        timer = of_find_compatible_node(NULL, NULL, timer_list[j]);
        if (timer)
            break;
    }

    timer_baseaddr = *(int *) of_get_property(timer, "reg", NULL);
    timer_baseaddr = (unsigned long) ioremap(timer_baseaddr, PAGE_SIZE);
    irq = *(int *) of_get_property(timer, "interrupts", NULL);
    printk(KERN_INFO "%s #0 at 0x%08x, irq=%d\n",
        timer_list[j], timer_baseaddr, irq);

    setup_irq(irq, &timer_irqaction);
#ifdef CONFIG_HEART_BEAT
    setup_heartbeat();
#endif
    xtime.tv_sec = mktime(2007, 1, 1, 0, 0, 0);
    xtime.tv_nsec = 0;
    set_normalized_timespec(&wall_to_monotonic,
                -xtime.tv_sec, -xtime.tv_nsec);

    microblaze_clocksource_init();
    microblaze_clockevent_init();
}

 cat /proc/timer_list
Timer List Version: v0.4
HRTIMER_MAX_CLOCK_BASES: 2
now at 1002231574778 nsecs

cpu: 0
 clock 0:
  .base:       901ef2dc
  .index:      0
  .resolution: 10000000 nsecs
  .get_time:   <9002bf24>
  .offset:     0 nsecs
active timers:
 clock 1:
  .base:       901ef308
  .index:      1
  .resolution: 10000000 nsecs
  .get_time:   <9002bee0>
  .offset:     0 nsecs
active timers:
 #0: <9f1c3a48>, <9002d4d4>, S:01, <9f1c3a48>, inetd/54
 # expires at 1002500373649-1002501373593 nsecs [in 268798871 to
269798815 nsecs]
 #1: <9f1c1a48>, <9002d4d4>, S:01, <9f1c1a48>, thttpd/50
 # expires at 1089000664023-1089100664023 nsecs [in 86769089245 to
86869089245 nsecs]
  .expires_next   : 2147483646999999999 nsecs
  .hres_active    : 0
  .nr_events      : 0
  .nohz_mode      : 0
  .idle_tick      : 0 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 0
  .idle_calls     : 0
  .idle_sleeps    : 0
  .idle_entrytime : 1002194619686 nsecs
  .idle_waketime  : 0 nsecs
  .idle_exittime  : 0 nsecs
  .idle_sleeptime : 19290105782 nsecs
  .last_jiffies   : 0
  .next_jiffies   : 0
  .idle_expires   : 0 nsecs
jiffies: 70223


Tick Device: mode:     0
Per CPU device: 0
Clock Event Device: microblaze-timer
 max_delta_ns:   2147483647
 min_delta_ns:   1000
 mult:           1024
 shift:          13
 mode:           2
 next_event:     2147483646999999999 nsecs
 set_next_event: <90003914>
 set_mode:       <900039a8>
 event_handler:  <90035ea0>

#




