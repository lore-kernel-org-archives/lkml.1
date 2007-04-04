Return-Path: <linux-kernel-owner+w=401wt.eu-S2992795AbXDDJmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992795AbXDDJmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 05:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992793AbXDDJmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 05:42:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50976 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992789AbXDDJmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 05:42:51 -0400
Date: Wed, 4 Apr 2007 11:42:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rui Nuno Capela <rncbc@rncbc.org>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: 2.6.21-rc5-rt10 troubles
Message-ID: <20070404094243.GA16385@elte.hu>
References: <23932.213.58.131.130.1170156409.squirrel@www.rncbc.org> <460FE7F3.4060303@rncbc.org> <20070401183928.GB27614@elte.hu> <4612E803.8070600@rncbc.org> <20070404084927.GA2521@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070404084927.GA2521@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> could you try rt11 (which fixes two bad bugs in rt10)? If rt11 freezes 
> too then could you try to unapply the attached patch? This patch is 
> the main delta between rt5 and rt11. (plus upstream changes but those 
> shouldnt matter for this problem)

FYI, i've released -rt12 meanwhile - and the patch to unapply from -rt12 
is below.

	Ingo

------------------->
Subject: [patch] softirq preemption: optimization
From: Ingo Molnar <mingo@elte.hu>

optimize softirq preemption by allowing a hardirq context to pick up
softirq processing.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/interrupt.h |    1 
 kernel/irq/manage.c       |   24 +++----
 kernel/softirq.c          |  150 ++++++++++++++++++++++++++++++++++++----------
 3 files changed, 131 insertions(+), 44 deletions(-)

Index: linux/include/linux/interrupt.h
===================================================================
--- linux.orig/include/linux/interrupt.h
+++ linux/include/linux/interrupt.h
@@ -266,6 +266,7 @@ struct softirq_action
 asmlinkage void do_softirq(void);
 extern void open_softirq(int nr, void (*action)(struct softirq_action*), void *data);
 extern void softirq_init(void);
+extern void do_softirq_from_hardirq(void);
 
 #ifdef CONFIG_PREEMPT_HARDIRQS
 # define __raise_softirq_irqoff(nr) raise_softirq_irqoff(nr)
Index: linux/kernel/irq/manage.c
===================================================================
--- linux.orig/kernel/irq/manage.c
+++ linux/kernel/irq/manage.c
@@ -628,14 +628,17 @@ static void thread_simple_irq(irq_desc_t
 	unsigned int irq = desc - irq_desc;
 	irqreturn_t action_ret;
 
+repeat:
 	if (action && !desc->depth) {
 		spin_unlock(&desc->lock);
 		action_ret = handle_IRQ_event(irq, action);
-		cond_resched_hardirq_context();
 		spin_lock_irq(&desc->lock);
 		if (!noirqdebug)
 			note_interrupt(irq, desc, action_ret);
 	}
+	if (desc->status & IRQ_PENDING)
+		goto repeat;
+
 	desc->status &= ~IRQ_INPROGRESS;
 }
 
@@ -692,7 +695,6 @@ static void thread_edge_irq(irq_desc_t *
 		desc->status &= ~IRQ_PENDING;
 		spin_unlock(&desc->lock);
 		action_ret = handle_IRQ_event(irq, action);
-		cond_resched_hardirq_context();
 		spin_lock_irq(&desc->lock);
 		if (!noirqdebug)
 			note_interrupt(irq, desc, action_ret);
@@ -721,7 +723,6 @@ static void thread_do_irq(irq_desc_t *de
 		desc->status &= ~IRQ_PENDING;
 		spin_unlock(&desc->lock);
 		action_ret = handle_IRQ_event(irq, action);
-		cond_resched_hardirq_context();
 		spin_lock_irq(&desc->lock);
 		if (!noirqdebug)
 			note_interrupt(irq, desc, action_ret);
@@ -757,8 +758,6 @@ static void do_hardirq(struct irq_desc *
 		wake_up(&desc->wait_for_handler);
 }
 
-extern asmlinkage void __do_softirq(void);
-
 static int do_irqd(void * __desc)
 {
 	struct sched_param param = { 0, };
@@ -781,16 +780,13 @@ static int do_irqd(void * __desc)
 
 	while (!kthread_should_stop()) {
 		local_irq_disable_nort();
-		set_current_state(TASK_INTERRUPTIBLE);
-#ifndef CONFIG_PREEMPT_RT
-		irq_enter();
-#endif
-		do_hardirq(desc);
-#ifndef CONFIG_PREEMPT_RT
-		irq_exit();
-#endif
+		do {
+			set_current_state(TASK_INTERRUPTIBLE);
+			do_hardirq(desc);
+			do_softirq_from_hardirq();
+		} while (current->state == TASK_RUNNING);
+
 		local_irq_enable_nort();
-		cond_resched();
 #ifdef CONFIG_SMP
 		/*
 		 * Did IRQ affinities change?
Index: linux/kernel/softirq.c
===================================================================
--- linux.orig/kernel/softirq.c
+++ linux/kernel/softirq.c
@@ -100,8 +100,26 @@ static void wakeup_softirqd(int softirq)
 	/* Interrupts are disabled: no need to stop preemption */
 	struct task_struct *tsk = __get_cpu_var(ksoftirqd)[softirq].tsk;
 
-	if (tsk && tsk->state != TASK_RUNNING)
-		wake_up_process(tsk);
+	if (unlikely(!tsk))
+		return;
+#if defined(CONFIG_PREEMPT_SOFTIRQS) && defined(CONFIG_PREEMPT_HARDIRQS)
+	/*
+	 * Optimization: if we are in a hardirq thread context, and
+	 * if the priority of the softirq thread is the same as the
+	 * priority of the hardirq thread, then 'merge' softirq
+	 * processing into the hardirq context. (it will later on
+	 * execute softirqs via do_softirq_from_hardirq()).
+	 * So here we can skip the wakeup and can rely on the hardirq
+	 * context processing it later on.
+	 */
+	if ((current->flags & PF_HARDIRQ) && !hardirq_count() &&
+			(tsk->normal_prio == current->normal_prio))
+		return;
+#endif
+	/*
+	 * Wake up the softirq task:
+	 */
+	wake_up_process(tsk);
 }
 
 /*
@@ -250,50 +268,100 @@ EXPORT_SYMBOL(local_bh_enable_ip);
  * we want to handle softirqs as soon as possible, but they
  * should not be able to lock up the box.
  */
-#define MAX_SOFTIRQ_RESTART 10
+#define MAX_SOFTIRQ_RESTART 20
+
+static DEFINE_PER_CPU(u32, softirq_running);
 
-asmlinkage void ___do_softirq(void)
+static void ___do_softirq(const int same_prio_only)
 {
+	int max_restart = MAX_SOFTIRQ_RESTART, max_loops = MAX_SOFTIRQ_RESTART;
+	__u32 pending, available_mask, same_prio_skipped;
 	struct softirq_action *h;
-	__u32 pending;
-	int max_restart = MAX_SOFTIRQ_RESTART;
-	int cpu;
+	struct task_struct *tsk;
+	int cpu, softirq;
 
 	pending = local_softirq_pending();
 	account_system_vtime(current);
 
 	cpu = smp_processor_id();
 restart:
+	available_mask = -1;
+	softirq = 0;
+	same_prio_skipped = 0;
 	/* Reset the pending bitmask before enabling irqs */
 	set_softirq_pending(0);
 
-	local_irq_enable();
-
 	h = softirq_vec;
 
 	do {
+		u32 softirq_mask = 1 << softirq;
+
 		if (pending & 1) {
-			{
-				u32 preempt_count = preempt_count();
-				h->action(h);
-				if (preempt_count != preempt_count()) {
-					print_symbol("BUG: softirq exited %s with wrong preemption count!\n", (unsigned long) h->action);
-					printk("entered with %08x, exited with %08x.\n", preempt_count, preempt_count());
-					preempt_count() = preempt_count;
+			u32 preempt_count = preempt_count();
+
+#if defined(CONFIG_PREEMPT_SOFTIRQS) && defined(CONFIG_PREEMPT_HARDIRQS)
+			/*
+			 * If executed by a same-prio hardirq thread
+			 * then skip pending softirqs that belong
+			 * to softirq threads with different priority:
+			 */
+			if (same_prio_only) {
+				tsk = __get_cpu_var(ksoftirqd)[softirq].tsk;
+				if (tsk && tsk->normal_prio !=
+						current->normal_prio) {
+					same_prio_skipped |= softirq_mask;
+					available_mask &= ~softirq_mask;
+					goto next;
 				}
 			}
+#endif
+			/*
+			 * Is this softirq already being processed?
+			 */
+			if (per_cpu(softirq_running, cpu) & softirq_mask) {
+				available_mask &= ~softirq_mask;
+				goto next;
+			}
+			per_cpu(softirq_running, cpu) |= softirq_mask;
+			local_irq_enable();
+
+			h->action(h);
+			if (preempt_count != preempt_count()) {
+				print_symbol("BUG: softirq exited %s with wrong preemption count!\n", (unsigned long) h->action);
+				printk("entered with %08x, exited with %08x.\n", preempt_count, preempt_count());
+				preempt_count() = preempt_count;
+			}
 			rcu_bh_qsctr_inc(cpu);
 			cond_resched_softirq_context();
+			local_irq_disable();
+			per_cpu(softirq_running, cpu) &= ~softirq_mask;
 		}
+next:
 		h++;
+		softirq++;
 		pending >>= 1;
 	} while (pending);
 
-	local_irq_disable();
-
+	or_softirq_pending(same_prio_skipped);
 	pending = local_softirq_pending();
-	if (pending && --max_restart)
-		goto restart;
+	if (pending & available_mask) {
+		if (--max_restart)
+			goto restart;
+		/*
+		 * With softirq threading there's no reason not to
+		 * finish the workload we have:
+		 */
+#ifdef CONFIG_PREEMPT_SOFTIRQS
+		if (--max_loops) {
+			if (printk_ratelimit())
+				printk("INFO: softirq overload: %08x\n", pending);
+			max_restart = MAX_SOFTIRQ_RESTART;
+			goto restart;
+		}
+		if (printk_ratelimit())
+			printk("BUG: softirq loop! %08x\n", pending);
+#endif
+	}
 
 	if (pending)
 		trigger_softirqs();
@@ -321,7 +389,7 @@ asmlinkage void __do_softirq(void)
 	p_flags = current->flags & PF_HARDIRQ;
 	current->flags &= ~PF_HARDIRQ;
 
-	___do_softirq();
+	___do_softirq(0);
 
 	trace_softirq_exit();
 
@@ -345,20 +413,29 @@ void do_softirq_from_hardirq(void)
 	if (!local_softirq_pending())
 		return;
 	/*
-	 * 'immediate' softirq execution:
+	 * 'immediate' softirq execution, from hardirq context:
 	 */
+	local_irq_disable();
 	__local_bh_disable((unsigned long)__builtin_return_address(0));
+#ifndef CONFIG_PREEMPT_SOFTIRQS
+	trace_softirq_enter();
+#endif
 	p_flags = current->flags & PF_HARDIRQ;
 	current->flags &= ~PF_HARDIRQ;
+	current->flags |= PF_SOFTIRQ;
 
-	___do_softirq();
+	___do_softirq(1);
 
+#ifndef CONFIG_PREEMPT_SOFTIRQS
 	trace_softirq_exit();
-
+#endif
 	account_system_vtime(current);
-	_local_bh_enable();
 
 	current->flags |= p_flags;
+	current->flags &= ~PF_SOFTIRQ;
+
+	_local_bh_enable();
+	local_irq_enable();
 }
 
 #ifndef __ARCH_HAS_DO_SOFTIRQ
@@ -669,8 +746,9 @@ static int ksoftirqd(void * __data)
 {
 	struct sched_param param = { .sched_priority = MAX_USER_RT_PRIO/2 };
 	struct softirqdata *data = __data;
-	u32 mask = (1 << data->nr);
+	u32 softirq_mask = (1 << data->nr);
 	struct softirq_action *h;
+	int cpu = data->cpu;
 
 	sys_sched_setscheduler(current->pid, SCHED_FIFO, &param);
 //	set_user_nice(current, -10);
@@ -684,7 +762,8 @@ static int ksoftirqd(void * __data)
 
 	while (!kthread_should_stop()) {
 		preempt_disable();
-		if (!(local_softirq_pending() & mask)) {
+		if (!(local_softirq_pending() & softirq_mask)) {
+sleep_more:
 			__preempt_enable_no_resched();
 			schedule();
 			preempt_disable();
@@ -694,16 +773,26 @@ static int ksoftirqd(void * __data)
 #endif
 		__set_current_state(TASK_RUNNING);
 
-		while (local_softirq_pending() & mask) {
+		while (local_softirq_pending() & softirq_mask) {
 			/* Preempt disable stops cpu going offline.
 			   If already offline, we'll be on wrong CPU:
 			   don't process */
-			if (cpu_is_offline(data->cpu))
+			if (cpu_is_offline(cpu))
 				goto wait_to_die;
 
 			local_irq_disable();
+			/*
+			 * Is the softirq already being executed by
+			 * a hardirq context?
+			 */
+			if (per_cpu(softirq_running, cpu) & softirq_mask) {
+				local_irq_enable();
+				set_current_state(TASK_INTERRUPTIBLE);
+				goto sleep_more;
+			}
+			per_cpu(softirq_running, cpu) |= softirq_mask;
 			__preempt_enable_no_resched();
-			set_softirq_pending(local_softirq_pending() & ~mask);
+			set_softirq_pending(local_softirq_pending() & ~softirq_mask);
 			local_bh_disable();
 			local_irq_enable();
 
@@ -713,6 +802,7 @@ static int ksoftirqd(void * __data)
 			rcu_bh_qsctr_inc(data->cpu);
 
 			local_irq_disable();
+			per_cpu(softirq_running, cpu) &= ~softirq_mask;
 			_local_bh_enable();
 			local_irq_enable();
 

