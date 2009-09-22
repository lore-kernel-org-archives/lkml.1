Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbZIVFah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbZIVFah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 01:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbZIVFaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 01:30:35 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:47468 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbZIVFaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 01:30:30 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH 4/5] futex: correct futex_q woken state commentary
To: linux-kernel@vger.kernel.org
Cc: Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       John Stultz <johnstul@us.ibm.com>
Date: Mon, 21 Sep 2009 22:30:30 -0700
Message-ID: <20090922053029.8717.62798.stgit@Aeon>
In-Reply-To: <20090922052452.8717.39673.stgit@Aeon>
References: <20090922052452.8717.39673.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kernel-doc format to describe struct futex_q.  Correct the wakeup
definition to eliminate the statement about waking the waiter between
the plist_del() and the q->lock_ptr = 0. Note in the comment that PI
futexes have a different definition of the woken state.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Dinakar Guniguntala <dino@in.ibm.com>
CC: John Stultz <johnstul@us.ibm.com>
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
 

