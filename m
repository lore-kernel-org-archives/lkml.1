Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab0BKJl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 04:41:57 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:42822 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145Ab0BKJlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 04:41:49 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Christoph Hellwig <hch@lst.de>
Cc: roland@redhat.com, oleg@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] Blackfin: use generic ptrace_resume code
Date: Thu, 11 Feb 2010 04:43:09 -0500
Message-Id: <1265881389-26925-3-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <20100202185907.GE3630@lst.de>
References: <20100202185907.GE3630@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

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
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/ptrace.c |   44 -----------------------------------------
 1 files changed, 0 insertions(+), 44 deletions(-)

diff --git a/arch/blackfin/kernel/ptrace.c b/arch/blackfin/kernel/ptrace.c
index f6e94ad..09fb04e 100644
--- a/arch/blackfin/kernel/ptrace.c
+++ b/arch/blackfin/kernel/ptrace.c
@@ -330,50 +330,6 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
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
-		user_disable_single_step(child);
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
-		user_disable_single_step(child);
-		wake_up_process(child);
-		break;
-
-	case PTRACE_SINGLESTEP:	/* set the trap flag. */
-		pr_debug("ptrace: single step\n");
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		user_enable_single_step(child);
-		child->exit_code = data;
-		wake_up_process(child);
-		ret = 0;
-		break;
-
 	case PTRACE_GETREGS:
 		/* Get all gp regs from the child. */
 		ret = ptrace_getregs(child, datap);
-- 
1.6.6.1

