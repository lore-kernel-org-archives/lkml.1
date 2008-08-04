Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbYHDP5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbYHDP5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 11:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbYHDP5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 11:57:15 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:40724 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245AbYHDP5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 11:57:14 -0400
Date: Mon, 4 Aug 2008 20:01:05 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark McLoughlin <markmc@redhat.com>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] posix-timers: move the initialization of timer->sigq from send to create path
Message-ID: <20080804160105.GA10524@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

posix_timer_event() always populates timer->sigq with the same numbers,
move this code into sys_timer_create().

Note that with this patch we can kill it_sigev_signo and it_sigev_value.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/posix-timers.c~6_SIGQ_INIT	2008-08-04 18:13:10.000000000 +0400
+++ 26-rc2/kernel/posix-timers.c	2008-08-04 19:14:16.000000000 +0400
@@ -312,11 +312,6 @@ int posix_timer_event(struct k_itimer *t
 	 */
 	timr->sigq->info.si_sys_private = si_private;
 
-	timr->sigq->info.si_signo = timr->it_sigev_signo;
-	timr->sigq->info.si_code = SI_TIMER;
-	timr->sigq->info.si_tid = timr->it_id;
-	timr->sigq->info.si_value = timr->it_sigev_value;
-
 	shared = !(timr->it_sigev_notify & SIGEV_THREAD_ID);
 	ret = send_sigqueue(timr->sigq, timr->it_process, shared);
 	/* If we failed to send the signal the timer stops. */
@@ -537,6 +532,11 @@ sys_timer_create(const clockid_t which_c
 		get_task_struct(process);
 	}
 
+	new_timer->sigq->info.si_code  = SI_TIMER;
+	new_timer->sigq->info.si_tid   = new_timer->it_id;
+	new_timer->sigq->info.si_signo = new_timer->it_sigev_signo;
+	new_timer->sigq->info.si_value = new_timer->it_sigev_value;
+
 	spin_lock_irq(&current->sighand->siglock);
 	new_timer->it_process = process;
 	list_add(&new_timer->list, &current->signal->posix_timers);

