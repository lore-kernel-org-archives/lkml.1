Return-Path: <linux-kernel-owner+w=401wt.eu-S932140AbXDIMMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbXDIMMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 08:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbXDIMMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 08:12:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:31597 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbXDIMML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 08:12:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:date:user-agent:mime-version:content-disposition:subject:to:cc:content-type:content-transfer-encoding:message-id;
        b=P6Rwvig5rhqP5ikl87AtSqMu9jCfO8cDum/Kk+BbdEuAWSb7mpHFsJbJldDyPSeQ7sWxd1iyYc2d1062175eIIWFsf6CU96TS3Psx8iLzXzLHmK7NRZyu1MPOlQ6PmVB2WFAVTfd7YdRjT+WOkp4V24jMsnGyr8tV7TRVL7YQqo=
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Date: Mon, 9 Apr 2007 09:23:09 +0200
User-Agent: KMail/1.8.2
MIME-Version: 1.0
Content-Disposition: inline
Subject: [PATCH 2.6.21-rc6] sched: modification of TASK_PREEMPTS_CURRENT to avoid redundant reschedules (e.g. in set_user_nice)
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, dmitry.adamushko@gmail.com
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200704090923.10495.dmitry.adamushko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Adamushko <dmitry.adamushko@gmail.com>

o  Fixed a mail client (shouldn't be white-space damaged now);
o  Andrew, a patch against SD will follow.

---

o  Make TASK_PREEMPTS_CURR(task, rq) return "true" only if the task's
prio is higher than the current's one and the task is in the "active"
array.
This ensures we don't make redundant resched_task() calls when the
task is in the "expired" array (as may happen now in set_user_prio(),
rt_mutex_setprio() and pull_task() ) ;

o  generilise conditions for a call to resched_task() in
set_user_nice(), rt_mutex_setprio() and sched_setscheduler()


Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

---

--- linux-2.6.21-rc6/kernel/sched-orig.c	2007-04-07 17:16:16.000000000 +0200
+++ linux-2.6.21-rc6/kernel/sched.c	2007-04-07 18:13:49.000000000 +0200
@@ -168,7 +168,7 @@ unsigned long long __attribute__((weak))
 		(MAX_BONUS / 2 + DELTA((p)) + 1) / MAX_BONUS - 1))
 
 #define TASK_PREEMPTS_CURR(p, rq) \
-	((p)->prio < (rq)->curr->prio)
+	(((p)->prio < (rq)->curr->prio) && ((p)->array == (rq)->active))
 
 #define SCALE_PRIO(x, prio) \
 	max(x * (MAX_PRIO - prio) / (MAX_USER_PRIO / 2), MIN_TIMESLICE)
@@ -3847,13 +3847,13 @@ void rt_mutex_setprio(struct task_struct
 	struct prio_array *array;
 	unsigned long flags;
 	struct rq *rq;
-	int oldprio;
+	int delta;
 
 	BUG_ON(prio < 0 || prio > MAX_PRIO);
 
 	rq = task_rq_lock(p, &flags);
 
-	oldprio = p->prio;
+	delta = prio - p->prio;
 	array = p->array;
 	if (array)
 		dequeue_task(p, array);
@@ -3869,13 +3869,11 @@ void rt_mutex_setprio(struct task_struct
 		enqueue_task(p, array);
 		/*
 		 * Reschedule if we are currently running on this runqueue and
-		 * our priority decreased, or if we are not currently running on
-		 * this runqueue and our priority is higher than the current's
+		 * our priority decreased, or if our priority became higher
+		 * than the current's.
 		 */
-		if (task_running(rq, p)) {
-			if (p->prio > oldprio)
-				resched_task(rq->curr);
-		} else if (TASK_PREEMPTS_CURR(p, rq))
+		if (TASK_PREEMPTS_CURR(p, rq) ||
+				(delta > 0 && task_running(rq, p)))
 			resched_task(rq->curr);
 	}
 	task_rq_unlock(rq, &flags);
@@ -3923,10 +3921,12 @@ void set_user_nice(struct task_struct *p
 		enqueue_task(p, array);
 		inc_raw_weighted_load(rq, p);
 		/*
-		 * If the task increased its priority or is running and
-		 * lowered its priority, then reschedule its CPU:
+		 * Reschedule if we are currently running on this runqueue and
+		 * our priority decreased, or if our priority became higher
+		 * than the current's.
 		 */
-		if (delta < 0 || (delta > 0 && task_running(rq, p)))
+		if (TASK_PREEMPTS_CURR(p, rq) ||
+				(delta > 0 && task_running(rq, p)))
 			resched_task(rq->curr);
 	}
 out_unlock:
@@ -4153,13 +4153,11 @@ recheck:
 		__activate_task(p, rq);
 		/*
 		 * Reschedule if we are currently running on this runqueue and
-		 * our priority decreased, or if we are not currently running on
-		 * this runqueue and our priority is higher than the current's
+		 * our priority decreased, or our priority became higher
+		 * than the current's.
 		 */
-		if (task_running(rq, p)) {
-			if (p->prio > oldprio)
-				resched_task(rq->curr);
-		} else if (TASK_PREEMPTS_CURR(p, rq))
+		if (TASK_PREEMPTS_CURR(p, rq) ||
+				(task_running(rq, p) && p->prio > oldprio))
 			resched_task(rq->curr);
 	}
 	__task_rq_unlock(rq);
