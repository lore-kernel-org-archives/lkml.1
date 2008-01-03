Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbYACPnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbYACPnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:43:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbYACPmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:42:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:44480 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994AbYACPmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:42:18 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103442.621670000@suse.de>
In-Reply-To: <20080103442.621670000@suse.de>
To: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH x86] [2/16] Add a counter for per cpu clocksource watchdog checks and report them in /proc/interrupts
Message-Id: <20080103154215.C793314DDB@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:42:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While infrequent it's better if all per CPU events have a counter.

Only done for x86 currently.

Cc: tglx@linutronix.de

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/irq_32.c    |    7 +++++++
 arch/x86/kernel/irq_64.c    |    7 +++++++
 include/linux/clocksource.h |    3 +++
 kernel/time/clocksource.c   |    5 +++++
 4 files changed, 22 insertions(+)

Index: linux/arch/x86/kernel/irq_32.c
===================================================================
--- linux.orig/arch/x86/kernel/irq_32.c
+++ linux/arch/x86/kernel/irq_32.c
@@ -15,6 +15,7 @@
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/delay.h>
+#include <linux/clocksource.h>
 
 #include <asm/apic.h>
 #include <asm/uaccess.h>
@@ -315,6 +316,12 @@ skip:
 				per_cpu(irq_stat,j).irq_tlb_count);
 		seq_printf(p, "  TLB shootdowns\n");
 #endif
+#ifdef CONFIG_CLOCKSOURCE_WATCHDOG
+		seq_printf(p, "CDG: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", per_cpu(clock_wdog_count,j));
+		seq_printf(p, "  Clocksource Watchdog checks\n");
+#endif
 		seq_printf(p, "TRM: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ",
Index: linux/include/linux/clocksource.h
===================================================================
--- linux.orig/include/linux/clocksource.h
+++ linux/include/linux/clocksource.h
@@ -14,6 +14,7 @@
 #include <linux/list.h>
 #include <linux/cache.h>
 #include <linux/timer.h>
+#include <linux/percpu.h>
 #include <asm/div64.h>
 #include <asm/io.h>
 
@@ -232,4 +233,6 @@ static inline void update_vsyscall_tz(vo
 }
 #endif
 
+DECLARE_PER_CPU(unsigned, clock_wdog_count);
+
 #endif /* _LINUX_CLOCKSOURCE_H */
Index: linux/kernel/time/clocksource.c
===================================================================
--- linux.orig/kernel/time/clocksource.c
+++ linux/kernel/time/clocksource.c
@@ -76,6 +76,8 @@ static DEFINE_SPINLOCK(watchdog_lock);
 static cycle_t watchdog_last;
 static unsigned long watchdog_resumed;
 
+DEFINE_PER_CPU(unsigned, clock_wdog_count);
+
 /*
  * Interval: 0.5sec Threshold: 0.0625s
  */
@@ -102,6 +104,9 @@ static void clocksource_watchdog(unsigne
 	int64_t wd_nsec, cs_nsec;
 	int resumed;
 
+	per_cpu(clock_wdog_count, get_cpu())++;
+	put_cpu();
+
 	spin_lock(&watchdog_lock);
 
 	resumed = test_and_clear_bit(0, &watchdog_resumed);
Index: linux/arch/x86/kernel/irq_64.c
===================================================================
--- linux.orig/arch/x86/kernel/irq_64.c
+++ linux/arch/x86/kernel/irq_64.c
@@ -13,6 +13,7 @@
 #include <linux/seq_file.h>
 #include <linux/module.h>
 #include <linux/delay.h>
+#include <linux/clocksource.h>
 #include <asm/uaccess.h>
 #include <asm/io_apic.h>
 #include <asm/idle.h>
@@ -139,6 +140,12 @@ skip:
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", cpu_pda(j)->irq_thermal_count);
 		seq_printf(p, "  Thermal event interrupts\n");
+#ifdef CONFIG_CLOCKSOURCE_WATCHDOG
+		seq_printf(p, "CDG: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", per_cpu(clock_wdog_count,j));
+		seq_printf(p, "  Clocksource Watchdog checks\n");
+#endif
 		seq_printf(p, "THR: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", cpu_pda(j)->irq_threshold_count);
