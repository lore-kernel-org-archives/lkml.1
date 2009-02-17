Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbZBQUuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbZBQUuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 15:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbZBQUuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 15:50:03 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54436 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbZBQUuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 15:50:01 -0500
Subject: Re: [PATCH -v4] generic-ipi: remove kmalloc()
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1234901777.4744.233.camel@laptop>
References: <20090216163847.431174825@chello.nl>
	 <20090216164114.433430761@chello.nl> <1234885258.4744.153.camel@laptop>
	 <20090217172113.GA26459@redhat.com> <1234892420.4744.158.camel@laptop>
	 <1234898958.4744.225.camel@laptop>  <20090217200247.GA8158@redhat.com>
	 <1234901512.4744.230.camel@laptop>  <1234901777.4744.233.camel@laptop>
Content-Type: text/plain
Date: Tue, 17 Feb 2009 21:49:41 +0100
Message-Id: <1234903781.4744.235.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-17 at 21:16 +0100, Peter Zijlstra wrote:
> On Tue, 2009-02-17 at 21:11 +0100, Peter Zijlstra wrote:
> > 
> > > As for the previous version. I am almost sure I missed something
> > > again, but do we really need both CSD_FLAG_WAIT and CSD_FLAG_LOCK
> > > flags? smp_call_function_many(wait => 1) can just wait for
> > > !CSD_FLAG_LOCK.
> > 
> > I suppose we can.
> 
> Ah, no, that would mean we cannot distinguish between the sync and async
> case in generic_exec_single().

Which can of course be solved like so, we could even drop the new .wait
argument to __smp_call_function_single() as CSD_FLAG_WAIT wasn't exposed
before and non of the current users use it.

---
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
-		 * Serialize stores to data with the flag clear and wakeup.
-		 */
-		smp_wmb();
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
@@ -222,7 +202,6 @@ void generic_smp_call_function_interrupt
 		if (refs)
 			continue;
 
-		csd_complete(&data->csd);
 		csd_unlock(&data->csd);
 	}
 
@@ -260,9 +239,6 @@ void generic_smp_call_function_single_in
 
 		data->func(data->info);
 
-		if (data_flags & CSD_FLAG_WAIT)
-			csd_complete(data);
-
 		/*
 		 * Unlocked CSDs are valid through generic_exec_single()
 		 */
@@ -303,36 +279,16 @@ int smp_call_function_single(int cpu, vo
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
@@ -352,12 +308,16 @@ EXPORT_SYMBOL(smp_call_function_single);
  * instance.
  *
  */
-void __smp_call_function_single(int cpu, struct call_single_data *data)
+void __smp_call_function_single(int cpu, struct call_single_data *data,
+				int wait)
 {
+	if (wait)
+		csd_lock(data);
+
 	/* Can deadlock when called with interrupts disabled */
-	WARN_ON((data->flags & CSD_FLAG_WAIT) && irqs_disabled());
+	WARN_ON(wait && irqs_disabled());
 
-	generic_exec_single(cpu, data);
+	generic_exec_single(cpu, data, wait);
 }
 
 /* FIXME: Shim for archs using old arch_send_call_function_ipi API. */
@@ -415,9 +375,6 @@ void smp_call_function_many(const struct
 	csd_lock(&data->csd);
 
 	spin_lock_irqsave(&data->lock, flags);
-	if (wait)
-		csd_wait_prepare(&data->csd);
-
 	data->csd.func = func;
 	data->csd.info = info;
 	cpumask_and(data->cpumask, mask, cpu_online_mask);
@@ -446,7 +403,7 @@ void smp_call_function_many(const struct
 
 	/* optionally wait for the CPUs to complete */
 	if (wait)
-		csd_wait(&data->csd);
+		csd_lock_wait(&data->csd);
 }
 EXPORT_SYMBOL(smp_call_function_many);
 
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


