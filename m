Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926Ab0BBTAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 14:00:10 -0500
Received: from verein.lst.de ([213.95.11.210]:38029 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756922Ab0BBTAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 14:00:03 -0500
Date: Tue, 2 Feb 2010 19:59:25 +0100
From: Christoph Hellwig <hch@lst.de>
To: roland@redhat.com, oleg@redhat.com, akpm@linux-foundation.org,
       ysato@users.sourceforge.jp
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 6/14] h8300: use generic ptrace_resume code
Message-ID: <20100202185925.GF3630@lst.de>
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


Index: linux-2.6/arch/h8300/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/h8300/kernel/ptrace.c	2010-02-02 11:01:22.072254015 +0100
+++ linux-2.6/arch/h8300/kernel/ptrace.c	2010-02-02 11:20:07.256255344 +0100
@@ -34,8 +34,11 @@
 /* cpu depend functions */
 extern long h8300_get_reg(struct task_struct *task, int regno);
 extern int  h8300_put_reg(struct task_struct *task, int regno, unsigned long data);
-extern void h8300_disable_trace(struct task_struct *child);
-extern void h8300_enable_trace(struct task_struct *child);
+
+
+void user_disable_single_step(struct task_struct *child)
+{
+}
 
 /*
  * does not yet catch signals sent when the child dies.
@@ -44,7 +47,7 @@ extern void h8300_enable_trace(struct ta
 
 void ptrace_disable(struct task_struct *child)
 {
-	h8300_disable_trace(child);
+	user_disable_single_step(child);
 }
 
 long arch_ptrace(struct task_struct *child, long request, long addr, long data)
@@ -107,49 +110,6 @@ long arch_ptrace(struct task_struct *chi
 			}
 			ret = -EIO;
 			break ;
-		case PTRACE_SYSCALL: /* continue and stop at next (return from) syscall */
-		case PTRACE_CONT: { /* restart after signal. */
-			ret = -EIO;
-			if (!valid_signal(data))
-				break ;
-			if (request == PTRACE_SYSCALL)
-				set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-			else
-				clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-			child->exit_code = data;
-			wake_up_process(child);
-			/* make sure the single step bit is not set. */
-			h8300_disable_trace(child);
-			ret = 0;
-		}
-
-/*
- * make the child exit.  Best I can do is send it a sigkill. 
- * perhaps it should be put in the status that it wants to 
- * exit.
- */
-		case PTRACE_KILL: {
-
-			ret = 0;
-			if (child->exit_state == EXIT_ZOMBIE) /* already dead */
-				break;
-			child->exit_code = SIGKILL;
-			h8300_disable_trace(child);
-			wake_up_process(child);
-			break;
-		}
-
-		case PTRACE_SINGLESTEP: {  /* set the trap flag. */
-			ret = -EIO;
-			if (!valid_signal(data))
-				break;
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-			child->exit_code = data;
-			h8300_enable_trace(child);
-			wake_up_process(child);
-			ret = 0;
-			break;
-		}
 
 		case PTRACE_GETREGS: { /* Get all gp regs from the child. */
 		  	int i;
Index: linux-2.6/arch/h8300/platform/h8300h/ptrace_h8300h.c
===================================================================
--- linux-2.6.orig/arch/h8300/platform/h8300h/ptrace_h8300h.c	2010-02-02 11:00:49.957253800 +0100
+++ linux-2.6/arch/h8300/platform/h8300h/ptrace_h8300h.c	2010-02-02 11:19:15.327003827 +0100
@@ -60,7 +60,7 @@ int h8300_put_reg(struct task_struct *ta
 }
 
 /* disable singlestep */
-void h8300_disable_trace(struct task_struct *child)
+void user_disable_single_step(struct task_struct *child)
 {
 	if((long)child->thread.breakinfo.addr != -1L) {
 		*child->thread.breakinfo.addr = child->thread.breakinfo.inst;
@@ -264,7 +264,7 @@ static unsigned short *getnextpc(struct 
 
 /* Set breakpoint(s) to simulate a single step from the current PC.  */
 
-void h8300_enable_trace(struct task_struct *child)
+void user_enable_single_step(struct task_struct *child)
 {
 	unsigned short *nextpc;
 	nextpc = getnextpc(child,(unsigned short *)h8300_get_reg(child, PT_PC));
@@ -276,7 +276,7 @@ void h8300_enable_trace(struct task_stru
 asmlinkage void trace_trap(unsigned long bp)
 {
 	if ((unsigned long)current->thread.breakinfo.addr == bp) {
-		h8300_disable_trace(current);
+		user_disable_single_step(current);
 		force_sig(SIGTRAP,current);
 	} else
 	        force_sig(SIGILL,current);
Index: linux-2.6/arch/h8300/platform/h8s/ptrace_h8s.c
===================================================================
--- linux-2.6.orig/arch/h8300/platform/h8s/ptrace_h8s.c	2010-02-02 11:00:49.968253944 +0100
+++ linux-2.6/arch/h8300/platform/h8s/ptrace_h8s.c	2010-02-02 11:19:15.329011624 +0100
@@ -65,13 +65,13 @@ int h8300_put_reg(struct task_struct *ta
 }
 
 /* disable singlestep */
-void h8300_disable_trace(struct task_struct *child)
+void user_disable_single_step(struct task_struct *child)
 {
 	*(unsigned short *)(child->thread.esp0 + h8300_register_offset[PT_EXR]) &= ~EXR_TRACE;
 }
 
 /* enable singlestep */
-void h8300_enable_trace(struct task_struct *child)
+void user_enable_single_step(struct task_struct *child)
 {
 	*(unsigned short *)(child->thread.esp0 + h8300_register_offset[PT_EXR]) |= EXR_TRACE;
 }
Index: linux-2.6/arch/h8300/include/asm/ptrace.h
===================================================================
--- linux-2.6.orig/arch/h8300/include/asm/ptrace.h	2010-02-02 11:19:24.753253118 +0100
+++ linux-2.6/arch/h8300/include/asm/ptrace.h	2010-02-02 11:19:36.822033076 +0100
@@ -55,6 +55,8 @@ struct pt_regs {
 /* Find the stack offset for a register, relative to thread.esp0. */
 #define PT_REG(reg)	((long)&((struct pt_regs *)0)->reg)
 
+#define arch_has_single_step()	(1)
+
 #define user_mode(regs) (!((regs)->ccr & PS_S))
 #define instruction_pointer(regs) ((regs)->pc)
 #define profile_pc(regs) instruction_pointer(regs)
