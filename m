Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbYJGLpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbYJGLpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 07:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbYJGLpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 07:45:09 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:38208 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbYJGLpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:45:06 -0400
Date: Tue, 7 Oct 2008 17:14:51 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, mingo@elte.hu, jason.wessel@windriver.com,
       avi@qumranet.com, richardj_moore@uk.ibm.com
Subject: [RFC Patch 6/9] Use virtual debug registers in process/thread
	handling code
Message-ID: <20081007114451.GA25875@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20081007113815.GA23523@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007113815.GA23523@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the use of abstract/virtual debug registers in
process-handling routines.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/kernel/process_32.c |   68 +++++++++++++++++++++++++------------------
 arch/x86/kernel/process_64.c |   65 ++++++++++++++++++++++++-----------------
 2 files changed, 79 insertions(+), 54 deletions(-)

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
 
@@ -158,9 +160,11 @@ void cpu_idle(void)
 void __show_registers(struct pt_regs *regs, int all)
 {
 	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L;
-	unsigned long d0, d1, d2, d3, d6, d7;
+	unsigned long u_debugreg[8];
 	unsigned long sp;
 	unsigned short ss, gs;
+	struct thread_hw_breakpoint *thbi = current->thread.hw_breakpoint_info;
+	int i;
 
 	if (user_mode_vm(regs)) {
 		sp = regs->sp;
@@ -201,17 +205,18 @@ void __show_registers(struct pt_regs *re
 	printk("CR0: %08lx CR2: %08lx CR3: %08lx CR4: %08lx\n",
 			cr0, cr2, cr3, cr4);
 
-	get_debugreg(d0, 0);
-	get_debugreg(d1, 1);
-	get_debugreg(d2, 2);
-	get_debugreg(d3, 3);
+	if (thbi) {
+		for (i = 0; i < HB_NUM; ++i)
+			u_debugreg[i] = thbi->vdr_bps[i].info.address;
+		u_debugreg[7] = thbi->vdr7;
+	}
+	u_debugreg[6] = current->thread.vdr6;
+
 	printk("DR0: %08lx DR1: %08lx DR2: %08lx DR3: %08lx\n",
-			d0, d1, d2, d3);
+					u_debugreg[0], u_debugreg[1],
+						u_debugreg[2], u_debugreg[3]);
 
-	get_debugreg(d6, 6);
-	get_debugreg(d7, 7);
-	printk("DR6: %08lx DR7: %08lx\n",
-			d6, d7);
+	printk("DR6: %08lx DR7: %08lx\n", u_debugreg[6], u_debugreg[7]);
 }
 
 void show_regs(struct pt_regs *regs)
@@ -257,6 +262,8 @@ EXPORT_SYMBOL(kernel_thread);
  */
 void exit_thread(void)
 {
+	struct task_struct *tsk = current;
+
 	/* The process may have allocated an io port bitmap... nuke it. */
 	if (unlikely(test_thread_flag(TIF_IO_BITMAP))) {
 		struct task_struct *tsk = current;
@@ -277,20 +284,17 @@ void exit_thread(void)
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
@@ -334,7 +338,15 @@ int copy_thread(int nr, unsigned long cl
 
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
@@ -354,10 +366,14 @@ int copy_thread(int nr, unsigned long cl
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
 
@@ -460,16 +476,6 @@ __switch_to_xtra(struct task_struct *pre
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
@@ -625,6 +631,12 @@ struct task_struct * __switch_to(struct 
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
 
@@ -156,9 +158,11 @@ void cpu_idle(void)
 void __show_regs(struct pt_regs * regs)
 {
 	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L, fs, gs, shadowgs;
-	unsigned long d0, d1, d2, d3, d6, d7;
+	unsigned long u_debugreg[8];
 	unsigned int fsindex, gsindex;
 	unsigned int ds, cs, es;
+	struct thread_hw_breakpoint *thbi = current->thread.hw_breakpoint_info;
+	int i;
 
 	printk("\n");
 	print_modules();
@@ -202,14 +206,17 @@ void __show_regs(struct pt_regs * regs)
 	printk("CS:  %04x DS: %04x ES: %04x CR0: %016lx\n", cs, ds, es, cr0); 
 	printk("CR2: %016lx CR3: %016lx CR4: %016lx\n", cr2, cr3, cr4);
 
-	get_debugreg(d0, 0);
-	get_debugreg(d1, 1);
-	get_debugreg(d2, 2);
-	printk("DR0: %016lx DR1: %016lx DR2: %016lx\n", d0, d1, d2);
-	get_debugreg(d3, 3);
-	get_debugreg(d6, 6);
-	get_debugreg(d7, 7);
-	printk("DR3: %016lx DR6: %016lx DR7: %016lx\n", d3, d6, d7);
+	if (thbi) {
+		for (i = 0; i < HB_NUM; ++i)
+			u_debugreg[i] = thbi->vdr_bps[i].info.address;
+		u_debugreg[7] = thbi->vdr7;
+	}
+	u_debugreg[6] = current->thread.vdr6;
+
+	printk("DR0: %016lx DR1: %016lx DR2: %016lx\n", u_debugreg[0],
+						u_debugreg[1], u_debugreg[2]);
+	printk("DR3: %016lx DR6: %016lx DR7: %016lx\n", u_debugreg[3],
+						u_debugreg[6], u_debugreg[7]);
 }
 
 void show_regs(struct pt_regs *regs)
@@ -240,6 +247,8 @@ void exit_thread(void)
 		t->io_bitmap_max = 0;
 		put_cpu();
 	}
+	if (unlikely(me->thread.hw_breakpoint_info))
+		flush_thread_hw_breakpoint(me);
 }
 
 void flush_thread(void)
@@ -257,13 +266,9 @@ void flush_thread(void)
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
@@ -338,13 +343,21 @@ int copy_thread(int nr, unsigned long cl
 
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
@@ -375,6 +388,9 @@ out:
 		kfree(p->thread.io_bitmap_ptr);
 		p->thread.io_bitmap_max = 0;
 	}
+	if (err)
+		flush_thread_hw_breakpoint(p);
+
 	return err;
 }
 
@@ -484,16 +500,6 @@ static inline void __switch_to_xtra(stru
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
@@ -524,6 +530,13 @@ static inline void __switch_to_xtra(stru
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
