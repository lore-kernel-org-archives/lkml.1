Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753106AbYLRBaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbYLRBaR (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 20:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750790AbYLRBaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 20:30:00 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55039 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbYLRB37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 20:29:59 -0500
Message-ID: <4949A794.8000502@us.ibm.com>
Date: Wed, 17 Dec 2008 17:29:56 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: "lkml," <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Update futex_q to clarify single waiter symmantics
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Hart <dvhltc@us.ibm.com>

I've tripped over this a couple times.  The futex_q uses a waiters list
to represent a single blocked task and then calles wake_up_all().  This
can lead to confusion in trying to understand the intent of the code,
which is to have a single futex_q for every task waiting on a futex.
This patch corrects the problem, using a single pointer to the waiting
task, and an appropriate call to wake_up, rather than wake_up_all.

Compile and boot tested on an 8way x86_64 machine.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
---

 kernel/futex.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)


diff --git a/kernel/futex.c b/kernel/futex.c
index ba0d3b8..99f8acc 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -92,11 +92,12 @@ struct futex_pi_state {
  * A futex_q has a woken state, just like tasks have TASK_RUNNING.
  * It is considered woken when plist_node_empty(&q->list) || q->lock_ptr == 0.
  * The order of wakup is always to make the first condition true, then
- * wake up q->waiters, then make the second condition true.
+ * wake up q->waiter, then make the second condition true.
  */
 struct futex_q {
 	struct plist_node list;
-	wait_queue_head_t waiters;
+	/* There can only be a single waiter */
+	wait_queue_head_t waiter;
 
 	/* Which hash list lock to use: */
 	spinlock_t *lock_ptr;
@@ -573,7 +574,7 @@ static void wake_futex(struct futex_q *q)
 	 * The lock in wake_up_all() is a crucial memory barrier after the
 	 * plist_del() and also before assigning to q->lock_ptr.
 	 */
-	wake_up_all(&q->waiters);
+	wake_up(&q->waiter);
 	/*
 	 * The waiting task can free the futex_q as soon as this is written,
 	 * without taking any locks.  This must come last.
@@ -930,7 +931,7 @@ static inline struct futex_hash_bucket *queue_lock(struct futex_q *q)
 {
 	struct futex_hash_bucket *hb;
 
-	init_waitqueue_head(&q->waiters);
+	init_waitqueue_head(&q->waiter);
 
 	get_futex_key_refs(&q->key);
 	hb = hash_futex(&q->key);
@@ -1221,7 +1222,7 @@ static int futex_wait(u32 __user *uaddr, int fshared,
 
 	/* add_wait_queue is the barrier after __set_current_state. */
 	__set_current_state(TASK_INTERRUPTIBLE);
-	add_wait_queue(&q.waiters, &wait);
+	add_wait_queue(&q.waiter, &wait);
 	/*
 	 * !plist_node_empty() is safe here without any lock.
 	 * q.lock_ptr != 0 is not safe, because of ordering against wakeup.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
