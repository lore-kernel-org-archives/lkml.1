Return-Path: <linux-kernel-owner+w=401wt.eu-S1756357AbXD2LDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbXD2LDt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 07:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755126AbXD2LBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 07:01:21 -0400
Received: from mx1.suse.de ([195.135.220.2]:52054 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755127AbXD2KxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:53:01 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [12/48] x86: Log reason why TSC was marked unstable
Message-Id: <20070429105300.6739D151CA@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:53:00 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: john stultz <johnstul@us.ibm.com>

Change mark_tsc_unstable() so it takes a string argument, which holds the
reason the TSC was marked unstable.

This is then displayed the first time mark_tsc_unstable is called.

This should help us better debug why the TSC was marked unstable on certain
systems and allow us to make sure we're not being overly paranoid when
throwing out this troublesome clocksource.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/cpu/cyrix.c                |    2 +-
 arch/i386/kernel/tsc.c                      |    5 +++--
 arch/x86_64/kernel/time.c                   |    2 +-
 arch/x86_64/kernel/tsc.c                    |    5 +++--
 arch/x86_64/kernel/tsc_sync.c               |    2 +-
 drivers/acpi/processor_idle.c               |    4 ++--
 include/asm-i386/mach-summit/mach_mpparse.h |    4 ++--
 include/asm-i386/tsc.h                      |    2 +-
 include/asm-x86_64/timex.h                  |    2 +-
 9 files changed, 15 insertions(+), 13 deletions(-)

Index: linux/arch/i386/kernel/cpu/cyrix.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/cyrix.c
+++ linux/arch/i386/kernel/cpu/cyrix.c
@@ -279,7 +279,7 @@ static void __cpuinit init_cyrix(struct 
 		 */  
 		if (vendor == PCI_VENDOR_ID_CYRIX &&
 	 (device == PCI_DEVICE_ID_CYRIX_5510 || device == PCI_DEVICE_ID_CYRIX_5520))
-			mark_tsc_unstable();
+			mark_tsc_unstable("cyrix 5510/5520 detected");
 	}
 #endif
 		c->x86_cache_size=16;	/* Yep 16K integrated cache thats it */
Index: linux/arch/i386/kernel/tsc.c
===================================================================
--- linux.orig/arch/i386/kernel/tsc.c
+++ linux/arch/i386/kernel/tsc.c
@@ -172,7 +172,7 @@ time_cpufreq_notifier(struct notifier_bl
 						ref_freq, freq->new);
 			if (!(freq->flags & CPUFREQ_CONST_LOOPS)) {
 				tsc_khz = cpu_khz;
-				mark_tsc_unstable();
+				mark_tsc_unstable("cpufreq changes");
 			}
 		}
 	}
@@ -220,11 +220,12 @@ static struct clocksource clocksource_ts
 				  CLOCK_SOURCE_MUST_VERIFY,
 };
 
-void mark_tsc_unstable(void)
+void mark_tsc_unstable(char *reason)
 {
 	if (!tsc_unstable) {
 		tsc_unstable = 1;
 		tsc_enabled = 0;
+		printk("Marking TSC unstable due to: %s.\n", reason);
 		/* Can be called before registration */
 		if (clocksource_tsc.mult)
 			clocksource_change_rating(&clocksource_tsc, 0);
Index: linux/arch/x86_64/kernel/time.c
===================================================================
--- linux.orig/arch/x86_64/kernel/time.c
+++ linux/arch/x86_64/kernel/time.c
@@ -397,7 +397,7 @@ void __init time_init(void)
 		cpu_khz = tsc_calibrate_cpu_khz();
 
 	if (unsynchronized_tsc())
-		mark_tsc_unstable();
+		mark_tsc_unstable("TSCs unsynchronized");
 
 	if (cpu_has(&boot_cpu_data, X86_FEATURE_RDTSCP))
 		vgetcpu_mode = VGETCPU_RDTSCP;
Index: linux/arch/x86_64/kernel/tsc.c
===================================================================
--- linux.orig/arch/x86_64/kernel/tsc.c
+++ linux/arch/x86_64/kernel/tsc.c
@@ -85,7 +85,7 @@ static int time_cpufreq_notifier(struct 
 
 		tsc_khz = cpufreq_scale(tsc_khz_ref, ref_freq, freq->new);
 		if (!(freq->flags & CPUFREQ_CONST_LOOPS))
-			mark_tsc_unstable();
+			mark_tsc_unstable("cpufreq changes");
 	}
 
 	return 0;
@@ -171,10 +171,11 @@ static struct clocksource clocksource_ts
 	.vread			= vread_tsc,
 };
 
-void mark_tsc_unstable(void)
+void mark_tsc_unstable(char *reason)
 {
 	if (!tsc_unstable) {
 		tsc_unstable = 1;
+		printk("Marking TSC unstable due to %s\n", reason);
 		/* Change only the rating, when not registered */
 		if (clocksource_tsc.mult)
 			clocksource_change_rating(&clocksource_tsc, 0);
Index: linux/arch/x86_64/kernel/tsc_sync.c
===================================================================
--- linux.orig/arch/x86_64/kernel/tsc_sync.c
+++ linux/arch/x86_64/kernel/tsc_sync.c
@@ -138,7 +138,7 @@ void __cpuinit check_tsc_sync_source(int
 		printk("\n");
 		printk(KERN_WARNING "Measured %Ld cycles TSC warp between CPUs,"
 				    " turning off TSC clock.\n", max_warp);
-		mark_tsc_unstable();
+		mark_tsc_unstable("check_tsc_sync_source failed");
 		nr_warps = 0;
 		max_warp = 0;
 		last_tsc = 0;
Index: linux/drivers/acpi/processor_idle.c
===================================================================
--- linux.orig/drivers/acpi/processor_idle.c
+++ linux/drivers/acpi/processor_idle.c
@@ -483,7 +483,7 @@ static void acpi_processor_idle(void)
 
 #ifdef CONFIG_GENERIC_TIME
 		/* TSC halts in C2, so notify users */
-		mark_tsc_unstable();
+		mark_tsc_unstable("possible TSC halt in C2");
 #endif
 		/* Re-enable interrupts */
 		local_irq_enable();
@@ -525,7 +525,7 @@ static void acpi_processor_idle(void)
 
 #ifdef CONFIG_GENERIC_TIME
 		/* TSC halts in C3, so notify users */
-		mark_tsc_unstable();
+		mark_tsc_unstable("TSC halts in C3");
 #endif
 		/* Re-enable interrupts */
 		local_irq_enable();
Index: linux/include/asm-i386/mach-summit/mach_mpparse.h
===================================================================
--- linux.orig/include/asm-i386/mach-summit/mach_mpparse.h
+++ linux/include/asm-i386/mach-summit/mach_mpparse.h
@@ -30,7 +30,7 @@ static inline int mps_oem_check(struct m
 			(!strncmp(productid, "VIGIL SMP", 9) 
 			 || !strncmp(productid, "EXA", 3)
 			 || !strncmp(productid, "RUTHLESS SMP", 12))){
-		mark_tsc_unstable();
+		mark_tsc_unstable("Summit based system");
 		use_cyclone = 1; /*enable cyclone-timer*/
 		setup_summit();
 		return 1;
@@ -44,7 +44,7 @@ static inline int acpi_madt_oem_check(ch
 	if (!strncmp(oem_id, "IBM", 3) &&
 	    (!strncmp(oem_table_id, "SERVIGIL", 8)
 	     || !strncmp(oem_table_id, "EXA", 3))){
-		mark_tsc_unstable();
+		mark_tsc_unstable("Summit based system");
 		use_cyclone = 1; /*enable cyclone-timer*/
 		setup_summit();
 		return 1;
Index: linux/include/asm-i386/tsc.h
===================================================================
--- linux.orig/include/asm-i386/tsc.h
+++ linux/include/asm-i386/tsc.h
@@ -53,7 +53,7 @@ static __always_inline cycles_t get_cycl
 }
 
 extern void tsc_init(void);
-extern void mark_tsc_unstable(void);
+extern void mark_tsc_unstable(char *reason);
 extern int unsynchronized_tsc(void);
 extern void init_tsc_clocksource(void);
 
Index: linux/include/asm-x86_64/timex.h
===================================================================
--- linux.orig/include/asm-x86_64/timex.h
+++ linux/include/asm-x86_64/timex.h
@@ -27,5 +27,5 @@ extern int read_current_timer(unsigned l
 #define NS_SCALE        10 /* 2^10, carefully chosen */
 #define US_SCALE        32 /* 2^32, arbitralrily chosen */
 
-extern void mark_tsc_unstable(void);
+extern void mark_tsc_unstable(char *);
 #endif
