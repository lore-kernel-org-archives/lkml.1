Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbZHNAhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbZHNAhE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 20:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbZHNAhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 20:37:03 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:48066 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbZHNAhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 20:37:01 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH] futex: detect mismatched requeue targets
To: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Cc: Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       John Stultz <johnstul@us.ibm.com>
Date: Thu, 13 Aug 2009 17:36:53 -0700
Message-ID: <20090814003650.14634.63916.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is currently no check to ensure that userspace uses the same futex
requeue target (uaddr2) in futex_requeue() that the waiter used in
futex_wait_requeue_pi().  A mismatch here could very unexpected results as the
waiter assumes it either wakes on uaddr1 or uaddr2.  We could detect this on
wakeup in the waiter, but the cleanup is more intense after the improper
requeue has occured.  This patch stores the waiter's expected requeue target in
a new requeue_pi_key pointer in the futex_q which futex_requeue() checks prior
to attempting to do a proxy lock acquistion or a requeue when requeue_pi=1.  If
they don't match, return -EINVAL from futex_requeue, aborting the requeue of
any remaining waiters.

I've run basic non-requeue-pi futex testing as well as a SpecJBB run (as Java
is fairly heavy futex user).  I saw no perceptible difference.  I did not
create a test case which generates the error path this patch addresses,
although I feel the fix is straighforward.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: John Kacur <jkacur@redhat.com>
CC: Dinakar Guniguntala <dino@in.ibm.com>
CC: John Stultz <johnstul@us.ibm.com>
---

 kernel/futex.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 0672ff8..8b0d8fe 100644
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

