Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbXLFQWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbXLFQWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 11:22:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbXLFQVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 11:21:55 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:40989 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbXLFQVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 11:21:54 -0500
Date: Thu, 6 Dec 2007 19:22:44 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] move the related code from exit_notify() to exit_signals()
Message-ID: <20071206162244.GA9878@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous bugfix was not optimal, we shouldn't care about group stop when
we are the only thread or the group stop is in progress. In that case nothing
special is needed, just set PF_EXITING and return.

Also, take the related "TIF_SIGPENDING re-targeting" code from exit_notify().

So, from the performance POV the only difference is that we don't trust
!signal_pending() until we take ->siglock. But this in fact fixes another
___pure___ theoretical minor race. __group_complete_signal() finds the task
without PF_EXITING and chooses it as the target for signal_wake_up(). But
nothing prevents this task from exiting in between without noticing the
pending signal and thus unpredictably delaying the actual delivery.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- PT/kernel/exit.c~2_unify_signal_exit	2007-12-05 19:50:26.000000000 +0300
+++ PT/kernel/exit.c	2007-12-06 18:06:09.000000000 +0300
@@ -743,24 +743,6 @@ static void exit_notify(struct task_stru
 	struct task_struct *t;
 	struct pid *pgrp;
 
-	if (signal_pending(tsk) && !(tsk->signal->flags & SIGNAL_GROUP_EXIT)
-	    && !thread_group_empty(tsk)) {
-		/*
-		 * This occurs when there was a race between our exit
-		 * syscall and a group signal choosing us as the one to
-		 * wake up.  It could be that we are the only thread
-		 * alerted to check for pending signals, but another thread
-		 * should be woken now to take the signal since we will not.
-		 * Now we'll wake all the threads in the group just to make
-		 * sure someone gets all the pending signals.
-		 */
-		spin_lock_irq(&tsk->sighand->siglock);
-		for (t = next_thread(tsk); t != tsk; t = next_thread(t))
-			if (!signal_pending(t) && !(t->flags & PF_EXITING))
-				recalc_sigpending_and_wake(t);
-		spin_unlock_irq(&tsk->sighand->siglock);
-	}
-
 	/*
 	 * This does two things:
 	 *
--- PT/kernel/signal.c~2_unify_signal_exit	2007-12-05 20:17:20.000000000 +0300
+++ PT/kernel/signal.c	2007-12-06 18:13:31.000000000 +0300
@@ -1871,19 +1871,36 @@ relock:
 void exit_signals(struct task_struct *tsk)
 {
 	int group_stop = 0;
+	struct task_struct *t;
 
-	spin_lock_irq(&tsk->sighand->siglock);
-	if (unlikely(tsk->signal->group_stop_count) &&
-			!--tsk->signal->group_stop_count) {
-		tsk->signal->flags = SIGNAL_STOP_STOPPED;
-		group_stop = 1;
+	if (thread_group_empty(tsk) || signal_group_exit(tsk->signal)) {
+		tsk->flags |= PF_EXITING;
+		return;
 	}
 
+	spin_lock_irq(&tsk->sighand->siglock);
 	/*
 	 * From now this task is not visible for group-wide signals,
 	 * see wants_signal(), do_signal_stop().
 	 */
 	tsk->flags |= PF_EXITING;
+	if (!signal_pending(tsk))
+		goto out;
+
+	/* It could be that __group_complete_signal() choose us to
+	 * notify about group-wide signal. Another thread should be
+	 * woken now to take the signal since we will not.
+	 */
+	for (t = tsk; (t = next_thread(t)) != tsk; )
+		if (!signal_pending(t) && !(t->flags & PF_EXITING))
+			recalc_sigpending_and_wake(t);
+
+	if (unlikely(tsk->signal->group_stop_count) &&
+			!--tsk->signal->group_stop_count) {
+		tsk->signal->flags = SIGNAL_STOP_STOPPED;
+		group_stop = 1;
+	}
+out:
 	spin_unlock_irq(&tsk->sighand->siglock);
 
 	if (unlikely(group_stop)) {

