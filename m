Return-Path: <linux-kernel-owner+w=401wt.eu-S1761357AbZCYM3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761357AbZCYM3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756719AbZCYM3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:29:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:60337 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220AbZCYM3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:29:08 -0400
Date: Wed, 25 Mar 2009 12:27:28 GMT
From: Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, akpm@linux-foundation.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <18890.6578.728637.139402@cargo.ozlabs.ibm.com>
References: <18890.6578.728637.139402@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: record time running and time enabled for each counter
Message-ID: <tip-03ced439c94d692363307eeb3abe0bbfa2d08a01@git.kernel.org>
Git-Commit-ID: 03ced439c94d692363307eeb3abe0bbfa2d08a01
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 12:27:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  03ced439c94d692363307eeb3abe0bbfa2d08a01
Gitweb:     http://git.kernel.org/tip/03ced439c94d692363307eeb3abe0bbfa2d08a01
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Wed, 25 Mar 2009 22:46:58 +1100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Mar 2009 13:24:00 +0100

perf_counter: record time running and time enabled for each counter

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
setting the PERF_FORMAT_TOTAL_TIME_ENABLED and/or
PERF_FORMAT_TOTAL_TIME_RUNNING bits in the hw_event.read_format field
when creating the counter.  (There is no way to change the read format
after the counter is created, though it would be possible to add some
way to do that.)

Using this information it is possible for userspace to scale the count
it reads from the counter to get an estimate of the true count:

true_count_estimate = count * total_time_enabled / total_time_running

This also lets userspace detect the situation where the counter never
got to go on the cpu: total_time_running == 0.

This functionality has been requested by the PAPI developers, and will
be generally needed for interpreting the count values from counting
counters correctly.

In the implementation, this keeps 5 time values (in nanoseconds) for
each counter: total_time_enabled and total_time_running are used when
the counter is in state OFF or ERROR and for reporting back to
userspace.  When the counter is in state INACTIVE or ACTIVE, it is the
tstamp_enabled, tstamp_running and tstamp_stopped values that are
relevant, and total_time_enabled and total_time_running are determined
from them.  (tstamp_stopped is only used in INACTIVE state.)  The
reason for doing it like this is that it means that only counters
being enabled or disabled at sched-in and sched-out time need to be
updated.  There are no new loops that iterate over all counters to
update total_time_enabled or total_time_running.

This also keeps separate child_total_time_running and
child_total_time_enabled fields that get added in when reporting the
totals to userspace.  They are separate fields so that they can be
atomic.  We don't want to use atomics for total_time_running,
total_time_enabled etc., because then we would have to use atomic
sequences to update them, which are slower than regular arithmetic and
memory accesses.

It is possible to measure total_time_running by adding a task_clock
counter to each group of counters, and total_time_enabled can be
measured approximately with a top-level task_clock counter (though
inaccuracies will creep in if you need to disable and enable groups
since it is not possible in general to disable/enable the top-level
task_clock counter simultaneously with another group).  However, that
adds extra overhead - I measured around 15% increase in the context
switch latency reported by lat_ctx (from lmbench) when a task_clock
counter was added to each of 2 groups, and around 25% increase when a
task_clock counter was added to each of 4 groups.  (In both cases a
top-level task-clock counter was also added.)

In contrast, the code added in this commit gives better information
with no overhead that I could measure (in fact in some cases I
measured lower times with this code, but the differences were all less
than one standard deviation).

[ v2: address review comments by Andrew Morton. ]

Signed-off-by: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <18890.6578.728637.139402@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/kernel/perf_counter.c |    2 +
 include/linux/perf_counter.h       |   53 ++++++++++++
 kernel/perf_counter.c              |  157 +++++++++++++++++++++++++++++++-----
 3 files changed, 191 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index d48596a..df007fe 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -455,6 +455,8 @@ static void counter_sched_in(struct perf_counter *counter, int cpu)
 {
 	counter->state = PERF_COUNTER_STATE_ACTIVE;
 	counter->oncpu = cpu;
+	counter->tstamp_running += counter->ctx->time_now -
+		counter->tstamp_stopped;
 	if (is_software_counter(counter))
 		counter->hw_ops->enable(counter);
 }
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 7fdbdf8..6bf67ce 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -103,6 +103,16 @@ enum perf_counter_record_type {
 #define PERF_COUNTER_EVENT_MASK		__PERF_COUNTER_MASK(EVENT)
 
 /*
+ * Bits that can be set in hw_event.read_format to request that
+ * reads on the counter should return the indicated quantities,
+ * in increasing order of bit value, after the counter value.
+ */
+enum perf_counter_read_format {
+	PERF_FORMAT_TOTAL_TIME_ENABLED	=  1,
+	PERF_FORMAT_TOTAL_TIME_RUNNING	=  2,
+};
+
+/*
  * Hardware event to monitor via a performance monitoring counter:
  */
 struct perf_counter_hw_event {
@@ -281,6 +291,32 @@ struct perf_counter {
 	enum perf_counter_active_state	prev_state;
 	atomic64_t			count;
 
+	/*
+	 * These are the total time in nanoseconds that the counter
+	 * has been enabled (i.e. eligible to run, and the task has
+	 * been scheduled in, if this is a per-task counter)
+	 * and running (scheduled onto the CPU), respectively.
+	 *
+	 * They are computed from tstamp_enabled, tstamp_running and
+	 * tstamp_stopped when the counter is in INACTIVE or ACTIVE state.
+	 */
+	u64				total_time_enabled;
+	u64				total_time_running;
+
+	/*
+	 * These are timestamps used for computing total_time_enabled
+	 * and total_time_running when the counter is in INACTIVE or
+	 * ACTIVE state, measured in nanoseconds from an arbitrary point
+	 * in time.
+	 * tstamp_enabled: the notional time when the counter was enabled
+	 * tstamp_running: the notional time when the counter was scheduled on
+	 * tstamp_stopped: in INACTIVE state, the notional time when the
+	 *	counter was scheduled off.
+	 */
+	u64				tstamp_enabled;
+	u64				tstamp_running;
+	u64				tstamp_stopped;
+
 	struct perf_counter_hw_event	hw_event;
 	struct hw_perf_counter		hw;
 
@@ -292,6 +328,13 @@ struct perf_counter {
 	struct list_head		child_list;
 
 	/*
+	 * These accumulate total time (in nanoseconds) that children
+	 * counters have been enabled and running, respectively.
+	 */
+	atomic64_t			child_total_time_enabled;
+	atomic64_t			child_total_time_running;
+
+	/*
 	 * Protect attach/detach and child_list:
 	 */
 	struct mutex			mutex;
@@ -339,6 +382,16 @@ struct perf_counter_context {
 	int			nr_active;
 	int			is_active;
 	struct task_struct	*task;
+
+	/*
+	 * time_now is the current time in nanoseconds since an arbitrary
+	 * point in the past.  For per-task counters, this is based on the
+	 * task clock, and for per-cpu counters it is based on the cpu clock.
+	 * time_lost is an offset from the task/cpu clock, used to make it
+	 * appear that time only passes while the context is scheduled in.
+	 */
+	u64			time_now;
+	u64			time_lost;
 #endif
 };
 
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 95e0257..3b862a7 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -116,6 +116,7 @@ counter_sched_out(struct perf_counter *counter,
 		return;
 
 	counter->state = PERF_COUNTER_STATE_INACTIVE;
+	counter->tstamp_stopped = ctx->time_now;
 	counter->hw_ops->disable(counter);
 	counter->oncpu = -1;
 
@@ -252,6 +253,60 @@ retry:
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
+ * Update the total_time_enabled and total_time_running fields for a counter.
+ */
+static void update_counter_times(struct perf_counter *counter)
+{
+	struct perf_counter_context *ctx = counter->ctx;
+	u64 run_end;
+
+	if (counter->state >= PERF_COUNTER_STATE_INACTIVE) {
+		counter->total_time_enabled = ctx->time_now -
+			counter->tstamp_enabled;
+		if (counter->state == PERF_COUNTER_STATE_INACTIVE)
+			run_end = counter->tstamp_stopped;
+		else
+			run_end = ctx->time_now;
+		counter->total_time_running = run_end - counter->tstamp_running;
+	}
+}
+
+/*
+ * Update total_time_enabled and total_time_running for all counters in a group.
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
@@ -276,6 +331,8 @@ static void __perf_counter_disable(void *info)
 	 * If it is in error state, leave it in error state.
 	 */
 	if (counter->state >= PERF_COUNTER_STATE_INACTIVE) {
+		update_context_time(ctx, 1);
+		update_counter_times(counter);
 		if (counter == counter->group_leader)
 			group_sched_out(counter, cpuctx, ctx);
 		else
@@ -320,8 +377,10 @@ static void perf_counter_disable(struct perf_counter *counter)
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
@@ -366,6 +425,8 @@ counter_sched_in(struct perf_counter *counter,
 		return -EAGAIN;
 	}
 
+	counter->tstamp_running += ctx->time_now - counter->tstamp_stopped;
+
 	if (!is_software_counter(counter))
 		cpuctx->active_oncpu++;
 	ctx->nr_active++;
@@ -425,6 +486,17 @@ static int group_can_go_on(struct perf_counter *counter,
 	return can_add_hw;
 }
 
+static void add_counter_to_ctx(struct perf_counter *counter,
+			       struct perf_counter_context *ctx)
+{
+	list_add_counter(counter, ctx);
+	ctx->nr_counters++;
+	counter->prev_state = PERF_COUNTER_STATE_OFF;
+	counter->tstamp_enabled = ctx->time_now;
+	counter->tstamp_running = ctx->time_now;
+	counter->tstamp_stopped = ctx->time_now;
+}
+
 /*
  * Cross CPU call to install and enable a performance counter
  */
@@ -449,6 +521,7 @@ static void __perf_install_in_context(void *info)
 
 	curr_rq_lock_irq_save(&flags);
 	spin_lock(&ctx->lock);
+	update_context_time(ctx, 1);
 
 	/*
 	 * Protect the list operation against NMI by disabling the
@@ -456,9 +529,7 @@ static void __perf_install_in_context(void *info)
 	 */
 	perf_flags = hw_perf_save_disable();
 
-	list_add_counter(counter, ctx);
-	ctx->nr_counters++;
-	counter->prev_state = PERF_COUNTER_STATE_OFF;
+	add_counter_to_ctx(counter, ctx);
 
 	/*
 	 * Don't put the counter on if it is disabled or if
@@ -486,8 +557,10 @@ static void __perf_install_in_context(void *info)
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
@@ -548,10 +621,8 @@ retry:
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
 
@@ -576,11 +647,13 @@ static void __perf_counter_enable(void *info)
 
 	curr_rq_lock_irq_save(&flags);
 	spin_lock(&ctx->lock);
+	update_context_time(ctx, 1);
 
 	counter->prev_state = counter->state;
 	if (counter->state >= PERF_COUNTER_STATE_INACTIVE)
 		goto unlock;
 	counter->state = PERF_COUNTER_STATE_INACTIVE;
+	counter->tstamp_enabled = ctx->time_now - counter->total_time_enabled;
 
 	/*
 	 * If the counter is in a group and isn't the group leader,
@@ -602,8 +675,10 @@ static void __perf_counter_enable(void *info)
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
@@ -659,8 +734,11 @@ static void perf_counter_enable(struct perf_counter *counter)
 	 * Since we have the lock this context can't be scheduled
 	 * in, so we can change the state safely.
 	 */
-	if (counter->state == PERF_COUNTER_STATE_OFF)
+	if (counter->state == PERF_COUNTER_STATE_OFF) {
 		counter->state = PERF_COUNTER_STATE_INACTIVE;
+		counter->tstamp_enabled = ctx->time_now -
+			counter->total_time_enabled;
+	}
  out:
 	spin_unlock_irq(&ctx->lock);
 }
@@ -693,6 +771,7 @@ void __perf_counter_sched_out(struct perf_counter_context *ctx,
 	ctx->is_active = 0;
 	if (likely(!ctx->nr_counters))
 		goto out;
+	update_context_time(ctx, 0);
 
 	flags = hw_perf_save_disable();
 	if (ctx->nr_active) {
@@ -797,6 +876,13 @@ __perf_counter_sched_in(struct perf_counter_context *ctx,
 	if (likely(!ctx->nr_counters))
 		goto out;
 
+	/*
+	 * Add any time since the last sched_out to the lost time
+	 * so it doesn't get included in the total_time_enabled and
+	 * total_time_running measures for counters in the context.
+	 */
+	ctx->time_lost = get_context_time(ctx, 0) - ctx->time_now;
+
 	flags = hw_perf_save_disable();
 
 	/*
@@ -817,8 +903,10 @@ __perf_counter_sched_in(struct perf_counter_context *ctx,
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
@@ -902,8 +990,10 @@ int perf_counter_task_disable(void)
 	perf_flags = hw_perf_save_disable();
 
 	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
-		if (counter->state != PERF_COUNTER_STATE_ERROR)
+		if (counter->state != PERF_COUNTER_STATE_ERROR) {
+			update_group_times(counter);
 			counter->state = PERF_COUNTER_STATE_OFF;
+		}
 	}
 
 	hw_perf_restore(perf_flags);
@@ -946,6 +1036,8 @@ int perf_counter_task_enable(void)
 		if (counter->state > PERF_COUNTER_STATE_OFF)
 			continue;
 		counter->state = PERF_COUNTER_STATE_INACTIVE;
+		counter->tstamp_enabled = ctx->time_now -
+			counter->total_time_enabled;
 		counter->hw_event.disabled = 0;
 	}
 	hw_perf_restore(perf_flags);
@@ -1009,10 +1101,14 @@ void perf_counter_task_tick(struct task_struct *curr, int cpu)
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
 
@@ -1025,6 +1121,8 @@ static u64 perf_counter_read(struct perf_counter *counter)
 	if (counter->state == PERF_COUNTER_STATE_ACTIVE) {
 		smp_call_function_single(counter->oncpu,
 					 __read, counter, 1);
+	} else if (counter->state == PERF_COUNTER_STATE_INACTIVE) {
+		update_counter_times(counter);
 	}
 
 	return atomic64_read(&counter->count);
@@ -1137,10 +1235,8 @@ static int perf_release(struct inode *inode, struct file *file)
 static ssize_t
 perf_read_hw(struct perf_counter *counter, char __user *buf, size_t count)
 {
-	u64 cntval;
-
-	if (count < sizeof(cntval))
-		return -EINVAL;
+	u64 values[3];
+	int n;
 
 	/*
 	 * Return end-of-file for a read on a counter that is in
@@ -1151,10 +1247,24 @@ perf_read_hw(struct perf_counter *counter, char __user *buf, size_t count)
 		return 0;
 
 	mutex_lock(&counter->mutex);
-	cntval = perf_counter_read(counter);
+	values[0] = perf_counter_read(counter);
+	n = 1;
+	if (counter->hw_event.read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
+		values[n++] = counter->total_time_enabled +
+			atomic64_read(&counter->child_total_time_enabled);
+	if (counter->hw_event.read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
+		values[n++] = counter->total_time_running +
+			atomic64_read(&counter->child_total_time_running);
 	mutex_unlock(&counter->mutex);
 
-	return put_user(cntval, (u64 __user *) buf) ? -EFAULT : sizeof(cntval);
+	if (count < n * sizeof(u64))
+		return -EINVAL;
+	count = n * sizeof(u64);
+
+	if (copy_to_user(buf, values, count))
+		return -EFAULT;
+
+	return count;
 }
 
 static ssize_t
@@ -2290,8 +2400,7 @@ inherit_counter(struct perf_counter *parent_counter,
 	 * Link it up in the child's context:
 	 */
 	child_counter->task = child;
-	list_add_counter(child_counter, child_ctx);
-	child_ctx->nr_counters++;
+	add_counter_to_ctx(child_counter, child_ctx);
 
 	child_counter->parent = parent_counter;
 	/*
@@ -2361,6 +2470,10 @@ static void sync_child_counter(struct perf_counter *child_counter,
 	 * Add back the child's count to the parent's count:
 	 */
 	atomic64_add(child_val, &parent_counter->count);
+	atomic64_add(child_counter->total_time_enabled,
+		     &parent_counter->child_total_time_enabled);
+	atomic64_add(child_counter->total_time_running,
+		     &parent_counter->child_total_time_running);
 
 	/*
 	 * Remove this counter from the parent's list
@@ -2395,6 +2508,7 @@ __perf_counter_exit_task(struct task_struct *child,
 	if (child != current) {
 		wait_task_inactive(child, 0);
 		list_del_init(&child_counter->list_entry);
+		update_counter_times(child_counter);
 	} else {
 		struct perf_cpu_context *cpuctx;
 		unsigned long flags;
@@ -2412,6 +2526,7 @@ __perf_counter_exit_task(struct task_struct *child,
 		cpuctx = &__get_cpu_var(perf_cpu_context);
 
 		group_sched_out(child_counter, cpuctx, child_ctx);
+		update_counter_times(child_counter);
 
 		list_del_init(&child_counter->list_entry);
 
