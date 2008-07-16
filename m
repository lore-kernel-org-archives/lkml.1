Return-Path: <linux-kernel-owner+w=401wt.eu-S1759729AbYGPXF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759729AbYGPXF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 19:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759839AbYGPXF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 19:05:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759780AbYGPXFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 19:05:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 3/4] x86 ptrace: unify syscall tracing
In-Reply-To: Roland McGrath's message of  Wednesday, 16 July 2008 16:02:17 -0700 <20080716230217.3C25715410D@magilla.localdomain>
References: <20080716230217.3C25715410D@magilla.localdomain>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080716230520.5C9BB15410D@magilla.localdomain>
Date: Wed, 16 Jul 2008 16:05:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This unifies and cleans up the syscall tracing code on i386 and x86_64.

Using a single function for entry and exit tracing on 32-bit made the
do_syscall_trace() into some terrible spaghetti.  The logic is clear and
simple using separate syscall_trace_enter() and syscall_trace_leave()
functions as on 64-bit.

The unification adds PTRACE_SYSEMU and PTRACE_SYSEMU_SINGLESTEP support
on x86_64, for 32-bit ptrace() callers and for 64-bit ptrace() callers
tracing either 32-bit or 64-bit tasks.  It behaves just like 32-bit.

Changing syscall_trace_enter() to return the syscall number shortens
all the assembly paths, while adding the SYSEMU feature in a simple way.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/ia32/ia32entry.S     |   17 +++---
 arch/x86/kernel/entry_32.S    |   19 ++----
 arch/x86/kernel/entry_64.S    |   14 +++--
 arch/x86/kernel/ptrace.c      |  141 +++++++++++++---------------------------
 include/asm-x86/calling.h     |    6 +-
 include/asm-x86/ptrace-abi.h  |    6 +-
 include/asm-x86/thread_info.h |   17 +++--
 7 files changed, 88 insertions(+), 132 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 20371d0..8796d19 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -37,6 +37,11 @@
 	movq	%rax,R8(%rsp)
 	.endm
 
+	/*
+	 * Reload arg registers from stack in case ptrace changed them.
+	 * We don't reload %eax because syscall_trace_enter() returned
+	 * the value it wants us to use in the table lookup.
+	 */
 	.macro LOAD_ARGS32 offset
 	movl \offset(%rsp),%r11d
 	movl \offset+8(%rsp),%r10d
@@ -46,7 +51,6 @@
 	movl \offset+48(%rsp),%edx
 	movl \offset+56(%rsp),%esi
 	movl \offset+64(%rsp),%edi
-	movl \offset+72(%rsp),%eax
 	.endm
 	
 	.macro CFI_STARTPROC32 simple
@@ -137,13 +141,12 @@ ENTRY(ia32_sysenter_target)
  	.previous	
 	GET_THREAD_INFO(%r10)
 	orl    $TS_COMPAT,TI_status(%r10)
-	testl  $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP), \
-		 TI_flags(%r10)
+	testl  $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
 	CFI_REMEMBER_STATE
 	jnz  sysenter_tracesys
-sysenter_do_call:	
 	cmpl	$(IA32_NR_syscalls-1),%eax
 	ja	ia32_badsys
+sysenter_do_call:
 	IA32_ARG_FIXUP 1
 	call	*ia32_sys_call_table(,%rax,8)
 	movq	%rax,RAX-ARGOFFSET(%rsp)
@@ -242,8 +245,7 @@ ENTRY(ia32_cstar_target)
 	.previous	
 	GET_THREAD_INFO(%r10)
 	orl   $TS_COMPAT,TI_status(%r10)
-	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP), \
-		TI_flags(%r10)
+	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
 	CFI_REMEMBER_STATE
 	jnz   cstar_tracesys
 cstar_do_call:	
@@ -336,8 +338,7 @@ ENTRY(ia32_syscall)
 	SAVE_ARGS 0,0,1
 	GET_THREAD_INFO(%r10)
 	orl   $TS_COMPAT,TI_status(%r10)
-	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP), \
-		TI_flags(%r10)
+	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
 	jnz ia32_tracesys
 ia32_do_syscall:	
 	cmpl $(IA32_NR_syscalls-1),%eax
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 0ad987d..cadf73f 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -332,7 +332,7 @@ sysenter_past_esp:
 	GET_THREAD_INFO(%ebp)
 
 	/* Note, _TIF_SECCOMP is bit number 8, and so it needs testw and not testb */
-	testw $(_TIF_SYSCALL_EMU|_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT),TI_flags(%ebp)
+	testw $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%ebp)
 	jnz syscall_trace_entry
 	cmpl $(nr_syscalls), %eax
 	jae syscall_badsys
@@ -370,7 +370,7 @@ ENTRY(system_call)
 	GET_THREAD_INFO(%ebp)
 					# system call tracing in operation / emulation
 	/* Note, _TIF_SECCOMP is bit number 8, and so it needs testw and not testb */
-	testw $(_TIF_SYSCALL_EMU|_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT),TI_flags(%ebp)
+	testw $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%ebp)
 	jnz syscall_trace_entry
 	cmpl $(nr_syscalls), %eax
 	jae syscall_badsys
@@ -510,12 +510,8 @@ END(work_pending)
 syscall_trace_entry:
 	movl $-ENOSYS,PT_EAX(%esp)
 	movl %esp, %eax
-	xorl %edx,%edx
-	call do_syscall_trace
-	cmpl $0, %eax
-	jne resume_userspace		# ret != 0 -> running under PTRACE_SYSEMU,
-					# so must skip actual syscall
-	movl PT_ORIG_EAX(%esp), %eax
+	call syscall_trace_enter
+	/* What it returned is what we'll actually use.  */
 	cmpl $(nr_syscalls), %eax
 	jnae syscall_call
 	jmp syscall_exit
@@ -524,14 +520,13 @@ END(syscall_trace_entry)
 	# perform syscall exit tracing
 	ALIGN
 syscall_exit_work:
-	testb $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SINGLESTEP), %cl
+	testb $_TIF_WORK_SYSCALL_EXIT, %cl
 	jz work_pending
 	TRACE_IRQS_ON
-	ENABLE_INTERRUPTS(CLBR_ANY)	# could let do_syscall_trace() call
+	ENABLE_INTERRUPTS(CLBR_ANY)	# could let syscall_trace_leave() call
 					# schedule() instead
 	movl %esp, %eax
-	movl $1, %edx
-	call do_syscall_trace
+	call syscall_trace_leave
 	jmp resume_userspace
 END(syscall_exit_work)
 	CFI_ENDPROC
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index ae63e58..63001c6 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -349,8 +349,7 @@ ENTRY(system_call_after_swapgs)
 	movq  %rcx,RIP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rip,RIP-ARGOFFSET
 	GET_THREAD_INFO(%rcx)
-	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP), \
-		TI_flags(%rcx)
+	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%rcx)
 	jnz tracesys
 	cmpq $__NR_syscall_max,%rax
 	ja badsys
@@ -430,7 +429,12 @@ tracesys:
 	FIXUP_TOP_OF_STACK %rdi
 	movq %rsp,%rdi
 	call syscall_trace_enter
-	LOAD_ARGS ARGOFFSET  /* reload args from stack in case ptrace changed it */
+	/*
+	 * Reload arg registers from stack in case ptrace changed them.
+	 * We don't reload %rax because syscall_trace_enter() returned
+	 * the value it wants us to use in the table lookup.
+	 */
+	LOAD_ARGS ARGOFFSET, 1
 	RESTORE_REST
 	cmpq $__NR_syscall_max,%rax
 	ja   int_ret_from_sys_call	/* RAX(%rsp) set to -ENOSYS above */
@@ -483,7 +487,7 @@ int_very_careful:
 	ENABLE_INTERRUPTS(CLBR_NONE)
 	SAVE_REST
 	/* Check for syscall exit trace */	
-	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SINGLESTEP),%edx
+	testl $_TIF_WORK_SYSCALL_EXIT,%edx
 	jz int_signal
 	pushq %rdi
 	CFI_ADJUST_CFA_OFFSET 8
@@ -491,7 +495,7 @@ int_very_careful:
 	call syscall_trace_leave
 	popq %rdi
 	CFI_ADJUST_CFA_OFFSET -8
-	andl $~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SINGLESTEP),%edi
+	andl $~(_TIF_WORK_SYSCALL_EXIT|_TIF_SYSCALL_EMU),%edi
 	jmp int_restore_rest
 	
 int_signal:
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 77040b6..34e77b1 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1357,8 +1357,6 @@ const struct user_regset_view *task_user_regset_view(struct task_struct *task)
 #endif
 }
 
-#ifdef CONFIG_X86_32
-
 void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs, int error_code)
 {
 	struct siginfo info;
@@ -1377,89 +1375,10 @@ void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs, int error_code)
 	force_sig_info(SIGTRAP, &info, tsk);
 }
 
-/* notification of system call entry/exit
- * - triggered by current->work.syscall_trace
- */
-int do_syscall_trace(struct pt_regs *regs, int entryexit)
-{
-	int is_sysemu = test_thread_flag(TIF_SYSCALL_EMU);
-	/*
-	 * With TIF_SYSCALL_EMU set we want to ignore TIF_SINGLESTEP for syscall
-	 * interception
-	 */
-	int is_singlestep = !is_sysemu && test_thread_flag(TIF_SINGLESTEP);
-	int ret = 0;
-
-	/* do the secure computing check first */
-	if (!entryexit)
-		secure_computing(regs->orig_ax);
-
-	if (unlikely(current->audit_context)) {
-		if (entryexit)
-			audit_syscall_exit(AUDITSC_RESULT(regs->ax),
-						regs->ax);
-		/* Debug traps, when using PTRACE_SINGLESTEP, must be sent only
-		 * on the syscall exit path. Normally, when TIF_SYSCALL_AUDIT is
-		 * not used, entry.S will call us only on syscall exit, not
-		 * entry; so when TIF_SYSCALL_AUDIT is used we must avoid
-		 * calling send_sigtrap() on syscall entry.
-		 *
-		 * Note that when PTRACE_SYSEMU_SINGLESTEP is used,
-		 * is_singlestep is false, despite his name, so we will still do
-		 * the correct thing.
-		 */
-		else if (is_singlestep)
-			goto out;
-	}
-
-	if (!(current->ptrace & PT_PTRACED))
-		goto out;
-
-	/* If a process stops on the 1st tracepoint with SYSCALL_TRACE
-	 * and then is resumed with SYSEMU_SINGLESTEP, it will come in
-	 * here. We have to check this and return */
-	if (is_sysemu && entryexit)
-		return 0;
-
-	/* Fake a debug trap */
-	if (is_singlestep)
-		send_sigtrap(current, regs, 0);
-
- 	if (!test_thread_flag(TIF_SYSCALL_TRACE) && !is_sysemu)
-		goto out;
-
-	/* the 0x80 provides a way for the tracing parent to distinguish
-	   between a syscall stop and SIGTRAP delivery */
-	/* Note that the debugger could change the result of test_thread_flag!*/
-	ptrace_notify(SIGTRAP | ((current->ptrace & PT_TRACESYSGOOD) ? 0x80:0));
-
-	/*
-	 * this isn't the same as continuing with a signal, but it will do
-	 * for normal use.  strace only continues with a signal if the
-	 * stopping signal is not SIGTRAP.  -brl
-	 */
-	if (current->exit_code) {
-		send_sig(current->exit_code, current, 1);
-		current->exit_code = 0;
-	}
-	ret = is_sysemu;
-out:
-	if (unlikely(current->audit_context) && !entryexit)
-		audit_syscall_entry(AUDIT_ARCH_I386, regs->orig_ax,
-				    regs->bx, regs->cx, regs->dx, regs->si);
-	if (ret == 0)
-		return 0;
-
-	regs->orig_ax = -1; /* force skip of syscall restarting */
-	if (unlikely(current->audit_context))
-		audit_syscall_exit(AUDITSC_RESULT(regs->ax), regs->ax);
-	return 1;
-}
-
-#else  /* CONFIG_X86_64 */
-
 static void syscall_trace(struct pt_regs *regs)
 {
+	if (!(current->ptrace & PT_PTRACED))
+		return;
 
 #if 0
 	printk("trace %s ip %lx sp %lx ax %d origrax %d caller %lx tiflags %x ptrace %x\n",
@@ -1481,39 +1400,71 @@ static void syscall_trace(struct pt_regs *regs)
 	}
 }
 
-asmlinkage void syscall_trace_enter(struct pt_regs *regs)
+#ifdef CONFIG_X86_32
+# define IS_IA32	1
+#elif defined CONFIG_IA32_EMULATION
+# define IS_IA32	test_thread_flag(TIF_IA32)
+#else
+# define IS_IA32	0
+#endif
+
+/*
+ * We must return the syscall number to actually look up in the table.
+ * This can be -1L to skip running any syscall at all.
+ */
+asmregparm long syscall_trace_enter(struct pt_regs *regs)
 {
+	long ret = 0;
+
 	/* do the secure computing check first */
 	secure_computing(regs->orig_ax);
 
-	if (test_thread_flag(TIF_SYSCALL_TRACE)
-	    && (current->ptrace & PT_PTRACED))
+	if (unlikely(test_thread_flag(TIF_SYSCALL_EMU)))
+		ret = -1L;
+
+	if (ret || test_thread_flag(TIF_SYSCALL_TRACE))
 		syscall_trace(regs);
 
 	if (unlikely(current->audit_context)) {
-		if (test_thread_flag(TIF_IA32)) {
+		if (IS_IA32)
 			audit_syscall_entry(AUDIT_ARCH_I386,
 					    regs->orig_ax,
 					    regs->bx, regs->cx,
 					    regs->dx, regs->si);
-		} else {
+#ifdef CONFIG_X86_64
+		else
 			audit_syscall_entry(AUDIT_ARCH_X86_64,
 					    regs->orig_ax,
 					    regs->di, regs->si,
 					    regs->dx, regs->r10);
-		}
+#endif
 	}
+
+	return ret ?: regs->orig_ax;
 }
 
-asmlinkage void syscall_trace_leave(struct pt_regs *regs)
+asmregparm void syscall_trace_leave(struct pt_regs *regs)
 {
 	if (unlikely(current->audit_context))
 		audit_syscall_exit(AUDITSC_RESULT(regs->ax), regs->ax);
 
-	if ((test_thread_flag(TIF_SYSCALL_TRACE)
-	     || test_thread_flag(TIF_SINGLESTEP))
-	    && (current->ptrace & PT_PTRACED))
+	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		syscall_trace(regs);
-}
 
-#endif	/* CONFIG_X86_32 */
+	/*
+	 * If TIF_SYSCALL_EMU is set, we only get here because of
+	 * TIF_SINGLESTEP (i.e. this is PTRACE_SYSEMU_SINGLESTEP).
+	 * We already reported this syscall instruction in
+	 * syscall_trace_enter(), so don't do any more now.
+	 */
+	if (unlikely(test_thread_flag(TIF_SYSCALL_EMU)))
+		return;
+
+	/*
+	 * If we are single-stepping, synthesize a trap to follow the
+	 * system call instruction.
+	 */
+	if (test_thread_flag(TIF_SINGLESTEP) &&
+	    (current->ptrace & PT_PTRACED))
+		send_sigtrap(current, regs, 0);
+}
diff --git a/include/asm-x86/calling.h b/include/asm-x86/calling.h
index f13e62e..2bc162e 100644
--- a/include/asm-x86/calling.h
+++ b/include/asm-x86/calling.h
@@ -104,7 +104,7 @@
 	.endif
 	.endm
 
-	.macro LOAD_ARGS offset
+	.macro LOAD_ARGS offset, skiprax=0
 	movq \offset(%rsp),    %r11
 	movq \offset+8(%rsp),  %r10
 	movq \offset+16(%rsp), %r9
@@ -113,7 +113,10 @@
 	movq \offset+48(%rsp), %rdx
 	movq \offset+56(%rsp), %rsi
 	movq \offset+64(%rsp), %rdi
+	.if \skiprax
+	.else
 	movq \offset+72(%rsp), %rax
+	.endif
 	.endm
 
 #define REST_SKIP	6*8
@@ -165,4 +168,3 @@
 	.macro icebp
 	.byte 0xf1
 	.endm
-
diff --git a/include/asm-x86/ptrace-abi.h b/include/asm-x86/ptrace-abi.h
index f224eb3..72e7b9d 100644
--- a/include/asm-x86/ptrace-abi.h
+++ b/include/asm-x86/ptrace-abi.h
@@ -73,11 +73,11 @@
 
 #ifdef __x86_64__
 # define PTRACE_ARCH_PRCTL	  30
-#else
-# define PTRACE_SYSEMU		  31
-# define PTRACE_SYSEMU_SINGLESTEP 32
 #endif
 
+#define PTRACE_SYSEMU		  31
+#define PTRACE_SYSEMU_SINGLESTEP  32
+
 #define PTRACE_SINGLEBLOCK	33	/* resume execution until next branch */
 
 #ifndef __ASSEMBLY__
diff --git a/include/asm-x86/thread_info.h b/include/asm-x86/thread_info.h
index fb8d3cd..b2702a1 100644
--- a/include/asm-x86/thread_info.h
+++ b/include/asm-x86/thread_info.h
@@ -75,9 +75,7 @@ struct thread_info {
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_SINGLESTEP		4	/* reenable singlestep on user return*/
 #define TIF_IRET		5	/* force IRET */
-#ifdef CONFIG_X86_32
 #define TIF_SYSCALL_EMU		6	/* syscall emulation active */
-#endif
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
 #define TIF_SECCOMP		8	/* secure computing */
 #define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
@@ -100,11 +98,7 @@ struct thread_info {
 #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_IRET		(1 << TIF_IRET)
-#ifdef CONFIG_X86_32
 #define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
-#else
-#define _TIF_SYSCALL_EMU	0
-#endif
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_MCE_NOTIFY		(1 << TIF_MCE_NOTIFY)
@@ -121,11 +115,20 @@ struct thread_info {
 #define _TIF_DS_AREA_MSR	(1 << TIF_DS_AREA_MSR)
 #define _TIF_BTS_TRACE_TS	(1 << TIF_BTS_TRACE_TS)
 
+/* work to do in syscall_trace_enter() */
+#define _TIF_WORK_SYSCALL_ENTRY	\
+	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_EMU | \
+	 _TIF_SYSCALL_AUDIT | _TIF_SECCOMP)
+
+/* work to do in syscall_trace_leave() */
+#define _TIF_WORK_SYSCALL_EXIT	\
+	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | _TIF_SINGLESTEP)
+
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK							\
 	(0x0000FFFF &							\
 	 ~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|			\
-	 _TIF_SECCOMP|_TIF_SYSCALL_EMU))
+	   _TIF_SINGLESTEP|_TIF_SECCOMP|_TIF_SYSCALL_EMU))
 
 /* work to do on any return to user space */
 #define _TIF_ALLWORK_MASK (0x0000FFFF & ~_TIF_SECCOMP)
