Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908Ab0BBS7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 13:59:25 -0500
Received: from verein.lst.de ([213.95.11.210]:37997 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756870Ab0BBS7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 13:59:20 -0500
Date: Tue, 2 Feb 2010 19:58:57 +0100
From: Christoph Hellwig <hch@lst.de>
To: roland@redhat.com, oleg@redhat.com, akpm@linux-foundation.org,
       hskinnemoen@atmel.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 4/14] avr32: use generic ptrace_resume code
Message-ID: <20100202185857.GD3630@lst.de>
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

Currently avr32 doesn't implement any code to disable single stepping
when one of the non-syscall requests is called which seems wrong,
but I've left it as-is for now.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/avr32/include/asm/ptrace.h
===================================================================
--- linux-2.6.orig/arch/avr32/include/asm/ptrace.h	2010-02-02 11:14:51.257023230 +0100
+++ linux-2.6/arch/avr32/include/asm/ptrace.h	2010-02-02 11:15:00.220025002 +0100
@@ -124,6 +124,8 @@ struct pt_regs {
 
 #include <asm/ocd.h>
 
+#define arch_has_single_step()		(1)
+
 #define arch_ptrace_attach(child)       ocd_enable(child)
 
 #define user_mode(regs)                 (((regs)->sr & MODE_MASK) == MODE_USER)
Index: linux-2.6/arch/avr32/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/avr32/kernel/ptrace.c	2010-02-02 11:14:51.269004225 +0100
+++ linux-2.6/arch/avr32/kernel/ptrace.c	2010-02-02 11:15:40.045282945 +0100
@@ -28,9 +28,9 @@ static struct pt_regs *get_user_regs(str
 				  THREAD_SIZE - sizeof(struct pt_regs));
 }
 
-static void ptrace_single_step(struct task_struct *tsk)
+static void user_enable_single_step(struct task_struct *tsk)
 {
-	pr_debug("ptrace_single_step: pid=%u, PC=0x%08lx, SR=0x%08lx\n",
+	pr_debug("user_enable_single_step: pid=%u, PC=0x%08lx, SR=0x%08lx\n",
 		 tsk->pid, task_pt_regs(tsk)->pc, task_pt_regs(tsk)->sr);
 
 	/*
@@ -49,6 +49,11 @@ static void ptrace_single_step(struct ta
 	set_tsk_thread_flag(tsk, TIF_SINGLE_STEP);
 }
 
+void user_disable_single_step(struct task_struct *child)
+{
+	/* XXX(hch): a no-op here seems wrong.. */
+}
+
 /*
  * Called by kernel/ptrace.c when detaching
  *
@@ -156,50 +161,6 @@ long arch_ptrace(struct task_struct *chi
 		ret = ptrace_write_user(child, addr, data);
 		break;
 
-	/* continue and stop at next (return from) syscall */
-	case PTRACE_SYSCALL:
-	/* restart after signal */
-	case PTRACE_CONT:
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		if (request == PTRACE_SYSCALL)
-			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		else
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		child->exit_code = data;
-		/* XXX: Are we sure no breakpoints are active here? */
-		wake_up_process(child);
-		ret = 0;
-		break;
-
-	/*
-	 * Make the child exit. Best I can do is send it a
-	 * SIGKILL. Perhaps it should be put in the status that it
-	 * wants to exit.
-	 */
-	case PTRACE_KILL:
-		ret = 0;
-		if (child->exit_state == EXIT_ZOMBIE)
-			break;
-		child->exit_code = SIGKILL;
-		wake_up_process(child);
-		break;
-
-	/*
-	 * execute single instruction.
-	 */
-	case PTRACE_SINGLESTEP:
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		ptrace_single_step(child);
-		child->exit_code = data;
-		wake_up_process(child);
-		ret = 0;
-		break;
-
 	case PTRACE_GETREGS:
 		ret = ptrace_getregs(child, (void __user *)data);
 		break;
