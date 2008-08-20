Return-Path: <linux-kernel-owner+w=401wt.eu-S1759489AbYHTQKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489AbYHTQKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 12:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756692AbYHTQJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 12:09:28 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:60070 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755333AbYHTQJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 12:09:27 -0400
Date: Wed, 20 Aug 2008 20:13:58 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] posix-timers: check ->it_signal instead of ->it_pid to validate the timer
Message-ID: <20080820161358.GA1407@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

->it_pid (was ->it_process) has also a special meaning: if it is NULL,
the timer is under deletion or it wasn't initialized yet. We can check
->it_signal != NULL instead, this way we can

	- simplify sys_timer_create() a bit

	- remove yet another check from lock_timer()

	- move put_pid(->it_pid) into release_posix_timer() which
	  runs outside of ->it_lock

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/posix-timers.c~12_USE_SIGNAL_MORE	2008-08-17 18:34:09.000000000 +0400
+++ 26-rc2/kernel/posix-timers.c	2008-08-17 21:09:52.000000000 +0400
@@ -449,6 +449,7 @@ static void release_posix_timer(struct k
 		idr_remove(&posix_timers_id, tmr->it_id);
 		spin_unlock_irqrestore(&idr_lock, flags);
 	}
+	put_pid(tmr->it_pid);
 	sigqueue_free(tmr->sigq);
 	kmem_cache_free(posix_timers_cache, tmr);
 }
@@ -465,7 +466,6 @@ sys_timer_create(const clockid_t which_c
 	int new_timer_id;
 	sigevent_t event;
 	int it_id_set = IT_ID_NOT_SET;
-	struct pid *it_pid;
 
 	if (invalid_clockid(which_clock))
 		return -EINVAL;
@@ -517,9 +517,9 @@ sys_timer_create(const clockid_t which_c
 			goto out;
 		}
 		rcu_read_lock();
-		it_pid = get_pid(good_sigevent(&event));
+		new_timer->it_pid = get_pid(good_sigevent(&event));
 		rcu_read_unlock();
-		if (!it_pid) {
+		if (!new_timer->it_pid) {
 			error = -EINVAL;
 			goto out;
 		}
@@ -527,7 +527,7 @@ sys_timer_create(const clockid_t which_c
 		event.sigev_notify = SIGEV_SIGNAL;
 		event.sigev_signo = SIGALRM;
 		event.sigev_value.sival_int = new_timer->it_id;
-		it_pid = get_pid(task_tgid(current));
+		new_timer->it_pid = get_pid(task_tgid(current));
 	}
 
 	new_timer->it_sigev_notify     = event.sigev_notify;
@@ -537,7 +537,6 @@ sys_timer_create(const clockid_t which_c
 	new_timer->sigq->info.si_code  = SI_TIMER;
 
 	spin_lock_irq(&current->sighand->siglock);
-	new_timer->it_pid = it_pid;
 	new_timer->it_signal = current->signal;
 	list_add(&new_timer->list, &current->signal->posix_timers);
 	spin_unlock_irq(&current->sighand->siglock);
@@ -573,7 +572,7 @@ static struct k_itimer *lock_timer(timer
 	timr = idr_find(&posix_timers_id, (int)timer_id);
 	if (timr) {
 		spin_lock(&timr->it_lock);
-		if (timr->it_pid && timr->it_signal == current->signal) {
+		if (timr->it_signal == current->signal) {
 			spin_unlock(&idr_lock);
 			return timr;
 		}
@@ -822,8 +821,7 @@ retry_delete:
 	 * This keeps any tasks waiting on the spin lock from thinking
 	 * they got something (see the lock code above).
 	 */
-	put_pid(timer->it_pid);
-	timer->it_pid = NULL;
+	timer->it_signal = NULL;
 
 	unlock_timer(timer, flags);
 	release_posix_timer(timer, IT_ID_SET);
@@ -849,8 +847,7 @@ retry_delete:
 	 * This keeps any tasks waiting on the spin lock from thinking
 	 * they got something (see the lock code above).
 	 */
-	put_pid(timer->it_pid);
-	timer->it_pid = NULL;
+	timer->it_signal = NULL;
 
 	unlock_timer(timer, flags);
 	release_posix_timer(timer, IT_ID_SET);

