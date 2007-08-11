Return-Path: <linux-kernel-owner+w=401wt.eu-S1762627AbXHKS61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762627AbXHKS61 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 14:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759606AbXHKS5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 14:57:53 -0400
Received: from 1wt.eu ([62.212.114.60]:1441 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756661AbXHKS5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 14:57:50 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070811184830.%N@1wt.eu>
References: <20070811184752.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 11 Aug 2007 21:47:55 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Neil Brown <neilb@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.16 review 03/28] md: Dont write more than is required of the last page of a bitmap
Content-Disposition: inline; filename=0003-PATCH-md-Don-t-write-more-than-is-required-of-the.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible that real data or metadata follows the bitmap
without full page alignment.
So limit the last write to be only the required number of bytes,
rounded up to the hard sector size of the device.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/md/bitmap.c         |   17 ++++++++++++-----
 include/linux/raid/bitmap.h |    1 +
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index cef1287..550ac72 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -255,19 +255,25 @@ static struct page *read_sb_page(mddev_t *mddev, long offset, unsigned long inde
 
 }
 
-static int write_sb_page(mddev_t *mddev, long offset, struct page *page, int wait)
+static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 {
 	mdk_rdev_t *rdev;
 	struct list_head *tmp;
+	mddev_t *mddev = bitmap->mddev;
 
 	ITERATE_RDEV(mddev, rdev, tmp)
 		if (test_bit(In_sync, &rdev->flags)
-		    && !test_bit(Faulty, &rdev->flags))
+		    && !test_bit(Faulty, &rdev->flags)) {
+			int size = PAGE_SIZE;
+			if (page->index == bitmap->file_pages-1)
+				size = roundup(bitmap->last_page_size,
+					       bdev_hardsect_size(rdev->bdev));
 			md_super_write(mddev, rdev,
-				       (rdev->sb_offset<<1) + offset
+				       (rdev->sb_offset<<1) + bitmap->offset
 				       + page->index * (PAGE_SIZE/512),
-				       PAGE_SIZE,
+				       size,
 				       page);
+		}
 
 	if (wait)
 		md_super_wait(mddev);
@@ -282,7 +288,7 @@ static int write_page(struct bitmap *bitmap, struct page *page, int wait)
 	struct buffer_head *bh;
 
 	if (bitmap->file == NULL)
-		return write_sb_page(bitmap->mddev, bitmap->offset, page, wait);
+		return write_sb_page(bitmap, page, wait);
 
 	bh = page_buffers(page);
 
@@ -923,6 +929,7 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 			}
 
 			bitmap->filemap[bitmap->file_pages++] = page;
+			bitmap->last_page_size = count;
 		}
 		paddr = kmap_atomic(page, KM_USER0);
 		if (bitmap->flags & BITMAP_HOSTENDIAN)
diff --git a/include/linux/raid/bitmap.h b/include/linux/raid/bitmap.h
index 6db9a4c..dd5a05d 100644
--- a/include/linux/raid/bitmap.h
+++ b/include/linux/raid/bitmap.h
@@ -232,6 +232,7 @@ struct bitmap {
 	struct page **filemap; /* list of cache pages for the file */
 	unsigned long *filemap_attr; /* attributes associated w/ filemap pages */
 	unsigned long file_pages; /* number of pages in the file */
+	int last_page_size; /* bytes in the last page */
 
 	unsigned long flags;
 
-- 
1.5.2.4

-- 
