Return-Path: <linux-kernel-owner+w=401wt.eu-S1753755AbZBQPls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbZBQPls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 10:41:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbZBQPlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 10:41:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46361 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbZBQPli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 10:41:38 -0500
Subject: [PATCH] generic-smp: remove kmalloc()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <20090216164114.433430761@chello.nl>
References: <20090216163847.431174825@chello.nl>
	 <20090216164114.433430761@chello.nl>
Content-Type: text/plain
Date: Tue, 17 Feb 2009 16:40:58 +0100
Message-Id: <1234885258.4744.153.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, so this is on top of Nick's cleanup from earlier today, and folds
everything.

No more RCU games as the storage for per-cpu entries is permanent - cpu
hotplug should be good because it does a synchronize_sched().

What we do play games with is the global list, we can extract entries
and place them to the front while its being observed. This means that
the list iteration can see some entries twice (not a problem since we
remove ourselves from the cpumask), but cannot miss entries.

Not-quite-signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 smp.c |  260 ++++++++++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 159 insertions(+), 101 deletions(-)

Index: linux-2.6/kernel/smp.c
===================================================================
--- linux-2.6.orig/kernel/smp.c
+++ linux-2.6/kernel/smp.c
@@ -10,23 +10,28 @@
 #include <linux/rcupdate.h>
 #include <linux/rculist.h>
 #include <linux/smp.h>
+#include <linux/cpu.h>
 
 static DEFINE_PER_CPU(struct call_single_queue, call_single_queue);
-static LIST_HEAD(call_function_queue);
-__cacheline_aligned_in_smp DEFINE_SPINLOCK(call_function_lock);
+
+static struct {
+	struct list_head	queue;
+	spinlock_t		lock;
+} call_function __cacheline_aligned_in_smp = {
+	.queue = LIST_HEAD_INIT(call_function.queue),
+	.lock  = __SPIN_LOCK_UNLOCKED(call_function.lock),
+};
 
 enum {
 	CSD_FLAG_WAIT		= 0x01,
-	CSD_FLAG_ALLOC		= 0x02,
-	CSD_FLAG_LOCK		= 0x04,
+	CSD_FLAG_LOCK		= 0x02,
 };
 
 struct call_function_data {
 	struct call_single_data csd;
 	spinlock_t lock;
 	unsigned int refs;
-	struct rcu_head rcu_head;
-	unsigned long cpumask_bits[];
+	cpumask_var_t cpumask;
 };
 
 struct call_single_queue {
@@ -34,8 +39,45 @@ struct call_single_queue {
 	spinlock_t lock;
 };
 
+static DEFINE_PER_CPU(struct call_function_data, cfd_data) = {
+	.lock = __SPIN_LOCK_UNLOCKED(cfd_data.lock),
+};
+
+static int
+hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
+{
+	long cpu = (long)hcpu;
+	struct call_function_data *cfd = &per_cpu(cfd_data, cpu);
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		if (!alloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
+				cpu_to_node(cpu)))
+			return NOTIFY_BAD;
+		break;
+
+#ifdef CONFIG_CPU_HOTPLUG
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		free_cpumask_var(cfd->cpumask);
+		break;
+#endif
+	};
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata hotplug_cfd_notifier = {
+	.notifier_call = hotplug_cfd,
+};
+
 static int __cpuinit init_call_single_data(void)
 {
+	void *cpu = (void *)(long)smp_processor_id();
 	int i;
 
 	for_each_possible_cpu(i) {
@@ -44,18 +86,61 @@ static int __cpuinit init_call_single_da
 		spin_lock_init(&q->lock);
 		INIT_LIST_HEAD(&q->list);
 	}
+
+	hotplug_cfd(&hotplug_cfd_notifier, CPU_UP_PREPARE, cpu);
+	register_cpu_notifier(&hotplug_cfd_notifier);
+
 	return 0;
 }
 early_initcall(init_call_single_data);
 
-static void csd_flag_wait(struct call_single_data *data)
+/*
+ * csd_wait/csd_complete are used for synchronous ipi calls
+ */
+static void csd_wait_prepare(struct call_single_data *data)
 {
-	/* Wait for response */
-	do {
-		if (!(data->flags & CSD_FLAG_WAIT))
-			break;
+	data->flags |= CSD_FLAG_WAIT;
+}
+
+static void csd_complete(struct call_single_data *data)
+{
+	if (data->flags & CSD_FLAG_WAIT) {
+		/*
+		 * Serialize stores to data with the flag clear and wakeup.
+		 */
+		smp_wmb();
+		data->flags &= ~CSD_FLAG_WAIT;
+	}
+}
+
+static void csd_wait(struct call_single_data *data)
+{
+	while (data->flags & CSD_FLAG_WAIT)
 		cpu_relax();
-	} while (1);
+}
+
+/*
+ * csd_lock/csd_unlock used to serialize access to per-cpu csd resources
+ *
+ * For non-synchronous ipi calls the csd can still be in use by the previous
+ * function call. For multi-cpu calls its even more interesting as we'll have
+ * to ensure no other cpu is observing our csd.
+ */
+static void csd_lock(struct call_single_data *data)
+{
+	while (data->flags & CSD_FLAG_LOCK)
+		cpu_relax();
+	data->flags = CSD_FLAG_LOCK;
+}
+
+static void csd_unlock(struct call_single_data *data)
+{
+	WARN_ON(!(data->flags & CSD_FLAG_LOCK));
+	/*
+	 * Serialize stores to data with the flags clear.
+	 */
+	smp_wmb();
+	data->flags &= ~CSD_FLAG_LOCK;
 }
 
 /*
@@ -89,16 +174,7 @@ static void generic_exec_single(int cpu,
 		arch_send_call_function_single_ipi(cpu);
 
 	if (wait)
-		csd_flag_wait(data);
-}
-
-static void rcu_free_call_data(struct rcu_head *head)
-{
-	struct call_function_data *data;
-
-	data = container_of(head, struct call_function_data, rcu_head);
-
-	kfree(data);
+		csd_wait(data);
 }
 
 /*
@@ -122,41 +198,32 @@ void generic_smp_call_function_interrupt
 	 * It's ok to use list_for_each_rcu() here even though we may delete
 	 * 'pos', since list_del_rcu() doesn't clear ->next
 	 */
-	rcu_read_lock();
-	list_for_each_entry_rcu(data, &call_function_queue, csd.list) {
+	list_for_each_entry_rcu(data, &call_function.queue, csd.list) {
 		int refs;
 
-		if (!cpumask_test_cpu(cpu, to_cpumask(data->cpumask_bits)))
-			continue;
-
-		data->csd.func(data->csd.info);
-
 		spin_lock(&data->lock);
-		cpumask_clear_cpu(cpu, to_cpumask(data->cpumask_bits));
+		if (!cpumask_test_cpu(cpu, data->cpumask)) {
+			spin_unlock(&data->lock);
+			continue;
+		}
+		cpumask_clear_cpu(cpu, data->cpumask);
 		WARN_ON(data->refs == 0);
 		data->refs--;
 		refs = data->refs;
 		spin_unlock(&data->lock);
 
+		data->csd.func(data->csd.info);
+
 		if (refs)
 			continue;
 
-		spin_lock(&call_function_lock);
+		spin_lock(&call_function.lock);
 		list_del_rcu(&data->csd.list);
-		spin_unlock(&call_function_lock);
+		spin_unlock(&call_function.lock);
 
-		if (data->csd.flags & CSD_FLAG_WAIT) {
-			/*
-			 * serialize stores to data with the flag clear
-			 * and wakeup
-			 */
-			smp_wmb();
-			data->csd.flags &= ~CSD_FLAG_WAIT;
-		}
-		if (data->csd.flags & CSD_FLAG_ALLOC)
-			call_rcu(&data->rcu_head, rcu_free_call_data);
+		csd_complete(&data->csd);
+		csd_unlock(&data->csd);
 	}
-	rcu_read_unlock();
 
 	put_cpu();
 }
@@ -192,14 +259,14 @@ void generic_smp_call_function_single_in
 
 		data->func(data->info);
 
-		if (data_flags & CSD_FLAG_WAIT) {
-			smp_wmb();
-			data->flags &= ~CSD_FLAG_WAIT;
-		} else if (data_flags & CSD_FLAG_LOCK) {
-			smp_wmb();
-			data->flags &= ~CSD_FLAG_LOCK;
-		} else if (data_flags & CSD_FLAG_ALLOC)
-			kfree(data);
+		if (data_flags & CSD_FLAG_WAIT)
+			csd_complete(data);
+
+		/*
+		 * Unlocked CSDs are valid through generic_exec_single()
+		 */
+		if (data_flags & CSD_FLAG_LOCK)
+			csd_unlock(data);
 	}
 }
 
@@ -233,19 +300,19 @@ int smp_call_function_single(int cpu, vo
 		func(info);
 		local_irq_restore(flags);
 	} else if ((unsigned)cpu < nr_cpu_ids && cpu_online(cpu)) {
-		struct call_single_data *data;
+		struct call_single_data *data = {
+			.flags = 0,
+		};
 
 		if (!wait) {
 			/*
 			 * We are calling a function on a single CPU
 			 * and we are not going to wait for it to finish.
-			 * We first try to allocate the data, but if we
-			 * fail, we fall back to use a per cpu data to pass
-			 * the information to that CPU. Since all callers
-			 * of this code will use the same data, we must
-			 * synchronize the callers to prevent a new caller
-			 * from corrupting the data before the callee
-			 * can access it.
+			 * We use a per cpu data to pass the information to
+			 * that CPU. Since all callers of this code will
+			 * use the same data, we must synchronize the
+			 * callers to prevent a new caller from corrupting
+			 * the data before the callee can access it.
 			 *
 			 * The CSD_FLAG_LOCK is used to let us know when
 			 * the IPI handler is done with the data.
@@ -255,18 +322,11 @@ int smp_call_function_single(int cpu, vo
 			 * will make sure the callee is done with the
 			 * data before a new caller will use it.
 			 */
-			data = kmalloc(sizeof(*data), GFP_ATOMIC);
-			if (data)
-				data->flags = CSD_FLAG_ALLOC;
-			else {
-				data = &per_cpu(csd_data, me);
-				while (data->flags & CSD_FLAG_LOCK)
-					cpu_relax();
-				data->flags = CSD_FLAG_LOCK;
-			}
+			data = &per_cpu(csd_data, me);
+			csd_lock(data);
 		} else {
 			data = &d;
-			data->flags = CSD_FLAG_WAIT;
+			csd_wait_prepare(data);
 		}
 
 		data->func = func;
@@ -326,14 +386,14 @@ void smp_call_function_many(const struct
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
@@ -341,7 +401,7 @@ void smp_call_function_many(const struct
 
 	/* Do we have another CPU which isn't us? */
 	next_cpu = cpumask_next_and(cpu, mask, cpu_online_mask);
-	if (next_cpu == smp_processor_id())
+	if (next_cpu == me)
 		next_cpu = cpumask_next_and(next_cpu, mask, cpu_online_mask);
 
 	/* Fastpath: do that cpu by itself. */
@@ -350,31 +410,28 @@ void smp_call_function_many(const struct
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
-	}
+	data = &per_cpu(cfd_data, me);
+	csd_lock(&data->csd);
 
-	spin_lock_init(&data->lock);
-	data->csd.flags = CSD_FLAG_ALLOC;
+	spin_lock_irqsave(&data->lock, flags);
 	if (wait)
-		data->csd.flags |= CSD_FLAG_WAIT;
+		csd_wait_prepare(&data->csd);
+
 	data->csd.func = func;
 	data->csd.info = info;
-	cpumask_and(to_cpumask(data->cpumask_bits), mask, cpu_online_mask);
-	cpumask_clear_cpu(smp_processor_id(), to_cpumask(data->cpumask_bits));
-	data->refs = cpumask_weight(to_cpumask(data->cpumask_bits));
-
-	spin_lock_irqsave(&call_function_lock, flags);
-	list_add_tail_rcu(&data->csd.list, &call_function_queue);
-	spin_unlock_irqrestore(&call_function_lock, flags);
+	cpumask_and(data->cpumask, mask, cpu_online_mask);
+	cpumask_clear_cpu(me, data->cpumask);
+	data->refs = cpumask_weight(data->cpumask);
+
+	spin_lock(&call_function.lock);
+	/*
+	 * Place entry at the _HEAD_ of the list, so that any cpu still
+	 * observing the entry in generic_smp_call_function_interrupt() will
+	 * not miss any other list entries.
+	 */
+	list_add_rcu(&data->csd.list, &call_function.queue);
+	spin_unlock(&call_function.lock);
+	spin_unlock_irqrestore(&data->lock, flags);
 
 	/*
 	 * Make the list addition visible before sending the ipi.
@@ -384,11 +441,11 @@ void smp_call_function_many(const struct
 	smp_mb();
 
 	/* Send a message to all CPUs in the map */
-	arch_send_call_function_ipi_mask(to_cpumask(data->cpumask_bits));
+	arch_send_call_function_ipi_mask(data->cpumask);
 
 	/* optionally wait for the CPUs to complete */
 	if (wait)
-		csd_flag_wait(&data->csd);
+		csd_wait(&data->csd);
 }
 EXPORT_SYMBOL(smp_call_function_many);
 
@@ -418,20 +475,20 @@ EXPORT_SYMBOL(smp_call_function);
 
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


