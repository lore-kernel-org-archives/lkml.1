Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbYHDP6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbYHDP6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 11:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755132AbYHDP5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 11:57:23 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:40743 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754674AbYHDP5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 11:57:22 -0400
Date: Mon, 4 Aug 2008 20:01:04 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark McLoughlin <markmc@redhat.com>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] posix-timers: sys_timer_create: simplify and s/tasklist/rcu/
Message-ID: <20080804160104.GA10521@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Change the code to do rcu_read_lock() instead of taking tasklist_lock,
  it is safe to get_task_struct(p) if p was found under RCU.

  However, now we must not use process's sighand/signal, they may be NULL.
  We can use current->sighand/signal instead, this "process" must belong
  to the current's thread-group.

- Factor out the common code for 2 "if (timer_event_spec)" branches, the
  !timer_event_spec case can use current too.

- use spin_lock_irq() instead of _irqsave(), kill "flags".

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/posix-timers.c~5_CLEANUP	2008-08-04 16:50:29.000000000 +0400
+++ 26-rc2/kernel/posix-timers.c	2008-08-04 18:13:10.000000000 +0400
@@ -463,7 +463,6 @@ sys_timer_create(const clockid_t which_c
 	struct k_itimer *new_timer;
 	int new_timer_id;
 	struct task_struct *process;
-	unsigned long flags;
 	sigevent_t event;
 	int it_id_set = IT_ID_NOT_SET;
 
@@ -521,16 +520,11 @@ sys_timer_create(const clockid_t which_c
 		new_timer->it_sigev_signo = event.sigev_signo;
 		new_timer->it_sigev_value = event.sigev_value;
 
-		read_lock(&tasklist_lock);
-		if ((process = good_sigevent(&event))) {
+		rcu_read_lock();
+		process = good_sigevent(&event);
+		if (process)
 			get_task_struct(process);
-			spin_lock_irqsave(&process->sighand->siglock, flags);
-			new_timer->it_process = process;
-			list_add(&new_timer->list,
-				&process->signal->posix_timers);
-			spin_unlock_irqrestore(&process->sighand->siglock, flags);
-		}
-		read_unlock(&tasklist_lock);
+		rcu_read_unlock();
 		if (!process) {
 			error = -EINVAL;
 			goto out;
@@ -541,19 +535,18 @@ sys_timer_create(const clockid_t which_c
 		new_timer->it_sigev_value.sival_int = new_timer->it_id;
 		process = current->group_leader;
 		get_task_struct(process);
-		spin_lock_irqsave(&process->sighand->siglock, flags);
-		new_timer->it_process = process;
-		list_add(&new_timer->list, &process->signal->posix_timers);
-		spin_unlock_irqrestore(&process->sighand->siglock, flags);
 	}
 
+	spin_lock_irq(&current->sighand->siglock);
+	new_timer->it_process = process;
+	list_add(&new_timer->list, &current->signal->posix_timers);
+	spin_unlock_irq(&current->sighand->siglock);
  	/*
 	 * In the case of the timer belonging to another task, after
 	 * the task is unlocked, the timer is owned by the other task
 	 * and may cease to exist at any time.  Don't use or modify
 	 * new_timer after the unlock call.
 	 */
-
 out:
 	if (error)
 		release_posix_timer(new_timer, it_id_set);

