Return-Path: <linux-kernel-owner+w=401wt.eu-S1756452AbXIYOuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452AbXIYOuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 10:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbXIYOuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 10:50:05 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:48593 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbXIYOuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 10:50:03 -0400
Date: Tue, 25 Sep 2007 20:18:30 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git] CFS-devel, latest code
Message-ID: <20070925144830.GA5286@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <1190700652.6482.7.camel@Homer.simpson.net> <1190705759.11910.10.camel@Homer.simpson.net> <1190709207.11226.6.camel@Homer.simpson.net> <20070925091331.GA22905@elte.hu> <20070925094440.GK26289@linux.vnet.ibm.com> <20070925094040.GA28391@elte.hu> <20070925101044.GA923@elte.hu> <20070925102855.GL26289@linux.vnet.ibm.com> <20070925103617.GA3426@elte.hu> <20070925113306.GA19166@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925113306.GA19166@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 01:33:06PM +0200, Ingo Molnar wrote:
> > hm. perhaps this fixup in kernel/sched.c:set_task_cpu():
> > 
> >         p->se.vruntime -= old_rq->cfs.min_vruntime - new_rq->cfs.min_vruntime;
> > 
> > needs to become properly group-hierarchy aware?

You seem to have hit the nerve for this problem. The two patches I sent:

	http://lkml.org/lkml/2007/9/25/117
	http://lkml.org/lkml/2007/9/25/168

partly help, but we can do better.

> ===================================================================
> --- linux.orig/kernel/sched.c
> +++ linux/kernel/sched.c
> @@ -1039,7 +1039,8 @@ void set_task_cpu(struct task_struct *p,
>  {
>  	int old_cpu = task_cpu(p);
>  	struct rq *old_rq = cpu_rq(old_cpu), *new_rq = cpu_rq(new_cpu);
> -	u64 clock_offset;
> +	struct sched_entity *se;
> +	u64 clock_offset, voffset;
> 
>  	clock_offset = old_rq->clock - new_rq->clock;
> 
> @@ -1051,7 +1052,11 @@ void set_task_cpu(struct task_struct *p,
>  	if (p->se.block_start)
>  		p->se.block_start -= clock_offset;
>  #endif
> -	p->se.vruntime -= old_rq->cfs.min_vruntime - new_rq->cfs.min_vruntime;
> +
> +	se = &p->se;
> +	voffset = old_rq->cfs.min_vruntime - new_rq->cfs.min_vruntime;

This one feels wrong, although I can't express my reaction correctly ..

> +	for_each_sched_entity(se)
> +		se->vruntime -= voffset;

Note that parent entities for a task is per-cpu. So if a task A
belonging to userid guest hops from CPU0 to CPU1, then it gets a new parent 
entity as well, which is different from its parent entity on CPU0.

Before:
	taskA->se.parent = guest's tg->se[0]

After:
	taskA->se.parent = guest's tg->se[1]

So walking up the entity hierarchy and fixing up (parent)se->vruntime will do
little good after the task has moved to a new cpu.

IMO, we need to be doing this :

	- For dequeue of higher level sched entities, simulate as if
	  they are going to "sleep" 
	- For enqueue of higher level entities, simulate as if they are
	  "waking up". This will cause enqueue_entity() to reset their
	  vruntime (to existing value for cfs_rq->min_vruntime) when they 
	  "wakeup".

If we don't do this, then lets say a group had only one task (A) and it
moves from CPU0 to CPU1. Then on CPU1, when group level entity for task
A is enqueued, it will have a very low vruntime (since it was never
running) and this will give task A unlimited cpu time, until its group
entity catches up with all the "sleep" time.

Let me try a fix for this next ..

-- 
Regards,
vatsa
