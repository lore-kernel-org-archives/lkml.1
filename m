Return-Path: <linux-kernel-owner+w=401wt.eu-S1756624AbZD2O7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbZD2O7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 10:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbZD2O65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 10:58:57 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:4346 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbZD2O65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 10:58:57 -0400
X-BigFish: VPS-31(zz1432R98dR936eQ1805Mzz1202hzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KIVAXP-03-FJ8-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH] perf_counter, x86: rename bitmasks to ->used_mask and ->active_mask
Date: Wed, 29 Apr 2009 16:55:56 +0200
Message-ID: <1241016956-24648-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <20090429131029.GA24485@elte.hu>
References: <20090429131029.GA24485@elte.hu>
X-OriginalArrivalTime: 29 Apr 2009 14:58:39.0368 (UTC) FILETIME=[FAD86080:01C9C8DA]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 9390496 (perf_counter, x86: rename
cpuc->active_mask). Instead, cpuc->used is renamed to
cpuc->used_mask. See Ingo's comment:

On 29.04.09 13:24:23, Ingo Molnar wrote:
> better would be to change ->used to ->used_mask. That makes it sure
> nobody does this typo:
>
>       if (cpuc->used)
>
> it's a lot harder to typo this:
>
>       if (cpuc->used_mask)
>

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_counter.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 47e563b..fc06f4d 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -28,8 +28,8 @@ static u64 perf_counter_mask __read_mostly;
 
 struct cpu_hw_counters {
 	struct perf_counter	*counters[X86_PMC_IDX_MAX];
-	unsigned long		used[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
-	unsigned long		active[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	unsigned long		used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	unsigned long		active_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	unsigned long		interrupts;
 	u64			throttle_ctrl;
 	int			enabled;
@@ -332,7 +332,7 @@ static u64 amd_pmu_save_disable_all(void)
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		u64 val;
 
-		if (!test_bit(idx, cpuc->active))
+		if (!test_bit(idx, cpuc->active_mask))
 			continue;
 		rdmsrl(MSR_K7_EVNTSEL0 + idx, val);
 		if (!(val & ARCH_PERFMON_EVENTSEL0_ENABLE))
@@ -373,7 +373,7 @@ static void amd_pmu_restore_all(u64 ctrl)
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		u64 val;
 
-		if (!test_bit(idx, cpuc->active))
+		if (!test_bit(idx, cpuc->active_mask))
 			continue;
 		rdmsrl(MSR_K7_EVNTSEL0 + idx, val);
 		if (val & ARCH_PERFMON_EVENTSEL0_ENABLE)
@@ -576,7 +576,7 @@ static int x86_pmu_enable(struct perf_counter *counter)
 		 * Try to get the fixed counter, if that is already taken
 		 * then try to get a generic counter:
 		 */
-		if (test_and_set_bit(idx, cpuc->used))
+		if (test_and_set_bit(idx, cpuc->used_mask))
 			goto try_generic;
 
 		hwc->config_base = MSR_ARCH_PERFMON_FIXED_CTR_CTRL;
@@ -590,14 +590,14 @@ static int x86_pmu_enable(struct perf_counter *counter)
 	} else {
 		idx = hwc->idx;
 		/* Try to get the previous generic counter again */
-		if (test_and_set_bit(idx, cpuc->used)) {
+		if (test_and_set_bit(idx, cpuc->used_mask)) {
 try_generic:
-			idx = find_first_zero_bit(cpuc->used,
+			idx = find_first_zero_bit(cpuc->used_mask,
 						  x86_pmu.num_counters);
 			if (idx == x86_pmu.num_counters)
 				return -EAGAIN;
 
-			set_bit(idx, cpuc->used);
+			set_bit(idx, cpuc->used_mask);
 			hwc->idx = idx;
 		}
 		hwc->config_base  = x86_pmu.eventsel;
@@ -609,7 +609,7 @@ try_generic:
 	x86_pmu.disable(hwc, idx);
 
 	cpuc->counters[idx] = counter;
-	set_bit(idx, cpuc->active);
+	set_bit(idx, cpuc->active_mask);
 
 	x86_perf_counter_set_period(counter, hwc, idx);
 	x86_pmu.enable(hwc, idx);
@@ -643,7 +643,7 @@ void perf_counter_print_debug(void)
 		pr_info("CPU#%d: overflow:   %016llx\n", cpu, overflow);
 		pr_info("CPU#%d: fixed:      %016llx\n", cpu, fixed);
 	}
-	pr_info("CPU#%d: used:       %016llx\n", cpu, *(u64 *)cpuc->used);
+	pr_info("CPU#%d: used:       %016llx\n", cpu, *(u64 *)cpuc->used_mask);
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		rdmsrl(x86_pmu.eventsel + idx, pmc_ctrl);
@@ -677,7 +677,7 @@ static void x86_pmu_disable(struct perf_counter *counter)
 	 * Must be done before we disable, otherwise the nmi handler
 	 * could reenable again:
 	 */
-	clear_bit(idx, cpuc->active);
+	clear_bit(idx, cpuc->active_mask);
 	x86_pmu.disable(hwc, idx);
 
 	/*
@@ -692,7 +692,7 @@ static void x86_pmu_disable(struct perf_counter *counter)
 	 */
 	x86_perf_counter_update(counter, hwc, idx);
 	cpuc->counters[idx] = NULL;
-	clear_bit(idx, cpuc->used);
+	clear_bit(idx, cpuc->used_mask);
 }
 
 /*
@@ -741,7 +741,7 @@ again:
 		struct perf_counter *counter = cpuc->counters[bit];
 
 		clear_bit(bit, (unsigned long *) &status);
-		if (!test_bit(bit, cpuc->active))
+		if (!test_bit(bit, cpuc->active_mask))
 			continue;
 
 		intel_pmu_save_and_restart(counter);
@@ -779,7 +779,7 @@ static int amd_pmu_handle_irq(struct pt_regs *regs, int nmi)
 
 	++cpuc->interrupts;
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
-		if (!test_bit(idx, cpuc->active))
+		if (!test_bit(idx, cpuc->active_mask))
 			continue;
 		counter = cpuc->counters[idx];
 		hwc = &counter->hw;
-- 
1.6.1.3


