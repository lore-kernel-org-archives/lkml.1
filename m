Return-Path: <linux-kernel-owner+w=401wt.eu-S1757917AbXLFDDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbXLFDDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 22:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756499AbXLFDAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 22:00:49 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:35494 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756351AbXLFDAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 22:00:47 -0500
Message-Id: <20071206025945.715352239@polymtl.ca>
References: <20071206025650.451824066@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:56:52 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch-early-RFC 02/10] LTTng - x86_32 instrumentation
Content-Disposition: inline; filename=lttng-instrumentation-i386.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:59:48 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/apic_32.c       |   21 +++++++++++++++++++++
 arch/x86/kernel/cpu/mcheck/p4.c |    7 +++++++
 arch/x86/kernel/entry_32.S      |    6 +++---
 arch/x86/kernel/process_32.c    |    6 +++++-
 arch/x86/kernel/ptrace_32.c     |    6 ++++++
 arch/x86/kernel/smp_32.c        |   18 ++++++++++++++++++
 arch/x86/kernel/sys_i386_32.c   |    2 ++
 arch/x86/kernel/traps_32.c      |   38 +++++++++++++++++++++++++++++++-------
 arch/x86/mm/fault_32.c          |    7 +++++++
 9 files changed, 100 insertions(+), 11 deletions(-)

Index: linux-2.6-lttng/arch/x86/kernel/process_32.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/process_32.c	2007-12-05 21:05:49.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/process_32.c	2007-12-05 21:48:05.000000000 -0500
@@ -374,6 +374,7 @@ extern void kernel_thread_helper(void);
 int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags)
 {
 	struct pt_regs regs;
+	long pid;
 
 	memset(&regs, 0, sizeof(regs));
 
@@ -389,7 +390,10 @@ int kernel_thread(int (*fn)(void *), voi
 	regs.eflags = X86_EFLAGS_IF | X86_EFLAGS_SF | X86_EFLAGS_PF | 0x2;
 
 	/* Ok, create the new process.. */
-	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0, &regs, 0, NULL, NULL);
+	pid = do_fork(flags | CLONE_VM | CLONE_UNTRACED,
+			0, &regs, 0, NULL, NULL);
+	trace_mark(kernel_arch_kthread_create, "pid %ld fn %p", pid, fn);
+	return pid;
 }
 EXPORT_SYMBOL(kernel_thread);
 
Index: linux-2.6-lttng/arch/x86/kernel/ptrace_32.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/ptrace_32.c	2007-12-05 21:05:49.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/ptrace_32.c	2007-12-05 21:48:05.000000000 -0500
@@ -650,6 +650,12 @@ int do_syscall_trace(struct pt_regs *reg
 	int is_singlestep = !is_sysemu && test_thread_flag(TIF_SINGLESTEP);
 	int ret = 0;
 
+	if (!entryexit)
+		trace_mark(kernel_arch_syscall_entry, "syscall_id %d ip #p%ld",
+			(int)regs->orig_eax, instruction_pointer(regs));
+	else
+		trace_mark(kernel_arch_syscall_exit, "ret %ld", regs->eax);
+
 	/* do the secure computing check first */
 	if (!entryexit)
 		secure_computing(regs->orig_eax);
Index: linux-2.6-lttng/arch/x86/kernel/sys_i386_32.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/sys_i386_32.c	2007-12-05 21:05:49.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/sys_i386_32.c	2007-12-05 21:48:05.000000000 -0500
@@ -128,6 +128,8 @@ asmlinkage int sys_ipc (uint call, int f
 	version = call >> 16; /* hack for backward compatibility */
 	call &= 0xffff;
 
+	trace_mark(kernel_arch_ipc_call, "call %u first %d", call, first);
+
 	switch (call) {
 	case SEMOP:
 		return sys_semtimedop (first, (struct sembuf __user *)ptr, second, NULL);
Index: linux-2.6-lttng/arch/x86/kernel/traps_32.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/traps_32.c	2007-12-05 21:48:04.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/traps_32.c	2007-12-05 21:48:05.000000000 -0500
@@ -455,6 +455,9 @@ static void __kprobes do_trap(int trapnr
 {
 	struct task_struct *tsk = current;
 
+	trace_mark(kernel_arch_trap_entry, "trap_id %d ip #p%ld", trapnr,
+		instruction_pointer(regs));
+
 	if (regs->eflags & VM_MASK) {
 		if (vm86)
 			goto vm86_trap;
@@ -481,7 +484,7 @@ static void __kprobes do_trap(int trapnr
 			force_sig_info(signr, info, tsk);
 		else
 			force_sig(signr, tsk);
-		return;
+		goto end;
 	}
 
 	kernel_trap: {
@@ -490,14 +493,16 @@ static void __kprobes do_trap(int trapnr
 			tsk->thread.trap_no = trapnr;
 			die(str, regs, error_code);
 		}
-		return;
+		goto end;
 	}
 
 	vm86_trap: {
 		int ret = handle_vm86_trap((struct kernel_vm86_regs *) regs, error_code, trapnr);
 		if (ret) goto trap_signal;
-		return;
+		goto end;
 	}
+end:
+	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 }
 
 #define DO_ERROR(trapnr, signr, str, name) \
@@ -611,7 +616,10 @@ fastcall void __kprobes do_general_prote
 		    current->comm, task_pid_nr(current),
 		    regs->eip, regs->esp, error_code);
 
+	trace_mark(kernel_arch_trap_entry, "trap_id %d ip #p%ld", 13,
+			instruction_pointer(regs));
 	force_sig(SIGSEGV, current);
+	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 	return;
 
 gp_in_vm86:
@@ -731,25 +739,28 @@ static __kprobes void default_do_nmi(str
 	if (!smp_processor_id())
 		reason = get_nmi_reason();
  
+	trace_mark(kernel_arch_trap_entry, "trap_id %d ip #p%ld", 2,
+		instruction_pointer(regs));
+
 	if (!(reason & 0xc0)) {
 		if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, reason, 2, SIGINT)
 							== NOTIFY_STOP)
-			return;
+			goto end;
 #ifdef CONFIG_X86_LOCAL_APIC
 		/*
 		 * Ok, so this is none of the documented NMI sources,
 		 * so it must be the NMI watchdog.
 		 */
 		if (nmi_watchdog_tick(regs, reason))
-			return;
+			goto end;
 		if (!do_nmi_callback(regs, smp_processor_id()))
 #endif
 			unknown_nmi_error(reason, regs);
 
-		return;
+		goto end;
 	}
 	if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT) == NOTIFY_STOP)
-		return;
+		goto end;
 	if (reason & 0x80)
 		mem_parity_error(reason, regs);
 	if (reason & 0x40)
@@ -759,6 +770,8 @@ static __kprobes void default_do_nmi(str
 	 * as it's edge-triggered.
 	 */
 	reassert_nmi();
+end:
+	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 }
 
 static int ignore_nmis;
@@ -873,7 +886,10 @@ fastcall void __kprobes do_debug(struct 
 	}
 
 	/* Ok, finally something we can handle */
+	trace_mark(kernel_arch_trap_entry, "trap_id %d ip #p%ld",
+			1, instruction_pointer(regs));
 	send_sigtrap(tsk, regs, error_code);
+	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 
 	/* Disable additional traps. They'll be re-enabled when
 	 * the signal is delivered.
@@ -883,7 +899,10 @@ clear_dr7:
 	return;
 
 debug_vm86:
+	trace_mark(kernel_arch_trap_entry, "trap_id %d ip #p%ld",
+			1, instruction_pointer(regs));
 	handle_vm86_trap((struct kernel_vm86_regs *) regs, error_code, 1);
+	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 	return;
 
 clear_TF_reenable:
@@ -1037,10 +1056,13 @@ fastcall void do_simd_coprocessor_error(
 fastcall void do_spurious_interrupt_bug(struct pt_regs * regs,
 					  long error_code)
 {
+	trace_mark(kernel_arch_trap_entry, "trap_id %d ip #p%ld",
+			16, instruction_pointer(regs));
 #if 0
 	/* No need to warn about this any longer. */
 	printk("Ignoring P6 Local APIC Spurious Interrupt Bug...\n");
 #endif
+	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 }
 
 fastcall unsigned long patch_espfix_desc(unsigned long uesp,
@@ -1091,8 +1113,10 @@ asmlinkage void math_emulate(long arg)
 {
 	printk(KERN_EMERG "math-emulation not enabled and no coprocessor found.\n");
 	printk(KERN_EMERG "killing %s.\n",current->comm);
+	trace_mark(kernel_arch_trap_entry, "trap_id %d ip #p%ld", 7, 0L);
 	force_sig(SIGFPE,current);
 	schedule();
+	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 }
 
 #endif /* CONFIG_MATH_EMULATION */
Index: linux-2.6-lttng/arch/x86/kernel/entry_32.S
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/entry_32.S	2007-12-05 21:05:49.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/entry_32.S	2007-12-05 21:48:05.000000000 -0500
@@ -333,7 +333,7 @@ sysenter_past_esp:
 	GET_THREAD_INFO(%ebp)
 
 	/* Note, _TIF_SECCOMP is bit number 8, and so it needs testw and not testb */
-	testw $(_TIF_SYSCALL_EMU|_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT),TI_flags(%ebp)
+	testw $(_TIF_SYSCALL_EMU|_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT|_TIF_KERNEL_TRACE),TI_flags(%ebp)
 	jnz syscall_trace_entry
 	cmpl $(nr_syscalls), %eax
 	jae syscall_badsys
@@ -371,7 +371,7 @@ ENTRY(system_call)
 	GET_THREAD_INFO(%ebp)
 					# system call tracing in operation / emulation
 	/* Note, _TIF_SECCOMP is bit number 8, and so it needs testw and not testb */
-	testw $(_TIF_SYSCALL_EMU|_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT),TI_flags(%ebp)
+	testw $(_TIF_SYSCALL_EMU|_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT|_TIF_KERNEL_TRACE),TI_flags(%ebp)
 	jnz syscall_trace_entry
 	cmpl $(nr_syscalls), %eax
 	jae syscall_badsys
@@ -528,7 +528,7 @@ END(syscall_trace_entry)
 	# perform syscall exit tracing
 	ALIGN
 syscall_exit_work:
-	testb $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SINGLESTEP), %cl
+	testw $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SINGLESTEP|_TIF_KERNEL_TRACE), %cx
 	jz work_pending
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_ANY)	# could let do_syscall_trace() call
Index: linux-2.6-lttng/arch/x86/mm/fault_32.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/mm/fault_32.c	2007-12-05 21:05:50.000000000 -0500
+++ linux-2.6-lttng/arch/x86/mm/fault_32.c	2007-12-05 21:48:16.000000000 -0500
@@ -426,7 +426,10 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
+	trace_mark(kernel_arch_trap_entry, "trap_id %d ip #p%ld",
+		14, instruction_pointer(regs));
 	fault = handle_mm_fault(mm, vma, address, write);
+	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
@@ -465,6 +468,9 @@ bad_area_nosemaphore:
 		 */
 		local_irq_enable();
 
+		trace_mark(kernel_arch_trap_entry, "trap_id %d ip #p%ld",
+		    14, instruction_pointer(regs));
+
 		/* 
 		 * Valid to do another page fault here because this one came 
 		 * from user space.
@@ -485,6 +491,7 @@ bad_area_nosemaphore:
 		tsk->thread.error_code = error_code | (address >= TASK_SIZE);
 		tsk->thread.trap_no = 14;
 		force_sig_info_fault(SIGSEGV, si_code, address, tsk);
+		trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 		return;
 	}
 
Index: linux-2.6-lttng/arch/x86/kernel/apic_32.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/apic_32.c	2007-12-05 21:05:49.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/apic_32.c	2007-12-05 21:48:28.000000000 -0500
@@ -592,7 +592,14 @@ void fastcall smp_apic_timer_interrupt(s
 	 * interrupt lock, which is the WrongThing (tm) to do.
 	 */
 	irq_enter();
+
+	trace_mark(kernel_irq_entry, "irq_id %u kernel_mode %u",
+		LOCAL_TIMER_VECTOR, (regs)?(!user_mode(regs)):(1));
+
 	local_apic_timer_interrupt();
+
+	trace_mark(kernel_irq_exit, MARK_NOARGS);
+
 	irq_exit();
 
 	set_irq_regs(old_regs);
@@ -1265,6 +1272,10 @@ void smp_spurious_interrupt(struct pt_re
 	unsigned long v;
 
 	irq_enter();
+
+	trace_mark(kernel_irq_entry, "irq_id %u kernel_mode %u",
+		SPURIOUS_APIC_VECTOR, (regs)?(!user_mode(regs)):(1));
+
 	/*
 	 * Check if this really is a spurious interrupt and ACK it
 	 * if it is a vectored one.  Just in case...
@@ -1278,6 +1289,9 @@ void smp_spurious_interrupt(struct pt_re
 	printk(KERN_INFO "spurious APIC interrupt on CPU#%d, "
 	       "should never happen.\n", smp_processor_id());
 	__get_cpu_var(irq_stat).irq_spurious_count++;
+
+	trace_mark(kernel_irq_exit, MARK_NOARGS);
+
 	irq_exit();
 }
 
@@ -1289,6 +1303,10 @@ void smp_error_interrupt(struct pt_regs 
 	unsigned long v, v1;
 
 	irq_enter();
+
+	trace_mark(kernel_irq_entry, "irq_id %u kernel_mode %u",
+		ERROR_APIC_VECTOR, (regs)?(!user_mode(regs)):(1));
+
 	/* First tickle the hardware, only then report what went on. -- REW */
 	v = apic_read(APIC_ESR);
 	apic_write(APIC_ESR, 0);
@@ -1308,6 +1326,9 @@ void smp_error_interrupt(struct pt_regs 
 	*/
 	printk (KERN_DEBUG "APIC error on CPU%d: %02lx(%02lx)\n",
 		smp_processor_id(), v , v1);
+
+	trace_mark(kernel_irq_exit, MARK_NOARGS);
+
 	irq_exit();
 }
 
Index: linux-2.6-lttng/arch/x86/kernel/cpu/mcheck/p4.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/cpu/mcheck/p4.c	2007-12-05 21:05:49.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/cpu/mcheck/p4.c	2007-12-05 21:48:28.000000000 -0500
@@ -60,8 +60,15 @@ static void (*vendor_thermal_interrupt)(
 fastcall void smp_thermal_interrupt(struct pt_regs *regs)
 {
 	irq_enter();
+
+	trace_mark(kernel_irq_entry, "irq_id %u kernel_mode %u",
+		THERMAL_APIC_VECTOR, (regs)?(!user_mode(regs)):(1));
+
 	vendor_thermal_interrupt(regs);
 	__get_cpu_var(irq_stat).irq_thermal_count++;
+
+	trace_mark(kernel_irq_exit, MARK_NOARGS);
+
 	irq_exit();
 }
 
Index: linux-2.6-lttng/arch/x86/kernel/smp_32.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/smp_32.c	2007-12-05 21:05:49.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/smp_32.c	2007-12-05 21:48:28.000000000 -0500
@@ -327,6 +327,9 @@ fastcall void smp_invalidate_interrupt(s
 		 * BUG();
 		 */
 		 
+	trace_mark(kernel_irq_entry, "irq_id %u kernel_mode %u",
+		INVALIDATE_TLB_VECTOR, (regs)?(!user_mode(regs)):(1));
+
 	if (flush_mm == per_cpu(cpu_tlbstate, cpu).active_mm) {
 		if (per_cpu(cpu_tlbstate, cpu).state == TLBSTATE_OK) {
 			if (flush_va == TLB_FLUSH_ALL)
@@ -343,6 +346,8 @@ fastcall void smp_invalidate_interrupt(s
 out:
 	put_cpu_no_resched();
 	__get_cpu_var(irq_stat).irq_tlb_count++;
+
+	trace_mark(kernel_irq_exit, MARK_NOARGS);
 }
 
 void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
@@ -641,7 +646,13 @@ static void native_smp_send_stop(void)
 fastcall void smp_reschedule_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
+
+	trace_mark(kernel_irq_entry, "irq_id %u kernel_mode %u",
+		RESCHEDULE_VECTOR, (regs)?(!user_mode(regs)):(1));
+
 	__get_cpu_var(irq_stat).irq_resched_count++;
+
+	trace_mark(kernel_irq_exit, MARK_NOARGS);
 }
 
 fastcall void smp_call_function_interrupt(struct pt_regs *regs)
@@ -661,8 +672,15 @@ fastcall void smp_call_function_interrup
 	 * At this point the info structure may be out of scope unless wait==1
 	 */
 	irq_enter();
+
+	trace_mark(kernel_irq_entry, "irq_id %u kernel_mode %u",
+		CALL_FUNCTION_VECTOR, (regs)?(!user_mode(regs)):(1));
+
 	(*func)(info);
 	__get_cpu_var(irq_stat).irq_call_count++;
+
+	trace_mark(kernel_irq_exit, MARK_NOARGS);
+
 	irq_exit();
 
 	if (wait) {

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
