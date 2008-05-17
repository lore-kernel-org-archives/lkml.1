Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979AbYEQPOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbYEQPOF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 11:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756374AbYEQPNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 11:13:31 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:47501 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756170AbYEQPNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 11:13:30 -0400
Date: Sat, 17 May 2008 19:14:19 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] posix timers: timer_delete: remove the bogus "->it_process != NULL" check
Message-ID: <20080517151419.GA9490@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_timer_delete() and itimer_delete() check "timer->it_process != NULL", this
looks completely bogus. ->it_process == NULL means that this timer is already
under destruction or it is not fully initialized, this must not happen.

	sys_timer_delete: the timer is locked, and lock_timer() can't succeed
	if ->it_process == NULL.

	itimer_delete: it is called by exit_itimers() when there are no other
	threads which can play with signal_struct->posix_timers.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>

--- 25/kernel/posix-timers.c~2_TIMER_DEL_NO_CHECK	2008-05-17 16:03:24.000000000 +0400
+++ 25/kernel/posix-timers.c	2008-05-17 16:31:26.000000000 +0400
@@ -855,11 +855,10 @@ retry_delete:
 	 * This keeps any tasks waiting on the spin lock from thinking
 	 * they got something (see the lock code above).
 	 */
-	if (timer->it_process) {
-		if (timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
-			put_task_struct(timer->it_process);
-		timer->it_process = NULL;
-	}
+	if (timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
+		put_task_struct(timer->it_process);
+	timer->it_process = NULL;
+
 	unlock_timer(timer, flags);
 	release_posix_timer(timer, IT_ID_SET);
 	return 0;
@@ -884,11 +883,10 @@ retry_delete:
 	 * This keeps any tasks waiting on the spin lock from thinking
 	 * they got something (see the lock code above).
 	 */
-	if (timer->it_process) {
-		if (timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
-			put_task_struct(timer->it_process);
-		timer->it_process = NULL;
-	}
+	if (timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
+		put_task_struct(timer->it_process);
+	timer->it_process = NULL;
+
 	unlock_timer(timer, flags);
 	release_posix_timer(timer, IT_ID_SET);
 }

