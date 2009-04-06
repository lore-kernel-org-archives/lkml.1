Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZDFJsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZDFJsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755864AbZDFJoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:44:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:42359 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbZDFJoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:44:39 -0400
Message-Id: <20090406094518.445450972@chello.nl>
References: <20090406094458.977814421@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 06 Apr 2009 11:45:11 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 13/15] perf_counter: rework the task clock software counter
Content-Disposition: inline; filename=perf_counter-sw-task-clock.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rework the task clock software counter to use the context time instead
of the task runtime clock, this removes the last such user.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |   42 ++++++++++++------------------------------
 1 file changed, 12 insertions(+), 30 deletions(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -974,9 +974,6 @@ int perf_counter_task_disable(void)
 	curr_rq_lock_irq_save(&flags);
 	cpu = smp_processor_id();
 
-	/* force the update of the task clock: */
-	__task_delta_exec(curr, 1);
-
 	perf_counter_task_sched_out(curr, cpu);
 
 	spin_lock(&ctx->lock);
@@ -1017,9 +1014,6 @@ int perf_counter_task_enable(void)
 	curr_rq_lock_irq_save(&flags);
 	cpu = smp_processor_id();
 
-	/* force the update of the task clock: */
-	__task_delta_exec(curr, 1);
-
 	perf_counter_task_sched_out(curr, cpu);
 
 	spin_lock(&ctx->lock);
@@ -2347,38 +2341,28 @@ static const struct hw_perf_counter_ops 
  * Software counter: task time clock
  */
 
-/*
- * Called from within the scheduler:
- */
-static u64 task_clock_perf_counter_val(struct perf_counter *counter, int update)
-{
-	struct task_struct *curr = counter->task;
-	u64 delta;
-
-	delta = __task_delta_exec(curr, update);
-
-	return curr->se.sum_exec_runtime + delta;
-}
-
-static void task_clock_perf_counter_update(struct perf_counter *counter, u64 now)
+static void task_clock_perf_counter_update(struct perf_counter *counter)
 {
-	u64 prev;
+	u64 prev, now;
 	s64 delta;
 
-	prev = atomic64_read(&counter->hw.prev_count);
-
-	atomic64_set(&counter->hw.prev_count, now);
+	update_context_time(counter->ctx);
+	now = counter->ctx->time;
 
+	prev = atomic64_xchg(&counter->hw.prev_count, now);
 	delta = now - prev;
-
 	atomic64_add(delta, &counter->count);
 }
 
 static int task_clock_perf_counter_enable(struct perf_counter *counter)
 {
 	struct hw_perf_counter *hwc = &counter->hw;
+	u64 now;
+
+	update_context_time(counter->ctx);
+	now = counter->ctx->time;
 
-	atomic64_set(&hwc->prev_count, task_clock_perf_counter_val(counter, 0));
+	atomic64_set(&hwc->prev_count, now);
 	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hwc->hrtimer.function = perf_swcounter_hrtimer;
 	if (hwc->irq_period) {
@@ -2393,14 +2377,12 @@ static int task_clock_perf_counter_enabl
 static void task_clock_perf_counter_disable(struct perf_counter *counter)
 {
 	hrtimer_cancel(&counter->hw.hrtimer);
-	task_clock_perf_counter_update(counter,
-			task_clock_perf_counter_val(counter, 0));
+	task_clock_perf_counter_update(counter);
 }
 
 static void task_clock_perf_counter_read(struct perf_counter *counter)
 {
-	task_clock_perf_counter_update(counter,
-			task_clock_perf_counter_val(counter, 1));
+	task_clock_perf_counter_update(counter);
 }
 
 static const struct hw_perf_counter_ops perf_ops_task_clock = {

-- 

