Return-Path: <linux-kernel-owner+w=401wt.eu-S1756624AbYJQPHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbYJQPHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbYJQPFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:05:32 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:60658 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219AbYJQPFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:05:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=VO0y2MWRG41EGvv+TLu2MgfdCvK/3vU7BJVU/5zj1+egL53mxU7YkGJaYg21qS+bGg
         7lZNgRWuVC3cnNh1CoyBKZZxg81SqZe34z3vjjIxnqHLNjBFdh20HK6KnCsOkZYdLrR5
         4+X1L/TlFHJSy39Yn/Di3xHoBKYQBbFajbcWw=
To: linux-kernel@vger.kernel.org
Subject: [patch 08/24] perfmon3:  X86 64-bit hooks
From: eranian@googlemail.com
Date: Fri, 17 Oct 2008 08:05:27 -0700 (PDT)
Message-ID: <48f8a9b7.111f5e0a.42a1.0ee3@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the necessary hooks to the X86 64-bit code
to support initialization, interrupts, context switching,
and termination of a perfmon session.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
-

Index: o3/arch/x86/kernel/entry_64.S
===================================================================
--- o3.orig/arch/x86/kernel/entry_64.S	2008-10-01 16:55:24.000000000 +0200
+++ o3/arch/x86/kernel/entry_64.S	2008-10-01 17:00:21.000000000 +0200
@@ -888,7 +888,13 @@
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
Index: o3/arch/x86/kernel/process_64.c
===================================================================
--- o3.orig/arch/x86/kernel/process_64.c	2008-10-01 16:55:24.000000000 +0200
+++ o3/arch/x86/kernel/process_64.c	2008-10-01 17:00:21.000000000 +0200
@@ -36,6 +36,7 @@
 #include <linux/kprobes.h>
 #include <linux/kdebug.h>
 #include <linux/tick.h>
+#include <linux/perfmon_kern.h>
 #include <linux/prctl.h>
 
 #include <asm/uaccess.h>
@@ -240,6 +241,7 @@
 		t->io_bitmap_max = 0;
 		put_cpu();
 	}
+	pfm_exit_thread();
 }
 
 void flush_thread(void)
@@ -344,6 +346,8 @@
 	savesegment(es, p->thread.es);
 	savesegment(ds, p->thread.ds);
 
+	pfm_copy_thread(p);
+
 	if (unlikely(test_tsk_thread_flag(me, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmalloc(IO_BITMAP_BYTES, GFP_KERNEL);
 		if (!p->thread.io_bitmap_ptr) {
@@ -472,6 +476,9 @@
 	prev = &prev_p->thread,
 	next = &next_p->thread;
 
+	if (test_tsk_thread_flag(prev_p, TIF_PERFMON_CTXSW))
+		pfm_ctxsw_out(prev_p, next_p);
+
 	debugctl = prev->debugctlmsr;
 	if (next->ds_area_msr != prev->ds_area_msr) {
 		/* we clear debugctl to make sure DS
@@ -484,6 +491,9 @@
 	if (next->debugctlmsr != debugctl)
 		update_debugctlmsr(next->debugctlmsr);
 
+	if (test_tsk_thread_flag(next_p, TIF_PERFMON_CTXSW))
+		pfm_ctxsw_in(prev_p, next_p);
+
 	if (test_tsk_thread_flag(next_p, TIF_DEBUG)) {
 		loaddebug(next, 0);
 		loaddebug(next, 1);
Index: o3/arch/x86/kernel/signal_64.c
===================================================================
--- o3.orig/arch/x86/kernel/signal_64.c	2008-10-01 16:55:24.000000000 +0200
+++ o3/arch/x86/kernel/signal_64.c	2008-10-01 17:00:21.000000000 +0200
@@ -19,6 +19,7 @@
 #include <linux/stddef.h>
 #include <linux/personality.h>
 #include <linux/compiler.h>
+#include <linux/perfmon_kern.h>
 #include <asm/processor.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
@@ -555,6 +556,10 @@
 		mce_notify_user();
 #endif /* CONFIG_X86_MCE */
 
+ 	/* process perfmon asynchronous work (e.g. block thread or reset) */
+ 	if (thread_info_flags & _TIF_PERFMON_WORK)
+ 		pfm_handle_work(regs);
+
 	/* deal with pending signal delivery */
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
Index: o3/arch/x86/kernel/irqinit_64.c
===================================================================
--- o3.orig/arch/x86/kernel/irqinit_64.c	2008-10-01 16:55:24.000000000 +0200
+++ o3/arch/x86/kernel/irqinit_64.c	2008-10-01 17:00:21.000000000 +0200
@@ -11,6 +11,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/sysdev.h>
 #include <linux/bitops.h>
+#include <linux/perfmon_kern.h>
 
 #include <asm/acpi.h>
 #include <asm/atomic.h>
@@ -217,6 +218,10 @@
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
 
+#ifdef CONFIG_PERFMON
+	alloc_intr_gate(LOCAL_PERFMON_VECTOR, pmu_interrupt);
+#endif
+
 	if (!acpi_ioapic)
 		setup_irq(2, &irq2);
 }

-- 

