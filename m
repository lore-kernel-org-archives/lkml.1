Return-Path: <linux-kernel-owner+w=401wt.eu-S1758386AbZKKSVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386AbZKKSVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 13:21:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758360AbZKKSVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 13:21:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758294AbZKKSVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 13:21:05 -0500
Date: Wed, 11 Nov 2009 19:13:49 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: GPF in run_workqueue()/list_del_init(cwq->worklist.next) on
	resume
Message-ID: <20091111181349.GA30638@redhat.com>
References: <200911091250.31626.rjw@sisk.pl> <200911092145.27485.rjw@sisk.pl> <alpine.LFD.2.01.0911091339290.31845@localhost.localdomain> <200911100119.38019.rjw@sisk.pl> <alpine.LFD.2.01.0911101343590.31845@localhost.localdomain> <4AFA70FB.60706@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFA70FB.60706@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11, Tejun Heo wrote:
>
> One thing that I can think of which might cause this early release is
> self-requeueing works which assume that only one instance of the
> function will be executed at any given time.  While preparing to bring
> down a cpu, worker threads are unbound from the cpu.  After cpu is
> brought down, the workqueue for that cpu is flushed.  This means that
> any work which was running or on queue at the time of cpu down will
> run on a different cpu.  So, let's assume there's a work function
> which looks like the following,
>
> void my_work_fn(struct work_struct *work)
> {
> 	struct my_struct *me = container_of(work, something...);
>
> 	DO SOMETHING;
>
> 	if (--me->todo)
> 		schedule_work(work);
> 	else
> 		free(me);
> }
>
> Which will work perfectly as long as all cpus stay alive as the work
> will be pinned on a single cpu and cwq guarantees that a single work
> is never executed in parallel.  However, if a cpu is brought down
> while my_work_fn() was doing SOMETHING and me->todo was above 1,
> schedule_work() will schedule itself to a different cpu which will
> happily execute the work in parallel.
>
> As worker threads become unbound, they may bounce among different cpus
> while executing and create more than two instances

Well, "more than two instances" is not possible in this particular
case.

But in general I agree. If a self-requeueing work assumes it stays on
the same CPU or it assumes it can never race with itself, it should hook
CPU_DOWN_PREPARE and cancel the work. Like slab.c does with reap_work.

This is even documented, the comment above queue_work() says:

	* We queue the work to the CPU on which it was submitted, but if the CPU dies
	* it can be processed by another CPU.

We can improve things, see http://marc.info/?l=linux-kernel&m=125562105103769

But then we should also change workqueue_cpu_callback(CPU_POST_DEAD).
Instead of flushing, we should carefully move the pending works to
another CPU, otherwise the self-requeueing work can block cpu_down().

> Another related issue is the behavior flush_work() when a work ends up
> scheduled on a different cpu.  flush_work() will only look at a single
> cpu workqueue on each flush attempt and if the work is not on the cpu
> or there but also running on other cpus, it won't do nothing about it.
> So, it's not too difficult to write code where the caller incorrectly
> assumes the work is done after flush_work() is finished while the work
> actually ended up being scheduled on a different cpu.

Yes, flush_work() is not even supposed to work "correctly" in this case.
Please note the changelog for db700897224b5ebdf852f2d38920ce428940d059
In particular:

	More precisely, it "flushes" the result of of the last
	queue_work() which is visible to the caller.

but we can add flush_work_sync().

But flush_work() do not have too much callers. Instead people often
use flush_workqueue() which just can't help if the work_struct is
self-requeueing or if it is delayed_work.

> One way to debug I can think of is to record work pointer -> function
> mapping in a percpu ring buffer

We can record work->func in work->entry.prev, which is either another
work or cwq. Please see the debugging patch I sent.

Not sure this patch will help, but I bet that the actual reason for
this bug is much simpler than the subtle races above ;)

Oleg.

