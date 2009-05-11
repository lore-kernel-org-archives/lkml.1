Return-Path: <linux-kernel-owner+w=401wt.eu-S1758567AbZEKRDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567AbZEKRDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758202AbZEKRBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:01:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:43746 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758187AbZEKRBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:01:31 -0400
Subject: [PATCH 14/15 -tip] x86: Add cpufeature for performance frequency
 APERF/MPERF
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Robert Richter <robert.richter@amd.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1242060858.5139.23.camel@ht.satnam>
References: <1242058494.5139.7.camel@ht.satnam>
	 <1242060119.5139.9.camel@ht.satnam>  <1242060207.5139.11.camel@ht.satnam>
	 <1242060254.5139.12.camel@ht.satnam>  <1242060301.5139.13.camel@ht.satnam>
	 <1242060523.5139.15.camel@ht.satnam>  <1242060567.5139.16.camel@ht.satnam>
	 <1242060601.5139.17.camel@ht.satnam>  <1242060644.5139.18.camel@ht.satnam>
	 <1242060681.5139.19.camel@ht.satnam>  <1242060721.5139.20.camel@ht.satnam>
	 <1242060771.5139.21.camel@ht.satnam>  <1242060812.5139.22.camel@ht.satnam>
	 <1242060858.5139.23.camel@ht.satnam>
Content-Type: text/plain
Date: Mon, 11 May 2009 22:25:05 +0530
Message-Id: <1242060905.5139.24.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


X86_FEATURE_PERF_FREQ : Hardware Coordination Feedback Capability
                        (Presence of IA32_APERF, IA32_MPERF MSRs)

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpufeature.h          |    1 +
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    9 ++-------
 arch/x86/kernel/cpu/intel.c                |    9 +++++++++
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index aee0978..b91cb47 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -168,6 +168,7 @@
 #define X86_FEATURE_SMM 	(7*32+ 13) /* System Management	Mode	*/
 #define X86_FEATURE_MM_CFG 	(7*32+ 14) /* MM configuration		*/
 #define X86_FEATURE_BUS_CFG 	(7*32+ 15) /* Bus configuration		*/
+#define X86_FEATURE_PERF_FREQ 	(7*32+ 16) /* Performance frequency	*/
 
 /* Virtualization flags: Linux defined */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
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
index 9c8f386..9c5169c 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -469,6 +469,15 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 			break;
 		}
 	}
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
-- 
1.6.0.6



