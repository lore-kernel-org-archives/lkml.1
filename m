Return-Path: <linux-kernel-owner+w=401wt.eu-S933295AbZKFWrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295AbZKFWrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932505AbZKFWrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:47:14 -0500
Received: from kroah.org ([198.145.64.141]:56684 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760073AbZKFWW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:27 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:40 2009
Message-Id: <20091106221540.293515838@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Darren Hart <dvhltc@us.ibm.com>, Peter Zijlstra <peterz@infradead.org>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [12/99] futex: Fix spurious wakeup for requeue_pi really
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=futex-fix-spurious-wakeup-for-requeue_pi-really.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

commit 11df6dddcbc38affb7473aad3d962baf8414a947 upstream.

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
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/futex.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2103,7 +2103,7 @@ int handle_early_requeue_pi_wakeup(struc
 		plist_del(&q->list, &q->list.plist);
 
 		/* Handle spurious wakeups gracefully */
-		ret = -EAGAIN;
+		ret = -EWOULDBLOCK;
 		if (timeout && !timeout->task)
 			ret = -ETIMEDOUT;
 		else if (signal_pending(current))
@@ -2184,7 +2184,6 @@ static int futex_wait_requeue_pi(u32 __u
 	debug_rt_mutex_init_waiter(&rt_waiter);
 	rt_waiter.task = NULL;
 
-retry:
 	key2 = FUTEX_KEY_INIT;
 	ret = get_futex_key(uaddr2, fshared, &key2, VERIFY_WRITE);
 	if (unlikely(ret != 0))
@@ -2282,9 +2281,6 @@ out_put_keys:
 out_key2:
 	put_futex_key(fshared, &key2);
 
-	/* Spurious wakeup ? */
-	if (ret == -EAGAIN)
-		goto retry;
 out:
 	if (to) {
 		hrtimer_cancel(&to->timer);


