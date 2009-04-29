Return-Path: <linux-kernel-owner+w=401wt.eu-S1759627AbZD2LA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627AbZD2LA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756465AbZD2Kvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:51:49 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:7142 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755608AbZD2Kvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:51:47 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j)
X-FB-SS: 5,
X-WSS-ID: 0KIUZGW-03-8MD-01
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 22/29] x86/perfcounters: rework counter disable functions
Date: Wed, 29 Apr 2009 12:47:19 +0200
Message-ID: <1241002046-8832-23-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 29 Apr 2009 10:50:49.0602 (UTC) FILETIME=[5BC62620:01C9C8B8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As for the enable function, this patch reworks the disable functions
and introduces x86_pmu_disable_counter(). The internal function i/f in
struct x86_pmu changed too.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_counter.c |   48 +++++++++++++++++------------------
 1 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index ae55933..df9012b 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -45,7 +45,7 @@ struct x86_pmu {
 	u64		(*save_disable_all)(void);
 	void		(*restore_all)(u64);
 	void		(*enable)(struct hw_perf_counter *, int);
-	void		(*disable)(int, u64);
+	void		(*disable)(struct hw_perf_counter *, int);
 	unsigned	eventsel;
 	unsigned	perfctr;
 	u64		(*event_map)(int);
@@ -425,28 +425,19 @@ static inline void x86_pmu_enable_counter(struct hw_perf_counter *hwc, int idx)
 			      hwc->config | ARCH_PERFMON_EVENTSEL0_ENABLE);
 }
 
-static void intel_pmu_disable_counter(int idx, u64 config)
+static inline void x86_pmu_disable_counter(struct hw_perf_counter *hwc, int idx)
 {
-	wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + idx, config);
-}
-
-static void amd_pmu_disable_counter(int idx, u64 config)
-{
-	wrmsrl(MSR_K7_EVNTSEL0 + idx, config);
-
-}
+	int err;
 
-static void hw_perf_disable(int idx, u64 config)
-{
 	if (unlikely(!perf_counters_initialized))
 		return;
 
-	x86_pmu.disable(idx, config);
+	err = checking_wrmsrl(hwc->config_base + idx,
+			      hwc->config);
 }
 
 static inline void
-__pmc_fixed_disable(struct perf_counter *counter,
-		    struct hw_perf_counter *hwc, int __idx)
+intel_pmu_disable_fixed(struct hw_perf_counter *hwc, int __idx)
 {
 	int idx = __idx - X86_PMC_IDX_FIXED;
 	u64 ctrl_val, mask;
@@ -460,13 +451,20 @@ __pmc_fixed_disable(struct perf_counter *counter,
 }
 
 static inline void
-__x86_pmu_disable(struct perf_counter *counter,
-		  struct hw_perf_counter *hwc, int idx)
+intel_pmu_disable_counter(struct hw_perf_counter *hwc, int idx)
 {
-	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL))
-		__pmc_fixed_disable(counter, hwc, idx);
-	else
-		hw_perf_disable(idx, hwc->config);
+	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
+		intel_pmu_disable_fixed(hwc, idx);
+		return;
+	}
+
+	x86_pmu_disable_counter(hwc, idx);
+}
+
+static inline void
+amd_pmu_disable_counter(struct hw_perf_counter *hwc, int idx)
+{
+	x86_pmu_disable_counter(hwc, idx);
 }
 
 static DEFINE_PER_CPU(u64, prev_left[X86_PMC_IDX_MAX]);
@@ -551,7 +549,7 @@ static void amd_pmu_enable_counter(struct hw_perf_counter *hwc, int idx)
 	if (cpuc->enabled)
 		x86_pmu_enable_counter(hwc, idx);
 	else
-		amd_pmu_disable_counter(idx, hwc->config);
+		x86_pmu_disable_counter(hwc, idx);
 }
 
 static int
@@ -622,7 +620,7 @@ try_generic:
 
 	perf_counters_lapic_init(hwc->nmi);
 
-	__x86_pmu_disable(counter, hwc, idx);
+	x86_pmu.disable(hwc, idx);
 
 	cpuc->counters[idx] = counter;
 	set_bit(idx, cpuc->active);
@@ -694,7 +692,7 @@ static void x86_pmu_disable(struct perf_counter *counter)
 	 * could reenable again:
 	 */
 	clear_bit(idx, cpuc->active);
-	__x86_pmu_disable(counter, hwc, idx);
+	x86_pmu.disable(hwc, idx);
 
 	/*
 	 * Make sure the cleared pointer becomes visible before we
@@ -762,7 +760,7 @@ again:
 
 		intel_pmu_save_and_restart(counter);
 		if (perf_counter_overflow(counter, nmi, regs, 0))
-			__x86_pmu_disable(counter, &counter->hw, bit);
+			intel_pmu_disable_counter(&counter->hw, bit);
 	}
 
 	intel_pmu_ack_status(ack);
-- 
1.6.1.3


