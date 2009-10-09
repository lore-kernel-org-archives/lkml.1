Return-Path: <linux-kernel-owner+w=401wt.eu-S933253AbZJIOXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253AbZJIOXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 10:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933222AbZJIOXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 10:23:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:42792 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933206AbZJIOXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 10:23:35 -0400
Date: Fri, 9 Oct 2009 14:22:36 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, eranian@gmail.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, eranian@gmail.com,
       mingo@elte.hu
In-Reply-To: <1254911461.26976.239.camel@twins>
References: <1254911461.26976.239.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Add simple group validation
Message-ID: <tip-fe9081cc9bdabb0be953a39ad977cea14e35bce5@git.kernel.org>
Git-Commit-ID: fe9081cc9bdabb0be953a39ad977cea14e35bce5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 09 Oct 2009 14:22:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fe9081cc9bdabb0be953a39ad977cea14e35bce5
Gitweb:     http://git.kernel.org/tip/fe9081cc9bdabb0be953a39ad977cea14e35bce5
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 8 Oct 2009 11:56:07 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 9 Oct 2009 15:56:14 +0200

perf, x86: Add simple group validation

Refuse to add events when the group wouldn't fit onto the PMU
anymore.

Naive implementation.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@gmail.com>
LKML-Reference: <1254911461.26976.239.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |   90 +++++++++++++++++++++++++++++---------
 1 files changed, 69 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 9c75854..9961d84 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -114,7 +114,8 @@ struct x86_pmu {
 	u64		intel_ctrl;
 	void		(*enable_bts)(u64 config);
 	void		(*disable_bts)(void);
-	int		(*get_event_idx)(struct hw_perf_event *hwc);
+	int		(*get_event_idx)(struct cpu_hw_events *cpuc,
+					 struct hw_perf_event *hwc);
 };
 
 static struct x86_pmu x86_pmu __read_mostly;
@@ -523,7 +524,7 @@ static u64 intel_pmu_raw_event(u64 hw_event)
 #define CORE_EVNTSEL_UNIT_MASK		0x0000FF00ULL
 #define CORE_EVNTSEL_EDGE_MASK		0x00040000ULL
 #define CORE_EVNTSEL_INV_MASK		0x00800000ULL
-#define CORE_EVNTSEL_REG_MASK	0xFF000000ULL
+#define CORE_EVNTSEL_REG_MASK		0xFF000000ULL
 
 #define CORE_EVNTSEL_MASK		\
 	(CORE_EVNTSEL_EVENT_MASK |	\
@@ -1390,8 +1391,7 @@ static void amd_pmu_enable_event(struct hw_perf_event *hwc, int idx)
 		x86_pmu_enable_event(hwc, idx);
 }
 
-static int
-fixed_mode_idx(struct perf_event *event, struct hw_perf_event *hwc)
+static int fixed_mode_idx(struct hw_perf_event *hwc)
 {
 	unsigned int hw_event;
 
@@ -1424,9 +1424,9 @@ fixed_mode_idx(struct perf_event *event, struct hw_perf_event *hwc)
 /*
  * generic counter allocator: get next free counter
  */
-static int gen_get_event_idx(struct hw_perf_event *hwc)
+static int
+gen_get_event_idx(struct cpu_hw_events *cpuc, struct hw_perf_event *hwc)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int idx;
 
 	idx = find_first_zero_bit(cpuc->used_mask, x86_pmu.num_events);
@@ -1436,16 +1436,16 @@ static int gen_get_event_idx(struct hw_perf_event *hwc)
 /*
  * intel-specific counter allocator: check event constraints
  */
-static int intel_get_event_idx(struct hw_perf_event *hwc)
+static int
+intel_get_event_idx(struct cpu_hw_events *cpuc, struct hw_perf_event *hwc)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	const struct event_constraint *event_constraint;
 	int i, code;
 
 	if (!event_constraint)
 		goto skip;
 
-	code = hwc->config & 0xff;
+	code = hwc->config & CORE_EVNTSEL_EVENT_MASK;
 
 	for_each_event_constraint(event_constraint, event_constraint) {
 		if (code == event_constraint->code) {
@@ -1457,26 +1457,22 @@ static int intel_get_event_idx(struct hw_perf_event *hwc)
 		}
 	}
 skip:
-	return gen_get_event_idx(hwc);
+	return gen_get_event_idx(cpuc, hwc);
 }
 
-/*
- * Find a PMC slot for the freshly enabled / scheduled in event:
- */
-static int x86_pmu_enable(struct perf_event *event)
+static int
+x86_schedule_event(struct cpu_hw_events *cpuc, struct hw_perf_event *hwc)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	struct hw_perf_event *hwc = &event->hw;
 	int idx;
 
-	idx = fixed_mode_idx(event, hwc);
+	idx = fixed_mode_idx(hwc);
 	if (idx == X86_PMC_IDX_FIXED_BTS) {
 		/* BTS is already occupied. */
 		if (test_and_set_bit(idx, cpuc->used_mask))
 			return -EAGAIN;
 
 		hwc->config_base	= 0;
-		hwc->event_base	= 0;
+		hwc->event_base		= 0;
 		hwc->idx		= idx;
 	} else if (idx >= 0) {
 		/*
@@ -1499,17 +1495,33 @@ static int x86_pmu_enable(struct perf_event *event)
 		/* Try to get the previous generic event again */
 		if (idx == -1 || test_and_set_bit(idx, cpuc->used_mask)) {
 try_generic:
-			idx = x86_pmu.get_event_idx(hwc);
+			idx = x86_pmu.get_event_idx(cpuc, hwc);
 			if (idx == -1)
 				return -EAGAIN;
 
 			set_bit(idx, cpuc->used_mask);
 			hwc->idx = idx;
 		}
-		hwc->config_base  = x86_pmu.eventsel;
-		hwc->event_base = x86_pmu.perfctr;
+		hwc->config_base = x86_pmu.eventsel;
+		hwc->event_base  = x86_pmu.perfctr;
 	}
 
+	return idx;
+}
+
+/*
+ * Find a PMC slot for the freshly enabled / scheduled in event:
+ */
+static int x86_pmu_enable(struct perf_event *event)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct hw_perf_event *hwc = &event->hw;
+	int idx;
+
+	idx = x86_schedule_event(cpuc, hwc);
+	if (idx < 0)
+		return idx;
+
 	perf_events_lapic_init();
 
 	x86_pmu.disable(hwc, idx);
@@ -2212,11 +2224,47 @@ static const struct pmu pmu = {
 	.unthrottle	= x86_pmu_unthrottle,
 };
 
+static int
+validate_event(struct cpu_hw_events *cpuc, struct perf_event *event)
+{
+	struct hw_perf_event fake_event = event->hw;
+
+	if (event->pmu != &pmu)
+		return 0;
+
+	return x86_schedule_event(cpuc, &fake_event);
+}
+
+static int validate_group(struct perf_event *event)
+{
+	struct perf_event *sibling, *leader = event->group_leader;
+	struct cpu_hw_events fake_pmu;
+
+	memset(&fake_pmu, 0, sizeof(fake_pmu));
+
+	if (!validate_event(&fake_pmu, leader))
+		return -ENOSPC;
+
+	list_for_each_entry(sibling, &leader->sibling_list, group_entry) {
+		if (!validate_event(&fake_pmu, sibling))
+			return -ENOSPC;
+	}
+
+	if (!validate_event(&fake_pmu, event))
+		return -ENOSPC;
+
+	return 0;
+}
+
 const struct pmu *hw_perf_event_init(struct perf_event *event)
 {
 	int err;
 
 	err = __hw_perf_event_init(event);
+	if (!err) {
+		if (event->group_leader != event)
+			err = validate_group(event);
+	}
 	if (err) {
 		if (event->destroy)
 			event->destroy(event);
