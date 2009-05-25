Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbZEYKiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbZEYKiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 06:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbZEYKiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 06:38:10 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:10083 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbZEYKiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 06:38:09 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 2/2] perf_counter: optimize context switch between
 identical inherited contexts
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <18969.58137.356360.144339@cargo.ozlabs.ibm.com>
References: <18966.10075.781053.231153@cargo.ozlabs.ibm.com>
	 <18966.10666.517218.332164@cargo.ozlabs.ibm.com>
	 <1243000016.6582.574.camel@laptop>
	 <18969.58137.356360.144339@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Mon, 25 May 2009 12:38:07 +0200
Message-Id: <1243247887.26820.651.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-25 at 10:15 +1000, Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
> > Ingo just pointed out that there is nothing there to close the race with
> > attaching a counter.
> > 
> > That is, you could end up attaching your counter to the wrong task.
> 
> Good point.  Doing the unclone in find_get_context would be a start,
> but the locking could get tricky (in fact we don't have any way to
> remove an inherited counter from a context, so we only have to worry
> about counters being attached).  I'll work out a solution after I have
> digested your recent batch of patches.

I'm currently staring at something like the below, trying to find races
etc.. ;-)

attach vs destroy vs flip

---

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -102,13 +102,29 @@ static void get_ctx(struct perf_counter_
 	atomic_inc(&ctx->refcount);
 }
 
-static void put_ctx(struct perf_counter_context *ctx)
+static void free_ctx_rcu(struct rcu_head *head)
+{
+	struct perf_counter_context *ctx;
+
+	ctx = container_of(head, struct perf_counter_context, rcu_head);
+	kfree(ctx);
+}
+
+static bool __put_ctx(struct perf_counter_context *ctx)
 {
 	if (atomic_dec_and_test(&ctx->refcount)) {
 		if (ctx->parent_ctx)
 			put_ctx(ctx->parent_ctx);
-		kfree(ctx);
+		return true;
 	}
+
+	return false;
+}
+
+static void put_ctx(struct perf_counter_context *ctx)
+{
+	if (__put_ctx(ctx))
+		call_rcu(&ctx->rcu_head, free_ctx_rcu);
 }
 
 /*
@@ -934,8 +950,16 @@ void perf_counter_task_sched_out(struct 
 
 	next_ctx = next->perf_counter_ctxp;
 	if (next_ctx && context_equiv(ctx, next_ctx)) {
+		ctx->task = NULL;
+		next_ctx->task = NULL;
+
+		smp_wmb();
+
 		task->perf_counter_ctxp = next_ctx;
 		next->perf_counter_ctxp = ctx;
+
+		smp_wmb();
+
 		ctx->task = next;
 		next_ctx->task = task;
 		return;
@@ -1284,19 +1308,31 @@ static struct perf_counter_context *find
 		return ERR_PTR(-EACCES);
 	}
 
+	rcu_read_lock();
+again:
 	ctx = task->perf_counter_ctxp;
+	/*
+	 * matched against the xchg() in perf_counter_exit_task() setting
+	 * ctx to NULL and the cmpxchg() below.
+	 */
+	smp_read_barrier_depends();
 	if (!ctx) {
+		rcu_read_unlock();
+		/*
+		 * cannot attach counters to a dying task.
+		 */
+		if (task->flags & PF_EXITING) {
+			put_task_struct(task);
+			return ERR_PTR(-ESRCH);
+		}
+
 		ctx = kmalloc(sizeof(struct perf_counter_context), GFP_KERNEL);
 		if (!ctx) {
 			put_task_struct(task);
 			return ERR_PTR(-ENOMEM);
 		}
 		__perf_counter_init_context(ctx, task);
-		/*
-		 * Make sure other cpus see correct values for *ctx
-		 * once task->perf_counter_ctxp is visible to them.
-		 */
-		smp_wmb();
+		rcu_read_lock();
 		tctx = cmpxchg(&task->perf_counter_ctxp, NULL, ctx);
 		if (tctx) {
 			/*
@@ -1308,6 +1344,16 @@ static struct perf_counter_context *find
 		}
 	}
 
+	if (!atomic_inc_not_zero(&ctx->reference))
+		goto again;
+
+	if (rcu_dereference(ctx->task) != task) {
+		put_ctx(ctx);
+		goto again;
+	}
+
+	rcu_read_unlock();
+
 	return ctx;
 }
 
@@ -1316,7 +1362,6 @@ static void free_counter_rcu(struct rcu_
 	struct perf_counter *counter;
 
 	counter = container_of(head, struct perf_counter, rcu_head);
-	put_ctx(counter->ctx);
 	kfree(counter);
 }
 
@@ -1337,6 +1382,7 @@ static void free_counter(struct perf_cou
 	if (counter->destroy)
 		counter->destroy(counter);
 
+	put_ctx(counter->ctx);
 	call_rcu(&counter->rcu_head, free_counter_rcu);
 }
 
@@ -3231,6 +3277,7 @@ SYSCALL_DEFINE5(perf_counter_open,
 
 out_fput:
 	fput_light(group_file, fput_needed);
+	put_ctx(ctx);
 
 	return ret;
 
@@ -3390,25 +3437,25 @@ __perf_counter_exit_task(struct task_str
  *
  * Note: we may be running in child context, but the PID is not hashed
  * anymore so new counters will not be added.
- * (XXX not sure that is true when we get called from flush_old_exec.
- *  -- paulus)
  */
 void perf_counter_exit_task(struct task_struct *child)
 {
 	struct perf_counter *child_counter, *tmp;
 	struct perf_counter_context *child_ctx;
 	unsigned long flags;
+	bool free_ctx;
 
 	WARN_ON_ONCE(child != current);
 
-	child_ctx = child->perf_counter_ctxp;
+	child_ctx = xchg(&child->perf_counter_ctxp, NULL);
 
 	if (likely(!child_ctx))
 		return;
 
+	free_ctx = __put_ctx(child_ctx);
+
 	local_irq_save(flags);
 	__perf_counter_task_sched_out(child_ctx);
-	child->perf_counter_ctxp = NULL;
 	local_irq_restore(flags);
 
 	mutex_lock(&child_ctx->mutex);
@@ -3428,7 +3475,8 @@ again:
 
 	mutex_unlock(&child_ctx->mutex);
 
-	put_ctx(child_ctx);
+	if (free_ctx)
+		call_rcu(&ctx->rcu_head, free_ctx_rcu);
 }
 
 /*


