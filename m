Return-Path: <linux-kernel-owner+w=401wt.eu-S1760312AbZBMQ3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760312AbZBMQ3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 11:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758042AbZBMQ2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 11:28:37 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:57187 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761238AbZBMQ2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 11:28:36 -0500
Date: Fri, 13 Feb 2009 20:27:32 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>, richardj_moore@uk.ibm.com,
       jason.wessel@windriver.com
Subject: [Patch 6/10] Use virtual debug registers in process/thread
	handling code
Message-ID: <20090213145732.GF32064@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090213145301.GA31546@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213145301.GA31546@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use virtual debug registers in process/thread handling code

From: Alan Stern <stern@rowland.harvard.edu>

This patch enables the use of abstract/virtual debug registers in
process-handling routines.

[K.Prasad: Split-out from the bigger patch and minor changes following
           re-basing]

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/kernel/process_32.c |   43 +++++++++++++++++++++++++------------------
 arch/x86/kernel/process_64.c |   41 ++++++++++++++++++++++++-----------------
 2 files changed, 49 insertions(+), 35 deletions(-)

Index: linux-2.6-tip.hbkpt/arch/x86/kernel/process_32.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/process_32.c
+++ linux-2.6-tip.hbkpt/arch/x86/kernel/process_32.c
@@ -61,6 +61,8 @@
 #include <asm/idle.h>
 #include <asm/syscalls.h>
 #include <asm/ds.h>
+#include <asm/debugreg.h>
+#include <asm/hw_breakpoint.h>
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
@@ -238,6 +240,8 @@ EXPORT_SYMBOL(kernel_thread);
  */
 void exit_thread(void)
 {
+	struct task_struct *tsk = current;
+
 	/* The process may have allocated an io port bitmap... nuke it. */
 	if (unlikely(test_thread_flag(TIF_IO_BITMAP))) {
 		struct task_struct *tsk = current;
@@ -258,6 +262,8 @@ void exit_thread(void)
 		tss->x86_tss.io_bitmap_base = INVALID_IO_BITMAP_OFFSET;
 		put_cpu();
 	}
+	if (unlikely(tsk->thread.hw_breakpoint_info))
+		flush_thread_hw_breakpoint(tsk);
 
 	ds_exit_thread(current);
 }
@@ -266,14 +272,9 @@ void flush_thread(void)
 {
 	struct task_struct *tsk = current;
 
-	tsk->thread.debugreg0 = 0;
-	tsk->thread.debugreg1 = 0;
-	tsk->thread.debugreg2 = 0;
-	tsk->thread.debugreg3 = 0;
-	tsk->thread.debugreg6 = 0;
-	tsk->thread.debugreg7 = 0;
 	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));
-	clear_tsk_thread_flag(tsk, TIF_DEBUG);
+	if (unlikely(tsk->thread.hw_breakpoint_info))
+		flush_thread_hw_breakpoint(tsk);
 	/*
 	 * Forget coprocessor state..
 	 */
@@ -317,7 +318,15 @@ int copy_thread(int nr, unsigned long cl
 
 	task_user_gs(p) = get_user_gs(regs);
 
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
@@ -336,11 +345,13 @@ int copy_thread(int nr, unsigned long cl
 	if (clone_flags & CLONE_SETTLS)
 		err = do_set_thread_area(p, -1,
 			(struct user_desc __user *)childregs->si, 0);
-
+ out:
 	if (err && p->thread.io_bitmap_ptr) {
 		kfree(p->thread.io_bitmap_ptr);
 		p->thread.io_bitmap_max = 0;
 	}
+	if (err)
+		flush_thread_hw_breakpoint(p);
 
 	ds_copy_thread(p, current);
 
@@ -442,16 +453,6 @@ __switch_to_xtra(struct task_struct *pre
 	else if (next->debugctlmsr != prev->debugctlmsr)
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
@@ -600,6 +601,12 @@ __switch_to(struct task_struct *prev_p, 
 
 	percpu_write(current_task, next_p);
 
+	/*
+	 * Handle debug registers.  This must be done _after_ current
+	 * is updated.
+	 */
+	if (unlikely(test_tsk_thread_flag(next_p, TIF_DEBUG)))
+		switch_to_thread_hw_breakpoint(next_p);
 	return prev_p;
 }
 
Index: linux-2.6-tip.hbkpt/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/process_64.c
+++ linux-2.6-tip.hbkpt/arch/x86/kernel/process_64.c
@@ -53,6 +53,8 @@
 #include <asm/proto.h>
 #include <asm/ia32.h>
 #include <asm/idle.h>
+#include <asm/debugreg.h>
+#include <asm/hw_breakpoint.h>
 #include <asm/syscalls.h>
 #include <asm/ds.h>
 
@@ -277,13 +279,9 @@ void flush_thread(void)
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
@@ -303,6 +301,8 @@ void release_thread(struct task_struct *
 			BUG();
 		}
 	}
+	if (unlikely(me->thread.hw_breakpoint_info))
+		flush_thread_hw_breakpoint(me);
 }
 
 static inline void set_32bit_tls(struct task_struct *t, int tls, u32 addr)
@@ -358,13 +358,21 @@ int copy_thread(int nr, unsigned long cl
 
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
@@ -401,6 +409,9 @@ out:
 		kfree(p->thread.io_bitmap_ptr);
 		p->thread.io_bitmap_max = 0;
 	}
+	if (err)
+		flush_thread_hw_breakpoint(p);
+
 	return err;
 }
 
@@ -503,16 +514,6 @@ static inline void __switch_to_xtra(stru
 	else if (next->debugctlmsr != prev->debugctlmsr)
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
@@ -535,6 +536,12 @@ static inline void __switch_to_xtra(stru
 		 */
 		memset(tss->io_bitmap, 0xff, prev->io_bitmap_max);
 	}
+	/*
+	 * Handle debug registers.  This must be done _after_ current
+	 * is updated.
+	 */
+	if (unlikely(test_tsk_thread_flag(next_p, TIF_DEBUG)))
+		switch_to_thread_hw_breakpoint(next_p);
 }
 
 /*
