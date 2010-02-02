Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab0BBTAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 14:00:49 -0500
Received: from verein.lst.de ([213.95.11.210]:38051 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756879Ab0BBTAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 14:00:43 -0500
Date: Tue, 2 Feb 2010 20:00:20 +0100
From: Christoph Hellwig <hch@lst.de>
To: roland@redhat.com, oleg@redhat.com, akpm@linux-foundation.org,
       chris@zankel.net
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 11/14] xtensa: use generic ptrace_resume code
Message-ID: <20100202190020.GK3630@lst.de>
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

Index: linux-2.6/arch/xtensa/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/xtensa/kernel/ptrace.c	2010-02-02 19:18:16.218004699 +0100
+++ linux-2.6/arch/xtensa/kernel/ptrace.c	2010-02-02 19:21:56.730004589 +0100
@@ -30,6 +30,17 @@
 #include <asm/elf.h>
 #include <asm/coprocessor.h>
 
+
+void user_enable_single_step(struct task_struct *child)
+{
+	child->ptrace |= PT_SINGLESTEP;
+}
+
+void user_disable_single_step(struct task_struct *child)
+{
+	child->ptrace &= ~PT_SINGLESTEP;
+}
+
 /*
  * Called by kernel/ptrace.c when detaching to disable single stepping.
  */
@@ -258,51 +269,6 @@ long arch_ptrace(struct task_struct *chi
 		ret = ptrace_pokeusr(child, addr, data);
 		break;
 
-	/* continue and stop at next (return from) syscall */
-
-	case PTRACE_SYSCALL:
-	case PTRACE_CONT: /* restart after signal. */
-	{
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		if (request == PTRACE_SYSCALL)
-			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		else
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		child->exit_code = data;
-		/* Make sure the single step bit is not set. */
-		child->ptrace &= ~PT_SINGLESTEP;
-		wake_up_process(child);
-		ret = 0;
-		break;
-	}
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
-		child->ptrace &= ~PT_SINGLESTEP;
-		wake_up_process(child);
-		break;
-
-	case PTRACE_SINGLESTEP:
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		child->ptrace |= PT_SINGLESTEP;
-		child->exit_code = data;
-		wake_up_process(child);
-		ret = 0;
-		break;
-
 	case PTRACE_GETREGS:
 		ret = ptrace_getregs(child, (void __user *) data);
 		break;
Index: linux-2.6/arch/xtensa/include/asm/ptrace.h
===================================================================
--- linux-2.6.orig/arch/xtensa/include/asm/ptrace.h	2010-02-02 19:18:16.234010089 +0100
+++ linux-2.6/arch/xtensa/include/asm/ptrace.h	2010-02-02 19:21:56.730004589 +0100
@@ -113,6 +113,7 @@ struct pt_regs {
 
 #include <variant/core.h>
 
+# define arch_has_single_step()	(1)
 # define task_pt_regs(tsk) ((struct pt_regs*) \
   (task_stack_page(tsk) + KERNEL_STACK_SIZE - (XCHAL_NUM_AREGS-16)*4) - 1)
 # define user_mode(regs) (((regs)->ps & 0x00000020)!=0)
