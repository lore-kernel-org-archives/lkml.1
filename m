Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbZELPq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbZELPq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192AbZELPqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:46:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:51013 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755627AbZELPqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:46:16 -0400
Subject: [git-pull -tip][PATCH 0/10] few cpufeature additions and users
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       Robert Richter <robert.richter@amd.com>, Dave Jones <davej@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Content-Type: text/plain
Date: Tue, 12 May 2009 21:05:30 +0530
Message-Id: <1242142530.2547.11.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is first patchset of cpufeatures I will release another cpufeature
patchset after these are applied.

The following changes since commit 3e0c373749d7eb5b354ac0b043f2b2cdf84eefef:
  Yinghai Lu (1):
        x86: clean up and fix setup_clear/force_cpu_cap handling

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-cpu.git x86/cpufeature

Jaswinder Singh Rajput (10):
      x86: Add cpufeature for Processor Name
      x86: get_model_name() user of X86_FEATURE_PNAME
      x86: Add cpufeatures for Advanced Power Management
      x86: check_powernow() for K7 user of Advanced Power Management features
      x86: check_powernow() for K8 and later user of Advanced Power Management features
      x86: early_init_intel() user of Advanced Power Management features
      x86: early_init_amd() user of Advanced Power Management features
      x86: Add cpufeature for Microcode update
      x86 : collect_cpu_info() of Intel user of Microcode feature
      x86 : collect_cpu_info() of AMD user of Microcode feature

 arch/x86/include/asm/cpufeature.h         |   20 ++++++++++++++++----
 arch/x86/kernel/cpu/amd.c                 |   21 ++++++++++++++++-----
 arch/x86/kernel/cpu/common.c              |   22 +++++++++++++++++-----
 arch/x86/kernel/cpu/cpufreq/powernow-k7.c |   16 ++++++----------
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   16 ++++++++--------
 arch/x86/kernel/cpu/cpufreq/powernow-k8.h |    4 ----
 arch/x86/kernel/cpu/intel.c               |   19 +++++++++++++++----
 arch/x86/kernel/microcode_amd.c           |    3 ++-
 arch/x86/kernel/microcode_intel.c         |    4 ++--
 9 files changed, 82 insertions(+), 43 deletions(-)

Complete diff:

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 13cc6a5..1fd6770 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -6,7 +6,7 @@
 
 #include <asm/required-features.h>
 
-#define NCAPINTS	9	/* N 32-bit words worth of info */
+#define NCAPINTS		10	/* N 32-bit words worth of info */
 
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
@@ -153,8 +152,10 @@
  * Auxiliary flags: Linux defined - For features scattered in various
  * CPUID levels like 0x6, 0xA etc
  */
-#define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
-#define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer */
+#define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration	*/
+#define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer	*/
+#define X86_FEATURE_PNAME	(7*32+ 2) /* Processor Name		*/
+#define X86_FEATURE_MICROCODE	(7*32+ 3) /* Microcode update		*/
 
 /* Virtualization flags: Linux defined */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
@@ -163,6 +164,17 @@
 #define X86_FEATURE_EPT         (8*32+ 3) /* Intel Extended Page Table */
 #define X86_FEATURE_VPID        (8*32+ 4) /* Intel Virtual Processor ID */
 
+/* Advanced Power Management (Function 8000_0007h), edx			*/
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
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 7e4a459..ca133a0 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -334,13 +334,12 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 	early_init_amd_mc(c);
 
 	/*
-	 * c->x86_power is 8000_0007 edx. Bit 8 is TSC runs at constant rate
-	 * with P/T states and does not stop in deep C-states
+	 * Advanced power management is 8000_0007 edx.
+	 * Bit 8 is TSC runs at constant rate with P/T states
+	 * and does not stop in deep C-states
 	 */
-	if (c->x86_power & (1 << 8)) {
-		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
+	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC))
 		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
-	}
 
 #ifdef CONFIG_X86_64
 	set_cpu_cap(c, X86_FEATURE_SYSCALL32);
@@ -353,6 +352,15 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 #endif
 }
 
+/* Set cpufeatures to friendly access miscellaneous MSRs		*/
+static void __cpuinit set_soft_cpufeatures(struct cpuinfo_x86 *c)
+{
+	if (c->x86 >= 0x10) {				/* fam10h+	*/
+		/* setting microcode update feature			*/
+		set_cpu_cap(c, X86_FEATURE_MICROCODE);
+	}
+}
+
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_SMP
@@ -372,6 +380,9 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	}
 #endif
 
+	/* setting early so that other functions can take advantage */
+	set_soft_cpufeatures(c);
+
 	early_init_amd(c);
 
 	/*
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e7fd5c4..a428b36 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -352,7 +352,7 @@ static void __cpuinit get_model_name(struct cpuinfo_x86 *c)
 	unsigned int *v;
 	char *p, *q;
 
-	if (c->extended_cpuid_level < 0x80000004)
+	if (!cpu_has(c, X86_FEATURE_PNAME))
 		return;
 
 	v = (unsigned int *)c->x86_model_id;
@@ -563,6 +563,22 @@ static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 		}
 	}
 
+	/*
+	 * Processor Name / Brand String
+	 * (Function 8000_0002h, 8000_0003h, 8000_0004h)
+	 * Functions 8000_0002h, 8000_0003h, and 8000_0004h each return up to
+	 * 16 ASCII bytes of the processor name in the EAX, EBX, ECX and EDX
+	 * registers.
+	 */
+	if (c->extended_cpuid_level >= 0x80000004)
+		set_cpu_cap(c, X86_FEATURE_PNAME);
+
+	/* Advanced Power Management (Function 8000_0007h), edx */
+	if (c->extended_cpuid_level >= 0x80000007){
+		c->x86_capability[9] = cpuid_edx(0x80000007);
+		c->x86_power = cpuid_edx(0x80000007);
+	}
+
 	if (c->extended_cpuid_level >= 0x80000008) {
 		u32 eax = cpuid_eax(0x80000008);
 
@@ -573,10 +589,6 @@ static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 	else if (cpu_has(c, X86_FEATURE_PAE) || cpu_has(c, X86_FEATURE_PSE36))
 		c->x86_phys_bits = 36;
 #endif
-
-	if (c->extended_cpuid_level >= 0x80000007)
-		c->x86_power = cpuid_edx(0x80000007);
-
 }
 
 static void __cpuinit identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k7.c b/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
index 3c28ccd..1f35474 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
@@ -118,7 +118,6 @@ static int check_fsb(unsigned int fsbspeed)
 static int check_powernow(void)
 {
 	struct cpuinfo_x86 *c = &cpu_data(0);
-	unsigned int maxei, eax, ebx, ecx, edx;
 
 	if ((c->x86_vendor != X86_VENDOR_AMD) || (c->x86 != 6)) {
 #ifdef MODULE
@@ -128,9 +127,8 @@ static int check_powernow(void)
 		return 0;
 	}
 
-	/* Get maximum capabilities */
-	maxei = cpuid_eax(0x80000000);
-	if (maxei < 0x80000007) {	/* Any powernow info ? */
+	/* Advanced Power Management capabilities */
+	if (c->x86_capability[9]) {	/* Any powernow info ? */
 #ifdef MODULE
 		printk(KERN_INFO PFX "No powernow capabilities detected\n");
 #endif
@@ -143,23 +141,21 @@ static int check_powernow(void)
 		have_a0 = 1;
 	}
 
-	cpuid(0x80000007, &eax, &ebx, &ecx, &edx);
-
 	/* Check we can actually do something before we say anything.*/
-	if (!(edx & (1 << 1 | 1 << 2)))
+	if (!cpu_has(c, X86_FEATURE_FID) && !cpu_has(c, X86_FEATURE_VID))
 		return 0;
 
 	printk(KERN_INFO PFX "PowerNOW! Technology present. Can scale: ");
 
-	if (edx & 1 << 1) {
+	if (cpu_has(c, X86_FEATURE_FID)) {
 		printk("frequency");
 		can_scale_bus = 1;
 	}
 
-	if ((edx & (1 << 1 | 1 << 2)) == 0x6)
+	if (cpu_has(c, X86_FEATURE_FID) && cpu_has(c, X86_FEATURE_VID))
 		printk(" and ");
 
-	if (edx & 1 << 2) {
+	if (cpu_has(c, X86_FEATURE_VID)) {
 		printk("voltage");
 		can_scale_vid = 1;
 	}
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 4709ead..b3f4ec8 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -512,8 +512,9 @@ static int core_voltage_post_transition(struct powernow_k8_data *data,
 
 static int check_supported_cpu(unsigned int cpu)
 {
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	cpumask_t oldmask;
-	u32 eax, ebx, ecx, edx;
+	u32 eax;
 	unsigned int rc = 0;
 
 	oldmask = current->cpus_allowed;
@@ -540,23 +541,22 @@ static int check_supported_cpu(unsigned int cpu)
 			goto out;
 		}
 
-		eax = cpuid_eax(CPUID_GET_MAX_CAPABILITIES);
-		if (eax < CPUID_FREQ_VOLT_CAPABILITIES) {
+		/* Advanced Power Management capabilities */
+		if (c->x86_capability[9]) {
 			printk(KERN_INFO PFX
 			       "No frequency change capabilities detected\n");
 			goto out;
 		}
 
-		cpuid(CPUID_FREQ_VOLT_CAPABILITIES, &eax, &ebx, &ecx, &edx);
-		if ((edx & P_STATE_TRANSITION_CAPABLE)
-			!= P_STATE_TRANSITION_CAPABLE) {
+		/* check for frequncy and volatage ID control support */
+		if (!cpu_has(c, X86_FEATURE_FID) &&
+			!cpu_has(c, X86_FEATURE_VID)) {
 			printk(KERN_INFO PFX
 				"Power state transitions not supported\n");
 			goto out;
 		}
 	} else { /* must be a HW Pstate capable processor */
-		cpuid(CPUID_FREQ_VOLT_CAPABILITIES, &eax, &ebx, &ecx, &edx);
-		if ((edx & USE_HW_PSTATE) == USE_HW_PSTATE)
+		if (cpu_has(c, X86_FEATURE_HWPSTATE))
 			cpu_family = CPU_HW_PSTATE;
 		else
 			goto out;
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
index 6c6698f..4dfe414 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
@@ -64,9 +64,6 @@ struct powernow_k8_data {
 #define CPUID_XMOD_REV_MASK		0x000c0000
 #define CPUID_XFAM_10H			0x00100000	/* family 0x10 */
 #define CPUID_USE_XFAM_XMOD		0x00000f00
-#define CPUID_GET_MAX_CAPABILITIES	0x80000000
-#define CPUID_FREQ_VOLT_CAPABILITIES	0x80000007
-#define P_STATE_TRANSITION_CAPABLE	6
 
 /* Model Specific Registers for p-state transitions. MSRs are 64-bit. For     */
 /* writes (wrmsr - opcode 0f 30), the register number is placed in ecx, and   */
@@ -101,7 +98,6 @@ struct powernow_k8_data {
 
 
 /* Hardware Pstate _PSS and MSR definitions */
-#define USE_HW_PSTATE		0x00000080
 #define HW_PSTATE_MASK 		0x00000007
 #define HW_PSTATE_VALID_MASK 	0x80000000
 #define HW_PSTATE_MAX_MASK	0x000000f0
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 7437fa1..ddb26f2 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -61,14 +61,14 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 		c->x86_phys_bits = 36;
 
 	/*
-	 * c->x86_power is 8000_0007 edx. Bit 8 is TSC runs at constant rate
-	 * with P/T states and does not stop in deep C-states.
+	 * Advanced power management is 8000_0007 edx.
+	 * Bit 8 is TSC runs at constant rate with P/T states
+	 * and does not stop in deep C-states.
 	 *
 	 * It is also reliable across cores and sockets. (but not across
 	 * cabinets - we turn it off in that case explicitly.)
 	 */
-	if (c->x86_power & (1 << 8)) {
-		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
+	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
 		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
 		set_cpu_cap(c, X86_FEATURE_TSC_RELIABLE);
 		sched_clock_stable = 1;
@@ -303,10 +303,21 @@ static void __cpuinit detect_vmx_virtcap(struct cpuinfo_x86 *c)
 	}
 }
 
+/* Set cpufeatures to friendly access miscellaneous MSRs		*/
+static void __cpuinit set_soft_cpufeatures(struct cpuinfo_x86 *c)
+{
+	/* setting microcode update feature				*/
+	if (c->x86 >= 6 && !cpu_has(c, X86_FEATURE_IA64))
+		set_cpu_cap(c, X86_FEATURE_MICROCODE);
+}
+
 static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 {
 	unsigned int l2 = 0;
 
+	/* setting early so that other functions can take advantage */
+	set_soft_cpufeatures(c);
+
 	early_init_intel(c);
 
 	intel_workarounds(c);
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 453b579..1178638 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -90,7 +90,8 @@ static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 	u32 dummy;
 
 	memset(csig, 0, sizeof(*csig));
-	if (c->x86_vendor != X86_VENDOR_AMD || c->x86 < 0x10) {
+	if (c->x86_vendor != X86_VENDOR_AMD ||
+	    !cpu_has(c, X86_FEATURE_MICROCODE)) {
 		printk(KERN_WARNING "microcode: CPU%d: AMD CPU family 0x%x not "
 		       "supported\n", cpu, c->x86);
 		return -1;
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 149b9ec..c2e128e 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -161,8 +161,8 @@ static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 
 	memset(csig, 0, sizeof(*csig));
 
-	if (c->x86_vendor != X86_VENDOR_INTEL || c->x86 < 6 ||
-	    cpu_has(c, X86_FEATURE_IA64)) {
+	if (c->x86_vendor != X86_VENDOR_INTEL ||
+	    !cpu_has(c, X86_FEATURE_MICROCODE)) {
 		printk(KERN_ERR "microcode: CPU%d not a capable Intel "
 			"processor\n", cpu_num);
 		return -1;


