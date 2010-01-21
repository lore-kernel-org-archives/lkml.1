Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445Ab0AUQo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab0AUQo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 11:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989Ab0AUQo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 11:44:27 -0500
Received: from smtp-out.google.com ([216.239.33.17]:22304 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab0AUQo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 11:44:26 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=OTHYXMrduxX9cp2FO5gptgUTcEjYnKoyTqCHprM8e6UehTaylJVAXIf2lXU2IOTAK
	mAVVi09AE+K/KW5ioU7UQ==
Message-ID: <4b588464.1818d00a.4456.383b@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Thu, 21 Jan 2010 17:39:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
       eranian@google.com
Subject: [PATCH]  perf_events: improve x86 event scheduling (v6 incremental)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Note unlike previous versions, this patch is incremental on top of our
	v5 patch.

	This patch improves event scheduling by maximizing the use
	of PMU registers regardless of the order in which events are
	created in a group.

	The algorithm takes into account the list of counter constraints
	for each event. It assigns events to counters from the most
	constrained, i.e., works on only one counter, to the least
	constrained, i.e., works on any counter.

	Intel Fixed counter events and the BTS special event are also
	handled via this algorithm which is designed to be fairly generic.

	The patch also updates the validation of an event to use the
	scheduling algorithm. This will cause early failure in
	perf_event_open().

	The 2nd version of this patch follows the model used
	by PPC, by running the scheduling algorithm and the actual
	assignment separately. Actual assignment takes place in
	hw_perf_enable() whereas scheduling is implemented in
	hw_perf_group_sched_in() and x86_pmu_enable().

	The 3rd version does:
	- correct handling of pmu->enable() error in hw_perf_group_sched_in()
	- simplified event scheduling
	- constraint storage in x86_schedule_events() (dynamic constraints)
	- new put_event_constraints() callback to release a dynamic constraint

	The 4th version does:
	- remove leftover debug code in x86_perf_event_set_period()

	The 5th version does:
	- fix missing bitmask initialization in intel_get_event_constraints()
	- use bitmap_copy() instead of memcpy() to copy bitmasks
	- call pmu->disable() in x86_event_sched_out()

	The 6th version does:
	- implement correct fastpath scheduling, i.e., reuse previous assignment
	- skip reprogramming counters in hw_perf_enable() with a generation number
	- define is_x86_event() to filter on non x86 pmu events
	
	Signed-off-by: Stephane Eranian <eranian@google.com>

--
 arch/x86/kernel/cpu/perf_event.c |  160 +++++++++++++++++++++++----------------
 include/linux/perf_event.h       |    2 
 2 files changed, 100 insertions(+), 62 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 03a888d..a961b1f 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -87,6 +87,7 @@ struct cpu_hw_events {
 	int			n_events;
 	int			n_added;
 	int			assign[X86_PMC_IDX_MAX]; /* event to counter assignment */
+	u64			tags[X86_PMC_IDX_MAX];
 	struct perf_event	*event_list[X86_PMC_IDX_MAX]; /* in enabled order */
 };
 
@@ -140,6 +141,7 @@ static DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
 static int x86_perf_event_set_period(struct perf_event *event,
 			     struct hw_perf_event *hwc, int idx);
 
+static const struct pmu pmu;
 /*
  * Not sure about some of these
  */
@@ -159,6 +161,12 @@ static u64 p6_pmu_event_map(int hw_event)
 	return p6_perfmon_event_map[hw_event];
 }
 
+static inline int is_x86_event(struct perf_event *event)
+{
+	return event->pmu == &pmu;
+}
+
+
 /*
  * Event setting that is specified not to count anything.
  * We use this to effectively disable a counter.
@@ -1010,6 +1018,8 @@ static int __hw_perf_event_init(struct perf_event *event)
 	hwc->config = ARCH_PERFMON_EVENTSEL_INT;
 
 	hwc->idx = -1;
+	hwc->last_cpu = -1;
+	hwc->last_tag = ~0ULL;
 
 	/*
 	 * Count user and OS events unless requested not to.
@@ -1235,6 +1245,44 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 	}
 
 	/*
+	 * fastpath, try to reuse previous register
+	 */
+	for(i=0, num = n; i < n; i++, num--) {
+		hwc = &cpuc->event_list[i]->hw;
+		c = (unsigned long *)constraints[i];
+
+		/* never assigned */
+		if (hwc->idx == -1)
+			break;
+
+		/* constraint still honored */
+		if (!test_bit(hwc->idx, c))
+			break;
+
+		/* not already used */
+		if (test_bit(hwc->idx, used_mask))
+			break;
+
+		pr_debug("CPU%d fast config=0x%llx idx=%d assign=%c\n",
+			 smp_processor_id(),
+			 hwc->config,
+			 hwc->idx,
+			 assign ? 'y' : 'n');
+
+		set_bit(hwc->idx, used_mask);
+		if (assign)
+			assign[i] = hwc->idx;
+	}
+	if (!num)
+		goto done;
+
+	/*
+	 * begin slow path
+	 */
+
+	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
+
+	/*
 	 * weight = number of possible counters
 	 *
 	 * 1    = most constrained, only works on one counter
@@ -1253,11 +1301,10 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 	if (x86_pmu.num_events_fixed)
 		wmax++;
 
-	num = n;
-	for(w=1; num && w <= wmax; w++) {
+	for(w=1, num = n; num && w <= wmax; w++) {
 
 		/* for each event */
-		for(i=0; i < n; i++) {
+		for(i=0; num && i < n; i++) {
 			c = (unsigned long *)constraints[i];
 			hwc = &cpuc->event_list[i]->hw;
 
@@ -1265,28 +1312,6 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 			if (weight != w)
 				continue;
 
-			/*
-			 * try to reuse previous assignment
-			 *
-			 * This is possible despite the fact that
-			 * events or events order may have changed.
-			 *
-			 * What matters is the level of constraints
-			 * of an event and this is constant for now.
-			 *
-			 * This is possible also because we always
-			 * scan from most to least constrained. Thus,
-			 * if a counter can be reused, it means no,
-			 * more constrained events, needed it. And
-			 * next events will either compete for it
-			 * (which cannot be solved anyway) or they
-			 * have fewer constraints, and they can use
-			 * another counter.
-			 */
-			j = hwc->idx;
-			if (j != -1 && !test_bit(j, used_mask))
-				goto skip;
-
 			for_each_bit(j, c, X86_PMC_IDX_MAX) {
 				if (!test_bit(j, used_mask))
 					break;
@@ -1294,20 +1319,21 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 
 			if (j == X86_PMC_IDX_MAX)
 				break;
-skip:
-			set_bit(j, used_mask);
 
-			pr_debug("CPU%d config=0x%llx idx=%d assign=%c\n",
+			pr_debug("CPU%d slow config=0x%llx idx=%d assign=%c\n",
 				smp_processor_id(),
 				hwc->config,
 				j,
 				assign ? 'y' : 'n');
 
+			set_bit(j, used_mask);
+
 			if (assign)
 				assign[i] = j;
 			num--;
 		}
 	}
+done:
 	/*
 	 * scheduling failed or is just a simulation,
 	 * free resources if necessary
@@ -1335,7 +1361,7 @@ static int collect_events(struct cpu_hw_events *cpuc, struct perf_event *leader,
 	/* current number of events already accepted */
 	n = cpuc->n_events;
 
-	if (!is_software_event(leader)) {
+	if (is_x86_event(leader)) {
 		if (n >= max_count)
 			return -ENOSPC;
 		cpuc->event_list[n] = leader;
@@ -1345,8 +1371,8 @@ static int collect_events(struct cpu_hw_events *cpuc, struct perf_event *leader,
 		return n;
 
 	list_for_each_entry(event, &leader->sibling_list, group_entry) {
-		if (is_software_event(event) ||
-		    event->state == PERF_EVENT_STATE_OFF)
+		if (!is_x86_event(event) ||
+		    event->state <= PERF_EVENT_STATE_OFF)
 			continue;
 
 		if (n >= max_count)
@@ -1358,11 +1384,15 @@ static int collect_events(struct cpu_hw_events *cpuc, struct perf_event *leader,
 	return n;
 }
 
-
 static inline void x86_assign_hw_event(struct perf_event *event,
-				struct hw_perf_event *hwc, int idx)
+				struct cpu_hw_events *cpuc,
+				int idx)
 {
+	struct hw_perf_event *hwc = &event->hw;
+
 	hwc->idx = idx;
+	hwc->last_cpu = smp_processor_id();
+	hwc->last_tag = ++cpuc->tags[idx];
 
 	if (hwc->idx == X86_PMC_IDX_FIXED_BTS) {
 		hwc->config_base = 0;
@@ -1383,6 +1413,11 @@ static inline void x86_assign_hw_event(struct perf_event *event,
 
 void hw_perf_enable(void)
 {
+#define match_prev_assignment(h, c, i) \
+	((h)->idx == (c)->assign[i] \
+	 && (h)->last_cpu == smp_processor_id() \
+	 && (h)->last_tag == (c)->tags[i])
+
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct perf_event *event;
 	struct hw_perf_event *hwc;
@@ -1395,40 +1430,28 @@ void hw_perf_enable(void)
 		 * apply assignment obtained either from
 		 * hw_perf_group_sched_in() or x86_pmu_enable()
 		 *
-		 * step1: save events moving to new counters
-		 * step2: reprogram moved events into new counters
+		 * We either re-enable or re-program and re-enable.
+		 * All events are disabled by the time we come here.
+		 * That means their state has been saved already.
 		 */
 		for(i=0; i < cpuc->n_events; i++) {
 
 			event = cpuc->event_list[i];
 			hwc = &event->hw;
 
-			if (hwc->idx == -1 || hwc->idx == cpuc->assign[i])
-				continue;
-
-			x86_pmu.disable(hwc, hwc->idx);
-
-			clear_bit(hwc->idx, cpuc->active_mask);
-			barrier();
-			cpuc->events[hwc->idx] = NULL;
-
-			x86_perf_event_update(event, hwc, hwc->idx);
-
-			hwc->idx = -1;
-		}
-
-		for(i=0; i < cpuc->n_events; i++) {
-
-			event = cpuc->event_list[i];
-			hwc = &event->hw;
-
-			if (hwc->idx == -1) {
-				x86_assign_hw_event(event, hwc, cpuc->assign[i]);
+			/*
+			 * we can avoid reprogramming counter if:
+			 * - assigned same counter as last time
+			 * - running on same CPU as last time
+			 * - no other event has used the counter since
+			 */
+			if (!match_prev_assignment(hwc, cpuc, i)) {
+				x86_assign_hw_event(event, cpuc, cpuc->assign[i]);
 				x86_perf_event_set_period(event, hwc, hwc->idx);
 			}
 			/*
 			 * need to mark as active because x86_pmu_disable()
-			 * clear active_mask and eventsp[] yet it preserves
+			 * clear active_mask and events[] yet it preserves
 			 * idx
 			 */
 			set_bit(hwc->idx, cpuc->active_mask);
@@ -2180,6 +2203,8 @@ static void amd_get_event_constraints(struct cpu_hw_events *cpuc,
 				      struct perf_event *event,
 				      u64 *idxmsk)
 {
+	/* no constraints, means supports all generic counters */
+	bitmap_fill((unsigned long *)idxmsk, x86_pmu.num_events);
 }
 
 static int x86_event_sched_in(struct perf_event *event,
@@ -2191,10 +2216,10 @@ static int x86_event_sched_in(struct perf_event *event,
 	event->oncpu = cpu;
 	event->tstamp_running += event->ctx->time - event->tstamp_stopped;
 
-	if (is_software_event(event))
+	if (!is_x86_event(event))
 		ret = event->pmu->enable(event);
 
-	if (!ret && !is_software_event(event))
+	if (!ret && is_x86_event(event))
 		cpuctx->active_oncpu++;
 
 	if (!ret && event->attr.exclusive)
@@ -2209,12 +2234,12 @@ static void x86_event_sched_out(struct perf_event *event,
 	event->state = PERF_EVENT_STATE_INACTIVE;
 	event->oncpu = -1;
 
-	if (is_software_event(event))
+	if (!is_x86_event(event))
 		event->pmu->disable(event);
 
 	event->tstamp_running -= event->ctx->time - event->tstamp_stopped;
 
-	if (!is_software_event(event))
+	if (is_x86_event(event))
 		cpuctx->active_oncpu--;
 
 	if (event->attr.exclusive || !cpuctx->active_oncpu)
@@ -2254,7 +2279,7 @@ int hw_perf_group_sched_in(struct perf_event *leader,
 
 	n1 = 1;
 	list_for_each_entry(sub, &leader->sibling_list, group_entry) {
-		if (sub->state != PERF_EVENT_STATE_OFF) {
+		if (sub->state > PERF_EVENT_STATE_OFF) {
 			ret = x86_event_sched_in(sub, cpuctx, cpu);
 			if (ret)
 				goto undo;
@@ -2609,12 +2634,23 @@ static int validate_group(struct perf_event *event)
 
 const struct pmu *hw_perf_event_init(struct perf_event *event)
 {
+	const struct pmu *tmp;
 	int err;
 
 	err = __hw_perf_event_init(event);
 	if (!err) {
+		/*
+ 		 * we temporarily connect event to its pmu
+ 		 * such that validate_group() can classify
+ 		 * it as an x86 event using is_x86_event()
+ 		 */
+		tmp = event->pmu;
+		event->pmu = &pmu;
+
 		if (event->group_leader != event)
 			err = validate_group(event);
+
+		event->pmu = tmp;
 	}
 	if (err) {
 		if (event->destroy)
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 9a1d276..d8a1d34 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -478,9 +478,11 @@ struct hw_perf_event {
 	union {
 		struct { /* hardware */
 			u64		config;
+			u64		last_tag;
 			unsigned long	config_base;
 			unsigned long	event_base;
 			int		idx;
+			int		last_cpu;
 		};
 		struct { /* software */
 			s64		remaining;
