Return-Path: <linux-kernel-owner+w=401wt.eu-S1752491AbZHHPb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbZHHPb0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 11:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbZHHPbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 11:31:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:40021 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbZHHPbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 11:31:24 -0400
Date: Sat, 8 Aug 2009 15:27:49 GMT
From: tip-bot for Darren Hart <dvhltc@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
       mingo@redhat.com, jkacur@redhat.com, johnstul@us.ibm.com,
       peterz@infradead.org, dino@in.ibm.com, rostedt@goodmis.org,
       stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, johnstul@us.ibm.com,
       peterz@infradead.org, dino@in.ibm.com, rostedt@goodmis.org,
       stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A7A016C.1090002@us.ibm.com>
References: <4A7A016C.1090002@us.ibm.com>
Subject: [tip:core/urgent] futex: Update woken requeued futex_q lock_ptr
Message-ID: <tip-00235fe25eba6d3a13f3349b2e3a2d94b699a414@git.kernel.org>
Git-Commit-ID: 00235fe25eba6d3a13f3349b2e3a2d94b699a414
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 08 Aug 2009 15:27:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  00235fe25eba6d3a13f3349b2e3a2d94b699a414
Gitweb:     http://git.kernel.org/tip/00235fe25eba6d3a13f3349b2e3a2d94b699a414
Author:     Darren Hart <dvhltc@us.ibm.com>
AuthorDate: Wed, 5 Aug 2009 15:02:20 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 8 Aug 2009 17:21:49 +0200

futex: Update woken requeued futex_q lock_ptr

futex_requeue() can acquire the lock on behalf of a waiter
during the requeue loop in the event of a lock steal or owner
died. futex_wait_requeue_pi() cleans up the pi_state owner,
using the lock_ptr to protect against concurrent access to the
pi_state.  The pi_state is found on the requeue target futex
hash bucket so the lock_ptr needs to be updated accordingly.

The problem manifested by triggering the WARN_ON in
lookup_pi_state() about the pid != pi_state->owner pid.

The astute reviewer will note that still exists a race between
the time futex_requeue() releases hb2->lock() and the time when
futex_wait_requeue_pi() acquires it.  During this time the
pi_state and the futex uaddr are not in sync with the rt_mutex
ownership.  This patch closes the window to the point where my
tests now pass, but we still need to address it.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Dinakar Guniguntala <dino@in.ibm.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: <stable@kernel.org>
LKML-Reference: <4A7A016C.1090002@us.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/futex.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 0672ff8..57f5a80 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1010,19 +1010,24 @@ void requeue_futex(struct futex_q *q, struct futex_hash_bucket *hb1,
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
+ * with the q->lock_ptr held.
  */
 static inline
-void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key)
+void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key,
+			   struct futex_hash_bucket *hb)
 {
 	drop_futex_key_refs(&q->key);
 	get_futex_key_refs(key);
 	q->key = *key;
+	q->lock_ptr = &hb->lock;
 
 	WARN_ON(plist_node_empty(&q->list));
 	plist_del(&q->list, &q->list.plist);
@@ -1088,7 +1093,7 @@ static int futex_proxy_trylock_atomic(u32 __user *pifutex,
 	ret = futex_lock_pi_atomic(pifutex, hb2, key2, ps, top_waiter->task,
 				   set_waiters);
 	if (ret == 1)
-		requeue_pi_wake_futex(top_waiter, key2);
+		requeue_pi_wake_futex(top_waiter, key2, hb2);
 
 	return ret;
 }
@@ -1273,7 +1278,7 @@ retry_private:
 							this->task, 1);
 			if (ret == 1) {
 				/* We got the lock. */
-				requeue_pi_wake_futex(this, &key2);
+				requeue_pi_wake_futex(this, &key2, hb2);
 				continue;
 			} else if (ret) {
 				/* -EDEADLK */
