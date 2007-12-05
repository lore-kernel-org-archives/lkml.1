Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbXLER34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbXLER34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 12:29:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbXLER3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 12:29:49 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:55036 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbXLER3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 12:29:48 -0500
Date: Wed, 5 Dec 2007 20:30:28 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fix group stop with exit race
Message-ID: <20071205173028.GA3745@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_signal_stop() counts all sub-thread and sets ->group_stop_count accordingly.
Every thread should decrement ->group_stop_count and stop, the last one should
notify the parent.

However a sub-thread can exit before it notices the signal_pending(), or it may
be somewhere in do_exit() already. In that case the group stop never finishes
properly.

Note: this is a minimal fix, we can add some optimizations later. Say we can
return quickly if thread_group_empty(). Also, we can move some signal related
code from exit_notify() to exit_signals().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- PT/include/linux/signal.h~1_stop_exit	2007-11-20 17:16:10.000000000 +0300
+++ PT/include/linux/signal.h	2007-12-05 19:49:14.000000000 +0300
@@ -241,6 +241,7 @@ extern int show_unhandled_signals;
 
 struct pt_regs;
 extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka, struct pt_regs *regs, void *cookie);
+extern void exit_signals(struct task_struct *tsk);
 
 extern struct kmem_cache *sighand_cachep;
 
--- PT/kernel/signal.c~1_stop_exit	2007-12-02 17:05:15.000000000 +0300
+++ PT/kernel/signal.c	2007-12-05 20:17:20.000000000 +0300
@@ -1707,7 +1707,7 @@ static int do_signal_stop(int signr)
 			 * stop is always done with the siglock held,
 			 * so this check has no races.
 			 */
-			if (!t->exit_state &&
+			if (!(t->flags & PF_EXITING) &&
 			    !is_task_stopped_or_traced(t)) {
 				stop_count++;
 				signal_wake_up(t, 0);
@@ -1868,6 +1868,31 @@ relock:
 	return signr;
 }
 
+void exit_signals(struct task_struct *tsk)
+{
+	int group_stop = 0;
+
+	spin_lock_irq(&tsk->sighand->siglock);
+	if (unlikely(tsk->signal->group_stop_count) &&
+			!--tsk->signal->group_stop_count) {
+		tsk->signal->flags = SIGNAL_STOP_STOPPED;
+		group_stop = 1;
+	}
+
+	/*
+	 * From now this task is not visible for group-wide signals,
+	 * see wants_signal(), do_signal_stop().
+	 */
+	tsk->flags |= PF_EXITING;
+	spin_unlock_irq(&tsk->sighand->siglock);
+
+	if (unlikely(group_stop)) {
+		read_lock(&tasklist_lock);
+		do_notify_parent_cldstop(tsk, CLD_STOPPED);
+		read_unlock(&tasklist_lock);
+	}
+}
+
 EXPORT_SYMBOL(recalc_sigpending);
 EXPORT_SYMBOL_GPL(dequeue_signal);
 EXPORT_SYMBOL(flush_signals);
--- PT/kernel/exit.c~1_stop_exit	2007-12-02 15:53:35.000000000 +0300
+++ PT/kernel/exit.c	2007-12-05 19:50:26.000000000 +0300
@@ -945,7 +945,7 @@ fastcall NORET_TYPE void do_exit(long co
 		schedule();
 	}
 
-	tsk->flags |= PF_EXITING;
+	exit_signals(tsk);  /* sets PF_EXITING */
 	/*
 	 * tsk->flags are checked in the futex code to protect against
 	 * an exiting task cleaning up the robust pi futexes.

