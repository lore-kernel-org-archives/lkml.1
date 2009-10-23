Return-Path: <linux-kernel-owner+w=401wt.eu-S1751981AbZJWNrC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbZJWNrC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 09:47:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbZJWNrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 09:47:01 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58751 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbZJWNrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 09:47:00 -0400
Date: Fri, 23 Oct 2009 19:17:00 +0530
From: Dinakar Guniguntala <dino@in.ibm.com>
To: tglx@linutronix.de
Cc: Darren Hart <dvhltc@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: [patch -rt] Fix infinite loop with 2.6.31.4-rt14
Message-ID: <20091023134700.GA5578@in.ibm.com>
Reply-To: dino@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

I see an application hang in 2.6.31.4-rt14 when running some java tests.

The kernel seems to be continuously looping in 
       futex_wait_requeue_pi -> futex_wait_setup ->
       ret -EAGAIN -> goto retry -> futex_wait_setup -> on and on

===============================================================================

    java-5544  [001] 79682.800631: __might_sleep <-rt_spin_lock_fastlock
    java-5544  [001] 79682.800631: get_futex_value_locked <-futex_wait_setup
    java-5544  [001] 79682.800632: pagefault_disable <-get_futex_value_locked
    java-5544  [001] 79682.800632: pagefault_enable <-get_futex_value_locked
    java-5544  [001] 79682.800632: queue_unlock <-futex_wait_setup
    java-5544  [001] 79682.800632: rt_spin_unlock <-queue_unlock
    java-5544  [001] 79682.800633: rt_spin_lock_fastunlock <-rt_spin_unlock
    java-5544  [001] 79682.800633: drop_futex_key_refs <-queue_unlock
    java-5544  [001] 79682.800633: put_futex_key <-futex_wait_setup
    java-5544  [001] 79682.800633: drop_futex_key_refs <-put_futex_key
    java-5544  [001] 79682.800633: put_futex_key <-do_futex
    java-5544  [001] 79682.800634: drop_futex_key_refs <-put_futex_key
    java-5544  [001] 79682.800634: get_futex_key <-do_futex
    java-5544  [001] 79682.800634: get_futex_key_refs <-get_futex_key
    java-5544  [001] 79682.800634: futex_wait_setup <-do_futex
    java-5544  [001] 79682.800635: get_futex_key <-futex_wait_setup
    java-5544  [001] 79682.800635: get_futex_key_refs <-get_futex_key
    java-5544  [001] 79682.800635: queue_lock <-futex_wait_setup
    java-5544  [001] 79682.800635: get_futex_key_refs <-queue_lock
    java-5544  [001] 79682.800635: hash_futex <-queue_lock
    java-5544  [001] 79682.800636: rt_spin_lock <-queue_lock
    java-5544  [001] 79682.800636: rt_spin_lock_fastlock <-rt_spin_lock
    java-5544  [001] 79682.800636: __might_sleep <-rt_spin_lock_fastlock
    java-5544  [001] 79682.800636: get_futex_value_locked <-futex_wait_setup
    java-5544  [001] 79682.800637: pagefault_disable <-get_futex_value_locked
    java-5544  [001] 79682.800637: pagefault_enable <-get_futex_value_locked
    java-5544  [001] 79682.800637: queue_unlock <-futex_wait_setup
    java-5544  [001] 79682.800637: rt_spin_unlock <-queue_unlock
    java-5544  [001] 79682.800637: rt_spin_lock_fastunlock <-rt_spin_unlock
    java-5544  [001] 79682.800638: drop_futex_key_refs <-queue_unlock
    java-5544  [001] 79682.800638: put_futex_key <-futex_wait_setup
    java-5544  [001] 79682.800638: drop_futex_key_refs <-put_futex_key
    java-5544  [001] 79682.800638: put_futex_key <-do_futex
    java-5544  [001] 79682.800639: drop_futex_key_refs <-put_futex_key
    java-5544  [001] 79682.800639: get_futex_key <-do_futex
    java-5544  [001] 79682.800639: get_futex_key_refs <-get_futex_key
    java-5544  [001] 79682.800639: futex_wait_setup <-do_futex
    java-5544  [001] 79682.800639: get_futex_key <-futex_wait_setup
    java-5544  [001] 79682.800640: get_futex_key_refs <-get_futex_key
    java-5544  [001] 79682.800640: queue_lock <-futex_wait_setup
    java-5544  [001] 79682.800640: get_futex_key_refs <-queue_lock
    java-5544  [001] 79682.800640: hash_futex <-queue_lock
    java-5544  [001] 79682.800640: rt_spin_lock <-queue_lock
    java-5544  [001] 79682.800641: rt_spin_lock_fastlock <-rt_spin_lock
    java-5544  [001] 79682.800641: __might_sleep <-rt_spin_lock_fastlock
    java-5544  [001] 79682.800641: get_futex_value_locked <-futex_wait_setup
    java-5544  [001] 79682.800641: pagefault_disable <-get_futex_value_locked
    java-5544  [001] 79682.800642: pagefault_enable <-get_futex_value_locked
    java-5544  [001] 79682.800642: queue_unlock <-futex_wait_setup
    java-5544  [001] 79682.800642: rt_spin_unlock <-queue_unlock
    java-5544  [001] 79682.800642: rt_spin_lock_fastunlock <-rt_spin_unlock


===============================================================================

This looks to be caused by the patch below
      -> http://patchwork.kernel.org/patch/53483/

Not sure if this the best way to go here, but the patch below seems to resolve
the problem for me

If this is fine, I'll send a separate patch for mainline. Currently mainline
seems to be missing the earlier patch referenced above as well

Signed-off-by: Dinakar Guniguntala <dino@in.ibm.com>

	-Dinakar

---
 kernel/futex.c |   84 +++++++++++++++++++++------------------------------------
 1 file changed, 32 insertions(+), 52 deletions(-)

Index: linux-2.6.31.4-rt14-lbf-f1/kernel/futex.c
===================================================================
--- linux-2.6.31.4-rt14-lbf-f1.orig/kernel/futex.c
+++ linux-2.6.31.4-rt14-lbf-f1/kernel/futex.c
@@ -2048,54 +2048,6 @@ pi_faulted:
 }
 
 /**
- * handle_early_requeue_pi_wakeup() - Detect early wakeup on the initial futex
- * @hb:		the hash_bucket futex_q was original enqueued on
- * @q:		the futex_q woken while waiting to be requeued
- * @key2:	the futex_key of the requeue target futex
- * @timeout:	the timeout associated with the wait (NULL if none)
- *
- * Detect if the task was woken on the initial futex as opposed to the requeue
- * target futex.  If so, determine if it was a timeout or a signal that caused
- * the wakeup and return the appropriate error code to the caller.  Must be
- * called with the hb lock held.
- *
- * Returns
- *  0 - no early wakeup detected
- * <0 - -ETIMEDOUT or -ERESTARTNOINTR
- */
-static inline
-int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
-				   struct futex_q *q, union futex_key *key2,
-				   struct hrtimer_sleeper *timeout)
-{
-	int ret = 0;
-
-	/*
-	 * With the hb lock held, we avoid races while we process the wakeup.
-	 * We only need to hold hb (and not hb2) to ensure atomicity as the
-	 * wakeup code can't change q.key from uaddr to uaddr2 if we hold hb.
-	 * It can't be requeued from uaddr2 to something else since we don't
-	 * support a PI aware source futex for requeue.
-	 */
-	if (!match_futex(&q->key, key2)) {
-		WARN_ON(q->lock_ptr && (&hb->lock != q->lock_ptr));
-		/*
-		 * We were woken prior to requeue by a timeout or a signal.
-		 * Unqueue the futex_q and determine which it was.
-		 */
-		plist_del(&q->list, &q->list.plist);
-
-		/* Handle spurious wakeups gracefully */
-		ret = -EAGAIN;
-		if (timeout && !timeout->task)
-			ret = -ETIMEDOUT;
-		else if (signal_pending(current))
-			ret = -ERESTARTNOINTR;
-	}
-	return ret;
-}
-
-/**
  * futex_wait_requeue_pi() - Wait on uaddr and take uaddr2
  * @uaddr:	the futex we initialyl wait on (non-pi)
  * @fshared:	whether the futexes are shared (1) or not (0).  They must be
@@ -2186,8 +2138,39 @@ retry:
 	futex_wait_queue_me(hb, &q, to);
 
 	spin_lock(&hb->lock);
-	ret = handle_early_requeue_pi_wakeup(hb, &q, &key2, to);
+	/*
+	 * Detect if the task was woken on the initial futex as opposed to the requeue
+	 * target futex.  If so, determine if it was a timeout or a signal that caused
+	 * the wakeup and return the appropriate error code to the caller.  Must be
+	 * called with the hb lock held.
+	 * With the hb lock held, we avoid races while we process the wakeup.
+	 * We only need to hold hb (and not hb2) to ensure atomicity as the
+	 * wakeup code can't change q.key from uaddr to uaddr2 if we hold hb.
+	 * It can't be requeued from uaddr2 to something else since we don't
+	 * support a PI aware source futex for requeue.
+	 */
+	if (!match_futex(&q.key, &key2)) {
+		WARN_ON(q.lock_ptr && (&hb->lock != q.lock_ptr));
+		/*
+		 * We were woken prior to requeue by a timeout or a signal.
+		 * Unqueue the futex_q and determine which it was.
+		 */
+		plist_del(&q.list, &q.list.plist);
+
+		/* Handle spurious wakeups gracefully */
+		ret = -EAGAIN;
+		if (to && !to->task)
+			ret = -ETIMEDOUT;
+		else if (signal_pending(current))
+			ret = -ERESTARTNOINTR;
+	}
 	spin_unlock(&hb->lock);
+	if (ret == -EAGAIN) {
+		/* Retry on spurious wakeup */
+		put_futex_key(fshared, &q.key);
+		put_futex_key(fshared, &key2);
+		goto retry;
+	}
 	if (ret)
 		goto out_put_keys;
 
@@ -2264,9 +2247,6 @@ out_put_keys:
 out_key2:
 	put_futex_key(fshared, &key2);
 
-	/* Spurious wakeup ? */
-	if (ret == -EAGAIN)
-		goto retry;
 out:
 	if (to) {
 		hrtimer_cancel(&to->timer);
