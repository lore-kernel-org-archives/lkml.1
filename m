Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbYKYVj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbYKYVj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbYKYVgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:36:19 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:62506 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbYKYVgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:36:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=Oe10P5AM0UfxpCEOLHDNtDF8GSEhyr/JNGJ677U1o1mfNDpRgyXug7Uum1xjPBhZAU
         8RBTnKZ9i7NDhTyzjg6xYcpn08hUrzYPBwwmnscneHPEXmoX1cScW8U+gtn4+0R8zmg8
         TiAtGbtYJwaqh2+SWtOcsjOonEOXCEdsP9lbA=
To: linux-kernel@vger.kernel.org
Subject: [patch 09/24] perfmon: X86 32-bit hooks (x86)
From: eranian@googlemail.com
Date: Tue, 25 Nov 2008 13:36:14 -0800 (PST)
Message-ID: <492c6fce.1c365e0a.167b.759e@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the necessary hooks to the X86 32-bit code
to support initialization, interrupts, context switching,
and termination of a perfmon session.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: o3/arch/x86/kernel/entry_32.S
===================================================================
--- o3.orig/arch/x86/kernel/entry_32.S	2008-11-03 11:34:00.000000000 +0100
+++ o3/arch/x86/kernel/entry_32.S	2008-11-03 11:35:20.000000000 +0100
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
--- o3.orig/arch/x86/kernel/process_32.c	2008-11-03 11:34:00.000000000 +0100
+++ o3/arch/x86/kernel/process_32.c	2008-11-03 12:54:08.000000000 +0100
@@ -36,6 +36,7 @@
 #include <linux/personality.h>
 #include <linux/tick.h>
 #include <linux/percpu.h>
+#include <linux/perfmon_kern.h>
 #include <linux/prctl.h>
 #include <linux/dmi.h>
 
@@ -258,6 +259,7 @@
 		ds_free(current->thread.ds_ctx);
 	}
 #endif /* CONFIG_X86_DS */
+	pfm_exit_thread();
 }
 
 void flush_thread(void)
@@ -315,6 +317,8 @@
 
 	savesegment(gs, p->thread.gs);
 
+	pfm_copy_thread(p);
+
 	tsk = current;
 	if (unlikely(test_tsk_thread_flag(tsk, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmemdup(tsk->thread.io_bitmap_ptr,
@@ -458,11 +462,17 @@
 	prev = &prev_p->thread;
 	next = &next_p->thread;
 
+ 	if (test_tsk_thread_flag(prev_p, TIF_PERFMON_CTXSW))
+ 		pfm_ctxsw_out(prev_p, next_p);
+
 	debugctl = update_debugctl(prev, next, prev->debugctlmsr);
 
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
--- o3.orig/arch/x86/kernel/signal_32.c	2008-11-03 11:34:00.000000000 +0100
+++ o3/arch/x86/kernel/signal_32.c	2008-11-03 11:35:20.000000000 +0100
@@ -19,6 +19,7 @@
 #include <linux/wait.h>
 #include <linux/tracehook.h>
 #include <linux/elf.h>
+#include <linux/perfmon_kern.h>
 #include <linux/smp.h>
 #include <linux/mm.h>
 
@@ -685,6 +686,10 @@
 		mce_notify_user();
 #endif /* CONFIG_X86_64 && CONFIG_X86_MCE */
 
+  	/* process perfmon asynchronous work (e.g. block thread or reset) */
+  	if (thread_info_flags & _TIF_PERFMON_WORK)
+  		pfm_handle_work(regs);
+
 	/* deal with pending signal delivery */
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
Index: o3/arch/x86/include/asm/mach-default/entry_arch.h
===================================================================
--- o3.orig/arch/x86/include/asm/mach-default/entry_arch.h	2008-11-03 11:34:00.000000000 +0100
+++ o3/arch/x86/include/asm/mach-default/entry_arch.h	2008-11-03 11:35:20.000000000 +0100
@@ -33,4 +33,8 @@
 BUILD_INTERRUPT(thermal_interrupt,THERMAL_APIC_VECTOR)
 #endif
 
+#ifdef CONFIG_PERFMON
+BUILD_INTERRUPT(pmu_interrupt,LOCAL_PERFMON_VECTOR)
+#endif
+
 #endif

-- 

