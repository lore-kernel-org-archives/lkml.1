Return-Path: <linux-kernel-owner+w=401wt.eu-S1762287AbZCSXub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762287AbZCSXub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 19:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762164AbZCSXta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 19:49:30 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:60927 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761788AbZCSXt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 19:49:29 -0400
Date: Fri, 20 Mar 2009 05:19:19 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [Patch 06/11] Use the new wrapper routines to access debug
	registers in process/thread code
Message-ID: <20090319234919.GG10517@in.ibm.com>
References: <20090319234044.410725944@K.Prasad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="6.new"
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch enables the use of abstract debug registers in
process-handling routines.

[K.Prasad: Split-out from the bigger patch and minor changes following
           re-basing]

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/kernel/process.c    |   23 ++++++-----------------
 arch/x86/kernel/process_32.c |   31 +++++++++++++++++++++++++++++++
 arch/x86/kernel/process_64.c |   33 +++++++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+), 17 deletions(-)

Index: linux-2.6-tip.hbkpt/arch/x86/kernel/process.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/process.c
+++ linux-2.6-tip.hbkpt/arch/x86/kernel/process.c
@@ -14,6 +14,8 @@
 #include <asm/idle.h>
 #include <asm/uaccess.h>
 #include <asm/i387.h>
+#include <asm/debugreg.h>
+#include <asm/hw_breakpoint.h>
 
 unsigned long idle_halt;
 EXPORT_SYMBOL(idle_halt);
@@ -83,6 +85,8 @@ void exit_thread(void)
 		put_cpu();
 		kfree(bp);
 	}
+	if (unlikely(t->dr7))
+		flush_thread_hw_breakpoint(me);
 
 	ds_exit_thread(current);
 }
@@ -103,14 +107,9 @@ void flush_thread(void)
 	}
 #endif
 
-	clear_tsk_thread_flag(tsk, TIF_DEBUG);
+	if (unlikely(tsk->thread.dr7))
+		flush_thread_hw_breakpoint(tsk);
 
-	tsk->thread.debugreg0 = 0;
-	tsk->thread.debugreg1 = 0;
-	tsk->thread.debugreg2 = 0;
-	tsk->thread.debugreg3 = 0;
-	tsk->thread.debugreg6 = 0;
-	tsk->thread.debugreg7 = 0;
 	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));
 	/*
 	 * Forget coprocessor state..
@@ -192,16 +191,6 @@ void __switch_to_xtra(struct task_struct
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
Index: linux-2.6-tip.hbkpt/arch/x86/kernel/process_32.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/process_32.c
+++ linux-2.6-tip.hbkpt/arch/x86/kernel/process_32.c
@@ -59,6 +59,8 @@
 #include <asm/idle.h>
 #include <asm/syscalls.h>
 #include <asm/ds.h>
+#include <asm/debugreg.h>
+#include <asm/hw_breakpoint.h>
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
@@ -263,7 +265,14 @@ int copy_thread(int nr, unsigned long cl
 
 	task_user_gs(p) = get_user_gs(regs);
 
+	p->thread.io_bitmap_ptr = NULL;
+
 	tsk = current;
+	err = -ENOMEM;
+	if (unlikely(tsk->thread.dr7)) {
+		if (copy_thread_hw_breakpoint(tsk, p, clone_flags))
+			goto out;
+	}
 	if (unlikely(test_tsk_thread_flag(tsk, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmemdup(tsk->thread.io_bitmap_ptr,
 						IO_BITMAP_BYTES, GFP_KERNEL);
@@ -283,10 +292,13 @@ int copy_thread(int nr, unsigned long cl
 		err = do_set_thread_area(p, -1,
 			(struct user_desc __user *)childregs->si, 0);
 
+out:
 	if (err && p->thread.io_bitmap_ptr) {
 		kfree(p->thread.io_bitmap_ptr);
 		p->thread.io_bitmap_max = 0;
 	}
+	if (err)
+		flush_thread_hw_breakpoint(p);
 
 	ds_copy_thread(p, current);
 
@@ -424,6 +436,25 @@ __switch_to(struct task_struct *prev_p, 
 		lazy_load_gs(next->gs);
 
 	percpu_write(current_task, next_p);
+	/*
+	 * There's a problem with moving the switch_to_thread_hw_breakpoint()
+	 * call before current is updated.  Suppose a kernel breakpoint is
+	 * triggered in between the two.  The hw-breakpoint handler will see
+	 * that current is different from the task pointer stored in the chbi
+	 * area, so it will think the task pointer is leftover from an old task
+	 * (lazy switching) and will erase it.  Then until the next context
+	 * switch, no user-breakpoints will be installed.
+	 *
+	 * The real problem is that it's impossible to update both current and
+	 * chbi->bp_task at the same instant, so there will always be a window
+	 * in which they disagree and a breakpoint might get triggered.  Since
+	 * we use lazy switching, we are forced to assume that a disagreement
+	 * means that current is correct and chbi->bp_task is old.  But if you
+	 * move the code above then you'll create a window in which current is
+	 * old and chbi->bp_task is correct.
+	 */
+	if (unlikely(test_tsk_thread_flag(next_p, TIF_DEBUG)))
+		switch_to_thread_hw_breakpoint(next_p);
 
 	return prev_p;
 }
Index: linux-2.6-tip.hbkpt/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/process_64.c
+++ linux-2.6-tip.hbkpt/arch/x86/kernel/process_64.c
@@ -55,6 +55,8 @@
 #include <asm/idle.h>
 #include <asm/syscalls.h>
 #include <asm/ds.h>
+#include <asm/debugreg.h>
+#include <asm/hw_breakpoint.h>
 
 asmlinkage extern void ret_from_fork(void);
 
@@ -248,6 +250,8 @@ void release_thread(struct task_struct *
 			BUG();
 		}
 	}
+	if (unlikely(dead_task->thread.tdr7))
+		flush_thread_hw_breakpoint(dead_task);
 }
 
 static inline void set_32bit_tls(struct task_struct *t, int tls, u32 addr)
@@ -303,12 +307,18 @@ int copy_thread(int nr, unsigned long cl
 
 	p->thread.fs = me->thread.fs;
 	p->thread.gs = me->thread.gs;
+	p->thread.io_bitmap_ptr = NULL;
 
 	savesegment(gs, p->thread.gsindex);
 	savesegment(fs, p->thread.fsindex);
 	savesegment(es, p->thread.es);
 	savesegment(ds, p->thread.ds);
 
+	err = -ENOMEM;
+	if (unlikely(me->thread.tdr7)) {
+		if (copy_thread_hw_breakpoint(me, p, clone_flags))
+			goto out;
+	}
 	if (unlikely(test_tsk_thread_flag(me, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmalloc(IO_BITMAP_BYTES, GFP_KERNEL);
 		if (!p->thread.io_bitmap_ptr) {
@@ -346,6 +356,9 @@ out:
 		kfree(p->thread.io_bitmap_ptr);
 		p->thread.io_bitmap_max = 0;
 	}
+	if (err)
+		flush_thread_hw_breakpoint(p);
+
 	return err;
 }
 
@@ -491,6 +504,26 @@ __switch_to(struct task_struct *prev_p, 
 	 */
 	if (tsk_used_math(next_p) && next_p->fpu_counter > 5)
 		math_state_restore();
+	/*
+	 * There's a problem with moving the switch_to_thread_hw_breakpoint()
+	 * call before current is updated.  Suppose a kernel breakpoint is
+	 * triggered in between the two.  The hw-breakpoint handler will see
+	 * that current is different from the task pointer stored in the chbi
+	 * area, so it will think the task pointer is leftover from an old task
+	 * (lazy switching) and will erase it.  Then until the next context
+	 * switch, no user-breakpoints will be installed.
+	 *
+	 * The real problem is that it's impossible to update both current and
+	 * chbi->bp_task at the same instant, so there will always be a window
+	 * in which they disagree and a breakpoint might get triggered.  Since
+	 * we use lazy switching, we are forced to assume that a disagreement
+	 * means that current is correct and chbi->bp_task is old.  But if you
+	 * move the code above then you'll create a window in which current is
+	 * old and chbi->bp_task is correct.
+	 */
+	if (unlikely(test_tsk_thread_flag(next_p, TIF_DEBUG)))
+		switch_to_thread_hw_breakpoint(next_p);
+
 	return prev_p;
 }
 

