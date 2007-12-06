Return-Path: <linux-kernel-owner+w=401wt.eu-S1755743AbXLFDAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbXLFDAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 22:00:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbXLFDAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 22:00:05 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:35376 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbXLFDAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 22:00:03 -0500
Message-Id: <20071206025947.168583114@polymtl.ca>
References: <20071206025650.451824066@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:56:56 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch-early-RFC 06/10] LTTng - instrumentation SH
Content-Disposition: inline; filename=lttng-instrumentation-sh.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:59:49 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
- fix do_fork instrumentation

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/sh/kernel/entry-common.S |   10 ++++++----
 arch/sh/kernel/process.c      |    5 ++++-
 arch/sh/kernel/ptrace.c       |    8 +++++++-
 arch/sh/kernel/sys_sh.c       |    2 ++
 arch/sh/kernel/traps.c        |   10 ++++++++--
 arch/sh/mm/fault.c            |   12 ++++++++++++
 6 files changed, 39 insertions(+), 8 deletions(-)

Index: linux-2.6-lttng/arch/sh/kernel/entry-common.S
===================================================================
--- linux-2.6-lttng.orig/arch/sh/kernel/entry-common.S	2007-11-26 13:36:40.000000000 -0500
+++ linux-2.6-lttng/arch/sh/kernel/entry-common.S	2007-11-26 13:37:12.000000000 -0500
@@ -224,7 +224,7 @@ work_resched:
 syscall_exit_work:
 	! r0: current_thread_info->flags
 	! r8: current_thread_info
-	tst	#_TIF_SYSCALL_TRACE | _TIF_SINGLESTEP, r0
+	tst	#_TIF_SYSCALL_TRACE | _TIF_SINGLESTEP | _TIF_KERNEL_TRACE, r0
 	bt/s	work_pending
 	 tst	#_TIF_NEED_RESCHED, r0
 #ifdef CONFIG_TRACE_IRQFLAGS
@@ -233,7 +233,8 @@ syscall_exit_work:
 	 nop
 #endif
 	sti
-	! XXX setup arguments...
+	mov	r15,r4			! pass stacked regs as arg
+	mov	#0, r5			! trace entry [0]
 	mov.l	4f, r0			! do_syscall_trace
 	jsr	@r0
 	 nop
@@ -243,7 +244,8 @@ syscall_exit_work:
 	.align	2
 syscall_trace_entry:
 	!                     	Yes it is traced.
-	! XXX setup arguments...
+	mov	r15,r4		! pass stacked regs as arg
+	mov	#1, r5		! trace entry [1]
 	mov.l	4f, r11		! Call do_syscall_trace which notifies
 	jsr	@r11	    	! superior (will chomp R[0-7])
 	 nop
@@ -366,7 +368,7 @@ ENTRY(system_call)
 	!
 	get_current_thread_info r8, r10
 	mov.l	@(TI_FLAGS,r8), r8
-	mov	#_TIF_SYSCALL_TRACE, r10
+	mov	#(_TIF_SYSCALL_TRACE | _TIF_KERNEL_TRACE), r10
 	tst	r10, r8
 	bf	syscall_trace_entry
 	!
Index: linux-2.6-lttng/arch/sh/kernel/process.c
===================================================================
--- linux-2.6-lttng.orig/arch/sh/kernel/process.c	2007-11-26 13:36:40.000000000 -0500
+++ linux-2.6-lttng/arch/sh/kernel/process.c	2007-11-28 08:29:11.000000000 -0500
@@ -172,6 +172,7 @@ __asm__(".align 5\n"
 /* Don't use this in BL=1(cli).  Or else, CPU resets! */
 int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags)
 {
+	unsigned long pid;
 	struct pt_regs regs;
 
 	memset(&regs, 0, sizeof(regs));
@@ -182,8 +183,10 @@ int kernel_thread(int (*fn)(void *), voi
 	regs.sr = (1 << 30);
 
 	/* Ok, create the new process.. */
-	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0,
+	pid =  do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0,
 		       &regs, 0, NULL, NULL);
+	trace_mark(kernel_arch_kthread_create, "pid %ld fn %p", pid, fn);
+	return pid;
 }
 
 /*
Index: linux-2.6-lttng/arch/sh/kernel/sys_sh.c
===================================================================
--- linux-2.6-lttng.orig/arch/sh/kernel/sys_sh.c	2007-11-26 13:36:40.000000000 -0500
+++ linux-2.6-lttng/arch/sh/kernel/sys_sh.c	2007-11-26 13:37:12.000000000 -0500
@@ -192,6 +192,8 @@ asmlinkage int sys_ipc(uint call, int fi
 	version = call >> 16; /* hack for backward compatibility */
 	call &= 0xffff;
 
+	trace_mark(kernel_arch_ipc_call, "call %u first %d", call, first);
+
 	if (call <= SEMCTL)
 		switch (call) {
 		case SEMOP:
Index: linux-2.6-lttng/arch/sh/kernel/traps.c
===================================================================
--- linux-2.6-lttng.orig/arch/sh/kernel/traps.c	2007-11-26 13:36:40.000000000 -0500
+++ linux-2.6-lttng/arch/sh/kernel/traps.c	2007-11-26 13:37:12.000000000 -0500
@@ -548,6 +548,9 @@ asmlinkage void do_address_error(struct 
 	lookup_exception_vector(error_code);
 #endif
 
+	trace_mark(kernel_arch_trap_entry, "trap_id %lu ip #p%ld",
+		(error_code >> 5), instruction_pointer(regs));
+
 	oldfs = get_fs();
 
 	if (user_mode(regs)) {
@@ -574,8 +577,10 @@ asmlinkage void do_address_error(struct 
 		tmp = handle_unaligned_access(instruction, regs);
 		set_fs(oldfs);
 
-		if (tmp==0)
-			return; /* sorted */
+		if (tmp==0) {
+			trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
+ 			return; /* sorted */
+		}
 #endif
 
 uspace_segv:
@@ -611,6 +616,7 @@ uspace_segv:
 		force_sig(SIGSEGV, current);
 #endif
 	}
+	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 }
 
 #ifdef CONFIG_SH_DSP
Index: linux-2.6-lttng/arch/sh/mm/fault.c
===================================================================
--- linux-2.6-lttng.orig/arch/sh/mm/fault.c	2007-11-26 13:36:40.000000000 -0500
+++ linux-2.6-lttng/arch/sh/mm/fault.c	2007-11-26 13:37:12.000000000 -0500
@@ -87,6 +87,14 @@ asmlinkage void __kprobes do_page_fault(
 		return;
 	}
 
+	trace_mark(kernel_arch_trap_entry, "trap_id %ld ip #p%ld",
+		({
+			unsigned long trapnr;
+			asm volatile("stc	r2_bank,%0": "=r" (trapnr));
+			trapnr;
+		}) >> 5,
+		instruction_pointer(regs));
+
 	/*
 	 * If we're in an interrupt or have no user
 	 * context, we must not take the fault..
@@ -139,6 +147,7 @@ survive:
 		tsk->min_flt++;
 
 	up_read(&mm->mmap_sem);
+	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 	return;
 
 /*
@@ -155,6 +164,7 @@ bad_area_nosemaphore:
 		info.si_code = si_code;
 		info.si_addr = (void *) address;
 		force_sig_info(SIGSEGV, &info, tsk);
+		trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 		return;
 	}
 
@@ -233,6 +243,8 @@ do_sigbus:
 	/* Kernel mode? Handle exceptions or die */
 	if (!user_mode(regs))
 		goto no_context;
+
+	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 }
 
 #ifdef CONFIG_SH_STORE_QUEUES
Index: linux-2.6-lttng/arch/sh/kernel/ptrace.c
===================================================================
--- linux-2.6-lttng.orig/arch/sh/kernel/ptrace.c	2007-11-26 13:36:40.000000000 -0500
+++ linux-2.6-lttng/arch/sh/kernel/ptrace.c	2007-11-26 13:37:12.000000000 -0500
@@ -248,10 +248,16 @@ long arch_ptrace(struct task_struct *chi
 	return ret;
 }
 
-asmlinkage void do_syscall_trace(void)
+asmlinkage void do_syscall_trace(struct pt_regs *regs, int entryexit)
 {
 	struct task_struct *tsk = current;
 
+	if (entryexit)
+		trace_mark(kernel_arch_syscall_entry, "syscall_id %d ip #p%ld",
+			regs->regs[3], instruction_pointer(regs));
+	else
+		trace_mark(kernel_arch_syscall_exit, MARK_NOARGS);
+
 	if (!test_thread_flag(TIF_SYSCALL_TRACE) &&
 	    !test_thread_flag(TIF_SINGLESTEP))
 		return;

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
