Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbYB0Mme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbYB0Mme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 07:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754865AbYB0MmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 07:42:22 -0500
Received: from ns2.suse.de ([195.135.220.15]:36976 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754737AbYB0MmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 07:42:19 -0500
Date: Wed, 27 Feb 2008 13:42:18 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
Subject: [rfc][patch] x86-64 new smp_call_function design
Message-ID: <20080227124217.GA1340@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This isn't finished yet, however I'd just like to ask for comments.


Design a new smp_call_function calling convention. This significantly
improves scalability of smp_call_function_single, and slightly improves
scalability and performance of smp_call_function; especially in the
cases where wait=0.

The non-wait case allocates function call data dynamically, so the
caller is able to return before all other CPUs have copied out the data
into their stack as is the case today.

The call_function_single case goes through a new vector, and uses
percpu queues and locks.


On a 2 socket, 8 core system, I see anywhere up to nearly 16x better
performance on a stress test. The common cases of call-all, and wait
are improved the least, however I think that if call-single and nowait
are turned into a high performance API, then new usages will pop up
(eg. I started this because I wanted to do "call single, nowait" calls
for migrating block IO completions back to submitting CPU; however I
am also interested in improving the "call all, wait" case for example
to improve vmalloc tlb flushing).

Time to perform 1 000 000 x cpus calls

calling cpus    vanilla   patched  speedup

Call all, wait
1                8.217s    7.304s  1.125x
2               15.842s    7.826s  2.024x
3               24.857s    9.630s  2.581x
4               32.844s   12.297s  2.670x
5               39.799s   14.599s  2.726x
6               33.105s   17.750s  1.965x
7               43.324s   20.336s  2.130x
8               30.720s   23.148s  1.327x

Call all, nowait
1                4.403s    1.197s 3.678x
2                7.590s    2.465s 3.079x
3               10.047s    3.414s 2.942x
4               12.412s    4.453s 2.787x
5               14.983s    5.729s 2.615x
6               17.308s    6.582s 2.629x
7               20.670s    8.057s 2.565x
8               23.792s    9.727s 2.445x

Call single, wait
1                2.491s    1.842s  1.352x
2                6.126s    2.968s  2.064x
3                7.268s    3.248s  2.237x
4               11.490s    2.891s  3.974x
5               11.965s    2.692s  4.444x
6               13.785s    2.634s  5.233x
7               17.920s    2.552s  7.021x
8               16.821s    3.350s  5.021x

Call single, nowait
1                1.708s    0.218s  7.834x
2                2.604s    0.295s  8.927x
3                3.771s    0.331s 11.392x
4                5.191s    0.531s  9.775x
5                8.222s    0.730s 11.263x
6                9.339s    0.758s 12.320x
7               13.806s    0.886s 15.582x
8               14.805s    0.983s 15.061x

Now one problem with my smp_call_function_mask design is that it uses RCU
(which isn't nice to use some major infrastructure to implement low level basic
functionality), and it is complex (and the fallback -ENOMEM case isn't quite
right either). What I can do is make another special case for "call all",
which should be probably even faster than this and doesn't use RCU, and then
have all other variations of masks just go through a slower and simpler
path that doesn't use RCU.

As far as I understand, calling a subset of online CPUs that is not all or
one, is used quite infrequently, so this might be OK.

Anyway, I think we'd want most architectures to implement the more
scalable scheme. Perhaps it can be put into generic code, and have the
arch just provide some functions for low level IPI generation and handling? 

---
Index: linux-2.6/arch/x86/kernel/smp_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smp_64.c
+++ linux-2.6/arch/x86/kernel/smp_64.c
@@ -18,6 +18,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/mc146818rtc.h>
 #include <linux/interrupt.h>
+#include <linux/rcupdate.h>
 
 #include <asm/mtrr.h>
 #include <asm/pgalloc.h>
@@ -295,21 +296,29 @@ void smp_send_reschedule(int cpu)
 	send_IPI_mask(cpumask_of_cpu(cpu), RESCHEDULE_VECTOR);
 }
 
+#define CALL_WAIT		0x01
+#define CALL_FALLBACK		0x02
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
 
-static struct call_data_struct * call_data;
+static LIST_HEAD(call_queue);
+
+static unsigned long call_fallback_used;
+static struct call_data call_data_fallback;
 
 void lock_ipi_call_lock(void)
 {
@@ -321,55 +330,47 @@ void unlock_ipi_call_lock(void)
 	spin_unlock_irq(&call_lock);
 }
 
-/*
- * this function sends a 'generic call function' IPI to all other CPU
- * of the system defined in the mask.
- */
-static int __smp_call_function_mask(cpumask_t mask,
-				    void (*func)(void *), void *info,
-				    int wait)
-{
-	struct call_data_struct data;
-	cpumask_t allbutself;
-	int cpus;
-
-	allbutself = cpu_online_map;
-	cpu_clear(smp_processor_id(), allbutself);
-
-	cpus_and(mask, mask, allbutself);
-	cpus = cpus_weight(mask);
-
-	if (!cpus)
-		return 0;
 
-	data.func = func;
-	data.info = info;
-	atomic_set(&data.started, 0);
-	data.wait = wait;
-	if (wait)
-		atomic_set(&data.finished, 0);
+struct call_single_data {
+	struct list_head list;
+	void (*func) (void *info);
+	void *info;
+	unsigned int flags;
+};
 
-	call_data = &data;
-	wmb();
+struct call_single_queue {
+	spinlock_t lock;
+	struct list_head list;
+};
+static DEFINE_PER_CPU(struct call_single_queue, call_single_queue);
 
-	/* Send a message to other CPUs */
-	if (cpus_equal(mask, allbutself))
-		send_IPI_allbutself(CALL_FUNCTION_VECTOR);
-	else
-		send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
+static unsigned long call_single_fallback_used;
+static struct call_single_data call_single_data_fallback;
 
-	/* Wait for response */
-	while (atomic_read(&data.started) != cpus)
-		cpu_relax();
+int __cpuinit init_smp_call(void)
+{
+	int i;
 
-	if (!wait)
-		return 0;
+	for_each_cpu_mask(i, cpu_possible_map) {
+		spin_lock_init(&per_cpu(call_single_queue, i).lock);
+		INIT_LIST_HEAD(&per_cpu(call_single_queue, i).list);
+	}
+	return 0;
+}
+core_initcall(init_smp_call);
 
-	while (atomic_read(&data.finished) != cpus)
-		cpu_relax();
+static void rcu_free_call_data(struct rcu_head *head)
+{
+	struct call_data *data;
+	data = container_of(head, struct call_data, rcu_head);
+	kfree(data);
+}
 
-	return 0;
+static void free_call_data(struct call_data *data)
+{
+	call_rcu(&data->rcu_head, rcu_free_call_data);
 }
+
 /**
  * smp_call_function_mask(): Run a function on a set of other CPUs.
  * @mask: The set of cpus to run on.  Must not include the current cpu.
@@ -389,15 +390,69 @@ int smp_call_function_mask(cpumask_t mas
 			   void (*func)(void *), void *info,
 			   int wait)
 {
-	int ret;
+	struct call_data *data;
+	cpumask_t allbutself;
+	unsigned int flags;
+	int cpus;
 
 	/* Can deadlock when called with interrupts disabled */
 	WARN_ON(irqs_disabled());
+	WARN_ON(preemptible());
+
+	allbutself = cpu_online_map;
+	cpu_clear(smp_processor_id(), allbutself);
+
+	cpus_and(mask, mask, allbutself);
+	cpus = cpus_weight(mask);
+
+	if (!cpus)
+		return 0;
+
+	flags = wait ? CALL_WAIT : 0;
+	data = kmalloc(sizeof(struct call_data), GFP_ATOMIC);
+	if (unlikely(!data)) {
+		while (test_and_set_bit_lock(0, &call_fallback_used))
+			cpu_relax();
+		data = &call_data_fallback;
+		flags |= CALL_FALLBACK;
+		/* XXX: can IPI all to "synchronize" RCU? */
+	}
 
-	spin_lock(&call_lock);
-	ret = __smp_call_function_mask(mask, func, info, wait);
+	spin_lock_init(&data->lock);
+	data->func = func;
+	data->info = info;
+	data->flags = flags;
+	data->refs = cpus;
+	data->cpumask = mask;
+
+	local_irq_disable();
+	while (!spin_trylock(&call_lock)) {
+		local_irq_enable();
+		cpu_relax();
+		local_irq_disable();
+	}
+	/* could do ipi = list_empty(&dst->list) || !cpumask_ipi_pending() */
+	list_add_tail_rcu(&data->list, &call_queue);
 	spin_unlock(&call_lock);
-	return ret;
+	local_irq_enable();
+
+	/* Send a message to other CPUs */
+	if (cpus_equal(mask, allbutself))
+		send_IPI_allbutself(CALL_FUNCTION_VECTOR);
+	else
+		send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
+
+	if (wait) {
+		/* Wait for response */
+		while (data->flags)
+			cpu_relax();
+		if (likely(!(flags & CALL_FALLBACK)))
+			free_call_data(data);
+		else
+			clear_bit_unlock(0, &call_fallback_used);
+	}
+
+	return 0;
 }
 EXPORT_SYMBOL(smp_call_function_mask);
 
@@ -414,11 +469,11 @@ EXPORT_SYMBOL(smp_call_function_mask);
  * or is or has executed.
  */
 
-int smp_call_function_single (int cpu, void (*func) (void *info), void *info,
+int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 			      int nonatomic, int wait)
 {
 	/* prevent preemption and reschedule on another processor */
-	int ret, me = get_cpu();
+	int me = get_cpu();
 
 	/* Can deadlock when called with interrupts disabled */
 	WARN_ON(irqs_disabled());
@@ -427,14 +482,54 @@ int smp_call_function_single (int cpu, v
 		local_irq_disable();
 		func(info);
 		local_irq_enable();
-		put_cpu();
-		return 0;
-	}
+	} else {
+		struct call_single_data d;
+		struct call_single_data *data;
+		struct call_single_queue *dst;
+		cpumask_t mask = cpumask_of_cpu(cpu);
+		unsigned int flags = wait ? CALL_WAIT : 0;
+		int ipi;
+
+		if (!wait) {
+			data = kmalloc(sizeof(struct call_single_data), GFP_ATOMIC);
+			if (unlikely(!data)) {
+				while (test_and_set_bit_lock(0, &call_single_fallback_used))
+					cpu_relax();
+				data = &call_single_data_fallback;
+				flags |= CALL_FALLBACK;
+			}
+		} else {
+			data = &d;
+		}
+
+		data->func = func;
+		data->info = info;
+		data->flags = flags;
+		dst = &per_cpu(call_single_queue, cpu);
+
+		local_irq_disable();
+		while (!spin_trylock(&dst->lock)) {
+			local_irq_enable();
+			cpu_relax();
+			local_irq_disable();
+		}
+		ipi = list_empty(&dst->list);
+		list_add_tail(&data->list, &dst->list);
+		spin_unlock(&dst->lock);
+		local_irq_enable();
+
+		if (ipi)
+			send_IPI_mask(mask, CALL_FUNCTION_SINGLE_VECTOR);
 
-	ret = smp_call_function_mask(cpumask_of_cpu(cpu), func, info, wait);
+		if (wait) {
+			/* Wait for response */
+			while (data->flags)
+				cpu_relax();
+		}
+	}
 
 	put_cpu();
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL(smp_call_function_single);
 
@@ -474,18 +569,13 @@ static void stop_this_cpu(void *dummy)
 
 void smp_send_stop(void)
 {
-	int nolock;
 	unsigned long flags;
 
 	if (reboot_force)
 		return;
 
-	/* Don't deadlock on the call lock in panic */
-	nolock = !spin_trylock(&call_lock);
 	local_irq_save(flags);
-	__smp_call_function_mask(cpu_online_map, stop_this_cpu, NULL, 0);
-	if (!nolock)
-		spin_unlock(&call_lock);
+	smp_call_function(stop_this_cpu, NULL, 0, 0);
 	disable_local_APIC();
 	local_irq_restore(flags);
 }
@@ -503,28 +593,83 @@ asmlinkage void smp_reschedule_interrupt
 
 asmlinkage void smp_call_function_interrupt(void)
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
 	exit_idle();
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
+				if (likely(!(data->flags & CALL_FALLBACK)))
+					free_call_data(data);
+				else
+					clear_bit_unlock(0, &call_fallback_used);
+			}
+		}
+	}
+
 	add_pda(irq_call_count, 1);
 	irq_exit();
-	if (wait) {
-		mb();
-		atomic_inc(&call_data->finished);
+}
+
+asmlinkage void smp_call_function_single_interrupt(void)
+{
+	struct call_single_queue *q;
+	LIST_HEAD(list);
+
+	ack_APIC_irq();
+	exit_idle();
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
+		} else {
+			if (likely(!(data->flags & CALL_FALLBACK)))
+				kfree(data);
+			else
+				clear_bit_unlock(0, &call_single_fallback_used);
+		}
 	}
+	add_pda(irq_call_count, 1);
+	irq_exit();
 }
 
Index: linux-2.6/include/asm-x86/hw_irq_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/hw_irq_64.h
+++ linux-2.6/include/asm-x86/hw_irq_64.h
@@ -68,8 +68,7 @@
 #define ERROR_APIC_VECTOR	0xfe
 #define RESCHEDULE_VECTOR	0xfd
 #define CALL_FUNCTION_VECTOR	0xfc
-/* fb free - please don't readd KDB here because it's useless
-   (hint - think what a NMI bit does to a vector) */
+#define CALL_FUNCTION_SINGLE_VECTOR	0xfb
 #define THERMAL_APIC_VECTOR	0xfa
 #define THRESHOLD_APIC_VECTOR   0xf9
 /* f8 free */
@@ -102,6 +101,7 @@ void spurious_interrupt(void);
 void error_interrupt(void);
 void reschedule_interrupt(void);
 void call_function_interrupt(void);
+void call_function_single_interrupt(void);
 void irq_move_cleanup_interrupt(void);
 void invalidate_interrupt0(void);
 void invalidate_interrupt1(void);
Index: linux-2.6/include/linux/smp.h
===================================================================
--- linux-2.6.orig/include/linux/smp.h
+++ linux-2.6/include/linux/smp.h
@@ -53,7 +53,6 @@ extern void smp_cpus_done(unsigned int m
  * Call a function on all other processors
  */
 int smp_call_function(void(*func)(void *info), void *info, int retry, int wait);
-
 int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
 				int retry, int wait);
 
@@ -92,6 +91,7 @@ static inline int up_smp_call_function(v
 }
 #define smp_call_function(func, info, retry, wait) \
 			(up_smp_call_function(func, info))
+
 #define on_each_cpu(func,info,retry,wait)	\
 	({					\
 		local_irq_disable();		\
Index: linux-2.6/arch/x86/kernel/entry_64.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/entry_64.S
+++ linux-2.6/arch/x86/kernel/entry_64.S
@@ -712,6 +712,9 @@ END(invalidate_interrupt\num)
 ENTRY(call_function_interrupt)
 	apicinterrupt CALL_FUNCTION_VECTOR,smp_call_function_interrupt
 END(call_function_interrupt)
+ENTRY(call_function_single_interrupt)
+	apicinterrupt CALL_FUNCTION_SINGLE_VECTOR,smp_call_function_single_interrupt
+END(call_function_single_interrupt)
 ENTRY(irq_move_cleanup_interrupt)
 	apicinterrupt IRQ_MOVE_CLEANUP_VECTOR,smp_irq_move_cleanup_interrupt
 END(irq_move_cleanup_interrupt)
Index: linux-2.6/arch/x86/kernel/i8259_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/i8259_64.c
+++ linux-2.6/arch/x86/kernel/i8259_64.c
@@ -493,6 +493,7 @@ void __init native_init_IRQ(void)
 
 	/* IPI for generic function call */
 	set_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
+	set_intr_gate(CALL_FUNCTION_SINGLE_VECTOR, call_function_single_interrupt);
 
 	/* Low priority IPI to cleanup after moving an irq */
 	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
Index: linux-2.6/include/asm-x86/mach-default/entry_arch.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-default/entry_arch.h
+++ linux-2.6/include/asm-x86/mach-default/entry_arch.h
@@ -13,6 +13,7 @@
 BUILD_INTERRUPT(reschedule_interrupt,RESCHEDULE_VECTOR)
 BUILD_INTERRUPT(invalidate_interrupt,INVALIDATE_TLB_VECTOR)
 BUILD_INTERRUPT(call_function_interrupt,CALL_FUNCTION_VECTOR)
+BUILD_INTERRUPT(call_function_single_interrupt,CALL_FUNCTION_SINGLE_VECTOR)
 #endif
 
 /*
