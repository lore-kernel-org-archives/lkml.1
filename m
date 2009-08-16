Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480AbZHPJBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbZHPJBK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbZHPJBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:01:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:41941 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbZHPJBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:01:07 -0400
Date: Sun, 16 Aug 2009 09:00:37 GMT
From: tip-bot for Darren Hart <dvhltc@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
       mingo@redhat.com, jkacur@redhat.com, eric.dumazet@gmail.com,
       johnstul@us.ibm.com, peterz@infradead.org, dino@in.ibm.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, eric.dumazet@gmail.com, jkacur@redhat.com,
       johnstul@us.ibm.com, peterz@infradead.org, dino@in.ibm.com,
       tglx@linutronix.de
In-Reply-To: <20090814003650.14634.63916.stgit@Aeon>
References: <20090814003650.14634.63916.stgit@Aeon>
Subject: [tip:core/futexes] futex: Detect mismatched requeue targets
Message-ID: <tip-84bc4af59081ee974dd80210e694ab59ebe51ce8@git.kernel.org>
Git-Commit-ID: 84bc4af59081ee974dd80210e694ab59ebe51ce8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 16 Aug 2009 09:00:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  84bc4af59081ee974dd80210e694ab59ebe51ce8
Gitweb:     http://git.kernel.org/tip/84bc4af59081ee974dd80210e694ab59ebe51ce8
Author:     Darren Hart <dvhltc@us.ibm.com>
AuthorDate: Thu, 13 Aug 2009 17:36:53 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 16 Aug 2009 10:59:05 +0200

futex: Detect mismatched requeue targets

There is currently no check to ensure that userspace uses the same
futex requeue target (uaddr2) in futex_requeue() that the waiter used
in futex_wait_requeue_pi().  A mismatch here could very unexpected
results as the waiter assumes it either wakes on uaddr1 or uaddr2. We
could detect this on wakeup in the waiter, but the cleanup is more
intense after the improper requeue has occured.

This patch stores the waiter's expected requeue target in a new
requeue_pi_key pointer in the futex_q which futex_requeue() checks
prior to attempting to do a proxy lock acquistion or a requeue when
requeue_pi=1. If they don't match, return -EINVAL from futex_requeue,
aborting the requeue of any remaining waiters.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Dinakar Guniguntala <dino@in.ibm.com>
Cc: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <20090814003650.14634.63916.stgit@Aeon>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 kernel/futex.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index d077201..f0dea28 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -115,6 +115,9 @@ struct futex_q {
 	/* rt_waiter storage for requeue_pi: */
 	struct rt_mutex_waiter *rt_waiter;
 
+	/* The expected requeue pi target futex key: */
+	union futex_key *requeue_pi_key;
+
 	/* Bitset for the optional bitmasked wakeup */
 	u32 bitset;
 };
@@ -1080,6 +1083,10 @@ static int futex_proxy_trylock_atomic(u32 __user *pifutex,
 	if (!top_waiter)
 		return 0;
 
+	/* Ensure we requeue to the expected futex. */
+	if (!match_futex(top_waiter->requeue_pi_key, key2))
+		return -EINVAL;
+
 	/*
 	 * Try to take the lock for top_waiter.  Set the FUTEX_WAITERS bit in
 	 * the contended case or if set_waiters is 1.  The pi_state is returned
@@ -1260,6 +1267,12 @@ retry_private:
 			continue;
 		}
 
+		/* Ensure we requeue to the expected futex for requeue_pi. */
+		if (requeue_pi && !match_futex(this->requeue_pi_key, &key2)) {
+			ret = -EINVAL;
+			break;
+		}
+
 		/*
 		 * Requeue nr_requeue waiters and possibly one more in the case
 		 * of requeue_pi if we couldn't acquire the lock atomically.
@@ -1735,6 +1748,7 @@ static int futex_wait(u32 __user *uaddr, int fshared,
 	q.pi_state = NULL;
 	q.bitset = bitset;
 	q.rt_waiter = NULL;
+	q.requeue_pi_key = NULL;
 
 	if (abs_time) {
 		to = &timeout;
@@ -1842,6 +1856,7 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
 
 	q.pi_state = NULL;
 	q.rt_waiter = NULL;
+	q.requeue_pi_key = NULL;
 retry:
 	q.key = FUTEX_KEY_INIT;
 	ret = get_futex_key(uaddr, fshared, &q.key, VERIFY_WRITE);
@@ -2153,15 +2168,16 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 	debug_rt_mutex_init_waiter(&rt_waiter);
 	rt_waiter.task = NULL;
 
-	q.pi_state = NULL;
-	q.bitset = bitset;
-	q.rt_waiter = &rt_waiter;
-
 	key2 = FUTEX_KEY_INIT;
 	ret = get_futex_key(uaddr2, fshared, &key2, VERIFY_WRITE);
 	if (unlikely(ret != 0))
 		goto out;
 
+	q.pi_state = NULL;
+	q.bitset = bitset;
+	q.rt_waiter = &rt_waiter;
+	q.requeue_pi_key = &key2;
+
 	/* Prepare to wait on uaddr. */
 	ret = futex_wait_setup(uaddr, val, fshared, &q, &hb);
 	if (ret)
