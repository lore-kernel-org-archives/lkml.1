Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab0BKLGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 06:06:09 -0500
Received: from mail.2ka.mipt.ru ([194.85.80.4]:33464 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697Ab0BKLGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 06:06:07 -0500
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Feb 2010 06:06:07 EST
Content-transfer-encoding: 7BIT
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, linux-ext4@vger.kernel.org,
       Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/4] ext4: convert extent zeroout to generic function
Date: Thu, 11 Feb 2010 13:59:56 +0300
Message-id: <1265885996-21982-1-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.6.6
In-reply-to: <1265885625-21608-1-git-send-email-dmonakhov@openvz.org>
References: <1265885625-21608-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |   70 +++-------------------------------------------------
 1 files changed, 4 insertions(+), 66 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 765a482..ff4473a 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2432,76 +2432,14 @@ void ext4_ext_release(struct super_block *sb)
 #endif
 }
 
-static void bi_complete(struct bio *bio, int error)
-{
-	complete((struct completion *)bio->bi_private);
-}
-
 /* FIXME!! we need to try to merge to left or right after zero-out  */
 static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
 {
-	int ret = -EIO;
-	struct bio *bio;
-	int blkbits, blocksize;
-	sector_t ee_pblock;
-	struct completion event;
-	unsigned int ee_len, len, done, offset;
-
-
-	blkbits   = inode->i_blkbits;
-	blocksize = inode->i_sb->s_blocksize;
-	ee_len    = ext4_ext_get_actual_len(ex);
-	ee_pblock = ext_pblock(ex);
+	sector_t nr_sects = ((sector_t)ext4_ext_get_actual_len(ex)) <<
+		inode->i_blkbits;
 
-	/* convert ee_pblock to 512 byte sectors */
-	ee_pblock = ee_pblock << (blkbits - 9);
-
-	while (ee_len > 0) {
-
-		if (ee_len > BIO_MAX_PAGES)
-			len = BIO_MAX_PAGES;
-		else
-			len = ee_len;
-
-		bio = bio_alloc(GFP_NOIO, len);
-		bio->bi_sector = ee_pblock;
-		bio->bi_bdev   = inode->i_sb->s_bdev;
-
-		done = 0;
-		offset = 0;
-		while (done < len) {
-			ret = bio_add_page(bio, ZERO_PAGE(0),
-							blocksize, offset);
-			if (ret != blocksize) {
-				/*
-				 * We can't add any more pages because of
-				 * hardware limitations.  Start a new bio.
-				 */
-				break;
-			}
-			done++;
-			offset += blocksize;
-			if (offset >= PAGE_CACHE_SIZE)
-				offset = 0;
-		}
-
-		init_completion(&event);
-		bio->bi_private = &event;
-		bio->bi_end_io = bi_complete;
-		submit_bio(WRITE, bio);
-		wait_for_completion(&event);
-
-		if (test_bit(BIO_UPTODATE, &bio->bi_flags))
-			ret = 0;
-		else {
-			ret = -EIO;
-			break;
-		}
-		bio_put(bio);
-		ee_len    -= done;
-		ee_pblock += done  << (blkbits - 9);
-	}
-	return ret;
+	return blkdev_issue_zeroout(inode->i_sb->s_bdev, ext_pblock(ex),
+				nr_sects, UINT_MAX >> 9, GFP_NOIO, WRITE);
 }
 
 #define EXT4_EXT_ZERO_LEN 7
-- 
1.6.6

