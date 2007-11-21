Return-Path: <linux-kernel-owner+w=401wt.eu-S1765780AbXKUBQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765780AbXKUBQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 20:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760638AbXKUBNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 20:13:53 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:37423 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763607AbXKUBNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 20:13:48 -0500
Message-Id: <20071121011250.298408035@goodmis.org>
References: <20071121010054.663842380@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 20 Nov 2007 20:01:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v4 09/20] RT: Consistency cleanup for this_rq usage
Content-Disposition: inline; filename=sched-cleanup-thisrq.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Haskins <ghaskins@novell.com>

"this_rq" is normally used to denote the RQ on the current cpu
(i.e. "cpu_rq(this_cpu)").  So clean up the usage of this_rq to be
more consistent with the rest of the code.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---

 kernel/sched_rt.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

Index: linux-compile.git/kernel/sched_rt.c
===================================================================
--- linux-compile.git.orig/kernel/sched_rt.c	2007-11-20 19:53:02.000000000 -0500
+++ linux-compile.git/kernel/sched_rt.c	2007-11-20 19:53:03.000000000 -0500
@@ -325,21 +325,21 @@ static struct rq *find_lock_lowest_rq(st
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
@@ -349,24 +349,24 @@ static int push_rt_task(struct rq *this_
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
@@ -377,7 +377,7 @@ static int push_rt_task(struct rq *this_
 
 	assert_spin_locked(&lowest_rq->lock);
 
-	deactivate_task(this_rq, next_task, 0);
+	deactivate_task(rq, next_task, 0);
 	set_task_cpu(next_task, lowest_rq->cpu);
 	activate_task(lowest_rq, next_task, 0);
 

-- 
