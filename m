Return-Path: <linux-kernel-owner+w=401wt.eu-S1755128AbZDFJpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbZDFJpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755364AbZDFJoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:44:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34354 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249AbZDFJof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:44:35 -0400
Message-Id: <20090406094518.353552838@chello.nl>
References: <20090406094458.977814421@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 06 Apr 2009 11:45:10 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 12/15] perf_counter: rework context time
Content-Disposition: inline; filename=perf_counter-context-clock.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since perf_counter_context is switched along with tasks, we can
maintain the context time without using the task runtime clock.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |   10 +----
 kernel/perf_counter.c        |   78 ++++++++++++++++++-------------------------
 2 files changed, 37 insertions(+), 51 deletions(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -477,14 +477,10 @@ struct perf_counter_context {
 	struct task_struct	*task;
 
 	/*
-	 * time_now is the current time in nanoseconds since an arbitrary
-	 * point in the past.  For per-task counters, this is based on the
-	 * task clock, and for per-cpu counters it is based on the cpu clock.
-	 * time_lost is an offset from the task/cpu clock, used to make it
-	 * appear that time only passes while the context is scheduled in.
+	 * Context clock, runs when context enabled.
 	 */
-	u64			time_now;
-	u64			time_lost;
+	u64			time;
+	u64			timestamp;
 #endif
 };
 
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -117,7 +117,7 @@ counter_sched_out(struct perf_counter *c
 		return;
 
 	counter->state = PERF_COUNTER_STATE_INACTIVE;
-	counter->tstamp_stopped = ctx->time_now;
+	counter->tstamp_stopped = ctx->time;
 	counter->hw_ops->disable(counter);
 	counter->oncpu = -1;
 
@@ -253,27 +253,20 @@ retry:
 	spin_unlock_irq(&ctx->lock);
 }
 
-/*
- * Get the current time for this context.
- * If this is a task context, we use the task's task clock,
- * or for a per-cpu context, we use the cpu clock.
- */
-static u64 get_context_time(struct perf_counter_context *ctx, int update)
+static inline u64 perf_clock(void)
 {
-	struct task_struct *curr = ctx->task;
-
-	if (!curr)
-		return cpu_clock(smp_processor_id());
-
-	return __task_delta_exec(curr, update) + curr->se.sum_exec_runtime;
+	return cpu_clock(smp_processor_id());
 }
 
 /*
  * Update the record of the current time in a context.
  */
-static void update_context_time(struct perf_counter_context *ctx, int update)
+static void update_context_time(struct perf_counter_context *ctx)
 {
-	ctx->time_now = get_context_time(ctx, update) - ctx->time_lost;
+	u64 now = perf_clock();
+
+	ctx->time += now - ctx->timestamp;
+	ctx->timestamp = now;
 }
 
 /*
@@ -284,15 +277,17 @@ static void update_counter_times(struct 
 	struct perf_counter_context *ctx = counter->ctx;
 	u64 run_end;
 
-	if (counter->state >= PERF_COUNTER_STATE_INACTIVE) {
-		counter->total_time_enabled = ctx->time_now -
-			counter->tstamp_enabled;
-		if (counter->state == PERF_COUNTER_STATE_INACTIVE)
-			run_end = counter->tstamp_stopped;
-		else
-			run_end = ctx->time_now;
-		counter->total_time_running = run_end - counter->tstamp_running;
-	}
+	if (counter->state < PERF_COUNTER_STATE_INACTIVE)
+		return;
+
+	counter->total_time_enabled = ctx->time - counter->tstamp_enabled;
+
+	if (counter->state == PERF_COUNTER_STATE_INACTIVE)
+		run_end = counter->tstamp_stopped;
+	else
+		run_end = ctx->time;
+
+	counter->total_time_running = run_end - counter->tstamp_running;
 }
 
 /*
@@ -332,7 +327,7 @@ static void __perf_counter_disable(void 
 	 * If it is in error state, leave it in error state.
 	 */
 	if (counter->state >= PERF_COUNTER_STATE_INACTIVE) {
-		update_context_time(ctx, 1);
+		update_context_time(ctx);
 		update_counter_times(counter);
 		if (counter == counter->group_leader)
 			group_sched_out(counter, cpuctx, ctx);
@@ -426,7 +421,7 @@ counter_sched_in(struct perf_counter *co
 		return -EAGAIN;
 	}
 
-	counter->tstamp_running += ctx->time_now - counter->tstamp_stopped;
+	counter->tstamp_running += ctx->time - counter->tstamp_stopped;
 
 	if (!is_software_counter(counter))
 		cpuctx->active_oncpu++;
@@ -493,9 +488,9 @@ static void add_counter_to_ctx(struct pe
 	list_add_counter(counter, ctx);
 	ctx->nr_counters++;
 	counter->prev_state = PERF_COUNTER_STATE_OFF;
-	counter->tstamp_enabled = ctx->time_now;
-	counter->tstamp_running = ctx->time_now;
-	counter->tstamp_stopped = ctx->time_now;
+	counter->tstamp_enabled = ctx->time;
+	counter->tstamp_running = ctx->time;
+	counter->tstamp_stopped = ctx->time;
 }
 
 /*
@@ -522,7 +517,7 @@ static void __perf_install_in_context(vo
 
 	curr_rq_lock_irq_save(&flags);
 	spin_lock(&ctx->lock);
-	update_context_time(ctx, 1);
+	update_context_time(ctx);
 
 	/*
 	 * Protect the list operation against NMI by disabling the
@@ -648,13 +643,13 @@ static void __perf_counter_enable(void *
 
 	curr_rq_lock_irq_save(&flags);
 	spin_lock(&ctx->lock);
-	update_context_time(ctx, 1);
+	update_context_time(ctx);
 
 	counter->prev_state = counter->state;
 	if (counter->state >= PERF_COUNTER_STATE_INACTIVE)
 		goto unlock;
 	counter->state = PERF_COUNTER_STATE_INACTIVE;
-	counter->tstamp_enabled = ctx->time_now - counter->total_time_enabled;
+	counter->tstamp_enabled = ctx->time - counter->total_time_enabled;
 
 	/*
 	 * If the counter is in a group and isn't the group leader,
@@ -737,8 +732,8 @@ static void perf_counter_enable(struct p
 	 */
 	if (counter->state == PERF_COUNTER_STATE_OFF) {
 		counter->state = PERF_COUNTER_STATE_INACTIVE;
-		counter->tstamp_enabled = ctx->time_now -
-			counter->total_time_enabled;
+		counter->tstamp_enabled =
+			ctx->time - counter->total_time_enabled;
 	}
  out:
 	spin_unlock_irq(&ctx->lock);
@@ -778,7 +773,7 @@ void __perf_counter_sched_out(struct per
 	ctx->is_active = 0;
 	if (likely(!ctx->nr_counters))
 		goto out;
-	update_context_time(ctx, 0);
+	update_context_time(ctx);
 
 	flags = hw_perf_save_disable();
 	if (ctx->nr_active) {
@@ -883,12 +878,7 @@ __perf_counter_sched_in(struct perf_coun
 	if (likely(!ctx->nr_counters))
 		goto out;
 
-	/*
-	 * Add any time since the last sched_out to the lost time
-	 * so it doesn't get included in the total_time_enabled and
-	 * total_time_running measures for counters in the context.
-	 */
-	ctx->time_lost = get_context_time(ctx, 0) - ctx->time_now;
+	ctx->timestamp = perf_clock();
 
 	flags = hw_perf_save_disable();
 
@@ -1043,8 +1033,8 @@ int perf_counter_task_enable(void)
 		if (counter->state > PERF_COUNTER_STATE_OFF)
 			continue;
 		counter->state = PERF_COUNTER_STATE_INACTIVE;
-		counter->tstamp_enabled = ctx->time_now -
-			counter->total_time_enabled;
+		counter->tstamp_enabled =
+			ctx->time - counter->total_time_enabled;
 		counter->hw_event.disabled = 0;
 	}
 	hw_perf_restore(perf_flags);
@@ -1113,7 +1103,7 @@ static void __read(void *info)
 
 	curr_rq_lock_irq_save(&flags);
 	if (ctx->is_active)
-		update_context_time(ctx, 1);
+		update_context_time(ctx);
 	counter->hw_ops->read(counter);
 	update_counter_times(counter);
 	curr_rq_unlock_irq_restore(&flags);

-- 

