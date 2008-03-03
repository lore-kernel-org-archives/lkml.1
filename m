Return-Path: <linux-kernel-owner+w=401wt.eu-S1760745AbYCCAR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760745AbYCCAR7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 19:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757785AbYCCARF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 19:17:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45651 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757332AbYCCARB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 19:17:01 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 3 Mar 2008 11:17:11 +1100
Message-Id: <1080303001711.23593@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 002 of 9] md: Reduce CPU wastage on idle md array with a write-intent bitmap.
References: <20080303111240.23302.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On an md array with a write-intent bitmap, a thread wakes up every few
seconds and scans the bitmap looking for work to do.  If the
array is idle, there will be no work to do, but a lot of scanning is
done to discover this.

So cache the fact that the bitmap is completely clean, and avoid
scanning the whole bitmap when the cache is known to be clean.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c         |   19 +++++++++++++++++--
 ./include/linux/raid/bitmap.h |    2 ++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
--- .prev/drivers/md/bitmap.c	2008-02-22 15:45:56.000000000 +1100
+++ ./drivers/md/bitmap.c	2008-02-22 15:45:56.000000000 +1100
@@ -1047,6 +1047,11 @@ void bitmap_daemon_work(struct bitmap *b
 	if (time_before(jiffies, bitmap->daemon_lastrun + bitmap->daemon_sleep*HZ))
 		return;
 	bitmap->daemon_lastrun = jiffies;
+	if (bitmap->allclean) {
+		bitmap->mddev->thread->timeout = MAX_SCHEDULE_TIMEOUT;
+		return;
+	}
+	bitmap->allclean = 1;
 
 	for (j = 0; j < bitmap->chunks; j++) {
 		bitmap_counter_t *bmc;
@@ -1068,8 +1073,10 @@ void bitmap_daemon_work(struct bitmap *b
 					clear_page_attr(bitmap, page, BITMAP_PAGE_NEEDWRITE);
 
 				spin_unlock_irqrestore(&bitmap->lock, flags);
-				if (need_write)
+				if (need_write) {
 					write_page(bitmap, page, 0);
+					bitmap->allclean = 0;
+				}
 				continue;
 			}
 
@@ -1098,6 +1105,9 @@ void bitmap_daemon_work(struct bitmap *b
 /*
   if (j < 100) printk("bitmap: j=%lu, *bmc = 0x%x\n", j, *bmc);
 */
+			if (*bmc)
+				bitmap->allclean = 0;
+
 			if (*bmc == 2) {
 				*bmc=1; /* maybe clear the bit next time */
 				set_page_attr(bitmap, page, BITMAP_PAGE_CLEAN);
@@ -1132,6 +1142,8 @@ void bitmap_daemon_work(struct bitmap *b
 		}
 	}
 
+	if (bitmap->allclean == 0)
+		bitmap->mddev->thread->timeout = bitmap->daemon_sleep * HZ;
 }
 
 static bitmap_counter_t *bitmap_get_counter(struct bitmap *bitmap,
@@ -1226,6 +1238,7 @@ int bitmap_startwrite(struct bitmap *bit
 			sectors -= blocks;
 		else sectors = 0;
 	}
+	bitmap->allclean = 0;
 	return 0;
 }
 
@@ -1296,6 +1309,7 @@ int bitmap_start_sync(struct bitmap *bit
 		}
 	}
 	spin_unlock_irq(&bitmap->lock);
+	bitmap->allclean = 0;
 	return rv;
 }
 
@@ -1332,6 +1346,7 @@ void bitmap_end_sync(struct bitmap *bitm
 	}
  unlock:
 	spin_unlock_irqrestore(&bitmap->lock, flags);
+	bitmap->allclean = 0;
 }
 
 void bitmap_close_sync(struct bitmap *bitmap)
@@ -1399,7 +1414,7 @@ static void bitmap_set_memory_bits(struc
 		set_page_attr(bitmap, page, BITMAP_PAGE_CLEAN);
 	}
 	spin_unlock_irq(&bitmap->lock);
-
+	bitmap->allclean = 0;
 }
 
 /* dirty the memory and file bits for bitmap chunks "s" to "e" */

diff .prev/include/linux/raid/bitmap.h ./include/linux/raid/bitmap.h
--- .prev/include/linux/raid/bitmap.h	2008-02-22 15:45:56.000000000 +1100
+++ ./include/linux/raid/bitmap.h	2008-02-22 15:45:56.000000000 +1100
@@ -235,6 +235,8 @@ struct bitmap {
 
 	unsigned long flags;
 
+	int allclean;
+
 	unsigned long max_write_behind; /* write-behind mode */
 	atomic_t behind_writes;
 
