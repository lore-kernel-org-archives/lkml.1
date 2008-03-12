Return-Path: <linux-kernel-owner+w=401wt.eu-S1754249AbYCLL7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbYCLL7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 07:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbYCLL5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 07:57:17 -0400
Received: from brick.kernel.dk ([87.55.233.238]:25762 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbYCLL5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 07:57:13 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: npiggin@suse.de, dgc@sgi.com, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 3/7] x86: add fast smp_call_function_single()
Date: Wed, 12 Mar 2008 12:55:36 +0100
Message-Id: <1205322940-20127-4-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1205322940-20127-1-git-send-email-jens.axboe@oracle.com>
References: <1205322940-20127-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on Nicks patch for x86-64, and with my tweaks thrown in.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/x86/kernel/smp_32.c                   |  309 +++++++++++++++++++++-------
 arch/x86/kernel/smpboot_32.c               |    4 +
 arch/x86/kernel/smpcommon_32.c             |   34 ---
 include/asm-x86/hw_irq_32.h                |    1 +
 include/asm-x86/mach-default/irq_vectors.h |    1 +
 5 files changed, 242 insertions(+), 107 deletions(-)

diff --git a/arch/x86/kernel/smp_32.c b/arch/x86/kernel/smp_32.c
index dc0cde9..dec7cd3 100644
--- a/arch/x86/kernel/smp_32.c
+++ b/arch/x86/kernel/smp_32.c
@@ -476,20 +476,32 @@ static void native_smp_send_reschedule(int cpu)
 	send_IPI_mask(cpumask_of_cpu(cpu), RESCHEDULE_VECTOR);
 }
 
+#define CALL_WAIT	0x01
+#define CALL_FALLBACK	0x02
+#define CALL_DATA_ALLOC	0x04
+
 /*
  * Structure and data for smp_call_function(). This is designed to minimise
  * static memory requirements. It also looks cleaner.
  */
 static DEFINE_SPINLOCK(call_lock);
 
-struct call_data_struct {
+struct call_data {
+	spinlock_t lock;
+	struct list_head list;
 	void (*func) (void *info);
 	void *info;
-	atomic_t started;
-	atomic_t finished;
-	int wait;
+	unsigned int flags;
+	unsigned int refs;
+	cpumask_t cpumask;
+	struct rcu_head rcu_head;
 };
 
+static LIST_HEAD(call_queue);
+
+static unsigned long call_fallback_used;
+static struct call_data call_data_fallback;
+
 void lock_ipi_call_lock(void)
 {
 	spin_lock_irq(&call_lock);
@@ -500,39 +512,35 @@ void unlock_ipi_call_lock(void)
 	spin_unlock_irq(&call_lock);
 }
 
-static struct call_data_struct *call_data;
+struct call_single_queue {
+	spinlock_t lock;
+	struct list_head list;
+};
+static DEFINE_PER_CPU(struct call_single_queue, call_single_queue);
 
-static void __smp_call_function(void (*func) (void *info), void *info,
-				int nonatomic, int wait)
+int __cpuinit init_smp_call(void)
 {
-	struct call_data_struct data;
-	int cpus = num_online_cpus() - 1;
-
-	if (!cpus)
-		return;
-
-	data.func = func;
-	data.info = info;
-	atomic_set(&data.started, 0);
-	data.wait = wait;
-	if (wait)
-		atomic_set(&data.finished, 0);
+	int i;
 
-	call_data = &data;
-	mb();
-	
-	/* Send a message to all other CPUs and wait for them to respond */
-	send_IPI_allbutself(CALL_FUNCTION_VECTOR);
+	for_each_cpu_mask(i, cpu_possible_map) {
+		spin_lock_init(&per_cpu(call_single_queue, i).lock);
+		INIT_LIST_HEAD(&per_cpu(call_single_queue, i).list);
+	}
+	return 0;
+}
+core_initcall(init_smp_call);
 
-	/* Wait for response */
-	while (atomic_read(&data.started) != cpus)
-		cpu_relax();
+static void rcu_free_call_data(struct rcu_head *head)
+{
+	struct call_data *data = container_of(head, struct call_data, rcu_head);
 
-	if (wait)
-		while (atomic_read(&data.finished) != cpus)
-			cpu_relax();
+	kfree(data);
 }
 
+static void free_call_data(struct call_data *data)
+{
+	call_rcu(&data->rcu_head, rcu_free_call_data);
+}
 
 /**
  * smp_call_function_mask(): Run a function on a set of other CPUs.
@@ -554,15 +562,14 @@ native_smp_call_function_mask(cpumask_t mask,
 			      void (*func)(void *), void *info,
 			      int wait)
 {
-	struct call_data_struct data;
+	struct call_data *data;
 	cpumask_t allbutself;
+	unsigned int flags;
 	int cpus;
 
 	/* Can deadlock when called with interrupts disabled */
 	WARN_ON(irqs_disabled());
-
-	/* Holding any lock stops cpus from going down. */
-	spin_lock(&call_lock);
+	WARN_ON(preemptible());
 
 	allbutself = cpu_online_map;
 	cpu_clear(smp_processor_id(), allbutself);
@@ -570,20 +577,37 @@ native_smp_call_function_mask(cpumask_t mask,
 	cpus_and(mask, mask, allbutself);
 	cpus = cpus_weight(mask);
 
-	if (!cpus) {
-		spin_unlock(&call_lock);
+	if (!cpus)
 		return 0;
-	}
 
-	data.func = func;
-	data.info = info;
-	atomic_set(&data.started, 0);
-	data.wait = wait;
-	if (wait)
-		atomic_set(&data.finished, 0);
+	flags = wait ? CALL_WAIT : 0;
+	data = kmalloc(sizeof(struct call_data), GFP_ATOMIC);
+	if (unlikely(!data)) {
+		while (test_and_set_bit_lock(0, &call_fallback_used))
+			cpu_relax();
+		data = &call_data_fallback;
+		flags |= CALL_FALLBACK;
+		/* XXX: can IPI all to "synchronize" RCU? */
+	} else
+		flags |= CALL_DATA_ALLOC;
+
+	spin_lock_init(&data->lock);
+	data->func = func;
+	data->info = info;
+	data->flags = flags;
+	data->refs = cpus;
+	data->cpumask = mask;
 
-	call_data = &data;
-	mb();
+	local_irq_disable();
+	while (!spin_trylock(&call_lock)) {
+		local_irq_enable();
+		cpu_relax();
+		local_irq_disable();
+	}
+	/* could do ipi = list_empty(&dst->list) || !cpumask_ipi_pending() */
+	list_add_tail_rcu(&data->list, &call_queue);
+	spin_unlock(&call_lock);
+	local_irq_enable();
 
 	/* Send a message to other CPUs */
 	if (cpus_equal(mask, allbutself))
@@ -591,18 +615,111 @@ native_smp_call_function_mask(cpumask_t mask,
 	else
 		send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
 
-	/* Wait for response */
-	while (atomic_read(&data.started) != cpus)
-		cpu_relax();
-
-	if (wait)
-		while (atomic_read(&data.finished) != cpus)
+	if (wait) {
+		/* Wait for response */
+		while (data->flags)
 			cpu_relax();
-	spin_unlock(&call_lock);
+		if (flags & CALL_DATA_ALLOC)
+			free_call_data(data);
+		else
+			clear_bit_unlock(0, &call_fallback_used);
+	}
 
 	return 0;
 }
 
+/*
+ * __smp_call_function_single - Run a function on a specific CPU
+ * @data: Associated data
+ *
+ * Retrurns 0 on success, else a negative status code.
+ *
+ * Does not return until the remote CPU is nearly ready to execute <func>
+ * or is or has executed. Also see smp_call_function_single()
+ */
+void __smp_call_function_single(int cpu, struct call_single_data *data)
+{
+	cpumask_t mask = cpumask_of_cpu(cpu);
+	struct call_single_queue *dst;
+	unsigned long flags;
+	/* prevent preemption and reschedule on another processor */
+	int ipi;
+
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON((data->flags & CALL_WAIT) && irqs_disabled());
+
+	INIT_LIST_HEAD(&data->list);
+	dst = &per_cpu(call_single_queue, cpu);
+
+	spin_lock_irqsave(&dst->lock, flags);
+	ipi = list_empty(&dst->list);
+	list_add_tail(&data->list, &dst->list);
+	spin_unlock_irqrestore(&dst->lock, flags);
+
+	if (ipi)
+		send_IPI_mask(mask, CALL_FUNCTION_SINGLE_VECTOR);
+
+	if (data->flags & CALL_WAIT) {
+		/* Wait for response */
+		while (data->flags)
+			cpu_relax();
+	}
+}
+EXPORT_SYMBOL(__smp_call_function_single);
+
+/*
+ * smp_call_function_single - Run a function on a specific CPU
+ * @func: The function to run. This must be fast and non-blocking.
+ * @info: An arbitrary pointer to pass to the function.
+ * @nonatomic: Currently unused.
+ * @wait: If true, wait until function has completed on other CPUs.
+ *
+ * Retrurns 0 on success, else a negative status code.
+ *
+ * Does not return until the remote CPU is nearly ready to execute <func>
+ * or is or has executed.
+ */
+int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
+			      int nonatomic, int wait)
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
+			data->flags = CALL_DATA_ALLOC;
+		} else {
+			data = &d;
+			data->flags = CALL_WAIT;
+		}
+
+		data->func = func;
+		data->info = info;
+		__smp_call_function_single(cpu, data);
+	}
+out:
+	put_cpu();
+	return ret;
+}
+EXPORT_SYMBOL(smp_call_function_single);
+
 static void stop_this_cpu (void * dummy)
 {
 	local_irq_disable();
@@ -622,14 +739,10 @@ static void stop_this_cpu (void * dummy)
 
 static void native_smp_send_stop(void)
 {
-	/* Don't deadlock on the call lock in panic */
-	int nolock = !spin_trylock(&call_lock);
 	unsigned long flags;
 
 	local_irq_save(flags);
-	__smp_call_function(stop_this_cpu, NULL, 0, 0);
-	if (!nolock)
-		spin_unlock(&call_lock);
+	smp_call_function(stop_this_cpu, NULL, 0, 0);
 	disable_local_APIC();
 	local_irq_restore(flags);
 }
@@ -647,29 +760,79 @@ void smp_reschedule_interrupt(struct pt_regs *regs)
 
 void smp_call_function_interrupt(struct pt_regs *regs)
 {
-	void (*func) (void *info) = call_data->func;
-	void *info = call_data->info;
-	int wait = call_data->wait;
+	struct list_head *pos, *tmp;
+	int cpu = smp_processor_id();
 
 	ack_APIC_irq();
-	/*
-	 * Notify initiating CPU that I've grabbed the data and am
-	 * about to execute the function
-	 */
-	mb();
-	atomic_inc(&call_data->started);
-	/*
-	 * At this point the info structure may be out of scope unless wait==1
-	 */
 	irq_enter();
-	(*func)(info);
+
+	list_for_each_safe_rcu(pos, tmp, &call_queue) {
+		struct call_data *data;
+		int refs;
+
+		data = list_entry(pos, struct call_data, list);
+		if (!cpu_isset(cpu, data->cpumask))
+			continue;
+
+		data->func(data->info);
+		spin_lock(&data->lock);
+		WARN_ON(!cpu_isset(cpu, data->cpumask));
+		cpu_clear(cpu, data->cpumask);
+		WARN_ON(data->refs == 0);
+		data->refs--;
+		refs = data->refs;
+		spin_unlock(&data->lock);
+
+		if (refs == 0) {
+			WARN_ON(cpus_weight(data->cpumask));
+			spin_lock(&call_lock);
+			list_del_rcu(&data->list);
+			spin_unlock(&call_lock);
+			if (data->flags & CALL_WAIT) {
+				smp_wmb();
+				data->flags = 0;
+			} else {
+				if (likely(data->flags & CALL_DATA_ALLOC))
+					free_call_data(data);
+				else
+					clear_bit_unlock(0, &call_fallback_used);
+			}
+		}
+	}
+
 	__get_cpu_var(irq_stat).irq_call_count++;
 	irq_exit();
+}
 
-	if (wait) {
-		mb();
-		atomic_inc(&call_data->finished);
+void smp_call_function_single_interrupt(void)
+{
+	struct call_single_queue *q;
+	LIST_HEAD(list);
+
+	ack_APIC_irq();
+	irq_enter();
+
+	q = &__get_cpu_var(call_single_queue);
+	spin_lock(&q->lock);
+	list_replace_init(&q->list, &list);
+	spin_unlock(&q->lock);
+
+	while (!list_empty(&list)) {
+		struct call_single_data *data;
+
+		data = list_entry(list.next, struct call_single_data, list);
+		list_del(&data->list);
+
+		data->func(data->info);
+		if (data->flags & CALL_WAIT) {
+			smp_wmb();
+			data->flags = 0;
+		} else if (data->flags & CALL_DATA_ALLOC)
+			kfree(data);
 	}
+
+	__get_cpu_var(irq_stat).irq_call_count++;
+	irq_exit();
 }
 
 static int convert_apicid_to_cpu(int apic_id)
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 579b9b7..d250388 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -1304,6 +1304,10 @@ void __init smp_intr_init(void)
 
 	/* IPI for generic function call */
 	set_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
+
+	/* IPI for single call function */
+	set_intr_gate(CALL_FUNCTION_SINGLE_VECTOR,
+					call_function_single_interrupt);
 }
 
 /*
diff --git a/arch/x86/kernel/smpcommon_32.c b/arch/x86/kernel/smpcommon_32.c
index 8bc38af..4590a67 100644
--- a/arch/x86/kernel/smpcommon_32.c
+++ b/arch/x86/kernel/smpcommon_32.c
@@ -46,37 +46,3 @@ int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
 	return smp_call_function_mask(cpu_online_map, func, info, wait);
 }
 EXPORT_SYMBOL(smp_call_function);
-
-/**
- * smp_call_function_single - Run a function on a specific CPU
- * @cpu: The target CPU.  Cannot be the calling CPU.
- * @func: The function to run. This must be fast and non-blocking.
- * @info: An arbitrary pointer to pass to the function.
- * @nonatomic: Unused.
- * @wait: If true, wait until function has completed on other CPUs.
- *
- * Returns 0 on success, else a negative status code.
- *
- * If @wait is true, then returns once @func has returned; otherwise
- * it returns just before the target cpu calls @func.
- */
-int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
-			     int nonatomic, int wait)
-{
-	/* prevent preemption and reschedule on another processor */
-	int ret;
-	int me = get_cpu();
-	if (cpu == me) {
-		local_irq_disable();
-		func(info);
-		local_irq_enable();
-		put_cpu();
-		return 0;
-	}
-
-	ret = smp_call_function_mask(cpumask_of_cpu(cpu), func, info, wait);
-
-	put_cpu();
-	return ret;
-}
-EXPORT_SYMBOL(smp_call_function_single);
diff --git a/include/asm-x86/hw_irq_32.h b/include/asm-x86/hw_irq_32.h
index ea88054..a87b132 100644
--- a/include/asm-x86/hw_irq_32.h
+++ b/include/asm-x86/hw_irq_32.h
@@ -32,6 +32,7 @@ extern void (*const interrupt[NR_IRQS])(void);
 void reschedule_interrupt(void);
 void invalidate_interrupt(void);
 void call_function_interrupt(void);
+void call_function_single_interrupt(void);
 #endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
diff --git a/include/asm-x86/mach-default/irq_vectors.h b/include/asm-x86/mach-default/irq_vectors.h
index 881c63c..ed7d495 100644
--- a/include/asm-x86/mach-default/irq_vectors.h
+++ b/include/asm-x86/mach-default/irq_vectors.h
@@ -48,6 +48,7 @@
 #define INVALIDATE_TLB_VECTOR	0xfd
 #define RESCHEDULE_VECTOR	0xfc
 #define CALL_FUNCTION_VECTOR	0xfb
+#define CALL_FUNCTION_SINGLE_VECTOR	0xfa
 
 #define THERMAL_APIC_VECTOR	0xf0
 /*
-- 
1.5.4.GIT

