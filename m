Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbXDDUFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbXDDUFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 16:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbXDDUFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 16:05:43 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:31461 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbXDDUFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 16:05:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FxdM+TpF8+ba9vsIIu5XgX7bmcIh/i2C16KRK2ue3HCftdermqn0StoJRgJZD0vXf6XKVI1u1ZTEexd5Q0hxiCIpU23TH1TEJ+A8nyCuRCVq/tLYc5woJrujFFcaUlSutjkznvpJzfwFbK8BKJjLskNR6f9ghl3/T0faCXXzN8I=
Message-ID: <b647ffbd0704041305t2a140369q56cf9f0746b8fd86@mail.gmail.com>
Date: Wed, 4 Apr 2007 22:05:40 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: [PATCH] [sched] redundant reschedule when set_user_nice() boosts a prio of a task from the "expired" array
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070404141546.GA862@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b647ffbd0704040704k2e4b3abcyfadc7662dff37f5b@mail.gmail.com>
	 <20070404141546.GA862@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

following the conversation on "a redundant reschedule call in set_user_prio()",
here is a possible approach.

The patch is somewhat intrusive as it even dares to adapt TASK_PREEMPTS_CURR().

Nevertheless, this adaptation seems to be ok with all the current use-cases.

Presupposition: TASK_PREEMPTS_CURR(p, rq) will /never/ be used as "a
mere prio comparator" - e.g. to make decisions on which array a task
has to be placed in.


=====

o  Make TASK_PREEMPTS_CURR(task, rq) return "true" only if the task's
prio is higher than the current's one and the task is in the "active"
array.
This ensures we don't make redundant resched_task() calls when the
task is in the "expired" array (as may happen now in set_user_prio(),
rt_mutex_setprio() and pull_task() ) ;

o  generilise conditions for a call to resched_task() in
set_user_nice(), rt_mutex_setprio() and sched_setscheduler()

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
--

--- linux-2.6.21-rc5/kernel/sched-orig.c        2007-04-04
18:26:19.000000000 +0200
+++ linux-2.6.21-rc5/kernel/sched.c     2007-04-04 18:26:43.000000000 +0200
@@ -168,7 +168,7 @@ unsigned long long __attribute__((weak))
                (MAX_BONUS / 2 + DELTA((p)) + 1) / MAX_BONUS - 1))

 #define TASK_PREEMPTS_CURR(p, rq) \
-       ((p)->prio < (rq)->curr->prio)
+       (((p)->prio < (rq)->curr->prio) && ((p)->array == (rq)->active))

 #define SCALE_PRIO(x, prio) \
        max(x * (MAX_PRIO - prio) / (MAX_USER_PRIO / 2), MIN_TIMESLICE)
@@ -3847,13 +3847,13 @@ void rt_mutex_setprio(struct task_struct
        struct prio_array *array;
        unsigned long flags;
        struct rq *rq;
-       int oldprio;
+       int delta;

        BUG_ON(prio < 0 || prio > MAX_PRIO);

        rq = task_rq_lock(p, &flags);

-       oldprio = p->prio;
+       delta = prio - p->prio;
        array = p->array;
        if (array)
                dequeue_task(p, array);
@@ -3869,13 +3869,10 @@ void rt_mutex_setprio(struct task_struct
                enqueue_task(p, array);
                /*
                 * Reschedule if we are currently running on this runqueue and
-                * our priority decreased, or if we are not currently running on
-                * this runqueue and our priority is higher than the current's
+                * our priority decreased, or if our priority became higher
+                * than the current's.
                 */
-               if (task_running(rq, p)) {
-                       if (p->prio > oldprio)
-                               resched_task(rq->curr);
-               } else if (TASK_PREEMPTS_CURR(p, rq))
+               if (TASK_PREEMPTS_CURR(p, rq) || (delta > 0 &&
task_running(rq, p)))
                        resched_task(rq->curr);
        }
        task_rq_unlock(rq, &flags);
@@ -3923,10 +3920,11 @@ void set_user_nice(struct task_struct *p
                enqueue_task(p, array);
                inc_raw_weighted_load(rq, p);
                /*
-                * If the task increased its priority or is running and
-                * lowered its priority, then reschedule its CPU:
+                * Reschedule if we are currently running on this runqueue and
+                * our priority decreased, or if our priority became higher
+                * than the current's.
                 */
-               if (delta < 0 || (delta > 0 && task_running(rq, p)))
+               if (TASK_PREEMPTS_CURR(p, rq) || (delta > 0 &&
task_running(rq, p)))
                        resched_task(rq->curr);
        }
 out_unlock:
@@ -4153,13 +4151,10 @@ recheck:
                __activate_task(p, rq);
                /*
                 * Reschedule if we are currently running on this runqueue and
-                * our priority decreased, or if we are not currently running on
-                * this runqueue and our priority is higher than the current's
+                * our priority decreased, or our priority became higher
+                * than the current's.
                 */
-               if (task_running(rq, p)) {
-                       if (p->prio > oldprio)
-                               resched_task(rq->curr);
-               } else if (TASK_PREEMPTS_CURR(p, rq))
+               if (TASK_PREEMPTS_CURR(p, rq) || (task_running(rq, p)
&& p->prio > oldprio))
                        resched_task(rq->curr);
        }
        __task_rq_unlock(rq);

=====

-- 
Best regards,
Dmitry Adamushko
