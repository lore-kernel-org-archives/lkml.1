Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbXCVHHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbXCVHHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 03:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbXCVHHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 03:07:50 -0400
Received: from mail.gmx.net ([213.165.64.20]:42589 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753219AbXCVHHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 03:07:48 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18NmQdW1HgNXRImSFnEtLO50W4HzrmLYSwcW0e/QR
	n5LTP9MMTo4JYe
Subject: Re: RSDL v0.31
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Willy Tarreau <w@1wt.eu>, Linus Torvalds <torvalds@linux-foundation.org>,
       Xavier Bestel <xavier.bestel@free.fr>, Mark Lord <lkml@rtr.ca>,
       Al Boldi <a1426z@gawab.com>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1174492966.16411.1.camel@twins>
References: <200703042335.26785.a1426z@gawab.com>
	 <200703172048.46267.kernel@kolivas.org>
	 <1174125534.7734.2.camel@Homer.simpson.net>
	 <200703172355.30989.a1426z@gawab.com> <45FEB54A.3040602@rtr.ca>
	 <1174321617.30876.69.camel@frg-rhel40-em64t-04> <45FEBBF5.9060002@rtr.ca>
	 <1174322580.30876.72.camel@frg-rhel40-em64t-04>
	 <Pine.LNX.4.64.0703192006130.6730@woody.linux-foundation.org>
	 <20070320061152.GW943@1wt.eu>  <1174377787.9756.21.camel@Homer.simpson.net>
	 <1174489064.5379.42.camel@Homer.simpson.net>
	 <1174492966.16411.1.camel@twins>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 08:07:36 +0100
Message-Id: <1174547256.7414.129.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a rather long message, and isn't directed at anyone in
particular, it's for others who may be digging into their own problems
with RSDL, and for others (if any other than Con exist) who understand
RSDL well enough to tell me if I'm missing something.  Anyone who's not
interested in RSDL's gizzard hit 'D' now.

On Wed, 2007-03-21 at 17:02 +0100, Peter Zijlstra wrote:
> On Wed, 2007-03-21 at 15:57 +0100, Mike Galbraith wrote:
> 
> > 'f' is a progglet which sleeps a bit and burns a bit, duration depending
> > on argument given. 'sh' is a shell 100% hog.  In this scenario, the
> > argument was set such that 'f' used right at 50% cpu.  All are started
> > at the same time, and I froze top when the first 'f' reached 1:00.
> 
> May one enquire how much CPU the mythical 'f' uses when ran alone? Just
> to get a gauge for the numbers?

Actually, the numbers are an interesting curiosity point, but not as
interesting as the fact that the deadline mechanism isn't kicking in.

>From task_running_tick():
	/*
	 * Accounting is performed by both the task and the runqueue. This
	 * allows frequently sleeping tasks to get their proper quota of
	 * cpu as the runqueue will have their quota still available at
	 * the appropriate priority level. It also means frequently waking
	 * tasks that might miss the scheduler_tick() will get forced down
	 * priority regardless.
	 */
	if (!--p->time_slice)
		task_expired_entitlement(rq, p);
	/*
	 * We only employ the deadline mechanism if we run over the quota.
	 * It allows aliasing problems around the scheduler_tick to be
	 * less harmful.
	 */
	if (!rt_task(p) && --rq_quota(rq, rq->prio_level) < 0) {
		if (unlikely(p->first_time_slice))
			p->first_time_slice = 0;
		rotate_runqueue_priority(rq);
		set_tsk_need_resched(p);
	}

The reason for ticking both runqueue and task is that you can't sample a
say 100KHz information stream at 1KHz and reproduce that information
accurately.  IOW, task time slices "blur" at high switch frequency, you
can't always hit tasks, so you hit what you _can_ hit every sample, the
runqueue, to minimize the theoretical effects of time slice theft.
(I've instrumented this before, and caught fast movers stealing 10s of
milliseconds in extreme cases.)  Generally speaking, statistics even
things out very much, the fast mover eventually gets hit, and pays a
full tick for his sub-tick dip in the pool, so in practice it's not a
great big hairy deal.

If you can accept that tasks can and do dodge the tick, an imbalance
between runqueue quota and task quota must occur.  It isn't happening
here, and the reason appears to be bean counting error, tasks migrate
but their quotas don't follow.  The first time a task is queued at any
priority, quota is allocated, task goes to sleep, quota on departed
runqueue stays behind, task awakens on a different runqueue, allocate
more quota, repeat.  For migration, there's twist, if you pull an
expired task, expired tasks don't have a quota yet, so they shouldn't
screw up bean counting.

>From pull_task():
	/*
	 * If this task has already been running on src_rq this priority
	 * cycle, make the new runqueue think it has been on its cycle
	 */
	if (p->rotation == src_rq->prio_rotation)
		p->rotation = this_rq->prio_rotation;

The intent here is clearly that this task continue on the new cpu as if
nothing has happened.  However, when the task was dequeued, p->array was
left as it was, points to the last place it was queued.  Stale data.

>From recalc_task_prio(), which is called by enqueue_task():
static void recalc_task_prio(struct task_struct *p, struct rq *rq)
{
	struct prio_array *array = rq->active;
	int queue_prio, search_prio;

	if (p->rotation == rq->prio_rotation) {
		if (p->array == array) {
			if (p->time_slice && rq_quota(rq, p->prio))
				return;
		} else if (p->array == rq->expired) {
			queue_expired(p, rq);
			return;
		} else
			task_new_array(p, rq);
	} else
		task_new_array(p, rq);
	search_prio = p->static_prio;

p->rotation was set to this runqueue's prio_rotation, but p->array is
stale, still points to the old cpu's runqueue, so...

static inline void task_new_array(struct task_struct *p, struct rq *rq)
{
	bitmap_zero(p->bitmap, PRIO_RANGE);
	p->rotation = rq->prio_rotation;
}

p->bitmap is the history of all priorities where this task has been
allocated a quota.  Here, that history is erased, so the task can't
continue it's staircase walk.  It is instead given a new runqueue quota
and time_slice (didn't it just gain ticks?).  Now, what if a cross-cpu
wakeup or migrating task _didn't_ have a stale array pointer, rather it
pointed to the current active array, _and_ there were no quota available
at it's priority?  It didn't bring any of it's old quota with it after
all.  In that case, it would fall through as well, and get the full new
time_slice and runqueue quota treatment.

The next logical step if the above is correct is obvious.  If it's not,
really bad things are going to happen here shortly :)

	-Mike (broom and dustpan at the ready)

