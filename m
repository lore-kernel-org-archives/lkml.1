Return-Path: <linux-kernel-owner+w=401wt.eu-S1758595AbYGFQAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595AbYGFQAQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 12:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756757AbYGFQAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 12:00:04 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:60768 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055AbYGFQAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 12:00:03 -0400
Date: Sun, 6 Jul 2008 20:02:52 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] ptrace: simplify ptrace_stop()->sigkill_pending() path
Message-ID: <20080706160252.GA4123@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. SIGKILL can't be blocked, remove this check from sigkill_pending().

2. When ptrace_stop() sees sigkill_pending() == T, it can just return.
   Kill "int killed" and simplify the code. This also is more correct,
   the tracer shouldn't see us in TASK_TRACED if we are not going to
   stop.

I strongly believe this code needs further changes. We should do the
"was this task killed" check unconditionally, currently it depends on
arch_ptrace_stop_needed(). On the other hand, sigkill_pending() isn't
very clever. If the task was killed tkill(SIGKILL), the signal can be
already dequeued if the caller is do_exit().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/signal.c~PT_KILL	2008-06-28 17:06:58.000000000 +0400
+++ 26-rc2/kernel/signal.c	2008-07-06 19:29:27.000000000 +0400
@@ -1498,9 +1498,8 @@ static inline int may_ptrace_stop(void)
  */
 static int sigkill_pending(struct task_struct *tsk)
 {
-	return ((sigismember(&tsk->pending.signal, SIGKILL) ||
-		 sigismember(&tsk->signal->shared_pending.signal, SIGKILL)) &&
-		!unlikely(sigismember(&tsk->blocked, SIGKILL)));
+	return	sigismember(&tsk->pending.signal, SIGKILL) ||
+		sigismember(&tsk->signal->shared_pending.signal, SIGKILL);
 }
 
 /*
@@ -1516,8 +1515,6 @@ static int sigkill_pending(struct task_s
  */
 static void ptrace_stop(int exit_code, int clear_code, siginfo_t *info)
 {
-	int killed = 0;
-
 	if (arch_ptrace_stop_needed(exit_code, info)) {
 		/*
 		 * The arch code has something special to do before a
@@ -1533,7 +1530,8 @@ static void ptrace_stop(int exit_code, i
 		spin_unlock_irq(&current->sighand->siglock);
 		arch_ptrace_stop(exit_code, info);
 		spin_lock_irq(&current->sighand->siglock);
-		killed = sigkill_pending(current);
+		if (sigkill_pending(current))
+			return;
 	}
 
 	/*
@@ -1550,7 +1548,7 @@ static void ptrace_stop(int exit_code, i
 	__set_current_state(TASK_TRACED);
 	spin_unlock_irq(&current->sighand->siglock);
 	read_lock(&tasklist_lock);
-	if (!unlikely(killed) && may_ptrace_stop()) {
+	if (may_ptrace_stop()) {
 		do_notify_parent_cldstop(current, CLD_TRAPPED);
 		read_unlock(&tasklist_lock);
 		schedule();

