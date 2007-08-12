Return-Path: <linux-kernel-owner+w=401wt.eu-S936556AbXHLRDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936556AbXHLRDq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 13:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936077AbXHLRDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 13:03:12 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:52887 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935998AbXHLRDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 13:03:10 -0400
Date: Sun, 12 Aug 2007 21:05:30 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk-manpages@gmx.net>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: [PATCH 3/4] signalfd: fix interaction with posix-timers
Message-ID: <20070812170530.GA4302@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

dequeue_signal:

	if (__SI_TIMER) {
		spin_unlock(&tsk->sighand->siglock);
		do_schedule_next_timer(info);
		spin_lock(&tsk->sighand->siglock);
	}

Unless tsk == curent, this is absolutely unsafe: nothing prevents tsk from
exiting. If signalfd was passed to another process, do_schedule_next_timer()
is just wrong.

Add yet another "tsk == current" check into dequeue_signal().

This patch fixes an oopsable bug, but breaks the scheduling of posix timers
if the shared __SI_TIMER signal was fetched via signalfd attached to another
sub-thread. Mostly fixed by the next patch.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/kernel/signal.c~3_SIGFD	2007-08-09 19:59:27.000000000 +0400
+++ t/kernel/signal.c	2007-08-12 19:48:26.000000000 +0400
@@ -378,7 +378,7 @@ int dequeue_signal(struct task_struct *t
 	/* We only dequeue private signals from ourselves, we don't let
 	 * signalfd steal them
 	 */
-	if (tsk == current)
+	if (likely(tsk == current))
 		signr = __dequeue_signal(&tsk->pending, mask, info);
 	if (!signr) {
 		signr = __dequeue_signal(&tsk->signal->shared_pending,
@@ -425,7 +425,7 @@ int dequeue_signal(struct task_struct *t
 		if (!(tsk->signal->flags & SIGNAL_GROUP_EXIT))
 			tsk->signal->flags |= SIGNAL_STOP_DEQUEUED;
 	}
-	if ( signr &&
+	if (signr && likely(tsk == current) &&
 	     ((info->si_code & __SI_MASK) == __SI_TIMER) &&
 	     info->si_sys_private){
 		/*

