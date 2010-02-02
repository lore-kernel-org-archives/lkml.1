Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab0BBTBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 14:01:10 -0500
Received: from verein.lst.de ([213.95.11.210]:38059 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110Ab0BBTA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 14:00:57 -0500
Date: Tue, 2 Feb 2010 20:00:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: roland@redhat.com, oleg@redhat.com, akpm@linux-foundation.org,
       starvik@axis.com, jesper.nilsson@axis.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH, RFC 13/14] cris arch-v32: use generic ptrace_resume code
Message-ID: <20100202190042.GM3630@lst.de>
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

The way breakpoints are disabled is entirely inconsistent
currently, I tried to make some sense of it, but I suspect all of the
content of ptrace_disable should be moved into user_disable_single_step,
this defintively needs some revisting as the current patch changes
behaviour in not quite designed ways.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/cris/arch-v32/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v32/kernel/ptrace.c	2010-02-02 19:23:12.314003057 +0100
+++ linux-2.6/arch/cris/arch-v32/kernel/ptrace.c	2010-02-02 19:25:27.396253967 +0100
@@ -78,6 +78,35 @@ int put_reg(struct task_struct *task, un
 	return 0;
 }
 
+void user_enable_single_step(struct task_struct *child)
+{
+	unsigned long tmp;
+
+	/*
+	 * Set up SPC if not set already (in which case we have no other
+	 * choice but to trust it).
+	 */
+	if (!get_reg(child, PT_SPC)) {
+		/* In case we're stopped in a delay slot. */
+		tmp = get_reg(child, PT_ERP) & ~1;
+		put_reg(child, PT_SPC, tmp);
+	}
+	tmp = get_reg(child, PT_CCS) | SBIT_USER;
+	put_reg(child, PT_CCS, tmp);
+}
+
+void user_disable_single_step(struct task_struct *child)
+{
+	put_reg(child, PT_SPC, 0);
+
+	if (!get_debugreg(child->pid, PT_BP_CTRL)) {
+		unsigned long tmp;
+		/* If no h/w bp configured, disable S bit. */
+		tmp = get_reg(child, PT_CCS) & ~SBIT_USER;
+		put_reg(child, PT_CCS, tmp);
+	}
+}
+
 /*
  * Called by kernel/ptrace.c when detaching.
  *
@@ -89,8 +118,7 @@ ptrace_disable(struct task_struct *child
 	unsigned long tmp;
 
 	/* Deconfigure SPC and S-bit. */
-	tmp = get_reg(child, PT_CCS) & ~SBIT_USER;
-	put_reg(child, PT_CCS, tmp);
+	user_disable_single_step(child);
 	put_reg(child, PT_SPC, 0);
 
 	/* Deconfigure any watchpoints associated with the child. */
@@ -163,83 +191,6 @@ long arch_ptrace(struct task_struct *chi
 			ret = 0;
 			break;
 
-		case PTRACE_SYSCALL:
-		case PTRACE_CONT:
-			ret = -EIO;
-
-			if (!valid_signal(data))
-				break;
-
-			/* Continue means no single-step. */
-			put_reg(child, PT_SPC, 0);
-
-			if (!get_debugreg(child->pid, PT_BP_CTRL)) {
-				unsigned long tmp;
-				/* If no h/w bp configured, disable S bit. */
-				tmp = get_reg(child, PT_CCS) & ~SBIT_USER;
-				put_reg(child, PT_CCS, tmp);
-			}
-
-			if (request == PTRACE_SYSCALL) {
-				set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-			}
-			else {
-				clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-			}
-
-			child->exit_code = data;
-
-			/* TODO: make sure any pending breakpoint is killed */
-			wake_up_process(child);
-			ret = 0;
-
-			break;
-
-		/* Make the child exit by sending it a sigkill. */
-		case PTRACE_KILL:
-			ret = 0;
-
-			if (child->exit_state == EXIT_ZOMBIE)
-				break;
-
-			child->exit_code = SIGKILL;
-
-			/* Deconfigure single-step and h/w bp. */
-			ptrace_disable(child);
-
-			/* TODO: make sure any pending breakpoint is killed */
-			wake_up_process(child);
-			break;
-
-		/* Set the trap flag. */
-		case PTRACE_SINGLESTEP:	{
-			unsigned long tmp;
-			ret = -EIO;
-
-			/* Set up SPC if not set already (in which case we have
-			   no other choice but to trust it). */
-			if (!get_reg(child, PT_SPC)) {
-				/* In case we're stopped in a delay slot. */
-				tmp = get_reg(child, PT_ERP) & ~1;
-				put_reg(child, PT_SPC, tmp);
-			}
-			tmp = get_reg(child, PT_CCS) | SBIT_USER;
-			put_reg(child, PT_CCS, tmp);
-
-			if (!valid_signal(data))
-				break;
-
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-
-			/* TODO: set some clever breakpoint mechanism... */
-
-			child->exit_code = data;
-			wake_up_process(child);
-			ret = 0;
-			break;
-
-		}
-
 		/* Get all GP registers from the child. */
 		case PTRACE_GETREGS: {
 			int i;
Index: linux-2.6/arch/cris/include/arch-v32/arch/ptrace.h
===================================================================
--- linux-2.6.orig/arch/cris/include/arch-v32/arch/ptrace.h	2010-02-02 19:25:39.092254418 +0100
+++ linux-2.6/arch/cris/include/arch-v32/arch/ptrace.h	2010-02-02 19:25:46.173254455 +0100
@@ -108,6 +108,7 @@ struct switch_stack {
 
 #ifdef __KERNEL__
 
+#define arch_has_single_step() (1)
 #define user_mode(regs) (((regs)->ccs & (1 << (U_CCS_BITNR + CCS_SHIFT))) != 0)
 #define instruction_pointer(regs) ((regs)->erp)
 extern void show_regs(struct pt_regs *);
