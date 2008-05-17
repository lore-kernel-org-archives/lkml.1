Return-Path: <linux-kernel-owner+w=401wt.eu-S1758549AbYEQPO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549AbYEQPO3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 11:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756847AbYEQPNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 11:13:33 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:47508 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756584AbYEQPNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 11:13:32 -0400
Date: Sat, 17 May 2008 19:14:18 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] signals: fix sigqueue_free() vs __exit_signal() race
Message-ID: <20080517151418.GA9487@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__exit_signal() does flush_sigqueue(tsk->pending) outside of ->siglock.
This can race with another thread doing sigqueue_free(), we can free
the same SIGQUEUE_PREALLOC sigqueue twice or corrupt the pending->list.

Note that even sys_exit_group() can trigger this race, not only
sys_timer_delete().

Move the callsite of flush_sigqueue(tsk->pending) under ->siglock.

This patch doesn't touch flush_sigqueue(->shared_pending) below, it is
called when there are no other threads which can play with signals,
and sigqueue_free() can't be used outside of our thread group.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>

--- 25/kernel/exit.c~1_SQFREE_EXIT_RACE	2008-05-17 16:03:29.000000000 +0400
+++ 25/kernel/exit.c	2008-05-17 16:22:07.000000000 +0400
@@ -125,6 +125,12 @@ static void __exit_signal(struct task_st
 
 	__unhash_process(tsk);
 
+	/*
+	 * Do this under ->siglock, we can race with another thread
+	 * doing sigqueue_free() if we have SIGQUEUE_PREALLOC signals.
+	 */
+	flush_sigqueue(&tsk->pending);
+
 	tsk->signal = NULL;
 	tsk->sighand = NULL;
 	spin_unlock(&sighand->siglock);
@@ -132,7 +138,6 @@ static void __exit_signal(struct task_st
 
 	__cleanup_sighand(sighand);
 	clear_tsk_thread_flag(tsk,TIF_SIGPENDING);
-	flush_sigqueue(&tsk->pending);
 	if (sig) {
 		flush_sigqueue(&sig->shared_pending);
 		taskstats_tgid_free(sig);
--- 25/kernel/signal.c~1_SQFREE_EXIT_RACE	2008-05-17 16:03:29.000000000 +0400
+++ 25/kernel/signal.c	2008-05-17 16:22:07.000000000 +0400
@@ -1242,7 +1242,8 @@ void sigqueue_free(struct sigqueue *q)
 	/*
 	 * If the signal is still pending remove it from the
 	 * pending queue. We must hold ->siglock while testing
-	 * q->list to serialize with collect_signal().
+	 * q->list to serialize with collect_signal() or with
+	 * __exit_signal()->flush_sigqueue().
 	 */
 	spin_lock_irqsave(lock, flags);
 	if (!list_empty(&q->list))

