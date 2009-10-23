Return-Path: <linux-kernel-owner+w=401wt.eu-S1752301AbZJWXaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbZJWXaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 19:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbZJWX37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 19:29:59 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:35339 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbZJWX36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 19:29:58 -0400
Message-ID: <4AE23C74.1090502@us.ibm.com>
Date: Fri, 23 Oct 2009 16:29:56 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: dino@in.ibm.com
CC: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: Re: [patch -rt] Fix infinite loop with 2.6.31.4-rt14 V2
References: <20091023134700.GA5578@in.ibm.com> <4AE1D802.6050906@us.ibm.com> <20091023200858.GA7011@in.ibm.com> <4AE214E8.9020406@us.ibm.com>
In-Reply-To: <4AE214E8.9020406@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darren Hart wrote:
> Dinakar Guniguntala wrote:
>  > Application threads calling futex_wait_requeue_pi run in an infinite 
> loop
>  > in the kernel if the futex value changes during the call. The following
>  > patch fixes the problem.
> 
> The key bit here being that EAGAIN == EWOULDBLOCK - who thought that was 
> a good idea?

And now that I think about it, when I reviewed this original patch I
remember mentioning that this isn't even needed for
futex_wait_requeue_pi() because we don't have the same wake-up race as
futex_wait() suffers from - since we don't use the same lock_ptr == NULL
test (nor do we use the wake_list in the requeue code). I suspect the
only case where -EAGAIN is being used here is when the uval doesn't
match val - no spurious wakeups.

Dino, can you try with the following patch which just reverts the
spurious wakeup handling for the requeue_pi path.


>From c21e762bf384e0a559fdf964e0ba7576550d90ec Mon Sep 17 00:00:00 2001
From: Darren Hart <dvhltc@us.ibm.com>
Date: Fri, 23 Oct 2009 16:18:48 -0700
Subject: [PATCH] futex: revert spurious wakeup fix for requeue_pi

The requeue_pi path doesn't use unqueue_me() (and the racy lock_ptr ==
NULL test) nor does it use the wake_list of futex_wake() which led to
the following fix.

41890f2... futex: Handle spurious wake up

See debugging discussing on LKML Message-ID: <4AD4080C.20703@us.ibm.com>

The changes in this fix to the requeue_pi path were considered to be a
likely unecessary, but harmless safety net. Since they are in fact
causing a problem, just remove them and insert a warning in their place.
We can remove the warning later, or even in this commit if folks would
rather.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Dinakar Guniguntala <dino@in.ibm.com>
CC: John Stultz <johnstul@us.ibm.com>

Witholding CC to stable for further discussion.
---
 kernel/futex.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 7c4a6ac..7e4e8b2 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2085,12 +2085,19 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
 		 */
 		plist_del(&q->list, &q->list.plist);
 
-		/* Handle spurious wakeups gracefully */
-		ret = -EAGAIN;
 		if (timeout && !timeout->task)
 			ret = -ETIMEDOUT;
 		else if (signal_pending(current))
 			ret = -ERESTARTNOINTR;
+		else {
+			/*
+			 * We don't use the racy unqueue_me() path with the
+			 * q.lock_ptr NULL test, nor does requeue use a
+			 * wake_list. All wakeups here should be accounted for.
+			 */
+			printk(KERN_ERR "Spurious wakeup in %s\n",
+			       __FUNCTION__);
+		}
 	}
 	return ret;
 }
@@ -2171,7 +2178,6 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 	q.bitset = bitset;
 	q.rt_waiter = &rt_waiter;
 
-retry:
 	key2 = FUTEX_KEY_INIT;
 	ret = get_futex_key(uaddr2, fshared, &key2, VERIFY_WRITE);
 	if (unlikely(ret != 0))
@@ -2264,9 +2270,6 @@ out_put_keys:
 out_key2:
 	put_futex_key(fshared, &key2);
 
-	/* Spurious wakeup ? */
-	if (ret == -EAGAIN)
-		goto retry;
 out:
 	if (to) {
 		hrtimer_cancel(&to->timer);
-- 
1.6.0.4


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
