Return-Path: <linux-kernel-owner+w=401wt.eu-S1161468AbXBGW3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161468AbXBGW3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 17:29:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161465AbXBGW3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 17:29:07 -0500
Received: from ns2.suse.de ([195.135.220.15]:56023 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161454AbXBGW3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 17:29:03 -0500
From: Neil Brown <neilb@suse.de>
To: akpm@linux-foundation.org
Date: Thu, 8 Feb 2007 09:28:28 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17866.21132.606116.583062@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: stable@kernel.org
Subject: [PATCH] md: Avoid possible BUG_ON in md bitmap handling.
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[[This patch is against 2.6.20 rather than -mm as the new plugging stuff
  in -mm breaks md/raid1/bitmap so I couldn't test it there...
  It is probably appropriate for -stable though I expect the failure
  case is fairly uncommon (raid1 over multipath).... but what would I
  know about how common things are :-?
]]


md/bitmap tracks how many active write requests are pending on blocks
associated with each bit in the bitmap, so that it knows when it can
clear the bit (when count hits zero).

The counter has 14 bits of space, so if there are ever more than 16383,
we cannot cope.

Currently the code just calles BUG_ON as "all" drivers have request queue
limits much smaller than this.

However is seems that some don't.  Apparently some multipath configurations
can allow more than 16383 concurrent write requests.

So, in this unlikely situation, instead of calling BUG_ON we now wait
for the count to drop down a bit.  This requires a new wait_queue_head,
some waiting code, and a wakeup call.

Tested by limiting the counter to 20 instead of 16383 (writes go a lot slower
in that case...).

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c         |   22 +++++++++++++++++++++-
 ./include/linux/raid/bitmap.h |    1 +
 2 files changed, 22 insertions(+), 1 deletion(-)

diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
--- .prev/drivers/md/bitmap.c	2007-02-07 13:03:56.000000000 +1100
+++ ./drivers/md/bitmap.c	2007-02-07 21:34:47.000000000 +1100
@@ -1160,6 +1160,22 @@ int bitmap_startwrite(struct bitmap *bit
 			return 0;
 		}
 
+		if (unlikely((*bmc & COUNTER_MAX) == COUNTER_MAX)) {
+			DEFINE_WAIT(__wait);
+			/* note that it is safe to do the prepare_to_wait
+			 * after the test as long as we do it before dropping
+			 * the spinlock.
+			 */
+			prepare_to_wait(&bitmap->overflow_wait, &__wait,
+					TASK_UNINTERRUPTIBLE);
+			spin_unlock_irq(&bitmap->lock);
+			bitmap->mddev->queue
+				->unplug_fn(bitmap->mddev->queue);
+			schedule();
+			finish_wait(&bitmap->overflow_wait, &__wait);
+			continue;
+		}
+
 		switch(*bmc) {
 		case 0:
 			bitmap_file_set_bit(bitmap, offset);
@@ -1169,7 +1185,7 @@ int bitmap_startwrite(struct bitmap *bit
 		case 1:
 			*bmc = 2;
 		}
-		BUG_ON((*bmc & COUNTER_MAX) == COUNTER_MAX);
+
 		(*bmc)++;
 
 		spin_unlock_irq(&bitmap->lock);
@@ -1207,6 +1223,9 @@ void bitmap_endwrite(struct bitmap *bitm
 		if (!success && ! (*bmc & NEEDED_MASK))
 			*bmc |= NEEDED_MASK;
 
+		if ((*bmc & COUNTER_MAX) == COUNTER_MAX)
+			wake_up(&bitmap->overflow_wait);
+
 		(*bmc)--;
 		if (*bmc <= 2) {
 			set_page_attr(bitmap,
@@ -1431,6 +1450,7 @@ int bitmap_create(mddev_t *mddev)
 	spin_lock_init(&bitmap->lock);
 	atomic_set(&bitmap->pending_writes, 0);
 	init_waitqueue_head(&bitmap->write_wait);
+	init_waitqueue_head(&bitmap->overflow_wait);
 
 	bitmap->mddev = mddev;
 

diff .prev/include/linux/raid/bitmap.h ./include/linux/raid/bitmap.h
--- .prev/include/linux/raid/bitmap.h	2007-02-07 13:03:56.000000000 +1100
+++ ./include/linux/raid/bitmap.h	2007-02-07 20:57:57.000000000 +1100
@@ -247,6 +247,7 @@ struct bitmap {
 
 	atomic_t pending_writes; /* pending writes to the bitmap file */
 	wait_queue_head_t write_wait;
+	wait_queue_head_t overflow_wait;
 
 };
 
