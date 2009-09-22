Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbZIVIl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbZIVIl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 04:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbZIVIl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 04:41:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:42326 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755556AbZIVIl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 04:41:56 -0400
Date: Tue, 22 Sep 2009 08:41:29 GMT
From: tip-bot for Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
       mingo@redhat.com, eric.dumazet@gmail.com, johnstul@us.ibm.com,
       peterz@infradead.org, dino@in.ibm.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       johnstul@us.ibm.com, peterz@infradead.org, dino@in.ibm.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090922053038.8717.97838.stgit@Aeon>
References: <20090922053038.8717.97838.stgit@Aeon>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] futex: Fix wakeup race by setting TASK_INTERRUPTIBLE before queue_me()
Message-ID: <tip-0729e196147692d84d4c099fcff056eba2ed61d8@git.kernel.org>
Git-Commit-ID: 0729e196147692d84d4c099fcff056eba2ed61d8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 22 Sep 2009 08:41:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0729e196147692d84d4c099fcff056eba2ed61d8
Gitweb:     http://git.kernel.org/tip/0729e196147692d84d4c099fcff056eba2ed61d8
Author:     Darren Hart <dvhltc@us.ibm.com>
AuthorDate: Mon, 21 Sep 2009 22:30:38 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 22 Sep 2009 10:37:44 +0200

futex: Fix wakeup race by setting TASK_INTERRUPTIBLE before queue_me()

PI futexes do not use the same plist_node_empty() test for wakeup.
It was possible for the waiter (in futex_wait_requeue_pi()) to set
TASK_INTERRUPTIBLE after the waker assigned the rtmutex to the
waiter. The waiter would then note the plist was not empty and call
schedule(). The task would not be found by any subsequeuent futex
wakeups, resulting in a userspace hang.

By moving the setting of TASK_INTERRUPTIBLE to before the call to
queue_me(), the race with the waker is eliminated. Since we no
longer call get_user() from within queue_me(), there is no need to
delay the setting of TASK_INTERRUPTIBLE until after the call to
queue_me().

The FUTEX_LOCK_PI operation is not affected as futex_lock_pi()
relies entirely on the rtmutex code to handle schedule() and
wakeup.  The requeue PI code is affected because the waiter starts
as a non-PI waiter and is woken on a PI futex.

Remove the crusty old comment about holding spinlocks() across
get_user() as we no longer do that. Correct the locking statement
with a description of why the test is performed.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dinakar Guniguntala <dino@in.ibm.com>
Cc: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <20090922053038.8717.97838.stgit@Aeon>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
