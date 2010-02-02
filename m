Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab0BBTAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 14:00:31 -0500
Received: from verein.lst.de ([213.95.11.210]:38042 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110Ab0BBTAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 14:00:23 -0500
Date: Tue, 2 Feb 2010 20:00:09 +0100
From: Christoph Hellwig <hch@lst.de>
To: roland@redhat.com, oleg@redhat.com, akpm@linux-foundation.org,
       jdike@addtoit.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 10/14] um: use generic ptrace_resume code
Message-ID: <20100202190009.GJ3630@lst.de>
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
which it previously wasn't which is consistent with all architectures
using the modern ptrace code.

XXX: I'm not sure arch_has_single_step() is placed in the exactly correct
location, please verify in which of the ptrace headers it should really be.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/um/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/um/kernel/ptrace.c	2010-02-02 11:00:50.048254427 +0100
+++ linux-2.6/arch/um/kernel/ptrace.c	2010-02-02 11:27:05.412275969 +0100
@@ -12,16 +12,25 @@
 #endif
 #include "skas_ptrace.h"
 
-static inline void set_singlestepping(struct task_struct *child, int on)
+
+
+void user_enable_single_step(struct task_struct *child)
 {
-	if (on)
-		child->ptrace |= PT_DTRACE;
-	else
-		child->ptrace &= ~PT_DTRACE;
+	child->ptrace |= PT_DTRACE;
 	child->thread.singlestep_syscall = 0;
 
 #ifdef SUBARCH_SET_SINGLESTEPPING
-	SUBARCH_SET_SINGLESTEPPING(child, on);
+	SUBARCH_SET_SINGLESTEPPING(child, 1);
+#endif
+}
+
+void user_disable_single_step(struct task_struct *child)
+{
+	child->ptrace &= ~PT_DTRACE;
+	child->thread.singlestep_syscall = 0;
+
+#ifdef SUBARCH_SET_SINGLESTEPPING
+	SUBARCH_SET_SINGLESTEPPING(child, 0);
 #endif
 }
 
@@ -30,7 +39,7 @@ static inline void set_singlestepping(st
  */
 void ptrace_disable(struct task_struct *child)
 {
-	set_singlestepping(child,0);
+	user_disable_single_step(child);
 }
 
 extern int peek_user(struct task_struct * child, long addr, long data);
@@ -57,53 +66,6 @@ long arch_ptrace(struct task_struct *chi
 		ret = -EIO;
 		break;
 
-	/* continue and stop at next (return from) syscall */
-	case PTRACE_SYSCALL:
-	/* restart after signal. */
-	case PTRACE_CONT: {
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-
-		set_singlestepping(child, 0);
-		if (request == PTRACE_SYSCALL)
-			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		else clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
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
-		set_singlestepping(child, 0);
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
-		set_singlestepping(child, 1);
-		child->exit_code = data;
-		/* give it a chance to run. */
-		wake_up_process(child);
-		ret = 0;
-		break;
-	}
-
 #ifdef PTRACE_GETREGS
 	case PTRACE_GETREGS: { /* Get all gp regs from the child. */
 		if (!access_ok(VERIFY_WRITE, p, MAX_REG_OFFSET)) {
Index: linux-2.6/arch/um/include/asm/ptrace-generic.h
===================================================================
--- linux-2.6.orig/arch/um/include/asm/ptrace-generic.h	2010-02-02 11:27:09.196004106 +0100
+++ linux-2.6/arch/um/include/asm/ptrace-generic.h	2010-02-02 11:28:57.615023962 +0100
@@ -16,6 +16,8 @@ struct pt_regs {
 	struct uml_pt_regs regs;
 };
 
+#define arch_has_single_step()	(1)
+
 #define EMPTY_REGS { .regs = EMPTY_UML_PT_REGS }
 
 #define PT_REGS_IP(r) UPT_IP(&(r)->regs)
