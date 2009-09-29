Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbZI2MWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbZI2MWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 08:22:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbZI2MWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 08:22:13 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:49867 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbZI2MWN (ORCPT
	<rfc822;groupwise-SJayaraman@novell.com;0:0>);
	Tue, 29 Sep 2009 08:22:13 -0400
Message-ID: <4AC1FC41.2060807@suse.de>
Date: Tue, 29 Sep 2009 17:53:29 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: LKML <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] swapfile: avoid NULL pointer dereference in swapon when s_bdev
 is NULL
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While testing Swap over NFS patchset, I noticed an oops that was triggered
during swapon. Investigating further, the NULL pointer deference is due to the
SSD device check/optimization in the swapon code that assumes s_bdev could never
be NULL.

inode->i_sb->s_bdev could be NULL in a few cases. For e.g. one such case is
loopback NFS mount, there could be others as well. Fix this by ensuring s_bdev
is not NULL before we try to deference s_bdev.

Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
---
 mm/swapfile.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4de7f02..a1bc6b9 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1974,12 +1974,14 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto bad_swap;
 	}
 
-	if (blk_queue_nonrot(bdev_get_queue(p->bdev))) {
-		p->flags |= SWP_SOLIDSTATE;
-		p->cluster_next = 1 + (random32() % p->highest_bit);
+	if (p->bdev) {
+		if (blk_queue_nonrot(bdev_get_queue(p->bdev))) {
+			p->flags |= SWP_SOLIDSTATE;
+			p->cluster_next = 1 + (random32() % p->highest_bit);
+		}
+		if (discard_swap(p) == 0)
+			p->flags |= SWP_DISCARDABLE;
 	}
-	if (discard_swap(p) == 0)
-		p->flags |= SWP_DISCARDABLE;
 
 	mutex_lock(&swapon_mutex);
 	spin_lock(&swap_lock);
