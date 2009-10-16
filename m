Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbZJPRSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbZJPRSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbZJPRSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:18:31 -0400
Received: from kroah.org ([198.145.64.141]:48537 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172AbZJPRS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:29 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:11:58 2009
Message-Id: <20091016171158.014986323@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Darren Hart <dvhltc@us.ibm.com>, Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       John Stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [22/46] futex: Fix wakeup race by setting TASK_INTERRUPTIBLE before queue_me()
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=futex-fix-wakeup-race-by-setting-task_interruptible-before-queue_me.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Darren Hart <dvhltc@us.ibm.com>

commit 0729e196147692d84d4c099fcff056eba2ed61d8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/futex.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1638,17 +1638,8 @@ out:
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
@@ -1658,8 +1649,8 @@ static void futex_wait_queue_me(struct f
 	}
 
 	/*
-	 * !plist_node_empty() is safe here without any lock.
-	 * q.lock_ptr != 0 is not safe, because of ordering against wakeup.
+	 * If we have been removed from the hash list, then another task
+	 * has tried to wake us, and we can skip the call to schedule().
 	 */
 	if (likely(!plist_node_empty(&q->list))) {
 		/*


