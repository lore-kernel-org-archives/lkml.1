Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab0BBS7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 13:59:40 -0500
Received: from verein.lst.de ([213.95.11.210]:38008 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756877Ab0BBS7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 13:59:37 -0500
Date: Tue, 2 Feb 2010 19:59:07 +0100
From: Christoph Hellwig <hch@lst.de>
To: roland@redhat.com, oleg@redhat.com, akpm@linux-foundation.org,
       vapier@gentoo.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 5/14] blackfin: use generic ptrace_resume code
Message-ID: <20100202185907.GE3630@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/blackfin/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/blackfin/kernel/ptrace.c	2010-02-02 11:00:49.917253804 +0100
+++ linux-2.6/arch/blackfin/kernel/ptrace.c	2010-02-02 11:18:07.673254085 +0100
@@ -160,7 +160,15 @@ static inline int is_user_addr_valid(str
 	return -EIO;
 }
 
-void ptrace_enable(struct task_struct *child)
+void user_disable_single_step(struct task_struct *child)
+{
+	unsigned long tmp;
+	/* make sure the single step bit is not set. */
+	tmp = get_reg(child, PT_SYSCFG) & ~TRACE_BITS;
+	put_reg(child, PT_SYSCFG, tmp);
+}
+
+void user_enable_single_step(struct task_struct *child)
 {
 	unsigned long tmp;
 	tmp = get_reg(child, PT_SYSCFG) | (TRACE_BITS);
@@ -174,10 +182,7 @@ void ptrace_enable(struct task_struct *c
  */
 void ptrace_disable(struct task_struct *child)
 {
-	unsigned long tmp;
-	/* make sure the single step bit is not set. */
-	tmp = get_reg(child, PT_SYSCFG) & ~TRACE_BITS;
-	put_reg(child, PT_SYSCFG, tmp);
+	user_disable_single_step(child);
 }
 
 long arch_ptrace(struct task_struct *child, long request, long addr, long data)
@@ -354,50 +359,6 @@ long arch_ptrace(struct task_struct *chi
 		ret = put_reg(child, addr, data);
 		break;
 
-	case PTRACE_SYSCALL:	/* continue and stop at next (return from) syscall */
-	case PTRACE_CONT:	/* restart after signal. */
-		pr_debug("ptrace: syscall/cont\n");
-
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		if (request == PTRACE_SYSCALL)
-			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		else
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		child->exit_code = data;
-		ptrace_disable(child);
-		pr_debug("ptrace: before wake_up_process\n");
-		wake_up_process(child);
-		ret = 0;
-		break;
-
-	/*
-	 * make the child exit.  Best I can do is send it a sigkill.
-	 * perhaps it should be put in the status that it wants to
-	 * exit.
-	 */
-	case PTRACE_KILL:
-		ret = 0;
-		if (child->exit_state == EXIT_ZOMBIE)	/* already dead */
-			break;
-		child->exit_code = SIGKILL;
-		ptrace_disable(child);
-		wake_up_process(child);
-		break;
-
-	case PTRACE_SINGLESTEP:	/* set the trap flag. */
-		pr_debug("ptrace: single step\n");
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		ptrace_enable(child);
-		child->exit_code = data;
-		wake_up_process(child);
-		ret = 0;
-		break;
-
 	case PTRACE_GETREGS:
 		/* Get all gp regs from the child. */
 		ret = ptrace_getregs(child, datap);
Index: linux-2.6/arch/blackfin/include/asm/ptrace.h
===================================================================
--- linux-2.6.orig/arch/blackfin/include/asm/ptrace.h	2010-02-02 11:16:35.673022299 +0100
+++ linux-2.6/arch/blackfin/include/asm/ptrace.h	2010-02-02 11:18:14.244006444 +0100
@@ -97,6 +97,8 @@ struct pt_regs {
 
 #ifdef __KERNEL__
 
+#define arch_has_single_step()	(1)
+
 /* user_mode returns true if only one bit is set in IPEND, other than the
    master interrupt enable.  */
 #define user_mode(regs) (!(((regs)->ipend & ~0x10) & (((regs)->ipend & ~0x10) - 1)))
