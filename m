Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbXEUBeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbXEUBeT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 21:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbXEUBdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 21:33:24 -0400
Received: from ns.suse.de ([195.135.220.2]:56609 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798AbXEUBdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 21:33:22 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 21 May 2007 11:33:10 +1000
Message-Id: <1070521013310.6687@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
Cc: stable@kernel.org
Subject: [PATCH 002 of 7] md: Don't write more than is required of the last page of a bitmap
References: <20070521111837.20906.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


It is possible that real data or metadata follows the bitmap
without full page alignment.
So limit the last write to be only the required number of bytes,
rounded up to the hard sector size of the device.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: stable@kernel.org

### Diffstat output
 ./drivers/md/bitmap.c         |   17 ++++++++++++-----
 ./include/linux/raid/bitmap.h |    1 +
 2 files changed, 13 insertions(+), 5 deletions(-)

diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
--- .prev/drivers/md/bitmap.c	2007-05-18 11:49:18.000000000 +1000
+++ ./drivers/md/bitmap.c	2007-05-18 11:49:18.000000000 +1000
@@ -255,19 +255,25 @@ static struct page *read_sb_page(mddev_t
 
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
@@ -282,7 +288,7 @@ static int write_page(struct bitmap *bit
 	struct buffer_head *bh;
 
 	if (bitmap->file == NULL)
-		return write_sb_page(bitmap->mddev, bitmap->offset, page, wait);
+		return write_sb_page(bitmap, page, wait);
 
 	bh = page_buffers(page);
 
@@ -923,6 +929,7 @@ static int bitmap_init_from_disk(struct 
 			}
 
 			bitmap->filemap[bitmap->file_pages++] = page;
+			bitmap->last_page_size = count;
 		}
 		paddr = kmap_atomic(page, KM_USER0);
 		if (bitmap->flags & BITMAP_HOSTENDIAN)

diff .prev/include/linux/raid/bitmap.h ./include/linux/raid/bitmap.h
--- .prev/include/linux/raid/bitmap.h	2007-05-18 11:49:18.000000000 +1000
+++ ./include/linux/raid/bitmap.h	2007-05-18 11:49:18.000000000 +1000
@@ -232,6 +232,7 @@ struct bitmap {
 	struct page **filemap; /* list of cache pages for the file */
 	unsigned long *filemap_attr; /* attributes associated w/ filemap pages */
 	unsigned long file_pages; /* number of pages in the file */
+	int last_page_size; /* bytes in the last page */
 
 	unsigned long flags;
 
