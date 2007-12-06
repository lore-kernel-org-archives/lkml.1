Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbXLFDCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbXLFDCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 22:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755580AbXLFDAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 22:00:19 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:35408 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755200AbXLFDAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 22:00:12 -0500
Message-Id: <20071206025945.366923886@polymtl.ca>
References: <20071206025650.451824066@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:56:51 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch-early-RFC 01/10] LTTng - ARM instrumentation
Content-Disposition: inline; filename=lttng-instrumentation-arm.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:59:47 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/arm/kernel/entry-common.S |    8 ++++----
 arch/arm/kernel/process.c      |    6 +++++-
 arch/arm/kernel/ptrace.c       |    6 ++++++
 arch/arm/kernel/sys_arm.c      |    2 ++
 arch/arm/kernel/traps.c        |    7 +++++++
 5 files changed, 24 insertions(+), 5 deletions(-)

Index: linux-2.6-lttng/arch/arm/kernel/entry-common.S
===================================================================
--- linux-2.6-lttng.orig/arch/arm/kernel/entry-common.S	2007-10-11 11:44:13.000000000 -0400
+++ linux-2.6-lttng/arch/arm/kernel/entry-common.S	2007-10-11 11:44:57.000000000 -0400
@@ -85,8 +85,8 @@ ENTRY(ret_from_fork)
 	get_thread_info tsk
 	ldr	r1, [tsk, #TI_FLAGS]		@ check for syscall tracing
 	mov	why, #1
-	tst	r1, #_TIF_SYSCALL_TRACE		@ are we tracing syscalls?
-	beq	ret_slow_syscall
+	tst	r1, #_TIF_SYSCALL_TRACE | _TIF_KERNEL_TRACE
+	beq	ret_slow_syscall		@ are we tracing syscalls?
 	mov	r1, sp
 	mov	r0, #1				@ trace exit [IP = 1]
 	bl	syscall_trace
@@ -205,8 +205,8 @@ ENTRY(vector_swi)
 #endif
 
 	stmdb	sp!, {r4, r5}			@ push fifth and sixth args
-	tst	ip, #_TIF_SYSCALL_TRACE		@ are we tracing syscalls?
-	bne	__sys_trace
+	tst	ip, #_TIF_SYSCALL_TRACE | _TIF_KERNEL_TRACE
+	bne	__sys_trace			@ are we tracing syscalls?
 
 	cmp	scno, #NR_syscalls		@ check upper syscall limit
 	adr	lr, ret_fast_syscall		@ return address
Index: linux-2.6-lttng/arch/arm/kernel/process.c
===================================================================
--- linux-2.6-lttng.orig/arch/arm/kernel/process.c	2007-10-11 11:44:13.000000000 -0400
+++ linux-2.6-lttng/arch/arm/kernel/process.c	2007-10-11 14:46:50.000000000 -0400
@@ -418,6 +418,7 @@ asm(	".section .text\n"
 pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 {
 	struct pt_regs regs;
+	long pid;
 
 	memset(&regs, 0, sizeof(regs));
 
@@ -427,7 +428,10 @@ pid_t kernel_thread(int (*fn)(void *), v
 	regs.ARM_pc = (unsigned long)kernel_thread_helper;
 	regs.ARM_cpsr = SVC_MODE;
 
-	return do_fork(flags|CLONE_VM|CLONE_UNTRACED, 0, &regs, 0, NULL, NULL);
+	pid = do_fork(flags|CLONE_VM|CLONE_UNTRACED, 0, &regs, 0, NULL, NULL);
+
+	trace_mark(kernel_arch_kthread_create, "pid %ld fn %p", pid, fn);
+	return pid;
 }
 EXPORT_SYMBOL(kernel_thread);
 
Index: linux-2.6-lttng/arch/arm/kernel/ptrace.c
===================================================================
--- linux-2.6-lttng.orig/arch/arm/kernel/ptrace.c	2007-10-11 11:44:13.000000000 -0400
+++ linux-2.6-lttng/arch/arm/kernel/ptrace.c	2007-10-11 14:48:21.000000000 -0400
@@ -789,6 +789,12 @@ asmlinkage int syscall_trace(int why, st
 {
 	unsigned long ip;
 
+	if (!why)
+		trace_mark(kernel_arch_syscall_entry, "syscall_id %d ip #p%ld",
+			scno, instruction_pointer(regs));
+	else
+		trace_mark(kernel_arch_syscall_exit, MARK_NOARGS);
+
 	if (!test_thread_flag(TIF_SYSCALL_TRACE))
 		return scno;
 	if (!(current->ptrace & PT_PTRACED))
Index: linux-2.6-lttng/arch/arm/kernel/sys_arm.c
===================================================================
--- linux-2.6-lttng.orig/arch/arm/kernel/sys_arm.c	2007-10-11 11:44:13.000000000 -0400
+++ linux-2.6-lttng/arch/arm/kernel/sys_arm.c	2007-10-11 14:47:23.000000000 -0400
@@ -161,6 +161,8 @@ asmlinkage int sys_ipc(uint call, int fi
 	version = call >> 16; /* hack for backward compatibility */
 	call &= 0xffff;
 
+	trace_mark(kernel_arch_ipc_call, "call %u first %d", call, first);
+
 	switch (call) {
 	case SEMOP:
 		return sys_semtimedop (first, (struct sembuf __user *)ptr, second, NULL);
Index: linux-2.6-lttng/arch/arm/kernel/traps.c
===================================================================
--- linux-2.6-lttng.orig/arch/arm/kernel/traps.c	2007-10-11 11:44:13.000000000 -0400
+++ linux-2.6-lttng/arch/arm/kernel/traps.c	2007-10-11 14:48:11.000000000 -0400
@@ -269,7 +269,14 @@ void arm_notify_die(const char *str, str
 		current->thread.error_code = err;
 		current->thread.trap_no = trap;
 
+		trace_mark(kernel_arch_trap_entry, "trap_id %ld ip #p%ld",
+			current->thread.trap_no,
+			instruction_pointer(regs));
+
 		force_sig_info(info->si_signo, info, current);
+
+		trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
+
 	} else {
 		die(str, regs, err);
 	}

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
