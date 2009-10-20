Return-Path: <linux-kernel-owner+w=401wt.eu-S1751802AbZJTLau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbZJTLau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 07:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbZJTLat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 07:30:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbZJTLas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 07:30:48 -0400
Date: Tue, 20 Oct 2009 13:30:39 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
cc: linux-rt-users@vger.kernel.org
Subject: [PATCH] futex: Detect mismatched requeue targets
Message-ID: <alpine.LFD.2.00.0910201325480.3609@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Darren

I took your patch from commit 84bc4af59081ee974dd80210e694ab59ebe51ce8
and I tried to git-cherry-pick it for v2.6.31.4-rt14

I had a little merge-commit to resolve. That wasn't too hard, but as the 
code is a bit different between the two versions, I would appreciate it if 
you could review the patch, and make sure that it still makes sense for 
v2.6.31.r-rt14

Thanks!
John

>From 7135729cbbc5bf16c95abdca5366ec5de0a01909 Mon Sep 17 00:00:00 2001
From: Darren Hart <dvhltc@us.ibm.com>
Date: Thu, 13 Aug 2009 17:36:53 -0700
Subject: [PATCH] futex: Detect mismatched requeue targets

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
Signed-off-by: John Kacur <jkacur@redhat.com>
---
 kernel/futex.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 7c4a6ac..5978a84 100644
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
@@ -1089,6 +1092,10 @@ static int futex_proxy_trylock_atomic(u32 __user *pifutex,
 	if (!top_waiter)
 		return 0;
 
+	/* Ensure we requeue to the expected futex. */
+	if (!match_futex(top_waiter->requeue_pi_key, key2))
+		return -EINVAL;
+
 	/*
 	 * Try to take the lock for top_waiter.  Set the FUTEX_WAITERS bit in
 	 * the contended case or if set_waiters is 1.  The pi_state is returned
@@ -1276,6 +1283,12 @@ retry_private:
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
@@ -1742,6 +1755,7 @@ static int futex_wait(u32 __user *uaddr, int fshared,
 	q.pi_state = NULL;
 	q.bitset = bitset;
 	q.rt_waiter = NULL;
+	q.requeue_pi_key = NULL;
 
 	if (abs_time) {
 		to = &timeout;
@@ -1855,6 +1869,7 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
 
 	q.pi_state = NULL;
 	q.rt_waiter = NULL;
+	q.requeue_pi_key = NULL;
 retry:
 	q.key = FUTEX_KEY_INIT;
 	ret = get_futex_key(uaddr, fshared, &q.key, VERIFY_WRITE);
@@ -2167,16 +2182,17 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 	debug_rt_mutex_init_waiter(&rt_waiter);
 	rt_waiter.task = NULL;
 
-	q.pi_state = NULL;
-	q.bitset = bitset;
-	q.rt_waiter = &rt_waiter;
-
 retry:
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
-- 
1.6.0.6

