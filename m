Return-Path: <linux-kernel-owner+w=401wt.eu-S937117AbZDCUm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937117AbZDCUm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 16:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936958AbZDCUkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 16:40:40 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:43930 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936952AbZDCUki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 16:40:38 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [tip PATCH v7 7/9] RFC: futex: Add requeue_futex() call
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>,
       Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>
Date: Fri, 03 Apr 2009 13:40:31 -0700
Message-ID: <20090403204031.9772.29584.stgit@Aeon>
In-Reply-To: <20090403203832.9772.21410.stgit@Aeon>
References: <20090403203832.9772.21410.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

futex_requeue() is getting a bit long-winded, and will be getting more so after
the requeue_pi patch.  Factor out the actual requeueing into a nicely contained
inline function to reduce function length and improve legibility.

Changelog:
V6: -Initial version

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sripathi Kodi <sripathik@in.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Dinakar Guniguntala <dino@in.ibm.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jakub Jelinek <jakub@redhat.com>
---

 kernel/futex.c |   43 +++++++++++++++++++++++++++++--------------
 1 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 04e5431..4fa5de1 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -940,6 +940,34 @@ out:
 	return ret;
 }
 
+/**
+ * requeue_futex() - Requeue a futex_q from one hb to another
+ * @q:		the futex_q to requeue
+ * @hb1:	the source hash_bucket
+ * @hb2:	the target hash_bucket
+ * @key2:	the new key for the requeued futex_q
+ */
+static inline
+void requeue_futex(struct futex_q *q, struct futex_hash_bucket *hb1,
+		   struct futex_hash_bucket *hb2, union futex_key *key2)
+{
+
+	/*
+	 * If key1 and key2 hash to the same bucket, no need to
+	 * requeue.
+	 */
+	if (likely(&hb1->chain != &hb2->chain)) {
+		plist_del(&q->list, &hb1->chain);
+		plist_add(&q->list, &hb2->chain);
+		q->lock_ptr = &hb2->lock;
+#ifdef CONFIG_DEBUG_PI_LIST
+		q->list.plist.lock = &hb2->lock;
+#endif
+	}
+	get_futex_key_refs(key2);
+	q->key = *key2;
+}
+
 /*
  * Requeue all waiters hashed on one physical page to another
  * physical page.
@@ -999,20 +1027,7 @@ retry_private:
 		if (++ret <= nr_wake) {
 			wake_futex(this);
 		} else {
-			/*
-			 * If key1 and key2 hash to the same bucket, no need to
-			 * requeue.
-			 */
-			if (likely(head1 != &hb2->chain)) {
-				plist_del(&this->list, &hb1->chain);
-				plist_add(&this->list, &hb2->chain);
-				this->lock_ptr = &hb2->lock;
-#ifdef CONFIG_DEBUG_PI_LIST
-				this->list.plist.lock = &hb2->lock;
-#endif
-			}
-			this->key = key2;
-			get_futex_key_refs(&key2);
+			requeue_futex(this, hb1, hb2, &key2);
 			drop_count++;
 
 			if (ret - nr_wake >= nr_requeue)

