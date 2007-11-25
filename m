Return-Path: <linux-kernel-owner+w=401wt.eu-S1758072AbXKYWBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072AbXKYWBh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757513AbXKYWAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:00:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757439AbXKYWAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:00:50 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 09/27] x86 single_step: TIF_FORCED_TF
In-Reply-To: Roland McGrath's message of  Sunday, 25 November 2007 13:55:07 -0800 <20071125215507.4B89226F8C5@magilla.localdomain>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20071125220045.18CA826F8C5@magilla.localdomain>
Date: Sun, 25 Nov 2007 14:00:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This changes the single-step support to use a new thread_info flag
TIF_FORCED_TF instead of the PT_DTRACE flag in task_struct.ptrace.
This keeps arch implementation uses out of this non-arch field.

This changes the ptrace access to eflags to mask TF and maintain
the TIF_FORCED_TF flag directly if userland sets TF, instead of
relying on ptrace_signal_deliver.  The 64-bit and 32-bit kernels
are harmonized on this same behavior.  The ptrace_signal_deliver
approach works now, but this change makes the low-level register
access code reliable when called from different contexts than a
ptrace stop, which will be possible in the future.

The 64-bit do_debug exception handler is also changed not to clear TF
from user-mode registers.  This matches the 32-bit kernel's behavior.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/ia32/ptrace32.c         |   20 ++++++++++++++++++--
 arch/x86/kernel/process_32.c     |    3 ---
 arch/x86/kernel/process_64.c     |    5 -----
 arch/x86/kernel/ptrace_32.c      |   17 +++++++++++++++++
 arch/x86/kernel/ptrace_64.c      |   20 ++++++++++++++++++++
 arch/x86/kernel/signal_32.c      |   12 +++++-------
 arch/x86/kernel/signal_64.c      |   14 +++++---------
 arch/x86/kernel/step.c           |    9 +++------
 arch/x86/kernel/traps_64.c       |   23 +++++------------------
 include/asm-x86/signal.h         |   11 ++---------
 include/asm-x86/thread_info_32.h |    2 ++
 include/asm-x86/thread_info_64.h |    3 ++-
 12 files changed, 79 insertions(+), 60 deletions(-)

diff --git a/arch/x86/ia32/ptrace32.c b/arch/x86/ia32/ptrace32.c
index 4a233ad..a9a5cd4 100644
--- a/arch/x86/ia32/ptrace32.c
+++ b/arch/x86/ia32/ptrace32.c
@@ -82,6 +82,15 @@ static int putreg32(struct task_struct *child, unsigned regno, u32 val)
 	case offsetof(struct user32, regs.eflags): {
 		__u64 *flags = &stack[offsetof(struct pt_regs, eflags)/8];
 		val &= FLAG_MASK;
+		/*
+		 * If the user value contains TF, mark that
+		 * it was not "us" (the debugger) that set it.
+		 * If not, make sure it stays set if we had.
+		 */
+		if (val & X86_EFLAGS_TF)
+			clear_tsk_thread_flag(child, TIF_FORCED_TF);
+		else if (test_tsk_thread_flag(child, TIF_FORCED_TF))
+			val |= X86_EFLAGS_TF;
 		*flags = val | (*flags & ~FLAG_MASK);
 		break;
 	}
@@ -168,9 +177,17 @@ static int getreg32(struct task_struct *child, unsigned regno, u32 *val)
 	R32(eax, rax);
 	R32(orig_eax, orig_rax);
 	R32(eip, rip);
-	R32(eflags, eflags);
 	R32(esp, rsp);
 
+	case offsetof(struct user32, regs.eflags):
+		/*
+		 * If the debugger set TF, hide it from the readout.
+		 */
+		*val = stack[offsetof(struct pt_regs, eflags)/8];
+		if (test_tsk_thread_flag(child, TIF_FORCED_TF))
+			*val &= ~X86_EFLAGS_TF;
+		break;
+
 	case offsetof(struct user32, u_debugreg[0]): 
 		*val = child->thread.debugreg0; 
 		break; 
@@ -401,4 +418,3 @@ asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 	put_task_struct(child);
 	return ret;
 }
-
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index ebbbfc5..f59544e 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -796,9 +796,6 @@ asmlinkage int sys_execve(struct pt_regs regs)
 			(char __user * __user *) regs.edx,
 			&regs);
 	if (error == 0) {
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
 		/* Make sure we don't return using sysenter.. */
 		set_thread_flag(TIF_IRET);
 	}
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 3fdbf78..586f88e 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -698,11 +698,6 @@ long sys_execve(char __user *name, char __user * __user *argv,
 	if (IS_ERR(filename))
 		return error;
 	error = do_execve(filename, argv, envp, &regs);
-	if (error == 0) {
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
-	}
 	putname(filename);
 	return error;
 }
diff --git a/arch/x86/kernel/ptrace_32.c b/arch/x86/kernel/ptrace_32.c
index e599db5..a493017 100644
--- a/arch/x86/kernel/ptrace_32.c
+++ b/arch/x86/kernel/ptrace_32.c
@@ -104,6 +104,15 @@ static int putreg(struct task_struct *child,
 			break;
 		case EFL:
 			value &= FLAG_MASK;
+			/*
+			 * If the user value contains TF, mark that
+			 * it was not "us" (the debugger) that set it.
+			 * If not, make sure it stays set if we had.
+			 */
+			if (value & X86_EFLAGS_TF)
+				clear_tsk_thread_flag(child, TIF_FORCED_TF);
+			else if (test_tsk_thread_flag(child, TIF_FORCED_TF))
+				value |= X86_EFLAGS_TF;
 			value |= get_stack_long(child, EFL_OFFSET) & ~FLAG_MASK;
 			break;
 	}
@@ -119,6 +128,14 @@ static unsigned long getreg(struct task_struct *child,
 	unsigned long retval = ~0UL;
 
 	switch (regno >> 2) {
+		case EFL:
+			/*
+			 * If the debugger set TF, hide it from the readout.
+			 */
+			retval = get_stack_long(child, EFL_OFFSET);
+			if (test_tsk_thread_flag(child, TIF_FORCED_TF))
+				retval &= ~X86_EFLAGS_TF;
+			break;
 		case GS:
 			retval = child->thread.gs;
 			break;
diff --git a/arch/x86/kernel/ptrace_64.c b/arch/x86/kernel/ptrace_64.c
index 52479b1..d8453da 100644
--- a/arch/x86/kernel/ptrace_64.c
+++ b/arch/x86/kernel/ptrace_64.c
@@ -143,6 +143,15 @@ static int putreg(struct task_struct *child,
 			return 0;
 		case offsetof(struct user_regs_struct, eflags):
 			value &= FLAG_MASK;
+			/*
+			 * If the user value contains TF, mark that
+			 * it was not "us" (the debugger) that set it.
+			 * If not, make sure it stays set if we had.
+			 */
+			if (value & X86_EFLAGS_TF)
+				clear_tsk_thread_flag(child, TIF_FORCED_TF);
+			else if (test_tsk_thread_flag(child, TIF_FORCED_TF))
+				value |= X86_EFLAGS_TF;
 			tmp = get_stack_long(child, EFL_OFFSET);
 			tmp &= ~FLAG_MASK;
 			value |= tmp;
@@ -189,6 +198,17 @@ static unsigned long getreg(struct task_struct *child, unsigned long regno)
 			if (child->thread.gsindex != GS_TLS_SEL)
 				return 0;
 			return get_desc_base(&child->thread.tls_array[GS_TLS]);
+		case offsetof(struct user_regs_struct, eflags):
+			/*
+			 * If the debugger set TF, hide it from the readout.
+			 */
+			regno = regno - sizeof(struct pt_regs);
+			val = get_stack_long(child, regno);
+			if (test_tsk_thread_flag(child, TIF_IA32))
+				val &= 0xffffffff;
+			if (test_tsk_thread_flag(child, TIF_FORCED_TF))
+				val &= ~X86_EFLAGS_TF;
+			return val;
 		default:
 			regno = regno - sizeof(struct pt_regs);
 			val = get_stack_long(child, regno);
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index 9bdd830..d58d455 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -537,14 +537,12 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	}
 
 	/*
-	 * If TF is set due to a debugger (PT_DTRACE), clear the TF flag so
-	 * that register information in the sigcontext is correct.
+	 * If TF is set due to a debugger (TIF_FORCED_TF), clear the TF
+	 * flag so that register information in the sigcontext is correct.
 	 */
-	if (unlikely(regs->eflags & TF_MASK)
-	    && likely(current->ptrace & PT_DTRACE)) {
-		current->ptrace &= ~PT_DTRACE;
-		regs->eflags &= ~TF_MASK;
-	}
+	if (unlikely(regs->eflags & X86_EFLAGS_TF) &&
+	    likely(test_and_clear_thread_flag(TIF_FORCED_TF)))
+		regs->eflags &= ~X86_EFLAGS_TF;
 
 	/* Set up the stack frame */
 	if (ka->sa.sa_flags & SA_SIGINFO)
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index ab086b0..d96a8c2 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -349,16 +349,12 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	}
 
 	/*
-	 * If TF is set due to a debugger (PT_DTRACE), clear the TF
-	 * flag so that register information in the sigcontext is
-	 * correct.
+	 * If TF is set due to a debugger (TIF_FORCED_TF), clear the TF
+	 * flag so that register information in the sigcontext is correct.
 	 */
-	if (unlikely(regs->eflags & TF_MASK)) {
-		if (likely(current->ptrace & PT_DTRACE)) {
-			current->ptrace &= ~PT_DTRACE;
-			regs->eflags &= ~TF_MASK;
-		}
-	}
+	if (unlikely(regs->eflags & X86_EFLAGS_TF) &&
+	    likely(test_and_clear_thread_flag(TIF_FORCED_TF)))
+		regs->eflags &= ~X86_EFLAGS_TF;
 
 #ifdef CONFIG_IA32_EMULATION
 	if (test_thread_flag(TIF_IA32)) {
diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
index 6732272..243bff6 100644
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -135,7 +135,7 @@ void user_enable_single_step(struct task_struct *child)
 	if (is_setting_trap_flag(child, regs))
 		return;
 
-	child->ptrace |= PT_DTRACE;
+	set_tsk_thread_flag(child, TIF_FORCED_TF);
 }
 
 void user_disable_single_step(struct task_struct *child)
@@ -144,9 +144,6 @@ void user_disable_single_step(struct task_struct *child)
 	clear_tsk_thread_flag(child, TIF_SINGLESTEP);
 
 	/* But touch TF only if it was set by us.. */
-	if (child->ptrace & PT_DTRACE) {
-		struct pt_regs *regs = task_pt_regs(child);
-		regs->eflags &= ~X86_EFLAGS_TF;
-		child->ptrace &= ~PT_DTRACE;
-	}
+	if (test_and_clear_tsk_thread_flag(child, TIF_FORCED_TF))
+		task_pt_regs(child)->eflags &= ~X86_EFLAGS_TF;
 }
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 4a6bd49..daf35a8 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -863,27 +863,14 @@ asmlinkage void __kprobes do_debug(struct pt_regs * regs,
 
 	tsk->thread.debugreg6 = condition;
 
-	/* Mask out spurious TF errors due to lazy TF clearing */
+
+	/*
+	 * Single-stepping through TF: make sure we ignore any events in
+	 * kernel space (but re-enable TF when returning to user mode).
+	 */
 	if (condition & DR_STEP) {
-		/*
-		 * The TF error should be masked out only if the current
-		 * process is not traced and if the TRAP flag has been set
-		 * previously by a tracing process (condition detected by
-		 * the PT_DTRACE flag); remember that the i386 TRAP flag
-		 * can be modified by the process itself in user mode,
-		 * allowing programs to debug themselves without the ptrace()
-		 * interface.
-		 */
                 if (!user_mode(regs))
                        goto clear_TF_reenable;
-		/*
-		 * Was the TF flag set by a debugger? If so, clear it now,
-		 * so that register information is correct.
-		 */
-		if (tsk->ptrace & PT_DTRACE) {
-			regs->eflags &= ~TF_MASK;
-			tsk->ptrace &= ~PT_DTRACE;
-		}
 	}
 
 	/* Ok, finally something we can handle */
diff --git a/include/asm-x86/signal.h b/include/asm-x86/signal.h
index 987a422..aee7eca 100644
--- a/include/asm-x86/signal.h
+++ b/include/asm-x86/signal.h
@@ -245,21 +245,14 @@ static __inline__ int sigfindinword(unsigned long word)
 
 struct pt_regs;
 
-#define ptrace_signal_deliver(regs, cookie)		\
-	do {						\
-		if (current->ptrace & PT_DTRACE) {	\
-			current->ptrace &= ~PT_DTRACE;	\
-			(regs)->eflags &= ~TF_MASK;	\
-		}					\
-	} while (0)
-
 #else /* __i386__ */
 
 #undef __HAVE_ARCH_SIG_BITOPS
 
+#endif /* !__i386__ */
+
 #define ptrace_signal_deliver(regs, cookie) do { } while (0)
 
-#endif /* !__i386__ */
 #endif /* __KERNEL__ */
 #endif /* __ASSEMBLY__ */
 
diff --git a/include/asm-x86/thread_info_32.h b/include/asm-x86/thread_info_32.h
index 22a8cbc..8a6483f 100644
--- a/include/asm-x86/thread_info_32.h
+++ b/include/asm-x86/thread_info_32.h
@@ -137,6 +137,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_IO_BITMAP		18	/* uses I/O bitmap */
 #define TIF_FREEZE		19	/* is freezing for suspend */
 #define TIF_NOTSC		20	/* TSC is not accessible in userland */
+#define TIF_FORCED_TF		21	/* true if TF in eflags artificially */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
@@ -151,6 +152,7 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_IO_BITMAP		(1<<TIF_IO_BITMAP)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
 #define _TIF_NOTSC		(1<<TIF_NOTSC)
+#define _TIF_FORCED_TF		(1<<TIF_FORCED_TF)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK \
diff --git a/include/asm-x86/thread_info_64.h b/include/asm-x86/thread_info_64.h
index beae2bf..0ebcac4 100644
--- a/include/asm-x86/thread_info_64.h
+++ b/include/asm-x86/thread_info_64.h
@@ -115,7 +115,7 @@ static inline struct thread_info *stack_thread_info(void)
 #define TIF_SECCOMP		8	/* secure computing */
 #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal */
 #define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
-/* 16 free */
+#define TIF_FORCED_TF		16	/* true if TF in eflags artificially */
 #define TIF_IA32		17	/* 32bit process */ 
 #define TIF_FORK		18	/* ret_from_fork */
 #define TIF_ABI_PENDING		19
@@ -133,6 +133,7 @@ static inline struct thread_info *stack_thread_info(void)
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_MCE_NOTIFY		(1<<TIF_MCE_NOTIFY)
+#define _TIF_FORCED_TF		(1<<TIF_FORCED_TF)
 #define _TIF_IA32		(1<<TIF_IA32)
 #define _TIF_FORK		(1<<TIF_FORK)
 #define _TIF_ABI_PENDING	(1<<TIF_ABI_PENDING)
