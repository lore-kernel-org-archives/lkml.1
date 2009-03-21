Return-Path: <linux-kernel-owner+w=401wt.eu-S1757930AbZCUMI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930AbZCUMI4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 08:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756862AbZCUMIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 08:08:31 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:60929 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbZCUMI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 08:08:29 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18884.55232.197620.696687@cargo.ozlabs.ibm.com>
Date: Sat, 21 Mar 2009 23:04:16 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH v2] perfcounters: record time running and time enabled for each counter
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

This also keeps separate child_time_running and child_time_enabled
fields that get added in when reporting the totals to userspace.  They
are separate fields so that they can be atomic.  We don't want to use
atomics for time_running, time_enabled etc., because then we would have
to use atomic sequences to update them, which are slower than regular
arithmetic and memory accesses.

It is possible to measure time_running by adding a task_clock counter
to each group of counters, and time_enabled can be measured approximately
with a top-level task_clock counter (though inaccuracies will creep in
if you need to disable and enable groups since it is not possible in
general to disable/enable the top-level task_clock counter simultaneously
with another group).  However, that adds extra overhead - I measured
around 15% increase in the context switch latency reported by lat_ctx
(from lmbench) when a task_clock counter was added to each of 2 groups,
and around 25% increase when a task_clock counter was added to each of
4 groups.  In contrast, the code added in this commit gives better
information with no overhead that I could measure (in fact in some cases
I measured lower times with this code, but the differences were all small).

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
This is in the rfc branch of my perfcounters.git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git rfc

 arch/powerpc/kernel/perf_counter.c |    2 +
 include/linux/perf_counter.h       |   20 +++++
 kernel/perf_counter.c              |  158 +++++++++++++++++++++++++++++++-----
 3 files changed, 159 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 6413d9c..0d59c8a 100644
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
index 98f5990..b1224f9 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -83,6 +83,16 @@ enum perf_counter_record_type {
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
@@ -234,6 +244,12 @@ struct perf_counter {
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
 
@@ -243,6 +259,8 @@ struct perf_counter {
 
 	struct perf_counter		*parent;
 	struct list_head		child_list;
+	atomic64_t			child_time_enabled;
+	atomic64_t			child_time_running;
 
 	/*
 	 * Protect attach/detach and child_list:
@@ -290,6 +308,8 @@ struct perf_counter_context {
 	int			nr_active;
 	int			is_active;
 	struct task_struct	*task;
+	u64			time_now;
+	u64			time_lost;
 #endif
 };
 
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index f054b8c..cabc820 100644
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
@@ -788,6 +865,13 @@ __perf_counter_sched_in(struct perf_counter_context *ctx,
 	if (likely(!ctx->nr_counters))
 		goto out;
 
+	/*
+	 * Add any time since the last sched_out to the lost time
+	 * so it doesn't get included in the time_enabled and
+	 * time_running measures for counters in the context.
+	 */
+	ctx->time_lost = get_context_time(ctx, 0) - ctx->time_now;
+
 	flags = hw_perf_save_disable();
 
 	/*
@@ -808,8 +892,10 @@ __perf_counter_sched_in(struct perf_counter_context *ctx,
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
@@ -893,8 +979,10 @@ int perf_counter_task_disable(void)
 	perf_flags = hw_perf_save_disable();
 
 	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
-		if (counter->state != PERF_COUNTER_STATE_ERROR)
+		if (counter->state != PERF_COUNTER_STATE_ERROR) {
+			update_group_times(counter);
 			counter->state = PERF_COUNTER_STATE_OFF;
+		}
 	}
 
 	hw_perf_restore(perf_flags);
@@ -937,6 +1025,7 @@ int perf_counter_task_enable(void)
 		if (counter->state > PERF_COUNTER_STATE_OFF)
 			continue;
 		counter->state = PERF_COUNTER_STATE_INACTIVE;
+		counter->start_enabled = ctx->time_now - counter->time_enabled;
 		counter->hw_event.disabled = 0;
 	}
 	hw_perf_restore(perf_flags);
@@ -1000,10 +1089,14 @@ void perf_counter_task_tick(struct task_struct *curr, int cpu)
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
 
@@ -1016,6 +1109,8 @@ static u64 perf_counter_read(struct perf_counter *counter)
 	if (counter->state == PERF_COUNTER_STATE_ACTIVE) {
 		smp_call_function_single(counter->oncpu,
 					 __read, counter, 1);
+	} else if (counter->state == PERF_COUNTER_STATE_INACTIVE) {
+		update_counter_times(counter);
 	}
 
 	return atomic64_read(&counter->count);
@@ -1188,10 +1283,9 @@ static int perf_release(struct inode *inode, struct file *file)
 static ssize_t
 perf_read_hw(struct perf_counter *counter, char __user *buf, size_t count)
 {
-	u64 cntval;
-
-	if (count != sizeof(cntval))
-		return -EINVAL;
+	u64 __user *uptr = (u64 __user *) buf;
+	u64 values[3];
+	int i, n = 0;
 
 	/*
 	 * Return end-of-file for a read on a counter that is in
@@ -1202,10 +1296,27 @@ perf_read_hw(struct perf_counter *counter, char __user *buf, size_t count)
 		return 0;
 
 	mutex_lock(&counter->mutex);
-	cntval = perf_counter_read(counter);
+	values[0] = perf_counter_read(counter);
+	n = 1;
+	if (counter->hw_event.read_format & PERF_FORMAT_TIME_ENABLED)
+		values[n++] = counter->time_enabled +
+			atomic64_read(&counter->child_time_enabled);
+	if (counter->hw_event.read_format & PERF_FORMAT_TIME_RUNNING)
+		values[n++] = counter->time_running +
+			atomic64_read(&counter->child_time_running);
 	mutex_unlock(&counter->mutex);
 
-	return put_user(cntval, (u64 __user *) buf) ? -EFAULT : sizeof(cntval);
+	if (count != n * sizeof(u64))
+		return -EINVAL;
+
+	if (!access_ok(VERIFY_WRITE, buf, count))
+		return -EFAULT;
+	
+	for (i = 0; i < n; ++i)
+		if (__put_user(values[i], uptr + i))
+			return -EFAULT;
+
+	return count;
 }
 
 static ssize_t
@@ -2056,8 +2167,7 @@ inherit_counter(struct perf_counter *parent_counter,
 	 * Link it up in the child's context:
 	 */
 	child_counter->task = child;
-	list_add_counter(child_counter, child_ctx);
-	child_ctx->nr_counters++;
+	add_counter_to_ctx(child_counter, child_ctx);
 
 	child_counter->parent = parent_counter;
 	/*
@@ -2127,6 +2237,10 @@ static void sync_child_counter(struct perf_counter *child_counter,
 	 * Add back the child's count to the parent's count:
 	 */
 	atomic64_add(child_val, &parent_counter->count);
+	atomic64_add(child_counter->time_enabled,
+		     &parent_counter->child_time_enabled);
+	atomic64_add(child_counter->time_running,
+		     &parent_counter->child_time_running);
 
 	/*
 	 * Remove this counter from the parent's list
@@ -2161,6 +2275,7 @@ __perf_counter_exit_task(struct task_struct *child,
 	if (child != current) {
 		wait_task_inactive(child, 0);
 		list_del_init(&child_counter->list_entry);
+		update_counter_times(child_counter);
 	} else {
 		struct perf_cpu_context *cpuctx;
 		unsigned long flags;
@@ -2178,6 +2293,7 @@ __perf_counter_exit_task(struct task_struct *child,
 		cpuctx = &__get_cpu_var(perf_cpu_context);
 
 		group_sched_out(child_counter, cpuctx, child_ctx);
+		update_counter_times(child_counter);
 
 		list_del_init(&child_counter->list_entry);
 
-- 
1.5.6.3

