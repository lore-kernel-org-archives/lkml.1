Return-Path: <linux-kernel-owner+w=401wt.eu-S1760956AbYHEP3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760956AbYHEP3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 11:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759638AbYHEP2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 11:28:44 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:54678 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759187AbYHEP2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 11:28:42 -0400
Date: Tue, 5 Aug 2008 19:32:12 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] posix-timers: kill ->it_sigev_signo and ->it_sigev_value
Message-ID: <20080805153212.GA9748@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the recent changes ->it_sigev_signo and ->it_sigev_value are only
used in sys_timer_create(), kill them.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 include/linux/posix-timers.h |    2 --
 kernel/posix-timers.c        |   17 +++++++----------
 2 files changed, 7 insertions(+), 12 deletions(-)

--- 26-rc2/include/linux/posix-timers.h~8_KILL_IT_XXX	2006-11-17 19:42:31.000000000 +0300
+++ 26-rc2/include/linux/posix-timers.h	2008-08-05 16:11:11.000000000 +0400
@@ -45,8 +45,6 @@ struct k_itimer {
 	int it_requeue_pending;		/* waiting to requeue this timer */
 #define REQUEUE_PENDING 1
 	int it_sigev_notify;		/* notify word of sigevent struct */
-	int it_sigev_signo;		/* signo word of sigevent struct */
-	sigval_t it_sigev_value;	/* value word of sigevent struct */
 	struct task_struct *it_process;	/* process to send signal to */
 	struct sigqueue *sigq;		/* signal queue entry. */
 	union {
--- 26-rc2/kernel/posix-timers.c~8_KILL_IT_XXX	2008-08-04 19:37:07.000000000 +0400
+++ 26-rc2/kernel/posix-timers.c	2008-08-05 16:48:22.000000000 +0400
@@ -511,10 +511,6 @@ sys_timer_create(const clockid_t which_c
 			error = -EFAULT;
 			goto out;
 		}
-		new_timer->it_sigev_notify = event.sigev_notify;
-		new_timer->it_sigev_signo = event.sigev_signo;
-		new_timer->it_sigev_value = event.sigev_value;
-
 		rcu_read_lock();
 		process = good_sigevent(&event);
 		if (process)
@@ -525,17 +521,18 @@ sys_timer_create(const clockid_t which_c
 			goto out;
 		}
 	} else {
-		new_timer->it_sigev_notify = SIGEV_SIGNAL;
-		new_timer->it_sigev_signo = SIGALRM;
-		new_timer->it_sigev_value.sival_int = new_timer->it_id;
+		event.sigev_notify = SIGEV_SIGNAL;
+		event.sigev_signo = SIGALRM;
+		event.sigev_value.sival_int = new_timer->it_id;
 		process = current->group_leader;
 		get_task_struct(process);
 	}
 
-	new_timer->sigq->info.si_code  = SI_TIMER;
+	new_timer->it_sigev_notify     = event.sigev_notify;
+	new_timer->sigq->info.si_signo = event.sigev_signo;
+	new_timer->sigq->info.si_value = event.sigev_value;
 	new_timer->sigq->info.si_tid   = new_timer->it_id;
-	new_timer->sigq->info.si_signo = new_timer->it_sigev_signo;
-	new_timer->sigq->info.si_value = new_timer->it_sigev_value;
+	new_timer->sigq->info.si_code  = SI_TIMER;
 
 	spin_lock_irq(&current->sighand->siglock);
 	new_timer->it_process = process;

