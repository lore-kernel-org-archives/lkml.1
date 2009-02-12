Return-Path: <linux-kernel-owner+w=401wt.eu-S1759428AbZBLWlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428AbZBLWlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 17:41:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756980AbZBLWkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 17:40:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:48229 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbZBLWkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 17:40:19 -0500
Message-Id: <20090212223750.295581470@chello.nl>
References: <20090212223200.979433820@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 12 Feb 2009 23:32:01 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/2] generic-smp: remove single ipi fallback for smp_call_function_many()
Content-Disposition: inline; filename=smp-many-fallback.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation of removing the kmalloc() calls from the generic-ipi code
get rid of the single ipi fallback for smp_call_function_many().

Because we cannot get around carrying the cpumask in the data -- imagine
2 such calls with different but overlapping masks -- put in a full mask.

Also, since we cannot simply remove an item from the global queue (another
cpu might be observing it), a quiesence of sorts needs to be observed. The
current code uses regular RCU for that purpose.

However, since we'll be wanting to quickly reuse an item, we need something
with a much faster turn-around. We do this by simply observing the global
queue quiesence. Since there are a limited number of elements, it will auto
force a quiecent state if we wait for it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/smp.c |  118 +++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 78 insertions(+), 40 deletions(-)

Index: linux-2.6/kernel/smp.c
===================================================================
--- linux-2.6.orig/kernel/smp.c
+++ linux-2.6/kernel/smp.c
@@ -12,8 +12,22 @@
 #include <linux/smp.h>
 
 static DEFINE_PER_CPU(struct call_single_queue, call_single_queue);
-static LIST_HEAD(call_function_queue);
-__cacheline_aligned_in_smp DEFINE_SPINLOCK(call_function_lock);
+
+static struct {
+	struct list_head	queue;
+	spinlock_t		lock;
+	/*
+	 * mini-RCU state machine
+	 *
+	 * @counter counts the number of entries on the queue, and @quiesent
+	 * is a sequence count incremented every time the queue is idle.
+	 */
+	unsigned int		counter;
+	unsigned int		quiesent;
+} call_function __cacheline_aligned_in_smp = {
+	.queue = LIST_HEAD_INIT(call_function.queue),
+	.lock  = __SPIN_LOCK_UNLOCKED(call_function.lock),
+};
 
 enum {
 	CSD_FLAG_WAIT		= 0x01,
@@ -25,8 +39,11 @@ struct call_function_data {
 	struct call_single_data csd;
 	spinlock_t lock;
 	unsigned int refs;
-	struct rcu_head rcu_head;
-	unsigned long cpumask_bits[];
+	union {
+		struct rcu_head rcu_head;
+		unsigned int stamp;
+	};
+	struct cpumask cpumask;
 };
 
 struct call_single_queue {
@@ -107,17 +124,16 @@ void generic_smp_call_function_interrupt
 	 * It's ok to use list_for_each_rcu() here even though we may delete
 	 * 'pos', since list_del_rcu() doesn't clear ->next
 	 */
-	rcu_read_lock();
-	list_for_each_entry_rcu(data, &call_function_queue, csd.list) {
-		int refs;
+	list_for_each_entry_rcu(data, &call_function.queue, csd.list) {
+		int refs, busy = 0;
 
-		if (!cpumask_test_cpu(cpu, to_cpumask(data->cpumask_bits)))
+		if (!cpumask_test_cpu(cpu, &data->cpumask))
 			continue;
 
 		data->csd.func(data->csd.info);
 
 		spin_lock(&data->lock);
-		cpumask_clear_cpu(cpu, to_cpumask(data->cpumask_bits));
+		cpumask_clear_cpu(cpu, &data->cpumask);
 		WARN_ON(data->refs == 0);
 		data->refs--;
 		refs = data->refs;
@@ -126,9 +142,13 @@ void generic_smp_call_function_interrupt
 		if (refs)
 			continue;
 
-		spin_lock(&call_function_lock);
+		spin_lock(&call_function.lock);
 		list_del_rcu(&data->csd.list);
-		spin_unlock(&call_function_lock);
+		if (!--call_function.counter)
+			call_function.quiesent++;
+		else
+			busy = 1;
+		spin_unlock(&call_function.lock);
 
 		if (data->csd.flags & CSD_FLAG_WAIT) {
 			/*
@@ -138,10 +158,17 @@ void generic_smp_call_function_interrupt
 			smp_wmb();
 			data->csd.flags &= ~CSD_FLAG_WAIT;
 		}
-		if (data->csd.flags & CSD_FLAG_ALLOC)
-			call_rcu(&data->rcu_head, rcu_free_call_data);
+		if (data->csd.flags & CSD_FLAG_LOCK) {
+			smp_wmb();
+			data->csd.flags &= ~CSD_FLAG_LOCK;
+		}
+		if (data->csd.flags & CSD_FLAG_ALLOC) {
+			if (busy)
+				call_rcu(&data->rcu_head, rcu_free_call_data);
+			else
+				kfree(data);
+		}
 	}
-	rcu_read_unlock();
 
 	put_cpu();
 }
@@ -302,6 +329,8 @@ void __smp_call_function_single(int cpu,
 	arch_send_call_function_ipi(*(maskp))
 #endif
 
+static DEFINE_PER_CPU(struct call_function_data, cfd_data);
+
 /**
  * smp_call_function_many(): Run a function on a set of other CPUs.
  * @mask: The set of cpus to run on (only runs on online subset).
@@ -323,14 +352,14 @@ void smp_call_function_many(const struct
 {
 	struct call_function_data *data;
 	unsigned long flags;
-	int cpu, next_cpu;
+	int cpu, next_cpu, me = smp_processor_id();
 
 	/* Can deadlock when called with interrupts disabled */
 	WARN_ON(irqs_disabled());
 
 	/* So, what's a CPU they want?  Ignoring this one. */
 	cpu = cpumask_first_and(mask, cpu_online_mask);
-	if (cpu == smp_processor_id())
+	if (cpu == me)
 		cpu = cpumask_next_and(cpu, mask, cpu_online_mask);
 	/* No online cpus?  We're done. */
 	if (cpu >= nr_cpu_ids)
@@ -338,7 +367,7 @@ void smp_call_function_many(const struct
 
 	/* Do we have another CPU which isn't us? */
 	next_cpu = cpumask_next_and(cpu, mask, cpu_online_mask);
-	if (next_cpu == smp_processor_id())
+	if (next_cpu == me)
 		next_cpu = cpumask_next_and(next_cpu, mask, cpu_online_mask);
 
 	/* Fastpath: do that cpu by itself. */
@@ -347,31 +376,40 @@ void smp_call_function_many(const struct
 		return;
 	}
 
-	data = kmalloc(sizeof(*data) + cpumask_size(), GFP_ATOMIC);
-	if (unlikely(!data)) {
-		/* Slow path. */
-		for_each_online_cpu(cpu) {
-			if (cpu == smp_processor_id())
-				continue;
-			if (cpumask_test_cpu(cpu, mask))
-				smp_call_function_single(cpu, func, info, wait);
-		}
-		return;
+	data = kmalloc(sizeof(*data), GFP_ATOMIC);
+	if (data)
+		data->csd.flags = CSD_FLAG_ALLOC;
+	else {
+		data = &per_cpu(cfd_data, me);
+		/*
+		 * We need to wait for all previous users to go away.
+		 */
+		while (data->csd.flags & CSD_FLAG_LOCK)
+			cpu_relax();
+		/*
+		 * Then we need to wait for the queue to pass through a
+		 * quiesent state, so that no other cpus can observe the
+		 * element anymore.
+		 */
+		while (data->stamp == call_function.quiesent)
+			cpu_relax();
+		data->csd.flags = CSD_FLAG_LOCK;
 	}
 
 	spin_lock_init(&data->lock);
-	data->csd.flags = CSD_FLAG_ALLOC;
 	if (wait)
 		data->csd.flags |= CSD_FLAG_WAIT;
 	data->csd.func = func;
 	data->csd.info = info;
-	cpumask_and(to_cpumask(data->cpumask_bits), mask, cpu_online_mask);
-	cpumask_clear_cpu(smp_processor_id(), to_cpumask(data->cpumask_bits));
-	data->refs = cpumask_weight(to_cpumask(data->cpumask_bits));
-
-	spin_lock_irqsave(&call_function_lock, flags);
-	list_add_tail_rcu(&data->csd.list, &call_function_queue);
-	spin_unlock_irqrestore(&call_function_lock, flags);
+	cpumask_and(&data->cpumask, mask, cpu_online_mask);
+	cpumask_clear_cpu(smp_processor_id(), &data->cpumask);
+	data->refs = cpumask_weight(&data->cpumask);
+
+	spin_lock_irqsave(&call_function.lock, flags);
+	call_function.counter++;
+	data->stamp = call_function.quiesent;
+	list_add_tail_rcu(&data->csd.list, &call_function.queue);
+	spin_unlock_irqrestore(&call_function.lock, flags);
 
 	/*
 	 * Make the list addition visible before sending the ipi.
@@ -379,7 +417,7 @@ void smp_call_function_many(const struct
 	smp_mb();
 
 	/* Send a message to all CPUs in the map */
-	arch_send_call_function_ipi_mask(to_cpumask(data->cpumask_bits));
+	arch_send_call_function_ipi_mask(&data->cpumask);
 
 	/* optionally wait for the CPUs to complete */
 	if (wait)
@@ -413,20 +451,20 @@ EXPORT_SYMBOL(smp_call_function);
 
 void ipi_call_lock(void)
 {
-	spin_lock(&call_function_lock);
+	spin_lock(&call_function.lock);
 }
 
 void ipi_call_unlock(void)
 {
-	spin_unlock(&call_function_lock);
+	spin_unlock(&call_function.lock);
 }
 
 void ipi_call_lock_irq(void)
 {
-	spin_lock_irq(&call_function_lock);
+	spin_lock_irq(&call_function.lock);
 }
 
 void ipi_call_unlock_irq(void)
 {
-	spin_unlock_irq(&call_function_lock);
+	spin_unlock_irq(&call_function.lock);
 }

-- 

