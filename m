Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbZHEWCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbZHEWCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 18:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbZHEWCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 18:02:34 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:38831 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbZHEWCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 18:02:33 -0400
Message-ID: <4A7A016C.1090002@us.ibm.com>
Date: Wed, 05 Aug 2009 15:02:20 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
CC: tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       mingo@elte.hu, dino@in.ibm.com, johnstul@us.ibm.com,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 1/2] Update woken requeued futex_q lock_ptr
References: <4A7A009E.2000202@us.ibm.com>
In-Reply-To: <4A7A009E.2000202@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

futex_requeue() can acquire the lock on behalf of a waiter during the requeue
loop in the event of a lock steal or owner died. futex_wait_requeue_pi() cleans
up the pi_state owner, using the lock_ptr to protect against concurrent access
to the pi_state.  The pi_state is found on the requeue target futex hash bucket
so the lock_ptr needs to be updated accordingly.  The problem manifested by
triggering the WARN_ON in lookup_pi_state() about the pid != pi_state->owner
pid. 

The astute reviewer will note that still exists a race between the time
futex_requeue() releases hb2->lock() and the time when futex_wait_requeue_pi()
acquires it.  During this time the pi_state and the futex uaddr are not in sync
with the rt_mutex ownership.  This patch closes the window to the point where
my tests now pass, but we still need to address it.

Note: Please apply to mainline and rt

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Dinakar Guniguntala <dino@in.ibm.com>
CC: John Stultz <johnstul@us.ibm.com>
CC: John Kacur <jkacur@redhat.com>

Index: 2.6.31-rc4-rt1/kernel/futex.c
===================================================================
--- 2.6.31-rc4-rt1.orig/kernel/futex.c	2009-08-05 10:00:56.000000000 -0700
+++ 2.6.31-rc4-rt1/kernel/futex.c	2009-08-05 10:29:56.000000000 -0700
@@ -1059,19 +1059,24 @@ void requeue_futex(struct futex_q *q, st
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
@@ -1137,7 +1142,7 @@ static int futex_proxy_trylock_atomic(u3
 	ret = futex_lock_pi_atomic(pifutex, hb2, key2, ps, top_waiter->task,
 				   set_waiters);
 	if (ret == 1)
-		requeue_pi_wake_futex(top_waiter, key2);
+		requeue_pi_wake_futex(top_waiter, key2, hb2);
 
 	return ret;
 }
@@ -1323,7 +1328,7 @@ retry_private:
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
