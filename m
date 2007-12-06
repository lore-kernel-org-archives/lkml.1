Return-Path: <linux-kernel-owner+w=401wt.eu-S1757114AbXLFDBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114AbXLFDBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 22:01:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755244AbXLFDAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 22:00:13 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:35385 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbXLFDAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 22:00:06 -0500
Message-Id: <20071206025947.529371200@polymtl.ca>
References: <20071206025650.451824066@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:56:57 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch-early-RFC 07/10] LTTng instrumentation SH64
Content-Disposition: inline; filename=lttng-instrumentation-sh64.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:59:50 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

traps are missing.
syscall trace missing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/sh64/kernel/entry.S    |    2 +-
 arch/sh64/kernel/process.c  |    5 ++++-
 arch/sh64/kernel/sys_sh64.c |    2 ++
 3 files changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/arch/sh64/kernel/entry.S
===================================================================
--- linux-2.6-lttng.orig/arch/sh64/kernel/entry.S	2007-11-13 09:25:23.000000000 -0500
+++ linux-2.6-lttng/arch/sh64/kernel/entry.S	2007-11-13 09:50:15.000000000 -0500
@@ -1282,7 +1282,7 @@ syscall_allowed:
 
 	getcon	KCR0, r2
 	ld.l	r2, TI_FLAGS, r4
-	movi	(1 << TIF_SYSCALL_TRACE), r6
+	movi	(_TIF_SYSCALL_TRACE|_TIF_KERNEL_TRACE), r6
 	and	r6, r4, r6
 	beq/l	r6, ZERO, tr0
 
Index: linux-2.6-lttng/arch/sh64/kernel/sys_sh64.c
===================================================================
--- linux-2.6-lttng.orig/arch/sh64/kernel/sys_sh64.c	2007-11-13 09:25:23.000000000 -0500
+++ linux-2.6-lttng/arch/sh64/kernel/sys_sh64.c	2007-11-13 09:50:15.000000000 -0500
@@ -187,6 +187,8 @@ asmlinkage int sys_ipc(uint call, int fi
 	version = call >> 16; /* hack for backward compatibility */
 	call &= 0xffff;
 
+	trace_mark(kernel_arch_ipc_call, "call %u first %d", call, first);
+
 	if (call <= SEMCTL)
 		switch (call) {
 		case SEMOP:
Index: linux-2.6-lttng/arch/sh64/kernel/process.c
===================================================================
--- linux-2.6-lttng.orig/arch/sh64/kernel/process.c	2007-11-13 09:25:23.000000000 -0500
+++ linux-2.6-lttng/arch/sh64/kernel/process.c	2007-11-13 09:50:15.000000000 -0500
@@ -393,6 +393,7 @@ ATTRIB_NORET void kernel_thread_helper(v
  */
 int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags)
 {
+	unsigned long pid;
 	struct pt_regs regs;
 
 	memset(&regs, 0, sizeof(regs));
@@ -402,8 +403,10 @@ int kernel_thread(int (*fn)(void *), voi
 	regs.pc = (unsigned long)kernel_thread_helper;
 	regs.sr = (1 << 30);
 
-	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0,
+	pid = do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0,
 		       &regs, 0, NULL, NULL);
+	trace_mark(kernel_arch_kthread_create, "pid %ld fn %p", pid, fn);
+	return pid;
 }
 
 /*

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
