Return-Path: <linux-kernel-owner+w=401wt.eu-S1758082AbZE2RRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082AbZE2RRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 13:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760986AbZE2RRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 13:17:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:57545 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225AbZE2RRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 13:17:02 -0400
Date: Fri, 29 May 2009 17:16:20 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Clean up task_ctx vs interrupts
Message-ID: <tip-665c2142a94202881a3c11cbaee6506cb10ada2d@git.kernel.org>
Git-Commit-ID: 665c2142a94202881a3c11cbaee6506cb10ada2d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 May 2009 17:16:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  665c2142a94202881a3c11cbaee6506cb10ada2d
Gitweb:     http://git.kernel.org/tip/665c2142a94202881a3c11cbaee6506cb10ada2d
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 29 May 2009 14:51:57 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 May 2009 16:21:51 +0200

perf_counter: Clean up task_ctx vs interrupts

Remove the local_irq_save() etc.. in routines that are smp function
calls, or have IRQs disabled by other means.

Then change the COMM, MMAP, and swcounter context iteration to
current->perf_counter_ctxp and RCU, since it really doesn't matter
which context they iterate, they're all folded.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   82 ++++++++++++++++++++++++++++++-------------------
 1 files changed, 50 insertions(+), 32 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 58d6d19..0c000d3 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -232,18 +232,14 @@ static void __perf_counter_remove_from_context(void *info)
 	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_counter *counter = info;
 	struct perf_counter_context *ctx = counter->ctx;
-	unsigned long flags;
 
-	local_irq_save(flags);
 	/*
 	 * If this is a task context, we need to check whether it is
 	 * the current task context of this cpu. If not it has been
 	 * scheduled out before the smp call arrived.
 	 */
-	if (ctx->task && cpuctx->task_ctx != ctx) {
-		local_irq_restore(flags);
+	if (ctx->task && cpuctx->task_ctx != ctx)
 		return;
-	}
 
 	spin_lock(&ctx->lock);
 	/*
@@ -267,7 +263,7 @@ static void __perf_counter_remove_from_context(void *info)
 	}
 
 	perf_enable();
-	spin_unlock_irqrestore(&ctx->lock, flags);
+	spin_unlock(&ctx->lock);
 }
 
 
@@ -383,17 +379,13 @@ static void __perf_counter_disable(void *info)
 	struct perf_counter *counter = info;
 	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_counter_context *ctx = counter->ctx;
-	unsigned long flags;
 
-	local_irq_save(flags);
 	/*
 	 * If this is a per-task counter, need to check whether this
 	 * counter's task is the current task on this cpu.
 	 */
-	if (ctx->task && cpuctx->task_ctx != ctx) {
-		local_irq_restore(flags);
+	if (ctx->task && cpuctx->task_ctx != ctx)
 		return;
-	}
 
 	spin_lock(&ctx->lock);
 
@@ -411,7 +403,7 @@ static void __perf_counter_disable(void *info)
 		counter->state = PERF_COUNTER_STATE_OFF;
 	}
 
-	spin_unlock_irqrestore(&ctx->lock, flags);
+	spin_unlock(&ctx->lock);
 }
 
 /*
@@ -618,10 +610,8 @@ static void __perf_install_in_context(void *info)
 	struct perf_counter_context *ctx = counter->ctx;
 	struct perf_counter *leader = counter->group_leader;
 	int cpu = smp_processor_id();
-	unsigned long flags;
 	int err;
 
-	local_irq_save(flags);
 	/*
 	 * If this is a task context, we need to check whether it is
 	 * the current task context of this cpu. If not it has been
@@ -630,10 +620,8 @@ static void __perf_install_in_context(void *info)
 	 * on this cpu because it had no counters.
 	 */
 	if (ctx->task && cpuctx->task_ctx != ctx) {
-		if (cpuctx->task_ctx || ctx->task != current) {
-			local_irq_restore(flags);
+		if (cpuctx->task_ctx || ctx->task != current)
 			return;
-		}
 		cpuctx->task_ctx = ctx;
 	}
 
@@ -687,7 +675,7 @@ static void __perf_install_in_context(void *info)
  unlock:
 	perf_enable();
 
-	spin_unlock_irqrestore(&ctx->lock, flags);
+	spin_unlock(&ctx->lock);
 }
 
 /*
@@ -751,19 +739,15 @@ static void __perf_counter_enable(void *info)
 	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_counter_context *ctx = counter->ctx;
 	struct perf_counter *leader = counter->group_leader;
-	unsigned long flags;
 	int err;
 
-	local_irq_save(flags);
 	/*
 	 * If this is a per-task counter, need to check whether this
 	 * counter's task is the current task on this cpu.
 	 */
 	if (ctx->task && cpuctx->task_ctx != ctx) {
-		if (cpuctx->task_ctx || ctx->task != current) {
-			local_irq_restore(flags);
+		if (cpuctx->task_ctx || ctx->task != current)
 			return;
-		}
 		cpuctx->task_ctx = ctx;
 	}
 
@@ -811,7 +795,7 @@ static void __perf_counter_enable(void *info)
 	}
 
  unlock:
-	spin_unlock_irqrestore(&ctx->lock, flags);
+	spin_unlock(&ctx->lock);
 }
 
 /*
@@ -981,6 +965,10 @@ void perf_counter_task_sched_out(struct task_struct *task,
 		spin_lock(&ctx->lock);
 		spin_lock_nested(&next_ctx->lock, SINGLE_DEPTH_NESTING);
 		if (context_equiv(ctx, next_ctx)) {
+			/*
+			 * XXX do we need a memory barrier of sorts
+			 * wrt to rcu_dereference() of perf_counter_ctxp
+			 */
 			task->perf_counter_ctxp = next_ctx;
 			next->perf_counter_ctxp = ctx;
 			ctx->task = next;
@@ -998,6 +986,9 @@ void perf_counter_task_sched_out(struct task_struct *task,
 	}
 }
 
+/*
+ * Called with IRQs disabled
+ */
 static void __perf_counter_task_sched_out(struct perf_counter_context *ctx)
 {
 	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
@@ -1012,6 +1003,9 @@ static void __perf_counter_task_sched_out(struct perf_counter_context *ctx)
 	cpuctx->task_ctx = NULL;
 }
 
+/*
+ * Called with IRQs disabled
+ */
 static void perf_counter_cpu_sched_out(struct perf_cpu_context *cpuctx)
 {
 	__perf_counter_sched_out(&cpuctx->ctx, cpuctx);
@@ -2431,6 +2425,7 @@ static void perf_counter_comm_ctx(struct perf_counter_context *ctx,
 static void perf_counter_comm_event(struct perf_comm_event *comm_event)
 {
 	struct perf_cpu_context *cpuctx;
+	struct perf_counter_context *ctx;
 	unsigned int size;
 	char *comm = comm_event->task->comm;
 
@@ -2443,9 +2438,17 @@ static void perf_counter_comm_event(struct perf_comm_event *comm_event)
 
 	cpuctx = &get_cpu_var(perf_cpu_context);
 	perf_counter_comm_ctx(&cpuctx->ctx, comm_event);
-	if (cpuctx->task_ctx)
-		perf_counter_comm_ctx(cpuctx->task_ctx, comm_event);
 	put_cpu_var(perf_cpu_context);
+
+	rcu_read_lock();
+	/*
+	 * doesn't really matter which of the child contexts the
+	 * events ends up in.
+	 */
+	ctx = rcu_dereference(current->perf_counter_ctxp);
+	if (ctx)
+		perf_counter_comm_ctx(ctx, comm_event);
+	rcu_read_unlock();
 }
 
 void perf_counter_comm(struct task_struct *task)
@@ -2536,6 +2539,7 @@ static void perf_counter_mmap_ctx(struct perf_counter_context *ctx,
 static void perf_counter_mmap_event(struct perf_mmap_event *mmap_event)
 {
 	struct perf_cpu_context *cpuctx;
+	struct perf_counter_context *ctx;
 	struct file *file = mmap_event->file;
 	unsigned int size;
 	char tmp[16];
@@ -2568,10 +2572,18 @@ got_name:
 
 	cpuctx = &get_cpu_var(perf_cpu_context);
 	perf_counter_mmap_ctx(&cpuctx->ctx, mmap_event);
-	if (cpuctx->task_ctx)
-		perf_counter_mmap_ctx(cpuctx->task_ctx, mmap_event);
 	put_cpu_var(perf_cpu_context);
 
+	rcu_read_lock();
+	/*
+	 * doesn't really matter which of the child contexts the
+	 * events ends up in.
+	 */
+	ctx = rcu_dereference(current->perf_counter_ctxp);
+	if (ctx)
+		perf_counter_mmap_ctx(ctx, mmap_event);
+	rcu_read_unlock();
+
 	kfree(buf);
 }
 
@@ -2882,6 +2894,7 @@ static void __perf_swcounter_event(enum perf_event_types type, u32 event,
 {
 	struct perf_cpu_context *cpuctx = &get_cpu_var(perf_cpu_context);
 	int *recursion = perf_swcounter_recursion_context(cpuctx);
+	struct perf_counter_context *ctx;
 
 	if (*recursion)
 		goto out;
@@ -2891,10 +2904,15 @@ static void __perf_swcounter_event(enum perf_event_types type, u32 event,
 
 	perf_swcounter_ctx_event(&cpuctx->ctx, type, event,
 				 nr, nmi, regs, addr);
-	if (cpuctx->task_ctx) {
-		perf_swcounter_ctx_event(cpuctx->task_ctx, type, event,
-					 nr, nmi, regs, addr);
-	}
+	rcu_read_lock();
+	/*
+	 * doesn't really matter which of the child contexts the
+	 * events ends up in.
+	 */
+	ctx = rcu_dereference(current->perf_counter_ctxp);
+	if (ctx)
+		perf_swcounter_ctx_event(ctx, type, event, nr, nmi, regs, addr);
+	rcu_read_unlock();
 
 	barrier();
 	(*recursion)--;
