Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbZJSPDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbZJSPDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 11:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756501AbZJSPDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 11:03:51 -0400
Received: from mail-gx0-f212.google.com ([209.85.217.212]:44404 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480AbZJSPDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 11:03:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GtiBOcArpja5dfRLBS+gyCjfLnklXZQ5F2iehW7OiHAOl4R4E0CKDd0VRnrRjt9rYx
         k3E3XnEFCXMC4f6P8WH+9V1Jskktav4f5VLH/3x5I+4gWfeI5tkvxeendrUMgDGz41Dx
         Xl13zhMBUBhOO61wwWU5HHjI+m0xHefv3YHs4=
From: Stephane Eranian <eranian@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, paulus@samba.org, a.p.zijlstra@chello.nl,
       perfmon2-devel@lists.sf.net, Stephane Eranian <eranian@gmail.com>
Subject: [PATCH]  perf_events: improve Intel event scheduling
Date: Mon, 19 Oct 2009 17:03:50 +0200
Message-Id: <1255964630-5878-1-git-send-email-eranian@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	This patch improves Intel event scheduling by maximizing
	the use of PMU registers regardless of the order in which
	events are submitted.

	The algorithm takes into account the list of counter constraints
	for each event. It assigns events to counters from the most
	constrained, i.e., works on only one counter, to the least
	constrained, i.e., works on any counter.

	Fixed counter events and the BTS special event are also handled via
	this algorithm which is designed to be fairly generic.

	The patch also updates the validation of an event to use the
	scheduling algorithm. This will cause early failure in
	perf_event_open().

	Signed-off-by: Stephane Eranian <eranian@gmail.com>
---
 arch/x86/include/asm/perf_event.h |    6 +-
 arch/x86/kernel/cpu/perf_event.c  |  497 +++++++++++++++++++++++--------------
 2 files changed, 318 insertions(+), 185 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 8d9f854..7c737af 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -26,7 +26,9 @@
 /*
  * Includes eventsel and unit mask as well:
  */
-#define ARCH_PERFMON_EVENT_MASK				    0xffff
+#define ARCH_PERFMON_EVENTSEL_EVENT_MASK		    0x00ff
+#define ARCH_PERFMON_EVENTSEL_UNIT_MASK			    0xff00
+#define ARCH_PERFMON_EVENT_MASK				    (ARCH_PERFMON_EVENTSEL_UNIT_MASK|ARCH_PERFMON_EVENTSEL_EVENT_MASK)
 
 /*
  * filter mask to validate fixed counter events.
@@ -38,6 +40,8 @@
  *  The any-thread option is supported starting with v3.
  */
 #define ARCH_PERFMON_EVENT_FILTER_MASK			0xff840000
+#define ARCH_PERFMON_FIXED_EVENT_MASK (ARCH_PERFMON_EVENT_FILTER_MASK|ARCH_PERFMON_EVENT_MASK)
+
 
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL		      0x3c
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK		(0x00 << 8)
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 2e20bca..0f96c51 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -7,6 +7,7 @@
  *  Copyright (C) 2009 Advanced Micro Devices, Inc., Robert Richter
  *  Copyright (C) 2008-2009 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
  *  Copyright (C) 2009 Intel Corporation, <markus.t.metzger@intel.com>
+ *  Copyright (C) 2009 Google, Inc., Stephane Eranian
  *
  *  For licencing details see kernel-base/COPYING
  */
@@ -68,6 +69,15 @@ struct debug_store {
 	u64	pebs_event_reset[MAX_PEBS_EVENTS];
 };
 
+#define BITS_TO_U64(nr) DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u64))
+
+struct event_constraint {
+	u64	idxmsk[BITS_TO_U64(X86_PMC_IDX_MAX)];
+	int	code;
+	int	mask;
+	int	weight;
+};
+
 struct cpu_hw_events {
 	struct perf_event	*events[X86_PMC_IDX_MAX];
 	unsigned long		used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
@@ -75,19 +85,23 @@ struct cpu_hw_events {
 	unsigned long		interrupts;
 	int			enabled;
 	struct debug_store	*ds;
-};
 
-struct event_constraint {
-	unsigned long	idxmsk[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
-	int		code;
+	int			n_events;
+	struct event_constraint	*constraints[X86_PMC_IDX_MAX];
+	struct perf_event	*event_list[X86_PMC_IDX_MAX]; /* in order they are collected */
 };
 
-#define EVENT_CONSTRAINT(c, m) { .code = (c), .idxmsk[0] = (m) }
-#define EVENT_CONSTRAINT_END  { .code = 0, .idxmsk[0] = 0 }
+#define EVENT_CONSTRAINT(c, n, w, m) { \
+	.code = (c),	\
+	.mask = (m), 	\
+	.weight = (w),	\
+	.idxmsk[0] = (n) }
 
-#define for_each_event_constraint(e, c) \
-	for ((e) = (c); (e)->idxmsk[0]; (e)++)
+#define EVENT_CONSTRAINT_END \
+	{ .code = 0, .mask = 0, .weight = 0, .idxmsk[0] = 0 }
 
+#define for_each_event_constraint(e, c) \
+	for ((e) = (c); (e)->weight; (e)++)
 
 /*
  * struct x86_pmu - generic x86 pmu
@@ -114,8 +128,7 @@ struct x86_pmu {
 	u64		intel_ctrl;
 	void		(*enable_bts)(u64 config);
 	void		(*disable_bts)(void);
-	int		(*get_event_idx)(struct cpu_hw_events *cpuc,
-					 struct hw_perf_event *hwc);
+	struct event_constraint *(*get_event_constraints)(struct perf_event *event);
 };
 
 static struct x86_pmu x86_pmu __read_mostly;
@@ -124,7 +137,7 @@ static DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
 	.enabled = 1,
 };
 
-static const struct event_constraint *event_constraints;
+static struct event_constraint *event_constraints;
 
 /*
  * Not sure about some of these
@@ -171,14 +184,14 @@ static u64 p6_pmu_raw_event(u64 hw_event)
 	return hw_event & P6_EVNTSEL_MASK;
 }
 
-static const struct event_constraint intel_p6_event_constraints[] =
+static struct event_constraint intel_p6_event_constraints[] =
 {
-	EVENT_CONSTRAINT(0xc1, 0x1),	/* FLOPS */
-	EVENT_CONSTRAINT(0x10, 0x1),	/* FP_COMP_OPS_EXE */
-	EVENT_CONSTRAINT(0x11, 0x1),	/* FP_ASSIST */
-	EVENT_CONSTRAINT(0x12, 0x2),	/* MUL */
-	EVENT_CONSTRAINT(0x13, 0x2),	/* DIV */
-	EVENT_CONSTRAINT(0x14, 0x1),	/* CYCLES_DIV_BUSY */
+	EVENT_CONSTRAINT(0xc1, 0x1, 1, 0xff),	/* FLOPS */
+	EVENT_CONSTRAINT(0x10, 0x1, 1, 0xff),	/* FP_COMP_OPS_EXE */
+	EVENT_CONSTRAINT(0x11, 0x1, 1, 0xff),	/* FP_ASSIST */
+	EVENT_CONSTRAINT(0x12, 0x2, 1, 0xff),	/* MUL */
+	EVENT_CONSTRAINT(0x13, 0x2, 1, 0xff),	/* DIV */
+	EVENT_CONSTRAINT(0x14, 0x1, 1, 0xff),	/* CYCLES_DIV_BUSY */
 	EVENT_CONSTRAINT_END
 };
 
@@ -196,32 +209,35 @@ static const u64 intel_perfmon_event_map[] =
   [PERF_COUNT_HW_BUS_CYCLES]		= 0x013c,
 };
 
-static const struct event_constraint intel_core_event_constraints[] =
-{
-	EVENT_CONSTRAINT(0x10, 0x1),	/* FP_COMP_OPS_EXE */
-	EVENT_CONSTRAINT(0x11, 0x2),	/* FP_ASSIST */
-	EVENT_CONSTRAINT(0x12, 0x2),	/* MUL */
-	EVENT_CONSTRAINT(0x13, 0x2),	/* DIV */
-	EVENT_CONSTRAINT(0x14, 0x1),	/* CYCLES_DIV_BUSY */
-	EVENT_CONSTRAINT(0x18, 0x1),	/* IDLE_DURING_DIV */
-	EVENT_CONSTRAINT(0x19, 0x2),	/* DELAYED_BYPASS */
-	EVENT_CONSTRAINT(0xa1, 0x1),	/* RS_UOPS_DISPATCH_CYCLES */
-	EVENT_CONSTRAINT(0xcb, 0x1),	/* MEM_LOAD_RETIRED */
+static struct event_constraint intel_core_event_constraints[] =
+{
+	EVENT_CONSTRAINT(0xc0, (0x3|(1ULL<<32)), 3, ARCH_PERFMON_FIXED_EVENT_MASK), /* INSTRUCTIONS_RETIRED */
+	EVENT_CONSTRAINT(0x3c, (0x3|(1ULL<<33)), 3, ARCH_PERFMON_FIXED_EVENT_MASK), /* UNHALTED_CORE_CYCLES */
+	EVENT_CONSTRAINT(0x10, 0x1, 1, ARCH_PERFMON_EVENTSEL_EVENT_MASK), /* FP_COMP_OPS_EXE */
+	EVENT_CONSTRAINT(0x11, 0x2, 1, ARCH_PERFMON_EVENTSEL_EVENT_MASK), /* FP_ASSIST */
+	EVENT_CONSTRAINT(0x12, 0x2, 1, ARCH_PERFMON_EVENTSEL_EVENT_MASK), /* MUL */
+	EVENT_CONSTRAINT(0x13, 0x2, 1, ARCH_PERFMON_EVENTSEL_EVENT_MASK), /* DIV */
+	EVENT_CONSTRAINT(0x14, 0x1, 1, ARCH_PERFMON_EVENTSEL_EVENT_MASK), /* CYCLES_DIV_BUSY */
+	EVENT_CONSTRAINT(0x18, 0x1, 1, ARCH_PERFMON_EVENTSEL_EVENT_MASK), /* IDLE_DURING_DIV */
+	EVENT_CONSTRAINT(0x19, 0x2, 1, ARCH_PERFMON_EVENTSEL_EVENT_MASK), /* DELAYED_BYPASS */
+	EVENT_CONSTRAINT(0xa1, 0x1, 1, ARCH_PERFMON_EVENTSEL_EVENT_MASK), /* RS_UOPS_DISPATCH_CYCLES */
+	EVENT_CONSTRAINT(0xcb, 0x1, 1, ARCH_PERFMON_EVENTSEL_EVENT_MASK), /* MEM_LOAD_RETIRED */
 	EVENT_CONSTRAINT_END
 };
 
-static const struct event_constraint intel_nehalem_event_constraints[] =
-{
-	EVENT_CONSTRAINT(0x40, 0x3),	/* L1D_CACHE_LD */
-	EVENT_CONSTRAINT(0x41, 0x3),	/* L1D_CACHE_ST */
-	EVENT_CONSTRAINT(0x42, 0x3),	/* L1D_CACHE_LOCK */
-	EVENT_CONSTRAINT(0x43, 0x3),	/* L1D_ALL_REF */
-	EVENT_CONSTRAINT(0x4e, 0x3),	/* L1D_PREFETCH */
-	EVENT_CONSTRAINT(0x4c, 0x3),	/* LOAD_HIT_PRE */
-	EVENT_CONSTRAINT(0x51, 0x3),	/* L1D */
-	EVENT_CONSTRAINT(0x52, 0x3),	/* L1D_CACHE_PREFETCH_LOCK_FB_HIT */
-	EVENT_CONSTRAINT(0x53, 0x3),	/* L1D_CACHE_LOCK_FB_HIT */
-	EVENT_CONSTRAINT(0xc5, 0x3),	/* CACHE_LOCK_CYCLES */
+static struct event_constraint intel_nehalem_event_constraints[] = {
+	EVENT_CONSTRAINT(0xc0, (0x3|(1ULL<<32)), 3, ARCH_PERFMON_FIXED_EVENT_MASK), /* INSTRUCTIONS_RETIRED */
+	EVENT_CONSTRAINT(0x3c, (0x3|(1ULL<<33)), 3, ARCH_PERFMON_FIXED_EVENT_MASK), /* UNHALTED_CORE_CYCLES */
+	EVENT_CONSTRAINT(0x40, 0x3, 2, ARCH_PERFMON_EVENTSEL_EVENT_MASK), /* L1D_CACHE_LD */
+	EVENT_CONSTRAINT(0x41, 0x3, 2, ARCH_PERFMON_EVENTSEL_EVENT_MASK), /* L1D_CACHE_ST */
+	EVENT_CONSTRAINT(0x42, 0x3, 2, ARCH_PERFMON_EVENTSEL_EVENT_MASK), /* L1D_CACHE_LOCK */
+	EVENT_CONSTRAINT(0x43, 0x3, 2, ARCH_PERFMON_EVENTSEL_EVENT_MASK), /* L1D_ALL_REF */
+	EVENT_CONSTRAINT(0x4e, 0x3, 2, ARCH_PERFMON_EVENTSEL_EVENT_MASK), /* L1D_PREFETCH */
+	EVENT_CONSTRAINT(0x4c, 0x3, 2, ARCH_PERFMON_EVENTSEL_EVENT_MASK), /* LOAD_HIT_PRE */
+	EVENT_CONSTRAINT(0x51, 0x3, 2, ARCH_PERFMON_EVENTSEL_EVENT_MASK), /* L1D */
+	EVENT_CONSTRAINT(0x52, 0x3, 2, ARCH_PERFMON_EVENTSEL_EVENT_MASK), /* L1D_CACHE_PREFETCH_LOCK_FB_HIT */
+	EVENT_CONSTRAINT(0x53, 0x3, 2, ARCH_PERFMON_EVENTSEL_EVENT_MASK), /* L1D_CACHE_LOCK_FB_HIT */
+	EVENT_CONSTRAINT(0xc5, 0x3, 2, ARCH_PERFMON_EVENTSEL_EVENT_MASK), /* CACHE_LOCK_CYCLES */
 	EVENT_CONSTRAINT_END
 };
 
@@ -1120,9 +1136,15 @@ static void amd_pmu_disable_all(void)
 
 void hw_perf_disable(void)
 {
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
 	if (!x86_pmu_initialized())
 		return;
-	return x86_pmu.disable_all();
+
+	if (cpuc->enabled)
+		cpuc->n_events = 0;
+
+	x86_pmu.disable_all();
 }
 
 static void p6_pmu_enable_all(void)
@@ -1391,124 +1413,6 @@ static void amd_pmu_enable_event(struct hw_perf_event *hwc, int idx)
 		x86_pmu_enable_event(hwc, idx);
 }
 
-static int fixed_mode_idx(struct hw_perf_event *hwc)
-{
-	unsigned int hw_event;
-
-	hw_event = hwc->config & ARCH_PERFMON_EVENT_MASK;
-
-	if (unlikely((hw_event ==
-		      x86_pmu.event_map(PERF_COUNT_HW_BRANCH_INSTRUCTIONS)) &&
-		     (hwc->sample_period == 1)))
-		return X86_PMC_IDX_FIXED_BTS;
-
-	if (!x86_pmu.num_events_fixed)
-		return -1;
-
-	/*
-	 * fixed counters do not take all possible filters
-	 */
-	if (hwc->config & ARCH_PERFMON_EVENT_FILTER_MASK)
-		return -1;
-
-	if (unlikely(hw_event == x86_pmu.event_map(PERF_COUNT_HW_INSTRUCTIONS)))
-		return X86_PMC_IDX_FIXED_INSTRUCTIONS;
-	if (unlikely(hw_event == x86_pmu.event_map(PERF_COUNT_HW_CPU_CYCLES)))
-		return X86_PMC_IDX_FIXED_CPU_CYCLES;
-	if (unlikely(hw_event == x86_pmu.event_map(PERF_COUNT_HW_BUS_CYCLES)))
-		return X86_PMC_IDX_FIXED_BUS_CYCLES;
-
-	return -1;
-}
-
-/*
- * generic counter allocator: get next free counter
- */
-static int
-gen_get_event_idx(struct cpu_hw_events *cpuc, struct hw_perf_event *hwc)
-{
-	int idx;
-
-	idx = find_first_zero_bit(cpuc->used_mask, x86_pmu.num_events);
-	return idx == x86_pmu.num_events ? -1 : idx;
-}
-
-/*
- * intel-specific counter allocator: check event constraints
- */
-static int
-intel_get_event_idx(struct cpu_hw_events *cpuc, struct hw_perf_event *hwc)
-{
-	const struct event_constraint *event_constraint;
-	int i, code;
-
-	if (!event_constraints)
-		goto skip;
-
-	code = hwc->config & CORE_EVNTSEL_EVENT_MASK;
-
-	for_each_event_constraint(event_constraint, event_constraints) {
-		if (code == event_constraint->code) {
-			for_each_bit(i, event_constraint->idxmsk, X86_PMC_IDX_MAX) {
-				if (!test_and_set_bit(i, cpuc->used_mask))
-					return i;
-			}
-			return -1;
-		}
-	}
-skip:
-	return gen_get_event_idx(cpuc, hwc);
-}
-
-static int
-x86_schedule_event(struct cpu_hw_events *cpuc, struct hw_perf_event *hwc)
-{
-	int idx;
-
-	idx = fixed_mode_idx(hwc);
-	if (idx == X86_PMC_IDX_FIXED_BTS) {
-		/* BTS is already occupied. */
-		if (test_and_set_bit(idx, cpuc->used_mask))
-			return -EAGAIN;
-
-		hwc->config_base	= 0;
-		hwc->event_base		= 0;
-		hwc->idx		= idx;
-	} else if (idx >= 0) {
-		/*
-		 * Try to get the fixed event, if that is already taken
-		 * then try to get a generic event:
-		 */
-		if (test_and_set_bit(idx, cpuc->used_mask))
-			goto try_generic;
-
-		hwc->config_base = MSR_ARCH_PERFMON_FIXED_CTR_CTRL;
-		/*
-		 * We set it so that event_base + idx in wrmsr/rdmsr maps to
-		 * MSR_ARCH_PERFMON_FIXED_CTR0 ... CTR2:
-		 */
-		hwc->event_base =
-			MSR_ARCH_PERFMON_FIXED_CTR0 - X86_PMC_IDX_FIXED;
-		hwc->idx = idx;
-	} else {
-		idx = hwc->idx;
-		/* Try to get the previous generic event again */
-		if (idx == -1 || test_and_set_bit(idx, cpuc->used_mask)) {
-try_generic:
-			idx = x86_pmu.get_event_idx(cpuc, hwc);
-			if (idx == -1)
-				return -EAGAIN;
-
-			set_bit(idx, cpuc->used_mask);
-			hwc->idx = idx;
-		}
-		hwc->config_base = x86_pmu.eventsel;
-		hwc->event_base  = x86_pmu.perfctr;
-	}
-
-	return idx;
-}
-
 /*
  * Find a PMC slot for the freshly enabled / scheduled in event:
  */
@@ -1518,7 +1422,7 @@ static int x86_pmu_enable(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	int idx;
 
-	idx = x86_schedule_event(cpuc, hwc);
+	idx = hwc->idx;
 	if (idx < 0)
 		return idx;
 
@@ -1958,6 +1862,224 @@ perf_event_nmi_handler(struct notifier_block *self,
 	return NOTIFY_STOP;
 }
 
+static struct event_constraint bts_constraint={
+	.code = 0,
+	.mask = 0,
+	.weight = 1,
+	.idxmsk[0] = 1ULL << X86_PMC_IDX_FIXED_BTS
+};
+
+static struct event_constraint *intel_special_constraints(struct perf_event *event)
+{
+	unsigned int hw_event;
+
+	hw_event = event->hw.config & ARCH_PERFMON_EVENT_MASK;
+
+	if (unlikely((hw_event ==
+		      x86_pmu.event_map(PERF_COUNT_HW_BRANCH_INSTRUCTIONS)) &&
+		     (event->hw.sample_period == 1)))
+		return &bts_constraint;
+
+	return NULL;
+}
+
+static struct event_constraint *intel_get_event_constraints(struct perf_event *event)
+{
+	struct event_constraint *c;
+
+	c = intel_special_constraints(event);
+	if (c)
+		return c;
+
+	if (event_constraints)
+		for_each_event_constraint(c, event_constraints) {
+			if ((event->hw.config & c->mask) == c->code)
+				return c;
+		}
+
+	return NULL;
+}
+
+static struct event_constraint *amd_get_event_constraints(struct perf_event *event)
+{
+	return NULL;
+}
+
+static int schedule_events(struct cpu_hw_events *cpuhw, int n, bool assign)
+{
+	int i, j , w, num, lim;
+	int weight, wmax;
+	struct event_constraint *c;
+	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	int assignments[X86_PMC_IDX_MAX];
+	struct hw_perf_event *hwc;
+
+	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
+
+	/*
+	 * weight = number of possible counters
+	 *
+	 * 1    = most constrained, only works on one counter
+	 * wmax = least constrained, works on 1 fixed counter
+	 *        or any generic counter
+	 *
+	 * assign events to counters starting with most
+	 * constrained events.
+	 */
+	wmax = 1 + x86_pmu.num_events;
+	num = n;
+	for(w=1; num && w <= wmax; w++) {
+
+		/* for each event */
+		for(i=0; i < n; i++) {
+			c = cpuhw->constraints[i];
+			hwc = &cpuhw->event_list[i]->hw;
+
+			weight = c ? c->weight : x86_pmu.num_events;
+			if (weight != w)
+				continue;
+
+			/*
+			 * try to reuse previous assignment
+			 *
+			 * This is possible despite the fact that
+			 * events or events order may have changed.
+			 *
+			 * What matters is the level of constraints
+			 * of an event and this is constant for now.
+			 *
+			 * This is possible also because we always
+			 * scan from most to least constrained. Thus,
+			 * if a counter can be reused, it means no,
+			 * more constrained events, needed it. And
+			 * next events will either compete for it
+			 * (which cannot be solved anyway) or they
+			 * have fewer constraints, and they can use
+			 * another counter.
+			 */
+			j = hwc->idx;
+			if (j != -1 && !test_bit(j, used_mask))
+				goto skip;
+
+			if (c) {
+				lim = X86_PMC_IDX_MAX;
+				for_each_bit(j, (unsigned long *)c->idxmsk, lim)
+					if (!test_bit(j, used_mask))
+						break;
+
+			} else  {
+				lim = x86_pmu.num_events;
+				/*
+				 * fixed counter events have necessarily a
+				 * constraint thus we come here only for
+				 * generic counters and thus we limit the
+				 * scan to those
+				 */
+				j = find_first_zero_bit(used_mask, lim);
+			}
+			if (j == lim)
+				return -EAGAIN;
+skip:
+			set_bit(j, used_mask);
+			assignments[i] = j;
+			num--;
+		}
+	}
+	if (num)
+		return -ENOSPC;
+
+	/* just simulate scheduling */
+	if (!assign)
+		return 0;
+
+	/*
+	 * commit assignments
+	 */
+	for(i=0; i < n; i++) {
+		hwc = &cpuhw->event_list[i]->hw;
+
+		hwc->idx = assignments[i];
+
+		set_bit(hwc->idx, cpuhw->used_mask);
+
+		if (hwc->idx == X86_PMC_IDX_FIXED_BTS) {
+			hwc->config_base = 0;
+			hwc->event_base	= 0;
+		} else if (hwc->idx >= X86_PMC_IDX_FIXED) {
+			hwc->config_base = MSR_ARCH_PERFMON_FIXED_CTR_CTRL;
+			/*
+			 * We set it so that event_base + idx in wrmsr/rdmsr maps to
+			 * MSR_ARCH_PERFMON_FIXED_CTR0 ... CTR2:
+			 */
+			hwc->event_base =
+				MSR_ARCH_PERFMON_FIXED_CTR0 - X86_PMC_IDX_FIXED;
+		} else {
+			hwc->config_base = x86_pmu.eventsel;
+			hwc->event_base  = x86_pmu.perfctr;
+		}
+	}
+	cpuhw->n_events = n;
+	return 0;
+}
+
+static int collect_events(struct cpu_hw_events *cpuhw, struct perf_event *leader)
+{
+	struct perf_event *event;
+	int n, max_count;
+
+	max_count = x86_pmu.num_events + x86_pmu.num_events_fixed;
+
+	/* current number of events already accepted */
+	n = cpuhw->n_events;
+
+	if (!is_software_event(leader)) {
+		if (n >= max_count)
+			return -ENOSPC;
+		cpuhw->constraints[n] = x86_pmu.get_event_constraints(leader);
+		cpuhw->event_list[n] = leader;
+		n++;
+	}
+
+	list_for_each_entry(event, &leader->sibling_list, group_entry) {
+		if (is_software_event(event) ||
+		    event->state == PERF_EVENT_STATE_OFF)
+			continue;
+
+		if (n >= max_count)
+			return -ENOSPC;
+
+		cpuhw->constraints[n] = x86_pmu.get_event_constraints(event);
+		cpuhw->event_list[n] = event;
+		n++;
+	}
+	return n;
+}
+
+/*
+ * Called to enable a whole group of events.
+ * Returns 1 if the group was enabled, or -EAGAIN if it could not be.
+ * Assumes the caller has disabled interrupts and has
+ * frozen the PMU with hw_perf_save_disable.
+ */
+int hw_perf_group_sched_in(struct perf_event *leader,
+	       struct perf_cpu_context *cpuctx,
+	       struct perf_event_context *ctx, int cpu)
+{
+	struct cpu_hw_events *cpuhw = &per_cpu(cpu_hw_events, cpu);
+	int n, ret;
+
+	n = collect_events(cpuhw, leader);
+	if (n < 0)
+		return n;
+
+	ret = schedule_events(cpuhw, n, true);
+	if (ret)
+		return ret;
+
+	/* 0 means successful and enable each event in caller */
+	return 0;
+}
+
 static __read_mostly struct notifier_block perf_event_nmi_notifier = {
 	.notifier_call		= perf_event_nmi_handler,
 	.next			= NULL,
@@ -1989,7 +2111,7 @@ static struct x86_pmu p6_pmu = {
 	 */
 	.event_bits		= 32,
 	.event_mask		= (1ULL << 32) - 1,
-	.get_event_idx		= intel_get_event_idx,
+	.get_event_constraints	= intel_get_event_constraints
 };
 
 static struct x86_pmu intel_pmu = {
@@ -2013,7 +2135,7 @@ static struct x86_pmu intel_pmu = {
 	.max_period		= (1ULL << 31) - 1,
 	.enable_bts		= intel_pmu_enable_bts,
 	.disable_bts		= intel_pmu_disable_bts,
-	.get_event_idx		= intel_get_event_idx,
+	.get_event_constraints	= intel_get_event_constraints
 };
 
 static struct x86_pmu amd_pmu = {
@@ -2034,7 +2156,7 @@ static struct x86_pmu amd_pmu = {
 	.apic			= 1,
 	/* use highest bit to detect overflow */
 	.max_period		= (1ULL << 47) - 1,
-	.get_event_idx		= gen_get_event_idx,
+	.get_event_constraints	= amd_get_event_constraints
 };
 
 static int p6_pmu_init(void)
@@ -2123,8 +2245,8 @@ static int intel_pmu_init(void)
 		memcpy(hw_cache_event_ids, core2_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
-		pr_cont("Core2 events, ");
 		event_constraints = intel_core_event_constraints;
+		pr_cont("Core2 events, ");
 		break;
 	default:
 	case 26:
@@ -2224,36 +2346,43 @@ static const struct pmu pmu = {
 	.unthrottle	= x86_pmu_unthrottle,
 };
 
-static int
-validate_event(struct cpu_hw_events *cpuc, struct perf_event *event)
-{
-	struct hw_perf_event fake_event = event->hw;
-
-	if (event->pmu != &pmu)
-		return 0;
-
-	return x86_schedule_event(cpuc, &fake_event);
-}
-
+/*
+ * validate a single event group
+ *
+ * validation include:
+ * 	- check events are compatible which each other
+ * 	- events do not compete for the same counter
+ * 	- number of events <= number of counters
+ *
+ * validation ensures the group can be loaded onto the
+ * PMU if it were the only group available.
+ */
 static int validate_group(struct perf_event *event)
 {
-	struct perf_event *sibling, *leader = event->group_leader;
+	struct perf_event *leader = event->group_leader;
 	struct cpu_hw_events fake_pmu;
+	int n, ret;
 
 	memset(&fake_pmu, 0, sizeof(fake_pmu));
 
-	if (!validate_event(&fake_pmu, leader))
+	/*
+	 * the event is not yet connected with its
+	 * siblings thererfore we must first collect
+	 * existing siblings, then add the new event
+	 * before we can simulate the scheduling
+	 */
+	n = collect_events(&fake_pmu, leader);
+	if (n < 0)
 		return -ENOSPC;
 
-	list_for_each_entry(sibling, &leader->sibling_list, group_entry) {
-		if (!validate_event(&fake_pmu, sibling))
-			return -ENOSPC;
-	}
+	fake_pmu.n_events = n;
 
-	if (!validate_event(&fake_pmu, event))
+	n = collect_events(&fake_pmu, event);
+	if (n < 0)
 		return -ENOSPC;
 
-	return 0;
+	ret = schedule_events(&fake_pmu, n, false);
+	return ret ? -ENOSPC : 0;
 }
 
 const struct pmu *hw_perf_event_init(struct perf_event *event)
-- 
1.5.4.3

