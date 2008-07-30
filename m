Return-Path: <linux-kernel-owner+w=401wt.eu-S1758798AbYG3RHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798AbYG3RHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 13:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757316AbYG3RGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 13:06:47 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:38855 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757266AbYG3RGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 13:06:44 -0400
Date: Wed, 30 Jul 2008 21:09:49 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] wait_task_inactive: don't use the dummy version when !SMP && PREEMPT
Message-ID: <20080730170949.GA18682@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wait_task_inactive() must return success only when/if the task leaves
the runqueue, it doesn't work correctly when !SMP && PREEMPT because
in that case we use the "dummy" version which doesn't check .on_rq.

Change the "#if" around the full-blown version from SMP to SMP || PREEMPT.

The patch looks monstrous because it moves the (unchanged) definition
of wait_task_inactive() outside of "#ifdef CONFIG_SMP", but it is quite
trivial.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 include/linux/sched.h |    2
 kernel/sched.c        |  210 +++++++++++++++++++++++++-------------------------
 2 files changed, 107 insertions(+), 105 deletions(-)

--- 27/include/linux/sched.h~3_WTI_PREEMPT	2008-07-30 20:28:31.000000000 +0400
+++ 27/include/linux/sched.h	2008-07-30 20:47:46.000000000 +0400
@@ -1874,7 +1874,7 @@ struct task_struct *fork_idle(int);
 extern void set_task_comm(struct task_struct *tsk, char *from);
 extern char *get_task_comm(char *to, struct task_struct *tsk);
 
-#ifdef CONFIG_SMP
+#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT)
 extern unsigned long wait_task_inactive(struct task_struct *, long match_state);
 #else
 static inline unsigned long wait_task_inactive(struct task_struct *p,
--- 27/kernel/sched.c~3_WTI_PREEMPT	2008-07-30 19:47:56.000000000 +0400
+++ 27/kernel/sched.c	2008-07-30 20:43:41.000000000 +0400
@@ -1864,110 +1864,6 @@ migrate_task(struct task_struct *p, int 
 	return 1;
 }
 
-/*
- * wait_task_inactive - wait for a thread to unschedule.
- *
- * If @match_state is nonzero, it's the @p->state value just checked and
- * not expected to change.  If it changes, i.e. @p might have woken up,
- * then return zero.  When we succeed in waiting for @p to be off its CPU,
- * we return a positive number (its total switch count).  If a second call
- * a short while later returns the same number, the caller can be sure that
- * @p has remained unscheduled the whole time.
- *
- * The caller must ensure that the task *will* unschedule sometime soon,
- * else this function might spin for a *long* time. This function can't
- * be called with interrupts off, or it may introduce deadlock with
- * smp_call_function() if an IPI is sent by the same process we are
- * waiting to become inactive.
- */
-unsigned long wait_task_inactive(struct task_struct *p, long match_state)
-{
-	unsigned long flags;
-	int running, on_rq;
-	unsigned long ncsw;
-	struct rq *rq;
-
-	for (;;) {
-		/*
-		 * We do the initial early heuristics without holding
-		 * any task-queue locks at all. We'll only try to get
-		 * the runqueue lock when things look like they will
-		 * work out!
-		 */
-		rq = task_rq(p);
-
-		/*
-		 * If the task is actively running on another CPU
-		 * still, just relax and busy-wait without holding
-		 * any locks.
-		 *
-		 * NOTE! Since we don't hold any locks, it's not
-		 * even sure that "rq" stays as the right runqueue!
-		 * But we don't care, since "task_running()" will
-		 * return false if the runqueue has changed and p
-		 * is actually now running somewhere else!
-		 */
-		while (task_running(rq, p)) {
-			if (match_state && unlikely(p->state != match_state))
-				return 0;
-			cpu_relax();
-		}
-
-		/*
-		 * Ok, time to look more closely! We need the rq
-		 * lock now, to be *sure*. If we're wrong, we'll
-		 * just go back and repeat.
-		 */
-		rq = task_rq_lock(p, &flags);
-		running = task_running(rq, p);
-		on_rq = p->se.on_rq;
-		ncsw = 0;
-		if (!match_state || p->state == match_state)
-			ncsw = p->nvcsw | LONG_MIN; /* sets MSB */
-		task_rq_unlock(rq, &flags);
-
-		/*
-		 * If it changed from the expected state, bail out now.
-		 */
-		if (unlikely(!ncsw))
-			break;
-
-		/*
-		 * Was it really running after all now that we
-		 * checked with the proper locks actually held?
-		 *
-		 * Oops. Go back and try again..
-		 */
-		if (unlikely(running)) {
-			cpu_relax();
-			continue;
-		}
-
-		/*
-		 * It's not enough that it's not actively running,
-		 * it must be off the runqueue _entirely_, and not
-		 * preempted!
-		 *
-		 * So if it wa still runnable (but just not actively
-		 * running right now), it's preempted, and we should
-		 * yield - it could be a while.
-		 */
-		if (unlikely(on_rq)) {
-			schedule_timeout_uninterruptible(1);
-			continue;
-		}
-
-		/*
-		 * Ahh, all good. It wasn't running, and it wasn't
-		 * runnable, which means that it will never become
-		 * running in the future either. We're all done!
-		 */
-		break;
-	}
-
-	return ncsw;
-}
-
 /***
  * kick_process - kick a running thread to enter/exit the kernel
  * @p: the to-be-kicked thread
@@ -2176,6 +2072,112 @@ static int sched_balance_self(int cpu, i
 
 #endif /* CONFIG_SMP */
 
+#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT)
+/*
+ * wait_task_inactive - wait for a thread to unschedule.
+ *
+ * If @match_state is nonzero, it's the @p->state value just checked and
+ * not expected to change.  If it changes, i.e. @p might have woken up,
+ * then return zero.  When we succeed in waiting for @p to be off its CPU,
+ * we return a positive number (its total switch count).  If a second call
+ * a short while later returns the same number, the caller can be sure that
+ * @p has remained unscheduled the whole time.
+ *
+ * The caller must ensure that the task *will* unschedule sometime soon,
+ * else this function might spin for a *long* time. This function can't
+ * be called with interrupts off, or it may introduce deadlock with
+ * smp_call_function() if an IPI is sent by the same process we are
+ * waiting to become inactive.
+ */
+unsigned long wait_task_inactive(struct task_struct *p, long match_state)
+{
+	unsigned long flags;
+	int running, on_rq;
+	unsigned long ncsw;
+	struct rq *rq;
+
+	for (;;) {
+		/*
+		 * We do the initial early heuristics without holding
+		 * any task-queue locks at all. We'll only try to get
+		 * the runqueue lock when things look like they will
+		 * work out!
+		 */
+		rq = task_rq(p);
+
+		/*
+		 * If the task is actively running on another CPU
+		 * still, just relax and busy-wait without holding
+		 * any locks.
+		 *
+		 * NOTE! Since we don't hold any locks, it's not
+		 * even sure that "rq" stays as the right runqueue!
+		 * But we don't care, since "task_running()" will
+		 * return false if the runqueue has changed and p
+		 * is actually now running somewhere else!
+		 */
+		while (task_running(rq, p)) {
+			if (match_state && unlikely(p->state != match_state))
+				return 0;
+			cpu_relax();
+		}
+
+		/*
+		 * Ok, time to look more closely! We need the rq
+		 * lock now, to be *sure*. If we're wrong, we'll
+		 * just go back and repeat.
+		 */
+		rq = task_rq_lock(p, &flags);
+		running = task_running(rq, p);
+		on_rq = p->se.on_rq;
+		ncsw = 0;
+		if (!match_state || p->state == match_state)
+			ncsw = p->nvcsw | LONG_MIN; /* sets MSB */
+		task_rq_unlock(rq, &flags);
+
+		/*
+		 * If it changed from the expected state, bail out now.
+		 */
+		if (unlikely(!ncsw))
+			break;
+
+		/*
+		 * Was it really running after all now that we
+		 * checked with the proper locks actually held?
+		 *
+		 * Oops. Go back and try again..
+		 */
+		if (unlikely(running)) {
+			cpu_relax();
+			continue;
+		}
+
+		/*
+		 * It's not enough that it's not actively running,
+		 * it must be off the runqueue _entirely_, and not
+		 * preempted!
+		 *
+		 * So if it wa still runnable (but just not actively
+		 * running right now), it's preempted, and we should
+		 * yield - it could be a while.
+		 */
+		if (unlikely(on_rq)) {
+			schedule_timeout_uninterruptible(1);
+			continue;
+		}
+
+		/*
+		 * Ahh, all good. It wasn't running, and it wasn't
+		 * runnable, which means that it will never become
+		 * running in the future either. We're all done!
+		 */
+		break;
+	}
+
+	return ncsw;
+}
+#endif
+
 /***
  * try_to_wake_up - wake up a thread
  * @p: the to-be-woken-up thread

