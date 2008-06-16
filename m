Return-Path: <linux-kernel-owner+w=401wt.eu-S1756478AbYFPOT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbYFPOT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 10:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbYFPOSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 10:18:36 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:38106 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160AbYFPOSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 10:18:35 -0400
Date: Mon, 16 Jun 2008 18:20:18 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ptrace: never sleep in TASK_TRACED if SIGKILL'ed
Message-ID: <20080616142018.GA13345@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change ptrace_stop() to check if the task was killed unconditionally and
simplify the "if (killed)" case - we can just return. Note that SIGKILL
can be already dequeued if ptrace_stop() is called from do_exit(), that
is why we use signal_group_exit().

The current behaviour is somewhat unpredictable. If we enter ptrace_stop()
with the pending SIGKILL the result depends on arch_ptrace_stop_needed()
and if it is true it also depends on was this signal private or group-wide
if the caller is do_exit().

With this patch we never sleep in TASK_TRACED with the pending SIGKILL.
This looks very logical, because only SIGKILL can wake up TASK_TRACED
task, and the second SIGKILL (in general) has no effect.

Note: If the tracee was killed because another thread execs, we are not going
to sleep anyway. If this is not desirable, we can check SIGNAL_GROUP_EXIT
instead. But again, the current behaviour is not very predictable.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/signal.c~2_PT_STOP_KILL	2008-06-08 16:15:25.000000000 +0400
+++ 26-rc2/kernel/signal.c	2008-06-10 20:06:24.000000000 +0400
@@ -1493,17 +1493,6 @@ static inline int may_ptrace_stop(void)
 }
 
 /*
- * Return nonzero if there is a SIGKILL that should be waking us up.
- * Called with the siglock held.
- */
-static int sigkill_pending(struct task_struct *tsk)
-{
-	return ((sigismember(&tsk->pending.signal, SIGKILL) ||
-		 sigismember(&tsk->signal->shared_pending.signal, SIGKILL)) &&
-		!unlikely(sigismember(&tsk->blocked, SIGKILL)));
-}
-
-/*
  * This must be called with current->sighand->siglock held.
  *
  * This should be the path for all ptrace stops.
@@ -1516,8 +1505,6 @@ static int sigkill_pending(struct task_s
  */
 static void ptrace_stop(int exit_code, int clear_code, siginfo_t *info)
 {
-	int killed = 0;
-
 	if (arch_ptrace_stop_needed(exit_code, info)) {
 		/*
 		 * The arch code has something special to do before a
@@ -1526,16 +1513,15 @@ static void ptrace_stop(int exit_code, i
 		 * calling arch_ptrace_stop, so we must release it now.
 		 * To preserve proper semantics, we must do this before
 		 * any signal bookkeeping like checking group_stop_count.
-		 * Meanwhile, a SIGKILL could come in before we retake the
-		 * siglock.  That must prevent us from sleeping in TASK_TRACED.
-		 * So after regaining the lock, we must check for SIGKILL.
 		 */
 		spin_unlock_irq(&current->sighand->siglock);
 		arch_ptrace_stop(exit_code, info);
 		spin_lock_irq(&current->sighand->siglock);
-		killed = sigkill_pending(current);
 	}
 
+	if (unlikely(signal_group_exit(current->signal)))
+		return;
+
 	/*
 	 * If there is a group stop in progress,
 	 * we must participate in the bookkeeping.
@@ -1550,7 +1536,7 @@ static void ptrace_stop(int exit_code, i
 	__set_current_state(TASK_TRACED);
 	spin_unlock_irq(&current->sighand->siglock);
 	read_lock(&tasklist_lock);
-	if (!unlikely(killed) && may_ptrace_stop()) {
+	if (may_ptrace_stop()) {
 		do_notify_parent_cldstop(current, CLD_TRAPPED);
 		read_unlock(&tasklist_lock);
 		schedule();

