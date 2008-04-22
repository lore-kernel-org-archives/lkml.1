Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbYDVQdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbYDVQdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 12:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbYDVQdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 12:33:40 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:41844 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945AbYDVQdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 12:33:39 -0400
Date: Tue, 22 Apr 2008 19:38:21 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Austin Clements <amdragon+kernelbugzilla@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [RFC,PATCH 2/2] posix timers: don't discard the signal if the timer was explicitly destroyed
Message-ID: <20080422153821.GA19903@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am not sure this patch is really needed, please review.

The previous patch adds the user-visible change. It is not clear to me why
should we cancel the pending signal sent by the timer after timer_delete().
Suppose the signal is blocked, pending, the user checks sys_rt_sigpending(),
destroys the timer and then doesn't see the signal.

Add the "boolean force" parameter to sigqueue_free(). Unless it is true, we
don't cancel the pending signal but just clear SIGQUEUE_PREALLOC, so that
"struct sigqueue" will be freed when dequeued, like the "regular" sigqueue.

So, with this patch exit/exec discard the signal, but timer_delete() doesn't.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/include/linux/sched.h~2_PT_ONLY_ON_EXEC	2008-03-08 17:35:43.000000000 +0300
+++ 25/include/linux/sched.h	2008-03-08 17:35:43.000000000 +0300
@@ -1709,7 +1709,7 @@ extern int send_sig(int, struct task_str
 extern void zap_other_threads(struct task_struct *p);
 extern int kill_proc(pid_t, int, int);
 extern struct sigqueue *sigqueue_alloc(void);
-extern void sigqueue_free(struct sigqueue *);
+extern void sigqueue_free(struct sigqueue *q, int force);
 extern int send_sigqueue(struct sigqueue *,  struct task_struct *, int group);
 extern int do_sigaction(int, struct k_sigaction *, struct k_sigaction *);
 extern int do_sigaltstack(const stack_t __user *, stack_t __user *, unsigned long);
--- 25/kernel/signal.c~2_PT_ONLY_ON_EXEC	2008-04-22 16:40:45.000000000 +0400
+++ 25/kernel/signal.c	2008-04-22 18:42:34.000000000 +0400
@@ -1255,7 +1255,7 @@ static void sigqueue_cancel(struct sigqu
 	recalc_sigpending();
 }
 
-void sigqueue_free(struct sigqueue *q)
+void sigqueue_free(struct sigqueue *q, int force)
 {
 	unsigned long flags;
 	spinlock_t *lock = &current->sighand->siglock;
@@ -1267,12 +1267,17 @@ void sigqueue_free(struct sigqueue *q)
 	 * q->list to serialize with collect_signal().
 	 */
 	spin_lock_irqsave(lock, flags);
-	if (!list_empty(&q->list))
-		sigqueue_cancel(q);
+	q->flags &= ~SIGQUEUE_PREALLOC;
+	if (!list_empty(&q->list)) {
+		if (force)
+			sigqueue_cancel(q);
+		else
+			q = NULL;
+	}
 	spin_unlock_irqrestore(lock, flags);
 
-	q->flags &= ~SIGQUEUE_PREALLOC;
-	__sigqueue_free(q);
+	if (q)
+		__sigqueue_free(q);
 }
 
 int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
--- 25/kernel/posix-timers.c~2_PT_ONLY_ON_EXEC	2008-03-08 17:41:18.000000000 +0300
+++ 25/kernel/posix-timers.c	2008-04-22 18:35:50.000000000 +0400
@@ -441,7 +441,7 @@ static struct k_itimer * alloc_posix_tim
 
 #define IT_ID_SET	1
 #define IT_ID_NOT_SET	0
-static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
+static void release_posix_timer(struct k_itimer *tmr, int it_id_set, int force)
 {
 	if (it_id_set) {
 		unsigned long flags;
@@ -449,7 +449,7 @@ static void release_posix_timer(struct k
 		idr_remove(&posix_timers_id, tmr->it_id);
 		spin_unlock_irqrestore(&idr_lock, flags);
 	}
-	sigqueue_free(tmr->sigq);
+	sigqueue_free(tmr->sigq, force);
 	if (unlikely(tmr->it_process) &&
 	    tmr->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
 		put_task_struct(tmr->it_process);
@@ -580,7 +580,7 @@ sys_timer_create(const clockid_t which_c
 
 out:
 	if (error)
-		release_posix_timer(new_timer, it_id_set);
+		release_posix_timer(new_timer, it_id_set, 0);
 
 	return error;
 }
@@ -861,7 +861,7 @@ retry_delete:
 		timer->it_process = NULL;
 	}
 	unlock_timer(timer, flags);
-	release_posix_timer(timer, IT_ID_SET);
+	release_posix_timer(timer, IT_ID_SET, 0);
 	return 0;
 }
 
@@ -890,7 +890,7 @@ retry_delete:
 		timer->it_process = NULL;
 	}
 	unlock_timer(timer, flags);
-	release_posix_timer(timer, IT_ID_SET);
+	release_posix_timer(timer, IT_ID_SET, 1);
 }
 
 /*

