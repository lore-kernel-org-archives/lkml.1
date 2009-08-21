Return-Path: <linux-kernel-owner+w=401wt.eu-S933028AbZHUVdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933028AbZHUVdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932986AbZHUVdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:33:50 -0400
Received: from www.tglx.de ([62.245.132.106]:51985 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932828AbZHUVdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:33:47 -0400
Message-Id: <20090821205603.122053372@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:31:55 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 27/32] x86: Move calibrate_cpu to tsc.c
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline; filename=x86-move-calibrate-cpu-to-tsc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the code where it's only user is. Also we need to look whether
this hardwired hackery might interfere with perfcounters.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/time.h |    2 -
 arch/x86/kernel/time_32.c   |    1 
 arch/x86/kernel/time_64.c   |   51 ---------------------------------------
 arch/x86/kernel/tsc.c       |   57 ++++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 55 insertions(+), 56 deletions(-)

Index: linux-2.6/arch/x86/include/asm/time.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/time.h
+++ linux-2.6/arch/x86/include/asm/time.h
@@ -57,6 +57,4 @@ extern void time_init(void);
 
 #endif /* CONFIG_PARAVIRT */
 
-extern unsigned long __init calibrate_cpu(void);
-
 #endif /* _ASM_X86_TIME_H */
Index: linux-2.6/arch/x86/kernel/time_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/time_32.c
+++ linux-2.6/arch/x86/kernel/time_32.c
@@ -20,7 +20,6 @@
 #include <asm/timer.h>
 #include <asm/hpet.h>
 #include <asm/time.h>
-#include <asm/nmi.h>
 
 #if defined(CONFIG_X86_32) && defined(CONFIG_X86_IO_APIC)
 int timer_ack;
Index: linux-2.6/arch/x86/kernel/time_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/time_64.c
+++ linux-2.6/arch/x86/kernel/time_64.c
@@ -20,7 +20,6 @@
 #include <asm/timer.h>
 #include <asm/hpet.h>
 #include <asm/time.h>
-#include <asm/nmi.h>
 
 #if defined(CONFIG_X86_32) && defined(CONFIG_X86_IO_APIC)
 int timer_ack;
@@ -83,56 +82,6 @@ static irqreturn_t timer_interrupt(int i
 	return IRQ_HANDLED;
 }
 
-/*
- * calibrate_cpu is used on systems with fixed rate TSCs to determine
- * processor frequency
- */
-#define TICK_COUNT 100000000
-unsigned long __init calibrate_cpu(void)
-{
-	int tsc_start, tsc_now;
-	int i, no_ctr_free;
-	unsigned long evntsel3 = 0, pmc3 = 0, pmc_now = 0;
-	unsigned long flags;
-
-	for (i = 0; i < 4; i++)
-		if (avail_to_resrv_perfctr_nmi_bit(i))
-			break;
-	no_ctr_free = (i == 4);
-	if (no_ctr_free) {
-		WARN(1, KERN_WARNING "Warning: AMD perfctrs busy ... "
-		     "cpu_khz value may be incorrect.\n");
-		i = 3;
-		rdmsrl(MSR_K7_EVNTSEL3, evntsel3);
-		wrmsrl(MSR_K7_EVNTSEL3, 0);
-		rdmsrl(MSR_K7_PERFCTR3, pmc3);
-	} else {
-		reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i);
-		reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
-	}
-	local_irq_save(flags);
-	/* start measuring cycles, incrementing from 0 */
-	wrmsrl(MSR_K7_PERFCTR0 + i, 0);
-	wrmsrl(MSR_K7_EVNTSEL0 + i, 1 << 22 | 3 << 16 | 0x76);
-	rdtscl(tsc_start);
-	do {
-		rdmsrl(MSR_K7_PERFCTR0 + i, pmc_now);
-		tsc_now = get_cycles();
-	} while ((tsc_now - tsc_start) < TICK_COUNT);
-
-	local_irq_restore(flags);
-	if (no_ctr_free) {
-		wrmsrl(MSR_K7_EVNTSEL3, 0);
-		wrmsrl(MSR_K7_PERFCTR3, pmc3);
-		wrmsrl(MSR_K7_EVNTSEL3, evntsel3);
-	} else {
-		release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
-		release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
-	}
-
-	return pmc_now * tsc_khz / (tsc_now - tsc_start);
-}
-
 static struct irqaction irq0  = {
 	.handler = timer_interrupt,
 	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL | IRQF_TIMER,
Index: linux-2.6/arch/x86/kernel/tsc.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/tsc.c
+++ linux-2.6/arch/x86/kernel/tsc.c
@@ -17,6 +17,7 @@
 #include <asm/time.h>
 #include <asm/delay.h>
 #include <asm/hypervisor.h>
+#include <asm/nmi.h>
 
 unsigned int __read_mostly cpu_khz;	/* TSC clocks / usec, not used here */
 EXPORT_SYMBOL(cpu_khz);
@@ -852,6 +853,60 @@ static void __init init_tsc_clocksource(
 	clocksource_register(&clocksource_tsc);
 }
 
+#ifdef CONFIG_X86_64
+/*
+ * calibrate_cpu is used on systems with fixed rate TSCs to determine
+ * processor frequency
+ */
+#define TICK_COUNT 100000000
+static unsigned long __init calibrate_cpu(void)
+{
+	int tsc_start, tsc_now;
+	int i, no_ctr_free;
+	unsigned long evntsel3 = 0, pmc3 = 0, pmc_now = 0;
+	unsigned long flags;
+
+	for (i = 0; i < 4; i++)
+		if (avail_to_resrv_perfctr_nmi_bit(i))
+			break;
+	no_ctr_free = (i == 4);
+	if (no_ctr_free) {
+		WARN(1, KERN_WARNING "Warning: AMD perfctrs busy ... "
+		     "cpu_khz value may be incorrect.\n");
+		i = 3;
+		rdmsrl(MSR_K7_EVNTSEL3, evntsel3);
+		wrmsrl(MSR_K7_EVNTSEL3, 0);
+		rdmsrl(MSR_K7_PERFCTR3, pmc3);
+	} else {
+		reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i);
+		reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
+	}
+	local_irq_save(flags);
+	/* start measuring cycles, incrementing from 0 */
+	wrmsrl(MSR_K7_PERFCTR0 + i, 0);
+	wrmsrl(MSR_K7_EVNTSEL0 + i, 1 << 22 | 3 << 16 | 0x76);
+	rdtscl(tsc_start);
+	do {
+		rdmsrl(MSR_K7_PERFCTR0 + i, pmc_now);
+		tsc_now = get_cycles();
+	} while ((tsc_now - tsc_start) < TICK_COUNT);
+
+	local_irq_restore(flags);
+	if (no_ctr_free) {
+		wrmsrl(MSR_K7_EVNTSEL3, 0);
+		wrmsrl(MSR_K7_PERFCTR3, pmc3);
+		wrmsrl(MSR_K7_EVNTSEL3, evntsel3);
+	} else {
+		release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
+		release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
+	}
+
+	return pmc_now * tsc_khz / (tsc_now - tsc_start);
+}
+#else
+static inline unsigned long calibrate_cpu(void) { return cpu_khz; }
+#endif
+
 void __init tsc_init(void)
 {
 	u64 lpj;
@@ -870,11 +925,9 @@ void __init tsc_init(void)
 		return;
 	}
 
-#ifdef CONFIG_X86_64
 	if (cpu_has(&boot_cpu_data, X86_FEATURE_CONSTANT_TSC) &&
 			(boot_cpu_data.x86_vendor == X86_VENDOR_AMD))
 		cpu_khz = calibrate_cpu();
-#endif
 
 	printk("Detected %lu.%03lu MHz processor.\n",
 			(unsigned long)cpu_khz / 1000,


