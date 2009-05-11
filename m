Return-Path: <linux-kernel-owner+w=401wt.eu-S1758660AbZEKLy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660AbZEKLy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 07:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758569AbZEKLxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 07:53:49 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:54877 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758557AbZEKLxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 07:53:47 -0400
Date: Mon, 11 May 2009 17:23:44 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [Patch 06/12] Use the new wrapper routines to access debug
	registers in process/thread code
Message-ID: <20090511115344.GG25673@in.ibm.com>
References: <20090511114422.133566343@prasadkr_t60p.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=modify_process_related_06
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
 arch/x86/include/asm/processor.h |    4 ----
 arch/x86/kernel/process.c        |   23 ++++++-----------------
 arch/x86/kernel/process_32.c     |   31 +++++++++++++++++++++++++++++++
 arch/x86/kernel/process_64.c     |   33 +++++++++++++++++++++++++++++++++
 4 files changed, 70 insertions(+), 21 deletions(-)

Index: arch/x86/kernel/process.c
===================================================================
--- arch/x86/kernel/process.c.orig
+++ arch/x86/kernel/process.c
@@ -16,6 +16,8 @@
 #include <asm/uaccess.h>
 #include <asm/i387.h>
 #include <asm/ds.h>
+#include <asm/debugreg.h>
+#include <asm/hw_breakpoint.h>
 
 unsigned long idle_halt;
 EXPORT_SYMBOL(idle_halt);
@@ -47,6 +49,8 @@ void free_thread_xstate(struct task_stru
 		kmem_cache_free(task_xstate_cachep, tsk->thread.xstate);
 		tsk->thread.xstate = NULL;
 	}
+	if (unlikely(test_tsk_thread_flag(tsk, TIF_DEBUG)))
+		flush_thread_hw_breakpoint(tsk);
 
 	WARN(tsk->thread.ds_ctx, "leaking DS context\n");
 }
@@ -105,14 +109,9 @@ void flush_thread(void)
 	}
 #endif
 
-	clear_tsk_thread_flag(tsk, TIF_DEBUG);
+	if (unlikely(test_tsk_thread_flag(tsk, TIF_DEBUG)))
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
@@ -194,16 +193,6 @@ void __switch_to_xtra(struct task_struct
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
Index: arch/x86/kernel/process_32.c
===================================================================
--- arch/x86/kernel/process_32.c.orig
+++ arch/x86/kernel/process_32.c
@@ -61,6 +61,8 @@
 #include <asm/idle.h>
 #include <asm/syscalls.h>
 #include <asm/ds.h>
+#include <asm/debugreg.h>
+#include <asm/hw_breakpoint.h>
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
@@ -265,7 +267,14 @@ int copy_thread(unsigned long clone_flag
 
 	task_user_gs(p) = get_user_gs(regs);
 
+	p->thread.io_bitmap_ptr = NULL;
+
 	tsk = current;
+	err = -ENOMEM;
+	if (unlikely(test_tsk_thread_flag(tsk, TIF_DEBUG)))
+		if (copy_thread_hw_breakpoint(tsk, p, clone_flags))
+			goto out;
+
 	if (unlikely(test_tsk_thread_flag(tsk, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmemdup(tsk->thread.io_bitmap_ptr,
 						IO_BITMAP_BYTES, GFP_KERNEL);
@@ -285,10 +294,13 @@ int copy_thread(unsigned long clone_flag
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
@@ -427,6 +439,25 @@ __switch_to(struct task_struct *prev_p, 
 		lazy_load_gs(next->gs);
 
 	percpu_write(current_task, next_p);
+	/*
+	 * There's a problem with moving the switch_to_thread_hw_breakpoint()
+	 * call before current is updated.  Suppose a kernel breakpoint is
+	 * triggered in between the two.  The hw-breakpoint handler will see
+	 * that current is different from the task pointer stored in
+	 * last_debugged_task, so it will think the task pointer is leftover
+	 * from an old task (lazy switching) and will erase it. Then until the
+	 * next context switch, no user-breakpoints will be installed.
+	 *
+	 * The real problem is that it's impossible to update both current and
+	 * last_debugged_task at the same instant, so there will always be a
+	 * window in which they disagree and a breakpoint might get triggered.
+	 * Since we use lazy switching, we are forced to assume that a
+	 * disagreement means that current is correct and last_debugged_task is
+	 * old.  But if you move the code above then you'll create a window in
+	 * which current is old and last_debugged_task is correct.
+	 */
+	if (unlikely(test_tsk_thread_flag(next_p, TIF_DEBUG)))
+		switch_to_thread_hw_breakpoint(next_p);
 
 	return prev_p;
 }
Index: arch/x86/kernel/process_64.c
===================================================================
--- arch/x86/kernel/process_64.c.orig
+++ arch/x86/kernel/process_64.c
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
+	if (unlikely(dead_task->thread.debugreg7))
+		flush_thread_hw_breakpoint(dead_task);
 }
 
 static inline void set_32bit_tls(struct task_struct *t, int tls, u32 addr)
@@ -303,12 +307,18 @@ int copy_thread(unsigned long clone_flag
 
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
@@ -347,6 +357,9 @@ out:
 		kfree(p->thread.io_bitmap_ptr);
 		p->thread.io_bitmap_max = 0;
 	}
+	if (err)
+		flush_thread_hw_breakpoint(p);
+
 	return err;
 }
 
@@ -492,6 +505,26 @@ __switch_to(struct task_struct *prev_p, 
 	 */
 	if (tsk_used_math(next_p) && next_p->fpu_counter > 5)
 		math_state_restore();
+	/*
+	 * There's a problem with moving the switch_to_thread_hw_breakpoint()
+	 * call before current is updated.  Suppose a kernel breakpoint is
+	 * triggered in between the two.  The hw-breakpoint handler will see
+	 * that current is different from the task pointer stored in
+	 * last_debugged_task, so it will think the task pointer is leftover
+	 * from an old task (lazy switching) and will erase it. Then until the
+	 * next context switch, no user-breakpoints will be installed.
+	 *
+	 * The real problem is that it's impossible to update both current and
+	 * last_debugged_task at the same instant, so there will always be a
+	 * window in which they disagree and a breakpoint might get triggered.
+	 * Since we use lazy switching, we are forced to assume that a
+	 * disagreement means that current is correct and last_debugged_task is
+	 * old.  But if you move the code above then you'll create a window in
+	 * which current is old and last_debugged_task is correct.
+	 */
+	if (unlikely(test_tsk_thread_flag(next_p, TIF_DEBUG)))
+		switch_to_thread_hw_breakpoint(next_p);
+
 	return prev_p;
 }
 
Index: arch/x86/include/asm/processor.h
===================================================================
--- arch/x86/include/asm/processor.h.orig
+++ arch/x86/include/asm/processor.h
@@ -432,10 +432,6 @@ struct thread_struct {
 	unsigned long		fs;
 	unsigned long		gs;
 	/* Hardware debugging registers: */
-	unsigned long		debugreg0;
-	unsigned long		debugreg1;
-	unsigned long		debugreg2;
-	unsigned long		debugreg3;
 	unsigned long		debugreg[HB_NUM];
 	unsigned long		debugreg6;
 	unsigned long		debugreg7;

