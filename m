Return-Path: <linux-kernel-owner+w=401wt.eu-S1764686AbYCUW6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764686AbYCUW6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762982AbYCUWuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:50:46 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:59268 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763720AbYCUWun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:50:43 -0400
Message-Id: <20080321224443.783675702@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:53 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Subject: [patch 63/76] sched: fix race in schedule()
Content-Disposition: inline; filename=sched-fix-race-in-schedule.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Fix a hard to trigger crash seen in the -rt kernel that also affects
the vanilla scheduler.

There is a race condition between schedule() and some dequeue/enqueue
functions; rt_mutex_setprio(), __setscheduler() and sched_move_task().

When scheduling to idle, idle_balance() is called to pull tasks from
other busy processor. It might drop the rq lock. It means that those 3
functions encounter on_rq=0 and running=1. The current task should be
put when running.

Here is a possible scenario:

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

The current process of CPU1(P1) is scheduling. Deactivated P1, and the
scheduler looks for another process on other CPU's runqueue because CPU1
will be idle. idle_balance(), load_balance_newidle() and
double_lock_balance() are called and double_lock_balance() could drop
the rq lock. On the other hand, CPU0 is trying to boost the priority of
P1. The result of boosting only P1's prio and sched_class are changed to
RT. The sched entities of P1 and P1's group are never put. It makes
cfs_rq invalid, because the cfs_rq has curr and no leaf, but
pick_next_task_fair() is called, then the kernel panics.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
[chrisw@sous-sol.org: backport to 2.6.24.3]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |   36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4028,11 +4028,10 @@ void rt_mutex_setprio(struct task_struct
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
@@ -4041,9 +4040,9 @@ void rt_mutex_setprio(struct task_struct
 
 	p->prio = prio;
 
+	if (running)
+		p->sched_class->set_curr_task(rq);
 	if (on_rq) {
-		if (running)
-			p->sched_class->set_curr_task(rq);
 		enqueue_task(rq, p, 0);
 		/*
 		 * Reschedule if we are currently running on this runqueue and
@@ -4339,18 +4338,17 @@ recheck:
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
 		activate_task(rq, p, 0);
 		/*
 		 * Reschedule if we are currently running on this runqueue and
@@ -7110,19 +7108,17 @@ void sched_move_task(struct task_struct 
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
 
 	set_task_cfs_rq(tsk, task_cpu(tsk));
 
-	if (on_rq) {
-		if (unlikely(running))
-			tsk->sched_class->set_curr_task(rq);
+	if (unlikely(running))
+		tsk->sched_class->set_curr_task(rq);
+	if (on_rq)
 		enqueue_task(rq, tsk, 0);
-	}
 
 done:
 	task_rq_unlock(rq, &flags);

-- 
