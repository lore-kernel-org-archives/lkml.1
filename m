Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbZJVMnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbZJVMnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 08:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755494AbZJVMnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 08:43:42 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:51704 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755328AbZJVMlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 08:41:11 -0400
Message-Id: <20091022124111.570692063@spinlock.in.ibm.com>
References: <20091022123743.506956796@spinlock.in.ibm.com>
User-Agent: quilt/0.44-1
Date: Thu, 22 Oct 2009 18:07:52 +0530
From: dino@in.ibm.com
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       John Kacur <jkacur@redhat.com>
Subject: [patch -rt 09/17] x86: move APERF/MPERF into a X86_FEATURE
Content-Disposition: inline; filename=sched-lb-8.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the APERFMPERF capacility into a X86_FEATURE flag so that it can
be used outside of the acpi cpufreq driver.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Dinakar Guniguntala <dino@in.ibm.com>
---
 arch/x86/include/asm/cpufeature.h          |    1 +
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    9 ++-------
 arch/x86/kernel/cpu/intel.c                |    6 ++++++
 3 files changed, 9 insertions(+), 7 deletions(-)

Index: linux-2.6.31.4-rt14/arch/x86/include/asm/cpufeature.h
===================================================================
--- linux-2.6.31.4-rt14.orig/arch/x86/include/asm/cpufeature.h	2009-10-12 16:15:40.000000000 -0400
+++ linux-2.6.31.4-rt14/arch/x86/include/asm/cpufeature.h	2009-10-16 09:15:39.000000000 -0400
@@ -95,6 +95,7 @@
 #define X86_FEATURE_NONSTOP_TSC	(3*32+24) /* TSC does not stop in C states */
 #define X86_FEATURE_CLFLUSH_MONITOR (3*32+25) /* "" clflush reqd with monitor */
 #define X86_FEATURE_EXTD_APICID	(3*32+26) /* has extended APICID (8 bits) */
+#define X86_FEATURE_APERFMPERF	(3*32+27) /* APERFMPERF */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
Index: linux-2.6.31.4-rt14/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
===================================================================
--- linux-2.6.31.4-rt14.orig/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c	2009-10-12 16:15:40.000000000 -0400
+++ linux-2.6.31.4-rt14/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c	2009-10-16 09:15:39.000000000 -0400
@@ -60,7 +60,6 @@
 };
 
 #define INTEL_MSR_RANGE		(0xffff)
-#define CPUID_6_ECX_APERFMPERF_CAPABILITY	(0x1)
 
 struct acpi_cpufreq_data {
 	struct acpi_processor_performance *acpi_data;
@@ -731,12 +730,8 @@
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
Index: linux-2.6.31.4-rt14/arch/x86/kernel/cpu/intel.c
===================================================================
--- linux-2.6.31.4-rt14.orig/arch/x86/kernel/cpu/intel.c	2009-10-12 16:15:40.000000000 -0400
+++ linux-2.6.31.4-rt14/arch/x86/kernel/cpu/intel.c	2009-10-16 09:15:39.000000000 -0400
@@ -349,6 +349,12 @@
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
