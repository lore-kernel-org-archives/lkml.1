Return-Path: <linux-kernel-owner+w=401wt.eu-S1761089AbYARChi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761089AbYARChi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 21:37:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758581AbYARCgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 21:36:42 -0500
Received: from waste.org ([66.93.16.53]:40552 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758371AbYARCgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 21:36:42 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 02 of 12] random: consolidate wakeup logic
X-Mercurial-Node: f814137b0bfc52f52a902ce9c070cab27c125ba2
Message-Id: <f814137b0bfc52f52a90.1200623624@cinder.waste.org>
In-Reply-To: <patchbomb.1200623622@cinder.waste.org>
Date: Thu, 17 Jan 2008 20:33:44 -0600
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Matt Mackall <mpm@selenic.com>

diff -r 905475c480bd -r f814137b0bfc drivers/char/random.c
--- a/drivers/char/random.c	Thu Jan 17 20:25:23 2008 -0600
+++ b/drivers/char/random.c	Thu Jan 17 20:25:23 2008 -0600
@@ -540,6 +540,10 @@
 				  nbits, r->name);
 	}
 
+	/* should we wake readers? */
+	if (r == &input_pool && r->entropy_count >= random_read_wakeup_thresh)
+		wake_up_interruptible(&random_read_wait);
+
 	spin_unlock_irqrestore(&r->lock, flags);
 }
 
@@ -624,10 +628,6 @@
 		credit_entropy_store(&input_pool,
 				     min_t(int, fls(delta>>1), 11));
 	}
-
-	if (input_pool.entropy_count >= random_read_wakeup_thresh)
-		wake_up_interruptible(&random_read_wait);
-
 out:
 	preempt_enable();
 }
@@ -1082,12 +1082,6 @@
 		if (get_user(ent_count, p))
 			return -EFAULT;
 		credit_entropy_store(&input_pool, ent_count);
-		/*
-		 * Wake up waiting processes if we have enough
-		 * entropy.
-		 */
-		if (input_pool.entropy_count >= random_read_wakeup_thresh)
-			wake_up_interruptible(&random_read_wait);
 		return 0;
 	case RNDADDENTROPY:
 		if (!capable(CAP_SYS_ADMIN))
@@ -1103,12 +1097,6 @@
 		if (retval < 0)
 			return retval;
 		credit_entropy_store(&input_pool, ent_count);
-		/*
-		 * Wake up waiting processes if we have enough
-		 * entropy.
-		 */
-		if (input_pool.entropy_count >= random_read_wakeup_thresh)
-			wake_up_interruptible(&random_read_wait);
 		return 0;
 	case RNDZAPENTCNT:
 	case RNDCLEARPOOL:
