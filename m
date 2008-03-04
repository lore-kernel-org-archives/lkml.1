Return-Path: <linux-kernel-owner+w=401wt.eu-S933000AbYCDS4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000AbYCDS4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 13:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932665AbYCDSyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 13:54:05 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:40639 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932640AbYCDSx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 13:53:59 -0500
Date: Tue, 4 Mar 2008 21:57:48 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] get_signal_to_deliver: use the cached ->signal/sighand values
Message-ID: <20080304185748.GA8491@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cache the values of current->signal/sighand. Shrinks .text a bit and makes the
code more readable. Also, remove "sigset_t *mask", it is pointless because in
fact we save the constant offset.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~4_GSTD_CACHE_SIGNAL	2008-03-04 21:10:22.000000000 +0300
+++ 25/kernel/signal.c	2008-03-04 21:24:20.000000000 +0300
@@ -1738,19 +1738,20 @@ static int do_signal_stop(int signr)
 int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
 			  struct pt_regs *regs, void *cookie)
 {
-	sigset_t *mask = &current->blocked;
-	int signr = 0;
+	struct sighand_struct *sighand = current->sighand;
+	struct signal_struct *signal = current->signal;
+	int signr;
 
 	try_to_freeze();
 
 relock:
-	spin_lock_irq(&current->sighand->siglock);
+	spin_lock_irq(&sighand->siglock);
 
-	if (unlikely(current->signal->flags & SIGNAL_CLD_MASK)) {
-		int why = (current->signal->flags & SIGNAL_STOP_CONTINUED)
+	if (unlikely(signal->flags & SIGNAL_CLD_MASK)) {
+		int why = (signal->flags & SIGNAL_STOP_CONTINUED)
 				? CLD_CONTINUED : CLD_STOPPED;
-		current->signal->flags &= ~SIGNAL_CLD_MASK;
-		spin_unlock_irq(&current->sighand->siglock);
+		signal->flags &= ~SIGNAL_CLD_MASK;
+		spin_unlock_irq(&sighand->siglock);
 
 		read_lock(&tasklist_lock);
 		do_notify_parent_cldstop(current->group_leader, why);
@@ -1761,12 +1762,11 @@ relock:
 	for (;;) {
 		struct k_sigaction *ka;
 
-		if (unlikely(current->signal->group_stop_count > 0) &&
+		if (unlikely(signal->group_stop_count > 0) &&
 		    do_signal_stop(0))
 			goto relock;
 
-		signr = dequeue_signal(current, mask, info);
-
+		signr = dequeue_signal(current, &current->blocked, info);
 		if (!signr)
 			break; /* will return 0 */
 
@@ -1802,7 +1802,7 @@ relock:
 			}
 		}
 
-		ka = &current->sighand->action[signr-1];
+		ka = &sighand->action[signr-1];
 		if (ka->sa.sa_handler == SIG_IGN) /* Do nothing.  */
 			continue;
 		if (ka->sa.sa_handler != SIG_DFL) {
@@ -1839,14 +1839,14 @@ relock:
 			 * We need to check for that and bail out if necessary.
 			 */
 			if (signr != SIGSTOP) {
-				spin_unlock_irq(&current->sighand->siglock);
+				spin_unlock_irq(&sighand->siglock);
 
 				/* signals can be posted during this window */
 
 				if (is_current_pgrp_orphaned())
 					goto relock;
 
-				spin_lock_irq(&current->sighand->siglock);
+				spin_lock_irq(&sighand->siglock);
 			}
 
 			if (likely(do_signal_stop(signr))) {
@@ -1861,7 +1861,7 @@ relock:
 			continue;
 		}
 
-		spin_unlock_irq(&current->sighand->siglock);
+		spin_unlock_irq(&sighand->siglock);
 
 		/*
 		 * Anything else is fatal, maybe with a core dump.
@@ -1887,7 +1887,7 @@ relock:
 		do_group_exit(signr);
 		/* NOTREACHED */
 	}
-	spin_unlock_irq(&current->sighand->siglock);
+	spin_unlock_irq(&sighand->siglock);
 	return signr;
 }
 

