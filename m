Return-Path: <linux-kernel-owner+w=401wt.eu-S1760987AbZJMTF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760987AbZJMTF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 15:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbZJMTF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 15:05:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:55865 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748AbZJMTF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 15:05:27 -0400
Date: Tue, 13 Oct 2009 19:04:19 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, blaise@willowgarage.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, blaise@willowgarage.com,
       peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] futex: Handle spurious wake up
Message-ID: <tip-d58e6576b0deec6f0b9ff8450fe282da18c50883@git.kernel.org>
Git-Commit-ID: d58e6576b0deec6f0b9ff8450fe282da18c50883
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Oct 2009 19:04:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d58e6576b0deec6f0b9ff8450fe282da18c50883
Gitweb:     http://git.kernel.org/tip/d58e6576b0deec6f0b9ff8450fe282da18c50883
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 13 Oct 2009 20:40:43 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 13 Oct 2009 20:40:43 +0200

futex: Handle spurious wake up

The futex code does not handle spurious wake up in futex_wait and
futex_wait_requeue_pi.

The code assumes that any wake up which was not caused by futex_wake /
requeue or by a timeout was caused by a signal wake up and returns one
of the syscall restart error codes.

In case of a spurious wake up the signal delivery code which deals
with the restart error codes is not invoked and we return that error
code to user space. That causes applications which actually check the
return codes to fail. Blaise reported that on preempt-rt a python test
program run into a exception trap. -rt exposed that due to a built in
spurious wake up accelerator :)

Solve this by checking signal_pending(current) in the wake up path and
handle the spurious wake up case w/o returning to user space.

Reported-by: Blaise Gassend <blaise@willowgarage.com>
Debugged-by: Darren Hart <dvhltc@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@kernel.org
LKML-Reference: <new-submission>
---
 kernel/futex.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 4949d33..5c88839 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1791,6 +1791,7 @@ static int futex_wait(u32 __user *uaddr, int fshared,
 					     current->timer_slack_ns);
 	}
 
+retry:
 	/* Prepare to wait on uaddr. */
 	ret = futex_wait_setup(uaddr, val, fshared, &q, &hb);
 	if (ret)
@@ -1808,9 +1809,14 @@ static int futex_wait(u32 __user *uaddr, int fshared,
 		goto out_put_key;
 
 	/*
-	 * We expect signal_pending(current), but another thread may
-	 * have handled it for us already.
+	 * We expect signal_pending(current), but we might be the
+	 * victim of a spurious wakeup as well.
 	 */
+	if (!signal_pending(current)) {
+		put_futex_key(fshared, &q.key);
+		goto retry;
+	}
+
 	ret = -ERESTARTSYS;
 	if (!abs_time)
 		goto out_put_key;
@@ -2118,9 +2124,11 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
 		 */
 		plist_del(&q->list, &q->list.plist);
 
+		/* Handle spurious wakeups gracefully */
+		ret = -EAGAIN;
 		if (timeout && !timeout->task)
 			ret = -ETIMEDOUT;
-		else
+		else if (signal_pending(current))
 			ret = -ERESTARTNOINTR;
 	}
 	return ret;
@@ -2198,6 +2206,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 	debug_rt_mutex_init_waiter(&rt_waiter);
 	rt_waiter.task = NULL;
 
+retry:
 	key2 = FUTEX_KEY_INIT;
 	ret = get_futex_key(uaddr2, fshared, &key2, VERIFY_WRITE);
 	if (unlikely(ret != 0))
@@ -2292,6 +2301,9 @@ out_put_keys:
 out_key2:
 	put_futex_key(fshared, &key2);
 
+	/* Spurious wakeup ? */
+	if (ret == -EAGAIN)
+		goto retry;
 out:
 	if (to) {
 		hrtimer_cancel(&to->timer);
