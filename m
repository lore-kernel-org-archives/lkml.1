Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbXLFDB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbXLFDB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 22:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbXLFDAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 22:00:15 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:35386 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581AbXLFDAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 22:00:07 -0500
Message-Id: <20071206025946.455265201@polymtl.ca>
References: <20071206025650.451824066@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:56:54 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch-early-RFC 04/10] LTTng instrumentation Powerpc
Content-Disposition: inline; filename=lttng-instrumentation-powerpc.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:59:48 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/powerpc/kernel/misc_32.S  |    2 +-
 arch/powerpc/kernel/misc_64.S  |    2 +-
 arch/powerpc/kernel/process.c  |   11 +++++++++++
 arch/powerpc/kernel/ptrace.c   |    4 ++++
 arch/powerpc/kernel/syscalls.c |    2 ++
 arch/powerpc/kernel/time.c     |    5 +++++
 arch/powerpc/kernel/traps.c    |   11 +++++++++++
 arch/powerpc/mm/fault.c        |    3 +++
 8 files changed, 38 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/arch/powerpc/kernel/misc_32.S
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/kernel/misc_32.S	2007-11-28 09:27:28.000000000 -0500
+++ linux-2.6-lttng/arch/powerpc/kernel/misc_32.S	2007-11-28 09:33:42.000000000 -0500
@@ -766,7 +766,7 @@ _GLOBAL(abs)
  * Create a kernel thread
  *   kernel_thread(fn, arg, flags)
  */
-_GLOBAL(kernel_thread)
+_GLOBAL(original_kernel_thread)
 	stwu	r1,-16(r1)
 	stw	r30,8(r1)
 	stw	r31,12(r1)
Index: linux-2.6-lttng/arch/powerpc/kernel/misc_64.S
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/kernel/misc_64.S	2007-11-28 09:27:28.000000000 -0500
+++ linux-2.6-lttng/arch/powerpc/kernel/misc_64.S	2007-11-28 09:33:42.000000000 -0500
@@ -427,7 +427,7 @@ _GLOBAL(scom970_write)
  * Create a kernel thread
  *   kernel_thread(fn, arg, flags)
  */
-_GLOBAL(kernel_thread)
+_GLOBAL(original_kernel_thread)
 	std	r29,-24(r1)
 	std	r30,-16(r1)
 	stdu	r1,-STACK_FRAME_OVERHEAD(r1)
Index: linux-2.6-lttng/arch/powerpc/kernel/process.c
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/kernel/process.c	2007-11-28 09:27:28.000000000 -0500
+++ linux-2.6-lttng/arch/powerpc/kernel/process.c	2007-11-28 09:33:42.000000000 -0500
@@ -488,6 +488,17 @@ void show_regs(struct pt_regs * regs)
 		show_instructions(regs);
 }
 
+long original_kernel_thread(int (*fn) (void*), void* arg, unsigned long flags);
+
+long kernel_thread(int (fn) (void *), void* arg, unsigned long flags)
+{
+	long retval;
+
+	retval = original_kernel_thread(fn, arg, flags);
+	trace_mark(kernel_arch_kthread_create, "pid %ld fn %p", retval, fn);
+	return retval;
+}
+
 void exit_thread(void)
 {
 	discard_lazy_cpu_state();
Index: linux-2.6-lttng/arch/powerpc/kernel/ptrace.c
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/kernel/ptrace.c	2007-11-28 09:27:28.000000000 -0500
+++ linux-2.6-lttng/arch/powerpc/kernel/ptrace.c	2007-11-28 09:33:42.000000000 -0500
@@ -624,6 +624,8 @@ static void do_syscall_trace(void)
 
 void do_syscall_trace_enter(struct pt_regs *regs)
 {
+	trace_mark(kernel_arch_syscall_entry, "syscall_id %d ip #p%ld",
+		(int)regs->gpr[0], instruction_pointer(regs));
 	secure_computing(regs->gpr[0]);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE)
@@ -650,6 +652,8 @@ void do_syscall_trace_enter(struct pt_re
 
 void do_syscall_trace_leave(struct pt_regs *regs)
 {
+	trace_mark(kernel_arch_syscall_exit, "ret %ld", regs->result);
+
 	if (unlikely(current->audit_context))
 		audit_syscall_exit((regs->ccr&0x10000000)?AUDITSC_FAILURE:AUDITSC_SUCCESS,
 				   regs->result);
Index: linux-2.6-lttng/arch/powerpc/kernel/syscalls.c
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/kernel/syscalls.c	2007-11-28 09:27:28.000000000 -0500
+++ linux-2.6-lttng/arch/powerpc/kernel/syscalls.c	2007-11-28 09:33:42.000000000 -0500
@@ -56,6 +56,8 @@ int sys_ipc(uint call, int first, unsign
 	version = call >> 16; /* hack for backward compatibility */
 	call &= 0xffff;
 
+	trace_mark(kernel_arch_ipc_call, "call %u first %d", call, first);
+
 	ret = -ENOSYS;
 	switch (call) {
 	case SEMOP:
Index: linux-2.6-lttng/arch/powerpc/kernel/time.c
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/kernel/time.c	2007-11-28 09:27:28.000000000 -0500
+++ linux-2.6-lttng/arch/powerpc/kernel/time.c	2007-11-28 09:33:42.000000000 -0500
@@ -564,6 +564,9 @@ void timer_interrupt(struct pt_regs * re
 	 * some CPUs will continuue to take decrementer exceptions */
 	set_dec(DECREMENTER_MAX);
 
+	trace_mark(kernel_arch_trap_entry, "trap_id %ld ip #p%ld", regs->trap,
+		instruction_pointer(regs));
+
 #ifdef CONFIG_PPC32
 	if (atomic_read(&ppc_n_lost_interrupts) != 0)
 		do_IRQ(regs);
@@ -605,6 +608,8 @@ void timer_interrupt(struct pt_regs * re
 
 	irq_exit();
 	set_irq_regs(old_regs);
+
+	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 }
 
 void wakeup_decrementer(void)
Index: linux-2.6-lttng/arch/powerpc/kernel/traps.c
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/kernel/traps.c	2007-11-28 09:27:28.000000000 -0500
+++ linux-2.6-lttng/arch/powerpc/kernel/traps.c	2007-11-28 09:33:42.000000000 -0500
@@ -188,6 +188,9 @@ void _exception(int signr, struct pt_reg
 				addr, regs->nip, regs->link, code);
 		}
 
+	trace_mark(kernel_arch_trap_entry, "trap_id %ld ip #p%ld", regs->trap,
+		instruction_pointer(regs));
+
 	memset(&info, 0, sizeof(info));
 	info.si_signo = signr;
 	info.si_code = code;
@@ -215,6 +218,8 @@ void _exception(int signr, struct pt_reg
 			do_exit(signr);
 		}
 	}
+
+	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 }
 
 #ifdef CONFIG_PPC64
@@ -908,7 +913,10 @@ void altivec_unavailable_exception(struc
 
 void performance_monitor_exception(struct pt_regs *regs)
 {
+	trace_mark(kernel_arch_trap_entry, "trap_id %ld ip #p%ld", regs->trap,
+		instruction_pointer(regs));
 	perf_irq(regs);
+	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 }
 
 #ifdef CONFIG_8xx
@@ -1020,12 +1028,15 @@ void altivec_assist_exception(struct pt_
 		/* got an error reading the instruction */
 		_exception(SIGSEGV, regs, SEGV_ACCERR, regs->nip);
 	} else {
+		trace_mark(kernel_arch_trap_entry, "trap_id %ld ip #p%ld",
+			regs->trap, instruction_pointer(regs));
 		/* didn't recognize the instruction */
 		/* XXX quick hack for now: set the non-Java bit in the VSCR */
 		if (printk_ratelimit())
 			printk(KERN_ERR "Unrecognized altivec instruction "
 			       "in %s at %lx\n", current->comm, regs->nip);
 		current->thread.vscr.u[3] |= 0x10000;
+		trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 	}
 }
 #endif /* CONFIG_ALTIVEC */
Index: linux-2.6-lttng/arch/powerpc/mm/fault.c
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/mm/fault.c	2007-11-28 09:27:28.000000000 -0500
+++ linux-2.6-lttng/arch/powerpc/mm/fault.c	2007-11-28 09:33:42.000000000 -0500
@@ -336,7 +336,10 @@ good_area:
 	 * the fault.
 	 */
  survive:
+ 	trace_mark(kernel_arch_trap_entry, "trap_id %ld ip #p%ld", regs->trap,
+		instruction_pointer(regs));
 	ret = handle_mm_fault(mm, vma, address, is_write);
+	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 	if (unlikely(ret & VM_FAULT_ERROR)) {
 		if (ret & VM_FAULT_OOM)
 			goto out_of_memory;

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
