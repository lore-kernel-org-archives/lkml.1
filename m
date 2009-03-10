Return-Path: <linux-kernel-owner+w=401wt.eu-S1757824AbZCJRtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824AbZCJRtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 13:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbZCJRtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 13:49:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:37289 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096AbZCJRtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 13:49:09 -0400
Date: Tue, 10 Mar 2009 17:48:26 GMT
From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu, jaswinderrajput@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, jaswinderrajput@gmail.com, mingo@elte.hu
In-Reply-To: <1236701373.3387.4.camel@localhost.localdomain>
References: <1236701373.3387.4.camel@localhost.localdomain>
Subject: [tip:x86/debug] x86: cpu architecture debug code
Message-ID: <tip-9b779edf4b97798d037bb44fca2719ac184d0f14@git.kernel.org>
Git-Commit-ID: 9b779edf4b97798d037bb44fca2719ac184d0f14
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 10 Mar 2009 17:48:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9b779edf4b97798d037bb44fca2719ac184d0f14
Gitweb:     http://git.kernel.org/tip/9b779edf4b97798d037bb44fca2719ac184d0f14
Author:     "Jaswinder Singh Rajput" <jaswinderrajput@gmail.com>
AuthorDate: Tue, 10 Mar 2009 15:37:51 +0530
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Mar 2009 18:39:45 +0100

x86: cpu architecture debug code

Introduce:

 cat /sys/kernel/debug/x86/cpu/*

for Intel and AMD processors to view / debug the state of each CPU.

By using this we can debug whole range of registers and other
cpu information for debugging purpose and monitor how things
are changing.

This can be useful for developers as well as for users.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
LKML-Reference: <1236701373.3387.4.camel@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/Kconfig                 |    6 +
 arch/x86/include/asm/cpu_debug.h |  193 ++++++++++
 arch/x86/kernel/cpu/Makefile     |    2 +
 arch/x86/kernel/cpu/cpu_debug.c  |  784 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 985 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3175837..03f0a3a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -931,6 +931,12 @@ config X86_CPUID
 	  with major 203 and minors 0 to 31 for /dev/cpu/0/cpuid to
 	  /dev/cpu/31/cpuid.
 
+config X86_CPU_DEBUG
+	tristate "/sys/kernel/debug/x86/cpu/* - CPU Debug support"
+	---help---
+	  If you select this option, this will provide various x86 CPUs
+	  information through debugfs.
+
 choice
 	prompt "High Memory Support"
 	default HIGHMEM4G if !X86_NUMAQ
diff --git a/arch/x86/include/asm/cpu_debug.h b/arch/x86/include/asm/cpu_debug.h
new file mode 100755
index 0000000..d24d64f
--- /dev/null
+++ b/arch/x86/include/asm/cpu_debug.h
@@ -0,0 +1,193 @@
+#ifndef _ASM_X86_CPU_DEBUG_H
+#define _ASM_X86_CPU_DEBUG_H
+
+/*
+ * CPU x86 architecture debug
+ *
+ * Copyright(C) 2009 Jaswinder Singh Rajput
+ */
+
+/* Register flags */
+enum cpu_debug_bit {
+/* Model Specific Registers (MSRs)					*/
+	CPU_MC_BIT,				/* Machine Check	*/
+	CPU_MONITOR_BIT,			/* Monitor		*/
+	CPU_TIME_BIT,				/* Time			*/
+	CPU_PMC_BIT,				/* Performance Monitor	*/
+	CPU_PLATFORM_BIT,			/* Platform		*/
+	CPU_APIC_BIT,				/* APIC			*/
+	CPU_POWERON_BIT,			/* Power-on		*/
+	CPU_CONTROL_BIT,			/* Control		*/
+	CPU_FEATURES_BIT,			/* Features control	*/
+	CPU_LBRANCH_BIT,			/* Last Branch		*/
+	CPU_BIOS_BIT,				/* BIOS			*/
+	CPU_FREQ_BIT,				/* Frequency		*/
+	CPU_MTTR_BIT,				/* MTRR			*/
+	CPU_PERF_BIT,				/* Performance		*/
+	CPU_CACHE_BIT,				/* Cache		*/
+	CPU_SYSENTER_BIT,			/* Sysenter		*/
+	CPU_THERM_BIT,				/* Thermal		*/
+	CPU_MISC_BIT,				/* Miscellaneous	*/
+	CPU_DEBUG_BIT,				/* Debug		*/
+	CPU_PAT_BIT,				/* PAT			*/
+	CPU_VMX_BIT,				/* VMX			*/
+	CPU_CALL_BIT,				/* System Call		*/
+	CPU_BASE_BIT,				/* BASE Address		*/
+	CPU_SMM_BIT,				/* System mgmt mode	*/
+	CPU_SVM_BIT,				/*Secure Virtual Machine*/
+	CPU_OSVM_BIT,				/* OS-Visible Workaround*/
+/* Standard Registers							*/
+	CPU_TSS_BIT,				/* Task Stack Segment	*/
+	CPU_CR_BIT,				/* Control Registers	*/
+	CPU_DT_BIT,				/* Descriptor Table	*/
+/* End of Registers flags						*/
+	CPU_REG_ALL_BIT,			/* Select all Registers	*/
+};
+
+#define	CPU_REG_ALL		(~0)		/* Select all Registers	*/
+
+#define	CPU_MC			(1 << CPU_MC_BIT)
+#define	CPU_MONITOR		(1 << CPU_MONITOR_BIT)
+#define	CPU_TIME		(1 << CPU_TIME_BIT)
+#define	CPU_PMC			(1 << CPU_PMC_BIT)
+#define	CPU_PLATFORM		(1 << CPU_PLATFORM_BIT)
+#define	CPU_APIC		(1 << CPU_APIC_BIT)
+#define	CPU_POWERON		(1 << CPU_POWERON_BIT)
+#define	CPU_CONTROL		(1 << CPU_CONTROL_BIT)
+#define	CPU_FEATURES		(1 << CPU_FEATURES_BIT)
+#define	CPU_LBRANCH		(1 << CPU_LBRANCH_BIT)
+#define	CPU_BIOS		(1 << CPU_BIOS_BIT)
+#define	CPU_FREQ		(1 << CPU_FREQ_BIT)
+#define	CPU_MTRR		(1 << CPU_MTTR_BIT)
+#define	CPU_PERF		(1 << CPU_PERF_BIT)
+#define	CPU_CACHE		(1 << CPU_CACHE_BIT)
+#define	CPU_SYSENTER		(1 << CPU_SYSENTER_BIT)
+#define	CPU_THERM		(1 << CPU_THERM_BIT)
+#define	CPU_MISC		(1 << CPU_MISC_BIT)
+#define	CPU_DEBUG		(1 << CPU_DEBUG_BIT)
+#define	CPU_PAT			(1 << CPU_PAT_BIT)
+#define	CPU_VMX			(1 << CPU_VMX_BIT)
+#define	CPU_CALL		(1 << CPU_CALL_BIT)
+#define	CPU_BASE		(1 << CPU_BASE_BIT)
+#define	CPU_SMM			(1 << CPU_SMM_BIT)
+#define	CPU_SVM			(1 << CPU_SVM_BIT)
+#define	CPU_OSVM		(1 << CPU_OSVM_BIT)
+#define	CPU_TSS			(1 << CPU_TSS_BIT)
+#define	CPU_CR			(1 << CPU_CR_BIT)
+#define	CPU_DT			(1 << CPU_DT_BIT)
+
+/* Register file flags */
+enum cpu_file_bit {
+	CPU_INDEX_BIT,				/* index		*/
+	CPU_VALUE_BIT,				/* value		*/
+};
+
+#define	CPU_FILE_VALUE			(1 << CPU_VALUE_BIT)
+
+/*
+ * DisplayFamily_DisplayModel	Processor Families/Processor Number Series
+ * --------------------------	------------------------------------------
+ * 05_01, 05_02, 05_04		Pentium, Pentium with MMX
+ *
+ * 06_01			Pentium Pro
+ * 06_03, 06_05			Pentium II Xeon, Pentium II
+ * 06_07, 06_08, 06_0A, 06_0B	Pentium III Xeon, Pentum III
+ *
+ * 06_09, 060D			Pentium M
+ *
+ * 06_0E			Core Duo, Core Solo
+ *
+ * 06_0F			Xeon 3000, 3200, 5100, 5300, 7300 series,
+ *				Core 2 Quad, Core 2 Extreme, Core 2 Duo,
+ *				Pentium dual-core
+ * 06_17			Xeon 5200, 5400 series, Core 2 Quad Q9650
+ *
+ * 06_1C			Atom
+ *
+ * 0F_00, 0F_01, 0F_02		Xeon, Xeon MP, Pentium 4
+ * 0F_03, 0F_04			Xeon, Xeon MP, Pentium 4, Pentium D
+ *
+ * 0F_06			Xeon 7100, 5000 Series, Xeon MP,
+ *				Pentium 4, Pentium D
+ */
+
+/* Register processors bits */
+enum cpu_processor_bit {
+	CPU_NONE,
+/* Intel */
+	CPU_INTEL_PENTIUM_BIT,
+	CPU_INTEL_P6_BIT,
+	CPU_INTEL_PENTIUM_M_BIT,
+	CPU_INTEL_CORE_BIT,
+	CPU_INTEL_CORE2_BIT,
+	CPU_INTEL_ATOM_BIT,
+	CPU_INTEL_XEON_P4_BIT,
+	CPU_INTEL_XEON_MP_BIT,
+};
+
+#define	CPU_ALL			(~0)		/* Select all CPUs	*/
+
+#define	CPU_INTEL_PENTIUM	(1 << CPU_INTEL_PENTIUM_BIT)
+#define	CPU_INTEL_P6		(1 << CPU_INTEL_P6_BIT)
+#define	CPU_INTEL_PENTIUM_M	(1 << CPU_INTEL_PENTIUM_M_BIT)
+#define	CPU_INTEL_CORE		(1 << CPU_INTEL_CORE_BIT)
+#define	CPU_INTEL_CORE2		(1 << CPU_INTEL_CORE2_BIT)
+#define	CPU_INTEL_ATOM		(1 << CPU_INTEL_ATOM_BIT)
+#define	CPU_INTEL_XEON_P4	(1 << CPU_INTEL_XEON_P4_BIT)
+#define	CPU_INTEL_XEON_MP	(1 << CPU_INTEL_XEON_MP_BIT)
+
+#define	CPU_INTEL_PX		(CPU_INTEL_P6 | CPU_INTEL_PENTIUM_M)
+#define	CPU_INTEL_COREX		(CPU_INTEL_CORE | CPU_INTEL_CORE2)
+#define	CPU_INTEL_XEON		(CPU_INTEL_XEON_P4 | CPU_INTEL_XEON_MP)
+#define	CPU_CO_AT		(CPU_INTEL_CORE | CPU_INTEL_ATOM)
+#define	CPU_C2_AT		(CPU_INTEL_CORE2 | CPU_INTEL_ATOM)
+#define	CPU_CX_AT		(CPU_INTEL_COREX | CPU_INTEL_ATOM)
+#define	CPU_CX_XE		(CPU_INTEL_COREX | CPU_INTEL_XEON)
+#define	CPU_P6_XE		(CPU_INTEL_P6 | CPU_INTEL_XEON)
+#define	CPU_PM_CO_AT		(CPU_INTEL_PENTIUM_M | CPU_CO_AT)
+#define	CPU_C2_AT_XE		(CPU_C2_AT | CPU_INTEL_XEON)
+#define	CPU_CX_AT_XE		(CPU_CX_AT | CPU_INTEL_XEON)
+#define	CPU_P6_CX_AT		(CPU_INTEL_P6 | CPU_CX_AT)
+#define	CPU_P6_CX_XE		(CPU_P6_XE | CPU_INTEL_COREX)
+#define	CPU_P6_CX_AT_XE		(CPU_INTEL_P6 | CPU_CX_AT_XE)
+#define	CPU_PM_CX_AT_XE		(CPU_INTEL_PENTIUM_M | CPU_CX_AT_XE)
+#define	CPU_PM_CX_AT		(CPU_INTEL_PENTIUM_M | CPU_CX_AT)
+#define	CPU_PM_CX_XE		(CPU_INTEL_PENTIUM_M | CPU_CX_XE)
+#define	CPU_PX_CX_AT		(CPU_INTEL_PX | CPU_CX_AT)
+#define	CPU_PX_CX_AT_XE		(CPU_INTEL_PX | CPU_CX_AT_XE)
+
+/* Select all Intel CPUs*/
+#define	CPU_INTEL_ALL		(CPU_INTEL_PENTIUM | CPU_PX_CX_AT_XE)
+
+#define MAX_CPU_FILES		512
+
+struct cpu_private {
+	unsigned		cpu;
+	unsigned		type;
+	unsigned		reg;
+	unsigned		file;
+};
+
+struct cpu_debug_base {
+	char			*name;		/* Register name	*/
+	unsigned		flag;		/* Register flag	*/
+};
+
+struct cpu_cpuX_base {
+	struct dentry		*dentry;	/* Register dentry	*/
+	int			init;		/* Register index file	*/
+};
+
+struct cpu_file_base {
+	char			*name;		/* Register file name	*/
+	unsigned		flag;		/* Register file flag	*/
+};
+
+struct cpu_debug_range {
+	unsigned		min;		/* Register range min	*/
+	unsigned		max;		/* Register range max	*/
+	unsigned		flag;		/* Supported flags	*/
+	unsigned		model;		/* Supported models	*/
+};
+
+#endif /* _ASM_X86_CPU_DEBUG_H */
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 82db7f4..d4356f8 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -14,6 +14,8 @@ obj-y			+= vmware.o hypervisor.o
 obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
 obj-$(CONFIG_X86_64)	+= bugs_64.o
 
+obj-$(CONFIG_X86_CPU_DEBUG)		+= cpu_debug.o
+
 obj-$(CONFIG_CPU_SUP_INTEL)		+= intel.o
 obj-$(CONFIG_CPU_SUP_AMD)		+= amd.o
 obj-$(CONFIG_CPU_SUP_CYRIX_32)		+= cyrix.o
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
new file mode 100755
index 0000000..0bdf4da
--- /dev/null
+++ b/arch/x86/kernel/cpu/cpu_debug.c
@@ -0,0 +1,784 @@
+/*
+ * CPU x86 architecture debug code
+ *
+ * Copyright(C) 2009 Jaswinder Singh Rajput
+ *
+ * For licencing details see kernel-base/COPYING
+ */
+
+#include <linux/interrupt.h>
+#include <linux/compiler.h>
+#include <linux/seq_file.h>
+#include <linux/debugfs.h>
+#include <linux/kprobes.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/percpu.h>
+#include <linux/signal.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/smp.h>
+
+#include <asm/cpu_debug.h>
+#include <asm/system.h>
+#include <asm/traps.h>
+#include <asm/apic.h>
+#include <asm/desc.h>
+
+static DEFINE_PER_CPU(struct cpu_cpuX_base, cpu_arr[CPU_REG_ALL_BIT]);
+static DEFINE_PER_CPU(struct cpu_private *, priv_arr[MAX_CPU_FILES]);
+static DEFINE_PER_CPU(unsigned, cpu_modelflag);
+static DEFINE_PER_CPU(int, cpu_priv_count);
+static DEFINE_PER_CPU(unsigned, cpu_model);
+
+static DEFINE_MUTEX(cpu_debug_lock);
+
+static struct dentry *cpu_debugfs_dir;
+
+static struct cpu_debug_base cpu_base[] = {
+	{ "mc",		CPU_MC		},	/* Machine Check	*/
+	{ "monitor",	CPU_MONITOR	},	/* Monitor		*/
+	{ "time",	CPU_TIME	},	/* Time			*/
+	{ "pmc",	CPU_PMC		},	/* Performance Monitor	*/
+	{ "platform",	CPU_PLATFORM	},	/* Platform		*/
+	{ "apic",	CPU_APIC	},	/* APIC			*/
+	{ "poweron",	CPU_POWERON	},	/* Power-on		*/
+	{ "control",	CPU_CONTROL	},	/* Control		*/
+	{ "features",	CPU_FEATURES	},	/* Features control	*/
+	{ "lastbranch",	CPU_LBRANCH	},	/* Last Branch		*/
+	{ "bios",	CPU_BIOS	},	/* BIOS			*/
+	{ "freq",	CPU_FREQ	},	/* Frequency		*/
+	{ "mtrr",	CPU_MTRR	},	/* MTRR			*/
+	{ "perf",	CPU_PERF	},	/* Performance		*/
+	{ "cache",	CPU_CACHE	},	/* Cache		*/
+	{ "sysenter",	CPU_SYSENTER	},	/* Sysenter		*/
+	{ "therm",	CPU_THERM	},	/* Thermal		*/
+	{ "misc",	CPU_MISC	},	/* Miscellaneous	*/
+	{ "debug",	CPU_DEBUG	},	/* Debug		*/
+	{ "pat",	CPU_PAT		},	/* PAT			*/
+	{ "vmx",	CPU_VMX		},	/* VMX			*/
+	{ "call",	CPU_CALL	},	/* System Call		*/
+	{ "base",	CPU_BASE	},	/* BASE Address		*/
+	{ "smm",	CPU_SMM		},	/* System mgmt mode	*/
+	{ "svm",	CPU_SVM		},	/*Secure Virtial Machine*/
+	{ "osvm",	CPU_OSVM	},	/* OS-Visible Workaround*/
+	{ "tss",	CPU_TSS		},	/* Task Stack Segment	*/
+	{ "cr",		CPU_CR		},	/* Control Registers	*/
+	{ "dt",		CPU_DT		},	/* Descriptor Table	*/
+	{ "registers",	CPU_REG_ALL	},	/* Select all Registers	*/
+};
+
+static struct cpu_file_base cpu_file[] = {
+	{ "index",	CPU_REG_ALL	},	/* index		*/
+	{ "value",	CPU_REG_ALL	},	/* value		*/
+};
+
+/* Intel Registers Range */
+static struct cpu_debug_range cpu_intel_range[] = {
+	{ 0x00000000, 0x00000001, CPU_MC,	CPU_INTEL_ALL		},
+	{ 0x00000006, 0x00000007, CPU_MONITOR,	CPU_CX_AT_XE		},
+	{ 0x00000010, 0x00000010, CPU_TIME,	CPU_INTEL_ALL		},
+	{ 0x00000011, 0x00000013, CPU_PMC,	CPU_INTEL_PENTIUM	},
+	{ 0x00000017, 0x00000017, CPU_PLATFORM,	CPU_PX_CX_AT_XE		},
+	{ 0x0000001B, 0x0000001B, CPU_APIC,	CPU_P6_CX_AT_XE		},
+
+	{ 0x0000002A, 0x0000002A, CPU_POWERON,	CPU_PX_CX_AT_XE		},
+	{ 0x0000002B, 0x0000002B, CPU_POWERON,	CPU_INTEL_XEON		},
+	{ 0x0000002C, 0x0000002C, CPU_FREQ,	CPU_INTEL_XEON		},
+	{ 0x0000003A, 0x0000003A, CPU_CONTROL,	CPU_CX_AT_XE		},
+
+	{ 0x00000040, 0x00000043, CPU_LBRANCH,	CPU_PM_CX_AT_XE		},
+	{ 0x00000044, 0x00000047, CPU_LBRANCH,	CPU_PM_CO_AT		},
+	{ 0x00000060, 0x00000063, CPU_LBRANCH,	CPU_C2_AT		},
+	{ 0x00000064, 0x00000067, CPU_LBRANCH,	CPU_INTEL_ATOM		},
+
+	{ 0x00000079, 0x00000079, CPU_BIOS,	CPU_P6_CX_AT_XE		},
+	{ 0x00000088, 0x0000008A, CPU_CACHE,	CPU_INTEL_P6		},
+	{ 0x0000008B, 0x0000008B, CPU_BIOS,	CPU_P6_CX_AT_XE		},
+	{ 0x0000009B, 0x0000009B, CPU_MONITOR,	CPU_INTEL_XEON		},
+
+	{ 0x000000C1, 0x000000C2, CPU_PMC,	CPU_P6_CX_AT		},
+	{ 0x000000CD, 0x000000CD, CPU_FREQ,	CPU_CX_AT		},
+	{ 0x000000E7, 0x000000E8, CPU_PERF,	CPU_CX_AT		},
+	{ 0x000000FE, 0x000000FE, CPU_MTRR,	CPU_P6_CX_XE		},
+
+	{ 0x00000116, 0x00000116, CPU_CACHE,	CPU_INTEL_P6		},
+	{ 0x00000118, 0x00000118, CPU_CACHE,	CPU_INTEL_P6		},
+	{ 0x00000119, 0x00000119, CPU_CACHE,	CPU_INTEL_PX		},
+	{ 0x0000011A, 0x0000011B, CPU_CACHE,	CPU_INTEL_P6		},
+	{ 0x0000011E, 0x0000011E, CPU_CACHE,	CPU_PX_CX_AT		},
+
+	{ 0x00000174, 0x00000176, CPU_SYSENTER,	CPU_P6_CX_AT_XE		},
+	{ 0x00000179, 0x0000017A, CPU_MC,	CPU_PX_CX_AT_XE		},
+	{ 0x0000017B, 0x0000017B, CPU_MC,	CPU_P6_XE		},
+	{ 0x00000186, 0x00000187, CPU_PMC,	CPU_P6_CX_AT		},
+	{ 0x00000198, 0x00000199, CPU_PERF,	CPU_PM_CX_AT_XE		},
+	{ 0x0000019A, 0x0000019A, CPU_TIME,	CPU_PM_CX_AT_XE		},
+	{ 0x0000019B, 0x0000019D, CPU_THERM,	CPU_PM_CX_AT_XE		},
+	{ 0x000001A0, 0x000001A0, CPU_MISC,	CPU_PM_CX_AT_XE		},
+
+	{ 0x000001C9, 0x000001C9, CPU_LBRANCH,	CPU_PM_CX_AT		},
+	{ 0x000001D7, 0x000001D8, CPU_LBRANCH,	CPU_INTEL_XEON		},
+	{ 0x000001D9, 0x000001D9, CPU_DEBUG,	CPU_CX_AT_XE		},
+	{ 0x000001DA, 0x000001DA, CPU_LBRANCH,	CPU_INTEL_XEON		},
+	{ 0x000001DB, 0x000001DB, CPU_LBRANCH,	CPU_P6_XE		},
+	{ 0x000001DC, 0x000001DC, CPU_LBRANCH,	CPU_INTEL_P6		},
+	{ 0x000001DD, 0x000001DE, CPU_LBRANCH,	CPU_PX_CX_AT_XE		},
+	{ 0x000001E0, 0x000001E0, CPU_LBRANCH,	CPU_INTEL_P6		},
+
+	{ 0x00000200, 0x0000020F, CPU_MTRR,	CPU_P6_CX_XE		},
+	{ 0x00000250, 0x00000250, CPU_MTRR,	CPU_P6_CX_XE		},
+	{ 0x00000258, 0x00000259, CPU_MTRR,	CPU_P6_CX_XE		},
+	{ 0x00000268, 0x0000026F, CPU_MTRR,	CPU_P6_CX_XE		},
+	{ 0x00000277, 0x00000277, CPU_PAT,	CPU_C2_AT_XE		},
+	{ 0x000002FF, 0x000002FF, CPU_MTRR,	CPU_P6_CX_XE		},
+
+	{ 0x00000300, 0x00000308, CPU_PMC,	CPU_INTEL_XEON		},
+	{ 0x00000309, 0x0000030B, CPU_PMC,	CPU_C2_AT_XE		},
+	{ 0x0000030C, 0x00000311, CPU_PMC,	CPU_INTEL_XEON		},
+	{ 0x00000345, 0x00000345, CPU_PMC,	CPU_C2_AT		},
+	{ 0x00000360, 0x00000371, CPU_PMC,	CPU_INTEL_XEON		},
+	{ 0x0000038D, 0x00000390, CPU_PMC,	CPU_C2_AT		},
+	{ 0x000003A0, 0x000003BE, CPU_PMC,	CPU_INTEL_XEON		},
+	{ 0x000003C0, 0x000003CD, CPU_PMC,	CPU_INTEL_XEON		},
+	{ 0x000003E0, 0x000003E1, CPU_PMC,	CPU_INTEL_XEON		},
+	{ 0x000003F0, 0x000003F0, CPU_PMC,	CPU_INTEL_XEON		},
+	{ 0x000003F1, 0x000003F1, CPU_PMC,	CPU_C2_AT_XE		},
+	{ 0x000003F2, 0x000003F2, CPU_PMC,	CPU_INTEL_XEON		},
+
+	{ 0x00000400, 0x00000402, CPU_MC,	CPU_PM_CX_AT_XE		},
+	{ 0x00000403, 0x00000403, CPU_MC,	CPU_INTEL_XEON		},
+	{ 0x00000404, 0x00000406, CPU_MC,	CPU_PM_CX_AT_XE		},
+	{ 0x00000407, 0x00000407, CPU_MC,	CPU_INTEL_XEON		},
+	{ 0x00000408, 0x0000040A, CPU_MC,	CPU_PM_CX_AT_XE		},
+	{ 0x0000040B, 0x0000040B, CPU_MC,	CPU_INTEL_XEON		},
+	{ 0x0000040C, 0x0000040E, CPU_MC,	CPU_PM_CX_XE		},
+	{ 0x0000040F, 0x0000040F, CPU_MC,	CPU_INTEL_XEON		},
+	{ 0x00000410, 0x00000412, CPU_MC,	CPU_PM_CX_AT_XE		},
+	{ 0x00000413, 0x00000417, CPU_MC,	CPU_CX_AT_XE		},
+	{ 0x00000480, 0x0000048B, CPU_VMX,	CPU_CX_AT_XE		},
+
+	{ 0x00000600, 0x00000600, CPU_DEBUG,	CPU_PM_CX_AT_XE		},
+	{ 0x00000680, 0x0000068F, CPU_LBRANCH,	CPU_INTEL_XEON		},
+	{ 0x000006C0, 0x000006CF, CPU_LBRANCH,	CPU_INTEL_XEON		},
+
+	{ 0x000107CC, 0x000107D3, CPU_PMC,	CPU_INTEL_XEON_MP	},
+
+	{ 0xC0000080, 0xC0000080, CPU_FEATURES,	CPU_INTEL_XEON		},
+	{ 0xC0000081, 0xC0000082, CPU_CALL,	CPU_INTEL_XEON		},
+	{ 0xC0000084, 0xC0000084, CPU_CALL,	CPU_INTEL_XEON		},
+	{ 0xC0000100, 0xC0000102, CPU_BASE,	CPU_INTEL_XEON		},
+};
+
+/* AMD Registers Range */
+static struct cpu_debug_range cpu_amd_range[] = {
+	{ 0x00000010, 0x00000010, CPU_TIME,	CPU_ALL,		},
+	{ 0x0000001B, 0x0000001B, CPU_APIC,	CPU_ALL,		},
+	{ 0x000000FE, 0x000000FE, CPU_MTRR,	CPU_ALL,		},
+
+	{ 0x00000174, 0x00000176, CPU_SYSENTER,	CPU_ALL,		},
+	{ 0x00000179, 0x0000017A, CPU_MC,	CPU_ALL,		},
+	{ 0x0000017B, 0x0000017B, CPU_MC,	CPU_ALL,		},
+	{ 0x000001D9, 0x000001D9, CPU_DEBUG,	CPU_ALL,		},
+	{ 0x000001DB, 0x000001DE, CPU_LBRANCH,	CPU_ALL,		},
+
+	{ 0x00000200, 0x0000020F, CPU_MTRR,	CPU_ALL,		},
+	{ 0x00000250, 0x00000250, CPU_MTRR,	CPU_ALL,		},
+	{ 0x00000258, 0x00000259, CPU_MTRR,	CPU_ALL,		},
+	{ 0x00000268, 0x0000026F, CPU_MTRR,	CPU_ALL,		},
+	{ 0x00000277, 0x00000277, CPU_PAT,	CPU_ALL,		},
+	{ 0x000002FF, 0x000002FF, CPU_MTRR,	CPU_ALL,		},
+
+	{ 0x00000400, 0x00000417, CPU_MC,	CPU_ALL,		},
+
+	{ 0xC0000080, 0xC0000080, CPU_FEATURES,	CPU_ALL,		},
+	{ 0xC0000081, 0xC0000084, CPU_CALL,	CPU_ALL,		},
+	{ 0xC0000100, 0xC0000102, CPU_BASE,	CPU_ALL,		},
+	{ 0xC0000103, 0xC0000103, CPU_TIME,	CPU_ALL,		},
+
+	{ 0xC0000408, 0xC000040A, CPU_MC,	CPU_ALL,		},
+
+	{ 0xc0010000, 0xc0010007, CPU_PMC,	CPU_ALL,		},
+	{ 0xc0010010, 0xc0010010, CPU_MTRR,	CPU_ALL,		},
+	{ 0xc0010016, 0xc001001A, CPU_MTRR,	CPU_ALL,		},
+	{ 0xc001001D, 0xc001001D, CPU_MTRR,	CPU_ALL,		},
+	{ 0xc0010030, 0xc0010035, CPU_BIOS,	CPU_ALL,		},
+	{ 0xc0010056, 0xc0010056, CPU_SMM,	CPU_ALL,		},
+	{ 0xc0010061, 0xc0010063, CPU_SMM,	CPU_ALL,		},
+	{ 0xc0010074, 0xc0010074, CPU_MC,	CPU_ALL,		},
+	{ 0xc0010111, 0xc0010113, CPU_SMM,	CPU_ALL,		},
+	{ 0xc0010114, 0xc0010118, CPU_SVM,	CPU_ALL,		},
+	{ 0xc0010119, 0xc001011A, CPU_SMM,	CPU_ALL,		},
+	{ 0xc0010140, 0xc0010141, CPU_OSVM,	CPU_ALL,		},
+	{ 0xc0010156, 0xc0010156, CPU_SMM,	CPU_ALL,		},
+};
+
+
+static int get_cpu_modelflag(unsigned cpu)
+{
+	int flag;
+
+	switch (per_cpu(cpu_model, cpu)) {
+	/* Intel */
+	case 0x0501:
+	case 0x0502:
+	case 0x0504:
+		flag = CPU_INTEL_PENTIUM;
+		break;
+	case 0x0601:
+	case 0x0603:
+	case 0x0605:
+	case 0x0607:
+	case 0x0608:
+	case 0x060A:
+	case 0x060B:
+		flag = CPU_INTEL_P6;
+		break;
+	case 0x0609:
+	case 0x060D:
+		flag = CPU_INTEL_PENTIUM_M;
+		break;
+	case 0x060E:
+		flag = CPU_INTEL_CORE;
+		break;
+	case 0x060F:
+	case 0x0617:
+		flag = CPU_INTEL_CORE2;
+		break;
+	case 0x061C:
+		flag = CPU_INTEL_ATOM;
+		break;
+	case 0x0F00:
+	case 0x0F01:
+	case 0x0F02:
+	case 0x0F03:
+	case 0x0F04:
+		flag = CPU_INTEL_XEON_P4;
+		break;
+	case 0x0F06:
+		flag = CPU_INTEL_XEON_MP;
+		break;
+	default:
+		flag = CPU_NONE;
+		break;
+	}
+
+	return flag;
+}
+
+static int get_cpu_range_count(unsigned cpu)
+{
+	int index;
+
+	switch (per_cpu(cpu_model, cpu) >> 16) {
+	case X86_VENDOR_INTEL:
+		index = ARRAY_SIZE(cpu_intel_range);
+		break;
+	case X86_VENDOR_AMD:
+		index = ARRAY_SIZE(cpu_amd_range);
+		break;
+	default:
+		index = 0;
+		break;
+	}
+
+	return index;
+}
+
+static int is_typeflag_valid(unsigned cpu, unsigned flag)
+{
+	unsigned vendor, modelflag;
+	int i, index;
+
+	/* Standard Registers should be always valid */
+	if (flag >= CPU_TSS)
+		return 1;
+
+	modelflag = per_cpu(cpu_modelflag, cpu);
+	vendor = per_cpu(cpu_model, cpu) >> 16;
+	index = get_cpu_range_count(cpu);
+
+	for (i = 0; i < index; i++) {
+		switch (vendor) {
+		case X86_VENDOR_INTEL:
+			if ((cpu_intel_range[i].model & modelflag) &&
+			    (cpu_intel_range[i].flag & flag))
+				return 1;
+			break;
+		case X86_VENDOR_AMD:
+			if (cpu_amd_range[i].flag & flag)
+				return 1;
+			break;
+		}
+	}
+
+	/* Invalid */
+	return 0;
+}
+
+static unsigned get_cpu_range(unsigned cpu, unsigned *min, unsigned *max,
+			      int index, unsigned flag)
+{
+	unsigned modelflag;
+
+	modelflag = per_cpu(cpu_modelflag, cpu);
+	*max = 0;
+	switch (per_cpu(cpu_model, cpu) >> 16) {
+	case X86_VENDOR_INTEL:
+		if ((cpu_intel_range[index].model & modelflag) &&
+		    (cpu_intel_range[index].flag & flag)) {
+			*min = cpu_intel_range[index].min;
+			*max = cpu_intel_range[index].max;
+		}
+		break;
+	case X86_VENDOR_AMD:
+		if (cpu_amd_range[index].flag & flag) {
+			*min = cpu_amd_range[index].min;
+			*max = cpu_amd_range[index].max;
+		}
+		break;
+	}
+
+	return *max;
+}
+
+/* This function can also be called with seq = NULL for printk */
+static void print_cpu_data(struct seq_file *seq, unsigned type,
+			   u32 low, u32 high)
+{
+	struct cpu_private *priv;
+	u64 val = high;
+
+	if (seq) {
+		priv = seq->private;
+		if (priv->file) {
+			val = (val << 32) | low;
+			seq_printf(seq, "0x%llx\n", val);
+		} else
+			seq_printf(seq, " %08x: %08x_%08x\n",
+				   type, high, low);
+	} else
+		printk(KERN_INFO " %08x: %08x_%08x\n", type, high, low);
+}
+
+/* This function can also be called with seq = NULL for printk */
+static void print_msr(struct seq_file *seq, unsigned cpu, unsigned flag)
+{
+	unsigned msr, msr_min, msr_max;
+	struct cpu_private *priv;
+	u32 low, high;
+	int i, range;
+
+	if (seq) {
+		priv = seq->private;
+		if (priv->file) {
+			if (!rdmsr_safe_on_cpu(priv->cpu, priv->reg,
+					       &low, &high))
+				print_cpu_data(seq, priv->reg, low, high);
+			return;
+		}
+	}
+
+	range = get_cpu_range_count(cpu);
+
+	for (i = 0; i < range; i++) {
+		if (!get_cpu_range(cpu, &msr_min, &msr_max, i, flag))
+			continue;
+
+		for (msr = msr_min; msr <= msr_max; msr++) {
+			if (rdmsr_safe_on_cpu(cpu, msr, &low, &high))
+				continue;
+			print_cpu_data(seq, msr, low, high);
+		}
+	}
+}
+
+static void print_tss(void *arg)
+{
+	struct pt_regs *regs = task_pt_regs(current);
+	struct seq_file *seq = arg;
+	unsigned int seg;
+
+	seq_printf(seq, " RAX\t: %016lx\n", regs->ax);
+	seq_printf(seq, " RBX\t: %016lx\n", regs->bx);
+	seq_printf(seq, " RCX\t: %016lx\n", regs->cx);
+	seq_printf(seq, " RDX\t: %016lx\n", regs->dx);
+
+	seq_printf(seq, " RSI\t: %016lx\n", regs->si);
+	seq_printf(seq, " RDI\t: %016lx\n", regs->di);
+	seq_printf(seq, " RBP\t: %016lx\n", regs->bp);
+	seq_printf(seq, " ESP\t: %016lx\n", regs->sp);
+
+#ifdef CONFIG_X86_64
+	seq_printf(seq, " R08\t: %016lx\n", regs->r8);
+	seq_printf(seq, " R09\t: %016lx\n", regs->r9);
+	seq_printf(seq, " R10\t: %016lx\n", regs->r10);
+	seq_printf(seq, " R11\t: %016lx\n", regs->r11);
+	seq_printf(seq, " R12\t: %016lx\n", regs->r12);
+	seq_printf(seq, " R13\t: %016lx\n", regs->r13);
+	seq_printf(seq, " R14\t: %016lx\n", regs->r14);
+	seq_printf(seq, " R15\t: %016lx\n", regs->r15);
+#endif
+
+	asm("movl %%cs,%0" : "=r" (seg));
+	seq_printf(seq, " CS\t:             %04x\n", seg);
+	asm("movl %%ds,%0" : "=r" (seg));
+	seq_printf(seq, " DS\t:             %04x\n", seg);
+	seq_printf(seq, " SS\t:             %04lx\n", regs->ss);
+	asm("movl %%es,%0" : "=r" (seg));
+	seq_printf(seq, " ES\t:             %04x\n", seg);
+	asm("movl %%fs,%0" : "=r" (seg));
+	seq_printf(seq, " FS\t:             %04x\n", seg);
+	asm("movl %%gs,%0" : "=r" (seg));
+	seq_printf(seq, " GS\t:             %04x\n", seg);
+
+	seq_printf(seq, " EFLAGS\t: %016lx\n", regs->flags);
+
+	seq_printf(seq, " EIP\t: %016lx\n", regs->ip);
+}
+
+static void print_cr(void *arg)
+{
+	struct seq_file *seq = arg;
+
+	seq_printf(seq, " cr0\t: %016lx\n", read_cr0());
+	seq_printf(seq, " cr2\t: %016lx\n", read_cr2());
+	seq_printf(seq, " cr3\t: %016lx\n", read_cr3());
+	seq_printf(seq, " cr4\t: %016lx\n", read_cr4_safe());
+#ifdef CONFIG_X86_64
+	seq_printf(seq, " cr8\t: %016lx\n", read_cr8());
+#endif
+}
+
+static void print_desc_ptr(char *str, struct seq_file *seq, struct desc_ptr dt)
+{
+	seq_printf(seq, " %s\t: %016llx\n", str, (u64)(dt.address | dt.size));
+}
+
+static void print_dt(void *seq)
+{
+	struct desc_ptr dt;
+	unsigned long ldt;
+
+	/* IDT */
+	store_idt((struct desc_ptr *)&dt);
+	print_desc_ptr("IDT", seq, dt);
+
+	/* GDT */
+	store_gdt((struct desc_ptr *)&dt);
+	print_desc_ptr("GDT", seq, dt);
+
+	/* LDT */
+	store_ldt(ldt);
+	seq_printf(seq, " LDT\t: %016lx\n", ldt);
+
+	/* TR */
+	store_tr(ldt);
+	seq_printf(seq, " TR\t: %016lx\n", ldt);
+}
+
+static void print_dr(void *arg)
+{
+	struct seq_file *seq = arg;
+	unsigned long dr;
+	int i;
+
+	for (i = 0; i < 8; i++) {
+		/* Ignore db4, db5 */
+		if ((i == 4) || (i == 5))
+			continue;
+		get_debugreg(dr, i);
+		seq_printf(seq, " dr%d\t: %016lx\n", i, dr);
+	}
+
+	seq_printf(seq, "\n MSR\t:\n");
+}
+
+static void print_apic(void *arg)
+{
+	struct seq_file *seq = arg;
+
+#ifdef CONFIG_X86_LOCAL_APIC
+	seq_printf(seq, " LAPIC\t:\n");
+	seq_printf(seq, " ID\t\t: %08x\n",  apic_read(APIC_ID) >> 24);
+	seq_printf(seq, " LVR\t\t: %08x\n",  apic_read(APIC_LVR));
+	seq_printf(seq, " TASKPRI\t: %08x\n",  apic_read(APIC_TASKPRI));
+	seq_printf(seq, " ARBPRI\t\t: %08x\n",  apic_read(APIC_ARBPRI));
+	seq_printf(seq, " PROCPRI\t: %08x\n",  apic_read(APIC_PROCPRI));
+	seq_printf(seq, " LDR\t\t: %08x\n",  apic_read(APIC_LDR));
+	seq_printf(seq, " DFR\t\t: %08x\n",  apic_read(APIC_DFR));
+	seq_printf(seq, " SPIV\t\t: %08x\n",  apic_read(APIC_SPIV));
+	seq_printf(seq, " ISR\t\t: %08x\n",  apic_read(APIC_ISR));
+	seq_printf(seq, " ESR\t\t: %08x\n",  apic_read(APIC_ESR));
+	seq_printf(seq, " ICR\t\t: %08x\n",  apic_read(APIC_ICR));
+	seq_printf(seq, " ICR2\t\t: %08x\n",  apic_read(APIC_ICR2));
+	seq_printf(seq, " LVTT\t\t: %08x\n",  apic_read(APIC_LVTT));
+	seq_printf(seq, " LVTTHMR\t: %08x\n",  apic_read(APIC_LVTTHMR));
+	seq_printf(seq, " LVTPC\t\t: %08x\n",  apic_read(APIC_LVTPC));
+	seq_printf(seq, " LVT0\t\t: %08x\n",  apic_read(APIC_LVT0));
+	seq_printf(seq, " LVT1\t\t: %08x\n",  apic_read(APIC_LVT1));
+	seq_printf(seq, " LVTERR\t\t: %08x\n",  apic_read(APIC_LVTERR));
+	seq_printf(seq, " TMICT\t\t: %08x\n",  apic_read(APIC_TMICT));
+	seq_printf(seq, " TMCCT\t\t: %08x\n",  apic_read(APIC_TMCCT));
+	seq_printf(seq, " TDCR\t\t: %08x\n",  apic_read(APIC_TDCR));
+#endif /* CONFIG_X86_LOCAL_APIC */
+
+	seq_printf(seq, "\n MSR\t:\n");
+}
+
+static int cpu_seq_show(struct seq_file *seq, void *v)
+{
+	struct cpu_private *priv = seq->private;
+
+	if (priv == NULL)
+		return -EINVAL;
+
+	switch (cpu_base[priv->type].flag) {
+	case CPU_TSS:
+		smp_call_function_single(priv->cpu, print_tss, seq, 1);
+		break;
+	case CPU_CR:
+		smp_call_function_single(priv->cpu, print_cr, seq, 1);
+		break;
+	case CPU_DT:
+		smp_call_function_single(priv->cpu, print_dt, seq, 1);
+		break;
+	case CPU_DEBUG:
+		if (priv->file == CPU_INDEX_BIT)
+			smp_call_function_single(priv->cpu, print_dr, seq, 1);
+		print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
+		break;
+	case CPU_APIC:
+		if (priv->file == CPU_INDEX_BIT)
+			smp_call_function_single(priv->cpu, print_apic, seq, 1);
+		print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
+		break;
+
+	default:
+		print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
+		break;
+	}
+	seq_printf(seq, "\n");
+
+	return 0;
+}
+
+static void *cpu_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	if (*pos == 0) /* One time is enough ;-) */
+		return seq;
+
+	return NULL;
+}
+
+static void *cpu_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	(*pos)++;
+
+	return cpu_seq_start(seq, pos);
+}
+
+static void cpu_seq_stop(struct seq_file *seq, void *v)
+{
+}
+
+static const struct seq_operations cpu_seq_ops = {
+	.start		= cpu_seq_start,
+	.next		= cpu_seq_next,
+	.stop		= cpu_seq_stop,
+	.show		= cpu_seq_show,
+};
+
+static int cpu_seq_open(struct inode *inode, struct file *file)
+{
+	struct cpu_private *priv = inode->i_private;
+	struct seq_file *seq;
+	int err;
+
+	err = seq_open(file, &cpu_seq_ops);
+	if (!err) {
+		seq = file->private_data;
+		seq->private = priv;
+	}
+
+	return err;
+}
+
+static const struct file_operations cpu_fops = {
+	.open		= cpu_seq_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+static int cpu_create_file(unsigned cpu, unsigned type, unsigned reg,
+			   unsigned file, struct dentry *dentry)
+{
+	struct cpu_private *priv = NULL;
+
+	/* Already intialized */
+	if (file == CPU_INDEX_BIT)
+		if (per_cpu(cpu_arr[type].init, cpu))
+			return 0;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (priv == NULL)
+		return -ENOMEM;
+
+	priv->cpu = cpu;
+	priv->type = type;
+	priv->reg = reg;
+	priv->file = file;
+	mutex_lock(&cpu_debug_lock);
+	per_cpu(priv_arr[type], cpu) = priv;
+	per_cpu(cpu_priv_count, cpu)++;
+	mutex_unlock(&cpu_debug_lock);
+
+	if (file)
+		debugfs_create_file(cpu_file[file].name, S_IRUGO,
+				    dentry, (void *)priv, &cpu_fops);
+	else {
+		debugfs_create_file(cpu_base[type].name, S_IRUGO,
+				    per_cpu(cpu_arr[type].dentry, cpu),
+				    (void *)priv, &cpu_fops);
+		mutex_lock(&cpu_debug_lock);
+		per_cpu(cpu_arr[type].init, cpu) = 1;
+		mutex_unlock(&cpu_debug_lock);
+	}
+
+	return 0;
+}
+
+static int cpu_init_regfiles(unsigned cpu, unsigned int type, unsigned reg,
+			     struct dentry *dentry)
+{
+	unsigned file;
+	int err = 0;
+
+	for (file = 0; file <  ARRAY_SIZE(cpu_file); file++) {
+		err = cpu_create_file(cpu, type, reg, file, dentry);
+		if (err)
+			return err;
+	}
+
+	return err;
+}
+
+static int cpu_init_msr(unsigned cpu, unsigned type, struct dentry *dentry)
+{
+	struct dentry *cpu_dentry = NULL;
+	unsigned reg, reg_min, reg_max;
+	int i, range, err = 0;
+	char reg_dir[12];
+	u32 low, high;
+
+	range = get_cpu_range_count(cpu);
+
+	for (i = 0; i < range; i++) {
+		if (!get_cpu_range(cpu, &reg_min, &reg_max, i,
+				   cpu_base[type].flag))
+			continue;
+
+		for (reg = reg_min; reg <= reg_max; reg++) {
+			if (rdmsr_safe_on_cpu(cpu, reg, &low, &high))
+				continue;
+
+			sprintf(reg_dir, "0x%x", reg);
+			cpu_dentry = debugfs_create_dir(reg_dir, dentry);
+			err = cpu_init_regfiles(cpu, type, reg, cpu_dentry);
+			if (err)
+				return err;
+		}
+	}
+
+	return err;
+}
+
+static int cpu_init_allreg(unsigned cpu, struct dentry *dentry)
+{
+	struct dentry *cpu_dentry = NULL;
+	unsigned type;
+	int err = 0;
+
+	for (type = 0; type <  ARRAY_SIZE(cpu_base) - 1; type++) {
+		if (!is_typeflag_valid(cpu, cpu_base[type].flag))
+			continue;
+		cpu_dentry = debugfs_create_dir(cpu_base[type].name, dentry);
+		per_cpu(cpu_arr[type].dentry, cpu) = cpu_dentry;
+
+		if (type < CPU_TSS_BIT)
+			err = cpu_init_msr(cpu, type, cpu_dentry);
+		else
+			err = cpu_create_file(cpu, type, 0, CPU_INDEX_BIT,
+					      cpu_dentry);
+		if (err)
+			return err;
+	}
+
+	return err;
+}
+
+static int cpu_init_cpu(void)
+{
+	struct dentry *cpu_dentry = NULL;
+	struct cpuinfo_x86 *cpui;
+	char cpu_dir[12];
+	unsigned cpu;
+	int err = 0;
+
+	for (cpu = 0; cpu < nr_cpu_ids; cpu++) {
+		cpui = &cpu_data(cpu);
+		if (!cpu_has(cpui, X86_FEATURE_MSR))
+			continue;
+		per_cpu(cpu_model, cpu) = ((cpui->x86_vendor << 16) |
+					   (cpui->x86 << 8) |
+					   (cpui->x86_model));
+		per_cpu(cpu_modelflag, cpu) = get_cpu_modelflag(cpu);
+
+		sprintf(cpu_dir, "cpu%d", cpu);
+		cpu_dentry = debugfs_create_dir(cpu_dir, cpu_debugfs_dir);
+		err = cpu_init_allreg(cpu, cpu_dentry);
+
+		pr_info("cpu%d(%d) debug files %d\n",
+			cpu, nr_cpu_ids, per_cpu(cpu_priv_count, cpu));
+		if (per_cpu(cpu_priv_count, cpu) > MAX_CPU_FILES) {
+			pr_err("Register files count %d exceeds limit %d\n",
+				per_cpu(cpu_priv_count, cpu), MAX_CPU_FILES);
+			per_cpu(cpu_priv_count, cpu) = MAX_CPU_FILES;
+			err = -ENFILE;
+		}
+		if (err)
+			return err;
+	}
+
+	return err;
+}
+
+static int __init cpu_debug_init(void)
+{
+	cpu_debugfs_dir = debugfs_create_dir("cpu", arch_debugfs_dir);
+
+	return cpu_init_cpu();
+}
+
+static void __exit cpu_debug_exit(void)
+{
+	int i, cpu;
+
+	if (cpu_debugfs_dir)
+		debugfs_remove_recursive(cpu_debugfs_dir);
+
+	for (cpu = 0; cpu <  nr_cpu_ids; cpu++)
+		for (i = 0; i < per_cpu(cpu_priv_count, cpu); i++)
+			kfree(per_cpu(priv_arr[i], cpu));
+}
+
+module_init(cpu_debug_init);
+module_exit(cpu_debug_exit);
+
+MODULE_AUTHOR("Jaswinder Singh Rajput");
+MODULE_DESCRIPTION("CPU Debug module");
+MODULE_LICENSE("GPL");
