Return-Path: <linux-kernel-owner+w=401wt.eu-S1755381AbYKTXJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbYKTXJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 18:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbYKTXJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 18:09:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052AbYKTXJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 18:09:09 -0500
Date: Thu, 20 Nov 2008 15:08:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       hpa@zytor.com, john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 1/2 v3] SGI RTC: add clocksource driver
Message-Id: <20081120150813.d7d1901e.akpm@linux-foundation.org>
In-Reply-To: <20081119212350.GB3377@sgi.com>
References: <20081023163041.GA14574@sgi.com>
	<20081119212202.GA3377@sgi.com>
	<20081119212350.GB3377@sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2008 15:23:50 -0600
Dimitri Sivanich <sivanich@sgi.com> wrote:

> This patch provides a driver for SGI RTC clocks and timers.
> 
> This provides a high resolution clock and timer source using the SGI
> system-wide synchronized RTC clock/timer hardware.

Plese copy John Stultz on clockevents things.

> @@ -0,0 +1,399 @@
> +/*
> + * SGI RTC clock/timer routines.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
> + *
> + *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
> + *  Copyright (c) Dimitri Sivanich
> + */
> +#include <linux/module.h>
> +#include <linux/clocksource.h>
> +#include <linux/clockchips.h>
> +#include <asm/genapic.h>
> +#include <asm/uv/bios.h>
> +#include <asm/uv/uv_mmrs.h>
> +#include <asm/uv/uv_hub.h>
> +
> +MODULE_LICENSE("GPL");
> +
> +#define RTC_NAME		"sgi_rtc"
> +#define cpu_to_pnode(_c_) \
> +		uv_apicid_to_pnode(per_cpu(x86_cpu_to_apicid, (_c_)))

It'd be nicer to implement this as a regular C function.

> +static cycle_t uv_read_rtc(void);
> +static int uv_rtc_next_event(unsigned long, struct clock_event_device *);
> +static void uv_rtc_timer_setup(enum clock_event_mode,
> +				struct clock_event_device *);
> +static void uv_rtc_timer_broadcast(cpumask_t);
> +
> +
> +static struct clocksource clocksource_uv = {
> +	.name		= RTC_NAME,
> +	.rating		= 400,
> +	.read		= uv_read_rtc,
> +	.mask		= (cycle_t)UVH_RTC_REAL_TIME_CLOCK_MASK,
> +	.shift		= 0,
> +	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
> +};
> +
> +static struct clock_event_device clock_event_device_uv = {
> +	.name		= RTC_NAME,
> +	.features	= CLOCK_EVT_FEAT_ONESHOT,
> +	.shift		= 10,
> +	.rating		= 400,
> +	.irq		= -1,
> +	.set_next_event	= uv_rtc_next_event,
> +	.set_mode	= uv_rtc_timer_setup,
> +	.event_handler	= NULL,
> +	.broadcast	= uv_rtc_timer_broadcast
> +};
> +
> +static DEFINE_PER_CPU(struct clock_event_device, cpu_ced);
> +
> +struct uv_rtc_timer_head {
> +	spinlock_t lock;
> +	int fcpu;
> +	int cpus;
> +	u64 next_cpu;	/* local cpu on this node */
> +	u64 expires[];
> +};
> +
> +static DEFINE_PER_CPU(struct uv_rtc_timer_head *, rtc_timer_head);

It would be useful to document the data structures and the relationship
between them.  When I read this code I wonder why we didn't just do

static DEFINE_PER_CPU(struct uv_rtc_timer_head, rtc_timer_head);

but then I see that zero-sized array and wonder what that is for, and
what it will contain, etc, etc.

> +
> +/*
> + * Hardware interface routines
> + */
> +
> +/* Send IPIs to another node */
> +static void
> +uv_rtc_send_IPI(int cpu, int vector)
> +{
> +	unsigned long val, apicid, lapicid;
> +	int pnode;
> +
> +	apicid = per_cpu(x86_cpu_to_apicid, cpu);
> +	lapicid = apicid & 0x3f;
> +	pnode = uv_apicid_to_pnode(apicid);
> +
> +	val = (1UL << UVH_IPI_INT_SEND_SHFT) | (lapicid <<
> +						UVH_IPI_INT_APIC_ID_SHFT) |
> +		(vector << UVH_IPI_INT_VECTOR_SHFT);
> +	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
> +}
> +
> +/* Check for an RTC interrupt pending */
> +static int
> +uv_intr_pending(int pnode)
> +{
> +	if (uv_read_global_mmr64(pnode, UVH_EVENT_OCCURRED0) &
> +			UVH_EVENT_OCCURRED0_RTC1_MASK)
> +		return 1;
> +	else
> +		return 0;
> +}
> +
> +static void
> +uv_clr_intr_pending(int pnode)
> +{
> +	uv_write_global_mmr64(pnode, UVH_EVENT_OCCURRED0_ALIAS,
> +		UVH_EVENT_OCCURRED0_RTC1_MASK);
> +}
> +
> +static void
> +uv_setup_intr(int cpu, u64 expires)
> +{
> +	u64 val;
> +	int pnode = cpu_to_pnode(cpu);
> +
> +	uv_write_global_mmr64(pnode, UVH_RTC1_INT_CONFIG,
> +		UVH_RTC1_INT_CONFIG_M_MASK);
> +	uv_write_global_mmr64(pnode, UVH_INT_CMPB, -1L);
> +
> +	uv_clr_intr_pending(pnode);
> +
> +	val = ((u64)GENERIC_TIMER_VECTOR << UVH_RTC1_INT_CONFIG_VECTOR_SHFT) |
> +		((u64)cpu_physical_id(cpu) << UVH_RTC1_INT_CONFIG_APIC_ID_SHFT);
> +	/* Set configuration */
> +	uv_write_global_mmr64(pnode, UVH_RTC1_INT_CONFIG, val);
> +	/* Initialize comparator value */
> +	uv_write_global_mmr64(pnode, UVH_INT_CMPB, expires);
> +}
> +
> +
> +/*
> + * Per-cpu timer tracking routines
> + */
> +
> +/* Allocate per-node list of cpu timer expiration times. */
> +static void
> +uv_rtc_allocate_timers(void)
> +{
> +	struct uv_rtc_timer_head *head = NULL;

This initialisation is unneeded.

The definition of `head' could be moved to a more inner scope, down
near where it is used.

> +	int cpu;
> +	int max = 0;
> +	int pnode = -1;
> +	int i = 0;
> +
> +	/* Determine max possible hyperthreads/pnode for allocation */
> +	for_each_present_cpu(cpu) {

Using the present CPU map surprised me.  I'd suggest that this is worth
a comment, because the reason cannot be determined in any other way.

That comment should also tell us about the situation with cpu hotplug,
which has me scratching my head.

> +		if (pnode != cpu_to_pnode(cpu)) {
> +			i = 0;
> +			pnode = cpu_to_pnode(cpu);
> +		}
> +		if (max < ++i)
> +			max = i;
> +	}
> +
> +	pnode = -1;
> +	for_each_present_cpu(cpu) {
> +		if (pnode != cpu_to_pnode(cpu)) {
> +			i = 0;
> +			pnode = cpu_to_pnode(cpu);
> +			head = kmalloc_node(sizeof(struct uv_rtc_timer_head) +
> +					(max * sizeof(u64)),
> +					GFP_KERNEL, pnode);
> +			spin_lock_init(&head->lock);
> +			head->fcpu = cpu;
> +			head->cpus = 0;
> +			head->next_cpu = -1;

This will oops if the allocation fails.

If this code will only ever be called during initial system boot then
sure, there's not much point in doing the check&recover.  If this is
the case then this function should be marked __init.

> +		}
> +		head->cpus++;
> +		head->expires[i++] = ULLONG_MAX;
> +		per_cpu(rtc_timer_head, cpu) = head;
> +	}
> +}
> +
> +/* Find and set the next expiring timer.  */
> +static void
> +uv_rtc_find_next_timer(struct uv_rtc_timer_head *head, int pnode)
> +{
> +	u64 exp;
> +	u64 lowest = ULLONG_MAX;
> +	int cpu = -1;
> +	int c;
> +
> +	head->next_cpu = -1;
> +	for (c = 0; c < head->cpus; c++) {
> +		exp = head->expires[c];
> +		if (exp < lowest) {
> +			cpu = c;
> +			lowest = exp;
> +		}
> +	}
> +	if (cpu >= 0) {
> +		head->next_cpu = cpu;
> +		c = head->fcpu + cpu;
> +		uv_setup_intr(c, lowest);
> +		/* If we didn't set it up in time, trigger */
> +		if (lowest < uv_read_rtc() && !uv_intr_pending(pnode))
> +			uv_rtc_send_IPI(c, GENERIC_TIMER_VECTOR);
> +	} else
> +		uv_write_global_mmr64(pnode, UVH_RTC1_INT_CONFIG,
> +			UVH_RTC1_INT_CONFIG_M_MASK);
> +}
> +
> +/*
> + * Set expiration time for current cpu.
> + *
> + * Returns 1 if we missed the expiration time.
> + */
> +static int
> +uv_rtc_set_timer(int cpu, u64 expires)
> +{
> +	int pnode = cpu_to_pnode(cpu);
> +	struct uv_rtc_timer_head *head = per_cpu(rtc_timer_head, cpu);
> +	int local_cpu = cpu - head->fcpu;
> +	u64 *t = &head->expires[local_cpu];
> +	unsigned long flags;
> +	int next_cpu;
> +
> +	spin_lock_irqsave(&head->lock, flags);
> +
> +	next_cpu = head->next_cpu;
> +	*t = expires;
> +
> +	/* Will this one be next to go off? */
> +	if (expires < head->expires[next_cpu]) {
> +		head->next_cpu = cpu;
> +		uv_setup_intr(cpu, expires);
> +		if (expires <= uv_read_rtc() && !uv_intr_pending(pnode)) {
> +			*t = ULLONG_MAX;
> +			uv_rtc_find_next_timer(head, pnode);
> +			spin_unlock_irqrestore(&head->lock, flags);
> +			return 1;
> +		}
> +	}
> +
> +	spin_unlock_irqrestore(&head->lock, flags);
> +	return 0;
> +}
> +
> +/*
> + * Unset expiration time for current cpu.
> + *
> + * Returns 1 if this timer was pending.
> + */
> +static int
> +uv_rtc_unset_timer(int cpu)
> +{
> +	int pnode = cpu_to_pnode(cpu);
> +	struct uv_rtc_timer_head *head = per_cpu(rtc_timer_head, cpu);
> +	int local_cpu = cpu - head->fcpu;
> +	u64 *t = &head->expires[local_cpu];
> +	unsigned long flags;
> +	int rc = 0;
> +
> +	spin_lock_irqsave(&head->lock, flags);
> +
> +	if (head->next_cpu == cpu && uv_read_rtc() >= *t)
> +		rc = 1;
> +
> +	*t = ULLONG_MAX;
> +	/* Was the hardware setup for this timer? */
> +	if (head->next_cpu == cpu)
> +		uv_rtc_find_next_timer(head, pnode);
> +
> +	spin_unlock_irqrestore(&head->lock, flags);
> +	return rc;
> +}
> +
> +
> +
> +/*
> + * Kernel interface routines.
> + */
> +
> +/*
> + * Read the RTC.
> + */
> +static cycle_t
> +uv_read_rtc(void)
> +{
> +	return (cycle_t)uv_read_local_mmr(UVH_RTC);
> +}
> +
> +/*
> + * Program the next event, relative to now
> + */
> +static int
> +uv_rtc_next_event(unsigned long delta, struct clock_event_device *ced)
> +{
> +	int ced_cpu = first_cpu(ced->cpumask);
> +
> +	return uv_rtc_set_timer(ced_cpu, delta + uv_read_rtc());
> +}
> +
> +/*
> + * Setup the RTC timer in oneshot mode
> + */
> +static void
> +uv_rtc_timer_setup(enum clock_event_mode mode, struct clock_event_device *evt)
> +{
> +	unsigned long flags;
> +	int ced_cpu = first_cpu(evt->cpumask);
> +
> +	local_irq_save(flags);
> +
> +	switch (mode) {
> +	case CLOCK_EVT_MODE_PERIODIC:
> +	case CLOCK_EVT_MODE_ONESHOT:
> +	case CLOCK_EVT_MODE_RESUME:
> +		/* Nothing to do here yet */
> +		break;
> +	case CLOCK_EVT_MODE_UNUSED:
> +	case CLOCK_EVT_MODE_SHUTDOWN:
> +		uv_rtc_unset_timer(ced_cpu);
> +		break;
> +	}
> +
> +	local_irq_restore(flags);
> +}

The local_irq_save() is surprising.  Is it well-known that
clock_event_device.set_mode() is called in a pinned-on-CPU state?  Or
is something else happening here?

Some comments explaining to readers (and to reviewers) what's going on
here would help.

> +/*
> + * Local APIC timer broadcast function
> + */
> +static void
> +uv_rtc_timer_broadcast(cpumask_t mask)
> +{
> +	int cpu;
> +	for_each_cpu_mask(cpu, mask)
> +		uv_rtc_send_IPI(cpu, GENERIC_TIMER_VECTOR);
> +}
> +
> +static void
> +uv_rtc_interrupt(void)
> +{
> +	struct clock_event_device *ced = &__get_cpu_var(cpu_ced);
> +	unsigned long flags;
> +	int cpu = smp_processor_id();
> +
> +	local_irq_save(flags);
> +	if (!ced || !ced->event_handler || !uv_rtc_unset_timer(cpu)) {
> +		local_irq_restore(flags);
> +		printk(KERN_WARNING
> +			"Spurious uv_rtc timer interrupt on cpu %d\n",
> +				smp_processor_id());
> +		return;
> +	}
> +	local_irq_restore(flags);
> +	ced->event_handler(ced);
> +}

I'll assume that this actually is a real interrupt handler.  If not,
the use of smp_processor_id() might be buggy.

I cannot tell, because I cannot find this generic_timer_reg_extension()
thing anywhere in any trees.  What's up with that?

The above printk could use local variable `cpu'.

> +static __init void
> +uv_rtc_register_clockevents(void *data)
> +{
> +	struct clock_event_device *ced = &__get_cpu_var(cpu_ced);
> +
> +	memcpy(ced, &clock_event_device_uv, sizeof(clock_event_device_uv));

Is that better than

	*ced = clock_event_device_uv;

?

> +	cpus_clear(ced->cpumask);
> +	cpu_set(smp_processor_id(), ced->cpumask);
> +	clockevents_register_device(ced);
> +}
> +
> +static __init int
> +uv_rtc_setup_clock(void)
> +{
> +	int rc;
> +
> +	if (!is_uv_system() || generic_timer_reg_extension(uv_rtc_interrupt))
> +		return -ENODEV;
> +
> +	clocksource_uv.mult = clocksource_hz2mult(sn_rtc_cycles_per_second,
> +				clocksource_uv.shift);
> +
> +	rc = clocksource_register(&clocksource_uv);
> +	if (rc) {
> +		generic_timer_unreg_extension();
> +		return rc;
> +	}
> +
> +	/* Setup and register clockevents */
> +	uv_rtc_allocate_timers();
> +
> +	clock_event_device_uv.mult = div_sc(sn_rtc_cycles_per_second,
> +				NSEC_PER_SEC, clock_event_device_uv.shift);
> +
> +	clock_event_device_uv.min_delta_ns = NSEC_PER_SEC /
> +						sn_rtc_cycles_per_second;
> +	clock_event_device_uv.max_delta_ns = clocksource_uv.mask *
> +				(NSEC_PER_SEC / sn_rtc_cycles_per_second);
> +
> +	smp_call_function(uv_rtc_register_clockevents, NULL, 0);
> +	uv_rtc_register_clockevents(NULL);

Use on_each_cpu() here.

Doing that will fix the bug wherein uv_rtc_register_clockevents() calls
smp_processor_id() in preemptible code.


> +	return 0;
> +}
> +module_init(uv_rtc_setup_clock);
> Index: linux/kernel/time/clockevents.c
> ===================================================================
> --- linux.orig/kernel/time/clockevents.c	2008-11-19 15:08:01.000000000 -0600
> +++ linux/kernel/time/clockevents.c	2008-11-19 15:09:54.000000000 -0600
> @@ -183,6 +183,7 @@ void clockevents_register_device(struct 
>  
>  	spin_unlock(&clockevents_lock);
>  }
> +EXPORT_SYMBOL_GPL(clockevents_register_device);
>  
>  /*
>   * Noop handler when we shut down an event device
> Index: linux/kernel/time/clocksource.c
> ===================================================================
> --- linux.orig/kernel/time/clocksource.c	2008-11-19 15:08:01.000000000 -0600
> +++ linux/kernel/time/clocksource.c	2008-11-19 15:09:54.000000000 -0600
> @@ -369,6 +369,7 @@ void clocksource_unregister(struct clock
>  	next_clocksource = select_clocksource();
>  	spin_unlock_irqrestore(&clocksource_lock, flags);
>  }
> +EXPORT_SYMBOL(clocksource_unregister);
>  
>  #ifdef CONFIG_SYSFS
>  /**
