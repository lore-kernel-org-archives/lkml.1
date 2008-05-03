Return-Path: <linux-kernel-owner+w=401wt.eu-S1757325AbYECRnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbYECRnl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 13:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932199AbYECRnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 13:43:25 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:50712 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbYECRnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 13:43:24 -0400
Date: Sat, 3 May 2008 21:43:11 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Austin Clements <amdragon+kernelbugzilla@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] posix timers: sigqueue_free: don't free sigqueue if it is queued
Message-ID: <20080503174311.GA8118@tv-sign.ru>
References: <20080503173553.GA8106@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080503173553.GA8106@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03, Oleg Nesterov wrote:
>
> Note: I am not sure we shouldn't do the opposite, free sigqueue + cancel the
> pending signal, but this needs some ugly changes. Perhaps we should reconsider
> this change later. See also http://bugzilla.kernel.org/show_bug.cgi?id=10460

In that case perhaps we can do something like (uncompiled, just for illustration)
patch below.

While I don't know what is the "right" behaviour, I hate this patch because
it "looks ugly" (even if correct).

Oleg.

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1709,7 +1709,7 @@ extern int send_sig(int, struct task_str
 extern void zap_other_threads(struct task_struct *p);
 extern int kill_proc(pid_t, int, int);
 extern struct sigqueue *sigqueue_alloc(void);
-extern void sigqueue_free(struct sigqueue *);
+extern void sigqueue_free(struct sigqueue *, struct sigpending *pending);
 extern int send_sigqueue(struct sigqueue *,  struct task_struct *, int group);
 extern int do_sigaction(int, struct k_sigaction *, struct k_sigaction *);
 extern int do_sigaltstack(const stack_t __user *, stack_t __user *, unsigned long);
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1233,7 +1233,24 @@ struct sigqueue *sigqueue_alloc(void)
 	return(q);
 }
 
-void sigqueue_free(struct sigqueue *q)
+static void sigqueue_cancel(struct sigqueue *q, struct sigpending *pending)
+{
+	int sig;
+
+	list_del_init(&q->list);
+
+	sig = q->info.si_signo;
+	if (sig >= SIGRTMIN) {
+		list_for_each_entry(q, &pending->list, list)
+			if (q->info.si_signo == sig)
+				return;
+	}
+
+	sigdelset(&pending->signal, sig);
+}
+
+
+void sigqueue_free(struct sigqueue *q, struct sigpending *pending)
 {
 	unsigned long flags;
 	spinlock_t *lock = &current->sighand->siglock;
@@ -1245,17 +1262,12 @@ void sigqueue_free(struct sigqueue *q)
 	 * __exit_signal()->flush_sigqueue().
 	 */
 	spin_lock_irqsave(lock, flags);
-	/*
-	 * If it is queued it will be freed when dequeued,
-	 * like the "regular" sigqueue.
-	 */
-	q->flags &= ~SIGQUEUE_PREALLOC;
 	if (!list_empty(&q->list))
-		q = NULL;
+		sigqueue_cancel(q, pending);
 	spin_unlock_irqrestore(lock, flags);
 
-	if (q)
-		__sigqueue_free(q);
+	q->flags &= ~SIGQUEUE_PREALLOC;
+	__sigqueue_free(q);
 }
 
 int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -449,7 +449,6 @@ static void release_posix_timer(struct k
 		idr_remove(&posix_timers_id, tmr->it_id);
 		spin_unlock_irqrestore(&idr_lock, flags);
 	}
-	sigqueue_free(tmr->sigq);
 	kmem_cache_free(posix_timers_cache, tmr);
 }
 
@@ -828,6 +827,27 @@ static inline int timer_delete_hook(stru
 	return CLOCK_DISPATCH(timer->it_clock, timer_del, (timer));
 }
 
+static void __timer_delete(struct k_itimer *timer, unsigned long flags)
+{
+	struct sigpending *pending;
+
+	pending = &current->signal->shared_pending;
+	if (timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID)) {
+		pending = &timer->it_process->pending;
+		put_task_struct(timer->it_process);
+	}
+	/*
+	 * This keeps any tasks waiting on the spin lock from thinking
+	 * they got something (see the lock code above).
+	 */
+	timer->it_process = NULL;
+	unlock_timer(timer, flags);
+
+	/* Note that "pending" can point to the freed memory */
+	sigqueue_free(timer->sigq, pending);
+	release_posix_timer(timer, IT_ID_SET);
+}
+
 /* Delete a POSIX.1b interval timer. */
 asmlinkage long
 sys_timer_delete(timer_t timer_id)
@@ -848,16 +868,8 @@ retry_delete:
 	spin_lock(&current->sighand->siglock);
 	list_del(&timer->list);
 	spin_unlock(&current->sighand->siglock);
-	/*
-	 * This keeps any tasks waiting on the spin lock from thinking
-	 * they got something (see the lock code above).
-	 */
-	if (timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
-		put_task_struct(timer->it_process);
-	timer->it_process = NULL;
 
-	unlock_timer(timer, flags);
-	release_posix_timer(timer, IT_ID_SET);
+	__timer_delete(timer, flags);
 	return 0;
 }
 
@@ -876,16 +888,8 @@ retry_delete:
 		goto retry_delete;
 	}
 	list_del(&timer->list);
-	/*
-	 * This keeps any tasks waiting on the spin lock from thinking
-	 * they got something (see the lock code above).
-	 */
-	if (timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
-		put_task_struct(timer->it_process);
-	timer->it_process = NULL;
 
-	unlock_timer(timer, flags);
-	release_posix_timer(timer, IT_ID_SET);
+	__timer_delete(timer, flags);
 }
 
 /*

