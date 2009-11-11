Return-Path: <linux-kernel-owner+w=401wt.eu-S1757492AbZKKRYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbZKKRYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 12:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756300AbZKKRYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 12:24:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757216AbZKKRYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 12:24:15 -0500
Date: Wed, 11 Nov 2009 18:17:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Tejun Heo <tj@kernel.org>
Subject: Re: GPF in run_workqueue()/list_del_init(cwq->worklist.next) on
	resume (was: Re: Help needed: Resume problems in 2.6.32-rc, perhaps
	related to preempt_count leakage in keventd)
Message-ID: <20091111171703.GA28506@redhat.com>
References: <200911091250.31626.rjw@sisk.pl> <200911092145.27485.rjw@sisk.pl> <alpine.LFD.2.01.0911091339290.31845@localhost.localdomain> <200911100119.38019.rjw@sisk.pl> <alpine.LFD.2.01.0911101343590.31845@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0911101343590.31845@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10, Linus Torvalds wrote:
>
> And the code really is pretty subtle. queue_delayed_work_on(), for
> example, uses raw_smp_processor_id() to basically pick a target CPU for
> the work ("whatever the CPU happens to be now"). But does that have to
> match the CPU that the timeout will trigger on?

Yes, but this doesn't matter.

	queue_delayed_work_on() does:
		
		/* This stores cwq for the moment, for the timer_fn */
		set_wq_data(work, wq_per_cpu(wq, raw_smp_processor_id()));

this is only needed to ensure that delayed_work_timer_fn() which does

	struct cpu_workqueue_struct *cwq = get_wq_data(&dwork->work);
	struct workqueue_struct *wq = cwq->wq;

gets the correct workqueue_struct, cpu_workqueue_struct can be "wrong"
and even destroyed. queue_delayed_work_on() could use any CPU from
cpu_possible_mask instead of raw_smp_processor_id().

I still owe you the promised changes which should fix the problems
with the "overlapping" works (although I don't agree we never want
to run the same work entry on multiple CPU's at once, so I am not
sure work_struct's should be always "single-threaded"), and the very
first change will be

	--- a/kernel/workqueue.c
	+++ b/kernel/workqueue.c
	@@ -246,7 +246,8 @@ int queue_delayed_work_on(int cpu, struc
			timer_stats_timer_set_start_info(&dwork->timer);
	 
			/* This stores cwq for the moment, for the timer_fn */
	-		set_wq_data(work, wq_per_cpu(wq, raw_smp_processor_id()));
	+		if (!get_wq_data(work))
	+			set_wq_data(work, wq_per_cpu(wq, raw_smp_processor_id()));
			timer->expires = jiffies + delay;
			timer->data = (unsigned long)dwork;
			timer->function = delayed_work_timer_fn;

except this change is not always right. Not only the same work_struct
can run on multiple CPU's, it can run on different workqueues. Perhaps
nobody does this, but this is possible.

IOW, I agree it makes sense to introcude WORK_STRUCT_SINGLE_THREADED flag,
and perhaps it can be even set by default (not sure), but in any case I
think we need work_{set,clear}_single_threaded().

> The workqueue code is very fragile in many ways.

Well, yes. Because any buggy user can easily kill the system, and we
constantly have the bugs like this one.

I think we should teach workqueue.c to use debugobjects.c at least.

But otherwise I don't see how we can improve things very much. The
problem is not that the code itself is fragile, just it has a lot
of buggy users. Once queue_work(work) adds this work to ->worklist
the kernel depends on the owner of this work, it can crash the kernel
in many ways.

Oleg.

