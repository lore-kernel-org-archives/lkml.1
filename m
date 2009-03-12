Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbZCLH40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbZCLH40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 03:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754768AbZCLHzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 03:55:51 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:32924 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbZCLHzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 03:55:50 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH 2/6] Additional (get|put)_futex_key() fixes
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>, Darren Hart <dvhltc@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 12 Mar 2009 00:55:46 -0700
Message-ID: <20090312075545.9856.75152.stgit@Aeon>
In-Reply-To: <20090312075349.9856.83687.stgit@Aeon>
References: <20090312075349.9856.83687.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

futex_requeue and futex_lock_pi still had some bad (get|put)_futex_key() usage.
This patch adds the missing put_futex_keys() and corrects a goto in
futex_lock_pi() to avoid a double get.

Build and boot tested on a 4 way Intel x86_64 workstation.  Passes basic
pthread_mutex and PI tests out of ltp/testcases/realtime.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---

 kernel/futex.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index e6a4d72..4000454 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -802,8 +802,10 @@ retry:
 
 		ret = get_user(dummy, uaddr2);
 		if (ret)
-			return ret;
+			goto out_put_keys;
 
+		put_futex_key(fshared, &key2);
+		put_futex_key(fshared, &key1);
 		goto retryfull;
 	}
 
@@ -878,6 +880,9 @@ retry:
 			if (hb1 != hb2)
 				spin_unlock(&hb2->lock);
 
+			put_futex_key(fshared, &key2);
+			put_futex_key(fshared, &key1);
+
 			ret = get_user(curval, uaddr1);
 
 			if (!ret)
@@ -1453,6 +1458,7 @@ retry_locked:
 			 * exit to complete.
 			 */
 			queue_unlock(&q, hb);
+			put_futex_key(fshared, &q.key);
 			cond_resched();
 			goto retry;
 
@@ -1595,13 +1601,12 @@ uaddr_faulted:
 
 	ret = get_user(uval, uaddr);
 	if (!ret)
-		goto retry;
+		goto retry_unlocked;
 
-	if (to)
-		destroy_hrtimer_on_stack(&to->timer);
-	return ret;
+	goto out_put_key;
 }
 
+
 /*
  * Userspace attempted a TID -> 0 atomic transition, and failed.
  * This is the in-kernel slowpath: we look up the PI state (if any),
@@ -1705,6 +1710,7 @@ pi_faulted:
 	}
 
 	ret = get_user(uval, uaddr);
+	put_futex_key(fshared, &key);
 	if (!ret)
 		goto retry;
 

