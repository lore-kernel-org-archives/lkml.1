Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbZIVIlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbZIVIlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 04:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbZIVIlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 04:41:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:42290 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405AbZIVIlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 04:41:21 -0400
Date: Tue, 22 Sep 2009 08:40:46 GMT
From: tip-bot for Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
       mingo@redhat.com, eric.dumazet@gmail.com, johnstul@us.ibm.com,
       peterz@infradead.org, dino@in.ibm.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       johnstul@us.ibm.com, peterz@infradead.org, dino@in.ibm.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090922053015.8717.71713.stgit@Aeon>
References: <20090922053015.8717.71713.stgit@Aeon>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] futex: Correct queue_me and unqueue_me commentary
Message-ID: <tip-d40d65c8dbdd39f0b64e043f6bd08f8a38f55194@git.kernel.org>
Git-Commit-ID: d40d65c8dbdd39f0b64e043f6bd08f8a38f55194
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 22 Sep 2009 08:40:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d40d65c8dbdd39f0b64e043f6bd08f8a38f55194
Gitweb:     http://git.kernel.org/tip/d40d65c8dbdd39f0b64e043f6bd08f8a38f55194
Author:     Darren Hart <dvhltc@us.ibm.com>
AuthorDate: Mon, 21 Sep 2009 22:30:15 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 22 Sep 2009 10:37:43 +0200

futex: Correct queue_me and unqueue_me commentary

The queue_me/unqueue_me commentary is oddly placed and out of date.
Clean it up and correct the inaccurate bits.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dinakar Guniguntala <dino@in.ibm.com>
Cc: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <20090922053015.8717.71713.stgit@Aeon>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
