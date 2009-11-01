Return-Path: <linux-kernel-owner+w=401wt.eu-S1752878AbZKAPiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbZKAPiy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 10:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbZKAPix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 10:38:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47736 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762AbZKAPix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 10:38:53 -0500
Date: Sun, 1 Nov 2009 16:38:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] futex fix
Message-ID: <20091101153844.GA31062@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
Thomas Gleixner (1):
      futex: Fix spurious wakeup for requeue_pi really


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
