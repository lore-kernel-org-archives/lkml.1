Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbYKYVjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbYKYVjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbYKYVgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:36:17 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:63378 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbYKYVgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:36:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=dEOaIQJof9o/Jl4ZhcuMLIZHrASP088M99Xj0vTbalkU+MjHsylXxbGqHj9dmvCz2J
         6epCd+jaBehsqNyBgKd1JPs0XqDR/wDWWhHCXNuwX62gEDGlLccIniTOdl4tcFHl1VDw
         E+LznccNOJGs7ZrKaDaliKvPqAr7d9EwyH7wc=
To: linux-kernel@vger.kernel.org
Subject: [patch 08/24] perfmon: X86 64-bit hooks (x86)
From: eranian@googlemail.com
Date: Tue, 25 Nov 2008 13:36:11 -0800 (PST)
Message-ID: <492c6fcb.0637560a.6fd5.0bd2@mx.google.com>
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
--- o3.orig/arch/x86/kernel/entry_64.S	2008-11-03 11:34:00.000000000 +0100
+++ o3/arch/x86/kernel/entry_64.S	2008-11-03 11:35:19.000000000 +0100
@@ -869,7 +869,13 @@
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
--- o3.orig/arch/x86/kernel/process_64.c	2008-11-03 11:34:01.000000000 +0100
+++ o3/arch/x86/kernel/process_64.c	2008-11-03 12:53:35.000000000 +0100
@@ -36,6 +36,7 @@
 #include <linux/kprobes.h>
 #include <linux/kdebug.h>
 #include <linux/tick.h>
+#include <linux/perfmon_kern.h>
 #include <linux/prctl.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
@@ -243,6 +244,7 @@
 		ds_free(t->ds_ctx);
 	}
 #endif /* CONFIG_X86_DS */
+	pfm_exit_thread();
 }
 
 void flush_thread(void)
@@ -347,6 +349,8 @@
 	savesegment(es, p->thread.es);
 	savesegment(ds, p->thread.ds);
 
+	pfm_copy_thread(p);
+
 	if (unlikely(test_tsk_thread_flag(me, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmalloc(IO_BITMAP_BYTES, GFP_KERNEL);
 		if (!p->thread.io_bitmap_ptr) {
@@ -475,6 +479,9 @@
 	prev = &prev_p->thread,
 	next = &next_p->thread;
 
+	if (test_tsk_thread_flag(prev_p, TIF_PERFMON_CTXSW))
+		pfm_ctxsw_out(prev_p, next_p);
+
 	debugctl = prev->debugctlmsr;
 
 #ifdef CONFIG_X86_DS
@@ -501,6 +508,9 @@
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
--- o3.orig/arch/x86/kernel/signal_64.c	2008-11-03 11:34:00.000000000 +0100
+++ o3/arch/x86/kernel/signal_64.c	2008-11-03 11:35:19.000000000 +0100
@@ -21,6 +21,7 @@
 #include <linux/personality.h>
 #include <linux/compiler.h>
 #include <linux/uaccess.h>
+#include <linux/perfmon_kern.h>
 
 #include <asm/processor.h>
 #include <asm/ucontext.h>
@@ -485,6 +486,10 @@
 		mce_notify_user();
 #endif /* CONFIG_X86_64 && CONFIG_X86_MCE */
 
+ 	/* process perfmon asynchronous work (e.g. block thread or reset) */
+ 	if (thread_info_flags & _TIF_PERFMON_WORK)
+ 		pfm_handle_work(regs);
+
 	/* deal with pending signal delivery */
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
Index: o3/arch/x86/kernel/irqinit_64.c
===================================================================
--- o3.orig/arch/x86/kernel/irqinit_64.c	2008-11-03 11:34:01.000000000 +0100
+++ o3/arch/x86/kernel/irqinit_64.c	2008-11-03 11:35:19.000000000 +0100
@@ -11,6 +11,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/sysdev.h>
 #include <linux/bitops.h>
+#include <linux/perfmon_kern.h>
 
 #include <asm/acpi.h>
 #include <asm/atomic.h>
@@ -224,6 +225,10 @@
 
 	apic_intr_init();
 
+#ifdef CONFIG_PERFMON
+	alloc_intr_gate(LOCAL_PERFMON_VECTOR, pmu_interrupt);
+#endif
+
 	if (!acpi_ioapic)
 		setup_irq(2, &irq2);
 }

-- 

