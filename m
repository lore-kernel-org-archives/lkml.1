Return-Path: <linux-kernel-owner+w=401wt.eu-S1759423AbZCQL1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759423AbZCQL1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 07:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbZCQL1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 07:27:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:34126 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbZCQL1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 07:27:12 -0400
Subject: [git-pull -tip] x86: cleanup code changing
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 17 Mar 2009 16:56:38 +0530
Message-Id: <1237289198.10142.1.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 1f31834fbbb8de367914f044d3268c6afbfdd783:
  Ingo Molnar (1):
        Merge branch 'x86/mce2'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-cpu.git master

Jaswinder Singh Rajput (2):
      x86: cpu/intel.c cleanup
      x86: mpparse cleanup

 arch/x86/kernel/cpu/intel.c |  187 ++++++++++++++------------
 arch/x86/kernel/mpparse.c   |  311 ++++++++++++++++++++-----------------------
 2 files changed, 244 insertions(+), 254 deletions(-)

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
 


