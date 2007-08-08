Return-Path: <linux-kernel-owner+w=401wt.eu-S1765956AbXHHUne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765956AbXHHUne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 16:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbXHHUn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 16:43:26 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:59763 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbXHHUnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 16:43:24 -0400
Subject: [PATCH RT] Only run softirqs from the irq thread if the irq
	affinity is set to 1 CPU
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: RT <linux-rt-users@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Content-Type: text/plain
Date: Wed, 08 Aug 2007 16:42:32 -0400
Message-Id: <1186605752.29097.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo and Thomas,

John and I have been discussing all the "run softirq from IRQ thread"
lately and discovered something nasty.

Now it is a nice optimization to run softirqs from the IRQ thread, but
it may not be feasible because of the semantics of the IRQ thread
compared with the softirq thread. Namely, the softirq thread is bound to
a single CPU and the IRQ thread is not.

We use to think that it would be fine to simply bind an IRQ thread to a
single CPU, either at the start of the IRQ thread code, or just while it
is running the softirq code.  But this has a major flaw as John Stultz
discovered.

If a RT hog that is of higher priority than the IRQ thread preempts the
IRQ thread while it is bound to the CPU (more likely with the latest
code that always binds the IRQ thread to 1 CPU), then that IRQ is, in
essence, masked.  That means no more actions will be taken place by that
IRQ while the RT thread is running.  Normally, one would expect, that if
the IRQ has its affinity set to all CPUS, if a RT thread were to preempt
the IRQ thread and run for a long time, it would be expected that the
IRQ thread would migrate to another CPU and finish. Letting more
interrupts from the IRQ line in (remember that the IRQ line is masked
until the IRQ finishes its handler).

This patch will only run the softirq functions if the IRQ thread and the
softirq thread have the same priority **and** the IRQ thread is already
bound to a single CPU.  If we are running on UP or the IRQ thread is
bound to a single CPU, we already have the possibility of having a RT
hog starve the IRQ.  But we should not add that scenario when the IRQ
thread has its affinity set to run on other CPUS that don't have RT hogs
on them.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6.23-rc2-rt2/kernel/irq/manage.c
===================================================================
--- linux-2.6.23-rc2-rt2.orig/kernel/irq/manage.c
+++ linux-2.6.23-rc2-rt2/kernel/irq/manage.c
@@ -769,17 +769,28 @@ static int do_irqd(void * __desc)
 {
 	struct sched_param param = { 0, };
 	struct irq_desc *desc = __desc;
+	int run_softirq = 1;
 
 #ifdef CONFIG_SMP
 	cpumask_t cpus_allowed, mask;
 
 	cpus_allowed = desc->affinity;
 	/*
-	 * Restrict it to one cpu so we avoid being migrated inside of
-	 * do_softirq_from_hardirq()
+	 * If the irqd is bound to one CPU we let it run softirqs
+	 * that have the same priority as the irqd thread. We do
+	 * not run it if the irqd is bound to more than one CPU
+	 * due to the fact that it can
+	 *  1) migrate to other CPUS while running the softirqd
+	 *  2) if we pin the irqd to a CPU to run the softirqd, then
+	 *     we risk a high priority process from waking up and
+	 *     preempting the irqd. Although the irqd may be able to
+	 *     run on other CPUS due to its irq affinity, it will not
+	 *     be able to since we bound it to a CPU to run softirqs.
+	 *     So a RT hog could starve the irqd from running on
+	 *     other CPUS that it's allowed to run on.
 	 */
-	mask = cpumask_of_cpu(first_cpu(desc->affinity));
-	set_cpus_allowed(current, mask);
+	if (cpus_weight(cpus_allowed) != 1)
+		run_softirq = 0; /* turn it off */
 #endif
 	current->flags |= PF_NOFREEZE | PF_HARDIRQ;
 
@@ -795,7 +806,8 @@ static int do_irqd(void * __desc)
 		do {
 			set_current_state(TASK_INTERRUPTIBLE);
 			do_hardirq(desc);
-			do_softirq_from_hardirq();
+			if (run_softirq)
+				do_softirq_from_hardirq();
 		} while (current->state == TASK_RUNNING);
 
 		local_irq_enable_nort();
@@ -806,12 +818,10 @@ static int do_irqd(void * __desc)
 		if (!cpus_equal(cpus_allowed, desc->affinity)) {
 			cpus_allowed = desc->affinity;
 			/*
-			 * Restrict it to one cpu so we avoid being
-			 * migrated inside of
-			 * do_softirq_from_hardirq()
+			 * Only allow the irq thread to run the softirqs
+			 * if it is bound to a single CPU.
 			 */
-			mask = cpumask_of_cpu(first_cpu(desc->affinity));
-			set_cpus_allowed(current, mask);
+			run_softirq = (cpus_weight(cpus_allowed) == 1);
 		}
 #endif
 		schedule();
Index: linux-2.6.23-rc2-rt2/kernel/softirq.c
===================================================================
--- linux-2.6.23-rc2-rt2.orig/kernel/softirq.c
+++ linux-2.6.23-rc2-rt2/kernel/softirq.c
@@ -114,7 +114,14 @@ static void wakeup_softirqd(int softirq)
 	 * context processing it later on.
 	 */
 	if ((current->flags & PF_HARDIRQ) && !hardirq_count() &&
-			(tsk->normal_prio == current->normal_prio))
+			(tsk->normal_prio == current->normal_prio) &&
+	    /*
+	     * The hard irq thread must be bound to a single CPU to run
+	     * a softirq. Don't worry about locking, the irq thread
+	     * should be the only one to modify the cpus_allowed, when
+	     * the irq affinity changes.
+	     */
+	    (cpus_weight(current->cpus_allowed) == 1))
 		return;
 #endif
 	/*


