Return-Path: <linux-kernel-owner+w=401wt.eu-S1759256AbYESBN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256AbYESBN3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 21:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757322AbYESBLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 21:11:15 -0400
Received: from ns1.suse.de ([195.135.220.2]:35933 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757212AbYESBLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 21:11:04 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 19 May 2008 11:10:57 +1000
Message-Id: <1080519011057.7754@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "Mike Snitzer" <snitzer@gmail.com>
Subject: [PATCH 008 of 10] md: Improve setting of "events_cleared" for write-intent bitmaps.
References: <20080519110910.7473.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When an array is degraded, bits in the write-intent bitmap are not
cleared, so that if the missing device is re-added, it can be synced
by only updated those parts of the device that have changed since
it was removed.

The enable this a 'events_cleared' value is stored. It is the event
counter for the array the last time that any bits were cleared.

Sometime - if a device disappears from an array while it is 'clean' -
the events_cleared value gets updated incorrectly (there are subtle
ordering issues between updateing events in the main metadata and the
bitmap metadata) resulting in the missing device appearing to require
a full resync when it is re-added.

With this patch, we update events_cleared precised when we are about
to clear a bit in the bitmap.  This makes it more "obviously correct".
We also need to update events_cleared when the event_count is going
backwards (as happens on a dirty->clean transition of a non-degraded
array).

Thanks to Mike Snitzer for identifying this problem and testing early
"fixes".


Cc:  "Mike Snitzer" <snitzer@gmail.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
--- .prev/drivers/md/bitmap.c	2008-05-19 11:02:35.000000000 +1000
+++ ./drivers/md/bitmap.c	2008-05-19 11:04:00.000000000 +1000
@@ -454,8 +454,11 @@ void bitmap_update_sb(struct bitmap *bit
 	spin_unlock_irqrestore(&bitmap->lock, flags);
 	sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
 	sb->events = cpu_to_le64(bitmap->mddev->events);
-	if (!bitmap->mddev->degraded)
-		sb->events_cleared = cpu_to_le64(bitmap->mddev->events);
+	if (bitmap->mddev->events < bitmap->events_cleared) {
+		/* rocking back to read-only */
+		bitmap->events_cleared = bitmap->mddev->events;
+		sb->events_cleared = cpu_to_le64(bitmap->events_cleared);
+	}
 	kunmap_atomic(sb, KM_USER0);
 	write_page(bitmap, bitmap->sb_page, 1);
 }
@@ -1085,9 +1088,22 @@ void bitmap_daemon_work(struct bitmap *b
 			} else
 				spin_unlock_irqrestore(&bitmap->lock, flags);
 			lastpage = page;
-/*
-			printk("bitmap clean at page %lu\n", j);
-*/
+
+			/* We are possibly going to clear some bits, so make
+			 * sure that events_cleared is up-to-date.
+			 */
+			if (bitmap->events_cleared < bitmap->mddev->events) {
+				bitmap_super_t *sb;
+				bitmap->events_cleared = bitmap->mddev->events;
+				wait_event(bitmap->mddev->sb_wait,
+				    !test_bit(MD_CHANGE_CLEAN,
+					      &bitmap->mddev->flags));
+				sb = kmap_atomic(bitmap->sb_page, KM_USER0);
+				sb->events_cleared =
+					cpu_to_le64(bitmap->events_cleared);
+				kunmap_atomic(sb, KM_USER0);
+				write_page(bitmap, bitmap->sb_page, 1);
+			}
 			spin_lock_irqsave(&bitmap->lock, flags);
 			clear_page_attr(bitmap, page, BITMAP_PAGE_CLEAN);
 		}
