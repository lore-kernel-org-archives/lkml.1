Return-Path: <linux-kernel-owner+w=401wt.eu-S1758759AbZKETUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759AbZKETUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 14:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758688AbZKETUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 14:20:40 -0500
Received: from www.tglx.de ([62.245.132.106]:51897 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758683AbZKETUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 14:20:40 -0500
Date: Thu, 5 Nov 2009 20:20:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Valdis.Kletnieks@vt.edu
cc: Andrew Morton <akpm@linux-foundation.org>, Darren Hart <dvhltc@us.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.32-rc5-mmotm1101 - unkillable processes stuck in futex.
In-Reply-To: <5906.1257443268@turing-police.cc.vt.edu>
Message-ID: <alpine.LFD.2.00.0911052000140.12138@localhost.localdomain>
References: <5906.1257443268@turing-police.cc.vt.edu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Nov 2009, Valdis.Kletnieks@vt.edu wrote:

> (Hmm.. I seem to be on a roll on this -mmotm, breaking all sorts of stuff.. :)
> 
> Am cc'ing Thomas and Darren because their names were attached to commits in
> the origin.patch that touched futex.c

Looks like you are hitting the bug we fixed last week. 

Thanks,

	tglx
---
commit 11df6dddcbc38affb7473aad3d962baf8414a947
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Wed Oct 28 20:26:48 2009 +0100

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
