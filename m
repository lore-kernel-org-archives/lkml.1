Return-Path: <linux-kernel-owner+w=401wt.eu-S964814AbYCSUir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964814AbYCSUir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757907AbYCSTmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:42:06 -0400
Received: from brick.kernel.dk ([87.55.233.238]:26256 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757870AbYCSTl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:41:59 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: npiggin@suse.de, paulus@samba.org, tglx@linutronix.de, mingo@redhat.com,
       tony.luck@intel.com, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 1/5] Add generic helpers for arch IPI function calls
Date: Wed, 19 Mar 2008 12:56:08 +0100
Message-Id: <1205927772-31401-2-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com>
References: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds kernel/smp.c which contains helpers for IPI function calls. In
addition to supporting the existing smp_call_function() in a more efficient
manner, it also adds a more scalable variant called smp_call_function_single()
for calling a given function on a single CPU only.

The core of this is based on the x86-64 patch from Nick Piggin.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/linux/smp.h |   30 +++++-
 kernel/Makefile     |    2 +-
 kernel/smp.c        |  316 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 345 insertions(+), 3 deletions(-)
 create mode 100644 kernel/smp.c

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 55232cc..19b217e 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -7,9 +7,19 @@
  */
 
 #include <linux/errno.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/cpumask.h>
 
 extern void cpu_idle(void);
 
+struct call_single_data {
+	struct list_head list;
+	void (*func) (void *info);
+	void *info;
+	unsigned int flags;
+};
+
 #ifdef CONFIG_SMP
 
 #include <linux/preempt.h>
@@ -50,12 +60,27 @@ extern int __cpu_up(unsigned int cpunum);
 extern void smp_cpus_done(unsigned int max_cpus);
 
 /*
- * Call a function on all other processors
+ * Call a function on all other processors - arch exported functions
  */
 int smp_call_function(void(*func)(void *info), void *info, int retry, int wait);
-
 int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
 				int retry, int wait);
+void __smp_call_function_single(int cpuid, struct call_single_data *data);
+
+/*
+ * Generic helpers
+ */
+int generic_smp_call_function_single(int cpuid, void (*func) (void *info),
+					void *info, int wait,
+					void (*send_ipi)(int cpu));
+int generic_smp_call_function(void (*func) (void *info), void *info, int wait,
+				cpumask_t mask, void (*send_ipi)(cpumask_t));
+void generic_exec_single(int cpu, struct call_single_data *data,
+			 void (*send_ipi)(int cpu));
+void generic_smp_call_function_single_interrupt(void);
+void generic_smp_call_function_interrupt(void);
+
+extern spinlock_t call_function_lock;
 
 /*
  * Call a function on all processors
@@ -92,6 +117,7 @@ static inline int up_smp_call_function(void (*func)(void *), void *info)
 }
 #define smp_call_function(func, info, retry, wait) \
 			(up_smp_call_function(func, info))
+
 #define on_each_cpu(func,info,retry,wait)	\
 	({					\
 		local_irq_disable();		\
diff --git a/kernel/Makefile b/kernel/Makefile
index 6c584c5..a805976 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -27,7 +27,7 @@ obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
 obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
 obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
 obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
-obj-$(CONFIG_SMP) += cpu.o spinlock.o
+obj-$(CONFIG_SMP) += cpu.o spinlock.o smp.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
 obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
 obj-$(CONFIG_UID16) += uid16.o
diff --git a/kernel/smp.c b/kernel/smp.c
new file mode 100644
index 0000000..ab2da5c
--- /dev/null
+++ b/kernel/smp.c
@@ -0,0 +1,316 @@
+/*
+ * Generic helpers for smp ipi calls
+ *
+ * (C) Jens Axboe <jens.axboe@oracle.com> 2008
+ *
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/percpu.h>
+#include <linux/rcupdate.h>
+#include <linux/smp.h>
+
+static DEFINE_PER_CPU(struct call_single_queue, call_single_queue);
+static LIST_HEAD(call_function_queue);
+__cacheline_aligned_in_smp DEFINE_SPINLOCK(call_function_lock);
+
+enum {
+	CSD_FLAG_WAIT		= 0x01,
+	CSD_FLAG_ALLOC		= 0x02,
+	CSD_FLAG_FALLBACK	= 0x04,
+};
+
+struct call_function_data {
+	struct call_single_data csd;
+	spinlock_t lock;
+	unsigned int refs;
+	cpumask_t cpumask;
+	struct rcu_head rcu_head;
+};
+
+struct call_single_queue {
+	struct list_head list;
+	spinlock_t lock;
+	int activated;
+};
+
+/*
+ * Fallback data to use, if the dyn allocation fails
+ */
+static struct call_function_data call_data_fallback;
+static unsigned long call_fallback_used;
+
+static int __cpuinit init_call_single_data(void)
+{
+	int i;
+
+	for_each_cpu_mask(i, cpu_possible_map) {
+		struct call_single_queue *q = &per_cpu(call_single_queue, i);
+
+		spin_lock_init(&q->lock);
+		INIT_LIST_HEAD(&q->list);
+		q->activated = 0;
+	}
+	return 0;
+}
+core_initcall(init_call_single_data);
+
+/*
+ * Insert a previously allocated call_single_data element for execution
+ * on the given CPU. data must already have ->func, ->info, and ->flags set.
+ */
+void generic_exec_single(int cpu, struct call_single_data *data,
+			 void (*send_ipi)(int cpu))
+{
+	struct call_single_queue *dst;
+	unsigned long flags;
+	int wait = data->flags & CSD_FLAG_WAIT, ipi = 0;
+
+	INIT_LIST_HEAD(&data->list);
+
+	dst = &per_cpu(call_single_queue, cpu);
+	spin_lock_irqsave(&dst->lock, flags);
+	list_add_tail(&data->list, &dst->list);
+
+	smp_rmb();
+	if (!dst->activated) {
+		dst->activated = 1;
+		ipi = 1;
+	}
+
+	spin_unlock_irqrestore(&dst->lock, flags);
+
+	if (ipi)
+		send_ipi(cpu);
+
+	if (wait) {
+		/* Wait for response */
+		smp_rmb();
+		while (data->flags) {
+			cpu_relax();
+			smp_rmb();
+		}
+	}
+}
+
+/*
+ * Execute func(info) on the given cpu
+ */
+int generic_smp_call_function_single(int cpu, void (*func) (void *info),
+				     void *info, int wait,
+				     void (*send_ipi)(int cpu))
+{
+	unsigned long flags;
+	/* prevent preemption and reschedule on another processor */
+	int me = get_cpu();
+	int ret = 0;
+
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(wait && irqs_disabled());
+
+	if (cpu == me) {
+		local_irq_save(flags);
+		func(info);
+		local_irq_restore(flags);
+	} else {
+		struct call_single_data d;
+		struct call_single_data *data;
+
+		if (!wait) {
+			data = kmalloc(sizeof(*data), GFP_ATOMIC);
+			if (unlikely(!data)) {
+				ret = -ENOMEM;
+				goto out;
+			}
+			data->flags = CSD_FLAG_ALLOC;
+		} else {
+			data = &d;
+			data->flags = CSD_FLAG_WAIT;
+		}
+
+		data->func = func;
+		data->info = info;
+		generic_exec_single(cpu, data, send_ipi);
+	}
+out:
+	put_cpu();
+	return ret;
+}
+
+static void rcu_free_call_data(struct rcu_head *head)
+{
+	struct call_function_data *cfd;
+
+	cfd = container_of(head, struct call_function_data, rcu_head);
+	kfree(cfd);
+}
+
+static void call_func_data_free(struct call_function_data *data)
+{
+	if (data->csd.flags & CSD_FLAG_ALLOC)
+		call_rcu(&data->rcu_head, rcu_free_call_data);
+	else
+		clear_bit_unlock(0, &call_fallback_used);
+}
+
+static struct call_function_data *call_func_data_alloc(gfp_t gfp, int wait_done)
+{
+	struct call_function_data *data;
+
+	data = kmalloc(sizeof(*data), gfp);
+	if (likely(data))
+		data->csd.flags = CSD_FLAG_ALLOC;
+	else {
+		while (test_and_set_bit_lock(0, &call_fallback_used))
+			cpu_relax();
+
+		data = &call_data_fallback;
+		data->csd.flags = CSD_FLAG_FALLBACK;
+	}
+
+	if (wait_done)
+		data->csd.flags |= CSD_FLAG_WAIT;
+
+	spin_lock_init(&data->lock);
+	return data;
+}
+
+/*
+ * Execute func(info) on the specified mask of CPUs
+ */
+int generic_smp_call_function(void (*func)(void *info), void *info, int wait,
+				cpumask_t mask,
+				void (*send_ipi)(cpumask_t mask))
+{
+	struct call_function_data *data;
+	cpumask_t allbutself;
+	int num_cpus;
+
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(wait && irqs_disabled());
+
+	allbutself = cpu_online_map;
+	cpu_clear(smp_processor_id(), allbutself);
+	cpus_and(mask, mask, allbutself);
+	num_cpus = cpus_weight(mask);
+
+	if (!num_cpus)
+		return 0;
+
+	data = call_func_data_alloc(GFP_ATOMIC, wait);
+	data->csd.func = func;
+	data->csd.info = info;
+	data->refs = num_cpus;
+	data->cpumask = mask;
+
+	local_irq_disable();
+	while (!spin_trylock(&call_function_lock)) {
+		local_irq_enable();
+		cpu_relax();
+		local_irq_disable();
+	}
+
+	list_add_tail_rcu(&data->csd.list, &call_function_queue);
+	spin_unlock(&call_function_lock);
+	local_irq_enable();
+
+	/* Send a message to all CPUs in the map */
+	send_ipi(mask);
+
+	/* optionally wait for the CPUs to complete */
+	if (wait) {
+		smp_rmb();
+		while (data->csd.flags) {
+			cpu_relax();
+			smp_rmb();
+		}
+		call_func_data_free(data);
+	}
+
+	return 0;
+}
+
+/*
+ * Invoked by arch to handle an IPI for call function
+ */
+void generic_smp_call_function_interrupt(void)
+{
+	int cpu = smp_processor_id();
+	struct list_head *pos, *tmp;
+
+	list_for_each_safe_rcu(pos, tmp, &call_function_queue) {
+		struct call_function_data *data;
+		int refs;
+
+		data = list_entry(pos, struct call_function_data, csd.list);
+		if (!cpu_isset(cpu, data->cpumask))
+			continue;
+
+		data->csd.func(data->csd.info);
+		spin_lock(&data->lock);
+		WARN_ON(!cpu_isset(cpu, data->cpumask));
+		cpu_clear(cpu, data->cpumask);
+		WARN_ON(data->refs == 0);
+		data->refs--;
+		refs = data->refs;
+		spin_unlock(&data->lock);
+
+		if (refs)
+			continue;
+
+		WARN_ON(cpus_weight(data->cpumask));
+		spin_lock(&call_function_lock);
+		list_del_rcu(&data->csd.list);
+		spin_unlock(&call_function_lock);
+
+		if (data->csd.flags & CSD_FLAG_WAIT) {
+			smp_wmb();
+			data->csd.flags = 0;
+		} else
+			call_func_data_free(data);
+	}
+}
+
+/*
+ * Invoked by arch to handle an IPI for call function single
+ */
+void generic_smp_call_function_single_interrupt(void)
+{
+	struct call_single_queue *q = &__get_cpu_var(call_single_queue);
+	LIST_HEAD(list);
+
+	/*
+	 * make sure list update is seen
+	 */
+	smp_mb();
+	while (!list_empty(&q->list)) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&q->lock, flags);
+		list_replace_init(&q->list, &list);
+		spin_unlock_irqrestore(&q->lock, flags);
+
+		while (!list_empty(&list)) {
+			struct call_single_data *data;
+
+			data = list_entry(list.next, struct call_single_data,
+						list);
+			list_del(&data->list);
+
+			data->func(data->info);
+			if (data->flags & CSD_FLAG_WAIT) {
+				smp_wmb();
+				data->flags = 0;
+			} else if (data->flags & CSD_FLAG_ALLOC)
+				kfree(data);
+		}
+
+		/*
+		 * make sure list update is seen
+		 */
+		smp_mb();
+	}
+
+	smp_wmb();
+	q->activated = 0;
+}
-- 
1.5.4.GIT

