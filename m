Return-Path: <linux-kernel-owner+w=401wt.eu-S1758280AbZEZVU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbZEZVU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbZEZVUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:20:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:55181 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbZEZVUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:20:15 -0400
Subject: Re: [RFC PATCH] perf_counter: Fix race in attaching counters to
 tasks
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <18971.57536.580490.918501@cargo.ozlabs.ibm.com>
References: <18971.57536.580490.918501@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Tue, 26 May 2009 23:20:09 +0200
Message-Id: <1243372809.6600.23.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-26 at 22:29 +1000, Paul Mackerras wrote:
> Commit 564c2b21 ("perf_counter: Optimize context switch between
> identical inherited contexts") introduced a race where it is possible
> that a counter being attached to a task could get attached to the
> wrong task, if the task is one that has inherited its context from
> another task via fork.  This happens because the optimized context
> switch could switch the context to another task after find_get_context
> has read task->perf_counter_ctxp.  In fact, it's possible that the
> context could then get freed, if the other task then exits.
> 
> This fixes the problem by protecting both the context switch and the
> critical code in find_get_context with a spinlock.  We use the
> ctx->lock of the parent context for this because it will be common
> between any pair of contexts that might get swapped.  Thus
> perf_counter_task_sched_out only needs to take one lock to exclude
> find_get_context from getting the wrong context for either the old
> task or the new task.

I'm not sure this is the better approach (as opposed to your previous
patch that used a per counter/task lock), since the parent context lock
will serialize the full process tree over all cpus, whereas the per
counter/task lock will be lock to the current cpu.

> To make sure that none of the contexts being looked at in
> find_get_context can get freed, this changes the context freeing code
> to use RCU.  Thus an rcu_read_lock() is sufficient to ensure that no
> contexts can get freed.  This part of the patch is lifted from a patch
> posted by Peter Zijlstra.
> 
> This also adds a check to make sure that we can't add a counter to a
> task that is exiting.  This solves a race between
> perf_counter_exit_task and find_get_context; it ensures that
> find_get_context can't attach a new context to a task after
> perf_counter_exit_task has disposed of the task's context.

Right, this leaves us with the flush_old_exec() race. I tried solving
that by dropping the ctx reference count to 0 before iterating the ctx
counters and destroying them vs atomic_inc_not_zero() reference acquire
in find_get_context().

> With this, we are now doing the unclone in find_get_context rather
> than when a counter was added to or removed from a context (actually,
> we were missing the unclone_ctx() call when adding a counter to a
> context). 

We destroy the parent_ctx pointer under the lock, but suppose we're
trying to attach to the parent context itself, doesn't that mean we need
to increment the generatoin count under the lock as well?

>  We don't need to unclone when removing a counter from a
> context because we have no way to remove a counter from a cloned
> context.

Not without removing it from the whole hierarchy indeed.

> This also takes out the smp_wmb() in find_get_context, which Peter
> Zijlstra pointed out was unnecessary because the cmpxchg implies a
> full barrier anyway.

> @@ -281,13 +273,16 @@ static void __perf_counter_remove_from_context(void *info)
>   *
>   * CPU counters are removed with a smp call. For task counters we only
>   * call when the task is on a CPU.
> + *
> + * If counter->ctx is a cloned context, callers must make sure that
> + * every task struct that counter->ctx->task could possibly point to
> + * remains valid.
>   */

This comment (and its replicas) confuse me in that they only require
something but then don't expand on how this is accomplished.

> @@ -1437,6 +1491,12 @@ static void perf_counter_for_each_sibling(struct perf_counter *counter,
>  	mutex_unlock(&ctx->mutex);
>  }
>  
> +/*
> + * Holding the top-level counter's child_mutex means that any
> + * descendant process that has inherited this counter will block
> + * in sync_child_counter if it goes to exit, thus satisfying the
> + * task existence requirements of perf_counter_enable/disable.
> + */
>  static void perf_counter_for_each_child(struct perf_counter *counter,
>  					void (*func)(struct perf_counter *))
>  {
> @@ -3449,17 +3509,13 @@ void perf_counter_exit_task(struct task_struct *child)
>  {
>  	struct perf_counter *child_counter, *tmp;
>  	struct perf_counter_context *child_ctx;
> -	unsigned long flags;
>  
>  	child_ctx = child->perf_counter_ctxp;
> -
>  	if (likely(!child_ctx))
>  		return;
>  
> -	local_irq_save(flags);
>  	__perf_counter_task_sched_out(child_ctx);
>  	child->perf_counter_ctxp = NULL;
> -	local_irq_restore(flags);
>  
>  	mutex_lock(&child_ctx->mutex);

This change looks wrong, __perf_counter_task_sched_out() ->
__perf_counter_sched_out() -> spin_lock(&ctx->lock) wants IRQs
disabled..

