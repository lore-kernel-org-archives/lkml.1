Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575AbZE2IGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbZE2IGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 04:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbZE2IGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 04:06:32 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:36642 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbZE2IG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 04:06:27 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH RFC] perf_counter: Don't swap contexts containing
 locked mutex
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <18975.31580.520676.619896@drongo.ozlabs.ibm.com>
References: <18975.31580.520676.619896@drongo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Fri, 29 May 2009 10:06:28 +0200
Message-Id: <1243584388.23657.156.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-29 at 16:06 +1000, Paul Mackerras wrote:
> Peter Zijlstra pointed out that under some circumstances, we can take
> the mutex in a context or a counter and then swap that context or
> counter to another task, potentially leading to lock order inversions
> or the mutexes not protecting what they are supposed to protect.
> 
> This fixes the problem by making sure that we never take a mutex in a
> context or counter which could get swapped to another task.  Most of
> the cases where we take a mutex is on a top-level counter or context,
> i.e. a counter which has an fd associated with it or a context that
> contains such a counter.  This adds WARN_ON_ONCE statements to verify
> that.
> 
> The two cases where we need to take the mutex on a context that is a
> clone of another are in perf_counter_exit_task and
> perf_counter_init_task.  The perf_counter_exit_task case is solved by
> uncloning the context before starting to remove the counters from it.
> The perf_counter_init_task is a little trickier; we temporarily
> disable context swapping for the parent (forking) task by setting its
> ctx->parent_gen to the all-1s value after locking the context, if it
> is a cloned context, and restore the ctx->parent_gen value at the end
> if the context didn't get uncloned in the meantime.
> 
> This also moves the increment of the context generation count to be
> within the same critical section, protected by the context mutex, that
> adds the new counter to the context.  That way, taking the mutex is
> sufficient to ensure that both the counter list and the generation
> count are stable.
> 
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> ---
>  kernel/perf_counter.c |   89 ++++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 79 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
> index 52e5a15..db843f8 100644
> --- a/kernel/perf_counter.c
> +++ b/kernel/perf_counter.c
> @@ -919,7 +919,8 @@ static int context_equiv(struct perf_counter_context *ctx1,
>  			 struct perf_counter_context *ctx2)
>  {
>  	return ctx1->parent_ctx && ctx1->parent_ctx == ctx2->parent_ctx
> -		&& ctx1->parent_gen == ctx2->parent_gen;
> +		&& ctx1->parent_gen == ctx2->parent_gen
> +		&& ctx1->parent_gen != ~0ull;
>  }

There's a nasty surprise for people a few generations down the line. All
of a sudden performance drops for a while for some unknown reason, and
then its good again,.. how odd ;-)

But yeah, seems fine, given that the alternative is yet another
variable.


> @@ -1414,6 +1414,7 @@ static int perf_release(struct inode *inode, struct file *file)
>  
>  	file->private_data = NULL;
>  
> +	WARN_ON_ONCE(ctx->parent_ctx);
>  	mutex_lock(&ctx->mutex);
>  	perf_counter_remove_from_context(counter);
>  	mutex_unlock(&ctx->mutex);

<snip all the other WARN_ON_ONCEs>

How about:

#define ASSERT_CTX_STABLE(ctx) \
  WARN_ON_ONCE((ctx)->parent_gen != ~0ull || ctx->parent_ctx)

which would deal with both a 'locked' context and uncloned one?


> @@ -3571,9 +3596,11 @@ again:
>  int perf_counter_init_task(struct task_struct *child)
>  {
>  	struct perf_counter_context *child_ctx, *parent_ctx;
> +	struct perf_counter_context *cloned_ctx;
>  	struct perf_counter *counter;
>  	struct task_struct *parent = current;
>  	int inherited_all = 1;
> +	u64 cloned_gen;
>  	int ret = 0;
>  
>  	child->perf_counter_ctxp = NULL;
> @@ -3581,8 +3608,7 @@ int perf_counter_init_task(struct task_struct *child)
>  	mutex_init(&child->perf_counter_mutex);
>  	INIT_LIST_HEAD(&child->perf_counter_list);
>  
> -	parent_ctx = parent->perf_counter_ctxp;
> -	if (likely(!parent_ctx || !parent_ctx->nr_counters))
> +	if (likely(!parent->perf_counter_ctxp))
>  		return 0;
>  
>  	/*
> @@ -3600,6 +3626,34 @@ int perf_counter_init_task(struct task_struct *child)
>  	get_task_struct(child);
>  
>  	/*
> +	 * If the parent's context is a clone, temporarily set its
> +	 * parent_gen to an impossible value (all 1s) so it won't get
> +	 * swapped under us.  The rcu_read_lock makes sure that
> +	 * parent_ctx continues to exist even if it gets swapped to
> +	 * another process and then freed while we are trying to get
> +	 * its lock.
> +	 */
> +	rcu_read_lock();
> + retry:
> +	parent_ctx = rcu_dereference(parent->perf_counter_ctxp);
> +	/*
> +	 * No need to check if parent_ctx != NULL here; since we saw
> +	 * it non-NULL earlier, the only reason for it to become NULL
> +	 * is if we exit, and since we're currently in the middle of
> +	 * a fork we can't be exiting at the same time.
> +	 */
> +	spin_lock_irq(&parent_ctx->lock);
> +	if (parent_ctx != rcu_dereference(parent->perf_counter_ctxp)) {
> +		spin_unlock_irq(&parent_ctx->lock);
> +		goto retry;
> +	}
> +	cloned_gen = parent_ctx->parent_gen;
> +	if (parent_ctx->parent_ctx)
> +		parent_ctx->parent_gen = ~0ull;
> +	spin_unlock_irq(&parent_ctx->lock);
> +	rcu_read_unlock();
> +
> +	/*
>  	 * Lock the parent list. No need to lock the child - not PID
>  	 * hashed yet and not running, so nobody can access it.
>  	 */
> @@ -3630,10 +3684,15 @@ int perf_counter_init_task(struct task_struct *child)
>  		/*
>  		 * Mark the child context as a clone of the parent
>  		 * context, or of whatever the parent is a clone of.
> +		 * Note that if the parent is a clone, it could get
> +		 * uncloned at any point, but that doesn't matter
> +		 * because the list of counters and the generation
> +		 * count can't have changed since we took the mutex.
>  		 */
> -		if (parent_ctx->parent_ctx) {
> -			child_ctx->parent_ctx = parent_ctx->parent_ctx;
> -			child_ctx->parent_gen = parent_ctx->parent_gen;
> +		cloned_ctx = rcu_dereference(parent_ctx->parent_ctx);
> +		if (cloned_ctx) {
> +			child_ctx->parent_ctx = cloned_ctx;
> +			child_ctx->parent_gen = cloned_gen;
>  		} else {
>  			child_ctx->parent_ctx = parent_ctx;
>  			child_ctx->parent_gen = parent_ctx->generation;
> @@ -3643,6 +3702,16 @@ int perf_counter_init_task(struct task_struct *child)
>  
>  	mutex_unlock(&parent_ctx->mutex);
>  
> +	/*
> +	 * Restore the clone status of the parent.
> +	 */
> +	if (parent_ctx->parent_ctx) {
> +		spin_lock_irq(&parent_ctx->lock);
> +		if (parent_ctx->parent_ctx)
> +			parent_ctx->parent_gen = cloned_gen;
> +		spin_unlock_irq(&parent_ctx->lock);
> +	}
> +
>  	return ret;
>  }


Could we maybe write this as:

static struct perf_counter_ctx *pin_ctx(struct perf_counter *counter, u64 *old_gen)
{
	struct perf_counter_context *ctx;
	unsigned long flags;

	rcu_read_lock();
retry:
	ctx = rcu_dereference(counter->ctx);
	spin_lock_irqsave(&ctx->lock, flags);
	if (ctx != rcu_dereference(counter->ctx))
		goto retry;

	*old_gen = ctx->generation;
	ctx->generation = ~0ULL;
	spin_unlock_irqrestore(&ctx->lock, flags);
	rcu_read_unlock();

	return ctx;
}

static void unpin_ctx(struct perf_counter_ctx *ctx, u64 old_gen)
{
	unsigned long flags;

	spin_lock_irqsave(&ctx->lock, flags);
	ctx->generation = old_gen;
	spin_unlock_irqrestore(&ctx->lock, flags);
}

So that's its easily reusable?

Things like perf_counter_{enable,disable}() also need it I think.

> @@ -3527,12 +3538,17 @@ void perf_counter_exit_task(struct task_struct *child) 
> 	struct perf_counter_context *child_ctx;
>  	unsigned long flags;
>  
> -	child_ctx = child->perf_counter_ctxp;
> -
> -	if (likely(!child_ctx))
> +	if (likely(!child->perf_counter_ctxp))
>  		return;
>  
>  	local_irq_save(flags);
> +	/*
> +	 * We can't reschedule here because interrupts are disabled,
> +	 * and either child is current or it is a task that can't be
> +	 * scheduled, so we are now safe from rescheduling changing
> +	 * our context.
> +	 */
> +	child_ctx = child->perf_counter_ctxp;
>  	__perf_counter_task_sched_out(child_ctx);
>  
>  	/*
> @@ -3542,6 +3558,15 @@ void perf_counter_exit_task(struct task_struct *child)
>  	 */
>  	spin_lock(&child_ctx->lock);
>  	child->perf_counter_ctxp = NULL;
> +	if (child_ctx->parent_ctx) {
> +		/*
> +		 * This context is a clone; unclone it so it can't get
> +		 * swapped to another process while we're removing all
> +		 * the counters from it.
> +		 */
> +		put_ctx(child_ctx->parent_ctx);
> +		child_ctx->parent_ctx = NULL;
> +	}
>  	spin_unlock(&child_ctx->lock);
>  	local_irq_restore(flags);

And then we can also use pin_ctx() here, right?


