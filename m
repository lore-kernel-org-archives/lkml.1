Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbYCLN3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbYCLN3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 09:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbYCLN1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 09:27:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34043 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbYCLN1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 09:27:47 -0400
Subject: Re: [PATCH] sched: fix race in schedule
From: Peter Zijlstra <peterz@infradead.org>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       hpj@urpla.net, stable <stable@kernel.org>
In-Reply-To: <b647ffbd0803111638sdc92903r7faad3d4b2b6b842@mail.gmail.com>
References: <47D57770.50909@ct.jp.nec.com> <1205174197.8514.159.camel@twins>
	 <47D593A5.5060906@ct.jp.nec.com> <1205181256.6241.320.camel@lappy>
	 <47D5EA9C.1040404@ct.jp.nec.com> <1205224835.8514.183.camel@twins>
	 <47D6BD0C.6070401@ct.jp.nec.com>
	 <b647ffbd0803111638sdc92903r7faad3d4b2b6b842@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 12 Mar 2008 14:27:37 +0100
Message-Id: <1205328457.8514.244.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-12 at 00:38 +0100, Dmitry Adamushko wrote:
> On 11/03/2008, Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
> > Peter Zijlstra wrote:
> >  > On Mon, 2008-03-10 at 19:12 -0700, Hiroshi Shimamoto wrote:
> >  >> Peter Zijlstra wrote:
> >  >>> On Mon, 2008-03-10 at 13:01 -0700, Hiroshi Shimamoto wrote:
> >  >>>
> >  >>>> thanks, your patch looks nice to me.
> >  >>>> I had focused setprio, on_rq=0 and running=1 situation, it makes me to
> >  >>>> fix these functions.
> >  >>>> But one point, I've just noticed. I'm not sure on same situation against
> >  >>>> sched_rt. I think the pre_schedule() of rt has chance to drop rq lock.
> >  >>>> Is it OK?
> >  >>> Ah, you are quite right, that'll teach me to rush out a patch just
> >  >>> because dinner is ready :-).
> >  >>>
> >  >>> How about we submit the following patch for mainline and CC -stable to
> >  >>> fix .23 and .24:
> >  >>>
> >  >> Unfortunately, I encountered similar panic with this patch on -rt.
> >  >> I'll look into this, again. I might have missed something...
> >  >>
> >  >> Unable to handle kernel NULL pointer dereference at 0000000000000128 RIP:
> >  >>  [<ffffffff802297f5>] pick_next_task_fair+0x2d/0x42
> >  >
> >  > :-(
> >  >
> >  > OK, so that means I'm not getting it.
> >  >
> >  > So what does your patch do that mine doesn't?
> >  >
> >  > It removes the dependency of running (=task_current()) from on_rq
> >  > (p->se.on_rq).
> >  >
> >  > So how can a current task not be on the runqueue?
> >  >
> >  > Only sched.c:dequeue_task() and sched_fair.c:account_entity_dequeue()
> >  > set on_rq to 0, the only one changing rq->curr is schedule().
> >  >
> >  > So the only scheme I can come up with is that we did dequeue p (on_rq ==
> >  > 0), but we didn't yet schedule so rq->curr == p.
> >  >
> >  > Is this how you ended up with your previuos analysis that it must be due
> >  > to a hole introduced by double_lock_balance()?
> >  >
> >  > Because now we can seemingly call deactivate_task() and put_prev_task()
> >  > in non-atomic fashion, but by placing the put_prev_task() before the
> >  > load balance calls we should avoid doing that.
> >  >
> >  > So what else is going on... /me puzzled
> >
> >
> > thanks for taking time.
> >  I've tested it with debug tracer, it took several hours to half day to
> >  reproduce it on my box. And I got the possible scenario.
> >
> >  Before begin, I can tell that se->on_rq is changed at enqueue_task() or
> >  dequeue_task() in sched.c.
> >
> >  Here is the flow to panic which I got;
> >
> >    CPU0                               CPU1
> >     |                              schedule()
> >     |                              ->deactivate_task()
> >
> >     |                              -->dequeue_task()
> >     |                                  * on_rq=0
> >     |                              ->put_prev_task_fair()
> >
> >     |                              ->idle_balance()
> >     |                              -->load_balance_newidle()
> >
> > (a wakeup function)                    |
> >
> >     |                              --->double_lock_balance()
> >     *get lock                          *rel lock
> >
> >     * wake up target is CPU1's curr    |
> >  ->enqueue_task()                      |
> >     * on_rq=1                          |
> >  ->rt_mutex_setprio()                  |
> >     * on_rq=1, ruuning=1               |
> >  -->dequeue_task()!!                   |
> >  -->put_prev_task_fair()!!             |
> 
> humm... this one should have caused the problem.
> 
> ->put_prev_task() has been previously done in schedule() so we get 2
> consequent ->put_prev_task() without set_curr_task/pick_next_task()
> being called in between
> [ as a result, __enqueue_entitty() is called twice for CPU1's curr and
> that definitely corrupts an rb-tree ]
> 
> your initial patch doesn't have this problem. humm... logically-wise,
> it looks like a change of the 'current' which can be expressed by a
> pair :
> 
> (1) put_prev_task() + (2) pick_next_task() or set_curr_task()
> (both end up calling set_next_entity())
> 
> has to be 'atomic' wrt the rq->lock.
> 
> For schedule() that also involves a change of rq->curr.

Right, this seems to 'rely' on rq->curr lagging behind put_prev_task().
So by doing something like:

---
diff --git a/kernel/sched.c b/kernel/sched.c
index a0c79e9..62d796f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4061,6 +4061,8 @@ need_resched_nonpreemptible:
 		}
 		switch_count = &prev->nvcsw;
 	}
+	prev->sched_class->put_prev_task(rq, prev);
+	rq->curr = rq->idle;
 
 #ifdef CONFIG_SMP
 	if (prev->sched_class->pre_schedule)
@@ -4070,14 +4072,13 @@ need_resched_nonpreemptible:
 	if (unlikely(!rq->nr_running))
 		idle_balance(cpu, rq);
 
-	prev->sched_class->put_prev_task(rq, prev);
 	next = pick_next_task(rq, prev);
+	rq->curr = next;
 
 	sched_info_switch(prev, next);
 
 	if (likely(prev != next)) {
 		rq->nr_switches++;
-		rq->curr = next;
 		++*switch_count;
 
 		context_switch(rq, prev, next); /* unlocks the rq */
---

We would avoid being considered running while we're not.

We set rq->curr to rq->idle, because rq->curr is assumed valid at all
times. Also, should we clear TIF_NEED_RESCHED right before
pick_next_task()?

> Your initial patch seems to qualify for this rule... but I'm still
> thinking whether the current scheme is a bit 'hairy' :-/

I'm not liking the initial patch much because it allows for a situation
where we're not on the RQ but are considered running. That just doesn't
make sense to me.

