Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbZIVFaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbZIVFaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 01:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbZIVFaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 01:30:17 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52665 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690AbZIVFaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 01:30:14 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH 2/5] futex: correct queue_me and unqueue_me commentary
To: linux-kernel@vger.kernel.org
Cc: Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       John Stultz <johnstul@us.ibm.com>
Date: Mon, 21 Sep 2009 22:30:15 -0700
Message-ID: <20090922053015.8717.71713.stgit@Aeon>
In-Reply-To: <20090922052452.8717.39673.stgit@Aeon>
References: <20090922052452.8717.39673.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The queue_me/unqueue_me commentary is oddly placed and out of date.
Clean it up and correct the inaccurate bits.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Dinakar Guniguntala <dino@in.ibm.com>
CC: John Stultz <johnstul@us.ibm.com>
---

 kernel/futex.c |   41 +++++++++++++++++++++++++++++------------
 1 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 6c498b1..cedcd60 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1350,6 +1350,25 @@ static inline struct futex_hash_bucket *queue_lock(struct futex_q *q)
 	return hb;
 }
 
+static inline void
+queue_unlock(struct futex_q *q, struct futex_hash_bucket *hb)
+{
+	spin_unlock(&hb->lock);
+	drop_futex_key_refs(&q->key);
+}
+
+/**
+ * queue_me() - Enqueue the futex_q on the futex_hash_bucket
+ * @q:	The futex_q to enqueue
+ * @hb:	The destination hash bucket
+ *
+ * The hb->lock must be held by the caller, and is released here. A call to
+ * queue_me() is typically paired with exactly one call to unqueue_me().  The
+ * exceptions involve the PI related operations, which may use unqueue_me_pi()
+ * or nothing if the unqueue is done as part of the wake process and the unqueue
+ * state is implicit in the state of woken task (see futex_wait_requeue_pi() for
+ * an example).
+ */
 static inline void queue_me(struct futex_q *q, struct futex_hash_bucket *hb)
 {
 	int prio;
@@ -1373,19 +1392,17 @@ static inline void queue_me(struct futex_q *q, struct futex_hash_bucket *hb)
 	spin_unlock(&hb->lock);
 }
 
-static inline void
-queue_unlock(struct futex_q *q, struct futex_hash_bucket *hb)
-{
-	spin_unlock(&hb->lock);
-	drop_futex_key_refs(&q->key);
-}
-
-/*
- * queue_me and unqueue_me must be called as a pair, each
- * exactly once.  They are called with the hashed spinlock held.
+/**
+ * unqueue_me() - Remove the futex_q from its futex_hash_bucket
+ * @q:	The futex_q to unqueue
+ *
+ * The q->lock_ptr must not be held by the caller. A call to unqueue_me() must
+ * be paired with exactly one earlier call to queue_me().
+ *
+ * Returns:
+ *   1 - if the futex_q was still queued (and we removed unqueued it)
+ *   0 - if the futex_q was already removed by the waking thread
  */
-
-/* Return 1 if we were still queued (ie. 0 means we were woken) */
 static int unqueue_me(struct futex_q *q)
 {
 	spinlock_t *lock_ptr;

