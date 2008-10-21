Return-Path: <linux-kernel-owner+w=401wt.eu-S1755037AbYJUVTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbYJUVTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 17:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbYJUVTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 17:19:23 -0400
Received: from relay1.sgi.com ([192.48.171.29]:37124 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752124AbYJUVTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 17:19:22 -0400
Date: Tue, 21 Oct 2008 16:19:21 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Cc: Dimitri Sivanich <sivanich@sgi.com>
Subject: [PATCH 1/3] SGI RTC: add clocksource driver
Message-ID: <20081021211921.GA4037@sgi.com>
References: <20081021211740.GA3936@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021211740.GA3936@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides a driver for SGI RTC clocks and timers.

This provides a high resolution clock and timer source using the SGI
system-wide synchronized RTC clock/timer hardware.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

Index: linux/drivers/clocksource/Makefile
===================================================================
--- linux.orig/drivers/clocksource/Makefile	2008-10-21 12:02:41.000000000 -0500
+++ linux/drivers/clocksource/Makefile	2008-10-21 12:02:44.000000000 -0500
@@ -2,3 +2,4 @@ obj-$(CONFIG_ATMEL_TCB_CLKSRC)	+= tcb_cl
 obj-$(CONFIG_X86_CYCLONE_TIMER)	+= cyclone.o
 obj-$(CONFIG_X86_PM_TIMER)	+= acpi_pm.o
 obj-$(CONFIG_SCx200HR_TIMER)	+= scx200_hrt.o
+obj-$(CONFIG_SGI_RTC_TIMER)	+= rtc_uv.o
Index: linux/drivers/misc/Kconfig
===================================================================
--- linux.orig/drivers/misc/Kconfig	2008-10-21 12:02:41.000000000 -0500
+++ linux/drivers/misc/Kconfig	2008-10-21 12:02:44.000000000 -0500
@@ -488,4 +488,12 @@ config SGI_GRU_DEBUG
 	This option enables addition debugging code for the SGI GRU driver. If
 	you are unsure, say N.
 
+config SGI_RTC_TIMER
+	tristate "SGI RTC driver"
+	depends on X86_64 || IA64_SGI_UV
+	default m
+	---help---
+	This option enables RTC event handling and adds the systemwide RTC
+	as a high resolution clock source for SGI systems.
+
 endif # MISC_DEVICES
Index: linux/drivers/clocksource/rtc_uv.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/drivers/clocksource/rtc_uv.c	2008-10-21 12:29:00.000000000 -0500
@@ -0,0 +1,213 @@
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
+	.shift		= 0,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+static struct clock_event_device clock_event_device_uv = {
+	.name		= RTC_NAME,
+	.features	= CLOCK_EVT_FEAT_ONESHOT,
+	.shift		= 10,
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
+/*
+ * Read the RTC.
+ */
+static cycle_t
+uv_read_rtc(void)
+{
+	cycle_t ticks;
+	uv_bios_rtct(UV_RTC_READ, &ticks, 0, 0, 0, 0);
+	return ticks;
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
+	return uv_bios_rtct(UV_RTC_EVT_SET, &ced_cpu, &delta, 0, 0, 0);
+}
+
+/*
+ * Setup the RTC timer in oneshot mode
+ */
+static void
+uv_rtc_timer_setup(enum clock_event_mode mode, struct clock_event_device *evt)
+{
+	unsigned long flags;
+	int ced_cpu = first_cpu(evt->cpumask);
+
+	local_irq_save(flags);
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+	case CLOCK_EVT_MODE_ONESHOT:
+		uv_bios_rtct(UV_RTC_EVT_START, &ced_cpu, 0, 0, 0, 0);
+		break;
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		uv_bios_rtct(UV_RTC_EVT_STOP, &ced_cpu, 0, 0, 0, 0);
+		break;
+	case CLOCK_EVT_MODE_RESUME:
+		uv_bios_rtct(UV_RTC_EVT_RESUME, &ced_cpu, 0, 0, 0, 0);
+		break;
+	}
+
+	local_irq_restore(flags);
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
+		uv_rtc_send_IPI(cpu, RTC_TIMER_VECTOR);
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
+	if (!ced || !ced->event_handler ||
+			uv_bios_rtct(UV_RTC_EVT_ACK, &cpu, 0, 0, 0, 0)) {
+		local_irq_restore(flags);
+		printk(KERN_WARNING
+			"Spurious uv_rtc timer interrupt on cpu %d\n",
+				smp_processor_id());
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
+	memcpy(ced, &clock_event_device_uv, sizeof(clock_event_device_uv));
+	cpus_clear(ced->cpumask);
+	cpu_set(smp_processor_id(), ced->cpumask);
+	clockevents_register_device(ced);
+}
+
+static __init int
+uv_rtc_setup_clock(void)
+{
+	u64 vector = RTC_TIMER_VECTOR;
+	int rc;
+
+	if (!is_uv_system() || uv_rtc_reg_extension(uv_rtc_interrupt))
+		return -1;
+
+	/* Setup and register the clocksource */
+	if (uv_bios_rtct(UV_RTC_MASK, &clocksource_uv.mask, 0, 0, 0, 0) ==
+			BIOS_STATUS_UNIMPLEMENTED) {
+		uv_rtc_unreg_extension();
+		printk("BIOS RTC unimplemented\n");
+		return -1;
+	}
+
+	clocksource_uv.mult = clocksource_hz2mult(sn_rtc_cycles_per_second,
+				clocksource_uv.shift);
+
+	rc = clocksource_register(&clocksource_uv);
+	if (rc) {
+		uv_rtc_unreg_extension();
+		return -1;
+	}
+
+	/* Setup and register clockevents */
+	uv_bios_rtct(UV_RTC_EVT_INIT, &vector, 0, 0, 0, 0);
+
+	clock_event_device_uv.mult = div_sc(sn_rtc_cycles_per_second,
+				NSEC_PER_SEC, clock_event_device_uv.shift);
+
+	clock_event_device_uv.min_delta_ns = NSEC_PER_SEC /
+						sn_rtc_cycles_per_second;
+	clock_event_device_uv.max_delta_ns = clocksource_uv.mask *
+				(NSEC_PER_SEC / sn_rtc_cycles_per_second);
+
+	smp_call_function(uv_rtc_register_clockevents, NULL, 0);
+	uv_rtc_register_clockevents(NULL);
+
+	return 0;
+}
+module_init(uv_rtc_setup_clock);
Index: linux/kernel/time/clockevents.c
===================================================================
--- linux.orig/kernel/time/clockevents.c	2008-10-21 12:02:41.000000000 -0500
+++ linux/kernel/time/clockevents.c	2008-10-21 12:02:44.000000000 -0500
@@ -183,6 +183,7 @@ void clockevents_register_device(struct 
 
 	spin_unlock(&clockevents_lock);
 }
+EXPORT_SYMBOL_GPL(clockevents_register_device);
 
 /*
  * Noop handler when we shut down an event device
Index: linux/kernel/time/clocksource.c
===================================================================
--- linux.orig/kernel/time/clocksource.c	2008-10-21 12:02:41.000000000 -0500
+++ linux/kernel/time/clocksource.c	2008-10-21 12:02:44.000000000 -0500
@@ -369,6 +369,7 @@ void clocksource_unregister(struct clock
 	next_clocksource = select_clocksource();
 	spin_unlock_irqrestore(&clocksource_lock, flags);
 }
+EXPORT_SYMBOL(clocksource_unregister);
 
 #ifdef CONFIG_SYSFS
 /**
