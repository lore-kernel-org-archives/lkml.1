Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbXLFDB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbXLFDB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 22:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754794AbXLFDAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 22:00:10 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:35381 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbXLFDAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 22:00:04 -0500
Message-Id: <20071206025946.091419028@polymtl.ca>
References: <20071206025650.451824066@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:56:53 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch-early-RFC 03/10] LTTng - MIPS instrumentation
Content-Disposition: inline; filename=lttng-instrumentation-mips.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:59:48 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/mips/kernel/entry.S     |    2 +-
 arch/mips/kernel/process.c   |    6 +++++-
 arch/mips/kernel/ptrace.c    |    7 +++++++
 arch/mips/kernel/syscall.c   |    2 ++
 arch/mips/kernel/traps.c     |   16 ++++++++++++----
 arch/mips/kernel/unaligned.c |   11 ++++++++++-
 arch/mips/mm/fault.c         |    3 +++
 include/asm-mips/mipsregs.h  |    1 +
 8 files changed, 41 insertions(+), 7 deletions(-)

Index: linux-2.6-lttng/arch/mips/kernel/process.c
===================================================================
--- linux-2.6-lttng.orig/arch/mips/kernel/process.c	2007-11-20 13:13:42.000000000 -0500
+++ linux-2.6-lttng/arch/mips/kernel/process.c	2007-11-20 13:19:04.000000000 -0500
@@ -226,6 +226,7 @@ static void __noreturn kernel_thread_hel
 long kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 {
 	struct pt_regs regs;
+	long pid;
 
 	memset(&regs, 0, sizeof(regs));
 
@@ -241,7 +242,10 @@ long kernel_thread(int (*fn)(void *), vo
 #endif
 
 	/* Ok, create the new process.. */
-	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0, &regs, 0, NULL, NULL);
+	pid = do_fork(flags | CLONE_VM | CLONE_UNTRACED,
+			0, &regs, 0, NULL, NULL);
+	trace_mark(kernel_arch_kthread_create, "pid %ld fn %p", pid, fn);
+	return pid;
 }
 
 /*
Index: linux-2.6-lttng/arch/mips/kernel/ptrace.c
===================================================================
--- linux-2.6-lttng.orig/arch/mips/kernel/ptrace.c	2007-11-20 13:13:42.000000000 -0500
+++ linux-2.6-lttng/arch/mips/kernel/ptrace.c	2007-11-20 13:19:52.000000000 -0500
@@ -466,6 +466,13 @@ static inline int audit_arch(void)
  */
 asmlinkage void do_syscall_trace(struct pt_regs *regs, int entryexit)
 {
+	if (!entryexit)
+		trace_mark(kernel_arch_syscall_entry, "syscall_id %d ip #p%ld",
+			(int)regs->regs[2], instruction_pointer(regs));
+	else
+		trace_mark(kernel_arch_syscall_exit, "ret %ld",
+			regs->regs[2]);
+
 	/* do the secure computing check first */
 	if (!entryexit)
 		secure_computing(regs->regs[0]);
Index: linux-2.6-lttng/arch/mips/kernel/syscall.c
===================================================================
--- linux-2.6-lttng.orig/arch/mips/kernel/syscall.c	2007-11-20 13:13:42.000000000 -0500
+++ linux-2.6-lttng/arch/mips/kernel/syscall.c	2007-11-20 13:19:04.000000000 -0500
@@ -327,6 +327,8 @@ asmlinkage int sys_ipc(unsigned int call
 	version = call >> 16; /* hack for backward compatibility */
 	call &= 0xffff;
 
+	trace_mark(kernel_arch_ipc_call, "call %u first %d", call, first);
+
 	switch (call) {
 	case SEMOP:
 		return sys_semtimedop(first, (struct sembuf __user *)ptr,
Index: linux-2.6-lttng/arch/mips/kernel/traps.c
===================================================================
--- linux-2.6-lttng.orig/arch/mips/kernel/traps.c	2007-11-20 13:13:42.000000000 -0500
+++ linux-2.6-lttng/arch/mips/kernel/traps.c	2007-11-20 13:19:04.000000000 -0500
@@ -293,7 +293,7 @@ static void __show_regs(const struct pt_
 
 	printk("Cause : %08x\n", cause);
 
-	cause = (cause & CAUSEF_EXCCODE) >> CAUSEB_EXCCODE;
+	cause = CAUSE_EXCCODE(cause);
 	if (1 <= cause && cause <= 5)
 		printk("BadVA : %0*lx\n", field, regs->cp0_badvaddr);
 
@@ -587,6 +587,8 @@ asmlinkage void do_fpe(struct pt_regs *r
 
 	die_if_kernel("FP exception in kernel code", regs);
 
+	trace_mark(kernel_arch_trap_entry, "trap_id %lu ip #p%ld",
+		CAUSE_EXCCODE(regs->cp0_cause), instruction_pointer(regs));
 	if (fcr31 & FPU_CSR_UNI_X) {
 		int sig;
 
@@ -800,6 +802,9 @@ asmlinkage void do_cpu(struct pt_regs *r
 	unsigned int cpid;
 	int status;
 
+	trace_mark(kernel_arch_trap_entry, "trap_id %lu ip #p%ld",
+		CAUSE_EXCCODE(regs->cp0_cause), instruction_pointer(regs));
+
 	die_if_kernel("do_cpu invoked from kernel context!", regs);
 
 	cpid = (regs->cp0_cause >> CAUSEB_CE) & 3;
@@ -811,8 +816,10 @@ asmlinkage void do_cpu(struct pt_regs *r
 		opcode = 0;
 		status = -1;
 
-		if (unlikely(compute_return_epc(regs) < 0))
+		if (unlikely(compute_return_epc(regs) < 0)) {
+			trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 			return;
+		}
 
 		if (unlikely(get_user(opcode, epc) < 0))
 			status = SIGSEGV;
@@ -830,7 +837,7 @@ asmlinkage void do_cpu(struct pt_regs *r
 			regs->cp0_epc = old_epc;	/* Undo skip-over.  */
 			force_sig(status, current);
 		}
-
+		trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 		return;
 
 	case 1:
@@ -850,7 +857,7 @@ asmlinkage void do_cpu(struct pt_regs *r
 			else
 				mt_ase_fp_affinity();
 		}
-
+		trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 		return;
 
 	case 2:
@@ -859,6 +866,7 @@ asmlinkage void do_cpu(struct pt_regs *r
 	}
 
 	force_sig(SIGILL, current);
+	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 }
 
 asmlinkage void do_mdmx(struct pt_regs *regs)
Index: linux-2.6-lttng/arch/mips/kernel/unaligned.c
===================================================================
--- linux-2.6-lttng.orig/arch/mips/kernel/unaligned.c	2007-11-20 13:13:42.000000000 -0500
+++ linux-2.6-lttng/arch/mips/kernel/unaligned.c	2007-11-20 13:19:04.000000000 -0500
@@ -503,14 +503,19 @@ asmlinkage void do_ade(struct pt_regs *r
 	unsigned int __user *pc;
 	mm_segment_t seg;
 
+	trace_mark(kernel_arch_trap_entry, "trap_id %lu ip #p%ld",
+		CAUSE_EXCCODE(regs->cp0_cause), instruction_pointer(regs));
+
 	/*
 	 * Address errors may be deliberately induced by the FPU emulator to
 	 * retake control of the CPU after executing the instruction in the
 	 * delay slot of an emulated branch.
 	 */
 	/* Terminate if exception was recognized as a delay slot return */
-	if (do_dsemulret(regs))
+	if (do_dsemulret(regs)) {
+		trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 		return;
+	}
 
 	/* Otherwise handle as normal */
 
@@ -539,6 +544,8 @@ asmlinkage void do_ade(struct pt_regs *r
 	emulate_load_store_insn(regs, (void __user *)regs->cp0_badvaddr, pc);
 	set_fs(seg);
 
+	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
+
 	return;
 
 sigbus:
@@ -548,6 +555,8 @@ sigbus:
 	/*
 	 * XXX On return from the signal handler we should advance the epc
 	 */
+
+	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 }
 
 #ifdef CONFIG_DEBUG_FS
Index: linux-2.6-lttng/include/asm-mips/mipsregs.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-mips/mipsregs.h	2007-11-20 13:13:42.000000000 -0500
+++ linux-2.6-lttng/include/asm-mips/mipsregs.h	2007-11-20 13:19:04.000000000 -0500
@@ -384,6 +384,7 @@
  */
 #define  CAUSEB_EXCCODE		2
 #define  CAUSEF_EXCCODE		(_ULCAST_(31)  <<  2)
+#define  CAUSE_EXCCODE(cause)	(((cause) & CAUSEF_EXCCODE) >> CAUSEB_EXCCODE)
 #define  CAUSEB_IP		8
 #define  CAUSEF_IP		(_ULCAST_(255) <<  8)
 #define  CAUSEB_IP0		8
Index: linux-2.6-lttng/arch/mips/mm/fault.c
===================================================================
--- linux-2.6-lttng.orig/arch/mips/mm/fault.c	2007-11-20 13:13:42.000000000 -0500
+++ linux-2.6-lttng/arch/mips/mm/fault.c	2007-11-20 13:19:04.000000000 -0500
@@ -103,7 +103,10 @@ survive:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
+	trace_mark(kernel_arch_trap_entry, "trap_id %lu ip #p%ld",
+		CAUSE_EXCCODE(regs->cp0_cause), instruction_pointer(regs));
 	fault = handle_mm_fault(mm, vma, address, write);
+	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
Index: linux-2.6-lttng/arch/mips/kernel/entry.S
===================================================================
--- linux-2.6-lttng.orig/arch/mips/kernel/entry.S	2007-11-20 13:13:42.000000000 -0500
+++ linux-2.6-lttng/arch/mips/kernel/entry.S	2007-11-20 13:19:04.000000000 -0500
@@ -167,7 +167,7 @@ work_notifysig:				# deal with pending s
 FEXPORT(syscall_exit_work_partial)
 	SAVE_STATIC
 syscall_exit_work:
-	li	t0, _TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT
+	li	t0, _TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | _TIF_KERNEL_TRACE
 	and	t0, a2			# a2 is preloaded with TI_FLAGS
 	beqz	t0, work_pending	# trace bit set?
 	local_irq_enable		# could let do_syscall_trace()

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
