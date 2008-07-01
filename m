Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbYGASni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbYGASni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 14:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754469AbYGASnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 14:43:20 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:49346 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754097AbYGASnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 14:43:18 -0400
Subject: [PATCH 01/05] x86: merge sched_clock handling
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>
Cc: Dan Hecht <dhecht@vmware.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 01 Jul 2008 11:43:18 -0700
Message-Id: <1214937798.20191.30.camel@promb-2n-dhcp368.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[VMware, Inc. is providing the following patch to you under the terms of the
GPL version 2 and no later version. This patch is provided as is, with no
warranties or support. VMware disclaims all liability in connection with
the use/inability to use this patch. Any use of the attached is considered
acceptance of the above.]

From:  Alok N Kataria <akataria@vmware.com>

Move the basic global variable definitions and sched_clock handling in the
common "tsc.c" file.

 - Unify notsc kernel command line handling for 32 bit and 64bit.
 - Functional changes for 64bit.
        - "tsc_disabled" is updated if "notsc" is passed at boottime.
        - Fallback to jiffies for sched_clock, incase notsc is passed on
	  commandline.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Signed-off-by: Dan Hecht <dhecht@vmware.com>

---

 arch/x86/kernel/Makefile  |    2 +
 arch/x86/kernel/time_32.c |    3 --
 arch/x86/kernel/tsc.c     |   86 +++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/tsc_32.c  |   86 +--------------------------------------------
 arch/x86/kernel/tsc_64.c  |   67 ++++++-----------------------------
 5 files changed, 100 insertions(+), 144 deletions(-)
 create mode 100644 arch/x86/kernel/tsc.c


diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index a33513d..631141b 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -34,7 +34,7 @@ obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o
 obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o
-obj-y			+= tsc_$(BITS).o io_delay.o rtc.o
+obj-y			+= tsc_$(BITS).o io_delay.o rtc.o tsc.o
 
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline.o
 obj-y				+= process.o
diff --git a/arch/x86/kernel/time_32.c b/arch/x86/kernel/time_32.c
index 5f29f12..059ca6e 100644
--- a/arch/x86/kernel/time_32.c
+++ b/arch/x86/kernel/time_32.c
@@ -39,9 +39,6 @@
 
 #include "do_timer.h"
 
-unsigned int cpu_khz;	/* Detected as we calibrate the TSC */
-EXPORT_SYMBOL(cpu_khz);
-
 int timer_ack;
 
 unsigned long profile_pc(struct pt_regs *regs)
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
new file mode 100644
index 0000000..5d0be77
--- /dev/null
+++ b/arch/x86/kernel/tsc.c
@@ -0,0 +1,86 @@
+#include <linux/sched.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/timer.h>
+
+unsigned int cpu_khz;           /* TSC clocks / usec, not used here */
+EXPORT_SYMBOL(cpu_khz);
+unsigned int tsc_khz;
+EXPORT_SYMBOL(tsc_khz);
+
+/*
+ * TSC can be unstable due to cpufreq or due to unsynced TSCs
+ */
+int tsc_unstable;
+
+/* native_sched_clock() is called before tsc_init(), so
+   we must start with the TSC soft disabled to prevent
+   erroneous rdtsc usage on !cpu_has_tsc processors */
+int tsc_disabled = -1;
+
+/*
+ * Scheduler clock - returns current time in nanosec units.
+ */
+u64 native_sched_clock(void)
+{
+	u64 this_offset;
+
+	/*
+	 * Fall back to jiffies if there's no TSC available:
+	 * ( But note that we still use it if the TSC is marked
+	 *   unstable. We do this because unlike Time Of Day,
+	 *   the scheduler clock tolerates small errors and it's
+	 *   very important for it to be as fast as the platform
+	 *   can achive it. )
+	 */
+	if (unlikely(tsc_disabled)) {
+		/* No locking but a rare wrong value is not a big deal: */
+		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
+	}
+
+	/* read the Time Stamp Counter: */
+	rdtscll(this_offset);
+
+	/* return the value in ns */
+	return cycles_2_ns(this_offset);
+}
+
+/* We need to define a real function for sched_clock, to override the
+   weak default version */
+#ifdef CONFIG_PARAVIRT
+unsigned long long sched_clock(void)
+{
+	return paravirt_sched_clock();
+}
+#else
+unsigned long long
+sched_clock(void) __attribute__((alias("native_sched_clock")));
+#endif
+
+int check_tsc_unstable(void)
+{
+	return tsc_unstable;
+}
+EXPORT_SYMBOL_GPL(check_tsc_unstable);
+
+#ifdef CONFIG_X86_TSC
+int __init notsc_setup(char *str)
+{
+	printk(KERN_WARNING "notsc: Kernel compiled with CONFIG_X86_TSC, "
+			"cannot disable TSC completely.\n");
+	tsc_disabled = 1;
+	return 1;
+}
+#else
+/*
+ * disable flag for tsc. Takes effect by clearing the TSC cpu flag
+ * in cpu/common.c
+ */
+int __init notsc_setup(char *str)
+{
+	setup_clear_cpu_cap(X86_FEATURE_TSC);
+	return 1;
+}
+#endif
+
+__setup("notsc", notsc_setup);
diff --git a/arch/x86/kernel/tsc_32.c b/arch/x86/kernel/tsc_32.c
index 6240922..dc89900 100644
--- a/arch/x86/kernel/tsc_32.c
+++ b/arch/x86/kernel/tsc_32.c
@@ -15,52 +15,8 @@
 
 #include "mach_timer.h"
 
-/* native_sched_clock() is called before tsc_init(), so
-   we must start with the TSC soft disabled to prevent
-   erroneous rdtsc usage on !cpu_has_tsc processors */
-static int tsc_disabled = -1;
-
-/*
- * On some systems the TSC frequency does not
- * change with the cpu frequency. So we need
- * an extra value to store the TSC freq
- */
-unsigned int tsc_khz;
-EXPORT_SYMBOL_GPL(tsc_khz);
-
-#ifdef CONFIG_X86_TSC
-static int __init tsc_setup(char *str)
-{
-	printk(KERN_WARNING "notsc: Kernel compiled with CONFIG_X86_TSC, "
-	       "cannot disable TSC completely.\n");
-	tsc_disabled = 1;
-	return 1;
-}
-#else
-/*
- * disable flag for tsc. Takes effect by clearing the TSC cpu flag
- * in cpu/common.c
- */
-static int __init tsc_setup(char *str)
-{
-	setup_clear_cpu_cap(X86_FEATURE_TSC);
-	return 1;
-}
-#endif
-
-__setup("notsc", tsc_setup);
-
-/*
- * code to mark and check if the TSC is unstable
- * due to cpufreq or due to unsynced TSCs
- */
-static int tsc_unstable;
-
-int check_tsc_unstable(void)
-{
-	return tsc_unstable;
-}
-EXPORT_SYMBOL_GPL(check_tsc_unstable);
+extern int tsc_unstable;
+extern int tsc_disabled;
 
 /* Accelerators for sched_clock()
  * convert from cycles(64bits) => nanoseconds (64bits)
@@ -109,44 +65,6 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 	local_irq_restore(flags);
 }
 
-/*
- * Scheduler clock - returns current time in nanosec units.
- */
-unsigned long long native_sched_clock(void)
-{
-	unsigned long long this_offset;
-
-	/*
-	 * Fall back to jiffies if there's no TSC available:
-	 * ( But note that we still use it if the TSC is marked
-	 *   unstable. We do this because unlike Time Of Day,
-	 *   the scheduler clock tolerates small errors and it's
-	 *   very important for it to be as fast as the platform
-	 *   can achive it. )
-	 */
-	if (unlikely(tsc_disabled))
-		/* No locking but a rare wrong value is not a big deal: */
-		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
-
-	/* read the Time Stamp Counter: */
-	rdtscll(this_offset);
-
-	/* return the value in ns */
-	return cycles_2_ns(this_offset);
-}
-
-/* We need to define a real function for sched_clock, to override the
-   weak default version */
-#ifdef CONFIG_PARAVIRT
-unsigned long long sched_clock(void)
-{
-	return paravirt_sched_clock();
-}
-#else
-unsigned long long sched_clock(void)
-	__attribute__((alias("native_sched_clock")));
-#endif
-
 unsigned long native_calculate_cpu_khz(void)
 {
 	unsigned long long start, end;
diff --git a/arch/x86/kernel/tsc_64.c b/arch/x86/kernel/tsc_64.c
index 9898fb0..69cbe4c 100644
--- a/arch/x86/kernel/tsc_64.c
+++ b/arch/x86/kernel/tsc_64.c
@@ -13,12 +13,8 @@
 #include <asm/timer.h>
 #include <asm/vgtod.h>
 
-static int notsc __initdata = 0;
-
-unsigned int cpu_khz;		/* TSC clocks / usec, not used here */
-EXPORT_SYMBOL(cpu_khz);
-unsigned int tsc_khz;
-EXPORT_SYMBOL(tsc_khz);
+extern int tsc_unstable;
+extern int tsc_disabled;
 
 /* Accelerators for sched_clock()
  * convert from cycles(64bits) => nanoseconds (64bits)
@@ -41,6 +37,7 @@ EXPORT_SYMBOL(tsc_khz);
  *
  *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
  */
+
 DEFINE_PER_CPU(unsigned long, cyc2ns);
 
 static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
@@ -63,41 +60,6 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 	local_irq_restore(flags);
 }
 
-unsigned long long native_sched_clock(void)
-{
-	unsigned long a = 0;
-
-	/* Could do CPU core sync here. Opteron can execute rdtsc speculatively,
-	 * which means it is not completely exact and may not be monotonous
-	 * between CPUs. But the errors should be too small to matter for
-	 * scheduling purposes.
-	 */
-
-	rdtscll(a);
-	return cycles_2_ns(a);
-}
-
-/* We need to define a real function for sched_clock, to override the
-   weak default version */
-#ifdef CONFIG_PARAVIRT
-unsigned long long sched_clock(void)
-{
-	return paravirt_sched_clock();
-}
-#else
-unsigned long long
-sched_clock(void) __attribute__((alias("native_sched_clock")));
-#endif
-
-
-static int tsc_unstable;
-
-int check_tsc_unstable(void)
-{
-	return tsc_unstable;
-}
-EXPORT_SYMBOL_GPL(check_tsc_unstable);
-
 #ifdef CONFIG_CPU_FREQ
 
 /* Frequency scaling support. Adjust the TSC based timer when the cpu frequency
@@ -281,14 +243,6 @@ __cpuinit int unsynchronized_tsc(void)
 	return num_present_cpus() > 1;
 }
 
-int __init notsc_setup(char *s)
-{
-	notsc = 1;
-	return 1;
-}
-
-__setup("notsc", notsc_setup);
-
 static struct clocksource clocksource_tsc;
 
 /*
@@ -346,12 +300,13 @@ EXPORT_SYMBOL_GPL(mark_tsc_unstable);
 
 void __init init_tsc_clocksource(void)
 {
-	if (!notsc) {
-		clocksource_tsc.mult = clocksource_khz2mult(tsc_khz,
-							clocksource_tsc.shift);
-		if (check_tsc_unstable())
-			clocksource_tsc.rating = 0;
+	if (tsc_disabled > 0)
+		return;
 
-		clocksource_register(&clocksource_tsc);
-	}
+	clocksource_tsc.mult = clocksource_khz2mult(tsc_khz,
+			clocksource_tsc.shift);
+	if (check_tsc_unstable())
+		clocksource_tsc.rating = 0;
+
+	clocksource_register(&clocksource_tsc);
 }


