Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbYHCRqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbYHCRqE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 13:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756858AbYHCRpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 13:45:46 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:33166 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756682AbYHCRpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 13:45:45 -0400
Date: Sun, 3 Aug 2008 21:49:10 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark McLoughlin <markmc@redhat.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] posix-timers: don't switch to ->group_leader if ->it_process dies
Message-ID: <20080803174910.GA4913@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(textually depends on posix-timers-fix-posix_timer_event-vs-dequeue_signal-race.patch)

posix_timer_event() drops SIGEV_THREAD_ID and switches to ->group_leader if
send_sigqueue() fails.

This is not very useful and doesn't work reliably. send_sigqueue() can only
fail if ->it_process is dead. But it can die before it dequeues the SI_TIMER
signal, in that case the timer stops anyway.

Remove this code. I guess it was needed a long ago to ensure that the timer
is not destroyed when when its creator thread dies.

Q: perhaps it makes sense to change sys_timer_settime() to return an error
if ->it_process is dead?

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/posix-timers.c~1_DONT_RESEND	2008-07-23 20:24:05.000000000 +0400
+++ 26-rc2/kernel/posix-timers.c	2008-08-03 20:25:41.000000000 +0400
@@ -298,6 +298,7 @@ void do_schedule_next_timer(struct sigin
 
 int posix_timer_event(struct k_itimer *timr, int si_private)
 {
+	int shared, ret;
 	/*
 	 * FIXME: if ->sigq is queued we can race with
 	 * dequeue_signal()->do_schedule_next_timer().
@@ -316,20 +317,10 @@ int posix_timer_event(struct k_itimer *t
 	timr->sigq->info.si_tid = timr->it_id;
 	timr->sigq->info.si_value = timr->it_sigev_value;
 
-	if (timr->it_sigev_notify & SIGEV_THREAD_ID) {
-		struct task_struct *leader;
-		int ret = send_sigqueue(timr->sigq, timr->it_process, 0);
-
-		if (likely(ret >= 0))
-			return ret;
-
-		timr->it_sigev_notify = SIGEV_SIGNAL;
-		leader = timr->it_process->group_leader;
-		put_task_struct(timr->it_process);
-		timr->it_process = leader;
-	}
-
-	return send_sigqueue(timr->sigq, timr->it_process, 1);
+	shared = !(timr->it_sigev_notify & SIGEV_THREAD_ID);
+	ret = send_sigqueue(timr->sigq, timr->it_process, shared);
+	/* If we failed to send the signal the timer stops. */
+	return ret > 0;
 }
 EXPORT_SYMBOL_GPL(posix_timer_event);
 

