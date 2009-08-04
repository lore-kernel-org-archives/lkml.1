Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559AbZHDORG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbZHDORG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755527AbZHDORF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:17:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:55142 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373AbZHDORC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:17:02 -0400
Date: Tue, 4 Aug 2009 14:15:51 GMT
From: tip-bot for Darren Hart <dvhltc@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A737C2A.9090001@us.ibm.com>
References: <4A737C2A.9090001@us.ibm.com>
Subject: [tip:core/futexes] futex: Correct futex_wait_requeue_pi() commentary
Message-ID: <tip-cc6db4e60116c1f76577b6850a35ae7de69a95b6@git.kernel.org>
Git-Commit-ID: cc6db4e60116c1f76577b6850a35ae7de69a95b6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 04 Aug 2009 14:15:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc6db4e60116c1f76577b6850a35ae7de69a95b6
Gitweb:     http://git.kernel.org/tip/cc6db4e60116c1f76577b6850a35ae7de69a95b6
Author:     Darren Hart <dvhltc@us.ibm.com>
AuthorDate: Fri, 31 Jul 2009 16:20:10 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 4 Aug 2009 15:59:14 +0200

futex: Correct futex_wait_requeue_pi() commentary

The state machine described in the comments wasn't updated with
a follow-on fix.  Address that and cleanup the corresponding
commentary in the function.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <4A737C2A.9090001@us.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/futex.c |   23 ++++++++++-------------
 1 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 0672ff8..d077201 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2102,11 +2102,11 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
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
@@ -2114,7 +2114,7 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
  * 7) timeout
  * 8) other lock acquisition failure
  *
- * If 6, we setup a restart_block with futex_lock_pi() as the function.
+ * If 6, return -EWOULDBLOCK (restarting the syscall would do the same).
  *
  * If 4 or 7, we cleanup and return with -ETIMEDOUT.
  *
@@ -2232,14 +2232,11 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
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
