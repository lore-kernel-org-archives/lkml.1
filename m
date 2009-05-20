Return-Path: <linux-kernel-owner+w=401wt.eu-S1755637AbZETPDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbZETPDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 11:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbZETPDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 11:03:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:34468 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbZETPDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 11:03:12 -0400
Subject: Re: [RFC PATCH] perf_counter: dynamically allocate tasks'
 perf_counter_context struct
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <18963.63352.489273.92145@cargo.ozlabs.ibm.com>
References: <18963.63352.489273.92145@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Wed, 20 May 2009 17:03:08 +0200
Message-Id: <1242831788.32543.1706.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-20 at 22:28 +1000, Paul Mackerras wrote:
> This replaces the struct perf_counter_context in the task_struct with
> a pointer to a dynamically allocated perf_counter_context struct.  The
> main reason for doing is this is to allow us to transfer a
> perf_counter_context from one task to another when we do lazy PMU
> switching in a later patch.

Looks good!, few comments below.

> +	ctx = task->perf_counter_ctx;
> +	if (!ctx) {
> +		ctx = kmalloc(sizeof(struct perf_counter_context), GFP_KERNEL);
> +		if (!ctx) {
> +			put_task_struct(task);
> +			return ERR_PTR(-ENOMEM);
> +		}
> +		__perf_counter_init_context(ctx, task);
> +		mutex_lock(&task->perf_counter_mutex);
> +		if (!task->perf_counter_ctx) {
> +			task->perf_counter_ctx = ctx;
> +		} else {
> +			kfree(ctx);
> +			ctx = task->perf_counter_ctx;
> +		}
> +		mutex_unlock(&task->perf_counter_mutex);
> +	}

This seems to be the only site where we use ->perf_counter_mutex,
couldn't we simply write this as:

 if (cmpxchg(&task->perf_counter_ctx, NULL, ctx) != NULL)
   kfree(ctx);

and get rid of the mutex?


> +/*
> + * Remove a counter from the lists for its context.
> + * Must be called with counter->mutex and ctx->mutex held.
> + */
>  static void
>  list_del_counter(struct perf_counter *counter, struct perf_counter_context *ctx)


> @@ -3295,6 +3354,8 @@ __perf_counter_exit_task(struct task_struct *child,
>   *
>   * Note: we may be running in child context, but the PID is not hashed
>   * anymore so new counters will not be added.
> + * (XXX not sure that is true when we get called from flush_old_exec.
> + *  -- paulus)
>   */
>  void perf_counter_exit_task(struct task_struct *child)
>  {

Yes, we have a little hole here, but I think it should fixable.

we have:

 do_exit()
 {
   exit_signals(); /* sets PF_EXITING */

   ... (1)

   perf_counter_exit_task();

   ... (2)

   <unhash somewhere>

vs


 find_get_context()


If, in find_get_context() we exclude PF_EXITING tasks under ctx->mutex,
and ensure we take ctx->mutex in perf_counter_exit_task() we should be
good.

Tasks could race and still attach in (1), but that would be ok, as
they'd get cleared out in perf_counter_exit_task(), but not after that
in (2) as they'd be sure to observe PF_EXITING.

Now it appears perf_counter_exit_task() is a little light on locking, so
the below patch adds both ctx->mutex and counter->mutex, as you say it
should when invoking list_del_counter().

Secondly it adds the PF_EXITING test in find_get_context().

(utterly untested and such..)

Almost-Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1228,6 +1228,13 @@ static struct perf_counter_context *find
 	ctx = &task->perf_counter_ctx;
 	ctx->task = task;
 
+	mutex_lock(&ctx->mutex);
+	if (task->state & PF_EXITING) {
+		mutex_unlock(&ctx->mutex);
+		return ERR_PTR(-ESRCH);
+	}
+	mutex_unlock(&ctx->mutex);
+
 	/* Reuse ptrace permission checks for now. */
 	if (!ptrace_may_access(task, PTRACE_MODE_READ)) {
 		put_context(ctx);
@@ -3292,42 +3299,29 @@ __perf_counter_exit_task(struct task_str
 			 struct perf_counter_context *child_ctx)
 {
 	struct perf_counter *parent_counter;
+	struct perf_cpu_context *cpuctx;
+	unsigned long flags;
 
 	/*
-	 * If we do not self-reap then we have to wait for the
-	 * child task to unschedule (it will happen for sure),
-	 * so that its counter is at its final count. (This
-	 * condition triggers rarely - child tasks usually get
-	 * off their CPU before the parent has a chance to
-	 * get this far into the reaping action)
-	 */
-	if (child != current) {
-		wait_task_inactive(child, 0);
-		update_counter_times(child_counter);
-		list_del_counter(child_counter, child_ctx);
-	} else {
-		struct perf_cpu_context *cpuctx;
-		unsigned long flags;
-
-		/*
-		 * Disable and unlink this counter.
-		 *
-		 * Be careful about zapping the list - IRQ/NMI context
-		 * could still be processing it:
-		 */
-		local_irq_save(flags);
-		perf_disable();
+	 * Disable and unlink this counter.
+	 *
+	 * Be careful about zapping the list - IRQ/NMI context
+	 * could still be processing it:
+	 */
+	local_irq_save(flags);
+	perf_disable();
 
-		cpuctx = &__get_cpu_var(perf_cpu_context);
+	cpuctx = &__get_cpu_var(perf_cpu_context);
 
-		group_sched_out(child_counter, cpuctx, child_ctx);
-		update_counter_times(child_counter);
+	group_sched_out(child_counter, cpuctx, child_ctx);
+	update_counter_times(child_counter);
 
-		list_del_counter(child_counter, child_ctx);
+	perf_enable();
+	local_irq_restore(flags);
 
-		perf_enable();
-		local_irq_restore(flags);
-	}
+	mutex_lock(&child_counter->mutex);
+	list_del_counter(child_counter, child_ctx);
+	mutex_unlock(&child_counter->mutex);
 
 	parent_counter = child_counter->parent;
 	/*
@@ -3359,6 +3353,8 @@ void perf_counter_exit_task(struct task_
 	if (likely(!child_ctx->nr_counters))
 		return;
 
+	mutex_lock(&child_ctx->mutex);
+
 again:
 	list_for_each_entry_safe(child_counter, tmp, &child_ctx->counter_list,
 				 list_entry)
@@ -3371,6 +3367,8 @@ again:
 	 */
 	if (!list_empty(&child_ctx->counter_list))
 		goto again;
+
+	mutex_unlock(&child_ctx->mutex);
 }
 
 /*


