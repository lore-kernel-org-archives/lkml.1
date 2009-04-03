Return-Path: <linux-kernel-owner+w=401wt.eu-S937160AbZDCUn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937160AbZDCUn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 16:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936963AbZDCUku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 16:40:50 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:52752 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936969AbZDCUkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 16:40:49 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [tip PATCH v7 8/9] RFC: futex: add futex_wait_setup()
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
Date: Fri, 03 Apr 2009 13:40:40 -0700
Message-ID: <20090403204039.9772.59564.stgit@Aeon>
In-Reply-To: <20090403203832.9772.21410.stgit@Aeon>
References: <20090403203832.9772.21410.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the code to validate the expected futex value in order to
reuse it with the requeue_pi code.

Changelog:
V7: -Initial version

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

 kernel/futex.c |  116 +++++++++++++++++++++++++++++++++++---------------------
 1 files changed, 72 insertions(+), 44 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 4fa5de1..bf657db 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1398,42 +1398,29 @@ static void futex_wait_queue_me(struct futex_hash_bucket *hb, struct futex_q *q,
 	__set_current_state(TASK_RUNNING);
 }
 
-static int futex_wait(u32 __user *uaddr, int fshared,
-		      u32 val, ktime_t *abs_time, u32 bitset, int clockrt)
+/**
+ * futex_wait_setup() - Prepare to wait on a futex
+ * @uaddr:	the futex userspace address
+ * @val:	the expected value
+ * @fshared:	whether the futex is shared (1) or not (0)
+ * @q:		the associated futex_q
+ * @hb:		storage for hash_bucket pointer to be returned to caller
+ *
+ * Setup the futex_q and locate the hash_bucket.  Get the futex value and
+ * compare it with the expected value.  Handle atomic faults internally.
+ * Return with the hb lock held and a q.key reference on success, and unlocked
+ * with no q.key reference on failure.
+ *
+ * Returns:
+ *  0 - uaddr contains val and hb has been locked
+ * <1 - -EFAULT or -EWOULDBLOCK (uaddr does not contain val) and hb is unlcoked
+ */
+static int futex_wait_setup(u32 __user *uaddr, u32 val, int fshared,
+			   struct futex_q *q, struct futex_hash_bucket **hb)
 {
-	struct hrtimer_sleeper timeout, *to = NULL;
-	DECLARE_WAITQUEUE(wait, current);
-	struct restart_block *restart;
-	struct futex_hash_bucket *hb;
-	struct futex_q q;
 	u32 uval;
 	int ret;
 
-	if (!bitset)
-		return -EINVAL;
-
-	q.pi_state = NULL;
-	q.bitset = bitset;
-
-	if (abs_time) {
-		to = &timeout;
-
-		hrtimer_init_on_stack(&to->timer, clockrt ? CLOCK_REALTIME :
-				      CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
-		hrtimer_init_sleeper(to, current);
-		hrtimer_set_expires_range_ns(&to->timer, *abs_time,
-					     current->timer_slack_ns);
-	}
-
-retry:
-	q.key = FUTEX_KEY_INIT;
-	ret = get_futex_key(uaddr, fshared, &q.key);
-	if (unlikely(ret != 0))
-		goto out;
-
-retry_private:
-	hb = queue_lock(&q);
-
 	/*
 	 * Access the page AFTER the hash-bucket is locked.
 	 * Order is important:
@@ -1450,33 +1437,74 @@ retry_private:
 	 * A consequence is that futex_wait() can return zero and absorb
 	 * a wakeup when *uaddr != val on entry to the syscall.  This is
 	 * rare, but normal.
-	 *
-	 * For shared futexes, we hold the mmap semaphore, so the mapping
-	 * cannot have changed since we looked it up in get_futex_key.
 	 */
+retry:
+	q->key = FUTEX_KEY_INIT;
+	ret = get_futex_key(uaddr, fshared, &q->key);
+	if (unlikely(ret != 0))
+		goto out;
+
+retry_private:
+	*hb = queue_lock(q);
+
 	ret = get_futex_value_locked(&uval, uaddr);
 
-	if (unlikely(ret)) {
-		queue_unlock(&q, hb);
+	if (ret) {
+		queue_unlock(q, *hb);
 
 		ret = get_user(uval, uaddr);
 		if (ret)
-			goto out_put_key;
+			goto out;
 
 		if (!fshared)
 			goto retry_private;
 
-		put_futex_key(fshared, &q.key);
+		put_futex_key(fshared, &q->key);
 		goto retry;
 	}
-	ret = -EWOULDBLOCK;
 
-	/* Only actually queue if *uaddr contained val.  */
-	if (unlikely(uval != val)) {
-		queue_unlock(&q, hb);
-		goto out_put_key;
+	if (uval != val) {
+		queue_unlock(q, *hb);
+		ret = -EWOULDBLOCK;
 	}
 
+out:
+	if (ret)
+		put_futex_key(fshared, &q->key);
+	return ret;
+}
+
+static int futex_wait(u32 __user *uaddr, int fshared,
+		      u32 val, ktime_t *abs_time, u32 bitset, int clockrt)
+{
+	struct hrtimer_sleeper timeout, *to = NULL;
+	DECLARE_WAITQUEUE(wait, current);
+	struct restart_block *restart;
+	struct futex_hash_bucket *hb;
+	struct futex_q q;
+	int ret;
+
+	if (!bitset)
+		return -EINVAL;
+
+	q.pi_state = NULL;
+	q.bitset = bitset;
+
+	if (abs_time) {
+		to = &timeout;
+
+		hrtimer_init_on_stack(&to->timer, clockrt ? CLOCK_REALTIME :
+				      CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+		hrtimer_init_sleeper(to, current);
+		hrtimer_set_expires_range_ns(&to->timer, *abs_time,
+					     current->timer_slack_ns);
+	}
+
+	/* Prepare to wait on uaddr. */
+	ret = futex_wait_setup(uaddr, val, fshared, &q, &hb);
+	if (ret)
+		goto out;
+
 	/* queue_me and wait for wakeup, timeout, or a signal. */
 	futex_wait_queue_me(hb, &q, to, &wait);
 

