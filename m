Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab0BBTBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 14:01:25 -0500
Received: from verein.lst.de ([213.95.11.210]:38063 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932149Ab0BBTBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 14:01:21 -0500
Date: Tue, 2 Feb 2010 20:00:54 +0100
From: Christoph Hellwig <hch@lst.de>
To: roland@redhat.com, oleg@redhat.com, akpm@linux-foundation.org,
       takata@linux-m32r.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH, RFC 14/14] m32r: use generic ptrace_resume code
Message-ID: <20100202190054.GN3630@lst.de>
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
which it previously wasn't, which is consistent with all architectures
using the modern ptrace code.

The old code only disables the breakpoints on PTRACE_KILL, while after
this patch this also happens for PTRACE_CONT and PTRACE_SYSCALL which
matches the behaviour of the other architetures.  I think this is a
bugfixes, but please double verify this is correct.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/m32r/include/asm/ptrace.h
===================================================================
--- linux-2.6.orig/arch/m32r/include/asm/ptrace.h	2010-02-02 19:26:37.456003660 +0100
+++ linux-2.6/arch/m32r/include/asm/ptrace.h	2010-02-02 19:26:49.405264333 +0100
@@ -120,6 +120,8 @@ struct pt_regs {
 
 #include <asm/m32r.h>		/* M32R_PSW_BSM, M32R_PSW_BPM */
 
+#define arch_has_single_step() (1)
+
 struct task_struct;
 extern void init_debug_traps(struct task_struct *);
 #define arch_ptrace_attach(child) \
Index: linux-2.6/arch/m32r/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/m32r/kernel/ptrace.c	2010-02-02 19:26:54.353253780 +0100
+++ linux-2.6/arch/m32r/kernel/ptrace.c	2010-02-02 19:29:39.935253922 +0100
@@ -580,6 +580,35 @@ init_debug_traps(struct task_struct *chi
 	}
 }
 
+void user_enable_single_step(struct task_struct *child)
+{
+	unsigned long next_pc;
+	unsigned long pc, insn;
+
+	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
+
+	/* Compute next pc.  */
+	pc = get_stack_long(child, PT_BPC);
+
+	if (access_process_vm(child, pc&~3, &insn, sizeof(insn), 0)
+	    != sizeof(insn))
+		break;
+
+	compute_next_pc(insn, pc, &next_pc, child);
+	if (next_pc & 0x80000000)
+		break;
+
+	if (embed_debug_trap(child, next_pc))
+		break;
+
+	invalidate_cache();
+}
+
+void user_disable_single_step(struct task_struct *child)
+{
+	unregister_all_debug_traps(child);
+	invalidate_cache();
+}
 
 /*
  * Called by kernel/ptrace.c when detaching..
@@ -612,74 +641,6 @@ arch_ptrace(struct task_struct *child, l
 		ret = ptrace_write_user(child, addr, data);
 		break;
 
-	/*
-	 * continue/restart and stop at next (return from) syscall
-	 */
-	case PTRACE_SYSCALL:
-	case PTRACE_CONT:
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		if (request == PTRACE_SYSCALL)
-			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		else
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		child->exit_code = data;
-		wake_up_process(child);
-		ret = 0;
-		break;
-
-	/*
-	 * make the child exit.  Best I can do is send it a sigkill.
-	 * perhaps it should be put in the status that it wants to
-	 * exit.
-	 */
-	case PTRACE_KILL: {
-		ret = 0;
-		unregister_all_debug_traps(child);
-		invalidate_cache();
-		if (child->exit_state == EXIT_ZOMBIE)	/* already dead */
-			break;
-		child->exit_code = SIGKILL;
-		wake_up_process(child);
-		break;
-	}
-
-	/*
-	 * execute single instruction.
-	 */
-	case PTRACE_SINGLESTEP: {
-		unsigned long next_pc;
-		unsigned long pc, insn;
-
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-
-		/* Compute next pc.  */
-		pc = get_stack_long(child, PT_BPC);
-
-		if (access_process_vm(child, pc&~3, &insn, sizeof(insn), 0)
-		    != sizeof(insn))
-			break;
-
-		compute_next_pc(insn, pc, &next_pc, child);
-		if (next_pc & 0x80000000)
-			break;
-
-		if (embed_debug_trap(child, next_pc))
-			break;
-
-		invalidate_cache();
-		child->exit_code = data;
-
-		/* give it a chance to run. */
-		wake_up_process(child);
-		ret = 0;
-		break;
-	}
-
 	case PTRACE_GETREGS:
 		ret = ptrace_getregs(child, (void __user *)data);
 		break;
