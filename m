Return-Path: <linux-kernel-owner+w=401wt.eu-S1755820AbYCJUes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbYCJUes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 16:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbYCJUek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 16:34:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55237 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbYCJUej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 16:34:39 -0400
Subject: Re: [PATCH] sched: fix race in schedule
From: Peter Zijlstra <peterz@infradead.org>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, hpj@urpla.net,
       stable <stable@kernel.org>
In-Reply-To: <47D593A5.5060906@ct.jp.nec.com>
References: <47D57770.50909@ct.jp.nec.com> <1205174197.8514.159.camel@twins>
	 <47D593A5.5060906@ct.jp.nec.com>
Content-Type: text/plain
Date: Mon, 10 Mar 2008 21:34:16 +0100
Message-Id: <1205181256.6241.320.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-03-10 at 13:01 -0700, Hiroshi Shimamoto wrote:

> thanks, your patch looks nice to me.
> I had focused setprio, on_rq=0 and running=1 situation, it makes me to
> fix these functions.
> But one point, I've just noticed. I'm not sure on same situation against
> sched_rt. I think the pre_schedule() of rt has chance to drop rq lock.
> Is it OK?

Ah, you are quite right, that'll teach me to rush out a patch just
because dinner is ready :-). 

How about we submit the following patch for mainline and CC -stable to
fix .23 and .24:

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
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: stable@kernel.org
---
 kernel/sched.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6-2/kernel/sched.c
===================================================================
--- linux-2.6-2.orig/kernel/sched.c
+++ linux-2.6-2/kernel/sched.c
@@ -4062,6 +4062,13 @@ need_resched_nonpreemptible:
 		switch_count = &prev->nvcsw;
 	}
 
+	/*
+	 * ->pre_schedule() and idle_balance() can release the rq->lock so we
+	 * have to call ->put_prev_task() before we do the balancing calls,
+	 * otherwise its possible to see the rq in an inconsistent state.
+	 */
+	prev->sched_class->put_prev_task(rq, prev);
+
 #ifdef CONFIG_SMP
 	if (prev->sched_class->pre_schedule)
 		prev->sched_class->pre_schedule(rq, prev);
@@ -4070,7 +4077,6 @@ need_resched_nonpreemptible:
 	if (unlikely(!rq->nr_running))
 		idle_balance(cpu, rq);
 
-	prev->sched_class->put_prev_task(rq, prev);
 	next = pick_next_task(rq, prev);
 
 	sched_info_switch(prev, next);


