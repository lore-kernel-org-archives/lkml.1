Return-Path: <linux-kernel-owner+w=401wt.eu-S1760698AbYFQWEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760698AbYFQWEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 18:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760017AbYFQWCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 18:02:44 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:14514 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758527AbYFQWCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:02:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=dAKsvIQXueQWAP+31t+PDySj1h2TaTAulES03BRa05Tbc5fa4cg5HQ86DbiBkARWpc
         /+XO/ei7VpC8F5tlzbfOBuDAViCAeIK8rT4TaO4omPxpUWT9j7wvfEjYqOXu5RScdD/L
         xx5ViVwntFNyf47KJi4eU9DCA5Pe+Za1VWWfI=
To: linux-kernel@vger.kernel.org
Subject: [patch 08/19] perfmon2 minimal v2:  X86 32-bit hooks
From: eranian@googlemail.com
Date: Tue, 17 Jun 2008 15:02:37 -0700 (PDT)
Message-ID: <4858347d.092a400a.7b2a.ffff83c4@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the necessary hooks to the X86 32-bit code
to support initialization, interrupts, context switching,
and termination of a perfmon session.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: o/arch/x86/kernel/apic_32.c
===================================================================
--- o.orig/arch/x86/kernel/apic_32.c	2008-06-04 11:09:10.000000000 +0200
+++ o/arch/x86/kernel/apic_32.c	2008-06-04 11:10:18.000000000 +0200
@@ -28,6 +28,7 @@
 #include <linux/acpi_pmtmr.h>
 #include <linux/module.h>
 #include <linux/dmi.h>
+#include <linux/perfmon_kern.h>
 
 #include <asm/atomic.h>
 #include <asm/smp.h>
@@ -1380,6 +1381,9 @@
 #ifdef CONFIG_X86_MCE_P4THERMAL
 	set_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
 #endif
+#ifdef CONFIG_PERFMON
+	set_intr_gate(LOCAL_PERFMON_VECTOR, pmu_interrupt);
+#endif
 }
 
 /**
Index: o/arch/x86/kernel/entry_32.S
===================================================================
--- o.orig/arch/x86/kernel/entry_32.S	2008-06-04 11:09:10.000000000 +0200
+++ o/arch/x86/kernel/entry_32.S	2008-06-04 11:10:18.000000000 +0200
@@ -464,7 +464,7 @@
 	ALIGN
 	RING0_PTREGS_FRAME		# can't unwind into user space anyway
 work_pending:
-	testb $_TIF_NEED_RESCHED, %cl
+	testw $(_TIF_NEED_RESCHED|_TIF_PERFMON_WORK), %cx
 	jz work_notifysig
 work_resched:
 	call schedule
Index: o/arch/x86/kernel/process_32.c
===================================================================
--- o.orig/arch/x86/kernel/process_32.c	2008-06-04 11:09:10.000000000 +0200
+++ o/arch/x86/kernel/process_32.c	2008-06-04 11:10:18.000000000 +0200
@@ -36,6 +36,7 @@
 #include <linux/personality.h>
 #include <linux/tick.h>
 #include <linux/percpu.h>
+#include <linux/perfmon_kern.h>
 #include <linux/prctl.h>
 
 #include <asm/uaccess.h>
@@ -316,6 +317,7 @@
 		tss->x86_tss.io_bitmap_base = INVALID_IO_BITMAP_OFFSET;
 		put_cpu();
 	}
+	pfm_exit_thread();
 }
 
 void flush_thread(void)
@@ -372,6 +374,8 @@
 
 	savesegment(gs, p->thread.gs);
 
+	pfm_copy_thread(p);
+
 	tsk = current;
 	if (unlikely(test_tsk_thread_flag(tsk, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmemdup(tsk->thread.io_bitmap_ptr,
@@ -486,6 +490,9 @@
 	prev = &prev_p->thread;
 	next = &next_p->thread;
 
+	if (test_tsk_thread_flag(prev_p, TIF_PERFMON_CTXSW))
+		pfm_ctxsw_out(prev_p, next_p);
+
 	debugctl = prev->debugctlmsr;
 	if (next->ds_area_msr != prev->ds_area_msr) {
 		/* we clear debugctl to make sure DS
@@ -498,6 +505,9 @@
 	if (next->debugctlmsr != debugctl)
 		update_debugctlmsr(next->debugctlmsr);
 
+	if (test_tsk_thread_flag(next_p, TIF_PERFMON_CTXSW))
+		pfm_ctxsw_in(prev_p, next_p);
+
 	if (test_tsk_thread_flag(next_p, TIF_DEBUG)) {
 		set_debugreg(next->debugreg0, 0);
 		set_debugreg(next->debugreg1, 1);
Index: o/arch/x86/kernel/signal_32.c
===================================================================
--- o.orig/arch/x86/kernel/signal_32.c	2008-06-04 11:09:10.000000000 +0200
+++ o/arch/x86/kernel/signal_32.c	2008-06-04 11:10:18.000000000 +0200
@@ -18,6 +18,7 @@
 #include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/elf.h>
+#include <linux/perfmon_kern.h>
 #include <linux/smp.h>
 #include <linux/mm.h>
 
@@ -663,6 +664,10 @@
 		clear_thread_flag(TIF_SINGLESTEP);
 	}
 
+	/* process perfmon asynchronous work (e.g. block thread or reset) */
+	if (thread_info_flags & _TIF_PERFMON_WORK)
+		pfm_handle_work(regs);
+
 	/* deal with pending signal delivery */
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
Index: o/include/asm-x86/mach-default/entry_arch.h
===================================================================
--- o.orig/include/asm-x86/mach-default/entry_arch.h	2008-06-04 11:09:10.000000000 +0200
+++ o/include/asm-x86/mach-default/entry_arch.h	2008-06-04 11:10:18.000000000 +0200
@@ -31,4 +31,8 @@
 BUILD_INTERRUPT(thermal_interrupt,THERMAL_APIC_VECTOR)
 #endif
 
+#ifdef CONFIG_PERFMON
+BUILD_INTERRUPT(pmu_interrupt,LOCAL_PERFMON_VECTOR)
+#endif
+
 #endif
Index: o/include/asm-x86/mach-default/irq_vectors.h
===================================================================
--- o.orig/include/asm-x86/mach-default/irq_vectors.h	2008-06-04 11:09:10.000000000 +0200
+++ o/include/asm-x86/mach-default/irq_vectors.h	2008-06-04 11:10:18.000000000 +0200
@@ -56,6 +56,7 @@
  * sources per level' errata.
  */
 #define LOCAL_TIMER_VECTOR	0xef
+#define LOCAL_PERFMON_VECTOR	0xee
 
 /*
  * First APIC vector available to drivers: (vectors 0x30-0xee)
@@ -63,7 +64,7 @@
  * levels. (0x80 is the syscall vector)
  */
 #define FIRST_DEVICE_VECTOR	0x31
-#define FIRST_SYSTEM_VECTOR	0xef
+#define FIRST_SYSTEM_VECTOR	0xee
 
 #define TIMER_IRQ 0
 
Index: o/include/asm-x86/thread_info_32.h
===================================================================
--- o.orig/include/asm-x86/thread_info_32.h	2008-06-04 11:09:10.000000000 +0200
+++ o/include/asm-x86/thread_info_32.h	2008-06-04 11:10:18.000000000 +0200
@@ -132,6 +132,7 @@
 #define TIF_SYSCALL_AUDIT	6	/* syscall auditing active */
 #define TIF_SECCOMP		7	/* secure computing */
 #define TIF_HRTICK_RESCHED	9	/* reprogram hrtick timer */
+#define TIF_PERFMON_WORK	10	/* work for pfm_handle_work() */
 #define TIF_MEMDIE		16
 #define TIF_DEBUG		17	/* uses debug registers */
 #define TIF_IO_BITMAP		18	/* uses I/O bitmap */
@@ -141,6 +142,7 @@
 #define TIF_DEBUGCTLMSR		22	/* uses thread_struct.debugctlmsr */
 #define TIF_DS_AREA_MSR 	23      /* uses thread_struct.ds_area_msr */
 #define TIF_BTS_TRACE_TS        24      /* record scheduling event timestamps */
+#define TIF_PERFMON_CTXSW	25	/* perfmon needs ctxsw calls */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
@@ -159,6 +161,8 @@
 #define _TIF_DEBUGCTLMSR	(1 << TIF_DEBUGCTLMSR)
 #define _TIF_DS_AREA_MSR	(1 << TIF_DS_AREA_MSR)
 #define _TIF_BTS_TRACE_TS	(1 << TIF_BTS_TRACE_TS)
+#define _TIF_PERFMON_WORK	(1 << TIF_PERFMON_WORK)
+#define _TIF_PERFMON_CTXSW	(1 << TIF_PERFMON_CTXSW)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK							\
@@ -168,9 +172,9 @@
 #define _TIF_ALLWORK_MASK	(0x0000FFFF & ~_TIF_SECCOMP)
 
 /* flags to check in __switch_to() */
-#define _TIF_WORK_CTXSW						\
-	(_TIF_IO_BITMAP | _TIF_NOTSC | _TIF_DEBUGCTLMSR |	\
-	 _TIF_DS_AREA_MSR | _TIF_BTS_TRACE_TS)
+#define _TIF_WORK_CTXSW \
+    (_TIF_IO_BITMAP | _TIF_NOTSC | _TIF_DEBUGCTLMSR | \
+     _TIF_DS_AREA_MSR | _TIF_BTS_TRACE_TS | _TIF_PERFMON_CTXSW)
 #define _TIF_WORK_CTXSW_PREV _TIF_WORK_CTXSW
 #define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW | _TIF_DEBUG)
 

-- 

