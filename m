Return-Path: <linux-kernel-owner+w=401wt.eu-S1751582AbZK0Mim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbZK0Mim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 07:38:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbZK0Mim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 07:38:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42067 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbZK0Mil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 07:38:41 -0500
Subject: Re: [patch] sched: fix b5d9d734 blunder in task_new_fair()
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1259324499.6483.257.camel@laptop>
References: <1258891664.14325.30.camel@marge.simson.net>
	 <1259252785.31676.216.camel@laptop>
	 <1259322921.3878.28.camel@marge.simson.net>
	 <1259324499.6483.257.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Nov 2009 13:38:42 +0100
Message-ID: <1259325522.6483.279.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-27 at 13:21 +0100, Peter Zijlstra wrote:
> +static struct rq *
> +balance_task(struct task_struct *p, int sd_flags, int wake_flags)
> +{
> +       struct rq *rq, *old_rq;
> +       u64 vdelta;
> +
> +               rq = old_rq = task_rq(p);
> +
> +       if (p->sched_class == &fair_sched_class)
> +               vdelta = task_cfs_rq(p)->min_vruntime;
> +
> +       __task_rq_unlock(old_rq);
> +
> +       cpu = select_task_rq(p, sd_flags, wake_flags);
> +
> +       rq = cpu_rq(cpu);
> +       spin_lock(&rq->lock);
> +       if (rq == old_rq)
> +               return rq;
> +
> +       update_rq_clock(rq);
> +
> +       set_task_cpu_all(p, task_cpu(p), cpu);
> +
> +       if (p->sched_class == &fair_sched_class) {
> +               vdelta -= task_cfs_rq(p)->min_vruntime;
> +               p->se.vruntime -= vdelta;
>         }
>  
> +       return rq;
> +} 

Feh, there's a much easier way to deal with that min_vruntime crap.

Do se->vruntime -= cfs_rq->min_vruntime, on dequeue, and
   se->vruntime += cfs_rq->min_vruntime, on enqueue

That leaves the whole thing invariant to the cfs_rq when its not
enqueued, and we don't have to fix it up when moving it around.

Also, note that I ripped out the clock_offset thingy, because with the
current sched_clock.c stuff clocks should get synchronized when we do a
remote clock update (or at least appear monotonic).

Getting these two things sorted returns set_task_cpu() to sanity.

/me tosses patch and starts over.

