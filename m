Return-Path: <linux-kernel-owner+w=401wt.eu-S1758937AbZCCAKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937AbZCCAKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:10:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbZCCAJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:09:53 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:58106 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbZCCAJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:09:50 -0500
Message-ID: <49AC754A.6060006@us.ibm.com>
Date: Mon, 02 Mar 2009 16:09:46 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <srostedt@redhat.com>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: [TIP][RFC 1/7] futex: futex_wait_queue_me()
References: <49AC73A9.4040804@us.ibm.com>
In-Reply-To: <49AC73A9.4040804@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Hart <dvhltc@us.ibm.com>

Refactor futex_wait in preparation for futex_wait_requeue_pi().  In order to
reuse a good chunk of the futex_wait code for the upcoming
futex_wait_requeue_pi function, this patch breaks out the queue-to-wakeup
section for futex_wait into futex_wait_queue_me().

Changelog:
V4: -Nesting cleanups
    -Delayed hrtimer start until after setting TASK_INTERRUPTIBLE
V1: -Initial version

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
---

 kernel/futex.c |  156 +++++++++++++++++++++++++++++++-------------------------
 1 files changed, 86 insertions(+), 70 deletions(-)


diff --git a/kernel/futex.c b/kernel/futex.c
index 206d4c9..16459c2 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1154,23 +1154,86 @@ handle_fault:
 
 static long futex_wait_restart(struct restart_block *restart);
 
+/*
+ * futex_wait_queue_me - queue_me and wait for wakeup, timeout, or signal.
+ * @hb: the futex hash bucket, must be locked by the caller
+ * @q: the futex_q to queue up on
+ * @abst_time: the absolute timeout, NULL for none
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
-	DECLARE_WAITQUEUE(wait, curr);
 	struct futex_hash_bucket *hb;
 	struct futex_q q;
 	u32 uval;
+	struct hrtimer_sleeper timeout, *to = NULL;
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
@@ -1209,78 +1272,26 @@ retry:
 
 		if (!ret)
 			goto retry;
-		return ret;
+		goto out;
 	}
 	ret = -EWOULDBLOCK;
-	if (uval != val)
-		goto out_unlock_put_key;
 
 	/* Only actually queue if *uaddr contained val.  */
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
-			unsigned long slack;
-			slack = current->timer_slack_ns;
-			if (rt_task(current))
-				slack = 0;
-			hrtimer_init_on_stack(&t.timer,
-					      clockrt ? CLOCK_REALTIME :
-					      CLOCK_MONOTONIC,
-					      HRTIMER_MODE_ABS);
-			hrtimer_init_sleeper(&t, current);
-			hrtimer_set_expires_range_ns(&t.timer, *abs_time, slack);
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
+	if (uval != val)
+		goto out_unlock_put_key;
 
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
-	if (!unqueue_me(&q))
-		return 0;
-	if (rem)
-		return -ETIMEDOUT;
+	if (!unqueue_me(&q)) {
+		ret = 0;
+		goto out;
+	}
+	if (to && !to->task) {
+		ret = -ETIMEDOUT;
+		goto out;
+	}
 
 	/*
 	 * We expect signal_pending(current), but another thread may
@@ -1302,7 +1313,8 @@ retry:
 			restart->futex.flags |= FLAGS_SHARED;
 		if (clockrt)
 			restart->futex.flags |= FLAGS_CLOCKRT;
-		return -ERESTART_RESTARTBLOCK;
+		ret = -ERESTART_RESTARTBLOCK;
+		goto out;
 	}
 
 out_unlock_put_key:
@@ -1310,6 +1322,10 @@ out_unlock_put_key:
 	put_futex_key(fshared, &q.key);
 
 out:
+	if (to) {
+		hrtimer_cancel(&to->timer);
+		destroy_hrtimer_on_stack(&to->timer);
+	}
 	return ret;
 }
 

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
