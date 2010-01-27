Return-Path: <linux-kernel-owner+w=401wt.eu-S1752146Ab0A0Ifg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab0A0Ifg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 03:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870Ab0A0Iff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 03:35:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40960 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab0A0Ife (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 03:35:34 -0500
Date: Wed, 27 Jan 2010 00:33:07 -0800
Message-Id: <201001270833.o0R8X7ZN018729@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for 2.6.33-rc6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Dean Nelson <dnelson@redhat.com>,
       Russ Anderson <rja@sgi.com>, ozan@pardus.org.tr,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai Lu <yinghai@kernel.org>,
       Gene Heskett <gene.heskett@verizon.net>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Mark Hounschell <markh@compro.net>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       David Rientjes <rientjes@google.com>,
       Haicheng Li <haicheng.li@linux.intel.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.2 (terminus.zytor.com [127.0.0.1]); Wed, 27 Jan 2010 00:33:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit b04da8bfdfbbd79544cab2fadfdc12e87eb01600:
  Greg Kroah-Hartman (1):
        fnctl: f_modown should call write_lock_irqsave/restore

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/x86/linux-2.6-tip.git x86-fixes-for-linus

Andreas Herrmann (1):
      Revert "x86: ucode-amd: Load ucode-patches once ..."

David Rientjes (1):
      x86: Set hotpluggable nodes in nodes_possible_map

H. Peter Anvin (1):
      x86: Remove "x86 CPU features in debugfs" (CONFIG_X86_CPU_DEBUG)

Pallipadi, Venkatesh (1):
      x86: Disable HPET MSI on ATI SB700/SB800

Russ Anderson (1):
      x86, msr/cpuid: Pass the number of minors when unregistering MSR and CPUID drivers.

 arch/x86/Kconfig                 |    6 -
 arch/x86/include/asm/cpu_debug.h |  127 -------
 arch/x86/include/asm/hpet.h      |    1 +
 arch/x86/include/asm/microcode.h |    2 -
 arch/x86/kernel/cpu/Makefile     |    2 -
 arch/x86/kernel/cpu/cpu_debug.c  |  688 --------------------------------------
 arch/x86/kernel/cpuid.c          |    2 +-
 arch/x86/kernel/hpet.c           |    8 +
 arch/x86/kernel/microcode_amd.c  |   44 +--
 arch/x86/kernel/microcode_core.c |    6 -
 arch/x86/kernel/msr.c            |    2 +-
 arch/x86/kernel/quirks.c         |   13 +
 arch/x86/mm/srat_64.c            |    4 +-
 13 files changed, 40 insertions(+), 865 deletions(-)
 delete mode 100644 arch/x86/include/asm/cpu_debug.h
 delete mode 100644 arch/x86/kernel/cpu/cpu_debug.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cbcbfde..eb40925 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -989,12 +989,6 @@ config X86_CPUID
 	  with major 203 and minors 0 to 31 for /dev/cpu/0/cpuid to
 	  /dev/cpu/31/cpuid.
 
-config X86_CPU_DEBUG
-	tristate "/sys/kernel/debug/x86/cpu/* - CPU Debug support"
-	---help---
-	  If you select this option, this will provide various x86 CPUs
-	  information through debugfs.
-
 choice
 	prompt "High Memory Support"
 	default HIGHMEM4G if !X86_NUMAQ
diff --git a/arch/x86/include/asm/cpu_debug.h b/arch/x86/include/asm/cpu_debug.h
deleted file mode 100644
index d96c1ee..0000000
--- a/arch/x86/include/asm/cpu_debug.h
+++ /dev/null
@@ -1,127 +0,0 @@
-#ifndef _ASM_X86_CPU_DEBUG_H
-#define _ASM_X86_CPU_DEBUG_H
-
-/*
- * CPU x86 architecture debug
- *
- * Copyright(C) 2009 Jaswinder Singh Rajput
- */
-
-/* Register flags */
-enum cpu_debug_bit {
-/* Model Specific Registers (MSRs)					*/
-	CPU_MC_BIT,				/* Machine Check	*/
-	CPU_MONITOR_BIT,			/* Monitor		*/
-	CPU_TIME_BIT,				/* Time			*/
-	CPU_PMC_BIT,				/* Performance Monitor	*/
-	CPU_PLATFORM_BIT,			/* Platform		*/
-	CPU_APIC_BIT,				/* APIC			*/
-	CPU_POWERON_BIT,			/* Power-on		*/
-	CPU_CONTROL_BIT,			/* Control		*/
-	CPU_FEATURES_BIT,			/* Features control	*/
-	CPU_LBRANCH_BIT,			/* Last Branch		*/
-	CPU_BIOS_BIT,				/* BIOS			*/
-	CPU_FREQ_BIT,				/* Frequency		*/
-	CPU_MTTR_BIT,				/* MTRR			*/
-	CPU_PERF_BIT,				/* Performance		*/
-	CPU_CACHE_BIT,				/* Cache		*/
-	CPU_SYSENTER_BIT,			/* Sysenter		*/
-	CPU_THERM_BIT,				/* Thermal		*/
-	CPU_MISC_BIT,				/* Miscellaneous	*/
-	CPU_DEBUG_BIT,				/* Debug		*/
-	CPU_PAT_BIT,				/* PAT			*/
-	CPU_VMX_BIT,				/* VMX			*/
-	CPU_CALL_BIT,				/* System Call		*/
-	CPU_BASE_BIT,				/* BASE Address		*/
-	CPU_VER_BIT,				/* Version ID		*/
-	CPU_CONF_BIT,				/* Configuration	*/
-	CPU_SMM_BIT,				/* System mgmt mode	*/
-	CPU_SVM_BIT,				/*Secure Virtual Machine*/
-	CPU_OSVM_BIT,				/* OS-Visible Workaround*/
-/* Standard Registers							*/
-	CPU_TSS_BIT,				/* Task Stack Segment	*/
-	CPU_CR_BIT,				/* Control Registers	*/
-	CPU_DT_BIT,				/* Descriptor Table	*/
-/* End of Registers flags						*/
-	CPU_REG_ALL_BIT,			/* Select all Registers	*/
-};
-
-#define	CPU_REG_ALL		(~0)		/* Select all Registers	*/
-
-#define	CPU_MC			(1 << CPU_MC_BIT)
-#define	CPU_MONITOR		(1 << CPU_MONITOR_BIT)
-#define	CPU_TIME		(1 << CPU_TIME_BIT)
-#define	CPU_PMC			(1 << CPU_PMC_BIT)
-#define	CPU_PLATFORM		(1 << CPU_PLATFORM_BIT)
-#define	CPU_APIC		(1 << CPU_APIC_BIT)
-#define	CPU_POWERON		(1 << CPU_POWERON_BIT)
-#define	CPU_CONTROL		(1 << CPU_CONTROL_BIT)
-#define	CPU_FEATURES		(1 << CPU_FEATURES_BIT)
-#define	CPU_LBRANCH		(1 << CPU_LBRANCH_BIT)
-#define	CPU_BIOS		(1 << CPU_BIOS_BIT)
-#define	CPU_FREQ		(1 << CPU_FREQ_BIT)
-#define	CPU_MTRR		(1 << CPU_MTTR_BIT)
-#define	CPU_PERF		(1 << CPU_PERF_BIT)
-#define	CPU_CACHE		(1 << CPU_CACHE_BIT)
-#define	CPU_SYSENTER		(1 << CPU_SYSENTER_BIT)
-#define	CPU_THERM		(1 << CPU_THERM_BIT)
-#define	CPU_MISC		(1 << CPU_MISC_BIT)
-#define	CPU_DEBUG		(1 << CPU_DEBUG_BIT)
-#define	CPU_PAT			(1 << CPU_PAT_BIT)
-#define	CPU_VMX			(1 << CPU_VMX_BIT)
-#define	CPU_CALL		(1 << CPU_CALL_BIT)
-#define	CPU_BASE		(1 << CPU_BASE_BIT)
-#define	CPU_VER			(1 << CPU_VER_BIT)
-#define	CPU_CONF		(1 << CPU_CONF_BIT)
-#define	CPU_SMM			(1 << CPU_SMM_BIT)
-#define	CPU_SVM			(1 << CPU_SVM_BIT)
-#define	CPU_OSVM		(1 << CPU_OSVM_BIT)
-#define	CPU_TSS			(1 << CPU_TSS_BIT)
-#define	CPU_CR			(1 << CPU_CR_BIT)
-#define	CPU_DT			(1 << CPU_DT_BIT)
-
-/* Register file flags */
-enum cpu_file_bit {
-	CPU_INDEX_BIT,				/* index		*/
-	CPU_VALUE_BIT,				/* value		*/
-};
-
-#define	CPU_FILE_VALUE		(1 << CPU_VALUE_BIT)
-
-#define MAX_CPU_FILES		512
-
-struct cpu_private {
-	unsigned		cpu;
-	unsigned		type;
-	unsigned		reg;
-	unsigned		file;
-};
-
-struct cpu_debug_base {
-	char			*name;		/* Register name	*/
-	unsigned		flag;		/* Register flag	*/
-	unsigned		write;		/* Register write flag	*/
-};
-
-/*
- * Currently it looks similar to cpu_debug_base but once we add more files
- * cpu_file_base will go in different direction
- */
-struct cpu_file_base {
-	char			*name;		/* Register file name	*/
-	unsigned		flag;		/* Register file flag	*/
-	unsigned		write;		/* Register write flag	*/
-};
-
-struct cpu_cpuX_base {
-	struct dentry		*dentry;	/* Register dentry	*/
-	int			init;		/* Register index file	*/
-};
-
-struct cpu_debug_range {
-	unsigned		min;		/* Register range min	*/
-	unsigned		max;		/* Register range max	*/
-	unsigned		flag;		/* Supported flags	*/
-};
-
-#endif /* _ASM_X86_CPU_DEBUG_H */
diff --git a/arch/x86/include/asm/hpet.h b/arch/x86/include/asm/hpet.h
index 5d89fd2..1d5c08a 100644
--- a/arch/x86/include/asm/hpet.h
+++ b/arch/x86/include/asm/hpet.h
@@ -67,6 +67,7 @@ extern unsigned long hpet_address;
 extern unsigned long force_hpet_address;
 extern u8 hpet_blockid;
 extern int hpet_force_user;
+extern u8 hpet_msi_disable;
 extern int is_hpet_enabled(void);
 extern int hpet_enable(void);
 extern void hpet_disable(void);
diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index c24ca9a..ef51b50 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -12,8 +12,6 @@ struct device;
 enum ucode_state { UCODE_ERROR, UCODE_OK, UCODE_NFOUND };
 
 struct microcode_ops {
-	void (*init)(struct device *device);
-	void (*fini)(void);
 	enum ucode_state (*request_microcode_user) (int cpu,
 				const void __user *buf, size_t size);
 
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 1d2cb38..c202b62 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -19,8 +19,6 @@ obj-y			+= vmware.o hypervisor.o sched.o
 obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
 obj-$(CONFIG_X86_64)	+= bugs_64.o
 
-obj-$(CONFIG_X86_CPU_DEBUG)		+= cpu_debug.o
-
 obj-$(CONFIG_CPU_SUP_INTEL)		+= intel.o
 obj-$(CONFIG_CPU_SUP_AMD)		+= amd.o
 obj-$(CONFIG_CPU_SUP_CYRIX_32)		+= cyrix.o
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
deleted file mode 100644
index b368cd8..0000000
--- a/arch/x86/kernel/cpu/cpu_debug.c
+++ /dev/null
@@ -1,688 +0,0 @@
-/*
- * CPU x86 architecture debug code
- *
- * Copyright(C) 2009 Jaswinder Singh Rajput
- *
- * For licencing details see kernel-base/COPYING
- */
-
-#include <linux/interrupt.h>
-#include <linux/compiler.h>
-#include <linux/seq_file.h>
-#include <linux/debugfs.h>
-#include <linux/kprobes.h>
-#include <linux/uaccess.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/percpu.h>
-#include <linux/signal.h>
-#include <linux/errno.h>
-#include <linux/sched.h>
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/slab.h>
-#include <linux/smp.h>
-
-#include <asm/cpu_debug.h>
-#include <asm/paravirt.h>
-#include <asm/system.h>
-#include <asm/traps.h>
-#include <asm/apic.h>
-#include <asm/desc.h>
-
-static DEFINE_PER_CPU(struct cpu_cpuX_base [CPU_REG_ALL_BIT], cpud_arr);
-static DEFINE_PER_CPU(struct cpu_private * [MAX_CPU_FILES], cpud_priv_arr);
-static DEFINE_PER_CPU(int, cpud_priv_count);
-
-static DEFINE_MUTEX(cpu_debug_lock);
-
-static struct dentry *cpu_debugfs_dir;
-
-static struct cpu_debug_base cpu_base[] = {
-	{ "mc",		CPU_MC,		0	},
-	{ "monitor",	CPU_MONITOR,	0	},
-	{ "time",	CPU_TIME,	0	},
-	{ "pmc",	CPU_PMC,	1	},
-	{ "platform",	CPU_PLATFORM,	0	},
-	{ "apic",	CPU_APIC,	0	},
-	{ "poweron",	CPU_POWERON,	0	},
-	{ "control",	CPU_CONTROL,	0	},
-	{ "features",	CPU_FEATURES,	0	},
-	{ "lastbranch",	CPU_LBRANCH,	0	},
-	{ "bios",	CPU_BIOS,	0	},
-	{ "freq",	CPU_FREQ,	0	},
-	{ "mtrr",	CPU_MTRR,	0	},
-	{ "perf",	CPU_PERF,	0	},
-	{ "cache",	CPU_CACHE,	0	},
-	{ "sysenter",	CPU_SYSENTER,	0	},
-	{ "therm",	CPU_THERM,	0	},
-	{ "misc",	CPU_MISC,	0	},
-	{ "debug",	CPU_DEBUG,	0	},
-	{ "pat",	CPU_PAT,	0	},
-	{ "vmx",	CPU_VMX,	0	},
-	{ "call",	CPU_CALL,	0	},
-	{ "base",	CPU_BASE,	0	},
-	{ "ver",	CPU_VER,	0	},
-	{ "conf",	CPU_CONF,	0	},
-	{ "smm",	CPU_SMM,	0	},
-	{ "svm",	CPU_SVM,	0	},
-	{ "osvm",	CPU_OSVM,	0	},
-	{ "tss",	CPU_TSS,	0	},
-	{ "cr",		CPU_CR,		0	},
-	{ "dt",		CPU_DT,		0	},
-	{ "registers",	CPU_REG_ALL,	0	},
-};
-
-static struct cpu_file_base cpu_file[] = {
-	{ "index",	CPU_REG_ALL,	0	},
-	{ "value",	CPU_REG_ALL,	1	},
-};
-
-/* CPU Registers Range */
-static struct cpu_debug_range cpu_reg_range[] = {
-	{ 0x00000000, 0x00000001, CPU_MC,	},
-	{ 0x00000006, 0x00000007, CPU_MONITOR,	},
-	{ 0x00000010, 0x00000010, CPU_TIME,	},
-	{ 0x00000011, 0x00000013, CPU_PMC,	},
-	{ 0x00000017, 0x00000017, CPU_PLATFORM,	},
-	{ 0x0000001B, 0x0000001B, CPU_APIC,	},
-	{ 0x0000002A, 0x0000002B, CPU_POWERON,	},
-	{ 0x0000002C, 0x0000002C, CPU_FREQ,	},
-	{ 0x0000003A, 0x0000003A, CPU_CONTROL,	},
-	{ 0x00000040, 0x00000047, CPU_LBRANCH,	},
-	{ 0x00000060, 0x00000067, CPU_LBRANCH,	},
-	{ 0x00000079, 0x00000079, CPU_BIOS,	},
-	{ 0x00000088, 0x0000008A, CPU_CACHE,	},
-	{ 0x0000008B, 0x0000008B, CPU_BIOS,	},
-	{ 0x0000009B, 0x0000009B, CPU_MONITOR,	},
-	{ 0x000000C1, 0x000000C4, CPU_PMC,	},
-	{ 0x000000CD, 0x000000CD, CPU_FREQ,	},
-	{ 0x000000E7, 0x000000E8, CPU_PERF,	},
-	{ 0x000000FE, 0x000000FE, CPU_MTRR,	},
-
-	{ 0x00000116, 0x0000011E, CPU_CACHE,	},
-	{ 0x00000174, 0x00000176, CPU_SYSENTER,	},
-	{ 0x00000179, 0x0000017B, CPU_MC,	},
-	{ 0x00000186, 0x00000189, CPU_PMC,	},
-	{ 0x00000198, 0x00000199, CPU_PERF,	},
-	{ 0x0000019A, 0x0000019A, CPU_TIME,	},
-	{ 0x0000019B, 0x0000019D, CPU_THERM,	},
-	{ 0x000001A0, 0x000001A0, CPU_MISC,	},
-	{ 0x000001C9, 0x000001C9, CPU_LBRANCH,	},
-	{ 0x000001D7, 0x000001D8, CPU_LBRANCH,	},
-	{ 0x000001D9, 0x000001D9, CPU_DEBUG,	},
-	{ 0x000001DA, 0x000001E0, CPU_LBRANCH,	},
-
-	{ 0x00000200, 0x0000020F, CPU_MTRR,	},
-	{ 0x00000250, 0x00000250, CPU_MTRR,	},
-	{ 0x00000258, 0x00000259, CPU_MTRR,	},
-	{ 0x00000268, 0x0000026F, CPU_MTRR,	},
-	{ 0x00000277, 0x00000277, CPU_PAT,	},
-	{ 0x000002FF, 0x000002FF, CPU_MTRR,	},
-
-	{ 0x00000300, 0x00000311, CPU_PMC,	},
-	{ 0x00000345, 0x00000345, CPU_PMC,	},
-	{ 0x00000360, 0x00000371, CPU_PMC,	},
-	{ 0x0000038D, 0x00000390, CPU_PMC,	},
-	{ 0x000003A0, 0x000003BE, CPU_PMC,	},
-	{ 0x000003C0, 0x000003CD, CPU_PMC,	},
-	{ 0x000003E0, 0x000003E1, CPU_PMC,	},
-	{ 0x000003F0, 0x000003F2, CPU_PMC,	},
-
-	{ 0x00000400, 0x00000417, CPU_MC,	},
-	{ 0x00000480, 0x0000048B, CPU_VMX,	},
-
-	{ 0x00000600, 0x00000600, CPU_DEBUG,	},
-	{ 0x00000680, 0x0000068F, CPU_LBRANCH,	},
-	{ 0x000006C0, 0x000006CF, CPU_LBRANCH,	},
-
-	{ 0x000107CC, 0x000107D3, CPU_PMC,	},
-
-	{ 0xC0000080, 0xC0000080, CPU_FEATURES,	},
-	{ 0xC0000081, 0xC0000084, CPU_CALL,	},
-	{ 0xC0000100, 0xC0000102, CPU_BASE,	},
-	{ 0xC0000103, 0xC0000103, CPU_TIME,	},
-
-	{ 0xC0010000, 0xC0010007, CPU_PMC,	},
-	{ 0xC0010010, 0xC0010010, CPU_CONF,	},
-	{ 0xC0010015, 0xC0010015, CPU_CONF,	},
-	{ 0xC0010016, 0xC001001A, CPU_MTRR,	},
-	{ 0xC001001D, 0xC001001D, CPU_MTRR,	},
-	{ 0xC001001F, 0xC001001F, CPU_CONF,	},
-	{ 0xC0010030, 0xC0010035, CPU_BIOS,	},
-	{ 0xC0010044, 0xC0010048, CPU_MC,	},
-	{ 0xC0010050, 0xC0010056, CPU_SMM,	},
-	{ 0xC0010058, 0xC0010058, CPU_CONF,	},
-	{ 0xC0010060, 0xC0010060, CPU_CACHE,	},
-	{ 0xC0010061, 0xC0010068, CPU_SMM,	},
-	{ 0xC0010069, 0xC001006B, CPU_SMM,	},
-	{ 0xC0010070, 0xC0010071, CPU_SMM,	},
-	{ 0xC0010111, 0xC0010113, CPU_SMM,	},
-	{ 0xC0010114, 0xC0010118, CPU_SVM,	},
-	{ 0xC0010140, 0xC0010141, CPU_OSVM,	},
-	{ 0xC0011022, 0xC0011023, CPU_CONF,	},
-};
-
-static int is_typeflag_valid(unsigned cpu, unsigned flag)
-{
-	int i;
-
-	/* Standard Registers should be always valid */
-	if (flag >= CPU_TSS)
-		return 1;
-
-	for (i = 0; i < ARRAY_SIZE(cpu_reg_range); i++) {
-		if (cpu_reg_range[i].flag == flag)
-			return 1;
-	}
-
-	/* Invalid */
-	return 0;
-}
-
-static unsigned get_cpu_range(unsigned cpu, unsigned *min, unsigned *max,
-			      int index, unsigned flag)
-{
-	if (cpu_reg_range[index].flag == flag) {
-		*min = cpu_reg_range[index].min;
-		*max = cpu_reg_range[index].max;
-	} else
-		*max = 0;
-
-	return *max;
-}
-
-/* This function can also be called with seq = NULL for printk */
-static void print_cpu_data(struct seq_file *seq, unsigned type,
-			   u32 low, u32 high)
-{
-	struct cpu_private *priv;
-	u64 val = high;
-
-	if (seq) {
-		priv = seq->private;
-		if (priv->file) {
-			val = (val << 32) | low;
-			seq_printf(seq, "0x%llx\n", val);
-		} else
-			seq_printf(seq, " %08x: %08x_%08x\n",
-				   type, high, low);
-	} else
-		printk(KERN_INFO " %08x: %08x_%08x\n", type, high, low);
-}
-
-/* This function can also be called with seq = NULL for printk */
-static void print_msr(struct seq_file *seq, unsigned cpu, unsigned flag)
-{
-	unsigned msr, msr_min, msr_max;
-	struct cpu_private *priv;
-	u32 low, high;
-	int i;
-
-	if (seq) {
-		priv = seq->private;
-		if (priv->file) {
-			if (!rdmsr_safe_on_cpu(priv->cpu, priv->reg,
-					       &low, &high))
-				print_cpu_data(seq, priv->reg, low, high);
-			return;
-		}
-	}
-
-	for (i = 0; i < ARRAY_SIZE(cpu_reg_range); i++) {
-		if (!get_cpu_range(cpu, &msr_min, &msr_max, i, flag))
-			continue;
-
-		for (msr = msr_min; msr <= msr_max; msr++) {
-			if (rdmsr_safe_on_cpu(cpu, msr, &low, &high))
-				continue;
-			print_cpu_data(seq, msr, low, high);
-		}
-	}
-}
-
-static void print_tss(void *arg)
-{
-	struct pt_regs *regs = task_pt_regs(current);
-	struct seq_file *seq = arg;
-	unsigned int seg;
-
-	seq_printf(seq, " RAX\t: %016lx\n", regs->ax);
-	seq_printf(seq, " RBX\t: %016lx\n", regs->bx);
-	seq_printf(seq, " RCX\t: %016lx\n", regs->cx);
-	seq_printf(seq, " RDX\t: %016lx\n", regs->dx);
-
-	seq_printf(seq, " RSI\t: %016lx\n", regs->si);
-	seq_printf(seq, " RDI\t: %016lx\n", regs->di);
-	seq_printf(seq, " RBP\t: %016lx\n", regs->bp);
-	seq_printf(seq, " ESP\t: %016lx\n", regs->sp);
-
-#ifdef CONFIG_X86_64
-	seq_printf(seq, " R08\t: %016lx\n", regs->r8);
-	seq_printf(seq, " R09\t: %016lx\n", regs->r9);
-	seq_printf(seq, " R10\t: %016lx\n", regs->r10);
-	seq_printf(seq, " R11\t: %016lx\n", regs->r11);
-	seq_printf(seq, " R12\t: %016lx\n", regs->r12);
-	seq_printf(seq, " R13\t: %016lx\n", regs->r13);
-	seq_printf(seq, " R14\t: %016lx\n", regs->r14);
-	seq_printf(seq, " R15\t: %016lx\n", regs->r15);
-#endif
-
-	asm("movl %%cs,%0" : "=r" (seg));
-	seq_printf(seq, " CS\t:             %04x\n", seg);
-	asm("movl %%ds,%0" : "=r" (seg));
-	seq_printf(seq, " DS\t:             %04x\n", seg);
-	seq_printf(seq, " SS\t:             %04lx\n", regs->ss & 0xffff);
-	asm("movl %%es,%0" : "=r" (seg));
-	seq_printf(seq, " ES\t:             %04x\n", seg);
-	asm("movl %%fs,%0" : "=r" (seg));
-	seq_printf(seq, " FS\t:             %04x\n", seg);
-	asm("movl %%gs,%0" : "=r" (seg));
-	seq_printf(seq, " GS\t:             %04x\n", seg);
-
-	seq_printf(seq, " EFLAGS\t: %016lx\n", regs->flags);
-
-	seq_printf(seq, " EIP\t: %016lx\n", regs->ip);
-}
-
-static void print_cr(void *arg)
-{
-	struct seq_file *seq = arg;
-
-	seq_printf(seq, " cr0\t: %016lx\n", read_cr0());
-	seq_printf(seq, " cr2\t: %016lx\n", read_cr2());
-	seq_printf(seq, " cr3\t: %016lx\n", read_cr3());
-	seq_printf(seq, " cr4\t: %016lx\n", read_cr4_safe());
-#ifdef CONFIG_X86_64
-	seq_printf(seq, " cr8\t: %016lx\n", read_cr8());
-#endif
-}
-
-static void print_desc_ptr(char *str, struct seq_file *seq, struct desc_ptr dt)
-{
-	seq_printf(seq, " %s\t: %016llx\n", str, (u64)(dt.address | dt.size));
-}
-
-static void print_dt(void *seq)
-{
-	struct desc_ptr dt;
-	unsigned long ldt;
-
-	/* IDT */
-	store_idt((struct desc_ptr *)&dt);
-	print_desc_ptr("IDT", seq, dt);
-
-	/* GDT */
-	store_gdt((struct desc_ptr *)&dt);
-	print_desc_ptr("GDT", seq, dt);
-
-	/* LDT */
-	store_ldt(ldt);
-	seq_printf(seq, " LDT\t: %016lx\n", ldt);
-
-	/* TR */
-	store_tr(ldt);
-	seq_printf(seq, " TR\t: %016lx\n", ldt);
-}
-
-static void print_dr(void *arg)
-{
-	struct seq_file *seq = arg;
-	unsigned long dr;
-	int i;
-
-	for (i = 0; i < 8; i++) {
-		/* Ignore db4, db5 */
-		if ((i == 4) || (i == 5))
-			continue;
-		get_debugreg(dr, i);
-		seq_printf(seq, " dr%d\t: %016lx\n", i, dr);
-	}
-
-	seq_printf(seq, "\n MSR\t:\n");
-}
-
-static void print_apic(void *arg)
-{
-	struct seq_file *seq = arg;
-
-#ifdef CONFIG_X86_LOCAL_APIC
-	seq_printf(seq, " LAPIC\t:\n");
-	seq_printf(seq, " ID\t\t: %08x\n",  apic_read(APIC_ID) >> 24);
-	seq_printf(seq, " LVR\t\t: %08x\n",  apic_read(APIC_LVR));
-	seq_printf(seq, " TASKPRI\t: %08x\n",  apic_read(APIC_TASKPRI));
-	seq_printf(seq, " ARBPRI\t\t: %08x\n",  apic_read(APIC_ARBPRI));
-	seq_printf(seq, " PROCPRI\t: %08x\n",  apic_read(APIC_PROCPRI));
-	seq_printf(seq, " LDR\t\t: %08x\n",  apic_read(APIC_LDR));
-	seq_printf(seq, " DFR\t\t: %08x\n",  apic_read(APIC_DFR));
-	seq_printf(seq, " SPIV\t\t: %08x\n",  apic_read(APIC_SPIV));
-	seq_printf(seq, " ISR\t\t: %08x\n",  apic_read(APIC_ISR));
-	seq_printf(seq, " ESR\t\t: %08x\n",  apic_read(APIC_ESR));
-	seq_printf(seq, " ICR\t\t: %08x\n",  apic_read(APIC_ICR));
-	seq_printf(seq, " ICR2\t\t: %08x\n",  apic_read(APIC_ICR2));
-	seq_printf(seq, " LVTT\t\t: %08x\n",  apic_read(APIC_LVTT));
-	seq_printf(seq, " LVTTHMR\t: %08x\n",  apic_read(APIC_LVTTHMR));
-	seq_printf(seq, " LVTPC\t\t: %08x\n",  apic_read(APIC_LVTPC));
-	seq_printf(seq, " LVT0\t\t: %08x\n",  apic_read(APIC_LVT0));
-	seq_printf(seq, " LVT1\t\t: %08x\n",  apic_read(APIC_LVT1));
-	seq_printf(seq, " LVTERR\t\t: %08x\n",  apic_read(APIC_LVTERR));
-	seq_printf(seq, " TMICT\t\t: %08x\n",  apic_read(APIC_TMICT));
-	seq_printf(seq, " TMCCT\t\t: %08x\n",  apic_read(APIC_TMCCT));
-	seq_printf(seq, " TDCR\t\t: %08x\n",  apic_read(APIC_TDCR));
-	if (boot_cpu_has(X86_FEATURE_EXTAPIC)) {
-		unsigned int i, v, maxeilvt;
-
-		v = apic_read(APIC_EFEAT);
-		maxeilvt = (v >> 16) & 0xff;
-		seq_printf(seq, " EFEAT\t\t: %08x\n", v);
-		seq_printf(seq, " ECTRL\t\t: %08x\n", apic_read(APIC_ECTRL));
-
-		for (i = 0; i < maxeilvt; i++) {
-			v = apic_read(APIC_EILVTn(i));
-			seq_printf(seq, " EILVT%d\t\t: %08x\n", i, v);
-		}
-	}
-#endif /* CONFIG_X86_LOCAL_APIC */
-	seq_printf(seq, "\n MSR\t:\n");
-}
-
-static int cpu_seq_show(struct seq_file *seq, void *v)
-{
-	struct cpu_private *priv = seq->private;
-
-	if (priv == NULL)
-		return -EINVAL;
-
-	switch (cpu_base[priv->type].flag) {
-	case CPU_TSS:
-		smp_call_function_single(priv->cpu, print_tss, seq, 1);
-		break;
-	case CPU_CR:
-		smp_call_function_single(priv->cpu, print_cr, seq, 1);
-		break;
-	case CPU_DT:
-		smp_call_function_single(priv->cpu, print_dt, seq, 1);
-		break;
-	case CPU_DEBUG:
-		if (priv->file == CPU_INDEX_BIT)
-			smp_call_function_single(priv->cpu, print_dr, seq, 1);
-		print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
-		break;
-	case CPU_APIC:
-		if (priv->file == CPU_INDEX_BIT)
-			smp_call_function_single(priv->cpu, print_apic, seq, 1);
-		print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
-		break;
-
-	default:
-		print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
-		break;
-	}
-	seq_printf(seq, "\n");
-
-	return 0;
-}
-
-static void *cpu_seq_start(struct seq_file *seq, loff_t *pos)
-{
-	if (*pos == 0) /* One time is enough ;-) */
-		return seq;
-
-	return NULL;
-}
-
-static void *cpu_seq_next(struct seq_file *seq, void *v, loff_t *pos)
-{
-	(*pos)++;
-
-	return cpu_seq_start(seq, pos);
-}
-
-static void cpu_seq_stop(struct seq_file *seq, void *v)
-{
-}
-
-static const struct seq_operations cpu_seq_ops = {
-	.start		= cpu_seq_start,
-	.next		= cpu_seq_next,
-	.stop		= cpu_seq_stop,
-	.show		= cpu_seq_show,
-};
-
-static int cpu_seq_open(struct inode *inode, struct file *file)
-{
-	struct cpu_private *priv = inode->i_private;
-	struct seq_file *seq;
-	int err;
-
-	err = seq_open(file, &cpu_seq_ops);
-	if (!err) {
-		seq = file->private_data;
-		seq->private = priv;
-	}
-
-	return err;
-}
-
-static int write_msr(struct cpu_private *priv, u64 val)
-{
-	u32 low, high;
-
-	high = (val >> 32) & 0xffffffff;
-	low = val & 0xffffffff;
-
-	if (!wrmsr_safe_on_cpu(priv->cpu, priv->reg, low, high))
-		return 0;
-
-	return -EPERM;
-}
-
-static int write_cpu_register(struct cpu_private *priv, const char *buf)
-{
-	int ret = -EPERM;
-	u64 val;
-
-	ret = strict_strtoull(buf, 0, &val);
-	if (ret < 0)
-		return ret;
-
-	/* Supporting only MSRs */
-	if (priv->type < CPU_TSS_BIT)
-		return write_msr(priv, val);
-
-	return ret;
-}
-
-static ssize_t cpu_write(struct file *file, const char __user *ubuf,
-			     size_t count, loff_t *off)
-{
-	struct seq_file *seq = file->private_data;
-	struct cpu_private *priv = seq->private;
-	char buf[19];
-
-	if ((priv == NULL) || (count >= sizeof(buf)))
-		return -EINVAL;
-
-	if (copy_from_user(&buf, ubuf, count))
-		return -EFAULT;
-
-	buf[count] = 0;
-
-	if ((cpu_base[priv->type].write) && (cpu_file[priv->file].write))
-		if (!write_cpu_register(priv, buf))
-			return count;
-
-	return -EACCES;
-}
-
-static const struct file_operations cpu_fops = {
-	.owner		= THIS_MODULE,
-	.open		= cpu_seq_open,
-	.read		= seq_read,
-	.write		= cpu_write,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
-static int cpu_create_file(unsigned cpu, unsigned type, unsigned reg,
-			   unsigned file, struct dentry *dentry)
-{
-	struct cpu_private *priv = NULL;
-
-	/* Already intialized */
-	if (file == CPU_INDEX_BIT)
-		if (per_cpu(cpud_arr[type].init, cpu))
-			return 0;
-
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (priv == NULL)
-		return -ENOMEM;
-
-	priv->cpu = cpu;
-	priv->type = type;
-	priv->reg = reg;
-	priv->file = file;
-	mutex_lock(&cpu_debug_lock);
-	per_cpu(cpud_priv_arr[type], cpu) = priv;
-	per_cpu(cpud_priv_count, cpu)++;
-	mutex_unlock(&cpu_debug_lock);
-
-	if (file)
-		debugfs_create_file(cpu_file[file].name, S_IRUGO,
-				    dentry, (void *)priv, &cpu_fops);
-	else {
-		debugfs_create_file(cpu_base[type].name, S_IRUGO,
-				    per_cpu(cpud_arr[type].dentry, cpu),
-				    (void *)priv, &cpu_fops);
-		mutex_lock(&cpu_debug_lock);
-		per_cpu(cpud_arr[type].init, cpu) = 1;
-		mutex_unlock(&cpu_debug_lock);
-	}
-
-	return 0;
-}
-
-static int cpu_init_regfiles(unsigned cpu, unsigned int type, unsigned reg,
-			     struct dentry *dentry)
-{
-	unsigned file;
-	int err = 0;
-
-	for (file = 0; file <  ARRAY_SIZE(cpu_file); file++) {
-		err = cpu_create_file(cpu, type, reg, file, dentry);
-		if (err)
-			return err;
-	}
-
-	return err;
-}
-
-static int cpu_init_msr(unsigned cpu, unsigned type, struct dentry *dentry)
-{
-	struct dentry *cpu_dentry = NULL;
-	unsigned reg, reg_min, reg_max;
-	int i, err = 0;
-	char reg_dir[12];
-	u32 low, high;
-
-	for (i = 0; i < ARRAY_SIZE(cpu_reg_range); i++) {
-		if (!get_cpu_range(cpu, &reg_min, &reg_max, i,
-				   cpu_base[type].flag))
-			continue;
-
-		for (reg = reg_min; reg <= reg_max; reg++) {
-			if (rdmsr_safe_on_cpu(cpu, reg, &low, &high))
-				continue;
-
-			sprintf(reg_dir, "0x%x", reg);
-			cpu_dentry = debugfs_create_dir(reg_dir, dentry);
-			err = cpu_init_regfiles(cpu, type, reg, cpu_dentry);
-			if (err)
-				return err;
-		}
-	}
-
-	return err;
-}
-
-static int cpu_init_allreg(unsigned cpu, struct dentry *dentry)
-{
-	struct dentry *cpu_dentry = NULL;
-	unsigned type;
-	int err = 0;
-
-	for (type = 0; type <  ARRAY_SIZE(cpu_base) - 1; type++) {
-		if (!is_typeflag_valid(cpu, cpu_base[type].flag))
-			continue;
-		cpu_dentry = debugfs_create_dir(cpu_base[type].name, dentry);
-		per_cpu(cpud_arr[type].dentry, cpu) = cpu_dentry;
-
-		if (type < CPU_TSS_BIT)
-			err = cpu_init_msr(cpu, type, cpu_dentry);
-		else
-			err = cpu_create_file(cpu, type, 0, CPU_INDEX_BIT,
-					      cpu_dentry);
-		if (err)
-			return err;
-	}
-
-	return err;
-}
-
-static int cpu_init_cpu(void)
-{
-	struct dentry *cpu_dentry = NULL;
-	struct cpuinfo_x86 *cpui;
-	char cpu_dir[12];
-	unsigned cpu;
-	int err = 0;
-
-	for (cpu = 0; cpu < nr_cpu_ids; cpu++) {
-		cpui = &cpu_data(cpu);
-		if (!cpu_has(cpui, X86_FEATURE_MSR))
-			continue;
-
-		sprintf(cpu_dir, "cpu%d", cpu);
-		cpu_dentry = debugfs_create_dir(cpu_dir, cpu_debugfs_dir);
-		err = cpu_init_allreg(cpu, cpu_dentry);
-
-		pr_info("cpu%d(%d) debug files %d\n",
-			cpu, nr_cpu_ids, per_cpu(cpud_priv_count, cpu));
-		if (per_cpu(cpud_priv_count, cpu) > MAX_CPU_FILES) {
-			pr_err("Register files count %d exceeds limit %d\n",
-				per_cpu(cpud_priv_count, cpu), MAX_CPU_FILES);
-			per_cpu(cpud_priv_count, cpu) = MAX_CPU_FILES;
-			err = -ENFILE;
-		}
-		if (err)
-			return err;
-	}
-
-	return err;
-}
-
-static int __init cpu_debug_init(void)
-{
-	cpu_debugfs_dir = debugfs_create_dir("cpu", arch_debugfs_dir);
-
-	return cpu_init_cpu();
-}
-
-static void __exit cpu_debug_exit(void)
-{
-	int i, cpu;
-
-	if (cpu_debugfs_dir)
-		debugfs_remove_recursive(cpu_debugfs_dir);
-
-	for (cpu = 0; cpu <  nr_cpu_ids; cpu++)
-		for (i = 0; i < per_cpu(cpud_priv_count, cpu); i++)
-			kfree(per_cpu(cpud_priv_arr[i], cpu));
-}
-
-module_init(cpu_debug_init);
-module_exit(cpu_debug_exit);
-
-MODULE_AUTHOR("Jaswinder Singh Rajput");
-MODULE_DESCRIPTION("CPU Debug module");
-MODULE_LICENSE("GPL");
diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index cb27fd6..83e5e62 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -229,7 +229,7 @@ static void __exit cpuid_exit(void)
 	for_each_online_cpu(cpu)
 		cpuid_device_destroy(cpu);
 	class_destroy(cpuid_class);
-	unregister_chrdev(CPUID_MAJOR, "cpu/cpuid");
+	__unregister_chrdev(CPUID_MAJOR, 0, NR_CPUS, "cpu/cpuid");
 	unregister_hotcpu_notifier(&cpuid_class_cpu_notifier);
 }
 
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index ba6e658..ad80a1c 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -34,6 +34,8 @@
  */
 unsigned long				hpet_address;
 u8					hpet_blockid; /* OS timer block num */
+u8					hpet_msi_disable;
+
 #ifdef CONFIG_PCI_MSI
 static unsigned long			hpet_num_timers;
 #endif
@@ -596,6 +598,9 @@ static void hpet_msi_capability_lookup(unsigned int start_timer)
 	unsigned int num_timers_used = 0;
 	int i;
 
+	if (hpet_msi_disable)
+		return;
+
 	if (boot_cpu_has(X86_FEATURE_ARAT))
 		return;
 	id = hpet_readl(HPET_ID);
@@ -928,6 +933,9 @@ static __init int hpet_late_init(void)
 	hpet_reserve_platform_timers(hpet_readl(HPET_ID));
 	hpet_print_config();
 
+	if (hpet_msi_disable)
+		return 0;
+
 	if (boot_cpu_has(X86_FEATURE_ARAT))
 		return 0;
 
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 37542b6..e1af7c0 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -36,9 +36,6 @@ MODULE_LICENSE("GPL v2");
 #define UCODE_EQUIV_CPU_TABLE_TYPE 0x00000000
 #define UCODE_UCODE_TYPE           0x00000001
 
-const struct firmware *firmware;
-static int supported_cpu;
-
 struct equiv_cpu_entry {
 	u32	installed_cpu;
 	u32	fixed_errata_mask;
@@ -77,12 +74,15 @@ static struct equiv_cpu_entry *equiv_cpu_table;
 
 static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 {
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	u32 dummy;
 
-	if (!supported_cpu)
-		return -1;
-
 	memset(csig, 0, sizeof(*csig));
+	if (c->x86_vendor != X86_VENDOR_AMD || c->x86 < 0x10) {
+		pr_warning("microcode: CPU%d: AMD CPU family 0x%x not "
+			   "supported\n", cpu, c->x86);
+		return -1;
+	}
 	rdmsr(MSR_AMD64_PATCH_LEVEL, csig->rev, dummy);
 	pr_info("CPU%d: patch_level=0x%x\n", cpu, csig->rev);
 	return 0;
@@ -294,10 +294,14 @@ generic_load_microcode(int cpu, const u8 *data, size_t size)
 
 static enum ucode_state request_microcode_fw(int cpu, struct device *device)
 {
+	const char *fw_name = "amd-ucode/microcode_amd.bin";
+	const struct firmware *firmware;
 	enum ucode_state ret;
 
-	if (firmware == NULL)
+	if (request_firmware(&firmware, fw_name, device)) {
+		printk(KERN_ERR "microcode: failed to load file %s\n", fw_name);
 		return UCODE_NFOUND;
+	}
 
 	if (*(u32 *)firmware->data != UCODE_MAGIC) {
 		pr_err("invalid UCODE_MAGIC (0x%08x)\n",
@@ -307,6 +311,8 @@ static enum ucode_state request_microcode_fw(int cpu, struct device *device)
 
 	ret = generic_load_microcode(cpu, firmware->data, firmware->size);
 
+	release_firmware(firmware);
+
 	return ret;
 }
 
@@ -325,31 +331,7 @@ static void microcode_fini_cpu_amd(int cpu)
 	uci->mc = NULL;
 }
 
-void init_microcode_amd(struct device *device)
-{
-	const char *fw_name = "amd-ucode/microcode_amd.bin";
-	struct cpuinfo_x86 *c = &boot_cpu_data;
-
-	WARN_ON(c->x86_vendor != X86_VENDOR_AMD);
-
-	if (c->x86 < 0x10) {
-		pr_warning("AMD CPU family 0x%x not supported\n", c->x86);
-		return;
-	}
-	supported_cpu = 1;
-
-	if (request_firmware(&firmware, fw_name, device))
-		pr_err("failed to load file %s\n", fw_name);
-}
-
-void fini_microcode_amd(void)
-{
-	release_firmware(firmware);
-}
-
 static struct microcode_ops microcode_amd_ops = {
-	.init				  = init_microcode_amd,
-	.fini				  = fini_microcode_amd,
 	.request_microcode_user           = request_microcode_user,
 	.request_microcode_fw             = request_microcode_fw,
 	.collect_cpu_info                 = collect_cpu_info_amd,
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 0c86324..cceb5bc 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -521,9 +521,6 @@ static int __init microcode_init(void)
 		return PTR_ERR(microcode_pdev);
 	}
 
-	if (microcode_ops->init)
-		microcode_ops->init(&microcode_pdev->dev);
-
 	get_online_cpus();
 	mutex_lock(&microcode_mutex);
 
@@ -566,9 +563,6 @@ static void __exit microcode_exit(void)
 
 	platform_device_unregister(microcode_pdev);
 
-	if (microcode_ops->fini)
-		microcode_ops->fini();
-
 	microcode_ops = NULL;
 
 	pr_info("Microcode Update Driver: v" MICROCODE_VERSION " removed.\n");
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 4bd93c9..206735a 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -285,7 +285,7 @@ static void __exit msr_exit(void)
 	for_each_online_cpu(cpu)
 		msr_device_destroy(cpu);
 	class_destroy(msr_class);
-	unregister_chrdev(MSR_MAJOR, "cpu/msr");
+	__unregister_chrdev(MSR_MAJOR, 0, NR_CPUS, "cpu/msr");
 	unregister_hotcpu_notifier(&msr_class_cpu_notifier);
 }
 
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 18093d7..12e9fea 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -491,6 +491,19 @@ void force_hpet_resume(void)
 		break;
 	}
 }
+
+/*
+ * HPET MSI on some boards (ATI SB700/SB800) has side effect on
+ * floppy DMA. Disable HPET MSI on such platforms.
+ */
+static void force_disable_hpet_msi(struct pci_dev *unused)
+{
+	hpet_msi_disable = 1;
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
+			 force_disable_hpet_msi);
+
 #endif
 
 #if defined(CONFIG_PCI) && defined(CONFIG_NUMA)
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index a271241..28c6876 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -229,9 +229,11 @@ update_nodes_add(int node, unsigned long start, unsigned long end)
 			printk(KERN_ERR "SRAT: Hotplug zone not continuous. Partly ignored\n");
 	}
 
-	if (changed)
+	if (changed) {
+		node_set(node, cpu_nodes_parsed);
 		printk(KERN_INFO "SRAT: hot plug zone found %Lx - %Lx\n",
 				 nd->start, nd->end);
+	}
 }
 
 /* Callback for parsing of the Proximity Domain <-> Memory Area mappings */
