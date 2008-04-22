Return-Path: <linux-kernel-owner+w=401wt.eu-S1756716AbYDVSYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbYDVSYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 14:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167AbYDVSXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 14:23:47 -0400
Received: from brick.kernel.dk ([87.55.233.238]:11019 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788AbYDVSXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 14:23:46 -0400
Date: Tue, 22 Apr 2008 20:23:38 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de
Subject: Re: [PATCH 1/11] Add generic helpers for arch IPI function calls
Message-ID: <20080422182337.GQ12774@kernel.dk>
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com> <1208851058-8500-2-git-send-email-jens.axboe@oracle.com> <alpine.LFD.1.10.0804220735350.2779@woody.linux-foundation.org> <20080422145105.GJ12774@kernel.dk> <alpine.LFD.1.10.0804220759020.2779@woody.linux-foundation.org> <20080422164947.GN12774@kernel.dk> <20080422170405.GO12774@kernel.dk> <20080422171324.GP12774@kernel.dk> <alpine.LFD.1.10.0804221027210.2779@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804221027210.2779@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22 2008, Linus Torvalds wrote:
> 
> 
> On Tue, 22 Apr 2008, Jens Axboe wrote:
> > 
> > But wait, falling back to wait cannot always be safe if we are called
> > with interrupts disabled. I don't see any way around using the global
> > fallback for that case.
> 
> Hmm. Good point. It does look like you need three cases.

OK, so how about this then? All three cases for both
smp_call_function_single() and smp_call_function_mask(). Data is always
freed in the ipi interrupt handler, since the 'wait' case is always
allocated on the stack.


>From 98cafbfd86760ccd3b0498b83b5b9ca044534b04 Mon Sep 17 00:00:00 2001
From: Jens Axboe <jens.axboe@oracle.com>
Date: Tue, 22 Apr 2008 20:14:09 +0200
Subject: [PATCH] Add generic helpers for arch IPI function calls

This adds kernel/smp.c which contains helpers for IPI function calls. In
addition to supporting the existing smp_call_function() in a more efficient
manner, it also adds a more scalable variant called smp_call_function_single()
for calling a given function on a single CPU only.

The core of this is based on the x86-64 patch from Nick Piggin, lots of
changes since then. "Alan D. Brunelle" <Alan.Brunelle@hp.com> has
contributed lots of fixes and suggestions as well.

Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/Kconfig        |    3 +
 include/linux/smp.h |   27 ++++-
 init/main.c         |    3 +
 kernel/Makefile     |    1 +
 kernel/smp.c        |  366 +++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 398 insertions(+), 2 deletions(-)
 create mode 100644 kernel/smp.c

diff --git a/arch/Kconfig b/arch/Kconfig
index 694c9af..a5a0184 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -36,3 +36,6 @@ config HAVE_KPROBES
 
 config HAVE_KRETPROBES
 	def_bool n
+
+config USE_GENERIC_SMP_HELPERS
+	def_bool n
diff --git a/include/linux/smp.h b/include/linux/smp.h
index 55232cc..4a5418b 100644
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
@@ -53,9 +63,23 @@ extern void smp_cpus_done(unsigned int max_cpus);
  * Call a function on all other processors
  */
 int smp_call_function(void(*func)(void *info), void *info, int retry, int wait);
-
+int smp_call_function_mask(cpumask_t mask, void(*func)(void *info), void *info,
+				int wait);
 int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
 				int retry, int wait);
+void __smp_call_function_single(int cpuid, struct call_single_data *data);
+
+/*
+ * Generic and arch helpers
+ */
+#ifdef CONFIG_USE_GENERIC_SMP_HELPERS
+void generic_smp_call_function_single_interrupt(void);
+void generic_smp_call_function_interrupt(void);
+void init_call_single_data(void);
+void arch_send_call_function_single_ipi(int cpu);
+void arch_send_call_function_ipi(cpumask_t mask);
+extern spinlock_t call_function_lock;
+#endif
 
 /*
  * Call a function on all processors
@@ -112,7 +136,6 @@ static inline void smp_send_reschedule(int cpu) { }
 })
 #define smp_call_function_mask(mask, func, info, wait) \
 			(up_smp_call_function(func, info))
-
 #endif /* !SMP */
 
 /*
diff --git a/init/main.c b/init/main.c
index 833a67d..0b7578c 100644
--- a/init/main.c
+++ b/init/main.c
@@ -773,6 +773,9 @@ static void __init do_pre_smp_initcalls(void)
 {
 	extern int spawn_ksoftirqd(void);
 
+#ifdef CONFIG_USE_GENERIC_SMP_HELPERS
+	init_call_single_data();
+#endif
 	migration_init();
 	spawn_ksoftirqd();
 	if (!nosoftlockup)
diff --git a/kernel/Makefile b/kernel/Makefile
index 6c5f081..7e275d4 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
 obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
 obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
 obj-$(CONFIG_SMP) += cpu.o spinlock.o
+obj-$(CONFIG_USE_GENERIC_SMP_HELPERS) += smp.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
 obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
 obj-$(CONFIG_UID16) += uid16.o
diff --git a/kernel/smp.c b/kernel/smp.c
new file mode 100644
index 0000000..a177a0d
--- /dev/null
+++ b/kernel/smp.c
@@ -0,0 +1,366 @@
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
+};
+
+static struct call_function_data cfd_fallback;
+static unsigned long cfd_fallback_used;
+
+void __cpuinit init_call_single_data(void)
+{
+	int i;
+
+	for_each_cpu_mask(i, cpu_possible_map) {
+		struct call_single_queue *q = &per_cpu(call_single_queue, i);
+
+		spin_lock_init(&q->lock);
+		INIT_LIST_HEAD(&q->list);
+	}
+}
+
+static inline void csd_flag_wait(struct call_single_data *data)
+{
+	/* Wait for response */
+	do {
+		/*
+		 * We need to see the flags store in the IPI handler
+		 */
+		smp_mb();
+		if (!(data->flags & CSD_FLAG_WAIT))
+			break;
+		cpu_relax();
+	} while (1);
+}
+
+/*
+ * Insert a previously allocated call_single_data element for execution
+ * on the given CPU. data must already have ->func, ->info, and ->flags set.
+ */
+static void generic_exec_single(int cpu, struct call_single_data *data)
+{
+	struct call_single_queue *dst = &per_cpu(call_single_queue, cpu);
+	int wait = data->flags & CSD_FLAG_WAIT, ipi;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dst->lock, flags);
+	ipi = list_empty(&dst->list);
+	list_add_tail(&data->list, &dst->list);
+	spin_unlock_irqrestore(&dst->lock, flags);
+
+	if (ipi)
+		arch_send_call_function_single_ipi(cpu);
+
+	if (wait)
+		csd_flag_wait(data);
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
+		clear_bit_unlock(0, &cfd_fallback_used);
+}
+
+/*
+ * Invoked by arch to handle an IPI for call function. Must be called with
+ * interrupts disabled.
+ */
+void generic_smp_call_function_interrupt(void)
+{
+	struct list_head *pos;
+	int cpu = get_cpu();
+
+	/*
+	 * It's ok to use list_for_each_rcu() here even though we may delete
+	 * 'pos', since list_del_rcu() doesn't clear ->next
+	 */
+	rcu_read_lock();
+	list_for_each_rcu(pos, &call_function_queue) {
+		struct call_function_data *data;
+		int refs;
+
+		data = list_entry(pos, struct call_function_data, csd.list);
+		if (!cpu_isset(cpu, data->cpumask))
+			continue;
+
+		data->csd.func(data->csd.info);
+
+		spin_lock(&data->lock);
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
+			data->csd.flags &= ~CSD_FLAG_WAIT;
+		} else
+			call_func_data_free(data);
+	}
+	rcu_read_unlock();
+
+	put_cpu();
+}
+
+/*
+ * Invoked by arch to handle an IPI for call function single. Must be called
+ * from the arch with interrupts disabled.
+ */
+void generic_smp_call_function_single_interrupt(void)
+{
+	struct call_single_queue *q = &__get_cpu_var(call_single_queue);
+	LIST_HEAD(list);
+
+	smp_mb();
+	while (!list_empty(&q->list)) {
+		unsigned int data_flags;
+
+		spin_lock(&q->lock);
+		list_replace_init(&q->list, &list);
+		spin_unlock(&q->lock);
+
+		while (!list_empty(&list)) {
+			struct call_single_data *data;
+
+			data = list_entry(list.next, struct call_single_data,
+						list);
+			list_del(&data->list);
+
+			/*
+			 * 'data' can be invalid after this call if
+			 * flags == 0 (when called through
+			 * generic_exec_single(), so save them away before
+			 * making the call.
+			 */
+			data_flags = data->flags;
+
+			data->func(data->info);
+
+			if (data_flags & CSD_FLAG_WAIT) {
+				smp_wmb();
+				data->flags &= ~CSD_FLAG_WAIT;
+			} else if (data_flags & CSD_FLAG_ALLOC)
+				kfree(data);
+			else if (data_flags & CSD_FLAG_FALLBACK)
+				clear_bit_unlock(0, &cfd_fallback_used);
+		}
+		smp_mb();
+	}
+}
+
+/*
+ * smp_call_function_single - Run a function on a specific CPU
+ * @func: The function to run. This must be fast and non-blocking.
+ * @info: An arbitrary pointer to pass to the function.
+ * @retry: Unused
+ * @wait: If true, wait until function has completed on other CPUs.
+ *
+ * Returns 0 on success, else a negative status code.
+ *
+ */
+int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
+			     int retry, int wait)
+{
+	unsigned long flags;
+	/* prevent preemption and reschedule on another processor */
+	int me = get_cpu();
+
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(wait && irqs_disabled());
+
+	if (cpu == me) {
+		local_irq_save(flags);
+		func(info);
+		local_irq_restore(flags);
+	} else {
+		struct call_single_data *data;
+
+		if (wait) {
+			struct call_single_data d;
+
+			data = &d;
+			data->flags = CSD_FLAG_WAIT;
+		} else {
+			data = kmalloc(sizeof(*data), GFP_ATOMIC);
+			if (data)
+				data->flags = CSD_FLAG_ALLOC;
+			else {
+				while (test_and_set_bit_lock(0,
+							&cfd_fallback_used))
+					cpu_relax();
+
+				data = &cfd_fallback.csd;
+				data->flags = CSD_FLAG_FALLBACK;
+			}
+		}
+
+		data->func = func;
+		data->info = info;
+		generic_exec_single(cpu, data);
+	}
+
+	put_cpu();
+	return 0;
+}
+EXPORT_SYMBOL(smp_call_function_single);
+
+/**
+ * __smp_call_function_single(): Run a function on another CPU
+ * @cpu: The CPU to run on.
+ * @data: Pre-allocated and setup data structure
+ *
+ * Like smp_call_function_single(), but allow caller to pass in a pre-allocated
+ * data structure. Useful for embedding @data inside other structures, for
+ * instance.
+ *
+ */
+void __smp_call_function_single(int cpu, struct call_single_data *data)
+{
+	generic_exec_single(cpu, data);
+}
+
+/**
+ * smp_call_function_mask(): Run a function on a set of other CPUs.
+ * @mask: The set of cpus to run on.
+ * @func: The function to run. This must be fast and non-blocking.
+ * @info: An arbitrary pointer to pass to the function.
+ * @wait: If true, wait (atomically) until function has completed on other CPUs.
+ *
+ * Returns 0 on success, else a negative status code.
+ *
+ * If @wait is true, then returns once @func has returned.
+ *
+ * You must not call this function with disabled interrupts or from a
+ * hardware interrupt handler or from a bottom half handler.
+ */
+int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
+			   int wait)
+{
+	struct call_function_data *data;
+	cpumask_t allbutself;
+	unsigned long flags;
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
+	if (wait) {
+		struct call_function_data d;
+
+		data = &d;
+		data->csd.flags = CSD_FLAG_WAIT;
+	} else {
+		data = kmalloc(sizeof(*data), GFP_ATOMIC);
+		if (data)
+			data->csd.flags = CSD_FLAG_ALLOC;
+		else {
+			while (test_and_set_bit_lock(0, &cfd_fallback_used))
+				cpu_relax();
+
+			data = &cfd_fallback;
+			data->csd.flags = CSD_FLAG_FALLBACK;
+		}
+	}
+
+	spin_lock_init(&data->lock);
+	data->csd.func = func;
+	data->csd.info = info;
+	data->refs = num_cpus;
+	data->cpumask = mask;
+
+	spin_lock_irqsave(&call_function_lock, flags);
+	list_add_tail_rcu(&data->csd.list, &call_function_queue);
+	spin_unlock_irqrestore(&call_function_lock, flags);
+
+	/* Send a message to all CPUs in the map */
+	arch_send_call_function_ipi(mask);
+
+	/* optionally wait for the CPUs to complete */
+	if (wait)
+		csd_flag_wait(&data->csd);
+
+	return 0;
+}
+EXPORT_SYMBOL(smp_call_function_mask);
+
+/**
+ * smp_call_function(): Run a function on all other CPUs.
+ * @func: The function to run. This must be fast and non-blocking.
+ * @info: An arbitrary pointer to pass to the function.
+ * @natomic: Unused
+ * @wait: If true, wait (atomically) until function has completed on other CPUs.
+ *
+ * Returns 0 on success, else a negative status code.
+ *
+ * If @wait is true, then returns once @func has returned; otherwise
+ * it returns just before the target cpu calls @func.
+ *
+ * You must not call this function with disabled interrupts or from a
+ * hardware interrupt handler or from a bottom half handler.
+ */
+int smp_call_function(void (*func)(void *), void *info, int natomic, int wait)
+{
+	int ret;
+
+	preempt_disable();
+	ret = smp_call_function_mask(cpu_online_map, func, info, wait);
+	preempt_enable();
+	return ret;
+}
+EXPORT_SYMBOL(smp_call_function);
-- 
1.5.5.1.57.g5909c

-- 
Jens Axboe

