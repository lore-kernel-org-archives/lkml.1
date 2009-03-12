Return-Path: <linux-kernel-owner+w=401wt.eu-S1755150AbZCLK0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbZCLK0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbZCLKZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:25:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:44956 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410AbZCLKZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:25:27 -0400
Date: Thu, 12 Mar 2009 10:24:36 GMT
From: Darren Hart <dvhltc@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
       mingo@redhat.com, rusty@rustcorp.com.au, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090312075545.9856.75152.stgit@Aeon>
References: <20090312075545.9856.75152.stgit@Aeon>
Subject: [tip:core/futexes] futex: additional (get|put)_futex_key() fixes
Message-ID: <tip-de87fcc124a5d4a171aa32707b3265608ebda6e7@git.kernel.org>
Git-Commit-ID: de87fcc124a5d4a171aa32707b3265608ebda6e7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 12 Mar 2009 10:24:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  de87fcc124a5d4a171aa32707b3265608ebda6e7
Gitweb:     http://git.kernel.org/tip/de87fcc124a5d4a171aa32707b3265608ebda6e7
Author:     "Darren Hart" <dvhltc@us.ibm.com>
AuthorDate: Thu, 12 Mar 2009 00:55:46 -0700
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 12 Mar 2009 11:20:56 +0100

futex: additional (get|put)_futex_key() fixes

Impact: fix races

futex_requeue and futex_lock_pi still had some bad
(get|put)_futex_key() usage. This patch adds the missing
put_futex_keys() and corrects a goto in futex_lock_pi() to avoid
a double get.

Build and boot tested on a 4 way Intel x86_64 workstation.
Passes basic pthread_mutex and PI tests out of
ltp/testcases/realtime.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
LKML-Reference: <20090312075545.9856.75152.stgit@Aeon>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
 
