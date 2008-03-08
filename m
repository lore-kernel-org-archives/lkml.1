Return-Path: <linux-kernel-owner+w=401wt.eu-S1757640AbYCHPH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640AbYCHPH4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 10:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755958AbYCHPG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 10:06:27 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:34561 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755904AbYCHPG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 10:06:26 -0500
Date: Sat, 8 Mar 2008 18:10:22 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] signals: change send_signal/do_send_sigqueue to take "boolean group" parameter
Message-ID: <20080308151022.GA25182@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

send_signal() is used either with ->pending or with ->signal->shared_pending.
Change it to take "int group" instead, this argument will be re-used later.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~2_SS_BOOL_GROUP	2008-03-08 16:16:52.000000000 +0300
+++ 25/kernel/signal.c	2008-03-08 16:26:43.000000000 +0300
@@ -754,18 +754,21 @@ static inline int legacy_queue(struct si
 }
 
 static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
-			struct sigpending *signals)
+			int group)
 {
+	struct sigpending *pending;
 	struct sigqueue *q;
 
 	assert_spin_locked(&t->sighand->siglock);
 	handle_stop_signal(sig, t);
+
+	pending = group ? &t->signal->shared_pending : &t->pending;
 	/*
 	 * Short-circuit ignored signals and support queuing
 	 * exactly one non-rt signal, so that we can get more
 	 * detailed information about the cause of the signal.
 	 */
-	if (sig_ignored(t, sig) || legacy_queue(signals, sig))
+	if (sig_ignored(t, sig) || legacy_queue(pending, sig))
 		return 0;
 
 	/*
@@ -793,7 +796,7 @@ static int send_signal(int sig, struct s
 					     (is_si_special(info) ||
 					      info->si_code >= 0)));
 	if (q) {
-		list_add_tail(&q->list, &signals->list);
+		list_add_tail(&q->list, &pending->list);
 		switch ((unsigned long) info) {
 		case (unsigned long) SEND_SIG_NOINFO:
 			q->info.si_signo = sig;
@@ -823,7 +826,7 @@ static int send_signal(int sig, struct s
 	}
 
 out_set:
-	sigaddset(&signals->signal, sig);
+	sigaddset(&pending->signal, sig);
 	return 1;
 }
 
@@ -864,7 +867,7 @@ specific_send_sig_info(int sig, struct s
 {
 	int ret;
 
-	ret = send_signal(sig, info, t, &t->pending);
+	ret = send_signal(sig, info, t, 0);
 	if (ret <= 0)
 		return ret;
 
@@ -923,7 +926,7 @@ __group_send_sig_info(int sig, struct si
 	 * We always use the shared queue for process-wide signals,
 	 * to avoid several races.
 	 */
-	ret = send_signal(sig, info, p, &p->signal->shared_pending);
+	ret = send_signal(sig, info, p, 1);
 	if (ret <= 0)
 		return ret;
 
@@ -1258,8 +1261,10 @@ void sigqueue_free(struct sigqueue *q)
 }
 
 static int do_send_sigqueue(int sig, struct sigqueue *q, struct task_struct *t,
-				struct sigpending *pending)
+				int group)
 {
+	struct sigpending *pending;
+
 	handle_stop_signal(sig, t);
 
 	if (unlikely(!list_empty(&q->list))) {
@@ -1277,8 +1282,10 @@ static int do_send_sigqueue(int sig, str
 		return 1;
 
 	signalfd_notify(t, sig);
+	pending = group ? &t->signal->shared_pending : &t->pending;
 	list_add_tail(&q->list, &pending->list);
 	sigaddset(&pending->signal, sig);
+
 	return 0;
 }
 
@@ -1300,7 +1307,7 @@ int send_sigqueue(int sig, struct sigque
 	if (!likely(lock_task_sighand(p, &flags)))
 		goto out_err;
 
-	ret = do_send_sigqueue(sig, q, p, &p->pending);
+	ret = do_send_sigqueue(sig, q, p, 0);
 
 	if (!sigismember(&p->blocked, sig))
 		signal_wake_up(p, sig == SIGKILL);
@@ -1321,7 +1328,7 @@ send_group_sigqueue(int sig, struct sigq
 	/* Since it_lock is held, p->sighand cannot be NULL. */
 	spin_lock_irqsave(&p->sighand->siglock, flags);
 
-	ret = do_send_sigqueue(sig, q, p, &p->signal->shared_pending);
+	ret = do_send_sigqueue(sig, q, p, 1);
 
 	__group_complete_signal(sig, p);
 

