Return-Path: <linux-kernel-owner+w=401wt.eu-S1756461AbZCJSTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461AbZCJSTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 14:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755168AbZCJSS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 14:18:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50935 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098AbZCJSS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 14:18:57 -0400
Subject: [PATCH] sched: avg_overlap decay
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 10 Mar 2009 19:18:51 +0100
Message-Id: <1236709131.25234.576.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike, are you good with this patch as it stands?

---
Subject: sched: avg_overlap decay
From: Mike Galbraith <efault@gmx.de>
Date: Tue Mar 10 19:08:11 CET 2009

avg_overlap is used to measure the runtime overlap of the waker and wakee.

However, when a process changes behaviour, eg a pipe becomes un-congested
and we don't need to go to sleep after a wakeup for a while, the avg_overlap
value grows stale.

When running we use the avg runtime between preemption as a measure for
avg_overlap since the amount of runtime can be correlated to cache footprint.

The longer we run, the less likely we'll be wanting to be migrated to another
CPU.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -4692,6 +4692,28 @@ static inline void schedule_debug(struct
 #endif
 }
 
+static void put_prev_task(struct rq *rq, struct task_struct *prev)
+{
+	if (prev->state == TASK_RUNNING) {
+		u64 runtime = prev->se.sum_exec_runtime;
+
+		runtime -= prev->se.prev_sum_exec_runtime;
+		runtime = min_t(u64, runtime, 2*sysctl_sched_migration_cost);
+
+		/*
+		 * In order to avoid avg_overlap growing stale when we are
+		 * indeed overlapping and hence not getting put to sleep, grow
+		 * the avg_overlap on preemption.
+		 *
+		 * We use the average preemption runtime because that
+		 * correlates to the amount of cache footprint a task can
+		 * build up.
+		 */
+		update_avg(&prev->se.avg_overlap, runtime);
+	}
+	prev->sched_class->put_prev_task(rq, prev);
+}
+
 /*
  * Pick up the highest-prio task:
  */
@@ -4768,7 +4790,7 @@ need_resched_nonpreemptible:
 	if (unlikely(!rq->nr_running))
 		idle_balance(cpu, rq);
 
-	prev->sched_class->put_prev_task(rq, prev);
+	put_prev_task(rq, prev);
 	next = pick_next_task(rq);
 
 	if (likely(prev != next)) {


