Return-Path: <linux-kernel-owner+w=401wt.eu-S1754331AbZJPRSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbZJPRSd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbZJPRSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:18:30 -0400
Received: from kroah.org ([198.145.64.141]:48525 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156AbZJPRS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:28 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:11:57 2009
Message-Id: <20091016171157.469811828@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Darren Hart <dvhltc@us.ibm.com>, Peter Zijlstra <peterz@infradead.org>,
       Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [21/46] futex: Detect mismatched requeue targets
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=futex-detect-mismatched-requeue-targets.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Darren Hart <dvhltc@us.ibm.com>

commit 84bc4af59081ee974dd80210e694ab59ebe51ce8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/futex.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

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
@@ -1089,6 +1092,10 @@ static int futex_proxy_trylock_atomic(u3
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
@@ -1751,6 +1764,7 @@ static int futex_wait(u32 __user *uaddr,
 	q.pi_state = NULL;
 	q.bitset = bitset;
 	q.rt_waiter = NULL;
+	q.requeue_pi_key = NULL;
 
 	if (abs_time) {
 		to = &timeout;
@@ -1858,6 +1872,7 @@ static int futex_lock_pi(u32 __user *uad
 
 	q.pi_state = NULL;
 	q.rt_waiter = NULL;
+	q.requeue_pi_key = NULL;
 retry:
 	q.key = FUTEX_KEY_INIT;
 	ret = get_futex_key(uaddr, fshared, &q.key, VERIFY_WRITE);
@@ -2168,15 +2183,16 @@ static int futex_wait_requeue_pi(u32 __u
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


