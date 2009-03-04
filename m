Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbZCDTRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbZCDTRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 14:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077AbZCDTQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 14:16:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:59696 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603AbZCDTQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 14:16:58 -0500
Subject: Re: [git-pull -tip] x86: msr architecture debug code
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090302205437.GB14471@elte.hu>
References: <1236008575.3332.2.camel@localhost.localdomain>
	 <20090302205437.GB14471@elte.hu>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 00:46:23 +0530
Message-Id: <1236194183.4994.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 21:54 +0100, Ingo Molnar wrote:


> Please vertical-align structure field definitions, like you see 
> we do it elsewhere in the x86 code.
> 

done.

> > +
> > +#include <linux/module.h>
> > +#include <linux/kernel.h>
> > +#include <linux/debugfs.h>
> > +#include <linux/seq_file.h>
> > +#include <asm/msr_debug.h>
> 
> Please have a good look at what the standard include files 
> section look like - for example in 
> arch/x86/kernel/cpu/perf_counter.c or in arch/x86/mm/fault.c. 
> Please use that same ordering of the lines here too.
> 

hmm, currently for my file these header files are more than enough, when
I will keep on add more stuff then header count will also increase and I
will do ordering.

> > +static int get_msr_intel_bit(unsigned model)
> > +{
> > +	int ret = 0;
> > +
> > +	switch (model) {
> > +	case 0x0501:
> > +	case 0x0502:
> > +	case 0x0504:
> > +		ret = MSR_INTEL_PENTIUM;
> > +		break;
> > +	case 0x0601:
> > +	case 0x0603:
> > +	case 0x0605:
> > +	case 0x0607:
> > +	case 0x0608:
> > +	case 0x060A:
> > +	case 0x060B:
> > +		ret = MSR_INTEL_P6;
> > +		break;
> > +	case 0x0609:
> > +	case 0x060D:
> > +		ret = MSR_INTEL_PENTIUM_M;
> > +		break;
> > +	case 0x060E:
> > +		ret = MSR_INTEL_CORE;
> > +		break;
> > +	case 0x060F:
> > +	case 0x0617:
> > +		ret = MSR_INTEL_CORE_2;
> > +		break;
> > +	case 0x061C:
> > +		ret = MSR_INTEL_ATOM;
> > +		break;
> > +	case 0x0F00:
> > +	case 0x0F01:
> > +	case 0x0F02:
> > +	case 0x0F03:
> > +	case 0x0F04:
> > +		ret = MSR_INTEL_XEON;
> > +		break;
> > +	case 0x0F06:
> > +		ret = MSR_INTEL_XEON_MP;
> > +		break;
> > +	}
> 
> all these magic constants open-coded look a bit ugly. Can it be 
> done cleaner?
> 

Then I need to do if-else and then it will become more ugly and every
time we need to add more magic numbers, it will also effect others.


> Check how structure initializations are done in other places of 
> the x86 tree - for example perf_counters.c. Apply that style 
> here too please.
> 

I have made some changes. Please check is it OK.

> > +
> > +static struct dentry *msr_file, *pmc_file, *msr_dir;
> > +static int __init msr_debug_init(void)
> 
> missing newline after static variables.
> 
Done :-)

> > +{
> > +	struct cpuinfo_x86 *cpu = &cpu_data(0);
> > +
> > +	if (!cpu_has(cpu, X86_FEATURE_MSR))
> > +		return -ENODEV;
> > +
> > +	msr_dir = debugfs_create_dir("msr", arch_debugfs_dir);
> > +
> > +	msr_file = debugfs_create_file("msr", S_IRUGO, msr_dir,
> > +					NULL, &msr_fops);
> > +	pmc_file = debugfs_create_file("pmc", S_IRUGO, msr_dir,
> > +					NULL, &pmc_fops);
> 
> I think it would be possible to have a much more intuitive file 
> layout under /debug/x86/msr/ than these two /debug/x86/msr/msr 
> and /debug/x86/msr/pmc files.
> 
> Firstly, it should move one level deeper, to /debug/x86/cpu/msr/ 
> - because the MSR is really a property of the CPU, and there are 
> other properties of the CPU we might want to expose in the 
> future.
> 

Done.

> Regarding the msr directory: one good approach would be to have 
> have several "topic" directories under /debug/x86/cpu/msr/.
> 
> One such topic would be the 'pmu', with a structure like:
> 
>  /debug/x86/cpu/msr/pmu/
>  /debug/x86/cpu/msr/pmu/pmc_0/
>  /debug/x86/cpu/msr/pmu/pmc_0/counter
>  /debug/x86/cpu/msr/pmu/pmc_0/eventsel
> 
> There would also be a /debug/x86/cpu/msr/raw/ directory with all 
> MSR numbers we know about explicitly, for example:
> 
>  /debug/x86/cpu/msr/raw/0x372/value
>  /debug/x86/cpu/msr/raw/0x372/width
> 
> Maybe a symlink pointing it back to the topic directory would be 
> useful as well. For example:
> 
>  /debug/x86/cpu/msr/raw/0x372/topic_dir -> /debug/x86/cpu/msr/pmu/pmc_0/
> 

OK I like this, and I will do in next phase.

> Other "topic directories" are possible too: a 
> /debug/x86/cpu/msr/apic/ layout would be very useful and 
> informative as well, and so are some of the other MSRs we tweak 
> during bootup.
> 

Done.

Here is new request pull:

The following changes since commit 1d10914bf2c8a1164aef6c341e6c3518a91b8374:
  Ingo Molnar (1):
        Merge branch 'core/percpu'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip-cpu.git master

Jaswinder Singh Rajput (1):
      x86: msr architecture debug code

 arch/x86/include/asm/msr_debug.h |  163 ++++++++++++++
 arch/x86/kernel/cpu/Makefile     |    2 +-
 arch/x86/kernel/cpu/msr_debug.c  |  461 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/kdebugfs.c       |    7 +
 4 files changed, 632 insertions(+), 1 deletions(-)
 create mode 100755 arch/x86/include/asm/msr_debug.h
 create mode 100755 arch/x86/kernel/cpu/msr_debug.c

diff --git a/arch/x86/include/asm/msr_debug.h b/arch/x86/include/asm/msr_debug.h
new file mode 100755
index 0000000..fd03923
--- /dev/null
+++ b/arch/x86/include/asm/msr_debug.h
@@ -0,0 +1,163 @@
+#ifndef _ASM_X86_MSR_DEBUG_H
+#define _ASM_X86_MSR_DEBUG_H
+
+/*
+ * Model Specific Registers (MSR) x86 architecture debug
+ *
+ * Copyright(C) 2009 Jaswinder Singh Rajput
+ */
+
+enum msr_debug_bit {
+	MSR_MC_BIT,				/* Machine Check	*/
+	MSR_MONITOR_BIT,			/* Monitor		*/
+	MSR_TIME_BIT,				/* Time			*/
+	MSR_PMC_BIT,				/* Performance Monitor	*/
+	MSR_PLATFORM_BIT,			/* Platform		*/
+	MSR_APIC_BIT,				/* APIC			*/
+	MSR_POWERON_BIT,			/* Power-on		*/
+	MSR_CONTROL_BIT,			/* Control		*/
+	MSR_FEATURES_BIT,			/* Features control	*/
+	MSR_LBRANCH_BIT,			/* Last Branch		*/
+	MSR_BIOS_BIT,				/* BIOS			*/
+	MSR_FREQ_BIT,				/* Frequency		*/
+	MSR_MTTR_BIT,				/* MTRR			*/
+	MSR_PERF_BIT,				/* Performance		*/
+	MSR_CACHE_BIT,				/* Cache		*/
+	MSR_SYSENTER_BIT,			/* Sysenter		*/
+	MSR_THERM_BIT,				/* Thermal		*/
+	MSR_MISC_BIT,				/* Miscellaneous	*/
+	MSR_DEBUG_BIT,				/* Debug		*/
+	MSR_PAT_BIT,				/* PAT			*/
+	MSR_VMX_BIT,				/* VMX			*/
+	MSR_CALL_BIT,				/* System Call		*/
+	MSR_BASE_BIT,				/* BASE Address		*/
+	MSR_SMM_BIT,				/* System mgmt mode	*/
+	MSR_SVM_BIT,				/*Secure Virtual Machine*/
+	MSR_OSVM_BIT,				/* OS-Visible Workaround*/
+	MSR_ALL_BIT,				/* Select all MSRs	*/
+};
+
+#define	MSR_ALL			(~0)		/* Select all MSRs	*/
+
+#define	MSR_MC			(1 << MSR_MC_BIT)
+#define	MSR_MONITOR		(1 << MSR_MONITOR_BIT)
+#define	MSR_TIME		(1 << MSR_TIME_BIT)
+#define	MSR_PMC			(1 << MSR_PMC_BIT)
+#define	MSR_PLATFORM		(1 << MSR_PLATFORM_BIT)
+#define	MSR_APIC		(1 << MSR_APIC_BIT)
+#define	MSR_POWERON		(1 << MSR_POWERON_BIT)
+#define	MSR_CONTROL		(1 << MSR_CONTROL_BIT)
+#define	MSR_FEATURES		(1 << MSR_FEATURES_BIT)
+#define	MSR_LBRANCH		(1 << MSR_LBRANCH_BIT)
+#define	MSR_BIOS		(1 << MSR_BIOS_BIT)
+#define	MSR_FREQ		(1 << MSR_FREQ_BIT)
+#define	MSR_MTRR		(1 << MSR_MTTR_BIT)
+#define	MSR_PERF		(1 << MSR_PERF_BIT)
+#define	MSR_CACHE		(1 << MSR_CACHE_BIT)
+#define	MSR_SYSENTER		(1 << MSR_SYSENTER_BIT)
+#define	MSR_THERM		(1 << MSR_THERM_BIT)
+#define	MSR_MISC		(1 << MSR_MISC_BIT)
+#define	MSR_DEBUG		(1 << MSR_DEBUG_BIT)
+#define	MSR_PAT			(1 << MSR_PAT_BIT)
+#define	MSR_VMX			(1 << MSR_VMX_BIT)
+#define	MSR_CALL		(1 << MSR_CALL_BIT)
+#define	MSR_BASE		(1 << MSR_BASE_BIT)
+#define	MSR_SMM			(1 << MSR_SMM_BIT)
+#define	MSR_SVM			(1 << MSR_SVM_BIT)
+#define	MSR_OSVM		(1 << MSR_OSVM_BIT)
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
+/* MSR processors bits */
+enum msr_cpu_bit {
+/* Intel */
+	MSR_INTEL_PENTIUM_BIT,
+	MSR_INTEL_P6_BIT,
+	MSR_INTEL_PENTIUM_M_BIT,
+	MSR_INTEL_CORE_BIT,
+	MSR_INTEL_CORE2_BIT,
+	MSR_INTEL_ATOM_BIT,
+	MSR_INTEL_XEON_P4_BIT,
+	MSR_INTEL_XEON_MP_BIT,
+};
+
+#define	MSR_CPU_ALL		(~0)		/* Select all CPUs	*/
+
+#define	MSR_INTEL_PENTIUM	(1 << MSR_INTEL_PENTIUM_BIT)
+#define	MSR_INTEL_P6		(1 << MSR_INTEL_P6_BIT)
+#define	MSR_INTEL_PENTIUM_M	(1 << MSR_INTEL_PENTIUM_M_BIT)
+#define	MSR_INTEL_CORE		(1 << MSR_INTEL_CORE_BIT)
+#define	MSR_INTEL_CORE2		(1 << MSR_INTEL_CORE2_BIT)
+#define	MSR_INTEL_ATOM		(1 << MSR_INTEL_ATOM_BIT)
+#define	MSR_INTEL_XEON_P4	(1 << MSR_INTEL_XEON_P4_BIT)
+#define	MSR_INTEL_XEON_MP	(1 << MSR_INTEL_XEON_MP_BIT)
+
+#define	MSR_INTEL_PX		(MSR_INTEL_P6 | MSR_INTEL_PENTIUM_M)
+#define	MSR_INTEL_COREX		(MSR_INTEL_CORE | MSR_INTEL_CORE2)
+#define	MSR_INTEL_XEON		(MSR_INTEL_XEON_P4 | MSR_INTEL_XEON_MP)
+#define	MSR_CO_AT		(MSR_INTEL_CORE | MSR_INTEL_ATOM)
+#define	MSR_C2_AT		(MSR_INTEL_CORE2 | MSR_INTEL_ATOM)
+#define	MSR_CX_AT		(MSR_INTEL_COREX | MSR_INTEL_ATOM)
+#define	MSR_CX_XE		(MSR_INTEL_COREX | MSR_INTEL_XEON)
+#define	MSR_P6_XE		(MSR_INTEL_P6 | MSR_INTEL_XEON)
+#define	MSR_PM_CO_AT		(MSR_INTEL_PENTIUM_M | MSR_CO_AT)
+#define	MSR_C2_AT_XE		(MSR_C2_AT | MSR_INTEL_XEON)
+#define	MSR_CX_AT_XE		(MSR_CX_AT | MSR_INTEL_XEON)
+#define	MSR_P6_CX_AT		(MSR_INTEL_P6 | MSR_CX_AT)
+#define	MSR_P6_CX_XE		(MSR_P6_XE | MSR_INTEL_COREX)
+#define	MSR_P6_CX_AT_XE		(MSR_INTEL_P6 | MSR_CX_AT_XE)
+#define	MSR_PM_CX_AT_XE		(MSR_INTEL_PENTIUM_M | MSR_CX_AT_XE)
+#define	MSR_PM_CX_AT		(MSR_INTEL_PENTIUM_M | MSR_CX_AT)
+#define	MSR_PM_CX_XE		(MSR_INTEL_PENTIUM_M | MSR_CX_XE)
+#define	MSR_PX_CX_AT		(MSR_INTEL_PX | MSR_CX_AT)
+#define	MSR_PX_CX_AT_XE		(MSR_INTEL_PX | MSR_CX_AT_XE)
+
+/* Select all Intel CPUs*/
+#define	MSR_INTEL_ALL		(MSR_INTEL_PENTIUM | MSR_PX_CX_AT_XE)
+
+struct msr_debug_base {
+	char		*name;			/* MSR name		*/
+	unsigned	flag;			/* MSR flag		*/
+};
+
+struct msr_debug_range {
+	unsigned	min;			/* MSR range min	*/
+	unsigned	max;			/* MSR range max	*/
+	unsigned	flag;			/* Supported flags	*/
+	unsigned	model;			/* Supported models	*/
+};
+
+struct msr_private {
+	unsigned cpu;
+	unsigned msr;
+	unsigned count;
+};
+
+extern struct dentry *arch_cpu_debugfs_dir;
+
+#endif /* _ASM_X86_MSR_DEBUG_H */
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index c381330..6c9187a 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -9,7 +9,7 @@ endif
 
 obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
 obj-y			+= proc.o capflags.o powerflags.o common.o
-obj-y			+= vmware.o hypervisor.o
+obj-y			+= vmware.o hypervisor.o msr_debug.o
 
 obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
 obj-$(CONFIG_X86_64)	+= bugs_64.o
diff --git a/arch/x86/kernel/cpu/msr_debug.c b/arch/x86/kernel/cpu/msr_debug.c
new file mode 100755
index 0000000..21808d0
--- /dev/null
+++ b/arch/x86/kernel/cpu/msr_debug.c
@@ -0,0 +1,461 @@
+/*
+ * Model Specific Registers (MSR) x86 architecture debug code
+ *
+ * Copyright(C) 2009 Jaswinder Singh Rajput
+ *
+ * For licencing details see kernel-base/COPYING
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <asm/msr_debug.h>
+
+static struct msr_debug_base msr_base[] = {
+	{ "mc",		MSR_MC		},	/* Machine Check	*/
+	{ "monitor",	MSR_MONITOR	},	/* Monitor		*/
+	{ "time",	MSR_TIME	},	/* Time			*/
+	{ "pmc",	MSR_PMC		},	/* Performance Monitor	*/
+	{ "platform",	MSR_PLATFORM	},	/* Platform		*/
+	{ "apic",	MSR_APIC	},	/* APIC			*/
+	{ "poweron",	MSR_POWERON	},	/* Power-on		*/
+	{ "control",	MSR_CONTROL	},	/* Control		*/
+	{ "features",	MSR_FEATURES	},	/* Features control	*/
+	{ "lastbranch",	MSR_LBRANCH	},	/* Last Branch		*/
+	{ "bios",	MSR_BIOS	},	/* BIOS			*/
+	{ "freq",	MSR_FREQ	},	/* Frequency		*/
+	{ "mttr",	MSR_MTRR	},	/* MTRR			*/
+	{ "perf",	MSR_PERF	},	/* Performance		*/
+	{ "cache",	MSR_CACHE	},	/* Cache		*/
+	{ "sysenter",	MSR_SYSENTER	},	/* Sysenter		*/
+	{ "therm",	MSR_THERM	},	/* Thermal		*/
+	{ "misc",	MSR_MISC	},	/* Miscellaneous	*/
+	{ "debug",	MSR_DEBUG	},	/* Debug		*/
+	{ "pat",	MSR_PAT		},	/* PAT			*/
+	{ "vmx",	MSR_VMX		},	/* VMX			*/
+	{ "call",	MSR_CALL	},	/* System Call		*/
+	{ "base",	MSR_BASE	},	/* BASE Address		*/
+	{ "smm",	MSR_SMM		},	/* System mgmt mode	*/
+	{ "svm",	MSR_SVM		},	/*Secure Virtial Machine*/
+	{ "osvm",	MSR_OSVM	},	/* OS-Visible Workaround*/
+	{ "msr",	MSR_ALL		},	/* Select all MSRs	*/
+};
+
+static struct msr_debug_range msr_intel_range[] = {
+	{ 0x00000000, 0x00000001, MSR_MC,	MSR_INTEL_ALL		},
+	{ 0x00000006, 0x00000007, MSR_MONITOR,	MSR_CX_AT_XE		},
+	{ 0x00000010, 0x00000010, MSR_TIME,	MSR_INTEL_ALL		},
+	{ 0x00000011, 0x00000013, MSR_PMC,	MSR_INTEL_PENTIUM	},
+	{ 0x00000017, 0x00000017, MSR_PLATFORM,	MSR_PX_CX_AT_XE		},
+	{ 0x0000001B, 0x0000001B, MSR_APIC,	MSR_P6_CX_AT_XE		},
+
+	{ 0x0000002A, 0x0000002A, MSR_POWERON,	MSR_PX_CX_AT_XE		},
+	{ 0x0000002B, 0x0000002B, MSR_POWERON,	MSR_INTEL_XEON		},
+	{ 0x0000002C, 0x0000002C, MSR_FREQ,	MSR_INTEL_XEON		},
+	{ 0x0000003A, 0x0000003A, MSR_CONTROL,	MSR_CX_AT_XE		},
+
+	{ 0x00000040, 0x00000043, MSR_LBRANCH,	MSR_PM_CX_AT_XE		},
+	{ 0x00000044, 0x00000047, MSR_LBRANCH,	MSR_PM_CO_AT		},
+	{ 0x00000060, 0x00000063, MSR_LBRANCH,	MSR_C2_AT		},
+	{ 0x00000064, 0x00000067, MSR_LBRANCH,	MSR_INTEL_ATOM		},
+
+	{ 0x00000079, 0x00000079, MSR_BIOS,	MSR_P6_CX_AT_XE		},
+	{ 0x00000088, 0x0000008A, MSR_CACHE,	MSR_INTEL_P6		},
+	{ 0x0000008B, 0x0000008B, MSR_BIOS,	MSR_P6_CX_AT_XE		},
+	{ 0x0000009B, 0x0000009B, MSR_MONITOR,	MSR_INTEL_XEON		},
+
+	{ 0x000000C1, 0x000000C2, MSR_PMC,	MSR_P6_CX_AT		},
+	{ 0x000000CD, 0x000000CD, MSR_FREQ,	MSR_CX_AT		},
+	{ 0x000000E7, 0x000000E8, MSR_PERF,	MSR_CX_AT		},
+	{ 0x000000FE, 0x000000FE, MSR_MTRR,	MSR_P6_CX_XE		},
+
+	{ 0x00000116, 0x00000116, MSR_CACHE,	MSR_INTEL_P6		},
+	{ 0x00000118, 0x00000118, MSR_CACHE,	MSR_INTEL_P6		},
+	{ 0x00000119, 0x00000119, MSR_CACHE,	MSR_INTEL_PX		},
+	{ 0x0000011A, 0x0000011B, MSR_CACHE,	MSR_INTEL_P6		},
+	{ 0x0000011E, 0x0000011E, MSR_CACHE,	MSR_PX_CX_AT		},
+
+	{ 0x00000174, 0x00000176, MSR_SYSENTER,	MSR_P6_CX_AT_XE		},
+	{ 0x00000179, 0x0000017A, MSR_MC,	MSR_PX_CX_AT_XE		},
+	{ 0x0000017B, 0x0000017B, MSR_MC,	MSR_P6_XE		},
+	{ 0x00000186, 0x00000187, MSR_PMC,	MSR_P6_CX_AT		},
+	{ 0x00000198, 0x00000199, MSR_PERF,	MSR_PM_CX_AT_XE		},
+	{ 0x0000019A, 0x0000019A, MSR_TIME,	MSR_PM_CX_AT_XE		},
+	{ 0x0000019B, 0x0000019D, MSR_THERM,	MSR_PM_CX_AT_XE		},
+	{ 0x000001A0, 0x000001A0, MSR_MISC,	MSR_PM_CX_AT_XE		},
+
+	{ 0x000001C9, 0x000001C9, MSR_LBRANCH,	MSR_PM_CX_AT		},
+	{ 0x000001D7, 0x000001D8, MSR_LBRANCH,	MSR_INTEL_XEON		},
+	{ 0x000001D9, 0x000001D9, MSR_DEBUG,	MSR_CX_AT_XE		},
+	{ 0x000001DA, 0x000001DA, MSR_LBRANCH,	MSR_INTEL_XEON		},
+	{ 0x000001DB, 0x000001DB, MSR_LBRANCH,	MSR_P6_XE		},
+	{ 0x000001DC, 0x000001DC, MSR_LBRANCH,	MSR_INTEL_P6		},
+	{ 0x000001DD, 0x000001DE, MSR_LBRANCH,	MSR_PX_CX_AT_XE		},
+	{ 0x000001E0, 0x000001E0, MSR_LBRANCH,	MSR_INTEL_P6		},
+
+	{ 0x00000200, 0x0000020F, MSR_MTRR,	MSR_P6_CX_XE		},
+	{ 0x00000250, 0x00000250, MSR_MTRR,	MSR_P6_CX_XE		},
+	{ 0x00000258, 0x00000259, MSR_MTRR,	MSR_P6_CX_XE		},
+	{ 0x00000268, 0x0000026F, MSR_MTRR,	MSR_P6_CX_XE		},
+	{ 0x00000277, 0x00000277, MSR_PAT,	MSR_C2_AT_XE		},
+	{ 0x000002FF, 0x000002FF, MSR_MTRR,	MSR_P6_CX_XE		},
+
+	{ 0x00000300, 0x00000308, MSR_PMC,	MSR_INTEL_XEON		},
+	{ 0x00000309, 0x0000030B, MSR_PMC,	MSR_C2_AT_XE		},
+	{ 0x0000030C, 0x00000311, MSR_PMC,	MSR_INTEL_XEON		},
+	{ 0x00000345, 0x00000345, MSR_PMC,	MSR_C2_AT		},
+	{ 0x00000360, 0x00000371, MSR_PMC,	MSR_INTEL_XEON		},
+	{ 0x0000038D, 0x00000390, MSR_PMC,	MSR_C2_AT		},
+	{ 0x000003A0, 0x000003BE, MSR_PMC,	MSR_INTEL_XEON		},
+	{ 0x000003C0, 0x000003CD, MSR_PMC,	MSR_INTEL_XEON		},
+	{ 0x000003E0, 0x000003E1, MSR_PMC,	MSR_INTEL_XEON		},
+	{ 0x000003F0, 0x000003F0, MSR_PMC,	MSR_INTEL_XEON		},
+	{ 0x000003F1, 0x000003F1, MSR_PMC,	MSR_C2_AT_XE		},
+	{ 0x000003F2, 0x000003F2, MSR_PMC,	MSR_INTEL_XEON		},
+
+	{ 0x00000400, 0x00000402, MSR_MC,	MSR_PM_CX_AT_XE		},
+	{ 0x00000403, 0x00000403, MSR_MC,	MSR_INTEL_XEON		},
+	{ 0x00000404, 0x00000406, MSR_MC,	MSR_PM_CX_AT_XE		},
+	{ 0x00000407, 0x00000407, MSR_MC,	MSR_INTEL_XEON		},
+	{ 0x00000408, 0x0000040A, MSR_MC,	MSR_PM_CX_AT_XE		},
+	{ 0x0000040B, 0x0000040B, MSR_MC,	MSR_INTEL_XEON		},
+	{ 0x0000040C, 0x0000040E, MSR_MC,	MSR_PM_CX_XE		},
+	{ 0x0000040F, 0x0000040F, MSR_MC,	MSR_INTEL_XEON		},
+	{ 0x00000410, 0x00000412, MSR_MC,	MSR_PM_CX_AT_XE		},
+	{ 0x00000413, 0x00000417, MSR_MC,	MSR_CX_AT_XE		},
+	{ 0x00000480, 0x0000048B, MSR_VMX,	MSR_CX_AT_XE		},
+
+	{ 0x00000600, 0x00000600, MSR_DEBUG,	MSR_PM_CX_AT_XE		},
+	{ 0x00000680, 0x0000068F, MSR_LBRANCH,	MSR_INTEL_XEON		},
+	{ 0x000006C0, 0x000006CF, MSR_LBRANCH,	MSR_INTEL_XEON		},
+
+	{ 0x000107CC, 0x000107D3, MSR_PMC,	MSR_INTEL_XEON_MP	},
+
+	{ 0xC0000080, 0xC0000080, MSR_FEATURES,	MSR_INTEL_XEON		},
+	{ 0xC0000081, 0xC0000082, MSR_CALL,	MSR_INTEL_XEON		},
+	{ 0xC0000084, 0xC0000084, MSR_CALL,	MSR_INTEL_XEON		},
+	{ 0xC0000100, 0xC0000102, MSR_BASE,	MSR_INTEL_XEON		},
+};
+
+/* AMD MSRs Range */
+static struct msr_debug_range msr_amd_range[] = {
+	{ 0x00000010, 0x00000010, MSR_TIME,	MSR_CPU_ALL,		},
+	{ 0x0000001B, 0x0000001B, MSR_APIC,	MSR_CPU_ALL,		},
+	{ 0x000000FE, 0x000000FE, MSR_MTRR,	MSR_CPU_ALL,		},
+
+	{ 0x00000174, 0x00000176, MSR_SYSENTER,	MSR_CPU_ALL,		},
+	{ 0x00000179, 0x0000017A, MSR_MC,	MSR_CPU_ALL,		},
+	{ 0x0000017B, 0x0000017B, MSR_MC,	MSR_CPU_ALL,		},
+	{ 0x000001D9, 0x000001D9, MSR_DEBUG,	MSR_CPU_ALL,		},
+	{ 0x000001DB, 0x000001DE, MSR_LBRANCH,	MSR_CPU_ALL,		},
+
+	{ 0x00000200, 0x0000020F, MSR_MTRR,	MSR_CPU_ALL,		},
+	{ 0x00000250, 0x00000250, MSR_MTRR,	MSR_CPU_ALL,		},
+	{ 0x00000258, 0x00000259, MSR_MTRR,	MSR_CPU_ALL,		},
+	{ 0x00000268, 0x0000026F, MSR_MTRR,	MSR_CPU_ALL,		},
+	{ 0x00000277, 0x00000277, MSR_PAT,	MSR_CPU_ALL,		},
+	{ 0x000002FF, 0x000002FF, MSR_MTRR,	MSR_CPU_ALL,		},
+
+	{ 0x00000400, 0x00000417, MSR_MC,	MSR_CPU_ALL,		},
+
+	{ 0xC0000080, 0xC0000080, MSR_FEATURES,	MSR_INTEL_XEON		},
+	{ 0xC0000081, 0xC0000084, MSR_CALL,	MSR_INTEL_XEON		},
+	{ 0xC0000100, 0xC0000102, MSR_BASE,	MSR_INTEL_XEON		},
+	{ 0xC0000103, 0xC0000103, MSR_TIME,	MSR_INTEL_XEON		},
+
+	{ 0xC0000408, 0xC000040A, MSR_MC,	MSR_CPU_ALL,		},
+
+	{ 0xc0010000, 0xc0010007, MSR_PMC,	MSR_CPU_ALL		},
+	{ 0xc0010010, 0xc0010010, MSR_MTRR,	MSR_CPU_ALL		},
+	{ 0xc0010016, 0xc001001A, MSR_MTRR,	MSR_CPU_ALL		},
+	{ 0xc001001D, 0xc001001D, MSR_MTRR,	MSR_CPU_ALL		},
+	{ 0xc0010030, 0xc0010035, MSR_BIOS,	MSR_CPU_ALL		},
+	{ 0xc0010056, 0xc0010056, MSR_SMM,	MSR_CPU_ALL		},
+	{ 0xc0010061, 0xc0010063, MSR_SMM,	MSR_CPU_ALL		},
+	{ 0xc0010074, 0xc0010074, MSR_MC,	MSR_CPU_ALL		},
+	{ 0xc0010111, 0xc0010113, MSR_SMM,	MSR_CPU_ALL		},
+	{ 0xc0010114, 0xc0010118, MSR_SVM,	MSR_CPU_ALL		},
+	{ 0xc0010119, 0xc001011A, MSR_SMM,	MSR_CPU_ALL		},
+	{ 0xc0010140, 0xc0010141, MSR_OSVM,	MSR_CPU_ALL		},
+	{ 0xc0010156, 0xc0010156, MSR_SMM,	MSR_CPU_ALL		},
+};
+
+static DEFINE_MUTEX(msr_debug_lock);
+
+static int get_msr_intel_bit(unsigned model)
+{
+	int ret = 0;
+
+	switch (model) {
+	case 0x0501:
+	case 0x0502:
+	case 0x0504:
+		ret = MSR_INTEL_PENTIUM;
+		break;
+	case 0x0601:
+	case 0x0603:
+	case 0x0605:
+	case 0x0607:
+	case 0x0608:
+	case 0x060A:
+	case 0x060B:
+		ret = MSR_INTEL_P6;
+		break;
+	case 0x0609:
+	case 0x060D:
+		ret = MSR_INTEL_PENTIUM_M;
+		break;
+	case 0x060E:
+		ret = MSR_INTEL_CORE;
+		break;
+	case 0x060F:
+	case 0x0617:
+		ret = MSR_INTEL_CORE2;
+		break;
+	case 0x061C:
+		ret = MSR_INTEL_ATOM;
+		break;
+	case 0x0F00:
+	case 0x0F01:
+	case 0x0F02:
+	case 0x0F03:
+	case 0x0F04:
+		ret = MSR_INTEL_XEON_P4;
+		break;
+	case 0x0F06:
+		ret = MSR_INTEL_XEON_MP;
+		break;
+	}
+
+	return ret;
+}
+
+static int get_msr_cpu_bit(unsigned model)
+{
+	unsigned vendor;
+
+	vendor = model >> 16;
+	if (vendor == X86_VENDOR_INTEL)
+		return get_msr_intel_bit(model & 0xffff);
+	else
+		return 0;
+}
+
+static unsigned get_msr_range(unsigned *min, unsigned *max, int index,
+			 unsigned flag, unsigned model)
+{
+	unsigned vendor, cpu_bit;
+
+	vendor = model >> 16;
+	cpu_bit = get_msr_cpu_bit(model);
+	*max = 0;
+	if (vendor == X86_VENDOR_INTEL) {
+		if ((msr_intel_range[index].model & cpu_bit) &&
+		    (msr_intel_range[index].flag & flag)) {
+			*min = msr_intel_range[index].min;
+			*max = msr_intel_range[index].max;
+		}
+	} else if (vendor == X86_VENDOR_AMD) {
+		if (msr_amd_range[index].flag & flag) {
+			*min = msr_amd_range[index].min;
+			*max = msr_amd_range[index].max;
+		}
+	}
+
+	return *max;
+}
+
+static int get_msr_range_count(unsigned flag, unsigned model)
+{
+	int index = 0;
+
+	model >>= 16;
+	if (model == X86_VENDOR_INTEL)
+		index = ARRAY_SIZE(msr_intel_range);
+	else if (model == X86_VENDOR_AMD)
+		index = ARRAY_SIZE(msr_amd_range);
+
+	return index;
+}
+
+static void print_intel_msr(struct seq_file *seq, unsigned int cpu,
+			    unsigned flag, unsigned model)
+{
+	int i, range;
+	u32 low, high;
+	unsigned msr, msr_min, msr_max;
+
+	range = get_msr_range_count(flag, model);
+
+	for (i = 0; i < range; i++) {
+		if (!get_msr_range(&msr_min, &msr_max, i, flag, model))
+			continue;
+		for (msr = msr_min; msr <= msr_max; msr++) {
+			if (rdmsr_safe_on_cpu(cpu, msr, &low, &high))
+				continue;
+			if (seq)
+				seq_printf(seq, " MSR_%08x: %08x_%08x\n",
+					   msr, high, low);
+			else
+				printk(KERN_INFO " MSR_%08x: %08x_%08x\n",
+				       msr, high, low);
+		}
+	}
+}
+
+static void print_amd_msr(struct seq_file *seq, unsigned flag, unsigned model)
+{
+	int i, range;
+	u64 val;
+	unsigned msr, msr_min, msr_max;
+
+	range = get_msr_range_count(flag, model);
+
+	for (i = 0; i < range; i++) {
+		if (!get_msr_range(&msr_min, &msr_max, i, flag, model))
+			continue;
+		for (msr = msr_min; msr <= msr_max; msr++) {
+			if (rdmsrl_amd_safe(msr, &val))
+				continue;
+			if (seq)
+				seq_printf(seq, " MSR_%08x: %016llx\n",
+					   msr, val);
+			else
+				printk(KERN_INFO " MSR_%08x: %016llx\n",
+				       msr, val);
+		}
+	}
+}
+
+static int msr_seq_show(struct seq_file *seq, void *v)
+{
+	unsigned model, flag;
+	struct cpuinfo_x86 *cpu = &cpu_data(0);
+	struct msr_private *priv = seq->private;
+
+#ifdef CONFIG_SMP
+	/* We are only interested for core_id 0 */
+	if (cpu->cpu_core_id || cpu->apicid)
+		return 0;
+#endif
+	model = ((cpu->x86_vendor << 16) | (cpu->x86 << 8) | (cpu->x86_model));
+	flag = msr_base[priv->msr].flag;
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
+		print_intel_msr(seq, cpu->phys_proc_id, flag, model);
+	else
+		print_amd_msr(seq, flag, model);
+
+	seq_printf(seq, "\n");
+
+	return 0;
+}
+
+static void *msr_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct cpuinfo_x86 *c = NULL;
+
+	if (*pos == 0) /* just in case, cpu 0 is not the first */
+		c = &cpu_data(*pos);
+
+	return c;
+}
+
+static void *msr_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	(*pos)++;
+
+	return msr_seq_start(seq, pos);
+}
+
+static void msr_seq_stop(struct seq_file *seq, void *v)
+{
+}
+
+static const struct seq_operations msr_seq_ops = {
+	.start = msr_seq_start,
+	.next  = msr_seq_next,
+	.stop  = msr_seq_stop,
+	.show  = msr_seq_show,
+};
+
+static int msr_seq_open(struct inode *inode, struct file *file)
+{
+	struct seq_file *seq;
+	struct msr_private *priv;
+	int err, private = inode->i_private;
+
+	err = seq_open(file, &msr_seq_ops);
+	mutex_lock(&msr_debug_lock);
+	if (!err) {
+		priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+        	if (priv) {
+			seq = file->private_data;
+			priv->cpu = (private & 0xFF);
+			private >>= 8;
+			priv->msr = (private & 0xFF);
+			private >>= 8;
+			priv->count = (private & 0xFF);
+			seq->private = priv;
+		} else
+                	err = -ENOMEM;
+
+	}
+	mutex_unlock(&msr_debug_lock);
+
+	return err;
+}
+
+static int msr_seq_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *seq = (struct seq_file *)file->private_data;
+	struct msr_private *priv = seq->private;
+
+	seq_release(inode, file);
+	kfree(priv);
+
+	return 0;
+}
+
+static const struct file_operations msr_fops = {
+	.open    = msr_seq_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = msr_seq_release,
+};
+
+static struct dentry *msr_debugfs_dir;
+
+static int __init msr_debug_init(void)
+{
+	int i;
+	unsigned priv_data;
+	struct dentry *msr_dentry;
+	struct cpuinfo_x86 *cpu = &cpu_data(0);
+
+	if (!cpu_has(cpu, X86_FEATURE_MSR))
+		return -ENODEV;
+
+	msr_debugfs_dir = debugfs_create_dir("msr", arch_cpu_debugfs_dir);
+	msr_dentry = debugfs_create_dir("cpu0", msr_debugfs_dir);
+
+	for (i = 0; i <  ARRAY_SIZE(msr_base); i++) {
+		priv_data = i << 8;
+		debugfs_create_file(msr_base[i].name, S_IRUGO, msr_dentry,
+				    (void *)priv_data, &msr_fops);
+	}
+	return 0;
+}
+
+static void __exit msr_debug_exit(void)
+{
+	if (msr_debugfs_dir)
+		debugfs_remove_recursive(msr_debugfs_dir);
+}
+
+module_init(msr_debug_init);
+module_exit(msr_debug_exit);
+
+MODULE_AUTHOR("Jaswinder Singh Rajput");
+MODULE_DESCRIPTION("MSR debug module");
+MODULE_LICENSE("GPL");
diff --git a/arch/x86/kernel/kdebugfs.c b/arch/x86/kernel/kdebugfs.c
index ff7d3b0..2fa3b08 100644
--- a/arch/x86/kernel/kdebugfs.c
+++ b/arch/x86/kernel/kdebugfs.c
@@ -19,6 +19,9 @@
 struct dentry *arch_debugfs_dir;
 EXPORT_SYMBOL(arch_debugfs_dir);
 
+struct dentry *arch_cpu_debugfs_dir;
+EXPORT_SYMBOL(arch_cpu_debugfs_dir);
+
 #ifdef CONFIG_DEBUG_BOOT_PARAMS
 struct setup_data_node {
 	u64 paddr;
@@ -218,6 +221,10 @@ static int __init arch_kdebugfs_init(void)
 	if (!arch_debugfs_dir)
 		return -ENOMEM;
 
+	arch_cpu_debugfs_dir = debugfs_create_dir("cpu", arch_debugfs_dir);
+	if (!arch_cpu_debugfs_dir)
+		return -ENOMEM;
+
 #ifdef CONFIG_DEBUG_BOOT_PARAMS
 	error = boot_params_kdebugfs_init();
 #endif


