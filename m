Return-Path: <linux-kernel-owner+w=401wt.eu-S1756110AbZFBWpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbZFBWpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbZFBWns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:43:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:20851 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869AbZFBWnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:43:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=aRCypLodWcJkSLKIZAvsMsucdHcRKeDovUrHnkXHE9wlDN2tRz2IexjDym3Mj/zrEN
         nsKEln6ZXCGYP8K/zDFy0/9h5A73ZbkbT/hv6guGZxrFXV61wBue0+TvG0A0Ty/GP07U
         ia12IhR3oBuOo8UayOESP9oXcfrAsIFaEr3IE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 06/12] hw-breakpoints: use the new wrapper routines to access debug registers in process/thread code
Date: Wed,  3 Jun 2009 00:43:30 +0200
Message-Id: <1243982616-18212-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1243982616-18212-1-git-send-email-fweisbec@gmail.com>
References: <1243982616-18212-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: K.Prasad <prasad@linux.vnet.ibm.com>

This patch enables the use of abstract debug registers in
process-handling routines, according to the new hardware breakpoint
Api.

[ Impact: adapt thread breakpoints handling code to the new breakpoint Api ]

Original-patch-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/process.c    |   22 ++++++----------------
 arch/x86/kernel/process_32.c |   28 ++++++++++++++++++++++++++++
 arch/x86/kernel/process_64.c |   31 +++++++++++++++++++++++++++++++
 3 files changed, 65 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 291527c..19a686c 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -15,6 +15,8 @@
 #include <asm/uaccess.h>
 #include <asm/i387.h>
 #include <asm/ds.h>
+#include <asm/debugreg.h>
+#include <asm/hw_breakpoint.h>
 
 unsigned long idle_halt;
 EXPORT_SYMBOL(idle_halt);
@@ -46,6 +48,8 @@ void free_thread_xstate(struct task_struct *tsk)
 		kmem_cache_free(task_xstate_cachep, tsk->thread.xstate);
 		tsk->thread.xstate = NULL;
 	}
+	if (unlikely(test_tsk_thread_flag(tsk, TIF_DEBUG)))
+		flush_thread_hw_breakpoint(tsk);
 
 	WARN(tsk->thread.ds_ctx, "leaking DS context\n");
 }
@@ -106,12 +110,8 @@ void flush_thread(void)
 
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
@@ -193,16 +193,6 @@ void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
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
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index b5e4bfe..297ffff 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -61,6 +61,8 @@
 #include <asm/idle.h>
 #include <asm/syscalls.h>
 #include <asm/ds.h>
+#include <asm/debugreg.h>
+#include <asm/hw_breakpoint.h>
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
@@ -265,7 +267,13 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 
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
@@ -285,10 +293,13 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
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
@@ -427,6 +438,23 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
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
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 5a1a1de..f7b276d 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -55,6 +55,8 @@
 #include <asm/idle.h>
 #include <asm/syscalls.h>
 #include <asm/ds.h>
+#include <asm/debugreg.h>
+#include <asm/hw_breakpoint.h>
 
 asmlinkage extern void ret_from_fork(void);
 
@@ -248,6 +250,8 @@ void release_thread(struct task_struct *dead_task)
 			BUG();
 		}
 	}
+	if (unlikely(dead_task->thread.debugreg7))
+		flush_thread_hw_breakpoint(dead_task);
 }
 
 static inline void set_32bit_tls(struct task_struct *t, int tls, u32 addr)
@@ -303,12 +307,18 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 
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
 
@@ -492,6 +505,24 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
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
 
-- 
1.6.2.3

