Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933733Ab0BGLbc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 06:31:32 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:47003 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab0BGLbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 06:31:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=S/B7nwP8ndNfeoMlVjDxSsEd/rjQ4dtXWRvEqGt78NSPSTlRt0F3kiCVosozv6Bxxe
         3FFf6VsNt7hNGJVgcgUYKEj+pznc51fTJ2mnSL1lIUo+lt1ZuHXR594qJd8QRHUNtK4K
         4ImqW/nr2YOlgqvWMZwlZYqWYA3IYE3Zt2hCA=
From: highguy@gmail.com
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       andrea@suse.de, tglx@linutronix.de, akpm@linux-foundation.org,
       peterz@infradead.org, Stijn Devriendt <stijn@stijn.telenet.be>
Subject: [PATCH 3/6] Add handlers for adding counter events, reading counter events, counter resets, wakeups. Renamed old read handler to update.
Date: Sun,  7 Feb 2010 12:30:56 +0100
Message-Id: <1265542259-5596-4-git-send-email-HIGHGuY@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1265542259-5596-3-git-send-email-HIGHGuY@gmail.com>
References: <1265542259-5596-1-git-send-email-HIGHGuY@gmail.com>
 <1265542259-5596-2-git-send-email-HIGHGuY@gmail.com>
 <1265542259-5596-3-git-send-email-HIGHGuY@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stijn Devriendt <stijn@stijn.telenet.be>

---
 arch/x86/kernel/cpu/perf_event.c |    4 +-
 include/linux/perf_event.h       |    8 ++-
 kernel/perf_event.c              |  120 +++++++++++++++++++++++++++-----------
 3 files changed, 94 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index c223b7e..9738f22 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -2222,7 +2222,7 @@ void __init init_hw_perf_events(void)
 	pr_info("... event mask:             %016Lx\n", perf_event_mask);
 }
 
-static inline void x86_pmu_read(struct perf_event *event)
+static inline void x86_pmu_update(struct perf_event *event)
 {
 	x86_perf_event_update(event, &event->hw, event->hw.idx);
 }
@@ -2230,7 +2230,7 @@ static inline void x86_pmu_read(struct perf_event *event)
 static const struct pmu pmu = {
 	.enable		= x86_pmu_enable,
 	.disable	= x86_pmu_disable,
-	.read		= x86_pmu_read,
+	.update		= x86_pmu_update,
 	.unthrottle	= x86_pmu_unthrottle,
 };
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 0fa235e..4f7d318 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -513,8 +513,12 @@ struct perf_event;
 struct pmu {
 	int (*enable)			(struct perf_event *event);
 	void (*disable)			(struct perf_event *event);
-	void (*read)			(struct perf_event *event);
+	void (*update)			(struct perf_event *event);
 	void (*unthrottle)		(struct perf_event *event);
+	u64 (*add)                      (struct perf_event *event, u64 count);
+	int (*reset)                    (struct perf_event *event);
+	void (*wakeup)                  (struct perf_event *event);
+	u64 (*read)                     (struct perf_event *event);
 };
 
 /**
@@ -639,7 +643,7 @@ struct perf_event {
 	struct perf_mmap_data		*data;
 
 	/* poll related */
-	atomic_t			poll;		/* POLL_ for wakeups */
+	atomic_t			poll;		/* POLLX for wakeups */
 	wait_queue_head_t		waitq;
 	struct fasync_struct		*fasync;
 
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 70ca6e1..724aafd 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1092,7 +1092,7 @@ static void __perf_event_sync_stat(struct perf_event *event,
 		return;
 
 	/*
-	 * Update the event value, we cannot use perf_event_read()
+	 * Update the event value, we cannot use perf_event_update()
 	 * because we're in the middle of a context switch and have IRQs
 	 * disabled, which upsets smp_call_function_single(), however
 	 * we know the event must be on the current CPU, therefore we
@@ -1100,7 +1100,7 @@ static void __perf_event_sync_stat(struct perf_event *event,
 	 */
 	switch (event->state) {
 	case PERF_EVENT_STATE_ACTIVE:
-		event->pmu->read(event);
+		event->pmu->update(event);
 		/* fall-through */
 
 	case PERF_EVENT_STATE_INACTIVE:
@@ -1534,10 +1534,23 @@ static void perf_event_enable_on_exec(struct task_struct *task)
 	local_irq_restore(flags);
 }
 
+static u64 __perf_event_read(struct perf_event *event)
+{
+	return atomic64_read(&event->count);
+}
+
+static u64 perf_event_read(struct perf_event *event)
+{
+	if (event->pmu->read)
+		return event->pmu->read(event);
+	else
+		return __perf_event_read(event);
+}
+
 /*
  * Cross CPU call to read the hardware event
  */
-static void __perf_event_read(void *info)
+static void __perf_event_update(void *info)
 {
 	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_event *event = info;
@@ -1558,10 +1571,10 @@ static void __perf_event_read(void *info)
 	update_event_times(event);
 	raw_spin_unlock(&ctx->lock);
 
-	event->pmu->read(event);
+	event->pmu->update(event);
 }
 
-static u64 perf_event_read(struct perf_event *event)
+static u64 perf_event_update(struct perf_event *event)
 {
 	/*
 	 * If event is enabled and currently active on a CPU, update the
@@ -1569,7 +1582,7 @@ static u64 perf_event_read(struct perf_event *event)
 	 */
 	if (event->state == PERF_EVENT_STATE_ACTIVE) {
 		smp_call_function_single(event->oncpu,
-					 __perf_event_read, event, 1);
+					 __perf_event_update, event, 1);
 	} else if (event->state == PERF_EVENT_STATE_INACTIVE) {
 		struct perf_event_context *ctx = event->ctx;
 		unsigned long flags;
@@ -1580,7 +1593,7 @@ static u64 perf_event_read(struct perf_event *event)
 		raw_spin_unlock_irqrestore(&ctx->lock, flags);
 	}
 
-	return atomic64_read(&event->count);
+	return perf_event_read(event);
 }
 
 /*
@@ -1793,14 +1806,14 @@ u64 perf_event_read_value(struct perf_event *event, u64 *enabled, u64 *running)
 	*running = 0;
 
 	mutex_lock(&event->child_mutex);
-	total += perf_event_read(event);
+	total += perf_event_update(event);
 	*enabled += event->total_time_enabled +
 			atomic64_read(&event->child_total_time_enabled);
 	*running += event->total_time_running +
 			atomic64_read(&event->child_total_time_running);
 
 	list_for_each_entry(child, &event->child_list, child_list) {
-		total += perf_event_read(child);
+		total += perf_event_update(child);
 		*enabled += child->total_time_enabled;
 		*running += child->total_time_running;
 	}
@@ -1925,7 +1938,7 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
 
 	if (event->attr.threshold)
 	{
-		u64 count = atomic64_read(&event->count);
+		u64 count = perf_event_read(event);
 		if (count < event->attr.min_threshold)
 			events |= POLLIN;
 		else if (count > event->attr.max_threshold)
@@ -1937,13 +1950,25 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
 	return events;
 }
 
-static void perf_event_reset(struct perf_event *event)
+static void perf_event_reset_noop(struct perf_event *event)
+{
+}
+
+static void __perf_event_reset(struct perf_event *event)
 {
-	(void)perf_event_read(event);
+	(void)perf_event_update(event);
 	atomic64_set(&event->count, 0);
 	perf_event_update_userpage(event);
 }
 
+static void perf_event_reset(struct perf_event *event)
+{
+	if (event->pmu->reset)
+		event->pmu->reset(event);
+	else
+		__perf_event_reset(event);
+}
+
 /*
  * Holding the top-level event's child_mutex means that any
  * descendant process that has inherited this event will block
@@ -2123,7 +2148,7 @@ void perf_event_update_userpage(struct perf_event *event)
 	++userpg->lock;
 	barrier();
 	userpg->index = perf_event_index(event);
-	userpg->offset = atomic64_read(&event->count);
+	userpg->offset = perf_event_read(event);
 	if (event->state == PERF_EVENT_STATE_ACTIVE)
 		userpg->offset -= atomic64_read(&event->hw.prev_count);
 
@@ -2540,7 +2565,10 @@ static const struct file_operations perf_fops = {
 
 void perf_event_wakeup(struct perf_event *event)
 {
-	wake_up_all(&event->waitq);
+	if (event->pmu->wakeup)
+		event->pmu->wakeup(event);
+	else
+		wake_up_all(&event->waitq);
 
 	if (event->pending_kill) {
 		kill_fasync(&event->fasync, SIGIO, event->pending_kill);
@@ -2689,7 +2717,7 @@ static bool perf_output_space(struct perf_mmap_data *data, unsigned long tail,
 
 static void __perf_output_wakeup(struct perf_event* event, int nmi)
 {
-	if (event->attr.threshold && atomic64_read(&event->count) > event->attr.max_threshold)
+	if (event->attr.threshold && perf_event_read(event) > event->attr.max_threshold)
 		return;
 	
 	atomic_set(&event->poll, POLLIN);
@@ -2912,7 +2940,7 @@ void perf_output_end(struct perf_output_handle *handle)
 	struct perf_event *event = handle->event;
 	struct perf_mmap_data *data = handle->data;
 
-	int wakeup_events = event->attr.thresold ? 1 : event->attr.wakeup_events;
+	int wakeup_events = event->attr.threshold ? 1 : event->attr.wakeup_events;
 
 	if (handle->sample && wakeup_events) {
 		int events = atomic_inc_return(&data->events);
@@ -2955,7 +2983,7 @@ static void perf_output_read_one(struct perf_output_handle *handle,
 	u64 values[4];
 	int n = 0;
 
-	values[n++] = atomic64_read(&event->count);
+	values[n++] = perf_event_read(event);
 	if (read_format & PERF_FORMAT_TOTAL_TIME_ENABLED) {
 		values[n++] = event->total_time_enabled +
 			atomic64_read(&event->child_total_time_enabled);
@@ -2990,7 +3018,7 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 		values[n++] = leader->total_time_running;
 
 	if (leader != event)
-		leader->pmu->read(leader);
+		leader->pmu->update(leader);
 
 	values[n++] = atomic64_read(&leader->count);
 	if (read_format & PERF_FORMAT_ID)
@@ -3002,7 +3030,7 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 		n = 0;
 
 		if (sub != event)
-			sub->pmu->read(sub);
+			sub->pmu->update(sub);
 
 		values[n++] = atomic64_read(&sub->count);
 		if (read_format & PERF_FORMAT_ID)
@@ -3737,6 +3765,29 @@ int perf_event_overflow(struct perf_event *event, int nmi,
 	return __perf_event_overflow(event, nmi, 1, data, regs);
 }
 
+static void perf_event_wakeup_one(struct perf_event *event)
+{
+	wake_up(&event->waitq);
+}
+
+static u64 __perf_event_add(struct perf_event *event, u64 count)
+{
+	return atomic64_add_return(count, &event->count);
+}
+
+static u64 perf_event_add(struct perf_event *event, u64 count)
+{
+	if (event->pmu->add)
+		return event->pmu->add(event, count);
+	else
+		return __perf_event_add(event, count);
+}
+
+static u64 perf_event_add_parent(struct perf_event *event, u64 count)
+{
+	return event->parent ? __perf_event_add(event->parent, count) : __perf_event_add(event, count);
+}
+
 /*
  * Generic software event infrastructure
  */
@@ -3811,7 +3862,7 @@ static void perf_swevent_add(struct perf_event *event, u64 nr,
 {
 	struct hw_perf_event *hwc = &event->hw;
 
-	atomic64_add(nr, &event->count);
+	perf_event_add(event, nr);
 
 	if (!regs)
 		return;
@@ -4011,10 +4062,11 @@ static void perf_swevent_disable(struct perf_event *event)
 {
 }
 
+
 static const struct pmu perf_ops_generic = {
 	.enable		= perf_swevent_enable,
 	.disable	= perf_swevent_disable,
-	.read		= perf_swevent_read,
+	.update		= perf_swevent_read,
 	.unthrottle	= perf_swevent_unthrottle,
 };
 
@@ -4031,7 +4083,7 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
 	u64 period;
 
 	event	= container_of(hrtimer, struct perf_event, hw.hrtimer);
-	event->pmu->read(event);
+	event->pmu->update(event);
 
 	data.addr = 0;
 	data.raw = NULL;
@@ -4097,7 +4149,7 @@ static void perf_swevent_cancel_hrtimer(struct perf_event *event)
  * Software event: cpu wall time clock
  */
 
-static void cpu_clock_perf_event_update(struct perf_event *event)
+static void __cpu_clock_perf_event_update(struct perf_event *event)
 {
 	int cpu = raw_smp_processor_id();
 	s64 prev;
@@ -4105,7 +4157,7 @@ static void cpu_clock_perf_event_update(struct perf_event *event)
 
 	now = cpu_clock(cpu);
 	prev = atomic64_xchg(&event->hw.prev_count, now);
-	atomic64_add(now - prev, &event->count);
+	perf_event_add(event, now - prev);
 }
 
 static int cpu_clock_perf_event_enable(struct perf_event *event)
@@ -4122,32 +4174,32 @@ static int cpu_clock_perf_event_enable(struct perf_event *event)
 static void cpu_clock_perf_event_disable(struct perf_event *event)
 {
 	perf_swevent_cancel_hrtimer(event);
-	cpu_clock_perf_event_update(event);
+	__cpu_clock_perf_event_update(event);
 }
 
-static void cpu_clock_perf_event_read(struct perf_event *event)
+static void cpu_clock_perf_event_update(struct perf_event *event)
 {
-	cpu_clock_perf_event_update(event);
+	__cpu_clock_perf_event_update(event);
 }
 
 static const struct pmu perf_ops_cpu_clock = {
 	.enable		= cpu_clock_perf_event_enable,
 	.disable	= cpu_clock_perf_event_disable,
-	.read		= cpu_clock_perf_event_read,
+	.update		= cpu_clock_perf_event_update,
 };
 
 /*
  * Software event: task time clock
  */
 
-static void task_clock_perf_event_update(struct perf_event *event, u64 now)
+static void __task_clock_perf_event_update(struct perf_event *event, u64 now)
 {
 	u64 prev;
 	s64 delta;
 
 	prev = atomic64_xchg(&event->hw.prev_count, now);
 	delta = now - prev;
-	atomic64_add(delta, &event->count);
+	perf_event_add(event, delta);
 }
 
 static int task_clock_perf_event_enable(struct perf_event *event)
@@ -4167,11 +4219,11 @@ static int task_clock_perf_event_enable(struct perf_event *event)
 static void task_clock_perf_event_disable(struct perf_event *event)
 {
 	perf_swevent_cancel_hrtimer(event);
-	task_clock_perf_event_update(event, event->ctx->time);
+	__task_clock_perf_event_update(event, event->ctx->time);
 
 }
 
-static void task_clock_perf_event_read(struct perf_event *event)
+static void task_clock_perf_event_update(struct perf_event *event)
 {
 	u64 time;
 
@@ -4184,13 +4236,13 @@ static void task_clock_perf_event_read(struct perf_event *event)
 		time = event->ctx->time + delta;
 	}
 
-	task_clock_perf_event_update(event, time);
+	__task_clock_perf_event_update(event, time);
 }
 
 static const struct pmu perf_ops_task_clock = {
 	.enable		= task_clock_perf_event_enable,
 	.disable	= task_clock_perf_event_disable,
-	.read		= task_clock_perf_event_read,
+	.update		= task_clock_perf_event_update,
 };
 
 #ifdef CONFIG_EVENT_PROFILE
-- 
1.6.6

