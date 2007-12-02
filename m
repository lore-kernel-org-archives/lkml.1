Return-Path: <linux-kernel-owner+w=401wt.eu-S1756231AbXLBPPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbXLBPPc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 10:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbXLBPOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 10:14:45 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:37476 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480AbXLBPOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 10:14:43 -0500
Date: Sun, 2 Dec 2007 18:14:55 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] remove handle_group_stop() in favor of do_signal_stop()
Message-ID: <20071202151455.GA13183@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every time we set SIGNAL_GROUP_EXIT or clear SIGNAL_STOP_DEQUEUED we also
reset ->group_stop_count.

This means that the SIGNAL_GROUP_EXIT check in handle_group_stop() is not
needed, and do_signal_stop() should check SIGNAL_STOP_DEQUEUED only when
->group_stop_count == 0. With these changes handle_group_stop() becomes the
subset of do_signal_stop(), we can kill it and use do_signal_stop() instead.

Also, a preparation for the next patch.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- PT/kernel/signal.c~1_UNIFY_STOP	2007-12-02 14:36:22.000000000 +0300
+++ PT/kernel/signal.c	2007-12-02 16:56:16.000000000 +0300
@@ -1683,9 +1683,6 @@ static int do_signal_stop(int signr)
 	struct signal_struct *sig = current->signal;
 	int stop_count;
 
-	if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED))
-		return 0;
-
 	if (sig->group_stop_count > 0) {
 		/*
 		 * There is a group stop in progress.  We don't need to
@@ -1693,12 +1690,14 @@ static int do_signal_stop(int signr)
 		 */
 		stop_count = --sig->group_stop_count;
 	} else {
+		struct task_struct *t;
+
+		if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED))
+			return 0;
 		/*
 		 * There is no group stop already in progress.
 		 * We must initiate one now.
 		 */
-		struct task_struct *t;
-
 		sig->group_exit_code = signr;
 
 		stop_count = 0;
@@ -1726,38 +1725,6 @@ static int do_signal_stop(int signr)
 	return 1;
 }
 
-/*
- * Do appropriate magic when group_stop_count > 0.
- * We return nonzero if we stopped, after releasing the siglock.
- * We return zero if we still hold the siglock and should look
- * for another signal without checking group_stop_count again.
- */
-static int handle_group_stop(void)
-{
-	int stop_count;
-
-	if (current->signal->flags & SIGNAL_GROUP_EXIT)
-		/*
-		 * Group stop is so another thread can do a core dump,
-		 * or else we are racing against a death signal.
-		 * Just punt the stop so we can get the next signal.
-		 */
-		return 0;
-
-	/*
-	 * There is a group stop in progress.  We stop
-	 * without any associated signal being in our queue.
-	 */
-	stop_count = --current->signal->group_stop_count;
-	if (stop_count == 0)
-		current->signal->flags = SIGNAL_STOP_STOPPED;
-	current->exit_code = current->signal->group_exit_code;
-	__set_current_state(TASK_STOPPED);
-	spin_unlock_irq(&current->sighand->siglock);
-	finish_stop(stop_count);
-	return 1;
-}
-
 int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
 			  struct pt_regs *regs, void *cookie)
 {
@@ -1772,7 +1739,7 @@ relock:
 		struct k_sigaction *ka;
 
 		if (unlikely(current->signal->group_stop_count > 0) &&
-		    handle_group_stop())
+		    do_signal_stop(0))
 			goto relock;
 
 		signr = dequeue_signal(current, mask, info);

