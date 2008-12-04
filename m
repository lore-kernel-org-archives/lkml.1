Return-Path: <linux-kernel-owner+w=401wt.eu-S1760068AbYLDTOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068AbYLDTOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 14:14:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759914AbYLDTNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 14:13:53 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:60254 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759895AbYLDTNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 14:13:52 -0500
Date: Fri, 5 Dec 2008 00:43:44 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, mingo@elte.hu, richardj_moore@uk.ibm.com
Subject: [RFC Patch 6/9] Use virtual debug registers in process/thread
	handling code
Message-ID: <20081204191344.GF20563@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20081204190804.GA15134@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204190804.GA15134@in.ibm.com>
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
 arch/x86/kernel/process_64.c |   41 ++++++++++++++++++++++-----------------
 2 files changed, 51 insertions(+), 35 deletions(-)

Index: linux-2.6.28-rc5-bkpt-latest/arch/x86/kernel/process_32.c
===================================================================
--- linux-2.6.28-rc5-bkpt-latest.orig/arch/x86/kernel/process_32.c
+++ linux-2.6.28-rc5-bkpt-latest/arch/x86/kernel/process_32.c
@@ -59,6 +59,8 @@
 #include <asm/idle.h>
 #include <asm/syscalls.h>
 #include <asm/smp.h>
+#include <asm/debugreg.h>
+#include <asm/hw_breakpoint.h>
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
@@ -230,6 +232,8 @@ EXPORT_SYMBOL(kernel_thread);
  */
 void exit_thread(void)
 {
+	struct task_struct *tsk = current;
+
 	/* The process may have allocated an io port bitmap... nuke it. */
 	if (unlikely(test_thread_flag(TIF_IO_BITMAP))) {
 		struct task_struct *tsk = current;
@@ -250,6 +254,8 @@ void exit_thread(void)
 		tss->x86_tss.io_bitmap_base = INVALID_IO_BITMAP_OFFSET;
 		put_cpu();
 	}
+	if (unlikely(tsk->thread.hw_breakpoint_info))
+		flush_thread_hw_breakpoint(tsk);
 #ifdef CONFIG_X86_DS
 	/* Free any DS contexts that have not been properly released. */
 	if (unlikely(current->thread.ds_ctx)) {
@@ -264,14 +270,9 @@ void flush_thread(void)
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
@@ -315,7 +316,15 @@ int copy_thread(int nr, unsigned long cl
 
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
@@ -335,10 +344,14 @@ int copy_thread(int nr, unsigned long cl
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
 
@@ -463,16 +476,6 @@ __switch_to_xtra(struct task_struct *pre
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
@@ -628,6 +631,12 @@ struct task_struct * __switch_to(struct 
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
Index: linux-2.6.28-rc5-bkpt-latest/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6.28-rc5-bkpt-latest.orig/arch/x86/kernel/process_64.c
+++ linux-2.6.28-rc5-bkpt-latest/arch/x86/kernel/process_64.c
@@ -51,6 +51,8 @@
 #include <asm/proto.h>
 #include <asm/ia32.h>
 #include <asm/idle.h>
+#include <asm/debugreg.h>
+#include <asm/hw_breakpoint.h>
 #include <asm/syscalls.h>
 
 asmlinkage extern void ret_from_fork(void);
@@ -260,13 +262,9 @@ void flush_thread(void)
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
@@ -286,6 +284,8 @@ void release_thread(struct task_struct *
 			BUG();
 		}
 	}
+	if (unlikely(me->thread.hw_breakpoint_info))
+		flush_thread_hw_breakpoint(me);
 }
 
 static inline void set_32bit_tls(struct task_struct *t, int tls, u32 addr)
@@ -341,13 +341,21 @@ int copy_thread(int nr, unsigned long cl
 
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
@@ -378,6 +386,9 @@ out:
 		kfree(p->thread.io_bitmap_ptr);
 		p->thread.io_bitmap_max = 0;
 	}
+	if (err)
+		flush_thread_hw_breakpoint(p);
+
 	return err;
 }
 
@@ -501,16 +512,6 @@ static inline void __switch_to_xtra(stru
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
@@ -541,6 +542,12 @@ static inline void __switch_to_xtra(stru
 	if (test_tsk_thread_flag(next_p, TIF_BTS_TRACE_TS))
 		ptrace_bts_take_timestamp(next_p, BTS_TASK_ARRIVES);
 #endif /* CONFIG_X86_PTRACE_BTS */
+/*
+	 * Handle debug registers.  This must be done _after_ current
+	 * is updated.
+	 */
+	if (unlikely(test_tsk_thread_flag(next_p, TIF_DEBUG)))
+		switch_to_thread_hw_breakpoint(next_p);
 }
 
 /*
