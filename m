Return-Path: <linux-kernel-owner+w=401wt.eu-S1757873AbYA3DWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873AbYA3DWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 22:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754918AbYA3DTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 22:19:06 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:49371 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbYA3DSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 22:18:50 -0500
Message-Id: <20080130031843.270336407@goodmis.org>
References: <20080130031521.258552785@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 29 Jan 2008 22:15:41 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 20/22 -v7] Add markers to various events
Content-Disposition: inline; filename=tracer-add-event-markers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds markers to various events in the kernel.
(interrupts, task activation and hrtimers)

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/apic_32.c  |    2 ++
 arch/x86/kernel/irq_32.c   |    1 +
 arch/x86/kernel/irq_64.c   |    2 ++
 arch/x86/kernel/traps_32.c |    2 ++
 arch/x86/kernel/traps_64.c |    2 ++
 arch/x86/mm/fault_32.c     |    3 +++
 arch/x86/mm/fault_64.c     |    3 +++
 kernel/hrtimer.c           |    7 +++++++
 kernel/sched.c             |   11 +++++++++++
 9 files changed, 33 insertions(+)

Index: linux-mcount.git/arch/x86/kernel/apic_32.c
===================================================================
--- linux-mcount.git.orig/arch/x86/kernel/apic_32.c	2008-01-28 08:37:49.000000000 -0500
+++ linux-mcount.git/arch/x86/kernel/apic_32.c	2008-01-28 09:54:49.000000000 -0500
@@ -581,6 +581,8 @@ notrace fastcall void smp_apic_timer_int
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
+	trace_mark(arch_apic_timer, "ip %lx", regs->eip);
+
 	/*
 	 * NOTE! We'd better ACK the irq immediately,
 	 * because timer handling can be slow.
Index: linux-mcount.git/arch/x86/kernel/irq_32.c
===================================================================
--- linux-mcount.git.orig/arch/x86/kernel/irq_32.c	2008-01-28 08:37:14.000000000 -0500
+++ linux-mcount.git/arch/x86/kernel/irq_32.c	2008-01-28 09:54:49.000000000 -0500
@@ -85,6 +85,7 @@ fastcall unsigned int do_IRQ(struct pt_r
 
 	old_regs = set_irq_regs(regs);
 	irq_enter();
+	trace_mark(arch_do_irq, "ip %lx irq %d", regs->eip, irq);
 #ifdef CONFIG_DEBUG_STACKOVERFLOW
 	/* Debugging check for stack overflow: is there less than 1KB free? */
 	{
Index: linux-mcount.git/arch/x86/kernel/irq_64.c
===================================================================
--- linux-mcount.git.orig/arch/x86/kernel/irq_64.c	2008-01-28 08:37:14.000000000 -0500
+++ linux-mcount.git/arch/x86/kernel/irq_64.c	2008-01-28 09:54:49.000000000 -0500
@@ -149,6 +149,8 @@ asmlinkage unsigned int do_IRQ(struct pt
 	irq_enter();
 	irq = __get_cpu_var(vector_irq)[vector];
 
+	trace_mark(arch_do_irq, "ip %lx irq %d", regs->rip, irq);
+
 #ifdef CONFIG_DEBUG_STACKOVERFLOW
 	stack_overflow_check(regs);
 #endif
Index: linux-mcount.git/arch/x86/kernel/traps_32.c
===================================================================
--- linux-mcount.git.orig/arch/x86/kernel/traps_32.c	2008-01-28 08:37:17.000000000 -0500
+++ linux-mcount.git/arch/x86/kernel/traps_32.c	2008-01-28 09:54:49.000000000 -0500
@@ -769,6 +769,8 @@ fastcall __kprobes void do_nmi(struct pt
 
 	nmi_enter();
 
+	trace_mark(arch_do_nmi, "ip %lx flags %lx", regs->eip, regs->eflags);
+
 	cpu = smp_processor_id();
 
 	++nmi_count(cpu);
Index: linux-mcount.git/arch/x86/kernel/traps_64.c
===================================================================
--- linux-mcount.git.orig/arch/x86/kernel/traps_64.c	2008-01-28 08:37:14.000000000 -0500
+++ linux-mcount.git/arch/x86/kernel/traps_64.c	2008-01-28 09:54:49.000000000 -0500
@@ -782,6 +782,8 @@ asmlinkage __kprobes void default_do_nmi
 
 	cpu = smp_processor_id();
 
+	trace_mark(arch_do_nmi, "ip %lx flags %lx", regs->rip, regs->eflags);
+
 	/* Only the BSP gets external NMIs from the system.  */
 	if (!cpu)
 		reason = get_nmi_reason();
Index: linux-mcount.git/arch/x86/mm/fault_32.c
===================================================================
--- linux-mcount.git.orig/arch/x86/mm/fault_32.c	2008-01-28 08:37:14.000000000 -0500
+++ linux-mcount.git/arch/x86/mm/fault_32.c	2008-01-28 09:54:49.000000000 -0500
@@ -311,6 +311,9 @@ fastcall void __kprobes do_page_fault(st
 	/* get the address */
         address = read_cr2();
 
+	trace_mark(arch_do_page_fault, "ip %lx err %lx addr %lx",
+		   regs->eip, error_code, address);
+
 	tsk = current;
 
 	si_code = SEGV_MAPERR;
Index: linux-mcount.git/arch/x86/mm/fault_64.c
===================================================================
--- linux-mcount.git.orig/arch/x86/mm/fault_64.c	2008-01-28 08:37:14.000000000 -0500
+++ linux-mcount.git/arch/x86/mm/fault_64.c	2008-01-28 09:54:49.000000000 -0500
@@ -316,6 +316,9 @@ asmlinkage void __kprobes do_page_fault(
 	/* get the address */
 	address = read_cr2();
 
+	trace_mark(arch_do_page_fault, "ip %lx err %lx addr %lx",
+		   regs->rip, error_code, address);
+
 	info.si_code = SEGV_MAPERR;
 
 
Index: linux-mcount.git/kernel/hrtimer.c
===================================================================
--- linux-mcount.git.orig/kernel/hrtimer.c	2008-01-28 08:37:14.000000000 -0500
+++ linux-mcount.git/kernel/hrtimer.c	2008-01-28 09:54:49.000000000 -0500
@@ -709,6 +709,8 @@ static void enqueue_hrtimer(struct hrtim
 	struct hrtimer *entry;
 	int leftmost = 1;
 
+	trace_mark(kernel_hrtimer_enqueue,
+		   "expires %p timer %p", &timer->expires, timer);
 	/*
 	 * Find the right place in the rbtree:
 	 */
@@ -1130,6 +1132,7 @@ void hrtimer_interrupt(struct clock_even
 
  retry:
 	now = ktime_get();
+	trace_mark(kernel_hrtimer_interrupt, "now %p", &now);
 
 	expires_next.tv64 = KTIME_MAX;
 
@@ -1168,6 +1171,10 @@ void hrtimer_interrupt(struct clock_even
 				continue;
 			}
 
+			trace_mark(kernel_hrtimer_interrupt_expire,
+				   "expires %p timer %p",
+				   &timer->expires, timer);
+
 			__run_hrtimer(timer);
 		}
 		spin_unlock(&cpu_base->lock);
Index: linux-mcount.git/kernel/sched.c
===================================================================
--- linux-mcount.git.orig/kernel/sched.c	2008-01-28 09:54:40.000000000 -0500
+++ linux-mcount.git/kernel/sched.c	2008-01-28 09:54:49.000000000 -0500
@@ -90,6 +90,11 @@ unsigned long long __attribute__((weak))
 #define PRIO_TO_NICE(prio)	((prio) - MAX_RT_PRIO - 20)
 #define TASK_NICE(p)		PRIO_TO_NICE((p)->static_prio)
 
+#define __PRIO(prio) \
+	((prio) <= 99 ? 199 - (prio) : (prio) - 120)
+
+#define PRIO(p) __PRIO((p)->prio)
+
 /*
  * 'User priority' is the nice value converted to something we
  * can work with better when scaling various scheduler parameters,
@@ -1372,6 +1377,9 @@ static void activate_task(struct rq *rq,
 	if (p->state == TASK_UNINTERRUPTIBLE)
 		rq->nr_uninterruptible--;
 
+	trace_mark(kernel_sched_activate_task,
+		   "pid %d prio %d nr_running %ld",
+		   p->pid, PRIO(p), rq->nr_running);
 	enqueue_task(rq, p, wakeup);
 	inc_nr_running(p, rq);
 }
@@ -1385,6 +1393,9 @@ static void deactivate_task(struct rq *r
 		rq->nr_uninterruptible++;
 
 	dequeue_task(rq, p, sleep);
+	trace_mark(kernel_sched_deactivate_task,
+		   "pid %d prio %d nr_running %ld",
+		   p->pid, PRIO(p), rq->nr_running);
 	dec_nr_running(p, rq);
 }
 

-- 
