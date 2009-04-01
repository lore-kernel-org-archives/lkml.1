Return-Path: <linux-kernel-owner+w=401wt.eu-S1757777AbZDALHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbZDALHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739AbZDALFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:05:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:35200 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755796AbZDALFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:05:01 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/8] bio: remove size/segments limit on bio_{copy|map}_{user|kern}*()
Date: Wed,  1 Apr 2009 20:04:42 +0900
Message-Id: <1238583884-13517-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1238583884-13517-1-git-send-email-tj@kernel.org>
References: <1238583884-13517-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 11:04:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: API improvement, constant renames

bio_{copy|map}_{user|kern}*() don't guarantee successful allocation
and thus don't have any reason to use bio_alloc().  Switch to
bio_kmalloc().  This removes size/segments limit from these APIs,
which will be used to fix multiple bio mapping bug in
blk_rq_map_user().

As this means that bio size is not capped, rename BIO_MAX_* to
BIO_GUARANTEED_*.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-map.c            |   12 +++++++-----
 drivers/md/dm-io.c         |    4 ++--
 drivers/md/dm.c            |    4 ++--
 drivers/scsi/scsi_lib.c    |    3 ++-
 fs/bio.c                   |   10 +++++-----
 fs/btrfs/extent_io.c       |    2 +-
 fs/ext4/extents.c          |    4 ++--
 fs/xfs/linux-2.6/xfs_buf.c |    2 +-
 include/linux/bio.h        |    6 +++---
 9 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index f103729..6718021 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -127,17 +127,19 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 	while (bytes_read != len) {
 		unsigned long map_len, end, start;
 
-		map_len = min_t(unsigned long, len - bytes_read, BIO_MAX_SIZE);
+		map_len = min_t(unsigned long, len - bytes_read,
+				BIO_GUARANTEED_SIZE);
 		end = ((unsigned long)ubuf + map_len + PAGE_SIZE - 1)
 								>> PAGE_SHIFT;
 		start = (unsigned long)ubuf >> PAGE_SHIFT;
 
 		/*
-		 * A bad offset could cause us to require BIO_MAX_PAGES + 1
-		 * pages. If this happens we just lower the requested
-		 * mapping len by a page so that we can fit
+		 * A bad offset could cause us to require
+		 * BIO_GUARANTEED_PAGES + 1 pages. If this happens we
+		 * just lower the requested mapping len by a page so
+		 * that we can fit
 		 */
-		if (end - start > BIO_MAX_PAGES)
+		if (end - start > BIO_GUARANTEED_PAGES)
 			map_len -= PAGE_SIZE;
 
 		ret = __blk_rq_map_user(q, rq, map_data, ubuf, map_len,
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 36e2b5e..38a175a 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -292,8 +292,8 @@ static void do_region(int rw, unsigned region, struct dm_io_region *where,
 					     (PAGE_SIZE >> SECTOR_SHIFT));
 		num_bvecs = 1 + min_t(int, bio_get_nr_vecs(where->bdev),
 				      num_bvecs);
-		if (unlikely(num_bvecs > BIO_MAX_PAGES))
-			num_bvecs = BIO_MAX_PAGES;
+		if (unlikely(num_bvecs > BIO_GUARANTEED_PAGES))
+			num_bvecs = BIO_GUARANTEED_PAGES;
 		bio = bio_alloc_bioset(GFP_NOIO, num_bvecs, io->client->bios);
 		bio->bi_sector = where->sector + (where->count - remaining);
 		bio->bi_bdev = where->bdev;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8d40f27..4949112 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -894,8 +894,8 @@ static int dm_merge_bvec(struct request_queue *q,
 	/*
 	 * Find maximum amount of I/O that won't need splitting
 	 */
-	max_sectors = min(max_io_len(md, bvm->bi_sector, ti),
-			  (sector_t) BIO_MAX_SECTORS);
+	max_sectors = min_t(sector_t, max_io_len(md, bvm->bi_sector, ti),
+			    BIO_GUARANTEED_SECTORS);
 	max_size = (max_sectors << SECTOR_SHIFT) - bvm->bi_size;
 	if (max_size < 0)
 		max_size = 0;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b82ffd9..3196c83 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -351,7 +351,8 @@ static int scsi_req_map_sg(struct request *rq, struct scatterlist *sgl,
 			bytes = min(bytes, data_len);
 
 			if (!bio) {
-				nr_vecs = min_t(int, BIO_MAX_PAGES, nr_pages);
+				nr_vecs = min_t(int, BIO_GUARANTEED_PAGES,
+						nr_pages);
 				nr_pages -= nr_vecs;
 
 				bio = bio_alloc(gfp, nr_vecs);
diff --git a/fs/bio.c b/fs/bio.c
index e15e457..8ad9784 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -40,7 +40,7 @@ static mempool_t *bio_split_pool __read_mostly;
  */
 #define BV(x) { .nr_vecs = x, .name = "biovec-"__stringify(x) }
 struct biovec_slab bvec_slabs[BIOVEC_NR_POOLS] __read_mostly = {
-	BV(1), BV(4), BV(16), BV(64), BV(128), BV(BIO_MAX_PAGES),
+	BV(1), BV(4), BV(16), BV(64), BV(128), BV(BIO_GUARANTEED_PAGES),
 };
 #undef BV
 
@@ -187,7 +187,7 @@ struct bio_vec *bvec_alloc_bs(gfp_t gfp_mask, int nr, unsigned long *idx,
 	case 65 ... 128:
 		*idx = 4;
 		break;
-	case 129 ... BIO_MAX_PAGES:
+	case 129 ... BIO_GUARANTEED_PAGES:
 		*idx = 5;
 		break;
 	default:
@@ -818,7 +818,7 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 		return ERR_PTR(-ENOMEM);
 
 	ret = -ENOMEM;
-	bio = bio_alloc(gfp_mask, nr_pages);
+	bio = bio_kmalloc(gfp_mask, nr_pages);
 	if (!bio)
 		goto out_bmd;
 
@@ -942,7 +942,7 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 	if (!nr_pages)
 		return ERR_PTR(-EINVAL);
 
-	bio = bio_alloc(gfp_mask, nr_pages);
+	bio = bio_kmalloc(gfp_mask, nr_pages);
 	if (!bio)
 		return ERR_PTR(-ENOMEM);
 
@@ -1126,7 +1126,7 @@ static struct bio *__bio_map_kern(struct request_queue *q, void *data,
 	int offset, i;
 	struct bio *bio;
 
-	bio = bio_alloc(gfp_mask, nr_pages);
+	bio = bio_kmalloc(gfp_mask, nr_pages);
 	if (!bio)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ebe6b29..8560995 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1899,7 +1899,7 @@ static int submit_extent_page(int rw, struct extent_io_tree *tree,
 		}
 	}
 	if (this_compressed)
-		nr = BIO_MAX_PAGES;
+		nr = BIO_GUARANTEED_PAGES;
 	else
 		nr = bio_get_nr_vecs(bdev);
 
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e0aa4fe..6aad7b2 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2315,8 +2315,8 @@ static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
 
 	while (ee_len > 0) {
 
-		if (ee_len > BIO_MAX_PAGES)
-			len = BIO_MAX_PAGES;
+		if (ee_len > BIO_GUARANTEED_PAGES)
+			len = BIO_GUARANTEED_PAGES;
 		else
 			len = ee_len;
 
diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index aa1016b..5d7c571 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1211,7 +1211,7 @@ _xfs_buf_ioapply(
 
 next_chunk:
 	atomic_inc(&bp->b_io_remaining);
-	nr_pages = BIO_MAX_SECTORS >> (PAGE_SHIFT - BBSHIFT);
+	nr_pages = BIO_GUARANTEED_SECTORS >> (PAGE_SHIFT - BBSHIFT);
 	if (nr_pages > total_nr_pages)
 		nr_pages = total_nr_pages;
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index e01e41d..8647dd9 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -36,9 +36,9 @@
 #define BIO_BUG_ON
 #endif
 
-#define BIO_MAX_PAGES		256
-#define BIO_MAX_SIZE		(BIO_MAX_PAGES << PAGE_CACHE_SHIFT)
-#define BIO_MAX_SECTORS		(BIO_MAX_SIZE >> 9)
+#define BIO_GUARANTEED_PAGES	256
+#define BIO_GUARANTEED_SIZE	(BIO_GUARANTEED_PAGES << PAGE_CACHE_SHIFT)
+#define BIO_GUARANTEED_SECTORS	(BIO_GUARANTEED_SIZE >> 9)
 
 #define BIO_INLINE_VECS		4
 
-- 
1.6.0.2

