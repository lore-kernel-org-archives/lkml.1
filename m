Return-Path: <linux-kernel-owner+w=401wt.eu-S1762313AbZFJVPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762313AbZFJVPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759131AbZFJVPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:15:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45128 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756500AbZFJVPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:15:16 -0400
Date: Wed, 10 Jun 2009 23:15:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cpu for v2.6.31
Message-ID: <20090610211506.GA5828@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-cpu-for-linus

 Thanks,

	Ingo

------------------>
Andreas Herrmann (5):
      x86: cacheinfo: use L3 cache index disable feature only for CPUs that support it
      x86: cacheinfo: correct return value when cache_disable feature is not active
      x86: cacheinfo: use cached K8 NB_MISC devices instead of scanning for it
      x86: cacheinfo: complete L2/L3 Cache and TLB associativity field definitions
      x86: fixup numa_node information for AMD CPU northbridge functions

Jaswinder Singh Rajput (2):
      x86: k8 convert node_to_k8_nb_misc() from a macro to an inline function
      x86: cpu_debug: Remove model information to reduce encoding-decoding

Mark Langsdorf (3):
      x86: cacheinfo: replace sysfs interface for cache_disable feature
      x86: cacheinfo: disable L3 ECC scrubbing when L3 cache index is disabled
      x86/docs: add description for cache_disable sysfs interface


 .../ABI/testing/sysfs-devices-cache_disable        |   18 +
 arch/x86/include/asm/cpu_debug.h                   |  101 +-----
 arch/x86/include/asm/k8.h                          |   13 +
 arch/x86/kernel/cpu/cpu_debug.c                    |  417 +++++---------------
 arch/x86/kernel/cpu/intel_cacheinfo.c              |  153 ++++----
 arch/x86/kernel/quirks.c                           |   37 ++
 6 files changed, 237 insertions(+), 502 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-cache_disable

diff --git a/Documentation/ABI/testing/sysfs-devices-cache_disable b/Documentation/ABI/testing/sysfs-devices-cache_disable
new file mode 100644
index 0000000..175bb4f
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-devices-cache_disable
@@ -0,0 +1,18 @@
+What:      /sys/devices/system/cpu/cpu*/cache/index*/cache_disable_X
+Date:      August 2008
+KernelVersion:	2.6.27
+Contact:	mark.langsdorf@amd.com
+Description:	These files exist in every cpu's cache index directories.
+		There are currently 2 cache_disable_# files in each
+		directory.  Reading from these files on a supported
+		processor will return that cache disable index value
+		for that processor and node.  Writing to one of these
+		files will cause the specificed cache index to be disabled.
+
+		Currently, only AMD Family 10h Processors support cache index
+		disable, and only for their L3 caches.  See the BIOS and
+		Kernel Developer's Guide at
+		http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/31116-Public-GH-BKDG_3.20_2-4-09.pdf
+		for formatting information and other details on the
+		cache index disable.
+Users:    joachim.deguara@amd.com
diff --git a/arch/x86/include/asm/cpu_debug.h b/arch/x86/include/asm/cpu_debug.h
index 2228020..d96c1ee 100644
--- a/arch/x86/include/asm/cpu_debug.h
+++ b/arch/x86/include/asm/cpu_debug.h
@@ -86,105 +86,7 @@ enum cpu_file_bit {
 	CPU_VALUE_BIT,				/* value		*/
 };
 
-#define	CPU_FILE_VALUE			(1 << CPU_VALUE_BIT)
-
-/*
- * DisplayFamily_DisplayModel	Processor Families/Processor Number Series
- * --------------------------	------------------------------------------
- * 05_01, 05_02, 05_04		Pentium, Pentium with MMX
- *
- * 06_01			Pentium Pro
- * 06_03, 06_05			Pentium II Xeon, Pentium II
- * 06_07, 06_08, 06_0A, 06_0B	Pentium III Xeon, Pentum III
- *
- * 06_09, 060D			Pentium M
- *
- * 06_0E			Core Duo, Core Solo
- *
- * 06_0F			Xeon 3000, 3200, 5100, 5300, 7300 series,
- *				Core 2 Quad, Core 2 Extreme, Core 2 Duo,
- *				Pentium dual-core
- * 06_17			Xeon 5200, 5400 series, Core 2 Quad Q9650
- *
- * 06_1C			Atom
- *
- * 0F_00, 0F_01, 0F_02		Xeon, Xeon MP, Pentium 4
- * 0F_03, 0F_04			Xeon, Xeon MP, Pentium 4, Pentium D
- *
- * 0F_06			Xeon 7100, 5000 Series, Xeon MP,
- *				Pentium 4, Pentium D
- */
-
-/* Register processors bits */
-enum cpu_processor_bit {
-	CPU_NONE,
-/* Intel */
-	CPU_INTEL_PENTIUM_BIT,
-	CPU_INTEL_P6_BIT,
-	CPU_INTEL_PENTIUM_M_BIT,
-	CPU_INTEL_CORE_BIT,
-	CPU_INTEL_CORE2_BIT,
-	CPU_INTEL_ATOM_BIT,
-	CPU_INTEL_XEON_P4_BIT,
-	CPU_INTEL_XEON_MP_BIT,
-/* AMD */
-	CPU_AMD_K6_BIT,
-	CPU_AMD_K7_BIT,
-	CPU_AMD_K8_BIT,
-	CPU_AMD_0F_BIT,
-	CPU_AMD_10_BIT,
-	CPU_AMD_11_BIT,
-};
-
-#define	CPU_INTEL_PENTIUM	(1 << CPU_INTEL_PENTIUM_BIT)
-#define	CPU_INTEL_P6		(1 << CPU_INTEL_P6_BIT)
-#define	CPU_INTEL_PENTIUM_M	(1 << CPU_INTEL_PENTIUM_M_BIT)
-#define	CPU_INTEL_CORE		(1 << CPU_INTEL_CORE_BIT)
-#define	CPU_INTEL_CORE2		(1 << CPU_INTEL_CORE2_BIT)
-#define	CPU_INTEL_ATOM		(1 << CPU_INTEL_ATOM_BIT)
-#define	CPU_INTEL_XEON_P4	(1 << CPU_INTEL_XEON_P4_BIT)
-#define	CPU_INTEL_XEON_MP	(1 << CPU_INTEL_XEON_MP_BIT)
-
-#define	CPU_INTEL_PX		(CPU_INTEL_P6 | CPU_INTEL_PENTIUM_M)
-#define	CPU_INTEL_COREX		(CPU_INTEL_CORE | CPU_INTEL_CORE2)
-#define	CPU_INTEL_XEON		(CPU_INTEL_XEON_P4 | CPU_INTEL_XEON_MP)
-#define	CPU_CO_AT		(CPU_INTEL_CORE | CPU_INTEL_ATOM)
-#define	CPU_C2_AT		(CPU_INTEL_CORE2 | CPU_INTEL_ATOM)
-#define	CPU_CX_AT		(CPU_INTEL_COREX | CPU_INTEL_ATOM)
-#define	CPU_CX_XE		(CPU_INTEL_COREX | CPU_INTEL_XEON)
-#define	CPU_P6_XE		(CPU_INTEL_P6 | CPU_INTEL_XEON)
-#define	CPU_PM_CO_AT		(CPU_INTEL_PENTIUM_M | CPU_CO_AT)
-#define	CPU_C2_AT_XE		(CPU_C2_AT | CPU_INTEL_XEON)
-#define	CPU_CX_AT_XE		(CPU_CX_AT | CPU_INTEL_XEON)
-#define	CPU_P6_CX_AT		(CPU_INTEL_P6 | CPU_CX_AT)
-#define	CPU_P6_CX_XE		(CPU_P6_XE | CPU_INTEL_COREX)
-#define	CPU_P6_CX_AT_XE		(CPU_INTEL_P6 | CPU_CX_AT_XE)
-#define	CPU_PM_CX_AT_XE		(CPU_INTEL_PENTIUM_M | CPU_CX_AT_XE)
-#define	CPU_PM_CX_AT		(CPU_INTEL_PENTIUM_M | CPU_CX_AT)
-#define	CPU_PM_CX_XE		(CPU_INTEL_PENTIUM_M | CPU_CX_XE)
-#define	CPU_PX_CX_AT		(CPU_INTEL_PX | CPU_CX_AT)
-#define	CPU_PX_CX_AT_XE		(CPU_INTEL_PX | CPU_CX_AT_XE)
-
-/* Select all supported Intel CPUs */
-#define	CPU_INTEL_ALL		(CPU_INTEL_PENTIUM | CPU_PX_CX_AT_XE)
-
-#define	CPU_AMD_K6		(1 << CPU_AMD_K6_BIT)
-#define	CPU_AMD_K7		(1 << CPU_AMD_K7_BIT)
-#define	CPU_AMD_K8		(1 << CPU_AMD_K8_BIT)
-#define	CPU_AMD_0F		(1 << CPU_AMD_0F_BIT)
-#define	CPU_AMD_10		(1 << CPU_AMD_10_BIT)
-#define	CPU_AMD_11		(1 << CPU_AMD_11_BIT)
-
-#define	CPU_K10_PLUS		(CPU_AMD_10 | CPU_AMD_11)
-#define	CPU_K0F_PLUS		(CPU_AMD_0F | CPU_K10_PLUS)
-#define	CPU_K8_PLUS		(CPU_AMD_K8 | CPU_K0F_PLUS)
-#define	CPU_K7_PLUS		(CPU_AMD_K7 | CPU_K8_PLUS)
-
-/* Select all supported AMD CPUs */
-#define	CPU_AMD_ALL		(CPU_AMD_K6 | CPU_K7_PLUS)
-
-/* Select all supported CPUs */
-#define	CPU_ALL			(CPU_INTEL_ALL | CPU_AMD_ALL)
+#define	CPU_FILE_VALUE		(1 << CPU_VALUE_BIT)
 
 #define MAX_CPU_FILES		512
 
@@ -220,7 +122,6 @@ struct cpu_debug_range {
 	unsigned		min;		/* Register range min	*/
 	unsigned		max;		/* Register range max	*/
 	unsigned		flag;		/* Supported flags	*/
-	unsigned		model;		/* Supported models	*/
 };
 
 #endif /* _ASM_X86_CPU_DEBUG_H */
diff --git a/arch/x86/include/asm/k8.h b/arch/x86/include/asm/k8.h
index 54c8cc5..c2d1f3b 100644
--- a/arch/x86/include/asm/k8.h
+++ b/arch/x86/include/asm/k8.h
@@ -12,4 +12,17 @@ extern int cache_k8_northbridges(void);
 extern void k8_flush_garts(void);
 extern int k8_scan_nodes(unsigned long start, unsigned long end);
 
+#ifdef CONFIG_K8_NB
+static inline struct pci_dev *node_to_k8_nb_misc(int node)
+{
+	return (node < num_k8_northbridges) ? k8_northbridges[node] : NULL;
+}
+#else
+static inline struct pci_dev *node_to_k8_nb_misc(int node)
+{
+	return NULL;
+}
+#endif
+
+
 #endif /* _ASM_X86_K8_H */
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
index 46e29ab..86afe13 100644
--- a/arch/x86/kernel/cpu/cpu_debug.c
+++ b/arch/x86/kernel/cpu/cpu_debug.c
@@ -32,9 +32,7 @@
 
 static DEFINE_PER_CPU(struct cpu_cpuX_base, cpu_arr[CPU_REG_ALL_BIT]);
 static DEFINE_PER_CPU(struct cpu_private *, priv_arr[MAX_CPU_FILES]);
-static DEFINE_PER_CPU(unsigned, cpu_modelflag);
 static DEFINE_PER_CPU(int, cpu_priv_count);
-static DEFINE_PER_CPU(unsigned, cpu_model);
 
 static DEFINE_MUTEX(cpu_debug_lock);
 
@@ -80,302 +78,102 @@ static struct cpu_file_base cpu_file[] = {
 	{ "value",	CPU_REG_ALL,	1	},
 };
 
-/* Intel Registers Range */
-static struct cpu_debug_range cpu_intel_range[] = {
-	{ 0x00000000, 0x00000001, CPU_MC,	CPU_INTEL_ALL		},
-	{ 0x00000006, 0x00000007, CPU_MONITOR,	CPU_CX_AT_XE		},
-	{ 0x00000010, 0x00000010, CPU_TIME,	CPU_INTEL_ALL		},
-	{ 0x00000011, 0x00000013, CPU_PMC,	CPU_INTEL_PENTIUM	},
-	{ 0x00000017, 0x00000017, CPU_PLATFORM,	CPU_PX_CX_AT_XE		},
-	{ 0x0000001B, 0x0000001B, CPU_APIC,	CPU_P6_CX_AT_XE		},
-
-	{ 0x0000002A, 0x0000002A, CPU_POWERON,	CPU_PX_CX_AT_XE		},
-	{ 0x0000002B, 0x0000002B, CPU_POWERON,	CPU_INTEL_XEON		},
-	{ 0x0000002C, 0x0000002C, CPU_FREQ,	CPU_INTEL_XEON		},
-	{ 0x0000003A, 0x0000003A, CPU_CONTROL,	CPU_CX_AT_XE		},
-
-	{ 0x00000040, 0x00000043, CPU_LBRANCH,	CPU_PM_CX_AT_XE		},
-	{ 0x00000044, 0x00000047, CPU_LBRANCH,	CPU_PM_CO_AT		},
-	{ 0x00000060, 0x00000063, CPU_LBRANCH,	CPU_C2_AT		},
-	{ 0x00000064, 0x00000067, CPU_LBRANCH,	CPU_INTEL_ATOM		},
-
-	{ 0x00000079, 0x00000079, CPU_BIOS,	CPU_P6_CX_AT_XE		},
-	{ 0x00000088, 0x0000008A, CPU_CACHE,	CPU_INTEL_P6		},
-	{ 0x0000008B, 0x0000008B, CPU_BIOS,	CPU_P6_CX_AT_XE		},
-	{ 0x0000009B, 0x0000009B, CPU_MONITOR,	CPU_INTEL_XEON		},
-
-	{ 0x000000C1, 0x000000C2, CPU_PMC,	CPU_P6_CX_AT		},
-	{ 0x000000CD, 0x000000CD, CPU_FREQ,	CPU_CX_AT		},
-	{ 0x000000E7, 0x000000E8, CPU_PERF,	CPU_CX_AT		},
-	{ 0x000000FE, 0x000000FE, CPU_MTRR,	CPU_P6_CX_XE		},
-
-	{ 0x00000116, 0x00000116, CPU_CACHE,	CPU_INTEL_P6		},
-	{ 0x00000118, 0x00000118, CPU_CACHE,	CPU_INTEL_P6		},
-	{ 0x00000119, 0x00000119, CPU_CACHE,	CPU_INTEL_PX		},
-	{ 0x0000011A, 0x0000011B, CPU_CACHE,	CPU_INTEL_P6		},
-	{ 0x0000011E, 0x0000011E, CPU_CACHE,	CPU_PX_CX_AT		},
-
-	{ 0x00000174, 0x00000176, CPU_SYSENTER,	CPU_P6_CX_AT_XE		},
-	{ 0x00000179, 0x0000017A, CPU_MC,	CPU_PX_CX_AT_XE		},
-	{ 0x0000017B, 0x0000017B, CPU_MC,	CPU_P6_XE		},
-	{ 0x00000186, 0x00000187, CPU_PMC,	CPU_P6_CX_AT		},
-	{ 0x00000198, 0x00000199, CPU_PERF,	CPU_PM_CX_AT_XE		},
-	{ 0x0000019A, 0x0000019A, CPU_TIME,	CPU_PM_CX_AT_XE		},
-	{ 0x0000019B, 0x0000019D, CPU_THERM,	CPU_PM_CX_AT_XE		},
-	{ 0x000001A0, 0x000001A0, CPU_MISC,	CPU_PM_CX_AT_XE		},
-
-	{ 0x000001C9, 0x000001C9, CPU_LBRANCH,	CPU_PM_CX_AT		},
-	{ 0x000001D7, 0x000001D8, CPU_LBRANCH,	CPU_INTEL_XEON		},
-	{ 0x000001D9, 0x000001D9, CPU_DEBUG,	CPU_CX_AT_XE		},
-	{ 0x000001DA, 0x000001DA, CPU_LBRANCH,	CPU_INTEL_XEON		},
-	{ 0x000001DB, 0x000001DB, CPU_LBRANCH,	CPU_P6_XE		},
-	{ 0x000001DC, 0x000001DC, CPU_LBRANCH,	CPU_INTEL_P6		},
-	{ 0x000001DD, 0x000001DE, CPU_LBRANCH,	CPU_PX_CX_AT_XE		},
-	{ 0x000001E0, 0x000001E0, CPU_LBRANCH,	CPU_INTEL_P6		},
-
-	{ 0x00000200, 0x0000020F, CPU_MTRR,	CPU_P6_CX_XE		},
-	{ 0x00000250, 0x00000250, CPU_MTRR,	CPU_P6_CX_XE		},
-	{ 0x00000258, 0x00000259, CPU_MTRR,	CPU_P6_CX_XE		},
-	{ 0x00000268, 0x0000026F, CPU_MTRR,	CPU_P6_CX_XE		},
-	{ 0x00000277, 0x00000277, CPU_PAT,	CPU_C2_AT_XE		},
-	{ 0x000002FF, 0x000002FF, CPU_MTRR,	CPU_P6_CX_XE		},
-
-	{ 0x00000300, 0x00000308, CPU_PMC,	CPU_INTEL_XEON		},
-	{ 0x00000309, 0x0000030B, CPU_PMC,	CPU_C2_AT_XE		},
-	{ 0x0000030C, 0x00000311, CPU_PMC,	CPU_INTEL_XEON		},
-	{ 0x00000345, 0x00000345, CPU_PMC,	CPU_C2_AT		},
-	{ 0x00000360, 0x00000371, CPU_PMC,	CPU_INTEL_XEON		},
-	{ 0x0000038D, 0x00000390, CPU_PMC,	CPU_C2_AT		},
-	{ 0x000003A0, 0x000003BE, CPU_PMC,	CPU_INTEL_XEON		},
-	{ 0x000003C0, 0x000003CD, CPU_PMC,	CPU_INTEL_XEON		},
-	{ 0x000003E0, 0x000003E1, CPU_PMC,	CPU_INTEL_XEON		},
-	{ 0x000003F0, 0x000003F0, CPU_PMC,	CPU_INTEL_XEON		},
-	{ 0x000003F1, 0x000003F1, CPU_PMC,	CPU_C2_AT_XE		},
-	{ 0x000003F2, 0x000003F2, CPU_PMC,	CPU_INTEL_XEON		},
-
-	{ 0x00000400, 0x00000402, CPU_MC,	CPU_PM_CX_AT_XE		},
-	{ 0x00000403, 0x00000403, CPU_MC,	CPU_INTEL_XEON		},
-	{ 0x00000404, 0x00000406, CPU_MC,	CPU_PM_CX_AT_XE		},
-	{ 0x00000407, 0x00000407, CPU_MC,	CPU_INTEL_XEON		},
-	{ 0x00000408, 0x0000040A, CPU_MC,	CPU_PM_CX_AT_XE		},
-	{ 0x0000040B, 0x0000040B, CPU_MC,	CPU_INTEL_XEON		},
-	{ 0x0000040C, 0x0000040E, CPU_MC,	CPU_PM_CX_XE		},
-	{ 0x0000040F, 0x0000040F, CPU_MC,	CPU_INTEL_XEON		},
-	{ 0x00000410, 0x00000412, CPU_MC,	CPU_PM_CX_AT_XE		},
-	{ 0x00000413, 0x00000417, CPU_MC,	CPU_CX_AT_XE		},
-	{ 0x00000480, 0x0000048B, CPU_VMX,	CPU_CX_AT_XE		},
-
-	{ 0x00000600, 0x00000600, CPU_DEBUG,	CPU_PM_CX_AT_XE		},
-	{ 0x00000680, 0x0000068F, CPU_LBRANCH,	CPU_INTEL_XEON		},
-	{ 0x000006C0, 0x000006CF, CPU_LBRANCH,	CPU_INTEL_XEON		},
-
-	{ 0x000107CC, 0x000107D3, CPU_PMC,	CPU_INTEL_XEON_MP	},
-
-	{ 0xC0000080, 0xC0000080, CPU_FEATURES,	CPU_INTEL_XEON		},
-	{ 0xC0000081, 0xC0000082, CPU_CALL,	CPU_INTEL_XEON		},
-	{ 0xC0000084, 0xC0000084, CPU_CALL,	CPU_INTEL_XEON		},
-	{ 0xC0000100, 0xC0000102, CPU_BASE,	CPU_INTEL_XEON		},
+/* CPU Registers Range */
+static struct cpu_debug_range cpu_reg_range[] = {
+	{ 0x00000000, 0x00000001, CPU_MC,	},
+	{ 0x00000006, 0x00000007, CPU_MONITOR,	},
+	{ 0x00000010, 0x00000010, CPU_TIME,	},
+	{ 0x00000011, 0x00000013, CPU_PMC,	},
+	{ 0x00000017, 0x00000017, CPU_PLATFORM,	},
+	{ 0x0000001B, 0x0000001B, CPU_APIC,	},
+	{ 0x0000002A, 0x0000002B, CPU_POWERON,	},
+	{ 0x0000002C, 0x0000002C, CPU_FREQ,	},
+	{ 0x0000003A, 0x0000003A, CPU_CONTROL,	},
+	{ 0x00000040, 0x00000047, CPU_LBRANCH,	},
+	{ 0x00000060, 0x00000067, CPU_LBRANCH,	},
+	{ 0x00000079, 0x00000079, CPU_BIOS,	},
+	{ 0x00000088, 0x0000008A, CPU_CACHE,	},
+	{ 0x0000008B, 0x0000008B, CPU_BIOS,	},
+	{ 0x0000009B, 0x0000009B, CPU_MONITOR,	},
+	{ 0x000000C1, 0x000000C4, CPU_PMC,	},
+	{ 0x000000CD, 0x000000CD, CPU_FREQ,	},
+	{ 0x000000E7, 0x000000E8, CPU_PERF,	},
+	{ 0x000000FE, 0x000000FE, CPU_MTRR,	},
+
+	{ 0x00000116, 0x0000011E, CPU_CACHE,	},
+	{ 0x00000174, 0x00000176, CPU_SYSENTER,	},
+	{ 0x00000179, 0x0000017B, CPU_MC,	},
+	{ 0x00000186, 0x00000189, CPU_PMC,	},
+	{ 0x00000198, 0x00000199, CPU_PERF,	},
+	{ 0x0000019A, 0x0000019A, CPU_TIME,	},
+	{ 0x0000019B, 0x0000019D, CPU_THERM,	},
+	{ 0x000001A0, 0x000001A0, CPU_MISC,	},
+	{ 0x000001C9, 0x000001C9, CPU_LBRANCH,	},
+	{ 0x000001D7, 0x000001D8, CPU_LBRANCH,	},
+	{ 0x000001D9, 0x000001D9, CPU_DEBUG,	},
+	{ 0x000001DA, 0x000001E0, CPU_LBRANCH,	},
+
+	{ 0x00000200, 0x0000020F, CPU_MTRR,	},
+	{ 0x00000250, 0x00000250, CPU_MTRR,	},
+	{ 0x00000258, 0x00000259, CPU_MTRR,	},
+	{ 0x00000268, 0x0000026F, CPU_MTRR,	},
+	{ 0x00000277, 0x00000277, CPU_PAT,	},
+	{ 0x000002FF, 0x000002FF, CPU_MTRR,	},
+
+	{ 0x00000300, 0x00000311, CPU_PMC,	},
+	{ 0x00000345, 0x00000345, CPU_PMC,	},
+	{ 0x00000360, 0x00000371, CPU_PMC,	},
+	{ 0x0000038D, 0x00000390, CPU_PMC,	},
+	{ 0x000003A0, 0x000003BE, CPU_PMC,	},
+	{ 0x000003C0, 0x000003CD, CPU_PMC,	},
+	{ 0x000003E0, 0x000003E1, CPU_PMC,	},
+	{ 0x000003F0, 0x000003F2, CPU_PMC,	},
+
+	{ 0x00000400, 0x00000417, CPU_MC,	},
+	{ 0x00000480, 0x0000048B, CPU_VMX,	},
+
+	{ 0x00000600, 0x00000600, CPU_DEBUG,	},
+	{ 0x00000680, 0x0000068F, CPU_LBRANCH,	},
+	{ 0x000006C0, 0x000006CF, CPU_LBRANCH,	},
+
+	{ 0x000107CC, 0x000107D3, CPU_PMC,	},
+
+	{ 0xC0000080, 0xC0000080, CPU_FEATURES,	},
+	{ 0xC0000081, 0xC0000084, CPU_CALL,	},
+	{ 0xC0000100, 0xC0000102, CPU_BASE,	},
+	{ 0xC0000103, 0xC0000103, CPU_TIME,	},
+
+	{ 0xC0010000, 0xC0010007, CPU_PMC,	},
+	{ 0xC0010010, 0xC0010010, CPU_CONF,	},
+	{ 0xC0010015, 0xC0010015, CPU_CONF,	},
+	{ 0xC0010016, 0xC001001A, CPU_MTRR,	},
+	{ 0xC001001D, 0xC001001D, CPU_MTRR,	},
+	{ 0xC001001F, 0xC001001F, CPU_CONF,	},
+	{ 0xC0010030, 0xC0010035, CPU_BIOS,	},
+	{ 0xC0010044, 0xC0010048, CPU_MC,	},
+	{ 0xC0010050, 0xC0010056, CPU_SMM,	},
+	{ 0xC0010058, 0xC0010058, CPU_CONF,	},
+	{ 0xC0010060, 0xC0010060, CPU_CACHE,	},
+	{ 0xC0010061, 0xC0010068, CPU_SMM,	},
+	{ 0xC0010069, 0xC001006B, CPU_SMM,	},
+	{ 0xC0010070, 0xC0010071, CPU_SMM,	},
+	{ 0xC0010111, 0xC0010113, CPU_SMM,	},
+	{ 0xC0010114, 0xC0010118, CPU_SVM,	},
+	{ 0xC0010140, 0xC0010141, CPU_OSVM,	},
+	{ 0xC0011022, 0xC0011023, CPU_CONF,	},
 };
 
-/* AMD Registers Range */
-static struct cpu_debug_range cpu_amd_range[] = {
-	{ 0x00000000, 0x00000001, CPU_MC,	CPU_K10_PLUS,		},
-	{ 0x00000010, 0x00000010, CPU_TIME,	CPU_K8_PLUS,		},
-	{ 0x0000001B, 0x0000001B, CPU_APIC,	CPU_K8_PLUS,		},
-	{ 0x0000002A, 0x0000002A, CPU_POWERON,	CPU_K7_PLUS		},
-	{ 0x0000008B, 0x0000008B, CPU_VER,	CPU_K8_PLUS		},
-	{ 0x000000FE, 0x000000FE, CPU_MTRR,	CPU_K8_PLUS,		},
-
-	{ 0x00000174, 0x00000176, CPU_SYSENTER,	CPU_K8_PLUS,		},
-	{ 0x00000179, 0x0000017B, CPU_MC,	CPU_K8_PLUS,		},
-	{ 0x000001D9, 0x000001D9, CPU_DEBUG,	CPU_K8_PLUS,		},
-	{ 0x000001DB, 0x000001DE, CPU_LBRANCH,	CPU_K8_PLUS,		},
-
-	{ 0x00000200, 0x0000020F, CPU_MTRR,	CPU_K8_PLUS,		},
-	{ 0x00000250, 0x00000250, CPU_MTRR,	CPU_K8_PLUS,		},
-	{ 0x00000258, 0x00000259, CPU_MTRR,	CPU_K8_PLUS,		},
-	{ 0x00000268, 0x0000026F, CPU_MTRR,	CPU_K8_PLUS,		},
-	{ 0x00000277, 0x00000277, CPU_PAT,	CPU_K8_PLUS,		},
-	{ 0x000002FF, 0x000002FF, CPU_MTRR,	CPU_K8_PLUS,		},
-
-	{ 0x00000400, 0x00000413, CPU_MC,	CPU_K8_PLUS,		},
-
-	{ 0xC0000080, 0xC0000080, CPU_FEATURES,	CPU_AMD_ALL,		},
-	{ 0xC0000081, 0xC0000084, CPU_CALL,	CPU_K8_PLUS,		},
-	{ 0xC0000100, 0xC0000102, CPU_BASE,	CPU_K8_PLUS,		},
-	{ 0xC0000103, 0xC0000103, CPU_TIME,	CPU_K10_PLUS,		},
-
-	{ 0xC0010000, 0xC0010007, CPU_PMC,	CPU_K8_PLUS,		},
-	{ 0xC0010010, 0xC0010010, CPU_CONF,	CPU_K7_PLUS,		},
-	{ 0xC0010015, 0xC0010015, CPU_CONF,	CPU_K7_PLUS,		},
-	{ 0xC0010016, 0xC001001A, CPU_MTRR,	CPU_K8_PLUS,		},
-	{ 0xC001001D, 0xC001001D, CPU_MTRR,	CPU_K8_PLUS,		},
-	{ 0xC001001F, 0xC001001F, CPU_CONF,	CPU_K8_PLUS,		},
-	{ 0xC0010030, 0xC0010035, CPU_BIOS,	CPU_K8_PLUS,		},
-	{ 0xC0010044, 0xC0010048, CPU_MC,	CPU_K8_PLUS,		},
-	{ 0xC0010050, 0xC0010056, CPU_SMM,	CPU_K0F_PLUS,		},
-	{ 0xC0010058, 0xC0010058, CPU_CONF,	CPU_K10_PLUS,		},
-	{ 0xC0010060, 0xC0010060, CPU_CACHE,	CPU_AMD_11,		},
-	{ 0xC0010061, 0xC0010068, CPU_SMM,	CPU_K10_PLUS,		},
-	{ 0xC0010069, 0xC001006B, CPU_SMM,	CPU_AMD_11,		},
-	{ 0xC0010070, 0xC0010071, CPU_SMM,	CPU_K10_PLUS,		},
-	{ 0xC0010111, 0xC0010113, CPU_SMM,	CPU_K8_PLUS,		},
-	{ 0xC0010114, 0xC0010118, CPU_SVM,	CPU_K10_PLUS,		},
-	{ 0xC0010140, 0xC0010141, CPU_OSVM,	CPU_K10_PLUS,		},
-	{ 0xC0011022, 0xC0011023, CPU_CONF,	CPU_K10_PLUS,		},
-};
-
-
-/* Intel */
-static int get_intel_modelflag(unsigned model)
-{
-	int flag;
-
-	switch (model) {
-	case 0x0501:
-	case 0x0502:
-	case 0x0504:
-		flag = CPU_INTEL_PENTIUM;
-		break;
-	case 0x0601:
-	case 0x0603:
-	case 0x0605:
-	case 0x0607:
-	case 0x0608:
-	case 0x060A:
-	case 0x060B:
-		flag = CPU_INTEL_P6;
-		break;
-	case 0x0609:
-	case 0x060D:
-		flag = CPU_INTEL_PENTIUM_M;
-		break;
-	case 0x060E:
-		flag = CPU_INTEL_CORE;
-		break;
-	case 0x060F:
-	case 0x0617:
-		flag = CPU_INTEL_CORE2;
-		break;
-	case 0x061C:
-		flag = CPU_INTEL_ATOM;
-		break;
-	case 0x0F00:
-	case 0x0F01:
-	case 0x0F02:
-	case 0x0F03:
-	case 0x0F04:
-		flag = CPU_INTEL_XEON_P4;
-		break;
-	case 0x0F06:
-		flag = CPU_INTEL_XEON_MP;
-		break;
-	default:
-		flag = CPU_NONE;
-		break;
-	}
-
-	return flag;
-}
-
-/* AMD */
-static int get_amd_modelflag(unsigned model)
-{
-	int flag;
-
-	switch (model >> 8) {
-	case 0x6:
-		flag = CPU_AMD_K6;
-		break;
-	case 0x7:
-		flag = CPU_AMD_K7;
-		break;
-	case 0x8:
-		flag = CPU_AMD_K8;
-		break;
-	case 0xf:
-		flag = CPU_AMD_0F;
-		break;
-	case 0x10:
-		flag = CPU_AMD_10;
-		break;
-	case 0x11:
-		flag = CPU_AMD_11;
-		break;
-	default:
-		flag = CPU_NONE;
-		break;
-	}
-
-	return flag;
-}
-
-static int get_cpu_modelflag(unsigned cpu)
-{
-	int flag;
-
-	flag = per_cpu(cpu_model, cpu);
-
-	switch (flag >> 16) {
-	case X86_VENDOR_INTEL:
-		flag = get_intel_modelflag(flag);
-		break;
-	case X86_VENDOR_AMD:
-		flag = get_amd_modelflag(flag & 0xffff);
-		break;
-	default:
-		flag = CPU_NONE;
-		break;
-	}
-
-	return flag;
-}
-
-static int get_cpu_range_count(unsigned cpu)
-{
-	int index;
-
-	switch (per_cpu(cpu_model, cpu) >> 16) {
-	case X86_VENDOR_INTEL:
-		index = ARRAY_SIZE(cpu_intel_range);
-		break;
-	case X86_VENDOR_AMD:
-		index = ARRAY_SIZE(cpu_amd_range);
-		break;
-	default:
-		index = 0;
-		break;
-	}
-
-	return index;
-}
-
 static int is_typeflag_valid(unsigned cpu, unsigned flag)
 {
-	unsigned vendor, modelflag;
-	int i, index;
+	int i;
 
 	/* Standard Registers should be always valid */
 	if (flag >= CPU_TSS)
 		return 1;
 
-	modelflag = per_cpu(cpu_modelflag, cpu);
-	vendor = per_cpu(cpu_model, cpu) >> 16;
-	index = get_cpu_range_count(cpu);
-
-	for (i = 0; i < index; i++) {
-		switch (vendor) {
-		case X86_VENDOR_INTEL:
-			if ((cpu_intel_range[i].model & modelflag) &&
-			    (cpu_intel_range[i].flag & flag))
-				return 1;
-			break;
-		case X86_VENDOR_AMD:
-			if ((cpu_amd_range[i].model & modelflag) &&
-			    (cpu_amd_range[i].flag & flag))
-				return 1;
-			break;
-		}
+	for (i = 0; i < ARRAY_SIZE(cpu_reg_range); i++) {
+		if (cpu_reg_range[i].flag == flag)
+			return 1;
 	}
 
 	/* Invalid */
@@ -385,26 +183,11 @@ static int is_typeflag_valid(unsigned cpu, unsigned flag)
 static unsigned get_cpu_range(unsigned cpu, unsigned *min, unsigned *max,
 			      int index, unsigned flag)
 {
-	unsigned modelflag;
-
-	modelflag = per_cpu(cpu_modelflag, cpu);
-	*max = 0;
-	switch (per_cpu(cpu_model, cpu) >> 16) {
-	case X86_VENDOR_INTEL:
-		if ((cpu_intel_range[index].model & modelflag) &&
-		    (cpu_intel_range[index].flag & flag)) {
-			*min = cpu_intel_range[index].min;
-			*max = cpu_intel_range[index].max;
-		}
-		break;
-	case X86_VENDOR_AMD:
-		if ((cpu_amd_range[index].model & modelflag) &&
-		    (cpu_amd_range[index].flag & flag)) {
-			*min = cpu_amd_range[index].min;
-			*max = cpu_amd_range[index].max;
-		}
-		break;
-	}
+	if (cpu_reg_range[index].flag == flag) {
+		*min = cpu_reg_range[index].min;
+		*max = cpu_reg_range[index].max;
+	} else
+		*max = 0;
 
 	return *max;
 }
@@ -434,7 +217,7 @@ static void print_msr(struct seq_file *seq, unsigned cpu, unsigned flag)
 	unsigned msr, msr_min, msr_max;
 	struct cpu_private *priv;
 	u32 low, high;
-	int i, range;
+	int i;
 
 	if (seq) {
 		priv = seq->private;
@@ -446,9 +229,7 @@ static void print_msr(struct seq_file *seq, unsigned cpu, unsigned flag)
 		}
 	}
 
-	range = get_cpu_range_count(cpu);
-
-	for (i = 0; i < range; i++) {
+	for (i = 0; i < ARRAY_SIZE(cpu_reg_range); i++) {
 		if (!get_cpu_range(cpu, &msr_min, &msr_max, i, flag))
 			continue;
 
@@ -788,13 +569,11 @@ static int cpu_init_msr(unsigned cpu, unsigned type, struct dentry *dentry)
 {
 	struct dentry *cpu_dentry = NULL;
 	unsigned reg, reg_min, reg_max;
-	int i, range, err = 0;
+	int i, err = 0;
 	char reg_dir[12];
 	u32 low, high;
 
-	range = get_cpu_range_count(cpu);
-
-	for (i = 0; i < range; i++) {
+	for (i = 0; i < ARRAY_SIZE(cpu_reg_range); i++) {
 		if (!get_cpu_range(cpu, &reg_min, &reg_max, i,
 				   cpu_base[type].flag))
 			continue;
@@ -850,10 +629,6 @@ static int cpu_init_cpu(void)
 		cpui = &cpu_data(cpu);
 		if (!cpu_has(cpui, X86_FEATURE_MSR))
 			continue;
-		per_cpu(cpu_model, cpu) = ((cpui->x86_vendor << 16) |
-					   (cpui->x86 << 8) |
-					   (cpui->x86_model));
-		per_cpu(cpu_modelflag, cpu) = get_cpu_modelflag(cpu);
 
 		sprintf(cpu_dir, "cpu%d", cpu);
 		cpu_dentry = debugfs_create_dir(cpu_dir, cpu_debugfs_dir);
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 483eda9..789efe2 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -17,6 +17,7 @@
 
 #include <asm/processor.h>
 #include <asm/smp.h>
+#include <asm/k8.h>
 
 #define LVL_1_INST	1
 #define LVL_1_DATA	2
@@ -159,14 +160,6 @@ struct _cpuid4_info_regs {
 	unsigned long can_disable;
 };
 
-#if defined(CONFIG_PCI) && defined(CONFIG_SYSFS)
-static struct pci_device_id k8_nb_id[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1103) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1203) },
-	{}
-};
-#endif
-
 unsigned short			num_cache_leaves;
 
 /* AMD doesn't have CPUID4. Emulate it here to report the same
@@ -207,10 +200,17 @@ union l3_cache {
 };
 
 static const unsigned short __cpuinitconst assocs[] = {
-	[1] = 1, [2] = 2, [4] = 4, [6] = 8,
-	[8] = 16, [0xa] = 32, [0xb] = 48,
+	[1] = 1,
+	[2] = 2,
+	[4] = 4,
+	[6] = 8,
+	[8] = 16,
+	[0xa] = 32,
+	[0xb] = 48,
 	[0xc] = 64,
-	[0xf] = 0xffff // ??
+	[0xd] = 96,
+	[0xe] = 128,
+	[0xf] = 0xffff /* fully associative - no way to show this currently */
 };
 
 static const unsigned char __cpuinitconst levels[] = { 1, 1, 2, 3 };
@@ -271,7 +271,8 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 	eax->split.type = types[leaf];
 	eax->split.level = levels[leaf];
 	if (leaf == 3)
-		eax->split.num_threads_sharing = current_cpu_data.x86_max_cores - 1;
+		eax->split.num_threads_sharing =
+			current_cpu_data.x86_max_cores - 1;
 	else
 		eax->split.num_threads_sharing = 0;
 	eax->split.num_cores_on_die = current_cpu_data.x86_max_cores - 1;
@@ -291,6 +292,14 @@ amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
 {
 	if (index < 3)
 		return;
+
+	if (boot_cpu_data.x86 == 0x11)
+		return;
+
+	/* see erratum #382 */
+	if ((boot_cpu_data.x86 == 0x10) && (boot_cpu_data.x86_model < 0x8))
+		return;
+
 	this_leaf->can_disable = 1;
 }
 
@@ -696,97 +705,75 @@ static ssize_t show_type(struct _cpuid4_info *this_leaf, char *buf)
 #define to_object(k)	container_of(k, struct _index_kobject, kobj)
 #define to_attr(a)	container_of(a, struct _cache_attr, attr)
 
-#ifdef CONFIG_PCI
-static struct pci_dev *get_k8_northbridge(int node)
-{
-	struct pci_dev *dev = NULL;
-	int i;
-
-	for (i = 0; i <= node; i++) {
-		do {
-			dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev);
-			if (!dev)
-				break;
-		} while (!pci_match_id(&k8_nb_id[0], dev));
-		if (!dev)
-			break;
-	}
-	return dev;
-}
-#else
-static struct pci_dev *get_k8_northbridge(int node)
-{
-	return NULL;
-}
-#endif
-
-static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf)
+static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
+				  unsigned int index)
 {
-	const struct cpumask *mask = to_cpumask(this_leaf->shared_cpu_map);
-	int node = cpu_to_node(cpumask_first(mask));
-	struct pci_dev *dev = NULL;
-	ssize_t ret = 0;
-	int i;
+	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
+	int node = cpu_to_node(cpu);
+	struct pci_dev *dev = node_to_k8_nb_misc(node);
+	unsigned int reg = 0;
 
 	if (!this_leaf->can_disable)
-		return sprintf(buf, "Feature not enabled\n");
-
-	dev = get_k8_northbridge(node);
-	if (!dev) {
-		printk(KERN_ERR "Attempting AMD northbridge operation on a system with no northbridge\n");
 		return -EINVAL;
-	}
 
-	for (i = 0; i < 2; i++) {
-		unsigned int reg;
+	if (!dev)
+		return -EINVAL;
 
-		pci_read_config_dword(dev, 0x1BC + i * 4, &reg);
+	pci_read_config_dword(dev, 0x1BC + index * 4, &reg);
+	return sprintf(buf, "%x\n", reg);
+}
 
-		ret += sprintf(buf, "%sEntry: %d\n", buf, i);
-		ret += sprintf(buf, "%sReads:  %s\tNew Entries: %s\n",  
-			buf,
-			reg & 0x80000000 ? "Disabled" : "Allowed",
-			reg & 0x40000000 ? "Disabled" : "Allowed");
-		ret += sprintf(buf, "%sSubCache: %x\tIndex: %x\n",
-			buf, (reg & 0x30000) >> 16, reg & 0xfff);
-	}
-	return ret;
+#define SHOW_CACHE_DISABLE(index)					\
+static ssize_t								\
+show_cache_disable_##index(struct _cpuid4_info *this_leaf, char *buf)  	\
+{									\
+	return show_cache_disable(this_leaf, buf, index);		\
 }
+SHOW_CACHE_DISABLE(0)
+SHOW_CACHE_DISABLE(1)
 
-static ssize_t
-store_cache_disable(struct _cpuid4_info *this_leaf, const char *buf,
-		    size_t count)
+static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
+	const char *buf, size_t count, unsigned int index)
 {
-	const struct cpumask *mask = to_cpumask(this_leaf->shared_cpu_map);
-	int node = cpu_to_node(cpumask_first(mask));
-	struct pci_dev *dev = NULL;
-	unsigned int ret, index, val;
+	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
+	int node = cpu_to_node(cpu);
+	struct pci_dev *dev = node_to_k8_nb_misc(node);
+	unsigned long val = 0;
+	unsigned int scrubber = 0;
 
 	if (!this_leaf->can_disable)
-		return 0;
-
-	if (strlen(buf) > 15)
 		return -EINVAL;
 
-	ret = sscanf(buf, "%x %x", &index, &val);
-	if (ret != 2)
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (!dev)
 		return -EINVAL;
-	if (index > 1)
+
+	if (strict_strtoul(buf, 10, &val) < 0)
 		return -EINVAL;
 
 	val |= 0xc0000000;
-	dev = get_k8_northbridge(node);
-	if (!dev) {
-		printk(KERN_ERR "Attempting AMD northbridge operation on a system with no northbridge\n");
-		return -EINVAL;
-	}
+
+	pci_read_config_dword(dev, 0x58, &scrubber);
+	scrubber &= ~0x1f000000;
+	pci_write_config_dword(dev, 0x58, scrubber);
 
 	pci_write_config_dword(dev, 0x1BC + index * 4, val & ~0x40000000);
 	wbinvd();
 	pci_write_config_dword(dev, 0x1BC + index * 4, val);
+	return count;
+}
 
-	return 1;
+#define STORE_CACHE_DISABLE(index)					\
+static ssize_t								\
+store_cache_disable_##index(struct _cpuid4_info *this_leaf,	     	\
+			    const char *buf, size_t count)		\
+{									\
+	return store_cache_disable(this_leaf, buf, count, index);	\
 }
+STORE_CACHE_DISABLE(0)
+STORE_CACHE_DISABLE(1)
 
 struct _cache_attr {
 	struct attribute attr;
@@ -808,7 +795,10 @@ define_one_ro(size);
 define_one_ro(shared_cpu_map);
 define_one_ro(shared_cpu_list);
 
-static struct _cache_attr cache_disable = __ATTR(cache_disable, 0644, show_cache_disable, store_cache_disable);
+static struct _cache_attr cache_disable_0 = __ATTR(cache_disable_0, 0644,
+		show_cache_disable_0, store_cache_disable_0);
+static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
+		show_cache_disable_1, store_cache_disable_1);
 
 static struct attribute * default_attrs[] = {
 	&type.attr,
@@ -820,7 +810,8 @@ static struct attribute * default_attrs[] = {
 	&size.attr,
 	&shared_cpu_map.attr,
 	&shared_cpu_list.attr,
-	&cache_disable.attr,
+	&cache_disable_0.attr,
+	&cache_disable_1.attr,
 	NULL
 };
 
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 7563b31..af71d06 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -491,5 +491,42 @@ void force_hpet_resume(void)
 		break;
 	}
 }
+#endif
+
+#if defined(CONFIG_PCI) && defined(CONFIG_NUMA)
+/* Set correct numa_node information for AMD NB functions */
+static void __init quirk_amd_nb_node(struct pci_dev *dev)
+{
+	struct pci_dev *nb_ht;
+	unsigned int devfn;
+	u32 val;
+
+	devfn = PCI_DEVFN(PCI_SLOT(dev->devfn), 0);
+	nb_ht = pci_get_slot(dev->bus, devfn);
+	if (!nb_ht)
+		return;
+
+	pci_read_config_dword(nb_ht, 0x60, &val);
+	set_dev_node(&dev->dev, val & 7);
+	pci_dev_put(dev);
+}
 
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB,
+			quirk_amd_nb_node);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_ADDRMAP,
+			quirk_amd_nb_node);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MEMCTL,
+			quirk_amd_nb_node);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MISC,
+			quirk_amd_nb_node);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_HT,
+			quirk_amd_nb_node);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MAP,
+			quirk_amd_nb_node);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_DRAM,
+			quirk_amd_nb_node);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC,
+			quirk_amd_nb_node);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_LINK,
+			quirk_amd_nb_node);
 #endif
