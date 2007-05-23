Return-Path: <linux-kernel-owner+w=401wt.eu-S1758401AbXEWWtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401AbXEWWtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 18:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755709AbXEWWtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 18:49:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:18686 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755293AbXEWWtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 18:49:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,571,1170662400"; 
   d="scan'208";a="249025319"
Date: Wed, 23 May 2007 15:46:37 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
       Len Brown <len.brown@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Display Intel Dynamic Acceleration feature in /proc/cpuinfo
Message-ID: <20070523224637.GB15887@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Display Intel Dynamic Acceleration feature in /proc/cpuinfo. This feature
will be enabled automatically by current acpi-cpufreq driver and cpufreq.

Refer to Intel Software Developer's Manual for more details about the feature.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.22-rc-mm/arch/i386/kernel/cpu/proc.c
===================================================================
--- linux-2.6.22-rc-mm.orig/arch/i386/kernel/cpu/proc.c
+++ linux-2.6.22-rc-mm/arch/i386/kernel/cpu/proc.c
@@ -41,7 +41,7 @@ static int show_cpuinfo(struct seq_file 
 		"cxmmx", "k6_mtrr", "cyrix_arr", "centaur_mcr",
 		NULL, NULL, NULL, NULL,
 		"constant_tsc", "up", NULL, NULL, NULL, NULL, NULL, NULL,
-		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
+		"ida", NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 
 		/* Intel-defined (#2) */
Index: linux-2.6.22-rc-mm/arch/x86_64/kernel/setup.c
===================================================================
--- linux-2.6.22-rc-mm.orig/arch/x86_64/kernel/setup.c
+++ linux-2.6.22-rc-mm/arch/x86_64/kernel/setup.c
@@ -949,7 +949,7 @@ static int show_cpuinfo(struct seq_file 
 		/* Other (Linux-defined) */
 		"cxmmx", NULL, "cyrix_arr", "centaur_mcr", NULL,
 		"constant_tsc", NULL, NULL,
-		"up", NULL, NULL, NULL, NULL, NULL, NULL, NULL,
+		"up", NULL, NULL, NULL, "ida", NULL, NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 
Index: linux-2.6.22-rc-mm/include/asm-i386/cpufeature.h
===================================================================
--- linux-2.6.22-rc-mm.orig/include/asm-i386/cpufeature.h
+++ linux-2.6.22-rc-mm/include/asm-i386/cpufeature.h
@@ -81,6 +81,7 @@
 #define X86_FEATURE_BTS		(3*32+13)  /* Branch Trace Store */
 #define X86_FEATURE_LAPIC_TIMER_BROKEN (3*32+ 14) /* lapic timer broken in C1 */
 #define X86_FEATURE_SYNC_RDTSC	(3*32+15)  /* RDTSC synchronizes the CPU */
+#define X86_FEATURE_IDA		(3*32+16)  /* Intel Dynamic Acceleration */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */
Index: linux-2.6.22-rc-mm/include/asm-x86_64/cpufeature.h
===================================================================
--- linux-2.6.22-rc-mm.orig/include/asm-x86_64/cpufeature.h
+++ linux-2.6.22-rc-mm/include/asm-x86_64/cpufeature.h
@@ -70,6 +70,7 @@
 #define X86_FEATURE_ARCH_PERFMON (3*32+9) /* Intel Architectural PerfMon */
 #define X86_FEATURE_PEBS	(3*32+10) /* Precise-Event Based Sampling */
 #define X86_FEATURE_BTS		(3*32+11) /* Branch Trace Store */
+#define X86_FEATURE_IDA		(3*32+12) /* Intel Dynamic Acceleration */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */
Index: linux-2.6.22-rc-mm/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
===================================================================
--- linux-2.6.22-rc-mm.orig/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ linux-2.6.22-rc-mm/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -58,6 +58,7 @@ enum {
 
 #define INTEL_MSR_RANGE		(0xffff)
 #define CPUID_6_ECX_APERFMPERF_CAPABILITY	(0x1)
+#define CPUID_6_EAX_IDA_CAPABILITY		(0x2)
 
 struct acpi_cpufreq_data {
 	struct acpi_processor_performance *acpi_data;
@@ -699,10 +700,20 @@ static int acpi_cpufreq_cpu_init(struct 
 
 	/* Check for APERF/MPERF support in hardware */
 	if (c->x86_vendor == X86_VENDOR_INTEL && c->cpuid_level >= 6) {
-		unsigned int ecx;
+		unsigned int eax, ecx;
 		ecx = cpuid_ecx(6);
 		if (ecx & CPUID_6_ECX_APERFMPERF_CAPABILITY)
 			acpi_cpufreq_driver.getavg = get_measured_perf;
+
+		eax = cpuid_eax(6);
+		if (eax & CPUID_6_EAX_IDA_CAPABILITY) {
+			unsigned int i;
+
+			for_each_cpu_mask(i, policy->cpus) {
+				struct cpuinfo_x86 *c = &cpu_data[i];
+				set_bit(X86_FEATURE_IDA, c->x86_capability);
+			}
+		}
 	}
 
 	dprintk("CPU%u - ACPI performance management activated.\n", cpu);
