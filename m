Return-Path: <linux-kernel-owner+w=401wt.eu-S1758128AbZFJLh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128AbZFJLh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 07:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755600AbZFJLht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 07:37:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:41275 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299AbZFJLhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 07:37:47 -0400
Subject: [git-pull -tip] cpu_debug patches 20090610
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 10 Jun 2009 17:08:32 +0530
Message-Id: <1244633912.20890.6.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 50149b2db7be15514079089d0c4efa4c7a2676bb:
  Ingo Molnar (1):
        Merge branch 'linus'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git master

Jaswinder Singh Rajput (7):
      x86: cpu_debug update Kconfig entry
      x86: cpu_debug.c remove some not required header files
      x86: cpu_debug.c use a WARN_ONCE() instead of a pr_err()
      x86: cpu_debug make room to support more categories
      x86: cpu_debug update MSR list to support new architectures
      x86: cpu_debug make room for more cpu registers
      x86: cpu_debug support APIC_register_name with directory structure

 arch/x86/Kconfig                 |   12 ++-
 arch/x86/include/asm/cpu_debug.h |  111 +++++++----------
 arch/x86/kernel/cpu/cpu_debug.c  |  252 ++++++++++++++++++++++++++------------
 3 files changed, 227 insertions(+), 148 deletions(-)

Complete diff:

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0c2321d..e5e26b3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -994,9 +994,19 @@ config X86_CPUID
 
 config X86_CPU_DEBUG
 	tristate "/sys/kernel/debug/x86/cpu/* - CPU Debug support"
+	select DEBUG_FS
 	---help---
 	  If you select this option, this will provide various x86 CPUs
-	  information through debugfs.
+	  information through debugfs. Any user can read these file but writing
+	  needs root privilege.
+
+	  Note: 1. If you compile cpu_debug as a module, it will _not_ be loaded
+	  automatically (like usual drivers). You will need to load it manually
+	  (or add it to list of modules loaded during boot).
+
+	  2. You need debugfs, if you want to mount debugfs automatically
+	  append this line in /etc/fstab:
+	  debugfs	/sys/kernel/debug	debugfs	defaults	0 0
 
 choice
 	prompt "High Memory Support"
diff --git a/arch/x86/include/asm/cpu_debug.h b/arch/x86/include/asm/cpu_debug.h
index d96c1ee..fd20da7 100644
--- a/arch/x86/include/asm/cpu_debug.h
+++ b/arch/x86/include/asm/cpu_debug.h
@@ -10,83 +10,59 @@
 /* Register flags */
 enum cpu_debug_bit {
 /* Model Specific Registers (MSRs)					*/
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
+	CPU_MC,					/* Machine Check	*/
+	CPU_MONITOR,				/* Monitor		*/
+	CPU_TIME,				/* Time			*/
+	CPU_PMC,				/* Performance Monitor	*/
+	CPU_PLATFORM,				/* Platform		*/
+	CPU_APIC,				/* APIC			*/
+	CPU_POWERON,				/* Power-on		*/
+	CPU_CONTROL,				/* Control		*/
+	CPU_FEATURES,				/* Features control	*/
+	CPU_LBRANCH,				/* Last Branch		*/
+	CPU_BIOS,				/* BIOS			*/
+	CPU_FREQ,				/* Frequency		*/
+	CPU_MTRR,				/* MTRR			*/
+	CPU_PERF,				/* Performance		*/
+	CPU_CACHE,				/* Cache		*/
+	CPU_SYSENTER,				/* Sysenter		*/
+	CPU_THERM,				/* Thermal		*/
+	CPU_MISC,				/* Miscellaneous	*/
+	CPU_DEBUG,				/* Debug		*/
+	CPU_PAT,				/* PAT			*/
+	CPU_VMX,				/* VMX			*/
+	CPU_CALL,				/* System Call		*/
+	CPU_BASE,				/* BASE Address		*/
+	CPU_VER,				/* Version ID		*/
+	CPU_CONF,				/* Configuration	*/
+	CPU_SMM,				/* System mgmt mode	*/
+	CPU_POWER,				/* Power mgmt		*/
+	CPU_PNAME,				/* Processor name	*/
+	CPU_IBS,				/* IBS			*/
+	CPU_SVM,				/*Secure Virtual Machine*/
+	CPU_OSVM,				/* OS-Visible Workaround*/
 /* Standard Registers							*/
-	CPU_TSS_BIT,				/* Task Stack Segment	*/
-	CPU_CR_BIT,				/* Control Registers	*/
-	CPU_DT_BIT,				/* Descriptor Table	*/
+	CPU_TSS,				/* Task Stack Segment	*/
+	CPU_CR,					/* Control Registers	*/
+	CPU_DT,					/* Descriptor Table	*/
 /* End of Registers flags						*/
-	CPU_REG_ALL_BIT,			/* Select all Registers	*/
+	CPU_REG_MAX,				/* Max Registers flags	*/
 };
 
 #define	CPU_REG_ALL		(~0)		/* Select all Registers	*/
 
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
 /* Register file flags */
 enum cpu_file_bit {
-	CPU_INDEX_BIT,				/* index		*/
-	CPU_VALUE_BIT,				/* value		*/
+	CPU_INDEX,				/* index		*/
+	CPU_VALUE,				/* value		*/
 };
 
-#define	CPU_FILE_VALUE		(1 << CPU_VALUE_BIT)
+/* Register category flags */
+enum cpu_cat_bit {
+	CPU_REG_STD,				/* Standard registers	*/
+	CPU_REG_MSR,				/* MSRs			*/
+	CPU_REG_APIC,				/* APIC registers	*/
+};
 
 #define MAX_CPU_FILES		512
 
@@ -95,6 +71,7 @@ struct cpu_private {
 	unsigned		type;
 	unsigned		reg;
 	unsigned		file;
+	unsigned		cat;
 };
 
 struct cpu_debug_base {
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
index 6b2a52d..fcfd22f 100644
--- a/arch/x86/kernel/cpu/cpu_debug.c
+++ b/arch/x86/kernel/cpu/cpu_debug.c
@@ -6,16 +6,12 @@
  * For licencing details see kernel-base/COPYING
  */
 
-#include <linux/interrupt.h>
-#include <linux/compiler.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
-#include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/percpu.h>
-#include <linux/signal.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/types.h>
@@ -26,11 +22,10 @@
 #include <asm/cpu_debug.h>
 #include <asm/paravirt.h>
 #include <asm/system.h>
-#include <asm/traps.h>
 #include <asm/apic.h>
 #include <asm/desc.h>
 
-static DEFINE_PER_CPU(struct cpu_cpuX_base, cpu_arr[CPU_REG_ALL_BIT]);
+static DEFINE_PER_CPU(struct cpu_cpuX_base, cpu_arr[CPU_REG_MAX]);
 static DEFINE_PER_CPU(struct cpu_private *, priv_arr[MAX_CPU_FILES]);
 static DEFINE_PER_CPU(int, cpu_priv_count);
 
@@ -65,6 +60,9 @@ static struct cpu_debug_base cpu_base[] = {
 	{ "ver",	CPU_VER,	0	},
 	{ "conf",	CPU_CONF,	0	},
 	{ "smm",	CPU_SMM,	0	},
+	{ "power",	CPU_POWER,	0	},
+	{ "pname",	CPU_PNAME,	0	},
+	{ "ibs",	CPU_IBS,	0	},
 	{ "svm",	CPU_SVM,	0	},
 	{ "osvm",	CPU_OSVM,	0	},
 	{ "tss",	CPU_TSS,	0	},
@@ -73,13 +71,44 @@ static struct cpu_debug_base cpu_base[] = {
 	{ "registers",	CPU_REG_ALL,	0	},
 };
 
+#ifdef CONFIG_X86_LOCAL_APIC
+static struct cpu_debug_base cpu_apic[] = {
+	{ "ID",		APIC_ID,	0	},
+	{ "LVR",	APIC_LVR,	0	},
+	{ "TASKPRI",	APIC_TASKPRI,	0	},
+	{ "ARBPRI",	APIC_ARBPRI,	0	},
+	{ "PROCPRI",	APIC_PROCPRI,	0	},
+	{ "LDR",	APIC_LDR,	0	},
+	{ "DFR",	APIC_DFR,	0	},
+	{ "SPIV",	APIC_SPIV,	0	},
+	{ "ISR",	APIC_ISR,	0	},
+	{ "ESR",	APIC_ESR,	0	},
+	{ "ICR",	APIC_ICR,	0	},
+	{ "ICR2",	APIC_ICR2,	0	},
+	{ "LVTT",	APIC_LVTT,	0	},
+	{ "LVTTHMR",	APIC_LVTTHMR,	0	},
+	{ "LVTPC",	APIC_LVTPC,	0	},
+	{ "LVT0",	APIC_LVT0,	0	},
+	{ "LVT1",	APIC_LVT1,	0	},
+	{ "LVTERR",	APIC_LVTERR,	0	},
+	{ "TMICT",	APIC_TMICT,	0	},
+	{ "TMCCT",	APIC_TMCCT,	0	},
+	{ "TDCR",	APIC_TDCR,	0	},
+};
+
+static struct cpu_debug_base cpu_xapic[] = {
+	{ "EFEAT",	APIC_EFEAT,	0	},
+	{ "ECTRL",	APIC_ECTRL,	0	},
+};
+#endif
+
 static struct cpu_file_base cpu_file[] = {
-	{ "index",	CPU_REG_ALL,	0	},
+	{ "state",	CPU_REG_ALL,	0	},
 	{ "value",	CPU_REG_ALL,	1	},
 };
 
 /* CPU Registers Range */
-static struct cpu_debug_range cpu_reg_range[] = {
+static struct cpu_debug_range cpu_msr_range[] = {
 	{ 0x00000000, 0x00000001, CPU_MC,	},
 	{ 0x00000006, 0x00000007, CPU_MONITOR,	},
 	{ 0x00000010, 0x00000010, CPU_TIME,	},
@@ -95,6 +124,7 @@ static struct cpu_debug_range cpu_reg_range[] = {
 	{ 0x00000088, 0x0000008A, CPU_CACHE,	},
 	{ 0x0000008B, 0x0000008B, CPU_BIOS,	},
 	{ 0x0000009B, 0x0000009B, CPU_MONITOR,	},
+	{ 0x000000A0, 0x000000A1, CPU_SMM,	},
 	{ 0x000000C1, 0x000000C4, CPU_PMC,	},
 	{ 0x000000CD, 0x000000CD, CPU_FREQ,	},
 	{ 0x000000E7, 0x000000E8, CPU_PERF,	},
@@ -103,40 +133,49 @@ static struct cpu_debug_range cpu_reg_range[] = {
 	{ 0x00000116, 0x0000011E, CPU_CACHE,	},
 	{ 0x00000174, 0x00000176, CPU_SYSENTER,	},
 	{ 0x00000179, 0x0000017B, CPU_MC,	},
+	{ 0x00000180, 0x00000185, CPU_MC,	},
 	{ 0x00000186, 0x00000189, CPU_PMC,	},
 	{ 0x00000198, 0x00000199, CPU_PERF,	},
 	{ 0x0000019A, 0x0000019A, CPU_TIME,	},
 	{ 0x0000019B, 0x0000019D, CPU_THERM,	},
 	{ 0x000001A0, 0x000001A0, CPU_MISC,	},
-	{ 0x000001C9, 0x000001C9, CPU_LBRANCH,	},
+	{ 0x000001A1, 0x000001A1, CPU_PLATFORM,	},
+	{ 0x000001A2, 0x000001A2, CPU_THERM,	},
+	{ 0x000001A6, 0x000001A6, CPU_PMC,	},
+	{ 0x000001AD, 0x000001AD, CPU_FREQ,	},
+	{ 0x000001C8, 0x000001C9, CPU_LBRANCH,	},
 	{ 0x000001D7, 0x000001D8, CPU_LBRANCH,	},
 	{ 0x000001D9, 0x000001D9, CPU_DEBUG,	},
 	{ 0x000001DA, 0x000001E0, CPU_LBRANCH,	},
+	{ 0x000001F2, 0x000001F3, CPU_SMM,	},
 
 	{ 0x00000200, 0x0000020F, CPU_MTRR,	},
 	{ 0x00000250, 0x00000250, CPU_MTRR,	},
 	{ 0x00000258, 0x00000259, CPU_MTRR,	},
 	{ 0x00000268, 0x0000026F, CPU_MTRR,	},
 	{ 0x00000277, 0x00000277, CPU_PAT,	},
+	{ 0x00000280, 0x00000288, CPU_MC,	},
 	{ 0x000002FF, 0x000002FF, CPU_MTRR,	},
 
 	{ 0x00000300, 0x00000311, CPU_PMC,	},
 	{ 0x00000345, 0x00000345, CPU_PMC,	},
 	{ 0x00000360, 0x00000371, CPU_PMC,	},
-	{ 0x0000038D, 0x00000390, CPU_PMC,	},
+	{ 0x0000038D, 0x00000396, CPU_PMC,	},
 	{ 0x000003A0, 0x000003BE, CPU_PMC,	},
 	{ 0x000003C0, 0x000003CD, CPU_PMC,	},
 	{ 0x000003E0, 0x000003E1, CPU_PMC,	},
-	{ 0x000003F0, 0x000003F2, CPU_PMC,	},
+	{ 0x000003F0, 0x000003FD, CPU_PMC,	},
 
-	{ 0x00000400, 0x00000417, CPU_MC,	},
+	{ 0x00000400, 0x00000421, CPU_MC,	},
 	{ 0x00000480, 0x0000048B, CPU_VMX,	},
 
 	{ 0x00000600, 0x00000600, CPU_DEBUG,	},
 	{ 0x00000680, 0x0000068F, CPU_LBRANCH,	},
 	{ 0x000006C0, 0x000006CF, CPU_LBRANCH,	},
 
-	{ 0x000107CC, 0x000107D3, CPU_PMC,	},
+	{ 0x00000800, 0x0000083F, CPU_APIC,	},
+
+	{ 0x000107CC, 0x000107D8, CPU_PMC,	},
 
 	{ 0xC0000080, 0xC0000080, CPU_FEATURES,	},
 	{ 0xC0000081, 0xC0000084, CPU_CALL,	},
@@ -149,20 +188,26 @@ static struct cpu_debug_range cpu_reg_range[] = {
 	{ 0xC0010016, 0xC001001A, CPU_MTRR,	},
 	{ 0xC001001D, 0xC001001D, CPU_MTRR,	},
 	{ 0xC001001F, 0xC001001F, CPU_CONF,	},
-	{ 0xC0010030, 0xC0010035, CPU_BIOS,	},
-	{ 0xC0010044, 0xC0010048, CPU_MC,	},
+	{ 0xC0010022, 0xC0010022, CPU_MC,	},
+	{ 0xC0010030, 0xC0010035, CPU_PNAME,	},
+	{ 0xC0010044, 0xC0010049, CPU_MC,	},
 	{ 0xC0010050, 0xC0010056, CPU_SMM,	},
 	{ 0xC0010058, 0xC0010058, CPU_CONF,	},
 	{ 0xC0010060, 0xC0010060, CPU_CACHE,	},
-	{ 0xC0010061, 0xC0010068, CPU_SMM,	},
-	{ 0xC0010069, 0xC001006B, CPU_SMM,	},
+	{ 0xC0010061, 0xC001006B, CPU_POWER,	},
 	{ 0xC0010070, 0xC0010071, CPU_SMM,	},
+	{ 0xC0010074, 0xC0010074, CPU_TIME,	},
 	{ 0xC0010111, 0xC0010113, CPU_SMM,	},
 	{ 0xC0010114, 0xC0010118, CPU_SVM,	},
 	{ 0xC0010140, 0xC0010141, CPU_OSVM,	},
+
+	{ 0xC0011004, 0xC0011005, CPU_FEATURES,	},
 	{ 0xC0011022, 0xC0011023, CPU_CONF,	},
+	{ 0xC001102A, 0xC001102A, CPU_CONF,	},
+	{ 0xC0011030, 0xC001103A, CPU_IBS,	},
 };
 
+/* Check validity of cpu debug flag */
 static int is_typeflag_valid(unsigned cpu, unsigned flag)
 {
 	int i;
@@ -171,8 +216,9 @@ static int is_typeflag_valid(unsigned cpu, unsigned flag)
 	if (flag >= CPU_TSS)
 		return 1;
 
-	for (i = 0; i < ARRAY_SIZE(cpu_reg_range); i++) {
-		if (cpu_reg_range[i].flag == flag)
+	/* check MSR range */
+	for (i = 0; i < ARRAY_SIZE(cpu_msr_range); i++) {
+		if (cpu_msr_range[i].flag == flag)
 			return 1;
 	}
 
@@ -180,12 +226,13 @@ static int is_typeflag_valid(unsigned cpu, unsigned flag)
 	return 0;
 }
 
-static unsigned get_cpu_range(unsigned cpu, unsigned *min, unsigned *max,
+/* get MSR range */
+static unsigned get_msr_range(unsigned cpu, unsigned *min, unsigned *max,
 			      int index, unsigned flag)
 {
-	if (cpu_reg_range[index].flag == flag) {
-		*min = cpu_reg_range[index].min;
-		*max = cpu_reg_range[index].max;
+	if (cpu_msr_range[index].flag == flag) {
+		*min = cpu_msr_range[index].min;
+		*max = cpu_msr_range[index].max;
 	} else
 		*max = 0;
 
@@ -226,11 +273,12 @@ static void print_msr(struct seq_file *seq, unsigned cpu, unsigned flag)
 					       &low, &high))
 				print_cpu_data(seq, priv->reg, low, high);
 			return;
-		}
+		} else
+			seq_printf(seq, " MSR\t:\n");
 	}
 
-	for (i = 0; i < ARRAY_SIZE(cpu_reg_range); i++) {
-		if (!get_cpu_range(cpu, &msr_min, &msr_max, i, flag))
+	for (i = 0; i < ARRAY_SIZE(cpu_msr_range); i++) {
+		if (!get_msr_range(cpu, &msr_min, &msr_max, i, flag))
 			continue;
 
 		for (msr = msr_min; msr <= msr_max; msr++) {
@@ -339,7 +387,7 @@ static void print_dr(void *arg)
 		seq_printf(seq, " dr%d\t: %016lx\n", i, dr);
 	}
 
-	seq_printf(seq, "\n MSR\t:\n");
+	seq_printf(seq, "\n");
 }
 
 static void print_apic(void *arg)
@@ -347,43 +395,42 @@ static void print_apic(void *arg)
 	struct seq_file *seq = arg;
 
 #ifdef CONFIG_X86_LOCAL_APIC
+	unsigned int i;
+
 	seq_printf(seq, " LAPIC\t:\n");
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
+	for (i = 0; i < ARRAY_SIZE(cpu_apic); i++) {
+		if (strlen(cpu_apic[i].name) < 7)
+			seq_printf(seq, " %s\t\t: %08x\n",  cpu_apic[i].name,
+				   apic_read(cpu_apic[i].flag));
+		else
+			seq_printf(seq, " %s\t: %08x\n",  cpu_apic[i].name,
+				   apic_read(cpu_apic[i].flag));
+	}
 	if (boot_cpu_has(X86_FEATURE_EXTAPIC)) {
-		unsigned int i, v, maxeilvt;
+		unsigned int maxeilvt;
 
-		v = apic_read(APIC_EFEAT);
-		maxeilvt = (v >> 16) & 0xff;
-		seq_printf(seq, " EFEAT\t\t: %08x\n", v);
-		seq_printf(seq, " ECTRL\t\t: %08x\n", apic_read(APIC_ECTRL));
+		for (i = 0; i < ARRAY_SIZE(cpu_xapic); i++)
+			seq_printf(seq, " %s\t\t: %08x\n",  cpu_xapic[i].name,
+				   apic_read(cpu_xapic[i].flag));
 
-		for (i = 0; i < maxeilvt; i++) {
-			v = apic_read(APIC_EILVTn(i));
-			seq_printf(seq, " EILVT%d\t\t: %08x\n", i, v);
-		}
+		maxeilvt = (apic_read(APIC_EFEAT) >> 16) & 0xff;
+		for (i = 0; i < maxeilvt; i++)
+			seq_printf(seq, " EILVT%d\t\t: %08x\n",
+				   i, apic_read(APIC_EILVTn(i)));
 	}
-#endif /* CONFIG_X86_LOCAL_APIC */
-	seq_printf(seq, "\n MSR\t:\n");
+	seq_printf(seq, "\n");
+#endif
+}
+
+static void print_apicval(void *arg)
+{
+	struct seq_file *seq = arg;
+
+#ifdef CONFIG_X86_LOCAL_APIC
+	struct cpu_private *priv = seq->private;
+
+	seq_printf(seq, "0x%x\n", apic_read(priv->reg));
+#endif
 }
 
 static int cpu_seq_show(struct seq_file *seq, void *v)
@@ -404,18 +451,24 @@ static int cpu_seq_show(struct seq_file *seq, void *v)
 		smp_call_function_single(priv->cpu, print_dt, seq, 1);
 		break;
 	case CPU_DEBUG:
-		if (priv->file == CPU_INDEX_BIT)
+		if (priv->file == CPU_INDEX)
 			smp_call_function_single(priv->cpu, print_dr, seq, 1);
-		print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
+		if (priv->cat == CPU_REG_MSR)
+			print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
 		break;
 	case CPU_APIC:
-		if (priv->file == CPU_INDEX_BIT)
+		if (priv->file == CPU_INDEX)
 			smp_call_function_single(priv->cpu, print_apic, seq, 1);
-		print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
+		if (priv->cat == CPU_REG_MSR)
+			print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
+		else if (priv->cat == CPU_REG_APIC)
+			smp_call_function_single(priv->cpu, print_apicval,
+						 seq, 1);
 		break;
 
 	default:
-		print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
+		if (priv->cat == CPU_REG_MSR)
+			print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
 		break;
 	}
 	seq_printf(seq, "\n");
@@ -487,7 +540,7 @@ static int write_cpu_register(struct cpu_private *priv, const char *buf)
 		return ret;
 
 	/* Supporting only MSRs */
-	if (priv->type < CPU_TSS_BIT)
+	if (priv->type < CPU_TSS)
 		return write_msr(priv, val);
 
 	return ret;
@@ -525,12 +578,12 @@ static const struct file_operations cpu_fops = {
 };
 
 static int cpu_create_file(unsigned cpu, unsigned type, unsigned reg,
-			   unsigned file, struct dentry *dentry)
+			   unsigned file, unsigned cat, struct dentry *dentry)
 {
 	struct cpu_private *priv = NULL;
 
 	/* Already intialized */
-	if (file == CPU_INDEX_BIT)
+	if (file == CPU_INDEX)
 		if (per_cpu(cpu_arr[type].init, cpu))
 			return 0;
 
@@ -542,6 +595,7 @@ static int cpu_create_file(unsigned cpu, unsigned type, unsigned reg,
 	priv->type = type;
 	priv->reg = reg;
 	priv->file = file;
+	priv->cat = cat;
 	mutex_lock(&cpu_debug_lock);
 	per_cpu(priv_arr[type], cpu) = priv;
 	per_cpu(cpu_priv_count, cpu)++;
@@ -551,7 +605,7 @@ static int cpu_create_file(unsigned cpu, unsigned type, unsigned reg,
 		debugfs_create_file(cpu_file[file].name, S_IRUGO,
 				    dentry, (void *)priv, &cpu_fops);
 	else {
-		debugfs_create_file(cpu_base[type].name, S_IRUGO,
+		debugfs_create_file(cpu_file[file].name, S_IRUGO,
 				    per_cpu(cpu_arr[type].dentry, cpu),
 				    (void *)priv, &cpu_fops);
 		mutex_lock(&cpu_debug_lock);
@@ -563,13 +617,13 @@ static int cpu_create_file(unsigned cpu, unsigned type, unsigned reg,
 }
 
 static int cpu_init_regfiles(unsigned cpu, unsigned int type, unsigned reg,
-			     struct dentry *dentry)
+			     unsigned cat, struct dentry *dentry)
 {
 	unsigned file;
 	int err = 0;
 
 	for (file = 0; file <  ARRAY_SIZE(cpu_file); file++) {
-		err = cpu_create_file(cpu, type, reg, file, dentry);
+		err = cpu_create_file(cpu, type, reg, file, cat, dentry);
 		if (err)
 			return err;
 	}
@@ -585,8 +639,8 @@ static int cpu_init_msr(unsigned cpu, unsigned type, struct dentry *dentry)
 	char reg_dir[12];
 	u32 low, high;
 
-	for (i = 0; i < ARRAY_SIZE(cpu_reg_range); i++) {
-		if (!get_cpu_range(cpu, &reg_min, &reg_max, i,
+	for (i = 0; i < ARRAY_SIZE(cpu_msr_range); i++) {
+		if (!get_msr_range(cpu, &reg_min, &reg_max, i,
 				   cpu_base[type].flag))
 			continue;
 
@@ -594,9 +648,10 @@ static int cpu_init_msr(unsigned cpu, unsigned type, struct dentry *dentry)
 			if (rdmsr_safe_on_cpu(cpu, reg, &low, &high))
 				continue;
 
-			sprintf(reg_dir, "0x%x", reg);
+			sprintf(reg_dir, "MSR_%x", reg);
 			cpu_dentry = debugfs_create_dir(reg_dir, dentry);
-			err = cpu_init_regfiles(cpu, type, reg, cpu_dentry);
+			err = cpu_init_regfiles(cpu, type, reg, CPU_REG_MSR,
+						cpu_dentry);
 			if (err)
 				return err;
 		}
@@ -605,6 +660,41 @@ static int cpu_init_msr(unsigned cpu, unsigned type, struct dentry *dentry)
 	return err;
 }
 
+static void cpu_init_apic(unsigned cpu, struct dentry *dentry)
+{
+#ifdef CONFIG_X86_LOCAL_APIC
+	struct dentry *cpu_dentry;
+	char reg_dir[16];
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(cpu_apic); i++) {
+		sprintf(reg_dir, "APIC_%s", cpu_apic[i].name);
+		cpu_dentry = debugfs_create_dir(reg_dir, dentry);
+		cpu_create_file(cpu, CPU_APIC, cpu_apic[i].flag, CPU_VALUE,
+				CPU_REG_APIC, cpu_dentry);
+	}
+
+	if (boot_cpu_has(X86_FEATURE_EXTAPIC)) {
+		unsigned int maxeilvt;
+
+		for (i = 0; i < ARRAY_SIZE(cpu_xapic); i++) {
+			sprintf(reg_dir, "APIC_%s", cpu_xapic[i].name);
+			cpu_dentry = debugfs_create_dir(reg_dir, dentry);
+			cpu_create_file(cpu, CPU_APIC, cpu_xapic[i].flag,
+					CPU_VALUE, CPU_REG_APIC, cpu_dentry);
+		}
+
+		maxeilvt = (apic_read(APIC_EFEAT) >> 16) & 0xff;
+		for (i = 0; i < maxeilvt; i++) {
+			sprintf(reg_dir, "APIC_EILVT%d", i);
+			cpu_dentry = debugfs_create_dir(reg_dir, dentry);
+			cpu_create_file(cpu, CPU_APIC, APIC_EILVTn(i),
+					CPU_VALUE, CPU_REG_APIC, cpu_dentry);
+		}
+	}
+#endif
+}
+
 static int cpu_init_allreg(unsigned cpu, struct dentry *dentry)
 {
 	struct dentry *cpu_dentry = NULL;
@@ -617,11 +707,13 @@ static int cpu_init_allreg(unsigned cpu, struct dentry *dentry)
 		cpu_dentry = debugfs_create_dir(cpu_base[type].name, dentry);
 		per_cpu(cpu_arr[type].dentry, cpu) = cpu_dentry;
 
-		if (type < CPU_TSS_BIT)
+		if (type == CPU_APIC)
+			cpu_init_apic(cpu, cpu_dentry);
+		if (type < CPU_TSS)
 			err = cpu_init_msr(cpu, type, cpu_dentry);
 		else
-			err = cpu_create_file(cpu, type, 0, CPU_INDEX_BIT,
-					      cpu_dentry);
+			err = cpu_create_file(cpu, type, 0, CPU_INDEX,
+					      CPU_REG_STD, cpu_dentry);
 		if (err)
 			return err;
 	}
@@ -649,8 +741,8 @@ static int cpu_init_cpu(void)
 		pr_info("cpu%d(%d) debug files %d\n",
 			cpu, nr_cpu_ids, per_cpu(cpu_priv_count, cpu));
 		if (per_cpu(cpu_priv_count, cpu) > MAX_CPU_FILES) {
-			pr_err("Register files count %d exceeds limit %d\n",
-				per_cpu(cpu_priv_count, cpu), MAX_CPU_FILES);
+			WARN_ONCE(1, "debug files count %d exceeds limit %d\n",
+				  per_cpu(cpu_priv_count, cpu), MAX_CPU_FILES);
 			per_cpu(cpu_priv_count, cpu) = MAX_CPU_FILES;
 			err = -ENFILE;
 		}
@@ -683,6 +775,6 @@ static void __exit cpu_debug_exit(void)
 module_init(cpu_debug_init);
 module_exit(cpu_debug_exit);
 
-MODULE_AUTHOR("Jaswinder Singh Rajput");
+MODULE_AUTHOR("Jaswinder Singh Rajput <jaswinder@kernel.org>");
 MODULE_DESCRIPTION("CPU Debug module");
 MODULE_LICENSE("GPL");


