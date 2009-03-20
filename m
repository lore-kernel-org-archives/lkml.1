Return-Path: <linux-kernel-owner+w=401wt.eu-S1758229AbZCTMH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229AbZCTMH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 08:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbZCTMHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 08:07:50 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:42579 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbZCTMHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 08:07:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18883.34555.748843.35920@cargo.ozlabs.ibm.com>
Date: Fri, 20 Mar 2009 23:07:23 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH/RFC] perfcounters: record time running and time
   enabled for each counter
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: new functionality

Currently, if there are more counters enabled than can fit on the CPU,
the kernel will multiplex the counters on to the hardware using
round-robin scheduling.  That isn't too bad for sampling counters, but
for counting counters it means that the value read from a counter
represents some unknown fraction of the true count of events that
occurred while the counter was enabled.

This remedies the situation by keeping track of how long each counter
is enabled for, and how long it is actually on the cpu and counting
events.  These times are recorded in nanoseconds using the task clock
for per-task counters and the cpu clock for per-cpu counters.

These values can be supplied to userspace on a read from the counter.
Userspace requests that they be supplied after the counter value by
setting the PERF_FORMAT_TIME_ENABLED and/or PERF_FORMAT_TIME_RUNNING
bits in the hw_event.read_format field when creating the counter.
(There is no way to change the read format after the counter is
created, though it would be possible to add some way to do that.)

Using this information it is possible for userspace to scale the count
it reads from the counter to get an estimate of the true count:

	true_count_estimate = count * time_enabled / time_running

This also lets userspace detect the situation where the counter never
got to go on the cpu: time_running == 0.

This functionality has been requested by the PAPI developers, and will
be generally needed for interpreting the count values from counting
counters correctly.

In the implementation, this keeps 5 time values for each counter:
time_enabled and time_running are used when the counter is in state
OFF or ERROR and for reporting back to userspace.  When the counter is
in state INACTIVE or ACTIVE, it is the start_enabled, start_running
and last_stopped values that are relevant, and time_enabled and
time_running are determined from them.  (last_stopped is only used in
INACTIVE state.)  The reason for doing it like this is that it means
that only counters being enabled or disabled at sched-in and sched-out
time need to be updated.  There are no new loops that iterate over all
counters to update time_enabled or time_running.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
I'll rebase this on top of Peter's string of patches that have just
gone in, but I'm posting this version to get peoples' comments on the
implementation.

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 5008762..871089b 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -454,6 +454,8 @@ static void counter_sched_in(struct perf_counter *counter, int cpu)
 {
 	counter->state = PERF_COUNTER_STATE_ACTIVE;
 	counter->oncpu = cpu;
+	counter->start_running += counter->ctx->time_now -
+		counter->last_stopped;
 	if (is_software_counter(counter))
 		counter->hw_ops->enable(counter);
 }
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 08c11a6..9e70b75 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -65,6 +65,16 @@ enum perf_counter_record_type {
 };
 
 /*
+ * Bits that can be set in hw_event.read_format to request that
+ * reads on the counter should return the indicated quantities,
+ * in increasing order of bit value, after the counter value.
+ */
+enum perf_counter_read_format {
+	PERF_FORMAT_TIME_ENABLED	=  1,
+	PERF_FORMAT_TIME_RUNNING	=  2,
+};
+
+/*
  * Hardware event to monitor via a performance monitoring counter:
  */
 struct perf_counter_hw_event {
@@ -196,6 +206,12 @@ struct perf_counter {
 	enum perf_counter_active_state	prev_state;
 	atomic64_t			count;
 
+	u64				time_enabled;
+	u64				time_running;
+	u64				start_enabled;
+	u64				start_running;
+	u64				last_stopped;
+
 	struct perf_counter_hw_event	hw_event;
 	struct hw_perf_counter		hw;
 
@@ -251,6 +267,8 @@ struct perf_counter_context {
 	int			nr_active;
 	int			is_active;
 	struct task_struct	*task;
+	u64			time_now;
+	u64			time_lost;
 #endif
 };
 
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index b39456a..49a4b29 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -109,6 +109,7 @@ counter_sched_out(struct perf_counter *counter,
 		return;
 
 	counter->state = PERF_COUNTER_STATE_INACTIVE;
+	counter->last_stopped = ctx->time_now;
 	counter->hw_ops->disable(counter);
 	counter->oncpu = -1;
 
@@ -245,6 +246,59 @@ retry:
 }
 
 /*
+ * Get the current time for this context.
+ * If this is a task context, we use the task's task clock,
+ * or for a per-cpu context, we use the cpu clock.
+ */
+static u64 get_context_time(struct perf_counter_context *ctx, int update)
+{
+	struct task_struct *curr = ctx->task;
+
+	if (!curr)
+		return cpu_clock(smp_processor_id());
+
+	return __task_delta_exec(curr, update) + curr->se.sum_exec_runtime;
+}
+
+/*
+ * Update the record of the current time in a context.
+ */
+static void update_context_time(struct perf_counter_context *ctx, int update)
+{
+	ctx->time_now = get_context_time(ctx, update) - ctx->time_lost;
+}
+
+/*
+ * Update the time_enabled and time_running fields for a counter.
+ */
+static void update_counter_times(struct perf_counter *counter)
+{
+	struct perf_counter_context *ctx = counter->ctx;
+	u64 run_end;
+
+	if (counter->state >= PERF_COUNTER_STATE_INACTIVE) {
+		counter->time_enabled = ctx->time_now - counter->start_enabled;
+		if (counter->state == PERF_COUNTER_STATE_INACTIVE)
+			run_end = counter->last_stopped;
+		else
+			run_end = ctx->time_now;
+		counter->time_running = run_end - counter->start_running;
+	}
+}
+
+/*
+ * Update time_enabled and time_running for all counters in a group.
+ */
+static void update_group_times(struct perf_counter *leader)
+{
+	struct perf_counter *counter;
+
+	update_counter_times(leader);
+	list_for_each_entry(counter, &leader->sibling_list, list_entry)
+		update_counter_times(counter);
+}
+
+/*
  * Cross CPU call to disable a performance counter
  */
 static void __perf_counter_disable(void *info)
@@ -269,6 +323,8 @@ static void __perf_counter_disable(void *info)
 	 * If it is in error state, leave it in error state.
 	 */
 	if (counter->state >= PERF_COUNTER_STATE_INACTIVE) {
+		update_context_time(ctx, 1);
+		update_counter_times(counter);
 		if (counter == counter->group_leader)
 			group_sched_out(counter, cpuctx, ctx);
 		else
@@ -313,8 +369,10 @@ static void perf_counter_disable(struct perf_counter *counter)
 	 * Since we have the lock this context can't be scheduled
 	 * in, so we can change the state safely.
 	 */
-	if (counter->state == PERF_COUNTER_STATE_INACTIVE)
+	if (counter->state == PERF_COUNTER_STATE_INACTIVE) {
+		update_counter_times(counter);
 		counter->state = PERF_COUNTER_STATE_OFF;
+	}
 
 	spin_unlock_irq(&ctx->lock);
 }
@@ -359,6 +417,8 @@ counter_sched_in(struct perf_counter *counter,
 		return -EAGAIN;
 	}
 
+	counter->start_running += ctx->time_now - counter->last_stopped;
+
 	if (!is_software_counter(counter))
 		cpuctx->active_oncpu++;
 	ctx->nr_active++;
@@ -416,6 +476,17 @@ static int group_can_go_on(struct perf_counter *counter,
 	return can_add_hw;
 }
 
+static void add_counter_to_ctx(struct perf_counter *counter,
+			       struct perf_counter_context *ctx)
+{
+	list_add_counter(counter, ctx);
+	ctx->nr_counters++;
+	counter->prev_state = PERF_COUNTER_STATE_OFF;
+	counter->start_enabled = ctx->time_now;
+	counter->start_running = ctx->time_now;
+	counter->last_stopped = ctx->time_now;
+}
+
 /*
  * Cross CPU call to install and enable a performance counter
  */
@@ -440,6 +511,7 @@ static void __perf_install_in_context(void *info)
 
 	curr_rq_lock_irq_save(&flags);
 	spin_lock(&ctx->lock);
+	update_context_time(ctx, 1);
 
 	/*
 	 * Protect the list operation against NMI by disabling the
@@ -447,9 +519,7 @@ static void __perf_install_in_context(void *info)
 	 */
 	perf_flags = hw_perf_save_disable();
 
-	list_add_counter(counter, ctx);
-	ctx->nr_counters++;
-	counter->prev_state = PERF_COUNTER_STATE_OFF;
+	add_counter_to_ctx(counter, ctx);
 
 	/*
 	 * Don't put the counter on if it is disabled or if
@@ -477,8 +547,10 @@ static void __perf_install_in_context(void *info)
 		 */
 		if (leader != counter)
 			group_sched_out(leader, cpuctx, ctx);
-		if (leader->hw_event.pinned)
+		if (leader->hw_event.pinned) {
+			update_group_times(leader);
 			leader->state = PERF_COUNTER_STATE_ERROR;
+		}
 	}
 
 	if (!err && !ctx->task && cpuctx->max_pertask)
@@ -539,10 +611,8 @@ retry:
 	 * can add the counter safely, if it the call above did not
 	 * succeed.
 	 */
-	if (list_empty(&counter->list_entry)) {
-		list_add_counter(counter, ctx);
-		ctx->nr_counters++;
-	}
+	if (list_empty(&counter->list_entry))
+		add_counter_to_ctx(counter, ctx);
 	spin_unlock_irq(&ctx->lock);
 }
 
@@ -567,11 +637,13 @@ static void __perf_counter_enable(void *info)
 
 	curr_rq_lock_irq_save(&flags);
 	spin_lock(&ctx->lock);
+	update_context_time(ctx, 1);
 
 	counter->prev_state = counter->state;
 	if (counter->state >= PERF_COUNTER_STATE_INACTIVE)
 		goto unlock;
 	counter->state = PERF_COUNTER_STATE_INACTIVE;
+	counter->start_enabled = ctx->time_now - counter->time_enabled;
 
 	/*
 	 * If the counter is in a group and isn't the group leader,
@@ -593,8 +665,10 @@ static void __perf_counter_enable(void *info)
 		 */
 		if (leader != counter)
 			group_sched_out(leader, cpuctx, ctx);
-		if (leader->hw_event.pinned)
+		if (leader->hw_event.pinned) {
+			update_group_times(leader);
 			leader->state = PERF_COUNTER_STATE_ERROR;
+		}
 	}
 
  unlock:
@@ -650,8 +724,10 @@ static void perf_counter_enable(struct perf_counter *counter)
 	 * Since we have the lock this context can't be scheduled
 	 * in, so we can change the state safely.
 	 */
-	if (counter->state == PERF_COUNTER_STATE_OFF)
+	if (counter->state == PERF_COUNTER_STATE_OFF) {
 		counter->state = PERF_COUNTER_STATE_INACTIVE;
+		counter->start_enabled = ctx->time_now - counter->time_enabled;
+	}
  out:
 	spin_unlock_irq(&ctx->lock);
 }
@@ -684,6 +760,7 @@ void __perf_counter_sched_out(struct perf_counter_context *ctx,
 	ctx->is_active = 0;
 	if (likely(!ctx->nr_counters))
 		goto out;
+	update_context_time(ctx, 0);
 
 	flags = hw_perf_save_disable();
 	if (ctx->nr_active) {
@@ -785,6 +862,13 @@ __perf_counter_sched_in(struct perf_counter_context *ctx,
 	if (likely(!ctx->nr_counters))
 		goto out;
 
+	/*
+	 * Add any time since the last sched_out to the lost time
+	 * so it doesn't get included in the time_enabled and
+	 * time_running measures for counters in the context.
+	 */
+	ctx->time_lost += get_context_time(ctx, 0) - ctx->time_now;
+
 	flags = hw_perf_save_disable();
 
 	/*
@@ -805,8 +889,10 @@ __perf_counter_sched_in(struct perf_counter_context *ctx,
 		 * If this pinned group hasn't been scheduled,
 		 * put it in error state.
 		 */
-		if (counter->state == PERF_COUNTER_STATE_INACTIVE)
+		if (counter->state == PERF_COUNTER_STATE_INACTIVE) {
+			update_group_times(counter);
 			counter->state = PERF_COUNTER_STATE_ERROR;
+		}
 	}
 
 	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
@@ -890,8 +976,10 @@ int perf_counter_task_disable(void)
 	perf_flags = hw_perf_save_disable();
 
 	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
-		if (counter->state != PERF_COUNTER_STATE_ERROR)
+		if (counter->state != PERF_COUNTER_STATE_ERROR) {
+			update_group_times(counter);
 			counter->state = PERF_COUNTER_STATE_OFF;
+		}
 	}
 
 	hw_perf_restore(perf_flags);
@@ -934,6 +1022,7 @@ int perf_counter_task_enable(void)
 		if (counter->state > PERF_COUNTER_STATE_OFF)
 			continue;
 		counter->state = PERF_COUNTER_STATE_INACTIVE;
+		counter->start_enabled = ctx->time_now - counter->time_enabled;
 		counter->hw_event.disabled = 0;
 	}
 	hw_perf_restore(perf_flags);
@@ -997,10 +1086,14 @@ void perf_counter_task_tick(struct task_struct *curr, int cpu)
 static void __read(void *info)
 {
 	struct perf_counter *counter = info;
+	struct perf_counter_context *ctx = counter->ctx;
 	unsigned long flags;
 
 	curr_rq_lock_irq_save(&flags);
+	if (ctx->is_active)
+		update_context_time(ctx, 1);
 	counter->hw_ops->read(counter);
+	update_counter_times(counter);
 	curr_rq_unlock_irq_restore(&flags);
 }
 
@@ -1013,6 +1106,8 @@ static u64 perf_counter_read(struct perf_counter *counter)
 	if (counter->state == PERF_COUNTER_STATE_ACTIVE) {
 		smp_call_function_single(counter->oncpu,
 					 __read, counter, 1);
+	} else if (counter->state == PERF_COUNTER_STATE_INACTIVE) {
+		update_counter_times(counter);
 	}
 
 	return atomic64_read(&counter->count);
@@ -2037,8 +2132,7 @@ inherit_counter(struct perf_counter *parent_counter,
 	 * Link it up in the child's context:
 	 */
 	child_counter->task = child;
-	list_add_counter(child_counter, child_ctx);
-	child_ctx->nr_counters++;
+	add_counter_to_ctx(child_counter, child_ctx);
 
 	child_counter->parent = parent_counter;
 	/*
