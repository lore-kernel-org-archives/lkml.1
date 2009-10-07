Return-Path: <linux-kernel-owner+w=401wt.eu-S1758719AbZJGK2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719AbZJGK2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 06:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758139AbZJGK2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 06:28:12 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:49353 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757549AbZJGK2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 06:28:11 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 2/2] perf_events: add event constraints support for
 Intel  processors
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: eranian@gmail.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       perfmon2-devel@lists.sf.net
In-Reply-To: <7c86c4470910061026o247c182dwdea7fa7296027@mail.gmail.com>
References: <1254840129-6198-1-git-send-email-eranian@gmail.com>
	 <1254840129-6198-2-git-send-email-eranian@gmail.com>
	 <1254840129-6198-3-git-send-email-eranian@gmail.com>
	 <1254846544.21044.298.camel@laptop>
	 <7c86c4470910061026o247c182dwdea7fa7296027@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 07 Oct 2009 12:31:01 +0200
Message-Id: <1254911461.26976.239.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 19:26 +0200, stephane eranian wrote:
> >>       As a result of the constraints, it is possible for some event groups
> >>       to never actually be loaded onto the PMU if they contain two events
> >>       which can only be measured on a single counter. That situation can be
> >>       detected with the scaling information extracted with read().
> >
> > Right, that's a pre existing bug in the x86 code (we can create groups
> > larger than the PMU) and should be fixed.
> >
> Nope, this happens event if you specify only two events on a two-counter
> PMU. For instance, if I want to breakdown the number of multiplication
> between user and kernel to compute a ratio. I would measure MUL twice:
> 
>     perf stat -e MUL:u,MUL:k
> 
> Assuming that with perf you could express that you want those events grouped.
> This would always yield zero. I am not using all the counters but my two events
> compete for the same counter, here counter 0.

Right, so what I meant was, we could specify unschedulable groups by
adding more counters than present, these constraints make that worse.

> The problem is that for the tool it is hard to print some meaningful
> messages to help
> the user. You can detect something is wrong with the group because time_enabled
> will be zero. But there are multiple reasons why this can happen.

Something like the below patch (on top of your two patches, compile
tested only) would give better feedback by returning -ENOSPC when a
group doesn't fit (still relies on the counter order).

> But what is more problematic is if I build a group with an event
> without a constraint
> and one with a constraint. For instance, I want to measure BACLEARS and MUL in
> the same group. If I make BACLEARS the group leader then the group will never
> be loaded. That's because the assignment code  looks at each event individually.
> Thus it will assign BACLEARS to the first available counter, i.e.,
> counter 0. Then it will
> try to assign MUL, which can only run on counter 0, and it will always
> fail. The assignment
> code needs to look at groups not individual events. Then, it will be
> able to find a working
> assignment: MUL -> counter0, BACLEARS -> counter 1.
> 
> By design of this API, the user should never be concerned about
> ordering the events
> in a group a certain way to get a successful assignment to counters.
> This should all
> be handled by the kernel.

Agreed, the POWER implementation actually does this quite nicely, maybe
we should borrow some of its code for scheduling groups.


---
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -114,7 +114,8 @@ struct x86_pmu {
 	u64		intel_ctrl;
 	void		(*enable_bts)(u64 config);
 	void		(*disable_bts)(void);
-	int 		(*get_event_idx)(struct hw_perf_event *hwc);
+	int 		(*get_event_idx)(struct cpu_hw_events *cpuc, 
+					 struct hw_perf_event *hwc);
 };
 
 static struct x86_pmu x86_pmu __read_mostly;
@@ -520,7 +521,7 @@ static u64 intel_pmu_raw_event(u64 hw_ev
 #define CORE_EVNTSEL_UNIT_MASK		0x0000FF00ULL
 #define CORE_EVNTSEL_EDGE_MASK		0x00040000ULL
 #define CORE_EVNTSEL_INV_MASK		0x00800000ULL
-#define CORE_EVNTSEL_REG_MASK	0xFF000000ULL
+#define CORE_EVNTSEL_REG_MASK		0xFF000000ULL
 
 #define CORE_EVNTSEL_MASK		\
 	(CORE_EVNTSEL_EVENT_MASK |	\
@@ -1387,8 +1388,7 @@ static void amd_pmu_enable_event(struct 
 		x86_pmu_enable_event(hwc, idx);
 }
 
-static int
-fixed_mode_idx(struct perf_event *event, struct hw_perf_event *hwc)
+static int fixed_mode_idx(struct hw_perf_event *hwc)
 {
 	unsigned int hw_event;
 
@@ -1421,9 +1421,9 @@ fixed_mode_idx(struct perf_event *event,
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
@@ -1433,16 +1433,16 @@ static int gen_get_event_idx(struct hw_p
 /*
  * intel-specific counter allocator: check event constraints
  */
-static int intel_get_event_idx(struct hw_perf_event *hwc)
+static int 
+intel_get_event_idx(struct cpu_hw_events *cpuc, struct hw_perf_event *hwc)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	const struct evt_cstr *evt;
 	int i, code;
 
 	if (!evt_cstr)
 		goto skip;
 
-	code = hwc->config & 0xff;
+	code = hwc->config & CORE_EVNTSEL_EVENT_MASK;
 
 	for_each_evt_cstr(evt, evt_cstr) {
 		if (code == evt->code) {
@@ -1454,26 +1454,22 @@ static int intel_get_event_idx(struct hw
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
@@ -1496,17 +1492,33 @@ static int x86_pmu_enable(struct perf_ev
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
@@ -2209,11 +2221,47 @@ static const struct pmu pmu = {
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


