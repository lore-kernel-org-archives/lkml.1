Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbYKXT6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbYKXT6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 14:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYKXT6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 14:58:13 -0500
Received: from relay1.sgi.com ([192.48.179.29]:47855 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750890AbYKXT6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 14:58:11 -0500
Date: Mon, 24 Nov 2008 13:58:10 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, john stultz <johnstul@us.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/2 v4] SGI RTC: add clocksource driver
Message-ID: <20081124195810.GB8387@sgi.com>
References: <20081124195405.GA8339@sgi.com> <20081124195617.GA8387@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081124195617.GA8387@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides a driver for SGI RTC clocks and timers.

This provides a high resolution clock and timer source using the SGI
system-wide synchronized RTC clock/timer hardware.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

Changed the shift values for clocksource and clockevent.
Made other stylistic changes.

 drivers/clocksource/Makefile |    1 
 drivers/clocksource/rtc_uv.c |  410 +++++++++++++++++++++++++++++++++++++++
 drivers/misc/Kconfig         |    9 
 kernel/time/clockevents.c    |    1 
 kernel/time/clocksource.c    |    1 
 5 files changed, 422 insertions(+)

Index: linux/drivers/clocksource/Makefile
===================================================================
--- linux.orig/drivers/clocksource/Makefile	2008-11-24 12:36:59.000000000 -0600
+++ linux/drivers/clocksource/Makefile	2008-11-24 12:37:01.000000000 -0600
@@ -2,3 +2,4 @@ obj-$(CONFIG_ATMEL_TCB_CLKSRC)	+= tcb_cl
 obj-$(CONFIG_X86_CYCLONE_TIMER)	+= cyclone.o
 obj-$(CONFIG_X86_PM_TIMER)	+= acpi_pm.o
 obj-$(CONFIG_SCx200HR_TIMER)	+= scx200_hrt.o
+obj-$(CONFIG_SGI_RTC_TIMER)	+= rtc_uv.o
Index: linux/drivers/misc/Kconfig
===================================================================
--- linux.orig/drivers/misc/Kconfig	2008-11-24 12:36:59.000000000 -0600
+++ linux/drivers/misc/Kconfig	2008-11-24 12:37:01.000000000 -0600
@@ -498,6 +498,15 @@ config SGI_GRU_DEBUG
 	This option enables addition debugging code for the SGI GRU driver. If
 	you are unsure, say N.
 
+config SGI_RTC_TIMER
+	tristate "SGI RTC driver"
+	depends on GENERIC_CLOCKEVENTS_BUILD
+	depends on (X86_64 || IA64_SGI_UV || IA64_GENERIC) && SMP
+	default m
+	---help---
+	This option enables RTC event handling and adds the systemwide RTC
+	as a high resolution clock source for SGI systems.
+
 source "drivers/misc/c2port/Kconfig"
 
 endif # MISC_DEVICES
Index: linux/drivers/clocksource/rtc_uv.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/drivers/clocksource/rtc_uv.c	2008-11-24 13:18:14.000000000 -0600
@@ -0,0 +1,410 @@
+/*
+ * SGI RTC clock/timer routines.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ *  Copyright (c) Dimitri Sivanich
+ */
+#include <linux/module.h>
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
+#include <asm/genapic.h>
+#include <asm/uv/bios.h>
+#include <asm/uv/uv_mmrs.h>
+#include <asm/uv/uv_hub.h>
+
+MODULE_LICENSE("GPL");
+
+#define RTC_NAME		"sgi_rtc"
+
+static cycle_t uv_read_rtc(void);
+static int uv_rtc_next_event(unsigned long, struct clock_event_device *);
+static void uv_rtc_timer_setup(enum clock_event_mode,
+				struct clock_event_device *);
+static void uv_rtc_timer_broadcast(cpumask_t);
+
+
+static struct clocksource clocksource_uv = {
+	.name		= RTC_NAME,
+	.rating		= 400,
+	.read		= uv_read_rtc,
+	.mask		= (cycle_t)UVH_RTC_REAL_TIME_CLOCK_MASK,
+	.shift		= 10,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+static struct clock_event_device clock_event_device_uv = {
+	.name		= RTC_NAME,
+	.features	= CLOCK_EVT_FEAT_ONESHOT,
+	.shift		= 20,
+	.rating		= 400,
+	.irq		= -1,
+	.set_next_event	= uv_rtc_next_event,
+	.set_mode	= uv_rtc_timer_setup,
+	.event_handler	= NULL,
+	.broadcast	= uv_rtc_timer_broadcast
+};
+
+static DEFINE_PER_CPU(struct clock_event_device, cpu_ced);
+
+/* There is one of these allocated per node */
+struct uv_rtc_timer_head {
+	spinlock_t lock;
+	int fcpu;	/* first cpu on this node, system-wide reference */
+	int cpus;	/* number of cpus on this node */
+	u64 next_cpu;	/* next cpu waiting for timer, local node relative */
+	u64 expires[];	/* next timer expiration for each cpu on this node */
+};
+
+/*
+ * This points to the uv_rtc_timer_head allocated for this cpu's node.
+ */
+static DEFINE_PER_CPU(struct uv_rtc_timer_head *, rtc_timer_head);
+
+int cpu_to_pnode(int cpu)
+{
+	return uv_apicid_to_pnode(per_cpu(x86_cpu_to_apicid, cpu));
+}
+
+/*
+ * Hardware interface routines
+ */
+
+/* Send IPIs to another node */
+static void
+uv_rtc_send_IPI(int cpu, int vector)
+{
+	unsigned long val, apicid, lapicid;
+	int pnode;
+
+	apicid = per_cpu(x86_cpu_to_apicid, cpu);
+	lapicid = apicid & 0x3f;
+	pnode = uv_apicid_to_pnode(apicid);
+
+	val = (1UL << UVH_IPI_INT_SEND_SHFT) | (lapicid <<
+						UVH_IPI_INT_APIC_ID_SHFT) |
+		(vector << UVH_IPI_INT_VECTOR_SHFT);
+	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
+}
+
+/* Check for an RTC interrupt pending */
+static int
+uv_intr_pending(int pnode)
+{
+	if (uv_read_global_mmr64(pnode, UVH_EVENT_OCCURRED0) &
+			UVH_EVENT_OCCURRED0_RTC1_MASK)
+		return 1;
+	else
+		return 0;
+}
+
+static void
+uv_clr_intr_pending(int pnode)
+{
+	uv_write_global_mmr64(pnode, UVH_EVENT_OCCURRED0_ALIAS,
+		UVH_EVENT_OCCURRED0_RTC1_MASK);
+}
+
+static void
+uv_setup_intr(int cpu, u64 expires)
+{
+	u64 val;
+	int pnode = cpu_to_pnode(cpu);
+
+	uv_write_global_mmr64(pnode, UVH_RTC1_INT_CONFIG,
+		UVH_RTC1_INT_CONFIG_M_MASK);
+	uv_write_global_mmr64(pnode, UVH_INT_CMPB, -1L);
+
+	uv_clr_intr_pending(pnode);
+
+	val = ((u64)GENERIC_TIMER_VECTOR << UVH_RTC1_INT_CONFIG_VECTOR_SHFT) |
+		((u64)cpu_physical_id(cpu) << UVH_RTC1_INT_CONFIG_APIC_ID_SHFT);
+	/* Set configuration */
+	uv_write_global_mmr64(pnode, UVH_RTC1_INT_CONFIG, val);
+	/* Initialize comparator value */
+	uv_write_global_mmr64(pnode, UVH_INT_CMPB, expires);
+}
+
+
+/*
+ * Per-cpu timer tracking routines
+ */
+
+/* Allocate per-node list of cpu timer expiration times. */
+static int
+uv_rtc_allocate_timers(void)
+{
+	int cpu;
+	int max = 0;
+	int pnode = -1;
+	int i = 0;
+	struct uv_rtc_timer_head *head = NULL;
+
+	/*
+	 * Determine max possible hyperthreads/pnode for allocation.
+	 *
+	 * Allocate for all cpus that could come up, although we don't
+	 * fully support hotplug (yet).
+	 */
+	for_each_possible_cpu(cpu) {
+		if (pnode != cpu_to_pnode(cpu)) {
+			i = 0;
+			pnode = cpu_to_pnode(cpu);
+		}
+		if (max < ++i)
+			max = i;
+	}
+
+	pnode = -1;
+	for_each_possible_cpu(cpu) {
+		if (pnode != cpu_to_pnode(cpu)) {
+			i = 0;
+			pnode = cpu_to_pnode(cpu);
+			head = kmalloc_node(sizeof(struct uv_rtc_timer_head) +
+					(max * sizeof(u64)),
+					GFP_KERNEL, pnode);
+			if (!head)
+				return -ENOMEM;
+			spin_lock_init(&head->lock);
+			head->fcpu = cpu;
+			head->cpus = 0;
+			head->next_cpu = -1;
+		}
+		head->cpus++;
+		head->expires[i++] = ULLONG_MAX;
+		per_cpu(rtc_timer_head, cpu) = head;
+	}
+	return 0;
+}
+
+/* Find and set the next expiring timer.  */
+static void
+uv_rtc_find_next_timer(struct uv_rtc_timer_head *head, int pnode)
+{
+	u64 exp;
+	u64 lowest = ULLONG_MAX;
+	int cpu = -1;
+	int c;
+
+	head->next_cpu = -1;
+	for (c = 0; c < head->cpus; c++) {
+		exp = head->expires[c];
+		if (exp < lowest) {
+			cpu = c;
+			lowest = exp;
+		}
+	}
+	if (cpu >= 0) {
+		head->next_cpu = cpu;
+		c = head->fcpu + cpu;
+		uv_setup_intr(c, lowest);
+		/* If we didn't set it up in time, trigger */
+		if (lowest < uv_read_rtc() && !uv_intr_pending(pnode))
+			uv_rtc_send_IPI(c, GENERIC_TIMER_VECTOR);
+	} else
+		uv_write_global_mmr64(pnode, UVH_RTC1_INT_CONFIG,
+			UVH_RTC1_INT_CONFIG_M_MASK);
+}
+
+/*
+ * Set expiration time for current cpu.
+ *
+ * Returns 1 if we missed the expiration time.
+ */
+static int
+uv_rtc_set_timer(int cpu, u64 expires)
+{
+	int pnode = cpu_to_pnode(cpu);
+	struct uv_rtc_timer_head *head = per_cpu(rtc_timer_head, cpu);
+	int local_cpu = cpu - head->fcpu;
+	u64 *t = &head->expires[local_cpu];
+	unsigned long flags;
+	int next_cpu;
+
+	spin_lock_irqsave(&head->lock, flags);
+
+	next_cpu = head->next_cpu;
+	*t = expires;
+
+	/* Will this one be next to go off? */
+	if (expires < head->expires[next_cpu]) {
+		head->next_cpu = cpu;
+		uv_setup_intr(cpu, expires);
+		if (expires <= uv_read_rtc() && !uv_intr_pending(pnode)) {
+			*t = ULLONG_MAX;
+			uv_rtc_find_next_timer(head, pnode);
+			spin_unlock_irqrestore(&head->lock, flags);
+			return 1;
+		}
+	}
+
+	spin_unlock_irqrestore(&head->lock, flags);
+	return 0;
+}
+
+/*
+ * Unset expiration time for current cpu.
+ *
+ * Returns 1 if this timer was pending.
+ */
+static int
+uv_rtc_unset_timer(int cpu)
+{
+	int pnode = cpu_to_pnode(cpu);
+	struct uv_rtc_timer_head *head = per_cpu(rtc_timer_head, cpu);
+	int local_cpu = cpu - head->fcpu;
+	u64 *t = &head->expires[local_cpu];
+	unsigned long flags;
+	int rc = 0;
+
+	spin_lock_irqsave(&head->lock, flags);
+
+	if (head->next_cpu == cpu && uv_read_rtc() >= *t)
+		rc = 1;
+
+	*t = ULLONG_MAX;
+	/* Was the hardware setup for this timer? */
+	if (head->next_cpu == cpu)
+		uv_rtc_find_next_timer(head, pnode);
+
+	spin_unlock_irqrestore(&head->lock, flags);
+	return rc;
+}
+
+
+
+/*
+ * Kernel interface routines.
+ */
+
+/*
+ * Read the RTC.
+ */
+static cycle_t
+uv_read_rtc(void)
+{
+	return (cycle_t)uv_read_local_mmr(UVH_RTC);
+}
+
+/*
+ * Program the next event, relative to now
+ */
+static int
+uv_rtc_next_event(unsigned long delta, struct clock_event_device *ced)
+{
+	int ced_cpu = first_cpu(ced->cpumask);
+
+	return uv_rtc_set_timer(ced_cpu, delta + uv_read_rtc());
+}
+
+/*
+ * Setup the RTC timer in oneshot mode
+ */
+static void
+uv_rtc_timer_setup(enum clock_event_mode mode, struct clock_event_device *evt)
+{
+	int ced_cpu = first_cpu(evt->cpumask);
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+	case CLOCK_EVT_MODE_ONESHOT:
+	case CLOCK_EVT_MODE_RESUME:
+		/* Nothing to do here yet */
+		break;
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		uv_rtc_unset_timer(ced_cpu);
+		break;
+	}
+}
+
+/*
+ * Local APIC timer broadcast function
+ */
+static void
+uv_rtc_timer_broadcast(cpumask_t mask)
+{
+	int cpu;
+	for_each_cpu_mask(cpu, mask)
+		uv_rtc_send_IPI(cpu, GENERIC_TIMER_VECTOR);
+}
+
+static void
+uv_rtc_interrupt(void)
+{
+	struct clock_event_device *ced = &__get_cpu_var(cpu_ced);
+	unsigned long flags;
+	int cpu = smp_processor_id();
+
+	local_irq_save(flags);
+	if (!ced || !ced->event_handler || !uv_rtc_unset_timer(cpu)) {
+		local_irq_restore(flags);
+		printk(KERN_WARNING
+			"Spurious uv_rtc timer interrupt on cpu %d\n", cpu);
+		return;
+	}
+	local_irq_restore(flags);
+	ced->event_handler(ced);
+}
+
+static __init void
+uv_rtc_register_clockevents(void *data)
+{
+	struct clock_event_device *ced = &__get_cpu_var(cpu_ced);
+
+	*ced = clock_event_device_uv;
+	cpus_clear(ced->cpumask);
+	cpu_set(smp_processor_id(), ced->cpumask);
+	clockevents_register_device(ced);
+}
+
+static __init int
+uv_rtc_setup_clock(void)
+{
+	int rc;
+
+	if (!is_uv_system() ||
+			register_generic_timer_extension(uv_rtc_interrupt))
+		return -ENODEV;
+
+	clocksource_uv.mult = clocksource_hz2mult(sn_rtc_cycles_per_second,
+				clocksource_uv.shift);
+
+	rc = clocksource_register(&clocksource_uv);
+	if (rc) {
+		unregister_generic_timer_extension();
+		return rc;
+	}
+
+	/* Setup and register clockevents */
+	rc = uv_rtc_allocate_timers();
+	if (rc) {
+		unregister_generic_timer_extension();
+		return rc;
+	}
+
+	clock_event_device_uv.mult = div_sc(sn_rtc_cycles_per_second,
+				NSEC_PER_SEC, clock_event_device_uv.shift);
+
+	clock_event_device_uv.min_delta_ns = NSEC_PER_SEC /
+						sn_rtc_cycles_per_second;
+	clock_event_device_uv.max_delta_ns = clocksource_uv.mask *
+				(NSEC_PER_SEC / sn_rtc_cycles_per_second);
+
+	on_each_cpu(uv_rtc_register_clockevents, NULL, 0);
+	return 0;
+}
+module_init(uv_rtc_setup_clock);
Index: linux/kernel/time/clockevents.c
===================================================================
--- linux.orig/kernel/time/clockevents.c	2008-11-24 12:36:59.000000000 -0600
+++ linux/kernel/time/clockevents.c	2008-11-24 12:37:01.000000000 -0600
@@ -183,6 +183,7 @@ void clockevents_register_device(struct 
 
 	spin_unlock(&clockevents_lock);
 }
+EXPORT_SYMBOL_GPL(clockevents_register_device);
 
 /*
  * Noop handler when we shut down an event device
Index: linux/kernel/time/clocksource.c
===================================================================
--- linux.orig/kernel/time/clocksource.c	2008-11-24 12:36:59.000000000 -0600
+++ linux/kernel/time/clocksource.c	2008-11-24 12:37:01.000000000 -0600
@@ -369,6 +369,7 @@ void clocksource_unregister(struct clock
 	next_clocksource = select_clocksource();
 	spin_unlock_irqrestore(&clocksource_lock, flags);
 }
+EXPORT_SYMBOL(clocksource_unregister);
 
 #ifdef CONFIG_SYSFS
 /**
