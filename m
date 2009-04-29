Return-Path: <linux-kernel-owner+w=401wt.eu-S1759357AbZD2NIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357AbZD2NIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758507AbZD2NGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:06:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:44540 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758313AbZD2NGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:06:18 -0400
Date: Wed, 29 Apr 2009 13:05:47 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1241002046-8832-14-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-14-git-send-email-robert.richter@amd.com>
Subject: [tip:perfcounters/core] perf_counter, x86: modify initialization of struct x86_pmu
Message-ID: <tip-72eae04d3a3075c26d39e1e685acfc8e8c29db64@git.kernel.org>
Git-Commit-ID: 72eae04d3a3075c26d39e1e685acfc8e8c29db64
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 13:05:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  72eae04d3a3075c26d39e1e685acfc8e8c29db64
Gitweb:     http://git.kernel.org/tip/72eae04d3a3075c26d39e1e685acfc8e8c29db64
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 29 Apr 2009 12:47:10 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 14:51:07 +0200

perf_counter, x86: modify initialization of struct x86_pmu

This patch adds an error handler and changes initialization of struct
x86_pmu. No functional changes. Needed for follow-on patches.

[ Impact: cleanup ]

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1241002046-8832-14-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
