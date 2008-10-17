Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbYJQPIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbYJQPIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755376AbYJQPFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:05:34 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:55326 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332AbYJQPFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:05:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=OJlClzv9a27LijL2xcfJnxuvbz8B+R3QdqkrCcVN47qRnvvLS8VVSb/2SbXclOeJs8
         oBvI/gKheHTfzDeh1fcODngLgdroZpEYJglusKF6jRqohDp0CCl63viNhzrg1gQ+EpIz
         eYDO2lJ6nyuVzGlnon/MKYmmENBABdTq7qLyk=
To: linux-kernel@vger.kernel.org
Subject: [patch 09/24] perfmon3:  X86 32-bit hooks
From: eranian@googlemail.com
Date: Fri, 17 Oct 2008 08:05:30 -0700 (PDT)
Message-ID: <48f8a9ba.05a0660a.7463.6aa8@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the necessary hooks to the X86 32-bit code
to support initialization, interrupts, context switching,
and termination of a perfmon session.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: o3/arch/x86/kernel/apic_32.c
===================================================================
--- o3.orig/arch/x86/kernel/apic_32.c	2008-09-30 12:03:23.000000000 +0200
+++ o3/arch/x86/kernel/apic_32.c	2008-09-30 15:14:05.000000000 +0200
@@ -28,6 +28,7 @@
 #include <linux/acpi_pmtmr.h>
 #include <linux/module.h>
 #include <linux/dmi.h>
+#include <linux/perfmon_kern.h>
 
 #include <asm/atomic.h>
 #include <asm/smp.h>
@@ -1367,6 +1368,9 @@
 #ifdef CONFIG_X86_MCE_P4THERMAL
 	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
 #endif
+#ifdef CONFIG_PERFMON
+	set_intr_gate(LOCAL_PERFMON_VECTOR, pmu_interrupt);
+#endif
 }
 
 /**
Index: o3/arch/x86/kernel/entry_32.S
===================================================================
--- o3.orig/arch/x86/kernel/entry_32.S	2008-09-30 12:03:23.000000000 +0200
+++ o3/arch/x86/kernel/entry_32.S	2008-09-30 15:14:05.000000000 +0200
@@ -513,7 +513,7 @@
 	ALIGN
 	RING0_PTREGS_FRAME		# can't unwind into user space anyway
 work_pending:
-	testb $_TIF_NEED_RESCHED, %cl
+	testw $(_TIF_NEED_RESCHED|_TIF_PERFMON_WORK), %cx
 	jz work_notifysig
 work_resched:
 	call schedule
Index: o3/arch/x86/kernel/process_32.c
===================================================================
--- o3.orig/arch/x86/kernel/process_32.c	2008-09-30 12:03:22.000000000 +0200
+++ o3/arch/x86/kernel/process_32.c	2008-09-30 15:14:05.000000000 +0200
@@ -36,6 +36,7 @@
 #include <linux/personality.h>
 #include <linux/tick.h>
 #include <linux/percpu.h>
+#include <linux/perfmon_kern.h>
 #include <linux/prctl.h>
 
 #include <asm/uaccess.h>
@@ -277,6 +278,7 @@
 		tss->x86_tss.io_bitmap_base = INVALID_IO_BITMAP_OFFSET;
 		put_cpu();
 	}
+	pfm_exit_thread();
 }
 
 void flush_thread(void)
@@ -334,6 +336,8 @@
 
 	savesegment(gs, p->thread.gs);
 
+	pfm_copy_thread(p);
+
 	tsk = current;
 	if (unlikely(test_tsk_thread_flag(tsk, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmemdup(tsk->thread.io_bitmap_ptr,
@@ -448,6 +452,9 @@
 	prev = &prev_p->thread;
 	next = &next_p->thread;
 
+	if (test_tsk_thread_flag(prev_p, TIF_PERFMON_CTXSW))
+		pfm_ctxsw_out(prev_p, next_p);
+
 	debugctl = prev->debugctlmsr;
 	if (next->ds_area_msr != prev->ds_area_msr) {
 		/* we clear debugctl to make sure DS
@@ -460,6 +467,9 @@
 	if (next->debugctlmsr != debugctl)
 		update_debugctlmsr(next->debugctlmsr);
 
+	if (test_tsk_thread_flag(next_p, TIF_PERFMON_CTXSW))
+		pfm_ctxsw_in(prev_p, next_p);
+
 	if (test_tsk_thread_flag(next_p, TIF_DEBUG)) {
 		set_debugreg(next->debugreg0, 0);
 		set_debugreg(next->debugreg1, 1);
Index: o3/arch/x86/kernel/signal_32.c
===================================================================
--- o3.orig/arch/x86/kernel/signal_32.c	2008-09-30 12:03:23.000000000 +0200
+++ o3/arch/x86/kernel/signal_32.c	2008-09-30 15:14:05.000000000 +0200
@@ -18,6 +18,7 @@
 #include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/elf.h>
+#include <linux/perfmon_kern.h>
 #include <linux/smp.h>
 #include <linux/mm.h>
 
@@ -657,6 +658,10 @@
 void
 do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 {
+ 	/* process perfmon asynchronous work (e.g. block thread or reset) */
+ 	if (thread_info_flags & _TIF_PERFMON_WORK)
+ 		pfm_handle_work(regs);
+
 	/* deal with pending signal delivery */
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
Index: o3/include/asm-x86/mach-default/entry_arch.h
===================================================================
--- o3.orig/include/asm-x86/mach-default/entry_arch.h	2008-09-30 12:04:08.000000000 +0200
+++ o3/include/asm-x86/mach-default/entry_arch.h	2008-09-30 15:14:05.000000000 +0200
@@ -32,4 +32,8 @@
 BUILD_INTERRUPT(thermal_interrupt,THERMAL_APIC_VECTOR)
 #endif
 
+#ifdef CONFIG_PERFMON
+BUILD_INTERRUPT(pmu_interrupt,LOCAL_PERFMON_VECTOR)
+#endif
+
 #endif

-- 

