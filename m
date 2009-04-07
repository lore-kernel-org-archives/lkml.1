Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbZDGJLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbZDGJLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 05:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756087AbZDGJJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 05:09:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:47095 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756048AbZDGJJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 05:09:35 -0400
Date: Tue, 7 Apr 2009 09:09:00 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090406094518.353552838@chello.nl>
References: <20090406094518.353552838@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: rework context time
Message-ID: <tip-4af4998b8aa35600f4c4a4f3c3a23baca6081d02@git.kernel.org>
Git-Commit-ID: 4af4998b8aa35600f4c4a4f3c3a23baca6081d02
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Apr 2009 09:09:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4af4998b8aa35600f4c4a4f3c3a23baca6081d02
Gitweb:     http://git.kernel.org/tip/4af4998b8aa35600f4c4a4f3c3a23baca6081d02
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 6 Apr 2009 11:45:10 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 10:49:00 +0200

perf_counter: rework context time

Since perf_counter_context is switched along with tasks, we can
maintain the context time without using the task runtime clock.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090406094518.353552838@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |   10 ++----
 kernel/perf_counter.c        |   78 ++++++++++++++++++-----------------------
 2 files changed, 37 insertions(+), 51 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 0f5a400..7f5d353 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
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
 
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 8c8eaf0..84d85ab 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -117,7 +117,7 @@ counter_sched_out(struct perf_counter *counter,
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
@@ -284,15 +277,17 @@ static void update_counter_times(struct perf_counter *counter)
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
@@ -332,7 +327,7 @@ static void __perf_counter_disable(void *info)
 	 * If it is in error state, leave it in error state.
 	 */
 	if (counter->state >= PERF_COUNTER_STATE_INACTIVE) {
-		update_context_time(ctx, 1);
+		update_context_time(ctx);
 		update_counter_times(counter);
 		if (counter == counter->group_leader)
 			group_sched_out(counter, cpuctx, ctx);
@@ -426,7 +421,7 @@ counter_sched_in(struct perf_counter *counter,
 		return -EAGAIN;
 	}
 
-	counter->tstamp_running += ctx->time_now - counter->tstamp_stopped;
+	counter->tstamp_running += ctx->time - counter->tstamp_stopped;
 
 	if (!is_software_counter(counter))
 		cpuctx->active_oncpu++;
@@ -493,9 +488,9 @@ static void add_counter_to_ctx(struct perf_counter *counter,
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
@@ -522,7 +517,7 @@ static void __perf_install_in_context(void *info)
 
 	curr_rq_lock_irq_save(&flags);
 	spin_lock(&ctx->lock);
-	update_context_time(ctx, 1);
+	update_context_time(ctx);
 
 	/*
 	 * Protect the list operation against NMI by disabling the
@@ -648,13 +643,13 @@ static void __perf_counter_enable(void *info)
 
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
@@ -737,8 +732,8 @@ static void perf_counter_enable(struct perf_counter *counter)
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
@@ -778,7 +773,7 @@ void __perf_counter_sched_out(struct perf_counter_context *ctx,
 	ctx->is_active = 0;
 	if (likely(!ctx->nr_counters))
 		goto out;
-	update_context_time(ctx, 0);
+	update_context_time(ctx);
 
 	flags = hw_perf_save_disable();
 	if (ctx->nr_active) {
@@ -883,12 +878,7 @@ __perf_counter_sched_in(struct perf_counter_context *ctx,
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
