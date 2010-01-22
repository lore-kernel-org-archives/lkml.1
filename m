Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917Ab0AVOzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab0AVOzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 09:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754665Ab0AVOzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 09:55:52 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:4813 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab0AVOzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 09:55:42 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzab9bh936eMzz1202hzzz32i87h6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KWNLFK-02-1LF-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@googlemail.com>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 02/12] perf/core, x86: undo some some *_counter* -> *_event* renames
Date: Fri, 22 Jan 2010 15:21:57 +0100
Message-ID: <1264170127-17402-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264170127-17402-1-git-send-email-robert.richter@amd.com>
References: <1264170127-17402-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jan 2010 14:54:55.0268 (UTC) FILETIME=[DBFA6E40:01CA9B72]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The big rename

 cdd6c48 perf: Do the big rename: Performance Counters -> Performance Events

accidentally renamed some members of stucts that were named after
registers in the spec. To avoid confusion this patch reverts some
changes. The related specs are MSR descriptions in AMD's BKDGs and the
ARCHITECTURAL PERFORMANCE MONITORING section in the Intel 64 and IA-32
Architectures Software Developer's Manuals.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/perf_event.h |    4 +-
 arch/x86/kernel/cpu/perf_event.c  |   96 ++++++++++++++++++------------------
 arch/x86/oprofile/op_model_ppro.c |    4 +-
 3 files changed, 52 insertions(+), 52 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 8d9f854..1f50cfc 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -54,7 +54,7 @@
 union cpuid10_eax {
 	struct {
 		unsigned int version_id:8;
-		unsigned int num_events:8;
+		unsigned int num_counters:8;
 		unsigned int bit_width:8;
 		unsigned int mask_length:8;
 	} split;
@@ -63,7 +63,7 @@ union cpuid10_eax {
 
 union cpuid10_edx {
 	struct {
-		unsigned int num_events_fixed:4;
+		unsigned int num_counters_fixed:4;
 		unsigned int reserved:28;
 	} split;
 	unsigned int full;
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index b1bb8c5..c3f920a 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -105,10 +105,10 @@ struct x86_pmu {
 	u64		(*event_map)(int);
 	u64		(*raw_event)(u64);
 	int		max_events;
-	int		num_events;
-	int		num_events_fixed;
-	int		event_bits;
-	u64		event_mask;
+	int		num_counters;
+	int		num_counters_fixed;
+	int		cntval_bits;
+	u64		cntval_mask;
 	int		apic;
 	u64		max_period;
 	u64		intel_ctrl;
@@ -672,7 +672,7 @@ static u64
 x86_perf_event_update(struct perf_event *event,
 			struct hw_perf_event *hwc, int idx)
 {
-	int shift = 64 - x86_pmu.event_bits;
+	int shift = 64 - x86_pmu.cntval_bits;
 	u64 prev_raw_count, new_raw_count;
 	s64 delta;
 
@@ -722,12 +722,12 @@ static bool reserve_pmc_hardware(void)
 	if (nmi_watchdog == NMI_LOCAL_APIC)
 		disable_lapic_nmi_watchdog();
 
-	for (i = 0; i < x86_pmu.num_events; i++) {
+	for (i = 0; i < x86_pmu.num_counters; i++) {
 		if (!reserve_perfctr_nmi(x86_pmu.perfctr + i))
 			goto perfctr_fail;
 	}
 
-	for (i = 0; i < x86_pmu.num_events; i++) {
+	for (i = 0; i < x86_pmu.num_counters; i++) {
 		if (!reserve_evntsel_nmi(x86_pmu.eventsel + i))
 			goto eventsel_fail;
 	}
@@ -740,7 +740,7 @@ eventsel_fail:
 	for (i--; i >= 0; i--)
 		release_evntsel_nmi(x86_pmu.eventsel + i);
 
-	i = x86_pmu.num_events;
+	i = x86_pmu.num_counters;
 
 perfctr_fail:
 	for (i--; i >= 0; i--)
@@ -758,7 +758,7 @@ static void release_pmc_hardware(void)
 #ifdef CONFIG_X86_LOCAL_APIC
 	int i;
 
-	for (i = 0; i < x86_pmu.num_events; i++) {
+	for (i = 0; i < x86_pmu.num_counters; i++) {
 		release_perfctr_nmi(x86_pmu.perfctr + i);
 		release_evntsel_nmi(x86_pmu.eventsel + i);
 	}
@@ -1105,7 +1105,7 @@ static void amd_pmu_disable_all(void)
 	 */
 	barrier();
 
-	for (idx = 0; idx < x86_pmu.num_events; idx++) {
+	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		u64 val;
 
 		if (!test_bit(idx, cpuc->active_mask))
@@ -1176,7 +1176,7 @@ static void amd_pmu_enable_all(void)
 	cpuc->enabled = 1;
 	barrier();
 
-	for (idx = 0; idx < x86_pmu.num_events; idx++) {
+	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		struct perf_event *event = cpuc->events[idx];
 		u64 val;
 
@@ -1319,7 +1319,7 @@ x86_perf_event_set_period(struct perf_event *event,
 	atomic64_set(&hwc->prev_count, (u64)-left);
 
 	err = checking_wrmsrl(hwc->event_base + idx,
-			     (u64)(-left) & x86_pmu.event_mask);
+			     (u64)(-left) & x86_pmu.cntval_mask);
 
 	perf_event_update_userpage(event);
 
@@ -1402,7 +1402,7 @@ static int fixed_mode_idx(struct hw_perf_event *hwc)
 		     (hwc->sample_period == 1)))
 		return X86_PMC_IDX_FIXED_BTS;
 
-	if (!x86_pmu.num_events_fixed)
+	if (!x86_pmu.num_counters_fixed)
 		return -1;
 
 	/*
@@ -1429,8 +1429,8 @@ gen_get_event_idx(struct cpu_hw_events *cpuc, struct hw_perf_event *hwc)
 {
 	int idx;
 
-	idx = find_first_zero_bit(cpuc->used_mask, x86_pmu.num_events);
-	return idx == x86_pmu.num_events ? -1 : idx;
+	idx = find_first_zero_bit(cpuc->used_mask, x86_pmu.num_counters);
+	return idx == x86_pmu.num_counters ? -1 : idx;
 }
 
 /*
@@ -1556,7 +1556,7 @@ void perf_event_print_debug(void)
 	unsigned long flags;
 	int cpu, idx;
 
-	if (!x86_pmu.num_events)
+	if (!x86_pmu.num_counters)
 		return;
 
 	local_irq_save(flags);
@@ -1578,7 +1578,7 @@ void perf_event_print_debug(void)
 	}
 	pr_info("CPU#%d: used:       %016llx\n", cpu, *(u64 *)cpuc->used_mask);
 
-	for (idx = 0; idx < x86_pmu.num_events; idx++) {
+	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		rdmsrl(x86_pmu.eventsel + idx, pmc_ctrl);
 		rdmsrl(x86_pmu.perfctr  + idx, pmc_count);
 
@@ -1591,7 +1591,7 @@ void perf_event_print_debug(void)
 		pr_info("CPU#%d:   gen-PMC%d left:  %016llx\n",
 			cpu, idx, prev_left);
 	}
-	for (idx = 0; idx < x86_pmu.num_events_fixed; idx++) {
+	for (idx = 0; idx < x86_pmu.num_counters_fixed; idx++) {
 		rdmsrl(MSR_ARCH_PERFMON_FIXED_CTR0 + idx, pmc_count);
 
 		pr_info("CPU#%d: fixed-PMC%d count: %016llx\n",
@@ -1720,18 +1720,18 @@ static void intel_pmu_reset(void)
 	unsigned long flags;
 	int idx;
 
-	if (!x86_pmu.num_events)
+	if (!x86_pmu.num_counters)
 		return;
 
 	local_irq_save(flags);
 
 	printk("clearing PMU state on CPU#%d\n", smp_processor_id());
 
-	for (idx = 0; idx < x86_pmu.num_events; idx++) {
+	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		checking_wrmsrl(x86_pmu.eventsel + idx, 0ull);
 		checking_wrmsrl(x86_pmu.perfctr  + idx, 0ull);
 	}
-	for (idx = 0; idx < x86_pmu.num_events_fixed; idx++) {
+	for (idx = 0; idx < x86_pmu.num_counters_fixed; idx++) {
 		checking_wrmsrl(MSR_ARCH_PERFMON_FIXED_CTR0 + idx, 0ull);
 	}
 	if (ds)
@@ -1754,7 +1754,7 @@ static int p6_pmu_handle_irq(struct pt_regs *regs)
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
-	for (idx = 0; idx < x86_pmu.num_events; idx++) {
+	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		if (!test_bit(idx, cpuc->active_mask))
 			continue;
 
@@ -1762,7 +1762,7 @@ static int p6_pmu_handle_irq(struct pt_regs *regs)
 		hwc = &event->hw;
 
 		val = x86_perf_event_update(event, hwc, idx);
-		if (val & (1ULL << (x86_pmu.event_bits - 1)))
+		if (val & (1ULL << (x86_pmu.cntval_bits - 1)))
 			continue;
 
 		/*
@@ -1864,7 +1864,7 @@ static int amd_pmu_handle_irq(struct pt_regs *regs)
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
-	for (idx = 0; idx < x86_pmu.num_events; idx++) {
+	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		if (!test_bit(idx, cpuc->active_mask))
 			continue;
 
@@ -1872,7 +1872,7 @@ static int amd_pmu_handle_irq(struct pt_regs *regs)
 		hwc = &event->hw;
 
 		val = x86_perf_event_update(event, hwc, idx);
-		if (val & (1ULL << (x86_pmu.event_bits - 1)))
+		if (val & (1ULL << (x86_pmu.cntval_bits - 1)))
 			continue;
 
 		/*
@@ -1983,7 +1983,7 @@ static __initconst struct x86_pmu p6_pmu = {
 	.apic			= 1,
 	.max_period		= (1ULL << 31) - 1,
 	.version		= 0,
-	.num_events		= 2,
+	.num_counters		= 2,
 	/*
 	 * Events have 40 bits implemented. However they are designed such
 	 * that bits [32-39] are sign extensions of bit 31. As such the
@@ -1991,8 +1991,8 @@ static __initconst struct x86_pmu p6_pmu = {
 	 *
 	 * See IA-32 Intel Architecture Software developer manual Vol 3B
 	 */
-	.event_bits		= 32,
-	.event_mask		= (1ULL << 32) - 1,
+	.cntval_bits		= 32,
+	.cntval_mask		= (1ULL << 32) - 1,
 	.get_event_idx		= intel_get_event_idx,
 };
 
@@ -2032,9 +2032,9 @@ static __initconst struct x86_pmu amd_pmu = {
 	.event_map		= amd_pmu_event_map,
 	.raw_event		= amd_pmu_raw_event,
 	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
-	.num_events		= 4,
-	.event_bits		= 48,
-	.event_mask		= (1ULL << 48) - 1,
+	.num_counters		= 4,
+	.cntval_bits		= 48,
+	.cntval_mask		= (1ULL << 48) - 1,
 	.apic			= 1,
 	/* use highest bit to detect overflow */
 	.max_period		= (1ULL << 47) - 1,
@@ -2100,15 +2100,15 @@ static __init int intel_pmu_init(void)
 
 	x86_pmu				= intel_pmu;
 	x86_pmu.version			= version;
-	x86_pmu.num_events		= eax.split.num_events;
-	x86_pmu.event_bits		= eax.split.bit_width;
-	x86_pmu.event_mask		= (1ULL << eax.split.bit_width) - 1;
+	x86_pmu.num_counters		= eax.split.num_counters;
+	x86_pmu.cntval_bits		= eax.split.bit_width;
+	x86_pmu.cntval_mask		= (1ULL << eax.split.bit_width) - 1;
 
 	/*
 	 * Quirk: v2 perfmon does not report fixed-purpose events, so
 	 * assume at least 3 events:
 	 */
-	x86_pmu.num_events_fixed	= max((int)edx.split.num_events_fixed, 3);
+	x86_pmu.num_counters_fixed	= max((int)edx.split.num_counters_fixed, 3);
 
 	/*
 	 * Install the hw-cache-events table:
@@ -2192,33 +2192,33 @@ void __init init_hw_perf_events(void)
 
 	pr_cont("%s PMU driver.\n", x86_pmu.name);
 
-	if (x86_pmu.num_events > X86_PMC_MAX_GENERIC) {
+	if (x86_pmu.num_counters > X86_PMC_MAX_GENERIC) {
 		WARN(1, KERN_ERR "hw perf events %d > max(%d), clipping!",
-		     x86_pmu.num_events, X86_PMC_MAX_GENERIC);
-		x86_pmu.num_events = X86_PMC_MAX_GENERIC;
+		     x86_pmu.num_counters, X86_PMC_MAX_GENERIC);
+		x86_pmu.num_counters = X86_PMC_MAX_GENERIC;
 	}
-	perf_event_mask = (1 << x86_pmu.num_events) - 1;
-	perf_max_events = x86_pmu.num_events;
+	perf_event_mask = (1 << x86_pmu.num_counters) - 1;
+	perf_max_events = x86_pmu.num_counters;
 
-	if (x86_pmu.num_events_fixed > X86_PMC_MAX_FIXED) {
+	if (x86_pmu.num_counters_fixed > X86_PMC_MAX_FIXED) {
 		WARN(1, KERN_ERR "hw perf events fixed %d > max(%d), clipping!",
-		     x86_pmu.num_events_fixed, X86_PMC_MAX_FIXED);
-		x86_pmu.num_events_fixed = X86_PMC_MAX_FIXED;
+		     x86_pmu.num_counters_fixed, X86_PMC_MAX_FIXED);
+		x86_pmu.num_counters_fixed = X86_PMC_MAX_FIXED;
 	}
 
 	perf_event_mask |=
-		((1LL << x86_pmu.num_events_fixed)-1) << X86_PMC_IDX_FIXED;
+		((1LL << x86_pmu.num_counters_fixed)-1) << X86_PMC_IDX_FIXED;
 	x86_pmu.intel_ctrl = perf_event_mask;
 
 	perf_events_lapic_init();
 	register_die_notifier(&perf_event_nmi_notifier);
 
 	pr_info("... version:                %d\n",     x86_pmu.version);
-	pr_info("... bit width:              %d\n",     x86_pmu.event_bits);
-	pr_info("... generic registers:      %d\n",     x86_pmu.num_events);
-	pr_info("... value mask:             %016Lx\n", x86_pmu.event_mask);
+	pr_info("... bit width:              %d\n",     x86_pmu.cntval_bits);
+	pr_info("... generic registers:      %d\n",     x86_pmu.num_counters);
+	pr_info("... value mask:             %016Lx\n", x86_pmu.cntval_mask);
 	pr_info("... max period:             %016Lx\n", x86_pmu.max_period);
-	pr_info("... fixed-purpose events:   %d\n",     x86_pmu.num_events_fixed);
+	pr_info("... fixed-purpose events:   %d\n",     x86_pmu.num_counters_fixed);
 	pr_info("... event mask:             %016Lx\n", perf_event_mask);
 }
 
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 8eb0587..4899215 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -234,11 +234,11 @@ static void arch_perfmon_setup_counters(void)
 	if (eax.split.version_id == 0 && current_cpu_data.x86 == 6 &&
 		current_cpu_data.x86_model == 15) {
 		eax.split.version_id = 2;
-		eax.split.num_events = 2;
+		eax.split.num_counters = 2;
 		eax.split.bit_width = 40;
 	}
 
-	num_counters = eax.split.num_events;
+	num_counters = eax.split.num_counters;
 
 	op_arch_perfmon_spec.num_counters = num_counters;
 	op_arch_perfmon_spec.num_controls = num_counters;
-- 
1.6.6


