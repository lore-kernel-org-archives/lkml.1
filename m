Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbYCJSBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbYCJSBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 14:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbYCJSBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 14:01:24 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:34669 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920AbYCJSBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 14:01:22 -0400
Message-ID: <47D57770.50909@ct.jp.nec.com>
Date: Mon, 10 Mar 2008 11:01:20 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       hpj@urpla.net
Subject: [PATCH] sched: fix race in schedule
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I found a race condition in scheduler.
The first report is the below;
http://lkml.org/lkml/2008/2/26/459

It took a bit long time to investigate and I couldn't have much time last week.
It is hard to reproduce but -rt is little easier because it has preemptible
spin lock and rcu.

Could you please check the scenario and the patch.
It will be needed for the stable, too.

---
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

There is a race condition between schedule() and some dequeue/enqueue
functions; rt_mutex_setprio(), __setscheduler() and sched_move_task().

When scheduling to idle, idle_balance() is called to pull tasks from
other busy processor. It might drop the rq lock.
It means that those 3 functions encounter on_rq=0 and running=1.
The current task should be put when running.

Here is a possible scenario;
   CPU0                               CPU1
    |                              schedule()
    |                              ->deactivate_task()
    |                              ->idle_balance()
    |                              -->load_balance_newidle()
rt_mutex_setprio()                     |
    |                              --->double_lock_balance()
    *get lock                          *rel lock
    * on_rq=0, ruuning=1               |
    * sched_class is changed           |
    *rel lock                          *get lock
    :                                  |
                                       :
                                   ->put_prev_task_rt()
                                   ->pick_next_task_fair()
                                       => panic

The current process of CPU1(P1) is scheduling. Deactivated P1,
and the scheduler looks for another process on other CPU's runqueue
because CPU1 will be idle. idle_balance(), load_balance_newidle()
and double_lock_balance() are called and double_lock_balance() could
drop the rq lock. On the other hand, CPU0 is trying to boost the
priority of P1. The result of boosting only P1's prio and sched_class
are changed to RT. The sched entities of P1 and P1's group are never
put. It makes cfs_rq invalid, because the cfs_rq has curr and no leaf,
but pick_next_task_fair() is called, then the kernel panics.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 kernel/sched.c |   38 ++++++++++++++++----------------------
 1 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 52b9867..eedf748 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4268,11 +4268,10 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	oldprio = p->prio;
 	on_rq = p->se.on_rq;
 	running = task_current(rq, p);
-	if (on_rq) {
+	if (on_rq)
 		dequeue_task(rq, p, 0);
-		if (running)
-			p->sched_class->put_prev_task(rq, p);
-	}
+	if (running)
+		p->sched_class->put_prev_task(rq, p);
 
 	if (rt_prio(prio))
 		p->sched_class = &rt_sched_class;
@@ -4281,10 +4280,9 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 
 	p->prio = prio;
 
+	if (running)
+		p->sched_class->set_curr_task(rq);
 	if (on_rq) {
-		if (running)
-			p->sched_class->set_curr_task(rq);
-
 		enqueue_task(rq, p, 0);
 
 		check_class_changed(rq, p, prev_class, oldprio, running);
@@ -4581,19 +4579,17 @@ recheck:
 	update_rq_clock(rq);
 	on_rq = p->se.on_rq;
 	running = task_current(rq, p);
-	if (on_rq) {
+	if (on_rq)
 		deactivate_task(rq, p, 0);
-		if (running)
-			p->sched_class->put_prev_task(rq, p);
-	}
+	if (running)
+		p->sched_class->put_prev_task(rq, p);
 
 	oldprio = p->prio;
 	__setscheduler(rq, p, policy, param->sched_priority);
 
+	if (running)
+		p->sched_class->set_curr_task(rq);
 	if (on_rq) {
-		if (running)
-			p->sched_class->set_curr_task(rq);
-
 		activate_task(rq, p, 0);
 
 		check_class_changed(rq, p, prev_class, oldprio, running);
@@ -7617,11 +7613,10 @@ void sched_move_task(struct task_struct *tsk)
 	running = task_current(rq, tsk);
 	on_rq = tsk->se.on_rq;
 
-	if (on_rq) {
+	if (on_rq)
 		dequeue_task(rq, tsk, 0);
-		if (unlikely(running))
-			tsk->sched_class->put_prev_task(rq, tsk);
-	}
+	if (unlikely(running))
+		tsk->sched_class->put_prev_task(rq, tsk);
 
 	set_task_rq(tsk, task_cpu(tsk));
 
@@ -7630,11 +7625,10 @@ void sched_move_task(struct task_struct *tsk)
 		tsk->sched_class->moved_group(tsk);
 #endif
 
-	if (on_rq) {
-		if (unlikely(running))
-			tsk->sched_class->set_curr_task(rq);
+	if (unlikely(running))
+		tsk->sched_class->set_curr_task(rq);
+	if (on_rq)
 		enqueue_task(rq, tsk, 0);
-	}
 
 	task_rq_unlock(rq, &flags);
 }
-- 
1.5.4.1

