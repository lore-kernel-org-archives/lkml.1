Return-Path: <linux-kernel-owner+w=401wt.eu-S2992499AbXCGTyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992499AbXCGTyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 14:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992538AbXCGTyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 14:54:16 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:50840 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992499AbXCGTyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 14:54:14 -0500
Message-ID: <45EF175D.6030609@vmware.com>
Date: Wed, 07 Mar 2007 11:49:49 -0800
From: Dan Hecht <dhecht@vmware.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: James Morris <jmorris@namei.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       akpm@linux-foundation.org, john stultz <johnstul@us.ibm.com>,
       tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Dan Hecht <dhecht@vmware.com>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>	<45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu>	<20070306084647.GA16280@elte.hu> <45ED2C82.3080008@vmware.com>	<1173178774.24738.311.camel@localhost.localdomain>	<45EDD82F.90204@vmware.com>	<1173225182.24738.507.camel@localhost.localdomain>	<45EE0628.1080108@goop.org> <45EE08E8.2020008@vmware.com>	<1173228544.24738.514.camel@localhost.localdomain>	<45EE0D10.7070807@vmware.com>	<1173230305.24738.529.camel@localhost.localdomain>	<45EE1EA3.90803@vmware.com>	<1173256666.24738.576.camel@localhost.localdomain>	<45EEF966.6060902@goop.org>	<Line.LNX.4.64.0703071304080.1851@d.namei> <45EF0CF5.5090305@goop.org>
In-Reply-To: <45EF0CF5.5090305@goop.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Mar 2007 19:54:11.0470 (UTC) FILETIME=[60246AE0:01C760F2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2007 11:05 AM, Jeremy Fitzhardinge wrote:
> James Morris wrote:
>> It seems to me that it could be useful to have a library of common virtual 
>> time code (entirely separate from pv_ops), to avoid re-implementing some 
>> apparently common requirements, such as: handling TSC frequency changes, 
>> stolen time accounting, synthetic programmable clockevent etc.
>>   
> 
> Well, lets put our clock* implementations next to each other and see how
> much common code there is to be factored out.
> 
> The Xen time code is pretty lean.  There's not much difference in
> abstraction between the clocksource/event interface and the hypervisor
> interface, so there's just not very much code there.
> 

Jeremy, I saw you sent out the Xen version earlier, thanks.  Here's ours 
for reference (please excuse any formating issues); it's also lean. 
We'll send out a proper patch later after some more testing:

---

/*
  * VMI paravirtual timer support routines.
  *
  * Copyright (C) 2007, VMware, Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful, but
  * WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
  * NON INFRINGEMENT.  See the GNU General Public License for more
  * details.
  *
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  */

#include <linux/smp.h>
#include <linux/cpumask.h>
#include <linux/clocksource.h>
#include <linux/clockchips.h>

#include <asm/vmi.h>
#include <asm/vmi_time.h>
#include <asm/apic.h>
#include <asm/i8253.h>
#include <asm/arch_hooks.h>

#include <irq_vectors.h>

#define VMI_ONESHOT  (VMI_ALARM_IS_ONESHOT  | VMI_CYCLES_REAL)
#define VMI_PERIODIC (VMI_ALARM_IS_PERIODIC | VMI_CYCLES_REAL)

static inline u32 vmi_counter(u32 flags)
{
	/* Given VMI_ONESHOT or VMI_PERIODIC, return the corresponding
	 * cycle counter. */
	return flags & VMI_ALARM_COUNTER_MASK;
}

/* paravirt_ops.get_wallclock = vmi_get_wallclock */
unsigned long vmi_get_wallclock(void)
{
	unsigned long long wallclock;
	wallclock = vmi_timer_ops.get_wallclock(); // nsec
	(void)do_div(wallclock, 1000000000);       // sec

	return wallclock;
}

/* paravirt_ops.set_wallclock = vmi_set_wallclock */
int vmi_set_wallclock(unsigned long now)
{
	return 0;
}

/* paravirt_ops.get_scheduled_cycles = vmi_get_sched_cycles */
unsigned long long vmi_get_sched_cycles(void)
{
	return vmi_timer_ops.get_cycle_counter(VMI_CYCLES_AVAILABLE);
}

/* paravirt_ops.get_cpu_khz = vmi_cpu_khz */
unsigned long vmi_cpu_khz(void)
{
	unsigned long long khz;
	khz = vmi_timer_ops.get_cycle_frequency();
	(void)do_div(khz, 1000);
	return khz;
}

/** vmi clockevent */

static struct clock_event_device vmi_global_clockevent;

static inline u32 vmi_alarm_wiring(struct clock_event_device *evt)
{
	return (evt == &vmi_global_clockevent) ?
		VMI_ALARM_WIRED_IRQ0 : VMI_ALARM_WIRED_LVTT;
}

static void vmi_timer_set_mode(enum clock_event_mode mode,
			       struct clock_event_device *evt)
{
	u32 wiring;
	cycle_t now, cycles_per_hz;
	BUG_ON(!irqs_disabled());

	wiring = vmi_alarm_wiring(evt);
	if (wiring == VMI_ALARM_WIRED_LVTT)
		/* Route the interrupt to the correct vector */
		apic_write_around(APIC_LVTT, LOCAL_TIMER_VECTOR);

	switch (mode) {
	case CLOCK_EVT_MODE_ONESHOT:
		break;
	case CLOCK_EVT_MODE_PERIODIC:
		cycles_per_hz = vmi_timer_ops.get_cycle_frequency();
		(void)do_div(cycles_per_hz, HZ);
		now = vmi_timer_ops.get_cycle_counter(vmi_counter(VMI_PERIODIC));
		vmi_timer_ops.set_alarm(wiring | VMI_PERIODIC,
					now, cycles_per_hz);
		break;
	case CLOCK_EVT_MODE_UNUSED:
	case CLOCK_EVT_MODE_SHUTDOWN:
		switch (evt->mode) {
		case CLOCK_EVT_MODE_ONESHOT:
			vmi_timer_ops.cancel_alarm(VMI_ONESHOT);
			break;
		case CLOCK_EVT_MODE_PERIODIC:
			vmi_timer_ops.cancel_alarm(VMI_PERIODIC);
			break;
		default:
			break;
		}
		break;
	default:
		break;
	}
}

static int vmi_timer_next_event(unsigned long delta,
				struct clock_event_device *evt)
{
	/* Unfortunately, set_next_event interface only passes relative
	 * expiry, but we want absolute expiry.  It'd be better if were
	 * were passed an aboslute expiry, since a bunch of time may
	 * have been stolen between the time the delta is computed and
	 * when we set the alarm below. */
	cycle_t now = vmi_timer_ops.get_cycle_counter(vmi_counter(VMI_ONESHOT));

	BUG_ON(evt->mode != CLOCK_EVT_MODE_ONESHOT);
	vmi_timer_ops.set_alarm(vmi_alarm_wiring(evt) | VMI_ONESHOT,
				now + delta, 0);
	return 0;
}

static struct clock_event_device vmi_clockevent = {
	.name		= "vmi-timer",
	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
	.shift		= 22,
	.set_mode	= vmi_timer_set_mode,
	.set_next_event = vmi_timer_next_event,
	.rating         = 1000,
	.irq		= -1,
};

/* Replacement for PIT/HPET global clock event.
  * paravirt_ops.choose_time_init = vmi_time_init_clockevent
  */
void __init vmi_time_init_clockevent(void)
{
	cycle_t cycles_per_msec;

	/* One time setup: initialize the vmi clockevent parameters.
	 * These will be copied to the global and local clockevents. */

	/* Use cycles_per_msec since div_sc params are 32-bits. */
	cycles_per_msec = vmi_timer_ops.get_cycle_frequency();
	(void)do_div(cycles_per_msec, 1000);

	/* Must pick .shift such that .mult fits in 32-bits.  Choosing
	 * .shift to be 22 allows 2^(32-22) cycles per nano-seconds
	 * before overflow. */
	vmi_clockevent.mult = div_sc(cycles_per_msec, NSEC_PER_MSEC,
				     vmi_clockevent.shift);
	/* Upper bound is clockevent's use of ulong for cycle deltas. */
	vmi_clockevent.max_delta_ns =
		clockevent_delta2ns(ULONG_MAX, &vmi_clockevent);
	vmi_clockevent.min_delta_ns =
		clockevent_delta2ns(1, &vmi_clockevent);

	memcpy(&vmi_global_clockevent, &vmi_clockevent,
	       sizeof(vmi_global_clockevent));
	vmi_global_clockevent.name = "vmi-timer (boot)";
	vmi_global_clockevent.cpumask = cpumask_of_cpu(0);
	vmi_global_clockevent.irq = 0;

	printk(KERN_WARNING "vmi: registering clock event %s. mult=%lu 
shift=%u\n",
	       vmi_global_clockevent.name, vmi_global_clockevent.mult,
	       vmi_global_clockevent.shift);
	clockevents_register_device(&vmi_global_clockevent);
	global_clock_event = &vmi_global_clockevent;

	/* We use normal irq0 handler on cpu0. */
	time_init_hook();
}

#ifdef CONFIG_X86_LOCAL_APIC

/* Replacement for lapic timer local clock event.
  * paravirt_ops.setup_boot_clock      = vmi_nop
  *       (continue using global_clock_event on cpu0)
  * paravirt_ops.setup_secondary_clock = vmi_timer_setup_local_alarm
  */
void __devinit vmi_timer_setup_local_alarm(void)
{
	struct clock_event_device *evt = &__get_cpu_var(local_clock_events);

	/* Then, start it back up as a local clockevent device. */
	memcpy(evt, &vmi_clockevent, sizeof(*evt));
	evt->cpumask = cpumask_of_cpu(smp_processor_id());

	printk(KERN_WARNING "vmi: registering clock event %s. mult=%lu 
shift=%u\n",
	       evt->name, evt->mult, evt->shift);
	clockevents_register_device(evt);
}

#endif

/** vmi clocksource */

static cycle_t read_real_cycles(void)
{
	return vmi_timer_ops.get_cycle_counter(VMI_CYCLES_REAL);
}

static struct clocksource clocksource_vmi = {
	.name			= "vmi-timer",
	.rating			= 450,
	.read			= read_real_cycles,
	.mask			= CLOCKSOURCE_MASK(64),
	.mult			= 0, /* to be set */
	.shift			= 22,
	.flags			= CLOCK_SOURCE_IS_CONTINUOUS,
};

static int __init init_vmi_clocksource(void)
{
	cycle_t cycles_per_msec;

	if (!vmi_timer_ops.get_cycle_frequency)
		return 0;
	/* Use khz2mult rather than hz2mult since hz arg is only 32-bits. */
	cycles_per_msec = vmi_timer_ops.get_cycle_frequency();
	(void)do_div(cycles_per_msec, 1000);
	
	/* Note that clocksource.{mult, shift} converts in the opposite direction
	 * as clockevents.  */
	clocksource_vmi.mult = clocksource_khz2mult(cycles_per_msec,
						    clocksource_vmi.shift);

	printk(KERN_WARNING "vmi: registering clock source khz=%lld\n", 
cycles_per_msec);
	return clocksource_register(&clocksource_vmi);

}
module_init(init_vmi_clocksource);
