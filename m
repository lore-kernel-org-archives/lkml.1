Return-Path: <linux-kernel-owner+w=401wt.eu-S933190AbZJIOXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190AbZJIOXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 10:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932458AbZJIOXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 10:23:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:42789 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932275AbZJIOXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 10:23:30 -0400
Date: Fri, 9 Oct 2009 14:22:22 GMT
From: tip-bot for Stephane Eranian <eranian@googlemail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       eranian@googlemail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       eranian@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eranian@googlemail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       eranian@gmail.com, mingo@elte.hu
In-Reply-To: <1254840129-6198-3-git-send-email-eranian@gmail.com>
References: <1254840129-6198-3-git-send-email-eranian@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Add event constraints support for Intel processors
Message-ID: <tip-b690081d4d3f6a23541493f1682835c3cd5c54a1@git.kernel.org>
Git-Commit-ID: b690081d4d3f6a23541493f1682835c3cd5c54a1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 09 Oct 2009 14:22:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b690081d4d3f6a23541493f1682835c3cd5c54a1
Gitweb:     http://git.kernel.org/tip/b690081d4d3f6a23541493f1682835c3cd5c54a1
Author:     Stephane Eranian <eranian@googlemail.com>
AuthorDate: Tue, 6 Oct 2009 16:42:09 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 9 Oct 2009 15:56:12 +0200

perf_events: Add event constraints support for Intel processors

On some Intel processors, not all events can be measured in all
counters. Some events can only be measured in one particular
counter, for instance. Assigning an event to the wrong counter does
not crash the machine but this yields bogus counts, i.e., silent
error.

This patch changes the event to counter assignment logic to take
into account event constraints for Intel P6, Core and Nehalem
processors. There is no contraints on Intel Atom. There are
constraints on Intel Yonah (Core Duo) but they are not provided in
this patch given that this processor is not yet supported by
perf_events.

As a result of the constraints, it is possible for some event
groups to never actually be loaded onto the PMU if they contain two
events which can only be measured on a single counter. That
situation can be detected with the scaling information extracted
with read().

Signed-off-by: Stephane Eranian <eranian@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1254840129-6198-3-git-send-email-eranian@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |  109 ++++++++++++++++++++++++++++++++++++--
 1 files changed, 105 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 1d16bd6..9c75854 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -77,6 +77,18 @@ struct cpu_hw_events {
 	struct debug_store	*ds;
 };
 
+struct event_constraint {
+	unsigned long	idxmsk[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	int		code;
+};
+
+#define EVENT_CONSTRAINT(c, m) { .code = (c), .idxmsk[0] = (m) }
+#define EVENT_CONSTRAINT_END  { .code = 0, .idxmsk[0] = 0 }
+
+#define for_each_event_constraint(e, c) \
+	for ((e) = (c); (e)->idxmsk[0]; (e)++)
+
+
 /*
  * struct x86_pmu - generic x86 pmu
  */
@@ -102,6 +114,7 @@ struct x86_pmu {
 	u64		intel_ctrl;
 	void		(*enable_bts)(u64 config);
 	void		(*disable_bts)(void);
+	int		(*get_event_idx)(struct hw_perf_event *hwc);
 };
 
 static struct x86_pmu x86_pmu __read_mostly;
@@ -110,6 +123,8 @@ static DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
 	.enabled = 1,
 };
 
+static const struct event_constraint *event_constraint;
+
 /*
  * Not sure about some of these
  */
@@ -155,6 +170,16 @@ static u64 p6_pmu_raw_event(u64 hw_event)
 	return hw_event & P6_EVNTSEL_MASK;
 }
 
+static const struct event_constraint intel_p6_event_constraints[] =
+{
+	EVENT_CONSTRAINT(0xc1, 0x1),	/* FLOPS */
+	EVENT_CONSTRAINT(0x10, 0x1),	/* FP_COMP_OPS_EXE */
+	EVENT_CONSTRAINT(0x11, 0x1),	/* FP_ASSIST */
+	EVENT_CONSTRAINT(0x12, 0x2),	/* MUL */
+	EVENT_CONSTRAINT(0x13, 0x2),	/* DIV */
+	EVENT_CONSTRAINT(0x14, 0x1),	/* CYCLES_DIV_BUSY */
+	EVENT_CONSTRAINT_END
+};
 
 /*
  * Intel PerfMon v3. Used on Core2 and later.
@@ -170,6 +195,35 @@ static const u64 intel_perfmon_event_map[] =
   [PERF_COUNT_HW_BUS_CYCLES]		= 0x013c,
 };
 
+static const struct event_constraint intel_core_event_constraints[] =
+{
+	EVENT_CONSTRAINT(0x10, 0x1),	/* FP_COMP_OPS_EXE */
+	EVENT_CONSTRAINT(0x11, 0x2),	/* FP_ASSIST */
+	EVENT_CONSTRAINT(0x12, 0x2),	/* MUL */
+	EVENT_CONSTRAINT(0x13, 0x2),	/* DIV */
+	EVENT_CONSTRAINT(0x14, 0x1),	/* CYCLES_DIV_BUSY */
+	EVENT_CONSTRAINT(0x18, 0x1),	/* IDLE_DURING_DIV */
+	EVENT_CONSTRAINT(0x19, 0x2),	/* DELAYED_BYPASS */
+	EVENT_CONSTRAINT(0xa1, 0x1),	/* RS_UOPS_DISPATCH_CYCLES */
+	EVENT_CONSTRAINT(0xcb, 0x1),	/* MEM_LOAD_RETIRED */
+	EVENT_CONSTRAINT_END
+};
+
+static const struct event_constraint intel_nehalem_event_constraints[] =
+{
+	EVENT_CONSTRAINT(0x40, 0x3),	/* L1D_CACHE_LD */
+	EVENT_CONSTRAINT(0x41, 0x3),	/* L1D_CACHE_ST */
+	EVENT_CONSTRAINT(0x42, 0x3),	/* L1D_CACHE_LOCK */
+	EVENT_CONSTRAINT(0x43, 0x3),	/* L1D_ALL_REF */
+	EVENT_CONSTRAINT(0x4e, 0x3),	/* L1D_PREFETCH */
+	EVENT_CONSTRAINT(0x4c, 0x3),	/* LOAD_HIT_PRE */
+	EVENT_CONSTRAINT(0x51, 0x3),	/* L1D */
+	EVENT_CONSTRAINT(0x52, 0x3),	/* L1D_CACHE_PREFETCH_LOCK_FB_HIT */
+	EVENT_CONSTRAINT(0x53, 0x3),	/* L1D_CACHE_LOCK_FB_HIT */
+	EVENT_CONSTRAINT(0xc5, 0x3),	/* CACHE_LOCK_CYCLES */
+	EVENT_CONSTRAINT_END
+};
+
 static u64 intel_pmu_event_map(int hw_event)
 {
 	return intel_perfmon_event_map[hw_event];
@@ -932,6 +986,8 @@ static int __hw_perf_event_init(struct perf_event *event)
 	 */
 	hwc->config = ARCH_PERFMON_EVENTSEL_INT;
 
+	hwc->idx = -1;
+
 	/*
 	 * Count user and OS events unless requested not to.
 	 */
@@ -1366,6 +1422,45 @@ fixed_mode_idx(struct perf_event *event, struct hw_perf_event *hwc)
 }
 
 /*
+ * generic counter allocator: get next free counter
+ */
+static int gen_get_event_idx(struct hw_perf_event *hwc)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	int idx;
+
+	idx = find_first_zero_bit(cpuc->used_mask, x86_pmu.num_events);
+	return idx == x86_pmu.num_events ? -1 : idx;
+}
+
+/*
+ * intel-specific counter allocator: check event constraints
+ */
+static int intel_get_event_idx(struct hw_perf_event *hwc)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	const struct event_constraint *event_constraint;
+	int i, code;
+
+	if (!event_constraint)
+		goto skip;
+
+	code = hwc->config & 0xff;
+
+	for_each_event_constraint(event_constraint, event_constraint) {
+		if (code == event_constraint->code) {
+			for_each_bit(i, event_constraint->idxmsk, X86_PMC_IDX_MAX) {
+				if (!test_and_set_bit(i, cpuc->used_mask))
+					return i;
+			}
+			return -1;
+		}
+	}
+skip:
+	return gen_get_event_idx(hwc);
+}
+
+/*
  * Find a PMC slot for the freshly enabled / scheduled in event:
  */
 static int x86_pmu_enable(struct perf_event *event)
@@ -1402,11 +1497,10 @@ static int x86_pmu_enable(struct perf_event *event)
 	} else {
 		idx = hwc->idx;
 		/* Try to get the previous generic event again */
-		if (test_and_set_bit(idx, cpuc->used_mask)) {
+		if (idx == -1 || test_and_set_bit(idx, cpuc->used_mask)) {
 try_generic:
-			idx = find_first_zero_bit(cpuc->used_mask,
-						  x86_pmu.num_events);
-			if (idx == x86_pmu.num_events)
+			idx = x86_pmu.get_event_idx(hwc);
+			if (idx == -1)
 				return -EAGAIN;
 
 			set_bit(idx, cpuc->used_mask);
@@ -1883,6 +1977,7 @@ static struct x86_pmu p6_pmu = {
 	 */
 	.event_bits		= 32,
 	.event_mask		= (1ULL << 32) - 1,
+	.get_event_idx		= intel_get_event_idx,
 };
 
 static struct x86_pmu intel_pmu = {
@@ -1906,6 +2001,7 @@ static struct x86_pmu intel_pmu = {
 	.max_period		= (1ULL << 31) - 1,
 	.enable_bts		= intel_pmu_enable_bts,
 	.disable_bts		= intel_pmu_disable_bts,
+	.get_event_idx		= intel_get_event_idx,
 };
 
 static struct x86_pmu amd_pmu = {
@@ -1926,6 +2022,7 @@ static struct x86_pmu amd_pmu = {
 	.apic			= 1,
 	/* use highest bit to detect overflow */
 	.max_period		= (1ULL << 47) - 1,
+	.get_event_idx		= gen_get_event_idx,
 };
 
 static int p6_pmu_init(void)
@@ -1938,10 +2035,12 @@ static int p6_pmu_init(void)
 	case 7:
 	case 8:
 	case 11: /* Pentium III */
+		event_constraint = intel_p6_event_constraints;
 		break;
 	case 9:
 	case 13:
 		/* Pentium M */
+		event_constraint = intel_p6_event_constraints;
 		break;
 	default:
 		pr_cont("unsupported p6 CPU model %d ",
@@ -2013,12 +2112,14 @@ static int intel_pmu_init(void)
 		       sizeof(hw_cache_event_ids));
 
 		pr_cont("Core2 events, ");
+		event_constraint = intel_core_event_constraints;
 		break;
 	default:
 	case 26:
 		memcpy(hw_cache_event_ids, nehalem_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
+		event_constraint = intel_nehalem_event_constraints;
 		pr_cont("Nehalem/Corei7 events, ");
 		break;
 	case 28:
