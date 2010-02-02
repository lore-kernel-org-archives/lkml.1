Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab0BBS7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 13:59:17 -0500
Received: from verein.lst.de ([213.95.11.210]:37994 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756376Ab0BBS7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 13:59:13 -0500
Date: Tue, 2 Feb 2010 19:58:47 +0100
From: Christoph Hellwig <hch@lst.de>
To: roland@redhat.com, oleg@redhat.com, akpm@linux-foundation.org,
       linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 3/14] arm: use generic ptrace_resume code
Message-ID: <20100202185847.GC3630@lst.de>
References: <20100202185755.GA3630@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100202185755.GA3630@lst.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic ptrace_resume code for PTRACE_SYSCALL, PTRACE_CONT,
PTRACE_KILL and PTRACE_SINGLESTEP.  This implies defining
arch_has_single_step in <asm/ptrace.h> and implementing the
user_enable_single_step and user_disable_single_step functions, which
also causes the breakpoint information to be cleared on fork, which
could be considered a bug fix.

Also the TIF_SYSCALL_TRACE thread flag is now cleared on PTRACE_KILL
which it previously wasn't and the single stepping disable only happens
if the tracee process isn't a zombie yet, which is consistent with all
architectures using the modern ptrace code.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/arm/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/ptrace.c	2010-02-02 11:00:49.883004121 +0100
+++ linux-2.6/arch/arm/kernel/ptrace.c	2010-02-02 11:10:20.549264275 +0100
@@ -452,12 +452,23 @@ void ptrace_cancel_bpt(struct task_struc
 		clear_breakpoint(child, &child->thread.debug.bp[i]);
 }
 
+void user_disable_single_step(struct task_struct *task)
+{
+	task->ptrace &= ~PT_SINGLESTEP;
+	ptrace_cancel_bpt(task);
+}
+
+void user_enable_single_step(struct task_struct *task)
+{
+	task->ptrace |= PT_SINGLESTEP;
+}
+
 /*
  * Called by kernel/ptrace.c when detaching..
  */
 void ptrace_disable(struct task_struct *child)
 {
-	single_step_disable(child);
+	user_disable_single_step(child);
 }
 
 /*
@@ -723,53 +734,6 @@ long arch_ptrace(struct task_struct *chi
 			ret = ptrace_write_user(child, addr, data);
 			break;
 
-		/*
-		 * continue/restart and stop at next (return from) syscall
-		 */
-		case PTRACE_SYSCALL:
-		case PTRACE_CONT:
-			ret = -EIO;
-			if (!valid_signal(data))
-				break;
-			if (request == PTRACE_SYSCALL)
-				set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-			else
-				clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-			child->exit_code = data;
-			single_step_disable(child);
-			wake_up_process(child);
-			ret = 0;
-			break;
-
-		/*
-		 * make the child exit.  Best I can do is send it a sigkill.
-		 * perhaps it should be put in the status that it wants to
-		 * exit.
-		 */
-		case PTRACE_KILL:
-			single_step_disable(child);
-			if (child->exit_state != EXIT_ZOMBIE) {
-				child->exit_code = SIGKILL;
-				wake_up_process(child);
-			}
-			ret = 0;
-			break;
-
-		/*
-		 * execute single instruction.
-		 */
-		case PTRACE_SINGLESTEP:
-			ret = -EIO;
-			if (!valid_signal(data))
-				break;
-			single_step_enable(child);
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-			child->exit_code = data;
-			/* give it a chance to run. */
-			wake_up_process(child);
-			ret = 0;
-			break;
-
 		case PTRACE_GETREGS:
 			ret = ptrace_getregs(child, (void __user *)data);
 			break;
Index: linux-2.6/arch/arm/kernel/ptrace.h
===================================================================
--- linux-2.6.orig/arch/arm/kernel/ptrace.h	2010-02-02 11:00:49.892003451 +0100
+++ linux-2.6/arch/arm/kernel/ptrace.h	2010-02-02 11:08:43.476003178 +0100
@@ -14,20 +14,6 @@ extern void ptrace_set_bpt(struct task_s
 extern void ptrace_break(struct task_struct *, struct pt_regs *);
 
 /*
- * make sure single-step breakpoint is gone.
- */
-static inline void single_step_disable(struct task_struct *task)
-{
-	task->ptrace &= ~PT_SINGLESTEP;
-	ptrace_cancel_bpt(task);
-}
-
-static inline void single_step_enable(struct task_struct *task)
-{
-	task->ptrace |= PT_SINGLESTEP;
-}
-
-/*
  * Send SIGTRAP if we're single-stepping
  */
 static inline void single_step_trap(struct task_struct *task)
Index: linux-2.6/arch/arm/include/asm/ptrace.h
===================================================================
--- linux-2.6.orig/arch/arm/include/asm/ptrace.h	2010-02-02 11:08:55.072253922 +0100
+++ linux-2.6/arch/arm/include/asm/ptrace.h	2010-02-02 11:09:10.909066877 +0100
@@ -128,6 +128,8 @@ struct pt_regs {
 
 #ifdef __KERNEL__
 
+#define arch_has_single_step()	(1)
+
 #define user_mode(regs)	\
 	(((regs)->ARM_cpsr & 0xf) == 0)
 
