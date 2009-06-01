Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbZFASPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbZFASPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 14:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756049AbZFASPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 14:15:17 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:53592 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987AbZFASPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 14:15:15 -0400
Date: Mon, 1 Jun 2009 23:44:55 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Stern <stern@rowland.harvard.edu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [Patch 06/12] Use the new wrapper routines to access debug
	registers in process/thread code
Message-ID: <20090601181455.GG23582@in.ibm.com>
References: <20090601180605.799735829@prasadkr_t60p.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=modify_process_related_06
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the use of abstract debug registers in
process-handling routines.

Original-patch-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/kernel/process.c    |   22 ++++++----------------
 arch/x86/kernel/process_32.c |   28 ++++++++++++++++++++++++++++
 arch/x86/kernel/process_64.c |   31 +++++++++++++++++++++++++++++++
 3 files changed, 65 insertions(+), 16 deletions(-)

Index: linux-2.6-tip.hbkpt/arch/x86/kernel/process.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/process.c
+++ linux-2.6-tip.hbkpt/arch/x86/kernel/process.c
@@ -17,6 +17,8 @@
 #include <asm/uaccess.h>
 #include <asm/i387.h>
 #include <asm/ds.h>
+#include <asm/debugreg.h>
+#include <asm/hw_breakpoint.h>
 
 unsigned long idle_halt;
 EXPORT_SYMBOL(idle_halt);
@@ -48,6 +50,8 @@ void free_thread_xstate(struct task_stru
 		kmem_cache_free(task_xstate_cachep, tsk->thread.xstate);
 		tsk->thread.xstate = NULL;
 	}
+	if (unlikely(test_tsk_thread_flag(tsk, TIF_DEBUG)))
+		flush_thread_hw_breakpoint(tsk);
 
 	WARN(tsk->thread.ds_ctx, "leaking DS context\n");
 }
@@ -108,12 +112,8 @@ void flush_thread(void)
 
 	clear_tsk_thread_flag(tsk, TIF_DEBUG);
 
-	tsk->thread.debugreg[0] = 0;
-	tsk->thread.debugreg[1] = 0;
-	tsk->thread.debugreg[2] = 0;
-	tsk->thread.debugreg[3] = 0;
-	tsk->thread.debugreg6 = 0;
-	tsk->thread.debugreg7 = 0;
+	if (unlikely(test_tsk_thread_flag(tsk, TIF_DEBUG)))
+		flush_thread_hw_breakpoint(tsk);
 	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));
 	/*
 	 * Forget coprocessor state..
@@ -195,16 +195,6 @@ void __switch_to_xtra(struct task_struct
 	else if (next->debugctlmsr != prev->debugctlmsr)
 		update_debugctlmsr(next->debugctlmsr);
 
-	if (test_tsk_thread_flag(next_p, TIF_DEBUG)) {
-		set_debugreg(next->debugreg[0], 0);
-		set_debugreg(next->debugreg[1], 1);
-		set_debugreg(next->debugreg[2], 2);
-		set_debugreg(next->debugreg[3], 3);
-		/* no 4 and 5 */
-		set_debugreg(next->debugreg6, 6);
-		set_debugreg(next->debugreg7, 7);
-	}
-
 	if (test_tsk_thread_flag(prev_p, TIF_NOTSC) ^
 	    test_tsk_thread_flag(next_p, TIF_NOTSC)) {
 		/* prev and next are different */
Index: linux-2.6-tip.hbkpt/arch/x86/kernel/process_32.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/process_32.c
+++ linux-2.6-tip.hbkpt/arch/x86/kernel/process_32.c
@@ -58,6 +58,8 @@
 #include <asm/idle.h>
 #include <asm/syscalls.h>
 #include <asm/ds.h>
+#include <asm/debugreg.h>
+#include <asm/hw_breakpoint.h>
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
@@ -262,7 +264,13 @@ int copy_thread(unsigned long clone_flag
 
 	task_user_gs(p) = get_user_gs(regs);
 
+	p->thread.io_bitmap_ptr = NULL;
 	tsk = current;
+	err = -ENOMEM;
+	if (unlikely(test_tsk_thread_flag(tsk, TIF_DEBUG)))
+		if (copy_thread_hw_breakpoint(tsk, p, clone_flags))
+			goto out;
+
 	if (unlikely(test_tsk_thread_flag(tsk, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmemdup(tsk->thread.io_bitmap_ptr,
 						IO_BITMAP_BYTES, GFP_KERNEL);
@@ -282,10 +290,13 @@ int copy_thread(unsigned long clone_flag
 		err = do_set_thread_area(p, -1,
 			(struct user_desc __user *)childregs->si, 0);
 
+out:
 	if (err && p->thread.io_bitmap_ptr) {
 		kfree(p->thread.io_bitmap_ptr);
 		p->thread.io_bitmap_max = 0;
 	}
+	if (err)
+		flush_thread_hw_breakpoint(p);
 
 	clear_tsk_thread_flag(p, TIF_DS_AREA_MSR);
 	p->thread.ds_ctx = NULL;
@@ -424,6 +435,23 @@ __switch_to(struct task_struct *prev_p, 
 		lazy_load_gs(next->gs);
 
 	percpu_write(current_task, next_p);
+	/*
+	 * There's a problem with moving the arch_install_thread_hw_breakpoint()
+	 * call before current is updated.  Suppose a kernel breakpoint is
+	 * triggered in between the two, the hw-breakpoint handler will see that
+	 * the 'current' task does not have TIF_DEBUG flag set and will think it
+	 * is leftover from an old task (lazy switching) and will erase it. Then
+	 * until the next context switch, no user-breakpoints will be installed.
+	 *
+	 * The real problem is that it's impossible to update both current and
+	 * physical debug registers at the same instant, so there will always be
+	 * a window in which they disagree and a breakpoint might get triggered.
+	 * Since we use lazy switching, we are forced to assume that a
+	 * disagreement means that current is correct and the exception is due
+	 * to lazy debug register switching.
+	 */
+	if (unlikely(test_tsk_thread_flag(next_p, TIF_DEBUG)))
+		arch_install_thread_hw_breakpoint(next_p);
 
 	return prev_p;
 }
Index: linux-2.6-tip.hbkpt/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/process_64.c
+++ linux-2.6-tip.hbkpt/arch/x86/kernel/process_64.c
@@ -52,6 +52,8 @@
 #include <asm/idle.h>
 #include <asm/syscalls.h>
 #include <asm/ds.h>
+#include <asm/debugreg.h>
+#include <asm/hw_breakpoint.h>
 
 asmlinkage extern void ret_from_fork(void);
 
@@ -245,6 +247,8 @@ void release_thread(struct task_struct *
 			BUG();
 		}
 	}
+	if (unlikely(dead_task->thread.debugreg7))
+		flush_thread_hw_breakpoint(dead_task);
 }
 
 static inline void set_32bit_tls(struct task_struct *t, int tls, u32 addr)
@@ -300,12 +304,18 @@ int copy_thread(unsigned long clone_flag
 
 	p->thread.fs = me->thread.fs;
 	p->thread.gs = me->thread.gs;
+	p->thread.io_bitmap_ptr = NULL;
 
 	savesegment(gs, p->thread.gsindex);
 	savesegment(fs, p->thread.fsindex);
 	savesegment(es, p->thread.es);
 	savesegment(ds, p->thread.ds);
 
+	err = -ENOMEM;
+	if (unlikely(test_tsk_thread_flag(me, TIF_DEBUG)))
+		if (copy_thread_hw_breakpoint(me, p, clone_flags))
+			goto out;
+
 	if (unlikely(test_tsk_thread_flag(me, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmalloc(IO_BITMAP_BYTES, GFP_KERNEL);
 		if (!p->thread.io_bitmap_ptr) {
@@ -344,6 +354,9 @@ out:
 		kfree(p->thread.io_bitmap_ptr);
 		p->thread.io_bitmap_max = 0;
 	}
+	if (err)
+		flush_thread_hw_breakpoint(p);
+
 	return err;
 }
 
@@ -489,6 +502,24 @@ __switch_to(struct task_struct *prev_p, 
 	 */
 	if (tsk_used_math(next_p) && next_p->fpu_counter > 5)
 		math_state_restore();
+	/*
+	 * There's a problem with moving the arch_install_thread_hw_breakpoint()
+	 * call before current is updated.  Suppose a kernel breakpoint is
+	 * triggered in between the two, the hw-breakpoint handler will see that
+	 * the 'current' task does not have TIF_DEBUG flag set and will think it
+	 * is leftover from an old task (lazy switching) and will erase it. Then
+	 * until the next context switch, no user-breakpoints will be installed.
+	 *
+	 * The real problem is that it's impossible to update both current and
+	 * physical debug registers at the same instant, so there will always be
+	 * a window in which they disagree and a breakpoint might get triggered.
+	 * Since we use lazy switching, we are forced to assume that a
+	 * disagreement means that current is correct and the exception is due
+	 * to lazy debug register switching.
+	 */
+	if (unlikely(test_tsk_thread_flag(next_p, TIF_DEBUG)))
+		arch_install_thread_hw_breakpoint(next_p);
+
 	return prev_p;
 }
 

