Return-Path: <linux-kernel-owner+w=401wt.eu-S1754439AbZFHH5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439AbZFHH5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 03:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbZFHH5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 03:57:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:59632 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbZFHH5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 03:57:05 -0400
Subject: [GIT-PULL -tip] x86: xpu_debug patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 08 Jun 2009 13:28:01 +0530
Message-Id: <1244447882.6943.2.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull cpu_debug patches :

The following changes since commit 5095f59bda6793a7b8f0856096d6893fe98e0e51:
  Jaswinder Singh Rajput (1):
        x86: cpu_debug: Remove model information to reduce encoding-decoding

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-cpu.git x86/cpu

Jaswinder Singh Rajput (5):
      x86: cpu_debug update Kconfig entry
      x86: cpu_debug.c remove some not required header files
      x86: cpu_debug.c use a WARN_ONCE() instead of a pr_err()
      x86: cpu_debug make room to support more categories
      x86: cpu_debug update MSR list to support new architectures

 arch/x86/Kconfig                 |   12 ++++-
 arch/x86/include/asm/cpu_debug.h |  102 +++++++++++++-------------------------
 arch/x86/kernel/cpu/cpu_debug.c  |   45 +++++++++-------
 3 files changed, 70 insertions(+), 89 deletions(-)

Complete diff:

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a6efe0a..cd2debd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -955,9 +955,19 @@ config X86_CPUID
 
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
index d96c1ee..da5c221 100644
--- a/arch/x86/include/asm/cpu_debug.h
+++ b/arch/x86/include/asm/cpu_debug.h
@@ -10,84 +10,50 @@
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
-
 #define MAX_CPU_FILES		512
 
 struct cpu_private {
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
index 86afe13..943dae8 100644
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
 
@@ -95,6 +90,7 @@ static struct cpu_debug_range cpu_reg_range[] = {
 	{ 0x00000088, 0x0000008A, CPU_CACHE,	},
 	{ 0x0000008B, 0x0000008B, CPU_BIOS,	},
 	{ 0x0000009B, 0x0000009B, CPU_MONITOR,	},
+	{ 0x000000A0, 0x000000A1, CPU_SMM,	},
 	{ 0x000000C1, 0x000000C4, CPU_PMC,	},
 	{ 0x000000CD, 0x000000CD, CPU_FREQ,	},
 	{ 0x000000E7, 0x000000E8, CPU_PERF,	},
@@ -103,40 +99,49 @@ static struct cpu_debug_range cpu_reg_range[] = {
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
@@ -392,12 +397,12 @@ static int cpu_seq_show(struct seq_file *seq, void *v)
 		smp_call_function_single(priv->cpu, print_dt, seq, 1);
 		break;
 	case CPU_DEBUG:
-		if (priv->file == CPU_INDEX_BIT)
+		if (priv->file == CPU_INDEX)
 			smp_call_function_single(priv->cpu, print_dr, seq, 1);
 		print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
 		break;
 	case CPU_APIC:
-		if (priv->file == CPU_INDEX_BIT)
+		if (priv->file == CPU_INDEX)
 			smp_call_function_single(priv->cpu, print_apic, seq, 1);
 		print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
 		break;
@@ -475,7 +480,7 @@ static int write_cpu_register(struct cpu_private *priv, const char *buf)
 		return ret;
 
 	/* Supporting only MSRs */
-	if (priv->type < CPU_TSS_BIT)
+	if (priv->type < CPU_TSS)
 		return write_msr(priv, val);
 
 	return ret;
@@ -518,7 +523,7 @@ static int cpu_create_file(unsigned cpu, unsigned type, unsigned reg,
 	struct cpu_private *priv = NULL;
 
 	/* Already intialized */
-	if (file == CPU_INDEX_BIT)
+	if (file == CPU_INDEX)
 		if (per_cpu(cpu_arr[type].init, cpu))
 			return 0;
 
@@ -605,10 +610,10 @@ static int cpu_init_allreg(unsigned cpu, struct dentry *dentry)
 		cpu_dentry = debugfs_create_dir(cpu_base[type].name, dentry);
 		per_cpu(cpu_arr[type].dentry, cpu) = cpu_dentry;
 
-		if (type < CPU_TSS_BIT)
+		if (type < CPU_TSS)
 			err = cpu_init_msr(cpu, type, cpu_dentry);
 		else
-			err = cpu_create_file(cpu, type, 0, CPU_INDEX_BIT,
+			err = cpu_create_file(cpu, type, 0, CPU_INDEX,
 					      cpu_dentry);
 		if (err)
 			return err;
@@ -637,8 +642,8 @@ static int cpu_init_cpu(void)
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
@@ -671,6 +676,6 @@ static void __exit cpu_debug_exit(void)
 module_init(cpu_debug_init);
 module_exit(cpu_debug_exit);
 
-MODULE_AUTHOR("Jaswinder Singh Rajput");
+MODULE_AUTHOR("Jaswinder Singh Rajput <jaswinder@kernel.org>");
 MODULE_DESCRIPTION("CPU Debug module");
 MODULE_LICENSE("GPL");


