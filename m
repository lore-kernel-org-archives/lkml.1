Return-Path: <linux-kernel-owner+w=401wt.eu-S1758319AbZD2Kzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319AbZD2Kzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 06:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755965AbZD2KvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:51:22 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:23631
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755238AbZD2KvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:51:09 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0KIUZGS-01-7AH-01
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 21/29] x86/perfcounters: rework counter enable functions
Date: Wed, 29 Apr 2009 12:47:18 +0200
Message-ID: <1241002046-8832-22-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 29 Apr 2009 10:50:49.0539 (UTC) FILETIME=[5BBC8930:01C9C8B8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is vendor specific code in generic x86 code, and there is vendor
specific code that could be generic. This patch introduces
x86_pmu_enable_counter() for x86 generic code. Fixed counter code for
Intel is moved to Intel only functions. In the end, checks and calls
via function pointers were reduced to the necessary. Also, the
internal function i/f changed.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_counter.c |   52 ++++++++++++++++-------------------
 1 files changed, 24 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index d8beebe..ae55933 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -44,7 +44,7 @@ struct x86_pmu {
 	int		(*handle_irq)(struct pt_regs *, int);
 	u64		(*save_disable_all)(void);
 	void		(*restore_all)(u64);
-	void		(*enable)(int, u64);
+	void		(*enable)(struct hw_perf_counter *, int);
 	void		(*disable)(int, u64);
 	unsigned	eventsel;
 	unsigned	perfctr;
@@ -414,28 +414,15 @@ static inline void intel_pmu_ack_status(u64 ack)
 	wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, ack);
 }
 
-static void intel_pmu_enable_counter(int idx, u64 config)
+static inline void x86_pmu_enable_counter(struct hw_perf_counter *hwc, int idx)
 {
-	wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + idx,
-			config | ARCH_PERFMON_EVENTSEL0_ENABLE);
-}
-
-static void amd_pmu_enable_counter(int idx, u64 config)
-{
-	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
-
-	if (cpuc->enabled)
-		config |= ARCH_PERFMON_EVENTSEL0_ENABLE;
-
-	wrmsrl(MSR_K7_EVNTSEL0 + idx, config);
-}
+	int err;
 
-static void hw_perf_enable(int idx, u64 config)
-{
 	if (unlikely(!perf_counters_initialized))
 		return;
 
-	x86_pmu.enable(idx, config);
+	err = checking_wrmsrl(hwc->config_base + idx,
+			      hwc->config | ARCH_PERFMON_EVENTSEL0_ENABLE);
 }
 
 static void intel_pmu_disable_counter(int idx, u64 config)
@@ -522,8 +509,7 @@ x86_perf_counter_set_period(struct perf_counter *counter,
 }
 
 static inline void
-__pmc_fixed_enable(struct perf_counter *counter,
-		   struct hw_perf_counter *hwc, int __idx)
+intel_pmu_enable_fixed(struct hw_perf_counter *hwc, int __idx)
 {
 	int idx = __idx - X86_PMC_IDX_FIXED;
 	u64 ctrl_val, bits, mask;
@@ -548,14 +534,24 @@ __pmc_fixed_enable(struct perf_counter *counter,
 	err = checking_wrmsrl(hwc->config_base, ctrl_val);
 }
 
-static void
-__x86_pmu_enable(struct perf_counter *counter,
-		 struct hw_perf_counter *hwc, int idx)
+static void intel_pmu_enable_counter(struct hw_perf_counter *hwc, int idx)
 {
-	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL))
-		__pmc_fixed_enable(counter, hwc, idx);
+	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
+		intel_pmu_enable_fixed(hwc, idx);
+		return;
+	}
+
+	x86_pmu_enable_counter(hwc, idx);
+}
+
+static void amd_pmu_enable_counter(struct hw_perf_counter *hwc, int idx)
+{
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+
+	if (cpuc->enabled)
+		x86_pmu_enable_counter(hwc, idx);
 	else
-		hw_perf_enable(idx, hwc->config);
+		amd_pmu_disable_counter(idx, hwc->config);
 }
 
 static int
@@ -632,7 +628,7 @@ try_generic:
 	set_bit(idx, cpuc->active);
 
 	x86_perf_counter_set_period(counter, hwc, idx);
-	__x86_pmu_enable(counter, hwc, idx);
+	x86_pmu.enable(hwc, idx);
 
 	return 0;
 }
@@ -728,7 +724,7 @@ static void intel_pmu_save_and_restart(struct perf_counter *counter)
 	x86_perf_counter_set_period(counter, hwc, idx);
 
 	if (counter->state == PERF_COUNTER_STATE_ACTIVE)
-		__x86_pmu_enable(counter, hwc, idx);
+		intel_pmu_enable_counter(hwc, idx);
 }
 
 /*
-- 
1.6.1.3


