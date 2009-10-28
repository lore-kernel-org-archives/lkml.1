Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbZJ1Th2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbZJ1Th2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 15:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbZJ1Th1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 15:37:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:34944 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638AbZJ1Th0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 15:37:26 -0400
Date: Wed, 28 Oct 2009 19:36:38 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
       mingo@redhat.com, johnstul@linux.vnet.ibm.com, eric.dumazet@gmail.com,
       peterz@infradead.org, dino@in.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       johnstul@linux.vnet.ibm.com, peterz@infradead.org, dino@in.ibm.com,
       tglx@linutronix.de
In-Reply-To: <4AE23C74.1090502@us.ibm.com>
References: <4AE23C74.1090502@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] futex: Fix spurious wakeup for requeue_pi really
Message-ID: <tip-11df6dddcbc38affb7473aad3d962baf8414a947@git.kernel.org>
Git-Commit-ID: 11df6dddcbc38affb7473aad3d962baf8414a947
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  11df6dddcbc38affb7473aad3d962baf8414a947
Gitweb:     http://git.kernel.org/tip/11df6dddcbc38affb7473aad3d962baf8414a947
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 28 Oct 2009 20:26:48 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 28 Oct 2009 20:34:34 +0100

futex: Fix spurious wakeup for requeue_pi really

The requeue_pi path doesn't use unqueue_me() (and the racy lock_ptr ==
NULL test) nor does it use the wake_list of futex_wake() which where
the reason for commit 41890f2 (futex: Handle spurious wake up)

See debugging discussing on LKML Message-ID: <4AD4080C.20703@us.ibm.com>

The changes in this fix to the wait_requeue_pi path were considered to
be a likely unecessary, but harmless safety net. But it turns out that
due to the fact that for unknown $@#!*( reasons EWOULDBLOCK is defined
as EAGAIN we built an endless loop in the code path which returns
correctly EWOULDBLOCK.

Spurious wakeups in wait_requeue_pi code path are unlikely so we do
the easy solution and return EWOULDBLOCK^WEAGAIN to user space and let
it deal with the spurious wakeup.

Cc: Darren Hart <dvhltc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: John Stultz <johnstul@linux.vnet.ibm.com>
Cc: Dinakar Guniguntala <dino@in.ibm.com>
LKML-Reference: <4AE23C74.1090502@us.ibm.com>
Cc: stable@kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/futex.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 642f3bb..fb65e82 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2127,7 +2127,7 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
 		plist_del(&q->list, &q->list.plist);
 
 		/* Handle spurious wakeups gracefully */
-		ret = -EAGAIN;
+		ret = -EWOULDBLOCK;
 		if (timeout && !timeout->task)
 			ret = -ETIMEDOUT;
 		else if (signal_pending(current))
@@ -2208,7 +2208,6 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 	debug_rt_mutex_init_waiter(&rt_waiter);
 	rt_waiter.task = NULL;
 
-retry:
 	key2 = FUTEX_KEY_INIT;
 	ret = get_futex_key(uaddr2, fshared, &key2, VERIFY_WRITE);
 	if (unlikely(ret != 0))
@@ -2303,9 +2302,6 @@ out_put_keys:
 out_key2:
 	put_futex_key(fshared, &key2);
 
-	/* Spurious wakeup ? */
-	if (ret == -EAGAIN)
-		goto retry;
 out:
 	if (to) {
 		hrtimer_cancel(&to->timer);
