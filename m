Return-Path: <linux-kernel-owner+w=401wt.eu-S934309AbZDATte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934309AbZDATte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 15:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759719AbZDATtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 15:49:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43138 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759316AbZDATtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 15:49:18 -0400
Date: Wed, 1 Apr 2009 21:45:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Markus Metzger <markus.t.metzger@intel.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
       markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com,
       juan.villacis@intel.com, ak@linux.jf.intel.com
Subject: Re: [patch 3/21] x86, bts: wait until traced task has been
	scheduled out
Message-ID: <20090401194511.GB16033@redhat.com>
References: <20090331145947.A12565@sedona.ch.intel.com> <20090401001729.GC28228@redhat.com> <20090401114140.GB23678@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401114140.GB23678@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> > On 03/31, Markus Metzger wrote:
> > >
> > > +static void wait_to_unschedule(struct task_struct *task)
> > > +{
> > > +	unsigned long nvcsw;
> > > +	unsigned long nivcsw;
> > > +
> > > +	if (!task)
> > > +		return;
> > > +
> > > +	if (task == current)
> > > +		return;
> > > +
> > > +	nvcsw  = task->nvcsw;
> > > +	nivcsw = task->nivcsw;
> > > +	for (;;) {
> > > +		if (!task_is_running(task))
> > > +			break;
> > > +		/*
> > > +		 * The switch count is incremented before the actual
> > > +		 * context switch. We thus wait for two switches to be
> > > +		 * sure at least one completed.
> > > +		 */
> > > +		if ((task->nvcsw - nvcsw) > 1)
> > > +			break;
> > > +		if ((task->nivcsw - nivcsw) > 1)
> > > +			break;
> > > +
> > > +		schedule();
> >
> > schedule() is a nop here. We can wait unpredictably long...
> >
> > Ingo, do have have any ideas to improve this helper?
>
> hm, there's a similar looking existing facility:
> wait_task_inactive(). Have i missed some subtle detail that makes it
> inappropriate for use here?

Yes, there are similar, but still different.

wait_to_unschedule(task) waits until this task does context switch at
least once. It is fine if this task runs again when wait_to_unschedule()
returns. (if !task_is_running(task), it already did context switch).

wait_task_inactive() ensures that this task is deactivated. It can't be
used here, because it can "never" be deactivated.

> > 	int force_unschedule(struct task_struct *p)
> > 	{
> > 		struct rq *rq;
> > 		unsigned long flags;
> > 		int running;
> >
> > 		rq = task_rq_lock(p, &flags);
> > 		running = task_running(rq, p);
> > 		task_rq_unlock(rq, &flags);
> >
> > 		if (running)
> > 			wake_up_process(rq->migration_thread);
> >
> > 		return running;
> > 	}
> >
> > which should be used instead of task_is_running() ?
>
> Yes - wait_task_inactive() should be switched to a scheme like that

Yes, I thought about this, perhaps we can improve wait_task_inactive()
a bit. Unfortunately, this is not enough to kill schedule_timeout(1).

> - it would fix bugs like:
>
>   53da1d9: fix ptrace slowness

I don't think so. Quite contrary, the problem with "fix ptrace slowness"
is that we do not want the TASK_TRACED task to be preempted before it
does the voluntary schedule() (without PREEMPT_ACTIVE).

> > 	void wait_to_unschedule(struct task_struct *task)
> > 	{
> > 		struct migration_req req;
> >
> > 		rq = task_rq_lock(p, &task);
> > 		running = task_running(rq, p);
> > 		if (running) {
> > 			// make sure __migrate_task() will do nothing
> > 			req->dest_cpu = NR_CPUS + 1;
> > 			init_completion(&req->done);
> > 			list_add(&req->list, &rq->migration_queue);
> > 		}
> > 		task_rq_unlock(rq, &flags);
> >
> > 		if (running) {
> > 			wake_up_process(rq->migration_thread);
> > 			wait_for_completion(&req.done);
> > 		}
> > 	}
> >
> > This way we don't poll, and we need only one helper.
>
> Looks even better. The migration thread would run complete(), right?

Yes,

> A detail: i suspect this needs to be in a while() loop, for the case
> that the victim task raced with us and went to another CPU before we
> kicked it off via the migration thread.

I think this doesn't matter. If the task is not running - we don't
care and do nothing. If it is running and migrates - it should do
a context switch at least once.

But the code above is not right wrt cpu hotplug. wake_up_process()
can hit the NULL rq->migration_thread if we race with CPU_DEAD.

Hmm. don't we have this problem in, say, set_cpus_allowed_ptr() ?
Unless it is called without get_online_cpus(), ->migration_thread
can go away once we drop rq->lock.

Perhaps, we need something like this

	--- kernel/sched.c
	+++ kernel/sched.c
	@@ -6132,8 +6132,10 @@ int set_cpus_allowed_ptr(struct task_str
	 
		if (migrate_task(p, cpumask_any_and(cpu_online_mask, new_mask), &req)) {
			/* Need help from migration thread: drop lock and wait. */
	+		preempt_disable();
			task_rq_unlock(rq, &flags);
			wake_up_process(rq->migration_thread);
	+		preempt_enable();
			wait_for_completion(&req.done);
			tlb_migrate_finish(p->mm);
			return 0;

?

Oleg.

