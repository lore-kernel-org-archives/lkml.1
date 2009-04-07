Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbZDGJL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbZDGJL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 05:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756021AbZDGJJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 05:09:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:47104 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756154AbZDGJJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 05:09:44 -0400
Date: Tue, 7 Apr 2009 09:09:13 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090406094518.445450972@chello.nl>
References: <20090406094518.445450972@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: rework the task clock software counter
Message-ID: <tip-a39d6f2556c4a19f58f538c6aa28bf8faca4fcb8@git.kernel.org>
Git-Commit-ID: a39d6f2556c4a19f58f538c6aa28bf8faca4fcb8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Apr 2009 09:09:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a39d6f2556c4a19f58f538c6aa28bf8faca4fcb8
Gitweb:     http://git.kernel.org/tip/a39d6f2556c4a19f58f538c6aa28bf8faca4fcb8
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 6 Apr 2009 11:45:11 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 10:49:00 +0200

perf_counter: rework the task clock software counter

Rework the task clock software counter to use the context time instead
of the task runtime clock, this removes the last such user.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090406094518.445450972@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   42 ++++++++++++------------------------------
 1 files changed, 12 insertions(+), 30 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 84d85ab..56b7eb5 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
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
@@ -2347,38 +2341,28 @@ static const struct hw_perf_counter_ops perf_ops_cpu_clock = {
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
@@ -2393,14 +2377,12 @@ static int task_clock_perf_counter_enable(struct perf_counter *counter)
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
