Return-Path: <linux-kernel-owner+w=401wt.eu-S1761663AbZC3ViN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761663AbZC3ViN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 17:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761589AbZC3Vhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 17:37:47 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:39781 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760812AbZC3Vhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 17:37:46 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [tip PATCH v6 1/8] RFC: futex: futex_wait_queue_me()
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>,
       Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>
Date: Mon, 30 Mar 2009 14:37:39 -0700
Message-ID: <20090330213739.606.85804.stgit@Aeon>
In-Reply-To: <20090330213306.606.9540.stgit@Aeon>
References: <20090330213306.606.9540.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor futex_wait() in preparation for futex_wait_requeue_pi().  In order to
reuse a good chunk of the futex_wait() code for the upcoming
futex_wait_requeue_pi() function, this patch breaks out the queue-to-wakeup
section of futex_wait() into futex_wait_queue_me().

Changelog:
V6: -Incremental build fixes
V4: -Nesting cleanups
    -Delayed hrtimer start until after setting TASK_INTERRUPTIBLE
V1: -Initial version

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sripathi Kodi <sripathik@in.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Dinakar Guniguntala <dino@in.ibm.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jakub Jelinek <jakub@redhat.com>
---

 kernel/futex.c |  138 +++++++++++++++++++++++++++++++-------------------------
 1 files changed, 76 insertions(+), 62 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 6b50a02..b2ed762 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1115,24 +1115,87 @@ handle_fault:
 
 static long futex_wait_restart(struct restart_block *restart);
 
+/**
+ * futex_wait_queue_me() - queue_me and wait for wakeup, timeout, or signal.
+ * @hb:		the futex hash bucket, must be locked by the caller
+ * @q:		the futex_q to queue up on
+ * @timeout:	the prepared hrtimer_sleeper, or null for no timeout.
+ */
+static void futex_wait_queue_me(struct futex_hash_bucket *hb, struct futex_q *q,
+				struct hrtimer_sleeper *timeout)
+{
+	DECLARE_WAITQUEUE(wait, current);
+
+	queue_me(q, hb);
+
+	/*
+	 * There might have been scheduling since the queue_me(), as we
+	 * cannot hold a spinlock across the get_user() in case it
+	 * faults, and we cannot just set TASK_INTERRUPTIBLE state when
+	 * queueing ourselves into the futex hash.  This code thus has to
+	 * rely on the futex_wake() code removing us from hash when it
+	 * wakes us up.
+	 */
+
+	/* add_wait_queue is the barrier after __set_current_state. */
+	__set_current_state(TASK_INTERRUPTIBLE);
+	add_wait_queue(&q->waiter, &wait);
+	/*
+	 * NOTE: we don't remove ourselves from the waitqueue because
+	 * we are the only user of it.
+	 */
+
+	/* Arm the timer */
+	if (timeout) {
+		hrtimer_start_expires(&timeout->timer, HRTIMER_MODE_ABS);
+		if (!hrtimer_active(&timeout->timer))
+			timeout->task = NULL;
+	}
+
+	/*
+	 * !plist_node_empty() is safe here without any lock.
+	 * q.lock_ptr != 0 is not safe, because of ordering against wakeup.
+	 */
+	if (likely(!plist_node_empty(&q->list))) {
+		/*
+		 * If the timer has already expired, current will already be
+		 * flagged for rescheduling. Only call schedule if there
+		 * is no timeout, or if it has yet to expire.
+		 */
+		if (!timeout || likely(timeout->task))
+			schedule();
+	}
+	__set_current_state(TASK_RUNNING);
+}
+
 static int futex_wait(u32 __user *uaddr, int fshared,
 		      u32 val, ktime_t *abs_time, u32 bitset, int clockrt)
 {
-	struct task_struct *curr = current;
+	struct hrtimer_sleeper timeout, *to = NULL;
 	struct restart_block *restart;
-	DECLARE_WAITQUEUE(wait, curr);
 	struct futex_hash_bucket *hb;
 	struct futex_q q;
 	u32 uval;
 	int ret;
-	struct hrtimer_sleeper t;
-	int rem = 0;
 
 	if (!bitset)
 		return -EINVAL;
 
 	q.pi_state = NULL;
 	q.bitset = bitset;
+
+	if (abs_time) {
+		unsigned long slack;
+		to = &timeout;
+		slack = current->timer_slack_ns;
+		if (rt_task(current))
+			slack = 0;
+		hrtimer_init_on_stack(&to->timer, clockrt ? CLOCK_REALTIME :
+				      CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+		hrtimer_init_sleeper(to, current);
+		hrtimer_set_expires_range_ns(&to->timer, *abs_time, slack);
+	}
+
 retry:
 	q.key = FUTEX_KEY_INIT;
 	ret = get_futex_key(uaddr, fshared, &q.key);
@@ -1178,75 +1241,22 @@ retry_private:
 		goto retry;
 	}
 	ret = -EWOULDBLOCK;
+
+	/* Only actually queue if *uaddr contained val.  */
 	if (unlikely(uval != val)) {
 		queue_unlock(&q, hb);
 		goto out_put_key;
 	}
 
-	/* Only actually queue if *uaddr contained val.  */
-	queue_me(&q, hb);
-
-	/*
-	 * There might have been scheduling since the queue_me(), as we
-	 * cannot hold a spinlock across the get_user() in case it
-	 * faults, and we cannot just set TASK_INTERRUPTIBLE state when
-	 * queueing ourselves into the futex hash.  This code thus has to
-	 * rely on the futex_wake() code removing us from hash when it
-	 * wakes us up.
-	 */
-
-	/* add_wait_queue is the barrier after __set_current_state. */
-	__set_current_state(TASK_INTERRUPTIBLE);
-	add_wait_queue(&q.waiter, &wait);
-	/*
-	 * !plist_node_empty() is safe here without any lock.
-	 * q.lock_ptr != 0 is not safe, because of ordering against wakeup.
-	 */
-	if (likely(!plist_node_empty(&q.list))) {
-		if (!abs_time)
-			schedule();
-		else {
-			hrtimer_init_on_stack(&t.timer,
-					      clockrt ? CLOCK_REALTIME :
-					      CLOCK_MONOTONIC,
-					      HRTIMER_MODE_ABS);
-			hrtimer_init_sleeper(&t, current);
-			hrtimer_set_expires_range_ns(&t.timer, *abs_time,
-						     current->timer_slack_ns);
-
-			hrtimer_start_expires(&t.timer, HRTIMER_MODE_ABS);
-			if (!hrtimer_active(&t.timer))
-				t.task = NULL;
-
-			/*
-			 * the timer could have already expired, in which
-			 * case current would be flagged for rescheduling.
-			 * Don't bother calling schedule.
-			 */
-			if (likely(t.task))
-				schedule();
-
-			hrtimer_cancel(&t.timer);
-
-			/* Flag if a timeout occured */
-			rem = (t.task == NULL);
-
-			destroy_hrtimer_on_stack(&t.timer);
-		}
-	}
-	__set_current_state(TASK_RUNNING);
-
-	/*
-	 * NOTE: we don't remove ourselves from the waitqueue because
-	 * we are the only user of it.
-	 */
+	/* queue_me and wait for wakeup, timeout, or a signal. */
+	futex_wait_queue_me(hb, &q, to);
 
 	/* If we were woken (and unqueued), we succeeded, whatever. */
 	ret = 0;
 	if (!unqueue_me(&q))
 		goto out_put_key;
 	ret = -ETIMEDOUT;
-	if (rem)
+	if (to && !to->task)
 		goto out_put_key;
 
 	/*
@@ -1275,6 +1285,10 @@ retry_private:
 out_put_key:
 	put_futex_key(fshared, &q.key);
 out:
+	if (to) {
+		hrtimer_cancel(&to->timer);
+		destroy_hrtimer_on_stack(&to->timer);
+	}
 	return ret;
 }
 

