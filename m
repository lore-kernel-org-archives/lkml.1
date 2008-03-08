Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbYCHPGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbYCHPGR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 10:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbYCHPGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 10:06:05 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:34542 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbYCHPGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 10:06:04 -0500
Date: Sat, 8 Mar 2008 18:10:23 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] signals: use __group_complete_signal() for the specific signals too
Message-ID: <20080308151023.GA25185@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on Pavel Emelyanov's suggestion.

Rename __group_complete_signal() to complete_signal() and use it to process
the specific signals too. To do this we simply add the "int group" argument.

This allows us to greatly simply the signal-sending code and adds a useful
behaviour change. We can avoid the unneeded wakeups for the private signals
because wants_signal() is more clever than sigismember(blocked), but more
importantly we now take into account the fatal specific signals too.

The latter allows us to kill some subtle checks in handle_stop_signal() and
makes the specific/group signal's behaviour more consistent. For example,
currently sigtimedwait(FATAL_SIGNAL) behaves differently depending on was
the signal sent by kill() or tkill() if the signal was not blocked.

And. This allows us to tweak/fix the behaviour when the specific signal is
sent to the dying/dead ->group_leader.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~3_GCS_UNIFY	2008-03-08 16:26:43.000000000 +0300
+++ 25/kernel/signal.c	2008-03-08 16:37:23.000000000 +0300
@@ -673,8 +673,7 @@ static inline int wants_signal(int sig, 
 	return task_curr(p) || !signal_pending(p);
 }
 
-static void
-__group_complete_signal(int sig, struct task_struct *p)
+static void complete_signal(int sig, struct task_struct *p, int group)
 {
 	struct signal_struct *signal = p->signal;
 	struct task_struct *t;
@@ -687,7 +686,7 @@ __group_complete_signal(int sig, struct 
 	 */
 	if (wants_signal(sig, p))
 		t = p;
-	else if (thread_group_empty(p))
+	else if (!group || thread_group_empty(p))
 		/*
 		 * There is just one thread and it does not need to be woken.
 		 * It will dequeue unblocked signals before it runs again.
@@ -871,8 +870,7 @@ specific_send_sig_info(int sig, struct s
 	if (ret <= 0)
 		return ret;
 
-	if (!sigismember(&t->blocked, sig))
-		signal_wake_up(t, sig == SIGKILL);
+	complete_signal(sig, t, 0);
 	return 0;
 }
 
@@ -930,7 +928,7 @@ __group_send_sig_info(int sig, struct si
 	if (ret <= 0)
 		return ret;
 
-	__group_complete_signal(sig, p);
+	complete_signal(sig, p, 1);
 	return 0;
 }
 
@@ -1309,8 +1307,7 @@ int send_sigqueue(int sig, struct sigque
 
 	ret = do_send_sigqueue(sig, q, p, 0);
 
-	if (!sigismember(&p->blocked, sig))
-		signal_wake_up(p, sig == SIGKILL);
+	complete_signal(sig, p, 0);
 
 	unlock_task_sighand(p, &flags);
 out_err:
@@ -1330,7 +1327,7 @@ send_group_sigqueue(int sig, struct sigq
 
 	ret = do_send_sigqueue(sig, q, p, 1);
 
-	__group_complete_signal(sig, p);
+	complete_signal(sig, p, 1);
 
 	spin_unlock_irqrestore(&p->sighand->siglock, flags);
 

