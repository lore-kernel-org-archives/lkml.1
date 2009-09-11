Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbZIKSnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbZIKSnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 14:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755878AbZIKSni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 14:43:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38632 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755876AbZIKSnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 14:43:37 -0400
Date: Fri, 11 Sep 2009 20:43:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] core/futexes for v2.6.32
Message-ID: <20090911184333.GA6018@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-futexes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-futexes-for-linus

 Thanks,

	Ingo

------------------>
Darren Hart (2):
      futex: Correct futex_wait_requeue_pi() commentary
      futex: Detect mismatched requeue targets


 kernel/futex.c |   47 ++++++++++++++++++++++++++++++-----------------
 1 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 0672ff8..f0dea28 100644
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
@@ -2102,11 +2117,11 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
  * We call schedule in futex_wait_queue_me() when we enqueue and return there
  * via the following:
  * 1) wakeup on uaddr2 after an atomic lock acquisition by futex_requeue()
- * 2) wakeup on uaddr2 after a requeue and subsequent unlock
- * 3) signal (before or after requeue)
- * 4) timeout (before or after requeue)
+ * 2) wakeup on uaddr2 after a requeue
+ * 3) signal
+ * 4) timeout
  *
- * If 3, we setup a restart_block with futex_wait_requeue_pi() as the function.
+ * If 3, cleanup and return -ERESTARTNOINTR.
  *
  * If 2, we may then block on trying to take the rt_mutex and return via:
  * 5) successful lock
@@ -2114,7 +2129,7 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
  * 7) timeout
  * 8) other lock acquisition failure
  *
- * If 6, we setup a restart_block with futex_lock_pi() as the function.
+ * If 6, return -EWOULDBLOCK (restarting the syscall would do the same).
  *
  * If 4 or 7, we cleanup and return with -ETIMEDOUT.
  *
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
@@ -2232,14 +2248,11 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 			rt_mutex_unlock(pi_mutex);
 	} else if (ret == -EINTR) {
 		/*
-		 * We've already been requeued, but we have no way to
-		 * restart by calling futex_lock_pi() directly. We
-		 * could restart the syscall, but that will look at
-		 * the user space value and return right away. So we
-		 * drop back with EWOULDBLOCK to tell user space that
-		 * "val" has been changed. That's the same what the
-		 * restart of the syscall would do in
-		 * futex_wait_setup().
+		 * We've already been requeued, but cannot restart by calling
+		 * futex_lock_pi() directly. We could restart this syscall, but
+		 * it would detect that the user space "val" changed and return
+		 * -EWOULDBLOCK.  Save the overhead of the restart and return
+		 * -EWOULDBLOCK directly.
 		 */
 		ret = -EWOULDBLOCK;
 	}
