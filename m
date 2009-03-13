Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbZCMCAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbZCMCAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbZCMCAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:00:09 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:43658 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbZCMCAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:00:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18873.48668.562126.113618@cargo.ozlabs.ibm.com>
Date: Fri, 13 Mar 2009 12:59:56 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] perfcounters: Make s/w counters in a group only count when group is on
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: bug fix

If one has a group that has one or more hardware counters in it and also
a software counter, the software counter should count only when the
hardware counters are on the PMU.  At present, the software counters
count all the time, even when the hardware counters can't go on the PMU.

Fundamentally, the problem is that currently we are using sched-out for
two distinct things: one is "take the counters off because this task
is being taken off the CPU" and the other is "take the counters off
because this group can't go on, or because we're changing things around".
In the first case we need the software counters to keep counting, and in
the second case we need them to stop, but currently we use sched_out
functions for both.

To make things clearer, this uses "sched_out" for the first case and
"inactivate" for the second case.  So, adds counter_inactivate,
group_inactivate and perf_counter_inactivate_ctx functions, which
differ from the corresponding *_sched_out functions in that they always
disable all the counters and put them into the inactive state.

The *_sched_out functions now are only used for the situation where a
task is being taken off the CPU.  If a counter has a sched_out function
in its hw_ops structure, counter_sched_out will now call that and leave
the counter in the active state (if it doesn't, it will call the
counter's disable function and put it in the inactive state as before).
Then, when the task gets scheduled in again, counter_sched_in will see
that the counter is active and call the counter's sched_in function
(if it has one) instead of the counter's enable function.

This means that we can add sched_out functions for the software counters
which just do a counter update.  The enable functions no longer need
to check counter->prev_state, and in fact the prev_state field gets
removed.  Because the software counters work off per-task variables,
they don't need sched_in functions.

This adds a perf_counter_activate_ctx function for symmetry with
perf_counter_inactivate_ctx.  It just calls __perf_counter_sched_in.

This also adds calls to group_inactivate in various places to make sure
that a group gets inactivated if it can't go on the PMU.  In future it
would be useful to have an indication on the group leader as to whether
there are any active counters in the group (the leader could be an
inactive hardware counter but there could now be an active software
counter in the group).

A corollary of all this is that it is now possible to have counters
in active state when their context is inactive.  Therefore this adds
checks to perf_counter_read and __read that the context is active
before calling the counter's read function.

It would have been possible to combine counter_inactive with
counter_sched_out, group_inactivate with group_sched_out, etc., by
passing down a 'disable_all' parameter.  I made them separate functions
because it seemed clearer in the callers and because this will make
it easier to implement lazy PMU context-switching and caching of the
PMU scheduling decisions in future.

This also fixes a bug where enabling a group would only put the group
leader on the PMU, not the other group members, because
__perf_counter_enable was calling counter_sched_in rather than
group_sched_in.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
This is in the master branch of my perfcounters.git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git master

Ingo, please pull if it looks OK.  Peter, I realize this will conflict
with your generic software counter patches, but I think it's important
that this bug gets fixed.

 arch/powerpc/kernel/perf_counter.c |    8 +-
 include/linux/perf_counter.h       |    2 +
 kernel/perf_counter.c              |  216 +++++++++++++++++++++++-------------
 3 files changed, 145 insertions(+), 81 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 0e33d27..5c72528 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -452,10 +452,12 @@ static int collect_events(struct perf_counter *group, int max_count,
 
 static void counter_sched_in(struct perf_counter *counter, int cpu)
 {
-	counter->state = PERF_COUNTER_STATE_ACTIVE;
 	counter->oncpu = cpu;
-	if (is_software_counter(counter))
-		counter->hw_ops->enable(counter);
+	if (counter->state == PERF_COUNTER_STATE_INACTIVE) {
+		counter->state = PERF_COUNTER_STATE_ACTIVE;
+		if (is_software_counter(counter))
+			counter->hw_ops->enable(counter);
+	}
 }
 
 /*
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index dde5645..eba40c1 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -155,6 +155,8 @@ struct perf_counter;
 struct hw_perf_counter_ops {
 	int (*enable)			(struct perf_counter *counter);
 	void (*disable)			(struct perf_counter *counter);
+	int (*sched_in)			(struct perf_counter *counter);
+	void (*sched_out)		(struct perf_counter *counter);
 	void (*read)			(struct perf_counter *counter);
 };
 
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index b2e8389..cc0c32a 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -58,6 +58,11 @@ int __weak hw_perf_group_sched_in(struct perf_counter *group_leader,
 
 void __weak perf_counter_print_debug(void)	{ }
 
+static int group_sched_in(struct perf_counter *group_counter,
+			  struct perf_cpu_context *cpuctx,
+			  struct perf_counter_context *ctx,
+			  int cpu);
+
 static void
 list_add_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
 {
@@ -95,10 +100,9 @@ list_del_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
 	}
 }
 
-static void
-counter_sched_out(struct perf_counter *counter,
-		  struct perf_cpu_context *cpuctx,
-		  struct perf_counter_context *ctx)
+static void counter_inactivate(struct perf_counter *counter,
+			       struct perf_cpu_context *cpuctx,
+			       struct perf_counter_context *ctx)
 {
 	if (counter->state != PERF_COUNTER_STATE_ACTIVE)
 		return;
@@ -114,6 +118,43 @@ counter_sched_out(struct perf_counter *counter,
 		cpuctx->exclusive = 0;
 }
 
+static void group_inactivate(struct perf_counter *group_counter,
+			     struct perf_cpu_context *cpuctx,
+			     struct perf_counter_context *ctx)
+{
+	struct perf_counter *counter;
+
+	counter_inactivate(group_counter, cpuctx, ctx);
+
+	/*
+	 * Inactivate siblings (if any):
+	 */
+	list_for_each_entry(counter, &group_counter->sibling_list, list_entry)
+		counter_inactivate(counter, cpuctx, ctx);
+}
+
+static void counter_sched_out(struct perf_counter *counter,
+			      struct perf_cpu_context *cpuctx,
+			      struct perf_counter_context *ctx)
+{
+	if (counter->state != PERF_COUNTER_STATE_ACTIVE)
+		return;
+
+	if (counter->hw_ops->sched_out) {
+		counter->hw_ops->sched_out(counter);
+	} else {
+		counter->state = PERF_COUNTER_STATE_INACTIVE;
+		counter->hw_ops->disable(counter);
+		counter->oncpu = -1;
+	}
+
+	if (!is_software_counter(counter))
+		cpuctx->active_oncpu--;
+	ctx->nr_active--;
+	if (counter->hw_event.exclusive || !cpuctx->active_oncpu)
+		cpuctx->exclusive = 0;
+}
+
 static void
 group_sched_out(struct perf_counter *group_counter,
 		struct perf_cpu_context *cpuctx,
@@ -161,7 +202,7 @@ static void __perf_counter_remove_from_context(void *info)
 	curr_rq_lock_irq_save(&flags);
 	spin_lock(&ctx->lock);
 
-	counter_sched_out(counter, cpuctx, ctx);
+	counter_inactivate(counter, cpuctx, ctx);
 
 	counter->task = NULL;
 	ctx->nr_counters--;
@@ -265,9 +306,9 @@ static void __perf_counter_disable(void *info)
 	 */
 	if (counter->state >= PERF_COUNTER_STATE_INACTIVE) {
 		if (counter == counter->group_leader)
-			group_sched_out(counter, cpuctx, ctx);
+			group_inactivate(counter, cpuctx, ctx);
 		else
-			counter_sched_out(counter, cpuctx, ctx);
+			counter_inactivate(counter, cpuctx, ctx);
 		counter->state = PERF_COUNTER_STATE_OFF;
 	}
 
@@ -338,11 +379,16 @@ counter_sched_in(struct perf_counter *counter,
 		 struct perf_counter_context *ctx,
 		 int cpu)
 {
-	if (counter->state <= PERF_COUNTER_STATE_OFF)
+	if (counter->state != PERF_COUNTER_STATE_INACTIVE) {
+		if (counter->state == PERF_COUNTER_STATE_ACTIVE &&
+		    counter->hw_ops->sched_in)
+			counter->hw_ops->sched_in(counter);
 		return 0;
+	}
 
 	counter->state = PERF_COUNTER_STATE_ACTIVE;
 	counter->oncpu = cpu;	/* TODO: put 'cpu' into cpuctx->cpu */
+
 	/*
 	 * The new state must be visible before we turn it on in the hardware:
 	 */
@@ -444,7 +490,6 @@ static void __perf_install_in_context(void *info)
 
 	list_add_counter(counter, ctx);
 	ctx->nr_counters++;
-	counter->prev_state = PERF_COUNTER_STATE_OFF;
 
 	/*
 	 * Don't put the counter on if it is disabled or if
@@ -455,14 +500,15 @@ static void __perf_install_in_context(void *info)
 		goto unlock;
 
 	/*
-	 * An exclusive counter can't go on if there are already active
+	 * An exclusive group can't go on if there are already active
 	 * hardware counters, and no hardware counter can go on if there
 	 * is already an exclusive counter on.
 	 */
-	if (!group_can_go_on(counter, cpuctx, 1))
-		err = -EEXIST;
-	else
+	err = -EEXIST;
+	if (leader != counter)
 		err = counter_sched_in(counter, cpuctx, ctx, cpu);
+	else if (group_can_go_on(counter, cpuctx, 1))
+		err = group_sched_in(counter, cpuctx, ctx, cpu);
 
 	if (err) {
 		/*
@@ -471,7 +517,7 @@ static void __perf_install_in_context(void *info)
 		 * If the counter group is pinned then put it in error state.
 		 */
 		if (leader != counter)
-			group_sched_out(leader, cpuctx, ctx);
+			group_inactivate(leader, cpuctx, ctx);
 		if (leader->hw_event.pinned)
 			leader->state = PERF_COUNTER_STATE_ERROR;
 	}
@@ -552,6 +598,7 @@ static void __perf_counter_enable(void *info)
 	struct perf_counter *leader = counter->group_leader;
 	unsigned long flags;
 	int err;
+	int cpu = smp_processor_id();
 
 	/*
 	 * If this is a per-task counter, need to check whether this
@@ -563,7 +610,6 @@ static void __perf_counter_enable(void *info)
 	curr_rq_lock_irq_save(&flags);
 	spin_lock(&ctx->lock);
 
-	counter->prev_state = counter->state;
 	if (counter->state >= PERF_COUNTER_STATE_INACTIVE)
 		goto unlock;
 	counter->state = PERF_COUNTER_STATE_INACTIVE;
@@ -575,11 +621,11 @@ static void __perf_counter_enable(void *info)
 	if (leader != counter && leader->state != PERF_COUNTER_STATE_ACTIVE)
 		goto unlock;
 
-	if (!group_can_go_on(counter, cpuctx, 1))
-		err = -EEXIST;
-	else
-		err = counter_sched_in(counter, cpuctx, ctx,
-				       smp_processor_id());
+	err = -EEXIST;
+	if (leader != counter)
+		err = counter_sched_in(counter, cpuctx, ctx, cpu);
+	else if (group_can_go_on(counter, cpuctx, 1))
+		err = group_sched_in(counter, cpuctx, ctx, cpu);
 
 	if (err) {
 		/*
@@ -587,7 +633,7 @@ static void __perf_counter_enable(void *info)
 		 * group, then the whole group has to come off.
 		 */
 		if (leader != counter)
-			group_sched_out(leader, cpuctx, ctx);
+			group_inactivate(leader, cpuctx, ctx);
 		if (leader->hw_event.pinned)
 			leader->state = PERF_COUNTER_STATE_ERROR;
 	}
@@ -669,8 +715,24 @@ static void perf_counter_enable_family(struct perf_counter *counter)
 	mutex_unlock(&counter->mutex);
 }
 
-void __perf_counter_sched_out(struct perf_counter_context *ctx,
-			      struct perf_cpu_context *cpuctx)
+static void perf_counter_inactivate_ctx(struct perf_counter_context *ctx,
+					struct perf_cpu_context *cpuctx)
+{
+	struct perf_counter *counter;
+	u64 flags;
+
+	spin_lock(&ctx->lock);
+	flags = hw_perf_save_disable();
+	if (ctx->nr_active) {
+		list_for_each_entry(counter, &ctx->counter_list, list_entry)
+			group_inactivate(counter, cpuctx, ctx);
+	}
+	hw_perf_restore(flags);
+	spin_unlock(&ctx->lock);
+}
+
+static void __perf_counter_sched_out(struct perf_counter_context *ctx,
+				     struct perf_cpu_context *cpuctx)
 {
 	struct perf_counter *counter;
 	u64 flags;
@@ -714,40 +776,33 @@ void perf_counter_task_sched_out(struct task_struct *task, int cpu)
 	cpuctx->task_ctx = NULL;
 }
 
-static void perf_counter_cpu_sched_out(struct perf_cpu_context *cpuctx)
-{
-	__perf_counter_sched_out(&cpuctx->ctx, cpuctx);
-}
-
 static int
 group_sched_in(struct perf_counter *group_counter,
 	       struct perf_cpu_context *cpuctx,
 	       struct perf_counter_context *ctx,
 	       int cpu)
 {
-	struct perf_counter *counter, *partial_group;
+	struct perf_counter *counter;
 	int ret;
 
 	if (group_counter->state == PERF_COUNTER_STATE_OFF)
 		return 0;
 
 	ret = hw_perf_group_sched_in(group_counter, cpuctx, ctx, cpu);
-	if (ret)
-		return ret < 0 ? ret : 0;
+	if (ret > 0)
+		return 0;
+	if (ret < 0)
+		goto group_error;
 
-	group_counter->prev_state = group_counter->state;
 	if (counter_sched_in(group_counter, cpuctx, ctx, cpu))
-		return -EAGAIN;
+		goto group_error;
 
 	/*
 	 * Schedule in siblings as one group (if any):
 	 */
 	list_for_each_entry(counter, &group_counter->sibling_list, list_entry) {
-		counter->prev_state = counter->state;
-		if (counter_sched_in(counter, cpuctx, ctx, cpu)) {
-			partial_group = counter;
+		if (counter_sched_in(counter, cpuctx, ctx, cpu))
 			goto group_error;
-		}
 	}
 
 	return 0;
@@ -757,19 +812,13 @@ group_error:
 	 * Groups can be scheduled in as one unit only, so undo any
 	 * partial group before returning:
 	 */
-	list_for_each_entry(counter, &group_counter->sibling_list, list_entry) {
-		if (counter == partial_group)
-			break;
-		counter_sched_out(counter, cpuctx, ctx);
-	}
-	counter_sched_out(group_counter, cpuctx, ctx);
+	group_inactivate(group_counter, cpuctx, ctx);
 
 	return -EAGAIN;
 }
 
-static void
-__perf_counter_sched_in(struct perf_counter_context *ctx,
-			struct perf_cpu_context *cpuctx, int cpu)
+static void __perf_counter_sched_in(struct perf_counter_context *ctx,
+				    struct perf_cpu_context *cpuctx, int cpu)
 {
 	struct perf_counter *counter;
 	u64 flags;
@@ -800,8 +849,10 @@ __perf_counter_sched_in(struct perf_counter_context *ctx,
 		 * If this pinned group hasn't been scheduled,
 		 * put it in error state.
 		 */
-		if (counter->state == PERF_COUNTER_STATE_INACTIVE)
+		if (counter->state == PERF_COUNTER_STATE_INACTIVE) {
+			group_inactivate(counter, cpuctx, ctx);
 			counter->state = PERF_COUNTER_STATE_ERROR;
+		}
 	}
 
 	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
@@ -823,6 +874,8 @@ __perf_counter_sched_in(struct perf_counter_context *ctx,
 		if (group_can_go_on(counter, cpuctx, can_add_hw)) {
 			if (group_sched_in(counter, cpuctx, ctx, cpu))
 				can_add_hw = 0;
+		} else {
+			group_inactivate(counter, cpuctx, ctx);
 		}
 	}
 	hw_perf_restore(flags);
@@ -830,6 +883,12 @@ __perf_counter_sched_in(struct perf_counter_context *ctx,
 	spin_unlock(&ctx->lock);
 }
 
+static void perf_counter_activate_ctx(struct perf_counter_context *ctx,
+				      struct perf_cpu_context *cpuctx, int cpu)
+{
+	__perf_counter_sched_in(ctx, cpuctx, cpu);
+}
+
 /*
  * Called from scheduler to add the counters of the current task
  * with interrupts disabled.
@@ -850,32 +909,25 @@ void perf_counter_task_sched_in(struct task_struct *task, int cpu)
 	cpuctx->task_ctx = ctx;
 }
 
-static void perf_counter_cpu_sched_in(struct perf_cpu_context *cpuctx, int cpu)
-{
-	struct perf_counter_context *ctx = &cpuctx->ctx;
-
-	__perf_counter_sched_in(ctx, cpuctx, cpu);
-}
-
 int perf_counter_task_disable(void)
 {
 	struct task_struct *curr = current;
 	struct perf_counter_context *ctx = &curr->perf_counter_ctx;
+	struct perf_cpu_context *cpuctx;
 	struct perf_counter *counter;
 	unsigned long flags;
 	u64 perf_flags;
-	int cpu;
 
 	if (likely(!ctx->nr_counters))
 		return 0;
 
 	curr_rq_lock_irq_save(&flags);
-	cpu = smp_processor_id();
 
 	/* force the update of the task clock: */
 	__task_delta_exec(curr, 1);
 
-	perf_counter_task_sched_out(curr, cpu);
+	cpuctx = &__get_cpu_var(perf_cpu_context);
+	perf_counter_inactivate_ctx(ctx, cpuctx);
 
 	spin_lock(&ctx->lock);
 
@@ -902,6 +954,7 @@ int perf_counter_task_enable(void)
 {
 	struct task_struct *curr = current;
 	struct perf_counter_context *ctx = &curr->perf_counter_ctx;
+	struct perf_cpu_context *cpuctx;
 	struct perf_counter *counter;
 	unsigned long flags;
 	u64 perf_flags;
@@ -916,12 +969,13 @@ int perf_counter_task_enable(void)
 	/* force the update of the task clock: */
 	__task_delta_exec(curr, 1);
 
-	perf_counter_task_sched_out(curr, cpu);
+	cpuctx = &__get_cpu_var(perf_cpu_context);
+	perf_counter_inactivate_ctx(ctx, cpuctx);
 
 	spin_lock(&ctx->lock);
 
 	/*
-	 * Disable all the counters:
+	 * Enable all the counters:
 	 */
 	perf_flags = hw_perf_save_disable();
 
@@ -935,7 +989,7 @@ int perf_counter_task_enable(void)
 
 	spin_unlock(&ctx->lock);
 
-	perf_counter_task_sched_in(curr, cpu);
+	perf_counter_activate_ctx(ctx, cpuctx, cpu);
 
 	curr_rq_unlock_irq_restore(&flags);
 
@@ -975,16 +1029,17 @@ void perf_counter_task_tick(struct task_struct *curr, int cpu)
 	const int rotate_percpu = 0;
 
 	if (rotate_percpu)
-		perf_counter_cpu_sched_out(cpuctx);
-	perf_counter_task_sched_out(curr, cpu);
+		perf_counter_inactivate_ctx(&cpuctx->ctx, cpuctx);
+	if (ctx->nr_counters)
+		perf_counter_inactivate_ctx(ctx, cpuctx);
 
 	if (rotate_percpu)
 		rotate_ctx(&cpuctx->ctx);
 	rotate_ctx(ctx);
 
 	if (rotate_percpu)
-		perf_counter_cpu_sched_in(cpuctx, cpu);
-	perf_counter_task_sched_in(curr, cpu);
+		perf_counter_activate_ctx(&cpuctx->ctx, cpuctx, cpu);
+	perf_counter_activate_ctx(ctx, cpuctx, cpu);
 }
 
 /*
@@ -993,10 +1048,16 @@ void perf_counter_task_tick(struct task_struct *curr, int cpu)
 static void __read(void *info)
 {
 	struct perf_counter *counter = info;
+	struct perf_counter_context *ctx = counter->ctx;
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	unsigned long flags;
 
 	curr_rq_lock_irq_save(&flags);
-	counter->hw_ops->read(counter);
+	spin_lock(&ctx->lock);
+	if (counter->state == PERF_COUNTER_STATE_ACTIVE && ctx->is_active &&
+	    (!ctx->task || ctx == cpuctx->task_ctx))
+		counter->hw_ops->read(counter);
+	spin_unlock(&ctx->lock);
 	curr_rq_unlock_irq_restore(&flags);
 }
 
@@ -1006,7 +1067,8 @@ static u64 perf_counter_read(struct perf_counter *counter)
 	 * If counter is enabled and currently active on a CPU, update the
 	 * value in the counter structure:
 	 */
-	if (counter->state == PERF_COUNTER_STATE_ACTIVE) {
+	if (counter->state == PERF_COUNTER_STATE_ACTIVE &&
+	    counter->ctx->is_active) {
 		smp_call_function_single(counter->oncpu,
 					 __read, counter, 1);
 	}
@@ -1402,9 +1464,8 @@ static void task_clock_perf_counter_read(struct perf_counter *counter)
 
 static int task_clock_perf_counter_enable(struct perf_counter *counter)
 {
-	if (counter->prev_state <= PERF_COUNTER_STATE_OFF)
-		atomic64_set(&counter->hw.prev_count,
-			     task_clock_perf_counter_val(counter, 0));
+	atomic64_set(&counter->hw.prev_count,
+		     task_clock_perf_counter_val(counter, 0));
 
 	return 0;
 }
@@ -1419,6 +1480,7 @@ static void task_clock_perf_counter_disable(struct perf_counter *counter)
 static const struct hw_perf_counter_ops perf_ops_task_clock = {
 	.enable		= task_clock_perf_counter_enable,
 	.disable	= task_clock_perf_counter_disable,
+	.sched_out	= task_clock_perf_counter_disable,
 	.read		= task_clock_perf_counter_read,
 };
 
@@ -1459,8 +1521,7 @@ static void page_faults_perf_counter_read(struct perf_counter *counter)
 
 static int page_faults_perf_counter_enable(struct perf_counter *counter)
 {
-	if (counter->prev_state <= PERF_COUNTER_STATE_OFF)
-		atomic64_set(&counter->hw.prev_count, get_page_faults(counter));
+	atomic64_set(&counter->hw.prev_count, get_page_faults(counter));
 	return 0;
 }
 
@@ -1472,6 +1533,7 @@ static void page_faults_perf_counter_disable(struct perf_counter *counter)
 static const struct hw_perf_counter_ops perf_ops_page_faults = {
 	.enable		= page_faults_perf_counter_enable,
 	.disable	= page_faults_perf_counter_disable,
+	.sched_out	= page_faults_perf_counter_update,
 	.read		= page_faults_perf_counter_read,
 };
 
@@ -1506,9 +1568,7 @@ static void context_switches_perf_counter_read(struct perf_counter *counter)
 
 static int context_switches_perf_counter_enable(struct perf_counter *counter)
 {
-	if (counter->prev_state <= PERF_COUNTER_STATE_OFF)
-		atomic64_set(&counter->hw.prev_count,
-			     get_context_switches(counter));
+	atomic64_set(&counter->hw.prev_count, get_context_switches(counter));
 	return 0;
 }
 
@@ -1520,6 +1580,7 @@ static void context_switches_perf_counter_disable(struct perf_counter *counter)
 static const struct hw_perf_counter_ops perf_ops_context_switches = {
 	.enable		= context_switches_perf_counter_enable,
 	.disable	= context_switches_perf_counter_disable,
+	.sched_out	= context_switches_perf_counter_update,
 	.read		= context_switches_perf_counter_read,
 };
 
@@ -1554,9 +1615,7 @@ static void cpu_migrations_perf_counter_read(struct perf_counter *counter)
 
 static int cpu_migrations_perf_counter_enable(struct perf_counter *counter)
 {
-	if (counter->prev_state <= PERF_COUNTER_STATE_OFF)
-		atomic64_set(&counter->hw.prev_count,
-			     get_cpu_migrations(counter));
+	atomic64_set(&counter->hw.prev_count, get_cpu_migrations(counter));
 	return 0;
 }
 
@@ -1568,6 +1627,7 @@ static void cpu_migrations_perf_counter_disable(struct perf_counter *counter)
 static const struct hw_perf_counter_ops perf_ops_cpu_migrations = {
 	.enable		= cpu_migrations_perf_counter_enable,
 	.disable	= cpu_migrations_perf_counter_disable,
+	.sched_out	= cpu_migrations_perf_counter_update,
 	.read		= cpu_migrations_perf_counter_read,
 };
 
@@ -1951,7 +2011,7 @@ __perf_counter_exit_task(struct task_struct *child,
 
 		cpuctx = &__get_cpu_var(perf_cpu_context);
 
-		group_sched_out(child_counter, cpuctx, child_ctx);
+		group_inactivate(child_counter, cpuctx, child_ctx);
 
 		list_del_init(&child_counter->list_entry);
 
-- 
1.5.6.3

