Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbXKFAvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbXKFAvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 19:51:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755680AbXKFAug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 19:50:36 -0500
Received: from nds154-200.nds.lab.novell.com ([151.155.154.200]:25183 "EHLO
	lsg.lab.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755481AbXKFAud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 19:50:33 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 1/8] RT: Consistency cleanup for this_rq usage
To: rostedt@goodmis.org
Cc: mingo@elte.hu, dvhltc@us.ibm.com, zijlstra@redhat.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       ghaskins@novell.com
Date: Mon, 05 Nov 2007 16:48:37 -0700
Message-ID: <20071105234837.25451.26924.stgit@lsg>
In-Reply-To: <20071105234832.25451.55430.stgit@lsg>
References: <20071105234832.25451.55430.stgit@lsg>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"this_rq" is normally used to denote the RQ on the current cpu
(i.e. "cpu_rq(this_cpu)").  So clean up the usage of this_rq to be
more consistent with the rest of the code.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched_rt.c |   46 +++++++++++++++++++++++-----------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 9b06d7c..0348423 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -307,7 +307,7 @@ static struct task_struct *pick_next_highest_task_rt(struct rq *rq,
 
 /* Will lock the rq it finds */
 static struct rq *find_lock_lowest_rq(struct task_struct *task,
-				      struct rq *this_rq)
+				      struct rq *rq)
 {
 	struct rq *lowest_rq = NULL;
 	cpumask_t cpu_mask;
@@ -321,21 +321,21 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task,
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
 
@@ -343,16 +343,16 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task,
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
@@ -377,21 +377,21 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task,
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
@@ -401,24 +401,24 @@ static int push_rt_task(struct rq *this_rq)
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
@@ -429,13 +429,13 @@ static int push_rt_task(struct rq *this_rq)
 
 	assert_spin_locked(&lowest_rq->lock);
 
-	deactivate_task(this_rq, next_task, 0);
+	deactivate_task(rq, next_task, 0);
 	set_task_cpu(next_task, lowest_rq->cpu);
 	activate_task(lowest_rq, next_task, 0);
 
 	resched_task(lowest_rq->curr);
 
-	schedstat_inc(this_rq, rto_pushed);
+	schedstat_inc(rq, rto_pushed);
 
 	spin_unlock(&lowest_rq->lock);
 

