Return-Path: <linux-kernel-owner+w=401wt.eu-S1757830AbZD2KyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830AbZD2KyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 06:54:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbZD2KvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:51:17 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:9919 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbZD2KvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:51:04 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KIUZGR-04-0X5-01
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 13/29] x86/perfcounters: modify initialization of struct x86_pmu
Date: Wed, 29 Apr 2009 12:47:10 +0200
Message-ID: <1241002046-8832-14-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 29 Apr 2009 10:50:49.0352 (UTC) FILETIME=[5BA00080:01C9C8B8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an error handler and changes initialization of struct
x86_pmu. No functional changes. Needed for follow-on patches.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_counter.c |   27 ++++++++++++++++-----------
 1 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 5a52d73..7c72a94 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -913,7 +913,7 @@ static struct x86_pmu amd_pmu = {
 	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
 };
 
-static struct x86_pmu *intel_pmu_init(void)
+static int intel_pmu_init(void)
 {
 	union cpuid10_edx edx;
 	union cpuid10_eax eax;
@@ -921,7 +921,7 @@ static struct x86_pmu *intel_pmu_init(void)
 	unsigned int ebx;
 
 	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
-		return NULL;
+		return -ENODEV;
 
 	/*
 	 * Check whether the Architectural PerfMon supports
@@ -929,49 +929,54 @@ static struct x86_pmu *intel_pmu_init(void)
 	 */
 	cpuid(10, &eax.full, &ebx, &unused, &edx.full);
 	if (eax.split.mask_length <= ARCH_PERFMON_BRANCH_MISSES_RETIRED)
-		return NULL;
+		return -ENODEV;
 
 	intel_perfmon_version = eax.split.version_id;
 	if (intel_perfmon_version < 2)
-		return NULL;
+		return -ENODEV;
 
 	pr_info("Intel Performance Monitoring support detected.\n");
 	pr_info("... version:         %d\n", intel_perfmon_version);
 	pr_info("... bit width:       %d\n", eax.split.bit_width);
 	pr_info("... mask length:     %d\n", eax.split.mask_length);
 
+	x86_pmu = &intel_pmu;
+
 	nr_counters_generic = eax.split.num_counters;
 	nr_counters_fixed = edx.split.num_counters_fixed;
 	counter_value_mask = (1ULL << eax.split.bit_width) - 1;
 
-	return &intel_pmu;
+	return 0;
 }
 
-static struct x86_pmu *amd_pmu_init(void)
+static int amd_pmu_init(void)
 {
+	x86_pmu = &amd_pmu;
+
 	nr_counters_generic = 4;
 	nr_counters_fixed = 0;
 	counter_value_mask = 0x0000FFFFFFFFFFFFULL;
 	counter_value_bits = 48;
 
 	pr_info("AMD Performance Monitoring support detected.\n");
-
-	return &amd_pmu;
+	return 0;
 }
 
 void __init init_hw_perf_counters(void)
 {
+	int err;
+
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_INTEL:
-		x86_pmu = intel_pmu_init();
+		err = intel_pmu_init();
 		break;
 	case X86_VENDOR_AMD:
-		x86_pmu = amd_pmu_init();
+		err = amd_pmu_init();
 		break;
 	default:
 		return;
 	}
-	if (!x86_pmu)
+	if (err != 0)
 		return;
 
 	pr_info("... num counters:    %d\n", nr_counters_generic);
-- 
1.6.1.3


