Return-Path: <linux-kernel-owner+w=401wt.eu-S1754926AbZBQWEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbZBQWEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 17:04:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbZBQWDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 17:03:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:46391 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbZBQWDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 17:03:22 -0500
Message-Id: <20090217220053.596214345@chello.nl>
References: <20090217215904.059250145@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 17 Feb 2009 22:59:07 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/3] generic-ipi: remove CSD_FLAG_WAIT
Content-Disposition: inline; filename=smp-wait.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg noticed that we don't strictly need CSD_FLAG_WAIT, rework the code so
that we can use CSD_FLAG_LOCK for both purposes.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 block/blk-softirq.c |    2 -
 include/linux/smp.h |    3 +
 kernel/sched.c      |    2 -
 kernel/smp.c        |   90 +++++++++++++---------------------------------------
 kernel/softirq.c    |    2 -
 5 files changed, 28 insertions(+), 71 deletions(-)

Index: linux-2.6/block/blk-softirq.c
===================================================================
--- linux-2.6.orig/block/blk-softirq.c
+++ linux-2.6/block/blk-softirq.c
@@ -64,7 +64,7 @@ static int raise_blk_irq(int cpu, struct
 		data->info = rq;
 		data->flags = 0;
 
-		__smp_call_function_single(cpu, data);
+		__smp_call_function_single(cpu, data, 0);
 		return 0;
 	}
 
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1120,7 +1120,7 @@ static void hrtick_start(struct rq *rq, 
 	if (rq == this_rq()) {
 		hrtimer_restart(timer);
 	} else if (!rq->hrtick_csd_pending) {
-		__smp_call_function_single(cpu_of(rq), &rq->hrtick_csd);
+		__smp_call_function_single(cpu_of(rq), &rq->hrtick_csd, 0);
 		rq->hrtick_csd_pending = 1;
 	}
 }
Index: linux-2.6/kernel/smp.c
===================================================================
--- linux-2.6.orig/kernel/smp.c
+++ linux-2.6/kernel/smp.c
@@ -23,8 +23,7 @@ static struct {
 };
 
 enum {
-	CSD_FLAG_WAIT		= 0x01,
-	CSD_FLAG_LOCK		= 0x02,
+	CSD_FLAG_LOCK		= 0x01,
 };
 
 struct call_function_data {
@@ -95,41 +94,21 @@ static int __cpuinit init_call_single_da
 early_initcall(init_call_single_data);
 
 /*
- * csd_wait/csd_complete are used for synchronous ipi calls
- */
-static void csd_wait_prepare(struct call_single_data *data)
-{
-	data->flags |= CSD_FLAG_WAIT;
-}
-
-static void csd_complete(struct call_single_data *data)
-{
-	if (data->flags & CSD_FLAG_WAIT) {
-		/*
-		 * ensure we're all done before saying we are
-		 */
-		smp_mb();
-		data->flags &= ~CSD_FLAG_WAIT;
-	}
-}
-
-static void csd_wait(struct call_single_data *data)
-{
-	while (data->flags & CSD_FLAG_WAIT)
-		cpu_relax();
-}
-
-/*
  * csd_lock/csd_unlock used to serialize access to per-cpu csd resources
  *
  * For non-synchronous ipi calls the csd can still be in use by the previous
  * function call. For multi-cpu calls its even more interesting as we'll have
  * to ensure no other cpu is observing our csd.
  */
-static void csd_lock(struct call_single_data *data)
+static void csd_lock_wait(struct call_single_data *data)
 {
 	while (data->flags & CSD_FLAG_LOCK)
 		cpu_relax();
+}
+
+static void csd_lock(struct call_single_data *data)
+{
+	csd_lock_wait(data);
 	data->flags = CSD_FLAG_LOCK;
 }
 
@@ -147,11 +126,12 @@ static void csd_unlock(struct call_singl
  * Insert a previously allocated call_single_data element for execution
  * on the given CPU. data must already have ->func, ->info, and ->flags set.
  */
-static void generic_exec_single(int cpu, struct call_single_data *data)
+static
+void generic_exec_single(int cpu, struct call_single_data *data, int wait)
 {
 	struct call_single_queue *dst = &per_cpu(call_single_queue, cpu);
-	int wait = data->flags & CSD_FLAG_WAIT, ipi;
 	unsigned long flags;
+	int ipi;
 
 	spin_lock_irqsave(&dst->lock, flags);
 	ipi = list_empty(&dst->list);
@@ -174,7 +154,7 @@ static void generic_exec_single(int cpu,
 		arch_send_call_function_single_ipi(cpu);
 
 	if (wait)
-		csd_wait(data);
+		csd_lock_wait(data);
 }
 
 /*
@@ -224,7 +204,6 @@ void generic_smp_call_function_interrupt
 		if (refs)
 			continue;
 
-		csd_complete(&data->csd);
 		csd_unlock(&data->csd);
 	}
 
@@ -262,9 +241,6 @@ void generic_smp_call_function_single_in
 
 		data->func(data->info);
 
-		if (data_flags & CSD_FLAG_WAIT)
-			csd_complete(data);
-
 		/*
 		 * Unlocked CSDs are valid through generic_exec_single()
 		 */
@@ -305,36 +281,16 @@ int smp_call_function_single(int cpu, vo
 		func(info);
 		local_irq_restore(flags);
 	} else if ((unsigned)cpu < nr_cpu_ids && cpu_online(cpu)) {
-		struct call_single_data *data;
+		struct call_single_data *data = &d;
 
-		if (!wait) {
-			/*
-			 * We are calling a function on a single CPU
-			 * and we are not going to wait for it to finish.
-			 * We use a per cpu data to pass the information to
-			 * that CPU. Since all callers of this code will
-			 * use the same data, we must synchronize the
-			 * callers to prevent a new caller from corrupting
-			 * the data before the callee can access it.
-			 *
-			 * The CSD_FLAG_LOCK is used to let us know when
-			 * the IPI handler is done with the data.
-			 * The first caller will set it, and the callee
-			 * will clear it. The next caller must wait for
-			 * it to clear before we set it again. This
-			 * will make sure the callee is done with the
-			 * data before a new caller will use it.
-			 */
+		if (!wait)
 			data = &per_cpu(csd_data, me);
-			csd_lock(data);
-		} else {
-			data = &d;
-			csd_wait_prepare(data);
-		}
+
+		csd_lock(data);
 
 		data->func = func;
 		data->info = info;
-		generic_exec_single(cpu, data);
+		generic_exec_single(cpu, data, wait);
 	} else {
 		err = -ENXIO;	/* CPU not online */
 	}
@@ -354,12 +310,15 @@ EXPORT_SYMBOL(smp_call_function_single);
  * instance.
  *
  */
-void __smp_call_function_single(int cpu, struct call_single_data *data)
+void __smp_call_function_single(int cpu, struct call_single_data *data,
+				int wait)
 {
+	csd_lock(data);
+
 	/* Can deadlock when called with interrupts disabled */
-	WARN_ON((data->flags & CSD_FLAG_WAIT) && irqs_disabled());
+	WARN_ON(wait && irqs_disabled());
 
-	generic_exec_single(cpu, data);
+	generic_exec_single(cpu, data, wait);
 }
 
 /* FIXME: Shim for archs using old arch_send_call_function_ipi API. */
@@ -417,9 +376,6 @@ void smp_call_function_many(const struct
 	csd_lock(&data->csd);
 
 	spin_lock_irqsave(&data->lock, flags);
-	if (wait)
-		csd_wait_prepare(&data->csd);
-
 	data->csd.func = func;
 	data->csd.info = info;
 	cpumask_and(data->cpumask, mask, cpu_online_mask);
@@ -448,7 +404,7 @@ void smp_call_function_many(const struct
 
 	/* optionally wait for the CPUs to complete */
 	if (wait)
-		csd_wait(&data->csd);
+		csd_lock_wait(&data->csd);
 }
 EXPORT_SYMBOL(smp_call_function_many);
 
Index: linux-2.6/kernel/softirq.c
===================================================================
--- linux-2.6.orig/kernel/softirq.c
+++ linux-2.6/kernel/softirq.c
@@ -518,7 +518,7 @@ static int __try_remote_softirq(struct c
 		cp->flags = 0;
 		cp->priv = softirq;
 
-		__smp_call_function_single(cpu, cp);
+		__smp_call_function_single(cpu, cp, 0);
 		return 0;
 	}
 	return 1;
Index: linux-2.6/include/linux/smp.h
===================================================================
--- linux-2.6.orig/include/linux/smp.h
+++ linux-2.6/include/linux/smp.h
@@ -82,7 +82,8 @@ smp_call_function_mask(cpumask_t mask, v
 	return 0;
 }
 
-void __smp_call_function_single(int cpuid, struct call_single_data *data);
+void __smp_call_function_single(int cpuid, struct call_single_data *data,
+				int wait);
 
 /*
  * Generic and arch helpers

-- 

