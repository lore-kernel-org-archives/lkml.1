Return-Path: <linux-kernel-owner+w=401wt.eu-S1760683AbZEZXWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760683AbZEZXWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759305AbZEZXSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:18:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53166 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759254AbZEZXSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:18:32 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 10/17] x86: MCE: Use 64bit machine check code on 32bit
Date: Wed, 27 May 2009 01:18:09 +0200
Message-Id: <91219e907da103fc39dba8d32aaa9f872f0e6cc1.1243377662.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <c8c4b619d810eba16e62044a38284761ef69c8f2.1243377662.git.ak@linux.intel.com>
References: <1243379896-26869-1-git-send-email-andi@firstfloor.org>
 <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
 <86b35f6b0b17e1edc38fb5c3178967ffc4d1fa0a.1243377662.git.ak@linux.intel.com>
 <5a2337a03ce794fe7cf69e338ffacacb3770797c.1243377662.git.ak@linux.intel.com>
 <4010bb177562589d0fd54043bb7bc6ea4d7998fd.1243377662.git.ak@linux.intel.com>
 <c21d841c7b7d68f60e52c9c20c3d9573cfd8bf95.1243377662.git.ak@linux.intel.com>
 <e625a26c7a082ec6033b4a836c98d7f725fe80f9.1243377662.git.ak@linux.intel.com>
 <b7b15c0ea92409e6641de1e90da9c63664066eba.1243377662.git.ak@linux.intel.com>
 <e2d81decded3202e410a569f8c224986f2e83668.1243377662.git.ak@linux.intel.com>
 <c8c4b619d810eba16e62044a38284761ef69c8f2.1243377662.git.ak@linux.intel.com>
In-Reply-To: <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
References: <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The 64bit machine check code is in many ways much better than
the 32bit machine check code: it is more specification compliant,
is cleaner, only has a single code base versus one per CPU,
has better infrastructure for recovery, has a cleaner way to communicate
with user space etc. etc.

Use the 64bit code for 32bit too.

This is the second attempt to do this. There was one a couple of years
ago to unify this code for 32bit and 64bit.  Back then this ran into some
trouble with K7s and was reverted.

I believe this time the K7 problems (and some others) are addressed.
I went over the old handlers and was very careful to retain
all quirks.

But of course this needs a lot of testing on old systems. On newer
64bit capable systems I don't expect much problems because they have been
already tested with the 64bit kernel.

I made this a CONFIG for now that still allows to select the old
machine check code. This is mostly to make testing easier,
if someone runs into a problem we can ask them to try
with the CONFIG switched.

The new code is default y for more coverage.

Once there is confidence the 64bit code works well on older hardware
too the CONFIG_X86_OLD_MCE and the associated code can be easily
removed.

This causes a behaviour change for 32bit installations. They now
have to install the mcelog package to be able to log
corrected machine checks.

The 64bit machine check code only handles CPUs which support the
standard Intel machine check architecture described in the IA32 SDM.
The 32bit code has special support for some older CPUs which
have non standard machine check architectures, in particular
WinChip C3 and Intel P5.  I made those a separate CONFIG option
and kept them for now. The WinChip variant could be probably
removed without too much pain, it doesn't really do anything
interesting. P5 is also disabled by default (like it
was before) because many motherboards have it miswired, but
according to Alan Cox a few embedded setups use that one.

Forward ported/heavily changed version of old patch, original patch
included review/fixes from Thomas Gleixner, Bert Wesarg.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/Kconfig                    |   33 +++++++++++++++++++++++++++++++--
 arch/x86/include/asm/entry_arch.h   |    2 +-
 arch/x86/kernel/apic/apic.c         |    4 ++--
 arch/x86/kernel/apic/nmi.c          |    2 +-
 arch/x86/kernel/cpu/mcheck/Makefile |    3 ++-
 arch/x86/kernel/cpu/mcheck/mce.c    |   32 ++++++++++++++++++++++++++++----
 arch/x86/kernel/cpu/mcheck/mce.h    |   18 +++++++++++++++---
 arch/x86/kernel/cpu/mcheck/p5.c     |    5 +++++
 arch/x86/kernel/irq.c               |    4 ++--
 arch/x86/kernel/irqinit_32.c        |    2 +-
 arch/x86/kernel/signal.c            |    4 ++--
 arch/x86/kernel/traps.c             |    4 ++--
 12 files changed, 92 insertions(+), 21 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a6efe0a..c1c5ccd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -789,6 +789,22 @@ config X86_MCE
 	  to disable it.  MCE support simply ignores non-MCE processors like
 	  the 386 and 486, so nearly everyone can say Y here.
 
+config X86_OLD_MCE
+	depends on X86_32 && X86_MCE
+	bool "Use legacy machine check code (will go away)"
+	default n
+	select X86_ANCIENT_MCE
+	---help---
+	  Use the old i386 machine check code. This is merely intended for
+	  testing in a transition period. Try this if you run into any machine
+	  check related software problems, but report the problem to
+	  linux-kernel.  When in doubt say no.
+
+config X86_NEW_MCE
+	depends on X86_MCE
+	bool
+	default y if (!X86_OLD_MCE && X86_32) || X86_64
+
 config X86_MCE_INTEL
 	def_bool y
 	prompt "Intel MCE features"
@@ -805,6 +821,15 @@ config X86_MCE_AMD
 	   Additional support for AMD specific MCE features such as
 	   the DRAM Error Threshold.
 
+config X86_ANCIENT_MCE
+       def_bool n
+       depends on X86_32
+       prompt "Support for old Pentium 5 / WinChip machine checks"
+       ---help---
+	 Include support for machine check handling on old Pentium 5 or WinChip
+	 systems. These typically need to be enabled explicitely on the command
+	 line.
+
 config X86_MCE_THRESHOLD
 	depends on X86_MCE_AMD || X86_MCE_INTEL
 	bool
@@ -812,7 +837,7 @@ config X86_MCE_THRESHOLD
 
 config X86_MCE_NONFATAL
 	tristate "Check for non-fatal errors on AMD Athlon/Duron / Intel Pentium 4"
-	depends on X86_32 && X86_MCE
+	depends on X86_OLD_MCE
 	---help---
 	  Enabling this feature starts a timer that triggers every 5 seconds which
 	  will look at the machine check registers to see if anything happened.
@@ -825,11 +850,15 @@ config X86_MCE_NONFATAL
 
 config X86_MCE_P4THERMAL
 	bool "check for P4 thermal throttling interrupt."
-	depends on X86_32 && X86_MCE && (X86_UP_APIC || SMP)
+	depends on X86_OLD_MCE && X86_MCE && (X86_UP_APIC || SMP)
 	---help---
 	  Enabling this feature will cause a message to be printed when the P4
 	  enters thermal throttling.
 
+config X86_THERMAL_VECTOR
+	def_bool y
+	depends on X86_MCE_P4THERMAL || X86_MCE_INTEL
+
 config VM86
 	bool "Enable VM86 support" if EMBEDDED
 	default y
diff --git a/arch/x86/include/asm/entry_arch.h b/arch/x86/include/asm/entry_arch.h
index c2e6bed..486c9e9 100644
--- a/arch/x86/include/asm/entry_arch.h
+++ b/arch/x86/include/asm/entry_arch.h
@@ -52,7 +52,7 @@ BUILD_INTERRUPT(spurious_interrupt,SPURIOUS_APIC_VECTOR)
 BUILD_INTERRUPT(perf_counter_interrupt, LOCAL_PERF_VECTOR)
 #endif
 
-#ifdef CONFIG_X86_MCE_P4THERMAL
+#ifdef CONFIG_X86_THERMAL_VECTOR
 BUILD_INTERRUPT(thermal_interrupt,THERMAL_APIC_VECTOR)
 #endif
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index f287092..ad53228 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -843,7 +843,7 @@ void clear_local_APIC(void)
 	}
 
 	/* lets not touch this if we didn't frob it */
-#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(CONFIG_X86_MCE_INTEL)
+#ifdef CONFIG_X86_THERMAL_VECTOR
 	if (maxlvt >= 5) {
 		v = apic_read(APIC_LVTTHMR);
 		apic_write(APIC_LVTTHMR, v | APIC_LVT_MASKED);
@@ -1962,7 +1962,7 @@ static int lapic_suspend(struct sys_device *dev, pm_message_t state)
 	apic_pm_state.apic_lvterr = apic_read(APIC_LVTERR);
 	apic_pm_state.apic_tmict = apic_read(APIC_TMICT);
 	apic_pm_state.apic_tdcr = apic_read(APIC_TDCR);
-#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(CONFIG_X86_MCE_INTEL)
+#ifdef CONFIG_X86_THERMAL_VECTOR
 	if (maxlvt >= 5)
 		apic_pm_state.apic_thmr = apic_read(APIC_LVTTHMR);
 #endif
diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index ce4fbfa..c476227 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -66,7 +66,7 @@ static inline unsigned int get_nmi_count(int cpu)
 
 static inline int mce_in_progress(void)
 {
-#if defined(CONFIG_X86_64) && defined(CONFIG_X86_MCE)
+#if defined(CONFIG_X86_NEW_MCE)
 	return atomic_read(&mce_entry) > 0;
 #endif
 	return 0;
diff --git a/arch/x86/kernel/cpu/mcheck/Makefile b/arch/x86/kernel/cpu/mcheck/Makefile
index 55f01b3..5f8b094 100644
--- a/arch/x86/kernel/cpu/mcheck/Makefile
+++ b/arch/x86/kernel/cpu/mcheck/Makefile
@@ -1,6 +1,7 @@
 obj-y				=  mce.o therm_throt.o
 
-obj-$(CONFIG_X86_32)		+= k7.o p4.o p5.o p6.o winchip.o
+obj-$(CONFIG_X86_OLD_MCE)	+= k7.o p4.o p6.o
+obj-$(CONFIG_X86_ANCIENT_MCE)	+= winchip.o p5.o
 obj-$(CONFIG_X86_MCE_P4THERMAL)	+= mce_intel.o
 obj-$(CONFIG_X86_MCE_INTEL)	+= mce_intel_64.o mce_intel.o
 obj-$(CONFIG_X86_MCE_AMD)	+= mce_amd_64.o
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 62b863a..a3c8bd0 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -52,7 +52,7 @@ void (*machine_check_vector)(struct pt_regs *, long error_code) =
 
 int				mce_disabled;
 
-#ifdef CONFIG_X86_64
+#ifdef CONFIG_X86_NEW_MCE
 
 #define MISC_MCELOG_MINOR	227
 
@@ -663,6 +663,21 @@ static void mce_cpu_quirks(struct cpuinfo_x86 *c)
 	}
 }
 
+static void __cpuinit mce_ancient_init(struct cpuinfo_x86 *c)
+{
+	if (c->x86 != 5)
+		return;
+	switch (c->x86_vendor) {
+	case X86_VENDOR_INTEL:
+		if (mce_p5_enabled())
+			intel_p5_mcheck_init(c);
+		break;
+	case X86_VENDOR_CENTAUR:
+		winchip_mcheck_init(c);
+		break;
+	}
+}
+
 static void mce_cpu_features(struct cpuinfo_x86 *c)
 {
 	switch (c->x86_vendor) {
@@ -696,6 +711,11 @@ static void mce_init_timer(void)
  */
 void __cpuinit mcheck_init(struct cpuinfo_x86 *c)
 {
+	if (mce_disabled)
+		return;
+
+	mce_ancient_init(c);
+
 	if (!mce_available(c))
 		return;
 
@@ -894,6 +914,10 @@ static struct miscdevice mce_log_device = {
  */
 static int __init mcheck_enable(char *str)
 {
+	if (*str == 0)
+		enable_p5_mce();
+	if (*str == '=')
+		str++;
 	if (!strcmp(str, "off"))
 		mce_disabled = 1;
 	else if (!strcmp(str, "bootlog") || !strcmp(str, "nobootlog"))
@@ -901,13 +925,13 @@ static int __init mcheck_enable(char *str)
 	else if (isdigit(str[0]))
 		get_option(&str, &tolerant);
 	else {
-		printk(KERN_INFO "mce= argument %s ignored. Please use /sys\n",
+		printk(KERN_INFO "mce argument %s ignored. Please use /sys\n",
 		       str);
 		return 0;
 	}
 	return 1;
 }
-__setup("mce=", mcheck_enable);
+__setup("mce", mcheck_enable);
 
 /*
  * Sysfs support
@@ -1264,7 +1288,7 @@ static __init int mce_init_device(void)
 
 device_initcall(mce_init_device);
 
-#else /* CONFIG_X86_32: */
+#else /* CONFIG_X86_OLD_MCE: */
 
 int nr_mce_banks;
 EXPORT_SYMBOL_GPL(nr_mce_banks);	/* non-fatal.o */
diff --git a/arch/x86/kernel/cpu/mcheck/mce.h b/arch/x86/kernel/cpu/mcheck/mce.h
index def7e34..2326284 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.h
+++ b/arch/x86/kernel/cpu/mcheck/mce.h
@@ -1,17 +1,29 @@
 #include <linux/init.h>
 #include <asm/mce.h>
 
+#ifdef CONFIG_X86_OLD_MCE
 extern void amd_mcheck_init(struct cpuinfo_x86 *c);
 extern void intel_p4_mcheck_init(struct cpuinfo_x86 *c);
-extern void intel_p5_mcheck_init(struct cpuinfo_x86 *c);
 extern void intel_p6_mcheck_init(struct cpuinfo_x86 *c);
-extern void winchip_mcheck_init(struct cpuinfo_x86 *c);
+#endif
 
+#ifdef CONFIG_X86_ANCIENT_MCE
+extern void intel_p5_mcheck_init(struct cpuinfo_x86 *c);
+extern void winchip_mcheck_init(struct cpuinfo_x86 *c);
+extern int mce_p5_enable;
+static inline int mce_p5_enabled(void) { return mce_p5_enable; }
+static inline void enable_p5_mce(void) { mce_p5_enable = 1; }
+#else
+static inline void intel_p5_mcheck_init(struct cpuinfo_x86 *c) {}
+static inline void winchip_mcheck_init(struct cpuinfo_x86 *c) {}
+static inline int mce_p5_enabled(void) { return 0; }
+static inline void enable_p5_mce(void) { }
+#endif
 
 /* Call the installed machine check handler for this CPU setup. */
 extern void (*machine_check_vector)(struct pt_regs *, long error_code);
 
-#ifdef CONFIG_X86_32
+#ifdef CONFIG_X86_OLD_MCE
 
 extern int nr_mce_banks;
 
diff --git a/arch/x86/kernel/cpu/mcheck/p5.c b/arch/x86/kernel/cpu/mcheck/p5.c
index 8812f54..015f481 100644
--- a/arch/x86/kernel/cpu/mcheck/p5.c
+++ b/arch/x86/kernel/cpu/mcheck/p5.c
@@ -14,6 +14,9 @@
 
 #include "mce.h"
 
+/* By default disabled */
+int		mce_p5_enable;
+
 /* Machine check handler for Pentium class Intel CPUs: */
 static void pentium_machine_check(struct pt_regs *regs, long error_code)
 {
@@ -44,9 +47,11 @@ void intel_p5_mcheck_init(struct cpuinfo_x86 *c)
 	if (!cpu_has(c, X86_FEATURE_MCE))
 		return;
 
+#ifdef CONFIG_X86_OLD_MCE
 	/* Default P5 to off as its often misconnected: */
 	if (mce_disabled != -1)
 		return;
+#endif
 
 	machine_check_vector = pentium_machine_check;
 	/* Make sure the vector pointer is visible before we enable MCEs: */
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index c3fe010..35eddc9 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -89,7 +89,7 @@ static int show_other_interrupts(struct seq_file *p, int prec)
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_thermal_count);
 	seq_printf(p, "  Thermal event interrupts\n");
-# ifdef CONFIG_X86_64
+# ifdef CONFIG_X86_MCE_THRESHOLD
 	seq_printf(p, "%*s: ", prec, "THR");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_threshold_count);
@@ -176,7 +176,7 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 #endif
 #ifdef CONFIG_X86_MCE
 	sum += irq_stats(cpu)->irq_thermal_count;
-# ifdef CONFIG_X86_64
+# ifdef CONFIG_X86_MCE_THRESHOLD
 	sum += irq_stats(cpu)->irq_threshold_count;
 #endif
 #endif
diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index 368b0a8..98846e0 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -181,7 +181,7 @@ void __init native_init_IRQ(void)
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
 #endif
 
-#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_MCE_P4THERMAL)
+#ifdef CONFIG_X86_THERMAL_VECTOR
 	/* thermal monitor LVT interrupt */
 	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
 #endif
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 1442516..d0851e3 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -25,11 +25,11 @@
 #include <asm/ucontext.h>
 #include <asm/i387.h>
 #include <asm/vdso.h>
+#include <asm/mce.h>
 
 #ifdef CONFIG_X86_64
 #include <asm/proto.h>
 #include <asm/ia32_unistd.h>
-#include <asm/mce.h>
 #endif /* CONFIG_X86_64 */
 
 #include <asm/syscall.h>
@@ -857,7 +857,7 @@ static void do_signal(struct pt_regs *regs)
 void
 do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 {
-#if defined(CONFIG_X86_64) && defined(CONFIG_X86_MCE)
+#ifdef CONFIG_X86_NEW_MCE
 	/* notify userspace of pending MCEs */
 	if (thread_info_flags & _TIF_MCE_NOTIFY)
 		mce_notify_user();
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index a1d2883..ad771f1 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -798,7 +798,8 @@ unsigned long patch_espfix_desc(unsigned long uesp, unsigned long kesp)
 
 	return new_kesp;
 }
-#else
+#endif
+
 asmlinkage void __attribute__((weak)) smp_thermal_interrupt(void)
 {
 }
@@ -806,7 +807,6 @@ asmlinkage void __attribute__((weak)) smp_thermal_interrupt(void)
 asmlinkage void __attribute__((weak)) mce_threshold_interrupt(void)
 {
 }
-#endif
 
 /*
  * 'math_state_restore()' saves the current math information in the
-- 
1.6.0.2

