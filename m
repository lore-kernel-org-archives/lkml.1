Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbXLFDBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbXLFDBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 22:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbXLFDAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 22:00:08 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:35379 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbXLFDAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 22:00:04 -0500
Message-Id: <20071206025946.819429839@polymtl.ca>
References: <20071206025650.451824066@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:56:55 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch-early-RFC 05/10] LTTng instrumentation PPC
Content-Disposition: inline; filename=lttng-instrumentation-ppc.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:59:49 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/ppc/kernel/misc.S  |    2 +-
 arch/ppc/kernel/time.c  |    4 ++++
 arch/ppc/kernel/traps.c |    3 +++
 arch/ppc/mm/fault.c     |    3 +++
 4 files changed, 11 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/arch/ppc/kernel/misc.S
===================================================================
--- linux-2.6-lttng.orig/arch/ppc/kernel/misc.S	2007-11-13 09:25:23.000000000 -0500
+++ linux-2.6-lttng/arch/ppc/kernel/misc.S	2007-11-13 09:50:11.000000000 -0500
@@ -868,7 +868,7 @@ _GLOBAL(_get_SP)
  * Create a kernel thread
  *   kernel_thread(fn, arg, flags)
  */
-_GLOBAL(kernel_thread)
+_GLOBAL(original_kernel_thread)
 	stwu	r1,-16(r1)
 	stw	r30,8(r1)
 	stw	r31,12(r1)
Index: linux-2.6-lttng/arch/ppc/kernel/time.c
===================================================================
--- linux-2.6-lttng.orig/arch/ppc/kernel/time.c	2007-11-13 09:25:23.000000000 -0500
+++ linux-2.6-lttng/arch/ppc/kernel/time.c	2007-11-13 09:50:11.000000000 -0500
@@ -139,7 +139,10 @@ void timer_interrupt(struct pt_regs * re
 	if (atomic_read(&ppc_n_lost_interrupts) != 0)
 		do_IRQ(regs);
 
+	trace_mark(kernel_arch_trap_entry, "trap_id %ld ip #p%ld",
+		regs->trap, instruction_pointer(regs));
 	old_regs = set_irq_regs(regs);
+
 	irq_enter();
 
 	while ((next_dec = tb_ticks_per_jiffy - tb_delta(&jiffy_stamp)) <= 0) {
@@ -192,6 +195,7 @@ void timer_interrupt(struct pt_regs * re
 
 	irq_exit();
 	set_irq_regs(old_regs);
+	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 }
 
 /*
Index: linux-2.6-lttng/arch/ppc/kernel/traps.c
===================================================================
--- linux-2.6-lttng.orig/arch/ppc/kernel/traps.c	2007-11-13 09:25:23.000000000 -0500
+++ linux-2.6-lttng/arch/ppc/kernel/traps.c	2007-11-13 09:50:11.000000000 -0500
@@ -108,11 +108,14 @@ void _exception(int signr, struct pt_reg
 		debugger(regs);
 		die("Exception in kernel mode", regs, signr);
 	}
+	trace_mark(kernel_arch_trap_entry, "trap_id %ld ip #p%ld", regs->trap,
+		instruction_pointer(regs));
 	info.si_signo = signr;
 	info.si_errno = 0;
 	info.si_code = code;
 	info.si_addr = (void __user *) addr;
 	force_sig_info(signr, &info, current);
+	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 
 	/*
 	 * Init gets no signals that it doesn't have a handler for.
Index: linux-2.6-lttng/arch/ppc/mm/fault.c
===================================================================
--- linux-2.6-lttng.orig/arch/ppc/mm/fault.c	2007-11-13 09:25:23.000000000 -0500
+++ linux-2.6-lttng/arch/ppc/mm/fault.c	2007-11-13 09:50:11.000000000 -0500
@@ -250,7 +250,10 @@ good_area:
 	 * the fault.
 	 */
  survive:
+ 	trace_mark(kernel_arch_trap_entry, "trap_id %ld ip #p%ld",
+		regs->trap, instruction_pointer(regs));
 	fault = handle_mm_fault(mm, vma, address, is_write);
+	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
