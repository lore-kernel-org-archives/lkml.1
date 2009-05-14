Return-Path: <linux-kernel-owner+w=401wt.eu-S1762750AbZENXDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762750AbZENXDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 19:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762239AbZENW62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:58:28 -0400
Received: from kroah.org ([198.145.64.141]:45898 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762232AbZENW61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:58:27 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:52:36 2009
Message-Id: <20090514225236.591127690@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:51:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>
Subject: [patch 02/28] md: fix some (more) errors with bitmaps on devices larger than 2TB.
References: <20090514225126.907908936@mini.kroah.org>
Content-Disposition: inline; filename=md-fix-some-errors-with-bitmaps-on-devices-larger-than-2tb.patch
In-Reply-To: <20090514225413.GA705@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit db305e507d554430a69ede901a6308e6ecb72349 upstream.

If a write intent bitmap covers more than 2TB, we sometimes work with
values beyond 32bit, so these need to be sector_t.  This patches
add the required casts to some unsigned longs that are being shifted
up.

This will affect any raid10 larger than 2TB, or any raid1/4/5/6 with
member devices that are larger than 2TB.

Signed-off-by: NeilBrown <neilb@suse.de>
Reported-by: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/bitmap.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1013,9 +1013,11 @@ static int bitmap_init_from_disk(struct 
 		kunmap_atomic(paddr, KM_USER0);
 		if (b) {
 			/* if the disk bit is set, set the memory bit */
-			bitmap_set_memory_bits(bitmap, i << CHUNK_BLOCK_SHIFT(bitmap),
-					       ((i+1) << (CHUNK_BLOCK_SHIFT(bitmap)) >= start)
-				);
+			int needed = ((sector_t)(i+1) << (CHUNK_BLOCK_SHIFT(bitmap))
+				      >= start);
+			bitmap_set_memory_bits(bitmap,
+					       (sector_t)i << CHUNK_BLOCK_SHIFT(bitmap),
+					       needed);
 			bit_cnt++;
 			set_page_attr(bitmap, page, BITMAP_PAGE_CLEAN);
 		}
@@ -1151,8 +1153,9 @@ void bitmap_daemon_work(struct bitmap *b
 			spin_lock_irqsave(&bitmap->lock, flags);
 			clear_page_attr(bitmap, page, BITMAP_PAGE_CLEAN);
 		}
-		bmc = bitmap_get_counter(bitmap, j << CHUNK_BLOCK_SHIFT(bitmap),
-					&blocks, 0);
+		bmc = bitmap_get_counter(bitmap,
+					 (sector_t)j << CHUNK_BLOCK_SHIFT(bitmap),
+					 &blocks, 0);
 		if (bmc) {
 /*
   if (j < 100) printk("bitmap: j=%lu, *bmc = 0x%x\n", j, *bmc);
@@ -1166,7 +1169,8 @@ void bitmap_daemon_work(struct bitmap *b
 			} else if (*bmc == 1) {
 				/* we can clear the bit */
 				*bmc = 0;
-				bitmap_count_page(bitmap, j << CHUNK_BLOCK_SHIFT(bitmap),
+				bitmap_count_page(bitmap,
+						  (sector_t)j << CHUNK_BLOCK_SHIFT(bitmap),
 						  -1);
 
 				/* clear the bit */
@@ -1482,7 +1486,7 @@ void bitmap_dirty_bits(struct bitmap *bi
 	unsigned long chunk;
 
 	for (chunk = s; chunk <= e; chunk++) {
-		sector_t sec = chunk << CHUNK_BLOCK_SHIFT(bitmap);
+		sector_t sec = (sector_t)chunk << CHUNK_BLOCK_SHIFT(bitmap);
 		bitmap_set_memory_bits(bitmap, sec, 1);
 		bitmap_file_set_bit(bitmap, sec);
 	}


