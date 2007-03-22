Return-Path: <linux-kernel-owner+w=401wt.eu-S1752577AbXCVWvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbXCVWvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 18:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbXCVWvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 18:51:42 -0400
Received: from mail07.syd.optusnet.com.au ([211.29.132.188]:47663 "EHLO
	mail07.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752577AbXCVWvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 18:51:41 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: RSDL v0.31
Date: Fri, 23 Mar 2007 09:50:50 +1100
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Willy Tarreau <w@1wt.eu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Xavier Bestel <xavier.bestel@free.fr>, Mark Lord <lkml@rtr.ca>,
       Al Boldi <a1426z@gawab.com>, ck@vds.kolivas.org,
       Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200703042335.26785.a1426z@gawab.com> <1174492966.16411.1.camel@twins> <1174547256.7414.129.camel@Homer.simpson.net>
In-Reply-To: <1174547256.7414.129.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703230950.51716.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for taking the time to actually look at the code. All audits are most 
welcome!.

On Thursday 22 March 2007 18:07, Mike Galbraith wrote:
> This is a rather long message, and isn't directed at anyone in
> particular, it's for others who may be digging into their own problems
> with RSDL, and for others (if any other than Con exist) who understand
> RSDL well enough to tell me if I'm missing something.  Anyone who's not
> interested in RSDL's gizzard hit 'D' now.
>
> On Wed, 2007-03-21 at 17:02 +0100, Peter Zijlstra wrote:
> > On Wed, 2007-03-21 at 15:57 +0100, Mike Galbraith wrote:
> > > 'f' is a progglet which sleeps a bit and burns a bit, duration
> > > depending on argument given. 'sh' is a shell 100% hog.  In this
> > > scenario, the argument was set such that 'f' used right at 50% cpu. 
> > > All are started at the same time, and I froze top when the first 'f'
> > > reached 1:00.
> >
> > May one enquire how much CPU the mythical 'f' uses when ran alone? Just
> > to get a gauge for the numbers?
>
> Actually, the numbers are an interesting curiosity point, but not as
> interesting as the fact that the deadline mechanism isn't kicking in.
>
> >From task_running_tick():
>
> 	/*
> 	 * Accounting is performed by both the task and the runqueue. This
> 	 * allows frequently sleeping tasks to get their proper quota of
> 	 * cpu as the runqueue will have their quota still available at
> 	 * the appropriate priority level. It also means frequently waking
> 	 * tasks that might miss the scheduler_tick() will get forced down
> 	 * priority regardless.
> 	 */
> 	if (!--p->time_slice)
> 		task_expired_entitlement(rq, p);
> 	/*
> 	 * We only employ the deadline mechanism if we run over the quota.
> 	 * It allows aliasing problems around the scheduler_tick to be
> 	 * less harmful.
> 	 */
> 	if (!rt_task(p) && --rq_quota(rq, rq->prio_level) < 0) {
> 		if (unlikely(p->first_time_slice))
> 			p->first_time_slice = 0;
> 		rotate_runqueue_priority(rq);
> 		set_tsk_need_resched(p);
> 	}
>
> The reason for ticking both runqueue and task is that you can't sample a
> say 100KHz information stream at 1KHz and reproduce that information
> accurately.  IOW, task time slices "blur" at high switch frequency, you
> can't always hit tasks, so you hit what you _can_ hit every sample, the
> runqueue, to minimize the theoretical effects of time slice theft.
> (I've instrumented this before, and caught fast movers stealing 10s of
> milliseconds in extreme cases.)  Generally speaking, statistics even
> things out very much, the fast mover eventually gets hit, and pays a
> full tick for his sub-tick dip in the pool, so in practice it's not a
> great big hairy deal.
>
> If you can accept that tasks can and do dodge the tick, an imbalance
> between runqueue quota and task quota must occur.  It isn't happening
> here, and the reason appears to be bean counting error, tasks migrate
> but their quotas don't follow.  The first time a task is queued at any
> priority, quota is allocated, task goes to sleep, quota on departed
> runqueue stays behind, task awakens on a different runqueue, allocate
> more quota, repeat.  For migration, there's twist, if you pull an
> expired task, expired tasks don't have a quota yet, so they shouldn't
> screw up bean counting.

I had considered the quota not migrating to the new runqueue but basically it 
screws up the "set quota once and deadline only kicks in if absolutely 
necessary" policy. Migration means some extra quota is left behind on the 
runqueue it left from. It is never a huge extra quota and is reset on major 
rotation which occurs very frequently on rsdl. If I was to carry the quota 
over I would need to deduct p->time_slice from the source runqueue's quota, 
and add it to the target runqueue's quota. The problem there is that once the 
time_slice has been handed out to a task it is my position that I no longer 
trust the task to keep its accounting right and may well have exhausted all 
its quota from the source runqueue and is pulling quota away from tasks that 
haven't used theirs yet.

See below for more on updating prio rotation and adding quota to new runqueue.

>
> >From pull_task():
>
> 	/*
> 	 * If this task has already been running on src_rq this priority
> 	 * cycle, make the new runqueue think it has been on its cycle
> 	 */
> 	if (p->rotation == src_rq->prio_rotation)
> 		p->rotation = this_rq->prio_rotation;
>
> The intent here is clearly that this task continue on the new cpu as if
> nothing has happened.  However, when the task was dequeued, p->array was
> left as it was, points to the last place it was queued.  Stale data.
>
> >From recalc_task_prio(), which is called by enqueue_task():
>
> static void recalc_task_prio(struct task_struct *p, struct rq *rq)
> {
> 	struct prio_array *array = rq->active;
> 	int queue_prio, search_prio;
>
> 	if (p->rotation == rq->prio_rotation) {
> 		if (p->array == array) {
> 			if (p->time_slice && rq_quota(rq, p->prio))
> 				return;
> 		} else if (p->array == rq->expired) {
> 			queue_expired(p, rq);
> 			return;
> 		} else
> 			task_new_array(p, rq);
> 	} else
> 		task_new_array(p, rq);
> 	search_prio = p->static_prio;
> p->rotation was set to this runqueue's prio_rotation, but p->array is
> stale, still points to the old cpu's runqueue, so...
>
> static inline void task_new_array(struct task_struct *p, struct rq *rq)
> {
> 	bitmap_zero(p->bitmap, PRIO_RANGE);
> 	p->rotation = rq->prio_rotation;
> }
>
> p->bitmap is the history of all priorities where this task has been
> allocated a quota.  Here, that history is erased, so the task can't
> continue it's staircase walk.  It is instead given a new runqueue quota
> and time_slice (didn't it just gain ticks?).  Now, what if a cross-cpu
> wakeup or migrating task _didn't_ have a stale array pointer, rather it
> pointed to the current active array, _and_ there were no quota available
> at it's priority?  It didn't bring any of it's old quota with it after
> all.  In that case, it would fall through as well, and get the full new
> time_slice and runqueue quota treatment.

Cross cpu migrating task can't have p->array pointing to the new runqueue's 
active array by any means, but fork and friends could. The other point about 
cross cpu history having the wrong effect though is most valid. Good 
spotting! While it's unlikely this could cause an oops... you never know so 
hopefully fixing this will fix Andy's bug.

> The next logical step if the above is correct is obvious.  If it's not,
> really bad things are going to happen here shortly :)

Now to figure out some meaningful cheap way of improving this accounting.

> 	-Mike (broom and dustpan at the ready)

Thanks again!

-- 
-ck
