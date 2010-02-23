Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab0BWSR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 13:17:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab0BWSRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 13:17:25 -0500
Date: Tue, 23 Feb 2010 19:16:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Fenghua Yu <fenghua.yu@intel.com>, Tony Luck <tony.luck@intel.com>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] ia64: ptrace: kill thread_matches()
Message-ID: <20100223181632.GA19586@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial. thread_matches() has no callers since
e868a55c2a8cb72b66d7137fbcc54b82016e98eb, remove it.

Ironically, this helper is the only user of ptrace_check_attach()
outside of kernel/ptrace.c, and it was always wrong because it must
not use "might_sleep" ptrace_check_attach() under tasklist.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- a/arch/ia64/kernel/ptrace.c
+++ b/arch/ia64/kernel/ptrace.c
@@ -674,33 +674,6 @@ ptrace_attach_sync_user_rbs (struct task
 	read_unlock(&tasklist_lock);
 }
 
-static inline int
-thread_matches (struct task_struct *thread, unsigned long addr)
-{
-	unsigned long thread_rbs_end;
-	struct pt_regs *thread_regs;
-
-	if (ptrace_check_attach(thread, 0) < 0)
-		/*
-		 * If the thread is not in an attachable state, we'll
-		 * ignore it.  The net effect is that if ADDR happens
-		 * to overlap with the portion of the thread's
-		 * register backing store that is currently residing
-		 * on the thread's kernel stack, then ptrace() may end
-		 * up accessing a stale value.  But if the thread
-		 * isn't stopped, that's a problem anyhow, so we're
-		 * doing as well as we can...
-		 */
-		return 0;
-
-	thread_regs = task_pt_regs(thread);
-	thread_rbs_end = ia64_get_user_rbs_end(thread, thread_regs, NULL);
-	if (!on_kernel_rbs(addr, thread_regs->ar_bspstore, thread_rbs_end))
-		return 0;
-
-	return 1;	/* looks like we've got a winner */
-}
-
 /*
  * Write f32-f127 back to task->thread.fph if it has been modified.
  */

