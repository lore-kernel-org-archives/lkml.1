Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbXH1Pvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbXH1Pvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 11:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbXH1Pvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 11:51:32 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:55866 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbXH1Pvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 11:51:32 -0400
Date: Tue, 28 Aug 2007 19:54:33 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: PATCH? fix SIGNAL_STOP_DEQUEUED vs SIGCONT race
Message-ID: <20070828155433.GA1081@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Two threads, T1 and T2, SIGTTIN is SIG_DFL, SIGTTOU has a handler.

	T1 does get_signal_to_deliver(), dequeus SIGTTIN, unlocks ->siglock.

	SIGCONT comes in, nothing to do yet, just clear SIGNAL_STOP_DEQUEUED.

	SIGTTOU is sent, T2 dequeues it and sets SIGNAL_STOP_DEQUEUED again.
	It has a handler, we shouldn't stop, but

	T1 continues, takes ->siglock, and calls do_signal_stop().

Move the setting of SIGNAL_STOP_DEQUEUED from dequeue_signal() to
get_signal_to_deliver(), and set this flag only if we are really going to stop.
This also simplifies the code and makes the SIGNAL_STOP_DEQUEUED usage more
understandable.

However, this changes the behaviour when the task is ptraced. If the debugger
doesn't clear ->exit_code, SIGSTOP always succeeds after ptrace_stop(), even
if SIGCONT was sent in between. I can't decide whether this change is good
or bad, hopefully Roland can clarify.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/kernel/signal.c~S_G_S	2007-08-23 16:02:57.000000000 +0400
+++ t/kernel/signal.c	2007-08-28 19:15:28.000000000 +0400
@@ -409,22 +409,7 @@ int dequeue_signal(struct task_struct *t
 	}
 	if (likely(tsk == current))
 		recalc_sigpending();
-	if (signr && unlikely(sig_kernel_stop(signr))) {
-		/*
-		 * Set a marker that we have dequeued a stop signal.  Our
-		 * caller might release the siglock and then the pending
-		 * stop signal it is about to process is no longer in the
-		 * pending bitmasks, but must still be cleared by a SIGCONT
-		 * (and overruled by a SIGKILL).  So those cases clear this
-		 * shared flag after we've set it.  Note that this flag may
-		 * remain set after the signal we return is ignored or
-		 * handled.  That doesn't matter because its only purpose
-		 * is to alert stop-signal processing code when another
-		 * processor has come along and cleared the flag.
-		 */
-		if (!(tsk->signal->flags & SIGNAL_GROUP_EXIT))
-			tsk->signal->flags |= SIGNAL_STOP_DEQUEUED;
-	}
+
 	if (signr && likely(tsk == current) &&
 	     ((info->si_code & __SI_MASK) == __SI_TIMER) &&
 	     info->si_sys_private){
@@ -1683,9 +1668,6 @@ static int do_signal_stop(int signr)
 	struct signal_struct *sig = current->signal;
 	int stop_count;
 
-	if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED))
-		return 0;
-
 	if (sig->group_stop_count > 0) {
 		/*
 		 * There is a group stop in progress.  We don't need to
@@ -1849,6 +1831,9 @@ relock:
 			continue;
 
 		if (sig_kernel_stop(signr)) {
+			if (current->signal->flags & SIGNAL_GROUP_EXIT)
+				continue;
+
 			/*
 			 * The default action is to stop all threads in
 			 * the thread group.  The job control signals
@@ -1860,14 +1845,20 @@ relock:
 			 * We need to check for that and bail out if necessary.
 			 */
 			if (signr != SIGSTOP) {
+				/*
+				 * Set a marker that we have dequeued a stop
+				 * signal. We are going to unlock ->siglock,
+				 * another signal can cancel group stop request
+				 * during this window. In that case this marker
+				 * will be cleared when we re-check below.
+				 */
+				current->signal->flags |= SIGNAL_STOP_DEQUEUED;
 				spin_unlock_irq(&current->sighand->siglock);
-
-				/* signals can be posted during this window */
-
 				if (is_current_pgrp_orphaned())
 					goto relock;
-
 				spin_lock_irq(&current->sighand->siglock);
+				if (!(current->signal->flags & SIGNAL_STOP_DEQUEUED))
+					continue;
 			}
 
 			if (likely(do_signal_stop(signr))) {

