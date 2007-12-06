Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbXLFDDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbXLFDDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 22:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756782AbXLFDBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 22:01:08 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:35531 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723AbXLFDBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 22:01:05 -0500
Message-Id: <20071206025948.483446647@polymtl.ca>
References: <20071206025650.451824066@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:56:59 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch-early-RFC 09/10] LTTng - x86_64 instrumentation
Content-Disposition: inline; filename=lttng-instrumentation-x86_64.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:59:51 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/ia32/ia32entry.S                 |    6 +++---
 arch/x86/ia32/ipc32.c                     |    2 ++
 arch/x86/kernel/apic_64.c                 |   21 +++++++++++++++++++++
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |    6 ++++++
 arch/x86/kernel/entry_64.S                |   12 ++++++------
 arch/x86/kernel/process_64.c              |   11 +++++++++++
 arch/x86/kernel/ptrace_64.c               |    5 +++++
 arch/x86/kernel/setup64.c                 |    1 +
 arch/x86/kernel/smp_64.c                  |   18 ++++++++++++++++++
 arch/x86/kernel/traps_64.c                |   29 +++++++++++++++++++++++++----
 arch/x86/mm/fault_64.c                    |    7 +++++++
 11 files changed, 105 insertions(+), 13 deletions(-)

Index: linux-2.6-lttng/arch/x86/ia32/ia32entry.S
===================================================================
--- linux-2.6-lttng.orig/arch/x86/ia32/ia32entry.S	2007-12-05 21:05:48.000000000 -0500
+++ linux-2.6-lttng/arch/x86/ia32/ia32entry.S	2007-12-05 21:48:46.000000000 -0500
@@ -125,7 +125,7 @@ ENTRY(ia32_sysenter_target)
  	.previous	
 	GET_THREAD_INFO(%r10)
 	orl    $TS_COMPAT,threadinfo_status(%r10)
-	testl  $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),threadinfo_flags(%r10)
+	testl  $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_KERNEL_TRACE|_TIF_SECCOMP),threadinfo_flags(%r10)
 	CFI_REMEMBER_STATE
 	jnz  sysenter_tracesys
 sysenter_do_call:	
@@ -230,7 +230,7 @@ ENTRY(ia32_cstar_target)
 	.previous	
 	GET_THREAD_INFO(%r10)
 	orl   $TS_COMPAT,threadinfo_status(%r10)
-	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),threadinfo_flags(%r10)
+	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_KERNEL_TRACE|_TIF_SECCOMP),threadinfo_flags(%r10)
 	CFI_REMEMBER_STATE
 	jnz   cstar_tracesys
 cstar_do_call:	
@@ -322,7 +322,7 @@ ENTRY(ia32_syscall)
 	SAVE_ARGS 0,0,1
 	GET_THREAD_INFO(%r10)
 	orl   $TS_COMPAT,threadinfo_status(%r10)
-	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),threadinfo_flags(%r10)
+	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_KERNEL_TRACE|_TIF_SECCOMP),threadinfo_flags(%r10)
 	jnz ia32_tracesys
 ia32_do_syscall:	
 	cmpl $(IA32_NR_syscalls-1),%eax
Index: linux-2.6-lttng/arch/x86/ia32/ipc32.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/ia32/ipc32.c	2007-12-05 21:05:48.000000000 -0500
+++ linux-2.6-lttng/arch/x86/ia32/ipc32.c	2007-12-05 21:48:46.000000000 -0500
@@ -18,6 +18,8 @@ sys32_ipc(u32 call, int first, int secon
 	version = call >> 16; /* hack for backward compatibility */
 	call &= 0xffff;
 
+	trace_mark(kernel_arch_ipc_call, "call %u first %d", call, first);
+
 	switch (call) {
 	      case SEMOP:
 		/* struct sembuf is the same on 32 and 64bit :)) */
Index: linux-2.6-lttng/arch/x86/kernel/entry_64.S
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/entry_64.S	2007-12-05 21:48:05.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/entry_64.S	2007-12-05 21:48:46.000000000 -0500
@@ -161,7 +161,7 @@ ENTRY(ret_from_fork)
 	CFI_ADJUST_CFA_OFFSET -4
 	call schedule_tail
 	GET_THREAD_INFO(%rcx)
-	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT),threadinfo_flags(%rcx)
+	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_KERNEL_TRACE),threadinfo_flags(%rcx)
 	jnz rff_trace
 rff_action:	
 	RESTORE_REST
@@ -229,7 +229,7 @@ ENTRY(system_call)
 	movq  %rcx,RIP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rip,RIP-ARGOFFSET
 	GET_THREAD_INFO(%rcx)
-	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),threadinfo_flags(%rcx)
+	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_KERNEL_TRACE|_TIF_SECCOMP),threadinfo_flags(%rcx)
 	jnz tracesys
 	cmpq $__NR_syscall_max,%rax
 	ja badsys
@@ -268,7 +268,7 @@ sysret_check:		
 	/* Handle reschedules */
 	/* edx:	work, edi: workmask */	
 sysret_careful:
-	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),%edx
+	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_KERNEL_TRACE|_TIF_SECCOMP),%edx
 	jnz ret_from_sys_call_trace
 	bt $TIF_NEED_RESCHED,%edx
 	jnc sysret_signal
@@ -377,7 +377,7 @@ int_very_careful:
 	sti
 	SAVE_REST
 	/* Check for syscall exit trace */	
-	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SINGLESTEP),%edx
+	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_KERNEL_TRACE|_TIF_SINGLESTEP),%edx
 	jz int_signal
 	pushq %rdi
 	CFI_ADJUST_CFA_OFFSET 8
@@ -385,7 +385,7 @@ int_very_careful:
 	call syscall_trace_leave
 	popq %rdi
 	CFI_ADJUST_CFA_OFFSET -8
-	andl $~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SINGLESTEP),%edi
+	andl $~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_KERNEL_TRACE|_TIF_SINGLESTEP),%edi
 	jmp int_restore_rest
 	
 int_signal:
@@ -957,7 +957,7 @@ bad_gs: 
  * asm input arguments:
  *	rdi: fn, rsi: arg, rdx: flags
  */
-ENTRY(kernel_thread)
+ENTRY(kernel_thread_asm)
 	CFI_STARTPROC
 	FAKE_STACK_FRAME $child_rip
 	SAVE_ALL
Index: linux-2.6-lttng/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/process_64.c	2007-12-05 21:05:48.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/process_64.c	2007-12-05 21:48:46.000000000 -0500
@@ -54,6 +54,9 @@
 
 asmlinkage extern void ret_from_fork(void);
 
+asmlinkage long kernel_thread_asm(int (*fn)(void *), void * arg,
+	 unsigned long flags);
+
 unsigned long kernel_thread_flags = CLONE_VM | CLONE_UNTRACED;
 
 unsigned long boot_option_idle_override = 0;
@@ -903,3 +906,11 @@ unsigned long arch_align_stack(unsigned 
 		sp -= get_random_int() % 8192;
 	return sp & ~0xf;
 }
+
+asmlinkage long kernel_thread(int (*fn)(void *), void * arg,
+	 unsigned long flags)
+{
+	long pid = kernel_thread_asm(fn, arg, flags);
+	trace_mark(kernel_arch_kthread_create, "pid %ld fn %p", pid, fn);
+	return pid;
+}
Index: linux-2.6-lttng/arch/x86/kernel/ptrace_64.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/ptrace_64.c	2007-12-05 21:05:48.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/ptrace_64.c	2007-12-05 21:48:46.000000000 -0500
@@ -587,6 +587,9 @@ static void syscall_trace(struct pt_regs
 
 asmlinkage void syscall_trace_enter(struct pt_regs *regs)
 {
+	trace_mark(kernel_arch_syscall_entry, "syscall_id %d ip #p%ld",
+		(int)regs->orig_rax, instruction_pointer(regs));
+
 	/* do the secure computing check first */
 	secure_computing(regs->orig_rax);
 
@@ -611,6 +614,8 @@ asmlinkage void syscall_trace_enter(stru
 
 asmlinkage void syscall_trace_leave(struct pt_regs *regs)
 {
+	trace_mark(kernel_arch_syscall_exit, "ret %ld", regs->rax);
+
 	if (unlikely(current->audit_context))
 		audit_syscall_exit(AUDITSC_RESULT(regs->rax), regs->rax);
 
Index: linux-2.6-lttng/arch/x86/kernel/traps_64.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/traps_64.c	2007-12-05 21:05:48.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/traps_64.c	2007-12-05 21:49:48.000000000 -0500
@@ -573,6 +573,9 @@ static void __kprobes do_trap(int trapnr
 {
 	struct task_struct *tsk = current;
 
+	trace_mark(kernel_arch_trap_entry, "trap_id %d ip #p%ld", trapnr,
+		instruction_pointer(regs));
+
 	if (user_mode(regs)) {
 		/*
 		 * We want error_code and trap_no set for userspace
@@ -598,6 +601,7 @@ static void __kprobes do_trap(int trapnr
 			force_sig_info(signr, info, tsk);
 		else
 			force_sig(signr, tsk);
+		trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 		return;
 	}
 
@@ -613,8 +617,10 @@ static void __kprobes do_trap(int trapnr
 			tsk->thread.trap_no = trapnr;
 			die(str, regs, error_code);
 		}
+		trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 		return;
 	}
+	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 }
 
 #define DO_ERROR(trapnr, signr, str, name) \
@@ -699,7 +705,10 @@ asmlinkage void __kprobes do_general_pro
 			       tsk->comm, tsk->pid,
 			       regs->rip, regs->rsp, error_code); 
 
+		trace_mark(kernel_arch_trap_entry, "trap_id %d ip #p%ld", 13,
+			instruction_pointer(regs));
 		force_sig(SIGSEGV, tsk);
+		trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 		return;
 	} 
 
@@ -779,6 +788,9 @@ asmlinkage __kprobes void default_do_nmi
 	unsigned char reason = 0;
 	int cpu;
 
+	trace_mark(kernel_arch_trap_entry, "trap_id %d ip #p%ld",
+		2, instruction_pointer(regs));
+
 	cpu = smp_processor_id();
 
 	/* Only the BSP gets external NMIs from the system.  */
@@ -788,20 +800,20 @@ asmlinkage __kprobes void default_do_nmi
 	if (!(reason & 0xc0)) {
 		if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, reason, 2, SIGINT)
 								== NOTIFY_STOP)
-			return;
+			goto end;
 		/*
 		 * Ok, so this is none of the documented NMI sources,
 		 * so it must be the NMI watchdog.
 		 */
 		if (nmi_watchdog_tick(regs,reason))
-			return;
+			goto end;
 		if (!do_nmi_callback(regs,cpu))
 			unknown_nmi_error(reason, regs);
 
-		return;
+		goto end;
 	}
 	if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT) == NOTIFY_STOP)
-		return; 
+		goto end;
 
 	/* AK: following checks seem to be broken on modern chipsets. FIXME */
 
@@ -809,6 +821,8 @@ asmlinkage __kprobes void default_do_nmi
 		mem_parity_error(reason, regs);
 	if (reason & 0x40)
 		io_check_error(reason, regs);
+end:
+	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 }
 
 /* runs on IST stack. */
@@ -902,7 +916,10 @@ asmlinkage void __kprobes do_debug(struc
 	info.si_errno = 0;
 	info.si_code = TRAP_BRKPT;
 	info.si_addr = user_mode(regs) ? (void __user *)regs->rip : NULL;
+	trace_mark(kernel_arch_trap_entry, "trap_id %d ip #p%ld",
+		1, instruction_pointer(regs));
 	force_sig_info(SIGTRAP, &info, tsk);
+	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 
 clear_dr7:
 	set_debugreg(0UL, 7);
@@ -1060,6 +1077,10 @@ asmlinkage void do_simd_coprocessor_erro
 
 asmlinkage void do_spurious_interrupt_bug(struct pt_regs * regs)
 {
+	trace_mark(kernel_arch_trap_entry, "trap_id %d ip #p%ld",
+		16, instruction_pointer(regs));
+
+	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 }
 
 asmlinkage void __attribute__((weak)) smp_thermal_interrupt(void)
Index: linux-2.6-lttng/arch/x86/mm/fault_64.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/mm/fault_64.c	2007-12-05 21:05:48.000000000 -0500
+++ linux-2.6-lttng/arch/x86/mm/fault_64.c	2007-12-05 21:48:52.000000000 -0500
@@ -441,7 +441,10 @@ good_area:
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
@@ -472,6 +475,9 @@ bad_area_nosemaphore:
 		 */
 		local_irq_enable();
 
+		trace_mark(kernel_arch_trap_entry, "trap_id %d ip #p%ld",
+		    14, instruction_pointer(regs));
+
 		if (is_prefetch(regs, address, error_code))
 			return;
 
@@ -503,6 +509,7 @@ bad_area_nosemaphore:
 		/* info.si_code has been set above */
 		info.si_addr = (void __user *)address;
 		force_sig_info(SIGSEGV, &info, tsk);
+		trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 		return;
 	}
 
Index: linux-2.6-lttng/arch/x86/kernel/setup64.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/setup64.c	2007-12-05 21:05:48.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/setup64.c	2007-12-05 21:48:46.000000000 -0500
@@ -189,6 +189,7 @@ unsigned long kernel_eflags;
  * debugging, no special alignment required.
  */
 DEFINE_PER_CPU(struct orig_ist, orig_ist);
+EXPORT_PER_CPU_SYMBOL_GPL(orig_ist);
 
 /*
  * cpu_init() initializes state that is per-CPU. Some data is already
Index: linux-2.6-lttng/arch/x86/kernel/apic_64.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/apic_64.c	2007-12-05 21:05:48.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/apic_64.c	2007-12-05 21:48:58.000000000 -0500
@@ -1085,7 +1085,14 @@ void smp_apic_timer_interrupt(struct pt_
 	 */
 	exit_idle();
 	irq_enter();
+
+	trace_mark(kernel_irq_entry, "irq_id %u kernel_mode %u",
+		LOCAL_TIMER_VECTOR, (regs)?(!user_mode(regs)):(1));
+
 	smp_local_timer_interrupt();
+
+	trace_mark(kernel_irq_exit, MARK_NOARGS);
+
 	irq_exit();
 	set_irq_regs(old_regs);
 }
@@ -1145,6 +1152,10 @@ asmlinkage void smp_spurious_interrupt(v
 	unsigned int v;
 	exit_idle();
 	irq_enter();
+
+	trace_mark(kernel_irq_entry, "irq_id %u kernel_mode %u",
+		SPURIOUS_APIC_VECTOR, -1);
+
 	/*
 	 * Check if this really is a spurious interrupt and ACK it
 	 * if it is a vectored one.  Just in case...
@@ -1155,6 +1166,9 @@ asmlinkage void smp_spurious_interrupt(v
 		ack_APIC_irq();
 
 	add_pda(irq_spurious_count, 1);
+
+	trace_mark(kernel_irq_exit, MARK_NOARGS);
+
 	irq_exit();
 }
 
@@ -1168,6 +1182,10 @@ asmlinkage void smp_error_interrupt(void
 
 	exit_idle();
 	irq_enter();
+
+	trace_mark(kernel_irq_entry, "irq_id %u kernel_mode %u",
+		ERROR_APIC_VECTOR, -1);
+
 	/* First tickle the hardware, only then report what went on. -- REW */
 	v = apic_read(APIC_ESR);
 	apic_write(APIC_ESR, 0);
@@ -1187,6 +1205,9 @@ asmlinkage void smp_error_interrupt(void
 	*/
 	printk (KERN_DEBUG "APIC error on CPU%d: %02x(%02x)\n",
 		smp_processor_id(), v , v1);
+
+	trace_mark(kernel_irq_exit, MARK_NOARGS);
+
 	irq_exit();
 }
 
Index: linux-2.6-lttng/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/cpu/mcheck/mce_intel_64.c	2007-12-05 21:05:48.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/cpu/mcheck/mce_intel_64.c	2007-12-05 21:48:58.000000000 -0500
@@ -22,11 +22,17 @@ asmlinkage void smp_thermal_interrupt(vo
 	exit_idle();
 	irq_enter();
 
+	trace_mark(kernel_irq_entry, "irq_id %u kernel_mode %u",
+		THERMAL_APIC_VECTOR, -1);
+
 	rdmsrl(MSR_IA32_THERM_STATUS, msr_val);
 	if (therm_throt_process(msr_val & 1))
 		mce_log_therm_throt_event(smp_processor_id(), msr_val);
 
 	add_pda(irq_thermal_count, 1);
+
+	trace_mark(kernel_irq_exit, MARK_NOARGS);
+
 	irq_exit();
 }
 
Index: linux-2.6-lttng/arch/x86/kernel/smp_64.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/smp_64.c	2007-12-05 21:05:48.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/smp_64.c	2007-12-05 21:48:58.000000000 -0500
@@ -151,6 +151,9 @@ asmlinkage void smp_invalidate_interrupt
 		 * BUG();
 		 */
 		 
+	trace_mark(kernel_irq_entry, "irq_id %u kernel_mode %u",
+		sender, (regs)?(!user_mode(regs)):(1));
+
 	if (f->flush_mm == read_pda(active_mm)) {
 		if (read_pda(mmu_state) == TLBSTATE_OK) {
 			if (f->flush_va == FLUSH_ALL)
@@ -164,6 +167,8 @@ out:
 	ack_APIC_irq();
 	cpu_clear(cpu, f->flush_cpumask);
 	add_pda(irq_tlb_count, 1);
+
+	trace_mark(kernel_irq_exit, MARK_NOARGS);
 }
 
 static void flush_tlb_others(cpumask_t cpumask, struct mm_struct *mm,
@@ -501,7 +506,13 @@ void smp_send_stop(void)
 asmlinkage void smp_reschedule_interrupt(void)
 {
 	ack_APIC_irq();
+
+	trace_mark(kernel_irq_entry, "irq_id %u kernel_mode %u",
+		RESCHEDULE_VECTOR, -1);
+
 	add_pda(irq_resched_count, 1);
+
+	trace_mark(kernel_irq_exit, MARK_NOARGS);
 }
 
 asmlinkage void smp_call_function_interrupt(void)
@@ -522,8 +533,15 @@ asmlinkage void smp_call_function_interr
 	 */
 	exit_idle();
 	irq_enter();
+
+	trace_mark(kernel_irq_entry, "irq_id %u kernel_mode %u",
+		CALL_FUNCTION_VECTOR, -1);
+
 	(*func)(info);
 	add_pda(irq_call_count, 1);
+
+	trace_mark(kernel_irq_exit, MARK_NOARGS);
+
 	irq_exit();
 	if (wait) {
 		mb();

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
