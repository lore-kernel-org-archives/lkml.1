Return-Path: <linux-kernel-owner+w=401wt.eu-S1753124AbZHJJK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbZHJJK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 05:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbZHJJKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 05:10:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:50150 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbZHJJKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 05:10:20 -0400
Date: Mon, 10 Aug 2009 09:09:33 GMT
From: tip-bot for Darren Hart <dvhltc@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
       mingo@redhat.com, johnstul@linux.vnet.ibm.com, eric.dumazet@gmail.com,
       peterz@infradead.org, dino@in.ibm.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       johnstul@linux.vnet.ibm.com, rostedt@goodmis.org, peterz@infradead.org,
       dino@in.ibm.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A7F4EFF.6090903@us.ibm.com>
References: <4A7F4EFF.6090903@us.ibm.com>
Subject: [tip:core/urgent] futex: Update futex_q lock_ptr on requeue proxy lock
Message-ID: <tip-beda2c7ea2c15ed01eef00a997d2b0496c3a502d@git.kernel.org>
Git-Commit-ID: beda2c7ea2c15ed01eef00a997d2b0496c3a502d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 10 Aug 2009 09:09:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  beda2c7ea2c15ed01eef00a997d2b0496c3a502d
Gitweb:     http://git.kernel.org/tip/beda2c7ea2c15ed01eef00a997d2b0496c3a502d
Author:     Darren Hart <dvhltc@us.ibm.com>
AuthorDate: Sun, 9 Aug 2009 15:34:39 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 10 Aug 2009 11:07:03 +0200

futex: Update futex_q lock_ptr on requeue proxy lock

futex_requeue() can acquire the lock on behalf of a waiter
early on or during the requeue loop if it is uncontended or in
the event of a lock steal or owner died. On wakeup, the waiter
(in futex_wait_requeue_pi()) cleans up the pi_state owner using
the lock_ptr to protect against concurrent access to the
pi_state. The pi_state is hung off futex_q's on the requeue
target futex hash bucket so the lock_ptr needs to be updated
accordingly.

The problem manifested by triggering the WARN_ON in
lookup_pi_state() about the pid != pi_state->owner->pid.  With
this patch, the pi_state is properly guarded against concurrent
access via the requeue target hb lock.

The astute reviewer may notice that there is a window of time
between when futex_requeue() unlocks the hb locks and when
futex_wait_requeue_pi() will acquire hb2->lock.  During this
time the pi_state and uval are not in sync with the underlying
rtmutex owner (but the uval does indicate there are waiters, so
no atomic changes will occur in userspace).  However, this is
not a problem. Should a contending thread enter
lookup_pi_state() and acquire hb2->lock before the ownership is
fixed up, it will find the pi_state hung off a waiter's
(possibly the pending owner's) futex_q and block on the
rtmutex.  Once futex_wait_requeue_pi() fixes up the owner, it
will also move the pi_state from the old owner's
task->pi_state_list to its own.

v3: Fix plist lock name for application to mainline (rather
    than -rt) Compile tested against tip/v2.6.31-rc5.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dinakar Guniguntala <dino@in.ibm.com>
Cc: John Stultz <johnstul@linux.vnet.ibm.com>
LKML-Reference: <4A7F4EFF.6090903@us.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/futex.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 0672ff8..8cc3ee1 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1010,15 +1010,19 @@ void requeue_futex(struct futex_q *q, struct futex_hash_bucket *hb1,
  * requeue_pi_wake_futex() - Wake a task that acquired the lock during requeue
  * q:	the futex_q
  * key:	the key of the requeue target futex
+ * hb:  the hash_bucket of the requeue target futex
  *
  * During futex_requeue, with requeue_pi=1, it is possible to acquire the
  * target futex if it is uncontended or via a lock steal.  Set the futex_q key
  * to the requeue target futex so the waiter can detect the wakeup on the right
  * futex, but remove it from the hb and NULL the rt_waiter so it can detect
- * atomic lock acquisition.  Must be called with the q->lock_ptr held.
+ * atomic lock acquisition.  Set the q->lock_ptr to the requeue target hb->lock
+ * to protect access to the pi_state to fixup the owner later.  Must be called
+ * with both q->lock_ptr and hb->lock held.
  */
 static inline
-void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key)
+void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key,
+			   struct futex_hash_bucket *hb)
 {
 	drop_futex_key_refs(&q->key);
 	get_futex_key_refs(key);
@@ -1030,6 +1034,11 @@ void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key)
 	WARN_ON(!q->rt_waiter);
 	q->rt_waiter = NULL;
 
+	q->lock_ptr = &hb->lock;
+#ifdef CONFIG_DEBUG_PI_LIST
+	q->list.plist.lock = &hb->lock;
+#endif
+
 	wake_up_state(q->task, TASK_NORMAL);
 }
 
@@ -1088,7 +1097,7 @@ static int futex_proxy_trylock_atomic(u32 __user *pifutex,
 	ret = futex_lock_pi_atomic(pifutex, hb2, key2, ps, top_waiter->task,
 				   set_waiters);
 	if (ret == 1)
-		requeue_pi_wake_futex(top_waiter, key2);
+		requeue_pi_wake_futex(top_waiter, key2, hb2);
 
 	return ret;
 }
@@ -1273,7 +1282,7 @@ retry_private:
 							this->task, 1);
 			if (ret == 1) {
 				/* We got the lock. */
-				requeue_pi_wake_futex(this, &key2);
+				requeue_pi_wake_futex(this, &key2, hb2);
 				continue;
 			} else if (ret) {
 				/* -EDEADLK */
