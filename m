Return-Path: <linux-kernel-owner+w=401wt.eu-S1761572AbYF3NQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761572AbYF3NQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762049AbYF3NOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:14:09 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:57975 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762019AbYF3NOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:14:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=gx/B7LWAY0JUIvUYM06E3XSFR0QsXufCvySyThHkltLb2maYrSyh0FRg7P9otMqGcy
         h7p0LqfYCAwVY0KGInmSMKuSWXFq3Ly/14HddDxg3aRcQsNkNGJwjcZ4YHKpqMf28utU
         LB//yuT4IQo26QIkUkDevdE2DezYb177CHnOw=
To: linux-kernel@vger.kernel.org
Subject: [patch 08/19] perfmon2 minimal v3:  X86 32-bit hooks
From: eranian@googlemail.com
Date: Mon, 30 Jun 2008 06:14:01 -0700 (PDT)
Message-ID: <4868dc19.1c5c4e0a.36dd.ffff87d7@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the necessary hooks to the X86 32-bit code
to support initialization, interrupts, context switching,
and termination of a perfmon session.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: linux-next/arch/x86/kernel/apic_32.c
===================================================================
--- linux-next.orig/arch/x86/kernel/apic_32.c	2008-06-26 17:46:24.000000000 +0200
+++ linux-next/arch/x86/kernel/apic_32.c	2008-06-26 20:06:27.000000000 +0200
@@ -28,6 +28,7 @@
 #include <linux/acpi_pmtmr.h>
 #include <linux/module.h>
 #include <linux/dmi.h>
+#include <linux/perfmon_kern.h>
 
 #include <asm/atomic.h>
 #include <asm/smp.h>
@@ -1390,6 +1391,9 @@
 #ifdef CONFIG_X86_MCE_P4THERMAL
 	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
 #endif
+#ifdef CONFIG_PERFMON
+	set_intr_gate(LOCAL_PERFMON_VECTOR, pmu_interrupt);
+#endif
 }
 
 /**
Index: linux-next/arch/x86/kernel/entry_32.S
===================================================================
--- linux-next.orig/arch/x86/kernel/entry_32.S	2008-06-26 17:46:24.000000000 +0200
+++ linux-next/arch/x86/kernel/entry_32.S	2008-06-26 20:06:27.000000000 +0200
@@ -466,7 +466,7 @@
 	ALIGN
 	RING0_PTREGS_FRAME		# can't unwind into user space anyway
 work_pending:
-	testb $_TIF_NEED_RESCHED, %cl
+	testw $(_TIF_NEED_RESCHED|_TIF_PERFMON_WORK), %cx
 	jz work_notifysig
 work_resched:
 	call schedule
Index: linux-next/arch/x86/kernel/process_32.c
===================================================================
--- linux-next.orig/arch/x86/kernel/process_32.c	2008-06-26 17:46:24.000000000 +0200
+++ linux-next/arch/x86/kernel/process_32.c	2008-06-26 20:06:27.000000000 +0200
@@ -36,6 +36,7 @@
 #include <linux/personality.h>
 #include <linux/tick.h>
 #include <linux/percpu.h>
+#include <linux/perfmon_kern.h>
 #include <linux/prctl.h>
 
 #include <asm/uaccess.h>
@@ -276,6 +277,7 @@
 		tss->x86_tss.io_bitmap_base = INVALID_IO_BITMAP_OFFSET;
 		put_cpu();
 	}
+	pfm_exit_thread();
 }
 
 void flush_thread(void)
@@ -333,6 +335,8 @@
 
 	savesegment(gs, p->thread.gs);
 
+	pfm_copy_thread(p);
+
 	tsk = current;
 	if (unlikely(test_tsk_thread_flag(tsk, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmemdup(tsk->thread.io_bitmap_ptr,
@@ -447,6 +451,9 @@
 	prev = &prev_p->thread;
 	next = &next_p->thread;
 
+	if (test_tsk_thread_flag(prev_p, TIF_PERFMON_CTXSW))
+		pfm_ctxsw_out(prev_p, next_p);
+
 	debugctl = prev->debugctlmsr;
 	if (next->ds_area_msr != prev->ds_area_msr) {
 		/* we clear debugctl to make sure DS
@@ -459,6 +466,9 @@
 	if (next->debugctlmsr != debugctl)
 		update_debugctlmsr(next->debugctlmsr);
 
+	if (test_tsk_thread_flag(next_p, TIF_PERFMON_CTXSW))
+		pfm_ctxsw_in(prev_p, next_p);
+
 	if (test_tsk_thread_flag(next_p, TIF_DEBUG)) {
 		set_debugreg(next->debugreg0, 0);
 		set_debugreg(next->debugreg1, 1);
Index: linux-next/arch/x86/kernel/signal_32.c
===================================================================
--- linux-next.orig/arch/x86/kernel/signal_32.c	2008-06-26 17:46:24.000000000 +0200
+++ linux-next/arch/x86/kernel/signal_32.c	2008-06-26 20:06:27.000000000 +0200
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
Index: linux-next/include/asm-x86/mach-default/entry_arch.h
===================================================================
--- linux-next.orig/include/asm-x86/mach-default/entry_arch.h	2008-06-26 17:46:27.000000000 +0200
+++ linux-next/include/asm-x86/mach-default/entry_arch.h	2008-06-26 20:06:27.000000000 +0200
@@ -32,4 +32,8 @@
 BUILD_INTERRUPT(thermal_interrupt,THERMAL_APIC_VECTOR)
 #endif
 
+#ifdef CONFIG_PERFMON
+BUILD_INTERRUPT(pmu_interrupt,LOCAL_PERFMON_VECTOR)
+#endif
+
 #endif

-- 

