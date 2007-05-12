Return-Path: <linux-kernel-owner+w=401wt.eu-S1759612AbXELPpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612AbXELPpW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 11:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754970AbXELPpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 11:45:10 -0400
Received: from ns2.mvista.com ([63.81.120.158]:38036 "EHLO
	localhost.localdomain" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754887AbXELPpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 11:45:08 -0400
Message-Id: <20070512154344.395866578@mvista.com>
User-Agent: quilt/0.46-1
Date: Sat, 12 May 2007 08:43:45 -0700
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com, mingo@elte.hu, ak@suse.de
Content-Disposition: inline; filename=mark-tsc-unstable-reasons.patch
Subject: [PATCH 1/2] non-string based tsc unstable reasons
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just passing a string to mark_tsc_unstable() doesn't allow real code to change
based on the reason for the instablility. I changed mark_tsc_unstable()
to accept a string and a flag which denotes a general reason why the tsc
is unstable, and can be evaluated in code.

This is based off John Stultz patch to add the string reasons.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 arch/i386/kernel/cpu/cyrix.c                |    9 ++++--
 arch/i386/kernel/tsc.c                      |   39 +++++++++++++++++-----------
 arch/x86_64/kernel/time.c                   |    3 +-
 arch/x86_64/kernel/tsc.c                    |   28 +++++++++++++-------
 arch/x86_64/kernel/tsc_sync.c               |    3 +-
 drivers/acpi/processor_idle.c               |    6 ++--
 include/asm-i386/mach-summit/mach_mpparse.h |    5 ++-
 include/asm-i386/tsc.h                      |   13 ++++++++-
 include/asm-x86_64/timex.h                  |    1 
 9 files changed, 73 insertions(+), 34 deletions(-)

Index: linux-2.6.21/arch/i386/kernel/cpu/cyrix.c
===================================================================
--- linux-2.6.21.orig/arch/i386/kernel/cpu/cyrix.c
+++ linux-2.6.21/arch/i386/kernel/cpu/cyrix.c
@@ -275,11 +275,14 @@ static void __cpuinit init_cyrix(struct 
 		device = read_pci_config_16(0, 0, 0x12, PCI_DEVICE_ID);
 
 		/*
-		 *  The 5510/5520 companion chips have a funky PIT.
+		 *  The 5510/5520 companion chips have a funky PIT
+		 *  and an unstable TSC.
 		 */  
 		if (vendor == PCI_VENDOR_ID_CYRIX &&
-	 (device == PCI_DEVICE_ID_CYRIX_5510 || device == PCI_DEVICE_ID_CYRIX_5520))
-			pit_latch_buggy = 1;
+		    (device == PCI_DEVICE_ID_CYRIX_5510 ||
+		     device == PCI_DEVICE_ID_CYRIX_5520))
+			mark_tsc_unstable(CLOCK_TSC_UNSTABLE_FREQUENCY,
+					  "cyrix 5510/5520 detected");
 	}
 #endif
 		c->x86_cache_size=16;	/* Yep 16K integrated cache thats it */
Index: linux-2.6.21/arch/i386/kernel/tsc.c
===================================================================
--- linux-2.6.21.orig/arch/i386/kernel/tsc.c
+++ linux-2.6.21/arch/i386/kernel/tsc.c
@@ -233,7 +233,8 @@ time_cpufreq_notifier(struct notifier_bl
 				 * TSC based sched_clock turns
 				 * to junk w/ cpufreq
 				 */
-				mark_tsc_unstable();
+				mark_tsc_unstable(CLOCK_TSC_CPUFREQ_ADJUSTED,
+						  "cpufreq changes");
 			}
 		}
 	}
@@ -281,25 +282,34 @@ static struct clocksource clocksource_ts
 				  CLOCK_SOURCE_MUST_VERIFY,
 };
 
-void mark_tsc_unstable(void)
+void mark_tsc_unstable(enum tsc_unstable_flags flag, char *reason)
 {
-	if (!tsc_unstable) {
-		tsc_unstable = 1;
-		tsc_enabled = 0;
-		/* Can be called before registration */
-		if (clocksource_tsc.mult)
-			clocksource_change_rating(&clocksource_tsc, 0);
-		else
-			clocksource_tsc.rating = 0;
+	if (likely(tsc_unstable))
+		return;
+
+	switch (flag) {
+		case CLOCK_TSC_UNSTABLE_FREQUENCY:
+		case CLOCK_TSC_HALTS_IN_CSTATES:
+
+		case CLOCK_TSC_UNSYNCHRONIZED:
+		case CLOCK_TSC_CPUFREQ_ADJUSTED:
+			tsc_unstable = 1;
+			tsc_enabled = 0;
+			printk("Marking TSC unstable due to: %s.\n", reason);
+			/* Can be called before registration */
+			if (clocksource_tsc.mult)
+				clocksource_change_rating(&clocksource_tsc, 0);
+			else
+				clocksource_tsc.rating = 0;
 	}
 }
 EXPORT_SYMBOL_GPL(mark_tsc_unstable);
 
 static int __init dmi_mark_tsc_unstable(struct dmi_system_id *d)
 {
-	printk(KERN_NOTICE "%s detected: marking TSC unstable.\n",
-		       d->ident);
-	tsc_unstable = 1;
+
+	mark_tsc_unstable(CLOCK_TSC_UNSTABLE_FREQUENCY, (char*)d->ident);
+
 	return 0;
 }
 
@@ -331,7 +341,8 @@ __cpuinit int unsynchronized_tsc(void)
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL) {
 		/* assume multi socket systems are not synchronized: */
 		if (num_possible_cpus() > 1)
-			tsc_unstable = 1;
+			mark_tsc_unstable(CLOCK_TSC_UNSYNCHRONIZED,
+					  "Non-Intel SMP system");
 	}
 	return tsc_unstable;
 }
Index: linux-2.6.21/arch/x86_64/kernel/time.c
===================================================================
--- linux-2.6.21.orig/arch/x86_64/kernel/time.c
+++ linux-2.6.21/arch/x86_64/kernel/time.c
@@ -348,7 +348,8 @@ void __init time_init(void)
 	}
 
 	if (unsynchronized_tsc())
-		mark_tsc_unstable();
+		mark_tsc_unstable(CLOCK_TSC_UNSYNCHRONIZED,
+				  "TSCs unsynchronized");
 
 	if (cpu_has(&boot_cpu_data, X86_FEATURE_RDTSCP))
 		vgetcpu_mode = VGETCPU_RDTSCP;
Index: linux-2.6.21/arch/x86_64/kernel/tsc.c
===================================================================
--- linux-2.6.21.orig/arch/x86_64/kernel/tsc.c
+++ linux-2.6.21/arch/x86_64/kernel/tsc.c
@@ -109,7 +109,8 @@ static int time_cpufreq_notifier(struct 
 
 		cpu_khz = cpufreq_scale(cpu_khz_ref, ref_freq, freq->new);
 		if (!(freq->flags & CPUFREQ_CONST_LOOPS))
-			mark_tsc_unstable();
+			mark_tsc_unstable(CLOCK_TSC_CPUFREQ_ADJUSTED,
+					  "cpufreq changes");
 	}
 
 	set_cyc2ns_scale(cpu_khz_ref);
@@ -197,15 +198,24 @@ static struct clocksource clocksource_ts
 	.vread			= vread_tsc,
 };
 
-void mark_tsc_unstable(void)
+void mark_tsc_unstable(enum tsc_unstable_flags flag, char *reason)
 {
-	if (!tsc_unstable) {
-		tsc_unstable = 1;
-		/* Change only the rating, when not registered */
-		if (clocksource_tsc.mult)
-			clocksource_change_rating(&clocksource_tsc, 0);
-		else
-			clocksource_tsc.rating = 0;
+	if (likely(tsc_unstable))
+		return;
+
+	switch (flag) {
+		case CLOCK_TSC_UNSTABLE_FREQUENCY:
+		case CLOCK_TSC_HALTS_IN_CSTATES:
+
+		case CLOCK_TSC_UNSYNCHRONIZED:
+		case CLOCK_TSC_CPUFREQ_ADJUSTED:
+			tsc_unstable = 1;
+			printk("Marking TSC unstable due to: %s.\n", reason);
+			/* Can be called before registration */
+			if (clocksource_tsc.mult)
+				clocksource_change_rating(&clocksource_tsc, 0);
+			else
+				clocksource_tsc.rating = 0;
 	}
 }
 EXPORT_SYMBOL_GPL(mark_tsc_unstable);
Index: linux-2.6.21/arch/x86_64/kernel/tsc_sync.c
===================================================================
--- linux-2.6.21.orig/arch/x86_64/kernel/tsc_sync.c
+++ linux-2.6.21/arch/x86_64/kernel/tsc_sync.c
@@ -138,7 +138,8 @@ void __cpuinit check_tsc_sync_source(int
 		printk("\n");
 		printk(KERN_WARNING "Measured %Ld cycles TSC warp between CPUs,"
 				    " turning off TSC clock.\n", max_warp);
-		mark_tsc_unstable();
+		mark_tsc_unstable(CLOCK_TSC_UNSTABLE_FREQUENCY,
+				  "check_tsc_sync_source failed");
 		nr_warps = 0;
 		max_warp = 0;
 		last_tsc = 0;
Index: linux-2.6.21/drivers/acpi/processor_idle.c
===================================================================
--- linux-2.6.21.orig/drivers/acpi/processor_idle.c
+++ linux-2.6.21/drivers/acpi/processor_idle.c
@@ -483,7 +483,8 @@ static void acpi_processor_idle(void)
 
 #ifdef CONFIG_GENERIC_TIME
 		/* TSC halts in C2, so notify users */
-		mark_tsc_unstable();
+		mark_tsc_unstable(CLOCK_TSC_HALTS_IN_CSTATES,
+				  "possible TSC halt in C2");
 #endif
 		/* Re-enable interrupts */
 		local_irq_enable();
@@ -525,7 +526,8 @@ static void acpi_processor_idle(void)
 
 #ifdef CONFIG_GENERIC_TIME
 		/* TSC halts in C3, so notify users */
-		mark_tsc_unstable();
+		mark_tsc_unstable(CLOCK_TSC_HALTS_IN_CSTATES,
+				  "TSC halts in C3");
 #endif
 		/* Re-enable interrupts */
 		local_irq_enable();
Index: linux-2.6.21/include/asm-i386/mach-summit/mach_mpparse.h
===================================================================
--- linux-2.6.21.orig/include/asm-i386/mach-summit/mach_mpparse.h
+++ linux-2.6.21/include/asm-i386/mach-summit/mach_mpparse.h
@@ -30,7 +30,8 @@ static inline int mps_oem_check(struct m
 			(!strncmp(productid, "VIGIL SMP", 9) 
 			 || !strncmp(productid, "EXA", 3)
 			 || !strncmp(productid, "RUTHLESS SMP", 12))){
-		mark_tsc_unstable();
+		mark_tsc_unstable(CLOCK_TSC_UNSYNCHRONIZED,
+				  "Summit based system");
 		use_cyclone = 1; /*enable cyclone-timer*/
 		setup_summit();
 		return 1;
@@ -44,7 +45,7 @@ static inline int acpi_madt_oem_check(ch
 	if (!strncmp(oem_id, "IBM", 3) &&
 	    (!strncmp(oem_table_id, "SERVIGIL", 8)
 	     || !strncmp(oem_table_id, "EXA", 3))){
-		mark_tsc_unstable();
+		mark_tsc_unstable("Summit based system");
 		use_cyclone = 1; /*enable cyclone-timer*/
 		setup_summit();
 		return 1;
Index: linux-2.6.21/include/asm-i386/tsc.h
===================================================================
--- linux-2.6.21.orig/include/asm-i386/tsc.h
+++ linux-2.6.21/include/asm-i386/tsc.h
@@ -52,8 +52,19 @@ static __always_inline cycles_t get_cycl
 	return ret;
 }
 
+/*
+ * These are the known reason why a TSC would be flaged
+ * as unstable.
+ */
+enum tsc_unstable_flags {
+	CLOCK_TSC_UNSTABLE_FREQUENCY = 0,
+	CLOCK_TSC_CPUFREQ_ADJUSTED,
+	CLOCK_TSC_UNSYNCHRONIZED,
+	CLOCK_TSC_HALTS_IN_CSTATES,
+};
+extern void mark_tsc_unstable(enum tsc_unstable_flags flag, char *reason);
+
 extern void tsc_init(void);
-extern void mark_tsc_unstable(void);
 extern int unsynchronized_tsc(void);
 extern void init_tsc_clocksource(void);
 
Index: linux-2.6.21/include/asm-x86_64/timex.h
===================================================================
--- linux-2.6.21.orig/include/asm-x86_64/timex.h
+++ linux-2.6.21/include/asm-x86_64/timex.h
@@ -27,6 +27,5 @@ extern int read_current_timer(unsigned l
 #define NS_SCALE        10 /* 2^10, carefully chosen */
 #define US_SCALE        32 /* 2^32, arbitralrily chosen */
 
-extern void mark_tsc_unstable(void);
 extern void set_cyc2ns_scale(unsigned long khz);
 #endif

-- 
