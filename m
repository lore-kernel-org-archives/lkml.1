Return-Path: <linux-kernel-owner+w=401wt.eu-S1757597AbXLFDCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbXLFDCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 22:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755426AbXLFDAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 22:00:16 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:35406 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001AbXLFDAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 22:00:11 -0500
Message-Id: <20071206025948.909661374@polymtl.ca>
References: <20071206025650.451824066@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:57:00 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch-early-RFC 10/10] LTTng - s390 instrumentation
Content-Disposition: inline; filename=lttng-instrumentation-s390.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:59:51 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog :
- added syscall entry/exit instrumentation.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/s390/kernel/entry.S    |   10 ++++++++--
 arch/s390/kernel/entry64.S  |   10 ++++++++--
 arch/s390/kernel/ptrace.c   |    6 ++++++
 arch/s390/kernel/sys_s390.c |    2 ++
 arch/s390/kernel/traps.c    |   17 +++++++++++++++++
 arch/s390/mm/fault.c        |    6 ++++++
 6 files changed, 47 insertions(+), 4 deletions(-)

Index: linux-2.6-lttng/arch/s390/kernel/traps.c
===================================================================
--- linux-2.6-lttng.orig/arch/s390/kernel/traps.c	2007-11-28 09:27:27.000000000 -0500
+++ linux-2.6-lttng/arch/s390/kernel/traps.c	2007-11-28 09:33:55.000000000 -0500
@@ -5,6 +5,7 @@
  *    Copyright (C) 1999,2000 IBM Deutschland Entwicklung GmbH, IBM Corporation
  *    Author(s): Martin Schwidefsky (schwidefsky@de.ibm.com),
  *               Denis Joseph Barrow (djbarrow@de.ibm.com,barrow_dj@yahoo.com),
+ *  Portions added by T. Halloran: (C) Copyright 2002 IBM Poughkeepsie, IBM Corporation
  *
  *  Derived from "arch/i386/kernel/traps.c"
  *    Copyright (C) 1991, 1992 Linus Torvalds
@@ -307,6 +308,9 @@ static void __kprobes inline do_trap(lon
 				interruption_code, signr) == NOTIFY_STOP)
 		return;
 
+	trace_mark(kernel_arch_trap_entry, "trap_id %ld ip #p%lu",
+		interruption_code & 0xffff, instruction_pointer(regs));
+
         if (regs->psw.mask & PSW_MASK_PSTATE) {
                 struct task_struct *tsk = current;
 
@@ -327,6 +331,7 @@ static void __kprobes inline do_trap(lon
 			die(str, regs, interruption_code);
 		}
         }
+	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 }
 
 static inline void __user *get_check_address(struct pt_regs *regs)
@@ -437,6 +442,9 @@ static void illegal_op(struct pt_regs * 
 	if (regs->psw.mask & PSW_MASK_PSTATE)
 		local_irq_enable();
 
+	trace_mark(kernel_arch_trap_entry, "trap_id %ld ip #p%lu",
+		interruption_code & 0xffff, instruction_pointer(regs));
+
 	if (regs->psw.mask & PSW_MASK_PSTATE) {
 		if (get_user(*((__u16 *) opcode), (__u16 __user *) location))
 			return;
@@ -501,6 +509,7 @@ static void illegal_op(struct pt_regs * 
 		do_trap(interruption_code, signal,
 			"illegal operation", regs, &info);
 	}
+	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 }
 
 
@@ -521,6 +530,9 @@ specification_exception(struct pt_regs *
         if (regs->psw.mask & PSW_MASK_PSTATE)
 		local_irq_enable();
 
+	trace_mark(kernel_arch_trap_entry, "trap_id %ld ip #p%lu",
+		interruption_code & 0xffff, instruction_pointer(regs));
+
         if (regs->psw.mask & PSW_MASK_PSTATE) {
 		get_user(*((__u16 *) opcode), location);
 		switch (opcode[0]) {
@@ -565,6 +577,7 @@ specification_exception(struct pt_regs *
 		do_trap(interruption_code, signal, 
 			"specification exception", regs, &info);
 	}
+	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 }
 #else
 DO_ERROR_INFO(SIGILL, "specification exception", specification_exception,
@@ -585,6 +598,9 @@ static void data_exception(struct pt_reg
 	if (regs->psw.mask & PSW_MASK_PSTATE)
 		local_irq_enable();
 
+	trace_mark(kernel_arch_trap_entry, "trap_id %ld ip #p%lu",
+		interruption_code & 0xffff, instruction_pointer(regs));
+
 	if (MACHINE_HAS_IEEE)
 		asm volatile("stfpc %0" : "=m" (current->thread.fp_regs.fpc));
 
@@ -659,6 +675,7 @@ static void data_exception(struct pt_reg
 		do_trap(interruption_code, signal, 
 			"data exception", regs, &info);
 	}
+	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 }
 
 static void space_switch_exception(struct pt_regs * regs, long int_code)
Index: linux-2.6-lttng/arch/s390/kernel/sys_s390.c
===================================================================
--- linux-2.6-lttng.orig/arch/s390/kernel/sys_s390.c	2007-11-28 09:27:27.000000000 -0500
+++ linux-2.6-lttng/arch/s390/kernel/sys_s390.c	2007-11-28 09:33:55.000000000 -0500
@@ -150,6 +150,8 @@ asmlinkage long sys_ipc(uint call, int f
         struct ipc_kludge tmp;
 	int ret;
 
+        trace_mark(ipc_call, "call %u first %d", call, first);
+
         switch (call) {
         case SEMOP:
 		return sys_semtimedop(first, (struct sembuf __user *)ptr,
Index: linux-2.6-lttng/arch/s390/mm/fault.c
===================================================================
--- linux-2.6-lttng.orig/arch/s390/mm/fault.c	2007-11-28 09:27:27.000000000 -0500
+++ linux-2.6-lttng/arch/s390/mm/fault.c	2007-11-28 09:33:55.000000000 -0500
@@ -5,6 +5,7 @@
  *    Copyright (C) 1999 IBM Deutschland Entwicklung GmbH, IBM Corporation
  *    Author(s): Hartmut Penner (hp@de.ibm.com)
  *               Ulrich Weigand (uweigand@de.ibm.com)
+ *  Portions added by T. Halloran: (C) Copyright 2002 IBM Poughkeepsie, IBM Corporation
  *
  *  Derived from "arch/i386/mm/fault.c"
  *    Copyright (C) 1995  Linus Torvalds
@@ -169,6 +170,7 @@ static void do_no_context(struct pt_regs
 	fixup = search_exception_tables(regs->psw.addr & __FIXUP_MASK);
 	if (fixup) {
 		regs->psw.addr = fixup->fixup | PSW_ADDR_AMODE;
+		trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 		return;
 	}
 
@@ -334,6 +336,9 @@ do_exception(struct pt_regs *regs, unsig
 	 */
 	local_irq_enable();
 
+	trace_mark(kernel_arch_trap_entry, "trap_id %ld ip #p%lu",
+		error_code & 0xffff, instruction_pointer(regs));
+
 	down_read(&mm->mmap_sem);
 
 	si_code = SEGV_MAPERR;
@@ -415,6 +420,7 @@ bad_area:
 		tsk->thread.prot_addr = address;
 		tsk->thread.trap_no = error_code;
 		do_sigsegv(regs, error_code, si_code, address);
+		trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 		return;
 	}
 
Index: linux-2.6-lttng/arch/s390/kernel/entry.S
===================================================================
--- linux-2.6-lttng.orig/arch/s390/kernel/entry.S	2007-11-28 09:27:27.000000000 -0500
+++ linux-2.6-lttng/arch/s390/kernel/entry.S	2007-11-28 09:33:55.000000000 -0500
@@ -270,8 +270,10 @@ sysc_do_svc:
 sysc_nr_ok:
 	mvc	SP_ARGS(4,%r15),SP_R7(%r15)
 sysc_do_restart:
+	l	%r8,__TI_flags+3(%r9)
+	n	%r8,BASED(.Lc_tif_syscall_trace_or_audit_or_kernel_trace)
+	ltr	%r8,%r8
 	l	%r8,BASED(.Lsysc_table)
-	tm	__TI_flags+3(%r9),(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT)
 	l	%r8,0(%r7,%r8)	  # get system call addr.
 	bnz	BASED(sysc_tracesys)
 	basr	%r14,%r8	  # call sys_xxxx
@@ -398,7 +400,9 @@ sysc_tracego:
 	basr	%r14,%r8		# call sys_xxx
 	st	%r2,SP_R2(%r15)		# store return value
 sysc_tracenogo:
-	tm	__TI_flags+3(%r9),(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT)
+	l	%r8,__TI_flags+3(%r9)
+	n	%r8,BASED(.Lc_tif_syscall_trace_or_audit_or_kernel_trace)
+	ltr	%r8,%r8
 	bz	BASED(sysc_return)
 	l	%r1,BASED(.Ltrace)
 	la	%r2,SP_PTREGS(%r15)	# load pt_regs
@@ -1063,6 +1067,8 @@ cleanup_io_leave_insn:
 .L0x030:	.short	0x030
 .L0x038:	.short	0x038
 .Lc_1:		.long	1
+.Lc_tif_syscall_trace_or_audit_or_kernel_trace:
+		.long	_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_KERNEL_TRACE
 
 /*
  * Symbol constants
Index: linux-2.6-lttng/arch/s390/kernel/entry64.S
===================================================================
--- linux-2.6-lttng.orig/arch/s390/kernel/entry64.S	2007-11-28 09:27:27.000000000 -0500
+++ linux-2.6-lttng/arch/s390/kernel/entry64.S	2007-11-28 09:33:55.000000000 -0500
@@ -263,7 +263,9 @@ sysc_do_restart:
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
@@ -387,7 +389,9 @@ sysc_tracego:
 	basr	%r14,%r8		# call sys_xxx
 	stg	%r2,SP_R2(%r15)		# store return value
 sysc_tracenogo:
-	tm	__TI_flags+7(%r9),(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT)
+	l	%r8,__TI_flags+7(%r9)
+	n	%r8,BASED(.Lc_tif_syscall_trace_or_audit_or_kernel_trace)
+	ltr	%r8,%r8
 	jz	sysc_return
 	la	%r2,SP_PTREGS(%r15)	# load pt_regs
 	la	%r3,1
@@ -1023,6 +1027,8 @@ cleanup_io_leave_insn:
 		.align	4
 .Lconst:
 .Lnr_syscalls:	.long	NR_syscalls
+.Lc_tif_syscall_trace_or_audit_or_kernel_trace:
+		.long	_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_KERNEL_TRACE
 .L0x0130:	.short	0x130
 .L0x0140:	.short	0x140
 .L0x0150:	.short	0x150
Index: linux-2.6-lttng/arch/s390/kernel/ptrace.c
===================================================================
--- linux-2.6-lttng.orig/arch/s390/kernel/ptrace.c	2007-11-28 09:27:27.000000000 -0500
+++ linux-2.6-lttng/arch/s390/kernel/ptrace.c	2007-11-28 09:33:55.000000000 -0500
@@ -723,6 +723,12 @@ out:
 asmlinkage void
 syscall_trace(struct pt_regs *regs, int entryexit)
 {
+	if (!entryexit)
+		trace_mark(kernel_arch_syscall_entry, "syscall_id %d ip #p%ld",
+			(int)regs->gprs[2], instruction_pointer(regs));
+	else
+		trace_mark(kernel_arch_syscall_exit, "ret %ld", regs->gprs[2]);
+
 	if (unlikely(current->audit_context) && entryexit)
 		audit_syscall_exit(AUDITSC_RESULT(regs->gprs[2]), regs->gprs[2]);
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
