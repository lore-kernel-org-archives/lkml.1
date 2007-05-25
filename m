Return-Path: <linux-kernel-owner+w=401wt.eu-S1764455AbXEYTdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764455AbXEYTdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 15:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754851AbXEYTdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 15:33:07 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:38317 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754127AbXEYTdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 15:33:06 -0400
Message-Id: <20070525193209.607200255@mvista.com>
User-Agent: quilt/0.46
Date: Fri, 25 May 2007 12:32:10 -0700
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, andi@firstfloor.org
Content-Disposition: inline; filename=mark-tsc-unstable-reasons.patch
Subject: [PATCH 1/2] non-string based tsc unstable reasons
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just passing a string to mark_tsc_unstable() doesn't allow real code to change
based on the reason for the instablility. I changed mark_tsc_unstable()
to accept a string and a flag which denotes a general reason why the tsc
is unstable, and can be evaluated in code.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---

Against 2.6.22-rc2	

 arch/i386/kernel/cpu/cyrix.c                |   11 +++++---
 arch/i386/kernel/tsc.c                      |   38 ++++++++++++++++------------
 arch/x86_64/kernel/time.c                   |    3 +-
 arch/x86_64/kernel/tsc.c                    |   29 ++++++++++++++-------
 arch/x86_64/kernel/tsc_sync.c               |    3 +-
 drivers/acpi/processor_idle.c               |    6 ++--
 include/asm-i386/mach-summit/mach_mpparse.h |    6 ++--
 include/asm-i386/tsc.h                      |   13 ++++++++-
 include/asm-x86_64/timex.h                  |    1 
 9 files changed, 73 insertions(+), 37 deletions(-)

Index: linux-2.6.21/arch/i386/kernel/cpu/cyrix.c
===================================================================
--- linux-2.6.21.orig/arch/i386/kernel/cpu/cyrix.c
+++ linux-2.6.21/arch/i386/kernel/cpu/cyrix.c
@@ -274,12 +274,15 @@ static void __cpuinit init_cyrix(struct 
 		vendor = read_pci_config_16(0, 0, 0x12, PCI_VENDOR_ID);
 		device = read_pci_config_16(0, 0, 0x12, PCI_DEVICE_ID);
 
-		/*
-		 *  The 5510/5520 companion chips have a funky PIT.
+ 		/*
+		 *  The 5510/5520 companion chips have a funky PIT
+		 *  and an unstable TSC.
 		 */  
 		if (vendor == PCI_VENDOR_ID_CYRIX &&
-	 (device == PCI_DEVICE_ID_CYRIX_5510 || device == PCI_DEVICE_ID_CYRIX_5520))
-			mark_tsc_unstable("cyrix 5510/5520 detected");
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
@@ -230,7 +230,8 @@ time_cpufreq_notifier(struct notifier_bl
 				 * TSC based sched_clock turns
 				 * to junk w/ cpufreq
 				 */
-				mark_tsc_unstable("cpufreq changes");
+				mark_tsc_unstable(CLOCK_TSC_CPUFREQ_ADJUSTED,
+						  "cpufreq changes");
 			}
 		}
 	}
@@ -275,26 +276,32 @@ static struct clocksource clocksource_ts
 				  CLOCK_SOURCE_MUST_VERIFY,
 };
 
-void mark_tsc_unstable(char *reason)
+void mark_tsc_unstable(enum tsc_unstable_flags flag, char *reason)
 {
-	if (!tsc_unstable) {
-		tsc_unstable = 1;
-		tsc_enabled = 0;
-		printk("Marking TSC unstable due to: %s.\n", reason);
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
+	mark_tsc_unstable(CLOCK_TSC_UNSTABLE_FREQUENCY, (char*)d->ident);
 	return 0;
 }
 
@@ -326,7 +333,8 @@ __cpuinit int unsynchronized_tsc(void)
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
@@ -400,7 +400,8 @@ void __init time_init(void)
 		cpu_khz = tsc_calibrate_cpu_khz();
 
 	if (unsynchronized_tsc())
-		mark_tsc_unstable("TSCs unsynchronized");
+		mark_tsc_unstable(CLOCK_TSC_UNSYNCHRONIZED,
+				  "TSCs unsynchronized");
 
 	if (cpu_has(&boot_cpu_data, X86_FEATURE_RDTSCP))
 		vgetcpu_mode = VGETCPU_RDTSCP;
Index: linux-2.6.21/arch/x86_64/kernel/tsc.c
===================================================================
--- linux-2.6.21.orig/arch/x86_64/kernel/tsc.c
+++ linux-2.6.21/arch/x86_64/kernel/tsc.c
@@ -111,7 +111,8 @@ static int time_cpufreq_notifier(struct 
 
 		tsc_khz = cpufreq_scale(tsc_khz_ref, ref_freq, freq->new);
 		if (!(freq->flags & CPUFREQ_CONST_LOOPS))
-			mark_tsc_unstable("cpufreq changes");
+			mark_tsc_unstable(CLOCK_TSC_CPUFREQ_ADJUSTED,
+					  "cpufreq changes");
 	}
 
 	set_cyc2ns_scale(tsc_khz_ref);
@@ -199,16 +200,24 @@ static struct clocksource clocksource_ts
 	.vread			= vread_tsc,
 };
 
-void mark_tsc_unstable(char *reason)
+void mark_tsc_unstable(enum tsc_unstable_flags flag, char *reason)
 {
-	if (!tsc_unstable) {
-		tsc_unstable = 1;
-		printk("Marking TSC unstable due to %s\n", reason);
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
-		mark_tsc_unstable("check_tsc_sync_source failed");
+		mark_tsc_unstable(CLOCK_TSC_UNSTABLE_FREQUENCY,
+				  "check_tsc_sync_source failed");
 		nr_warps = 0;
 		max_warp = 0;
 		last_tsc = 0;
Index: linux-2.6.21/drivers/acpi/processor_idle.c
===================================================================
--- linux-2.6.21.orig/drivers/acpi/processor_idle.c
+++ linux-2.6.21/drivers/acpi/processor_idle.c
@@ -475,7 +475,8 @@ static void acpi_processor_idle(void)
 
 #ifdef CONFIG_GENERIC_TIME
 		/* TSC halts in C2, so notify users */
-		mark_tsc_unstable("possible TSC halt in C2");
+		mark_tsc_unstable(CLOCK_TSC_HALTS_IN_CSTATES,
+				  "possible TSC halt in C2");
 #endif
 		/* Re-enable interrupts */
 		local_irq_enable();
@@ -517,7 +518,8 @@ static void acpi_processor_idle(void)
 
 #ifdef CONFIG_GENERIC_TIME
 		/* TSC halts in C3, so notify users */
-		mark_tsc_unstable("TSC halts in C3");
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
-		mark_tsc_unstable("Summit based system");
+		mark_tsc_unstable(CLOCK_TSC_UNSYNCHRONIZED,
+				  "Summit based system");
 		use_cyclone = 1; /*enable cyclone-timer*/
 		setup_summit();
 		return 1;
@@ -44,7 +45,8 @@ static inline int acpi_madt_oem_check(ch
 	if (!strncmp(oem_id, "IBM", 3) &&
 	    (!strncmp(oem_table_id, "SERVIGIL", 8)
 	     || !strncmp(oem_table_id, "EXA", 3))){
-		mark_tsc_unstable("Summit based system");
+		mark_tsc_unstable(CLOCK_TSC_UNSYNCHRONIZED,
+				  "Summit based system");
 		use_cyclone = 1; /*enable cyclone-timer*/
 		setup_summit();
 		return 1;
Index: linux-2.6.21/include/asm-i386/tsc.h
===================================================================
--- linux-2.6.21.orig/include/asm-i386/tsc.h
+++ linux-2.6.21/include/asm-i386/tsc.h
@@ -59,8 +59,19 @@ static __always_inline cycles_t get_cycl
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
-extern void mark_tsc_unstable(char *reason);
 extern int unsynchronized_tsc(void);
 extern void init_tsc_clocksource(void);
 
Index: linux-2.6.21/include/asm-x86_64/timex.h
===================================================================
--- linux-2.6.21.orig/include/asm-x86_64/timex.h
+++ linux-2.6.21/include/asm-x86_64/timex.h
@@ -27,6 +27,5 @@ extern int read_current_timer(unsigned l
 #define NS_SCALE        10 /* 2^10, carefully chosen */
 #define US_SCALE        32 /* 2^32, arbitralrily chosen */
 
-extern void mark_tsc_unstable(char *msg);
 extern void set_cyc2ns_scale(unsigned long khz);
 #endif

-- 
