Return-Path: <linux-kernel-owner+w=401wt.eu-S1763451AbZDALmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763451AbZDALmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756549AbZDALmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:42:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38636 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935AbZDALmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:42:03 -0400
Date: Wed, 1 Apr 2009 13:41:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Markus Metzger <markus.t.metzger@intel.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@zytor.com, markus.t.metzger@gmail.com,
       roland@redhat.com, eranian@googlemail.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: Re: [patch 3/21] x86, bts: wait until traced task has been
	scheduled out
Message-ID: <20090401114140.GB23678@elte.hu>
References: <20090331145947.A12565@sedona.ch.intel.com> <20090401001729.GC28228@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401001729.GC28228@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 03/31, Markus Metzger wrote:
> >
> > +static void wait_to_unschedule(struct task_struct *task)
> > +{
> > +	unsigned long nvcsw;
> > +	unsigned long nivcsw;
> > +
> > +	if (!task)
> > +		return;
> > +
> > +	if (task == current)
> > +		return;
> > +
> > +	nvcsw  = task->nvcsw;
> > +	nivcsw = task->nivcsw;
> > +	for (;;) {
> > +		if (!task_is_running(task))
> > +			break;
> > +		/*
> > +		 * The switch count is incremented before the actual
> > +		 * context switch. We thus wait for two switches to be
> > +		 * sure at least one completed.
> > +		 */
> > +		if ((task->nvcsw - nvcsw) > 1)
> > +			break;
> > +		if ((task->nivcsw - nivcsw) > 1)
> > +			break;
> > +
> > +		schedule();
> 
> schedule() is a nop here. We can wait unpredictably long...
> 
> Ingo, do have have any ideas to improve this helper?

hm, there's a similar looking existing facility: 
wait_task_inactive(). Have i missed some subtle detail that makes it 
inappropriate for use here?

> Not that I really like it, but how about
> 
> 	int force_unschedule(struct task_struct *p)
> 	{
> 		struct rq *rq;
> 		unsigned long flags;
> 		int running;
> 
> 		rq = task_rq_lock(p, &flags);
> 		running = task_running(rq, p);
> 		task_rq_unlock(rq, &flags);
> 
> 		if (running)
> 			wake_up_process(rq->migration_thread);
> 
> 		return running;
> 	}
> 
> which should be used instead of task_is_running() ?

Yes - wait_task_inactive() should be switched to a scheme like that 
- it would fix bugs like:

  53da1d9: fix ptrace slowness

in a cleaner way.

> We can even do something like
> 
> 	void wait_to_unschedule(struct task_struct *task)
> 	{
> 		struct migration_req req;
> 
> 		rq = task_rq_lock(p, &task);
> 		running = task_running(rq, p);
> 		if (running) {
> 			// make sure __migrate_task() will do nothing
> 			req->dest_cpu = NR_CPUS + 1;
> 			init_completion(&req->done);
> 			list_add(&req->list, &rq->migration_queue);
> 		}
> 		task_rq_unlock(rq, &flags);
> 
> 		if (running) {
> 			wake_up_process(rq->migration_thread);
> 			wait_for_completion(&req.done);
> 		}
> 	}
> 
> This way we don't poll, and we need only one helper.

Looks even better. The migration thread would run complete(), right?

A detail: i suspect this needs to be in a while() loop, for the case 
that the victim task raced with us and went to another CPU before we 
kicked it off via the migration thread.

This looks very useful to me. It could also be tested easily: revert 
53da1d9 and you should see:

   time strace dd if=/dev/zero of=/dev/null bs=1024 count=1000000

performance plummet on an SMP box. The with your fix it should go up 
to near full speed again.

	Ingo
