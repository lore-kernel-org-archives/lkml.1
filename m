Return-Path: <linux-kernel-owner+w=401wt.eu-S1758681AbYEQPPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681AbYEQPPq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 11:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757994AbYEQPOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 11:14:34 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:47569 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758589AbYEQPOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 11:14:33 -0400
Date: Sat, 17 May 2008 19:14:20 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Austin Clements <amdragon+kernelbugzilla@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] signals: sigqueue_free: don't free sigqueue if it is queued
Message-ID: <20080517151420.GA9496@tv-sign.ru>
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

This patch doesn't change the behaviour of sys_timer_delete() and friends,
just makes it more correct and allows us to introduce other SIGQUEUE_ flags
passed to the receiver.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~4_SF_DONT_REMOVE	2008-05-17 16:22:07.000000000 +0400
+++ 25/kernel/signal.c	2008-05-17 17:14:04.000000000 +0400
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

