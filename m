Return-Path: <linux-kernel-owner+w=401wt.eu-S932419AbXCETa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbXCETa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 14:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933100AbXCETa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 14:30:26 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:48760 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932419AbXCETaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 14:30:25 -0500
Date: Mon, 5 Mar 2007 14:21:20 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH] UML utrace support, step 1
Message-ID: <20070305192120.GA7320@ccure.user-mode-linux.org>
References: <20070221181811.GA5845@ccure.user-mode-linux.org> <20070223031903.A55241800E4@magilla.sf.frob.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070223031903.A55241800E4@magilla.sf.frob.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 07:19:03PM -0800, Roland McGrath wrote:
> Your replacement patch still has utrace_regset stuff in it, so it doesn't
> compile without the later patches in the series.  Try applying only
> utrace-tracehook.patch from the series, then get it to build and make your
> utrace-tracehook-um.patch.

Below is a tracehook patch for UML which goes right after
utrace-utrace-tracehook.patch.

				Jeff

-- 
Work email - jdike at linux dot intel dot com


This is the tracehook part of the UML utrace work, enough to get UML
building with the utrace prep patches applied.

Checks of task->ptrace & PT_DTRACE were replaced with
test_thread_flag(TIF_SINGLESTEP, or removed, in the case of execve.

Most of arch/um/kernel/ptrace.c is gone, to be reinstated in future
utrace work.

Similarly, calls to syscall_trace and ptrace notifications in the
signal delivery code are gone.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/kernel/exec.c           |    1 
 arch/um/kernel/process.c        |    6 
 arch/um/kernel/ptrace.c         |  333 +++++-----------------------------------
 arch/um/kernel/signal.c         |    5 
 arch/um/kernel/skas/syscall.c   |    4 
 arch/um/sys-i386/signal.c       |    4 
 include/asm-um/ptrace-generic.h |    3 
 include/asm-um/ptrace-i386.h    |    2 
 include/asm-um/ptrace-x86_64.h  |    2 
 include/asm-um/tracehook.h      |   64 +++++++
 10 files changed, 117 insertions(+), 307 deletions(-)


Index: linux-2.6.18-mm/arch/um/kernel/exec.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/kernel/exec.c	2007-03-03 16:23:47.000000000 -0500
+++ linux-2.6.18-mm/arch/um/kernel/exec.c	2007-03-03 16:26:42.000000000 -0500
@@ -51,7 +51,6 @@ static long execve1(char *file, char __u
         error = do_execve(file, argv, env, &current->thread.regs);
         if (error == 0){
 		task_lock(current);
-                current->ptrace &= ~PT_DTRACE;
 #ifdef SUBARCH_EXECVE1
 		SUBARCH_EXECVE1(&current->thread.regs.regs);
 #endif
Index: linux-2.6.18-mm/arch/um/kernel/process.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/kernel/process.c	2007-03-03 16:20:36.000000000 -0500
+++ linux-2.6.18-mm/arch/um/kernel/process.c	2007-03-03 16:26:42.000000000 -0500
@@ -458,11 +458,11 @@ int singlestepping(void * t)
 {
 	struct task_struct *task = t ? t : current;
 
-	if ( ! (task->ptrace & PT_DTRACE) )
-		return(0);
+	if (!test_thread_flag(TIF_SINGLESTEP))
+		return 0;
 
 	if (task->thread.singlestep_syscall)
-		return(1);
+		return 1;
 
 	return 2;
 }
Index: linux-2.6.18-mm/arch/um/kernel/ptrace.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/kernel/ptrace.c	2007-03-03 16:23:47.000000000 -0500
+++ linux-2.6.18-mm/arch/um/kernel/ptrace.c	2007-03-03 16:26:42.000000000 -0500
@@ -3,261 +3,29 @@
  * Licensed under the GPL
  */
 
-#include "linux/sched.h"
-#include "linux/mm.h"
-#include "linux/errno.h"
-#include "linux/smp_lock.h"
-#include "linux/security.h"
-#include "linux/ptrace.h"
-#include "linux/audit.h"
-#ifdef CONFIG_PROC_MM
-#include "linux/proc_mm.h"
-#endif
-#include "asm/ptrace.h"
-#include "asm/uaccess.h"
-#include "kern_util.h"
-#include "skas_ptrace.h"
-#include "sysdep/ptrace.h"
-#include "os.h"
-
-static inline void set_singlestepping(struct task_struct *child, int on)
+#include <linux/audit.h>
+#include <linux/elf.h>
+#include <linux/module.h>
+#include <linux/ptrace.h>
+#include <linux/tracehook.h>
+
+const struct utrace_regset_view utrace_um_native = {
+	.name		= SUBARCH,
+	.e_machine	= ELF_ARCH,
+	.regsets	= NULL,
+	.n		= 0,
+};
+EXPORT_SYMBOL_GPL(utrace_um_native);
+
+int arch_ptrace(long *req, struct task_struct *child,
+		struct utrace_attached_engine *engine,
+		unsigned long addr, unsigned long data, long *val)
 {
-        if (on)
-                child->ptrace |= PT_DTRACE;
-        else
-                child->ptrace &= ~PT_DTRACE;
-        child->thread.singlestep_syscall = 0;
-
-#ifdef SUBARCH_SET_SINGLESTEPPING
-        SUBARCH_SET_SINGLESTEPPING(child, on);
-#endif
+	return -ENOSYS;
 }
 
-/*
- * Called by kernel/ptrace.c when detaching..
- */
-void ptrace_disable(struct task_struct *child)
-{ 
-        set_singlestepping(child,0);
-}
-
-extern int peek_user(struct task_struct * child, long addr, long data);
-extern int poke_user(struct task_struct * child, long addr, long data);
-
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
-{
-	int i, ret;
-	unsigned long __user *p = (void __user *)(unsigned long)data;
-
-	switch (request) {
-		/* when I and D space are separate, these will need to be fixed. */
-	case PTRACE_PEEKTEXT: /* read word at location addr. */ 
-	case PTRACE_PEEKDATA: {
-		unsigned long tmp;
-		int copied;
-
-		ret = -EIO;
-		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		if (copied != sizeof(tmp))
-			break;
-		ret = put_user(tmp, p);
-		break;
-	}
-
-	/* read the word at location addr in the USER area. */
-        case PTRACE_PEEKUSR:
-                ret = peek_user(child, addr, data);
-                break;
-
-	/* when I and D space are separate, this will have to be fixed. */
-	case PTRACE_POKETEXT: /* write the word at location addr. */
-	case PTRACE_POKEDATA:
-		ret = -EIO;
-		if (access_process_vm(child, addr, &data, sizeof(data), 
-				      1) != sizeof(data))
-			break;
-		ret = 0;
-		break;
-
-	case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
-                ret = poke_user(child, addr, data);
-                break;
-
-	case PTRACE_SYSCALL: /* continue and stop at next (return from) syscall */
-	case PTRACE_CONT: { /* restart after signal. */
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-
-                set_singlestepping(child, 0);
-		if (request == PTRACE_SYSCALL) {
-			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		}
-		else {
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		}
-		child->exit_code = data;
-		wake_up_process(child);
-		ret = 0;
-		break;
-	}
-
-/*
- * make the child exit.  Best I can do is send it a sigkill. 
- * perhaps it should be put in the status that it wants to 
- * exit.
- */
-	case PTRACE_KILL: {
-		ret = 0;
-		if (child->exit_state == EXIT_ZOMBIE)	/* already dead */
-			break;
-
-                set_singlestepping(child, 0);
-		child->exit_code = SIGKILL;
-		wake_up_process(child);
-		break;
-	}
-
-	case PTRACE_SINGLESTEP: {  /* set the trap flag. */
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-                set_singlestepping(child, 1);
-		child->exit_code = data;
-		/* give it a chance to run. */
-		wake_up_process(child);
-		ret = 0;
-		break;
-	}
-
-	case PTRACE_DETACH:
-		/* detach a process that was attached. */
-		ret = ptrace_detach(child, data);
- 		break;
-
-#ifdef PTRACE_GETREGS
-	case PTRACE_GETREGS: { /* Get all gp regs from the child. */
-		if (!access_ok(VERIFY_WRITE, p, MAX_REG_OFFSET)) {
-			ret = -EIO;
-			break;
-		}
-		for ( i = 0; i < MAX_REG_OFFSET; i += sizeof(long) ) {
-			__put_user(getreg(child, i), p);
-			p++;
-		}
-		ret = 0;
-		break;
-	}
-#endif
-#ifdef PTRACE_SETREGS
-	case PTRACE_SETREGS: { /* Set all gp regs in the child. */
-		unsigned long tmp = 0;
-		if (!access_ok(VERIFY_READ, p, MAX_REG_OFFSET)) {
-			ret = -EIO;
-			break;
-		}
-		for ( i = 0; i < MAX_REG_OFFSET; i += sizeof(long) ) {
-			__get_user(tmp, p);
-			putreg(child, i, tmp);
-			p++;
-		}
-		ret = 0;
-		break;
-	}
-#endif
-#ifdef PTRACE_GETFPREGS
-	case PTRACE_GETFPREGS: /* Get the child FPU state. */
-		ret = get_fpregs(data, child);
-		break;
-#endif
-#ifdef PTRACE_SETFPREGS
-	case PTRACE_SETFPREGS: /* Set the child FPU state. */
-	        ret = set_fpregs(data, child);
-		break;
-#endif
-#ifdef PTRACE_GETFPXREGS
-	case PTRACE_GETFPXREGS: /* Get the child FPU state. */
-		ret = get_fpxregs(data, child);
-		break;
-#endif
-#ifdef PTRACE_SETFPXREGS
-	case PTRACE_SETFPXREGS: /* Set the child FPU state. */
-		ret = set_fpxregs(data, child);
-		break;
-#endif
-	case PTRACE_GET_THREAD_AREA:
-		ret = ptrace_get_thread_area(child, addr,
-					     (struct user_desc __user *) data);
-		break;
-
-	case PTRACE_SET_THREAD_AREA:
-		ret = ptrace_set_thread_area(child, addr,
-					     (struct user_desc __user *) data);
-		break;
-
-	case PTRACE_FAULTINFO: {
-		/* Take the info from thread->arch->faultinfo,
-		 * but transfer max. sizeof(struct ptrace_faultinfo).
-		 * On i386, ptrace_faultinfo is smaller!
-		 */
-		ret = copy_to_user(p, &child->thread.arch.faultinfo,
-				   sizeof(struct ptrace_faultinfo));
-		if(ret)
-			break;
-		break;
-	}
-
-#ifdef PTRACE_LDT
-	case PTRACE_LDT: {
-		struct ptrace_ldt ldt;
-
-		if(copy_from_user(&ldt, p, sizeof(ldt))){
-			ret = -EIO;
-			break;
-		}
-
-		/* This one is confusing, so just punt and return -EIO for 
-		 * now
-		 */
-		ret = -EIO;
-		break;
-	}
-#endif
-#ifdef CONFIG_PROC_MM
-	case PTRACE_SWITCH_MM: {
-		struct mm_struct *old = child->mm;
-		struct mm_struct *new = proc_mm_get_mm(data);
-
-		if(IS_ERR(new)){
-			ret = PTR_ERR(new);
-			break;
-		}
-
-		atomic_inc(&new->mm_users);
-		child->mm = new;
-		child->active_mm = new;
-		mmput(old);
-		ret = 0;
-		break;
-	}
-#endif
-#ifdef PTRACE_ARCH_PRCTL
-        case PTRACE_ARCH_PRCTL:
-                /* XXX Calls ptrace on the host - needs some SMP thinking */
-                ret = arch_prctl_skas(child, data, (void *) addr);
-                break;
-#endif
-	default:
-		ret = ptrace_request(child, request, addr, data);
-		break;
-	}
-
-	return ret;
-}
-
-void send_sigtrap(struct task_struct *tsk, union uml_pt_regs *regs,
-		  int error_code)
+static void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
+			 int error_code)
 {
 	struct siginfo info;
 
@@ -266,56 +34,39 @@ void send_sigtrap(struct task_struct *ts
 	info.si_code = TRAP_BRKPT;
 
 	/* User-mode eip? */
-	info.si_addr = UPT_IS_USER(regs) ? (void __user *) UPT_IP(regs) : NULL;
+	info.si_addr = UPT_IS_USER(&regs->regs) ?
+		(void __user *) UPT_IP(&regs->regs) : NULL;
 
 	/* Send us the fakey SIGTRAP */
 	force_sig_info(SIGTRAP, &info, tsk);
 }
 
-/* XXX Check PT_DTRACE vs TIF_SINGLESTEP for singlestepping check and
- * PT_PTRACED vs TIF_SYSCALL_TRACE for syscall tracing check
+/* notification of system call entry/exit
+ * - triggered by current->work.syscall_trace
  */
-void syscall_trace(union uml_pt_regs *regs, int entryexit)
+void do_syscall_trace(struct pt_regs *regs, int entryexit)
 {
-	int is_singlestep = (current->ptrace & PT_DTRACE) && entryexit;
-	int tracesysgood;
+	/* do the secure computing check first */
+	if (!entryexit)
+		secure_computing(PT_REGS_SYSCALL_NR(regs));
+
+	if (unlikely(current->audit_context) && entryexit)
+		audit_syscall_exit(AUDITSC_RESULT(UPT_SYSCALL_RET(regs)),
+				   UPT_SYSCALL_RET(regs));
+
+	if (test_thread_flag(TIF_SYSCALL_TRACE))
+		tracehook_report_syscall(regs, entryexit);
+
+	if (test_thread_flag(TIF_SINGLESTEP) && entryexit) {
+		send_sigtrap(current, regs, 0);	/* XXX */
+		tracehook_report_syscall_step(regs);
+	}
 
-	if (unlikely(current->audit_context)) {
-		if (!entryexit)
-			audit_syscall_entry(HOST_AUDIT_ARCH,
+	if (unlikely(current->audit_context) && !entryexit)
+		audit_syscall_entry(HOST_AUDIT_ARCH,
 					    UPT_SYSCALL_NR(regs),
 					    UPT_SYSCALL_ARG1(regs),
 					    UPT_SYSCALL_ARG2(regs),
 					    UPT_SYSCALL_ARG3(regs),
 					    UPT_SYSCALL_ARG4(regs));
-		else audit_syscall_exit(AUDITSC_RESULT(UPT_SYSCALL_RET(regs)),
-                                        UPT_SYSCALL_RET(regs));
-	}
-
-	/* Fake a debug trap */
-	if (is_singlestep)
-		send_sigtrap(current, regs, 0);
-
-	if (!test_thread_flag(TIF_SYSCALL_TRACE))
-		return;
-
-	if (!(current->ptrace & PT_PTRACED))
-		return;
-
-	/* the 0x80 provides a way for the tracing parent to distinguish
-	   between a syscall stop and SIGTRAP delivery */
-	tracesysgood = (current->ptrace & PT_TRACESYSGOOD);
-	ptrace_notify(SIGTRAP | (tracesysgood ? 0x80 : 0));
-
-	if (entryexit) /* force do_signal() --> is_syscall() */
-		set_thread_flag(TIF_SIGPENDING);
-
-	/* this isn't the same as continuing with a signal, but it will do
-	 * for normal use.  strace only continues with a signal if the
-	 * stopping signal is not SIGTRAP.  -brl
-	 */
-	if (current->exit_code) {
-		send_sig(current->exit_code, current, 1);
-		current->exit_code = 0;
-	}
 }
Index: linux-2.6.18-mm/arch/um/kernel/signal.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/kernel/signal.c	2007-03-03 16:20:36.000000000 -0500
+++ linux-2.6.18-mm/arch/um/kernel/signal.c	2007-03-03 16:26:42.000000000 -0500
@@ -14,6 +14,7 @@
 #include "linux/tty.h"
 #include "linux/binfmts.h"
 #include "linux/ptrace.h"
+#include "linux/tracehook.h"
 #include "asm/signal.h"
 #include "asm/uaccess.h"
 #include "asm/unistd.h"
@@ -93,6 +94,8 @@ static int handle_signal(struct pt_regs 
 			sigaddset(&current->blocked, signr);
 		recalc_sigpending();
 		spin_unlock_irq(&current->sighand->siglock);
+
+		tracehook_report_handle_signal(signr, ka, oldset, regs);
 	}
 
 	return err;
@@ -148,7 +151,7 @@ static int kern_do_signal(struct pt_regs
 	 * on the host.  The tracing thread will check this flag and
 	 * PTRACE_SYSCALL if necessary.
 	 */
-	if(current->ptrace & PT_DTRACE)
+	if(test_thread_flag(TIF_SYSCALL_TRACE))
 		current->thread.singlestep_syscall =
 			is_syscall(PT_REGS_IP(&current->thread.regs));
 
Index: linux-2.6.18-mm/arch/um/kernel/skas/syscall.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/kernel/skas/syscall.c	2007-03-03 16:20:36.000000000 -0500
+++ linux-2.6.18-mm/arch/um/kernel/skas/syscall.c	2007-03-03 16:26:42.000000000 -0500
@@ -19,8 +19,6 @@ void handle_syscall(union uml_pt_regs *r
 	long result;
 	int syscall;
 
-	syscall_trace(r, 0);
-
 	current->thread.nsyscalls++;
 	nsyscalls++;
 
@@ -38,6 +36,4 @@ void handle_syscall(union uml_pt_regs *r
 	else result = EXECUTE_SYSCALL(syscall, regs);
 
 	REGS_SET_SYSCALL_RETURN(r->skas.regs, result);
-
-	syscall_trace(r, 1);
 }
Index: linux-2.6.18-mm/arch/um/sys-i386/signal.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/sys-i386/signal.c	2007-03-03 16:20:36.000000000 -0500
+++ linux-2.6.18-mm/arch/um/sys-i386/signal.c	2007-03-03 16:26:42.000000000 -0500
@@ -267,8 +267,6 @@ int setup_signal_stack_sc(unsigned long 
 	PT_REGS_EDX(regs) = (unsigned long) 0;
 	PT_REGS_ECX(regs) = (unsigned long) 0;
 
-	if ((current->ptrace & PT_DTRACE) && (current->ptrace & PT_PTRACED))
-		ptrace_notify(SIGTRAP);
 	return 0;
 
 err:
@@ -324,8 +322,6 @@ int setup_signal_stack_si(unsigned long 
 	PT_REGS_EDX(regs) = (unsigned long) &frame->info;
 	PT_REGS_ECX(regs) = (unsigned long) &frame->uc;
 
-	if ((current->ptrace & PT_DTRACE) && (current->ptrace & PT_PTRACED))
-		ptrace_notify(SIGTRAP);
 	return 0;
 
 err:
Index: linux-2.6.18-mm/include/asm-um/ptrace-generic.h
===================================================================
--- linux-2.6.18-mm.orig/include/asm-um/ptrace-generic.h	2007-03-03 16:20:36.000000000 -0500
+++ linux-2.6.18-mm/include/asm-um/ptrace-generic.h	2007-03-03 16:26:42.000000000 -0500
@@ -44,9 +44,6 @@ extern int set_fpxregs(unsigned long buf
 
 extern void show_regs(struct pt_regs *regs);
 
-extern void send_sigtrap(struct task_struct *tsk, union uml_pt_regs *regs,
-			 int error_code);
-
 extern int arch_copy_tls(struct task_struct *new);
 extern void clear_flushed_tls(struct task_struct *task);
 
Index: linux-2.6.18-mm/include/asm-um/ptrace-i386.h
===================================================================
--- linux-2.6.18-mm.orig/include/asm-um/ptrace-i386.h	2007-03-03 16:20:36.000000000 -0500
+++ linux-2.6.18-mm/include/asm-um/ptrace-i386.h	2007-03-03 16:26:42.000000000 -0500
@@ -6,6 +6,8 @@
 #ifndef __UM_PTRACE_I386_H
 #define __UM_PTRACE_I386_H
 
+#define ARCH_HAS_SINGLE_STEP	(1)
+
 #define HOST_AUDIT_ARCH AUDIT_ARCH_I386
 
 #include "linux/compiler.h"
Index: linux-2.6.18-mm/include/asm-um/ptrace-x86_64.h
===================================================================
--- linux-2.6.18-mm.orig/include/asm-um/ptrace-x86_64.h	2007-03-03 16:23:49.000000000 -0500
+++ linux-2.6.18-mm/include/asm-um/ptrace-x86_64.h	2007-03-03 16:26:42.000000000 -0500
@@ -14,6 +14,8 @@
 #define __FRAME_OFFSETS /* Needed to get the R* macros */
 #include "asm/ptrace-generic.h"
 
+#define ARCH_HAS_SINGLE_STEP	(1)
+
 #define HOST_AUDIT_ARCH AUDIT_ARCH_X86_64
 
 /* Also defined in sysdep/ptrace.h, so may already be defined. */
Index: linux-2.6.18-mm/include/asm-um/tracehook.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.18-mm/include/asm-um/tracehook.h	2007-03-03 16:26:42.000000000 -0500
@@ -0,0 +1,64 @@
+/*
+ * Tracing hooks, i386 CPU support
+ *
+ * Copyright (C) 2006, 2007 Red Hat, Inc.  All rights reserved.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License v.2.
+ *
+ * Red Hat Author: Roland McGrath.
+ *
+ * Munged for UML - jdike@{addtoit,linux.intel}.com
+ */
+
+#ifndef _ASM_TRACEHOOK_H
+#define _ASM_TRACEHOOK_H	1
+
+#include <linux/sched.h>
+#include <asm/ptrace.h>
+#include <asm/thread_info.h>
+
+/*
+ * See linux/tracehook.h for the descriptions of what these need to do.
+ */
+
+static inline void tracehook_enable_single_step(struct task_struct *tsk)
+{
+	set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
+}
+
+static inline void tracehook_disable_single_step(struct task_struct *tsk)
+{
+	clear_tsk_thread_flag(tsk, TIF_SINGLESTEP);
+}
+
+static inline int tracehook_single_step_enabled(struct task_struct *tsk)
+{
+	return test_tsk_thread_flag(tsk, TIF_SINGLESTEP);
+}
+
+static inline void tracehook_enable_syscall_trace(struct task_struct *tsk)
+{
+	set_tsk_thread_flag(tsk, TIF_SYSCALL_TRACE);
+}
+
+static inline void tracehook_disable_syscall_trace(struct task_struct *tsk)
+{
+	clear_tsk_thread_flag(tsk, TIF_SYSCALL_TRACE);
+}
+
+static inline void tracehook_abort_syscall(struct pt_regs *regs)
+{
+	PT_REGS_SYSCALL_NR(regs) = -1;
+}
+
+extern const struct utrace_regset_view utrace_um_native;
+static inline const struct utrace_regset_view *
+utrace_native_view(struct task_struct *tsk)
+{
+	return &utrace_um_native;
+}
+
+
+#endif
