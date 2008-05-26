Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbYEZQ4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbYEZQ4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 12:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbYEZQzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 12:55:45 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:58853 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbYEZQy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 12:54:58 -0400
Date: Mon, 26 May 2008 20:55:42 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Austin Clements <amdragon+kernelbugzilla@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] posix timers: sigqueue_free: don't free sigqueue if it is queued
Message-ID: <20080526165542.GA10894@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently sigqueue_free() removes sigqueue from list, but doesn't cancel the
pending signal. This is not consistent, the task should either receive the
"full" signal along with siginfo_t, or it shouldn't receive the signal at all.

Change sigqueue_free() to clear SIGQUEUE_PREALLOC but leave sigqueue on list
if it is queued.

This is a user-visible change. If the signal is blocked, it stays queued
after sys_timer_delete() until unblocked with the "stale" si_code/si_value,
and of course it is still counted wrt RLIMIT_SIGPENDING which also limits
the number of posix timers.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/signal.c~1_SF_DONT_REMOVE	2008-05-26 18:09:12.000000000 +0400
+++ 26-rc2/kernel/signal.c	2008-05-26 18:13:08.000000000 +0400
@@ -1240,18 +1240,22 @@ void sigqueue_free(struct sigqueue *q)
 
 	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
 	/*
-	 * If the signal is still pending remove it from the
-	 * pending queue. We must hold ->siglock while testing
-	 * q->list to serialize with collect_signal() or with
+	 * We must hold ->siglock while testing q->list
+	 * to serialize with collect_signal() or with
 	 * __exit_signal()->flush_sigqueue().
 	 */
 	spin_lock_irqsave(lock, flags);
+	q->flags &= ~SIGQUEUE_PREALLOC;
+	/*
+	 * If it is queued it will be freed when dequeued,
+	 * like the "regular" sigqueue.
+	 */
 	if (!list_empty(&q->list))
-		list_del_init(&q->list);
+		q = NULL;
 	spin_unlock_irqrestore(lock, flags);
 
-	q->flags &= ~SIGQUEUE_PREALLOC;
-	__sigqueue_free(q);
+	if (q)
+		__sigqueue_free(q);
 }
 
 int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)

