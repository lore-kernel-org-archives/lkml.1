Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbYJHT0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbYJHT0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 15:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbYJHT0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 15:26:00 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:52793 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754866AbYJHTZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 15:25:59 -0400
Date: Thu, 9 Oct 2008 00:55:48 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, mingo@elte.hu, jason.wessel@windriver.com,
       avi@qumranet.com, richardj_moore@uk.ibm.com
Subject: [RFC Patch 6/9] Use virtual debug registers in process/thread
	handling code
Message-ID: <20081008192548.GF4989@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20081008192044.GA4510@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081008192044.GA4510@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the use of abstract/virtual debug registers in
process-handling routines.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/kernel/process_32.c |   45 +++++++++++++++++++++++++------------------
 arch/x86/kernel/process_64.c |   42 +++++++++++++++++++++++-----------------
 2 files changed, 52 insertions(+), 35 deletions(-)

Index: linux-bkpt-lkml-27-rc9/arch/x86/kernel/process_32.c
===================================================================
--- linux-bkpt-lkml-27-rc9.orig/arch/x86/kernel/process_32.c
+++ linux-bkpt-lkml-27-rc9/arch/x86/kernel/process_32.c
@@ -56,6 +56,8 @@
 #include <asm/cpu.h>
 #include <asm/kdebug.h>
 #include <asm/idle.h>
+#include <asm/debugreg.h>
+#include <asm/hw_breakpoint.h>
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
@@ -257,6 +259,8 @@ EXPORT_SYMBOL(kernel_thread);
  */
 void exit_thread(void)
 {
+	struct task_struct *tsk = current;
+
 	/* The process may have allocated an io port bitmap... nuke it. */
 	if (unlikely(test_thread_flag(TIF_IO_BITMAP))) {
 		struct task_struct *tsk = current;
@@ -277,20 +281,17 @@ void exit_thread(void)
 		tss->x86_tss.io_bitmap_base = INVALID_IO_BITMAP_OFFSET;
 		put_cpu();
 	}
+	if (unlikely(tsk->thread.hw_breakpoint_info))
+		flush_thread_hw_breakpoint(tsk);
 }
 
 void flush_thread(void)
 {
 	struct task_struct *tsk = current;
 
-	tsk->thread.debugreg0 = 0;
-	tsk->thread.debugreg1 = 0;
-	tsk->thread.debugreg2 = 0;
-	tsk->thread.debugreg3 = 0;
-	tsk->thread.debugreg6 = 0;
-	tsk->thread.debugreg7 = 0;
-	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));	
-	clear_tsk_thread_flag(tsk, TIF_DEBUG);
+	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));
+	if (unlikely(tsk->thread.hw_breakpoint_info))
+		flush_thread_hw_breakpoint(tsk);
 	/*
 	 * Forget coprocessor state..
 	 */
@@ -334,7 +335,15 @@ int copy_thread(int nr, unsigned long cl
 
 	savesegment(gs, p->thread.gs);
 
+	p->thread.hw_breakpoint_info = NULL;
+	p->thread.io_bitmap_ptr = NULL;
+
 	tsk = current;
+	err = -ENOMEM;
+	if (unlikely(tsk->thread.hw_breakpoint_info)) {
+		if (copy_thread_hw_breakpoint(tsk, p, clone_flags))
+			goto out;
+	}
 	if (unlikely(test_tsk_thread_flag(tsk, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmemdup(tsk->thread.io_bitmap_ptr,
 						IO_BITMAP_BYTES, GFP_KERNEL);
@@ -354,10 +363,14 @@ int copy_thread(int nr, unsigned long cl
 		err = do_set_thread_area(p, -1,
 			(struct user_desc __user *)childregs->si, 0);
 
+out:
 	if (err && p->thread.io_bitmap_ptr) {
 		kfree(p->thread.io_bitmap_ptr);
 		p->thread.io_bitmap_max = 0;
 	}
+	if (err)
+		flush_thread_hw_breakpoint(p);
+
 	return err;
 }
 
@@ -460,16 +473,6 @@ __switch_to_xtra(struct task_struct *pre
 	if (next->debugctlmsr != debugctl)
 		update_debugctlmsr(next->debugctlmsr);
 
-	if (test_tsk_thread_flag(next_p, TIF_DEBUG)) {
-		set_debugreg(next->debugreg0, 0);
-		set_debugreg(next->debugreg1, 1);
-		set_debugreg(next->debugreg2, 2);
-		set_debugreg(next->debugreg3, 3);
-		/* no 4 and 5 */
-		set_debugreg(next->debugreg6, 6);
-		set_debugreg(next->debugreg7, 7);
-	}
-
 	if (test_tsk_thread_flag(prev_p, TIF_NOTSC) ^
 	    test_tsk_thread_flag(next_p, TIF_NOTSC)) {
 		/* prev and next are different */
@@ -625,6 +628,12 @@ struct task_struct * __switch_to(struct 
 		loadsegment(gs, next->gs);
 
 	x86_write_percpu(current_task, next_p);
+	/*
+	 * Handle debug registers.  This must be done _after_ current
+	 * is updated.
+	 */
+	if (unlikely(test_tsk_thread_flag(next_p, TIF_DEBUG)))
+		switch_to_thread_hw_breakpoint(next_p);
 
 	return prev_p;
 }
Index: linux-bkpt-lkml-27-rc9/arch/x86/kernel/process_64.c
===================================================================
--- linux-bkpt-lkml-27-rc9.orig/arch/x86/kernel/process_64.c
+++ linux-bkpt-lkml-27-rc9/arch/x86/kernel/process_64.c
@@ -51,6 +51,8 @@
 #include <asm/proto.h>
 #include <asm/ia32.h>
 #include <asm/idle.h>
+#include <asm/debugreg.h>
+#include <asm/hw_breakpoint.h>
 
 asmlinkage extern void ret_from_fork(void);
 
@@ -240,6 +242,8 @@ void exit_thread(void)
 		t->io_bitmap_max = 0;
 		put_cpu();
 	}
+	if (unlikely(me->thread.hw_breakpoint_info))
+		flush_thread_hw_breakpoint(me);
 }
 
 void flush_thread(void)
@@ -257,13 +261,9 @@ void flush_thread(void)
 	}
 	clear_tsk_thread_flag(tsk, TIF_DEBUG);
 
-	tsk->thread.debugreg0 = 0;
-	tsk->thread.debugreg1 = 0;
-	tsk->thread.debugreg2 = 0;
-	tsk->thread.debugreg3 = 0;
-	tsk->thread.debugreg6 = 0;
-	tsk->thread.debugreg7 = 0;
 	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));
+	if (unlikely(tsk->thread.hw_breakpoint_info))
+		flush_thread_hw_breakpoint(tsk);
 	/*
 	 * Forget coprocessor state..
 	 */
@@ -338,13 +338,21 @@ int copy_thread(int nr, unsigned long cl
 
 	p->thread.fs = me->thread.fs;
 	p->thread.gs = me->thread.gs;
+	p->thread.hw_breakpoint_info = NULL;
+	p->thread.io_bitmap_ptr = NULL;
 
 	savesegment(gs, p->thread.gsindex);
 	savesegment(fs, p->thread.fsindex);
 	savesegment(es, p->thread.es);
 	savesegment(ds, p->thread.ds);
 
-	if (unlikely(test_tsk_thread_flag(me, TIF_IO_BITMAP))) {
+	err = -ENOMEM;
+	if (unlikely(me->thread.hw_breakpoint_info)) {
+		if (copy_thread_hw_breakpoint(me, p, clone_flags))
+			goto out;
+	}
+
+if (unlikely(test_tsk_thread_flag(me, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmalloc(IO_BITMAP_BYTES, GFP_KERNEL);
 		if (!p->thread.io_bitmap_ptr) {
 			p->thread.io_bitmap_max = 0;
@@ -375,6 +383,9 @@ out:
 		kfree(p->thread.io_bitmap_ptr);
 		p->thread.io_bitmap_max = 0;
 	}
+	if (err)
+		flush_thread_hw_breakpoint(p);
+
 	return err;
 }
 
@@ -484,16 +495,6 @@ static inline void __switch_to_xtra(stru
 	if (next->debugctlmsr != debugctl)
 		update_debugctlmsr(next->debugctlmsr);
 
-	if (test_tsk_thread_flag(next_p, TIF_DEBUG)) {
-		loaddebug(next, 0);
-		loaddebug(next, 1);
-		loaddebug(next, 2);
-		loaddebug(next, 3);
-		/* no 4 and 5 */
-		loaddebug(next, 6);
-		loaddebug(next, 7);
-	}
-
 	if (test_tsk_thread_flag(prev_p, TIF_NOTSC) ^
 	    test_tsk_thread_flag(next_p, TIF_NOTSC)) {
 		/* prev and next are different */
@@ -524,6 +525,13 @@ static inline void __switch_to_xtra(stru
 	if (test_tsk_thread_flag(next_p, TIF_BTS_TRACE_TS))
 		ptrace_bts_take_timestamp(next_p, BTS_TASK_ARRIVES);
 #endif
+
+/*
+	 * Handle debug registers.  This must be done _after_ current
+	 * is updated.
+	 */
+	if (unlikely(test_tsk_thread_flag(next_p, TIF_DEBUG)))
+		switch_to_thread_hw_breakpoint(next_p);
 }
 
 /*
