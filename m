Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbYHDP5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbYHDP5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 11:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbYHDP5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 11:57:14 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:40731 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbYHDP5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 11:57:13 -0400
Date: Mon, 4 Aug 2008 20:01:06 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark McLoughlin <markmc@redhat.com>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] posix-timers: sys_timer_create: cleanup the error handling
Message-ID: <20080804160106.GA10527@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup.

- sys_timer_create() is big and complicated. The code above the "out:"
  label relies on the fact that "error" must be == 0. This is not very
  robust, make the code more explicit. Remove the unneeded initialization
  of error.

- If idr_get_new() succeeds (as it normally should), we check the returned
  value twice. Move the "-EAGAIN" check under "if (error)".

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/posix-timers.c~7_ERROR	2008-08-04 19:14:16.000000000 +0400
+++ 26-rc2/kernel/posix-timers.c	2008-08-04 19:37:07.000000000 +0400
@@ -454,7 +454,7 @@ sys_timer_create(const clockid_t which_c
 		 struct sigevent __user *timer_event_spec,
 		 timer_t __user * created_timer_id)
 {
-	int error = 0;
+	int error;
 	struct k_itimer *new_timer;
 	int new_timer_id;
 	struct task_struct *process;
@@ -478,9 +478,9 @@ sys_timer_create(const clockid_t which_c
 	error = idr_get_new(&posix_timers_id, (void *) new_timer,
 			    &new_timer_id);
 	spin_unlock_irq(&idr_lock);
-	if (error == -EAGAIN)
-		goto retry;
-	else if (error) {
+	if (error) {
+		if (error == -EAGAIN)
+			goto retry;
 		/*
 		 * Weird looking, but we return EAGAIN if the IDR is
 		 * full (proper POSIX return value for this)
@@ -541,6 +541,8 @@ sys_timer_create(const clockid_t which_c
 	new_timer->it_process = process;
 	list_add(&new_timer->list, &current->signal->posix_timers);
 	spin_unlock_irq(&current->sighand->siglock);
+
+	return 0;
  	/*
 	 * In the case of the timer belonging to another task, after
 	 * the task is unlocked, the timer is owned by the other task
@@ -548,9 +550,7 @@ sys_timer_create(const clockid_t which_c
 	 * new_timer after the unlock call.
 	 */
 out:
-	if (error)
-		release_posix_timer(new_timer, it_id_set);
-
+	release_posix_timer(new_timer, it_id_set);
 	return error;
 }
 

