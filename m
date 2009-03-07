Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbZCGFHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbZCGFHw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 00:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754552AbZCGFHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 00:07:06 -0500
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:44307 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbZCGFHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 00:07:02 -0500
Date: Sat, 7 Mar 2009 10:36:47 +0530
From: prasad@linux.vnet.ibm.com
To: mingo@elte.hu
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [Patch 06/11] Use virtual debug registers in process/thread
	handling code
Message-ID: <20090307050647.GG23959@in.ibm.com>
References: <20090307045120.039324630@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="6.new"
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch enables the use of abstract/virtual debug registers in
process-handling routines.

[K.Prasad: Split-out from the bigger patch and minor changes following
           re-basing]

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/kernel/process.c    |   21 ++++-----------------
 arch/x86/kernel/process_32.c |   19 +++++++++++++++++++
 arch/x86/kernel/process_64.c |   14 ++++++++++++++
 3 files changed, 37 insertions(+), 17 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/process.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/process.c
+++ linux-2.6-tip/arch/x86/kernel/process.c
@@ -82,6 +82,8 @@ void exit_thread(void)
 		t->io_bitmap_max = 0;
 		put_cpu();
 	}
+	if (unlikely(t.hw_breakpoint_info))
+		flush_thread_hw_breakpoint(me);
 
 	ds_exit_thread(current);
 }
@@ -102,14 +104,9 @@ void flush_thread(void)
 	}
 #endif
 
-	clear_tsk_thread_flag(tsk, TIF_DEBUG);
+	if (unlikely(tsk->thread.hw_breakpoint_info))
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
@@ -191,16 +188,6 @@ void __switch_to_xtra(struct task_struct
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
Index: linux-2.6-tip/arch/x86/kernel/process_32.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/process_32.c
+++ linux-2.6-tip/arch/x86/kernel/process_32.c
@@ -59,6 +59,8 @@
 #include <asm/idle.h>
 #include <asm/syscalls.h>
 #include <asm/ds.h>
+#include <asm/debugreg.h>
+#include <asm/hw_breakpoint.h>
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
@@ -263,7 +265,15 @@ int copy_thread(int nr, unsigned long cl
 
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
@@ -283,10 +293,13 @@ int copy_thread(int nr, unsigned long cl
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
 
@@ -424,6 +437,12 @@ __switch_to(struct task_struct *prev_p, 
 		lazy_load_gs(next->gs);
 
 	percpu_write(current_task, next_p);
+	/*
+	 * Handle debug registers.  This must be done _after_ current
+	 * is updated.
+	 */
+	if (unlikely(test_tsk_thread_flag(next_p, TIF_DEBUG)))
+		switch_to_thread_hw_breakpoint(next_p);
 
 	return prev_p;
 }
Index: linux-2.6-tip/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/process_64.c
+++ linux-2.6-tip/arch/x86/kernel/process_64.c
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
+	if (unlikely(me->thread.hw_breakpoint_info))
+		flush_thread_hw_breakpoint(me);
 }
 
 static inline void set_32bit_tls(struct task_struct *t, int tls, u32 addr)
@@ -303,12 +307,19 @@ int copy_thread(int nr, unsigned long cl
 
 	p->thread.fs = me->thread.fs;
 	p->thread.gs = me->thread.gs;
+	p->thread.hw_breakpoint_info = NULL;
+	p->thread.io_bitmap_ptr = NULL;
 
 	savesegment(gs, p->thread.gsindex);
 	savesegment(fs, p->thread.fsindex);
 	savesegment(es, p->thread.es);
 	savesegment(ds, p->thread.ds);
 
+	err = -ENOMEM;
+	if (unlikely(me->thread.hw_breakpoint_info)) {
+		if (copy_thread_hw_breakpoint(me, p, clone_flags))
+			goto out;
+	}
 	if (unlikely(test_tsk_thread_flag(me, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmalloc(IO_BITMAP_BYTES, GFP_KERNEL);
 		if (!p->thread.io_bitmap_ptr) {
@@ -346,6 +357,9 @@ out:
 		kfree(p->thread.io_bitmap_ptr);
 		p->thread.io_bitmap_max = 0;
 	}
+	if (err)
+		flush_thread_hw_breakpoint(p);
+
 	return err;
 }
 

