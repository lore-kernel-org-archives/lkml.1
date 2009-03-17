Return-Path: <linux-kernel-owner+w=401wt.eu-S1754999AbZCQF10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbZCQF10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 01:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbZCQF1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 01:27:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:56759 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbZCQF1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 01:27:14 -0400
Subject: Re: [git-pull -tip] x86: cleanup 20090317
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0903162128010.29264@localhost.localdomain>
References: <1237229111.2827.2.camel@ht.satnam>
	 <alpine.LFD.2.00.0903162128010.29264@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 17 Mar 2009 10:56:35 +0530
Message-Id: <1237267595.2480.9.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-16 at 23:33 +0100, Thomas Gleixner wrote:
> On Tue, 17 Mar 2009, Jaswinder Singh Rajput wrote:
> 
> > -static struct clock_event_device pit_clockevent = {
> > +static struct clock_event_device pit_dev = {
> 
>   Why do we need to change the name of the variable ? Just for fun or
>   is pit_dev more self explaining than pit_clockevent ?

pit already means it is a clock event, but with this change:

1. we save 8 characters per declaration
2. It solves various 80 characters problem

this declaration is just few lines above the code where we are using it,
so it will not be problem. So it seems worth to me.

If you still thinks this stinks, let me know I will revert it :-)

Here is new pull request:

The following changes since commit 1f31834fbbb8de367914f044d3268c6afbfdd783:
  Ingo Molnar (1):
        Merge branch 'x86/mce2'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git master

Jaswinder Singh Rajput (10):
      x86: mpparse cleanup
      x86: cpu/intel.c cleanup
      x86: i8237.c cleanup
      x86: topology.c cleanup
      x86: kdebugfs.c cleanup
      x86: i8253 cleanup
      x86: pci-nommu.c cleanup
      x86: io_delay.c cleanup
      x86: rtc.c cleanup
      x86: tls.c cleanup

 arch/x86/kernel/cpu/intel.c |  187 ++++++++++++++------------
 arch/x86/kernel/i8237.c     |    5 +-
 arch/x86/kernel/i8253.c     |   68 +++++-----
 arch/x86/kernel/io_delay.c  |    6 +-
 arch/x86/kernel/kdebugfs.c  |   76 +++++------
 arch/x86/kernel/mpparse.c   |  311 ++++++++++++++++++++-----------------------
 arch/x86/kernel/pci-nommu.c |   29 +++--
 arch/x86/kernel/rtc.c       |   24 ++--
 arch/x86/kernel/tls.c       |   20 ++-
 arch/x86/kernel/topology.c  |   14 +-
 10 files changed, 373 insertions(+), 367 deletions(-)

Complete diff:
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 5dac7bd..0e5880a 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1,38 +1,55 @@
-#include <linux/init.h>
+#include <linux/thread_info.h>
+#include <linux/uaccess.h>
+#include <linux/bitops.h>
 #include <linux/kernel.h>
-
+#include <linux/module.h>
 #include <linux/string.h>
-#include <linux/bitops.h>
-#include <linux/smp.h>
 #include <linux/sched.h>
-#include <linux/thread_info.h>
-#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/smp.h>
 
 #include <asm/processor.h>
+#include <asm/topology.h>
 #include <asm/pgtable.h>
-#include <asm/msr.h>
-#include <asm/uaccess.h>
-#include <asm/ds.h>
+#include <asm/apic.h>
 #include <asm/bugs.h>
+#include <asm/numa.h>
 #include <asm/cpu.h>
-
-#ifdef CONFIG_X86_64
-#include <asm/topology.h>
-#include <asm/numa_64.h>
-#endif
+#include <asm/msr.h>
+#include <asm/ds.h>
 
 #include "cpu.h"
 
-#ifdef CONFIG_X86_LOCAL_APIC
-#include <asm/mpspec.h>
-#include <asm/apic.h>
+/* Intel VMX MSR indicated features */
+#define X86_VMX_FEATURE_PROC_CTLS2_VIRT_APIC	0x00000001
+#define X86_VMX_FEATURE_PROC_CTLS2_EPT		0x00000002
+#define X86_VMX_FEATURE_PROC_CTLS2_VPID		0x00000020
+#define X86_VMX_FEATURE_PROC_CTLS_TPR_SHADOW	0x00200000
+#define X86_VMX_FEATURE_PROC_CTLS_VNMI		0x00400000
+#define X86_VMX_FEATURE_PROC_CTLS_2ND_CTLS	0x80000000
+
+static void early_init_intel_fam15(void)
+{
+#ifdef CONFIG_KMEMCHECK
+	u64 misc_enable;
+
+	rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+
+	if (misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING) {
+		pr_info("kmemcheck: Disabling fast string operations\n");
+
+		misc_enable &= ~MSR_IA32_MISC_ENABLE_FAST_STRING;
+		wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+	}
 #endif
+}
 
 static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 {
+	u64 misc_enable;
+
 	/* Unmask CPUID levels if masked: */
 	if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
-		u64 misc_enable;
 
 		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
 
@@ -44,7 +61,7 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 	}
 
 	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
-		(c->x86 == 0x6 && c->x86_model >= 0x0e))
+	    (c->x86 == 0x6 && c->x86_model >= 0x0e))
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 
 #ifdef CONFIG_X86_64
@@ -87,7 +104,6 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 	if (c->x86 == 6 && c->x86_model < 15)
 		clear_cpu_cap(c, X86_FEATURE_PAT);
 
-#ifdef CONFIG_KMEMCHECK
 	/*
 	 * P4s have a "fast strings" feature which causes single-
 	 * stepping REP instructions to only generate a #DB on
@@ -96,19 +112,9 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 	 * Ingo Molnar reported a Pentium D (model 6) and a Xeon
 	 * (model 2) with the same problem.
 	 */
-	if (c->x86 == 15) {
-		u64 misc_enable;
-
-		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
-
-		if (misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING) {
-			printk(KERN_INFO "kmemcheck: Disabling fast string operations\n");
+	if (c->x86 == 15)
+		early_init_intel_fam15();
 
-			misc_enable &= ~MSR_IA32_MISC_ENABLE_FAST_STRING;
-			wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
-		}
-	}
-#endif
 }
 
 #ifdef CONFIG_X86_32
@@ -125,9 +131,11 @@ int __cpuinit ppro_with_ram_bug(void)
 	    boot_cpu_data.x86 == 6 &&
 	    boot_cpu_data.x86_model == 1 &&
 	    boot_cpu_data.x86_mask < 8) {
-		printk(KERN_INFO "Pentium Pro with Errata#50 detected. Taking evasive action.\n");
+		pr_info("Pentium Pro with Errata#50 detected. "
+			"Taking evasive action.\n");
 		return 1;
 	}
+
 	return 0;
 }
 
@@ -167,14 +175,30 @@ static void __cpuinit intel_smp_check(struct cpuinfo_x86 *c)
 #endif
 }
 
+static unsigned int __cpuinit
+intel_size_cache(struct cpuinfo_x86 *c, unsigned int size)
+{
+	/*
+	 * Intel PIII Tualatin. This comes in two flavours.
+	 * One has 256kb of cache, the other 512. We have no way
+	 * to determine which, so we use a boottime override
+	 * for the 512kb model, and assume 256 otherwise.
+	 */
+	if ((c->x86 == 6) && (c->x86_model == 11) && (size == 0))
+		size = 256;
+
+	return size;
+}
+
 static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 {
 	unsigned long lo, hi;
 
 #ifdef CONFIG_X86_F00F_BUG
 	/*
-	 * All current models of Pentium and Pentium with MMX technology CPUs
-	 * have the F0 0F bug, which lets nonprivileged users lock up the system.
+	 * All current models of Pentium and Pentium with MMX technology
+	 * CPUs have the F0 0F bug, which lets nonprivileged users lock
+	 * up the system.
 	 * Note that the workaround only should be initialized once...
 	 */
 	c->f00f_bug = 0;
@@ -184,7 +208,8 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 		c->f00f_bug = 1;
 		if (!f00f_workaround_enabled) {
 			trap_init_f00f_bug();
-			printk(KERN_NOTICE "Intel Pentium with F0 0F bug - workaround enabled.\n");
+			printk(KERN_NOTICE "Intel Pentium with F0 0F bug - "
+				"workaround enabled.\n");
 			f00f_workaround_enabled = 1;
 		}
 	}
@@ -194,7 +219,7 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 	 * SEP CPUID bug: Pentium Pro reports SEP but doesn't have it until
 	 * model 3 mask 3
 	 */
-	if ((c->x86<<8 | c->x86_model<<4 | c->x86_mask) < 0x633)
+	if ((c->x86 << 8 | c->x86_model << 4 | c->x86_mask) < 0x633)
 		clear_cpu_cap(c, X86_FEATURE_SEP);
 
 	/*
@@ -204,10 +229,10 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 	if ((c->x86 == 15) && (c->x86_model == 1) && (c->x86_mask == 1)) {
 		rdmsr(MSR_IA32_MISC_ENABLE, lo, hi);
 		if ((lo & MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE) == 0) {
-			printk (KERN_INFO "CPU: C0 stepping P4 Xeon detected.\n");
-			printk (KERN_INFO "CPU: Disabling hardware prefetching (Errata 037)\n");
+			pr_info("CPU: C0 stepping P4 Xeon detected.\n");
+			pr_info("CPU: Disabling hardware prefetching (Errata 037)\n");
 			lo |= MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE;
-			wrmsr (MSR_IA32_MISC_ENABLE, lo, hi);
+			wrmsr(MSR_IA32_MISC_ENABLE, lo, hi);
 		}
 	}
 
@@ -217,7 +242,7 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 	 * integrated APIC (see 11AP erratum in "Pentium Processor
 	 * Specification Update").
 	 */
-	if (cpu_has_apic && (c->x86<<8 | c->x86_model<<4) == 0x520 &&
+	if (cpu_has_apic && (c->x86 << 8 | c->x86_model << 4) == 0x520 &&
 	    (c->x86_mask < 0x6 || c->x86_mask == 0xb))
 		set_cpu_cap(c, X86_FEATURE_11AP);
 
@@ -246,27 +271,30 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 
 	intel_smp_check(c);
 }
-#else
+#else /* CONFIG_X86_32 */
+
 static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 {
 }
-#endif
+#endif /* CONFIG_X86_32 */
 
 static void __cpuinit srat_detect_node(void)
 {
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
-	unsigned node;
-	int cpu = smp_processor_id();
 	int apicid = hard_smp_processor_id();
+	int cpu = smp_processor_id();
+	unsigned node;
 
-	/* Don't do the funky fallback heuristics the AMD version employs
-	   for now. */
+	/*
+	 * Don't do the funky fallback heuristics the AMD version
+	 * employs for now.
+	 */
 	node = apicid_to_node[apicid];
 	if (node == NUMA_NO_NODE || !node_online(node))
 		node = first_node(node_online_map);
 	numa_set_node(cpu, node);
 
-	printk(KERN_INFO "CPU %d/0x%x -> Node %d\n", cpu, apicid, node);
+	pr_info("CPU %d/0x%x -> Node %d\n", cpu, apicid, node);
 #endif
 }
 
@@ -283,28 +311,20 @@ static int __cpuinit intel_num_cpu_cores(struct cpuinfo_x86 *c)
 	/* Intel has a non-standard dependency on %ecx for this CPUID level. */
 	cpuid_count(4, 0, &eax, &ebx, &ecx, &edx);
 	if (eax & 0x1f)
-		return ((eax >> 26) + 1);
+		return (eax >> 26) + 1;
 	else
 		return 1;
 }
 
 static void __cpuinit detect_vmx_virtcap(struct cpuinfo_x86 *c)
 {
-	/* Intel VMX MSR indicated features */
-#define X86_VMX_FEATURE_PROC_CTLS_TPR_SHADOW	0x00200000
-#define X86_VMX_FEATURE_PROC_CTLS_VNMI		0x00400000
-#define X86_VMX_FEATURE_PROC_CTLS_2ND_CTLS	0x80000000
-#define X86_VMX_FEATURE_PROC_CTLS2_VIRT_APIC	0x00000001
-#define X86_VMX_FEATURE_PROC_CTLS2_EPT		0x00000002
-#define X86_VMX_FEATURE_PROC_CTLS2_VPID		0x00000020
-
 	u32 vmx_msr_low, vmx_msr_high, msr_ctl, msr_ctl2;
 
+	clear_cpu_cap(c, X86_FEATURE_FLEXPRIORITY);
 	clear_cpu_cap(c, X86_FEATURE_TPR_SHADOW);
+	clear_cpu_cap(c, X86_FEATURE_VPID);
 	clear_cpu_cap(c, X86_FEATURE_VNMI);
-	clear_cpu_cap(c, X86_FEATURE_FLEXPRIORITY);
 	clear_cpu_cap(c, X86_FEATURE_EPT);
-	clear_cpu_cap(c, X86_FEATURE_VPID);
 
 	rdmsr(MSR_IA32_VMX_PROCBASED_CTLS, vmx_msr_low, vmx_msr_high);
 	msr_ctl = vmx_msr_high | vmx_msr_low;
@@ -329,15 +349,16 @@ static void __cpuinit detect_vmx_virtcap(struct cpuinfo_x86 *c)
 static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 {
 	unsigned int l2 = 0;
+	char *p = NULL;
 
 	early_init_intel(c);
 
 	intel_workarounds(c);
 
 	/*
-	 * Detect the extended topology information if available. This
-	 * will reinitialise the initial_apicid which will be used
-	 * in init_intel_cacheinfo()
+	 * Detect the extended topology information if available.
+	 * This will reinitialise the initial_apicid which will be
+	 * used in init_intel_cacheinfo()
 	 */
 	detect_extended_topology(c);
 
@@ -361,13 +382,12 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 		ds_init_intel(c);
 	}
 
-	if (c->x86 == 6 && c->x86_model == 29 && cpu_has_clflush)
-		set_cpu_cap(c, X86_FEATURE_CLFLUSH_MONITOR);
+	switch (c->x86) {
+	case 6:
+		if (c->x86_model == 29 && cpu_has_clflush)
+			set_cpu_cap(c, X86_FEATURE_CLFLUSH_MONITOR);
 
 #ifdef CONFIG_X86_64
-	if (c->x86 == 15)
-		c->x86_cache_alignment = c->x86_clflush_size * 2;
-	if (c->x86 == 6)
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
 #else
 	/*
@@ -375,8 +395,6 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 	 * detectable only by also checking the cache size.
 	 * Dixon is NOT a Celeron.
 	 */
-	if (c->x86 == 6) {
-		char *p = NULL;
 
 		switch (c->x86_model) {
 		case 5:
@@ -403,13 +421,19 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 
 		if (p)
 			strcpy(c->x86_model_id, p);
-	}
 
-	if (c->x86 == 15)
-		set_cpu_cap(c, X86_FEATURE_P4);
-	if (c->x86 == 6)
 		set_cpu_cap(c, X86_FEATURE_P3);
 #endif
+		break;
+
+	case 15:
+#ifdef CONFIG_X86_64
+		c->x86_cache_alignment = c->x86_clflush_size * 2;
+#else
+		set_cpu_cap(c, X86_FEATURE_P4);
+#endif
+		break;
+	}
 
 	if (!cpu_has(c, X86_FEATURE_XTOPOLOGY)) {
 		/*
@@ -429,20 +453,6 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 		detect_vmx_virtcap(c);
 }
 
-#ifdef CONFIG_X86_32
-static unsigned int __cpuinit intel_size_cache(struct cpuinfo_x86 *c, unsigned int size)
-{
-	/*
-	 * Intel PIII Tualatin. This comes in two flavours.
-	 * One has 256kb of cache, the other 512. We have no way
-	 * to determine which, so we use a boottime override
-	 * for the 512kb model, and assume 256 otherwise.
-	 */
-	if ((c->x86 == 6) && (c->x86_model == 11) && (size == 0))
-		size = 256;
-	return size;
-}
-#endif
 
 static const struct cpu_dev __cpuinitconst intel_cpu_dev = {
 	.c_vendor	= "Intel",
@@ -498,11 +508,10 @@ static const struct cpu_dev __cpuinitconst intel_cpu_dev = {
 		},
 	},
 	.c_size_cache	= intel_size_cache,
-#endif
+#endif /* CONFIG_X86_32 */
 	.c_early_init   = early_init_intel,
 	.c_init		= init_intel,
 	.c_x86_vendor	= X86_VENDOR_INTEL,
 };
 
 cpu_dev_register(intel_cpu_dev);
-
diff --git a/arch/x86/kernel/i8237.c b/arch/x86/kernel/i8237.c
index b42ca69..044ca09 100644
--- a/arch/x86/kernel/i8237.c
+++ b/arch/x86/kernel/i8237.c
@@ -9,9 +9,8 @@
  * your option) any later version.
  */
 
-#include <linux/init.h>
 #include <linux/sysdev.h>
-
+#include <linux/init.h>
 #include <asm/dma.h>
 
 /*
@@ -64,8 +63,10 @@ static struct sys_device device_i8237A = {
 static int __init i8237A_init_sysfs(void)
 {
 	int error = sysdev_class_register(&i8237_sysdev_class);
+
 	if (!error)
 		error = sysdev_register(&device_i8237A);
+
 	return error;
 }
 device_initcall(i8237A_init_sysfs);
diff --git a/arch/x86/kernel/i8253.c b/arch/x86/kernel/i8253.c
index 10f92fb..8396672 100644
--- a/arch/x86/kernel/i8253.c
+++ b/arch/x86/kernel/i8253.c
@@ -3,17 +3,17 @@
  *
  */
 #include <linux/clockchips.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/spinlock.h>
 #include <linux/jiffies.h>
 #include <linux/module.h>
-#include <linux/spinlock.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/io.h>
 
-#include <asm/smp.h>
-#include <asm/delay.h>
 #include <asm/i8253.h>
-#include <asm/io.h>
 #include <asm/hpet.h>
+#include <asm/smp.h>
 
 DEFINE_SPINLOCK(i8253_lock);
 EXPORT_SYMBOL(i8253_lock);
@@ -40,7 +40,7 @@ static void init_pit_timer(enum clock_event_mode mode,
 {
 	spin_lock(&i8253_lock);
 
-	switch(mode) {
+	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
 		/* binary, mode 2, LSB/MSB, ch 0 */
 		outb_pit(0x34, PIT_MODE);
@@ -95,7 +95,7 @@ static int pit_next_event(unsigned long delta, struct clock_event_device *evt)
  * registered. This mechanism replaces the previous #ifdef LOCAL_APIC -
  * !using_apic_timer decisions in do_timer_interrupt_hook()
  */
-static struct clock_event_device pit_clockevent = {
+static struct clock_event_device pit_dev = {
 	.name		= "pit",
 	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
 	.set_mode	= init_pit_timer,
@@ -114,15 +114,13 @@ void __init setup_pit_timer(void)
 	 * Start pit with the boot cpu mask and make it global after the
 	 * IO_APIC has been initialized.
 	 */
-	pit_clockevent.cpumask = cpumask_of(smp_processor_id());
-	pit_clockevent.mult = div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC,
-				     pit_clockevent.shift);
-	pit_clockevent.max_delta_ns =
-		clockevent_delta2ns(0x7FFF, &pit_clockevent);
-	pit_clockevent.min_delta_ns =
-		clockevent_delta2ns(0xF, &pit_clockevent);
-	clockevents_register_device(&pit_clockevent);
-	global_clock_event = &pit_clockevent;
+	pit_dev.cpumask = cpumask_of(smp_processor_id());
+	pit_dev.mult = div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC, pit_dev.shift);
+	pit_dev.max_delta_ns = clockevent_delta2ns(0x7FFF, &pit_dev);
+	pit_dev.min_delta_ns = clockevent_delta2ns(0xF, &pit_dev);
+
+	clockevents_register_device(&pit_dev);
+	global_clock_event = &pit_dev;
 }
 
 #ifndef CONFIG_X86_64
@@ -133,11 +131,11 @@ void __init setup_pit_timer(void)
  */
 static cycle_t pit_read(void)
 {
+	static int old_count;
+	static u32 old_jifs;
 	unsigned long flags;
 	int count;
 	u32 jifs;
-	static int old_count;
-	static u32 old_jifs;
 
 	spin_lock_irqsave(&i8253_lock, flags);
 	/*
@@ -179,9 +177,9 @@ static cycle_t pit_read(void)
 	 * Previous attempts to handle these cases intelligently were
 	 * buggy, so we just do the simple thing now.
 	 */
-	if (count > old_count && jifs == old_jifs) {
+	if (count > old_count && jifs == old_jifs)
 		count = old_count;
-	}
+
 	old_count = count;
 	old_jifs = jifs;
 
@@ -192,13 +190,13 @@ static cycle_t pit_read(void)
 	return (cycle_t)(jifs * LATCH) + count;
 }
 
-static struct clocksource clocksource_pit = {
-	.name	= "pit",
-	.rating = 110,
-	.read	= pit_read,
-	.mask	= CLOCKSOURCE_MASK(32),
-	.mult	= 0,
-	.shift	= 20,
+static struct clocksource pit_src = {
+	.name		= "pit",
+	.rating		= 110,
+	.read		= pit_read,
+	.mask		= CLOCKSOURCE_MASK(32),
+	.mult		= 0,
+	.shift		= 20,
 };
 
 static void pit_disable_clocksource(void)
@@ -206,9 +204,9 @@ static void pit_disable_clocksource(void)
 	/*
 	 * Use mult to check whether it is registered or not
 	 */
-	if (clocksource_pit.mult) {
-		clocksource_unregister(&clocksource_pit);
-		clocksource_pit.mult = 0;
+	if (pit_src.mult) {
+		clocksource_unregister(&pit_src);
+		pit_src.mult = 0;
 	}
 }
 
@@ -222,13 +220,13 @@ static int __init init_pit_clocksource(void)
 	  * - when local APIC timer is active (PIT is switched off)
 	  */
 	if (num_possible_cpus() > 1 || is_hpet_enabled() ||
-	    pit_clockevent.mode != CLOCK_EVT_MODE_PERIODIC)
+	    pit_dev.mode != CLOCK_EVT_MODE_PERIODIC)
 		return 0;
 
-	clocksource_pit.mult = clocksource_hz2mult(CLOCK_TICK_RATE,
-						   clocksource_pit.shift);
-	return clocksource_register(&clocksource_pit);
+	pit_src.mult = clocksource_hz2mult(CLOCK_TICK_RATE, pit_src.shift);
+
+	return clocksource_register(&pit_src);
 }
 arch_initcall(init_pit_clocksource);
 
-#endif
+#endif /* !CONFIG_X86_64 */
diff --git a/arch/x86/kernel/io_delay.c b/arch/x86/kernel/io_delay.c
index 720d260..f222215 100644
--- a/arch/x86/kernel/io_delay.c
+++ b/arch/x86/kernel/io_delay.c
@@ -7,10 +7,10 @@
  */
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/delay.h>
+#include <linux/init.h>
 #include <linux/dmi.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 int io_delay_type __read_mostly = CONFIG_DEFAULT_IO_DELAY_TYPE;
 
@@ -126,7 +126,7 @@ static int __init io_delay_param(char *s)
 		return -EINVAL;
 
 	io_delay_override = 1;
+
 	return 0;
 }
-
 early_param("io_delay", io_delay_param);
diff --git a/arch/x86/kernel/kdebugfs.c b/arch/x86/kernel/kdebugfs.c
index ff7d3b0..0e05c30 100644
--- a/arch/x86/kernel/kdebugfs.c
+++ b/arch/x86/kernel/kdebugfs.c
@@ -8,11 +8,11 @@
  */
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
-#include <linux/stat.h>
+#include <linux/module.h>
 #include <linux/init.h>
+#include <linux/stat.h>
 #include <linux/io.h>
 #include <linux/mm.h>
-#include <linux/module.h>
 
 #include <asm/setup.h>
 
@@ -26,9 +26,8 @@ struct setup_data_node {
 	u32 len;
 };
 
-static ssize_t
-setup_data_read(struct file *file, char __user *user_buf, size_t count,
-		loff_t *ppos)
+static ssize_t setup_data_read(struct file *file, char __user *user_buf,
+			       size_t count, loff_t *ppos)
 {
 	struct setup_data_node *node = file->private_data;
 	unsigned long remain;
@@ -39,20 +38,21 @@ setup_data_read(struct file *file, char __user *user_buf, size_t count,
 
 	if (pos < 0)
 		return -EINVAL;
+
 	if (pos >= node->len)
 		return 0;
 
 	if (count > node->len - pos)
 		count = node->len - pos;
+
 	pa = node->paddr + sizeof(struct setup_data) + pos;
 	pg = pfn_to_page((pa + count - 1) >> PAGE_SHIFT);
 	if (PageHighMem(pg)) {
 		p = ioremap_cache(pa, count);
 		if (!p)
 			return -ENXIO;
-	} else {
+	} else
 		p = __va(pa);
-	}
 
 	remain = copy_to_user(user_buf, p, count);
 
@@ -70,12 +70,13 @@ setup_data_read(struct file *file, char __user *user_buf, size_t count,
 static int setup_data_open(struct inode *inode, struct file *file)
 {
 	file->private_data = inode->i_private;
+
 	return 0;
 }
 
 static const struct file_operations fops_setup_data = {
-	.read =		setup_data_read,
-	.open =		setup_data_open,
+	.read		= setup_data_read,
+	.open		= setup_data_open,
 };
 
 static int __init
@@ -84,24 +85,20 @@ create_setup_data_node(struct dentry *parent, int no,
 {
 	struct dentry *d, *type, *data;
 	char buf[16];
-	int error;
 
 	sprintf(buf, "%d", no);
 	d = debugfs_create_dir(buf, parent);
-	if (!d) {
-		error = -ENOMEM;
+	if (!d)
 		goto err_return;
-	}
+
 	type = debugfs_create_x32("type", S_IRUGO, d, &node->type);
-	if (!type) {
-		error = -ENOMEM;
+	if (!type)
 		goto err_dir;
-	}
+
 	data = debugfs_create_file("data", S_IRUGO, d, node, &fops_setup_data);
-	if (!data) {
-		error = -ENOMEM;
+	if (!data)
 		goto err_type;
-	}
+
 	return 0;
 
 err_type:
@@ -109,32 +106,29 @@ err_type:
 err_dir:
 	debugfs_remove(d);
 err_return:
-	return error;
+	return -ENOMEM;
 }
 
 static int __init create_setup_data_nodes(struct dentry *parent)
 {
 	struct setup_data_node *node;
 	struct setup_data *data;
-	int error, no = 0;
+	int error = 0, no = 0;
 	struct dentry *d;
 	struct page *pg;
 	u64 pa_data;
 
 	d = debugfs_create_dir("setup_data", parent);
-	if (!d) {
-		error = -ENOMEM;
+	if (!d)
 		goto err_return;
-	}
 
 	pa_data = boot_params.hdr.setup_data;
 
 	while (pa_data) {
 		node = kmalloc(sizeof(*node), GFP_KERNEL);
-		if (!node) {
-			error = -ENOMEM;
+		if (!node)
 			goto err_dir;
-		}
+
 		pg = pfn_to_page((pa_data+sizeof(*data)-1) >> PAGE_SHIFT);
 		if (PageHighMem(pg)) {
 			data = ioremap_cache(pa_data, sizeof(*data));
@@ -143,9 +137,8 @@ static int __init create_setup_data_nodes(struct dentry *parent)
 				error = -ENXIO;
 				goto err_dir;
 			}
-		} else {
+		} else
 			data = __va(pa_data);
-		}
 
 		node->paddr = pa_data;
 		node->type = data->type;
@@ -159,11 +152,14 @@ static int __init create_setup_data_nodes(struct dentry *parent)
 			goto err_dir;
 		no++;
 	}
+
 	return 0;
 
 err_dir:
 	debugfs_remove(d);
 err_return:
+	if (!error)
+		error = -ENOMEM;
 	return error;
 }
 
@@ -175,28 +171,26 @@ static struct debugfs_blob_wrapper boot_params_blob = {
 static int __init boot_params_kdebugfs_init(void)
 {
 	struct dentry *dbp, *version, *data;
-	int error;
+	int error = 0;
 
 	dbp = debugfs_create_dir("boot_params", NULL);
-	if (!dbp) {
-		error = -ENOMEM;
+	if (!dbp)
 		goto err_return;
-	}
+
 	version = debugfs_create_x16("version", S_IRUGO, dbp,
 				     &boot_params.hdr.version);
-	if (!version) {
-		error = -ENOMEM;
+	if (!version)
 		goto err_dir;
-	}
+
 	data = debugfs_create_blob("data", S_IRUGO, dbp,
 				   &boot_params_blob);
-	if (!data) {
-		error = -ENOMEM;
+	if (!data)
 		goto err_version;
-	}
+
 	error = create_setup_data_nodes(dbp);
 	if (error)
 		goto err_data;
+
 	return 0;
 
 err_data:
@@ -206,9 +200,11 @@ err_version:
 err_dir:
 	debugfs_remove(dbp);
 err_return:
+	if (!error)
+		error = -ENOMEM;
 	return error;
 }
-#endif
+#endif /* CONFIG_DEBUG_BOOT_PARAMS */
 
 static int __init arch_kdebugfs_init(void)
 {
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 47673e0..e46d66a 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -7,33 +7,32 @@
  *      (c) 2008 Alexey Starikovskiy <astarikovskiy@suse.de>
  */
 
-#include <linux/mm.h>
-#include <linux/init.h>
-#include <linux/delay.h>
-#include <linux/bootmem.h>
 #include <linux/kernel_stat.h>
 #include <linux/mc146818rtc.h>
+#include <linux/bootmem.h>
 #include <linux/bitops.h>
-#include <linux/acpi.h>
 #include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/acpi.h>
+#include <linux/init.h>
 #include <linux/smp.h>
+#include <linux/mm.h>
 
-#include <asm/mtrr.h>
-#include <asm/mpspec.h>
+#include <asm/trampoline.h>
+#include <asm/bios_ebda.h>
 #include <asm/pgalloc.h>
 #include <asm/io_apic.h>
+#include <asm/mpspec.h>
 #include <asm/proto.h>
-#include <asm/bios_ebda.h>
-#include <asm/e820.h>
-#include <asm/trampoline.h>
 #include <asm/setup.h>
+#include <asm/apic.h>
+#include <asm/e820.h>
+#include <asm/mtrr.h>
 #include <asm/smp.h>
 
-#include <asm/apic.h>
 /*
  * Checksum an MP configuration block.
  */
-
 static int __init mpf_checksum(unsigned char *mp, int len)
 {
 	int sum = 0;
@@ -46,8 +45,8 @@ static int __init mpf_checksum(unsigned char *mp, int len)
 
 static void __init MP_processor_info(struct mpc_cpu *m)
 {
-	int apicid;
 	char *bootup_cpu = "";
+	int apicid;
 
 	if (!(m->cpuflag & CPU_ENABLED)) {
 		disabled_cpus++;
@@ -72,6 +71,7 @@ static void __init MP_processor_info(struct mpc_cpu *m)
 static void __init MP_bus_info(struct mpc_bus *m)
 {
 	char str[7];
+
 	memcpy(str, m->bustype, 6);
 	str[6] = 0;
 
@@ -109,9 +109,6 @@ static void __init MP_bus_info(struct mpc_bus *m)
 	} else
 		printk(KERN_WARNING "Unknown bustype %s - ignoring\n", str);
 }
-#endif
-
-#ifdef CONFIG_X86_IO_APIC
 
 static int bad_ioapic(unsigned long address)
 {
@@ -224,8 +221,12 @@ static void __init MP_intsrc_info(struct mpc_intsrc *m)
 	if (++mp_irq_entries == MAX_IRQ_SOURCES)
 		panic("Max # of irq sources exceeded!!\n");
 }
+#else /* CONFIG_X86_IO_APIC */
+static inline void __init MP_bus_info(struct mpc_bus *m) {}
+static inline void __init MP_ioapic_info(struct mpc_ioapic *m) {}
+static inline void __init MP_intsrc_info(struct mpc_intsrc *m) {}
+#endif /* CONFIG_X86_IO_APIC */
 
-#endif
 
 static void __init MP_lintsrc_info(struct mpc_lintsrc *m)
 {
@@ -275,6 +276,12 @@ static int __init smp_check_mpc(struct mpc_table *mpc, char *oem, char *str)
 	return 1;
 }
 
+static void skip_entry(unsigned char **ptr, int *count, int size)
+{
+	*ptr += size;
+	*count += size;
+}
+
 static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 {
 	char str[16];
@@ -310,59 +317,31 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 	while (count < mpc->length) {
 		switch (*mpt) {
 		case MP_PROCESSOR:
-			{
-				struct mpc_cpu *m = (struct mpc_cpu *)mpt;
-				/* ACPI may have already provided this data */
-				if (!acpi_lapic)
-					MP_processor_info(m);
-				mpt += sizeof(*m);
-				count += sizeof(*m);
-				break;
-			}
+			/* ACPI may have already provided this data */
+			if (!acpi_lapic)
+				MP_processor_info((struct mpc_cpu *)&mpt);
+			skip_entry(&mpt, &count, sizeof(struct mpc_cpu));
+			break;
 		case MP_BUS:
-			{
-				struct mpc_bus *m = (struct mpc_bus *)mpt;
-#ifdef CONFIG_X86_IO_APIC
-				MP_bus_info(m);
-#endif
-				mpt += sizeof(*m);
-				count += sizeof(*m);
-				break;
-			}
+			MP_bus_info((struct mpc_bus *)&mpt);
+			skip_entry(&mpt, &count, sizeof(struct mpc_bus));
+			break;
 		case MP_IOAPIC:
-			{
-#ifdef CONFIG_X86_IO_APIC
-				struct mpc_ioapic *m = (struct mpc_ioapic *)mpt;
-				MP_ioapic_info(m);
-#endif
-				mpt += sizeof(struct mpc_ioapic);
-				count += sizeof(struct mpc_ioapic);
-				break;
-			}
+			MP_ioapic_info((struct mpc_ioapic *)&mpt);
+			skip_entry(&mpt, &count, sizeof(struct mpc_ioapic));
+			break;
 		case MP_INTSRC:
-			{
-#ifdef CONFIG_X86_IO_APIC
-				struct mpc_intsrc *m = (struct mpc_intsrc *)mpt;
-
-				MP_intsrc_info(m);
-#endif
-				mpt += sizeof(struct mpc_intsrc);
-				count += sizeof(struct mpc_intsrc);
-				break;
-			}
+			MP_intsrc_info((struct mpc_intsrc *)&mpt);
+			skip_entry(&mpt, &count, sizeof(struct mpc_intsrc));
+			break;
 		case MP_LINTSRC:
-			{
-				struct mpc_lintsrc *m =
-				    (struct mpc_lintsrc *)mpt;
-				MP_lintsrc_info(m);
-				mpt += sizeof(*m);
-				count += sizeof(*m);
-				break;
-			}
+			MP_lintsrc_info((struct mpc_lintsrc *)&mpt);
+			skip_entry(&mpt, &count, sizeof(struct mpc_lintsrc));
+			break;
 		default:
 			/* wrong mptable */
-			printk(KERN_ERR "Your mptable is wrong, contact your HW vendor!\n");
-			printk(KERN_ERR "type %x\n", *mpt);
+			pr_err("Your mptable is wrong, contact your HW vendor!\n");
+			pr_err("type %x\n", *mpt);
 			print_hex_dump(KERN_ERR, "  ", DUMP_PREFIX_ADDRESS, 16,
 					1, mpc, mpc->length, 1);
 			count = mpc->length;
@@ -391,14 +370,15 @@ static int __init ELCR_trigger(unsigned int irq)
 	unsigned int port;
 
 	port = 0x4d0 + (irq >> 3);
+
 	return (inb(port) >> (irq & 7)) & 1;
 }
 
 static void __init construct_default_ioirq_mptable(int mpc_default_type)
 {
 	struct mpc_intsrc intsrc;
-	int i;
 	int ELCR_fallback = 0;
+	int i;
 
 	intsrc.type = MP_INTSRC;
 	intsrc.irqflag = 0;	/* conforming */
@@ -443,9 +423,9 @@ static void __init construct_default_ioirq_mptable(int mpc_default_type)
 
 		if (ELCR_fallback) {
 			/*
-			 *  If the ELCR indicates a level-sensitive interrupt, we
-			 *  copy that information over to the MP table in the
-			 *  irqflag field (level sensitive, active high polarity).
+			 *  If the ELCR indicates a level-sensitive interrupt,
+			 *  we copy that information over to the MP table in the
+			 *  irqflag field(level sensitive, active high polarity)
 			 */
 			if (ELCR_trigger(i))
 				intsrc.irqflag = 13;
@@ -515,9 +495,9 @@ static inline void __init construct_ioapic_table(int mpc_default_type) { }
 
 static inline void __init construct_default_ISA_mptable(int mpc_default_type)
 {
-	struct mpc_cpu processor;
-	struct mpc_lintsrc lintsrc;
 	int linttypes[2] = { mp_ExtINT, mp_NMI };
+	struct mpc_lintsrc lintsrc;
+	struct mpc_cpu processor;
 	int i;
 
 	/*
@@ -689,6 +669,31 @@ void __init get_smp_config(void)
 	__get_smp_config(0);
 }
 
+static void smp_reserve_bootmem(struct mpf_intel *mpf)
+{
+	unsigned long size = get_mpc_size(mpf->physptr);
+#ifdef CONFIG_X86_32
+	/*
+	 * We cannot access to MPC table to compute table size yet,
+	 * as only few megabytes from the bottom is mapped now.
+	 * PC-9800's MPC table places on the very last of physical
+	 * memory; so that simply reserving PAGE_SIZE from mpf->physptr
+	 * yields BUG() in reserve_bootmem.
+	 * also need to make sure physptr is below than max_low_pfn
+	 * we don't need reserve the area above max_low_pfn
+	 */
+	unsigned long end = max_low_pfn * PAGE_SIZE;
+
+	if (mpf->physptr < end) {
+		if (mpf->physptr + size > end)
+			size = end - mpf->physptr;
+		reserve_bootmem_generic(mpf->physptr, size, BOOTMEM_DEFAULT);
+	}
+#else
+	reserve_bootmem_generic(mpf->physptr, size, BOOTMEM_DEFAULT);
+#endif
+}
+
 static int __init smp_scan_config(unsigned long base, unsigned long length,
 				  unsigned reserve)
 {
@@ -717,41 +722,16 @@ static int __init smp_scan_config(unsigned long base, unsigned long length,
 			if (!reserve)
 				return 1;
 			reserve_bootmem_generic(virt_to_phys(mpf), sizeof(*mpf),
-					BOOTMEM_DEFAULT);
-			if (mpf->physptr) {
-				unsigned long size = get_mpc_size(mpf->physptr);
-#ifdef CONFIG_X86_32
-				/*
-				 * We cannot access to MPC table to compute
-				 * table size yet, as only few megabytes from
-				 * the bottom is mapped now.
-				 * PC-9800's MPC table places on the very last
-				 * of physical memory; so that simply reserving
-				 * PAGE_SIZE from mpf->physptr yields BUG()
-				 * in reserve_bootmem.
-				 * also need to make sure physptr is below than
-				 * max_low_pfn
-				 * we don't need reserve the area above max_low_pfn
-				 */
-				unsigned long end = max_low_pfn * PAGE_SIZE;
-
-				if (mpf->physptr < end) {
-					if (mpf->physptr + size > end)
-						size = end - mpf->physptr;
-					reserve_bootmem_generic(mpf->physptr, size,
-							BOOTMEM_DEFAULT);
-				}
-#else
-				reserve_bootmem_generic(mpf->physptr, size,
 						BOOTMEM_DEFAULT);
-#endif
-			}
+			if (mpf->physptr)
+				smp_reserve_bootmem(mpf);
 
 			return 1;
 		}
 		bp += 4;
 		length -= 16;
 	}
+
 	return 0;
 }
 
@@ -848,79 +828,88 @@ static int  __init get_MP_intsrc_index(struct mpc_intsrc *m)
 #define SPARE_SLOT_NUM 20
 
 static struct mpc_intsrc __initdata *m_spare[SPARE_SLOT_NUM];
-#endif
+
+static void check_irq_src(struct mpc_intsrc *m, int *nr_m_spare)
+{
+	int i;
+
+	apic_printk(APIC_VERBOSE, "OLD ");
+	print_MP_intsrc_info(m);
+
+	i = get_MP_intsrc_index(m);
+	if (i > 0) {
+		assign_to_mpc_intsrc(&mp_irqs[i], m);
+		apic_printk(APIC_VERBOSE, "NEW ");
+		print_mp_irq_info(&mp_irqs[i]);
+		return;
+	}
+	if (!i) {
+		/* legacy, do nothing */
+		return;
+	}
+	if (*nr_m_spare < SPARE_SLOT_NUM) {
+		/*
+		 * not found (-1), or duplicated (-2) are invalid entries,
+		 * we need to use the slot later
+		 */
+		m_spare[*nr_m_spare] = m;
+		*nr_m_spare += 1;
+	}
+}
+#else /* CONFIG_X86_IO_APIC */
+static inline void check_irq_src(struct mpc_intsrc *m, int *nr_m_spare) {}
+#endif /* CONFIG_X86_IO_APIC */
+
+static int check_slot(unsigned long mpc_new_phys, unsigned long mpc_new_length,
+		      int count)
+{
+	if (!mpc_new_phys) {
+		pr_info("No spare slots, try to append...take your risk, "
+			"new mpc_length %x\n", count);
+	} else {
+		if (count <= mpc_new_length)
+			pr_info("No spare slots, try to append..., "
+				"new mpc_length %x\n", count);
+		else {
+			pr_err("mpc_new_length %lx is too small\n",
+				mpc_new_length);
+			return -1;
+		}
+	}
+
+	return 0;
+}
 
 static int  __init replace_intsrc_all(struct mpc_table *mpc,
-					unsigned long mpc_new_phys,
-					unsigned long mpc_new_length)
+				      unsigned long mpc_new_phys,
+				      unsigned long mpc_new_length)
 {
 #ifdef CONFIG_X86_IO_APIC
 	int i;
-	int nr_m_spare = 0;
 #endif
-
 	int count = sizeof(*mpc);
+	int nr_m_spare = 0;
 	unsigned char *mpt = ((unsigned char *)mpc) + count;
 
 	printk(KERN_INFO "mpc_length %x\n", mpc->length);
 	while (count < mpc->length) {
 		switch (*mpt) {
 		case MP_PROCESSOR:
-			{
-				struct mpc_cpu *m = (struct mpc_cpu *)mpt;
-				mpt += sizeof(*m);
-				count += sizeof(*m);
-				break;
-			}
+			skip_entry(&mpt, &count, sizeof(struct mpc_cpu));
+			break;
 		case MP_BUS:
-			{
-				struct mpc_bus *m = (struct mpc_bus *)mpt;
-				mpt += sizeof(*m);
-				count += sizeof(*m);
-				break;
-			}
+			skip_entry(&mpt, &count, sizeof(struct mpc_bus));
+			break;
 		case MP_IOAPIC:
-			{
-				mpt += sizeof(struct mpc_ioapic);
-				count += sizeof(struct mpc_ioapic);
-				break;
-			}
+			skip_entry(&mpt, &count, sizeof(struct mpc_ioapic));
+			break;
 		case MP_INTSRC:
-			{
-#ifdef CONFIG_X86_IO_APIC
-				struct mpc_intsrc *m = (struct mpc_intsrc *)mpt;
-
-				apic_printk(APIC_VERBOSE, "OLD ");
-				print_MP_intsrc_info(m);
-				i = get_MP_intsrc_index(m);
-				if (i > 0) {
-					assign_to_mpc_intsrc(&mp_irqs[i], m);
-					apic_printk(APIC_VERBOSE, "NEW ");
-					print_mp_irq_info(&mp_irqs[i]);
-				} else if (!i) {
-					/* legacy, do nothing */
-				} else if (nr_m_spare < SPARE_SLOT_NUM) {
-					/*
-					 * not found (-1), or duplicated (-2)
-					 * are invalid entries,
-					 * we need to use the slot  later
-					 */
-					m_spare[nr_m_spare] = m;
-					nr_m_spare++;
-				}
-#endif
-				mpt += sizeof(struct mpc_intsrc);
-				count += sizeof(struct mpc_intsrc);
-				break;
-			}
+			check_irq_src((struct mpc_intsrc *)&mpt, &nr_m_spare);
+			skip_entry(&mpt, &count, sizeof(struct mpc_intsrc));
+			break;
 		case MP_LINTSRC:
-			{
-				struct mpc_lintsrc *m =
-				    (struct mpc_lintsrc *)mpt;
-				mpt += sizeof(*m);
-				count += sizeof(*m);
-				break;
-			}
+			skip_entry(&mpt, &count, sizeof(struct mpc_lintsrc));
+			break;
 		default:
 			/* wrong mptable */
 			printk(KERN_ERR "Your mptable is wrong, contact your HW vendor!\n");
@@ -950,16 +939,8 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
 		} else {
 			struct mpc_intsrc *m = (struct mpc_intsrc *)mpt;
 			count += sizeof(struct mpc_intsrc);
-			if (!mpc_new_phys) {
-				printk(KERN_INFO "No spare slots, try to append...take your risk, new mpc_length %x\n", count);
-			} else {
-				if (count <= mpc_new_length)
-					printk(KERN_INFO "No spare slots, try to append..., new mpc_length %x\n", count);
-				else {
-					printk(KERN_ERR "mpc_new_length %lx is too small\n", mpc_new_length);
-					goto out;
-				}
-			}
+			if (!check_slot(mpc_new_phys, mpc_new_length, count))
+				goto out;
 			assign_to_mpc_intsrc(&mp_irqs[i], m);
 			mpc->length = count;
 			mpt += sizeof(struct mpc_intsrc);
@@ -1044,7 +1025,7 @@ static int __init update_mp_table(void)
 
 	if (mpc_new_phys && mpc->length > mpc_new_length) {
 		mpc_new_phys = 0;
-		printk(KERN_INFO "mpc_new_length is %ld, please use alloc_mptable=8k\n",
+		pr_info("mpc_new_length is %ld, please use alloc_mptable=8k\n",
 			 mpc_new_length);
 	}
 
diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index fe50214..b240d1b 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -1,14 +1,14 @@
 /* Fallback functions when the main IOMMU code is not compiled in. This
    code is roughly equivalent to i386. */
-#include <linux/mm.h>
-#include <linux/init.h>
-#include <linux/pci.h>
-#include <linux/string.h>
 #include <linux/dma-mapping.h>
 #include <linux/scatterlist.h>
+#include <linux/string.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/mm.h>
 
-#include <asm/iommu.h>
 #include <asm/processor.h>
+#include <asm/iommu.h>
 #include <asm/dma.h>
 
 static int
@@ -20,8 +20,10 @@ check_addr(char *name, struct device *hwdev, dma_addr_t bus, size_t size)
 			    "nommu_%s: overflow %Lx+%zu of device mask %Lx\n",
 				name, (long long)bus, size,
 				(long long)*hwdev->dma_mask);
+
 		return 0;
 	}
+
 	return 1;
 }
 
@@ -31,10 +33,14 @@ static dma_addr_t nommu_map_page(struct device *dev, struct page *page,
 				 struct dma_attrs *attrs)
 {
 	dma_addr_t bus = page_to_phys(page) + offset;
+
 	WARN_ON(size == 0);
+
 	if (!check_addr("map_single", dev, bus, size))
 		return bad_dma_address;
+
 	flush_write_buffers();
+
 	return bus;
 }
 
@@ -65,11 +71,14 @@ static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
 	for_each_sg(sg, s, nents, i) {
 		BUG_ON(!sg_page(s));
 		s->dma_address = sg_phys(s);
+
 		if (!check_addr("map_sg", hwdev, s->dma_address, s->length))
 			return 0;
+
 		s->dma_length = s->length;
 	}
 	flush_write_buffers();
+
 	return nents;
 }
 
@@ -80,11 +89,11 @@ static void nommu_free_coherent(struct device *dev, size_t size, void *vaddr,
 }
 
 struct dma_map_ops nommu_dma_ops = {
-	.alloc_coherent = dma_generic_alloc_coherent,
-	.free_coherent = nommu_free_coherent,
-	.map_sg = nommu_map_sg,
-	.map_page = nommu_map_page,
-	.is_phys = 1,
+	.alloc_coherent	= dma_generic_alloc_coherent,
+	.free_coherent	= nommu_free_coherent,
+	.map_sg		= nommu_map_sg,
+	.map_page	= nommu_map_page,
+	.is_phys	= 1,
 };
 
 void __init no_iommu_init(void)
diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index dd6f2b7..8f369d7 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -1,14 +1,14 @@
 /*
  * RTC related functions
  */
+#include <linux/platform_device.h>
+#include <linux/mc146818rtc.h>
 #include <linux/acpi.h>
 #include <linux/bcd.h>
-#include <linux/mc146818rtc.h>
-#include <linux/platform_device.h>
 #include <linux/pnp.h>
 
-#include <asm/time.h>
 #include <asm/vsyscall.h>
+#include <asm/time.h>
 
 #ifdef CONFIG_X86_32
 /*
@@ -16,9 +16,9 @@
  * register we are working with.  It is required for NMI access to the
  * CMOS/RTC registers.  See include/asm-i386/mc146818rtc.h for details.
  */
-volatile unsigned long cmos_lock = 0;
+volatile unsigned long cmos_lock;
 EXPORT_SYMBOL(cmos_lock);
-#endif
+#endif /* CONFIG_X86_32 */
 
 /* For two digit years assume time is always after that */
 #define CMOS_YEARS_OFFS 2000
@@ -38,9 +38,9 @@ EXPORT_SYMBOL(rtc_lock);
  */
 int mach_set_rtc_mmss(unsigned long nowtime)
 {
-	int retval = 0;
 	int real_seconds, real_minutes, cmos_minutes;
 	unsigned char save_control, save_freq_select;
+	int retval = 0;
 
 	 /* tell the clock it's being set */
 	save_control = CMOS_READ(RTC_CONTROL);
@@ -72,8 +72,8 @@ int mach_set_rtc_mmss(unsigned long nowtime)
 			real_seconds = bin2bcd(real_seconds);
 			real_minutes = bin2bcd(real_minutes);
 		}
-		CMOS_WRITE(real_seconds,RTC_SECONDS);
-		CMOS_WRITE(real_minutes,RTC_MINUTES);
+		CMOS_WRITE(real_seconds, RTC_SECONDS);
+		CMOS_WRITE(real_minutes, RTC_MINUTES);
 	} else {
 		printk(KERN_WARNING
 		       "set_rtc_mmss: can't update from %d to %d\n",
@@ -118,7 +118,7 @@ unsigned long mach_get_cmos_time(void)
 	if (acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID &&
 	    acpi_gbl_FADT.century)
 		century = CMOS_READ(acpi_gbl_FADT.century);
-#endif
+#endif /* CONFIG_ACPI */
 
 	status = CMOS_READ(RTC_CONTROL);
 	WARN_ON_ONCE(RTC_ALWAYS_BCD && (status & RTC_DM_BINARY));
@@ -151,6 +151,7 @@ unsigned char rtc_cmos_read(unsigned char addr)
 	outb(addr, RTC_PORT(0));
 	val = inb(RTC_PORT(1));
 	lock_cmos_suffix(addr);
+
 	return val;
 }
 EXPORT_SYMBOL(rtc_cmos_read);
@@ -166,8 +167,8 @@ EXPORT_SYMBOL(rtc_cmos_write);
 
 static int set_rtc_mmss(unsigned long nowtime)
 {
-	int retval;
 	unsigned long flags;
+	int retval;
 
 	spin_lock_irqsave(&rtc_lock, flags);
 	retval = set_wallclock(nowtime);
@@ -237,11 +238,12 @@ static __init int add_rtc_cmos(void)
 			}
 		}
 	}
-#endif
+#endif /* CONFIG_PNP */
 
 	platform_device_register(&rtc_device);
 	dev_info(&rtc_device.dev,
 		 "registered platform RTC device (no PNP device found)\n");
+
 	return 0;
 }
 device_initcall(add_rtc_cmos);
diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index 6bb7b85..2990598 100644
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -1,16 +1,16 @@
+#include <linux/uaccess.h>
 #include <linux/kernel.h>
+#include <linux/regset.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/user.h>
-#include <linux/regset.h>
 
-#include <asm/uaccess.h>
-#include <asm/desc.h>
-#include <asm/system.h>
-#include <asm/ldt.h>
 #include <asm/processor.h>
-#include <asm/proto.h>
 #include <asm/syscalls.h>
+#include <asm/system.h>
+#include <asm/proto.h>
+#include <asm/desc.h>
+#include <asm/ldt.h>
 
 #include "tls.h"
 
@@ -25,6 +25,7 @@ static int get_free_idx(void)
 	for (idx = 0; idx < GDT_ENTRY_TLS_ENTRIES; idx++)
 		if (desc_empty(&t->tls_array[idx]))
 			return idx + GDT_ENTRY_TLS_MIN;
+
 	return -ESRCH;
 }
 
@@ -93,7 +94,9 @@ int do_set_thread_area(struct task_struct *p, int idx,
 asmlinkage int sys_set_thread_area(struct user_desc __user *u_info)
 {
 	int ret = do_set_thread_area(current, -1, u_info, 1);
+
 	asmlinkage_protect(1, ret, u_info);
+
 	return ret;
 }
 
@@ -137,13 +140,16 @@ int do_get_thread_area(struct task_struct *p, int idx,
 
 	if (copy_to_user(u_info, &info, sizeof(info)))
 		return -EFAULT;
+
 	return 0;
 }
 
 asmlinkage int sys_get_thread_area(struct user_desc __user *u_info)
 {
 	int ret = do_get_thread_area(current, -1, u_info);
+
 	asmlinkage_protect(1, ret, u_info);
+
 	return ret;
 }
 
@@ -152,8 +158,10 @@ int regset_tls_active(struct task_struct *target,
 {
 	struct thread_struct *t = &target->thread;
 	int n = GDT_ENTRY_TLS_ENTRIES;
+
 	while (n > 0 && desc_empty(&t->tls_array[n - 1]))
 		--n;
+
 	return n;
 }
 
diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
index 0fcc95a..7e45159 100644
--- a/arch/x86/kernel/topology.c
+++ b/arch/x86/kernel/topology.c
@@ -25,10 +25,10 @@
  *
  * Send feedback to <colpatch@us.ibm.com>
  */
-#include <linux/init.h>
-#include <linux/smp.h>
 #include <linux/nodemask.h>
 #include <linux/mmzone.h>
+#include <linux/init.h>
+#include <linux/smp.h>
 #include <asm/cpu.h>
 
 static DEFINE_PER_CPU(struct x86_cpu, cpu_devices);
@@ -47,6 +47,7 @@ int __ref arch_register_cpu(int num)
 	 */
 	if (num)
 		per_cpu(cpu_devices, num).cpu.hotpluggable = 1;
+
 	return register_cpu(&per_cpu(cpu_devices, num).cpu, num);
 }
 EXPORT_SYMBOL(arch_register_cpu);
@@ -56,12 +57,13 @@ void arch_unregister_cpu(int num)
 	unregister_cpu(&per_cpu(cpu_devices, num).cpu);
 }
 EXPORT_SYMBOL(arch_unregister_cpu);
-#else
+#else /* CONFIG_HOTPLUG_CPU */
+
 static int __init arch_register_cpu(int num)
 {
 	return register_cpu(&per_cpu(cpu_devices, num).cpu, num);
 }
-#endif /*CONFIG_HOTPLUG_CPU*/
+#endif /* CONFIG_HOTPLUG_CPU */
 
 static int __init topology_init(void)
 {
@@ -70,11 +72,11 @@ static int __init topology_init(void)
 #ifdef CONFIG_NUMA
 	for_each_online_node(i)
 		register_one_node(i);
-#endif /* CONFIG_NUMA */
+#endif
 
 	for_each_present_cpu(i)
 		arch_register_cpu(i);
+
 	return 0;
 }
-
 subsys_initcall(topology_init);



