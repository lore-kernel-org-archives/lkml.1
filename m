Return-Path: <linux-kernel-owner+w=401wt.eu-S932503AbZHGVmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503AbZHGVmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 17:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbZHGVmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 17:42:54 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56890 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbZHGVmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 17:42:53 -0400
Message-ID: <4A7C9FD6.6060408@us.ibm.com>
Date: Fri, 07 Aug 2009 14:42:46 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH] futex: Update futex_q lock_ptr on requeue proxy lock (resend)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Hart <dvhltc@us.ibm.com>

futex_requeue() can acquire the lock on behalf of a waiter early on or during
the requeue loop if it is uncontended or in the event of a lock steal or owner
died. On wakeup, the waiter (in futex_wait_requeue_pi()) cleans up the pi_state
owner using the lock_ptr to protect against concurrent access to the pi_state.
The pi_state is hung off futex_q's on the requeue target futex hash bucket so
the lock_ptr needs to be updated accordingly.

The problem manifested by triggering the WARN_ON in lookup_pi_state() about the
pid != pi_state->owner->pid.  With this patch, the pi_state is properly guarded
against concurrent access via the requeue target hb lock.

The astute reviewer may notice that there is a window of time between when
futex_requeue() unlocks the hb locks and when futex_wait_requeue_pi() will
acquire hb2->lock.  During this time the pi_state and uval are not in sync with
the underlying rtmutex owner (but the uval does indicate there are waiters, so
no atomic changes will occur in userspace).  However, this is not a problem.
Should a contending thread enter lookup_pi_state() and acquire hb2->lock before
the ownership is fixed up, it will find the pi_state hung off a waiter's
(possibly the pending owner's) futex_q and block on the rtmutex.  Once
futex_wait_requeue_pi() fixes up the owner, it will also move the pi_state from
the old owner's task->pi_state_list to its own.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: John Kacur <jkacur@redhat.com>
CC: Dinakar Guniguntala <dino@in.ibm.com>
CC: John Stultz <johnstul@us.ibm.com>
---

 kernel/futex.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)


diff --git a/kernel/futex.c b/kernel/futex.c
index abce822..578c7b7 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1059,15 +1059,19 @@ void requeue_futex(struct futex_q *q, struct futex_hash_bucket *hb1,
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
@@ -1079,6 +1083,11 @@ void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key)
 	WARN_ON(!q->rt_waiter);
 	q->rt_waiter = NULL;
 
+	q->lock_ptr = &hb->lock;
+#ifdef CONFIG_DEBUG_PI_LIST
+	q->list.plist.slock = &hb->lock;
+#endif
+
 	wake_up_state(q->task, TASK_NORMAL);
 }
 
@@ -1137,7 +1146,7 @@ static int futex_proxy_trylock_atomic(u32 __user *pifutex,
 	ret = futex_lock_pi_atomic(pifutex, hb2, key2, ps, top_waiter->task,
 				   set_waiters);
 	if (ret == 1)
-		requeue_pi_wake_futex(top_waiter, key2);
+		requeue_pi_wake_futex(top_waiter, key2, hb2);
 
 	return ret;
 }
@@ -1323,7 +1332,7 @@ retry_private:
 							this->task, 1);
 			if (ret == 1) {
 				/* We got the lock. */
-				requeue_pi_wake_futex(this, &key2);
+				requeue_pi_wake_futex(this, &key2, hb2);
 				continue;
 			} else if (ret) {
 				/* -EDEADLK */
-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
