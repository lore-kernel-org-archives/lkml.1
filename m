Return-Path: <linux-kernel-owner+w=401wt.eu-S1759665AbZD2NJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759665AbZD2NJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758647AbZD2NGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:06:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:44570 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715AbZD2NGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:06:44 -0400
Date: Wed, 29 Apr 2009 13:06:10 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1241002046-8832-16-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-16-git-send-email-robert.richter@amd.com>
Subject: [tip:perfcounters/core] perf_counter, x86: move counter parameters to struct x86_pmu
Message-ID: <tip-0933e5c6a680ba8d8d786a6f7fa377b7ec0d1e49@git.kernel.org>
Git-Commit-ID: 0933e5c6a680ba8d8d786a6f7fa377b7ec0d1e49
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 13:06:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0933e5c6a680ba8d8d786a6f7fa377b7ec0d1e49
Gitweb:     http://git.kernel.org/tip/0933e5c6a680ba8d8d786a6f7fa377b7ec0d1e49
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 29 Apr 2009 12:47:12 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 14:51:08 +0200

perf_counter, x86: move counter parameters to struct x86_pmu

[ Impact: refactor and generalize code ]

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1241002046-8832-16-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |   80 ++++++++++++++++-------------------
 1 files changed, 37 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 68597d7..75dbb1f 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -24,16 +24,7 @@
 #include <asm/nmi.h>
 
 static bool perf_counters_initialized __read_mostly;
-
-/*
- * Number of (generic) HW counters:
- */
-static int nr_counters_generic __read_mostly;
 static u64 perf_counter_mask __read_mostly;
-static u64 counter_value_mask __read_mostly;
-static int counter_value_bits __read_mostly;
-
-static int nr_counters_fixed __read_mostly;
 
 struct cpu_hw_counters {
 	struct perf_counter	*counters[X86_PMC_IDX_MAX];
@@ -58,6 +49,10 @@ struct x86_pmu {
 	u64		(*event_map)(int);
 	u64		(*raw_event)(u64);
 	int		max_events;
+	int		num_counters;
+	int		num_counters_fixed;
+	int		counter_bits;
+	u64		counter_mask;
 };
 
 static struct x86_pmu x86_pmu __read_mostly;
@@ -183,12 +178,12 @@ static bool reserve_pmc_hardware(void)
 	if (nmi_watchdog == NMI_LOCAL_APIC)
 		disable_lapic_nmi_watchdog();
 
-	for (i = 0; i < nr_counters_generic; i++) {
+	for (i = 0; i < x86_pmu.num_counters; i++) {
 		if (!reserve_perfctr_nmi(x86_pmu.perfctr + i))
 			goto perfctr_fail;
 	}
 
-	for (i = 0; i < nr_counters_generic; i++) {
+	for (i = 0; i < x86_pmu.num_counters; i++) {
 		if (!reserve_evntsel_nmi(x86_pmu.eventsel + i))
 			goto eventsel_fail;
 	}
@@ -199,7 +194,7 @@ eventsel_fail:
 	for (i--; i >= 0; i--)
 		release_evntsel_nmi(x86_pmu.eventsel + i);
 
-	i = nr_counters_generic;
+	i = x86_pmu.num_counters;
 
 perfctr_fail:
 	for (i--; i >= 0; i--)
@@ -215,7 +210,7 @@ static void release_pmc_hardware(void)
 {
 	int i;
 
-	for (i = 0; i < nr_counters_generic; i++) {
+	for (i = 0; i < x86_pmu.num_counters; i++) {
 		release_perfctr_nmi(x86_pmu.perfctr + i);
 		release_evntsel_nmi(x86_pmu.eventsel + i);
 	}
@@ -336,7 +331,7 @@ static u64 amd_pmu_save_disable_all(void)
 	 */
 	barrier();
 
-	for (idx = 0; idx < nr_counters_generic; idx++) {
+	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		u64 val;
 
 		if (!test_bit(idx, cpuc->active_mask))
@@ -378,7 +373,7 @@ static void amd_pmu_restore_all(u64 ctrl)
 	if (!ctrl)
 		return;
 
-	for (idx = 0; idx < nr_counters_generic; idx++) {
+	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		u64 val;
 
 		if (!test_bit(idx, cpuc->active_mask))
@@ -527,7 +522,7 @@ x86_perf_counter_set_period(struct perf_counter *counter,
 	atomic64_set(&hwc->prev_count, (u64)-left);
 
 	err = checking_wrmsrl(hwc->counter_base + idx,
-			     (u64)(-left) & counter_value_mask);
+			     (u64)(-left) & x86_pmu.counter_mask);
 }
 
 static inline void
@@ -621,8 +616,9 @@ static int x86_pmu_enable(struct perf_counter *counter)
 		/* Try to get the previous generic counter again */
 		if (test_and_set_bit(idx, cpuc->used)) {
 try_generic:
-			idx = find_first_zero_bit(cpuc->used, nr_counters_generic);
-			if (idx == nr_counters_generic)
+			idx = find_first_zero_bit(cpuc->used,
+						  x86_pmu.num_counters);
+			if (idx == x86_pmu.num_counters)
 				return -EAGAIN;
 
 			set_bit(idx, cpuc->used);
@@ -654,7 +650,7 @@ void perf_counter_print_debug(void)
 	struct cpu_hw_counters *cpuc;
 	int cpu, idx;
 
-	if (!nr_counters_generic)
+	if (!x86_pmu.num_counters)
 		return;
 
 	local_irq_disable();
@@ -676,7 +672,7 @@ void perf_counter_print_debug(void)
 	}
 	pr_info("CPU#%d: used:       %016llx\n", cpu, *(u64 *)cpuc->used);
 
-	for (idx = 0; idx < nr_counters_generic; idx++) {
+	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		rdmsrl(x86_pmu.eventsel + idx, pmc_ctrl);
 		rdmsrl(x86_pmu.perfctr  + idx, pmc_count);
 
@@ -689,7 +685,7 @@ void perf_counter_print_debug(void)
 		pr_info("CPU#%d:   gen-PMC%d left:  %016llx\n",
 			cpu, idx, prev_left);
 	}
-	for (idx = 0; idx < nr_counters_fixed; idx++) {
+	for (idx = 0; idx < x86_pmu.num_counters_fixed; idx++) {
 		rdmsrl(MSR_ARCH_PERFMON_FIXED_CTR0 + idx, pmc_count);
 
 		pr_info("CPU#%d: fixed-PMC%d count: %016llx\n",
@@ -911,6 +907,9 @@ static struct x86_pmu amd_pmu = {
 	.event_map		= amd_pmu_event_map,
 	.raw_event		= amd_pmu_raw_event,
 	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
+	.num_counters		= 4,
+	.counter_bits		= 48,
+	.counter_mask		= (1ULL << 48) - 1,
 };
 
 static int intel_pmu_init(void)
@@ -941,10 +940,10 @@ static int intel_pmu_init(void)
 	pr_info("... mask length:     %d\n", eax.split.mask_length);
 
 	x86_pmu = intel_pmu;
-
-	nr_counters_generic = eax.split.num_counters;
-	nr_counters_fixed = edx.split.num_counters_fixed;
-	counter_value_mask = (1ULL << eax.split.bit_width) - 1;
+	x86_pmu.num_counters = eax.split.num_counters;
+	x86_pmu.num_counters_fixed = edx.split.num_counters_fixed;
+	x86_pmu.counter_bits = eax.split.bit_width;
+	x86_pmu.counter_mask = (1ULL << eax.split.bit_width) - 1;
 
 	return 0;
 }
@@ -952,12 +951,6 @@ static int intel_pmu_init(void)
 static int amd_pmu_init(void)
 {
 	x86_pmu = amd_pmu;
-
-	nr_counters_generic = 4;
-	nr_counters_fixed = 0;
-	counter_value_mask = 0x0000FFFFFFFFFFFFULL;
-	counter_value_bits = 48;
-
 	pr_info("AMD Performance Monitoring support detected.\n");
 	return 0;
 }
@@ -979,25 +972,26 @@ void __init init_hw_perf_counters(void)
 	if (err != 0)
 		return;
 
-	pr_info("... num counters:    %d\n", nr_counters_generic);
-	if (nr_counters_generic > X86_PMC_MAX_GENERIC) {
-		nr_counters_generic = X86_PMC_MAX_GENERIC;
+	pr_info("... num counters:    %d\n", x86_pmu.num_counters);
+	if (x86_pmu.num_counters > X86_PMC_MAX_GENERIC) {
+		x86_pmu.num_counters = X86_PMC_MAX_GENERIC;
 		WARN(1, KERN_ERR "hw perf counters %d > max(%d), clipping!",
-			nr_counters_generic, X86_PMC_MAX_GENERIC);
+		     x86_pmu.num_counters, X86_PMC_MAX_GENERIC);
 	}
-	perf_counter_mask = (1 << nr_counters_generic) - 1;
-	perf_max_counters = nr_counters_generic;
+	perf_counter_mask = (1 << x86_pmu.num_counters) - 1;
+	perf_max_counters = x86_pmu.num_counters;
 
-	pr_info("... value mask:      %016Lx\n", counter_value_mask);
+	pr_info("... value mask:      %016Lx\n", x86_pmu.counter_mask);
 
-	if (nr_counters_fixed > X86_PMC_MAX_FIXED) {
-		nr_counters_fixed = X86_PMC_MAX_FIXED;
+	if (x86_pmu.num_counters_fixed > X86_PMC_MAX_FIXED) {
+		x86_pmu.num_counters_fixed = X86_PMC_MAX_FIXED;
 		WARN(1, KERN_ERR "hw perf counters fixed %d > max(%d), clipping!",
-			nr_counters_fixed, X86_PMC_MAX_FIXED);
+		     x86_pmu.num_counters_fixed, X86_PMC_MAX_FIXED);
 	}
-	pr_info("... fixed counters:  %d\n", nr_counters_fixed);
+	pr_info("... fixed counters:  %d\n", x86_pmu.num_counters_fixed);
 
-	perf_counter_mask |= ((1LL << nr_counters_fixed)-1) << X86_PMC_IDX_FIXED;
+	perf_counter_mask |=
+		((1LL << x86_pmu.num_counters_fixed)-1) << X86_PMC_IDX_FIXED;
 
 	pr_info("... counter mask:    %016Lx\n", perf_counter_mask);
 	perf_counters_initialized = true;
