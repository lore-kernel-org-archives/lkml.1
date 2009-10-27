Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbZJ0A0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbZJ0A0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 20:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755310AbZJ0A0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 20:26:43 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:48794 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270AbZJ0A0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 20:26:42 -0400
Message-ID: <4AE63E3D.8030903@us.ibm.com>
Date: Mon, 26 Oct 2009 17:26:37 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       "Stultz, John" <johnstul@us.ibm.com>
Subject: [PATCH] RFC: futex: make futex_lock_pi interruptible
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9ea67856951c87a03a5177e1382d836622642521 Mon Sep 17 00:00:00 2001
From: Darren Hart <dvhltc@us.ibm.com>
Date: Mon, 26 Oct 2009 17:15:54 -0700
Subject: [PATCH] RFC: futex: make futex_lock_pi interruptible

NOT FOR INCLUSION

Interruptible locking constructs can currently be implemented in
userspace using condvars and mutexes. However, if FIFO ordered wakeup
and Priority Inheritance are requirements, the sleeping kernel call must
be interruptible. The following patch implements this by allowing
futex_lock_pi() to be interrupted if the new FUTEX_INTERRUPTIBLE opcode
flag is set (rather than perform a syscall restart).

An alternative approach might be to implement a new FUTEX_CANCEL opcode
and return -ECANCELED. This is slightly more complicated to use from
userspace I believe, but not overly so.

A final patch would also need to add support to FUTEX_WAIT. Before I do,
I wanted to get some opinions on this approach.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Dinakar Guniguntala <dino@in.ibm.com>
CC: John Stultz <johnstul@us.ibm.com>
---
 include/linux/futex.h |    3 ++-
 kernel/futex.c        |   20 ++++++++++++++------
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/include/linux/futex.h b/include/linux/futex.h
index 34956c8..f1a4f89 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -28,7 +28,8 @@ union ktime;
 
 #define FUTEX_PRIVATE_FLAG	128
 #define FUTEX_CLOCK_REALTIME	256
-#define FUTEX_CMD_MASK		~(FUTEX_PRIVATE_FLAG | FUTEX_CLOCK_REALTIME)
+#define FUTEX_INTERRUPTIBLE	512
+#define FUTEX_CMD_MASK		~(FUTEX_PRIVATE_FLAG | FUTEX_CLOCK_REALTIME | FUTEX_INTERRUPTIBLE)
 
 #define FUTEX_WAIT_PRIVATE	(FUTEX_WAIT | FUTEX_PRIVATE_FLAG)
 #define FUTEX_WAKE_PRIVATE	(FUTEX_WAKE | FUTEX_PRIVATE_FLAG)
diff --git a/kernel/futex.c b/kernel/futex.c
index 7c4a6ac..d41c55c 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1834,8 +1834,8 @@ static long futex_wait_restart(struct restart_block *restart)
  * if there are waiters then it will block, it does PI, etc. (Due to
  * races the kernel might see a 0 value of the futex too.)
  */
-static int futex_lock_pi(u32 __user *uaddr, int fshared,
-			 int detect, ktime_t *time, int trylock)
+static int futex_lock_pi(u32 __user *uaddr, int fshared, int detect,
+			 ktime_t *time, int trylock, int interruptible)
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
 	struct futex_hash_bucket *hb;
@@ -1937,7 +1937,11 @@ out_put_key:
 out:
 	if (to)
 		destroy_hrtimer_on_stack(&to->timer);
-	return ret != -EINTR ? ret : -ERESTARTNOINTR;
+
+	if (interruptible)
+		return ret;
+	else
+		return ret != -EINTR ? ret : -ERESTARTNOINTR;
 
 uaddr_faulted:
 	queue_unlock(&q, hb);
@@ -2489,7 +2493,7 @@ void exit_robust_list(struct task_struct *curr)
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		u32 __user *uaddr2, u32 val2, u32 val3)
 {
-	int clockrt, ret = -ENOSYS;
+	int clockrt, interruptible, ret = -ENOSYS;
 	int cmd = op & FUTEX_CMD_MASK;
 	int fshared = 0;
 
@@ -2500,6 +2504,8 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 	if (clockrt && cmd != FUTEX_WAIT_BITSET && cmd != FUTEX_WAIT_REQUEUE_PI)
 		return -ENOSYS;
 
+	interruptible = op & FUTEX_INTERRUPTIBLE;
+
 	switch (cmd) {
 	case FUTEX_WAIT:
 		val3 = FUTEX_BITSET_MATCH_ANY;
@@ -2523,7 +2529,8 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		break;
 	case FUTEX_LOCK_PI:
 		if (futex_cmpxchg_enabled)
-			ret = futex_lock_pi(uaddr, fshared, val, timeout, 0);
+			ret = futex_lock_pi(uaddr, fshared, val, timeout, 0,
+					    interruptible);
 		break;
 	case FUTEX_UNLOCK_PI:
 		if (futex_cmpxchg_enabled)
@@ -2531,7 +2538,8 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		break;
 	case FUTEX_TRYLOCK_PI:
 		if (futex_cmpxchg_enabled)
-			ret = futex_lock_pi(uaddr, fshared, 0, timeout, 1);
+			ret = futex_lock_pi(uaddr, fshared, 0, timeout, 1,
+					    interruptible);
 		break;
 	case FUTEX_WAIT_REQUEUE_PI:
 		val3 = FUTEX_BITSET_MATCH_ANY;
-- 
1.6.0.4
-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
