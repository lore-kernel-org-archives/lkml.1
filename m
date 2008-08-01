Return-Path: <linux-kernel-owner+w=401wt.eu-S1755077AbYHAQDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbYHAQDF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 12:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbYHAQCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 12:02:55 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:60638 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbYHAQCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 12:02:54 -0400
Date: Fri, 1 Aug 2008 20:06:11 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Ingo Molnar <mingo@elte.hu>, Mark McLoughlin <markmc@redhat.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Q: posix_timer_event: can't we kill the "switch to ->group_leader on failure" ?
Message-ID: <20080801160611.GA2123@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

posix_timer_event() drops SIGEV_THREAD_ID and switches to ->group_leader
if send_sigqueue() fails.

Is this really useful? I don't understand the point.

But more importantly, I think this code gives the false promises, it
doesn't work reliably.

send_sigqueue() can only fail if the thread dies. But it can die before
it dequeues the SI_TIMER signal, in that case the timer stops anyway.

Isn't it better to just remove this code?

--- 26-rc2/kernel/posix-timers.c~1_DONT_RESEND	2008-07-23 20:24:05.000000000 +0400
+++ 26-rc2/kernel/posix-timers.c	2008-08-01 19:37:47.000000000 +0400
@@ -298,6 +298,7 @@ void do_schedule_next_timer(struct sigin
 
 int posix_timer_event(struct k_itimer *timr, int si_private)
 {
+	int ret;
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
+	ret = send_sigqueue(timr->sigq, timr->it_process,
+			!(timr->it_sigev_notify & SIGEV_THREAD_ID));
+	/* if we failed to send the signal, the timer stops */
+	return ret > 0;
 }
 EXPORT_SYMBOL_GPL(posix_timer_event);
 
-------------------------------------------------------------------------------

If we can do the above, we can simplify the code further, see the patch
below (should be 2 patches).

Thoughts?

Oleg.

--- 26-rc2/kernel/posix-timers.c~2_GET_LEADER	2008-08-01 19:37:47.000000000 +0400
+++ 26-rc2/kernel/posix-timers.c	2008-08-01 19:43:09.000000000 +0400
@@ -541,10 +541,9 @@ sys_timer_create(const clockid_t which_c
 			spin_lock_irqsave(&process->sighand->siglock, flags);
 			if (!(process->flags & PF_EXITING)) {
 				new_timer->it_process = process;
+				get_task_struct(process);
 				list_add(&new_timer->list,
 					 &process->signal->posix_timers);
-				if (new_timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
-					get_task_struct(process);
 				spin_unlock_irqrestore(&process->sighand->siglock, flags);
 			} else {
 				spin_unlock_irqrestore(&process->sighand->siglock, flags);
@@ -561,6 +560,7 @@ sys_timer_create(const clockid_t which_c
 		new_timer->it_sigev_signo = SIGALRM;
 		new_timer->it_sigev_value.sival_int = new_timer->it_id;
 		process = current->group_leader;
+		get_task_struct(process);
 		spin_lock_irqsave(&process->sighand->siglock, flags);
 		new_timer->it_process = process;
 		list_add(&new_timer->list, &process->signal->posix_timers);
@@ -853,8 +853,7 @@ retry_delete:
 	 * This keeps any tasks waiting on the spin lock from thinking
 	 * they got something (see the lock code above).
 	 */
-	if (timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
-		put_task_struct(timer->it_process);
+	put_task_struct(timer->it_process);
 	timer->it_process = NULL;
 
 	unlock_timer(timer, flags);
@@ -881,8 +880,7 @@ retry_delete:
 	 * This keeps any tasks waiting on the spin lock from thinking
 	 * they got something (see the lock code above).
 	 */
-	if (timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
-		put_task_struct(timer->it_process);
+	put_task_struct(timer->it_process);
 	timer->it_process = NULL;
 
 	unlock_timer(timer, flags);
--- 26-rc2/fs/exec.c~2_GET_LEADER	2008-07-22 15:46:04.000000000 +0400
+++ 26-rc2/fs/exec.c	2008-08-01 19:44:31.000000000 +0400
@@ -757,7 +757,6 @@ static int de_thread(struct task_struct 
 	struct signal_struct *sig = tsk->signal;
 	struct sighand_struct *oldsighand = tsk->sighand;
 	spinlock_t *lock = &oldsighand->siglock;
-	struct task_struct *leader = NULL;
 	int count;
 
 	if (thread_group_empty(tsk))
@@ -795,7 +794,7 @@ static int de_thread(struct task_struct 
 	 * and to assume its PID:
 	 */
 	if (!thread_group_leader(tsk)) {
-		leader = tsk->group_leader;
+		struct task_struct *leader = tsk->group_leader;
 
 		sig->notify_count = -1;	/* for exit_notify() */
 		for (;;) {
@@ -849,8 +848,9 @@ static int de_thread(struct task_struct 
 
 		BUG_ON(leader->exit_state != EXIT_ZOMBIE);
 		leader->exit_state = EXIT_DEAD;
-
 		write_unlock_irq(&tasklist_lock);
+
+		release_task(leader);
 	}
 
 	sig->group_exit_task = NULL;
@@ -859,8 +859,6 @@ static int de_thread(struct task_struct 
 no_thread_group:
 	exit_itimers(sig);
 	flush_itimer_signals();
-	if (leader)
-		release_task(leader);
 
 	if (atomic_read(&oldsighand->count) != 1) {
 		struct sighand_struct *newsighand;

