Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbZCLH4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbZCLH4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 03:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbZCLHz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 03:55:58 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:48992 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbZCLHz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 03:55:57 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH 3/6] futex: add double_unlock_hb()
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>, Darren Hart <dvhltc@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 12 Mar 2009 00:55:52 -0700
Message-ID: <20090312075552.9856.48021.stgit@Aeon>
In-Reply-To: <20090312075349.9856.83687.stgit@Aeon>
References: <20090312075349.9856.83687.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The futex code uses double_lock_hb() which locks the hb->lock's in pointer
value order.  There is no parallel unlock routine, and the code unlocks them
in name order, ignoring pointer value.  This opens up a window for an ABBA
deadlock.  This patch adds double_unlock_hb() to remove the window as well
as refactor the duplicated code segments.

Build and boot tested on a 4 way Intel x86_64 workstation.  Passes basic
pthread_mutex and PI tests out of ltp/testcases/realtime.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
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

