Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbYFQQiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbYFQQiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 12:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbYFQQiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 12:38:12 -0400
Received: from [198.99.130.12] ([198.99.130.12]:35298 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbYFQQiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 12:38:09 -0400
Date: Tue, 17 Jun 2008 12:36:27 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Renzo Davoli <renzo@cs.unibo.it>
Cc: LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 0/2] ptrace_multi: speedup for virtual machines (and
	debuggers) running on ptrace
Message-ID: <20080617163627.GB7223@c2.user-mode-linux.org>
References: <20080616075820.GC6950@cs.unibo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080616075820.GC6950@cs.unibo.it>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 09:58:20AM +0200, Renzo Davoli wrote:
> This patch proposes/implements a new tag for ptrace: PTRACE_MULTI.

I would just forget this.  Linux, on purpose, hasn't implemented
system call batching, in favor of trying to keep system call overhead
low enough that it doesn't matter too much.

There's nothing special about ptrace - if you look around, you'll see
other common sequences which could equally well be batched.  So, even
if batching were a good idea, you'd need a more general design.

One possibility is the syslets idea introduced a while back by Ingo
and Zach Brown.

Another possibility is a more structured virtualization system which
accomplishes the same thing, which I hadn't got around to posting to
LKML yet.

The patch below implements sys_vcpu, which puts the current process
into a restricted mode in which a system call or signal causes a
return from sys_vcpu with the state at the time of the system call or
signal saved in a buffer.  This accomplishes the equivalent of
PTRACE_GETREGS + PTRACE_SYSEMU + PTRACE_SETREGS in one system call.

			Jeff
-- 
Work email - jdike at linux dot intel dot com


commit 7b7254ed4c788b8dbfdca3d52f21e29ae935805c
Author: Jeff Dike <jdike@addtoit.com>
Date:   Thu May 15 14:54:03 2008 -0400

    Host VCPU support
    
    This patch implements sys_vcpu, which allows a process to enter a new
    mode in which a signal or system call will cause a return to the
    original context.

diff --git a/arch/um/include/kern_util.h b/arch/um/include/kern_util.h
index 3c34122..0a91cb1 100644
--- a/arch/um/include/kern_util.h
+++ b/arch/um/include/kern_util.h
@@ -20,7 +20,7 @@ extern int kmalloc_ok;
 extern unsigned long alloc_stack(int order, int atomic);
 extern void free_stack(unsigned long stack, int order);
 
-extern int do_signal(void);
+extern void do_signal(void);
 extern void copy_sc(struct uml_pt_regs *regs, void *from);
 extern void interrupt_end(void);
 extern void relay_signal(int sig, struct uml_pt_regs *regs);
diff --git a/arch/um/include/sysdep-i386/ptrace.h b/arch/um/include/sysdep-i386/ptrace.h
index 11c0896..510c80f 100644
--- a/arch/um/include/sysdep-i386/ptrace.h
+++ b/arch/um/include/sysdep-i386/ptrace.h
@@ -156,7 +156,7 @@ struct syscall_args {
 	} while (0)
 
 #define UPT_SET_SYSCALL_RETURN(r, res) \
-	REGS_SET_SYSCALL_RETURN((r)->regs, (res))
+	REGS_SET_SYSCALL_RETURN((r)->gp, (res))
 
 #define UPT_RESTART_SYSCALL(r) REGS_RESTART_SYSCALL((r)->gp)
 
diff --git a/arch/um/include/sysdep-x86_64/ptrace.h b/arch/um/include/sysdep-x86_64/ptrace.h
index 9ea44d1..d3d1dda 100644
--- a/arch/um/include/sysdep-x86_64/ptrace.h
+++ b/arch/um/include/sysdep-x86_64/ptrace.h
@@ -225,11 +225,11 @@ struct syscall_args {
 	})
 
 #define UPT_SET_SYSCALL_RETURN(r, res) \
-	REGS_SET_SYSCALL_RETURN((r)->regs, (res))
+	REGS_SET_SYSCALL_RETURN((r)->gp, (res))
 
 #define UPT_RESTART_SYSCALL(r) REGS_RESTART_SYSCALL((r)->gp)
 
-#define UPT_SEGV_IS_FIXABLE(r) REGS_SEGV_IS_FIXABLE(&r->skas)
+#define UPT_SEGV_IS_FIXABLE(r) REGS_SEGV_IS_FIXABLE(&(r)->skas)
 
 #define UPT_FAULTINFO(r) (&(r)->faultinfo)
 
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index e8cb9ff..0963fcd 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -115,7 +115,7 @@ void interrupt_end(void)
 {
 	if (need_resched())
 		schedule();
-	if (test_tsk_thread_flag(current, TIF_SIGPENDING))
+	if (test_thread_flag(TIF_SIGPENDING))
 		do_signal();
 }
 
diff --git a/arch/um/kernel/signal.c b/arch/um/kernel/signal.c
index b0fce72..b1fcfde 100644
--- a/arch/um/kernel/signal.c
+++ b/arch/um/kernel/signal.c
@@ -85,8 +85,11 @@ static int handle_signal(struct pt_regs *regs, unsigned long signr,
 	return err;
 }
 
-static int kern_do_signal(struct pt_regs *regs)
+extern int unvcpu(struct pt_regs *regs, siginfo_t *siginfo);
+
+void do_signal(void)
 {
+	struct pt_regs *regs = &current->thread.regs;
 	struct k_sigaction ka_copy;
 	siginfo_t info;
 	sigset_t *oldset;
@@ -98,6 +101,11 @@ static int kern_do_signal(struct pt_regs *regs)
 		oldset = &current->blocked;
 
 	while ((sig = get_signal_to_deliver(&info, &ka_copy, regs, NULL)) > 0) {
+		if (test_thread_flag(TIF_VCPU)) {
+			PT_REGS_SET_SYSCALL_RETURN(regs, unvcpu(regs, &info));
+			return;
+		}
+
 		handled_sig = 1;
 		/* Whee!  Actually deliver the signal.  */
 		if (!handle_signal(regs, sig, &ka_copy, &info, oldset)) {
@@ -150,12 +158,6 @@ static int kern_do_signal(struct pt_regs *regs)
 		clear_thread_flag(TIF_RESTORE_SIGMASK);
 		sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
 	}
-	return handled_sig;
-}
-
-int do_signal(void)
-{
-	return kern_do_signal(&current->thread.regs);
 }
 
 /*
diff --git a/arch/um/kernel/skas/syscall.c b/arch/um/kernel/skas/syscall.c
index 4e3b820..c677b8e 100644
--- a/arch/um/kernel/skas/syscall.c
+++ b/arch/um/kernel/skas/syscall.c
@@ -12,12 +12,19 @@
 extern int syscall_table_size;
 #define NR_syscalls (syscall_table_size / sizeof(void *))
 
+extern int unvcpu(struct pt_regs *regs, siginfo_t *siginfo);
+
 void handle_syscall(struct uml_pt_regs *r)
 {
 	struct pt_regs *regs = container_of(r, struct pt_regs, regs);
 	long result;
 	int syscall;
 
+	if (test_thread_flag(TIF_VCPU)) {
+		REGS_SET_SYSCALL_RETURN(r->gp, unvcpu(regs, NULL));
+		return;
+	}
+
 	syscall_trace(r, 0);
 
 	/*
diff --git a/arch/um/kernel/syscall.c b/arch/um/kernel/syscall.c
index a9c2f6f..63c782d 100644
--- a/arch/um/kernel/syscall.c
+++ b/arch/um/kernel/syscall.c
@@ -1,17 +1,17 @@
 /*
- * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
+ * Copyright (C) 2000 - 2008 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include "linux/file.h"
-#include "linux/fs.h"
-#include "linux/mm.h"
-#include "linux/sched.h"
-#include "linux/utsname.h"
-#include "asm/current.h"
-#include "asm/mman.h"
-#include "asm/uaccess.h"
-#include "asm/unistd.h"
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <linux/utsname.h>
+#include <asm/current.h>
+#include <asm/mman.h>
+#include <asm/uaccess.h>
+#include <asm/unistd.h>
 
 long sys_fork(void)
 {
@@ -158,3 +158,11 @@ long sys_switch_mm(int fd, long __user *save, long __user *new,
 {
 	return do_switch_mm(fd, save, new, ip, sp, &current->thread.regs);
 }
+
+extern long do_vcpu(int mm_fd, struct vcpu_user __user *new,
+		    struct pt_regs *regs);
+
+long sys_vcpu(int mm_fd, struct vcpu_user __user *new)
+{
+	return do_vcpu(mm_fd, new, &current->thread.regs);
+}
diff --git a/arch/um/os-Linux/skas/process.c b/arch/um/os-Linux/skas/process.c
index cbb7986..21e24ba 100644
--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -446,8 +446,14 @@ void userspace(struct uml_pt_regs *regs)
 				       "with signal %d\n", sig);
 				fatal_sigsegv();
 			}
-			pid = userspace_pid[0];
+
+			/*
+			 * userspace_pid can change in in_interrupt since
+			 * PTRACE_SWITCH_MM can cause a process to change
+			 * address spaces
+			 */
 			interrupt_end();
+			pid = userspace_pid[0];
 
 			/* Avoid -ERESTARTSYS handling in host */
 			if (PT_SYSCALL_NR_OFFSET != PT_SYSCALL_RET_OFFSET)
diff --git a/arch/um/sys-x86_64/syscall_table.c b/arch/um/sys-x86_64/syscall_table.c
index 8b5c216..9bb72fc 100644
--- a/arch/um/sys-x86_64/syscall_table.c
+++ b/arch/um/sys-x86_64/syscall_table.c
@@ -40,6 +40,7 @@
 #define stub_sigaltstack sys_sigaltstack
 #define stub_rt_sigreturn sys_rt_sigreturn
 #define stub_switch_mm sys_switch_mm
+#define stub_vcpu sys_vcpu
 
 #define __SYSCALL(nr, sym) extern asmlinkage void sym(void) ;
 #undef _ASM_X86_64_UNISTD_H_
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 4b87c32..1e2adae 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -371,7 +371,7 @@ ENTRY(system_call)
 	GET_THREAD_INFO(%ebp)
 					# system call tracing in operation / emulation
 	/* Note, _TIF_SECCOMP is bit number 8, and so it needs testw and not testb */
-	testw $(_TIF_SYSCALL_EMU|_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT),TI_flags(%ebp)
+	testl $(_TIF_SYSCALL_EMU|_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT|_TIF_VCPU),TI_flags(%ebp)
 	jnz syscall_trace_entry
 	cmpl $(nr_syscalls), %eax
 	jae syscall_badsys
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index bb573ef..f3f403a 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -244,7 +244,7 @@ ENTRY(system_call_after_swapgs)
 	movq  %rcx,RIP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rip,RIP-ARGOFFSET
 	GET_THREAD_INFO(%rcx)
-	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),threadinfo_flags(%rcx)
+	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP|_TIF_VCPU),threadinfo_flags(%rcx)
 	jnz tracesys
 	cmpq $__NR_syscall_max,%rax
 	ja badsys
@@ -323,6 +323,12 @@ tracesys:
 	FIXUP_TOP_OF_STACK %rdi
 	movq %rsp,%rdi
 	call syscall_trace_enter
+	testl %eax, %eax
+	jz 2f
+	LOAD_ARGS ARGOFFSET  /* reload args from stack in case ptrace changed it */
+	RESTORE_REST
+	jmp int_ret_from_sys_call
+2:
 	LOAD_ARGS ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
 	cmpq $__NR_syscall_max,%rax
@@ -482,6 +488,23 @@ ENTRY(stub_rt_sigreturn)
 END(stub_rt_sigreturn)
 
 /*
+ * vcpu is special too
+ */
+ENTRY(stub_vcpu)
+	CFI_STARTPROC
+	addq $8, %rsp
+	CFI_ADJUST_CFA_OFFSET	-8
+	SAVE_REST
+	movq %rsp,%rdx
+	FIXUP_TOP_OF_STACK %r11
+	call sys_vcpu
+	movq %rax,RAX(%rsp) # fixme, this could be done at the higher layer
+	RESTORE_REST
+	jmp int_ret_from_sys_call
+	CFI_ENDPROC
+END(stub_vcpu)
+
+/*
  * initial frame state for interrupts and exceptions
  */
 	.macro _frame ref
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index de84950..44334e2 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1453,6 +1453,8 @@ void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs, int error_code)
 	force_sig_info(SIGTRAP, &info, tsk);
 }
 
+extern int unvcpu(struct pt_regs *regs, siginfo_t *siginfo);
+
 /* notification of system call entry/exit
  * - triggered by current->work.syscall_trace
  */
@@ -1489,6 +1491,14 @@ int do_syscall_trace(struct pt_regs *regs, int entryexit)
 			goto out;
 	}
 
+	if (test_thread_flag(TIF_VCPU)) {
+		if (entryexit)
+			return 0;
+
+		regs->ax = unvcpu(regs, NULL);
+		return 1;
+	}
+
 	if (!(current->ptrace & PT_PTRACED))
 		goto out;
 
@@ -1616,11 +1626,18 @@ static void syscall_trace(struct pt_regs *regs)
 	}
 }
 
-asmlinkage void syscall_trace_enter(struct pt_regs *regs)
+extern int unvcpu(struct pt_regs *regs, siginfo_t *siginfo);
+
+asmlinkage int syscall_trace_enter(struct pt_regs *regs)
 {
 	/* do the secure computing check first */
 	secure_computing(regs->orig_ax);
 
+	if (test_thread_flag(TIF_VCPU)) {
+		regs->ax = unvcpu(regs, NULL);
+		return 1;
+	}
+
 	if (test_thread_flag(TIF_SYSCALL_TRACE)
 	    && (current->ptrace & PT_PTRACED))
 		syscall_trace(regs);
@@ -1638,6 +1655,8 @@ asmlinkage void syscall_trace_enter(struct pt_regs *regs)
 					    regs->dx, regs->r10);
 		}
 	}
+
+	return 0;
 }
 
 asmlinkage void syscall_trace_leave(struct pt_regs *regs)
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index 0157a6f..73b5d21 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -573,6 +573,8 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	return ret;
 }
 
+extern int unvcpu(struct pt_regs *regs, siginfo_t *siginfo);
+
 /*
  * Note that 'init' is a special process: it doesn't get signals it doesn't
  * want to handle. Thus you cannot kill init even with a SIGKILL even by
@@ -603,6 +605,11 @@ static void do_signal(struct pt_regs *regs)
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
 	if (signr > 0) {
+		if (test_thread_flag(TIF_VCPU)) {
+			regs->ax = unvcpu(regs, &info);
+			return;
+		}
+
 		/* Re-enable any watchpoints before delivering the
 		 * signal to user space. The processor register will
 		 * have been cleared if the watchpoint triggered
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 1c83e51..8978b40 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -407,6 +407,8 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	return ret;
 }
 
+extern int unvcpu(struct pt_regs *regs, siginfo_t *siginfo);
+
 /*
  * Note that 'init' is a special process: it doesn't get signals it doesn't
  * want to handle. Thus you cannot kill init even with a SIGKILL even by
@@ -435,6 +437,11 @@ static void do_signal(struct pt_regs *regs)
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
 	if (signr > 0) {
+		if (test_thread_flag(TIF_VCPU)) {
+			regs->ax = unvcpu(regs, &info);
+			return;
+		}
+
 		/* Re-enable any watchpoints before delivering the
 		 * signal to user space. The processor register will
 		 * have been cleared if the watchpoint triggered
diff --git a/arch/x86/kernel/sys_i386_32.c b/arch/x86/kernel/sys_i386_32.c
index 23f6aff..d5d54f6 100644
--- a/arch/x86/kernel/sys_i386_32.c
+++ b/arch/x86/kernel/sys_i386_32.c
@@ -273,3 +273,17 @@ asmlinkage long sys_switch_mm(struct pt_regs regs)
 			    (struct __user user_regs *) regs.dx, regs.si,
 			    regs.di, &regs);
 }
+
+extern long do_vcpu(int mm_fd, struct vcpu_user __user *new,
+		    struct pt_regs *regs);
+
+asmlinkage long sys_vcpu(struct pt_regs regs)
+{
+	int err;
+
+	err = do_vcpu(regs.bx, (struct vcpu_user __user *) regs.cx, &regs);
+	if (err)
+		return err;
+
+	return regs.ax;
+}
diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index b3c98f5..aab9121 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -262,3 +262,18 @@ asmlinkage long sys_switch_mm(int fd, struct __user user_regs *save,
 {
 	return do_switch_mm(fd, save, new, ip, sp, regs);
 }
+
+extern long do_vcpu(int mm_fd, struct vcpu_user __user *new,
+		    struct pt_regs *regs);
+
+asmlinkage long sys_vcpu(int mm_fd, struct vcpu_user __user *new,
+			 struct pt_regs *regs)
+{
+	int err;
+
+	err = do_vcpu(mm_fd, new, regs);
+	if (err)
+		return err;
+
+	return regs->ax;
+}
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index 27f20f0..5b9803a 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -328,3 +328,4 @@ ENTRY(sys_call_table)
 	.long sys_timerfd_gettime
 	.long sys_new_mm
 	.long sys_switch_mm
+	.long sys_vcpu
diff --git a/include/asm-um/desc.h b/include/asm-um/desc.h
index 4ec34a5..efbabaf 100644
--- a/include/asm-um/desc.h
+++ b/include/asm-um/desc.h
@@ -1,6 +1,11 @@
 #ifndef __UM_DESC_H
 #define __UM_DESC_H
 
+#ifdef CONFIG_64BIT
+#define LM(info) (info)->lm == 0
+#else
+#define LM(info) (1)
+#endif
 /* Taken from asm-i386/desc.h, it's the only thing we need. The rest wouldn't
  * compile, and has never been used. */
 #define LDT_empty(info) (\
@@ -11,6 +16,7 @@
 	(info)->seg_32bit	== 0	&& \
 	(info)->limit_in_pages	== 0	&& \
 	(info)->seg_not_present	== 1	&& \
+	LM(info)			&& \
 	(info)->useable		== 0	)
 
 #endif
diff --git a/include/asm-um/host_ldt-i386.h b/include/asm-um/host_ldt-i386.h
index b27cb0a..e2ad59c 100644
--- a/include/asm-um/host_ldt-i386.h
+++ b/include/asm-um/host_ldt-i386.h
@@ -1,7 +1,8 @@
 #ifndef __ASM_HOST_LDT_I386_H
 #define __ASM_HOST_LDT_I386_H
 
-#include "asm/arch/ldt.h"
+#include <asm/desc.h>
+#include <asm/arch/ldt.h>
 
 /*
  * macros stolen from include/asm-i386/desc.h
@@ -21,14 +22,4 @@
 	((info)->useable << 20) | \
 	0x7000)
 
-#define LDT_empty(info) (\
-	(info)->base_addr	== 0	&& \
-	(info)->limit		== 0	&& \
-	(info)->contents	== 0	&& \
-	(info)->read_exec_only	== 1	&& \
-	(info)->seg_32bit	== 0	&& \
-	(info)->limit_in_pages	== 0	&& \
-	(info)->seg_not_present	== 1	&& \
-	(info)->useable		== 0	)
-
 #endif
diff --git a/include/asm-um/host_ldt-x86_64.h b/include/asm-um/host_ldt-x86_64.h
index 74a63f7..585c162 100644
--- a/include/asm-um/host_ldt-x86_64.h
+++ b/include/asm-um/host_ldt-x86_64.h
@@ -1,7 +1,8 @@
 #ifndef __ASM_HOST_LDT_X86_64_H
 #define __ASM_HOST_LDT_X86_64_H
 
-#include "asm/arch/ldt.h"
+#include <asm/desc.h>
+#include <asm/arch/ldt.h>
 
 /*
  * macros stolen from include/asm-x86_64/desc.h
@@ -24,15 +25,4 @@
 	/* ((info)->lm << 21) | */ \
 	0x7000)
 
-#define LDT_empty(info) (\
-	(info)->base_addr	== 0	&& \
-	(info)->limit		== 0	&& \
-	(info)->contents	== 0	&& \
-	(info)->read_exec_only	== 1	&& \
-	(info)->seg_32bit	== 0	&& \
-	(info)->limit_in_pages	== 0	&& \
-	(info)->seg_not_present	== 1	&& \
-	(info)->useable		== 0	&& \
-	(info)->lm              == 0)
-
 #endif
diff --git a/include/asm-um/thread_info.h b/include/asm-um/thread_info.h
index 356b83e..6aa19f3 100644
--- a/include/asm-um/thread_info.h
+++ b/include/asm-um/thread_info.h
@@ -83,6 +83,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_MEMDIE	 	5
 #define TIF_SYSCALL_AUDIT	6
 #define TIF_RESTORE_SIGMASK	7
+#define TIF_VCPU		8
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
@@ -91,5 +92,6 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_MEMDIE		(1 << TIF_MEMDIE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
+#define _TIF_VCPU		(1 << TIF_VCPU)
 
 #endif
diff --git a/include/asm-x86/thread_info_32.h b/include/asm-x86/thread_info_32.h
index 5bd5082..920c94a 100644
--- a/include/asm-x86/thread_info_32.h
+++ b/include/asm-x86/thread_info_32.h
@@ -142,6 +142,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_DEBUGCTLMSR		22	/* uses thread_struct.debugctlmsr */
 #define TIF_DS_AREA_MSR 	23      /* uses thread_struct.ds_area_msr */
 #define TIF_BTS_TRACE_TS        24      /* record scheduling event timestamps */
+#define TIF_VCPU		25
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
@@ -161,6 +162,7 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_DEBUGCTLMSR	(1<<TIF_DEBUGCTLMSR)
 #define _TIF_DS_AREA_MSR	(1<<TIF_DS_AREA_MSR)
 #define _TIF_BTS_TRACE_TS	(1<<TIF_BTS_TRACE_TS)
+#define _TIF_VCPU		(1<<TIF_VCPU)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK \
diff --git a/include/asm-x86/thread_info_64.h b/include/asm-x86/thread_info_64.h
index 6c9b214..179d036 100644
--- a/include/asm-x86/thread_info_64.h
+++ b/include/asm-x86/thread_info_64.h
@@ -125,6 +125,7 @@ static inline struct thread_info *stack_thread_info(void)
 #define TIF_DEBUGCTLMSR		25	/* uses thread_struct.debugctlmsr */
 #define TIF_DS_AREA_MSR		26      /* uses thread_struct.ds_area_msr */
 #define TIF_BTS_TRACE_TS	27      /* record scheduling event timestamps */
+#define TIF_VCPU		28
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
@@ -146,6 +147,7 @@ static inline struct thread_info *stack_thread_info(void)
 #define _TIF_DEBUGCTLMSR	(1<<TIF_DEBUGCTLMSR)
 #define _TIF_DS_AREA_MSR	(1<<TIF_DS_AREA_MSR)
 #define _TIF_BTS_TRACE_TS	(1<<TIF_BTS_TRACE_TS)
+#define _TIF_VCPU		(1<<TIF_VCPU)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK \
diff --git a/include/asm-x86/unistd_32.h b/include/asm-x86/unistd_32.h
index 5f8f291..cadbdb1 100644
--- a/include/asm-x86/unistd_32.h
+++ b/include/asm-x86/unistd_32.h
@@ -334,6 +334,7 @@
 #define __NR_timerfd_gettime	326
 #define __NR_new_mm		327
 #define __NR_switch_mm		328
+#define __NR_vcpu		329
 
 #ifdef __KERNEL__
 
diff --git a/include/asm-x86/unistd_64.h b/include/asm-x86/unistd_64.h
index a674098..51bd17c 100644
--- a/include/asm-x86/unistd_64.h
+++ b/include/asm-x86/unistd_64.h
@@ -643,6 +643,8 @@ __SYSCALL(__NR_timerfd_gettime, sys_timerfd_gettime)
 __SYSCALL(__NR_new_mm, sys_new_mm)
 #define __NR_switch_mm				289
 __SYSCALL(__NR_switch_mm, stub_switch_mm)
+#define __NR_vcpu				290
+__SYSCALL(__NR_vcpu, stub_vcpu)
 
 
 #ifndef __NO_STUBS
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 1f74e1d..5ed65eb 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -193,6 +193,7 @@ extern struct group_info init_groups;
 		[PIDTYPE_SID]  = INIT_PID_LINK(PIDTYPE_SID),		\
 	},								\
 	.dirties = INIT_PROP_LOCAL_SINGLE(dirties),			\
+	.vcpu		= NULL,						\
 	INIT_IDS							\
 	INIT_TRACE_IRQFLAGS						\
 	INIT_LOCKDEP							\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7360fde..5759bba 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -65,6 +65,7 @@ struct sched_param {
 #include <asm/page.h>
 #include <asm/ptrace.h>
 #include <asm/cputime.h>
+#include <asm/ldt.h>
 
 #include <linux/smp.h>
 #include <linux/sem.h>
@@ -991,6 +992,24 @@ struct sched_rt_entity {
 #endif
 };
 
+struct vcpu_user {
+	enum { VCPU_SYSCALL, VCPU_SIGNAL } event;
+	struct user_regs regs;
+	siginfo_t siginfo;
+#if defined(CONFIG_X86_32) && !defined(CONFIG_UML)
+	struct user_desc tls_array[GDT_ENTRY_TLS_ENTRIES];
+#endif
+};
+
+struct vcpu {
+	struct vcpu_user user;
+	struct mm_struct *mm;
+	struct vcpu_user __user *state;
+#if defined(CONFIG_X86_32) && !defined(CONFIG_UML)
+	struct user_desc tls[GDT_ENTRY_TLS_ENTRIES];
+#endif
+};
+
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	void *stack;
@@ -1103,6 +1122,7 @@ struct task_struct {
   	cputime_t it_prof_expires, it_virt_expires;
 	unsigned long long it_sched_expires;
 	struct list_head cpu_timers[3];
+	struct vcpu *vcpu;
 
 /* process credentials */
 	uid_t uid,euid,suid,fsuid;
diff --git a/kernel/Makefile b/kernel/Makefile
index 6c584c5..0119a37 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -9,7 +9,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o \
-	    notifier.o ksysfs.o pm_qos_params.o
+	    notifier.o ksysfs.o pm_qos_params.o vcpu.o
 
 obj-$(CONFIG_SYSCTL) += sysctl_check.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
diff --git a/kernel/exit.c b/kernel/exit.c
index 073005b..bda5e7f 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -175,6 +175,11 @@ repeat:
 
 	write_unlock_irq(&tasklist_lock);
 	release_thread(p);
+
+	if (p->vcpu && p->vcpu->mm)
+		mmput(p->vcpu->mm);
+	kfree(p->vcpu);
+
 	call_rcu(&p->rcu, delayed_put_task_struct);
 
 	p = leader;
diff --git a/kernel/fork.c b/kernel/fork.c
index 4ca580a..3b8ed4c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1086,6 +1086,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	clear_tsk_thread_flag(p, TIF_SIGPENDING);
 	init_sigpending(&p->pending);
 
+	p->vcpu = NULL;
+
 	p->utime = cputime_zero;
 	p->stime = cputime_zero;
 	p->gtime = cputime_zero;
diff --git a/kernel/signal.c b/kernel/signal.c
index 6025e33..67b5ec5 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1785,6 +1785,9 @@ relock:
 		if (!signr)
 			break; /* will return 0 */
 
+		if (test_thread_flag(TIF_VCPU))
+			break;
+
 		if ((current->ptrace & PT_PTRACED) && signr != SIGKILL) {
 			ptrace_signal_deliver(regs, cookie);
 
diff --git a/kernel/vcpu.c b/kernel/vcpu.c
new file mode 100644
index 0000000..5ca259e
--- /dev/null
+++ b/kernel/vcpu.c
@@ -0,0 +1,129 @@
+/*
+ * Copyright (C) 2008 Jeff Dike (jdike@{addtoit,linux.intel}.com)
+ * Licensed under the GPL
+ */
+
+#include <linux/sched.h>
+#include <asm/uaccess.h>
+#include <asm/desc.h>
+
+extern asmlinkage int sys_get_thread_area(struct user_desc __user *u_info);
+extern asmlinkage int sys_set_thread_area(struct user_desc __user *u_info);
+extern int do_switch(struct task_struct *task, int fd);
+
+long do_vcpu(int mm_fd, struct vcpu_user __user *new, struct pt_regs *regs)
+{
+	mm_segment_t fs;
+	struct vcpu *vcpu;
+	int err;
+
+	if (current->vcpu == NULL) {
+		current->vcpu = kmalloc(sizeof(struct vcpu), GFP_KERNEL);
+		if (current->vcpu == NULL)
+			return -ENOMEM;
+	}
+
+	vcpu = current->vcpu;
+	vcpu->mm = NULL;
+	vcpu->state = new;
+
+	fs = get_fs();
+	set_fs(KERNEL_DS);
+	err = pt_regs_to_ptrace(&vcpu->user.regs, regs);
+	set_fs(fs);
+	if (err)
+		return err;
+
+	err = ptrace_to_pt_regs(regs, &new->regs);
+	if (err)
+		return err;
+
+#if defined(CONFIG_X86_32) && !defined(CONFIG_UML)
+	{ int i;
+
+	memcpy(vcpu->tls, current->thread.tls_array, sizeof(vcpu->tls));
+	for (i = 0; i < ARRAY_SIZE(new->tls_array); i++){
+		fs = get_fs();
+		set_fs(KERNEL_DS);
+		vcpu->tls[i].entry_number = GDT_ENTRY_TLS_MIN + i;
+		err = sys_get_thread_area(&vcpu->tls[i]);
+		set_fs(fs);
+		if (err)
+			return err;
+
+		err = sys_set_thread_area(&new->tls_array[i]);
+		if (err)
+			return err;
+	}
+	}
+#endif
+
+	if (mm_fd != -1) {
+		vcpu->mm = current->mm;
+		atomic_inc(&vcpu->mm->mm_users);
+
+		err = do_switch(current, mm_fd);
+		if (err)
+			return err;
+	}
+
+#if defined(CONFIG_X86_32) && !defined(CONFIG_UML)
+	loadsegment(gs, current->thread.gs);
+#endif
+	set_thread_flag(TIF_VCPU);
+
+	return 0;
+}
+
+extern void do_switch_mm_struct(struct task_struct *task,
+				struct mm_struct *new);
+
+int unvcpu(struct pt_regs *regs, siginfo_t *siginfo)
+{
+	mm_segment_t fs;
+	struct vcpu *vcpu;
+	int err, event;
+
+	clear_thread_flag(TIF_VCPU);
+
+	vcpu = current->vcpu;
+	if (vcpu->mm != NULL) {
+		do_switch_mm_struct(current, vcpu->mm);
+		mmput(vcpu->mm);
+		vcpu->mm = NULL;
+	}
+
+	err = pt_regs_to_ptrace(&vcpu->state->regs, regs);
+	if (err)
+		return err;
+
+	err = -EFAULT;
+	if ((siginfo != NULL) &&
+	    (copy_to_user(&vcpu->state->siginfo, siginfo,
+			  sizeof(siginfo_t)) != 0))
+		return err;
+
+	event = (siginfo != NULL) ? VCPU_SIGNAL : VCPU_SYSCALL;
+	if (copy_to_user(&vcpu->state->event, &event, sizeof(event)) != 0)
+		return err;
+
+#if defined(CONFIG_X86_32) && !defined(CONFIG_UML)
+	{ int i;
+	for (i = 0; i < ARRAY_SIZE(vcpu->state->tls_array); i++){
+		fs = get_fs();
+		set_fs(KERNEL_DS);
+		err = sys_set_thread_area(&vcpu->tls[i]);
+		set_fs(fs);
+		if (err)
+			return err;
+	}
+	}
+#endif
+
+	fs = get_fs();
+	set_fs(KERNEL_DS);
+	err = ptrace_to_pt_regs(regs, &vcpu->user.regs);
+	set_fs(fs);
+
+	return err;
+}
