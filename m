Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666AbZKLSl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbZKLSl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 13:41:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbZKLSl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 13:41:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbZKLSl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 13:41:26 -0500
Date: Thu, 12 Nov 2009 19:35:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: GPF in run_workqueue()/list_del_init(cwq->worklist.next) on
	resume
Message-ID: <20091112183508.GA14661@redhat.com>
References: <200911091250.31626.rjw@sisk.pl> <200911092145.27485.rjw@sisk.pl> <alpine.LFD.2.01.0911091339290.31845@localhost.localdomain> <200911100119.38019.rjw@sisk.pl> <alpine.LFD.2.01.0911101343590.31845@localhost.localdomain> <4AFA70FB.60706@kernel.org> <20091111181349.GA30638@redhat.com> <4AFB9595.1030002@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFB9595.1030002@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12, Tejun Heo wrote:
>
> Oleg Nesterov wrote:
> >
> > This is even documented, the comment above queue_work() says:
> >
> > 	* We queue the work to the CPU on which it was submitted, but if the CPU dies
> > 	* it can be processed by another CPU.
> >
> > We can improve things, see http://marc.info/?l=linux-kernel&m=125562105103769
> >
> > But then we should also change workqueue_cpu_callback(CPU_POST_DEAD).
> > Instead of flushing, we should carefully move the pending works to
> > another CPU, otherwise the self-requeueing work can block cpu_down().
>
> That looks like an excellent idea and I don't think it will add
> noticeable overhead even done by default and it will magically make
> the "how to implement single-threaded wq semantics in conccurrency
> managed wq" problem go away.  I'll work on it.

I am still not sure all work_structs should single-threaded by default.

To clarify, I am not arguing. Just I don't know. I mean, this change can
break the existing code, and it is not easy to notice the problem.

> If you look at the workqueue code itself very closely, all subtleties
> are properly defined and described.  The problem is that it's not very
> clear and way too subtle when seen from outside and workqueue is
> something used very widely.

Yes, agreed.

> making flush_work() behave as
> flush_work_sync() by default should be doable without too much
> overhead.  I'll give it a shot.

Well, I disagree. Imho it is better to have both flush_work() and
flush_work_sync(). flush_work() is "special" and should be used with
care. But this is minor, and if the work_stuct is single-threaded then
flush_work() == flush_work_sync().

(Perhaps this is what you meant)

> > Not sure this patch will help, but I bet that the actual reason for
> > this bug is much simpler than the subtle races above ;)
>
> And yes it was but still I'm fairly sure unexpected races described
> above are happening.

Yes, sure, I never argued.

My only point was, it is not that workqueues are buggy, they were
designed (and even documented) to work this way. I can't judge if it
was right or not, but personally I think everything is "logical".

That said, I agree that we have too many buggy users, perhaps we
should simplify the rules.

I just noticed that schedule_on_each_cpu() was recently changed by

	HWPOISON: Allow schedule_on_each_cpu() from keventd
	commit: 65a64464349883891e21e74af16c05d6e1eeb4e9

Surprisingly, even this simple change is not exactly right.

	/*
	 * when running in keventd don't schedule a work item on itself.
	 * Can just call directly because the work queue is already bound.
	 * This also is faster.
	 * Make this a generic parameter for other workqueues?
	 */
	if (current_is_keventd()) {
		orig = raw_smp_processor_id();
		INIT_WORK(per_cpu_ptr(works, orig), func);
		func(per_cpu_ptr(works, orig));
	}

OK, but this code should be moved down, under get_online_cpus().

schedule_on_each_cpu() should guarantee that func() can't race with
CPU hotplug, can safely use per-cpu data, etc. That is why flush_work()
is called before put_online_cpus().

Another reason to move this code down is that current_is_keventd()
itself is racy, the "preempt-safe: keventd is per-cpu" comment is not
right. I think do_boot_cpu() case is fine though.

(off-topic, but we can also simplify the code a little bit, the second
 "if (cpu != orig)" is not necessary).


Perhaps you and Linus are right, and we should simplify the rules
unconditionally. But note that the problem above has nothing to do with
single-threaded behaviour, and I do not think it is possible to guarantee
work->func() can't be moved to another CPU.

Oleg.

