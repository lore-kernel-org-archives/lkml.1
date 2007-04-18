Return-Path: <linux-kernel-owner+w=401wt.eu-S2992971AbXDRSEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992971AbXDRSEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 14:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992977AbXDRSEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 14:04:07 -0400
Received: from verein.lst.de ([213.95.11.210]:54928 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992971AbXDRSED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 14:04:03 -0400
Date: Wed, 18 Apr 2007 20:03:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: akpm@osdl.org, roland@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] utrace: remove indirections
Message-ID: <20070418180332.GB18485@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently generic code calls into tracehook_* which then alls into
utrace_* to do the actual work.  With utrace as the new singing dancing
framework there's little point in that, and readability would be greatly
improved by getting rid of this.  The few places where tracehook_*
was more than a one-liner and used in multiple places in arch code
I renamed the call to utrace_*.

Also kill the CONFIG_UTRACE config option, there's very little reason
in not having a core debugging mechanisms, and this allows to get rid
of another layer of wrapping again.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/arm/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/ptrace.c	2007-04-13 15:05:11.000000000 +0200
+++ linux-2.6/arch/arm/kernel/ptrace.c	2007-04-13 15:37:11.000000000 +0200
@@ -820,7 +820,7 @@ asmlinkage int syscall_trace(int why, st
 		ip = regs->ARM_ip;
 		regs->ARM_ip = why;
 
-		tracehook_report_syscall(regs, why);
+		utrace_report_syscall(regs, why);
 
 		regs->ARM_ip = ip;
 	}
Index: linux-2.6/arch/arm26/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/arm26/kernel/ptrace.c	2007-04-13 15:05:11.000000000 +0200
+++ linux-2.6/arch/arm26/kernel/ptrace.c	2007-04-13 15:37:08.000000000 +0200
@@ -661,7 +661,7 @@ asmlinkage void syscall_trace(int why, s
 		ip = regs->ARM_ip;
 		regs->ARM_ip = why;
 
-		tracehook_report_syscall(regs, why);
+		utrace_report_syscall(regs, why);
 
 		regs->ARM_ip = ip;
 	}
Index: linux-2.6/arch/frv/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/frv/kernel/ptrace.c	2007-04-13 15:05:11.000000000 +0200
+++ linux-2.6/arch/frv/kernel/ptrace.c	2007-04-13 15:37:18.000000000 +0200
@@ -706,5 +706,5 @@ asmlinkage void do_syscall_trace(int lea
 	else
 		__frame->__status |= REG__STATUS_SYSC_ENTRY;
 
-	tracehook_report_syscall(regs, leaving);
+	utrace_report_syscall(regs, leaving);
 }
Index: linux-2.6/arch/i386/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/i386/kernel/ptrace.c	2007-04-13 15:05:11.000000000 +0200
+++ linux-2.6/arch/i386/kernel/ptrace.c	2007-04-13 15:58:53.000000000 +0200
@@ -804,11 +804,10 @@ void do_syscall_trace(struct pt_regs *re
 		audit_syscall_exit(AUDITSC_RESULT(regs->eax), regs->eax);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
-		tracehook_report_syscall(regs, entryexit);
+		utrace_report_syscall(regs, entryexit);
 
 	if (test_thread_flag(TIF_SINGLESTEP) && entryexit) {
 		send_sigtrap(current, regs, 0);	/* XXX */
-		tracehook_report_syscall_step(regs);
 	}
 
 	if (unlikely(current->audit_context) && !entryexit)
Index: linux-2.6/arch/i386/kernel/signal.c
===================================================================
--- linux-2.6.orig/arch/i386/kernel/signal.c	2007-04-13 15:35:36.000000000 +0200
+++ linux-2.6/arch/i386/kernel/signal.c	2007-04-13 15:35:46.000000000 +0200
@@ -543,7 +543,7 @@ handle_signal(unsigned long sig, siginfo
 		 * handler too.
 		 */
 		regs->eflags &= ~TF_MASK;
-		tracehook_report_handle_signal(sig, ka, oldset, regs);
+		utrace_report_handle_signal(sig, ka, oldset, regs);
 	}
 
 	return ret;
Index: linux-2.6/arch/ia64/ia32/sys_ia32.c
===================================================================
--- linux-2.6.orig/arch/ia64/ia32/sys_ia32.c	2007-04-13 15:15:29.000000000 +0200
+++ linux-2.6/arch/ia64/ia32/sys_ia32.c	2007-04-13 15:58:53.000000000 +0200
@@ -1869,7 +1869,6 @@ sys32_ptrace (int request, pid_t pid, un
 }
 #endif
 
-#ifdef CONFIG_UTRACE
 typedef struct utrace_get {
 	void *kbuf;
 	void __user *ubuf;
@@ -2339,7 +2338,6 @@ const struct utrace_regset_view utrace_i
 	.regsets = ia32_regsets, .n = ARRAY_SIZE(ia32_regsets)
 };
 EXPORT_SYMBOL_GPL(utrace_ia32_view);
-#endif
 
 #ifdef CONFIG_PTRACE
 /*
Index: linux-2.6/arch/ia64/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/ptrace.c	2007-04-13 15:05:11.000000000 +0200
+++ linux-2.6/arch/ia64/kernel/ptrace.c	2007-04-13 15:58:53.000000000 +0200
@@ -726,7 +726,7 @@ syscall_trace_enter (long arg0, long arg
 		     struct pt_regs regs)
 {
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
-		tracehook_report_syscall(&regs, 0);
+		utrace_report_syscall(&regs, 0);
 
 	if (unlikely(current->audit_context)) {
 		long syscall;
@@ -762,17 +762,14 @@ syscall_trace_leave (long arg0, long arg
 	}
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
-		tracehook_report_syscall(&regs, 1);
+		utrace_report_syscall(&regs, 1);
 
 	if (test_thread_flag(TIF_SINGLESTEP)) {
 		force_sig(SIGTRAP, current); /* XXX */
-		tracehook_report_syscall_step(&regs);
 	}
 }
 
 
-#ifdef CONFIG_UTRACE
-
 /* Utrace implementation starts here */
 
 typedef struct utrace_get {
@@ -1552,9 +1549,6 @@ const struct utrace_regset_view utrace_i
 };
 EXPORT_SYMBOL_GPL(utrace_ia64_native);
 
-#endif	/* CONFIG_UTRACE */
-
-
 #ifdef CONFIG_PTRACE
 
 #define WORD(member, num) \
Index: linux-2.6/arch/ia64/kernel/signal.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/signal.c	2007-04-13 15:35:36.000000000 +0200
+++ linux-2.6/arch/ia64/kernel/signal.c	2007-04-13 15:35:58.000000000 +0200
@@ -472,7 +472,7 @@ handle_signal (unsigned long sig, struct
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 
-	tracehook_report_handle_signal(sig, ka, oldset, &scr->pt);
+	utrace_report_handle_signal(sig, ka, oldset, &scr->pt);
 	return 1;
 }
 
Index: linux-2.6/arch/mips/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/ptrace.c	2007-04-13 15:05:11.000000000 +0200
+++ linux-2.6/arch/mips/kernel/ptrace.c	2007-04-13 15:37:59.000000000 +0200
@@ -488,7 +488,7 @@ asmlinkage void do_syscall_trace(struct 
 		                   regs->regs[2]);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
-		tracehook_report_syscall(regs, entryexit);
+		utrace_report_syscall(regs, entryexit);
 
 	if (unlikely(current->audit_context) && !entryexit)
 		audit_syscall_entry(audit_arch(), regs->regs[2],
Index: linux-2.6/arch/powerpc/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/ptrace.c	2007-04-13 15:05:11.000000000 +0200
+++ linux-2.6/arch/powerpc/kernel/ptrace.c	2007-04-13 15:58:53.000000000 +0200
@@ -710,7 +710,7 @@ void do_syscall_trace_enter(struct pt_re
 	secure_computing(regs->gpr[0]);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
-		tracehook_report_syscall(regs, 0);
+		utrace_report_syscall(regs, 0);
 
 	if (unlikely(current->audit_context)) {
 #ifdef CONFIG_PPC64
@@ -737,10 +737,9 @@ void do_syscall_trace_leave(struct pt_re
 				   regs->result);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
-		tracehook_report_syscall(regs, 1);
+		utrace_report_syscall(regs, 1);
 
 	if (test_thread_flag(TIF_SINGLESTEP)) {
 		force_sig(SIGTRAP, current); /* XXX */
-		tracehook_report_syscall_step(regs);
 	}
 }
Index: linux-2.6/arch/powerpc/kernel/signal_32.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/signal_32.c	2007-04-13 15:35:36.000000000 +0200
+++ linux-2.6/arch/powerpc/kernel/signal_32.c	2007-04-13 15:35:55.000000000 +0200
@@ -1280,7 +1280,7 @@ no_signal:
 		if (test_thread_flag(TIF_RESTORE_SIGMASK))
 			clear_thread_flag(TIF_RESTORE_SIGMASK);
 
-		tracehook_report_handle_signal(signr, &ka, oldset, regs);
+		utrace_report_handle_signal(signr, &ka, oldset, regs);
 	}
 
 	return ret;
Index: linux-2.6/arch/powerpc/kernel/signal_64.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/signal_64.c	2007-04-13 15:35:36.000000000 +0200
+++ linux-2.6/arch/powerpc/kernel/signal_64.c	2007-04-13 15:36:05.000000000 +0200
@@ -461,7 +461,7 @@ static int handle_signal(unsigned long s
 		recalc_sigpending();
 		spin_unlock_irq(&current->sighand->siglock);
 
-		tracehook_report_handle_signal(sig, ka, oldset, regs);
+		utrace_report_handle_signal(sig, ka, oldset, regs);
 	}
 
 	return ret;
Index: linux-2.6/arch/s390/kernel/compat_signal.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/compat_signal.c	2007-04-13 15:35:36.000000000 +0200
+++ linux-2.6/arch/s390/kernel/compat_signal.c	2007-04-13 15:36:08.000000000 +0200
@@ -581,7 +581,7 @@ handle_signal32(unsigned long sig, struc
 		recalc_sigpending();
 		spin_unlock_irq(&current->sighand->siglock);
 
-		tracehook_report_handle_signal(sig, ka, oldset, regs);
+		utrace_report_handle_signal(sig, ka, oldset, regs);
 	}
 
 	return ret;
Index: linux-2.6/arch/s390/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/ptrace.c	2007-04-13 15:05:11.000000000 +0200
+++ linux-2.6/arch/s390/kernel/ptrace.c	2007-04-13 15:58:53.000000000 +0200
@@ -726,7 +726,7 @@ syscall_trace(struct pt_regs *regs, int 
 		audit_syscall_exit(AUDITSC_RESULT(regs->gprs[2]), regs->gprs[2]);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE)) {
-		tracehook_report_syscall(regs, entryexit);
+		utrace_report_syscall(regs, entryexit);
 
 		/*
 		 * If the debugger has set an invalid system call number,
Index: linux-2.6/arch/s390/kernel/signal.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/signal.c	2007-04-13 15:35:37.000000000 +0200
+++ linux-2.6/arch/s390/kernel/signal.c	2007-04-13 15:36:10.000000000 +0200
@@ -397,7 +397,7 @@ handle_signal(unsigned long sig, struct 
 		recalc_sigpending();
 		spin_unlock_irq(&current->sighand->siglock);
 
-		tracehook_report_handle_signal(sig, ka, oldset, regs);
+		utrace_report_handle_signal(sig, ka, oldset, regs);
 	}
 
 	return ret;
Index: linux-2.6/arch/s390/kernel/traps.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/traps.c	2007-04-13 15:22:41.000000000 +0200
+++ linux-2.6/arch/s390/kernel/traps.c	2007-04-13 15:23:30.000000000 +0200
@@ -360,7 +360,7 @@ void __kprobes do_single_step(struct pt_
 					SIGTRAP) == NOTIFY_STOP){
 		return;
 	}
-	if (tracehook_consider_fatal_signal(current, SIGTRAP))
+	if (utrace_consider_fatal_signal(current, SIGTRAP))
 		force_sig(SIGTRAP, current);
 }
 
@@ -461,7 +461,7 @@ static void illegal_op(struct pt_regs * 
 		if (get_user(*((__u16 *) opcode), (__u16 __user *) location))
 			return;
 		if (*((__u16 *) opcode) == S390_BREAKPOINT_U16) {
-			if (tracehook_consider_fatal_signal(current, SIGTRAP))
+			if (utrace_consider_fatal_signal(current, SIGTRAP))
 				force_sig(SIGTRAP, current);
 			else
 				signal = SIGILL;
Index: linux-2.6/arch/sparc64/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/sparc64/kernel/ptrace.c	2007-04-13 15:05:12.000000000 +0200
+++ linux-2.6/arch/sparc64/kernel/ptrace.c	2007-04-13 15:58:53.000000000 +0200
@@ -789,7 +789,7 @@ asmlinkage void syscall_trace(struct pt_
 	}
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
-		tracehook_report_syscall(regs, syscall_exit_p);
+		utrace_report_syscall(regs, syscall_exit_p);
 
 	if (unlikely(current->audit_context) && !syscall_exit_p)
 		audit_syscall_entry((test_thread_flag(TIF_32BIT) ?
Index: linux-2.6/arch/sparc64/kernel/signal.c
===================================================================
--- linux-2.6.orig/arch/sparc64/kernel/signal.c	2007-04-13 15:35:37.000000000 +0200
+++ linux-2.6/arch/sparc64/kernel/signal.c	2007-04-13 15:36:12.000000000 +0200
@@ -492,7 +492,7 @@ static inline void handle_signal(unsigne
 		sigaddset(&current->blocked,signr);
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
-	tracehook_report_handle_signal(signr, ka, oldset, regs);
+	utrace_report_handle_signal(signr, ka, oldset, regs);
 }
 
 static inline void syscall_restart(unsigned long orig_i0, struct pt_regs *regs,
Index: linux-2.6/arch/sparc64/kernel/signal32.c
===================================================================
--- linux-2.6.orig/arch/sparc64/kernel/signal32.c	2007-04-13 15:35:37.000000000 +0200
+++ linux-2.6/arch/sparc64/kernel/signal32.c	2007-04-13 15:36:22.000000000 +0200
@@ -1238,7 +1238,7 @@ static inline void handle_signal32(unsig
 		sigaddset(&current->blocked,signr);
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
-	tracehook_report_handle_signal(signr, ka, oldset, regs);
+	utrace_report_handle_signal(signr, ka, oldset, regs);
 }
 
 static inline void syscall_restart32(unsigned long orig_i0, struct pt_regs *regs,
Index: linux-2.6/arch/um/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/um/kernel/ptrace.c	2007-04-13 15:05:12.000000000 +0200
+++ linux-2.6/arch/um/kernel/ptrace.c	2007-04-13 15:38:20.000000000 +0200
@@ -52,12 +52,10 @@ void do_syscall_trace(struct pt_regs *re
 				   UPT_SYSCALL_RET(&regs->regs));
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
-		tracehook_report_syscall(regs, entryexit);
+		utrace_report_syscall(regs, entryexit);
 
-	if (test_thread_flag(TIF_SINGLESTEP) && entryexit) {
+	if (test_thread_flag(TIF_SINGLESTEP) && entryexit)
 		send_sigtrap(current, regs, 0);	/* XXX */
-		tracehook_report_syscall_step(regs);
-	}
 
 	if (unlikely(current->audit_context) && !entryexit)
 		audit_syscall_entry(HOST_AUDIT_ARCH,
Index: linux-2.6/arch/um/kernel/signal.c
===================================================================
--- linux-2.6.orig/arch/um/kernel/signal.c	2007-04-13 15:35:37.000000000 +0200
+++ linux-2.6/arch/um/kernel/signal.c	2007-04-13 15:36:24.000000000 +0200
@@ -95,7 +95,7 @@ static int handle_signal(struct pt_regs 
 		recalc_sigpending();
 		spin_unlock_irq(&current->sighand->siglock);
 
-		tracehook_report_handle_signal(signr, ka, oldset, regs);
+		utrace_report_handle_signal(signr, ka, oldset, regs);
 	}
 
 	return err;
Index: linux-2.6/arch/x86_64/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/x86_64/kernel/ptrace.c	2007-04-13 15:05:12.000000000 +0200
+++ linux-2.6/arch/x86_64/kernel/ptrace.c	2007-04-13 15:58:53.000000000 +0200
@@ -758,7 +758,7 @@ asmlinkage void syscall_trace_enter(stru
 	secure_computing(regs->orig_rax);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
-		tracehook_report_syscall(regs, 0);
+		utrace_report_syscall(regs, 0);
 
 	if (unlikely(current->audit_context)) {
 		if (test_thread_flag(TIF_IA32)) {
@@ -781,10 +781,8 @@ asmlinkage void syscall_trace_leave(stru
 		audit_syscall_exit(AUDITSC_RESULT(regs->rax), regs->rax);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
-		tracehook_report_syscall(regs, 1);
+		utrace_report_syscall(regs, 1);
 
-	if (test_thread_flag(TIF_SINGLESTEP)) {
+	if (test_thread_flag(TIF_SINGLESTEP))
 		force_sig(SIGTRAP, current); /* XXX */
-		tracehook_report_syscall_step(regs);
-	}
 }
Index: linux-2.6/arch/x86_64/kernel/signal.c
===================================================================
--- linux-2.6.orig/arch/x86_64/kernel/signal.c	2007-04-13 15:35:37.000000000 +0200
+++ linux-2.6/arch/x86_64/kernel/signal.c	2007-04-13 15:36:26.000000000 +0200
@@ -380,7 +380,7 @@ handle_signal(unsigned long sig, siginfo
 		 * handler too.
 		 */
 		regs->eflags &= ~TF_MASK;
-		tracehook_report_handle_signal(sig, ka, oldset, regs);
+		utrace_report_handle_signal(sig, ka, oldset, regs);
 	}
 
 	return ret;
Index: linux-2.6/arch/x86_64/mm/fault.c
===================================================================
--- linux-2.6.orig/arch/x86_64/mm/fault.c	2007-04-13 15:22:41.000000000 +0200
+++ linux-2.6/arch/x86_64/mm/fault.c	2007-04-13 15:23:37.000000000 +0200
@@ -225,7 +225,7 @@ int unhandled_signal(struct task_struct 
 {
 	if (is_init(tsk))
 		return 1;
-	if (tracehook_consider_fatal_signal(tsk, sig))
+	if (utrace_consider_fatal_signal(tsk, sig))
 		return 0;
 	return (tsk->sighand->action[sig-1].sa.sa_handler == SIG_IGN) ||
 		(tsk->sighand->action[sig-1].sa.sa_handler == SIG_DFL);
Index: linux-2.6/fs/exec.c
===================================================================
--- linux-2.6.orig/fs/exec.c	2007-04-13 14:59:56.000000000 +0200
+++ linux-2.6/fs/exec.c	2007-04-13 15:14:47.000000000 +0200
@@ -953,7 +953,11 @@ EXPORT_SYMBOL(prepare_binprm);
 
 static int unsafe_exec(struct task_struct *p)
 {
-	int unsafe = tracehook_unsafe_exec(p);
+	int unsafe = 0;
+
+	if (p->utrace_flags)
+		unsafe = utrace_unsafe_exec(p);
+
 	if (atomic_read(&p->fs->count) > 1 ||
 	    atomic_read(&p->files->count) > 1 ||
 	    atomic_read(&p->sighand->count) > 1)
@@ -1078,7 +1082,8 @@ int search_binary_handler(struct linux_b
 				bprm->file = NULL;
 				current->did_exec = 1;
 				proc_exec_connector(current);
-				tracehook_report_exec(bprm, regs);
+				if (current->utrace_flags & UTRACE_EVENT(EXEC))
+					utrace_report_exec(bprm, regs);
 				return retval;
 			}
 			read_lock(&binfmt_lock);
Index: linux-2.6/fs/proc/array.c
===================================================================
--- linux-2.6.orig/fs/proc/array.c	2007-04-13 15:24:17.000000000 +0200
+++ linux-2.6/fs/proc/array.c	2007-04-13 15:25:05.000000000 +0200
@@ -166,7 +166,7 @@ static inline char * task_state(struct t
 	struct fdtable *fdt = NULL;
 
 	rcu_read_lock();
-	tracer = tracehook_tracer_task(p);
+	tracer = p->utrace_flags ? utrace_tracer_task(p) : NULL;
 	tracer_pid = tracer == NULL ? 0 : tracer->pid;
 
 	buffer += sprintf(buffer,
Index: linux-2.6/fs/proc/base.c
===================================================================
--- linux-2.6.orig/fs/proc/base.c	2007-04-13 15:26:32.000000000 +0200
+++ linux-2.6/fs/proc/base.c	2007-04-13 15:30:44.000000000 +0200
@@ -539,6 +539,20 @@ static const struct file_operations proc
 	.read		= proc_info_read,
 };
 
+/*
+ * Return nonzero if the current task should be allowed to use
+ * access_process_vm on the given task.
+ */
+static int allow_access_process_vm(struct task_struct *tsk)
+{
+	if (tsk == current)
+		return 1;
+	if (tsk->utrace_flags)
+		return utrace_allow_access_process_vm(tsk);
+	return 0;
+}
+
+
 static int mem_open(struct inode* inode, struct file* file)
 {
 	file->private_data = (void*)((long)current->self_exec_id);
@@ -557,8 +571,7 @@ static ssize_t mem_read(struct file * fi
 	if (!task)
 		goto out_no_task;
 
-	if (!tracehook_allow_access_process_vm(task)
-	    || !ptrace_may_attach(task))
+	if (!allow_access_process_vm(task) || !ptrace_may_attach(task))
 		goto out;
 
 	ret = -ENOMEM;
@@ -584,8 +597,8 @@ static ssize_t mem_read(struct file * fi
 
 		this_len = (count > PAGE_SIZE) ? PAGE_SIZE : count;
 		retval = access_process_vm(task, src, page, this_len, 0);
-		if (!retval || !tracehook_allow_access_process_vm(task)
-		    || !ptrace_may_attach(task)) {
+		if (!retval || !allow_access_process_vm(task) ||
+		    !ptrace_may_attach(task)) {
 			if (!ret)
 				ret = -EIO;
 			break;
@@ -629,8 +642,7 @@ static ssize_t mem_write(struct file * f
 	if (!task)
 		goto out_no_task;
 
-	if (!tracehook_allow_access_process_vm(task)
-	    || !ptrace_may_attach(task))
+	if (!allow_access_process_vm(task) || !ptrace_may_attach(task))
 		goto out;
 
 	copied = -ENOMEM;
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h	2007-04-13 15:16:21.000000000 +0200
+++ linux-2.6/include/linux/sched.h	2007-04-13 15:16:25.000000000 +0200
@@ -941,10 +941,8 @@ struct task_struct {
 	struct audit_context *audit_context;
 	seccomp_t seccomp;
 
-#ifdef CONFIG_UTRACE
 	struct utrace *utrace;
 	unsigned long utrace_flags;
-#endif
 
 /* Thread group tracking */
    	u32 parent_exec_id;
Index: linux-2.6/include/linux/tracehook.h
===================================================================
--- linux-2.6.orig/include/linux/tracehook.h	2007-04-13 14:45:28.000000000 +0200
+++ linux-2.6/include/linux/tracehook.h	2007-04-13 15:39:32.000000000 +0200
@@ -69,12 +69,12 @@ struct pt_regs;
  * should be one that can be evaluated in modules, i.e. uses exported symbols.
  *
  * Control system call tracing.  When enabled a syscall entry or exit
- * produces a call to tracehook_report_syscall, below.
+ * produces a call to utrace_report_syscall, below.
  *
  *	void tracehook_enable_syscall_trace(struct task_struct *tsk);
  *	void tracehook_disable_syscall_trace(struct task_struct *tsk);
  *
- * When stopped in tracehook_report_syscall for syscall entry,
+ * When stopped in utrace_report_syscall for syscall entry,
  * abort the syscall so no kernel function is called.
  * If the register state was not otherwise updated before,
  * this produces an -ENOSYS error return as for an invalid syscall number.
@@ -299,355 +299,5 @@ utrace_regset_copyin_ignore(unsigned int
 	return 0;
 }
 
-/**/
-
-
-/***
- ***
- *** Following are entry points from core code, where the user debugging
- *** support can affect the normal behavior.  The locking situation is
- *** described for each call.
- ***
- ***/
-
-
-/*
- * Called in copy_process when setting up the copied task_struct,
- * with tasklist_lock held for writing.
- */
-static inline void tracehook_init_task(struct task_struct *child)
-{
-	utrace_init_task(child);
-}
-
-/*
- * Called from release_task, no locks held.
- * After this, there should be no tracing entanglements.
- */
-static inline void tracehook_release_task(struct task_struct *p)
-{
-	smp_mb();
-	if (tsk_utrace_struct(p) != NULL)
-		utrace_release_task(p);
-}
-
-/*
- * Return nonzero to trigger a BUG_ON crash in release_task.
- * This should verify that there is no tracing-related state
- * still affecting the task_struct about to be released.
- * Called with tasklist_lock held for writing.
- */
-static inline int tracehook_check_released(struct task_struct *p)
-{
-	return unlikely(tsk_utrace_struct(p) != NULL);
-}
-
-/*
- * do_notify_parent_cldstop calls this when it's about to generate a SIGCHLD
- * for a job control stop.  Return nonzero to prevent that signal generation.
- * Called with tasklist_lock held for reading, sometimes with irqs disabled.
- */
-static inline int tracehook_notify_cldstop(struct task_struct *tsk,
-					   const siginfo_t *info)
-{
-	return (tsk_utrace_flags(tsk) & UTRACE_ACTION_NOREAP);
-}
-
-/*
- * exit_notify calls this with tasklist_lock held for writing.
- * Return nonzero to prevent any normal SIGCHLD generation for this
- * thread's death (i.e. when it is not ignored and its thread group is
- * empty).  This call must set *noreap to 0, or to 1 to force this thread
- * to become a zombie when it would normally reap itself.
- * The *death_cookie is passed to tracehook_report_death (below).
- */
-static inline int tracehook_notify_death(struct task_struct *tsk,
-					 int *noreap, void **death_cookie)
-{
-	*death_cookie = tsk_utrace_struct(tsk);
-	if (tsk_utrace_flags(tsk) & UTRACE_ACTION_NOREAP) {
-		*noreap = 1;
-		return 1;
-	}
-	*noreap = 0;
-	return 0;
-}
-
-/*
- * Return zero iff tracing doesn't care to examine this fatal signal,
- * so it can short-circuit normal delivery directly to a group exit.
- * Called with tsk->sighand->siglock held.
- */
-static inline int tracehook_consider_fatal_signal(struct task_struct *tsk,
-						  int sig)
-{
-	return (tsk_utrace_flags(tsk) & (UTRACE_EVENT(SIGNAL_TERM)
-					 | UTRACE_EVENT(SIGNAL_CORE)));
-}
-
-/*
- * Return zero iff tracing doesn't care to examine this ignored signal,
- * so it can short-circuit normal delivery and never even get queued.
- * Either the handler is SIG_DFL and sig's default is ignore, or it's SIG_IGN.
- * Called with tsk->sighand->siglock held.
- */
-static inline int tracehook_consider_ignored_signal(struct task_struct *tsk,
-						    int sig,
-						    void __user *handler)
-{
-	return (tsk_utrace_flags(tsk) & UTRACE_EVENT(SIGNAL_IGN));
-}
-
-
-/*
- * Called with the siglock held when computing tsk's signal_pending flag.
- * Return nonzero to force the signal_pending flag on, so that
- * tracehook_induce_signal will be called before the next return to user mode.
- */
-static inline int tracehook_induce_sigpending(struct task_struct *tsk)
-{
-	return unlikely(tsk_utrace_flags(tsk) & UTRACE_ACTION_QUIESCE);
-}
-
-/*
- * Called with the siglock held before dequeuing pending signals.
- * Return zero to check for a real pending signal normally.
- * Return -1 after releasing the siglock to repeat the check.
- * Return a signal number to induce an artifical signal delivery,
- * setting *info and *return_ka to specify its details and behavior.
- */
-static inline int tracehook_get_signal(struct task_struct *tsk,
-				       struct pt_regs *regs,
-				       siginfo_t *info,
-				       struct k_sigaction *return_ka)
-{
-	if (unlikely(tsk_utrace_flags(tsk)))
-		return utrace_get_signal(tsk, regs, info, return_ka);
-	return 0;
-}
-
-/*
- * Called with no locks held when about to stop for job control;
- * we are already in TASK_STOPPED state, about to call schedule.
- * Return zero if the normal SIGCHLD should be generated, which
- * will happen if last_one is true meaning this is the last thread
- * in the thread group to stop.
- */
-static inline int tracehook_finish_stop(int last_one)
-{
-	if (tsk_utrace_flags(current) & UTRACE_EVENT(JCTL))
-		return utrace_report_jctl(CLD_STOPPED);
-	return 0;
-}
-
-
-/*
- * Return nonzero if the child's parent (current) should be prevented
- * from seeing its child in TASK_STOPPED state when it waits with WSTOPPED.
- * Called with tasklist_lock held for reading.
- */
-static inline int tracehook_inhibit_wait_stopped(struct task_struct *child)
-{
-	return (tsk_utrace_flags(child) & UTRACE_ACTION_NOREAP);
-}
-
-/*
- * Return nonzero if the child's parent (current) should be prevented
- * from seeing its child in TASK_ZOMBIE state when it waits with WEXITED.
- * Called with tasklist_lock held for reading.
- */
-static inline int tracehook_inhibit_wait_zombie(struct task_struct *child)
-{
-	return (tsk_utrace_flags(child) & UTRACE_ACTION_NOREAP);
-}
-
-/*
- * Return nonzero if the child's parent (current) should be prevented
- * from seeing its child resuming after job stop when it waits with WCONTINUED.
- * Called with tasklist_lock held for reading.
- */
-static inline int tracehook_inhibit_wait_continued(struct task_struct *child)
-{
-	return (tsk_utrace_flags(child) & UTRACE_ACTION_NOREAP);
-}
-
-
-/*
- * Return LSM_UNSAFE_* bits applied to an exec because of tracing.
- * Called with task_lock(tsk) held.
- */
-static inline int tracehook_unsafe_exec(struct task_struct *tsk)
-{
-	if (tsk_utrace_flags(tsk))
-		return utrace_unsafe_exec(tsk);
-	return 0;
-}
-
-/*
- * Return the task_struct for the task using ptrace on this one, or NULL.
- * Must be called with rcu_read_lock held to keep the returned struct alive.
- *
- * At exec time, this may be called with task_lock(p) still held from when
- * tracehook_unsafe_exec was just called.
- *
- * The value is also used to display after "TracerPid:" in /proc/PID/status,
- * where it is called with only rcu_read_lock held.
- */
-static inline struct task_struct *tracehook_tracer_task(struct task_struct *p)
-{
-	if (tsk_utrace_flags(p))
-		return utrace_tracer_task(p);
-	return NULL;
-}
-
-/*
- * Return nonzero if the current task should be allowed to use
- * access_process_vm on the given task.
- */
-static inline int tracehook_allow_access_process_vm(struct task_struct *tsk)
-{
-	if (tsk == current)
-		return 1;
-	if (tsk_utrace_flags(tsk))
-		return utrace_allow_access_process_vm(tsk);
-	return 0;
-}
-
-
-/***
- ***
- *** Following decelarations are hook stubs where core code reports
- *** events.  These are called without locks, from the thread having the
- *** event.  In all tracehook_report_* calls, no locks are held and the thread
- *** is in a state close to returning to user mode with little baggage to
- *** unwind, except as noted below for tracehook_report_clone.  It is generally
- *** OK to block in these places if you want the user thread to be suspended.
- ***
- ***/
-
-/*
- * Thread has just become a zombie (exit_state==TASK_ZOMBIE) or is about to
- * self-reap (exit_state==EXIT_DEAD).  If normal reaping is not inhibited,
- * tsk->exit_state might be changing in parallel.  The death_cookie was
- * passed back by tracehook_notify_death (above).
- */
-static inline void tracehook_report_death(struct task_struct *tsk,
-					  int exit_state, void *death_cookie)
-{
-	smp_mb();
-	if (tsk_utrace_flags(tsk) & (UTRACE_EVENT(DEATH)
-				     | UTRACE_ACTION_QUIESCE))
-		utrace_report_death(tsk, death_cookie);
-}
-
-/*
- * This is called when tracehook_inhibit_wait_zombie(p) returned true
- * and a previously delayed group_leader is now eligible for reaping.
- * It's called from release_task, with no locks held, and p is not current.
- */
-static inline void tracehook_report_delayed_group_leader(struct task_struct *p)
-{
-	utrace_report_delayed_group_leader(p);
-}
-
-/*
- * exec completed, we are shortly going to return to user mode.
- * The freshly initialized register state can be seen and changed here.
- */
-static inline void tracehook_report_exec(struct linux_binprm *bprm,
-					 struct pt_regs *regs)
-{
-	if (tsk_utrace_flags(current) & UTRACE_EVENT(EXEC))
-		utrace_report_exec(bprm, regs);
-}
-
-/*
- * Called from do_exit, we are about to exit.  The code returned to the
- * parent for wait can be changed here.
- */
-static inline void tracehook_report_exit(long *exit_code)
-{
-	if (tsk_utrace_flags(current) & UTRACE_EVENT(EXIT))
-		utrace_report_exit(exit_code);
-}
-
-/*
- * Called after a child is set up, but before it has been started or
- * been given its CLONE_STOPPED initial stop.  (See also tracehook_init_task.)
- * This is not a good place to block, because the child has not started yet.
- * Suspend the child here if desired, and block in clone_complete (below).
- * This must prevent the child from self-reaping if clone_complete uses
- * the task_struct pointer; otherwise it might have died and been released
- * by the time tracehook_report_clone_complete is called.
- */
-static inline void tracehook_report_clone(unsigned long clone_flags,
-					  struct task_struct *child)
-{
-	if (tsk_utrace_flags(current) & UTRACE_EVENT(CLONE))
-		utrace_report_clone(clone_flags, child);
-}
-
-/*
- * Called after the child has started running, shortly after
- * tracehook_report_clone.  This is just before the clone/fork syscall returns,
- * or blocks for vfork child completion if (clone_flags & CLONE_VFORK).
- * The child pointer may be invalid if a self-reaping child died and
- * tracehook_report_clone took no action to prevent it from self-reaping.
- */
-static inline void tracehook_report_clone_complete(unsigned long clone_flags,
-						   pid_t pid,
-						   struct task_struct *child)
-{
-	if (tsk_utrace_flags(current) & UTRACE_ACTION_QUIESCE)
-		utrace_quiescent(current, NULL);
-}
-
-/*
- * Called after a CLONE_VFORK parent has waited for the child to complete.
- * The clone/vfork system call will return immediately after this.
- * The child pointer may be invalid if a self-reaping child died and
- * tracehook_report_clone took no action to prevent it from self-reaping.
- */
-static inline void tracehook_report_vfork_done(struct task_struct *child,
-					       pid_t child_pid)
-{
-	if (tsk_utrace_flags(current) & UTRACE_EVENT(VFORK_DONE))
-		utrace_report_vfork_done(child_pid);
-}
-
-/*
- * Called for system call entry or exit.
- */
-static inline void tracehook_report_syscall(struct pt_regs *regs, int is_exit)
-{
-	if (tsk_utrace_flags(current) & (is_exit ? UTRACE_EVENT(SYSCALL_EXIT)
-					 : UTRACE_EVENT(SYSCALL_ENTRY)))
-		utrace_report_syscall(regs, is_exit);
-}
-
-/*
- * Called after system call exit if single/block-stepped into the syscall.
- */
-static inline void tracehook_report_syscall_step(struct pt_regs *regs)
-{
-}
-
-/*
- * Called when a signal handler has been set up.
- * Register and stack state reflects the user handler about to run.
- * Signal mask changes have already been made.
- */
-static inline void tracehook_report_handle_signal(int sig,
-						  const struct k_sigaction *ka,
-						  const sigset_t *oldset,
-						  struct pt_regs *regs)
-{
-	struct task_struct *tsk = current;
-	if ((tsk_utrace_flags(tsk) & UTRACE_EVENT_SIGNAL_ALL)
-	    && (tsk_utrace_flags(tsk) & (UTRACE_ACTION_SINGLESTEP
-					 | UTRACE_ACTION_BLOCKSTEP)))
-		utrace_signal_handler_singlestep(tsk, regs);
-}
-
 
 #endif	/* <linux/tracehook.h> */
Index: linux-2.6/include/linux/utrace.h
===================================================================
--- linux-2.6.orig/include/linux/utrace.h	2007-04-13 14:35:01.000000000 +0200
+++ linux-2.6/include/linux/utrace.h	2007-04-13 15:47:43.000000000 +0200
@@ -178,7 +178,6 @@ enum utrace_events {
 #define UTRACE_ATTACH_MATCH_MASK	0x000f
 
 
-#ifdef CONFIG_UTRACE
 /*
  * Per-engine per-thread structure.
  *
@@ -470,9 +469,6 @@ const struct utrace_regset *utrace_regse
 					  int which);
 
 
-/*
- * Hooks in <linux/tracehook.h> call these entry points to the utrace dispatch.
- */
 int utrace_quiescent(struct task_struct *, struct utrace_signal *);
 void utrace_release_task(struct task_struct *);
 int utrace_get_signal(struct task_struct *, struct pt_regs *,
@@ -484,120 +480,47 @@ void utrace_report_death(struct task_str
 void utrace_report_delayed_group_leader(struct task_struct *);
 int utrace_report_jctl(int type);
 void utrace_report_exec(struct linux_binprm *bprm, struct pt_regs *regs);
-void utrace_report_syscall(struct pt_regs *regs, int is_exit);
+void __utrace_report_syscall(struct pt_regs *regs, int is_exit);
 struct task_struct *utrace_tracer_task(struct task_struct *);
 int utrace_allow_access_process_vm(struct task_struct *);
 int utrace_unsafe_exec(struct task_struct *);
 void utrace_signal_handler_singlestep(struct task_struct *, struct pt_regs *);
 
 /*
- * <linux/tracehook.h> uses these accessors to avoid #ifdef CONFIG_UTRACE.
+ * Return zero iff tracing doesn't care to examine this fatal signal,
+ * so it can short-circuit normal delivery directly to a group exit.
+ * Called with tsk->sighand->siglock held.
  */
-static inline unsigned long tsk_utrace_flags(struct task_struct *tsk)
-{
-	return tsk->utrace_flags;
-}
-static inline struct utrace *tsk_utrace_struct(struct task_struct *tsk)
-{
-	return tsk->utrace;
-}
-static inline void utrace_init_task(struct task_struct *child)
-{
-	child->utrace_flags = 0;
-	child->utrace = NULL;
-}
-
-#else  /* !CONFIG_UTRACE */
-
-static unsigned long tsk_utrace_flags(struct task_struct *tsk)
-{
-	return 0;
-}
-static struct utrace *tsk_utrace_struct(struct task_struct *tsk)
-{
-	return NULL;
-}
-static inline void utrace_init_task(struct task_struct *child)
+static inline int utrace_consider_fatal_signal(struct task_struct *tsk,
+						  int sig)
 {
+	return (tsk->utrace_flags &
+	        (UTRACE_EVENT(SIGNAL_TERM) | UTRACE_EVENT(SIGNAL_CORE)));
 }
 
 /*
- * The calls to these should all be in if (0) and optimized out entirely.
- * We have stubs here only so tracehook.h doesn't need to #ifdef them
- * to avoid external references in case of unoptimized compilation.
+ * Called for system call entry or exit.
  */
-static inline int utrace_quiescent(struct task_struct *tsk, void *ignored)
-{
-	BUG();
-	return 0;
-}
-static inline void utrace_release_task(struct task_struct *tsk)
-{
-	BUG();
-}
-static inline int utrace_get_signal(struct task_struct *tsk,
-				    struct pt_regs *regs,
-				    siginfo_t *info, struct k_sigaction *ka)
-{
-	BUG();
-	return 0;
-}
-static inline void utrace_report_clone(unsigned long clone_flags,
-				       struct task_struct *child)
-{
-	BUG();
-}
-static inline void utrace_report_vfork_done(pid_t child_pid)
-{
-	BUG();
-}
-static inline void utrace_report_exit(long *exit_code)
-{
-	BUG();
-}
-static inline void utrace_report_death(struct task_struct *tsk, void *ignored)
-{
-	BUG();
-}
-static inline void utrace_report_delayed_group_leader(struct task_struct *tsk)
-{
-	BUG();
-}
-static inline int utrace_report_jctl(int type)
-{
-	BUG();
-	return 0;
-}
-static inline void utrace_report_exec(struct linux_binprm *bprm,
-				      struct pt_regs *regs)
-{
-	BUG();
-}
 static inline void utrace_report_syscall(struct pt_regs *regs, int is_exit)
 {
-	BUG();
-}
-static inline struct task_struct *utrace_tracer_task(struct task_struct *tsk)
-{
-	BUG();
-	return NULL;
-}
-static inline int utrace_allow_access_process_vm(struct task_struct *tsk)
-{
-	BUG();
-	return 0;
-}
-static inline int utrace_unsafe_exec(struct task_struct *tsk)
-{
-	BUG();
-	return 0;
-}
-static inline void utrace_signal_handler_singlestep(struct task_struct *tsk,
-						    struct pt_regs *regs)
-{
-	BUG();
+	if (current->utrace_flags &
+	    (is_exit ? UTRACE_EVENT(SYSCALL_EXIT) : UTRACE_EVENT(SYSCALL_ENTRY)))
+		__utrace_report_syscall(regs, is_exit);
 }
 
-#endif  /* CONFIG_UTRACE */
+/*
+ * Called when a signal handler has been set up.
+ * Register and stack state reflects the user handler about to run.
+ * Signal mask changes have already been made.
+ */
+static inline void utrace_report_handle_signal(int sig,
+						  const struct k_sigaction *ka,
+						  const sigset_t *oldset,
+						  struct pt_regs *regs)
+{
+	if (current->utrace_flags & (UTRACE_EVENT_SIGNAL_ALL |
+			UTRACE_ACTION_SINGLESTEP | UTRACE_ACTION_BLOCKSTEP))
+		utrace_signal_handler_singlestep(current, regs);
+}
 
 #endif	/* linux/utrace.h */
Index: linux-2.6/kernel/Makefile
===================================================================
--- linux-2.6.orig/kernel/Makefile	2007-04-13 15:16:02.000000000 +0200
+++ linux-2.6/kernel/Makefile	2007-04-13 15:16:10.000000000 +0200
@@ -8,7 +8,7 @@ obj-y     = sched.o fork.o exec_domain.o
 	    signal.o sys.o kmod.o workqueue.o pid.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
-	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o
+	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o utrace.o
 
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-y += time/
@@ -51,7 +51,6 @@ obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
-obj-$(CONFIG_UTRACE) += utrace.o
 obj-$(CONFIG_PTRACE) += ptrace.o
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
Index: linux-2.6/kernel/exit.c
===================================================================
--- linux-2.6.orig/kernel/exit.c	2007-04-13 14:46:55.000000000 +0200
+++ linux-2.6/kernel/exit.c	2007-04-13 15:48:03.000000000 +0200
@@ -145,10 +145,12 @@ void release_task(struct task_struct * p
 	int zap_leader;
 	int inhibited_leader;
 repeat:
-	tracehook_release_task(p);
+	smp_mb();
+	if (p->utrace)
+		utrace_release_task(p);
 	atomic_dec(&p->user->processes);
 	write_lock_irq(&tasklist_lock);
-	BUG_ON(tracehook_check_released(p));
+	BUG_ON(p->utrace);
 	__exit_signal(p);
 
 	/*
@@ -161,7 +163,7 @@ repeat:
 	leader = p->group_leader;
 	if (leader != p && thread_group_empty(leader) && leader->exit_state == EXIT_ZOMBIE) {
 		BUG_ON(leader->exit_signal == -1);
-		if (tracehook_inhibit_wait_zombie(leader))
+		if (leader->utrace_flags & UTRACE_ACTION_NOREAP)
 			inhibited_leader = 1;
 		else
 			do_notify_parent(leader, leader->exit_signal);
@@ -191,7 +193,7 @@ repeat:
 	 * to be notified it would normally be reapable now.
 	 */
 	if (unlikely(inhibited_leader))
-		tracehook_report_delayed_group_leader(leader);
+		utrace_report_delayed_group_leader(leader);
 }
 
 /*
@@ -627,7 +629,7 @@ reparent_thread(struct task_struct *p, s
 	/* If we'd notified the old parent about this child's death,
 	 * also notify the new parent.
 	 */
-	if (!tracehook_inhibit_wait_zombie(p) &&
+	if (!(p->utrace_flags & UTRACE_ACTION_NOREAP) &&
 	    p->exit_state == EXIT_ZOMBIE &&
 	    p->exit_signal != -1 && thread_group_empty(p))
 		do_notify_parent(p, p->exit_signal);
@@ -687,8 +689,7 @@ static void exit_notify(struct task_stru
 	int state;
 	struct task_struct *t;
 	struct pid *pgrp;
-	int noreap;
-	void *cookie;
+	struct utrace *cookie;
 
 	if (signal_pending(tsk) && !(tsk->signal->flags & SIGNAL_GROUP_EXIT)
 	    && !thread_group_empty(tsk)) {
@@ -770,18 +771,19 @@ static void exit_notify(struct task_stru
 	    && !capable(CAP_KILL))
 		tsk->exit_signal = SIGCHLD;
 
-	if (!tracehook_notify_death(tsk, &noreap, &cookie)
-	    && tsk->exit_signal != -1 && thread_group_empty(tsk))
-		do_notify_parent(tsk, tsk->exit_signal);
-
 	state = EXIT_ZOMBIE;
-	if (tsk->exit_signal == -1 && !noreap)
-		state = EXIT_DEAD;
+	cookie = tsk->utrace;
+	if (!(tsk->utrace_flags & UTRACE_ACTION_NOREAP)) {
+		if (tsk->exit_signal == -1)
+			state = EXIT_DEAD;
+		else if (thread_group_empty(tsk))
+			do_notify_parent(tsk, tsk->exit_signal);
+	}
 	tsk->exit_state = state;
 
 	write_unlock_irq(&tasklist_lock);
-
-	tracehook_report_death(tsk, state, cookie);
+	if (tsk->utrace_flags & (UTRACE_EVENT(DEATH) | UTRACE_ACTION_QUIESCE))
+		utrace_report_death(tsk, cookie);
 
 	/* If the process is dead, release it - nobody will wait for it */
 	if (state == EXIT_DEAD)
@@ -808,8 +810,8 @@ fastcall NORET_TYPE void do_exit(long co
 			panic("Attempted to kill init!");
 	}
 
-
-	tracehook_report_exit(&code);
+	if (current->utrace_flags & UTRACE_EVENT(EXIT))
+		utrace_report_exit(&code);
 
 	/*
 	 * We're taking recursive faults here in do_exit. Safest is to just
@@ -1374,7 +1376,7 @@ repeat:
 				flag = 1;
 				if (!(options & WUNTRACED))
 					continue;
-				if (tracehook_inhibit_wait_stopped(p))
+				if (p->utrace_flags & UTRACE_ACTION_NOREAP)
 					continue;
 				retval = wait_task_stopped(p, ret == 2,
 							   (options & WNOWAIT),
@@ -1399,7 +1401,8 @@ repeat:
 						goto check_continued;
 					if (!likely(options & WEXITED))
 						continue;
-					if (tracehook_inhibit_wait_zombie(p)) {
+					if (p->utrace_flags &
+					    UTRACE_ACTION_NOREAP) {
 						flag = 1;
 						continue;
 					}
@@ -1419,7 +1422,7 @@ check_continued:
 				flag = 1;
 				if (!unlikely(options & WCONTINUED))
 					continue;
-				if (tracehook_inhibit_wait_continued(p))
+				if (p->utrace_flags & UTRACE_ACTION_NOREAP)
 					continue;
 				retval = wait_task_continued(
 					p, (options & WNOWAIT),
Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c	2007-04-13 14:45:28.000000000 +0200
+++ linux-2.6/kernel/fork.c	2007-04-13 15:17:59.000000000 +0200
@@ -1241,7 +1241,8 @@ static struct task_struct *copy_process(
 
 	if (likely(p->pid)) {
 		add_parent(p);
-		tracehook_init_task(p);
+		p->utrace_flags = 0;
+		p->utrace = NULL;
 
 		if (thread_group_leader(p)) {
 			p->signal->tty = current->signal->tty;
@@ -1362,8 +1363,9 @@ long do_fork(unsigned long clone_flags,
 			init_completion(&vfork);
 		}
 
-		if (likely(is_user))
-			tracehook_report_clone(clone_flags, p);
+		if (likely(is_user) &&
+		    (current->utrace_flags & UTRACE_EVENT(CLONE)))
+			utrace_report_clone(clone_flags, p);
 
 		p->flags &= ~PF_STARTING;
 
@@ -1378,13 +1380,15 @@ long do_fork(unsigned long clone_flags,
 		else
 			wake_up_new_task(p, clone_flags);
 
-		if (likely(is_user))
-			tracehook_report_clone_complete(clone_flags, nr, p);
+		if (likely(is_user) &&
+		    (current->utrace_flags & UTRACE_ACTION_QUIESCE))
+			utrace_quiescent(current, NULL);
 
 		if (clone_flags & CLONE_VFORK) {
 			wait_for_completion(&vfork);
-			if (likely(is_user))
-				tracehook_report_vfork_done(p, nr);
+			if (likely(is_user) &&
+			    (current->utrace_flags & UTRACE_EVENT(VFORK_DONE)))
+				utrace_report_vfork_done(nr);
 		}
 	} else {
 		free_pid(pid);
Index: linux-2.6/kernel/signal.c
===================================================================
--- linux-2.6.orig/kernel/signal.c	2007-04-13 14:52:52.000000000 +0200
+++ linux-2.6/kernel/signal.c	2007-04-13 15:23:22.000000000 +0200
@@ -178,7 +178,7 @@ static int sig_ignored(struct task_struc
 		return 0;
 
 	/* It's ignored, we can short-circuit unless a debugger wants it.  */
-	return !tracehook_consider_ignored_signal(t, sig, handler);
+	return !(t->utrace_flags & UTRACE_EVENT(SIGNAL_IGN));
 }
 
 /*
@@ -219,7 +219,7 @@ fastcall void recalc_sigpending_tsk(stru
 	    (freezing(t)) ||
 	    PENDING(&t->pending, &t->blocked) ||
 	    PENDING(&t->signal->shared_pending, &t->blocked) ||
-	    tracehook_induce_sigpending(t))
+	    unlikely(t->utrace_flags & UTRACE_ACTION_QUIESCE))
 		set_tsk_thread_flag(t, TIF_SIGPENDING);
 	else
 		clear_tsk_thread_flag(t, TIF_SIGPENDING);
@@ -927,7 +927,7 @@ __group_complete_signal(int sig, struct 
 	 */
 	if (sig_fatal(p, sig) && !(p->signal->flags & SIGNAL_GROUP_EXIT) &&
 	    !sigismember(&t->real_blocked, sig) &&
-	    (sig == SIGKILL || !tracehook_consider_fatal_signal(t, sig))) {
+	    (sig == SIGKILL || !utrace_consider_fatal_signal(t, sig))) {
 		/*
 		 * This signal will be fatal to the whole group.
 		 */
@@ -1570,7 +1570,7 @@ void do_notify_parent_cldstop(struct tas
 	/*
 	 * Tracing can decide that we should not do the normal notification.
 	 */
-	if (tracehook_notify_cldstop(tsk, &info))
+	if (tsk->utrace_flags & UTRACE_ACTION_NOREAP)
 		return;
 
 	tsk = tsk->group_leader;
@@ -1591,12 +1591,12 @@ void do_notify_parent_cldstop(struct tas
 static void
 finish_stop(int stop_count)
 {
-	/*
-	 * If there are no other threads in the group, or if there is
-	 * a group stop in progress and we are the last to stop,
-	 * report to the parent.  When ptraced, every thread reports itself.
-	 */
-	if (!tracehook_finish_stop(stop_count <= 0) && stop_count <= 0) {
+	int skip_notify = 0;
+
+	if (current->utrace_flags & UTRACE_EVENT(JCTL))
+		skip_notify = utrace_report_jctl(CLD_STOPPED);
+
+	if (!skip_notify && stop_count <= 0) {
 		read_lock(&tasklist_lock);
 		do_notify_parent_cldstop(current, CLD_STOPPED);
 		read_unlock(&tasklist_lock);
@@ -1728,7 +1728,11 @@ relock:
 		 * The return value in signr determines the default action,
 		 * but info->si_signo is the signal number we will report.
 		 */
-		signr = tracehook_get_signal(current, regs, info, return_ka);
+		if (unlikely(current->utrace_flags))
+			signr = utrace_get_signal(current, regs,
+						  info, return_ka);
+		else
+			signr = 0;
 		if (unlikely(signr < 0))
 			goto relock;
 		if (unlikely(signr != 0))
Index: linux-2.6/kernel/utrace.c
===================================================================
--- linux-2.6.orig/kernel/utrace.c	2007-04-13 14:35:01.000000000 +0200
+++ linux-2.6/kernel/utrace.c	2007-04-13 15:58:53.000000000 +0200
@@ -1464,7 +1464,7 @@ utrace_report_exec(struct linux_binprm *
  * Called iff UTRACE_EVENT(SYSCALL_{ENTRY,EXIT}) flag is set.
  */
 void
-utrace_report_syscall(struct pt_regs *regs, int is_exit)
+__utrace_report_syscall(struct pt_regs *regs, int is_exit)
 {
 	struct task_struct *tsk = current;
 	struct utrace *utrace = tsk->utrace;
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c	2007-04-13 15:24:17.000000000 +0200
+++ linux-2.6/security/selinux/hooks.c	2007-04-13 15:25:47.000000000 +0200
@@ -1849,7 +1849,8 @@ static void selinux_bprm_apply_creds(str
 			struct task_struct *t;
 
 			rcu_read_lock();
-			t = tracehook_tracer_task(current);
+			t = current->utrace_flags ?
+				utrace_tracer_task(current) : NULL;
 			if (unlikely(t == NULL))
 				rcu_read_unlock();
 			else {
@@ -4602,7 +4603,7 @@ static int selinux_setprocattr(struct ta
 		   Otherwise, leave SID unchanged and fail. */
 		task_lock(p);
 		rcu_read_lock();
-		tracer = tracehook_tracer_task(p);
+		tracer = p->utrace_flags ? utrace_tracer_task(p) : NULL;
 		if (tracer != NULL) {
 			struct task_security_struct *ptsec = tracer->security;
 			u32 ptsid = ptsec->sid;
Index: linux-2.6/init/Kconfig
===================================================================
--- linux-2.6.orig/init/Kconfig	2007-04-13 15:40:38.000000000 +0200
+++ linux-2.6/init/Kconfig	2007-04-13 15:40:56.000000000 +0200
@@ -597,24 +597,10 @@ endmenu
 
 menu "Process debugging support"
 
-config UTRACE
-	bool "Infrastructure for tracing and debugging user processes"
-	default y
-	help
-	  Enable the utrace process tracing interface.
-	  This is an internal kernel interface to track events in user
-	  threads, extract and change user thread state.  This interface
-	  is exported to kernel modules, and is also used to implement ptrace.
-	  If you disable this, no facilities for debugging user processes
-	  will be available, nor the facilities used by UML and other
-	  applications.  Unless you are making a specially stripped-down
-	  kernel and are very sure you don't need these facilitiies,
-	  say Y.
-
 config PTRACE
 	bool "Legacy ptrace system call interface"
 	default y
-	depends on UTRACE && PROC_FS
+	depends on PROC_FS
 	help
 	  Enable the ptrace system call.
 	  This is traditionally used by debuggers like GDB,
