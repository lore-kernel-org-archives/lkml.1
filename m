Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbZIVFaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbZIVFaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 01:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbZIVFam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 01:30:42 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:35368 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841AbZIVFai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 01:30:38 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH 5/5] futex: fix wakeup race by setting TASK_INTERRUPTIBLE
	before queue_me
To: linux-kernel@vger.kernel.org
Cc: Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       John Stultz <johnstul@us.ibm.com>
Date: Mon, 21 Sep 2009 22:30:38 -0700
Message-ID: <20090922053038.8717.97838.stgit@Aeon>
In-Reply-To: <20090922052452.8717.39673.stgit@Aeon>
References: <20090922052452.8717.39673.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PI futexes do not use the same plist_node_empty() test for wakeup. It was
possible for the waiter (in futex_wait_requeue_pi()) to set TASK_INTERRUPTIBLE
after the waker assigned the rtmutex to the waiter. The waiter would then note
the plist was not empty and call schedule(). The task would not be found by any
subsequeuent futex wakeups, resulting in a userspace hang. By moving the
setting of TASK_INTERRUPTIBLE to before the call to queue_me(), the race with
the waker is eliminated. Since we no longer call get_user() from within
queue_me(), there is no need to delay the setting of TASK_INTERRUPTIBLE until
after the call to queue_me().

The FUTEX_LOCK_PI operation is not affected as futex_lock_pi() relies entirely
on the rtmutex code to handle schedule() and wakeup.  The requeue PI code is
affected because the waiter starts as a non-PI waiter and is woken on a PI
futex.

Remove the crusty old comment about holding spinlocks() across get_user() as we
no longer do that. Correct the locking statement with a description of why the
test is performed.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Dinakar Guniguntala <dino@in.ibm.com>
CC: John Stultz <johnstul@us.ibm.com>
---

 kernel/futex.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index f92afbe..463af2e 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1656,17 +1656,8 @@ out:
 static void futex_wait_queue_me(struct futex_hash_bucket *hb, struct futex_q *q,
 				struct hrtimer_sleeper *timeout)
 {
-	queue_me(q, hb);
-
-	/*
-	 * There might have been scheduling since the queue_me(), as we
-	 * cannot hold a spinlock across the get_user() in case it
-	 * faults, and we cannot just set TASK_INTERRUPTIBLE state when
-	 * queueing ourselves into the futex hash. This code thus has to
-	 * rely on the futex_wake() code removing us from hash when it
-	 * wakes us up.
-	 */
 	set_current_state(TASK_INTERRUPTIBLE);
+	queue_me(q, hb);
 
 	/* Arm the timer */
 	if (timeout) {
@@ -1676,8 +1667,8 @@ static void futex_wait_queue_me(struct futex_hash_bucket *hb, struct futex_q *q,
 	}
 
 	/*
-	 * !plist_node_empty() is safe here without any lock.
-	 * q.lock_ptr != 0 is not safe, because of ordering against wakeup.
+	 * If we have been removed from the hash list, then another task
+	 * has tried to wake us, and we can skip the call to schedule().
 	 */
 	if (likely(!plist_node_empty(&q->list))) {
 		/*

