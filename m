Return-Path: <linux-kernel-owner+w=401wt.eu-S1762245AbZD3JqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762245AbZD3JqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 05:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbZD3JqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 05:46:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:56494 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbZD3JqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 05:46:04 -0400
Date: Thu, 30 Apr 2009 09:45:30 GMT
From: tip-bot for Darren Hart <dvhltc@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <49ED580E.1050502@us.ibm.com>
References: <49ED580E.1050502@us.ibm.com>
Subject: [tip:core/futexes] futex: remove FUTEX_REQUEUE_PI (non CMP)
Message-ID: <tip-ba9c22f2c01cf5c88beed5a6b9e07d42e10bd358@git.kernel.org>
Git-Commit-ID: ba9c22f2c01cf5c88beed5a6b9e07d42e10bd358
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 30 Apr 2009 09:45:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ba9c22f2c01cf5c88beed5a6b9e07d42e10bd358
Gitweb:     http://git.kernel.org/tip/ba9c22f2c01cf5c88beed5a6b9e07d42e10bd358
Author:     Darren Hart <dvhltc@us.ibm.com>
AuthorDate: Mon, 20 Apr 2009 22:22:22 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 30 Apr 2009 11:41:35 +0200

futex: remove FUTEX_REQUEUE_PI (non CMP)

The new requeue PI futex op codes were modeled after the existing
FUTEX_REQUEUE and FUTEX_CMP_REQUEUE calls.  I was unaware at the time
that FUTEX_REQUEUE was only around for compatibility reasons and
shouldn't be used in new code.  Ulrich Drepper elaborates on this in his
Futexes are Tricky paper: http://people.redhat.com/drepper/futex.pdf.
The deprecated call doesn't catch changes to the futex corresponding to
the destination futex which can lead to deadlock.

Therefor, I feel it best to remove FUTEX_REQUEUE_PI and leave only
FUTEX_CMP_REQUEUE_PI as there are not yet any existing users of the API.
This patch does change the OP code value of FUTEX_CMP_REQUEUE_PI to 12
from 13.  Since my test case is the only known user of this API, I felt
this was the right thing to do, rather than leave a hole in the
enumeration.

I chose to continue using the _CMP_ modifier in the OP code to make it
explicit to the user that the test is being done.

Builds, boots, and ran several hundred iterations requeue_pi.c.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
LKML-Reference: <49ED580E.1050502@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 include/linux/futex.h |    4 +---
 kernel/futex.c        |    6 +-----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/include/linux/futex.h b/include/linux/futex.h
index b05519c..34956c8 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -24,8 +24,7 @@ union ktime;
 #define FUTEX_WAIT_BITSET	9
 #define FUTEX_WAKE_BITSET	10
 #define FUTEX_WAIT_REQUEUE_PI	11
-#define FUTEX_REQUEUE_PI	12
-#define FUTEX_CMP_REQUEUE_PI	13
+#define FUTEX_CMP_REQUEUE_PI	12
 
 #define FUTEX_PRIVATE_FLAG	128
 #define FUTEX_CLOCK_REALTIME	256
@@ -43,7 +42,6 @@ union ktime;
 #define FUTEX_WAKE_BITSET_PRIVATE	(FUTEX_WAKE_BITS | FUTEX_PRIVATE_FLAG)
 #define FUTEX_WAIT_REQUEUE_PI_PRIVATE	(FUTEX_WAIT_REQUEUE_PI | \
 					 FUTEX_PRIVATE_FLAG)
-#define FUTEX_REQUEUE_PI_PRIVATE	(FUTEX_REQUEUE_PI | FUTEX_PRIVATE_FLAG)
 #define FUTEX_CMP_REQUEUE_PI_PRIVATE	(FUTEX_CMP_REQUEUE_PI | \
 					 FUTEX_PRIVATE_FLAG)
 
diff --git a/kernel/futex.c b/kernel/futex.c
index 6d2daa4..aec8bf8 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2555,9 +2555,6 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		ret = futex_wait_requeue_pi(uaddr, fshared, val, timeout, val3,
 					    clockrt, uaddr2);
 		break;
-	case FUTEX_REQUEUE_PI:
-		ret = futex_requeue(uaddr, fshared, uaddr2, val, val2, NULL, 1);
-		break;
 	case FUTEX_CMP_REQUEUE_PI:
 		ret = futex_requeue(uaddr, fshared, uaddr2, val, val2, &val3,
 				    1);
@@ -2596,8 +2593,7 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 	 * number of waiters to wake in 'utime' if cmd == FUTEX_WAKE_OP.
 	 */
 	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE ||
-	    cmd == FUTEX_REQUEUE_PI || cmd == FUTEX_CMP_REQUEUE_PI ||
-	    cmd == FUTEX_WAKE_OP)
+	    cmd == FUTEX_CMP_REQUEUE_PI || cmd == FUTEX_WAKE_OP)
 		val2 = (u32) (unsigned long) utime;
 
 	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
