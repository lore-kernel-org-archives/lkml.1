Return-Path: <linux-kernel-owner+w=401wt.eu-S1758847AbZDFJtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847AbZDFJtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755890AbZDFJou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:44:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:42367 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620AbZDFJot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:44:49 -0400
Message-Id: <20090406094518.531137582@chello.nl>
References: <20090406094458.977814421@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 06 Apr 2009 11:45:12 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 14/15] perf_counter: remove rq->lock usage
Content-Disposition: inline; filename=per_counter-remove-rq_lock.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all the task runtime clock users are gone, remove the ugly
rq->lock usage from perf counters, which solves the nasty deadlock
seen when a software task clock counter was read from an NMI overflow
context.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/kernel_stat.h |    2 --
 kernel/perf_counter.c       |   42 ++++++++++++++++--------------------------
 kernel/sched.c              |   20 --------------------
 3 files changed, 16 insertions(+), 48 deletions(-)

Index: linux-2.6/include/linux/kernel_stat.h
===================================================================
--- linux-2.6.orig/include/linux/kernel_stat.h
+++ linux-2.6/include/linux/kernel_stat.h
@@ -85,8 +85,6 @@ static inline unsigned int kstat_irqs(un
 /*
  * Lock/unlock the current runqueue - to extract task statistics:
  */
-extern void curr_rq_lock_irq_save(unsigned long *flags);
-extern void curr_rq_unlock_irq_restore(unsigned long *flags);
 extern unsigned long long __task_delta_exec(struct task_struct *tsk, int update);
 extern unsigned long long task_delta_exec(struct task_struct *);
 
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -172,8 +172,7 @@ static void __perf_counter_remove_from_c
 	if (ctx->task && cpuctx->task_ctx != ctx)
 		return;
 
-	curr_rq_lock_irq_save(&flags);
-	spin_lock(&ctx->lock);
+	spin_lock_irqsave(&ctx->lock, flags);
 
 	counter_sched_out(counter, cpuctx, ctx);
 
@@ -198,8 +197,7 @@ static void __perf_counter_remove_from_c
 			    perf_max_counters - perf_reserved_percpu);
 	}
 
-	spin_unlock(&ctx->lock);
-	curr_rq_unlock_irq_restore(&flags);
+	spin_unlock_irqrestore(&ctx->lock, flags);
 }
 
 
@@ -319,8 +317,7 @@ static void __perf_counter_disable(void 
 	if (ctx->task && cpuctx->task_ctx != ctx)
 		return;
 
-	curr_rq_lock_irq_save(&flags);
-	spin_lock(&ctx->lock);
+	spin_lock_irqsave(&ctx->lock, flags);
 
 	/*
 	 * If the counter is on, turn it off.
@@ -336,8 +333,7 @@ static void __perf_counter_disable(void 
 		counter->state = PERF_COUNTER_STATE_OFF;
 	}
 
-	spin_unlock(&ctx->lock);
-	curr_rq_unlock_irq_restore(&flags);
+	spin_unlock_irqrestore(&ctx->lock, flags);
 }
 
 /*
@@ -515,8 +511,7 @@ static void __perf_install_in_context(vo
 	if (ctx->task && cpuctx->task_ctx != ctx)
 		return;
 
-	curr_rq_lock_irq_save(&flags);
-	spin_lock(&ctx->lock);
+	spin_lock_irqsave(&ctx->lock, flags);
 	update_context_time(ctx);
 
 	/*
@@ -565,8 +560,7 @@ static void __perf_install_in_context(vo
  unlock:
 	hw_perf_restore(perf_flags);
 
-	spin_unlock(&ctx->lock);
-	curr_rq_unlock_irq_restore(&flags);
+	spin_unlock_irqrestore(&ctx->lock, flags);
 }
 
 /*
@@ -641,8 +635,7 @@ static void __perf_counter_enable(void *
 	if (ctx->task && cpuctx->task_ctx != ctx)
 		return;
 
-	curr_rq_lock_irq_save(&flags);
-	spin_lock(&ctx->lock);
+	spin_lock_irqsave(&ctx->lock, flags);
 	update_context_time(ctx);
 
 	counter->prev_state = counter->state;
@@ -678,8 +671,7 @@ static void __perf_counter_enable(void *
 	}
 
  unlock:
-	spin_unlock(&ctx->lock);
-	curr_rq_unlock_irq_restore(&flags);
+	spin_unlock_irqrestore(&ctx->lock, flags);
 }
 
 /*
@@ -971,7 +963,7 @@ int perf_counter_task_disable(void)
 	if (likely(!ctx->nr_counters))
 		return 0;
 
-	curr_rq_lock_irq_save(&flags);
+	local_irq_save(flags);
 	cpu = smp_processor_id();
 
 	perf_counter_task_sched_out(curr, cpu);
@@ -992,9 +984,7 @@ int perf_counter_task_disable(void)
 
 	hw_perf_restore(perf_flags);
 
-	spin_unlock(&ctx->lock);
-
-	curr_rq_unlock_irq_restore(&flags);
+	spin_unlock_irqrestore(&ctx->lock, flags);
 
 	return 0;
 }
@@ -1011,7 +1001,7 @@ int perf_counter_task_enable(void)
 	if (likely(!ctx->nr_counters))
 		return 0;
 
-	curr_rq_lock_irq_save(&flags);
+	local_irq_save(flags);
 	cpu = smp_processor_id();
 
 	perf_counter_task_sched_out(curr, cpu);
@@ -1037,7 +1027,7 @@ int perf_counter_task_enable(void)
 
 	perf_counter_task_sched_in(curr, cpu);
 
-	curr_rq_unlock_irq_restore(&flags);
+	local_irq_restore(flags);
 
 	return 0;
 }
@@ -1095,12 +1085,12 @@ static void __read(void *info)
 	struct perf_counter_context *ctx = counter->ctx;
 	unsigned long flags;
 
-	curr_rq_lock_irq_save(&flags);
+	local_irq_save(flags);
 	if (ctx->is_active)
 		update_context_time(ctx);
 	counter->hw_ops->read(counter);
 	update_counter_times(counter);
-	curr_rq_unlock_irq_restore(&flags);
+	local_irq_restore(flags);
 }
 
 static u64 perf_counter_read(struct perf_counter *counter)
@@ -2890,7 +2880,7 @@ __perf_counter_exit_task(struct task_str
 		 * Be careful about zapping the list - IRQ/NMI context
 		 * could still be processing it:
 		 */
-		curr_rq_lock_irq_save(&flags);
+		local_irq_save(flags);
 		perf_flags = hw_perf_save_disable();
 
 		cpuctx = &__get_cpu_var(perf_cpu_context);
@@ -2903,7 +2893,7 @@ __perf_counter_exit_task(struct task_str
 		child_ctx->nr_counters--;
 
 		hw_perf_restore(perf_flags);
-		curr_rq_unlock_irq_restore(&flags);
+		local_irq_restore(flags);
 	}
 
 	parent_counter = child_counter->parent;
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1004,26 +1004,6 @@ static struct rq *task_rq_lock(struct ta
 	}
 }
 
-void curr_rq_lock_irq_save(unsigned long *flags)
-	__acquires(rq->lock)
-{
-	struct rq *rq;
-
-	local_irq_save(*flags);
-	rq = cpu_rq(smp_processor_id());
-	spin_lock(&rq->lock);
-}
-
-void curr_rq_unlock_irq_restore(unsigned long *flags)
-	__releases(rq->lock)
-{
-	struct rq *rq;
-
-	rq = cpu_rq(smp_processor_id());
-	spin_unlock(&rq->lock);
-	local_irq_restore(*flags);
-}
-
 void task_rq_unlock_wait(struct task_struct *p)
 {
 	struct rq *rq = task_rq(p);

-- 

