Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbZCNNWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbZCNNWh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 09:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754853AbZCNNW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 09:22:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:39144 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbZCNNW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 09:22:26 -0400
Subject: Re: [PATCH -tip] x86: cpu/intel.c cleanup
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090314131142.GA29582@uranus.ravnborg.org>
References: <1237034492.4546.1.camel@ht.satnam>
	 <20090314131142.GA29582@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 18:51:27 +0530
Message-Id: <1237036887.4546.6.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-14 at 14:11 +0100, Sam Ravnborg wrote:
> >  
> >  #include <asm/processor.h>
> > +#include <asm/topology.h>
> >  #include <asm/pgtable.h>
> > -#include <asm/msr.h>
> > -#include <asm/uaccess.h>
> > -#include <asm/ds.h>
> > +#ifdef CONFIG_X86_LOCAL_APIC
> > +#include <asm/mpspec.h>
> > +#include <asm/apic.h>
> > +#endif
> 
> If these header files are only relevant for CONFIG_X86_LOCAL_APIC
> then we should move the ifdef down into the header file,
> so users do not forget it.
> 

I was also thinking about this.

Here is new patch:

Subject: [PATCH] x86: cpu/intel.c cleanup

- fix various style problems
 - fix header files issues

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/intel.c |  179 ++++++++++++++++++++++---------------------
 1 files changed, 90 insertions(+), 89 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 5dac7bd..f490614 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1,38 +1,40 @@
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
+#include <asm/mpspec.h>
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
-#endif
+/* Intel VMX MSR indicated features */
+#define X86_VMX_FEATURE_PROC_CTLS2_VIRT_APIC	0x00000001
+#define X86_VMX_FEATURE_PROC_CTLS2_EPT		0x00000002
+#define X86_VMX_FEATURE_PROC_CTLS2_VPID		0x00000020
+#define X86_VMX_FEATURE_PROC_CTLS_TPR_SHADOW	0x00200000
+#define X86_VMX_FEATURE_PROC_CTLS_VNMI		0x00400000
+#define X86_VMX_FEATURE_PROC_CTLS_2ND_CTLS	0x80000000
 
 static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 {
+	u64 misc_enable;
+
 	/* Unmask CPUID levels if masked: */
 	if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
-		u64 misc_enable;
 
 		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
 
@@ -44,7 +46,7 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 	}
 
 	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
-		(c->x86 == 0x6 && c->x86_model >= 0x0e))
+	    (c->x86 == 0x6 && c->x86_model >= 0x0e))
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 
 #ifdef CONFIG_X86_64
@@ -96,17 +98,16 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 	 * Ingo Molnar reported a Pentium D (model 6) and a Xeon
 	 * (model 2) with the same problem.
 	 */
-	if (c->x86 == 15) {
-		u64 misc_enable;
+	if (c->x86 != 15)
+		return;
 
-		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+	rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
 
-		if (misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING) {
-			printk(KERN_INFO "kmemcheck: Disabling fast string operations\n");
+	if (misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING) {
+		pr_info("kmemcheck: Disabling fast string operations\n");
 
-			misc_enable &= ~MSR_IA32_MISC_ENABLE_FAST_STRING;
-			wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
-		}
+		misc_enable &= ~MSR_IA32_MISC_ENABLE_FAST_STRING;
+		wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
 	}
 #endif
 }
@@ -125,9 +126,11 @@ int __cpuinit ppro_with_ram_bug(void)
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
 
@@ -167,14 +170,32 @@ static void __cpuinit intel_smp_check(struct cpuinfo_x86 *c)
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
+#endif
+
 static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 {
+#ifdef CONFIG_X86_32
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
@@ -184,7 +205,8 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 		c->f00f_bug = 1;
 		if (!f00f_workaround_enabled) {
 			trap_init_f00f_bug();
-			printk(KERN_NOTICE "Intel Pentium with F0 0F bug - workaround enabled.\n");
+			printk(KERN_NOTICE "Intel Pentium with F0 0F bug - "
+				"workaround enabled.\n");
 			f00f_workaround_enabled = 1;
 		}
 	}
@@ -194,7 +216,7 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 	 * SEP CPUID bug: Pentium Pro reports SEP but doesn't have it until
 	 * model 3 mask 3
 	 */
-	if ((c->x86<<8 | c->x86_model<<4 | c->x86_mask) < 0x633)
+	if ((c->x86 << 8 | c->x86_model << 4 | c->x86_mask) < 0x633)
 		clear_cpu_cap(c, X86_FEATURE_SEP);
 
 	/*
@@ -204,10 +226,10 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
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
 
@@ -217,7 +239,7 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 	 * integrated APIC (see 11AP erratum in "Pentium Processor
 	 * Specification Update").
 	 */
-	if (cpu_has_apic && (c->x86<<8 | c->x86_model<<4) == 0x520 &&
+	if (cpu_has_apic && (c->x86 << 8 | c->x86_model << 4) == 0x520 &&
 	    (c->x86_mask < 0x6 || c->x86_mask == 0xb))
 		set_cpu_cap(c, X86_FEATURE_11AP);
 
@@ -245,28 +267,26 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 #endif
 
 	intel_smp_check(c);
-}
-#else
-static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
-{
-}
 #endif
+}
 
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
 
@@ -283,28 +303,20 @@ static int __cpuinit intel_num_cpu_cores(struct cpuinfo_x86 *c)
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
@@ -329,15 +341,16 @@ static void __cpuinit detect_vmx_virtcap(struct cpuinfo_x86 *c)
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
 
@@ -361,22 +374,19 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
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
-#else
+#else /* CONFIG_X86_64 */
 	/*
 	 * Names for the Pentium II/Celeron processors
 	 * detectable only by also checking the cache size.
 	 * Dixon is NOT a Celeron.
 	 */
-	if (c->x86 == 6) {
-		char *p = NULL;
 
 		switch (c->x86_model) {
 		case 5:
@@ -403,13 +413,19 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 
 		if (p)
 			strcpy(c->x86_model_id, p);
-	}
 
-	if (c->x86 == 15)
-		set_cpu_cap(c, X86_FEATURE_P4);
-	if (c->x86 == 6)
 		set_cpu_cap(c, X86_FEATURE_P3);
-#endif
+#endif /* CONFIG_X86_64 */
+		break;
+
+	case 15:
+#ifdef CONFIG_X86_64
+		c->x86_cache_alignment = c->x86_clflush_size * 2;
+#else /* CONFIG_X86_64 */
+		set_cpu_cap(c, X86_FEATURE_P4);
+#endif /* CONFIG_X86_64 */
+		break;
+	}
 
 	if (!cpu_has(c, X86_FEATURE_XTOPOLOGY)) {
 		/*
@@ -429,20 +445,6 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
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
@@ -505,4 +507,3 @@ static const struct cpu_dev __cpuinitconst intel_cpu_dev = {
 };
 
 cpu_dev_register(intel_cpu_dev);
-
-- 
1.6.0.6



