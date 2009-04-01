Return-Path: <linux-kernel-owner+w=401wt.eu-S1765662AbZDAAWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765662AbZDAAWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 20:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763490AbZDAAVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 20:21:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56745 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765471AbZDAAVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 20:21:16 -0400
Date: Wed, 1 Apr 2009 02:17:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, juan.villacis@intel.com, ak@linux.jf.intel.com
Subject: Re: [patch 3/21] x86, bts: wait until traced task has been
	scheduled out
Message-ID: <20090401001729.GC28228@redhat.com>
References: <20090331145947.A12565@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090331145947.A12565@sedona.ch.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31, Markus Metzger wrote:
>
> +static void wait_to_unschedule(struct task_struct *task)
> +{
> +	unsigned long nvcsw;
> +	unsigned long nivcsw;
> +
> +	if (!task)
> +		return;
> +
> +	if (task == current)
> +		return;
> +
> +	nvcsw  = task->nvcsw;
> +	nivcsw = task->nivcsw;
> +	for (;;) {
> +		if (!task_is_running(task))
> +			break;
> +		/*
> +		 * The switch count is incremented before the actual
> +		 * context switch. We thus wait for two switches to be
> +		 * sure at least one completed.
> +		 */
> +		if ((task->nvcsw - nvcsw) > 1)
> +			break;
> +		if ((task->nivcsw - nivcsw) > 1)
> +			break;
> +
> +		schedule();

schedule() is a nop here. We can wait unpredictably long...

Ingo, do have have any ideas to improve this helper?

Not that I really like it, but how about

	int force_unschedule(struct task_struct *p)
	{
		struct rq *rq;
		unsigned long flags;
		int running;

		rq = task_rq_lock(p, &flags);
		running = task_running(rq, p);
		task_rq_unlock(rq, &flags);

		if (running)
			wake_up_process(rq->migration_thread);

		return running;
	}

which should be used instead of task_is_running() ?


We can even do something like

	void wait_to_unschedule(struct task_struct *task)
	{
		struct migration_req req;

		rq = task_rq_lock(p, &task);
		running = task_running(rq, p);
		if (running) {
			// make sure __migrate_task() will do nothing
			req->dest_cpu = NR_CPUS + 1;
			init_completion(&req->done);
			list_add(&req->list, &rq->migration_queue);
		}
		task_rq_unlock(rq, &flags);

		if (running) {
			wake_up_process(rq->migration_thread);
			wait_for_completion(&req.done);
		}
	}

This way we don't poll, and we need only one helper.

(Can't resist, this patch is not bisect friendly, without the next patches
 wait_to_unschedule() is called under write_lock_irq, this is deadlockable).

But anyway, I think we can do this later.

Oleg.

