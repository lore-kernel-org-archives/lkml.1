Return-Path: <linux-kernel-owner+w=401wt.eu-S1753104AbZDUFWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbZDUFWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 01:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbZDUFWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 01:22:30 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:36919 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbZDUFW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 01:22:29 -0400
Message-ID: <49ED580E.1050502@us.ibm.com>
Date: Mon, 20 Apr 2009 22:22:22 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>
Subject: [PATCH][tip:core/futexes][next][rt] remove FUTEX_REQUEUE_PI (non
 CMP)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sripathi Kodi <sripathik@in.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Dinakar Guniguntala <dino@in.ibm.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jakub Jelinek <jakub@redhat.com>
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
index 3421e27..0c406a3 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2560,9 +2560,6 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		ret = futex_wait_requeue_pi(uaddr, fshared, val, timeout, val3,
 					    clockrt, uaddr2);
 		break;
-	case FUTEX_REQUEUE_PI:
-		ret = futex_requeue(uaddr, fshared, uaddr2, val, val2, NULL, 1);
-		break;
 	case FUTEX_CMP_REQUEUE_PI:
 		ret = futex_requeue(uaddr, fshared, uaddr2, val, val2, &val3,
 				    1);
@@ -2601,8 +2598,7 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 	 * number of waiters to wake in 'utime' if cmd == FUTEX_WAKE_OP.
 	 */
 	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE ||
-	    cmd == FUTEX_REQUEUE_PI || cmd == FUTEX_CMP_REQUEUE_PI ||
-	    cmd == FUTEX_WAKE_OP)
+	    cmd == FUTEX_CMP_REQUEUE_PI || cmd == FUTEX_WAKE_OP)
 		val2 = (u32) (unsigned long) utime;
 
 	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
