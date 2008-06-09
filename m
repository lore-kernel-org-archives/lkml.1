Return-Path: <linux-kernel-owner+w=401wt.eu-S1762819AbYFIWhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762819AbYFIWhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760570AbYFIWeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:34:17 -0400
Received: from hu-out-0506.google.com ([72.14.214.239]:26395 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761572AbYFIWeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:34:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=Lx8QWlNeDb1vjvslDbJLtB3VFGn7EJfhni/WU496QWa6vKMQ6G0dtQlrBTUKFubd7B
         1RhPbNgvXTmFyWhXYUUCeMmF8F1vY4k8ImWoxwG9Z1nwZHirDP9Q1INQ0GzQ6vbwW5ce
         i0duhtfFytwvw9hVsyUa5i7ocr6IKMQ7neVEc=
To: linux-kernel@vger.kernel.org
Subject: [patch 09/21] perfmon2 minimal:  X86 64-bit hooks
From: eranian@googlemail.com
Date: Mon, 09 Jun 2008 15:34:13 -0700 (PDT)
Message-ID: <484dafe5.09a1660a.2a60.276a@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the necessary hooks to the X86 64-bit code
to support initialization, interrupts, context switching,
and termination of a perfmon session.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
-

Index: o/arch/x86/kernel/entry_64.S
===================================================================
--- o.orig/arch/x86/kernel/entry_64.S	2008-06-04 10:57:47.000000000 +0200
+++ o/arch/x86/kernel/entry_64.S	2008-06-04 10:58:05.000000000 +0200
@@ -727,7 +727,13 @@
 ENTRY(spurious_interrupt)
 	apicinterrupt SPURIOUS_APIC_VECTOR,smp_spurious_interrupt
 END(spurious_interrupt)
-				
+
+#ifdef CONFIG_PERFMON
+ENTRY(pmu_interrupt)
+	apicinterrupt LOCAL_PERFMON_VECTOR,smp_pmu_interrupt
+END(pmu_interrupt)
+#endif
+
 /*
  * Exception entry points.
  */ 		
Index: o/arch/x86/kernel/i8259_64.c
===================================================================
--- o.orig/arch/x86/kernel/i8259_64.c	2008-06-04 10:57:47.000000000 +0200
+++ o/arch/x86/kernel/i8259_64.c	2008-06-04 10:58:05.000000000 +0200
@@ -11,6 +11,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/sysdev.h>
 #include <linux/bitops.h>
+#include <linux/perfmon_kern.h>
 
 #include <asm/acpi.h>
 #include <asm/atomic.h>
@@ -507,6 +508,9 @@
 	set_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	set_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
 
+#ifdef CONFIG_PERFMON
+	set_intr_gate(LOCAL_PERFMON_VECTOR, pmu_interrupt);
+#endif
 	if (!acpi_ioapic)
 		setup_irq(2, &irq2);
 }
Index: o/arch/x86/kernel/process_64.c
===================================================================
--- o.orig/arch/x86/kernel/process_64.c	2008-06-04 10:57:47.000000000 +0200
+++ o/arch/x86/kernel/process_64.c	2008-06-04 10:58:05.000000000 +0200
@@ -36,6 +36,7 @@
 #include <linux/kprobes.h>
 #include <linux/kdebug.h>
 #include <linux/tick.h>
+#include <linux/perfmon_kern.h>
 #include <linux/prctl.h>
 
 #include <asm/uaccess.h>
@@ -267,6 +268,7 @@
 		t->io_bitmap_max = 0;
 		put_cpu();
 	}
+	pfm_exit_thread();
 }
 
 void flush_thread(void)
@@ -370,6 +372,8 @@
 	asm("mov %%es,%0" : "=m" (p->thread.es));
 	asm("mov %%ds,%0" : "=m" (p->thread.ds));
 
+	pfm_copy_thread(p);
+
 	if (unlikely(test_tsk_thread_flag(me, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmalloc(IO_BITMAP_BYTES, GFP_KERNEL);
 		if (!p->thread.io_bitmap_ptr) {
@@ -496,6 +500,9 @@
 	prev = &prev_p->thread,
 	next = &next_p->thread;
 
+	if (test_tsk_thread_flag(prev_p, TIF_PERFMON_CTXSW))
+		pfm_ctxsw_out(prev_p, next_p);
+
 	debugctl = prev->debugctlmsr;
 	if (next->ds_area_msr != prev->ds_area_msr) {
 		/* we clear debugctl to make sure DS
@@ -508,6 +515,9 @@
 	if (next->debugctlmsr != debugctl)
 		update_debugctlmsr(next->debugctlmsr);
 
+	if (test_tsk_thread_flag(next_p, TIF_PERFMON_CTXSW))
+		pfm_ctxsw_in(prev_p, next_p);
+
 	if (test_tsk_thread_flag(next_p, TIF_DEBUG)) {
 		loaddebug(next, 0);
 		loaddebug(next, 1);
Index: o/arch/x86/kernel/signal_64.c
===================================================================
--- o.orig/arch/x86/kernel/signal_64.c	2008-06-04 10:57:47.000000000 +0200
+++ o/arch/x86/kernel/signal_64.c	2008-06-04 10:58:05.000000000 +0200
@@ -19,6 +19,7 @@
 #include <linux/stddef.h>
 #include <linux/personality.h>
 #include <linux/compiler.h>
+#include <linux/perfmon_kern.h>
 #include <asm/processor.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
@@ -493,6 +494,10 @@
 		clear_thread_flag(TIF_SINGLESTEP);
 	}
 
+	/* process perfmon asynchronous work (e.g. block thread or reset) */
+	if (thread_info_flags & _TIF_PERFMON_WORK)
+		pfm_handle_work(regs);
+
 #ifdef CONFIG_X86_MCE
 	/* notify userspace of pending MCEs */
 	if (thread_info_flags & _TIF_MCE_NOTIFY)
Index: o/include/asm-x86/hw_irq_64.h
===================================================================
--- o.orig/include/asm-x86/hw_irq_64.h	2008-06-04 10:57:47.000000000 +0200
+++ o/include/asm-x86/hw_irq_64.h	2008-06-04 10:58:05.000000000 +0200
@@ -84,6 +84,7 @@
  * sources per level' errata.
  */
 #define LOCAL_TIMER_VECTOR	0xef
+#define LOCAL_PERFMON_VECTOR	0xee
 
 /*
  * First APIC vector available to drivers: (vectors 0x30-0xee)
@@ -91,7 +92,7 @@
  * levels. (0x80 is the syscall vector)
  */
 #define FIRST_DEVICE_VECTOR	(IRQ15_VECTOR + 2)
-#define FIRST_SYSTEM_VECTOR	0xef   /* duplicated in irq.h */
+#define FIRST_SYSTEM_VECTOR	0xee   /* duplicated in irq.h */
 
 
 #ifndef __ASSEMBLY__
Index: o/include/asm-x86/irq_64.h
===================================================================
--- o.orig/include/asm-x86/irq_64.h	2008-06-04 10:57:47.000000000 +0200
+++ o/include/asm-x86/irq_64.h	2008-06-04 10:58:05.000000000 +0200
@@ -29,7 +29,7 @@
  */
 #define NR_VECTORS 256
 
-#define FIRST_SYSTEM_VECTOR	0xef   /* duplicated in hw_irq.h */
+#define FIRST_SYSTEM_VECTOR	0xee   /* duplicated in hw_irq.h */
 
 #define NR_IRQS (NR_VECTORS + (32 * NR_CPUS))
 #define NR_IRQ_VECTORS NR_IRQS
Index: o/include/asm-x86/thread_info_64.h
===================================================================
--- o.orig/include/asm-x86/thread_info_64.h	2008-06-04 10:57:47.000000000 +0200
+++ o/include/asm-x86/thread_info_64.h	2008-06-04 10:58:05.000000000 +0200
@@ -103,6 +103,7 @@
  * Warning: layout of LSW is hardcoded in entry.S
  */
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
+#define TIF_PERFMON_WORK	1	/* aysnc work for pfm_handle_work() */
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_SINGLESTEP		4	/* reenable singlestep on user return*/
@@ -124,6 +125,7 @@
 #define TIF_DS_AREA_MSR		26      /* uses thread_struct.ds_area_msr */
 #define TIF_BTS_TRACE_TS	27      /* record scheduling event timestamps */
 #define TIF_NOTSC		28	/* TSC is not accessible in userland */
+#define TIF_PERFMON_CTXSW	29	/* perfmon needs ctxsw calls */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
@@ -145,6 +147,8 @@
 #define _TIF_DS_AREA_MSR	(1 << TIF_DS_AREA_MSR)
 #define _TIF_BTS_TRACE_TS	(1 << TIF_BTS_TRACE_TS)
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
+#define _TIF_PERFMON_CTXSW	(1<<TIF_PERFMON_CTXSW)
+#define _TIF_PERFMON_WORK	(1<<TIF_PERFMON_WORK)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK							\
@@ -154,11 +158,13 @@
 #define _TIF_ALLWORK_MASK (0x0000FFFF & ~_TIF_SECCOMP)
 
 #define _TIF_DO_NOTIFY_MASK						\
-	(_TIF_SIGPENDING|_TIF_SINGLESTEP|_TIF_MCE_NOTIFY|_TIF_HRTICK_RESCHED)
+	(_TIF_SIGPENDING|_TIF_SINGLESTEP|_TIF_MCE_NOTIFY|_TIF_HRTICK_RESCHED|\
+	 _TIF_PERFMON_WORK)
 
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW							\
-	(_TIF_IO_BITMAP|_TIF_DEBUGCTLMSR|_TIF_DS_AREA_MSR|_TIF_BTS_TRACE_TS|_TIF_NOTSC)
+	(_TIF_IO_BITMAP|_TIF_DEBUGCTLMSR|_TIF_DS_AREA_MSR|_TIF_BTS_TRACE_TS|\
+	 _TIF_NOTSC|_TIF_PERFMON_CTXSW)
 #define _TIF_WORK_CTXSW_PREV _TIF_WORK_CTXSW
 #define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW|_TIF_DEBUG)
 

-- 

