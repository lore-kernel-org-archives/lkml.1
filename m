Return-Path: <linux-kernel-owner+w=401wt.eu-S1756629AbZEKQOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbZEKQOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 12:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbZEKQOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 12:14:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:52446 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbZEKQOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 12:14:37 -0400
Subject: [git-pull -tip] x86: Addition of cpufeatures to friendly access
 miscellaneous MSRs
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       Robert Richter <robert.richter@amd.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 11 May 2009 21:44:54 +0530
Message-Id: <1242058494.5139.7.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Complete log is available at:
http://git.kernel.org/?p=linux/kernel/git/jaswinder/linux-2.6-cpu.git;a=shortlog;h=x86/cpufeature

The following changes since commit 3e0c373749d7eb5b354ac0b043f2b2cdf84eefef:
  Yinghai Lu (1):
        x86: clean up and fix setup_clear/force_cpu_cap handling

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-cpu.git x86/cpufeature

Jaswinder Singh Rajput (15):
      x86: Add cpufeature for Processor Name
      x86: Add cpufeatures for Advanced Power Management
      x86: Add cpufeature for Microcode update
      x86: Add cpufeature for Cache MSRs
      x86: Add cpufeature for Hard and Soft Poweron configuration
      x86: Add cpufeature for Scaleable bus speed
      x86: Add cpufeature for Miscellaneous Features
      x86: Add cpufeature for Platform feature
      x86: Add cpufeature for Hardware configuration
      x86: Add cpufeature for System configuration
      x86: Add cpufeature for System management mode (SMM)
      x86: Add cpufeature for MM configuration
      x86: Add cpufeature for Bus configuration
      x86: Add cpufeature for performance frequency APERF/MPERF
      x86: Add cpufeature for ancient performance monitoring

 arch/x86/include/asm/cpufeature.h          |   35 ++++++++--
 arch/x86/include/asm/processor.h           |    1 -
 arch/x86/kernel/cpu/Makefile               |    2 +-
 arch/x86/kernel/cpu/amd.c                  |   35 +++++++---
 arch/x86/kernel/cpu/common.c               |   17 ++++-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    9 +--
 arch/x86/kernel/cpu/intel.c                |  106 ++++++++++++++++++++++++----
 arch/x86/kernel/cpu/powerflags.c           |   20 -----
 arch/x86/kernel/cpu/proc.c                 |   14 ----
 arch/x86/kernel/microcode_amd.c            |    3 +
 arch/x86/kernel/microcode_intel.c          |    3 +
 11 files changed, 172 insertions(+), 73 deletions(-)
 delete mode 100644 arch/x86/kernel/cpu/powerflags.c

complete diff:

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 13cc6a5..f660e99 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -6,7 +6,7 @@
 
 #include <asm/required-features.h>
 
-#define NCAPINTS	9	/* N 32-bit words worth of info */
+#define NCAPINTS	10	/* N 32-bit words worth of info */
 
 /*
  * Note: If the comment begins with a quoted string, that string is used
@@ -76,7 +76,6 @@
 #define X86_FEATURE_K7		(3*32+ 5) /* "" Athlon */
 #define X86_FEATURE_P3		(3*32+ 6) /* "" P3 */
 #define X86_FEATURE_P4		(3*32+ 7) /* "" P4 */
-#define X86_FEATURE_CONSTANT_TSC (3*32+ 8) /* TSC ticks at a constant rate */
 #define X86_FEATURE_UP		(3*32+ 9) /* smp kernel running on up */
 #define X86_FEATURE_FXSAVE_LEAK (3*32+10) /* "" FXSAVE leaks FOP/FIP/FOP */
 #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Intel Architectural PerfMon */
@@ -153,8 +152,24 @@
  * Auxiliary flags: Linux defined - For features scattered in various
  * CPUID levels like 0x6, 0xA etc
  */
-#define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
-#define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer */
+#define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration	*/
+#define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer	*/
+#define X86_FEATURE_PNAME	(7*32+ 2) /* Processor Name		*/
+#define X86_FEATURE_MICROCODE	(7*32+ 3) /* Microcode update		*/
+#define X86_FEATURE_CACHE	(7*32+ 4) /* BBL_CR_* MSRs (PII & PIII)	*/
+#define X86_FEATURE_CACHE_CTL	(7*32+ 5) /* Cache control MSRs		*/
+#define X86_FEATURE_HARD_POWERON (7*32+ 6) /* Hard Poweron configuration*/
+#define X86_FEATURE_SOFT_POWERON (7*32+ 7) /* Soft Poweron configuration*/
+#define X86_FEATURE_FSB_FREQ 	(7*32+ 8) /* Scaleable bus speed	*/
+#define X86_FEATURE_MISC 	(7*32+ 9) /* Miscellaneous features	*/
+#define X86_FEATURE_PLATFORM 	(7*32+ 10) /* Platform feature		*/
+#define X86_FEATURE_HW_CFG 	(7*32+ 11) /* Hardware configuration	*/
+#define X86_FEATURE_SYS_CFG 	(7*32+ 12) /* System configuration	*/
+#define X86_FEATURE_SMM 	(7*32+ 13) /* System Management	Mode	*/
+#define X86_FEATURE_MM_CFG 	(7*32+ 14) /* MM configuration		*/
+#define X86_FEATURE_BUS_CFG 	(7*32+ 15) /* Bus configuration		*/
+#define X86_FEATURE_PERF_FREQ 	(7*32+ 16) /* Performance frequency	*/
+#define X86_FEATURE_PERFMON 	(7*32+ 17) /* Performance monitoring	*/
 
 /* Virtualization flags: Linux defined */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
@@ -163,12 +178,22 @@
 #define X86_FEATURE_EPT         (8*32+ 3) /* Intel Extended Page Table */
 #define X86_FEATURE_VPID        (8*32+ 4) /* Intel Virtual Processor ID */
 
+/* Advanced Power Management (Function 8000_0007h), edx */
+#define X86_FEATURE_TS		(9*32+ 0) /* Temperatue sensor		*/
+#define X86_FEATURE_FID		(9*32+ 1) /* Frequency ID control	*/
+#define X86_FEATURE_VID		(9*32+ 2) /* Voltage ID control		*/
+#define X86_FEATURE_TTP		(9*32+ 3) /* Thermal trip		*/
+#define X86_FEATURE_HTC		(9*32+ 4) /* Hardware thermal control	*/
+#define X86_FEATURE_STC		(9*32+ 5) /* Software thermal control	*/
+#define X86_FEATURE_100MHZSTEPS	(9*32+ 6) /* 100 MHz multiplier control	*/
+#define X86_FEATURE_HWPSTATE	(9*32+ 7) /* Hardware P-State control	*/
+#define X86_FEATURE_CONSTANT_TSC (9*32+ 8) /* Constant rate TSC ticks	*/
+
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
 #include <linux/bitops.h>
 
 extern const char * const x86_cap_flags[NCAPINTS*32];
-extern const char * const x86_power_flags[32];
 
 #define test_cpu_cap(c, bit)						\
 	 test_bit(bit, (unsigned long *)((c)->x86_capability))
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index fed93fe..163b447 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -90,7 +90,6 @@ struct cpuinfo_x86 {
 	/* in KB - valid for CPUS which support this call: */
 	int			x86_cache_size;
 	int			x86_cache_alignment;	/* In bytes */
-	int			x86_power;
 	unsigned long		loops_per_jiffy;
 #ifdef CONFIG_SMP
 	/* cpus sharing the last level cache: */
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 4e242f9..3e5da32 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -8,7 +8,7 @@ CFLAGS_REMOVE_common.o = -pg
 endif
 
 obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
-obj-y			+= proc.o capflags.o powerflags.o common.o
+obj-y			+= proc.o capflags.o common.o
 obj-y			+= vmware.o hypervisor.o
 
 obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 7e4a459..849d794 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -333,15 +333,6 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 {
 	early_init_amd_mc(c);
 
-	/*
-	 * c->x86_power is 8000_0007 edx. Bit 8 is TSC runs at constant rate
-	 * with P/T states and does not stop in deep C-states
-	 */
-	if (c->x86_power & (1 << 8)) {
-		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
-		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
-	}
-
 #ifdef CONFIG_X86_64
 	set_cpu_cap(c, X86_FEATURE_SYSCALL32);
 #else
@@ -485,6 +476,32 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		}
 	}
 #endif
+
+	/* Set cpufeatures for miscellaneous MSRs			*/
+	if (c->x86 >= 7) {				/* K7+		*/
+		/* MSRC001_0015 Hardware Configuration Register (HWCR)	*/
+		set_cpu_cap(c, X86_FEATURE_HW_CFG);
+		/* Performance monitoring support			*/
+		set_cpu_cap(c, X86_FEATURE_PERFMON);
+	}
+	if (c->x86 >= 8) {				/* K8+		*/
+		/*
+		 * System configuration MSRs:
+		 * MSRC001_0010 System Configuration Register (SYS_CFG)
+		 * MSRC001_001F Northbridge Configuration Register (NB_CFG)
+		 */
+		set_cpu_cap(c, X86_FEATURE_SYS_CFG);
+		/* SMM MSRs C001_0111-C001_0113 & C001_0050-C000_0056	*/
+		set_cpu_cap(c, X86_FEATURE_SMM);
+	}
+	if (c->x86 >= 0x10) {				/* fam10h+	*/
+		/* MSRC001_1022 Data Cache Configuration (DC_CFG)	*/
+		set_cpu_cap(c, X86_FEATURE_CACHE_CTL);
+		/* MSRC001_0058 MMIO Configuration Base Address Register*/
+		set_cpu_cap(c, X86_FEATURE_MM_CFG);
+		/* MSRC001_1023 Bus Unit Configuration Register (BU_CFG)*/
+		set_cpu_cap(c, X86_FEATURE_BUS_CFG);
+	}
 }
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e7fd5c4..511a970 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -360,6 +360,7 @@ static void __cpuinit get_model_name(struct cpuinfo_x86 *c)
 	cpuid(0x80000003, &v[4], &v[5], &v[6], &v[7]);
 	cpuid(0x80000004, &v[8], &v[9], &v[10], &v[11]);
 	c->x86_model_id[48] = 0;
+	set_cpu_cap(c, X86_FEATURE_PNAME);
 
 	/*
 	 * Intel chips right-justify this string for some dumb reason;
@@ -575,8 +576,22 @@ static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 #endif
 
 	if (c->extended_cpuid_level >= 0x80000007)
-		c->x86_power = cpuid_edx(0x80000007);
+		c->x86_capability[9] = cpuid_edx(0x80000007);
 
+	/*
+	 * Advanced power management is 8000_0007 edx.
+	 * Bit 8 is TSC runs at constant rate with P/T states
+	 * and does not stop in deep C-states.
+	 *
+	 * It is also reliable across cores and sockets. (but not across
+	 * cabinets - we turn it off in that case explicitly.)
+	 */
+	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
+		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
+		set_cpu_cap(c, X86_FEATURE_TSC_RELIABLE);
+		if (c->x86_vendor == X86_VENDOR_INTEL)
+			sched_clock_stable = 1;
+	}
 }
 
 static void __cpuinit identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 208ecf6..3811ca6 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -60,7 +60,6 @@ enum {
 };
 
 #define INTEL_MSR_RANGE		(0xffff)
-#define CPUID_6_ECX_APERFMPERF_CAPABILITY	(0x1)
 
 struct acpi_cpufreq_data {
 	struct acpi_processor_performance *acpi_data;
@@ -735,12 +734,8 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	acpi_processor_notify_smm(THIS_MODULE);
 
 	/* Check for APERF/MPERF support in hardware */
-	if (c->x86_vendor == X86_VENDOR_INTEL && c->cpuid_level >= 6) {
-		unsigned int ecx;
-		ecx = cpuid_ecx(6);
-		if (ecx & CPUID_6_ECX_APERFMPERF_CAPABILITY)
-			acpi_cpufreq_driver.getavg = get_measured_perf;
-	}
+	if (cpu_has(c, X86_FEATURE_PERF_FREQ))
+		acpi_cpufreq_driver.getavg = get_measured_perf;
 
 	dprintk("CPU%u - ACPI performance management activated.\n", cpu);
 	for (i = 0; i < perf->state_count; i++)
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 7437fa1..e3ce8c6 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -61,20 +61,6 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 		c->x86_phys_bits = 36;
 
 	/*
-	 * c->x86_power is 8000_0007 edx. Bit 8 is TSC runs at constant rate
-	 * with P/T states and does not stop in deep C-states.
-	 *
-	 * It is also reliable across cores and sockets. (but not across
-	 * cabinets - we turn it off in that case explicitly.)
-	 */
-	if (c->x86_power & (1 << 8)) {
-		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
-		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
-		set_cpu_cap(c, X86_FEATURE_TSC_RELIABLE);
-		sched_clock_stable = 1;
-	}
-
-	/*
 	 * There is a known erratum on Pentium III and Core Solo
 	 * and Core Duo CPUs.
 	 * " Page with PAT set to WC while associated MTRR is UC
@@ -324,7 +310,9 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 		/* Check for version and the number of counters */
 		if ((eax & 0xff) && (((eax>>8) & 0xff) > 1))
 			set_cpu_cap(c, X86_FEATURE_ARCH_PERFMON);
-	}
+	} else if (c->x86 >= 5)
+		/* ancient performance monitoring support */
+		set_cpu_cap(c, X86_FEATURE_PERFMON);
 
 	if (cpu_has_xmm2)
 		set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
@@ -404,6 +392,94 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 
 	if (cpu_has(c, X86_FEATURE_VMX))
 		detect_vmx_virtcap(c);
+
+	/* Set cpufeatures for miscellaneous MSRs			*/
+	if (c->x86 == 6) {
+		/* Miscellaneous Features IA32_MISC_ENABLE		*/
+		set_cpu_cap(c, X86_FEATURE_MISC);
+
+		switch (c->x86_model) {
+		case 1:					/* Pentium Pro	*/
+			/* Hard Poweron configuration MSR_EBL_CR_POWERON*/
+			set_cpu_cap(c, X86_FEATURE_HARD_POWERON);
+			/* !Miscellaneous Features IA32_MISC_ENABLE	*/
+			clear_cpu_cap(c, X86_FEATURE_MISC);
+			break;
+
+		case 3: case 5:				/* Pentium II	*/
+		case 7: case 8: case 0xA: case 0xB:	/* Pentium III	*/
+			/* Hard Poweron configuration MSR_EBL_CR_POWERON*/
+			set_cpu_cap(c, X86_FEATURE_HARD_POWERON);
+			/* BBL_CR_* MSRs (Pentium II & III processors)	*/
+			set_cpu_cap(c, X86_FEATURE_CACHE);
+			/* BBL_CR_CTL* MSRs (Cache control MSRs)	*/
+			set_cpu_cap(c, X86_FEATURE_CACHE_CTL);
+			/* !Miscellaneous Features IA32_MISC_ENABLE	*/
+			clear_cpu_cap(c, X86_FEATURE_MISC);
+			break;
+
+		case 9:	case 0xD:			/* Pentium M	*/
+			/* Hard Poweron configuration MSR_EBL_CR_POWERON*/
+			set_cpu_cap(c, X86_FEATURE_HARD_POWERON);
+			/* BBL_CR_CTL* MSRs (Cache control MSRs)	*/
+			set_cpu_cap(c, X86_FEATURE_CACHE_CTL);
+			break;
+
+		case 0xE:				/* Core		*/
+		case 0xF: case 0x17:			/* Core 2	*/
+		case 0x1C:				/* ATOM		*/
+			/* Hard Poweron configuration MSR_EBL_CR_POWERON*/
+			set_cpu_cap(c, X86_FEATURE_HARD_POWERON);
+			/* BBL_CR_CTL* MSRs (Cache control MSRs)	*/
+			set_cpu_cap(c, X86_FEATURE_CACHE_CTL);
+			/* Scaleable bus speed MSR_FSB_FREQ		*/
+			set_cpu_cap(c, X86_FEATURE_FSB_FREQ);
+			break;
+
+		case 0x16:				/* Celeron Core	*/
+			/* Hard Poweron configuration MSR_EBL_CR_POWERON*/
+			set_cpu_cap(c, X86_FEATURE_HARD_POWERON);
+			break;
+
+		case 0x1D:				/* Xeon MP	*/
+			/* Hard Poweron configuration MSR_EBL_CR_POWERON*/
+			set_cpu_cap(c, X86_FEATURE_HARD_POWERON);
+			/*
+			 * Soft Poweron configuration MSR_EBC_SOFT_POWERON
+			 * Frequency configuration MSR_EBC_FREQUENCY_ID
+			 */
+			set_cpu_cap(c, X86_FEATURE_SOFT_POWERON);
+			break;
+		}
+	}
+	if (c->x86 == 0xF) {
+		/* Hard Poweron configuration MSR_EBL_CR_POWERON	*/
+		set_cpu_cap(c, X86_FEATURE_HARD_POWERON);
+		/*
+		 * Soft Poweron configuration MSR_EBC_SOFT_POWERON
+		 * Frequency configuration MSR_EBC_FREQUENCY_ID
+		 */
+		set_cpu_cap(c, X86_FEATURE_SOFT_POWERON);
+
+		/* Miscellaneous Features IA32_MISC_ENABLE		*/
+		set_cpu_cap(c, X86_FEATURE_MISC);
+
+		switch (c->x86_model) {
+		case 3: case 4: case 6:
+			/* Platform Feature MSR_PLATFORM_BRV		*/
+			set_cpu_cap(c, X86_FEATURE_PLATFORM);
+			break;
+		}
+	}
+	if (c->cpuid_level >= 6) {
+		/*
+		 * Hardware Coordination Feedback Capability
+		 * (Presence of IA32_APERF, IA32_MPERF MSRs)
+		 */
+		l2 = cpuid_ecx(6);
+		if (l2 & 1)
+			set_cpu_cap(c, X86_FEATURE_PERF_FREQ);
+	}
 }
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/cpu/powerflags.c b/arch/x86/kernel/cpu/powerflags.c
deleted file mode 100644
index 5abbea2..0000000
--- a/arch/x86/kernel/cpu/powerflags.c
+++ /dev/null
@@ -1,20 +0,0 @@
-/*
- * Strings for the various x86 power flags
- *
- * This file must not contain any executable code.
- */
-
-#include <asm/cpufeature.h>
-
-const char *const x86_power_flags[32] = {
-	"ts",	/* temperature sensor */
-	"fid",  /* frequency id control */
-	"vid",  /* voltage id control */
-	"ttp",  /* thermal trip */
-	"tm",
-	"stc",
-	"100mhzsteps",
-	"hwpstate",
-	"",	/* tsc invariant mapped to constant_tsc */
-		/* nothing */
-};
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index f93047f..523bf39 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -121,20 +121,6 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	seq_printf(m, "address sizes\t: %u bits physical, %u bits virtual\n",
 		   c->x86_phys_bits, c->x86_virt_bits);
 #endif
-
-	seq_printf(m, "power management:");
-	for (i = 0; i < 32; i++) {
-		if (c->x86_power & (1 << i)) {
-			if (i < ARRAY_SIZE(x86_power_flags) &&
-			    x86_power_flags[i])
-				seq_printf(m, "%s%s",
-					   x86_power_flags[i][0]?" ":"",
-					   x86_power_flags[i]);
-			else
-				seq_printf(m, " [%d]", i);
-		}
-	}
-
 	seq_printf(m, "\n\n");
 
 	return 0;
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 453b579..ec9e5e2 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -95,6 +95,9 @@ static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 		       "supported\n", cpu, c->x86);
 		return -1;
 	}
+	/* setting microcode update feature to friendly access of UCODE MSRs */
+	set_cpu_cap(c, X86_FEATURE_MICROCODE);
+
 	rdmsr(MSR_AMD64_PATCH_LEVEL, csig->rev, dummy);
 	printk(KERN_INFO "microcode: CPU%d: patch_level=0x%x\n", cpu, csig->rev);
 	return 0;
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 149b9ec..2fcaa58 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -168,6 +168,9 @@ static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 		return -1;
 	}
 
+	/* setting microcode update feature to friendly access of UCODE MSRs */
+	set_cpu_cap(c, X86_FEATURE_MICROCODE);
+
 	csig->sig = cpuid_eax(0x00000001);
 
 	if ((c->x86_model >= 5) || (c->x86 > 6)) {


