Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbYCHPH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbYCHPH2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 10:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755831AbYCHPGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 10:06:24 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:34560 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755668AbYCHPGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 10:06:23 -0500
Date: Sat, 8 Mar 2008 18:10:25 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] signals: unify send_sigqueue/send_group_sigqueue completely
Message-ID: <20080308151025.GA25191@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggested by Pavel Emelyanov.

send_sigqueue/send_group_sigqueue are only differ in how they lock ->siglock.
Unify them. send_group_sigqueue() uses spin_lock() because it knows the task
can't exit, but in that case lock_task_sighand() can't fail and doesn't hurt.

Note that the "sig" argument is ignored, it is always equal to ->si_signo.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~5_SSQ_UNIFY	2008-03-08 16:54:57.000000000 +0300
+++ 25/kernel/signal.c	2008-03-08 17:15:59.000000000 +0300
@@ -1240,14 +1240,27 @@ void sigqueue_free(struct sigqueue *q)
 	__sigqueue_free(q);
 }
 
-static int do_send_sigqueue(int sig, struct sigqueue *q, struct task_struct *t,
+static int do_send_sigqueue(struct sigqueue *q, struct task_struct *t,
 				int group)
 {
+	int sig = q->info.si_signo;
 	struct sigpending *pending;
+	unsigned long flags;
+	int ret;
 
 	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
+
+	ret = -1;
+	if (!likely(lock_task_sighand(t, &flags)))
+		goto ret;
+
 	handle_stop_signal(sig, t);
 
+	ret = 1;
+	if (sig_ignored(t, sig))
+		goto out;
+
+	ret = 0;
 	if (unlikely(!list_empty(&q->list))) {
 		/*
 		 * If an SI_TIMER entry is already queue just increment
@@ -1256,58 +1269,29 @@ static int do_send_sigqueue(int sig, str
 
 		BUG_ON(q->info.si_code != SI_TIMER);
 		q->info.si_overrun++;
-		return 0;
+		goto out;
 	}
 
-	if (sig_ignored(t, sig))
-		return 1;
-
 	signalfd_notify(t, sig);
 	pending = group ? &t->signal->shared_pending : &t->pending;
 	list_add_tail(&q->list, &pending->list);
 	sigaddset(&pending->signal, sig);
 	complete_signal(sig, t, group);
-
-	return 0;
+out:
+	unlock_task_sighand(t, &flags);
+ret:
+	return ret;
 }
 
 int send_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)
 {
-	unsigned long flags;
-	int ret = -1;
-
-	/*
-	 * The rcu based delayed sighand destroy makes it possible to
-	 * run this without tasklist lock held. The task struct itself
-	 * cannot go away as create_timer did get_task_struct().
-	 *
-	 * We return -1, when the task is marked exiting, so
-	 * posix_timer_event can redirect it to the group leader
-	 */
-	if (!likely(lock_task_sighand(p, &flags)))
-		goto out_err;
-
-	ret = do_send_sigqueue(sig, q, p, 0);
-
-	unlock_task_sighand(p, &flags);
-out_err:
-	return ret;
+	return do_send_sigqueue(q, p, 0);
 }
 
 int
 send_group_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)
 {
-	unsigned long flags;
-	int ret;
-
-	/* Since it_lock is held, p->sighand cannot be NULL. */
-	spin_lock_irqsave(&p->sighand->siglock, flags);
-
-	ret = do_send_sigqueue(sig, q, p, 1);
-
-	spin_unlock_irqrestore(&p->sighand->siglock, flags);
-
-	return ret;
+	return do_send_sigqueue(q, p, 1);
 }
 
 /*

