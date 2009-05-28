Return-Path: <linux-kernel-owner+w=401wt.eu-S1756902AbZE1LNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbZE1LNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 07:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbZE1LM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 07:12:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45891 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbZE1LM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 07:12:58 -0400
Subject: Re: [PATCH v4] perf_counter: Fix race in attaching counters to
 tasks and exiting
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <18974.26663.618300.184845@cargo.ozlabs.ibm.com>
References: <18974.26663.618300.184845@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Thu, 28 May 2009 13:12:50 +0200
Message-Id: <1243509170.6600.36.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good, few nits below.

On Thu, 2009-05-28 at 20:32 +1000, Paul Mackerras wrote:

> +static void free_ctx(struct rcu_head *head)
> +{
> +	struct perf_counter_context *ctx;
> +
> +	ctx = container_of(head, struct perf_counter_context, rcu_head);
> +	if (ctx->task)
> +		put_task_struct(ctx->task);
> +	kfree(ctx);
> +}

The poor task will now have to wait for yet another RCU grace period,
but yeah :-)

> @@ -932,18 +950,39 @@ void perf_counter_task_sched_out(struct task_struct *task,
>  		return;
>  
>  	update_context_time(ctx);
> +
> +	rcu_read_lock();
> +	parent = rcu_dereference(ctx->parent_ctx);
>  	next_ctx = next->perf_counter_ctxp;
> +	if (parent && next_ctx &&
> +	    rcu_dereference(next_ctx->parent_ctx) == parent) {
> +		/*
> +		 * Looks like the two contexts are clones, so we might be
> +		 * able to optimize the context switch.  We lock both
> +		 * contexts and check that they are clones under the
> +		 * lock (including re-checking that neither has been
> +		 * uncloned in the meantime).  It doesn't matter which
> +		 * order we take the locks because no other cpu could
> +		 * be trying to lock both of these tasks.
> +		 */
> +		spin_lock(&ctx->lock);
> +		spin_lock(&next_ctx->lock);
> +		if (context_equiv(ctx, next_ctx)) {
> +			task->perf_counter_ctxp = next_ctx;
> +			next->perf_counter_ctxp = ctx;
> +			ctx->task = next;
> +			next_ctx->task = task;
> +			do_switch = 0;
> +		}
> +		spin_unlock(&next_ctx->lock);
> +		spin_unlock(&ctx->lock);
>  	}
> +	rcu_read_unlock();

Looks good, although lockdep will complain, the proper annotation would
be spin_lock_nested_lock(&ctx->lock, &rq->lock), but since we don't have
access to the rq here, we should change the second spin_lock, to:

  spin_lock_nested(&next_ctx->lock, SINGLE_DEPTH_NESTING);


> @@ -1265,37 +1300,78 @@ static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
>  	if (!task)
>  		return ERR_PTR(-ESRCH);
>  
> +	/*
> +	 * Can't attach counters to a dying task.
> +	 */
> +	err = -ESRCH;
> +	if (task->flags & PF_EXITING)
> +		goto errout;
> +
>  	/* Reuse ptrace permission checks for now. */
> +	err = -EACCES;
> +	if (!ptrace_may_access(task, PTRACE_MODE_READ))
> +		goto errout;
> +
> +	rcu_read_lock();
> + retry:
> +	ctx = rcu_dereference(task->perf_counter_ctxp);
> +	if (ctx) {
> +		/*
> +		 * If this context is a clone of another, it might
> +		 * get swapped for another underneath us by
> +		 * perf_counter_task_sched_out, though the
> +		 * rcu_read_lock() protects us from any context
> +		 * getting freed.  Lock the context and check if it
> +		 * got swapped before we could get the lock, and retry
> +		 * if so.  If we locked the right context, then it
> +		 * can't get swapped on us any more and we can
> +		 * unclone it if necessary.
> +		 * Once it's not a clone things will be stable.
> +		 */
> +		spin_lock(&ctx->lock);
> +		if (ctx != rcu_dereference(task->perf_counter_ctxp)) {
> +			spin_unlock(&ctx->lock);
> +			goto retry;
> +		}
> +		parent_ctx = ctx->parent_ctx;
> +		if (parent_ctx) {
> +			put_ctx(parent_ctx);
> +			ctx->parent_ctx = NULL;		/* no longer a clone */
> +		}
> +		++ctx->generation;
> +		/*
> +		 * Get an extra reference before dropping the lock so that
> +		 * this context won't get freed if the task exits.
> +		 */
> +		get_ctx(ctx);
> +		spin_unlock(&ctx->lock);
>  	}
> +	rcu_read_unlock();
>  
>  	if (!ctx) {
>  		ctx = kmalloc(sizeof(struct perf_counter_context), GFP_KERNEL);
> +		err = -ENOMEM;
> +		if (!ctx)
> +			goto errout;
>  		__perf_counter_init_context(ctx, task);
> +		get_ctx(ctx);
> +		if (cmpxchg(&task->perf_counter_ctxp, NULL, ctx)) {
>  			/*
>  			 * We raced with some other task; use
>  			 * the context they set.
>  			 */
>  			kfree(ctx);
> +			goto retry;

You jump into an rcu_read_lock() section there.

>  		}
> +		get_task_struct(task);
>  	}
>  
> +	put_task_struct(task);
>  	return ctx;
> +
> + errout:
> +	put_task_struct(task);
> +	return ERR_PTR(err);
>  }
>  
>  static void free_counter_rcu(struct rcu_head *head)

