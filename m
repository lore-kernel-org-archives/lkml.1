Return-Path: <linux-kernel-owner+w=401wt.eu-S1755825AbYKTSDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbYKTSDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 13:03:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbYKTSD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 13:03:26 -0500
Received: from www.tglx.de ([62.245.132.106]:53538 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195AbYKTSDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 13:03:25 -0500
Date: Thu, 20 Nov 2008 10:02:53 -0800 (PST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>
Subject: futex: make clock selectable for FUTEX_WAIT_BITSET
Message-ID: <alpine.LFD.2.00.0811201000580.3197@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUTEX_WAIT_BITSET could be used instead of FUTEX_WAIT by setting the
bit set to FUTEX_BITSET_MATCH_ANY, but FUTEX_WAIT uses CLOCK_REALTIME
while FUTEX_WAIT_BITSET uses CLOCK_MONOTONIC.

Add a flag to select CLOCK_REALTIME for FUTEX_WAIT_BITSET so glibc can
replace the FUTEX_WAIT logic which needs to do gettimeofday() calls
before and after the syscall to convert the absolute timeout to a
relative timeout for FUTEX_WAIT.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/futex.h |    3 ++-
 kernel/futex.c        |   24 +++++++++++++++++-------
 2 files changed, 19 insertions(+), 8 deletions(-)

Index: linux-2.6/include/linux/futex.h
===================================================================
--- linux-2.6.orig/include/linux/futex.h
+++ linux-2.6/include/linux/futex.h
@@ -25,7 +25,8 @@ union ktime;
 #define FUTEX_WAKE_BITSET	10
 
 #define FUTEX_PRIVATE_FLAG	128
-#define FUTEX_CMD_MASK		~FUTEX_PRIVATE_FLAG
+#define FUTEX_CLOCK_REALTIME	256
+#define FUTEX_CMD_MASK		~(FUTEX_PRIVATE_FLAG | FUTEX_CLOCK_REALTIME)
 
 #define FUTEX_WAIT_PRIVATE	(FUTEX_WAIT | FUTEX_PRIVATE_FLAG)
 #define FUTEX_WAKE_PRIVATE	(FUTEX_WAKE | FUTEX_PRIVATE_FLAG)
Index: linux-2.6/kernel/futex.c
===================================================================
--- linux-2.6.orig/kernel/futex.c
+++ linux-2.6/kernel/futex.c
@@ -1196,12 +1196,13 @@ handle_fault:
  * In case we must use restart_block to restart a futex_wait,
  * we encode in the 'flags' shared capability
  */
-#define FLAGS_SHARED  1
+#define FLAGS_SHARED		0x01
+#define FLAGS_CLOCKRT		0x02
 
 static long futex_wait_restart(struct restart_block *restart);
 
 static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
-		      u32 val, ktime_t *abs_time, u32 bitset)
+		      u32 val, ktime_t *abs_time, u32 bitset, int clockrt)
 {
 	struct task_struct *curr = current;
 	DECLARE_WAITQUEUE(wait, curr);
@@ -1300,8 +1301,10 @@ static int futex_wait(u32 __user *uaddr,
 			slack = current->timer_slack_ns;
 			if (rt_task(current))
 				slack = 0;
-			hrtimer_init_on_stack(&t.timer, CLOCK_MONOTONIC,
-						HRTIMER_MODE_ABS);
+			hrtimer_init_on_stack(&t.timer,
+					      clockrt ? CLOCK_REALTIME :
+					      CLOCK_MONOTONIC,
+					      HRTIMER_MODE_ABS);
 			hrtimer_init_sleeper(&t, current);
 			hrtimer_set_expires_range_ns(&t.timer, *abs_time, slack);
 
@@ -1356,6 +1359,8 @@ static int futex_wait(u32 __user *uaddr,
 
 		if (fshared)
 			restart->futex.flags |= FLAGS_SHARED;
+		if (clockrt)
+			restart->futex.flags |= FLAGS_CLOCKRT;
 		return -ERESTART_RESTARTBLOCK;
 	}
 
@@ -1379,7 +1384,8 @@ static long futex_wait_restart(struct re
 	if (restart->futex.flags & FLAGS_SHARED)
 		fshared = &current->mm->mmap_sem;
 	return (long)futex_wait(uaddr, fshared, restart->futex.val, &t,
-				restart->futex.bitset);
+				restart->futex.bitset,
+				restart->futex.flags & FLAGS_CLOCKRT);
 }
 
 
@@ -1993,18 +1999,22 @@ void exit_robust_list(struct task_struct
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		u32 __user *uaddr2, u32 val2, u32 val3)
 {
-	int ret = -ENOSYS;
+	int clockrt, ret = -ENOSYS;
 	int cmd = op & FUTEX_CMD_MASK;
 	struct rw_semaphore *fshared = NULL;
 
 	if (!(op & FUTEX_PRIVATE_FLAG))
 		fshared = &current->mm->mmap_sem;
 
+	clockrt = op & FUTEX_CLOCK_REALTIME;
+	if (clockrt && cmd != FUTEX_WAIT_BITSET)
+		return -ENOSYS;
+
 	switch (cmd) {
 	case FUTEX_WAIT:
 		val3 = FUTEX_BITSET_MATCH_ANY;
 	case FUTEX_WAIT_BITSET:
-		ret = futex_wait(uaddr, fshared, val, timeout, val3);
+		ret = futex_wait(uaddr, fshared, val, timeout, val3, clockrt);
 		break;
 	case FUTEX_WAKE:
 		val3 = FUTEX_BITSET_MATCH_ANY;
