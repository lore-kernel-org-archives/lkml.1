Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbZCLK03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbZCLK03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754953AbZCLKZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:25:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:44958 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755134AbZCLKZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:25:28 -0400
Date: Thu, 12 Mar 2009 10:24:44 GMT
From: Darren Hart <dvhltc@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
       mingo@redhat.com, rusty@rustcorp.com.au, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090312075552.9856.48021.stgit@Aeon>
References: <20090312075552.9856.48021.stgit@Aeon>
Subject: [tip:core/futexes] futex: add double_unlock_hb()
Message-ID: <tip-5eb3dc62fc5986e85715041c23dcf3832812be4b@git.kernel.org>
Git-Commit-ID: 5eb3dc62fc5986e85715041c23dcf3832812be4b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 12 Mar 2009 10:24:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5eb3dc62fc5986e85715041c23dcf3832812be4b
Gitweb:     http://git.kernel.org/tip/5eb3dc62fc5986e85715041c23dcf3832812be4b
Author:     "Darren Hart" <dvhltc@us.ibm.com>
AuthorDate: Thu, 12 Mar 2009 00:55:52 -0700
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 12 Mar 2009 11:20:56 +0100

futex: add double_unlock_hb()

Impact: cleanup

The futex code uses double_lock_hb() which locks the hb->lock's
in pointer value order.  There is no parallel unlock routine,
and the code unlocks them in name order, ignoring pointer value.

This patch adds double_unlock_hb() to refactor the duplicated
code segments.

Build and boot tested on a 4 way Intel x86_64 workstation.
Passes basic pthread_mutex and PI tests out of
ltp/testcases/realtime.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
LKML-Reference: <20090312075552.9856.48021.stgit@Aeon>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/futex.c |   29 +++++++++++++++++------------
 1 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 4000454..e149545 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -690,6 +690,19 @@ double_lock_hb(struct futex_hash_bucket *hb1, struct futex_hash_bucket *hb2)
 	}
 }
 
+static inline void
+double_unlock_hb(struct futex_hash_bucket *hb1, struct futex_hash_bucket *hb2)
+{
+	if (hb1 <= hb2) {
+		spin_unlock(&hb2->lock);
+		if (hb1 < hb2)
+			spin_unlock(&hb1->lock);
+	} else { /* hb1 > hb2 */
+		spin_unlock(&hb1->lock);
+		spin_unlock(&hb2->lock);
+	}
+}
+
 /*
  * Wake up waiters matching bitset queued on this futex (uaddr).
  */
@@ -767,9 +780,7 @@ retry:
 	if (unlikely(op_ret < 0)) {
 		u32 dummy;
 
-		spin_unlock(&hb1->lock);
-		if (hb1 != hb2)
-			spin_unlock(&hb2->lock);
+		double_unlock_hb(hb1, hb2);
 
 #ifndef CONFIG_MMU
 		/*
@@ -833,9 +844,7 @@ retry:
 		ret += op_ret;
 	}
 
-	spin_unlock(&hb1->lock);
-	if (hb1 != hb2)
-		spin_unlock(&hb2->lock);
+	double_unlock_hb(hb1, hb2);
 out_put_keys:
 	put_futex_key(fshared, &key2);
 out_put_key1:
@@ -876,9 +885,7 @@ retry:
 		ret = get_futex_value_locked(&curval, uaddr1);
 
 		if (unlikely(ret)) {
-			spin_unlock(&hb1->lock);
-			if (hb1 != hb2)
-				spin_unlock(&hb2->lock);
+			double_unlock_hb(hb1, hb2);
 
 			put_futex_key(fshared, &key2);
 			put_futex_key(fshared, &key1);
@@ -925,9 +932,7 @@ retry:
 	}
 
 out_unlock:
-	spin_unlock(&hb1->lock);
-	if (hb1 != hb2)
-		spin_unlock(&hb2->lock);
+	double_unlock_hb(hb1, hb2);
 
 	/* drop_futex_key_refs() must be called outside the spinlocks. */
 	while (--drop_count >= 0)
