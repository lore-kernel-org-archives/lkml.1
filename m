Return-Path: <linux-kernel-owner+w=401wt.eu-S932266AbYF3NQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266AbYF3NQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762036AbYF3NOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:14:08 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:63631 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468AbYF3NOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:14:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=VbWSqjo/caJPg9bSVhnpxZ7tEKOtPcDyxHq/LbR2QU/SZfLwzOlD9DzIh1nN9NQNal
         76rdcn4AKY0nNlOPV8iWY8iOWqFDZ6PAtjXtnJHuytIYlOdxveW7JBl6xmsjiQDIrcqi
         8M+K13niH/rcJhXY7CuWzh/3a0J1ywzVAnx5U=
To: linux-kernel@vger.kernel.org
Subject: [patch 07/19] perfmon2 minimal v3:  X86 64-bit hooks
From: eranian@googlemail.com
Date: Mon, 30 Jun 2008 06:13:57 -0700 (PDT)
Message-ID: <4868dc15.08b6660a.60ea.ffffac5b@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the necessary hooks to the X86 64-bit code
to support initialization, interrupts, context switching,
and termination of a perfmon session.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
-

Index: next/arch/x86/kernel/entry_64.S
===================================================================
--- next.orig/arch/x86/kernel/entry_64.S	2008-06-30 14:15:35.000000000 +0200
+++ next/arch/x86/kernel/entry_64.S	2008-06-30 14:18:29.000000000 +0200
@@ -835,7 +835,13 @@
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
Index: next/arch/x86/kernel/process_64.c
===================================================================
--- next.orig/arch/x86/kernel/process_64.c	2008-06-30 14:15:35.000000000 +0200
+++ next/arch/x86/kernel/process_64.c	2008-06-30 14:18:29.000000000 +0200
@@ -37,6 +37,7 @@
 #include <linux/kprobes.h>
 #include <linux/kdebug.h>
 #include <linux/tick.h>
+#include <linux/perfmon_kern.h>
 #include <linux/prctl.h>
 
 #include <asm/uaccess.h>
@@ -251,6 +252,7 @@
 		t->io_bitmap_max = 0;
 		put_cpu();
 	}
+	pfm_exit_thread();
 }
 
 void flush_thread(void)
@@ -355,6 +357,8 @@
 	asm("mov %%es,%0" : "=m" (p->thread.es));
 	asm("mov %%ds,%0" : "=m" (p->thread.ds));
 
+	pfm_copy_thread(p);
+
 	if (unlikely(test_tsk_thread_flag(me, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmalloc(IO_BITMAP_BYTES, GFP_KERNEL);
 		if (!p->thread.io_bitmap_ptr) {
@@ -481,6 +485,9 @@
 	prev = &prev_p->thread,
 	next = &next_p->thread;
 
+	if (test_tsk_thread_flag(prev_p, TIF_PERFMON_CTXSW))
+		pfm_ctxsw_out(prev_p, next_p);
+
 	debugctl = prev->debugctlmsr;
 	if (next->ds_area_msr != prev->ds_area_msr) {
 		/* we clear debugctl to make sure DS
@@ -493,6 +500,9 @@
 	if (next->debugctlmsr != debugctl)
 		update_debugctlmsr(next->debugctlmsr);
 
+	if (test_tsk_thread_flag(next_p, TIF_PERFMON_CTXSW))
+		pfm_ctxsw_in(prev_p, next_p);
+
 	if (test_tsk_thread_flag(next_p, TIF_DEBUG)) {
 		loaddebug(next, 0);
 		loaddebug(next, 1);
Index: next/arch/x86/kernel/signal_64.c
===================================================================
--- next.orig/arch/x86/kernel/signal_64.c	2008-06-30 14:15:35.000000000 +0200
+++ next/arch/x86/kernel/signal_64.c	2008-06-30 14:18:29.000000000 +0200
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
Index: next/arch/x86/kernel/irqinit_64.c
===================================================================
--- next.orig/arch/x86/kernel/irqinit_64.c	2008-06-30 14:15:35.000000000 +0200
+++ next/arch/x86/kernel/irqinit_64.c	2008-06-30 14:18:29.000000000 +0200
@@ -11,6 +11,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/sysdev.h>
 #include <linux/bitops.h>
+#include <linux/perfmon_kern.h>
 
 #include <asm/acpi.h>
 #include <asm/atomic.h>
@@ -216,6 +217,10 @@
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
 
+#ifdef CONFIG_PERFMON
+	alloc_intr_gate(LOCAL_PERFMON_VECTOR, pmu_interrupt);
+#endif
+
 	if (!acpi_ioapic)
 		setup_irq(2, &irq2);
 }
Index: next/include/asm-x86/irq_vectors.h
===================================================================
--- next.orig/include/asm-x86/irq_vectors.h	2008-06-30 14:15:38.000000000 +0200
+++ next/include/asm-x86/irq_vectors.h	2008-06-30 14:18:29.000000000 +0200
@@ -91,6 +91,11 @@
 #define LOCAL_TIMER_VECTOR	0xef
 
 /*
+ * PERfmon PMU interrupt vector
+ */
+#define LOCAL_PERFMON_VECTOR	0xee
+
+/*
  * First APIC vector available to drivers: (vectors 0x30-0xee) we
  * start at 0x31(0x41) to spread out vectors evenly between priority
  * levels. (0x80 is the syscall vector)
Index: next/include/asm-x86/thread_info.h
===================================================================
--- next.orig/include/asm-x86/thread_info.h	2008-06-30 14:15:38.000000000 +0200
+++ next/include/asm-x86/thread_info.h	2008-06-30 14:21:13.000000000 +0200
@@ -71,6 +71,7 @@
  * Warning: layout of LSW is hardcoded in entry.S
  */
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
+#define TIF_PERFMON_WORK	1	/* work for pfm_handle_work() */
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_SINGLESTEP		4	/* reenable singlestep on user return*/
@@ -94,6 +95,7 @@
 #define TIF_DEBUGCTLMSR		25	/* uses thread_struct.debugctlmsr */
 #define TIF_DS_AREA_MSR		26      /* uses thread_struct.ds_area_msr */
 #define TIF_BTS_TRACE_TS	27      /* record scheduling event timestamps */
+#define TIF_PERFMON_CTXSW	28	/* perfmon needs ctxsw calls */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
@@ -120,6 +122,8 @@
 #define _TIF_DEBUGCTLMSR	(1 << TIF_DEBUGCTLMSR)
 #define _TIF_DS_AREA_MSR	(1 << TIF_DS_AREA_MSR)
 #define _TIF_BTS_TRACE_TS	(1 << TIF_BTS_TRACE_TS)
+#define _TIF_PERFMON_WORK	(1<<TIF_PERFMON_WORK)
+#define _TIF_PERFMON_CTXSW	(1<<TIF_PERFMON_CTXSW)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK							\
@@ -137,7 +141,7 @@
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW							\
 	(_TIF_IO_BITMAP|_TIF_DEBUGCTLMSR|_TIF_DS_AREA_MSR|_TIF_BTS_TRACE_TS| \
-								_TIF_NOTSC)
+	 _TIF_NOTSC|_TIF_PERFMON_CTXSW)
 
 #define _TIF_WORK_CTXSW_PREV _TIF_WORK_CTXSW
 #define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW|_TIF_DEBUG)

-- 

