Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbXLFDCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbXLFDCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 22:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755529AbXLFDAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 22:00:18 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:35407 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053AbXLFDAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 22:00:12 -0500
Message-Id: <20071206025948.008490249@polymtl.ca>
References: <20071206025650.451824066@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:56:58 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch-early-RFC 08/10] LTTng Sparc instrumentation
Content-Disposition: inline; filename=lttng-instrumentation-sparc.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:59:50 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

syscall trace missing
traps missing

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/sparc/kernel/entry.S     |   10 +++++-----
 arch/sparc/kernel/process.c   |    1 +
 arch/sparc/kernel/sys_sparc.c |    2 ++
 3 files changed, 8 insertions(+), 5 deletions(-)

Index: linux-2.6-lttng/arch/sparc/kernel/entry.S
===================================================================
--- linux-2.6-lttng.orig/arch/sparc/kernel/entry.S	2007-11-13 09:25:23.000000000 -0500
+++ linux-2.6-lttng/arch/sparc/kernel/entry.S	2007-11-13 09:50:18.000000000 -0500
@@ -1231,7 +1231,7 @@ sys_ptrace:
 	 add	%sp, STACKFRAME_SZ, %o0
 
 	ld	[%curptr + TI_FLAGS], %l5
-	andcc	%l5, _TIF_SYSCALL_TRACE, %g0
+	andcc	%l5, (_TIF_SYSCALL_TRACE|_TIF_KERNEL_TRACE), %g0
 	be	1f
 	 nop
 
@@ -1280,7 +1280,7 @@ sys_sigreturn:
 	 add	%sp, STACKFRAME_SZ, %o0
 
 	ld	[%curptr + TI_FLAGS], %l5
-	andcc	%l5, _TIF_SYSCALL_TRACE, %g0
+	andcc	%l5, (_TIF_SYSCALL_TRACE|_TIF_KERNEL_TRACE), %g0
 	be	1f
 	 nop
 
@@ -1300,7 +1300,7 @@ sys_rt_sigreturn:
 	 add	%sp, STACKFRAME_SZ, %o0
 
 	ld	[%curptr + TI_FLAGS], %l5
-	andcc	%l5, _TIF_SYSCALL_TRACE, %g0
+	andcc	%l5, (_TIF_SYSCALL_TRACE|_TIF_KERNEL_TRACE), %g0
 	be	1f
 	 nop
 
@@ -1436,7 +1436,7 @@ syscall_is_too_hard:
 
 	ld	[%curptr + TI_FLAGS], %l5
 	mov	%i3, %o3
-	andcc	%l5, _TIF_SYSCALL_TRACE, %g0
+	andcc	%l5, (_TIF_SYSCALL_TRACE|_TIF_KERNEL_TRACE), %g0
 	mov	%i4, %o4
 	bne	linux_syscall_trace
 	 mov	%i0, %l5
@@ -1453,7 +1453,7 @@ ret_sys_call:
 	ld	[%sp + STACKFRAME_SZ + PT_PSR], %g3
 	set	PSR_C, %g2
 	bgeu	1f
-	 andcc	%l6, _TIF_SYSCALL_TRACE, %g0
+	 andcc	%l6, (_TIF_SYSCALL_TRACE|_TIF_KERNEL_TRACE), %g0
 
 	/* System call success, clear Carry condition code. */
 	andn	%g3, %g2, %g3
Index: linux-2.6-lttng/arch/sparc/kernel/sys_sparc.c
===================================================================
--- linux-2.6-lttng.orig/arch/sparc/kernel/sys_sparc.c	2007-11-13 09:25:23.000000000 -0500
+++ linux-2.6-lttng/arch/sparc/kernel/sys_sparc.c	2007-11-13 09:50:18.000000000 -0500
@@ -120,6 +120,8 @@ asmlinkage int sys_ipc (uint call, int f
 	version = call >> 16; /* hack for backward compatibility */
 	call &= 0xffff;
 
+	trace_mark(kernel_arch_ipc_call, "call %u first %d", call, first);
+
 	if (call <= SEMCTL)
 		switch (call) {
 		case SEMOP:
Index: linux-2.6-lttng/arch/sparc/kernel/process.c
===================================================================
--- linux-2.6-lttng.orig/arch/sparc/kernel/process.c	2007-11-13 09:25:23.000000000 -0500
+++ linux-2.6-lttng/arch/sparc/kernel/process.c	2007-11-13 09:50:18.000000000 -0500
@@ -709,6 +709,7 @@ pid_t kernel_thread(int (*fn)(void *), v
 			     "i" (__NR_clone), "r" (flags | CLONE_VM | CLONE_UNTRACED),
 			     "i" (__NR_exit),  "r" (fn), "r" (arg) :
 			     "g1", "g2", "g3", "o0", "o1", "memory", "cc");
+	trace_mark(kernel_arch_kthread_create, "pid %ld fn %p", retval, fn);
 	return retval;
 }
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
