Return-Path: <linux-kernel-owner+w=401wt.eu-S1753018AbZEYL1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbZEYL1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 07:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbZEYL1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 07:27:03 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:11700 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbZEYL1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 07:27:02 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 2/2] perf_counter: optimize context switch between
 identical inherited contexts
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <18970.31699.559802.462479@cargo.ozlabs.ibm.com>
References: <18966.10075.781053.231153@cargo.ozlabs.ibm.com>
	 <18966.10666.517218.332164@cargo.ozlabs.ibm.com>
	 <1243000016.6582.574.camel@laptop>
	 <18969.58137.356360.144339@cargo.ozlabs.ibm.com>
	 <1243247887.26820.651.camel@twins>
	 <18970.31699.559802.462479@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Mon, 25 May 2009 13:27:01 +0200
Message-Id: <1243250821.26820.677.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-25 at 21:06 +1000, Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
> > I'm currently staring at something like the below, trying to find races
> > etc.. ;-)
> [snip]
> >  	next_ctx = next->perf_counter_ctxp;
> >  	if (next_ctx && context_equiv(ctx, next_ctx)) {
> > +		ctx->task = NULL;
> > +		next_ctx->task = NULL;
> 
> Trouble is, ctx->task == NULL is used as an indication that this is a
> per-cpu context in various places.

Yeah, already realized that, its enough to simply put them to the new
task, before flipping the context pointers.

> Also, in find_get_context, we have a lifetime problem because *ctx
> could get swapped and then freed underneath us immediately after we
> read task->perf_counter_ctxp.  So we need a lock in the task_struct
> that stops sched_out from swapping the context underneath us.  That
> led me to the patch below, which I'm about to test... :)  It does the
> unclone in find_get_context; we don't actually need it on remove
> because we have no way to remove an inherited counter from a task
> without the task exiting.

Right, I was trying to solve the lifetime issues with RCU and refcount
tricks and the races with ordering, instead of adding another lock.

> @@ -932,12 +927,32 @@ void perf_counter_task_sched_out(struct task_struct *task,
>  	regs = task_pt_regs(task);
>  	perf_swcounter_event(PERF_COUNT_CONTEXT_SWITCHES, 1, 1, regs, 0);
>  
> +	/*
> +	 * Note: task->perf_counter_ctxp and next->perf_counter_ctxp
> +	 * can't change underneath us here if we see them non-NULL,
> +	 * because this is the only place where we change which
> +	 * context a task points to, and the scheduler will ensure
> +	 * that this code isn't being called for either of these tasks
> +	 * on any other cpu at the same time.
> +	 */
>  	next_ctx = next->perf_counter_ctxp;
>  	if (next_ctx && context_equiv(ctx, next_ctx)) {
> +		/*
> +		 * Lock the contexts of both the old and new tasks so that we
> +		 * don't change things underneath find_get_context etc.
> +		 * We don't need to be careful about the order in which we
> +		 * lock the tasks because no other cpu could be trying to lock
> +		 * both of these tasks -- this is the only place where we lock
> +		 * two tasks.
> +		 */
> +		spin_lock(&task->perf_counter_ctx_lock);
> +		spin_lock(&next->perf_counter_ctx_lock);
>  		task->perf_counter_ctxp = next_ctx;
>  		next->perf_counter_ctxp = ctx;
>  		ctx->task = next;
>  		next_ctx->task = task;
> +		spin_unlock(&next->perf_counter_ctx_lock);
> +		spin_unlock(&task->perf_counter_ctx_lock);
>  		return;
>  	}

FWIW that nested lock will make lockdep complain -- it can't deadlock
since we're under rq->lock and the tasks can't be stolen from the rq in
that case. So you can silence lockdep by using spin_lock_nested_lock()

> @@ -1067,6 +1082,7 @@ static void perf_counter_cpu_sched_in(struct perf_cpu_context *cpuctx, int cpu)
>  	__perf_counter_sched_in(ctx, cpuctx, cpu);
>  }
>  
> +// XXX doesn't do inherited counters too?
>  int perf_counter_task_enable(void)
>  {
>  	struct perf_counter *counter;

Good point,.. perf_counter_for_each_child(counter, perf_counter_disable)
should fix that I think.

> @@ -1360,7 +1389,7 @@ static int perf_release(struct inode *inode, struct file *file)
>  	put_task_struct(counter->owner);
>  
>  	free_counter(counter);
> -	put_context(ctx);
> +	put_context(ctx);		// XXX use after free?
>  
>  	return 0;
>  }

don't htink so, but will have a look.


