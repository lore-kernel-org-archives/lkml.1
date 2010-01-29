Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164Ab0A2J1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab0A2J1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173Ab0A2J1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:27:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:57370 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755614Ab0A2J13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:27:29 -0500
Date: Fri, 29 Jan 2010 09:26:31 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       eranian@google.com, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com>
References: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events, x86: Improve x86 event scheduling
Message-ID: <tip-1da53e023029c067ba1277a33038c65d6e4c99b3@git.kernel.org>
Git-Commit-ID: 1da53e023029c067ba1277a33038c65d6e4c99b3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Jan 2010 09:26:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1da53e023029c067ba1277a33038c65d6e4c99b3
Gitweb:     http://git.kernel.org/tip/1da53e023029c067ba1277a33038c65d6e4c99b3
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Mon, 18 Jan 2010 10:58:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 Jan 2010 09:01:33 +0100

perf_events, x86: Improve x86 event scheduling

This patch improves event scheduling by maximizing the use of PMU
registers regardless of the order in which events are created in a group.

The algorithm takes into account the list of counter constraints for each
event. It assigns events to counters from the most constrained, i.e.,
works on only one counter, to the least constrained, i.e., works on any
counter.

Intel Fixed counter events and the BTS special event are also handled via
this algorithm which is designed to be fairly generic.

The patch also updates the validation of an event to use the scheduling
algorithm. This will cause early failure in perf_event_open().

The 2nd version of this patch follows the model used by PPC, by running
the scheduling algorithm and the actual assignment separately. Actual
assignment takes place in hw_perf_enable() whereas scheduling is
implemented in hw_perf_group_sched_in() and x86_pmu_enable().

Signed-off-by: Stephane Eranian <eranian@google.com>
[ fixup whitespace and style nits as well as adding is_x86_event() ]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/perf_event.h |   16 +-
 arch/x86/kernel/cpu/perf_event.c  |  775 +++++++++++++++++++++++++++----------
 2 files changed, 574 insertions(+), 217 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 8d9f854..dbc0826 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -26,7 +26,14 @@
 /*
  * Includes eventsel and unit mask as well:
  */
-#define ARCH_PERFMON_EVENT_MASK				    0xffff
+
+
+#define INTEL_ARCH_EVTSEL_MASK		0x000000FFULL
+#define INTEL_ARCH_UNIT_MASK		0x0000FF00ULL
+#define INTEL_ARCH_EDGE_MASK		0x00040000ULL
+#define INTEL_ARCH_INV_MASK		0x00800000ULL
+#define INTEL_ARCH_CNT_MASK		0xFF000000ULL
+#define INTEL_ARCH_EVENT_MASK	(INTEL_ARCH_UNIT_MASK|INTEL_ARCH_EVTSEL_MASK)
 
 /*
  * filter mask to validate fixed counter events.
@@ -37,7 +44,12 @@
  *  The other filters are supported by fixed counters.
  *  The any-thread option is supported starting with v3.
  */
-#define ARCH_PERFMON_EVENT_FILTER_MASK			0xff840000
+#define INTEL_ARCH_FIXED_MASK \
+	(INTEL_ARCH_CNT_MASK| \
+	 INTEL_ARCH_INV_MASK| \
+	 INTEL_ARCH_EDGE_MASK|\
+	 INTEL_ARCH_UNIT_MASK|\
+	 INTEL_ARCH_EVENT_MASK)
 
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL		      0x3c
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK		(0x00 << 8)
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index ed1998b..995ac4a 100644
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
@@ -68,26 +69,37 @@ struct debug_store {
 	u64	pebs_event_reset[MAX_PEBS_EVENTS];
 };
 
+#define BITS_TO_U64(nr) DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u64))
+
+struct event_constraint {
+	u64	idxmsk[BITS_TO_U64(X86_PMC_IDX_MAX)];
+	int	code;
+	int	cmask;
+};
+
 struct cpu_hw_events {
-	struct perf_event	*events[X86_PMC_IDX_MAX];
-	unsigned long		used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	struct perf_event	*events[X86_PMC_IDX_MAX]; /* in counter order */
 	unsigned long		active_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	unsigned long		interrupts;
 	int			enabled;
 	struct debug_store	*ds;
-};
 
-struct event_constraint {
-	unsigned long	idxmsk[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
-	int		code;
+	int			n_events;
+	int			n_added;
+	int			assign[X86_PMC_IDX_MAX]; /* event to counter assignment */
+	struct perf_event	*event_list[X86_PMC_IDX_MAX]; /* in enabled order */
 };
 
-#define EVENT_CONSTRAINT(c, m) { .code = (c), .idxmsk[0] = (m) }
-#define EVENT_CONSTRAINT_END  { .code = 0, .idxmsk[0] = 0 }
+#define EVENT_CONSTRAINT(c, n, m) { \
+	.code = (c),	\
+	.cmask = (m),	\
+	.idxmsk[0] = (n) }
 
-#define for_each_event_constraint(e, c) \
-	for ((e) = (c); (e)->idxmsk[0]; (e)++)
+#define EVENT_CONSTRAINT_END \
+	{ .code = 0, .cmask = 0, .idxmsk[0] = 0 }
 
+#define for_each_event_constraint(e, c) \
+	for ((e) = (c); (e)->cmask; (e)++)
 
 /*
  * struct x86_pmu - generic x86 pmu
@@ -114,8 +126,9 @@ struct x86_pmu {
 	u64		intel_ctrl;
 	void		(*enable_bts)(u64 config);
 	void		(*disable_bts)(void);
-	int		(*get_event_idx)(struct cpu_hw_events *cpuc,
-					 struct hw_perf_event *hwc);
+	void		(*get_event_constraints)(struct cpu_hw_events *cpuc, struct perf_event *event, u64 *idxmsk);
+	void		(*put_event_constraints)(struct cpu_hw_events *cpuc, struct perf_event *event);
+	const struct event_constraint *event_constraints;
 };
 
 static struct x86_pmu x86_pmu __read_mostly;
@@ -124,7 +137,8 @@ static DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
 	.enabled = 1,
 };
 
-static const struct event_constraint *event_constraints;
+static int x86_perf_event_set_period(struct perf_event *event,
+			     struct hw_perf_event *hwc, int idx);
 
 /*
  * Not sure about some of these
@@ -171,14 +185,14 @@ static u64 p6_pmu_raw_event(u64 hw_event)
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
+	EVENT_CONSTRAINT(0xc1, 0x1, INTEL_ARCH_EVENT_MASK),	/* FLOPS */
+	EVENT_CONSTRAINT(0x10, 0x1, INTEL_ARCH_EVENT_MASK),	/* FP_COMP_OPS_EXE */
+	EVENT_CONSTRAINT(0x11, 0x1, INTEL_ARCH_EVENT_MASK),	/* FP_ASSIST */
+	EVENT_CONSTRAINT(0x12, 0x2, INTEL_ARCH_EVENT_MASK),	/* MUL */
+	EVENT_CONSTRAINT(0x13, 0x2, INTEL_ARCH_EVENT_MASK),	/* DIV */
+	EVENT_CONSTRAINT(0x14, 0x1, INTEL_ARCH_EVENT_MASK),	/* CYCLES_DIV_BUSY */
 	EVENT_CONSTRAINT_END
 };
 
@@ -196,32 +210,43 @@ static const u64 intel_perfmon_event_map[] =
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
+	EVENT_CONSTRAINT(0xc0, (0x3|(1ULL<<32)), INTEL_ARCH_FIXED_MASK), /* INSTRUCTIONS_RETIRED */
+	EVENT_CONSTRAINT(0x3c, (0x3|(1ULL<<33)), INTEL_ARCH_FIXED_MASK), /* UNHALTED_CORE_CYCLES */
+	EVENT_CONSTRAINT(0x10, 0x1, INTEL_ARCH_EVENT_MASK), /* FP_COMP_OPS_EXE */
+	EVENT_CONSTRAINT(0x11, 0x2, INTEL_ARCH_EVENT_MASK), /* FP_ASSIST */
+	EVENT_CONSTRAINT(0x12, 0x2, INTEL_ARCH_EVENT_MASK), /* MUL */
+	EVENT_CONSTRAINT(0x13, 0x2, INTEL_ARCH_EVENT_MASK), /* DIV */
+	EVENT_CONSTRAINT(0x14, 0x1, INTEL_ARCH_EVENT_MASK), /* CYCLES_DIV_BUSY */
+	EVENT_CONSTRAINT(0x18, 0x1, INTEL_ARCH_EVENT_MASK), /* IDLE_DURING_DIV */
+	EVENT_CONSTRAINT(0x19, 0x2, INTEL_ARCH_EVENT_MASK), /* DELAYED_BYPASS */
+	EVENT_CONSTRAINT(0xa1, 0x1, INTEL_ARCH_EVENT_MASK), /* RS_UOPS_DISPATCH_CYCLES */
+	EVENT_CONSTRAINT(0xcb, 0x1, INTEL_ARCH_EVENT_MASK), /* MEM_LOAD_RETIRED */
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
+static struct event_constraint intel_nehalem_event_constraints[] =
+{
+	EVENT_CONSTRAINT(0xc0, (0x3|(1ULL<<32)), INTEL_ARCH_FIXED_MASK), /* INSTRUCTIONS_RETIRED */
+	EVENT_CONSTRAINT(0x3c, (0x3|(1ULL<<33)), INTEL_ARCH_FIXED_MASK), /* UNHALTED_CORE_CYCLES */
+	EVENT_CONSTRAINT(0x40, 0x3, INTEL_ARCH_EVENT_MASK), /* L1D_CACHE_LD */
+	EVENT_CONSTRAINT(0x41, 0x3, INTEL_ARCH_EVENT_MASK), /* L1D_CACHE_ST */
+	EVENT_CONSTRAINT(0x42, 0x3, INTEL_ARCH_EVENT_MASK), /* L1D_CACHE_LOCK */
+	EVENT_CONSTRAINT(0x43, 0x3, INTEL_ARCH_EVENT_MASK), /* L1D_ALL_REF */
+	EVENT_CONSTRAINT(0x4e, 0x3, INTEL_ARCH_EVENT_MASK), /* L1D_PREFETCH */
+	EVENT_CONSTRAINT(0x4c, 0x3, INTEL_ARCH_EVENT_MASK), /* LOAD_HIT_PRE */
+	EVENT_CONSTRAINT(0x51, 0x3, INTEL_ARCH_EVENT_MASK), /* L1D */
+	EVENT_CONSTRAINT(0x52, 0x3, INTEL_ARCH_EVENT_MASK), /* L1D_CACHE_PREFETCH_LOCK_FB_HIT */
+	EVENT_CONSTRAINT(0x53, 0x3, INTEL_ARCH_EVENT_MASK), /* L1D_CACHE_LOCK_FB_HIT */
+	EVENT_CONSTRAINT(0xc5, 0x3, INTEL_ARCH_EVENT_MASK), /* CACHE_LOCK_CYCLES */
+	EVENT_CONSTRAINT_END
+};
+
+static struct event_constraint intel_gen_event_constraints[] =
+{
+	EVENT_CONSTRAINT(0xc0, (0x3|(1ULL<<32)), INTEL_ARCH_FIXED_MASK), /* INSTRUCTIONS_RETIRED */
+	EVENT_CONSTRAINT(0x3c, (0x3|(1ULL<<33)), INTEL_ARCH_FIXED_MASK), /* UNHALTED_CORE_CYCLES */
 	EVENT_CONSTRAINT_END
 };
 
@@ -527,11 +552,11 @@ static u64 intel_pmu_raw_event(u64 hw_event)
 #define CORE_EVNTSEL_REG_MASK		0xFF000000ULL
 
 #define CORE_EVNTSEL_MASK		\
-	(CORE_EVNTSEL_EVENT_MASK |	\
-	 CORE_EVNTSEL_UNIT_MASK  |	\
-	 CORE_EVNTSEL_EDGE_MASK  |	\
-	 CORE_EVNTSEL_INV_MASK  |	\
-	 CORE_EVNTSEL_REG_MASK)
+	(INTEL_ARCH_EVTSEL_MASK |	\
+	 INTEL_ARCH_UNIT_MASK   |	\
+	 INTEL_ARCH_EDGE_MASK   |	\
+	 INTEL_ARCH_INV_MASK    |	\
+	 INTEL_ARCH_CNT_MASK)
 
 	return hw_event & CORE_EVNTSEL_MASK;
 }
@@ -1120,9 +1145,15 @@ static void amd_pmu_disable_all(void)
 
 void hw_perf_disable(void)
 {
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
 	if (!x86_pmu_initialized())
 		return;
-	return x86_pmu.disable_all();
+
+	if (cpuc->enabled)
+		cpuc->n_added = 0;
+
+	x86_pmu.disable_all();
 }
 
 static void p6_pmu_enable_all(void)
@@ -1189,10 +1220,237 @@ static void amd_pmu_enable_all(void)
 	}
 }
 
+static const struct pmu pmu;
+
+static inline int is_x86_event(struct perf_event *event)
+{
+	return event->pmu == &pmu;
+}
+
+static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
+{
+	int i, j , w, num;
+	int weight, wmax;
+	unsigned long *c;
+	u64 constraints[X86_PMC_IDX_MAX][BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	struct hw_perf_event *hwc;
+
+	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
+
+	for (i = 0; i < n; i++) {
+		x86_pmu.get_event_constraints(cpuc,
+					      cpuc->event_list[i],
+					      constraints[i]);
+	}
+
+	/*
+	 * weight = number of possible counters
+	 *
+	 * 1    = most constrained, only works on one counter
+	 * wmax = least constrained, works on any counter
+	 *
+	 * assign events to counters starting with most
+	 * constrained events.
+	 */
+	wmax = x86_pmu.num_events;
+
+	/*
+	 * when fixed event counters are present,
+	 * wmax is incremented by 1 to account
+	 * for one more choice
+	 */
+	if (x86_pmu.num_events_fixed)
+		wmax++;
+
+	num = n;
+	for (w = 1; num && w <= wmax; w++) {
+		/* for each event */
+		for (i = 0; i < n; i++) {
+			c = (unsigned long *)constraints[i];
+			hwc = &cpuc->event_list[i]->hw;
+
+			weight = bitmap_weight(c, X86_PMC_IDX_MAX);
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
+			for_each_bit(j, c, X86_PMC_IDX_MAX) {
+				if (!test_bit(j, used_mask))
+					break;
+			}
+
+			if (j == X86_PMC_IDX_MAX)
+				break;
+skip:
+			set_bit(j, used_mask);
+
+#if 0
+			pr_debug("CPU%d config=0x%llx idx=%d assign=%c\n",
+				smp_processor_id(),
+				hwc->config,
+				j,
+				assign ? 'y' : 'n');
+#endif
+
+			if (assign)
+				assign[i] = j;
+			num--;
+		}
+	}
+	/*
+	 * scheduling failed or is just a simulation,
+	 * free resources if necessary
+	 */
+	if (!assign || num) {
+		for (i = 0; i < n; i++) {
+			if (x86_pmu.put_event_constraints)
+				x86_pmu.put_event_constraints(cpuc, cpuc->event_list[i]);
+		}
+	}
+	return num ? -ENOSPC : 0;
+}
+
+/*
+ * dogrp: true if must collect siblings events (group)
+ * returns total number of events and error code
+ */
+static int collect_events(struct cpu_hw_events *cpuc, struct perf_event *leader, bool dogrp)
+{
+	struct perf_event *event;
+	int n, max_count;
+
+	max_count = x86_pmu.num_events + x86_pmu.num_events_fixed;
+
+	/* current number of events already accepted */
+	n = cpuc->n_events;
+
+	if (is_x86_event(leader)) {
+		if (n >= max_count)
+			return -ENOSPC;
+		cpuc->event_list[n] = leader;
+		n++;
+	}
+	if (!dogrp)
+		return n;
+
+	list_for_each_entry(event, &leader->sibling_list, group_entry) {
+		if (!is_x86_event(event) ||
+		    event->state == PERF_EVENT_STATE_OFF)
+			continue;
+
+		if (n >= max_count)
+			return -ENOSPC;
+
+		cpuc->event_list[n] = event;
+		n++;
+	}
+	return n;
+}
+
+
+static inline void x86_assign_hw_event(struct perf_event *event,
+				struct hw_perf_event *hwc, int idx)
+{
+	hwc->idx = idx;
+
+	if (hwc->idx == X86_PMC_IDX_FIXED_BTS) {
+		hwc->config_base = 0;
+		hwc->event_base	= 0;
+	} else if (hwc->idx >= X86_PMC_IDX_FIXED) {
+		hwc->config_base = MSR_ARCH_PERFMON_FIXED_CTR_CTRL;
+		/*
+		 * We set it so that event_base + idx in wrmsr/rdmsr maps to
+		 * MSR_ARCH_PERFMON_FIXED_CTR0 ... CTR2:
+		 */
+		hwc->event_base =
+			MSR_ARCH_PERFMON_FIXED_CTR0 - X86_PMC_IDX_FIXED;
+	} else {
+		hwc->config_base = x86_pmu.eventsel;
+		hwc->event_base  = x86_pmu.perfctr;
+	}
+}
+
 void hw_perf_enable(void)
 {
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct perf_event *event;
+	struct hw_perf_event *hwc;
+	int i;
+
 	if (!x86_pmu_initialized())
 		return;
+	if (cpuc->n_added) {
+		/*
+		 * apply assignment obtained either from
+		 * hw_perf_group_sched_in() or x86_pmu_enable()
+		 *
+		 * step1: save events moving to new counters
+		 * step2: reprogram moved events into new counters
+		 */
+		for (i = 0; i < cpuc->n_events; i++) {
+
+			event = cpuc->event_list[i];
+			hwc = &event->hw;
+
+			if (hwc->idx == -1 || hwc->idx == cpuc->assign[i])
+				continue;
+
+			x86_pmu.disable(hwc, hwc->idx);
+
+			clear_bit(hwc->idx, cpuc->active_mask);
+			barrier();
+			cpuc->events[hwc->idx] = NULL;
+
+			x86_perf_event_update(event, hwc, hwc->idx);
+
+			hwc->idx = -1;
+		}
+
+		for (i = 0; i < cpuc->n_events; i++) {
+
+			event = cpuc->event_list[i];
+			hwc = &event->hw;
+
+			if (hwc->idx == -1) {
+				x86_assign_hw_event(event, hwc, cpuc->assign[i]);
+				x86_perf_event_set_period(event, hwc, hwc->idx);
+			}
+			/*
+			 * need to mark as active because x86_pmu_disable()
+			 * clear active_mask and eventsp[] yet it preserves
+			 * idx
+			 */
+			set_bit(hwc->idx, cpuc->active_mask);
+			cpuc->events[hwc->idx] = event;
+
+			x86_pmu.enable(hwc, hwc->idx);
+			perf_event_update_userpage(event);
+		}
+		cpuc->n_added = 0;
+		perf_events_lapic_init();
+	}
 	x86_pmu.enable_all();
 }
 
@@ -1391,148 +1649,43 @@ static void amd_pmu_enable_event(struct hw_perf_event *hwc, int idx)
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
 /*
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
-/*
- * Find a PMC slot for the freshly enabled / scheduled in event:
+ * activate a single event
+ *
+ * The event is added to the group of enabled events
+ * but only if it can be scehduled with existing events.
+ *
+ * Called with PMU disabled. If successful and return value 1,
+ * then guaranteed to call perf_enable() and hw_perf_enable()
  */
 static int x86_pmu_enable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	struct hw_perf_event *hwc = &event->hw;
-	int idx;
+	struct hw_perf_event *hwc;
+	int assign[X86_PMC_IDX_MAX];
+	int n, n0, ret;
 
-	idx = x86_schedule_event(cpuc, hwc);
-	if (idx < 0)
-		return idx;
+	hwc = &event->hw;
 
-	perf_events_lapic_init();
+	n0 = cpuc->n_events;
+	n = collect_events(cpuc, event, false);
+	if (n < 0)
+		return n;
 
-	x86_pmu.disable(hwc, idx);
-
-	cpuc->events[idx] = event;
-	set_bit(idx, cpuc->active_mask);
+	ret = x86_schedule_events(cpuc, n, assign);
+	if (ret)
+		return ret;
+	/*
+	 * copy new assignment, now we know it is possible
+	 * will be used by hw_perf_enable()
+	 */
+	memcpy(cpuc->assign, assign, n*sizeof(int));
 
-	x86_perf_event_set_period(event, hwc, idx);
-	x86_pmu.enable(hwc, idx);
+	cpuc->n_events = n;
+	cpuc->n_added  = n - n0;
 
-	perf_event_update_userpage(event);
+	if (hwc->idx != -1)
+		x86_perf_event_set_period(event, hwc, hwc->idx);
 
 	return 0;
 }
@@ -1576,7 +1729,7 @@ void perf_event_print_debug(void)
 		pr_info("CPU#%d: overflow:   %016llx\n", cpu, overflow);
 		pr_info("CPU#%d: fixed:      %016llx\n", cpu, fixed);
 	}
-	pr_info("CPU#%d: used:       %016llx\n", cpu, *(u64 *)cpuc->used_mask);
+	pr_info("CPU#%d: active:       %016llx\n", cpu, *(u64 *)cpuc->active_mask);
 
 	for (idx = 0; idx < x86_pmu.num_events; idx++) {
 		rdmsrl(x86_pmu.eventsel + idx, pmc_ctrl);
@@ -1664,7 +1817,7 @@ static void x86_pmu_disable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
-	int idx = hwc->idx;
+	int i, idx = hwc->idx;
 
 	/*
 	 * Must be done before we disable, otherwise the nmi handler
@@ -1690,8 +1843,19 @@ static void x86_pmu_disable(struct perf_event *event)
 		intel_pmu_drain_bts_buffer(cpuc);
 
 	cpuc->events[idx] = NULL;
-	clear_bit(idx, cpuc->used_mask);
 
+	for (i = 0; i < cpuc->n_events; i++) {
+		if (event == cpuc->event_list[i]) {
+
+			if (x86_pmu.put_event_constraints)
+				x86_pmu.put_event_constraints(cpuc, event);
+
+			while (++i < cpuc->n_events)
+				cpuc->event_list[i-1] = cpuc->event_list[i];
+
+			--cpuc->n_events;
+		}
+	}
 	perf_event_update_userpage(event);
 }
 
@@ -1962,6 +2126,176 @@ perf_event_nmi_handler(struct notifier_block *self,
 	return NOTIFY_STOP;
 }
 
+static struct event_constraint bts_constraint = {
+	.code = 0,
+	.cmask = 0,
+	.idxmsk[0] = 1ULL << X86_PMC_IDX_FIXED_BTS
+};
+
+static int intel_special_constraints(struct perf_event *event,
+				     u64 *idxmsk)
+{
+	unsigned int hw_event;
+
+	hw_event = event->hw.config & INTEL_ARCH_EVENT_MASK;
+
+	if (unlikely((hw_event ==
+		      x86_pmu.event_map(PERF_COUNT_HW_BRANCH_INSTRUCTIONS)) &&
+		     (event->hw.sample_period == 1))) {
+
+		bitmap_copy((unsigned long *)idxmsk,
+			    (unsigned long *)bts_constraint.idxmsk,
+			    X86_PMC_IDX_MAX);
+		return 1;
+	}
+	return 0;
+}
+
+static void intel_get_event_constraints(struct cpu_hw_events *cpuc,
+					struct perf_event *event,
+					u64 *idxmsk)
+{
+	const struct event_constraint *c;
+
+	/*
+	 * cleanup bitmask
+	 */
+	bitmap_zero((unsigned long *)idxmsk, X86_PMC_IDX_MAX);
+
+	if (intel_special_constraints(event, idxmsk))
+		return;
+
+	if (x86_pmu.event_constraints) {
+		for_each_event_constraint(c, x86_pmu.event_constraints) {
+			if ((event->hw.config & c->cmask) == c->code) {
+
+				bitmap_copy((unsigned long *)idxmsk,
+					    (unsigned long *)c->idxmsk,
+					    X86_PMC_IDX_MAX);
+				return;
+			}
+		}
+	}
+	/* no constraints, means supports all generic counters */
+	bitmap_fill((unsigned long *)idxmsk, x86_pmu.num_events);
+}
+
+static void amd_get_event_constraints(struct cpu_hw_events *cpuc,
+				      struct perf_event *event,
+				      u64 *idxmsk)
+{
+}
+
+static int x86_event_sched_in(struct perf_event *event,
+			  struct perf_cpu_context *cpuctx, int cpu)
+{
+	int ret = 0;
+
+	event->state = PERF_EVENT_STATE_ACTIVE;
+	event->oncpu = cpu;
+	event->tstamp_running += event->ctx->time - event->tstamp_stopped;
+
+	if (!is_x86_event(event))
+		ret = event->pmu->enable(event);
+
+	if (!ret && !is_software_event(event))
+		cpuctx->active_oncpu++;
+
+	if (!ret && event->attr.exclusive)
+		cpuctx->exclusive = 1;
+
+	return ret;
+}
+
+static void x86_event_sched_out(struct perf_event *event,
+			    struct perf_cpu_context *cpuctx, int cpu)
+{
+	event->state = PERF_EVENT_STATE_INACTIVE;
+	event->oncpu = -1;
+
+	if (!is_x86_event(event))
+		event->pmu->disable(event);
+
+	event->tstamp_running -= event->ctx->time - event->tstamp_stopped;
+
+	if (!is_software_event(event))
+		cpuctx->active_oncpu--;
+
+	if (event->attr.exclusive || !cpuctx->active_oncpu)
+		cpuctx->exclusive = 0;
+}
+
+/*
+ * Called to enable a whole group of events.
+ * Returns 1 if the group was enabled, or -EAGAIN if it could not be.
+ * Assumes the caller has disabled interrupts and has
+ * frozen the PMU with hw_perf_save_disable.
+ *
+ * called with PMU disabled. If successful and return value 1,
+ * then guaranteed to call perf_enable() and hw_perf_enable()
+ */
+int hw_perf_group_sched_in(struct perf_event *leader,
+	       struct perf_cpu_context *cpuctx,
+	       struct perf_event_context *ctx, int cpu)
+{
+	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
+	struct perf_event *sub;
+	int assign[X86_PMC_IDX_MAX];
+	int n0, n1, ret;
+
+	/* n0 = total number of events */
+	n0 = collect_events(cpuc, leader, true);
+	if (n0 < 0)
+		return n0;
+
+	ret = x86_schedule_events(cpuc, n0, assign);
+	if (ret)
+		return ret;
+
+	ret = x86_event_sched_in(leader, cpuctx, cpu);
+	if (ret)
+		return ret;
+
+	n1 = 1;
+	list_for_each_entry(sub, &leader->sibling_list, group_entry) {
+		if (sub->state != PERF_EVENT_STATE_OFF) {
+			ret = x86_event_sched_in(sub, cpuctx, cpu);
+			if (ret)
+				goto undo;
+			++n1;
+		}
+	}
+	/*
+	 * copy new assignment, now we know it is possible
+	 * will be used by hw_perf_enable()
+	 */
+	memcpy(cpuc->assign, assign, n0*sizeof(int));
+
+	cpuc->n_events  = n0;
+	cpuc->n_added   = n1;
+	ctx->nr_active += n1;
+
+	/*
+	 * 1 means successful and events are active
+	 * This is not quite true because we defer
+	 * actual activation until hw_perf_enable() but
+	 * this way we* ensure caller won't try to enable
+	 * individual events
+	 */
+	return 1;
+undo:
+	x86_event_sched_out(leader, cpuctx, cpu);
+	n0  = 1;
+	list_for_each_entry(sub, &leader->sibling_list, group_entry) {
+		if (sub->state == PERF_EVENT_STATE_ACTIVE) {
+			x86_event_sched_out(sub, cpuctx, cpu);
+			if (++n0 == n1)
+				break;
+		}
+	}
+	return ret;
+}
+
 static __read_mostly struct notifier_block perf_event_nmi_notifier = {
 	.notifier_call		= perf_event_nmi_handler,
 	.next			= NULL,
@@ -1993,7 +2327,8 @@ static __initconst struct x86_pmu p6_pmu = {
 	 */
 	.event_bits		= 32,
 	.event_mask		= (1ULL << 32) - 1,
-	.get_event_idx		= intel_get_event_idx,
+	.get_event_constraints	= intel_get_event_constraints,
+	.event_constraints	= intel_p6_event_constraints
 };
 
 static __initconst struct x86_pmu intel_pmu = {
@@ -2017,7 +2352,7 @@ static __initconst struct x86_pmu intel_pmu = {
 	.max_period		= (1ULL << 31) - 1,
 	.enable_bts		= intel_pmu_enable_bts,
 	.disable_bts		= intel_pmu_disable_bts,
-	.get_event_idx		= intel_get_event_idx,
+	.get_event_constraints	= intel_get_event_constraints
 };
 
 static __initconst struct x86_pmu amd_pmu = {
@@ -2038,7 +2373,7 @@ static __initconst struct x86_pmu amd_pmu = {
 	.apic			= 1,
 	/* use highest bit to detect overflow */
 	.max_period		= (1ULL << 47) - 1,
-	.get_event_idx		= gen_get_event_idx,
+	.get_event_constraints	= amd_get_event_constraints
 };
 
 static __init int p6_pmu_init(void)
@@ -2051,12 +2386,9 @@ static __init int p6_pmu_init(void)
 	case 7:
 	case 8:
 	case 11: /* Pentium III */
-		event_constraints = intel_p6_event_constraints;
-		break;
 	case 9:
 	case 13:
 		/* Pentium M */
-		event_constraints = intel_p6_event_constraints;
 		break;
 	default:
 		pr_cont("unsupported p6 CPU model %d ",
@@ -2121,23 +2453,29 @@ static __init int intel_pmu_init(void)
 		memcpy(hw_cache_event_ids, core2_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
+		x86_pmu.event_constraints = intel_core_event_constraints;
 		pr_cont("Core2 events, ");
-		event_constraints = intel_core_event_constraints;
 		break;
-	default:
 	case 26:
 		memcpy(hw_cache_event_ids, nehalem_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
-		event_constraints = intel_nehalem_event_constraints;
+		x86_pmu.event_constraints = intel_nehalem_event_constraints;
 		pr_cont("Nehalem/Corei7 events, ");
 		break;
 	case 28:
 		memcpy(hw_cache_event_ids, atom_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
+		x86_pmu.event_constraints = intel_gen_event_constraints;
 		pr_cont("Atom events, ");
 		break;
+	default:
+		/*
+		 * default constraints for v2 and up
+		 */
+		x86_pmu.event_constraints = intel_gen_event_constraints;
+		pr_cont("generic architected perfmon, ");
 	}
 	return 0;
 }
@@ -2234,36 +2572,43 @@ static const struct pmu pmu = {
 	.unthrottle	= x86_pmu_unthrottle,
 };
 
-static int
-validate_event(struct cpu_hw_events *cpuc, struct perf_event *event)
-{
-	struct hw_perf_event fake_event = event->hw;
-
-	if (event->pmu && event->pmu != &pmu)
-		return 0;
-
-	return x86_schedule_event(cpuc, &fake_event) >= 0;
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
+ * PMU if it was the only group available.
+ */
 static int validate_group(struct perf_event *event)
 {
-	struct perf_event *sibling, *leader = event->group_leader;
-	struct cpu_hw_events fake_pmu;
+	struct perf_event *leader = event->group_leader;
+	struct cpu_hw_events fake_cpuc;
+	int n;
 
-	memset(&fake_pmu, 0, sizeof(fake_pmu));
+	memset(&fake_cpuc, 0, sizeof(fake_cpuc));
 
-	if (!validate_event(&fake_pmu, leader))
+	/*
+	 * the event is not yet connected with its
+	 * siblings therefore we must first collect
+	 * existing siblings, then add the new event
+	 * before we can simulate the scheduling
+	 */
+	n = collect_events(&fake_cpuc, leader, true);
+	if (n < 0)
 		return -ENOSPC;
 
-	list_for_each_entry(sibling, &leader->sibling_list, group_entry) {
-		if (!validate_event(&fake_pmu, sibling))
-			return -ENOSPC;
-	}
-
-	if (!validate_event(&fake_pmu, event))
+	fake_cpuc.n_events = n;
+	n = collect_events(&fake_cpuc, event, false);
+	if (n < 0)
 		return -ENOSPC;
 
-	return 0;
+	fake_cpuc.n_events = n;
+
+	return x86_schedule_events(&fake_cpuc, n, NULL);
 }
 
 const struct pmu *hw_perf_event_init(struct perf_event *event)
