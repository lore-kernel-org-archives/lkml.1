Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbXDJVFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbXDJVFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbXDJVFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:05:05 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:22149 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbXDJVFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:05:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=O8N/ioZt2WVs+S9TYqjIJVtxGfMlPQSOs/cJRwfuyCIN7q7B04WMOuaI+SVGwMdYbrL6TECvmopFWUTscJZAH9733i/PT8vdC0z8baLxi1y+NYdFTUmpri9y8Cr62C/lrXsoVcbGan0IkdaXh30WEaOaC0tu+NGCQisIj3NL/ec=
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: "Con Kolivas" <kernel@kolivas.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: [PATCH 2.6.21-rc6-mm1] SD sched: avoid redundant reschedule in set_user_nice()
Date: Tue, 10 Apr 2007 17:16:13 +0200
User-Agent: KMail/1.8.2
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200704101716.14372.dmitry.adamushko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

This change seems to be pretty logical. OTOH, it's just a micro-optimization.
So there is no hurry and we may wait till Con is back (Andrew, if you think it'd be better).

Logically-wise, this is similar to the changes I have sent earlier for the mainline.

There is no need to change TASK_PREEMPTS_CURR() here. All the infrastructure is already in place
(task_preempts_curr() already does the necessary checks). And nevertheless, set_user_nice() can be made
nicer. So that's what this patch is about.

---

Call for reschedule upon increasing a task's priority in set_user_nice() only
if the task may preempt the current one.


Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

---

--- linux-2.6.21-rc6-mm1/kernel/sched-orig.c	2007-04-09 10:10:52.000000000 +0200
+++ linux-2.6.21-rc6-mm1/kernel/sched.c	2007-04-09 17:07:12.000000000 +0200
@@ -4022,14 +4022,14 @@ EXPORT_SYMBOL(sleep_on_timeout);
 void rt_mutex_setprio(struct task_struct *p, int prio)
 {
 	unsigned long flags;
-	int queued, oldprio;
+	int queued, delta;
 	struct rq *rq;
 
 	BUG_ON(prio < 0 || prio > MAX_PRIO);
 
 	rq = task_rq_lock(p, &flags);
 
-	oldprio = p->prio;
+	delta = prio - p->prio;
 	queued = task_queued(p);
 	if (queued)
 		dequeue_task(p, rq);
@@ -4043,7 +4043,7 @@ void rt_mutex_setprio(struct task_struct
 		 * this runqueue and our priority is higher than the current's
 		 */
 		if (task_running(rq, p)) {
-			if (p->prio > oldprio)
+			if (delta > 0)
 				resched_task(rq->curr);
 		} else
 			try_preempt(p, rq);
@@ -4055,7 +4055,7 @@ void rt_mutex_setprio(struct task_struct
 
 void set_user_nice(struct task_struct *p, long nice)
 {
-	int queued, old_prio,delta;
+	int queued, old_prio, delta;
 	unsigned long flags;
 	struct rq *rq;
 
@@ -4096,8 +4096,11 @@ void set_user_nice(struct task_struct *p
 		 * If the task increased its priority or is running and
 		 * lowered its priority, then reschedule its CPU:
 		 */
-		if (delta < 0 || (delta > 0 && task_running(rq, p)))
-			resched_task(rq->curr);
+		if (task_running(rq, p)) {
+			if (delta > 0)
+				resched_task(rq->curr);
+		} else
+			try_preempt(p, rq);
 	}
 out_unlock:
 	task_rq_unlock(rq, &flags);
