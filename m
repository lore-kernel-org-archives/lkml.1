Return-Path: <linux-kernel-owner+w=401wt.eu-S1754097AbZICNX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbZICNX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 09:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbZICNXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 09:23:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37068 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbZICNXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 09:23:19 -0400
Message-Id: <20090903132212.914248136@chello.nl>
References: <20090903132145.482814810@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 03 Sep 2009 15:21:54 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>, Dave Jones <davej@redhat.com>,
       Len Brown <len.brown@intel.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       cpufreq@vger.kernel.org
Subject: [RFC][PATCH 09/14] x86: move APERF/MPERF into a X86_FEATURE
Content-Disposition: inline; filename=sched-lb-8.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the APERFMPERF capacility into a X86_FEATURE flag so that it can
be used outside of the acpi cpufreq driver.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Yanmin <yanmin_zhang@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: cpufreq@vger.kernel.org
---
 arch/x86/include/asm/cpufeature.h          |    1 +
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    9 ++-------
 arch/x86/kernel/cpu/intel.c                |    6 ++++++
 3 files changed, 9 insertions(+), 7 deletions(-)

Index: linux-2.6/arch/x86/include/asm/cpufeature.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/cpufeature.h
+++ linux-2.6/arch/x86/include/asm/cpufeature.h
@@ -95,6 +95,7 @@
 #define X86_FEATURE_NONSTOP_TSC	(3*32+24) /* TSC does not stop in C states */
 #define X86_FEATURE_CLFLUSH_MONITOR (3*32+25) /* "" clflush reqd with monitor */
 #define X86_FEATURE_EXTD_APICID	(3*32+26) /* has extended APICID (8 bits) */
+#define X86_FEATURE_APERFMPERF	(3*32+27) /* APERFMPERF */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
Index: linux-2.6/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ linux-2.6/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -60,7 +60,6 @@ enum {
 };
 
 #define INTEL_MSR_RANGE		(0xffff)
-#define CPUID_6_ECX_APERFMPERF_CAPABILITY	(0x1)
 
 struct acpi_cpufreq_data {
 	struct acpi_processor_performance *acpi_data;
@@ -731,12 +730,8 @@ static int acpi_cpufreq_cpu_init(struct 
 	acpi_processor_notify_smm(THIS_MODULE);
 
 	/* Check for APERF/MPERF support in hardware */
-	if (c->x86_vendor == X86_VENDOR_INTEL && c->cpuid_level >= 6) {
-		unsigned int ecx;
-		ecx = cpuid_ecx(6);
-		if (ecx & CPUID_6_ECX_APERFMPERF_CAPABILITY)
-			acpi_cpufreq_driver.getavg = get_measured_perf;
-	}
+	if (cpu_has(c, X86_FEATURE_APERFMPERF))
+		acpi_cpufreq_driver.getavg = get_measured_perf;
 
 	dprintk("CPU%u - ACPI performance management activated.\n", cpu);
 	for (i = 0; i < perf->state_count; i++)
Index: linux-2.6/arch/x86/kernel/cpu/intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/intel.c
+++ linux-2.6/arch/x86/kernel/cpu/intel.c
@@ -350,6 +350,12 @@ static void __cpuinit init_intel(struct 
 			set_cpu_cap(c, X86_FEATURE_ARCH_PERFMON);
 	}
 
+	if (c->cpuid_level > 6) {
+		unsigned ecx = cpuid_ecx(6);
+		if (ecx & 0x01)
+			set_cpu_cap(c, X86_FEATURE_APERFMPERF);
+	}
+
 	if (cpu_has_xmm2)
 		set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
 	if (cpu_has_ds) {

-- 

