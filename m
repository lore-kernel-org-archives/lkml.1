Return-Path: <linux-kernel-owner+w=401wt.eu-S1753125AbZDTBgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbZDTBgy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 21:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbZDTBgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 21:36:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:52911 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbZDTBgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 21:36:43 -0400
Subject: Re: [git-pull -tip] x86: cpu_debug patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1240190145.3106.90.camel@ht.satnam>
References: <1240190145.3106.90.camel@ht.satnam>
Content-Type: text/plain
Date: Mon, 20 Apr 2009 07:05:59 +0530
Message-Id: <1240191359.3106.93.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-20 at 06:45 +0530, Jaswinder Singh Rajput wrote:
>  	{ "conf",	CPU_CONF,	0	},
> -	{ "smm",	CPU_SMM,	0	},
> +	{ "sm",		CPU_SM,	0	},

Here is new pull request after fixing this tab:
The following changes since commit 88dc4c8e38d64db32907e0bd605f8c1ec4c4d1bd:
  Ingo Molnar (1):
        Merge branch 'tracing/ftrace'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git master

Jaswinder Singh Rajput (5):
      x86: cpu_debug add support for Intel Xeon MP 7400 series
      x86: cpu_debug add support for Intel Nehalem microarchitecture
      x86: cpu_debug avoid storing cpu_descriptors locally where possible
      x86: cpu_debug.c prepare report if files are inappropriate or CPU is not supported
      x86: cpu_debug.c remove unwanted header files

 arch/x86/include/asm/cpu_debug.h |   32 ++++++-
 arch/x86/kernel/cpu/cpu_debug.c  |  183 ++++++++++++++++++++++++--------------
 2 files changed, 146 insertions(+), 69 deletions(-)

Complete diff:
diff --git a/arch/x86/include/asm/cpu_debug.h b/arch/x86/include/asm/cpu_debug.h
index 2228020..8105863 100644
--- a/arch/x86/include/asm/cpu_debug.h
+++ b/arch/x86/include/asm/cpu_debug.h
@@ -35,7 +35,7 @@ enum cpu_debug_bit {
 	CPU_BASE_BIT,				/* BASE Address		*/
 	CPU_VER_BIT,				/* Version ID		*/
 	CPU_CONF_BIT,				/* Configuration	*/
-	CPU_SMM_BIT,				/* System mgmt mode	*/
+	CPU_SM_BIT,				/* System Management	*/
 	CPU_SVM_BIT,				/*Secure Virtual Machine*/
 	CPU_OSVM_BIT,				/* OS-Visible Workaround*/
 /* Standard Registers							*/
@@ -73,7 +73,7 @@ enum cpu_debug_bit {
 #define	CPU_BASE		(1 << CPU_BASE_BIT)
 #define	CPU_VER			(1 << CPU_VER_BIT)
 #define	CPU_CONF		(1 << CPU_CONF_BIT)
-#define	CPU_SMM			(1 << CPU_SMM_BIT)
+#define	CPU_SM			(1 << CPU_SM_BIT)
 #define	CPU_SVM			(1 << CPU_SVM_BIT)
 #define	CPU_OSVM		(1 << CPU_OSVM_BIT)
 #define	CPU_TSS			(1 << CPU_TSS_BIT)
@@ -89,6 +89,7 @@ enum cpu_file_bit {
 #define	CPU_FILE_VALUE			(1 << CPU_VALUE_BIT)
 
 /*
+ * 			Intel CPU support
  * DisplayFamily_DisplayModel	Processor Families/Processor Number Series
  * --------------------------	------------------------------------------
  * 05_01, 05_02, 05_04		Pentium, Pentium with MMX
@@ -106,8 +107,12 @@ enum cpu_file_bit {
  *				Pentium dual-core
  * 06_17			Xeon 5200, 5400 series, Core 2 Quad Q9650
  *
+ * 06_1A			Core i7, Xeon Processor 5500 series (Nehalem)
+ *
  * 06_1C			Atom
  *
+ * 06_1D			Xeon MP 7400 series
+ *
  * 0F_00, 0F_01, 0F_02		Xeon, Xeon MP, Pentium 4
  * 0F_03, 0F_04			Xeon, Xeon MP, Pentium 4, Pentium D
  *
@@ -124,6 +129,8 @@ enum cpu_processor_bit {
 	CPU_INTEL_PENTIUM_M_BIT,
 	CPU_INTEL_CORE_BIT,
 	CPU_INTEL_CORE2_BIT,
+	CPU_INTEL_XEON_7400_BIT,
+	CPU_INTEL_NEHALEM_BIT,
 	CPU_INTEL_ATOM_BIT,
 	CPU_INTEL_XEON_P4_BIT,
 	CPU_INTEL_XEON_MP_BIT,
@@ -141,29 +148,46 @@ enum cpu_processor_bit {
 #define	CPU_INTEL_PENTIUM_M	(1 << CPU_INTEL_PENTIUM_M_BIT)
 #define	CPU_INTEL_CORE		(1 << CPU_INTEL_CORE_BIT)
 #define	CPU_INTEL_CORE2		(1 << CPU_INTEL_CORE2_BIT)
+#define	CPU_INTEL_XEON_7400	(1 << CPU_INTEL_XEON_7400_BIT)
+#define	CPU_INTEL_NEHALEM	(1 << CPU_INTEL_NEHALEM_BIT)
 #define	CPU_INTEL_ATOM		(1 << CPU_INTEL_ATOM_BIT)
 #define	CPU_INTEL_XEON_P4	(1 << CPU_INTEL_XEON_P4_BIT)
 #define	CPU_INTEL_XEON_MP	(1 << CPU_INTEL_XEON_MP_BIT)
 
 #define	CPU_INTEL_PX		(CPU_INTEL_P6 | CPU_INTEL_PENTIUM_M)
-#define	CPU_INTEL_COREX		(CPU_INTEL_CORE | CPU_INTEL_CORE2)
+#define	CPU_INTEL_CORE2X	(CPU_INTEL_CORE2 | CPU_INTEL_XEON_7400)
+#define	CPU_INTEL_COREX		(CPU_INTEL_CORE | CPU_INTEL_CORE2X)
 #define	CPU_INTEL_XEON		(CPU_INTEL_XEON_P4 | CPU_INTEL_XEON_MP)
+#define	CPU_XEON_MPX		(CPU_INTEL_XEON_MP | CPU_INTEL_XEON_7400)
+#define	CPU_XEON_NE		(CPU_INTEL_XEON | CPU_INTEL_NEHALEM)
 #define	CPU_CO_AT		(CPU_INTEL_CORE | CPU_INTEL_ATOM)
-#define	CPU_C2_AT		(CPU_INTEL_CORE2 | CPU_INTEL_ATOM)
+#define	CPU_C2_AT		(CPU_INTEL_CORE2X | CPU_INTEL_ATOM)
 #define	CPU_CX_AT		(CPU_INTEL_COREX | CPU_INTEL_ATOM)
 #define	CPU_CX_XE		(CPU_INTEL_COREX | CPU_INTEL_XEON)
 #define	CPU_P6_XE		(CPU_INTEL_P6 | CPU_INTEL_XEON)
 #define	CPU_PM_CO_AT		(CPU_INTEL_PENTIUM_M | CPU_CO_AT)
 #define	CPU_C2_AT_XE		(CPU_C2_AT | CPU_INTEL_XEON)
 #define	CPU_CX_AT_XE		(CPU_CX_AT | CPU_INTEL_XEON)
+#define	CPU_C2_AT_NE		(CPU_C2_AT | CPU_INTEL_NEHALEM)
+#define	CPU_CX_AT_NE		(CPU_CX_AT | CPU_INTEL_NEHALEM)
 #define	CPU_P6_CX_AT		(CPU_INTEL_P6 | CPU_CX_AT)
 #define	CPU_P6_CX_XE		(CPU_P6_XE | CPU_INTEL_COREX)
+#define	CPU_C2_AT_XE_NE		(CPU_C2_AT_XE | CPU_INTEL_NEHALEM)
+#define	CPU_CX_AT_XE_NE		(CPU_CX_AT_XE | CPU_INTEL_NEHALEM)
+#define	CPU_P6_CX_AT_NE		(CPU_P6_CX_AT | CPU_INTEL_NEHALEM)
+#define	CPU_P6_CX_XE_NE		(CPU_P6_CX_XE | CPU_INTEL_NEHALEM)
 #define	CPU_P6_CX_AT_XE		(CPU_INTEL_P6 | CPU_CX_AT_XE)
 #define	CPU_PM_CX_AT_XE		(CPU_INTEL_PENTIUM_M | CPU_CX_AT_XE)
 #define	CPU_PM_CX_AT		(CPU_INTEL_PENTIUM_M | CPU_CX_AT)
 #define	CPU_PM_CX_XE		(CPU_INTEL_PENTIUM_M | CPU_CX_XE)
 #define	CPU_PX_CX_AT		(CPU_INTEL_PX | CPU_CX_AT)
+#define	CPU_PX_CX_XE		(CPU_INTEL_PX | CPU_CX_XE)
 #define	CPU_PX_CX_AT_XE		(CPU_INTEL_PX | CPU_CX_AT_XE)
+#define	CPU_PM_CX_AT_NE		(CPU_PM_CX_AT | CPU_INTEL_NEHALEM)
+#define	CPU_PX_CX_XE_NE		(CPU_PX_CX_XE | CPU_INTEL_NEHALEM)
+#define	CPU_P6_CX_AT_XE_NE	(CPU_P6_CX_AT_XE | CPU_INTEL_NEHALEM)
+#define	CPU_PX_CX_AT_XE_NE	(CPU_PX_CX_AT_XE | CPU_INTEL_NEHALEM)
+#define	CPU_PM_CX_AT_XE_NE	(CPU_PM_CX_AT_XE | CPU_INTEL_NEHALEM)
 
 /* Select all supported Intel CPUs */
 #define	CPU_INTEL_ALL		(CPU_INTEL_PENTIUM | CPU_PX_CX_AT_XE)
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
index 46e29ab..ddd95be 100644
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
@@ -30,11 +26,15 @@
 #include <asm/apic.h>
 #include <asm/desc.h>
 
+#define EMAIL	"<linux-kernel@vger.kernel.org>, <jaswinderrajput@gmail.com>"
+
 static DEFINE_PER_CPU(struct cpu_cpuX_base, cpu_arr[CPU_REG_ALL_BIT]);
 static DEFINE_PER_CPU(struct cpu_private *, priv_arr[MAX_CPU_FILES]);
 static DEFINE_PER_CPU(unsigned, cpu_modelflag);
 static DEFINE_PER_CPU(int, cpu_priv_count);
-static DEFINE_PER_CPU(unsigned, cpu_model);
+
+/* Storing vendor locally because it is used excessive in this code */
+static int cpu_vendor;
 
 static DEFINE_MUTEX(cpu_debug_lock);
 
@@ -66,7 +66,7 @@ static struct cpu_debug_base cpu_base[] = {
 	{ "base",	CPU_BASE,	0	},
 	{ "ver",	CPU_VER,	0	},
 	{ "conf",	CPU_CONF,	0	},
-	{ "smm",	CPU_SMM,	0	},
+	{ "sm",		CPU_SM,		0	},
 	{ "svm",	CPU_SVM,	0	},
 	{ "osvm",	CPU_OSVM,	0	},
 	{ "tss",	CPU_TSS,	0	},
@@ -83,31 +83,33 @@ static struct cpu_file_base cpu_file[] = {
 /* Intel Registers Range */
 static struct cpu_debug_range cpu_intel_range[] = {
 	{ 0x00000000, 0x00000001, CPU_MC,	CPU_INTEL_ALL		},
-	{ 0x00000006, 0x00000007, CPU_MONITOR,	CPU_CX_AT_XE		},
+	{ 0x00000006, 0x00000006, CPU_MONITOR,	CPU_CX_AT_XE_NE		},
 	{ 0x00000010, 0x00000010, CPU_TIME,	CPU_INTEL_ALL		},
 	{ 0x00000011, 0x00000013, CPU_PMC,	CPU_INTEL_PENTIUM	},
-	{ 0x00000017, 0x00000017, CPU_PLATFORM,	CPU_PX_CX_AT_XE		},
-	{ 0x0000001B, 0x0000001B, CPU_APIC,	CPU_P6_CX_AT_XE		},
+	{ 0x00000017, 0x00000017, CPU_PLATFORM,	CPU_PX_CX_AT_XE_NE	},
+	{ 0x0000001B, 0x0000001B, CPU_APIC,	CPU_P6_CX_AT_XE_NE	},
 
 	{ 0x0000002A, 0x0000002A, CPU_POWERON,	CPU_PX_CX_AT_XE		},
 	{ 0x0000002B, 0x0000002B, CPU_POWERON,	CPU_INTEL_XEON		},
 	{ 0x0000002C, 0x0000002C, CPU_FREQ,	CPU_INTEL_XEON		},
-	{ 0x0000003A, 0x0000003A, CPU_CONTROL,	CPU_CX_AT_XE		},
+	{ 0x0000003A, 0x0000003A, CPU_CONTROL,	CPU_CX_AT_XE_NE		},
 
 	{ 0x00000040, 0x00000043, CPU_LBRANCH,	CPU_PM_CX_AT_XE		},
 	{ 0x00000044, 0x00000047, CPU_LBRANCH,	CPU_PM_CO_AT		},
 	{ 0x00000060, 0x00000063, CPU_LBRANCH,	CPU_C2_AT		},
 	{ 0x00000064, 0x00000067, CPU_LBRANCH,	CPU_INTEL_ATOM		},
 
-	{ 0x00000079, 0x00000079, CPU_BIOS,	CPU_P6_CX_AT_XE		},
+	{ 0x00000079, 0x00000079, CPU_BIOS,	CPU_P6_CX_AT_XE_NE	},
 	{ 0x00000088, 0x0000008A, CPU_CACHE,	CPU_INTEL_P6		},
-	{ 0x0000008B, 0x0000008B, CPU_BIOS,	CPU_P6_CX_AT_XE		},
+	{ 0x0000008B, 0x0000008B, CPU_BIOS,	CPU_P6_CX_AT_XE_NE	},
 	{ 0x0000009B, 0x0000009B, CPU_MONITOR,	CPU_INTEL_XEON		},
 
-	{ 0x000000C1, 0x000000C2, CPU_PMC,	CPU_P6_CX_AT		},
+	{ 0x000000C1, 0x000000C2, CPU_PMC,	CPU_P6_CX_AT_NE		},
+	{ 0x000000C3, 0x000000C4, CPU_PMC,	CPU_INTEL_NEHALEM	},
 	{ 0x000000CD, 0x000000CD, CPU_FREQ,	CPU_CX_AT		},
-	{ 0x000000E7, 0x000000E8, CPU_PERF,	CPU_CX_AT		},
-	{ 0x000000FE, 0x000000FE, CPU_MTRR,	CPU_P6_CX_XE		},
+	{ 0x000000CE, 0x000000CE, CPU_PLATFORM,	CPU_INTEL_NEHALEM	},
+	{ 0x000000E7, 0x000000E8, CPU_PERF,	CPU_CX_AT_NE		},
+	{ 0x000000FE, 0x000000FE, CPU_MTRR,	CPU_P6_CX_XE_NE		},
 
 	{ 0x00000116, 0x00000116, CPU_CACHE,	CPU_INTEL_P6		},
 	{ 0x00000118, 0x00000118, CPU_CACHE,	CPU_INTEL_P6		},
@@ -115,66 +117,96 @@ static struct cpu_debug_range cpu_intel_range[] = {
 	{ 0x0000011A, 0x0000011B, CPU_CACHE,	CPU_INTEL_P6		},
 	{ 0x0000011E, 0x0000011E, CPU_CACHE,	CPU_PX_CX_AT		},
 
-	{ 0x00000174, 0x00000176, CPU_SYSENTER,	CPU_P6_CX_AT_XE		},
-	{ 0x00000179, 0x0000017A, CPU_MC,	CPU_PX_CX_AT_XE		},
+	{ 0x00000174, 0x00000176, CPU_SYSENTER,	CPU_P6_CX_AT_XE_NE	},
+	{ 0x00000179, 0x0000017A, CPU_MC,	CPU_PX_CX_AT_XE_NE	},
 	{ 0x0000017B, 0x0000017B, CPU_MC,	CPU_P6_XE		},
-	{ 0x00000186, 0x00000187, CPU_PMC,	CPU_P6_CX_AT		},
+	{ 0x00000186, 0x00000187, CPU_PMC,	CPU_P6_CX_AT_NE		},
+	{ 0x00000188, 0x00000189, CPU_PMC,	CPU_INTEL_NEHALEM	},
+	{ 0x00000186, 0x0000018A, CPU_MC,	CPU_INTEL_XEON		},
+	{ 0x00000190, 0x00000197, CPU_MC,	CPU_INTEL_XEON		},
 	{ 0x00000198, 0x00000199, CPU_PERF,	CPU_PM_CX_AT_XE		},
 	{ 0x0000019A, 0x0000019A, CPU_TIME,	CPU_PM_CX_AT_XE		},
-	{ 0x0000019B, 0x0000019D, CPU_THERM,	CPU_PM_CX_AT_XE		},
-	{ 0x000001A0, 0x000001A0, CPU_MISC,	CPU_PM_CX_AT_XE		},
-
-	{ 0x000001C9, 0x000001C9, CPU_LBRANCH,	CPU_PM_CX_AT		},
+	{ 0x0000019B, 0x0000019D, CPU_THERM,	CPU_PM_CX_AT_XE_NE	},
+	{ 0x000001A0, 0x000001A0, CPU_MISC,	CPU_PM_CX_AT_XE_NE	},
+	{ 0x000001A1, 0x000001A1, CPU_PLATFORM,	CPU_INTEL_XEON		},
+	{ 0x000001A2, 0x000001A2, CPU_THERM,	CPU_INTEL_NEHALEM	},
+	{ 0x000001A6, 0x000001A6, CPU_PMC,	CPU_INTEL_NEHALEM	},
+	{ 0x000001AD, 0x000001AD, CPU_FREQ,	CPU_INTEL_NEHALEM	},
+
+	{ 0x000001C8, 0x000001C8, CPU_LBRANCH,	CPU_INTEL_NEHALEM	},
+	{ 0x000001C9, 0x000001C9, CPU_LBRANCH,	CPU_PM_CX_AT_NE		},
 	{ 0x000001D7, 0x000001D8, CPU_LBRANCH,	CPU_INTEL_XEON		},
-	{ 0x000001D9, 0x000001D9, CPU_DEBUG,	CPU_CX_AT_XE		},
+	{ 0x000001D9, 0x000001D9, CPU_DEBUG,	CPU_PX_CX_AT_XE_NE	},
 	{ 0x000001DA, 0x000001DA, CPU_LBRANCH,	CPU_INTEL_XEON		},
 	{ 0x000001DB, 0x000001DB, CPU_LBRANCH,	CPU_P6_XE		},
 	{ 0x000001DC, 0x000001DC, CPU_LBRANCH,	CPU_INTEL_P6		},
-	{ 0x000001DD, 0x000001DE, CPU_LBRANCH,	CPU_PX_CX_AT_XE		},
+	{ 0x000001DD, 0x000001DE, CPU_LBRANCH,	CPU_PX_CX_AT_XE_NE	},
 	{ 0x000001E0, 0x000001E0, CPU_LBRANCH,	CPU_INTEL_P6		},
+	{ 0x000001F2, 0x000001F3, CPU_SM,	CPU_INTEL_NEHALEM	},
 
-	{ 0x00000200, 0x0000020F, CPU_MTRR,	CPU_P6_CX_XE		},
-	{ 0x00000250, 0x00000250, CPU_MTRR,	CPU_P6_CX_XE		},
-	{ 0x00000258, 0x00000259, CPU_MTRR,	CPU_P6_CX_XE		},
-	{ 0x00000268, 0x0000026F, CPU_MTRR,	CPU_P6_CX_XE		},
-	{ 0x00000277, 0x00000277, CPU_PAT,	CPU_C2_AT_XE		},
-	{ 0x000002FF, 0x000002FF, CPU_MTRR,	CPU_P6_CX_XE		},
+	{ 0x00000200, 0x0000020F, CPU_MTRR,	CPU_P6_CX_XE_NE		},
+	{ 0x00000250, 0x00000250, CPU_MTRR,	CPU_P6_CX_XE_NE		},
+	{ 0x00000258, 0x00000259, CPU_MTRR,	CPU_P6_CX_XE_NE		},
+	{ 0x00000268, 0x0000026F, CPU_MTRR,	CPU_P6_CX_XE_NE		},
+	{ 0x00000277, 0x00000277, CPU_PAT,	CPU_C2_AT_XE_NE		},
+	{ 0x000002FF, 0x000002FF, CPU_MTRR,	CPU_PX_CX_XE_NE		},
 
 	{ 0x00000300, 0x00000308, CPU_PMC,	CPU_INTEL_XEON		},
-	{ 0x00000309, 0x0000030B, CPU_PMC,	CPU_C2_AT_XE		},
+	{ 0x00000301, 0x00000301, CPU_MC,	CPU_INTEL_NEHALEM	},
+	{ 0x00000309, 0x0000030B, CPU_PMC,	CPU_C2_AT_XE_NE		},
 	{ 0x0000030C, 0x00000311, CPU_PMC,	CPU_INTEL_XEON		},
-	{ 0x00000345, 0x00000345, CPU_PMC,	CPU_C2_AT		},
+	{ 0x00000345, 0x00000345, CPU_PMC,	CPU_C2_AT_NE		},
 	{ 0x00000360, 0x00000371, CPU_PMC,	CPU_INTEL_XEON		},
-	{ 0x0000038D, 0x00000390, CPU_PMC,	CPU_C2_AT		},
+	{ 0x0000038D, 0x00000390, CPU_PMC,	CPU_C2_AT_NE		},
+	{ 0x00000391, 0x00000396, CPU_PMC,	CPU_INTEL_NEHALEM	},
 	{ 0x000003A0, 0x000003BE, CPU_PMC,	CPU_INTEL_XEON		},
+	{ 0x000003B0, 0x000003B7, CPU_PMC,	CPU_INTEL_NEHALEM	},
+	{ 0x000003C0, 0x000003C7, CPU_PMC,	CPU_INTEL_NEHALEM	},
 	{ 0x000003C0, 0x000003CD, CPU_PMC,	CPU_INTEL_XEON		},
 	{ 0x000003E0, 0x000003E1, CPU_PMC,	CPU_INTEL_XEON		},
 	{ 0x000003F0, 0x000003F0, CPU_PMC,	CPU_INTEL_XEON		},
-	{ 0x000003F1, 0x000003F1, CPU_PMC,	CPU_C2_AT_XE		},
+	{ 0x000003F1, 0x000003F1, CPU_PMC,	CPU_C2_AT_XE_NE		},
 	{ 0x000003F2, 0x000003F2, CPU_PMC,	CPU_INTEL_XEON		},
+	{ 0x000003F6, 0x000003F6, CPU_PMC,	CPU_INTEL_NEHALEM	},
+	{ 0x000003F8, 0x000003FA, CPU_MONITOR,	CPU_INTEL_NEHALEM	},
+	{ 0x000003FC, 0x000003FD, CPU_MONITOR,	CPU_INTEL_NEHALEM	},
 
-	{ 0x00000400, 0x00000402, CPU_MC,	CPU_PM_CX_AT_XE		},
+	{ 0x00000400, 0x00000402, CPU_MC,	CPU_PM_CX_AT_XE_NE	},
 	{ 0x00000403, 0x00000403, CPU_MC,	CPU_INTEL_XEON		},
-	{ 0x00000404, 0x00000406, CPU_MC,	CPU_PM_CX_AT_XE		},
+	{ 0x00000404, 0x00000406, CPU_MC,	CPU_PM_CX_AT_XE_NE	},
 	{ 0x00000407, 0x00000407, CPU_MC,	CPU_INTEL_XEON		},
-	{ 0x00000408, 0x0000040A, CPU_MC,	CPU_PM_CX_AT_XE		},
+	{ 0x00000408, 0x0000040A, CPU_MC,	CPU_PM_CX_AT_XE_NE	},
 	{ 0x0000040B, 0x0000040B, CPU_MC,	CPU_INTEL_XEON		},
-	{ 0x0000040C, 0x0000040E, CPU_MC,	CPU_PM_CX_XE		},
+	{ 0x0000040C, 0x0000040E, CPU_MC,	CPU_PM_CX_AT_XE_NE	},
 	{ 0x0000040F, 0x0000040F, CPU_MC,	CPU_INTEL_XEON		},
-	{ 0x00000410, 0x00000412, CPU_MC,	CPU_PM_CX_AT_XE		},
+	{ 0x00000410, 0x00000412, CPU_MC,	CPU_PM_CX_AT_XE_NE	},
 	{ 0x00000413, 0x00000417, CPU_MC,	CPU_CX_AT_XE		},
-	{ 0x00000480, 0x0000048B, CPU_VMX,	CPU_CX_AT_XE		},
+	{ 0x00000419, 0x00000419, CPU_MC,	CPU_INTEL_XEON_7400	},
+	{ 0x0000041D, 0x0000041D, CPU_MC,	CPU_INTEL_NEHALEM	},
+	{ 0x00000421, 0x00000421, CPU_MC,	CPU_INTEL_NEHALEM	},
+	{ 0x00000480, 0x0000048B, CPU_VMX,	CPU_CX_AT_XE_NE		},
 
 	{ 0x00000600, 0x00000600, CPU_DEBUG,	CPU_PM_CX_AT_XE		},
-	{ 0x00000680, 0x0000068F, CPU_LBRANCH,	CPU_INTEL_XEON		},
-	{ 0x000006C0, 0x000006CF, CPU_LBRANCH,	CPU_INTEL_XEON		},
-
-	{ 0x000107CC, 0x000107D3, CPU_PMC,	CPU_INTEL_XEON_MP	},
-
-	{ 0xC0000080, 0xC0000080, CPU_FEATURES,	CPU_INTEL_XEON		},
-	{ 0xC0000081, 0xC0000082, CPU_CALL,	CPU_INTEL_XEON		},
-	{ 0xC0000084, 0xC0000084, CPU_CALL,	CPU_INTEL_XEON		},
-	{ 0xC0000100, 0xC0000102, CPU_BASE,	CPU_INTEL_XEON		},
+	{ 0x00000680, 0x0000068F, CPU_LBRANCH,	CPU_XEON_NE		},
+	{ 0x000006C0, 0x000006CF, CPU_LBRANCH,	CPU_XEON_NE		},
+
+	{ 0x00000802, 0x00000803, CPU_APIC,	CPU_INTEL_NEHALEM	},
+	{ 0x00000808, 0x00000808, CPU_APIC,	CPU_INTEL_NEHALEM	},
+	{ 0x0000080A, 0x0000080B, CPU_APIC,	CPU_INTEL_NEHALEM	},
+	{ 0x0000080D, 0x0000080D, CPU_APIC,	CPU_INTEL_NEHALEM	},
+	{ 0x0000080F, 0x00000828, CPU_APIC,	CPU_INTEL_NEHALEM	},
+	{ 0x0000082F, 0x0000082F, CPU_APIC,	CPU_INTEL_NEHALEM	},
+	{ 0x00000830, 0x00000830, CPU_APIC,	CPU_INTEL_NEHALEM	},
+	{ 0x00000832, 0x00000839, CPU_APIC,	CPU_INTEL_NEHALEM	},
+	{ 0x0000083E, 0x0000083F, CPU_APIC,	CPU_INTEL_NEHALEM	},
+
+	{ 0x000107CC, 0x000107D3, CPU_PMC,	CPU_XEON_MPX		},
+	{ 0x000107D8, 0x000107D8, CPU_PMC,	CPU_INTEL_XEON_7400	},
+
+	{ 0xC0000080, 0xC0000080, CPU_FEATURES,	CPU_CX_AT_XE_NE		},
+	{ 0xC0000081, 0xC0000082, CPU_CALL,	CPU_C2_AT_XE_NE		},
+	{ 0xC0000084, 0xC0000084, CPU_CALL,	CPU_C2_AT_XE_NE		},
+	{ 0xC0000100, 0xC0000102, CPU_BASE,	CPU_C2_AT_XE_NE		},
 };
 
 /* AMD Registers Range */
@@ -213,13 +245,13 @@ static struct cpu_debug_range cpu_amd_range[] = {
 	{ 0xC001001F, 0xC001001F, CPU_CONF,	CPU_K8_PLUS,		},
 	{ 0xC0010030, 0xC0010035, CPU_BIOS,	CPU_K8_PLUS,		},
 	{ 0xC0010044, 0xC0010048, CPU_MC,	CPU_K8_PLUS,		},
-	{ 0xC0010050, 0xC0010056, CPU_SMM,	CPU_K0F_PLUS,		},
+	{ 0xC0010050, 0xC0010056, CPU_SM,	CPU_K0F_PLUS,		},
 	{ 0xC0010058, 0xC0010058, CPU_CONF,	CPU_K10_PLUS,		},
 	{ 0xC0010060, 0xC0010060, CPU_CACHE,	CPU_AMD_11,		},
-	{ 0xC0010061, 0xC0010068, CPU_SMM,	CPU_K10_PLUS,		},
-	{ 0xC0010069, 0xC001006B, CPU_SMM,	CPU_AMD_11,		},
-	{ 0xC0010070, 0xC0010071, CPU_SMM,	CPU_K10_PLUS,		},
-	{ 0xC0010111, 0xC0010113, CPU_SMM,	CPU_K8_PLUS,		},
+	{ 0xC0010061, 0xC0010068, CPU_SM,	CPU_K10_PLUS,		},
+	{ 0xC0010069, 0xC001006B, CPU_SM,	CPU_AMD_11,		},
+	{ 0xC0010070, 0xC0010071, CPU_SM,	CPU_K10_PLUS,		},
+	{ 0xC0010111, 0xC0010113, CPU_SM,	CPU_K8_PLUS,		},
 	{ 0xC0010114, 0xC0010118, CPU_SVM,	CPU_K10_PLUS,		},
 	{ 0xC0010140, 0xC0010141, CPU_OSVM,	CPU_K10_PLUS,		},
 	{ 0xC0011022, 0xC0011023, CPU_CONF,	CPU_K10_PLUS,		},
@@ -257,9 +289,15 @@ static int get_intel_modelflag(unsigned model)
 	case 0x0617:
 		flag = CPU_INTEL_CORE2;
 		break;
+	case 0x061A:
+		flag = CPU_INTEL_NEHALEM_BIT;
+		break;
 	case 0x061C:
 		flag = CPU_INTEL_ATOM;
 		break;
+	case 0x061D:
+		flag = CPU_INTEL_XEON_7400;
+		break;
 	case 0x0F00:
 	case 0x0F01:
 	case 0x0F02:
@@ -312,16 +350,18 @@ static int get_amd_modelflag(unsigned model)
 
 static int get_cpu_modelflag(unsigned cpu)
 {
+	struct cpuinfo_x86 *cpui;
 	int flag;
 
-	flag = per_cpu(cpu_model, cpu);
+	cpui = &cpu_data(cpu);
+	flag = (cpui->x86 << 8) | cpui->x86_model;
 
-	switch (flag >> 16) {
+	switch (cpu_vendor) {
 	case X86_VENDOR_INTEL:
 		flag = get_intel_modelflag(flag);
 		break;
 	case X86_VENDOR_AMD:
-		flag = get_amd_modelflag(flag & 0xffff);
+		flag = get_amd_modelflag(flag);
 		break;
 	default:
 		flag = CPU_NONE;
@@ -335,7 +375,7 @@ static int get_cpu_range_count(unsigned cpu)
 {
 	int index;
 
-	switch (per_cpu(cpu_model, cpu) >> 16) {
+	switch (cpu_vendor) {
 	case X86_VENDOR_INTEL:
 		index = ARRAY_SIZE(cpu_intel_range);
 		break;
@@ -352,7 +392,7 @@ static int get_cpu_range_count(unsigned cpu)
 
 static int is_typeflag_valid(unsigned cpu, unsigned flag)
 {
-	unsigned vendor, modelflag;
+	unsigned modelflag;
 	int i, index;
 
 	/* Standard Registers should be always valid */
@@ -360,11 +400,10 @@ static int is_typeflag_valid(unsigned cpu, unsigned flag)
 		return 1;
 
 	modelflag = per_cpu(cpu_modelflag, cpu);
-	vendor = per_cpu(cpu_model, cpu) >> 16;
 	index = get_cpu_range_count(cpu);
 
 	for (i = 0; i < index; i++) {
-		switch (vendor) {
+		switch (cpu_vendor) {
 		case X86_VENDOR_INTEL:
 			if ((cpu_intel_range[i].model & modelflag) &&
 			    (cpu_intel_range[i].flag & flag))
@@ -389,7 +428,7 @@ static unsigned get_cpu_range(unsigned cpu, unsigned *min, unsigned *max,
 
 	modelflag = per_cpu(cpu_modelflag, cpu);
 	*max = 0;
-	switch (per_cpu(cpu_model, cpu) >> 16) {
+	switch (cpu_vendor) {
 	case X86_VENDOR_INTEL:
 		if ((cpu_intel_range[index].model & modelflag) &&
 		    (cpu_intel_range[index].flag & flag)) {
@@ -838,6 +877,17 @@ static int cpu_init_allreg(unsigned cpu, struct dentry *dentry)
 	return err;
 }
 
+/*
+ * Prepare report for LKML and maintainer if files count are inappropriate
+ * Or CPU is not supported
+ */
+static void send_report(int files, struct cpuinfo_x86 *cpui)
+{
+	WARN_ONCE(1, "Please report \"cpu_debug files %d for %x:%x:%x:%x\" to"
+		  " %s\n", files, cpui->x86_vendor, cpui->x86, cpui->x86_model,
+		  cpui->x86_mask, EMAIL);
+}
+
 static int cpu_init_cpu(void)
 {
 	struct dentry *cpu_dentry = NULL;
@@ -846,14 +896,16 @@ static int cpu_init_cpu(void)
 	unsigned cpu;
 	int err = 0;
 
+	/* Assuming vendor will be same for all CPUs */
+	cpu_vendor = boot_cpu_data.x86_vendor;
+
 	for (cpu = 0; cpu < nr_cpu_ids; cpu++) {
 		cpui = &cpu_data(cpu);
 		if (!cpu_has(cpui, X86_FEATURE_MSR))
 			continue;
-		per_cpu(cpu_model, cpu) = ((cpui->x86_vendor << 16) |
-					   (cpui->x86 << 8) |
-					   (cpui->x86_model));
 		per_cpu(cpu_modelflag, cpu) = get_cpu_modelflag(cpu);
+		if (!per_cpu(cpu_modelflag, cpu))
+			send_report(per_cpu(cpu_priv_count, cpu), cpui);
 
 		sprintf(cpu_dir, "cpu%d", cpu);
 		cpu_dentry = debugfs_create_dir(cpu_dir, cpu_debugfs_dir);
@@ -864,6 +916,7 @@ static int cpu_init_cpu(void)
 		if (per_cpu(cpu_priv_count, cpu) > MAX_CPU_FILES) {
 			pr_err("Register files count %d exceeds limit %d\n",
 				per_cpu(cpu_priv_count, cpu), MAX_CPU_FILES);
+			send_report(per_cpu(cpu_priv_count, cpu), cpui);
 			per_cpu(cpu_priv_count, cpu) = MAX_CPU_FILES;
 			err = -ENFILE;
 		}


