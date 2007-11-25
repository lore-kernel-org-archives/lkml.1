Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbXKYWEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbXKYWEU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756358AbXKYWEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:04:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756279AbXKYWEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:04:07 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Subject: [PATCH 14/27] powerpc: ptrace generic resume
In-Reply-To: Roland McGrath's message of  Sunday, 25 November 2007 13:55:07 -0800 <20071125215507.4B89226F8C5@magilla.localdomain>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
X-Shopping-List: (1) Impudent bag lunches
   (2) Delirious yies
   (3) Barking pianos
Message-Id: <20071125220402.4C43C26F8DE@magilla.localdomain>
Date: Sun, 25 Nov 2007 14:04:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This removes the handling for PTRACE_CONT et al from the powerpc
ptrace code, so it uses the new generic code via ptrace_request.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/kernel/ptrace.c |   46 ------------------------------------------
 1 files changed, 0 insertions(+), 46 deletions(-)

diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index b970d79..8b056d2 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -445,52 +445,6 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		break;
 	}
 
-	case PTRACE_SYSCALL: /* continue and stop at next (return from) syscall */
-	case PTRACE_CONT: { /* restart after signal. */
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		if (request == PTRACE_SYSCALL)
-			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		else
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		child->exit_code = data;
-		/* make sure the single step bit is not set. */
-		user_disable_single_step(child);
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
-		child->exit_code = SIGKILL;
-		/* make sure the single step bit is not set. */
-		user_disable_single_step(child);
-		wake_up_process(child);
-		break;
-	}
-
-	case PTRACE_SINGLESTEP: {  /* set the trap flag. */
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		user_enable_single_step(child);
-		child->exit_code = data;
-		/* give it a chance to run. */
-		wake_up_process(child);
-		ret = 0;
-		break;
-	}
-
 	case PTRACE_GET_DEBUGREG: {
 		ret = -EINVAL;
 		/* We only support one DABR and no IABRS at the moment */
