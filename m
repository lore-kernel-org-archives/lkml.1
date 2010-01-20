Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445Ab0ATK7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab0ATK7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 05:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167Ab0ATK7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 05:59:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44358
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202Ab0ATK73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 05:59:29 -0500
Date: Wed, 20 Jan 2010 02:59:39 -0800 (PST)
Message-Id: <20100120.025939.160729920.davem@davemloft.net>
To: paulus@samba.org
CC: peterz@infradead.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH]: sparc64: Fully support both performance counters.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Paul, I basically took your powerpc implementation and adapted it to
sparc64's case.

Sparc64 is much simpler in nature, as the event encoding is always the
same no matter what counter the event goes on, and we only have two
counters to contend with.

Events are either restricted to one of the two counters, or can run on
both.

Another noteworthy difference is that I handle counter index
assignment in a somewhat inverted manner to how powerpc does.  The
per-cpu structure maintains where the counter actually is, whereas
event->hw.idx is where the conflict resolver wants us to put it.  It
just ended up feeling more natural to implement it that way.

sparc64: Fully support both performance counters.

Add the rest of the conflict detection and resolution logic necessary
to support more than one counter at a time on sparc64.

The structure and implementation closely mimicks that of powerpc.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index 2386ac6..e856456 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -55,16 +55,49 @@
 
 #define PIC_UPPER_INDEX			0
 #define PIC_LOWER_INDEX			1
+#define PIC_NO_INDEX			-1
 
 struct cpu_hw_events {
-	struct perf_event	*events[MAX_HWEVENTS];
-	unsigned long		used_mask[BITS_TO_LONGS(MAX_HWEVENTS)];
-	unsigned long		active_mask[BITS_TO_LONGS(MAX_HWEVENTS)];
+	/* Number of events currently scheduled onto this cpu.
+	 * This tells how many entries in the arrays below
+	 * are valid.
+	 */
+	int			n_events;
+
+	/* Number of new events added since the last hw_perf_disable().
+	 * This works because the perf event layer always adds new
+	 * events inside of a perf_{disable,enable}() sequence.
+	 */
+	int			n_added;
+
+	/* Array of events current scheduled on this cpu.  */
+	struct perf_event	*event[MAX_HWEVENTS];
+
+	/* Array of encoded longs, specifying the %pcr register
+	 * encoding and the mask of PIC counters this even can
+	 * be scheduled on.  See perf_event_encode() et al.
+	 */
+	unsigned long		events[MAX_HWEVENTS];
+
+	/* The current counter index assigned to an event.  When the
+	 * event hasn't been programmed into the cpu yet, this will
+	 * hold PIC_NO_INDEX.  The event->hw.idx value tells us where
+	 * we ought to schedule the event.
+	 */
+	int			current_idx[MAX_HWEVENTS];
+
+	/* Software copy of %pcr register on this cpu.  */
 	u64			pcr;
+
+	/* Enabled/disable state.  */
 	int			enabled;
 };
 DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = { .enabled = 1, };
 
+/* An event map describes the characteristics of a performance
+ * counter event.  In particular it gives the encoding as well as
+ * a mask telling which counters the event can be measured on.
+ */
 struct perf_event_map {
 	u16	encoding;
 	u8	pic_mask;
@@ -73,15 +106,20 @@ struct perf_event_map {
 #define PIC_LOWER	0x02
 };
 
+/* Encode a perf_event_map entry into a long.  */
 static unsigned long perf_event_encode(const struct perf_event_map *pmap)
 {
 	return ((unsigned long) pmap->encoding << 16) | pmap->pic_mask;
 }
 
-static void perf_event_decode(unsigned long val, u16 *enc, u8 *msk)
+static u8 perf_event_get_msk(unsigned long val)
+{
+	return val & 0xff;
+}
+
+static u64 perf_event_get_enc(unsigned long val)
 {
-	*msk = val & 0xff;
-	*enc = val >> 16;
+	return val >> 16;
 }
 
 #define C(x) PERF_COUNT_HW_CACHE_##x
@@ -495,53 +533,6 @@ static inline void sparc_pmu_disable_event(struct cpu_hw_events *cpuc, struct hw
 	pcr_ops->write(cpuc->pcr);
 }
 
-void hw_perf_enable(void)
-{
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	u64 val;
-	int i;
-
-	if (cpuc->enabled)
-		return;
-
-	cpuc->enabled = 1;
-	barrier();
-
-	val = cpuc->pcr;
-
-	for (i = 0; i < MAX_HWEVENTS; i++) {
-		struct perf_event *cp = cpuc->events[i];
-		struct hw_perf_event *hwc;
-
-		if (!cp)
-			continue;
-		hwc = &cp->hw;
-		val |= hwc->config_base;
-	}
-
-	cpuc->pcr = val;
-
-	pcr_ops->write(cpuc->pcr);
-}
-
-void hw_perf_disable(void)
-{
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	u64 val;
-
-	if (!cpuc->enabled)
-		return;
-
-	cpuc->enabled = 0;
-
-	val = cpuc->pcr;
-	val &= ~(PCR_UTRACE | PCR_STRACE |
-		 sparc_pmu->hv_bit | sparc_pmu->irq_bit);
-	cpuc->pcr = val;
-
-	pcr_ops->write(cpuc->pcr);
-}
-
 static u32 read_pmc(int idx)
 {
 	u64 val;
@@ -570,6 +561,30 @@ static void write_pmc(int idx, u64 val)
 	write_pic(pic);
 }
 
+static u64 sparc_perf_event_update(struct perf_event *event,
+				   struct hw_perf_event *hwc, int idx)
+{
+	int shift = 64 - 32;
+	u64 prev_raw_count, new_raw_count;
+	s64 delta;
+
+again:
+	prev_raw_count = atomic64_read(&hwc->prev_count);
+	new_raw_count = read_pmc(idx);
+
+	if (atomic64_cmpxchg(&hwc->prev_count, prev_raw_count,
+			     new_raw_count) != prev_raw_count)
+		goto again;
+
+	delta = (new_raw_count << shift) - (prev_raw_count << shift);
+	delta >>= shift;
+
+	atomic64_add(delta, &event->count);
+	atomic64_sub(delta, &hwc->period_left);
+
+	return new_raw_count;
+}
+
 static int sparc_perf_event_set_period(struct perf_event *event,
 				       struct hw_perf_event *hwc, int idx)
 {
@@ -602,81 +617,166 @@ static int sparc_perf_event_set_period(struct perf_event *event,
 	return ret;
 }
 
-static int sparc_pmu_enable(struct perf_event *event)
+/* If performance event entries have been added, move existing
+ * events around (if necessary) and then assign new entries to
+ * counters.
+ */
+static u64 maybe_change_configuration(struct cpu_hw_events *cpuc, u64 pcr)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	struct hw_perf_event *hwc = &event->hw;
-	int idx = hwc->idx;
+	int i;
 
-	if (test_and_set_bit(idx, cpuc->used_mask))
-		return -EAGAIN;
+	if (!cpuc->n_added)
+		goto out;
 
-	sparc_pmu_disable_event(cpuc, hwc, idx);
+	/* Read in the counters which are moving.  */
+	for (i = 0; i < cpuc->n_events; i++) {
+		struct perf_event *cp = cpuc->event[i];
 
-	cpuc->events[idx] = event;
-	set_bit(idx, cpuc->active_mask);
+		if (cpuc->current_idx[i] != PIC_NO_INDEX &&
+		    cpuc->current_idx[i] != cp->hw.idx) {
+			sparc_perf_event_update(cp, &cp->hw,
+						cpuc->current_idx[i]);
+			cpuc->current_idx[i] = PIC_NO_INDEX;
+		}
+	}
 
-	sparc_perf_event_set_period(event, hwc, idx);
-	sparc_pmu_enable_event(cpuc, hwc, idx);
-	perf_event_update_userpage(event);
-	return 0;
+	/* Assign to counters all unassigned events.  */
+	for (i = 0; i < cpuc->n_events; i++) {
+		struct perf_event *cp = cpuc->event[i];
+		struct hw_perf_event *hwc = &cp->hw;
+		int idx = hwc->idx;
+		u64 enc;
+
+		if (cpuc->current_idx[i] != PIC_NO_INDEX)
+			continue;
+
+		sparc_perf_event_set_period(cp, hwc, idx);
+		cpuc->current_idx[i] = idx;
+
+		enc = perf_event_get_enc(cpuc->events[i]);
+		pcr |= event_encoding(enc, idx);
+	}
+out:
+	return pcr;
 }
 
-static u64 sparc_perf_event_update(struct perf_event *event,
-				   struct hw_perf_event *hwc, int idx)
+void hw_perf_enable(void)
 {
-	int shift = 64 - 32;
-	u64 prev_raw_count, new_raw_count;
-	s64 delta;
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	u64 pcr;
 
-again:
-	prev_raw_count = atomic64_read(&hwc->prev_count);
-	new_raw_count = read_pmc(idx);
+	if (cpuc->enabled)
+		return;
 
-	if (atomic64_cmpxchg(&hwc->prev_count, prev_raw_count,
-			     new_raw_count) != prev_raw_count)
-		goto again;
+	cpuc->enabled = 1;
+	barrier();
 
-	delta = (new_raw_count << shift) - (prev_raw_count << shift);
-	delta >>= shift;
+	pcr = cpuc->pcr;
+	if (!cpuc->n_events) {
+		pcr = 0;
+	} else {
+		pcr = maybe_change_configuration(cpuc, pcr);
 
-	atomic64_add(delta, &event->count);
-	atomic64_sub(delta, &hwc->period_left);
+		/* We require that all of the events have the same
+		 * configuration, so just fetch the settings from the
+		 * first entry.
+		 */
+		cpuc->pcr = pcr | cpuc->event[0]->hw.config_base;
+	}
 
-	return new_raw_count;
+	pcr_ops->write(cpuc->pcr);
+}
+
+void hw_perf_disable(void)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	u64 val;
+
+	if (!cpuc->enabled)
+		return;
+
+	cpuc->enabled = 0;
+	cpuc->n_added = 0;
+
+	val = cpuc->pcr;
+	val &= ~(PCR_UTRACE | PCR_STRACE |
+		 sparc_pmu->hv_bit | sparc_pmu->irq_bit);
+	cpuc->pcr = val;
+
+	pcr_ops->write(cpuc->pcr);
 }
 
 static void sparc_pmu_disable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
-	int idx = hwc->idx;
+	unsigned long flags;
+	int i;
 
-	clear_bit(idx, cpuc->active_mask);
-	sparc_pmu_disable_event(cpuc, hwc, idx);
+	local_irq_save(flags);
+	perf_disable();
+
+	for (i = 0; i < cpuc->n_events; i++) {
+		if (event == cpuc->event[i]) {
+			int idx = cpuc->current_idx[i];
+
+			/* Shift remaining entries down into
+			 * the existing slot.
+			 */
+			while (++i < cpuc->n_events) {
+				cpuc->event[i - 1] = cpuc->event[i];
+				cpuc->events[i - 1] = cpuc->events[i];
+				cpuc->current_idx[i - 1] =
+					cpuc->current_idx[i];
+			}
+
+			/* Absorb the final count and turn off the
+			 * event.
+			 */
+			sparc_pmu_disable_event(cpuc, hwc, idx);
+			barrier();
+			sparc_perf_event_update(event, hwc, idx);
 
-	barrier();
+			perf_event_update_userpage(event);
 
-	sparc_perf_event_update(event, hwc, idx);
-	cpuc->events[idx] = NULL;
-	clear_bit(idx, cpuc->used_mask);
+			cpuc->n_events--;
+			break;
+		}
+	}
 
-	perf_event_update_userpage(event);
+	perf_enable();
+	local_irq_restore(flags);
+}
+
+static int active_event_index(struct cpu_hw_events *cpuc,
+			      struct perf_event *event)
+{
+	int i;
+
+	for (i = 0; i < cpuc->n_events; i++) {
+		if (cpuc->event[i] == event)
+			break;
+	}
+	BUG_ON(i == cpuc->n_events);
+	return cpuc->current_idx[i];
 }
 
 static void sparc_pmu_read(struct perf_event *event)
 {
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	int idx = active_event_index(cpuc, event);
 	struct hw_perf_event *hwc = &event->hw;
 
-	sparc_perf_event_update(event, hwc, hwc->idx);
+	sparc_perf_event_update(event, hwc, idx);
 }
 
 static void sparc_pmu_unthrottle(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	int idx = active_event_index(cpuc, event);
 	struct hw_perf_event *hwc = &event->hw;
 
-	sparc_pmu_enable_event(cpuc, hwc, hwc->idx);
+	sparc_pmu_enable_event(cpuc, hwc, idx);
 }
 
 static atomic_t active_events = ATOMIC_INIT(0);
@@ -754,43 +854,75 @@ static void hw_perf_event_destroy(struct perf_event *event)
 /* Make sure all events can be scheduled into the hardware at
  * the same time.  This is simplified by the fact that we only
  * need to support 2 simultaneous HW events.
+ *
+ * As a side effect, the evts[]->hw.idx values will be assigned
+ * on success.  These are pending indexes.  When the events are
+ * actually programmed into the chip, these values will propagate
+ * to the per-cpu cpuc->current_idx[] slots, see the code in
+ * maybe_change_configuration() for details.
  */
-static int sparc_check_constraints(unsigned long *events, int n_ev)
+static int sparc_check_constraints(struct perf_event **evts,
+				   unsigned long *events, int n_ev)
 {
-	if (n_ev <= perf_max_events) {
-		u8 msk1, msk2;
-		u16 dummy;
-
-		if (n_ev == 1)
-			return 0;
-		BUG_ON(n_ev != 2);
-		perf_event_decode(events[0], &dummy, &msk1);
-		perf_event_decode(events[1], &dummy, &msk2);
-
-		/* If both events can go on any counter, OK.  */
-		if (msk1 == (PIC_UPPER | PIC_LOWER) &&
-		    msk2 == (PIC_UPPER | PIC_LOWER))
-			return 0;
-
-		/* If one event is limited to a specific counter,
-		 * and the other can go on both, OK.
-		 */
-		if ((msk1 == PIC_UPPER || msk1 == PIC_LOWER) &&
-		    msk2 == (PIC_UPPER | PIC_LOWER))
-			return 0;
-		if ((msk2 == PIC_UPPER || msk2 == PIC_LOWER) &&
-		    msk1 == (PIC_UPPER | PIC_LOWER))
-			return 0;
-
-		/* If the events are fixed to different counters, OK.  */
-		if ((msk1 == PIC_UPPER && msk2 == PIC_LOWER) ||
-		    (msk1 == PIC_LOWER && msk2 == PIC_UPPER))
-			return 0;
-
-		/* Otherwise, there is a conflict.  */
+	u8 msk0 = 0, msk1 = 0;
+	int idx0 = 0;
+
+	/* This case is possible when we are invoked from
+	 * hw_perf_group_sched_in().
+	 */
+	if (!n_ev)
+		return 0;
+
+	if (n_ev > perf_max_events)
+		return -1;
+
+	msk0 = perf_event_get_msk(events[0]);
+	if (n_ev == 1) {
+		if (msk0 & PIC_LOWER)
+			idx0 = 1;
+		goto success;
+	}
+	BUG_ON(n_ev != 2);
+	msk1 = perf_event_get_msk(events[1]);
+
+	/* If both events can go on any counter, OK.  */
+	if (msk0 == (PIC_UPPER | PIC_LOWER) &&
+	    msk1 == (PIC_UPPER | PIC_LOWER))
+		goto success;
+
+	/* If one event is limited to a specific counter,
+	 * and the other can go on both, OK.
+	 */
+	if ((msk0 == PIC_UPPER || msk0 == PIC_LOWER) &&
+	    msk1 == (PIC_UPPER | PIC_LOWER)) {
+		if (msk0 & PIC_LOWER)
+			idx0 = 1;
+		goto success;
 	}
 
+	if ((msk1 == PIC_UPPER || msk1 == PIC_LOWER) &&
+	    msk0 == (PIC_UPPER | PIC_LOWER)) {
+		if (msk1 & PIC_UPPER)
+			idx0 = 1;
+		goto success;
+	}
+
+	/* If the events are fixed to different counters, OK.  */
+	if ((msk0 == PIC_UPPER && msk1 == PIC_LOWER) ||
+	    (msk0 == PIC_LOWER && msk1 == PIC_UPPER)) {
+		if (msk0 & PIC_LOWER)
+			idx0 = 1;
+		goto success;
+	}
+
+	/* Otherwise, there is a conflict.  */
 	return -1;
+
+success:
+	evts[0]->hw.idx = idx0;
+	if (n_ev == 2)
+		evts[1]->hw.idx = idx0 ^ 1;
+	return 0;
 }
 
 static int check_excludes(struct perf_event **evts, int n_prev, int n_new)
@@ -822,7 +954,8 @@ static int check_excludes(struct perf_event **evts, int n_prev, int n_new)
 }
 
 static int collect_events(struct perf_event *group, int max_count,
-			  struct perf_event *evts[], unsigned long *events)
+			  struct perf_event *evts[], unsigned long *events,
+			  int *current_idx)
 {
 	struct perf_event *event;
 	int n = 0;
@@ -831,7 +964,8 @@ static int collect_events(struct perf_event *group, int max_count,
 		if (n >= max_count)
 			return -1;
 		evts[n] = group;
-		events[n++] = group->hw.event_base;
+		events[n] = group->hw.event_base;
+		current_idx[n++] = PIC_NO_INDEX;
 	}
 	list_for_each_entry(event, &group->sibling_list, group_entry) {
 		if (!is_software_event(event) &&
@@ -839,20 +973,100 @@ static int collect_events(struct perf_event *group, int max_count,
 			if (n >= max_count)
 				return -1;
 			evts[n] = event;
-			events[n++] = event->hw.event_base;
+			events[n] = event->hw.event_base;
+			current_idx[n++] = PIC_NO_INDEX;
 		}
 	}
 	return n;
 }
 
+static void event_sched_in(struct perf_event *event, int cpu)
+{
+	event->state = PERF_EVENT_STATE_ACTIVE;
+	event->oncpu = cpu;
+	event->tstamp_running += event->ctx->time - event->tstamp_stopped;
+	if (is_software_event(event))
+		event->pmu->enable(event);
+}
+
+int hw_perf_group_sched_in(struct perf_event *group_leader,
+			   struct perf_cpu_context *cpuctx,
+			   struct perf_event_context *ctx, int cpu)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct perf_event *sub;
+	int n0, n;
+
+	if (!sparc_pmu)
+		return 0;
+
+	n0 = cpuc->n_events;
+	n = collect_events(group_leader, perf_max_events - n0,
+			   &cpuc->event[n0], &cpuc->events[n0],
+			   &cpuc->current_idx[n0]);
+	if (n < 0)
+		return -EAGAIN;
+	if (check_excludes(cpuc->event, n0, n))
+		return -EINVAL;
+	if (sparc_check_constraints(cpuc->event, cpuc->events, n + n0))
+		return -EAGAIN;
+	cpuc->n_events = n0 + n;
+	cpuc->n_added += n;
+
+	cpuctx->active_oncpu += n;
+	n = 1;
+	event_sched_in(group_leader, cpu);
+	list_for_each_entry(sub, &group_leader->sibling_list, group_entry) {
+		if (sub->state != PERF_EVENT_STATE_OFF) {
+			event_sched_in(sub, cpu);
+			n++;
+		}
+	}
+	ctx->nr_active += n;
+
+	return 1;
+}
+
+static int sparc_pmu_enable(struct perf_event *event)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	int n0, ret = -EAGAIN;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	perf_disable();
+
+	n0 = cpuc->n_events;
+	if (n0 >= perf_max_events)
+		goto out;
+
+	cpuc->event[n0] = event;
+	cpuc->events[n0] = event->hw.event_base;
+	cpuc->current_idx[n0] = PIC_NO_INDEX;
+
+	if (check_excludes(cpuc->event, n0, 1))
+		goto out;
+	if (sparc_check_constraints(cpuc->event, cpuc->events, n0 + 1))
+		goto out;
+
+	cpuc->n_events++;
+	cpuc->n_added++;
+
+	ret = 0;
+out:
+	perf_enable();
+	local_irq_restore(flags);
+	return ret;
+}
+
 static int __hw_perf_event_init(struct perf_event *event)
 {
 	struct perf_event_attr *attr = &event->attr;
 	struct perf_event *evts[MAX_HWEVENTS];
 	struct hw_perf_event *hwc = &event->hw;
 	unsigned long events[MAX_HWEVENTS];
+	int current_idx_dmy[MAX_HWEVENTS];
 	const struct perf_event_map *pmap;
-	u64 enc;
 	int n;
 
 	if (atomic_read(&nmi_active) < 0)
@@ -869,10 +1083,7 @@ static int __hw_perf_event_init(struct perf_event *event)
 	} else
 		return -EOPNOTSUPP;
 
-	/* We save the enable bits in the config_base.  So to
-	 * turn off sampling just write 'config', and to enable
-	 * things write 'config | config_base'.
-	 */
+	/* We save the enable bits in the config_base.  */
 	hwc->config_base = sparc_pmu->irq_bit;
 	if (!attr->exclude_user)
 		hwc->config_base |= PCR_UTRACE;
@@ -883,13 +1094,11 @@ static int __hw_perf_event_init(struct perf_event *event)
 
 	hwc->event_base = perf_event_encode(pmap);
 
-	enc = pmap->encoding;
-
 	n = 0;
 	if (event->group_leader != event) {
 		n = collect_events(event->group_leader,
 				   perf_max_events - 1,
-				   evts, events);
+				   evts, events, current_idx_dmy);
 		if (n < 0)
 			return -EINVAL;
 	}
@@ -899,9 +1108,11 @@ static int __hw_perf_event_init(struct perf_event *event)
 	if (check_excludes(evts, n, 1))
 		return -EINVAL;
 
-	if (sparc_check_constraints(events, n + 1))
+	if (sparc_check_constraints(evts, events, n + 1))
 		return -EINVAL;
 
+	hwc->idx = PIC_NO_INDEX;
+
 	/* Try to do all error checking before this point, as unwinding
 	 * state after grabbing the PMC is difficult.
 	 */
@@ -914,15 +1125,6 @@ static int __hw_perf_event_init(struct perf_event *event)
 		atomic64_set(&hwc->period_left, hwc->sample_period);
 	}
 
-	if (pmap->pic_mask & PIC_UPPER) {
-		hwc->idx = PIC_UPPER_INDEX;
-		enc <<= sparc_pmu->upper_shift;
-	} else {
-		hwc->idx = PIC_LOWER_INDEX;
-		enc <<= sparc_pmu->lower_shift;
-	}
-
-	hwc->config |= enc;
 	return 0;
 }
 
@@ -972,7 +1174,7 @@ static int __kprobes perf_event_nmi_handler(struct notifier_block *self,
 	struct perf_sample_data data;
 	struct cpu_hw_events *cpuc;
 	struct pt_regs *regs;
-	int idx;
+	int i;
 
 	if (!atomic_read(&active_events))
 		return NOTIFY_DONE;
@@ -1001,13 +1203,12 @@ static int __kprobes perf_event_nmi_handler(struct notifier_block *self,
 	if (sparc_pmu->irq_bit)
 		pcr_ops->write(cpuc->pcr);
 
-	for (idx = 0; idx < MAX_HWEVENTS; idx++) {
-		struct perf_event *event = cpuc->events[idx];
+	for (i = 0; i < cpuc->n_events; i++) {
+		struct perf_event *event = cpuc->event[i];
+		int idx = cpuc->current_idx[i];
 		struct hw_perf_event *hwc;
 		u64 val;
 
-		if (!test_bit(idx, cpuc->active_mask))
-			continue;
 		hwc = &event->hw;
 		val = sparc_perf_event_update(event, hwc, idx);
 		if (val & (1ULL << 31))
@@ -1059,10 +1260,8 @@ void __init init_hw_perf_events(void)
 
 	pr_cont("Supported PMU type is '%s'\n", sparc_pmu_type);
 
-	/* All sparc64 PMUs currently have 2 events.  But this simple
-	 * driver only supports one active event at a time.
-	 */
-	perf_max_events = 1;
+	/* All sparc64 PMUs currently have 2 events.  */
+	perf_max_events = 2;
 
 	register_die_notifier(&perf_event_nmi_notifier);
 }
