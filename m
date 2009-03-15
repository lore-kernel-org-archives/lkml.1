Return-Path: <linux-kernel-owner+w=401wt.eu-S1758384AbZCOU3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384AbZCOU3b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 16:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758933AbZCOU0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 16:26:00 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:58966 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758714AbZCOUZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 16:25:57 -0400
Message-Id: <20090315200506.913418618@polymtl.ca>
References: <20090315200144.017321577@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 15 Mar 2009 16:01:58 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 14/20] LTTng Kernel Trace Thread Flag s390
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-s390.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sun, 15 Mar 2009 20:24:31 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/s390/include/asm/thread_info.h |    2 ++
 arch/s390/kernel/entry.S            |   10 ++++++++--
 arch/s390/kernel/entry64.S          |   10 ++++++++--
 3 files changed, 18 insertions(+), 4 deletions(-)

Index: linux-2.6-lttng/arch/s390/include/asm/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/arch/s390/include/asm/thread_info.h	2009-03-15 15:57:04.000000000 -0400
+++ linux-2.6-lttng/arch/s390/include/asm/thread_info.h	2009-03-15 15:57:17.000000000 -0400
@@ -90,6 +90,7 @@ static inline struct thread_info *curren
 #define TIF_SYSCALL_AUDIT	5	/* syscall auditing active */
 #define TIF_SINGLE_STEP		6	/* deliver sigtrap on return to user */
 #define TIF_MCCK_PENDING	7	/* machine check handling is pending */
+#define TIF_KERNEL_TRACE	8	/* kernel trace active */
 #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
 #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling 
 					   TIF_NEED_RESCHED */
@@ -107,6 +108,7 @@ static inline struct thread_info *curren
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_SINGLE_STEP	(1<<TIF_SINGLE_STEP)
 #define _TIF_MCCK_PENDING	(1<<TIF_MCCK_PENDING)
+#define _TIF_KERNEL_TRACE	(1<<TIF_KERNEL_TRACE)
 #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_31BIT		(1<<TIF_31BIT)
Index: linux-2.6-lttng/arch/s390/kernel/entry.S
===================================================================
--- linux-2.6-lttng.orig/arch/s390/kernel/entry.S	2009-03-15 15:51:10.000000000 -0400
+++ linux-2.6-lttng/arch/s390/kernel/entry.S	2009-03-15 15:57:17.000000000 -0400
@@ -265,7 +265,9 @@ sysc_do_restart:
 	sth	%r7,SP_SVCNR(%r15)
 	sll	%r7,2		  # svc number *4
 	l	%r8,BASED(.Lsysc_table)
-	tm	__TI_flags+3(%r9),(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT)
+	l	%r8,__TI_flags+3(%r9)
+	n	%r8,BASED(.Lc_tif_syscall_trace_or_audit_or_kernel_trace)
+	ltr	%r8,%r8
 	l	%r8,0(%r7,%r8)	  # get system call addr.
 	bnz	BASED(sysc_tracesys)
 	basr	%r14,%r8	  # call sys_xxxx
@@ -405,7 +407,9 @@ sysc_tracego:
 	basr	%r14,%r8		# call sys_xxx
 	st	%r2,SP_R2(%r15)		# store return value
 sysc_tracenogo:
-	tm	__TI_flags+3(%r9),(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT)
+	l	%r8,__TI_flags+3(%r9)
+	n	%r8,BASED(.Lc_tif_syscall_trace_or_audit_or_kernel_trace)
+	ltr	%r8,%r8
 	bz	BASED(sysc_return)
 	l	%r1,BASED(.Ltrace_exit)
 	la	%r2,SP_PTREGS(%r15)	# load pt_regs
@@ -1049,6 +1053,8 @@ cleanup_io_leave_insn:
 .L0x030:	.short	0x030
 .L0x038:	.short	0x038
 .Lc_1:		.long	1
+.Lc_tif_syscall_trace_or_audit_or_kernel_trace:
+		.long	_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_KERNEL_TRACE
 
 /*
  * Symbol constants
Index: linux-2.6-lttng/arch/s390/kernel/entry64.S
===================================================================
--- linux-2.6-lttng.orig/arch/s390/kernel/entry64.S	2009-03-15 15:51:10.000000000 -0400
+++ linux-2.6-lttng/arch/s390/kernel/entry64.S	2009-03-15 15:57:17.000000000 -0400
@@ -260,7 +260,9 @@ sysc_do_restart:
 	larl	%r10,sys_call_table_emu  # use 31 bit emulation system calls
 sysc_noemu:
 #endif
-	tm	__TI_flags+7(%r9),(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT)
+	l	%r8,__TI_flags+7(%r9)
+	n	%r8,BASED(.Lc_tif_syscall_trace_or_audit_or_kernel_trace)
+	ltr	%r8,%r8
 	lgf	%r8,0(%r7,%r10) # load address of system call routine
 	jnz	sysc_tracesys
 	basr	%r14,%r8	# call sys_xxxx
@@ -391,7 +393,9 @@ sysc_tracego:
 	basr	%r14,%r8		# call sys_xxx
 	stg	%r2,SP_R2(%r15)		# store return value
 sysc_tracenogo:
-	tm	__TI_flags+7(%r9),(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT)
+	l	%r8,__TI_flags+7(%r9)
+	n	%r8,BASED(.Lc_tif_syscall_trace_or_audit_or_kernel_trace)
+	ltr	%r8,%r8
 	jz	sysc_return
 	la	%r2,SP_PTREGS(%r15)	# load pt_regs
 	larl	%r14,sysc_return	# return point is sysc_return
@@ -1033,6 +1037,8 @@ cleanup_io_leave_insn:
 		.align	4
 .Lconst:
 .Lnr_syscalls:	.long	NR_syscalls
+.Lc_tif_syscall_trace_or_audit_or_kernel_trace:
+		.long	_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_KERNEL_TRACE
 .L0x0130:	.short	0x130
 .L0x0140:	.short	0x140
 .L0x0150:	.short	0x150

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
