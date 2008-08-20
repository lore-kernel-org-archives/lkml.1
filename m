Return-Path: <linux-kernel-owner+w=401wt.eu-S1759308AbYHTQJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308AbYHTQJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 12:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755774AbYHTQJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 12:09:27 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:60069 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbYHTQJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 12:09:26 -0400
Date: Wed, 20 Aug 2008 20:13:57 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] posix-timers: use "struct pid*" instead of "struct task_struct*"
Message-ID: <20080820161357.GA1404@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

k_itimer holds the ref to the ->it_process until sys_timer_delete(). This
allows to pin up to RLIMIT_SIGPENDING dead task_struct's. Change the code
to use "struct pid *" instead.

The patch doesn't kill ->it_process, it places ->it_pid into the union.
->it_process is still used by do_cpu_nanosleep() as before. It would be
trivial to change the nanosleep code as well, but since it uses it_process
in a special way I think it is better to keep this field for grep.

The patch bloats the kernel by 104 bytes and it also adds the new pointer,
->it_signal, to k_itimer. It is used by lock_timer() to verify that the
found timer was not created by another process. It is not clear why do we
use the global database (and thus the global idr_lock) for posix timers.
We still need the signal_struct->posix_timers which contains all useable
timers, perhaps it is better to use some form of per-process array instead.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 include/linux/posix-timers.h |    6 +++++-
 kernel/posix-timers.c        |   43 +++++++++++++++++++++++--------------------
 2 files changed, 28 insertions(+), 21 deletions(-)

--- 26-rc2/include/linux/posix-timers.h~11_S_TASK_PID	2008-08-05 16:11:11.000000000 +0400
+++ 26-rc2/include/linux/posix-timers.h	2008-08-17 17:26:52.000000000 +0400
@@ -45,7 +45,11 @@ struct k_itimer {
 	int it_requeue_pending;		/* waiting to requeue this timer */
 #define REQUEUE_PENDING 1
 	int it_sigev_notify;		/* notify word of sigevent struct */
-	struct task_struct *it_process;	/* process to send signal to */
+	struct signal_struct *it_signal;
+	union {
+		struct pid *it_pid;	/* pid of process to send signal to */
+		struct task_struct *it_process;	/* for clock_nanosleep */
+	};
 	struct sigqueue *sigq;		/* signal queue entry. */
 	union {
 		struct {
--- 26-rc2/kernel/posix-timers.c~11_S_TASK_PID	2008-08-05 18:53:19.000000000 +0400
+++ 26-rc2/kernel/posix-timers.c	2008-08-17 18:34:09.000000000 +0400
@@ -116,7 +116,7 @@ static DEFINE_SPINLOCK(idr_lock);
  *	    must supply functions here, even if the function just returns
  *	    ENOSYS.  The standard POSIX timer management code assumes the
  *	    following: 1.) The k_itimer struct (sched.h) is used for the
- *	    timer.  2.) The list, it_lock, it_clock, it_id and it_process
+ *	    timer.  2.) The list, it_lock, it_clock, it_id and it_pid
  *	    fields are not modified by timer code.
  *
  *          At this time all functions EXCEPT clock_nanosleep can be
@@ -298,7 +298,8 @@ void do_schedule_next_timer(struct sigin
 
 int posix_timer_event(struct k_itimer *timr, int si_private)
 {
-	int shared, ret;
+	struct task_struct *task;
+	int shared, ret = -1;
 	/*
 	 * FIXME: if ->sigq is queued we can race with
 	 * dequeue_signal()->do_schedule_next_timer().
@@ -312,8 +313,13 @@ int posix_timer_event(struct k_itimer *t
 	 */
 	timr->sigq->info.si_sys_private = si_private;
 
-	shared = !(timr->it_sigev_notify & SIGEV_THREAD_ID);
-	ret = send_sigqueue(timr->sigq, timr->it_process, shared);
+	rcu_read_lock();
+	task = pid_task(timr->it_pid, PIDTYPE_PID);
+	if (task) {
+		shared = !(timr->it_sigev_notify & SIGEV_THREAD_ID);
+		ret = send_sigqueue(timr->sigq, task, shared);
+	}
+	rcu_read_unlock();
 	/* If we failed to send the signal the timer stops. */
 	return ret > 0;
 }
@@ -390,7 +396,7 @@ static enum hrtimer_restart posix_timer_
 	return ret;
 }
 
-static struct task_struct * good_sigevent(sigevent_t * event)
+static struct pid *good_sigevent(sigevent_t * event)
 {
 	struct task_struct *rtn = current->group_leader;
 
@@ -404,7 +410,7 @@ static struct task_struct * good_sigeven
 	    ((event->sigev_signo <= 0) || (event->sigev_signo > SIGRTMAX)))
 		return NULL;
 
-	return rtn;
+	return task_pid(rtn);
 }
 
 void register_posix_clock(const clockid_t clock_id, struct k_clock *new_clock)
@@ -457,9 +463,9 @@ sys_timer_create(const clockid_t which_c
 	int error;
 	struct k_itimer *new_timer;
 	int new_timer_id;
-	struct task_struct *process;
 	sigevent_t event;
 	int it_id_set = IT_ID_NOT_SET;
+	struct pid *it_pid;
 
 	if (invalid_clockid(which_clock))
 		return -EINVAL;
@@ -511,11 +517,9 @@ sys_timer_create(const clockid_t which_c
 			goto out;
 		}
 		rcu_read_lock();
-		process = good_sigevent(&event);
-		if (process)
-			get_task_struct(process);
+		it_pid = get_pid(good_sigevent(&event));
 		rcu_read_unlock();
-		if (!process) {
+		if (!it_pid) {
 			error = -EINVAL;
 			goto out;
 		}
@@ -523,8 +527,7 @@ sys_timer_create(const clockid_t which_c
 		event.sigev_notify = SIGEV_SIGNAL;
 		event.sigev_signo = SIGALRM;
 		event.sigev_value.sival_int = new_timer->it_id;
-		process = current->group_leader;
-		get_task_struct(process);
+		it_pid = get_pid(task_tgid(current));
 	}
 
 	new_timer->it_sigev_notify     = event.sigev_notify;
@@ -534,7 +537,8 @@ sys_timer_create(const clockid_t which_c
 	new_timer->sigq->info.si_code  = SI_TIMER;
 
 	spin_lock_irq(&current->sighand->siglock);
-	new_timer->it_process = process;
+	new_timer->it_pid = it_pid;
+	new_timer->it_signal = current->signal;
 	list_add(&new_timer->list, &current->signal->posix_timers);
 	spin_unlock_irq(&current->sighand->siglock);
 
@@ -569,8 +573,7 @@ static struct k_itimer *lock_timer(timer
 	timr = idr_find(&posix_timers_id, (int)timer_id);
 	if (timr) {
 		spin_lock(&timr->it_lock);
-		if (timr->it_process &&
-		    same_thread_group(timr->it_process, current)) {
+		if (timr->it_pid && timr->it_signal == current->signal) {
 			spin_unlock(&idr_lock);
 			return timr;
 		}
@@ -819,8 +822,8 @@ retry_delete:
 	 * This keeps any tasks waiting on the spin lock from thinking
 	 * they got something (see the lock code above).
 	 */
-	put_task_struct(timer->it_process);
-	timer->it_process = NULL;
+	put_pid(timer->it_pid);
+	timer->it_pid = NULL;
 
 	unlock_timer(timer, flags);
 	release_posix_timer(timer, IT_ID_SET);
@@ -846,8 +849,8 @@ retry_delete:
 	 * This keeps any tasks waiting on the spin lock from thinking
 	 * they got something (see the lock code above).
 	 */
-	put_task_struct(timer->it_process);
-	timer->it_process = NULL;
+	put_pid(timer->it_pid);
+	timer->it_pid = NULL;
 
 	unlock_timer(timer, flags);
 	release_posix_timer(timer, IT_ID_SET);

