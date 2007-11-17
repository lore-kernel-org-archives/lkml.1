Return-Path: <linux-kernel-owner+w=401wt.eu-S935538AbXKQG3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935538AbXKQG3y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 01:29:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762396AbXKQGYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 01:24:48 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:38176 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759144AbXKQGYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 01:24:41 -0500
Message-Id: <20071117062404.509253800@goodmis.org>
References: <20071117062104.177779113@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 17 Nov 2007 01:21:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v3 09/17] Consistency cleanup for this_rq usage
Content-Disposition: inline; filename=0001-this_rq-consistency-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Haskins <ghaskins@novell.com>

"this_rq" is normally used to denote the RQ on the current cpu
(i.e. "cpu_rq(this_cpu)").  So clean up the usage of this_rq to be
more consistent with the rest of the code.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---

 kernel/sched_rt.c |   44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

Index: linus.git/kernel/sched_rt.c
===================================================================
--- linus.git.orig/kernel/sched_rt.c
+++ linus.git/kernel/sched_rt.c
@@ -253,7 +253,7 @@ static struct task_struct *pick_next_hig
 
 /* Will lock the rq it finds */
 static struct rq *find_lock_lowest_rq(struct task_struct *task,
-				      struct rq *this_rq)
+				      struct rq *rq)
 {
 	struct rq *lowest_rq = NULL;
 	cpumask_t cpu_mask;
@@ -267,21 +267,21 @@ static struct rq *find_lock_lowest_rq(st
 		 * Scan each rq for the lowest prio.
 		 */
 		for_each_cpu_mask(cpu, cpu_mask) {
-			struct rq *rq = &per_cpu(runqueues, cpu);
+			struct rq *curr_rq = &per_cpu(runqueues, cpu);
 
-			if (cpu == this_rq->cpu)
+			if (cpu == rq->cpu)
 				continue;
 
 			/* We look for lowest RT prio or non-rt CPU */
-			if (rq->rt.highest_prio >= MAX_RT_PRIO) {
-				lowest_rq = rq;
+			if (curr_rq->rt.highest_prio >= MAX_RT_PRIO) {
+				lowest_rq = curr_rq;
 				break;
 			}
 
 			/* no locking for now */
-			if (rq->rt.highest_prio > task->prio &&
-			    (!lowest_rq || rq->rt.highest_prio > lowest_rq->rt.highest_prio)) {
-				lowest_rq = rq;
+			if (curr_rq->rt.highest_prio > task->prio &&
+			    (!lowest_rq || curr_rq->rt.highest_prio > lowest_rq->rt.highest_prio)) {
+				lowest_rq = curr_rq;
 			}
 		}
 
@@ -289,16 +289,16 @@ static struct rq *find_lock_lowest_rq(st
 			break;
 
 		/* if the prio of this runqueue changed, try again */
-		if (double_lock_balance(this_rq, lowest_rq)) {
+		if (double_lock_balance(rq, lowest_rq)) {
 			/*
 			 * We had to unlock the run queue. In
 			 * the mean time, task could have
 			 * migrated already or had its affinity changed.
 			 * Also make sure that it wasn't scheduled on its rq.
 			 */
-			if (unlikely(task_rq(task) != this_rq ||
+			if (unlikely(task_rq(task) != rq ||
 				     !cpu_isset(lowest_rq->cpu, task->cpus_allowed) ||
-				     task_running(this_rq, task) ||
+				     task_running(rq, task) ||
 				     !task->se.on_rq)) {
 				spin_unlock(&lowest_rq->lock);
 				lowest_rq = NULL;
@@ -323,21 +323,21 @@ static struct rq *find_lock_lowest_rq(st
  * running task can migrate over to a CPU that is running a task
  * of lesser priority.
  */
-static int push_rt_task(struct rq *this_rq)
+static int push_rt_task(struct rq *rq)
 {
 	struct task_struct *next_task;
 	struct rq *lowest_rq;
 	int ret = 0;
 	int paranoid = RT_MAX_TRIES;
 
-	assert_spin_locked(&this_rq->lock);
+	assert_spin_locked(&rq->lock);
 
-	next_task = pick_next_highest_task_rt(this_rq, -1);
+	next_task = pick_next_highest_task_rt(rq, -1);
 	if (!next_task)
 		return 0;
 
  retry:
-	if (unlikely(next_task == this_rq->curr)) {
+	if (unlikely(next_task == rq->curr)) {
 		WARN_ON(1);
 		return 0;
 	}
@@ -347,24 +347,24 @@ static int push_rt_task(struct rq *this_
 	 * higher priority than current. If that's the case
 	 * just reschedule current.
 	 */
-	if (unlikely(next_task->prio < this_rq->curr->prio)) {
-		resched_task(this_rq->curr);
+	if (unlikely(next_task->prio < rq->curr->prio)) {
+		resched_task(rq->curr);
 		return 0;
 	}
 
-	/* We might release this_rq lock */
+	/* We might release rq lock */
 	get_task_struct(next_task);
 
 	/* find_lock_lowest_rq locks the rq if found */
-	lowest_rq = find_lock_lowest_rq(next_task, this_rq);
+	lowest_rq = find_lock_lowest_rq(next_task, rq);
 	if (!lowest_rq) {
 		struct task_struct *task;
 		/*
-		 * find lock_lowest_rq releases this_rq->lock
+		 * find lock_lowest_rq releases rq->lock
 		 * so it is possible that next_task has changed.
 		 * If it has, then try again.
 		 */
-		task = pick_next_highest_task_rt(this_rq, -1);
+		task = pick_next_highest_task_rt(rq, -1);
 		if (unlikely(task != next_task) && task && paranoid--) {
 			put_task_struct(next_task);
 			next_task = task;
@@ -375,7 +375,7 @@ static int push_rt_task(struct rq *this_
 
 	assert_spin_locked(&lowest_rq->lock);
 
-	deactivate_task(this_rq, next_task, 0);
+	deactivate_task(rq, next_task, 0);
 	set_task_cpu(next_task, lowest_rq->cpu);
 	activate_task(lowest_rq, next_task, 0);
 

-- 
