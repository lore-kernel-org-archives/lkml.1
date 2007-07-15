Return-Path: <linux-kernel-owner+w=401wt.eu-S1762787AbXGOQQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762787AbXGOQQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762563AbXGOQFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:05:39 -0400
Received: from www.osadl.org ([213.239.205.134]:42635 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762691AbXGOQFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:05:21 -0400
Message-Id: <20070715155541.831155126@inhelltoy.tec.linutronix.de>
References: <20070715155510.341941668@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 15 Jul 2007 16:11:08 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch-mm 26/33] x86_64: apic add clock event functions
Content-Disposition: inline;
	filename=x86_64-apic-add-clockevents-functions.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add the clock event functions to apic.c. Still unused, but setup of
the factors integrated into the calibration code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 arch/x86_64/Kconfig       |    6 +++
 arch/x86_64/kernel/apic.c |   79 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+)

Index: linux-2.6.22-rc6-mm/arch/x86_64/Kconfig
===================================================================
--- linux-2.6.22-rc6-mm.orig/arch/x86_64/Kconfig	2007-07-15 17:30:43.000000000 +0200
+++ linux-2.6.22-rc6-mm/arch/x86_64/Kconfig	2007-07-15 17:48:54.000000000 +0200
@@ -28,6 +28,10 @@ config GENERIC_TIME
 	bool
 	default y
 
+config GENERIC_CLOCKEVENTS_MIGR
+	bool
+	default y
+
 config GENERIC_TIME_VSYSCALL
 	bool
 	default y
@@ -138,6 +142,8 @@ source "init/Kconfig"
 
 menu "Processor type and features"
 
+source "kernel/time/Kconfig"
+
 choice
 	prompt "Subarchitecture Type"
 	default X86_PC
Index: linux-2.6.22-rc6-mm/arch/x86_64/kernel/apic.c
===================================================================
--- linux-2.6.22-rc6-mm.orig/arch/x86_64/kernel/apic.c	2007-07-15 17:42:19.000000000 +0200
+++ linux-2.6.22-rc6-mm/arch/x86_64/kernel/apic.c	2007-07-15 17:48:54.000000000 +0200
@@ -25,6 +25,7 @@
 #include <linux/sysdev.h>
 #include <linux/module.h>
 #include <linux/ioport.h>
+#include <linux/clockchips.h>
 
 #include <asm/atomic.h>
 #include <asm/smp.h>
@@ -58,6 +59,77 @@ static struct resource lapic_resource = 
 
 static unsigned int calibration_result;
 
+static int lapic_next_event(unsigned long delta,
+			    struct clock_event_device *evt);
+static void lapic_timer_setup(enum clock_event_mode mode,
+			      struct clock_event_device *evt);
+
+static void lapic_timer_broadcast(cpumask_t mask);
+
+static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen);
+
+static struct clock_event_device lapic_clockevent = {
+	.name		= "lapic",
+	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT
+			| CLOCK_EVT_FEAT_C3STOP | CLOCK_EVT_FEAT_DUMMY,
+	.shift		= 32,
+	.set_mode	= lapic_timer_setup,
+	.set_next_event	= lapic_next_event,
+	.broadcast	= lapic_timer_broadcast,
+	.rating		= 100,
+	.irq		= -1,
+};
+static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
+
+static int lapic_next_event(unsigned long delta,
+			    struct clock_event_device *evt)
+{
+	apic_write(APIC_TMICT, delta);
+	return 0;
+}
+
+static void lapic_timer_setup(enum clock_event_mode mode,
+			      struct clock_event_device *evt)
+{
+	unsigned long flags;
+	unsigned int v;
+
+	/* Lapic used as dummy for broadcast ? */
+	if (evt->features & CLOCK_EVT_FEAT_DUMMY)
+		return;
+
+	local_irq_save(flags);
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+	case CLOCK_EVT_MODE_ONESHOT:
+		__setup_APIC_LVTT(calibration_result,
+				  mode != CLOCK_EVT_MODE_PERIODIC, 1);
+		break;
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		v = apic_read(APIC_LVTT);
+		v |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
+		apic_write(APIC_LVTT, v);
+		break;
+	case CLOCK_EVT_MODE_RESUME:
+		/* Nothing to do here */
+		break;
+	}
+
+	local_irq_restore(flags);
+}
+
+/*
+ * Local APIC timer broadcast function
+ */
+static void lapic_timer_broadcast(cpumask_t mask)
+{
+#ifdef CONFIG_SMP
+	send_IPI_mask(mask, LOCAL_TIMER_VECTOR);
+#endif
+}
+
 /*
  * cpu_mask that denotes the CPUs that needs timer interrupt coming in as
  * IPIs in place of local APIC timers
@@ -867,6 +939,13 @@ static void __init calibrate_APIC_clock(
 	printk(KERN_INFO "Detected %d.%03d MHz APIC timer.\n",
 		result / 1000 / 1000, result / 1000 % 1000);
 
+	/* Calculate the scaled math multiplication factor */
+	lapic_clockevent.mult = div_sc(result, NSEC_PER_SEC, 32);
+	lapic_clockevent.max_delta_ns =
+		clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
+	lapic_clockevent.min_delta_ns =
+		clockevent_delta2ns(0xF, &lapic_clockevent);
+
 	calibration_result = result / HZ;
 }
 

-- 

