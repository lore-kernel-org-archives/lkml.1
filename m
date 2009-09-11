Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbZIKTld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbZIKTld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756196AbZIKTlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:41:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48529 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756184AbZIKTl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:41:26 -0400
Date: Fri, 11 Sep 2009 21:41:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] x86/cleanups for v2.6.32
Message-ID: <20090911194106.GA27608@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the x86-cleanups-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-cleanups-for-linus

 Thanks,

	Ingo

------------------>
Alan Cox (1):
      x86/cpu: Clean up various files a bit

Alexey Dobriyan (1):
      x86: uv: Clean up uv_ptc_init(), use proc_create()

Cyrill Gorcunov (2):
      x86: Clean up idt_descr and idt_tableby using NR_VECTORS instead of hardcoded number
      x86, ipi: Clean up safe_smp_processor_id() by using the cpu_has_apic() macro helper

Huang Weiyi (1):
      x86: Remove duplicated #include

Ingo Molnar (1):
      x86: Further clean up of mtrr/generic.c

Jaswinder Singh Rajput (10):
      x86: ds.c fix invalid assignment
      x86: Clean up mtrr/amd.c:
      x86: Clean up mtrr/centaur.c
      x86: Clean up mtrr/cleanup.c
      x86: Clean up mtrr/cyrix.c
      x86: Clean up mtrr/generic.c
      x86: Clean up mtrr/if.c
      x86: Clean up mtrr/mtrr.h
      x86: Clean up mtrr/state.c
      x86: Clean up mtrr/main.c

Marcin Slusarz (1):
      x86: Use printk_once()

Tobias Klauser (1):
      x86: Make memtype_seq_ops const


 arch/x86/kernel/apic/ipi.c             |    2 +-
 arch/x86/kernel/cpu/amd.c              |   37 ++--
 arch/x86/kernel/cpu/bugs.c             |   10 +-
 arch/x86/kernel/cpu/bugs_64.c          |    2 +-
 arch/x86/kernel/cpu/common.c           |   10 +-
 arch/x86/kernel/cpu/cyrix.c            |   19 +-
 arch/x86/kernel/cpu/hypervisor.c       |    5 +-
 arch/x86/kernel/cpu/intel.c            |   11 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c  |  116 +++++----
 arch/x86/kernel/cpu/mtrr/amd.c         |   97 ++++----
 arch/x86/kernel/cpu/mtrr/centaur.c     |  168 +++----------
 arch/x86/kernel/cpu/mtrr/cleanup.c     |  390 ++++++++++++++--------------
 arch/x86/kernel/cpu/mtrr/cyrix.c       |   94 ++++---
 arch/x86/kernel/cpu/mtrr/generic.c     |  304 ++++++++++++----------
 arch/x86/kernel/cpu/mtrr/if.c          |  135 ++++++----
 arch/x86/kernel/cpu/mtrr/main.c        |  455 +++++++++++++++++---------------
 arch/x86/kernel/cpu/mtrr/mtrr.h        |   19 +-
 arch/x86/kernel/cpu/mtrr/state.c       |   68 +++--
 arch/x86/kernel/cpu/perfctr-watchdog.c |   45 ++--
 arch/x86/kernel/cpu/proc.c             |    2 +-
 arch/x86/kernel/cpu/vmware.c           |   18 +-
 arch/x86/kernel/ds.c                   |    6 +-
 arch/x86/kernel/dumpstack.c            |    1 -
 arch/x86/kernel/irq_32.c               |    5 +-
 arch/x86/kernel/tlb_uv.c               |    4 +-
 arch/x86/kernel/traps.c                |    2 +-
 arch/x86/kvm/x86.c                     |    7 +-
 arch/x86/mm/pat.c                      |    2 +-
 28 files changed, 1024 insertions(+), 1010 deletions(-)

diff --git a/arch/x86/kernel/apic/ipi.c b/arch/x86/kernel/apic/ipi.c
index 6ef00ba..08385e0 100644
--- a/arch/x86/kernel/apic/ipi.c
+++ b/arch/x86/kernel/apic/ipi.c
@@ -153,7 +153,7 @@ int safe_smp_processor_id(void)
 {
 	int apicid, cpuid;
 
-	if (!boot_cpu_has(X86_FEATURE_APIC))
+	if (!cpu_has_apic)
 		return 0;
 
 	apicid = hard_smp_processor_id();
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 63fddcd..83b217c 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -2,7 +2,7 @@
 #include <linux/bitops.h>
 #include <linux/mm.h>
 
-#include <asm/io.h>
+#include <linux/io.h>
 #include <asm/processor.h>
 #include <asm/apic.h>
 #include <asm/cpu.h>
@@ -45,8 +45,8 @@ static void __cpuinit init_amd_k5(struct cpuinfo_x86 *c)
 #define CBAR_ENB	(0x80000000)
 #define CBAR_KEY	(0X000000CB)
 	if (c->x86_model == 9 || c->x86_model == 10) {
-		if (inl (CBAR) & CBAR_ENB)
-			outl (0 | CBAR_KEY, CBAR);
+		if (inl(CBAR) & CBAR_ENB)
+			outl(0 | CBAR_KEY, CBAR);
 	}
 }
 
@@ -87,9 +87,10 @@ static void __cpuinit init_amd_k6(struct cpuinfo_x86 *c)
 		d = d2-d;
 
 		if (d > 20*K6_BUG_LOOP)
-			printk("system stability may be impaired when more than 32 MB are used.\n");
+			printk(KERN_CONT
+				"system stability may be impaired when more than 32 MB are used.\n");
 		else
-			printk("probably OK (after B9730xxxx).\n");
+			printk(KERN_CONT "probably OK (after B9730xxxx).\n");
 		printk(KERN_INFO "Please see http://membres.lycos.fr/poulot/k6bug.html\n");
 	}
 
@@ -219,8 +220,9 @@ static void __cpuinit init_amd_k7(struct cpuinfo_x86 *c)
 	if ((c->x86_model == 8 && c->x86_mask >= 1) || (c->x86_model > 8)) {
 		rdmsr(MSR_K7_CLK_CTL, l, h);
 		if ((l & 0xfff00000) != 0x20000000) {
-			printk ("CPU: CLK_CTL MSR was %x. Reprogramming to %x\n", l,
-				((l & 0x000fffff)|0x20000000));
+			printk(KERN_INFO
+			    "CPU: CLK_CTL MSR was %x. Reprogramming to %x\n",
+					l, ((l & 0x000fffff)|0x20000000));
 			wrmsr(MSR_K7_CLK_CTL, (l & 0x000fffff)|0x20000000, h);
 		}
 	}
@@ -398,7 +400,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		u32 level;
 
 		level = cpuid_eax(1);
-		if((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
+		if ((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
 			set_cpu_cap(c, X86_FEATURE_REP_GOOD);
 
 		/*
@@ -494,27 +496,30 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		 * benefit in doing so.
 		 */
 		if (!rdmsrl_safe(MSR_K8_TSEG_ADDR, &tseg)) {
-		    printk(KERN_DEBUG "tseg: %010llx\n", tseg);
-		    if ((tseg>>PMD_SHIFT) <
+			printk(KERN_DEBUG "tseg: %010llx\n", tseg);
+			if ((tseg>>PMD_SHIFT) <
 				(max_low_pfn_mapped>>(PMD_SHIFT-PAGE_SHIFT)) ||
-			((tseg>>PMD_SHIFT) <
+				((tseg>>PMD_SHIFT) <
 				(max_pfn_mapped>>(PMD_SHIFT-PAGE_SHIFT)) &&
-			 (tseg>>PMD_SHIFT) >= (1ULL<<(32 - PMD_SHIFT))))
-			set_memory_4k((unsigned long)__va(tseg), 1);
+				(tseg>>PMD_SHIFT) >= (1ULL<<(32 - PMD_SHIFT))))
+				set_memory_4k((unsigned long)__va(tseg), 1);
 		}
 	}
 #endif
 }
 
 #ifdef CONFIG_X86_32
-static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 *c, unsigned int size)
+static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 *c,
+							unsigned int size)
 {
 	/* AMD errata T13 (order #21922) */
 	if ((c->x86 == 6)) {
-		if (c->x86_model == 3 && c->x86_mask == 0)	/* Duron Rev A0 */
+		/* Duron Rev A0 */
+		if (c->x86_model == 3 && c->x86_mask == 0)
 			size = 64;
+		/* Tbird rev A1/A2 */
 		if (c->x86_model == 4 &&
-		    (c->x86_mask == 0 || c->x86_mask == 1))	/* Tbird rev A1/A2 */
+			(c->x86_mask == 0 || c->x86_mask == 1))
 			size = 256;
 	}
 	return size;
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index c8e315f..01a2652 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -81,7 +81,7 @@ static void __init check_fpu(void)
 
 	boot_cpu_data.fdiv_bug = fdiv_bug;
 	if (boot_cpu_data.fdiv_bug)
-		printk("Hmm, FPU with FDIV bug.\n");
+		printk(KERN_WARNING "Hmm, FPU with FDIV bug.\n");
 }
 
 static void __init check_hlt(void)
@@ -98,7 +98,7 @@ static void __init check_hlt(void)
 	halt();
 	halt();
 	halt();
-	printk("OK.\n");
+	printk(KERN_CONT "OK.\n");
 }
 
 /*
@@ -122,9 +122,9 @@ static void __init check_popad(void)
 	 * CPU hard. Too bad.
 	 */
 	if (res != 12345678)
-		printk("Buggy.\n");
+		printk(KERN_CONT "Buggy.\n");
 	else
-		printk("OK.\n");
+		printk(KERN_CONT "OK.\n");
 #endif
 }
 
@@ -156,7 +156,7 @@ void __init check_bugs(void)
 {
 	identify_boot_cpu();
 #ifndef CONFIG_SMP
-	printk("CPU: ");
+	printk(KERN_INFO "CPU: ");
 	print_cpu_info(&boot_cpu_data);
 #endif
 	check_config();
diff --git a/arch/x86/kernel/cpu/bugs_64.c b/arch/x86/kernel/cpu/bugs_64.c
index 9a3ed06..04f0fe5 100644
--- a/arch/x86/kernel/cpu/bugs_64.c
+++ b/arch/x86/kernel/cpu/bugs_64.c
@@ -15,7 +15,7 @@ void __init check_bugs(void)
 {
 	identify_boot_cpu();
 #if !defined(CONFIG_SMP)
-	printk("CPU: ");
+	printk(KERN_INFO "CPU: ");
 	print_cpu_info(&boot_cpu_data);
 #endif
 	alternative_instructions();
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 5ce60a8..734eaad 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -18,8 +18,8 @@
 #include <asm/hypervisor.h>
 #include <asm/processor.h>
 #include <asm/sections.h>
-#include <asm/topology.h>
-#include <asm/cpumask.h>
+#include <linux/topology.h>
+#include <linux/cpumask.h>
 #include <asm/pgtable.h>
 #include <asm/atomic.h>
 #include <asm/proto.h>
@@ -28,13 +28,13 @@
 #include <asm/desc.h>
 #include <asm/i387.h>
 #include <asm/mtrr.h>
-#include <asm/numa.h>
+#include <linux/numa.h>
 #include <asm/asm.h>
 #include <asm/cpu.h>
 #include <asm/mce.h>
 #include <asm/msr.h>
 #include <asm/pat.h>
-#include <asm/smp.h>
+#include <linux/smp.h>
 
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/uv/uv.h>
@@ -982,7 +982,7 @@ static __init int setup_disablecpuid(char *arg)
 __setup("clearcpuid=", setup_disablecpuid);
 
 #ifdef CONFIG_X86_64
-struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
+struct desc_ptr idt_descr = { NR_VECTORS * 16 - 1, (unsigned long) idt_table };
 
 DEFINE_PER_CPU_FIRST(union irq_stack_union,
 		     irq_stack_union) __aligned(PAGE_SIZE);
diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index 593171e..19807b8 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -3,10 +3,10 @@
 #include <linux/delay.h>
 #include <linux/pci.h>
 #include <asm/dma.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include <asm/processor-cyrix.h>
 #include <asm/processor-flags.h>
-#include <asm/timer.h>
+#include <linux/timer.h>
 #include <asm/pci-direct.h>
 #include <asm/tsc.h>
 
@@ -282,7 +282,8 @@ static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 		 *  The 5510/5520 companion chips have a funky PIT.
 		 */
 		if (vendor == PCI_VENDOR_ID_CYRIX &&
-	 (device == PCI_DEVICE_ID_CYRIX_5510 || device == PCI_DEVICE_ID_CYRIX_5520))
+			(device == PCI_DEVICE_ID_CYRIX_5510 ||
+					device == PCI_DEVICE_ID_CYRIX_5520))
 			mark_tsc_unstable("cyrix 5510/5520 detected");
 	}
 #endif
@@ -299,7 +300,8 @@ static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 			 *  ?  : 0x7x
 			 * GX1 : 0x8x          GX1  datasheet 56
 			 */
-			if ((0x30 <= dir1 && dir1 <= 0x6f) || (0x80 <= dir1 && dir1 <= 0x8f))
+			if ((0x30 <= dir1 && dir1 <= 0x6f) ||
+					(0x80 <= dir1 && dir1 <= 0x8f))
 				geode_configure();
 			return;
 		} else { /* MediaGX */
@@ -427,9 +429,12 @@ static void __cpuinit cyrix_identify(struct cpuinfo_x86 *c)
 			printk(KERN_INFO "Enabling CPUID on Cyrix processor.\n");
 			local_irq_save(flags);
 			ccr3 = getCx86(CX86_CCR3);
-			setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10);       /* enable MAPEN  */
-			setCx86_old(CX86_CCR4, getCx86_old(CX86_CCR4) | 0x80);  /* enable cpuid  */
-			setCx86(CX86_CCR3, ccr3);                       /* disable MAPEN */
+			/* enable MAPEN  */
+			setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10);
+			/* enable cpuid  */
+			setCx86_old(CX86_CCR4, getCx86_old(CX86_CCR4) | 0x80);
+			/* disable MAPEN */
+			setCx86(CX86_CCR3, ccr3);
 			local_irq_restore(flags);
 		}
 	}
diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index fb5b86a..93ba8ee 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -28,11 +28,10 @@
 static inline void __cpuinit
 detect_hypervisor_vendor(struct cpuinfo_x86 *c)
 {
-	if (vmware_platform()) {
+	if (vmware_platform())
 		c->x86_hyper_vendor = X86_HYPER_VENDOR_VMWARE;
-	} else {
+	else
 		c->x86_hyper_vendor = X86_HYPER_VENDOR_NONE;
-	}
 }
 
 unsigned long get_hypervisor_tsc_freq(void)
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 3260ab0..80a722a 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -7,17 +7,17 @@
 #include <linux/sched.h>
 #include <linux/thread_info.h>
 #include <linux/module.h>
+#include <linux/uaccess.h>
 
 #include <asm/processor.h>
 #include <asm/pgtable.h>
 #include <asm/msr.h>
-#include <asm/uaccess.h>
 #include <asm/ds.h>
 #include <asm/bugs.h>
 #include <asm/cpu.h>
 
 #ifdef CONFIG_X86_64
-#include <asm/topology.h>
+#include <linux/topology.h>
 #include <asm/numa_64.h>
 #endif
 
@@ -174,7 +174,8 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 #ifdef CONFIG_X86_F00F_BUG
 	/*
 	 * All current models of Pentium and Pentium with MMX technology CPUs
-	 * have the F0 0F bug, which lets nonprivileged users lock up the system.
+	 * have the F0 0F bug, which lets nonprivileged users lock up the
+	 * system.
 	 * Note that the workaround only should be initialized once...
 	 */
 	c->f00f_bug = 0;
@@ -207,7 +208,7 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 			printk (KERN_INFO "CPU: C0 stepping P4 Xeon detected.\n");
 			printk (KERN_INFO "CPU: Disabling hardware prefetching (Errata 037)\n");
 			lo |= MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE;
-			wrmsr (MSR_IA32_MISC_ENABLE, lo, hi);
+			wrmsr(MSR_IA32_MISC_ENABLE, lo, hi);
 		}
 	}
 
@@ -283,7 +284,7 @@ static int __cpuinit intel_num_cpu_cores(struct cpuinfo_x86 *c)
 	/* Intel has a non-standard dependency on %ecx for this CPUID level. */
 	cpuid_count(4, 0, &eax, &ebx, &ecx, &edx);
 	if (eax & 0x1f)
-		return ((eax >> 26) + 1);
+		return (eax >> 26) + 1;
 	else
 		return 1;
 }
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 789efe2..306bf0d 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -3,7 +3,7 @@
  *
  *	Changes:
  *	Venkatesh Pallipadi	: Adding cache identification through cpuid(4)
- *		Ashok Raj <ashok.raj@intel.com>: Work with CPU hotplug infrastructure.
+ *	Ashok Raj <ashok.raj@intel.com>: Work with CPU hotplug infrastructure.
  *	Andi Kleen / Andreas Herrmann	: CPUID4 emulation on AMD.
  */
 
@@ -16,7 +16,7 @@
 #include <linux/pci.h>
 
 #include <asm/processor.h>
-#include <asm/smp.h>
+#include <linux/smp.h>
 #include <asm/k8.h>
 
 #define LVL_1_INST	1
@@ -25,14 +25,15 @@
 #define LVL_3		4
 #define LVL_TRACE	5
 
-struct _cache_table
-{
+struct _cache_table {
 	unsigned char descriptor;
 	char cache_type;
 	short size;
 };
 
-/* all the cache descriptor types we care about (no TLB or trace cache entries) */
+/* All the cache descriptor types we care about (no TLB or
+   trace cache entries) */
+
 static const struct _cache_table __cpuinitconst cache_table[] =
 {
 	{ 0x06, LVL_1_INST, 8 },	/* 4-way set assoc, 32 byte line size */
@@ -105,8 +106,7 @@ static const struct _cache_table __cpuinitconst cache_table[] =
 };
 
 
-enum _cache_type
-{
+enum _cache_type {
 	CACHE_TYPE_NULL	= 0,
 	CACHE_TYPE_DATA = 1,
 	CACHE_TYPE_INST = 2,
@@ -170,31 +170,31 @@ unsigned short			num_cache_leaves;
    Maybe later */
 union l1_cache {
 	struct {
-		unsigned line_size : 8;
-		unsigned lines_per_tag : 8;
-		unsigned assoc : 8;
-		unsigned size_in_kb : 8;
+		unsigned line_size:8;
+		unsigned lines_per_tag:8;
+		unsigned assoc:8;
+		unsigned size_in_kb:8;
 	};
 	unsigned val;
 };
 
 union l2_cache {
 	struct {
-		unsigned line_size : 8;
-		unsigned lines_per_tag : 4;
-		unsigned assoc : 4;
-		unsigned size_in_kb : 16;
+		unsigned line_size:8;
+		unsigned lines_per_tag:4;
+		unsigned assoc:4;
+		unsigned size_in_kb:16;
 	};
 	unsigned val;
 };
 
 union l3_cache {
 	struct {
-		unsigned line_size : 8;
-		unsigned lines_per_tag : 4;
-		unsigned assoc : 4;
-		unsigned res : 2;
-		unsigned size_encoded : 14;
+		unsigned line_size:8;
+		unsigned lines_per_tag:4;
+		unsigned assoc:4;
+		unsigned res:2;
+		unsigned size_encoded:14;
 	};
 	unsigned val;
 };
@@ -350,7 +350,8 @@ static int __cpuinit find_num_cache_leaves(void)
 
 unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 {
-	unsigned int trace = 0, l1i = 0, l1d = 0, l2 = 0, l3 = 0; /* Cache sizes */
+	/* Cache sizes */
+	unsigned int trace = 0, l1i = 0, l1d = 0, l2 = 0, l3 = 0;
 	unsigned int new_l1d = 0, new_l1i = 0; /* Cache sizes from cpuid(4) */
 	unsigned int new_l2 = 0, new_l3 = 0, i; /* Cache sizes from cpuid(4) */
 	unsigned int l2_id = 0, l3_id = 0, num_threads_sharing, index_msb;
@@ -377,8 +378,8 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 
 			retval = cpuid4_cache_lookup_regs(i, &this_leaf);
 			if (retval >= 0) {
-				switch(this_leaf.eax.split.level) {
-				    case 1:
+				switch (this_leaf.eax.split.level) {
+				case 1:
 					if (this_leaf.eax.split.type ==
 							CACHE_TYPE_DATA)
 						new_l1d = this_leaf.size/1024;
@@ -386,19 +387,20 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 							CACHE_TYPE_INST)
 						new_l1i = this_leaf.size/1024;
 					break;
-				    case 2:
+				case 2:
 					new_l2 = this_leaf.size/1024;
 					num_threads_sharing = 1 + this_leaf.eax.split.num_threads_sharing;
 					index_msb = get_count_order(num_threads_sharing);
 					l2_id = c->apicid >> index_msb;
 					break;
-				    case 3:
+				case 3:
 					new_l3 = this_leaf.size/1024;
 					num_threads_sharing = 1 + this_leaf.eax.split.num_threads_sharing;
-					index_msb = get_count_order(num_threads_sharing);
+					index_msb = get_count_order(
+							num_threads_sharing);
 					l3_id = c->apicid >> index_msb;
 					break;
-				    default:
+				default:
 					break;
 				}
 			}
@@ -421,22 +423,21 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 		/* Number of times to iterate */
 		n = cpuid_eax(2) & 0xFF;
 
-		for ( i = 0 ; i < n ; i++ ) {
+		for (i = 0 ; i < n ; i++) {
 			cpuid(2, &regs[0], &regs[1], &regs[2], &regs[3]);
 
 			/* If bit 31 is set, this is an unknown format */
-			for ( j = 0 ; j < 3 ; j++ ) {
-				if (regs[j] & (1 << 31)) regs[j] = 0;
-			}
+			for (j = 0 ; j < 3 ; j++)
+				if (regs[j] & (1 << 31))
+					regs[j] = 0;
 
 			/* Byte 0 is level count, not a descriptor */
-			for ( j = 1 ; j < 16 ; j++ ) {
+			for (j = 1 ; j < 16 ; j++) {
 				unsigned char des = dp[j];
 				unsigned char k = 0;
 
 				/* look up this descriptor in the table */
-				while (cache_table[k].descriptor != 0)
-				{
+				while (cache_table[k].descriptor != 0) {
 					if (cache_table[k].descriptor == des) {
 						if (only_trace && cache_table[k].cache_type != LVL_TRACE)
 							break;
@@ -488,14 +489,14 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 	}
 
 	if (trace)
-		printk (KERN_INFO "CPU: Trace cache: %dK uops", trace);
-	else if ( l1i )
-		printk (KERN_INFO "CPU: L1 I cache: %dK", l1i);
+		printk(KERN_INFO "CPU: Trace cache: %dK uops", trace);
+	else if (l1i)
+		printk(KERN_INFO "CPU: L1 I cache: %dK", l1i);
 
 	if (l1d)
-		printk(", L1 D cache: %dK\n", l1d);
+		printk(KERN_CONT ", L1 D cache: %dK\n", l1d);
 	else
-		printk("\n");
+		printk(KERN_CONT "\n");
 
 	if (l2)
 		printk(KERN_INFO "CPU: L2 cache: %dK\n", l2);
@@ -558,8 +559,13 @@ static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index)
 	}
 }
 #else
-static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index) {}
-static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index) {}
+static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
+{
+}
+
+static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index)
+{
+}
 #endif
 
 static void __cpuinit free_cache_attributes(unsigned int cpu)
@@ -645,7 +651,7 @@ static DEFINE_PER_CPU(struct _index_kobject *, index_kobject);
 static ssize_t show_##file_name						\
 			(struct _cpuid4_info *this_leaf, char *buf)	\
 {									\
-	return sprintf (buf, "%lu\n", (unsigned long)this_leaf->object + val); \
+	return sprintf(buf, "%lu\n", (unsigned long)this_leaf->object + val); \
 }
 
 show_one_plus(level, eax.split.level, 0);
@@ -656,7 +662,7 @@ show_one_plus(number_of_sets, ecx.split.number_of_sets, 1);
 
 static ssize_t show_size(struct _cpuid4_info *this_leaf, char *buf)
 {
-	return sprintf (buf, "%luK\n", this_leaf->size / 1024);
+	return sprintf(buf, "%luK\n", this_leaf->size / 1024);
 }
 
 static ssize_t show_shared_cpu_map_func(struct _cpuid4_info *this_leaf,
@@ -669,7 +675,7 @@ static ssize_t show_shared_cpu_map_func(struct _cpuid4_info *this_leaf,
 		const struct cpumask *mask;
 
 		mask = to_cpumask(this_leaf->shared_cpu_map);
-		n = type?
+		n = type ?
 			cpulist_scnprintf(buf, len-2, mask) :
 			cpumask_scnprintf(buf, len-2, mask);
 		buf[n++] = '\n';
@@ -800,7 +806,7 @@ static struct _cache_attr cache_disable_0 = __ATTR(cache_disable_0, 0644,
 static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
 		show_cache_disable_1, store_cache_disable_1);
 
-static struct attribute * default_attrs[] = {
+static struct attribute *default_attrs[] = {
 	&type.attr,
 	&level.attr,
 	&coherency_line_size.attr,
@@ -815,7 +821,7 @@ static struct attribute * default_attrs[] = {
 	NULL
 };
 
-static ssize_t show(struct kobject * kobj, struct attribute * attr, char * buf)
+static ssize_t show(struct kobject *kobj, struct attribute *attr, char *buf)
 {
 	struct _cache_attr *fattr = to_attr(attr);
 	struct _index_kobject *this_leaf = to_object(kobj);
@@ -828,8 +834,8 @@ static ssize_t show(struct kobject * kobj, struct attribute * attr, char * buf)
 	return ret;
 }
 
-static ssize_t store(struct kobject * kobj, struct attribute * attr,
-		     const char * buf, size_t count)
+static ssize_t store(struct kobject *kobj, struct attribute *attr,
+		     const char *buf, size_t count)
 {
 	struct _cache_attr *fattr = to_attr(attr);
 	struct _index_kobject *this_leaf = to_object(kobj);
@@ -883,7 +889,7 @@ static int __cpuinit cpuid4_cache_sysfs_init(unsigned int cpu)
 		goto err_out;
 
 	per_cpu(index_kobject, cpu) = kzalloc(
-	    sizeof(struct _index_kobject ) * num_cache_leaves, GFP_KERNEL);
+	    sizeof(struct _index_kobject) * num_cache_leaves, GFP_KERNEL);
 	if (unlikely(per_cpu(index_kobject, cpu) == NULL))
 		goto err_out;
 
@@ -917,7 +923,7 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 	}
 
 	for (i = 0; i < num_cache_leaves; i++) {
-		this_object = INDEX_KOBJECT_PTR(cpu,i);
+		this_object = INDEX_KOBJECT_PTR(cpu, i);
 		this_object->cpu = cpu;
 		this_object->index = i;
 		retval = kobject_init_and_add(&(this_object->kobj),
@@ -925,9 +931,8 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 					      per_cpu(cache_kobject, cpu),
 					      "index%1lu", i);
 		if (unlikely(retval)) {
-			for (j = 0; j < i; j++) {
-				kobject_put(&(INDEX_KOBJECT_PTR(cpu,j)->kobj));
-			}
+			for (j = 0; j < i; j++)
+				kobject_put(&(INDEX_KOBJECT_PTR(cpu, j)->kobj));
 			kobject_put(per_cpu(cache_kobject, cpu));
 			cpuid4_cache_sysfs_exit(cpu);
 			return retval;
@@ -952,7 +957,7 @@ static void __cpuinit cache_remove_dev(struct sys_device * sys_dev)
 	cpumask_clear_cpu(cpu, to_cpumask(cache_dev_map));
 
 	for (i = 0; i < num_cache_leaves; i++)
-		kobject_put(&(INDEX_KOBJECT_PTR(cpu,i)->kobj));
+		kobject_put(&(INDEX_KOBJECT_PTR(cpu, i)->kobj));
 	kobject_put(per_cpu(cache_kobject, cpu));
 	cpuid4_cache_sysfs_exit(cpu);
 }
@@ -977,8 +982,7 @@ static int __cpuinit cacheinfo_cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata cacheinfo_cpu_notifier =
-{
+static struct notifier_block __cpuinitdata cacheinfo_cpu_notifier = {
 	.notifier_call = cacheinfo_cpu_callback,
 };
 
diff --git a/arch/x86/kernel/cpu/mtrr/amd.c b/arch/x86/kernel/cpu/mtrr/amd.c
index ee2331b..33af141 100644
--- a/arch/x86/kernel/cpu/mtrr/amd.c
+++ b/arch/x86/kernel/cpu/mtrr/amd.c
@@ -7,15 +7,15 @@
 
 static void
 amd_get_mtrr(unsigned int reg, unsigned long *base,
-	     unsigned long *size, mtrr_type * type)
+	     unsigned long *size, mtrr_type *type)
 {
 	unsigned long low, high;
 
 	rdmsr(MSR_K6_UWCCR, low, high);
-	/*  Upper dword is region 1, lower is region 0  */
+	/* Upper dword is region 1, lower is region 0 */
 	if (reg == 1)
 		low = high;
-	/*  The base masks off on the right alignment  */
+	/* The base masks off on the right alignment */
 	*base = (low & 0xFFFE0000) >> PAGE_SHIFT;
 	*type = 0;
 	if (low & 1)
@@ -27,74 +27,81 @@ amd_get_mtrr(unsigned int reg, unsigned long *base,
 		return;
 	}
 	/*
-	 *  This needs a little explaining. The size is stored as an
-	 *  inverted mask of bits of 128K granularity 15 bits long offset
-	 *  2 bits
+	 * This needs a little explaining. The size is stored as an
+	 * inverted mask of bits of 128K granularity 15 bits long offset
+	 * 2 bits.
 	 *
-	 *  So to get a size we do invert the mask and add 1 to the lowest
-	 *  mask bit (4 as its 2 bits in). This gives us a size we then shift
-	 *  to turn into 128K blocks
+	 * So to get a size we do invert the mask and add 1 to the lowest
+	 * mask bit (4 as its 2 bits in). This gives us a size we then shift
+	 * to turn into 128K blocks.
 	 *
-	 *  eg              111 1111 1111 1100      is 512K
+	 * eg              111 1111 1111 1100      is 512K
 	 *
-	 *  invert          000 0000 0000 0011
-	 *  +1              000 0000 0000 0100
-	 *  *128K   ...
+	 * invert          000 0000 0000 0011
+	 * +1              000 0000 0000 0100
+	 * *128K   ...
 	 */
 	low = (~low) & 0x1FFFC;
 	*size = (low + 4) << (15 - PAGE_SHIFT);
-	return;
 }
 
-static void amd_set_mtrr(unsigned int reg, unsigned long base,
-			 unsigned long size, mtrr_type type)
-/*  [SUMMARY] Set variable MTRR register on the local CPU.
-    <reg> The register to set.
-    <base> The base address of the region.
-    <size> The size of the region. If this is 0 the region is disabled.
-    <type> The type of the region.
-    [RETURNS] Nothing.
-*/
+/**
+ * amd_set_mtrr - Set variable MTRR register on the local CPU.
+ *
+ * @reg The register to set.
+ * @base The base address of the region.
+ * @size The size of the region. If this is 0 the region is disabled.
+ * @type The type of the region.
+ *
+ * Returns nothing.
+ */
+static void
+amd_set_mtrr(unsigned int reg, unsigned long base, unsigned long size, mtrr_type type)
 {
 	u32 regs[2];
 
 	/*
-	 *  Low is MTRR0 , High MTRR 1
+	 * Low is MTRR0, High MTRR 1
 	 */
 	rdmsr(MSR_K6_UWCCR, regs[0], regs[1]);
 	/*
-	 *  Blank to disable
+	 * Blank to disable
 	 */
-	if (size == 0)
+	if (size == 0) {
 		regs[reg] = 0;
-	else
-		/* Set the register to the base, the type (off by one) and an
-		   inverted bitmask of the size The size is the only odd
-		   bit. We are fed say 512K We invert this and we get 111 1111
-		   1111 1011 but if you subtract one and invert you get the   
-		   desired 111 1111 1111 1100 mask
-
-		   But ~(x - 1) == ~x + 1 == -x. Two's complement rocks!  */
+	} else {
+		/*
+		 * Set the register to the base, the type (off by one) and an
+		 * inverted bitmask of the size The size is the only odd
+		 * bit. We are fed say 512K We invert this and we get 111 1111
+		 * 1111 1011 but if you subtract one and invert you get the
+		 * desired 111 1111 1111 1100 mask
+		 *
+		 *  But ~(x - 1) == ~x + 1 == -x. Two's complement rocks!
+		 */
 		regs[reg] = (-size >> (15 - PAGE_SHIFT) & 0x0001FFFC)
 		    | (base << PAGE_SHIFT) | (type + 1);
+	}
 
 	/*
-	 *  The writeback rule is quite specific. See the manual. Its
-	 *  disable local interrupts, write back the cache, set the mtrr
+	 * The writeback rule is quite specific. See the manual. Its
+	 * disable local interrupts, write back the cache, set the mtrr
 	 */
 	wbinvd();
 	wrmsr(MSR_K6_UWCCR, regs[0], regs[1]);
 }
 
-static int amd_validate_add_page(unsigned long base, unsigned long size, unsigned int type)
+static int
+amd_validate_add_page(unsigned long base, unsigned long size, unsigned int type)
 {
-	/* Apply the K6 block alignment and size rules
-	   In order
-	   o Uncached or gathering only
-	   o 128K or bigger block
-	   o Power of 2 block
-	   o base suitably aligned to the power
-	*/
+	/*
+	 * Apply the K6 block alignment and size rules
+	 * In order
+	 * o Uncached or gathering only
+	 * o 128K or bigger block
+	 * o Power of 2 block
+	 * o base suitably aligned to the power
+	 */
 	if (type > MTRR_TYPE_WRCOMB || size < (1 << (17 - PAGE_SHIFT))
 	    || (size & ~(size - 1)) - size || (base & (size - 1)))
 		return -EINVAL;
@@ -115,5 +122,3 @@ int __init amd_init_mtrr(void)
 	set_mtrr_ops(&amd_mtrr_ops);
 	return 0;
 }
-
-//arch_initcall(amd_mtrr_init);
diff --git a/arch/x86/kernel/cpu/mtrr/centaur.c b/arch/x86/kernel/cpu/mtrr/centaur.c
index cb9aa3a..de89f14 100644
--- a/arch/x86/kernel/cpu/mtrr/centaur.c
+++ b/arch/x86/kernel/cpu/mtrr/centaur.c
@@ -1,7 +1,9 @@
 #include <linux/init.h>
 #include <linux/mm.h>
+
 #include <asm/mtrr.h>
 #include <asm/msr.h>
+
 #include "mtrr.h"
 
 static struct {
@@ -12,25 +14,25 @@ static struct {
 static u8 centaur_mcr_reserved;
 static u8 centaur_mcr_type;	/* 0 for winchip, 1 for winchip2 */
 
-/*
- *	Report boot time MCR setups 
+/**
+ * centaur_get_free_region - Get a free MTRR.
+ *
+ * @base: The starting (base) address of the region.
+ * @size: The size (in bytes) of the region.
+ *
+ * Returns: the index of the region on success, else -1 on error.
  */
-
 static int
 centaur_get_free_region(unsigned long base, unsigned long size, int replace_reg)
-/*  [SUMMARY] Get a free MTRR.
-    <base> The starting (base) address of the region.
-    <size> The size (in bytes) of the region.
-    [RETURNS] The index of the region on success, else -1 on error.
-*/
 {
-	int i, max;
-	mtrr_type ltype;
 	unsigned long lbase, lsize;
+	mtrr_type ltype;
+	int i, max;
 
 	max = num_var_ranges;
 	if (replace_reg >= 0 && replace_reg < max)
 		return replace_reg;
+
 	for (i = 0; i < max; ++i) {
 		if (centaur_mcr_reserved & (1 << i))
 			continue;
@@ -38,11 +40,14 @@ centaur_get_free_region(unsigned long base, unsigned long size, int replace_reg)
 		if (lsize == 0)
 			return i;
 	}
+
 	return -ENOSPC;
 }
 
-void
-mtrr_centaur_report_mcr(int mcr, u32 lo, u32 hi)
+/*
+ * Report boot time MCR setups
+ */
+void mtrr_centaur_report_mcr(int mcr, u32 lo, u32 hi)
 {
 	centaur_mcr[mcr].low = lo;
 	centaur_mcr[mcr].high = hi;
@@ -54,33 +59,35 @@ centaur_get_mcr(unsigned int reg, unsigned long *base,
 {
 	*base = centaur_mcr[reg].high >> PAGE_SHIFT;
 	*size = -(centaur_mcr[reg].low & 0xfffff000) >> PAGE_SHIFT;
-	*type = MTRR_TYPE_WRCOMB;	/*  If it is there, it is write-combining  */
+	*type = MTRR_TYPE_WRCOMB;		/* write-combining  */
+
 	if (centaur_mcr_type == 1 && ((centaur_mcr[reg].low & 31) & 2))
 		*type = MTRR_TYPE_UNCACHABLE;
 	if (centaur_mcr_type == 1 && (centaur_mcr[reg].low & 31) == 25)
 		*type = MTRR_TYPE_WRBACK;
 	if (centaur_mcr_type == 0 && (centaur_mcr[reg].low & 31) == 31)
 		*type = MTRR_TYPE_WRBACK;
-
 }
 
-static void centaur_set_mcr(unsigned int reg, unsigned long base,
-			    unsigned long size, mtrr_type type)
+static void
+centaur_set_mcr(unsigned int reg, unsigned long base,
+		unsigned long size, mtrr_type type)
 {
 	unsigned long low, high;
 
 	if (size == 0) {
-		/*  Disable  */
+		/* Disable */
 		high = low = 0;
 	} else {
 		high = base << PAGE_SHIFT;
-		if (centaur_mcr_type == 0)
-			low = -size << PAGE_SHIFT | 0x1f;	/* only support write-combining... */
-		else {
+		if (centaur_mcr_type == 0) {
+			/* Only support write-combining... */
+			low = -size << PAGE_SHIFT | 0x1f;
+		} else {
 			if (type == MTRR_TYPE_UNCACHABLE)
-				low = -size << PAGE_SHIFT | 0x02;	/* NC */
+				low = -size << PAGE_SHIFT | 0x02; /* NC */
 			else
-				low = -size << PAGE_SHIFT | 0x09;	/* WWO,WC */
+				low = -size << PAGE_SHIFT | 0x09; /* WWO, WC */
 		}
 	}
 	centaur_mcr[reg].high = high;
@@ -88,118 +95,16 @@ static void centaur_set_mcr(unsigned int reg, unsigned long base,
 	wrmsr(MSR_IDT_MCR0 + reg, low, high);
 }
 
-#if 0
-/*
- *	Initialise the later (saner) Winchip MCR variant. In this version
- *	the BIOS can pass us the registers it has used (but not their values)
- *	and the control register is read/write
- */
-
-static void __init
-centaur_mcr1_init(void)
-{
-	unsigned i;
-	u32 lo, hi;
-
-	/* Unfortunately, MCR's are read-only, so there is no way to
-	 * find out what the bios might have done.
-	 */
-
-	rdmsr(MSR_IDT_MCR_CTRL, lo, hi);
-	if (((lo >> 17) & 7) == 1) {	/* Type 1 Winchip2 MCR */
-		lo &= ~0x1C0;	/* clear key */
-		lo |= 0x040;	/* set key to 1 */
-		wrmsr(MSR_IDT_MCR_CTRL, lo, hi);	/* unlock MCR */
-	}
-
-	centaur_mcr_type = 1;
-
-	/*
-	 *  Clear any unconfigured MCR's.
-	 */
-
-	for (i = 0; i < 8; ++i) {
-		if (centaur_mcr[i].high == 0 && centaur_mcr[i].low == 0) {
-			if (!(lo & (1 << (9 + i))))
-				wrmsr(MSR_IDT_MCR0 + i, 0, 0);
-			else
-				/*
-				 *      If the BIOS set up an MCR we cannot see it
-				 *      but we don't wish to obliterate it
-				 */
-				centaur_mcr_reserved |= (1 << i);
-		}
-	}
-	/*  
-	 *  Throw the main write-combining switch... 
-	 *  However if OOSTORE is enabled then people have already done far
-	 *  cleverer things and we should behave. 
-	 */
-
-	lo |= 15;		/* Write combine enables */
-	wrmsr(MSR_IDT_MCR_CTRL, lo, hi);
-}
-
-/*
- *	Initialise the original winchip with read only MCR registers
- *	no used bitmask for the BIOS to pass on and write only control
- */
-
-static void __init
-centaur_mcr0_init(void)
-{
-	unsigned i;
-
-	/* Unfortunately, MCR's are read-only, so there is no way to
-	 * find out what the bios might have done.
-	 */
-
-	/* Clear any unconfigured MCR's.
-	 * This way we are sure that the centaur_mcr array contains the actual
-	 * values. The disadvantage is that any BIOS tweaks are thus undone.
-	 *
-	 */
-	for (i = 0; i < 8; ++i) {
-		if (centaur_mcr[i].high == 0 && centaur_mcr[i].low == 0)
-			wrmsr(MSR_IDT_MCR0 + i, 0, 0);
-	}
-
-	wrmsr(MSR_IDT_MCR_CTRL, 0x01F0001F, 0);	/* Write only */
-}
-
-/*
- *	Initialise Winchip series MCR registers
- */
-
-static void __init
-centaur_mcr_init(void)
-{
-	struct set_mtrr_context ctxt;
-
-	set_mtrr_prepare_save(&ctxt);
-	set_mtrr_cache_disable(&ctxt);
-
-	if (boot_cpu_data.x86_model == 4)
-		centaur_mcr0_init();
-	else if (boot_cpu_data.x86_model == 8 || boot_cpu_data.x86_model == 9)
-		centaur_mcr1_init();
-
-	set_mtrr_done(&ctxt);
-}
-#endif
-
-static int centaur_validate_add_page(unsigned long base, 
-				     unsigned long size, unsigned int type)
+static int
+centaur_validate_add_page(unsigned long base, unsigned long size, unsigned int type)
 {
 	/*
-	 *  FIXME: Winchip2 supports uncached
+	 * FIXME: Winchip2 supports uncached
 	 */
-	if (type != MTRR_TYPE_WRCOMB && 
+	if (type != MTRR_TYPE_WRCOMB &&
 	    (centaur_mcr_type == 0 || type != MTRR_TYPE_UNCACHABLE)) {
-		printk(KERN_WARNING
-		       "mtrr: only write-combining%s supported\n",
-		       centaur_mcr_type ? " and uncacheable are"
-		       : " is");
+		pr_warning("mtrr: only write-combining%s supported\n",
+			   centaur_mcr_type ? " and uncacheable are" : " is");
 		return -EINVAL;
 	}
 	return 0;
@@ -207,7 +112,6 @@ static int centaur_validate_add_page(unsigned long base,
 
 static struct mtrr_ops centaur_mtrr_ops = {
 	.vendor            = X86_VENDOR_CENTAUR,
-//	.init              = centaur_mcr_init,
 	.set               = centaur_set_mcr,
 	.get               = centaur_get_mcr,
 	.get_free_region   = centaur_get_free_region,
@@ -220,5 +124,3 @@ int __init centaur_init_mtrr(void)
 	set_mtrr_ops(&centaur_mtrr_ops);
 	return 0;
 }
-
-//arch_initcall(centaur_init_mtrr);
diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index 1d584a1..315738c 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -1,51 +1,75 @@
-/*  MTRR (Memory Type Range Register) cleanup
-
-    Copyright (C) 2009 Yinghai Lu
-
-    This library is free software; you can redistribute it and/or
-    modify it under the terms of the GNU Library General Public
-    License as published by the Free Software Foundation; either
-    version 2 of the License, or (at your option) any later version.
-
-    This library is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-    Library General Public License for more details.
-
-    You should have received a copy of the GNU Library General Public
-    License along with this library; if not, write to the Free
-    Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-*/
-
+/*
+ * MTRR (Memory Type Range Register) cleanup
+ *
+ *  Copyright (C) 2009 Yinghai Lu
+ *
+ * This library is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Library General Public
+ * License as published by the Free Software Foundation; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Library General Public License for more details.
+ *
+ * You should have received a copy of the GNU Library General Public
+ * License along with this library; if not, write to the Free
+ * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/smp.h>
 #include <linux/cpu.h>
-#include <linux/mutex.h>
 #include <linux/sort.h>
+#include <linux/mutex.h>
+#include <linux/uaccess.h>
+#include <linux/kvm_para.h>
 
+#include <asm/processor.h>
 #include <asm/e820.h>
 #include <asm/mtrr.h>
-#include <asm/uaccess.h>
-#include <asm/processor.h>
 #include <asm/msr.h>
-#include <asm/kvm_para.h>
-#include "mtrr.h"
 
-/* should be related to MTRR_VAR_RANGES nums */
-#define RANGE_NUM 256
+#include "mtrr.h"
 
 struct res_range {
-	unsigned long start;
-	unsigned long end;
+	unsigned long	start;
+	unsigned long	end;
+};
+
+struct var_mtrr_range_state {
+	unsigned long	base_pfn;
+	unsigned long	size_pfn;
+	mtrr_type	type;
+};
+
+struct var_mtrr_state {
+	unsigned long	range_startk;
+	unsigned long	range_sizek;
+	unsigned long	chunk_sizek;
+	unsigned long	gran_sizek;
+	unsigned int	reg;
 };
 
+/* Should be related to MTRR_VAR_RANGES nums */
+#define RANGE_NUM				256
+
+static struct res_range __initdata		range[RANGE_NUM];
+static int __initdata				nr_range;
+
+static struct var_mtrr_range_state __initdata	range_state[RANGE_NUM];
+
+static int __initdata debug_print;
+#define Dprintk(x...) do { if (debug_print) printk(KERN_DEBUG x); } while (0)
+
+
 static int __init
-add_range(struct res_range *range, int nr_range, unsigned long start,
-			      unsigned long end)
+add_range(struct res_range *range, int nr_range,
+	  unsigned long start, unsigned long end)
 {
-	/* out of slots */
+	/* Out of slots: */
 	if (nr_range >= RANGE_NUM)
 		return nr_range;
 
@@ -58,12 +82,12 @@ add_range(struct res_range *range, int nr_range, unsigned long start,
 }
 
 static int __init
-add_range_with_merge(struct res_range *range, int nr_range, unsigned long start,
-			      unsigned long end)
+add_range_with_merge(struct res_range *range, int nr_range,
+		     unsigned long start, unsigned long end)
 {
 	int i;
 
-	/* try to merge it with old one */
+	/* Try to merge it with old one: */
 	for (i = 0; i < nr_range; i++) {
 		unsigned long final_start, final_end;
 		unsigned long common_start, common_end;
@@ -84,7 +108,7 @@ add_range_with_merge(struct res_range *range, int nr_range, unsigned long start,
 		return nr_range;
 	}
 
-	/* need to add that */
+	/* Need to add it: */
 	return add_range(range, nr_range, start, end);
 }
 
@@ -117,7 +141,7 @@ subtract_range(struct res_range *range, unsigned long start, unsigned long end)
 		}
 
 		if (start > range[j].start && end < range[j].end) {
-			/* find the new spare */
+			/* Find the new spare: */
 			for (i = 0; i < RANGE_NUM; i++) {
 				if (range[i].end == 0)
 					break;
@@ -146,14 +170,8 @@ static int __init cmp_range(const void *x1, const void *x2)
 	return start1 - start2;
 }
 
-struct var_mtrr_range_state {
-	unsigned long base_pfn;
-	unsigned long size_pfn;
-	mtrr_type type;
-};
-
-static struct var_mtrr_range_state __initdata range_state[RANGE_NUM];
-static int __initdata debug_print;
+#define BIOS_BUG_MSG KERN_WARNING \
+	"WARNING: BIOS bug: VAR MTRR %d contains strange UC entry under 1M, check with your system vendor!\n"
 
 static int __init
 x86_get_mtrr_mem_range(struct res_range *range, int nr_range,
@@ -180,7 +198,7 @@ x86_get_mtrr_mem_range(struct res_range *range, int nr_range,
 				 range[i].start, range[i].end + 1);
 	}
 
-	/* take out UC ranges */
+	/* Take out UC ranges: */
 	for (i = 0; i < num_var_ranges; i++) {
 		type = range_state[i].type;
 		if (type != MTRR_TYPE_UNCACHABLE &&
@@ -193,9 +211,7 @@ x86_get_mtrr_mem_range(struct res_range *range, int nr_range,
 		if (base < (1<<(20-PAGE_SHIFT)) && mtrr_state.have_fixed &&
 		    (mtrr_state.enabled & 1)) {
 			/* Var MTRR contains UC entry below 1M? Skip it: */
-			printk(KERN_WARNING "WARNING: BIOS bug: VAR MTRR %d "
-				"contains strange UC entry under 1M, check "
-				"with your system vendor!\n", i);
+			printk(BIOS_BUG_MSG, i);
 			if (base + size <= (1<<(20-PAGE_SHIFT)))
 				continue;
 			size -= (1<<(20-PAGE_SHIFT)) - base;
@@ -237,17 +253,13 @@ x86_get_mtrr_mem_range(struct res_range *range, int nr_range,
 	return nr_range;
 }
 
-static struct res_range __initdata range[RANGE_NUM];
-static int __initdata nr_range;
-
 #ifdef CONFIG_MTRR_SANITIZER
 
 static unsigned long __init sum_ranges(struct res_range *range, int nr_range)
 {
-	unsigned long sum;
+	unsigned long sum = 0;
 	int i;
 
-	sum = 0;
 	for (i = 0; i < nr_range; i++)
 		sum += range[i].end + 1 - range[i].start;
 
@@ -278,17 +290,9 @@ static int __init mtrr_cleanup_debug_setup(char *str)
 }
 early_param("mtrr_cleanup_debug", mtrr_cleanup_debug_setup);
 
-struct var_mtrr_state {
-	unsigned long	range_startk;
-	unsigned long	range_sizek;
-	unsigned long	chunk_sizek;
-	unsigned long	gran_sizek;
-	unsigned int	reg;
-};
-
 static void __init
 set_var_mtrr(unsigned int reg, unsigned long basek, unsigned long sizek,
-		unsigned char type, unsigned int address_bits)
+	     unsigned char type, unsigned int address_bits)
 {
 	u32 base_lo, base_hi, mask_lo, mask_hi;
 	u64 base, mask;
@@ -301,7 +305,7 @@ set_var_mtrr(unsigned int reg, unsigned long basek, unsigned long sizek,
 	mask = (1ULL << address_bits) - 1;
 	mask &= ~((((u64)sizek) << 10) - 1);
 
-	base  = ((u64)basek) << 10;
+	base = ((u64)basek) << 10;
 
 	base |= type;
 	mask |= 0x800;
@@ -317,15 +321,14 @@ set_var_mtrr(unsigned int reg, unsigned long basek, unsigned long sizek,
 
 static void __init
 save_var_mtrr(unsigned int reg, unsigned long basek, unsigned long sizek,
-		unsigned char type)
+	      unsigned char type)
 {
 	range_state[reg].base_pfn = basek >> (PAGE_SHIFT - 10);
 	range_state[reg].size_pfn = sizek >> (PAGE_SHIFT - 10);
 	range_state[reg].type = type;
 }
 
-static void __init
-set_var_mtrr_all(unsigned int address_bits)
+static void __init set_var_mtrr_all(unsigned int address_bits)
 {
 	unsigned long basek, sizek;
 	unsigned char type;
@@ -342,11 +345,11 @@ set_var_mtrr_all(unsigned int address_bits)
 
 static unsigned long to_size_factor(unsigned long sizek, char *factorp)
 {
-	char factor;
 	unsigned long base = sizek;
+	char factor;
 
 	if (base & ((1<<10) - 1)) {
-		/* not MB alignment */
+		/* Not MB-aligned: */
 		factor = 'K';
 	} else if (base & ((1<<20) - 1)) {
 		factor = 'M';
@@ -372,11 +375,12 @@ range_to_mtrr(unsigned int reg, unsigned long range_startk,
 		unsigned long max_align, align;
 		unsigned long sizek;
 
-		/* Compute the maximum size I can make a range */
+		/* Compute the maximum size with which we can make a range: */
 		if (range_startk)
 			max_align = ffs(range_startk) - 1;
 		else
 			max_align = 32;
+
 		align = fls(range_sizek) - 1;
 		if (align > max_align)
 			align = max_align;
@@ -386,11 +390,10 @@ range_to_mtrr(unsigned int reg, unsigned long range_startk,
 			char start_factor = 'K', size_factor = 'K';
 			unsigned long start_base, size_base;
 
-			start_base = to_size_factor(range_startk,
-							 &start_factor),
-			size_base = to_size_factor(sizek, &size_factor),
+			start_base = to_size_factor(range_startk, &start_factor);
+			size_base = to_size_factor(sizek, &size_factor);
 
-			printk(KERN_DEBUG "Setting variable MTRR %d, "
+			Dprintk("Setting variable MTRR %d, "
 				"base: %ld%cB, range: %ld%cB, type %s\n",
 				reg, start_base, start_factor,
 				size_base, size_factor,
@@ -425,10 +428,11 @@ range_to_mtrr_with_hole(struct var_mtrr_state *state, unsigned long basek,
 	chunk_sizek = state->chunk_sizek;
 	gran_sizek = state->gran_sizek;
 
-	/* align with gran size, prevent small block used up MTRRs */
+	/* Align with gran size, prevent small block used up MTRRs: */
 	range_basek = ALIGN(state->range_startk, gran_sizek);
 	if ((range_basek > basek) && basek)
 		return second_sizek;
+
 	state->range_sizek -= (range_basek - state->range_startk);
 	range_sizek = ALIGN(state->range_sizek, gran_sizek);
 
@@ -439,22 +443,21 @@ range_to_mtrr_with_hole(struct var_mtrr_state *state, unsigned long basek,
 	}
 	state->range_sizek = range_sizek;
 
-	/* try to append some small hole */
+	/* Try to append some small hole: */
 	range0_basek = state->range_startk;
 	range0_sizek = ALIGN(state->range_sizek, chunk_sizek);
 
-	/* no increase */
+	/* No increase: */
 	if (range0_sizek == state->range_sizek) {
-		if (debug_print)
-			printk(KERN_DEBUG "rangeX: %016lx - %016lx\n",
-				range0_basek<<10,
-				(range0_basek + state->range_sizek)<<10);
+		Dprintk("rangeX: %016lx - %016lx\n",
+			range0_basek<<10,
+			(range0_basek + state->range_sizek)<<10);
 		state->reg = range_to_mtrr(state->reg, range0_basek,
 				state->range_sizek, MTRR_TYPE_WRBACK);
 		return 0;
 	}
 
-	/* only cut back, when it is not the last */
+	/* Only cut back when it is not the last: */
 	if (sizek) {
 		while (range0_basek + range0_sizek > (basek + sizek)) {
 			if (range0_sizek >= chunk_sizek)
@@ -470,16 +473,16 @@ range_to_mtrr_with_hole(struct var_mtrr_state *state, unsigned long basek,
 second_try:
 	range_basek = range0_basek + range0_sizek;
 
-	/* one hole in the middle */
+	/* One hole in the middle: */
 	if (range_basek > basek && range_basek <= (basek + sizek))
 		second_sizek = range_basek - basek;
 
 	if (range0_sizek > state->range_sizek) {
 
-		/* one hole in middle or at end */
+		/* One hole in middle or at the end: */
 		hole_sizek = range0_sizek - state->range_sizek - second_sizek;
 
-		/* hole size should be less than half of range0 size */
+		/* Hole size should be less than half of range0 size: */
 		if (hole_sizek >= (range0_sizek >> 1) &&
 		    range0_sizek >= chunk_sizek) {
 			range0_sizek -= chunk_sizek;
@@ -491,32 +494,30 @@ second_try:
 	}
 
 	if (range0_sizek) {
-		if (debug_print)
-			printk(KERN_DEBUG "range0: %016lx - %016lx\n",
-				range0_basek<<10,
-				(range0_basek + range0_sizek)<<10);
+		Dprintk("range0: %016lx - %016lx\n",
+			range0_basek<<10,
+			(range0_basek + range0_sizek)<<10);
 		state->reg = range_to_mtrr(state->reg, range0_basek,
 				range0_sizek, MTRR_TYPE_WRBACK);
 	}
 
 	if (range0_sizek < state->range_sizek) {
-		/* need to handle left over */
+		/* Need to handle left over range: */
 		range_sizek = state->range_sizek - range0_sizek;
 
-		if (debug_print)
-			printk(KERN_DEBUG "range: %016lx - %016lx\n",
-				 range_basek<<10,
-				 (range_basek + range_sizek)<<10);
+		Dprintk("range: %016lx - %016lx\n",
+			 range_basek<<10,
+			 (range_basek + range_sizek)<<10);
+
 		state->reg = range_to_mtrr(state->reg, range_basek,
 				 range_sizek, MTRR_TYPE_WRBACK);
 	}
 
 	if (hole_sizek) {
 		hole_basek = range_basek - hole_sizek - second_sizek;
-		if (debug_print)
-			printk(KERN_DEBUG "hole: %016lx - %016lx\n",
-				 hole_basek<<10,
-				 (hole_basek + hole_sizek)<<10);
+		Dprintk("hole: %016lx - %016lx\n",
+			 hole_basek<<10,
+			 (hole_basek + hole_sizek)<<10);
 		state->reg = range_to_mtrr(state->reg, hole_basek,
 				 hole_sizek, MTRR_TYPE_UNCACHABLE);
 	}
@@ -537,23 +538,23 @@ set_var_mtrr_range(struct var_mtrr_state *state, unsigned long base_pfn,
 	basek = base_pfn << (PAGE_SHIFT - 10);
 	sizek = size_pfn << (PAGE_SHIFT - 10);
 
-	/* See if I can merge with the last range */
+	/* See if I can merge with the last range: */
 	if ((basek <= 1024) ||
 	    (state->range_startk + state->range_sizek == basek)) {
 		unsigned long endk = basek + sizek;
 		state->range_sizek = endk - state->range_startk;
 		return;
 	}
-	/* Write the range mtrrs */
+	/* Write the range mtrrs: */
 	if (state->range_sizek != 0)
 		second_sizek = range_to_mtrr_with_hole(state, basek, sizek);
 
-	/* Allocate an msr */
+	/* Allocate an msr: */
 	state->range_startk = basek + second_sizek;
 	state->range_sizek  = sizek - second_sizek;
 }
 
-/* mininum size of mtrr block that can take hole */
+/* Mininum size of mtrr block that can take hole: */
 static u64 mtrr_chunk_size __initdata = (256ULL<<20);
 
 static int __init parse_mtrr_chunk_size_opt(char *p)
@@ -565,7 +566,7 @@ static int __init parse_mtrr_chunk_size_opt(char *p)
 }
 early_param("mtrr_chunk_size", parse_mtrr_chunk_size_opt);
 
-/* granity of mtrr of block */
+/* Granularity of mtrr of block: */
 static u64 mtrr_gran_size __initdata;
 
 static int __init parse_mtrr_gran_size_opt(char *p)
@@ -577,7 +578,7 @@ static int __init parse_mtrr_gran_size_opt(char *p)
 }
 early_param("mtrr_gran_size", parse_mtrr_gran_size_opt);
 
-static int nr_mtrr_spare_reg __initdata =
+static unsigned long nr_mtrr_spare_reg __initdata =
 				 CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT;
 
 static int __init parse_mtrr_spare_reg(char *arg)
@@ -586,7 +587,6 @@ static int __init parse_mtrr_spare_reg(char *arg)
 		nr_mtrr_spare_reg = simple_strtoul(arg, NULL, 0);
 	return 0;
 }
-
 early_param("mtrr_spare_reg_nr", parse_mtrr_spare_reg);
 
 static int __init
@@ -594,8 +594,8 @@ x86_setup_var_mtrrs(struct res_range *range, int nr_range,
 		    u64 chunk_size, u64 gran_size)
 {
 	struct var_mtrr_state var_state;
-	int i;
 	int num_reg;
+	int i;
 
 	var_state.range_startk	= 0;
 	var_state.range_sizek	= 0;
@@ -605,17 +605,18 @@ x86_setup_var_mtrrs(struct res_range *range, int nr_range,
 
 	memset(range_state, 0, sizeof(range_state));
 
-	/* Write the range etc */
-	for (i = 0; i < nr_range; i++)
+	/* Write the range: */
+	for (i = 0; i < nr_range; i++) {
 		set_var_mtrr_range(&var_state, range[i].start,
 				   range[i].end - range[i].start + 1);
+	}
 
-	/* Write the last range */
+	/* Write the last range: */
 	if (var_state.range_sizek != 0)
 		range_to_mtrr_with_hole(&var_state, 0, 0);
 
 	num_reg = var_state.reg;
-	/* Clear out the extra MTRR's */
+	/* Clear out the extra MTRR's: */
 	while (var_state.reg < num_var_ranges) {
 		save_var_mtrr(var_state.reg, 0, 0, 0);
 		var_state.reg++;
@@ -625,11 +626,11 @@ x86_setup_var_mtrrs(struct res_range *range, int nr_range,
 }
 
 struct mtrr_cleanup_result {
-	unsigned long gran_sizek;
-	unsigned long chunk_sizek;
-	unsigned long lose_cover_sizek;
-	unsigned int num_reg;
-	int bad;
+	unsigned long	gran_sizek;
+	unsigned long	chunk_sizek;
+	unsigned long	lose_cover_sizek;
+	unsigned int	num_reg;
+	int		bad;
 };
 
 /*
@@ -645,10 +646,10 @@ static unsigned long __initdata min_loss_pfn[RANGE_NUM];
 
 static void __init print_out_mtrr_range_state(void)
 {
-	int i;
 	char start_factor = 'K', size_factor = 'K';
 	unsigned long start_base, size_base;
 	mtrr_type type;
+	int i;
 
 	for (i = 0; i < num_var_ranges; i++) {
 
@@ -676,10 +677,10 @@ static int __init mtrr_need_cleanup(void)
 	int i;
 	mtrr_type type;
 	unsigned long size;
-	/* extra one for all 0 */
+	/* Extra one for all 0: */
 	int num[MTRR_NUM_TYPES + 1];
 
-	/* check entries number */
+	/* Check entries number: */
 	memset(num, 0, sizeof(num));
 	for (i = 0; i < num_var_ranges; i++) {
 		type = range_state[i].type;
@@ -693,88 +694,86 @@ static int __init mtrr_need_cleanup(void)
 		num[type]++;
 	}
 
-	/* check if we got UC entries */
+	/* Check if we got UC entries: */
 	if (!num[MTRR_TYPE_UNCACHABLE])
 		return 0;
 
-	/* check if we only had WB and UC */
+	/* Check if we only had WB and UC */
 	if (num[MTRR_TYPE_WRBACK] + num[MTRR_TYPE_UNCACHABLE] !=
-		num_var_ranges - num[MTRR_NUM_TYPES])
+	    num_var_ranges - num[MTRR_NUM_TYPES])
 		return 0;
 
 	return 1;
 }
 
 static unsigned long __initdata range_sums;
-static void __init mtrr_calc_range_state(u64 chunk_size, u64 gran_size,
-					 unsigned long extra_remove_base,
-					 unsigned long extra_remove_size,
-					 int i)
+
+static void __init
+mtrr_calc_range_state(u64 chunk_size, u64 gran_size,
+		      unsigned long x_remove_base,
+		      unsigned long x_remove_size, int i)
 {
-	int num_reg;
 	static struct res_range range_new[RANGE_NUM];
-	static int nr_range_new;
 	unsigned long range_sums_new;
+	static int nr_range_new;
+	int num_reg;
 
-	/* convert ranges to var ranges state */
-	num_reg = x86_setup_var_mtrrs(range, nr_range,
-						chunk_size, gran_size);
+	/* Convert ranges to var ranges state: */
+	num_reg = x86_setup_var_mtrrs(range, nr_range, chunk_size, gran_size);
 
-	/* we got new setting in range_state, check it */
+	/* We got new setting in range_state, check it: */
 	memset(range_new, 0, sizeof(range_new));
 	nr_range_new = x86_get_mtrr_mem_range(range_new, 0,
-				extra_remove_base, extra_remove_size);
+				x_remove_base, x_remove_size);
 	range_sums_new = sum_ranges(range_new, nr_range_new);
 
 	result[i].chunk_sizek = chunk_size >> 10;
 	result[i].gran_sizek = gran_size >> 10;
 	result[i].num_reg = num_reg;
+
 	if (range_sums < range_sums_new) {
-		result[i].lose_cover_sizek =
-			(range_sums_new - range_sums) << PSHIFT;
+		result[i].lose_cover_sizek = (range_sums_new - range_sums) << PSHIFT;
 		result[i].bad = 1;
-	} else
-		result[i].lose_cover_sizek =
-			(range_sums - range_sums_new) << PSHIFT;
+	} else {
+		result[i].lose_cover_sizek = (range_sums - range_sums_new) << PSHIFT;
+	}
 
-	/* double check it */
+	/* Double check it: */
 	if (!result[i].bad && !result[i].lose_cover_sizek) {
-		if (nr_range_new != nr_range ||
-			memcmp(range, range_new, sizeof(range)))
-				result[i].bad = 1;
+		if (nr_range_new != nr_range || memcmp(range, range_new, sizeof(range)))
+			result[i].bad = 1;
 	}
 
-	if (!result[i].bad && (range_sums - range_sums_new <
-				min_loss_pfn[num_reg])) {
-		min_loss_pfn[num_reg] =
-			range_sums - range_sums_new;
-	}
+	if (!result[i].bad && (range_sums - range_sums_new < min_loss_pfn[num_reg]))
+		min_loss_pfn[num_reg] = range_sums - range_sums_new;
 }
 
 static void __init mtrr_print_out_one_result(int i)
 {
-	char gran_factor, chunk_factor, lose_factor;
 	unsigned long gran_base, chunk_base, lose_base;
+	char gran_factor, chunk_factor, lose_factor;
 
 	gran_base = to_size_factor(result[i].gran_sizek, &gran_factor),
 	chunk_base = to_size_factor(result[i].chunk_sizek, &chunk_factor),
 	lose_base = to_size_factor(result[i].lose_cover_sizek, &lose_factor),
-	printk(KERN_INFO "%sgran_size: %ld%c \tchunk_size: %ld%c \t",
-			result[i].bad ? "*BAD*" : " ",
-			gran_base, gran_factor, chunk_base, chunk_factor);
-	printk(KERN_CONT "num_reg: %d  \tlose cover RAM: %s%ld%c\n",
-			result[i].num_reg, result[i].bad ? "-" : "",
-			lose_base, lose_factor);
+
+	pr_info("%sgran_size: %ld%c \tchunk_size: %ld%c \t",
+		result[i].bad ? "*BAD*" : " ",
+		gran_base, gran_factor, chunk_base, chunk_factor);
+	pr_cont("num_reg: %d  \tlose cover RAM: %s%ld%c\n",
+		result[i].num_reg, result[i].bad ? "-" : "",
+		lose_base, lose_factor);
 }
 
 static int __init mtrr_search_optimal_index(void)
 {
-	int i;
 	int num_reg_good;
 	int index_good;
+	int i;
 
 	if (nr_mtrr_spare_reg >= num_var_ranges)
 		nr_mtrr_spare_reg = num_var_ranges - 1;
+
 	num_reg_good = -1;
 	for (i = num_var_ranges - nr_mtrr_spare_reg; i > 0; i--) {
 		if (!min_loss_pfn[i])
@@ -796,24 +795,24 @@ static int __init mtrr_search_optimal_index(void)
 	return index_good;
 }
 
-
 int __init mtrr_cleanup(unsigned address_bits)
 {
-	unsigned long extra_remove_base, extra_remove_size;
+	unsigned long x_remove_base, x_remove_size;
 	unsigned long base, size, def, dummy;
-	mtrr_type type;
 	u64 chunk_size, gran_size;
+	mtrr_type type;
 	int index_good;
 	int i;
 
 	if (!is_cpu(INTEL) || enable_mtrr_cleanup < 1)
 		return 0;
+
 	rdmsr(MSR_MTRRdefType, def, dummy);
 	def &= 0xff;
 	if (def != MTRR_TYPE_UNCACHABLE)
 		return 0;
 
-	/* get it and store it aside */
+	/* Get it and store it aside: */
 	memset(range_state, 0, sizeof(range_state));
 	for (i = 0; i < num_var_ranges; i++) {
 		mtrr_if->get(i, &base, &size, &type);
@@ -822,29 +821,28 @@ int __init mtrr_cleanup(unsigned address_bits)
 		range_state[i].type = type;
 	}
 
-	/* check if we need handle it and can handle it */
+	/* Check if we need handle it and can handle it: */
 	if (!mtrr_need_cleanup())
 		return 0;
 
-	/* print original var MTRRs at first, for debugging: */
+	/* Print original var MTRRs at first, for debugging: */
 	printk(KERN_DEBUG "original variable MTRRs\n");
 	print_out_mtrr_range_state();
 
 	memset(range, 0, sizeof(range));
-	extra_remove_size = 0;
-	extra_remove_base = 1 << (32 - PAGE_SHIFT);
+	x_remove_size = 0;
+	x_remove_base = 1 << (32 - PAGE_SHIFT);
 	if (mtrr_tom2)
-		extra_remove_size =
-			(mtrr_tom2 >> PAGE_SHIFT) - extra_remove_base;
-	nr_range = x86_get_mtrr_mem_range(range, 0, extra_remove_base,
-					  extra_remove_size);
+		x_remove_size = (mtrr_tom2 >> PAGE_SHIFT) - x_remove_base;
+
+	nr_range = x86_get_mtrr_mem_range(range, 0, x_remove_base, x_remove_size);
 	/*
-	 * [0, 1M) should always be coverred by var mtrr with WB
-	 * and fixed mtrrs should take effective before var mtrr for it
+	 * [0, 1M) should always be covered by var mtrr with WB
+	 * and fixed mtrrs should take effect before var mtrr for it:
 	 */
 	nr_range = add_range_with_merge(range, nr_range, 0,
 					(1ULL<<(20 - PAGE_SHIFT)) - 1);
-	/* sort the ranges */
+	/* Sort the ranges: */
 	sort(range, nr_range, sizeof(struct res_range), cmp_range, NULL);
 
 	range_sums = sum_ranges(range, nr_range);
@@ -854,7 +852,7 @@ int __init mtrr_cleanup(unsigned address_bits)
 	if (mtrr_chunk_size && mtrr_gran_size) {
 		i = 0;
 		mtrr_calc_range_state(mtrr_chunk_size, mtrr_gran_size,
-				      extra_remove_base, extra_remove_size, i);
+				      x_remove_base, x_remove_size, i);
 
 		mtrr_print_out_one_result(i);
 
@@ -880,7 +878,7 @@ int __init mtrr_cleanup(unsigned address_bits)
 				continue;
 
 			mtrr_calc_range_state(chunk_size, gran_size,
-				      extra_remove_base, extra_remove_size, i);
+				      x_remove_base, x_remove_size, i);
 			if (debug_print) {
 				mtrr_print_out_one_result(i);
 				printk(KERN_INFO "\n");
@@ -890,7 +888,7 @@ int __init mtrr_cleanup(unsigned address_bits)
 		}
 	}
 
-	/* try to find the optimal index */
+	/* Try to find the optimal index: */
 	index_good = mtrr_search_optimal_index();
 
 	if (index_good != -1) {
@@ -898,7 +896,7 @@ int __init mtrr_cleanup(unsigned address_bits)
 		i = index_good;
 		mtrr_print_out_one_result(i);
 
-		/* convert ranges to var ranges state */
+		/* Convert ranges to var ranges state: */
 		chunk_size = result[i].chunk_sizek;
 		chunk_size <<= 10;
 		gran_size = result[i].gran_sizek;
@@ -941,8 +939,8 @@ early_param("disable_mtrr_trim", disable_mtrr_trim_setup);
  * Note this won't check if the MTRRs < 4GB where the magic bit doesn't
  * apply to are wrong, but so far we don't know of any such case in the wild.
  */
-#define Tom2Enabled (1U << 21)
-#define Tom2ForceMemTypeWB (1U << 22)
+#define Tom2Enabled		(1U << 21)
+#define Tom2ForceMemTypeWB	(1U << 22)
 
 int __init amd_special_default_mtrr(void)
 {
@@ -952,7 +950,7 @@ int __init amd_special_default_mtrr(void)
 		return 0;
 	if (boot_cpu_data.x86 < 0xf || boot_cpu_data.x86 > 0x11)
 		return 0;
-	/* In case some hypervisor doesn't pass SYSCFG through */
+	/* In case some hypervisor doesn't pass SYSCFG through: */
 	if (rdmsr_safe(MSR_K8_SYSCFG, &l, &h) < 0)
 		return 0;
 	/*
@@ -965,19 +963,21 @@ int __init amd_special_default_mtrr(void)
 	return 0;
 }
 
-static u64 __init real_trim_memory(unsigned long start_pfn,
-				   unsigned long limit_pfn)
+static u64 __init
+real_trim_memory(unsigned long start_pfn, unsigned long limit_pfn)
 {
 	u64 trim_start, trim_size;
+
 	trim_start = start_pfn;
 	trim_start <<= PAGE_SHIFT;
+
 	trim_size = limit_pfn;
 	trim_size <<= PAGE_SHIFT;
 	trim_size -= trim_start;
 
-	return e820_update_range(trim_start, trim_size, E820_RAM,
-				E820_RESERVED);
+	return e820_update_range(trim_start, trim_size, E820_RAM, E820_RESERVED);
 }
+
 /**
  * mtrr_trim_uncached_memory - trim RAM not covered by MTRRs
  * @end_pfn: ending page frame number
@@ -985,7 +985,7 @@ static u64 __init real_trim_memory(unsigned long start_pfn,
  * Some buggy BIOSes don't setup the MTRRs properly for systems with certain
  * memory configurations.  This routine checks that the highest MTRR matches
  * the end of memory, to make sure the MTRRs having a write back type cover
- * all of the memory the kernel is intending to use. If not, it'll trim any
+ * all of the memory the kernel is intending to use.  If not, it'll trim any
  * memory off the end by adjusting end_pfn, removing it from the kernel's
  * allocation pools, warning the user with an obnoxious message.
  */
@@ -994,21 +994,22 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 	unsigned long i, base, size, highest_pfn = 0, def, dummy;
 	mtrr_type type;
 	u64 total_trim_size;
-
 	/* extra one for all 0 */
 	int num[MTRR_NUM_TYPES + 1];
+
 	/*
 	 * Make sure we only trim uncachable memory on machines that
 	 * support the Intel MTRR architecture:
 	 */
 	if (!is_cpu(INTEL) || disable_mtrr_trim)
 		return 0;
+
 	rdmsr(MSR_MTRRdefType, def, dummy);
 	def &= 0xff;
 	if (def != MTRR_TYPE_UNCACHABLE)
 		return 0;
 
-	/* get it and store it aside */
+	/* Get it and store it aside: */
 	memset(range_state, 0, sizeof(range_state));
 	for (i = 0; i < num_var_ranges; i++) {
 		mtrr_if->get(i, &base, &size, &type);
@@ -1017,7 +1018,7 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 		range_state[i].type = type;
 	}
 
-	/* Find highest cached pfn */
+	/* Find highest cached pfn: */
 	for (i = 0; i < num_var_ranges; i++) {
 		type = range_state[i].type;
 		if (type != MTRR_TYPE_WRBACK)
@@ -1028,13 +1029,13 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 			highest_pfn = base + size;
 	}
 
-	/* kvm/qemu doesn't have mtrr set right, don't trim them all */
+	/* kvm/qemu doesn't have mtrr set right, don't trim them all: */
 	if (!highest_pfn) {
 		printk(KERN_INFO "CPU MTRRs all blank - virtualized system.\n");
 		return 0;
 	}
 
-	/* check entries number */
+	/* Check entries number: */
 	memset(num, 0, sizeof(num));
 	for (i = 0; i < num_var_ranges; i++) {
 		type = range_state[i].type;
@@ -1046,11 +1047,11 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 		num[type]++;
 	}
 
-	/* no entry for WB? */
+	/* No entry for WB? */
 	if (!num[MTRR_TYPE_WRBACK])
 		return 0;
 
-	/* check if we only had WB and UC */
+	/* Check if we only had WB and UC: */
 	if (num[MTRR_TYPE_WRBACK] + num[MTRR_TYPE_UNCACHABLE] !=
 		num_var_ranges - num[MTRR_NUM_TYPES])
 		return 0;
@@ -1066,31 +1067,31 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 	}
 	nr_range = x86_get_mtrr_mem_range(range, nr_range, 0, 0);
 
+	/* Check the head: */
 	total_trim_size = 0;
-	/* check the head */
 	if (range[0].start)
 		total_trim_size += real_trim_memory(0, range[0].start);
-	/* check the holes */
+
+	/* Check the holes: */
 	for (i = 0; i < nr_range - 1; i++) {
 		if (range[i].end + 1 < range[i+1].start)
 			total_trim_size += real_trim_memory(range[i].end + 1,
 							    range[i+1].start);
 	}
-	/* check the top */
+
+	/* Check the top: */
 	i = nr_range - 1;
 	if (range[i].end + 1 < end_pfn)
 		total_trim_size += real_trim_memory(range[i].end + 1,
 							 end_pfn);
 
 	if (total_trim_size) {
-		printk(KERN_WARNING "WARNING: BIOS bug: CPU MTRRs don't cover"
-			" all of memory, losing %lluMB of RAM.\n",
-			total_trim_size >> 20);
+		pr_warning("WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing %lluMB of RAM.\n", total_trim_size >> 20);
 
 		if (!changed_by_mtrr_cleanup)
 			WARN_ON(1);
 
-		printk(KERN_INFO "update e820 for mtrr\n");
+		pr_info("update e820 for mtrr\n");
 		update_e820();
 
 		return 1;
@@ -1098,4 +1099,3 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 
 	return 0;
 }
-
diff --git a/arch/x86/kernel/cpu/mtrr/cyrix.c b/arch/x86/kernel/cpu/mtrr/cyrix.c
index ff14c32..228d982 100644
--- a/arch/x86/kernel/cpu/mtrr/cyrix.c
+++ b/arch/x86/kernel/cpu/mtrr/cyrix.c
@@ -1,38 +1,40 @@
 #include <linux/init.h>
+#include <linux/io.h>
 #include <linux/mm.h>
-#include <asm/mtrr.h>
-#include <asm/msr.h>
-#include <asm/io.h>
+
 #include <asm/processor-cyrix.h>
 #include <asm/processor-flags.h>
+#include <asm/mtrr.h>
+#include <asm/msr.h>
+
 #include "mtrr.h"
 
 static void
 cyrix_get_arr(unsigned int reg, unsigned long *base,
 	      unsigned long *size, mtrr_type * type)
 {
-	unsigned long flags;
 	unsigned char arr, ccr3, rcr, shift;
+	unsigned long flags;
 
 	arr = CX86_ARR_BASE + (reg << 1) + reg;	/* avoid multiplication by 3 */
 
-	/* Save flags and disable interrupts */
 	local_irq_save(flags);
 
 	ccr3 = getCx86(CX86_CCR3);
 	setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10);	/* enable MAPEN */
-	((unsigned char *) base)[3] = getCx86(arr);
-	((unsigned char *) base)[2] = getCx86(arr + 1);
-	((unsigned char *) base)[1] = getCx86(arr + 2);
+	((unsigned char *)base)[3] = getCx86(arr);
+	((unsigned char *)base)[2] = getCx86(arr + 1);
+	((unsigned char *)base)[1] = getCx86(arr + 2);
 	rcr = getCx86(CX86_RCR_BASE + reg);
-	setCx86(CX86_CCR3, ccr3);	/* disable MAPEN */
+	setCx86(CX86_CCR3, ccr3);			/* disable MAPEN */
 
-	/* Enable interrupts if it was enabled previously */
 	local_irq_restore(flags);
+
 	shift = ((unsigned char *) base)[1] & 0x0f;
 	*base >>= PAGE_SHIFT;
 
-	/* Power of two, at least 4K on ARR0-ARR6, 256K on ARR7
+	/*
+	 * Power of two, at least 4K on ARR0-ARR6, 256K on ARR7
 	 * Note: shift==0xf means 4G, this is unsupported.
 	 */
 	if (shift)
@@ -76,17 +78,20 @@ cyrix_get_arr(unsigned int reg, unsigned long *base,
 	}
 }
 
+/*
+ * cyrix_get_free_region - get a free ARR.
+ *
+ * @base: the starting (base) address of the region.
+ * @size: the size (in bytes) of the region.
+ *
+ * Returns: the index of the region on success, else -1 on error.
+*/
 static int
 cyrix_get_free_region(unsigned long base, unsigned long size, int replace_reg)
-/*  [SUMMARY] Get a free ARR.
-    <base> The starting (base) address of the region.
-    <size> The size (in bytes) of the region.
-    [RETURNS] The index of the region on success, else -1 on error.
-*/
 {
-	int i;
-	mtrr_type ltype;
 	unsigned long lbase, lsize;
+	mtrr_type ltype;
+	int i;
 
 	switch (replace_reg) {
 	case 7:
@@ -107,14 +112,17 @@ cyrix_get_free_region(unsigned long base, unsigned long size, int replace_reg)
 		cyrix_get_arr(7, &lbase, &lsize, &ltype);
 		if (lsize == 0)
 			return 7;
-		/*  Else try ARR0-ARR6 first  */
+		/* Else try ARR0-ARR6 first  */
 	} else {
 		for (i = 0; i < 7; i++) {
 			cyrix_get_arr(i, &lbase, &lsize, &ltype);
 			if (lsize == 0)
 				return i;
 		}
-		/* ARR0-ARR6 isn't free, try ARR7 but its size must be at least 256K */
+		/*
+		 * ARR0-ARR6 isn't free
+		 * try ARR7 but its size must be at least 256K
+		 */
 		cyrix_get_arr(i, &lbase, &lsize, &ltype);
 		if ((lsize == 0) && (size >= 0x40))
 			return i;
@@ -122,21 +130,22 @@ cyrix_get_free_region(unsigned long base, unsigned long size, int replace_reg)
 	return -ENOSPC;
 }
 
-static u32 cr4 = 0;
-static u32 ccr3;
+static u32 cr4, ccr3;
 
 static void prepare_set(void)
 {
 	u32 cr0;
 
 	/*  Save value of CR4 and clear Page Global Enable (bit 7)  */
-	if ( cpu_has_pge ) {
+	if (cpu_has_pge) {
 		cr4 = read_cr4();
 		write_cr4(cr4 & ~X86_CR4_PGE);
 	}
 
-	/*  Disable and flush caches. Note that wbinvd flushes the TLBs as
-	    a side-effect  */
+	/*
+	 * Disable and flush caches.
+	 * Note that wbinvd flushes the TLBs as a side-effect
+	 */
 	cr0 = read_cr0() | X86_CR0_CD;
 	wbinvd();
 	write_cr0(cr0);
@@ -147,22 +156,21 @@ static void prepare_set(void)
 
 	/* Cyrix ARRs - everything else was excluded at the top */
 	setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10);
-
 }
 
 static void post_set(void)
 {
-	/*  Flush caches and TLBs  */
+	/* Flush caches and TLBs */
 	wbinvd();
 
 	/* Cyrix ARRs - everything else was excluded at the top */
 	setCx86(CX86_CCR3, ccr3);
-		
-	/*  Enable caches  */
+
+	/* Enable caches */
 	write_cr0(read_cr0() & 0xbfffffff);
 
-	/*  Restore value of CR4  */
-	if ( cpu_has_pge )
+	/* Restore value of CR4 */
+	if (cpu_has_pge)
 		write_cr4(cr4);
 }
 
@@ -178,7 +186,8 @@ static void cyrix_set_arr(unsigned int reg, unsigned long base,
 		size >>= 6;
 
 	size &= 0x7fff;		/* make sure arr_size <= 14 */
-	for (arr_size = 0; size; arr_size++, size >>= 1) ;
+	for (arr_size = 0; size; arr_size++, size >>= 1)
+		;
 
 	if (reg < 7) {
 		switch (type) {
@@ -215,18 +224,18 @@ static void cyrix_set_arr(unsigned int reg, unsigned long base,
 	prepare_set();
 
 	base <<= PAGE_SHIFT;
-	setCx86(arr, ((unsigned char *) &base)[3]);
-	setCx86(arr + 1, ((unsigned char *) &base)[2]);
-	setCx86(arr + 2, (((unsigned char *) &base)[1]) | arr_size);
+	setCx86(arr + 0,  ((unsigned char *)&base)[3]);
+	setCx86(arr + 1,  ((unsigned char *)&base)[2]);
+	setCx86(arr + 2, (((unsigned char *)&base)[1]) | arr_size);
 	setCx86(CX86_RCR_BASE + reg, arr_type);
 
 	post_set();
 }
 
 typedef struct {
-	unsigned long base;
-	unsigned long size;
-	mtrr_type type;
+	unsigned long	base;
+	unsigned long	size;
+	mtrr_type	type;
 } arr_state_t;
 
 static arr_state_t arr_state[8] = {
@@ -247,16 +256,17 @@ static void cyrix_set_all(void)
 		setCx86(CX86_CCR0 + i, ccr_state[i]);
 	for (; i < 7; i++)
 		setCx86(CX86_CCR4 + i, ccr_state[i]);
-	for (i = 0; i < 8; i++)
-		cyrix_set_arr(i, arr_state[i].base, 
+
+	for (i = 0; i < 8; i++) {
+		cyrix_set_arr(i, arr_state[i].base,
 			      arr_state[i].size, arr_state[i].type);
+	}
 
 	post_set();
 }
 
 static struct mtrr_ops cyrix_mtrr_ops = {
 	.vendor            = X86_VENDOR_CYRIX,
-//	.init              = cyrix_arr_init,
 	.set_all	   = cyrix_set_all,
 	.set               = cyrix_set_arr,
 	.get               = cyrix_get_arr,
@@ -270,5 +280,3 @@ int __init cyrix_init_mtrr(void)
 	set_mtrr_ops(&cyrix_mtrr_ops);
 	return 0;
 }
-
-//arch_initcall(cyrix_init_mtrr);
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 0543f69..55da0c5 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -1,28 +1,34 @@
-/* This only handles 32bit MTRR on 32bit hosts. This is strictly wrong
-   because MTRRs can span upto 40 bits (36bits on most modern x86) */ 
+/*
+ * This only handles 32bit MTRR on 32bit hosts. This is strictly wrong
+ * because MTRRs can span upto 40 bits (36bits on most modern x86)
+ */
+#define DEBUG
+
+#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/io.h>
 #include <linux/mm.h>
-#include <linux/module.h>
-#include <asm/io.h>
-#include <asm/mtrr.h>
-#include <asm/msr.h>
-#include <asm/system.h>
-#include <asm/cpufeature.h>
+
 #include <asm/processor-flags.h>
+#include <asm/cpufeature.h>
 #include <asm/tlbflush.h>
+#include <asm/system.h>
+#include <asm/mtrr.h>
+#include <asm/msr.h>
 #include <asm/pat.h>
+
 #include "mtrr.h"
 
 struct fixed_range_block {
-	int base_msr; /* start address of an MTRR block */
-	int ranges;   /* number of MTRRs in this block  */
+	int base_msr;		/* start address of an MTRR block */
+	int ranges;		/* number of MTRRs in this block  */
 };
 
 static struct fixed_range_block fixed_range_blocks[] = {
-	{ MSR_MTRRfix64K_00000, 1 }, /* one  64k MTRR  */
-	{ MSR_MTRRfix16K_80000, 2 }, /* two  16k MTRRs */
-	{ MSR_MTRRfix4K_C0000,  8 }, /* eight 4k MTRRs */
+	{ MSR_MTRRfix64K_00000, 1 }, /* one   64k MTRR  */
+	{ MSR_MTRRfix16K_80000, 2 }, /* two   16k MTRRs */
+	{ MSR_MTRRfix4K_C0000,  8 }, /* eight  4k MTRRs */
 	{}
 };
 
@@ -30,10 +36,10 @@ static unsigned long smp_changes_mask;
 static int mtrr_state_set;
 u64 mtrr_tom2;
 
-struct mtrr_state_type mtrr_state = {};
+struct mtrr_state_type mtrr_state;
 EXPORT_SYMBOL_GPL(mtrr_state);
 
-/**
+/*
  * BIOS is expected to clear MtrrFixDramModEn bit, see for example
  * "BIOS and Kernel Developer's Guide for the AMD Athlon 64 and AMD
  * Opteron Processors" (26094 Rev. 3.30 February 2006), section
@@ -104,9 +110,8 @@ u8 mtrr_type_lookup(u64 start, u64 end)
 	 * Look of multiple ranges matching this address and pick type
 	 * as per MTRR precedence
 	 */
-	if (!(mtrr_state.enabled & 2)) {
+	if (!(mtrr_state.enabled & 2))
 		return mtrr_state.def_type;
-	}
 
 	prev_match = 0xFF;
 	for (i = 0; i < num_var_ranges; ++i) {
@@ -125,9 +130,8 @@ u8 mtrr_type_lookup(u64 start, u64 end)
 		if (start_state != end_state)
 			return 0xFE;
 
-		if ((start & mask) != (base & mask)) {
+		if ((start & mask) != (base & mask))
 			continue;
-		}
 
 		curr_match = mtrr_state.var_ranges[i].base_lo & 0xff;
 		if (prev_match == 0xFF) {
@@ -148,9 +152,8 @@ u8 mtrr_type_lookup(u64 start, u64 end)
 			curr_match = MTRR_TYPE_WRTHROUGH;
 		}
 
-		if (prev_match != curr_match) {
+		if (prev_match != curr_match)
 			return MTRR_TYPE_UNCACHABLE;
-		}
 	}
 
 	if (mtrr_tom2) {
@@ -164,7 +167,7 @@ u8 mtrr_type_lookup(u64 start, u64 end)
 	return mtrr_state.def_type;
 }
 
-/*  Get the MSR pair relating to a var range  */
+/* Get the MSR pair relating to a var range */
 static void
 get_mtrr_var_range(unsigned int index, struct mtrr_var_range *vr)
 {
@@ -172,7 +175,7 @@ get_mtrr_var_range(unsigned int index, struct mtrr_var_range *vr)
 	rdmsr(MTRRphysMask_MSR(index), vr->mask_lo, vr->mask_hi);
 }
 
-/*  fill the MSR pair relating to a var range  */
+/* Fill the MSR pair relating to a var range */
 void fill_mtrr_var_range(unsigned int index,
 		u32 base_lo, u32 base_hi, u32 mask_lo, u32 mask_hi)
 {
@@ -186,10 +189,9 @@ void fill_mtrr_var_range(unsigned int index,
 	vr[index].mask_hi = mask_hi;
 }
 
-static void
-get_fixed_ranges(mtrr_type * frs)
+static void get_fixed_ranges(mtrr_type *frs)
 {
-	unsigned int *p = (unsigned int *) frs;
+	unsigned int *p = (unsigned int *)frs;
 	int i;
 
 	k8_check_syscfg_dram_mod_en();
@@ -217,22 +219,22 @@ static void __init print_fixed_last(void)
 	if (!last_fixed_end)
 		return;
 
-	printk(KERN_DEBUG "  %05X-%05X %s\n", last_fixed_start,
-		last_fixed_end - 1, mtrr_attrib_to_str(last_fixed_type));
+	pr_debug("  %05X-%05X %s\n", last_fixed_start,
+		 last_fixed_end - 1, mtrr_attrib_to_str(last_fixed_type));
 
 	last_fixed_end = 0;
 }
 
 static void __init update_fixed_last(unsigned base, unsigned end,
-				       mtrr_type type)
+				     mtrr_type type)
 {
 	last_fixed_start = base;
 	last_fixed_end = end;
 	last_fixed_type = type;
 }
 
-static void __init print_fixed(unsigned base, unsigned step,
-			       const mtrr_type *types)
+static void __init
+print_fixed(unsigned base, unsigned step, const mtrr_type *types)
 {
 	unsigned i;
 
@@ -259,54 +261,55 @@ static void __init print_mtrr_state(void)
 	unsigned int i;
 	int high_width;
 
-	printk(KERN_DEBUG "MTRR default type: %s\n",
-			 mtrr_attrib_to_str(mtrr_state.def_type));
+	pr_debug("MTRR default type: %s\n",
+		 mtrr_attrib_to_str(mtrr_state.def_type));
 	if (mtrr_state.have_fixed) {
-		printk(KERN_DEBUG "MTRR fixed ranges %sabled:\n",
-		       mtrr_state.enabled & 1 ? "en" : "dis");
+		pr_debug("MTRR fixed ranges %sabled:\n",
+			 mtrr_state.enabled & 1 ? "en" : "dis");
 		print_fixed(0x00000, 0x10000, mtrr_state.fixed_ranges + 0);
 		for (i = 0; i < 2; ++i)
-			print_fixed(0x80000 + i * 0x20000, 0x04000, mtrr_state.fixed_ranges + (i + 1) * 8);
+			print_fixed(0x80000 + i * 0x20000, 0x04000,
+				    mtrr_state.fixed_ranges + (i + 1) * 8);
 		for (i = 0; i < 8; ++i)
-			print_fixed(0xC0000 + i * 0x08000, 0x01000, mtrr_state.fixed_ranges + (i + 3) * 8);
+			print_fixed(0xC0000 + i * 0x08000, 0x01000,
+				    mtrr_state.fixed_ranges + (i + 3) * 8);
 
 		/* tail */
 		print_fixed_last();
 	}
-	printk(KERN_DEBUG "MTRR variable ranges %sabled:\n",
-	       mtrr_state.enabled & 2 ? "en" : "dis");
+	pr_debug("MTRR variable ranges %sabled:\n",
+		 mtrr_state.enabled & 2 ? "en" : "dis");
 	if (size_or_mask & 0xffffffffUL)
 		high_width = ffs(size_or_mask & 0xffffffffUL) - 1;
 	else
 		high_width = ffs(size_or_mask>>32) + 32 - 1;
 	high_width = (high_width - (32 - PAGE_SHIFT) + 3) / 4;
+
 	for (i = 0; i < num_var_ranges; ++i) {
 		if (mtrr_state.var_ranges[i].mask_lo & (1 << 11))
-			printk(KERN_DEBUG "  %u base %0*X%05X000 mask %0*X%05X000 %s\n",
-			       i,
-			       high_width,
-			       mtrr_state.var_ranges[i].base_hi,
-			       mtrr_state.var_ranges[i].base_lo >> 12,
-			       high_width,
-			       mtrr_state.var_ranges[i].mask_hi,
-			       mtrr_state.var_ranges[i].mask_lo >> 12,
-			       mtrr_attrib_to_str(mtrr_state.var_ranges[i].base_lo & 0xff));
+			pr_debug("  %u base %0*X%05X000 mask %0*X%05X000 %s\n",
+				 i,
+				 high_width,
+				 mtrr_state.var_ranges[i].base_hi,
+				 mtrr_state.var_ranges[i].base_lo >> 12,
+				 high_width,
+				 mtrr_state.var_ranges[i].mask_hi,
+				 mtrr_state.var_ranges[i].mask_lo >> 12,
+				 mtrr_attrib_to_str(mtrr_state.var_ranges[i].base_lo & 0xff));
 		else
-			printk(KERN_DEBUG "  %u disabled\n", i);
-	}
-	if (mtrr_tom2) {
-		printk(KERN_DEBUG "TOM2: %016llx aka %lldM\n",
-				  mtrr_tom2, mtrr_tom2>>20);
+			pr_debug("  %u disabled\n", i);
 	}
+	if (mtrr_tom2)
+		pr_debug("TOM2: %016llx aka %lldM\n", mtrr_tom2, mtrr_tom2>>20);
 }
 
-/*  Grab all of the MTRR state for this CPU into *state  */
+/* Grab all of the MTRR state for this CPU into *state */
 void __init get_mtrr_state(void)
 {
-	unsigned int i;
 	struct mtrr_var_range *vrs;
-	unsigned lo, dummy;
 	unsigned long flags;
+	unsigned lo, dummy;
+	unsigned int i;
 
 	vrs = mtrr_state.var_ranges;
 
@@ -324,6 +327,7 @@ void __init get_mtrr_state(void)
 
 	if (amd_special_default_mtrr()) {
 		unsigned low, high;
+
 		/* TOP_MEM2 */
 		rdmsr(MSR_K8_TOP_MEM2, low, high);
 		mtrr_tom2 = high;
@@ -344,10 +348,9 @@ void __init get_mtrr_state(void)
 
 	post_set();
 	local_irq_restore(flags);
-
 }
 
-/*  Some BIOS's are fucked and don't set all MTRRs the same!  */
+/* Some BIOS's are messed up and don't set all MTRRs the same! */
 void __init mtrr_state_warn(void)
 {
 	unsigned long mask = smp_changes_mask;
@@ -355,28 +358,33 @@ void __init mtrr_state_warn(void)
 	if (!mask)
 		return;
 	if (mask & MTRR_CHANGE_MASK_FIXED)
-		printk(KERN_WARNING "mtrr: your CPUs had inconsistent fixed MTRR settings\n");
+		pr_warning("mtrr: your CPUs had inconsistent fixed MTRR settings\n");
 	if (mask & MTRR_CHANGE_MASK_VARIABLE)
-		printk(KERN_WARNING "mtrr: your CPUs had inconsistent variable MTRR settings\n");
+		pr_warning("mtrr: your CPUs had inconsistent variable MTRR settings\n");
 	if (mask & MTRR_CHANGE_MASK_DEFTYPE)
-		printk(KERN_WARNING "mtrr: your CPUs had inconsistent MTRRdefType settings\n");
+		pr_warning("mtrr: your CPUs had inconsistent MTRRdefType settings\n");
+
 	printk(KERN_INFO "mtrr: probably your BIOS does not setup all CPUs.\n");
 	printk(KERN_INFO "mtrr: corrected configuration.\n");
 }
 
-/* Doesn't attempt to pass an error out to MTRR users
-   because it's quite complicated in some cases and probably not
-   worth it because the best error handling is to ignore it. */
+/*
+ * Doesn't attempt to pass an error out to MTRR users
+ * because it's quite complicated in some cases and probably not
+ * worth it because the best error handling is to ignore it.
+ */
 void mtrr_wrmsr(unsigned msr, unsigned a, unsigned b)
 {
-	if (wrmsr_safe(msr, a, b) < 0)
+	if (wrmsr_safe(msr, a, b) < 0) {
 		printk(KERN_ERR
 			"MTRR: CPU %u: Writing MSR %x to %x:%x failed\n",
 			smp_processor_id(), msr, a, b);
+	}
 }
 
 /**
- * set_fixed_range - checks & updates a fixed-range MTRR if it differs from the value it should have
+ * set_fixed_range - checks & updates a fixed-range MTRR if it
+ *		     differs from the value it should have
  * @msr: MSR address of the MTTR which should be checked and updated
  * @changed: pointer which indicates whether the MTRR needed to be changed
  * @msrwords: pointer to the MSR values which the MSR should have
@@ -401,20 +409,23 @@ static void set_fixed_range(int msr, bool *changed, unsigned int *msrwords)
  *
  * Returns: The index of the region on success, else negative on error.
  */
-int generic_get_free_region(unsigned long base, unsigned long size, int replace_reg)
+int
+generic_get_free_region(unsigned long base, unsigned long size, int replace_reg)
 {
-	int i, max;
-	mtrr_type ltype;
 	unsigned long lbase, lsize;
+	mtrr_type ltype;
+	int i, max;
 
 	max = num_var_ranges;
 	if (replace_reg >= 0 && replace_reg < max)
 		return replace_reg;
+
 	for (i = 0; i < max; ++i) {
 		mtrr_if->get(i, &lbase, &lsize, &ltype);
 		if (lsize == 0)
 			return i;
 	}
+
 	return -ENOSPC;
 }
 
@@ -434,7 +445,7 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 	rdmsr(MTRRphysMask_MSR(reg), mask_lo, mask_hi);
 
 	if ((mask_lo & 0x800) == 0) {
-		/*  Invalid (i.e. free) range  */
+		/*  Invalid (i.e. free) range */
 		*base = 0;
 		*size = 0;
 		*type = 0;
@@ -471,27 +482,31 @@ out_put_cpu:
 }
 
 /**
- * set_fixed_ranges - checks & updates the fixed-range MTRRs if they differ from the saved set
+ * set_fixed_ranges - checks & updates the fixed-range MTRRs if they
+ *		      differ from the saved set
  * @frs: pointer to fixed-range MTRR values, saved by get_fixed_ranges()
  */
-static int set_fixed_ranges(mtrr_type * frs)
+static int set_fixed_ranges(mtrr_type *frs)
 {
-	unsigned long long *saved = (unsigned long long *) frs;
+	unsigned long long *saved = (unsigned long long *)frs;
 	bool changed = false;
-	int block=-1, range;
+	int block = -1, range;
 
 	k8_check_syscfg_dram_mod_en();
 
-	while (fixed_range_blocks[++block].ranges)
-	    for (range=0; range < fixed_range_blocks[block].ranges; range++)
-		set_fixed_range(fixed_range_blocks[block].base_msr + range,
-		    &changed, (unsigned int *) saved++);
+	while (fixed_range_blocks[++block].ranges) {
+		for (range = 0; range < fixed_range_blocks[block].ranges; range++)
+			set_fixed_range(fixed_range_blocks[block].base_msr + range,
+					&changed, (unsigned int *)saved++);
+	}
 
 	return changed;
 }
 
-/*  Set the MSR pair relating to a var range. Returns TRUE if
-    changes are made  */
+/*
+ * Set the MSR pair relating to a var range.
+ * Returns true if changes are made.
+ */
 static bool set_mtrr_var_ranges(unsigned int index, struct mtrr_var_range *vr)
 {
 	unsigned int lo, hi;
@@ -501,6 +516,7 @@ static bool set_mtrr_var_ranges(unsigned int index, struct mtrr_var_range *vr)
 	if ((vr->base_lo & 0xfffff0ffUL) != (lo & 0xfffff0ffUL)
 	    || (vr->base_hi & (size_and_mask >> (32 - PAGE_SHIFT))) !=
 		(hi & (size_and_mask >> (32 - PAGE_SHIFT)))) {
+
 		mtrr_wrmsr(MTRRphysBase_MSR(index), vr->base_lo, vr->base_hi);
 		changed = true;
 	}
@@ -526,21 +542,26 @@ static u32 deftype_lo, deftype_hi;
  */
 static unsigned long set_mtrr_state(void)
 {
-	unsigned int i;
 	unsigned long change_mask = 0;
+	unsigned int i;
 
-	for (i = 0; i < num_var_ranges; i++)
+	for (i = 0; i < num_var_ranges; i++) {
 		if (set_mtrr_var_ranges(i, &mtrr_state.var_ranges[i]))
 			change_mask |= MTRR_CHANGE_MASK_VARIABLE;
+	}
 
 	if (mtrr_state.have_fixed && set_fixed_ranges(mtrr_state.fixed_ranges))
 		change_mask |= MTRR_CHANGE_MASK_FIXED;
 
-	/*  Set_mtrr_restore restores the old value of MTRRdefType,
-	   so to set it we fiddle with the saved value  */
+	/*
+	 * Set_mtrr_restore restores the old value of MTRRdefType,
+	 * so to set it we fiddle with the saved value:
+	 */
 	if ((deftype_lo & 0xff) != mtrr_state.def_type
 	    || ((deftype_lo & 0xc00) >> 10) != mtrr_state.enabled) {
-		deftype_lo = (deftype_lo & ~0xcff) | mtrr_state.def_type | (mtrr_state.enabled << 10);
+
+		deftype_lo = (deftype_lo & ~0xcff) | mtrr_state.def_type |
+			     (mtrr_state.enabled << 10);
 		change_mask |= MTRR_CHANGE_MASK_DEFTYPE;
 	}
 
@@ -548,33 +569,36 @@ static unsigned long set_mtrr_state(void)
 }
 
 
-static unsigned long cr4 = 0;
+static unsigned long cr4;
 static DEFINE_SPINLOCK(set_atomicity_lock);
 
 /*
- * Since we are disabling the cache don't allow any interrupts - they
- * would run extremely slow and would only increase the pain.  The caller must
- * ensure that local interrupts are disabled and are reenabled after post_set()
- * has been called.
+ * Since we are disabling the cache don't allow any interrupts,
+ * they would run extremely slow and would only increase the pain.
+ *
+ * The caller must ensure that local interrupts are disabled and
+ * are reenabled after post_set() has been called.
  */
-
 static void prepare_set(void) __acquires(set_atomicity_lock)
 {
 	unsigned long cr0;
 
-	/*  Note that this is not ideal, since the cache is only flushed/disabled
-	   for this CPU while the MTRRs are changed, but changing this requires
-	   more invasive changes to the way the kernel boots  */
+	/*
+	 * Note that this is not ideal
+	 * since the cache is only flushed/disabled for this CPU while the
+	 * MTRRs are changed, but changing this requires more invasive
+	 * changes to the way the kernel boots
+	 */
 
 	spin_lock(&set_atomicity_lock);
 
-	/*  Enter the no-fill (CD=1, NW=0) cache mode and flush caches. */
+	/* Enter the no-fill (CD=1, NW=0) cache mode and flush caches. */
 	cr0 = read_cr0() | X86_CR0_CD;
 	write_cr0(cr0);
 	wbinvd();
 
-	/*  Save value of CR4 and clear Page Global Enable (bit 7)  */
-	if ( cpu_has_pge ) {
+	/* Save value of CR4 and clear Page Global Enable (bit 7) */
+	if (cpu_has_pge) {
 		cr4 = read_cr4();
 		write_cr4(cr4 & ~X86_CR4_PGE);
 	}
@@ -582,26 +606,26 @@ static void prepare_set(void) __acquires(set_atomicity_lock)
 	/* Flush all TLBs via a mov %cr3, %reg; mov %reg, %cr3 */
 	__flush_tlb();
 
-	/*  Save MTRR state */
+	/* Save MTRR state */
 	rdmsr(MSR_MTRRdefType, deftype_lo, deftype_hi);
 
-	/*  Disable MTRRs, and set the default type to uncached  */
+	/* Disable MTRRs, and set the default type to uncached */
 	mtrr_wrmsr(MSR_MTRRdefType, deftype_lo & ~0xcff, deftype_hi);
 }
 
 static void post_set(void) __releases(set_atomicity_lock)
 {
-	/*  Flush TLBs (no need to flush caches - they are disabled)  */
+	/* Flush TLBs (no need to flush caches - they are disabled) */
 	__flush_tlb();
 
 	/* Intel (P6) standard MTRRs */
 	mtrr_wrmsr(MSR_MTRRdefType, deftype_lo, deftype_hi);
-		
-	/*  Enable caches  */
+
+	/* Enable caches */
 	write_cr0(read_cr0() & 0xbfffffff);
 
-	/*  Restore value of CR4  */
-	if ( cpu_has_pge )
+	/* Restore value of CR4 */
+	if (cpu_has_pge)
 		write_cr4(cr4);
 	spin_unlock(&set_atomicity_lock);
 }
@@ -623,24 +647,27 @@ static void generic_set_all(void)
 	post_set();
 	local_irq_restore(flags);
 
-	/*  Use the atomic bitops to update the global mask  */
+	/* Use the atomic bitops to update the global mask */
 	for (count = 0; count < sizeof mask * 8; ++count) {
 		if (mask & 0x01)
 			set_bit(count, &smp_changes_mask);
 		mask >>= 1;
 	}
-	
+
 }
 
+/**
+ * generic_set_mtrr - set variable MTRR register on the local CPU.
+ *
+ * @reg: The register to set.
+ * @base: The base address of the region.
+ * @size: The size of the region. If this is 0 the region is disabled.
+ * @type: The type of the region.
+ *
+ * Returns nothing.
+ */
 static void generic_set_mtrr(unsigned int reg, unsigned long base,
 			     unsigned long size, mtrr_type type)
-/*  [SUMMARY] Set variable MTRR register on the local CPU.
-    <reg> The register to set.
-    <base> The base address of the region.
-    <size> The size of the region. If this is 0 the region is disabled.
-    <type> The type of the region.
-    [RETURNS] Nothing.
-*/
 {
 	unsigned long flags;
 	struct mtrr_var_range *vr;
@@ -651,8 +678,10 @@ static void generic_set_mtrr(unsigned int reg, unsigned long base,
 	prepare_set();
 
 	if (size == 0) {
-		/* The invalid bit is kept in the mask, so we simply clear the
-		   relevant mask register to disable a range. */
+		/*
+		 * The invalid bit is kept in the mask, so we simply
+		 * clear the relevant mask register to disable a range.
+		 */
 		mtrr_wrmsr(MTRRphysMask_MSR(reg), 0, 0);
 		memset(vr, 0, sizeof(struct mtrr_var_range));
 	} else {
@@ -669,46 +698,50 @@ static void generic_set_mtrr(unsigned int reg, unsigned long base,
 	local_irq_restore(flags);
 }
 
-int generic_validate_add_page(unsigned long base, unsigned long size, unsigned int type)
+int generic_validate_add_page(unsigned long base, unsigned long size,
+			      unsigned int type)
 {
 	unsigned long lbase, last;
 
-	/*  For Intel PPro stepping <= 7, must be 4 MiB aligned 
-	    and not touch 0x70000000->0x7003FFFF */
+	/*
+	 * For Intel PPro stepping <= 7
+	 * must be 4 MiB aligned and not touch 0x70000000 -> 0x7003FFFF
+	 */
 	if (is_cpu(INTEL) && boot_cpu_data.x86 == 6 &&
 	    boot_cpu_data.x86_model == 1 &&
 	    boot_cpu_data.x86_mask <= 7) {
 		if (base & ((1 << (22 - PAGE_SHIFT)) - 1)) {
-			printk(KERN_WARNING "mtrr: base(0x%lx000) is not 4 MiB aligned\n", base);
+			pr_warning("mtrr: base(0x%lx000) is not 4 MiB aligned\n", base);
 			return -EINVAL;
 		}
 		if (!(base + size < 0x70000 || base > 0x7003F) &&
 		    (type == MTRR_TYPE_WRCOMB
 		     || type == MTRR_TYPE_WRBACK)) {
-			printk(KERN_WARNING "mtrr: writable mtrr between 0x70000000 and 0x7003FFFF may hang the CPU.\n");
+			pr_warning("mtrr: writable mtrr between 0x70000000 and 0x7003FFFF may hang the CPU.\n");
 			return -EINVAL;
 		}
 	}
 
-	/*  Check upper bits of base and last are equal and lower bits are 0
-	    for base and 1 for last  */
+	/*
+	 * Check upper bits of base and last are equal and lower bits are 0
+	 * for base and 1 for last
+	 */
 	last = base + size - 1;
 	for (lbase = base; !(lbase & 1) && (last & 1);
-	     lbase = lbase >> 1, last = last >> 1) ;
+	     lbase = lbase >> 1, last = last >> 1)
+		;
 	if (lbase != last) {
-		printk(KERN_WARNING "mtrr: base(0x%lx000) is not aligned on a size(0x%lx000) boundary\n",
-		       base, size);
+		pr_warning("mtrr: base(0x%lx000) is not aligned on a size(0x%lx000) boundary\n", base, size);
 		return -EINVAL;
 	}
 	return 0;
 }
 
-
 static int generic_have_wrcomb(void)
 {
 	unsigned long config, dummy;
 	rdmsr(MSR_MTRRcap, config, dummy);
-	return (config & (1 << 10));
+	return config & (1 << 10);
 }
 
 int positive_have_wrcomb(void)
@@ -716,14 +749,15 @@ int positive_have_wrcomb(void)
 	return 1;
 }
 
-/* generic structure...
+/*
+ * Generic structure...
  */
 struct mtrr_ops generic_mtrr_ops = {
-	.use_intel_if      = 1,
-	.set_all	   = generic_set_all,
-	.get               = generic_get_mtrr,
-	.get_free_region   = generic_get_free_region,
-	.set               = generic_set_mtrr,
-	.validate_add_page = generic_validate_add_page,
-	.have_wrcomb       = generic_have_wrcomb,
+	.use_intel_if		= 1,
+	.set_all		= generic_set_all,
+	.get			= generic_get_mtrr,
+	.get_free_region	= generic_get_free_region,
+	.set			= generic_set_mtrr,
+	.validate_add_page	= generic_validate_add_page,
+	.have_wrcomb		= generic_have_wrcomb,
 };
diff --git a/arch/x86/kernel/cpu/mtrr/if.c b/arch/x86/kernel/cpu/mtrr/if.c
index fb73a52..08b6ea4 100644
--- a/arch/x86/kernel/cpu/mtrr/if.c
+++ b/arch/x86/kernel/cpu/mtrr/if.c
@@ -1,27 +1,28 @@
-#include <linux/init.h>
-#include <linux/proc_fs.h>
 #include <linux/capability.h>
-#include <linux/ctype.h>
-#include <linux/module.h>
 #include <linux/seq_file.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
+#include <linux/proc_fs.h>
+#include <linux/module.h>
+#include <linux/ctype.h>
+#include <linux/init.h>
 
 #define LINE_SIZE 80
 
 #include <asm/mtrr.h>
+
 #include "mtrr.h"
 
 #define FILE_FCOUNT(f) (((struct seq_file *)((f)->private_data))->private)
 
 static const char *const mtrr_strings[MTRR_NUM_TYPES] =
 {
-    "uncachable",               /* 0 */
-    "write-combining",          /* 1 */
-    "?",                        /* 2 */
-    "?",                        /* 3 */
-    "write-through",            /* 4 */
-    "write-protect",            /* 5 */
-    "write-back",               /* 6 */
+	"uncachable",		/* 0 */
+	"write-combining",	/* 1 */
+	"?",			/* 2 */
+	"?",			/* 3 */
+	"write-through",	/* 4 */
+	"write-protect",	/* 5 */
+	"write-back",		/* 6 */
 };
 
 const char *mtrr_attrib_to_str(int x)
@@ -35,8 +36,8 @@ static int
 mtrr_file_add(unsigned long base, unsigned long size,
 	      unsigned int type, bool increment, struct file *file, int page)
 {
+	unsigned int *fcount = FILE_FCOUNT(file);
 	int reg, max;
-	unsigned int *fcount = FILE_FCOUNT(file); 
 
 	max = num_var_ranges;
 	if (fcount == NULL) {
@@ -61,8 +62,8 @@ static int
 mtrr_file_del(unsigned long base, unsigned long size,
 	      struct file *file, int page)
 {
-	int reg;
 	unsigned int *fcount = FILE_FCOUNT(file);
+	int reg;
 
 	if (!page) {
 		if ((base & (PAGE_SIZE - 1)) || (size & (PAGE_SIZE - 1)))
@@ -81,13 +82,14 @@ mtrr_file_del(unsigned long base, unsigned long size,
 	return reg;
 }
 
-/* RED-PEN: seq_file can seek now. this is ignored. */
+/*
+ * seq_file can seek but we ignore it.
+ *
+ * Format of control line:
+ *    "base=%Lx size=%Lx type=%s" or "disable=%d"
+ */
 static ssize_t
 mtrr_write(struct file *file, const char __user *buf, size_t len, loff_t * ppos)
-/*  Format of control line:
-    "base=%Lx size=%Lx type=%s"     OR:
-    "disable=%d"
-*/
 {
 	int i, err;
 	unsigned long reg;
@@ -100,15 +102,18 @@ mtrr_write(struct file *file, const char __user *buf, size_t len, loff_t * ppos)
 		return -EPERM;
 	if (!len)
 		return -EINVAL;
+
 	memset(line, 0, LINE_SIZE);
 	if (len > LINE_SIZE)
 		len = LINE_SIZE;
 	if (copy_from_user(line, buf, len - 1))
 		return -EFAULT;
+
 	linelen = strlen(line);
 	ptr = line + linelen - 1;
 	if (linelen && *ptr == '\n')
 		*ptr = '\0';
+
 	if (!strncmp(line, "disable=", 8)) {
 		reg = simple_strtoul(line + 8, &ptr, 0);
 		err = mtrr_del_page(reg, 0, 0);
@@ -116,28 +121,35 @@ mtrr_write(struct file *file, const char __user *buf, size_t len, loff_t * ppos)
 			return err;
 		return len;
 	}
+
 	if (strncmp(line, "base=", 5))
 		return -EINVAL;
+
 	base = simple_strtoull(line + 5, &ptr, 0);
-	for (; isspace(*ptr); ++ptr) ;
+	for (; isspace(*ptr); ++ptr)
+		;
+
 	if (strncmp(ptr, "size=", 5))
 		return -EINVAL;
+
 	size = simple_strtoull(ptr + 5, &ptr, 0);
 	if ((base & 0xfff) || (size & 0xfff))
 		return -EINVAL;
-	for (; isspace(*ptr); ++ptr) ;
+	for (; isspace(*ptr); ++ptr)
+		;
+
 	if (strncmp(ptr, "type=", 5))
 		return -EINVAL;
 	ptr += 5;
-	for (; isspace(*ptr); ++ptr) ;
+	for (; isspace(*ptr); ++ptr)
+		;
+
 	for (i = 0; i < MTRR_NUM_TYPES; ++i) {
 		if (strcmp(ptr, mtrr_strings[i]))
 			continue;
 		base >>= PAGE_SHIFT;
 		size >>= PAGE_SHIFT;
-		err =
-		    mtrr_add_page((unsigned long) base, (unsigned long) size, i,
-				  true);
+		err = mtrr_add_page((unsigned long)base, (unsigned long)size, i, true);
 		if (err < 0)
 			return err;
 		return len;
@@ -181,7 +193,9 @@ mtrr_ioctl(struct file *file, unsigned int cmd, unsigned long __arg)
 	case MTRRIOC32_SET_PAGE_ENTRY:
 	case MTRRIOC32_DEL_PAGE_ENTRY:
 	case MTRRIOC32_KILL_PAGE_ENTRY: {
-		struct mtrr_sentry32 __user *s32 = (struct mtrr_sentry32 __user *)__arg;
+		struct mtrr_sentry32 __user *s32;
+
+		s32 = (struct mtrr_sentry32 __user *)__arg;
 		err = get_user(sentry.base, &s32->base);
 		err |= get_user(sentry.size, &s32->size);
 		err |= get_user(sentry.type, &s32->type);
@@ -191,7 +205,9 @@ mtrr_ioctl(struct file *file, unsigned int cmd, unsigned long __arg)
 	}
 	case MTRRIOC32_GET_ENTRY:
 	case MTRRIOC32_GET_PAGE_ENTRY: {
-		struct mtrr_gentry32 __user *g32 = (struct mtrr_gentry32 __user *)__arg;
+		struct mtrr_gentry32 __user *g32;
+
+		g32 = (struct mtrr_gentry32 __user *)__arg;
 		err = get_user(gentry.regnum, &g32->regnum);
 		err |= get_user(gentry.base, &g32->base);
 		err |= get_user(gentry.size, &g32->size);
@@ -314,7 +330,7 @@ mtrr_ioctl(struct file *file, unsigned int cmd, unsigned long __arg)
 	if (err)
 		return err;
 
-	switch(cmd) {
+	switch (cmd) {
 	case MTRRIOC_GET_ENTRY:
 	case MTRRIOC_GET_PAGE_ENTRY:
 		if (copy_to_user(arg, &gentry, sizeof gentry))
@@ -323,7 +339,9 @@ mtrr_ioctl(struct file *file, unsigned int cmd, unsigned long __arg)
 #ifdef CONFIG_COMPAT
 	case MTRRIOC32_GET_ENTRY:
 	case MTRRIOC32_GET_PAGE_ENTRY: {
-		struct mtrr_gentry32 __user *g32 = (struct mtrr_gentry32 __user *)__arg;
+		struct mtrr_gentry32 __user *g32;
+
+		g32 = (struct mtrr_gentry32 __user *)__arg;
 		err = put_user(gentry.base, &g32->base);
 		err |= put_user(gentry.size, &g32->size);
 		err |= put_user(gentry.regnum, &g32->regnum);
@@ -335,11 +353,10 @@ mtrr_ioctl(struct file *file, unsigned int cmd, unsigned long __arg)
 	return err;
 }
 
-static int
-mtrr_close(struct inode *ino, struct file *file)
+static int mtrr_close(struct inode *ino, struct file *file)
 {
-	int i, max;
 	unsigned int *fcount = FILE_FCOUNT(file);
+	int i, max;
 
 	if (fcount != NULL) {
 		max = num_var_ranges;
@@ -359,22 +376,22 @@ static int mtrr_seq_show(struct seq_file *seq, void *offset);
 
 static int mtrr_open(struct inode *inode, struct file *file)
 {
-	if (!mtrr_if) 
+	if (!mtrr_if)
 		return -EIO;
-	if (!mtrr_if->get) 
-		return -ENXIO; 
+	if (!mtrr_if->get)
+		return -ENXIO;
 	return single_open(file, mtrr_seq_show, NULL);
 }
 
 static const struct file_operations mtrr_fops = {
-	.owner   = THIS_MODULE,
-	.open	 = mtrr_open, 
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.write   = mtrr_write,
-	.unlocked_ioctl = mtrr_ioctl,
-	.compat_ioctl = mtrr_ioctl,
-	.release = mtrr_close,
+	.owner			= THIS_MODULE,
+	.open			= mtrr_open,
+	.read			= seq_read,
+	.llseek			= seq_lseek,
+	.write			= mtrr_write,
+	.unlocked_ioctl		= mtrr_ioctl,
+	.compat_ioctl		= mtrr_ioctl,
+	.release		= mtrr_close,
 };
 
 static int mtrr_seq_show(struct seq_file *seq, void *offset)
@@ -388,23 +405,24 @@ static int mtrr_seq_show(struct seq_file *seq, void *offset)
 	max = num_var_ranges;
 	for (i = 0; i < max; i++) {
 		mtrr_if->get(i, &base, &size, &type);
-		if (size == 0)
+		if (size == 0) {
 			mtrr_usage_table[i] = 0;
-		else {
-			if (size < (0x100000 >> PAGE_SHIFT)) {
-				/* less than 1MB */
-				factor = 'K';
-				size <<= PAGE_SHIFT - 10;
-			} else {
-				factor = 'M';
-				size >>= 20 - PAGE_SHIFT;
-			}
-			/* RED-PEN: base can be > 32bit */ 
-			len += seq_printf(seq, 
-				   "reg%02i: base=0x%06lx000 (%5luMB), size=%5lu%cB, count=%d: %s\n",
-			     i, base, base >> (20 - PAGE_SHIFT), size, factor,
-			     mtrr_usage_table[i], mtrr_attrib_to_str(type));
+			continue;
 		}
+		if (size < (0x100000 >> PAGE_SHIFT)) {
+			/* less than 1MB */
+			factor = 'K';
+			size <<= PAGE_SHIFT - 10;
+		} else {
+			factor = 'M';
+			size >>= 20 - PAGE_SHIFT;
+		}
+		/* Base can be > 32bit */
+		len += seq_printf(seq, "reg%02i: base=0x%06lx000 "
+			"(%5luMB), size=%5lu%cB, count=%d: %s\n",
+			i, base, base >> (20 - PAGE_SHIFT), size,
+			factor, mtrr_usage_table[i],
+			mtrr_attrib_to_str(type));
 	}
 	return 0;
 }
@@ -422,6 +440,5 @@ static int __init mtrr_if_init(void)
 	proc_create("mtrr", S_IWUSR | S_IRUGO, NULL, &mtrr_fops);
 	return 0;
 }
-
 arch_initcall(mtrr_if_init);
 #endif			/*  CONFIG_PROC_FS  */
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 8fc248b..7af0f88 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -25,43 +25,48 @@
     Operating System Writer's Guide" (Intel document number 242692),
     section 11.11.7
 
-    This was cleaned and made readable by Patrick Mochel <mochel@osdl.org> 
-    on 6-7 March 2002. 
-    Source: Intel Architecture Software Developers Manual, Volume 3: 
+    This was cleaned and made readable by Patrick Mochel <mochel@osdl.org>
+    on 6-7 March 2002.
+    Source: Intel Architecture Software Developers Manual, Volume 3:
     System Programming Guide; Section 9.11. (1997 edition - PPro).
 */
 
+#define DEBUG
+
+#include <linux/types.h> /* FIXME: kvm_para.h needs this */
+
+#include <linux/kvm_para.h>
+#include <linux/uaccess.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/init.h>
+#include <linux/sort.h>
+#include <linux/cpu.h>
 #include <linux/pci.h>
 #include <linux/smp.h>
-#include <linux/cpu.h>
-#include <linux/mutex.h>
-#include <linux/sort.h>
 
+#include <asm/processor.h>
 #include <asm/e820.h>
 #include <asm/mtrr.h>
-#include <asm/uaccess.h>
-#include <asm/processor.h>
 #include <asm/msr.h>
-#include <asm/kvm_para.h>
+
 #include "mtrr.h"
 
-u32 num_var_ranges = 0;
+u32 num_var_ranges;
 
 unsigned int mtrr_usage_table[MTRR_MAX_VAR_RANGES];
 static DEFINE_MUTEX(mtrr_mutex);
 
 u64 size_or_mask, size_and_mask;
 
-static struct mtrr_ops * mtrr_ops[X86_VENDOR_NUM] = {};
+static struct mtrr_ops *mtrr_ops[X86_VENDOR_NUM];
 
-struct mtrr_ops * mtrr_if = NULL;
+struct mtrr_ops *mtrr_if;
 
 static void set_mtrr(unsigned int reg, unsigned long base,
 		     unsigned long size, mtrr_type type);
 
-void set_mtrr_ops(struct mtrr_ops * ops)
+void set_mtrr_ops(struct mtrr_ops *ops)
 {
 	if (ops->vendor && ops->vendor < X86_VENDOR_NUM)
 		mtrr_ops[ops->vendor] = ops;
@@ -72,30 +77,36 @@ static int have_wrcomb(void)
 {
 	struct pci_dev *dev;
 	u8 rev;
-	
-	if ((dev = pci_get_class(PCI_CLASS_BRIDGE_HOST << 8, NULL)) != NULL) {
-		/* ServerWorks LE chipsets < rev 6 have problems with write-combining
-		   Don't allow it and leave room for other chipsets to be tagged */
+
+	dev = pci_get_class(PCI_CLASS_BRIDGE_HOST << 8, NULL);
+	if (dev != NULL) {
+		/*
+		 * ServerWorks LE chipsets < rev 6 have problems with
+		 * write-combining. Don't allow it and leave room for other
+		 * chipsets to be tagged
+		 */
 		if (dev->vendor == PCI_VENDOR_ID_SERVERWORKS &&
 		    dev->device == PCI_DEVICE_ID_SERVERWORKS_LE) {
 			pci_read_config_byte(dev, PCI_CLASS_REVISION, &rev);
 			if (rev <= 5) {
-				printk(KERN_INFO "mtrr: Serverworks LE rev < 6 detected. Write-combining disabled.\n");
+				pr_info("mtrr: Serverworks LE rev < 6 detected. Write-combining disabled.\n");
 				pci_dev_put(dev);
 				return 0;
 			}
 		}
-		/* Intel 450NX errata # 23. Non ascending cacheline evictions to
-		   write combining memory may resulting in data corruption */
+		/*
+		 * Intel 450NX errata # 23. Non ascending cacheline evictions to
+		 * write combining memory may resulting in data corruption
+		 */
 		if (dev->vendor == PCI_VENDOR_ID_INTEL &&
 		    dev->device == PCI_DEVICE_ID_INTEL_82451NX) {
-			printk(KERN_INFO "mtrr: Intel 450NX MMC detected. Write-combining disabled.\n");
+			pr_info("mtrr: Intel 450NX MMC detected. Write-combining disabled.\n");
 			pci_dev_put(dev);
 			return 0;
 		}
 		pci_dev_put(dev);
-	}		
-	return (mtrr_if->have_wrcomb ? mtrr_if->have_wrcomb() : 0);
+	}
+	return mtrr_if->have_wrcomb ? mtrr_if->have_wrcomb() : 0;
 }
 
 /*  This function returns the number of variable MTRRs  */
@@ -103,12 +114,13 @@ static void __init set_num_var_ranges(void)
 {
 	unsigned long config = 0, dummy;
 
-	if (use_intel()) {
+	if (use_intel())
 		rdmsr(MSR_MTRRcap, config, dummy);
-	} else if (is_cpu(AMD))
+	else if (is_cpu(AMD))
 		config = 2;
 	else if (is_cpu(CYRIX) || is_cpu(CENTAUR))
 		config = 8;
+
 	num_var_ranges = config & 0xff;
 }
 
@@ -130,10 +142,12 @@ struct set_mtrr_data {
 	mtrr_type	smp_type;
 };
 
+/**
+ * ipi_handler - Synchronisation handler. Executed by "other" CPUs.
+ *
+ * Returns nothing.
+ */
 static void ipi_handler(void *info)
-/*  [SUMMARY] Synchronisation handler. Executed by "other" CPUs.
-    [RETURNS] Nothing.
-*/
 {
 #ifdef CONFIG_SMP
 	struct set_mtrr_data *data = info;
@@ -142,18 +156,19 @@ static void ipi_handler(void *info)
 	local_irq_save(flags);
 
 	atomic_dec(&data->count);
-	while(!atomic_read(&data->gate))
+	while (!atomic_read(&data->gate))
 		cpu_relax();
 
 	/*  The master has cleared me to execute  */
-	if (data->smp_reg != ~0U) 
-		mtrr_if->set(data->smp_reg, data->smp_base, 
+	if (data->smp_reg != ~0U) {
+		mtrr_if->set(data->smp_reg, data->smp_base,
 			     data->smp_size, data->smp_type);
-	else
+	} else {
 		mtrr_if->set_all();
+	}
 
 	atomic_dec(&data->count);
-	while(atomic_read(&data->gate))
+	while (atomic_read(&data->gate))
 		cpu_relax();
 
 	atomic_dec(&data->count);
@@ -161,7 +176,8 @@ static void ipi_handler(void *info)
 #endif
 }
 
-static inline int types_compatible(mtrr_type type1, mtrr_type type2) {
+static inline int types_compatible(mtrr_type type1, mtrr_type type2)
+{
 	return type1 == MTRR_TYPE_UNCACHABLE ||
 	       type2 == MTRR_TYPE_UNCACHABLE ||
 	       (type1 == MTRR_TYPE_WRTHROUGH && type2 == MTRR_TYPE_WRBACK) ||
@@ -176,10 +192,10 @@ static inline int types_compatible(mtrr_type type1, mtrr_type type2) {
  * @type:	mtrr type
  *
  * This is kinda tricky, but fortunately, Intel spelled it out for us cleanly:
- * 
+ *
  * 1. Send IPI to do the following:
  * 2. Disable Interrupts
- * 3. Wait for all procs to do so 
+ * 3. Wait for all procs to do so
  * 4. Enter no-fill cache mode
  * 5. Flush caches
  * 6. Clear PGE bit
@@ -189,26 +205,27 @@ static inline int types_compatible(mtrr_type type1, mtrr_type type2) {
  * 10. Enable all range registers
  * 11. Flush all TLBs and caches again
  * 12. Enter normal cache mode and reenable caching
- * 13. Set PGE 
+ * 13. Set PGE
  * 14. Wait for buddies to catch up
  * 15. Enable interrupts.
- * 
+ *
  * What does that mean for us? Well, first we set data.count to the number
  * of CPUs. As each CPU disables interrupts, it'll decrement it once. We wait
  * until it hits 0 and proceed. We set the data.gate flag and reset data.count.
- * Meanwhile, they are waiting for that flag to be set. Once it's set, each 
- * CPU goes through the transition of updating MTRRs. The CPU vendors may each do it 
- * differently, so we call mtrr_if->set() callback and let them take care of it.
- * When they're done, they again decrement data->count and wait for data.gate to 
- * be reset. 
- * When we finish, we wait for data.count to hit 0 and toggle the data.gate flag.
+ * Meanwhile, they are waiting for that flag to be set. Once it's set, each
+ * CPU goes through the transition of updating MTRRs.
+ * The CPU vendors may each do it differently,
+ * so we call mtrr_if->set() callback and let them take care of it.
+ * When they're done, they again decrement data->count and wait for data.gate
+ * to be reset.
+ * When we finish, we wait for data.count to hit 0 and toggle the data.gate flag
  * Everyone then enables interrupts and we all continue on.
  *
  * Note that the mechanism is the same for UP systems, too; all the SMP stuff
  * becomes nops.
  */
-static void set_mtrr(unsigned int reg, unsigned long base,
-		     unsigned long size, mtrr_type type)
+static void
+set_mtrr(unsigned int reg, unsigned long base, unsigned long size, mtrr_type type)
 {
 	struct set_mtrr_data data;
 	unsigned long flags;
@@ -218,121 +235,122 @@ static void set_mtrr(unsigned int reg, unsigned long base,
 	data.smp_size = size;
 	data.smp_type = type;
 	atomic_set(&data.count, num_booting_cpus() - 1);
-	/* make sure data.count is visible before unleashing other CPUs */
+
+	/* Make sure data.count is visible before unleashing other CPUs */
 	smp_wmb();
-	atomic_set(&data.gate,0);
+	atomic_set(&data.gate, 0);
 
-	/*  Start the ball rolling on other CPUs  */
+	/* Start the ball rolling on other CPUs */
 	if (smp_call_function(ipi_handler, &data, 0) != 0)
 		panic("mtrr: timed out waiting for other CPUs\n");
 
 	local_irq_save(flags);
 
-	while(atomic_read(&data.count))
+	while (atomic_read(&data.count))
 		cpu_relax();
 
-	/* ok, reset count and toggle gate */
+	/* Ok, reset count and toggle gate */
 	atomic_set(&data.count, num_booting_cpus() - 1);
 	smp_wmb();
-	atomic_set(&data.gate,1);
+	atomic_set(&data.gate, 1);
 
-	/* do our MTRR business */
+	/* Do our MTRR business */
 
-	/* HACK!
+	/*
+	 * HACK!
 	 * We use this same function to initialize the mtrrs on boot.
 	 * The state of the boot cpu's mtrrs has been saved, and we want
-	 * to replicate across all the APs. 
+	 * to replicate across all the APs.
 	 * If we're doing that @reg is set to something special...
 	 */
-	if (reg != ~0U) 
-		mtrr_if->set(reg,base,size,type);
+	if (reg != ~0U)
+		mtrr_if->set(reg, base, size, type);
 
-	/* wait for the others */
-	while(atomic_read(&data.count))
+	/* Wait for the others */
+	while (atomic_read(&data.count))
 		cpu_relax();
 
 	atomic_set(&data.count, num_booting_cpus() - 1);
 	smp_wmb();
-	atomic_set(&data.gate,0);
+	atomic_set(&data.gate, 0);
 
 	/*
 	 * Wait here for everyone to have seen the gate change
 	 * So we're the last ones to touch 'data'
 	 */
-	while(atomic_read(&data.count))
+	while (atomic_read(&data.count))
 		cpu_relax();
 
 	local_irq_restore(flags);
 }
 
 /**
- *	mtrr_add_page - Add a memory type region
- *	@base: Physical base address of region in pages (in units of 4 kB!)
- *	@size: Physical size of region in pages (4 kB)
- *	@type: Type of MTRR desired
- *	@increment: If this is true do usage counting on the region
+ * mtrr_add_page - Add a memory type region
+ * @base: Physical base address of region in pages (in units of 4 kB!)
+ * @size: Physical size of region in pages (4 kB)
+ * @type: Type of MTRR desired
+ * @increment: If this is true do usage counting on the region
  *
- *	Memory type region registers control the caching on newer Intel and
- *	non Intel processors. This function allows drivers to request an
- *	MTRR is added. The details and hardware specifics of each processor's
- *	implementation are hidden from the caller, but nevertheless the 
- *	caller should expect to need to provide a power of two size on an
- *	equivalent power of two boundary.
+ * Memory type region registers control the caching on newer Intel and
+ * non Intel processors. This function allows drivers to request an
+ * MTRR is added. The details and hardware specifics of each processor's
+ * implementation are hidden from the caller, but nevertheless the
+ * caller should expect to need to provide a power of two size on an
+ * equivalent power of two boundary.
  *
- *	If the region cannot be added either because all regions are in use
- *	or the CPU cannot support it a negative value is returned. On success
- *	the register number for this entry is returned, but should be treated
- *	as a cookie only.
+ * If the region cannot be added either because all regions are in use
+ * or the CPU cannot support it a negative value is returned. On success
+ * the register number for this entry is returned, but should be treated
+ * as a cookie only.
  *
- *	On a multiprocessor machine the changes are made to all processors.
- *	This is required on x86 by the Intel processors.
+ * On a multiprocessor machine the changes are made to all processors.
+ * This is required on x86 by the Intel processors.
  *
- *	The available types are
+ * The available types are
  *
- *	%MTRR_TYPE_UNCACHABLE	-	No caching
+ * %MTRR_TYPE_UNCACHABLE - No caching
  *
- *	%MTRR_TYPE_WRBACK	-	Write data back in bursts whenever
+ * %MTRR_TYPE_WRBACK - Write data back in bursts whenever
  *
- *	%MTRR_TYPE_WRCOMB	-	Write data back soon but allow bursts
+ * %MTRR_TYPE_WRCOMB - Write data back soon but allow bursts
  *
- *	%MTRR_TYPE_WRTHROUGH	-	Cache reads but not writes
+ * %MTRR_TYPE_WRTHROUGH - Cache reads but not writes
  *
- *	BUGS: Needs a quiet flag for the cases where drivers do not mind
- *	failures and do not wish system log messages to be sent.
+ * BUGS: Needs a quiet flag for the cases where drivers do not mind
+ * failures and do not wish system log messages to be sent.
  */
-
-int mtrr_add_page(unsigned long base, unsigned long size, 
+int mtrr_add_page(unsigned long base, unsigned long size,
 		  unsigned int type, bool increment)
 {
+	unsigned long lbase, lsize;
 	int i, replace, error;
 	mtrr_type ltype;
-	unsigned long lbase, lsize;
 
 	if (!mtrr_if)
 		return -ENXIO;
-		
-	if ((error = mtrr_if->validate_add_page(base,size,type)))
+
+	error = mtrr_if->validate_add_page(base, size, type);
+	if (error)
 		return error;
 
 	if (type >= MTRR_NUM_TYPES) {
-		printk(KERN_WARNING "mtrr: type: %u invalid\n", type);
+		pr_warning("mtrr: type: %u invalid\n", type);
 		return -EINVAL;
 	}
 
-	/*  If the type is WC, check that this processor supports it  */
+	/* If the type is WC, check that this processor supports it */
 	if ((type == MTRR_TYPE_WRCOMB) && !have_wrcomb()) {
-		printk(KERN_WARNING
-		       "mtrr: your processor doesn't support write-combining\n");
+		pr_warning("mtrr: your processor doesn't support write-combining\n");
 		return -ENOSYS;
 	}
 
 	if (!size) {
-		printk(KERN_WARNING "mtrr: zero sized request\n");
+		pr_warning("mtrr: zero sized request\n");
 		return -EINVAL;
 	}
 
 	if (base & size_or_mask || size & size_or_mask) {
-		printk(KERN_WARNING "mtrr: base or size exceeds the MTRR width\n");
+		pr_warning("mtrr: base or size exceeds the MTRR width\n");
 		return -EINVAL;
 	}
 
@@ -341,36 +359,40 @@ int mtrr_add_page(unsigned long base, unsigned long size,
 
 	/* No CPU hotplug when we change MTRR entries */
 	get_online_cpus();
-	/*  Search for existing MTRR  */
+
+	/* Search for existing MTRR  */
 	mutex_lock(&mtrr_mutex);
 	for (i = 0; i < num_var_ranges; ++i) {
 		mtrr_if->get(i, &lbase, &lsize, &ltype);
-		if (!lsize || base > lbase + lsize - 1 || base + size - 1 < lbase)
+		if (!lsize || base > lbase + lsize - 1 ||
+		    base + size - 1 < lbase)
 			continue;
-		/*  At this point we know there is some kind of overlap/enclosure  */
+		/*
+		 * At this point we know there is some kind of
+		 * overlap/enclosure
+		 */
 		if (base < lbase || base + size - 1 > lbase + lsize - 1) {
-			if (base <= lbase && base + size - 1 >= lbase + lsize - 1) {
+			if (base <= lbase &&
+			    base + size - 1 >= lbase + lsize - 1) {
 				/*  New region encloses an existing region  */
 				if (type == ltype) {
 					replace = replace == -1 ? i : -2;
 					continue;
-				}
-				else if (types_compatible(type, ltype))
+				} else if (types_compatible(type, ltype))
 					continue;
 			}
-			printk(KERN_WARNING
-			       "mtrr: 0x%lx000,0x%lx000 overlaps existing"
-			       " 0x%lx000,0x%lx000\n", base, size, lbase,
-			       lsize);
+			pr_warning("mtrr: 0x%lx000,0x%lx000 overlaps existing"
+				" 0x%lx000,0x%lx000\n", base, size, lbase,
+				lsize);
 			goto out;
 		}
-		/*  New region is enclosed by an existing region  */
+		/* New region is enclosed by an existing region */
 		if (ltype != type) {
 			if (types_compatible(type, ltype))
 				continue;
-			printk (KERN_WARNING "mtrr: type mismatch for %lx000,%lx000 old: %s new: %s\n",
-			     base, size, mtrr_attrib_to_str(ltype),
-			     mtrr_attrib_to_str(type));
+			pr_warning("mtrr: type mismatch for %lx000,%lx000 old: %s new: %s\n",
+				base, size, mtrr_attrib_to_str(ltype),
+				mtrr_attrib_to_str(type));
 			goto out;
 		}
 		if (increment)
@@ -378,7 +400,7 @@ int mtrr_add_page(unsigned long base, unsigned long size,
 		error = i;
 		goto out;
 	}
-	/*  Search for an empty MTRR  */
+	/* Search for an empty MTRR */
 	i = mtrr_if->get_free_region(base, size, replace);
 	if (i >= 0) {
 		set_mtrr(i, base, size, type);
@@ -393,8 +415,9 @@ int mtrr_add_page(unsigned long base, unsigned long size,
 				mtrr_usage_table[replace] = 0;
 			}
 		}
-	} else
-		printk(KERN_INFO "mtrr: no more MTRRs available\n");
+	} else {
+		pr_info("mtrr: no more MTRRs available\n");
+	}
 	error = i;
  out:
 	mutex_unlock(&mtrr_mutex);
@@ -405,10 +428,8 @@ int mtrr_add_page(unsigned long base, unsigned long size,
 static int mtrr_check(unsigned long base, unsigned long size)
 {
 	if ((base & (PAGE_SIZE - 1)) || (size & (PAGE_SIZE - 1))) {
-		printk(KERN_WARNING
-			"mtrr: size and base must be multiples of 4 kiB\n");
-		printk(KERN_DEBUG
-			"mtrr: size: 0x%lx  base: 0x%lx\n", size, base);
+		pr_warning("mtrr: size and base must be multiples of 4 kiB\n");
+		pr_debug("mtrr: size: 0x%lx  base: 0x%lx\n", size, base);
 		dump_stack();
 		return -1;
 	}
@@ -416,66 +437,64 @@ static int mtrr_check(unsigned long base, unsigned long size)
 }
 
 /**
- *	mtrr_add - Add a memory type region
- *	@base: Physical base address of region
- *	@size: Physical size of region
- *	@type: Type of MTRR desired
- *	@increment: If this is true do usage counting on the region
+ * mtrr_add - Add a memory type region
+ * @base: Physical base address of region
+ * @size: Physical size of region
+ * @type: Type of MTRR desired
+ * @increment: If this is true do usage counting on the region
  *
- *	Memory type region registers control the caching on newer Intel and
- *	non Intel processors. This function allows drivers to request an
- *	MTRR is added. The details and hardware specifics of each processor's
- *	implementation are hidden from the caller, but nevertheless the 
- *	caller should expect to need to provide a power of two size on an
- *	equivalent power of two boundary.
+ * Memory type region registers control the caching on newer Intel and
+ * non Intel processors. This function allows drivers to request an
+ * MTRR is added. The details and hardware specifics of each processor's
+ * implementation are hidden from the caller, but nevertheless the
+ * caller should expect to need to provide a power of two size on an
+ * equivalent power of two boundary.
  *
- *	If the region cannot be added either because all regions are in use
- *	or the CPU cannot support it a negative value is returned. On success
- *	the register number for this entry is returned, but should be treated
- *	as a cookie only.
+ * If the region cannot be added either because all regions are in use
+ * or the CPU cannot support it a negative value is returned. On success
+ * the register number for this entry is returned, but should be treated
+ * as a cookie only.
  *
- *	On a multiprocessor machine the changes are made to all processors.
- *	This is required on x86 by the Intel processors.
+ * On a multiprocessor machine the changes are made to all processors.
+ * This is required on x86 by the Intel processors.
  *
- *	The available types are
+ * The available types are
  *
- *	%MTRR_TYPE_UNCACHABLE	-	No caching
+ * %MTRR_TYPE_UNCACHABLE - No caching
  *
- *	%MTRR_TYPE_WRBACK	-	Write data back in bursts whenever
+ * %MTRR_TYPE_WRBACK - Write data back in bursts whenever
  *
- *	%MTRR_TYPE_WRCOMB	-	Write data back soon but allow bursts
+ * %MTRR_TYPE_WRCOMB - Write data back soon but allow bursts
  *
- *	%MTRR_TYPE_WRTHROUGH	-	Cache reads but not writes
+ * %MTRR_TYPE_WRTHROUGH - Cache reads but not writes
  *
- *	BUGS: Needs a quiet flag for the cases where drivers do not mind
- *	failures and do not wish system log messages to be sent.
+ * BUGS: Needs a quiet flag for the cases where drivers do not mind
+ * failures and do not wish system log messages to be sent.
  */
-
-int
-mtrr_add(unsigned long base, unsigned long size, unsigned int type,
-	 bool increment)
+int mtrr_add(unsigned long base, unsigned long size, unsigned int type,
+	     bool increment)
 {
 	if (mtrr_check(base, size))
 		return -EINVAL;
 	return mtrr_add_page(base >> PAGE_SHIFT, size >> PAGE_SHIFT, type,
 			     increment);
 }
+EXPORT_SYMBOL(mtrr_add);
 
 /**
- *	mtrr_del_page - delete a memory type region
- *	@reg: Register returned by mtrr_add
- *	@base: Physical base address
- *	@size: Size of region
+ * mtrr_del_page - delete a memory type region
+ * @reg: Register returned by mtrr_add
+ * @base: Physical base address
+ * @size: Size of region
  *
- *	If register is supplied then base and size are ignored. This is
- *	how drivers should call it.
+ * If register is supplied then base and size are ignored. This is
+ * how drivers should call it.
  *
- *	Releases an MTRR region. If the usage count drops to zero the 
- *	register is freed and the region returns to default state.
- *	On success the register is returned, on failure a negative error
- *	code.
+ * Releases an MTRR region. If the usage count drops to zero the
+ * register is freed and the region returns to default state.
+ * On success the register is returned, on failure a negative error
+ * code.
  */
-
 int mtrr_del_page(int reg, unsigned long base, unsigned long size)
 {
 	int i, max;
@@ -500,22 +519,22 @@ int mtrr_del_page(int reg, unsigned long base, unsigned long size)
 			}
 		}
 		if (reg < 0) {
-			printk(KERN_DEBUG "mtrr: no MTRR for %lx000,%lx000 found\n", base,
-			       size);
+			pr_debug("mtrr: no MTRR for %lx000,%lx000 found\n",
+				 base, size);
 			goto out;
 		}
 	}
 	if (reg >= max) {
-		printk(KERN_WARNING "mtrr: register: %d too big\n", reg);
+		pr_warning("mtrr: register: %d too big\n", reg);
 		goto out;
 	}
 	mtrr_if->get(reg, &lbase, &lsize, &ltype);
 	if (lsize < 1) {
-		printk(KERN_WARNING "mtrr: MTRR %d not used\n", reg);
+		pr_warning("mtrr: MTRR %d not used\n", reg);
 		goto out;
 	}
 	if (mtrr_usage_table[reg] < 1) {
-		printk(KERN_WARNING "mtrr: reg: %d has count=0\n", reg);
+		pr_warning("mtrr: reg: %d has count=0\n", reg);
 		goto out;
 	}
 	if (--mtrr_usage_table[reg] < 1)
@@ -526,33 +545,31 @@ int mtrr_del_page(int reg, unsigned long base, unsigned long size)
 	put_online_cpus();
 	return error;
 }
+
 /**
- *	mtrr_del - delete a memory type region
- *	@reg: Register returned by mtrr_add
- *	@base: Physical base address
- *	@size: Size of region
+ * mtrr_del - delete a memory type region
+ * @reg: Register returned by mtrr_add
+ * @base: Physical base address
+ * @size: Size of region
  *
- *	If register is supplied then base and size are ignored. This is
- *	how drivers should call it.
+ * If register is supplied then base and size are ignored. This is
+ * how drivers should call it.
  *
- *	Releases an MTRR region. If the usage count drops to zero the 
- *	register is freed and the region returns to default state.
- *	On success the register is returned, on failure a negative error
- *	code.
+ * Releases an MTRR region. If the usage count drops to zero the
+ * register is freed and the region returns to default state.
+ * On success the register is returned, on failure a negative error
+ * code.
  */
-
-int
-mtrr_del(int reg, unsigned long base, unsigned long size)
+int mtrr_del(int reg, unsigned long base, unsigned long size)
 {
 	if (mtrr_check(base, size))
 		return -EINVAL;
 	return mtrr_del_page(reg, base >> PAGE_SHIFT, size >> PAGE_SHIFT);
 }
-
-EXPORT_SYMBOL(mtrr_add);
 EXPORT_SYMBOL(mtrr_del);
 
-/* HACK ALERT!
+/*
+ * HACK ALERT!
  * These should be called implicitly, but we can't yet until all the initcall
  * stuff is done...
  */
@@ -576,29 +593,28 @@ struct mtrr_value {
 
 static struct mtrr_value mtrr_value[MTRR_MAX_VAR_RANGES];
 
-static int mtrr_save(struct sys_device * sysdev, pm_message_t state)
+static int mtrr_save(struct sys_device *sysdev, pm_message_t state)
 {
 	int i;
 
 	for (i = 0; i < num_var_ranges; i++) {
-		mtrr_if->get(i,
-			     &mtrr_value[i].lbase,
-			     &mtrr_value[i].lsize,
-			     &mtrr_value[i].ltype);
+		mtrr_if->get(i, &mtrr_value[i].lbase,
+				&mtrr_value[i].lsize,
+				&mtrr_value[i].ltype);
 	}
 	return 0;
 }
 
-static int mtrr_restore(struct sys_device * sysdev)
+static int mtrr_restore(struct sys_device *sysdev)
 {
 	int i;
 
 	for (i = 0; i < num_var_ranges; i++) {
-		if (mtrr_value[i].lsize)
-			set_mtrr(i,
-				 mtrr_value[i].lbase,
-				 mtrr_value[i].lsize,
-				 mtrr_value[i].ltype);
+		if (mtrr_value[i].lsize) {
+			set_mtrr(i, mtrr_value[i].lbase,
+				    mtrr_value[i].lsize,
+				    mtrr_value[i].ltype);
+		}
 	}
 	return 0;
 }
@@ -615,26 +631,29 @@ int __initdata changed_by_mtrr_cleanup;
 /**
  * mtrr_bp_init - initialize mtrrs on the boot CPU
  *
- * This needs to be called early; before any of the other CPUs are 
+ * This needs to be called early; before any of the other CPUs are
  * initialized (i.e. before smp_init()).
- * 
+ *
  */
 void __init mtrr_bp_init(void)
 {
 	u32 phys_addr;
+
 	init_ifs();
 
 	phys_addr = 32;
 
 	if (cpu_has_mtrr) {
 		mtrr_if = &generic_mtrr_ops;
-		size_or_mask = 0xff000000;	/* 36 bits */
+		size_or_mask = 0xff000000;			/* 36 bits */
 		size_and_mask = 0x00f00000;
 		phys_addr = 36;
 
-		/* This is an AMD specific MSR, but we assume(hope?) that
-		   Intel will implement it to when they extend the address
-		   bus of the Xeon. */
+		/*
+		 * This is an AMD specific MSR, but we assume(hope?) that
+		 * Intel will implement it to when they extend the address
+		 * bus of the Xeon.
+		 */
 		if (cpuid_eax(0x80000000) >= 0x80000008) {
 			phys_addr = cpuid_eax(0x80000008) & 0xff;
 			/* CPUID workaround for Intel 0F33/0F34 CPU */
@@ -649,9 +668,11 @@ void __init mtrr_bp_init(void)
 			size_and_mask = ~size_or_mask & 0xfffff00000ULL;
 		} else if (boot_cpu_data.x86_vendor == X86_VENDOR_CENTAUR &&
 			   boot_cpu_data.x86 == 6) {
-			/* VIA C* family have Intel style MTRRs, but
-			   don't support PAE */
-			size_or_mask = 0xfff00000;	/* 32 bits */
+			/*
+			 * VIA C* family have Intel style MTRRs,
+			 * but don't support PAE
+			 */
+			size_or_mask = 0xfff00000;		/* 32 bits */
 			size_and_mask = 0;
 			phys_addr = 32;
 		}
@@ -694,7 +715,6 @@ void __init mtrr_bp_init(void)
 				changed_by_mtrr_cleanup = 1;
 				mtrr_if->set_all();
 			}
-
 		}
 	}
 }
@@ -706,12 +726,17 @@ void mtrr_ap_init(void)
 	if (!mtrr_if || !use_intel())
 		return;
 	/*
-	 * Ideally we should hold mtrr_mutex here to avoid mtrr entries changed,
-	 * but this routine will be called in cpu boot time, holding the lock
-	 * breaks it. This routine is called in two cases: 1.very earily time
-	 * of software resume, when there absolutely isn't mtrr entry changes;
-	 * 2.cpu hotadd time. We let mtrr_add/del_page hold cpuhotplug lock to
-	 * prevent mtrr entry changes
+	 * Ideally we should hold mtrr_mutex here to avoid mtrr entries
+	 * changed, but this routine will be called in cpu boot time,
+	 * holding the lock breaks it.
+	 *
+	 * This routine is called in two cases:
+	 *
+	 *   1. very earily time of software resume, when there absolutely
+	 *      isn't mtrr entry changes;
+	 *
+	 *   2. cpu hotadd time. We let mtrr_add/del_page hold cpuhotplug
+	 *      lock to prevent mtrr entry changes
 	 */
 	local_irq_save(flags);
 
@@ -732,19 +757,23 @@ static int __init mtrr_init_finialize(void)
 {
 	if (!mtrr_if)
 		return 0;
+
 	if (use_intel()) {
 		if (!changed_by_mtrr_cleanup)
 			mtrr_state_warn();
-	} else {
-		/* The CPUs haven't MTRR and seem to not support SMP. They have
-		 * specific drivers, we use a tricky method to support
-		 * suspend/resume for them.
-		 * TBD: is there any system with such CPU which supports
-		 * suspend/resume?  if no, we should remove the code.
-		 */
-		sysdev_driver_register(&cpu_sysdev_class,
-			&mtrr_sysdev_driver);
+		return 0;
 	}
+
+	/*
+	 * The CPU has no MTRR and seems to not support SMP. They have
+	 * specific drivers, we use a tricky method to support
+	 * suspend/resume for them.
+	 *
+	 * TBD: is there any system with such CPU which supports
+	 * suspend/resume? If no, we should remove the code.
+	 */
+	sysdev_driver_register(&cpu_sysdev_class, &mtrr_sysdev_driver);
+
 	return 0;
 }
 subsys_initcall(mtrr_init_finialize);
diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
index 7538b76..a501dee 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -1,5 +1,5 @@
 /*
- * local mtrr defines.
+ * local MTRR defines.
  */
 
 #include <linux/types.h>
@@ -14,13 +14,12 @@ extern unsigned int mtrr_usage_table[MTRR_MAX_VAR_RANGES];
 struct mtrr_ops {
 	u32	vendor;
 	u32	use_intel_if;
-//	void	(*init)(void);
 	void	(*set)(unsigned int reg, unsigned long base,
 		       unsigned long size, mtrr_type type);
 	void	(*set_all)(void);
 
 	void	(*get)(unsigned int reg, unsigned long *base,
-		       unsigned long *size, mtrr_type * type);
+		       unsigned long *size, mtrr_type *type);
 	int	(*get_free_region)(unsigned long base, unsigned long size,
 				   int replace_reg);
 	int	(*validate_add_page)(unsigned long base, unsigned long size,
@@ -39,11 +38,11 @@ extern int positive_have_wrcomb(void);
 
 /* library functions for processor-specific routines */
 struct set_mtrr_context {
-	unsigned long flags;
-	unsigned long cr4val;
-	u32 deftype_lo;
-	u32 deftype_hi;
-	u32 ccr3;
+	unsigned long	flags;
+	unsigned long	cr4val;
+	u32		deftype_lo;
+	u32		deftype_hi;
+	u32		ccr3;
 };
 
 void set_mtrr_done(struct set_mtrr_context *ctxt);
@@ -54,10 +53,10 @@ void fill_mtrr_var_range(unsigned int index,
 		u32 base_lo, u32 base_hi, u32 mask_lo, u32 mask_hi);
 void get_mtrr_state(void);
 
-extern void set_mtrr_ops(struct mtrr_ops * ops);
+extern void set_mtrr_ops(struct mtrr_ops *ops);
 
 extern u64 size_or_mask, size_and_mask;
-extern struct mtrr_ops * mtrr_if;
+extern struct mtrr_ops *mtrr_if;
 
 #define is_cpu(vnd)	(mtrr_if && mtrr_if->vendor == X86_VENDOR_##vnd)
 #define use_intel()	(mtrr_if && mtrr_if->use_intel_if == 1)
diff --git a/arch/x86/kernel/cpu/mtrr/state.c b/arch/x86/kernel/cpu/mtrr/state.c
index 1f5fb15..dfc80b4 100644
--- a/arch/x86/kernel/cpu/mtrr/state.c
+++ b/arch/x86/kernel/cpu/mtrr/state.c
@@ -1,24 +1,25 @@
-#include <linux/mm.h>
 #include <linux/init.h>
-#include <asm/io.h>
-#include <asm/mtrr.h>
-#include <asm/msr.h>
+#include <linux/io.h>
+#include <linux/mm.h>
+
 #include <asm/processor-cyrix.h>
 #include <asm/processor-flags.h>
-#include "mtrr.h"
+#include <asm/mtrr.h>
+#include <asm/msr.h>
 
+#include "mtrr.h"
 
-/*  Put the processor into a state where MTRRs can be safely set  */
+/* Put the processor into a state where MTRRs can be safely set */
 void set_mtrr_prepare_save(struct set_mtrr_context *ctxt)
 {
 	unsigned int cr0;
 
-	/*  Disable interrupts locally  */
+	/* Disable interrupts locally */
 	local_irq_save(ctxt->flags);
 
 	if (use_intel() || is_cpu(CYRIX)) {
 
-		/*  Save value of CR4 and clear Page Global Enable (bit 7)  */
+		/* Save value of CR4 and clear Page Global Enable (bit 7) */
 		if (cpu_has_pge) {
 			ctxt->cr4val = read_cr4();
 			write_cr4(ctxt->cr4val & ~X86_CR4_PGE);
@@ -33,50 +34,61 @@ void set_mtrr_prepare_save(struct set_mtrr_context *ctxt)
 		write_cr0(cr0);
 		wbinvd();
 
-		if (use_intel())
-			/*  Save MTRR state */
+		if (use_intel()) {
+			/* Save MTRR state */
 			rdmsr(MSR_MTRRdefType, ctxt->deftype_lo, ctxt->deftype_hi);
-		else
-			/* Cyrix ARRs - everything else were excluded at the top */
+		} else {
+			/*
+			 * Cyrix ARRs -
+			 * everything else were excluded at the top
+			 */
 			ctxt->ccr3 = getCx86(CX86_CCR3);
+		}
 	}
 }
 
 void set_mtrr_cache_disable(struct set_mtrr_context *ctxt)
 {
-	if (use_intel())
-		/*  Disable MTRRs, and set the default type to uncached  */
+	if (use_intel()) {
+		/* Disable MTRRs, and set the default type to uncached */
 		mtrr_wrmsr(MSR_MTRRdefType, ctxt->deftype_lo & 0xf300UL,
 		      ctxt->deftype_hi);
-	else if (is_cpu(CYRIX))
-		/* Cyrix ARRs - everything else were excluded at the top */
-		setCx86(CX86_CCR3, (ctxt->ccr3 & 0x0f) | 0x10);
+	} else {
+		if (is_cpu(CYRIX)) {
+			/* Cyrix ARRs - everything else were excluded at the top */
+			setCx86(CX86_CCR3, (ctxt->ccr3 & 0x0f) | 0x10);
+		}
+	}
 }
 
-/*  Restore the processor after a set_mtrr_prepare  */
+/* Restore the processor after a set_mtrr_prepare */
 void set_mtrr_done(struct set_mtrr_context *ctxt)
 {
 	if (use_intel() || is_cpu(CYRIX)) {
 
-		/*  Flush caches and TLBs  */
+		/* Flush caches and TLBs */
 		wbinvd();
 
-		/*  Restore MTRRdefType  */
-		if (use_intel())
+		/* Restore MTRRdefType */
+		if (use_intel()) {
 			/* Intel (P6) standard MTRRs */
-			mtrr_wrmsr(MSR_MTRRdefType, ctxt->deftype_lo, ctxt->deftype_hi);
-		else
-			/* Cyrix ARRs - everything else was excluded at the top */
+			mtrr_wrmsr(MSR_MTRRdefType, ctxt->deftype_lo,
+				   ctxt->deftype_hi);
+		} else {
+			/*
+			 * Cyrix ARRs -
+			 * everything else was excluded at the top
+			 */
 			setCx86(CX86_CCR3, ctxt->ccr3);
+		}
 
-		/*  Enable caches  */
+		/* Enable caches */
 		write_cr0(read_cr0() & 0xbfffffff);
 
-		/*  Restore value of CR4  */
+		/* Restore value of CR4 */
 		if (cpu_has_pge)
 			write_cr4(ctxt->cr4val);
 	}
-	/*  Re-enable interrupts locally (if enabled previously)  */
+	/* Re-enable interrupts locally (if enabled previously) */
 	local_irq_restore(ctxt->flags);
 }
-
diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index e60ed74..392bea4 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -68,16 +68,16 @@ static inline unsigned int nmi_perfctr_msr_to_bit(unsigned int msr)
 	/* returns the bit offset of the performance counter register */
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
-		return (msr - MSR_K7_PERFCTR0);
+		return msr - MSR_K7_PERFCTR0;
 	case X86_VENDOR_INTEL:
 		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
-			return (msr - MSR_ARCH_PERFMON_PERFCTR0);
+			return msr - MSR_ARCH_PERFMON_PERFCTR0;
 
 		switch (boot_cpu_data.x86) {
 		case 6:
-			return (msr - MSR_P6_PERFCTR0);
+			return msr - MSR_P6_PERFCTR0;
 		case 15:
-			return (msr - MSR_P4_BPU_PERFCTR0);
+			return msr - MSR_P4_BPU_PERFCTR0;
 		}
 	}
 	return 0;
@@ -92,16 +92,16 @@ static inline unsigned int nmi_evntsel_msr_to_bit(unsigned int msr)
 	/* returns the bit offset of the event selection register */
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
-		return (msr - MSR_K7_EVNTSEL0);
+		return msr - MSR_K7_EVNTSEL0;
 	case X86_VENDOR_INTEL:
 		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
-			return (msr - MSR_ARCH_PERFMON_EVENTSEL0);
+			return msr - MSR_ARCH_PERFMON_EVENTSEL0;
 
 		switch (boot_cpu_data.x86) {
 		case 6:
-			return (msr - MSR_P6_EVNTSEL0);
+			return msr - MSR_P6_EVNTSEL0;
 		case 15:
-			return (msr - MSR_P4_BSU_ESCR0);
+			return msr - MSR_P4_BSU_ESCR0;
 		}
 	}
 	return 0;
@@ -113,7 +113,7 @@ int avail_to_resrv_perfctr_nmi_bit(unsigned int counter)
 {
 	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
 
-	return (!test_bit(counter, perfctr_nmi_owner));
+	return !test_bit(counter, perfctr_nmi_owner);
 }
 
 /* checks the an msr for availability */
@@ -124,7 +124,7 @@ int avail_to_resrv_perfctr_nmi(unsigned int msr)
 	counter = nmi_perfctr_msr_to_bit(msr);
 	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
 
-	return (!test_bit(counter, perfctr_nmi_owner));
+	return !test_bit(counter, perfctr_nmi_owner);
 }
 EXPORT_SYMBOL(avail_to_resrv_perfctr_nmi_bit);
 
@@ -237,7 +237,7 @@ static unsigned int adjust_for_32bit_ctr(unsigned int hz)
 	 */
 	counter_val = (u64)cpu_khz * 1000;
 	do_div(counter_val, retval);
- 	if (counter_val > 0x7fffffffULL) {
+	if (counter_val > 0x7fffffffULL) {
 		u64 count = (u64)cpu_khz * 1000;
 		do_div(count, 0x7fffffffUL);
 		retval = count + 1;
@@ -251,7 +251,7 @@ static void write_watchdog_counter(unsigned int perfctr_msr,
 	u64 count = (u64)cpu_khz * 1000;
 
 	do_div(count, nmi_hz);
-	if(descr)
+	if (descr)
 		pr_debug("setting %s to -0x%08Lx\n", descr, count);
 	wrmsrl(perfctr_msr, 0 - count);
 }
@@ -262,7 +262,7 @@ static void write_watchdog_counter32(unsigned int perfctr_msr,
 	u64 count = (u64)cpu_khz * 1000;
 
 	do_div(count, nmi_hz);
-	if(descr)
+	if (descr)
 		pr_debug("setting %s to -0x%08Lx\n", descr, count);
 	wrmsr(perfctr_msr, (u32)(-count), 0);
 }
@@ -296,7 +296,7 @@ static int setup_k7_watchdog(unsigned nmi_hz)
 
 	/* setup the timer */
 	wrmsr(evntsel_msr, evntsel, 0);
-	write_watchdog_counter(perfctr_msr, "K7_PERFCTR0",nmi_hz);
+	write_watchdog_counter(perfctr_msr, "K7_PERFCTR0", nmi_hz);
 
 	/* initialize the wd struct before enabling */
 	wd->perfctr_msr = perfctr_msr;
@@ -387,7 +387,7 @@ static int setup_p6_watchdog(unsigned nmi_hz)
 	/* setup the timer */
 	wrmsr(evntsel_msr, evntsel, 0);
 	nmi_hz = adjust_for_32bit_ctr(nmi_hz);
-	write_watchdog_counter32(perfctr_msr, "P6_PERFCTR0",nmi_hz);
+	write_watchdog_counter32(perfctr_msr, "P6_PERFCTR0", nmi_hz);
 
 	/* initialize the wd struct before enabling */
 	wd->perfctr_msr = perfctr_msr;
@@ -415,7 +415,7 @@ static void __kprobes p6_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 
 	/* P6/ARCH_PERFMON has 32 bit counter write */
-	write_watchdog_counter32(wd->perfctr_msr, NULL,nmi_hz);
+	write_watchdog_counter32(wd->perfctr_msr, NULL, nmi_hz);
 }
 
 static const struct wd_ops p6_wd_ops = {
@@ -490,9 +490,9 @@ static int setup_p4_watchdog(unsigned nmi_hz)
 	if (smp_num_siblings == 2) {
 		unsigned int ebx, apicid;
 
-        	ebx = cpuid_ebx(1);
-	        apicid = (ebx >> 24) & 0xff;
-        	ht_num = apicid & 1;
+		ebx = cpuid_ebx(1);
+		apicid = (ebx >> 24) & 0xff;
+		ht_num = apicid & 1;
 	} else
 #endif
 		ht_num = 0;
@@ -544,7 +544,7 @@ static int setup_p4_watchdog(unsigned nmi_hz)
 	}
 
 	evntsel = P4_ESCR_EVENT_SELECT(0x3F)
-	 	| P4_ESCR_OS
+		| P4_ESCR_OS
 		| P4_ESCR_USR;
 
 	cccr_val |= P4_CCCR_THRESHOLD(15)
@@ -612,7 +612,7 @@ static void __kprobes p4_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
 {
 	unsigned dummy;
 	/*
- 	 * P4 quirks:
+	 * P4 quirks:
 	 * - An overflown perfctr will assert its interrupt
 	 *   until the OVF flag in its CCCR is cleared.
 	 * - LVTPC is masked on interrupt and must be
@@ -662,7 +662,8 @@ static int setup_intel_arch_watchdog(unsigned nmi_hz)
 	 * NOTE: Corresponding bit = 0 in ebx indicates event present.
 	 */
 	cpuid(10, &(eax.full), &ebx, &unused, &unused);
-	if ((eax.split.mask_length < (ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX+1)) ||
+	if ((eax.split.mask_length <
+			(ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX+1)) ||
 	    (ebx & ARCH_PERFMON_UNHALTED_CORE_CYCLES_PRESENT))
 		return 0;
 
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index d5e3039..1e90434 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -128,7 +128,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 			if (i < ARRAY_SIZE(x86_power_flags) &&
 			    x86_power_flags[i])
 				seq_printf(m, "%s%s",
-					   x86_power_flags[i][0]?" ":"",
+					   x86_power_flags[i][0] ? " " : "",
 					   x86_power_flags[i]);
 			else
 				seq_printf(m, " [%d]", i);
diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index 284c399..bc24f51 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -49,17 +49,17 @@ static inline int __vmware_platform(void)
 
 static unsigned long __vmware_get_tsc_khz(void)
 {
-        uint64_t tsc_hz;
-        uint32_t eax, ebx, ecx, edx;
+	uint64_t tsc_hz;
+	uint32_t eax, ebx, ecx, edx;
 
-        VMWARE_PORT(GETHZ, eax, ebx, ecx, edx);
+	VMWARE_PORT(GETHZ, eax, ebx, ecx, edx);
 
-        if (ebx == UINT_MAX)
-                return 0;
-        tsc_hz = eax | (((uint64_t)ebx) << 32);
-        do_div(tsc_hz, 1000);
-        BUG_ON(tsc_hz >> 32);
-        return tsc_hz;
+	if (ebx == UINT_MAX)
+		return 0;
+	tsc_hz = eax | (((uint64_t)ebx) << 32);
+	do_div(tsc_hz, 1000);
+	BUG_ON(tsc_hz >> 32);
+	return tsc_hz;
 }
 
 /*
diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index 48bfe13..ef42a03 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -509,15 +509,15 @@ enum bts_field {
 	bts_escape		= ((unsigned long)-1 & ~bts_qual_mask)
 };
 
-static inline unsigned long bts_get(const char *base, enum bts_field field)
+static inline unsigned long bts_get(const char *base, unsigned long field)
 {
 	base += (ds_cfg.sizeof_ptr_field * field);
 	return *(unsigned long *)base;
 }
 
-static inline void bts_set(char *base, enum bts_field field, unsigned long val)
+static inline void bts_set(char *base, unsigned long field, unsigned long val)
 {
-	base += (ds_cfg.sizeof_ptr_field * field);;
+	base += (ds_cfg.sizeof_ptr_field * field);
 	(*(unsigned long *)base) = val;
 }
 
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index c840571..2d8a371 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -15,7 +15,6 @@
 #include <linux/bug.h>
 #include <linux/nmi.h>
 #include <linux/sysfs.h>
-#include <linux/ftrace.h>
 
 #include <asm/stacktrace.h>
 
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 3b09634..7d35d0f 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -218,7 +218,6 @@ bool handle_irq(unsigned irq, struct pt_regs *regs)
 void fixup_irqs(void)
 {
 	unsigned int irq;
-	static int warned;
 	struct irq_desc *desc;
 
 	for_each_irq_desc(irq, desc) {
@@ -236,8 +235,8 @@ void fixup_irqs(void)
 		}
 		if (desc->chip->set_affinity)
 			desc->chip->set_affinity(irq, affinity);
-		else if (desc->action && !(warned++))
-			printk("Cannot set affinity for irq %i\n", irq);
+		else if (desc->action)
+			printk_once("Cannot set affinity for irq %i\n", irq);
 	}
 
 #if 0
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index 77b9689..503c1f2 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -640,13 +640,13 @@ static int __init uv_ptc_init(void)
 	if (!is_uv_system())
 		return 0;
 
-	proc_uv_ptc = create_proc_entry(UV_PTC_BASENAME, 0444, NULL);
+	proc_uv_ptc = proc_create(UV_PTC_BASENAME, 0444, NULL,
+				  &proc_uv_ptc_operations);
 	if (!proc_uv_ptc) {
 		printk(KERN_ERR "unable to create %s proc entry\n",
 		       UV_PTC_BASENAME);
 		return -EINVAL;
 	}
-	proc_uv_ptc->proc_fops = &proc_uv_ptc_operations;
 	return 0;
 }
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 5204332..7e4b1f5 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -76,7 +76,7 @@ char ignore_fpu_irq;
  * F0 0F bug workaround.. We have a special link segment
  * for this.
  */
-gate_desc idt_table[256]
+gate_desc idt_table[NR_VECTORS]
 	__attribute__((__section__(".data.idt"))) = { { { { 0, 0 } } }, };
 #endif
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3d45290..633ccc7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2297,12 +2297,7 @@ static int emulator_cmpxchg_emulated(unsigned long addr,
 				     unsigned int bytes,
 				     struct kvm_vcpu *vcpu)
 {
-	static int reported;
-
-	if (!reported) {
-		reported = 1;
-		printk(KERN_WARNING "kvm: emulating exchange as write\n");
-	}
+	printk_once(KERN_WARNING "kvm: emulating exchange as write\n");
 #ifndef CONFIG_X86_64
 	/* guests cmpxchg8b have to be emulated atomically */
 	if (bytes == 8) {
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index e6718bb..e2900a3 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -826,7 +826,7 @@ static int memtype_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static struct seq_operations memtype_seq_ops = {
+static const struct seq_operations memtype_seq_ops = {
 	.start = memtype_seq_start,
 	.next  = memtype_seq_next,
 	.stop  = memtype_seq_stop,
