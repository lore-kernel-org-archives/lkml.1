Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbXKYWBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbXKYWBw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758052AbXKYWBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:01:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758048AbXKYWBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:01:33 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 12/27] x86-32: ptrace generic resume
In-Reply-To: Roland McGrath's message of  Sunday, 25 November 2007 13:55:07 -0800 <20071125215507.4B89226F8C5@magilla.localdomain>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
X-Zippy-Says: If Robert Di Niro assassinates Walter Slezak, will Jodie Foster
    marry Bonzo??
Message-Id: <20071125220128.DBD2D26F8E1@magilla.localdomain>
Date: Sun, 25 Nov 2007 14:01:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This removes the handling for PTRACE_CONT et al from the 32-bit
ptrace code, so it uses the new generic code via ptrace_request.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace_32.c |   57 -------------------------------------------
 1 files changed, 0 insertions(+), 57 deletions(-)

diff --git a/arch/x86/kernel/ptrace_32.c b/arch/x86/kernel/ptrace_32.c
index a493017..50882b3 100644
--- a/arch/x86/kernel/ptrace_32.c
+++ b/arch/x86/kernel/ptrace_32.c
@@ -277,63 +277,6 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		  }
 		  break;
 
-	case PTRACE_SYSEMU: /* continue and stop at next syscall, which will not be executed */
-	case PTRACE_SYSCALL:	/* continue and stop at next (return from) syscall */
-	case PTRACE_CONT:	/* restart after signal. */
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		if (request == PTRACE_SYSEMU) {
-			set_tsk_thread_flag(child, TIF_SYSCALL_EMU);
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		} else if (request == PTRACE_SYSCALL) {
-			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-			clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
-		} else {
-			clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		}
-		child->exit_code = data;
-		/* make sure the single step bit is not set. */
-		user_disable_single_step(child);
-		wake_up_process(child);
-		ret = 0;
-		break;
-
-/*
- * make the child exit.  Best I can do is send it a sigkill.
- * perhaps it should be put in the status that it wants to
- * exit.
- */
-	case PTRACE_KILL:
-		ret = 0;
-		if (child->exit_state == EXIT_ZOMBIE)	/* already dead */
-			break;
-		child->exit_code = SIGKILL;
-		/* make sure the single step bit is not set. */
-		user_disable_single_step(child);
-		wake_up_process(child);
-		break;
-
-	case PTRACE_SYSEMU_SINGLESTEP: /* Same as SYSEMU, but singlestep if not syscall */
-	case PTRACE_SINGLESTEP:	/* set the trap flag. */
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-
-		if (request == PTRACE_SYSEMU_SINGLESTEP)
-			set_tsk_thread_flag(child, TIF_SYSCALL_EMU);
-		else
-			clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
-
-		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		user_enable_single_step(child);
-		child->exit_code = data;
-		/* give it a chance to run. */
-		wake_up_process(child);
-		ret = 0;
-		break;
-
 	case PTRACE_GETREGS: { /* Get all gp regs from the child. */
 	  	if (!access_ok(VERIFY_WRITE, datap, FRAME_SIZE*sizeof(long))) {
 			ret = -EIO;
