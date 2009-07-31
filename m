Return-Path: <linux-kernel-owner+w=401wt.eu-S1751857AbZGaXUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbZGaXUO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 19:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbZGaXUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 19:20:14 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39988 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbZGaXUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 19:20:12 -0400
Message-ID: <4A737C2A.9090001@us.ibm.com>
Date: Fri, 31 Jul 2009 16:20:10 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH V2] futex: futex_wait_requeue_pi commentary corrections
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

futex: futex_wait_requeue_pi commentary corrections

From: Darren Hart <dvhltc@us.ibm.com>

The state machine described in the comments wasn't updated with a follow-on
fix.  Address that and cleanup the corresponding commentary in the function.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
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
-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
