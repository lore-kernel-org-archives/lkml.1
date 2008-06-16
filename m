Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbYFPOTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbYFPOTp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 10:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754323AbYFPOSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 10:18:37 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:38108 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212AbYFPOSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 10:18:36 -0400
Date: Mon, 16 Jun 2008 18:20:19 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] ptrace: kill may_ptrace_stop()
Message-ID: <20080616142019.GA13348@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that ptrace_stop() can't sleep if the tracee was SIGKILL'ed, we don't
need the special mm->core_waiters check in may_ptrace_stop(). It was needed
to prevent the deadlock with the tracer with the same ->mm which waits for
us in coredump_wait()->wait_for_completion(&startup_done), and the the
unkillable tracee waits for PTRACE_CONT from the tracer.

Without this check may_ptrace_stop() becomes trivial and can be removed.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/signal.c~	2008-06-15 16:15:46.000000000 +0400
+++ 26-rc2/kernel/signal.c	2008-06-15 17:51:50.000000000 +0400
@@ -1472,26 +1472,6 @@ static void do_notify_parent_cldstop(str
 	spin_unlock_irqrestore(&sighand->siglock, flags);
 }
 
-static inline int may_ptrace_stop(void)
-{
-	if (!likely(current->ptrace & PT_PTRACED))
-		return 0;
-	/*
-	 * Are we in the middle of do_coredump?
-	 * If so and our tracer is also part of the coredump stopping
-	 * is a deadlock situation, and pointless because our tracer
-	 * is dead so don't allow us to stop.
-	 * If SIGKILL was already sent before the caller unlocked
-	 * ->siglock we must see ->core_waiters != 0. Otherwise it
-	 * is safe to enter schedule().
-	 */
-	if (unlikely(current->mm->core_waiters) &&
-	    unlikely(current->mm == current->parent->mm))
-		return 0;
-
-	return 1;
-}
-
 /*
  * This must be called with current->sighand->siglock held.
  *
@@ -1536,7 +1516,7 @@ static void ptrace_stop(int exit_code, i
 	__set_current_state(TASK_TRACED);
 	spin_unlock_irq(&current->sighand->siglock);
 	read_lock(&tasklist_lock);
-	if (may_ptrace_stop()) {
+	if (likely(current->ptrace & PT_PTRACED)) {
 		do_notify_parent_cldstop(current, CLD_TRAPPED);
 		read_unlock(&tasklist_lock);
 		schedule();

