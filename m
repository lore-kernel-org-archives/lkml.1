Return-Path: <linux-kernel-owner+w=401wt.eu-S1752940AbYCHPGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbYCHPGv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 10:06:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755705AbYCHPGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 10:06:23 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:34559 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbYCHPGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 10:06:22 -0500
Date: Sat, 8 Mar 2008 18:10:24 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] signals: fold complete_signal() into send_signal/do_send_sigqueue
Message-ID: <20080308151024.GA25188@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Emelyanov <xemul@openvz.org>

Factor out complete_signal() callsites. This change completely unifies the
helpers sending the specific/group signals.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~4_CS_FACTOR	2008-03-08 16:37:23.000000000 +0300
+++ 25/kernel/signal.c	2008-03-08 16:54:57.000000000 +0300
@@ -826,7 +826,8 @@ static int send_signal(int sig, struct s
 
 out_set:
 	sigaddset(&pending->signal, sig);
-	return 1;
+	complete_signal(sig, t, group);
+	return 0;
 }
 
 int print_fatal_signals;
@@ -861,17 +862,16 @@ static int __init setup_print_fatal_sign
 
 __setup("print-fatal-signals=", setup_print_fatal_signals);
 
+int
+__group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
+{
+	return send_signal(sig, info, p, 1);
+}
+
 static int
 specific_send_sig_info(int sig, struct siginfo *info, struct task_struct *t)
 {
-	int ret;
-
-	ret = send_signal(sig, info, t, 0);
-	if (ret <= 0)
-		return ret;
-
-	complete_signal(sig, t, 0);
-	return 0;
+	return send_signal(sig, info, t, 0);
 }
 
 /*
@@ -914,24 +914,6 @@ force_sig_specific(int sig, struct task_
 	force_sig_info(sig, SEND_SIG_FORCED, t);
 }
 
-int
-__group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
-{
-	int ret;
-
-	/*
-	 * Put this signal on the shared-pending queue, or fail with EAGAIN.
-	 * We always use the shared queue for process-wide signals,
-	 * to avoid several races.
-	 */
-	ret = send_signal(sig, info, p, 1);
-	if (ret <= 0)
-		return ret;
-
-	complete_signal(sig, p, 1);
-	return 0;
-}
-
 /*
  * Nuke all other threads in the group.
  */
@@ -1263,6 +1245,7 @@ static int do_send_sigqueue(int sig, str
 {
 	struct sigpending *pending;
 
+	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
 	handle_stop_signal(sig, t);
 
 	if (unlikely(!list_empty(&q->list))) {
@@ -1283,6 +1266,7 @@ static int do_send_sigqueue(int sig, str
 	pending = group ? &t->signal->shared_pending : &t->pending;
 	list_add_tail(&q->list, &pending->list);
 	sigaddset(&pending->signal, sig);
+	complete_signal(sig, t, group);
 
 	return 0;
 }
@@ -1292,8 +1276,6 @@ int send_sigqueue(int sig, struct sigque
 	unsigned long flags;
 	int ret = -1;
 
-	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
-
 	/*
 	 * The rcu based delayed sighand destroy makes it possible to
 	 * run this without tasklist lock held. The task struct itself
@@ -1307,8 +1289,6 @@ int send_sigqueue(int sig, struct sigque
 
 	ret = do_send_sigqueue(sig, q, p, 0);
 
-	complete_signal(sig, p, 0);
-
 	unlock_task_sighand(p, &flags);
 out_err:
 	return ret;
@@ -1320,15 +1300,11 @@ send_group_sigqueue(int sig, struct sigq
 	unsigned long flags;
 	int ret;
 
-	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
-
 	/* Since it_lock is held, p->sighand cannot be NULL. */
 	spin_lock_irqsave(&p->sighand->siglock, flags);
 
 	ret = do_send_sigqueue(sig, q, p, 1);
 
-	complete_signal(sig, p, 1);
-
 	spin_unlock_irqrestore(&p->sighand->siglock, flags);
 
 	return ret;

