Return-Path: <linux-kernel-owner+w=401wt.eu-S1759590AbZC1TxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590AbZC1TxW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 15:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756451AbZC1TuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 15:50:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38373 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757217AbZC1TuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 15:50:14 -0400
Message-Id: <20090328194929.451591360@chello.nl>
References: <20090328194359.426029037@chello.nl>
User-Agent: quilt/0.46-1
Date: Sat, 28 Mar 2009 20:44:00 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: [PATCH 1/9] perf_counter: unify and fix delayed counter wakeup
Content-Disposition: inline; filename=perf_counter-fix-delayed-wakeup.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While going over the wakeup code I noticed delayed wakeups only work
for hardware counters but basically all software counters rely on
them.

This patch unifies and generalizes the delayed wakeup to fix this
issue.

Since we're dealing with NMI context bits here, use a cmpxchg() based
single link list implementation to track counters that have pending
wakeups.

[ This should really be generic code for delayed wakeups, but since we
  cannot use cmpxchg()/xchg() in generic code, I've let it live in the
  perf_counter code. -- Eric Dumazet could use it to aggregate the
  network wakeups. ]

Furthermore, the x86 method of using TIF flags was flawed in that its
quite possible to end up setting the bit on the idle task, loosing the
wakeup.

The powerpc method uses per-cpu storage and would appear to work -- it
would check the per-cpu pending state every time it enabled IRQs.
However, since I fully removed the x86 code, I pulled it as well.

If we find the current jiffy tick based approach too slow, we can
re-instate the powerpc method and implement something similar on x86.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Eric Dumazet <dada1@cosmosbay.com>
---
 arch/powerpc/include/asm/hw_irq.h   |   39 -----------
 arch/powerpc/include/asm/paca.h     |    1 
 arch/powerpc/kernel/asm-offsets.c   |    1 
 arch/powerpc/kernel/entry_64.S      |    9 --
 arch/powerpc/kernel/irq.c           |    5 -
 arch/powerpc/kernel/perf_counter.c  |   33 ---------
 arch/x86/include/asm/perf_counter.h |    3 
 arch/x86/include/asm/thread_info.h  |    4 -
 arch/x86/kernel/cpu/perf_counter.c  |   29 --------
 arch/x86/kernel/signal.c            |    6 -
 include/linux/perf_counter.h        |   15 ++--
 kernel/perf_counter.c               |  126 +++++++++++++++++++++++++++++++++---
 kernel/timer.c                      |    3 
 13 files changed, 133 insertions(+), 141 deletions(-)

Index: linux-2.6/arch/powerpc/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_counter.c
+++ linux-2.6/arch/powerpc/kernel/perf_counter.c
@@ -650,24 +650,6 @@ hw_perf_counter_init(struct perf_counter
 }
 
 /*
- * Handle wakeups.
- */
-void perf_counter_do_pending(void)
-{
-	int i;
-	struct cpu_hw_counters *cpuhw = &__get_cpu_var(cpu_hw_counters);
-	struct perf_counter *counter;
-
-	for (i = 0; i < cpuhw->n_counters; ++i) {
-		counter = cpuhw->counter[i];
-		if (counter && counter->wakeup_pending) {
-			counter->wakeup_pending = 0;
-			wake_up(&counter->waitq);
-		}
-	}
-}
-
-/*
  * A counter has overflowed; update its count and record
  * things if requested.  Note that interrupts are hard-disabled
  * here so there is no possibility of being interrupted.
@@ -720,7 +702,7 @@ static void perf_counter_interrupt(struc
 	struct cpu_hw_counters *cpuhw = &__get_cpu_var(cpu_hw_counters);
 	struct perf_counter *counter;
 	long val;
-	int need_wakeup = 0, found = 0;
+	int found = 0;
 
 	for (i = 0; i < cpuhw->n_counters; ++i) {
 		counter = cpuhw->counter[i];
@@ -754,19 +736,6 @@ static void perf_counter_interrupt(struc
 	 * we get back out of this interrupt.
 	 */
 	mtspr(SPRN_MMCR0, cpuhw->mmcr[0]);
-
-	/*
-	 * If we need a wakeup, check whether interrupts were soft-enabled
-	 * when we took the interrupt.  If they were, we can wake stuff up
-	 * immediately; otherwise we'll have do the wakeup when interrupts
-	 * get soft-enabled.
-	 */
-	if (get_perf_counter_pending() && regs->softe) {
-		irq_enter();
-		clear_perf_counter_pending();
-		perf_counter_do_pending();
-		irq_exit();
-	}
 }
 
 void hw_perf_counter_setup(int cpu)
Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c
@@ -227,7 +227,6 @@ static int __hw_perf_counter_init(struct
 		 */
 		hwc->config |= pmc_ops->event_map(perf_event_id(hw_event));
 	}
-	counter->wakeup_pending = 0;
 
 	return 0;
 }
@@ -773,34 +772,6 @@ void smp_perf_counter_interrupt(struct p
 	irq_exit();
 }
 
-/*
- * This handler is triggered by NMI contexts:
- */
-void perf_counter_notify(struct pt_regs *regs)
-{
-	struct cpu_hw_counters *cpuc;
-	unsigned long flags;
-	int bit, cpu;
-
-	local_irq_save(flags);
-	cpu = smp_processor_id();
-	cpuc = &per_cpu(cpu_hw_counters, cpu);
-
-	for_each_bit(bit, cpuc->used, X86_PMC_IDX_MAX) {
-		struct perf_counter *counter = cpuc->counters[bit];
-
-		if (!counter)
-			continue;
-
-		if (counter->wakeup_pending) {
-			counter->wakeup_pending = 0;
-			wake_up(&counter->waitq);
-		}
-	}
-
-	local_irq_restore(flags);
-}
-
 void perf_counters_lapic_init(int nmi)
 {
 	u32 apic_val;
Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -275,6 +275,10 @@ struct perf_mmap_data {
 	void 				*data_pages[0];
 };
 
+struct perf_wakeup_entry {
+	struct perf_wakeup_entry *next;
+};
+
 /**
  * struct perf_counter - performance counter kernel representation:
  */
@@ -350,7 +354,7 @@ struct perf_counter {
 	/* poll related */
 	wait_queue_head_t		waitq;
 	/* optional: for NMIs */
-	int				wakeup_pending;
+	struct perf_wakeup_entry	wakeup;
 
 	void (*destroy)(struct perf_counter *);
 	struct rcu_head			rcu_head;
@@ -427,7 +431,7 @@ extern void perf_counter_task_sched_out(
 extern void perf_counter_task_tick(struct task_struct *task, int cpu);
 extern void perf_counter_init_task(struct task_struct *child);
 extern void perf_counter_exit_task(struct task_struct *child);
-extern void perf_counter_notify(struct pt_regs *regs);
+extern void perf_counter_do_pending(void);
 extern void perf_counter_print_debug(void);
 extern void perf_counter_unthrottle(void);
 extern u64 hw_perf_save_disable(void);
@@ -461,7 +465,7 @@ static inline void
 perf_counter_task_tick(struct task_struct *task, int cpu)		{ }
 static inline void perf_counter_init_task(struct task_struct *child)	{ }
 static inline void perf_counter_exit_task(struct task_struct *child)	{ }
-static inline void perf_counter_notify(struct pt_regs *regs)		{ }
+static inline void perf_counter_do_pending(void)			{ }
 static inline void perf_counter_print_debug(void)			{ }
 static inline void perf_counter_unthrottle(void)			{ }
 static inline void hw_perf_restore(u64 ctrl)				{ }
@@ -469,8 +473,9 @@ static inline u64 hw_perf_save_disable(v
 static inline int perf_counter_task_disable(void)	{ return -EINVAL; }
 static inline int perf_counter_task_enable(void)	{ return -EINVAL; }
 
-static inline void perf_swcounter_event(u32 event, u64 nr,
-					int nmi, struct pt_regs *regs)	{ }
+static inline void
+perf_swcounter_event(u32 event, u64 nr, int nmi, struct pt_regs *regs)	{ }
+
 #endif
 
 #endif /* __KERNEL__ */
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1197,8 +1197,12 @@ static void free_counter_rcu(struct rcu_
 	kfree(counter);
 }
 
+static void perf_pending_sync(struct perf_counter *counter);
+
 static void free_counter(struct perf_counter *counter)
 {
+	perf_pending_sync(counter);
+
 	if (counter->destroy)
 		counter->destroy(counter);
 
@@ -1529,6 +1533,116 @@ static const struct file_operations perf
 };
 
 /*
+ * Perf counter wakeup
+ *
+ * If there's data, ensure we set the poll() state and publish everything
+ * to user-space before waking everybody up.
+ */
+
+void perf_counter_wakeup(struct perf_counter *counter)
+{
+	struct perf_mmap_data *data;
+
+	rcu_read_lock();
+	data = rcu_dereference(counter->data);
+	if (data) {
+		(void)atomic_xchg(&data->wakeup, POLL_IN);
+		__perf_counter_update_userpage(counter, data);
+	}
+	rcu_read_unlock();
+
+	wake_up_all(&counter->waitq);
+}
+
+/*
+ * Pending wakeups
+ *
+ * Handle the case where we need to wakeup up from NMI (or rq->lock) context.
+ *
+ * The NMI bit means we cannot possibly take locks. Therefore, maintain a
+ * single linked list and use cmpxchg() to add entries lockless.
+ */
+
+#define PENDING_TAIL ((struct perf_wakeup_entry *)-1UL)
+
+static DEFINE_PER_CPU(struct perf_wakeup_entry *, perf_wakeup_head) = {
+	PENDING_TAIL,
+};
+
+static void perf_pending_queue(struct perf_counter *counter)
+{
+	struct perf_wakeup_entry **head;
+	struct perf_wakeup_entry *prev, *next;
+
+	if (cmpxchg(&counter->wakeup.next, NULL, PENDING_TAIL) != NULL)
+		return;
+
+	head = &get_cpu_var(perf_wakeup_head);
+
+	do {
+		prev = counter->wakeup.next = *head;
+		next = &counter->wakeup;
+	} while (cmpxchg(head, prev, next) != prev);
+
+	put_cpu_var(perf_wakeup_head);
+}
+
+static int __perf_pending_run(void)
+{
+	struct perf_wakeup_entry *list;
+	int nr = 0;
+
+	list = xchg(&__get_cpu_var(perf_wakeup_head), PENDING_TAIL);
+	while (list != PENDING_TAIL) {
+		struct perf_counter *counter = container_of(list,
+				struct perf_counter, wakeup);
+
+		list = list->next;
+
+		counter->wakeup.next = NULL;
+		/*
+		 * Ensure we observe the unqueue before we issue the wakeup,
+		 * so that we won't be waiting forever.
+		 * -- see perf_not_pending().
+		 */
+		smp_wmb();
+
+		perf_counter_wakeup(counter);
+		nr++;
+	}
+
+	return nr;
+}
+
+static inline int perf_not_pending(struct perf_counter *counter)
+{
+	/*
+	 * If we flush on whatever cpu we run, there is a chance we don't
+	 * need to wait.
+	 */
+	get_cpu();
+	__perf_pending_run();
+	put_cpu();
+
+	/*
+	 * Ensure we see the proper queue state before going to sleep
+	 * so that we do not miss the wakeup. -- see perf_pending_handle()
+	 */
+	smp_rmb();
+	return counter->wakeup.next == NULL;
+}
+
+static void perf_pending_sync(struct perf_counter *counter)
+{
+	wait_event(counter->waitq, perf_not_pending(counter));
+}
+
+void perf_counter_do_pending(void)
+{
+	__perf_pending_run();
+}
+
+/*
  * Output
  */
 
@@ -1611,13 +1725,10 @@ static void perf_output_copy(struct perf
 static void perf_output_end(struct perf_output_handle *handle, int nmi)
 {
 	if (handle->wakeup) {
-		(void)atomic_xchg(&handle->data->wakeup, POLL_IN);
-		__perf_counter_update_userpage(handle->counter, handle->data);
-		if (nmi) {
-			handle->counter->wakeup_pending = 1;
-			set_perf_counter_pending();
-		} else
-			wake_up(&handle->counter->waitq);
+		if (nmi)
+			perf_pending_queue(handle->counter);
+		else
+			perf_counter_wakeup(handle->counter);
 	}
 	rcu_read_unlock();
 }
@@ -2211,7 +2322,6 @@ perf_counter_alloc(struct perf_counter_h
 
 	counter->cpu			= cpu;
 	counter->hw_event		= *hw_event;
-	counter->wakeup_pending		= 0;
 	counter->group_leader		= group_leader;
 	counter->hw_ops			= NULL;
 	counter->ctx			= ctx;
Index: linux-2.6/arch/x86/kernel/signal.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/signal.c
+++ linux-2.6/arch/x86/kernel/signal.c
@@ -6,7 +6,6 @@
  *  2000-06-20  Pentium III FXSR, SSE support by Gareth Hughes
  *  2000-2002   x86-64 support by Andi Kleen
  */
-#include <linux/perf_counter.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
@@ -872,11 +871,6 @@ do_notify_resume(struct pt_regs *regs, v
 		tracehook_notify_resume(regs);
 	}
 
-	if (thread_info_flags & _TIF_PERF_COUNTERS) {
-		clear_thread_flag(TIF_PERF_COUNTERS);
-		perf_counter_notify(regs);
-	}
-
 #ifdef CONFIG_X86_32
 	clear_thread_flag(TIF_IRET);
 #endif /* CONFIG_X86_32 */
Index: linux-2.6/arch/powerpc/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/irq.c
+++ linux-2.6/arch/powerpc/kernel/irq.c
@@ -135,11 +135,6 @@ notrace void raw_local_irq_restore(unsig
 			iseries_handle_interrupts();
 	}
 
-	if (get_perf_counter_pending()) {
-		clear_perf_counter_pending();
-		perf_counter_do_pending();
-	}
-
 	/*
 	 * if (get_paca()->hard_enabled) return;
 	 * But again we need to take care that gcc gets hard_enabled directly
Index: linux-2.6/arch/x86/include/asm/perf_counter.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/perf_counter.h
+++ linux-2.6/arch/x86/include/asm/perf_counter.h
@@ -84,9 +84,6 @@ union cpuid10_edx {
 #define MSR_ARCH_PERFMON_FIXED_CTR2			0x30b
 #define X86_PMC_IDX_FIXED_BUS_CYCLES			(X86_PMC_IDX_FIXED + 2)
 
-#define set_perf_counter_pending()	\
-		set_tsk_thread_flag(current, TIF_PERF_COUNTERS);
-
 #ifdef CONFIG_PERF_COUNTERS
 extern void init_hw_perf_counters(void);
 extern void perf_counters_lapic_init(int nmi);
Index: linux-2.6/arch/powerpc/include/asm/hw_irq.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/hw_irq.h
+++ linux-2.6/arch/powerpc/include/asm/hw_irq.h
@@ -131,44 +131,5 @@ static inline int irqs_disabled_flags(un
  */
 struct hw_interrupt_type;
 
-#ifdef CONFIG_PERF_COUNTERS
-static inline unsigned long get_perf_counter_pending(void)
-{
-	unsigned long x;
-
-	asm volatile("lbz %0,%1(13)"
-		: "=r" (x)
-		: "i" (offsetof(struct paca_struct, perf_counter_pending)));
-	return x;
-}
-
-static inline void set_perf_counter_pending(void)
-{
-	asm volatile("stb %0,%1(13)" : :
-		"r" (1),
-		"i" (offsetof(struct paca_struct, perf_counter_pending)));
-}
-
-static inline void clear_perf_counter_pending(void)
-{
-	asm volatile("stb %0,%1(13)" : :
-		"r" (0),
-		"i" (offsetof(struct paca_struct, perf_counter_pending)));
-}
-
-extern void perf_counter_do_pending(void);
-
-#else
-
-static inline unsigned long get_perf_counter_pending(void)
-{
-	return 0;
-}
-
-static inline void set_perf_counter_pending(void) {}
-static inline void clear_perf_counter_pending(void) {}
-static inline void perf_counter_do_pending(void) {}
-#endif /* CONFIG_PERF_COUNTERS */
-
 #endif	/* __KERNEL__ */
 #endif	/* _ASM_POWERPC_HW_IRQ_H */
Index: linux-2.6/arch/powerpc/include/asm/paca.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/paca.h
+++ linux-2.6/arch/powerpc/include/asm/paca.h
@@ -99,7 +99,6 @@ struct paca_struct {
 	u8 soft_enabled;		/* irq soft-enable flag */
 	u8 hard_enabled;		/* set if irqs are enabled in MSR */
 	u8 io_sync;			/* writel() needs spin_unlock sync */
-	u8 perf_counter_pending;	/* PM interrupt while soft-disabled */
 
 	/* Stuff for accurate time accounting */
 	u64 user_time;			/* accumulated usermode TB ticks */
Index: linux-2.6/arch/powerpc/kernel/asm-offsets.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/asm-offsets.c
+++ linux-2.6/arch/powerpc/kernel/asm-offsets.c
@@ -131,7 +131,6 @@ int main(void)
 	DEFINE(PACAKMSR, offsetof(struct paca_struct, kernel_msr));
 	DEFINE(PACASOFTIRQEN, offsetof(struct paca_struct, soft_enabled));
 	DEFINE(PACAHARDIRQEN, offsetof(struct paca_struct, hard_enabled));
-	DEFINE(PACAPERFPEND, offsetof(struct paca_struct, perf_counter_pending));
 	DEFINE(PACASLBCACHE, offsetof(struct paca_struct, slb_cache));
 	DEFINE(PACASLBCACHEPTR, offsetof(struct paca_struct, slb_cache_ptr));
 	DEFINE(PACACONTEXTID, offsetof(struct paca_struct, context.id));
Index: linux-2.6/arch/powerpc/kernel/entry_64.S
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/entry_64.S
+++ linux-2.6/arch/powerpc/kernel/entry_64.S
@@ -526,15 +526,6 @@ ALT_FW_FTR_SECTION_END_IFCLR(FW_FEATURE_
 2:
 	TRACE_AND_RESTORE_IRQ(r5);
 
-#ifdef CONFIG_PERF_COUNTERS
-	/* check paca->perf_counter_pending if we're enabling ints */
-	lbz	r3,PACAPERFPEND(r13)
-	and.	r3,r3,r5
-	beq	27f
-	bl	.perf_counter_do_pending
-27:
-#endif /* CONFIG_PERF_COUNTERS */
-
 	/* extract EE bit and use it to restore paca->hard_enabled */
 	ld	r3,_MSR(r1)
 	rldicl	r4,r3,49,63		/* r0 = (r3 >> 15) & 1 */
Index: linux-2.6/arch/x86/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/thread_info.h
+++ linux-2.6/arch/x86/include/asm/thread_info.h
@@ -83,7 +83,6 @@ struct thread_info {
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
 #define TIF_SECCOMP		8	/* secure computing */
 #define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
-#define TIF_PERF_COUNTERS	11	/* notify perf counter work */
 #define TIF_NOTSC		16	/* TSC is not accessible in userland */
 #define TIF_IA32		17	/* 32bit process */
 #define TIF_FORK		18	/* ret_from_fork */
@@ -107,7 +106,6 @@ struct thread_info {
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_MCE_NOTIFY		(1 << TIF_MCE_NOTIFY)
-#define _TIF_PERF_COUNTERS	(1 << TIF_PERF_COUNTERS)
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
 #define _TIF_IA32		(1 << TIF_IA32)
 #define _TIF_FORK		(1 << TIF_FORK)
@@ -141,7 +139,7 @@ struct thread_info {
 
 /* Only used for 64 bit */
 #define _TIF_DO_NOTIFY_MASK						\
-	(_TIF_SIGPENDING|_TIF_MCE_NOTIFY|_TIF_PERF_COUNTERS|_TIF_NOTIFY_RESUME)
+	(_TIF_SIGPENDING|_TIF_MCE_NOTIFY|_TIF_NOTIFY_RESUME)
 
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW							\
Index: linux-2.6/kernel/timer.c
===================================================================
--- linux-2.6.orig/kernel/timer.c
+++ linux-2.6/kernel/timer.c
@@ -37,6 +37,7 @@
 #include <linux/delay.h>
 #include <linux/tick.h>
 #include <linux/kallsyms.h>
+#include <linux/perf_counter.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -1167,6 +1168,8 @@ static void run_timer_softirq(struct sof
 {
 	struct tvec_base *base = __get_cpu_var(tvec_bases);
 
+	perf_counter_do_pending();
+
 	hrtimer_run_pending();
 
 	if (time_after_eq(jiffies, base->timer_jiffies))

-- 

