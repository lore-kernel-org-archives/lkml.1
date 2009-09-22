Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbZIVIls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbZIVIls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 04:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755522AbZIVIlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 04:41:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:42320 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755520AbZIVIlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 04:41:46 -0400
Date: Tue, 22 Sep 2009 08:41:14 GMT
From: tip-bot for Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
       mingo@redhat.com, eric.dumazet@gmail.com, johnstul@us.ibm.com,
       peterz@infradead.org, dino@in.ibm.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       johnstul@us.ibm.com, peterz@infradead.org, dino@in.ibm.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090922053029.8717.62798.stgit@Aeon>
References: <20090922053029.8717.62798.stgit@Aeon>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] futex: Correct futex_q woken state commentary
Message-ID: <tip-d8d88fbb186fe3ea37b2a58adb32413c98b59656@git.kernel.org>
Git-Commit-ID: d8d88fbb186fe3ea37b2a58adb32413c98b59656
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 22 Sep 2009 08:41:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8d88fbb186fe3ea37b2a58adb32413c98b59656
Gitweb:     http://git.kernel.org/tip/d8d88fbb186fe3ea37b2a58adb32413c98b59656
Author:     Darren Hart <dvhltc@us.ibm.com>
AuthorDate: Mon, 21 Sep 2009 22:30:30 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 22 Sep 2009 10:37:44 +0200

futex: Correct futex_q woken state commentary

Use kernel-doc format to describe struct futex_q.

Correct the wakeup definition to eliminate the statement about
waking the waiter between the plist_del() and the q->lock_ptr = 0.

Note in the comment that PI futexes have a different definition of
the woken state.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dinakar Guniguntala <dino@in.ibm.com>
Cc: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <20090922053029.8717.62798.stgit@Aeon>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/futex.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 720fa3d..f92afbe 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -89,36 +89,36 @@ struct futex_pi_state {
 	union futex_key key;
 };
 
-/*
- * We use this hashed waitqueue instead of a normal wait_queue_t, so
+/**
+ * struct futex_q - The hashed futex queue entry, one per waiting task
+ * @task:		the task waiting on the futex
+ * @lock_ptr:		the hash bucket lock
+ * @key:		the key the futex is hashed on
+ * @pi_state:		optional priority inheritance state
+ * @rt_waiter:		rt_waiter storage for use with requeue_pi
+ * @requeue_pi_key:	the requeue_pi target futex key
+ * @bitset:		bitset for the optional bitmasked wakeup
+ *
+ * We use this hashed waitqueue, instead of a normal wait_queue_t, so
  * we can wake only the relevant ones (hashed queues may be shared).
  *
  * A futex_q has a woken state, just like tasks have TASK_RUNNING.
  * It is considered woken when plist_node_empty(&q->list) || q->lock_ptr == 0.
  * The order of wakup is always to make the first condition true, then
- * wake up q->waiter, then make the second condition true.
+ * the second.
+ *
+ * PI futexes are typically woken before they are removed from the hash list via
+ * the rt_mutex code. See unqueue_me_pi().
  */
 struct futex_q {
 	struct plist_node list;
-	/* Waiter reference */
-	struct task_struct *task;
 
-	/* Which hash list lock to use: */
+	struct task_struct *task;
 	spinlock_t *lock_ptr;
-
-	/* Key which the futex is hashed on: */
 	union futex_key key;
-
-	/* Optional priority inheritance state: */
 	struct futex_pi_state *pi_state;
-
-	/* rt_waiter storage for requeue_pi: */
 	struct rt_mutex_waiter *rt_waiter;
-
-	/* The expected requeue pi target futex key: */
 	union futex_key *requeue_pi_key;
-
-	/* Bitset for the optional bitmasked wakeup */
 	u32 bitset;
 };
 
