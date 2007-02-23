Return-Path: <linux-kernel-owner+w=401wt.eu-S1752107AbXBWBYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbXBWBYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 20:24:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbXBWBYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 20:24:11 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:60209 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbXBWBYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 20:24:10 -0500
Subject: [PATCH -mm] Log reason why TSC was marked unstable
From: john stultz <johnstul@us.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@mvista.com>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 17:24:06 -0800
Message-Id: <1172193846.5422.43.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes mark_tsc_unstable() so it takes a string argument,
which holds the reason the TSC was marked unstable. 

This is then displayed the first time mark_tsc_unstable is called.

This should help us better debug why the TSC was marked unstable on
certain systems and allow us to make sure we're not being overly
paranoid when throwing out this troublesome clocksource.

thanks
-john

 arch/i386/kernel/tsc.c                      |    5 +++--
 arch/x86_64/kernel/time.c                   |    2 +-
 arch/x86_64/kernel/tsc.c                    |    5 +++--
 arch/x86_64/kernel/tsc_sync.c               |    2 +-
 drivers/acpi/processor_idle.c               |    4 ++--
 include/asm-i386/mach-summit/mach_mpparse.h |    4 ++--
 include/asm-x86_64/timex.h                  |    2 +-
 include/asm-x86_64/tsc.h                    |    2 +-
 8 files changed, 14 insertions(+), 12 deletions(-)

linux-2.6.21-rc1_mark-unstable-reason_C7.patch
============================================
diff --git a/arch/i386/kernel/tsc.c b/arch/i386/kernel/tsc.c
index 3082a41..c276575 100644
--- a/arch/i386/kernel/tsc.c
+++ b/arch/i386/kernel/tsc.c
@@ -262,7 +262,7 @@ time_cpufreq_notifier(struct notifier_bl
 				 * TSC based sched_clock turns
 				 * to junk w/ cpufreq
 				 */
-				mark_tsc_unstable();
+				mark_tsc_unstable("cpufreq changes");
 			}
 		}
 	}
@@ -310,10 +310,11 @@ static struct clocksource clocksource_ts
 				  CLOCK_SOURCE_MUST_VERIFY,
 };
 
-void mark_tsc_unstable(void)
+void mark_tsc_unstable(char *reason)
 {
 	if (!tsc_unstable) {
 		tsc_unstable = 1;
+		printk("Marking TSC unstable due to: %s.\n", reason);
 		/* Can be called before registration */
 		if (clocksource_tsc.mult)
 			clocksource_change_rating(&clocksource_tsc, 0);
diff --git a/arch/x86_64/kernel/time.c b/arch/x86_64/kernel/time.c
index c9addcf..b05bb3c 100644
--- a/arch/x86_64/kernel/time.c
+++ b/arch/x86_64/kernel/time.c
@@ -348,7 +348,7 @@ void __init time_init(void)
 	}
 
 	if (unsynchronized_tsc())
-		mark_tsc_unstable();
+		mark_tsc_unstable("TSCs unsynchronized");
 
 	if (cpu_has(&boot_cpu_data, X86_FEATURE_RDTSCP))
 		vgetcpu_mode = VGETCPU_RDTSCP;
diff --git a/arch/x86_64/kernel/tsc.c b/arch/x86_64/kernel/tsc.c
index 8958318..d8e5f06 100644
--- a/arch/x86_64/kernel/tsc.c
+++ b/arch/x86_64/kernel/tsc.c
@@ -109,7 +109,7 @@ #endif
 
 		cpu_khz = cpufreq_scale(cpu_khz_ref, ref_freq, freq->new);
 		if (!(freq->flags & CPUFREQ_CONST_LOOPS))
-			mark_tsc_unstable();
+			mark_tsc_unstable("cpufreq changes");
 	}
 
 	set_cyc2ns_scale(cpu_khz_ref);
@@ -197,10 +197,11 @@ static struct clocksource clocksource_ts
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
diff --git a/arch/x86_64/kernel/tsc_sync.c b/arch/x86_64/kernel/tsc_sync.c
index 014f0db..fe571fb 100644
--- a/arch/x86_64/kernel/tsc_sync.c
+++ b/arch/x86_64/kernel/tsc_sync.c
@@ -138,7 +138,7 @@ void __cpuinit check_tsc_sync_source(int
 		printk("\n");
 		printk(KERN_WARNING "Measured %Ld cycles TSC warp between CPUs,"
 				    " turning off TSC clock.\n", max_warp);
-		mark_tsc_unstable();
+		mark_tsc_unstable("check_tsc_sync_source failed");
 		nr_warps = 0;
 		max_warp = 0;
 		last_tsc = 0;
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 6077300..44b7836 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -482,7 +482,7 @@ #endif
 
 #ifdef CONFIG_GENERIC_TIME
 		/* TSC halts in C2, so notify users */
-		mark_tsc_unstable();
+		mark_tsc_unstable("possible TSC halt in C2");
 #endif
 		/* Re-enable interrupts */
 		local_irq_enable();
@@ -524,7 +524,7 @@ #endif
 
 #ifdef CONFIG_GENERIC_TIME
 		/* TSC halts in C3, so notify users */
-		mark_tsc_unstable();
+		mark_tsc_unstable("TSC halts in C3");
 #endif
 		/* Re-enable interrupts */
 		local_irq_enable();
diff --git a/include/asm-i386/mach-summit/mach_mpparse.h b/include/asm-i386/mach-summit/mach_mpparse.h
index 9426839..c252053 100644
--- a/include/asm-i386/mach-summit/mach_mpparse.h
+++ b/include/asm-i386/mach-summit/mach_mpparse.h
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
diff --git a/include/asm-x86_64/timex.h b/include/asm-x86_64/timex.h
index 8c6808a..326dd42 100644
--- a/include/asm-x86_64/timex.h
+++ b/include/asm-x86_64/timex.h
@@ -27,6 +27,6 @@ #define FSEC_PER_TICK (FSEC_PER_SEC / HZ
 #define NS_SCALE        10 /* 2^10, carefully chosen */
 #define US_SCALE        32 /* 2^32, arbitralrily chosen */
 
-extern void mark_tsc_unstable(void);
+extern void mark_tsc_unstable(char*);
 extern void set_cyc2ns_scale(unsigned long khz);
 #endif
diff --git a/include/asm-x86_64/tsc.h b/include/asm-x86_64/tsc.h
index 9a0a368..49b8bdf 100644
--- a/include/asm-x86_64/tsc.h
+++ b/include/asm-x86_64/tsc.h
@@ -53,7 +53,7 @@ #endif
 }
 
 extern void tsc_init(void);
-extern void mark_tsc_unstable(void);
+extern void mark_tsc_unstable(char*);
 extern int unsynchronized_tsc(void);
 
 /*


