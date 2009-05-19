Return-Path: <linux-kernel-owner+w=401wt.eu-S1753704AbZESQZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbZESQZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 12:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbZESQZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 12:25:14 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:40426 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbZESQZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 12:25:13 -0400
Date: Tue, 19 May 2009 21:54:59 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [Patch 1/2] Improvements and minor fixes to HW Breakpoint interface
Message-ID: <20090519162459.GB26009@in.ibm.com>
References: <20090519161720.374172804@prasadkr_t60p.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=fix_issues_hwbkpt_NEW_01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch brings a couple of changes to the HW Breakpoint infrastructure:

- Set/clear TIF_DEBUG task flag in <un>register_user_hw_breakpoint()
  instead of being done by users of this interface (such as ptrace).

- Modify return code of hw_breakpoint_handler() to NOTIFY_STOP if
  triggered due to lazy debug register switching.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 arch/x86/kernel/hw_breakpoint.c |    4 +++-
 arch/x86/kernel/ptrace.c        |    4 +---
 kernel/hw_breakpoint.c          |   16 +++++++++++++---
 3 files changed, 17 insertions(+), 7 deletions(-)

Index: linux-2.6-tip.hbkpt/arch/x86/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/hw_breakpoint.c
+++ linux-2.6-tip.hbkpt/arch/x86/kernel/hw_breakpoint.c
@@ -346,8 +346,10 @@ int __kprobes hw_breakpoint_handler(stru
 		 * or due to the delay between updates of hbp_kernel_pos
 		 * and this_hbp_kernel.
 		 */
-		if (!bp)
+		if (!bp) {
+			rc = NOTIFY_STOP;
 			continue;
+		}
 
 		(bp->triggered)(bp, args->regs);
 		/*
Index: linux-2.6-tip.hbkpt/arch/x86/kernel/ptrace.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/ptrace.c
+++ linux-2.6-tip.hbkpt/arch/x86/kernel/ptrace.c
@@ -530,9 +530,7 @@ restore:
 				bp->info.len = len;
 				bp->info.type = type;
 				rc = register_user_hw_breakpoint(tsk, bp);
-				if (!rc)
-					set_tsk_thread_flag(tsk, TIF_DEBUG);
-				else
+				if (rc)
 					kfree(bp);
 			}
 		} else
Index: linux-2.6-tip.hbkpt/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/kernel/hw_breakpoint.c
+++ linux-2.6-tip.hbkpt/kernel/hw_breakpoint.c
@@ -233,6 +233,8 @@ int register_user_hw_breakpoint(struct t
 			break;
 		}
 	}
+	if (!rc)
+		set_tsk_thread_flag(tsk, TIF_DEBUG);
 
 	spin_unlock_bh(&hw_breakpoint_lock);
 	return rc;
@@ -272,15 +274,23 @@ void unregister_user_hw_breakpoint(struc
 						struct hw_breakpoint *bp)
 {
 	struct thread_struct *thread = &(tsk->thread);
-	int i;
+	int i, pos = -1, clear_tsk_debug_counter = 0;
 
 	spin_lock_bh(&hw_breakpoint_lock);
 	for (i = 0; i < hbp_kernel_pos; i++) {
+		if (thread->hbp[i])
+			clear_tsk_debug_counter++;
 		if (bp == thread->hbp[i]) {
-			__unregister_user_hw_breakpoint(i, tsk);
-			break;
+			clear_tsk_debug_counter--;
+			pos = i;
 		}
 	}
+	if (pos >= 0)
+		__unregister_user_hw_breakpoint(pos, tsk);
+
+	if (!clear_tsk_debug_counter)
+		clear_tsk_thread_flag(tsk, TIF_DEBUG);
+
 	spin_unlock_bh(&hw_breakpoint_lock);
 }
 EXPORT_SYMBOL_GPL(unregister_user_hw_breakpoint);

