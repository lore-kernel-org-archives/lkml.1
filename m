Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939AbZDNLnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbZDNLnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 07:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbZDNLno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 07:43:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52447 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbZDNLnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 07:43:42 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/6] Handle bio_alloc failure
Date: Tue, 14 Apr 2009 17:11:19 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Kleikamp <shaggy@austin.ibm.com>, xfs-masters@oss.sgi.com
References: <200904141636.26557.knikanth@novell.com> <20090414111838.GG5178@kernel.dk>
In-Reply-To: <20090414111838.GG5178@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904141711.20378.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 April 2009 16:48:38 Jens Axboe wrote:
> On Tue, Apr 14 2009, Nikanth Karthikesan wrote:
> > Hi Jens
> >
> > Some of the callers of bio_alloc() assume that it will never fail and
> > always return bios. But it can fail. This patch set changes those callers
> > to take action when bio_alloc() fails.
>
> It will not fail as long as __GFP_WAIT is set, which it is for all 6 of
> your patches.

I thought so, but was confused by various places where it was being handled!
Can this be merged then?

Thanks
Nikanth

bio_alloc() will not fail as long as __GFP_WAIT is set. __GFP_WAIT is also set
as part of GFP_KERNEL, GFP_NOIO and GFP_NOFS. Remove unnecessary code to
handle bio_alloc failure in those cases.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index f7dae57..20b4111 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -319,9 +319,6 @@ int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
 		return -ENXIO;
 
 	bio = bio_alloc(GFP_KERNEL, 0);
-	if (!bio)
-		return -ENOMEM;
-
 	bio->bi_end_io = bio_end_empty_barrier;
 	bio->bi_private = &wait;
 	bio->bi_bdev = bdev;
diff --git a/block/ioctl.c b/block/ioctl.c
index 0f22e62..ad474d4 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -146,8 +146,6 @@ static int blk_ioctl_discard(struct block_device *bdev, uint64_t start,
 		struct bio *bio;
 
 		bio = bio_alloc(GFP_KERNEL, 0);
-		if (!bio)
-			return -ENOMEM;
 
 		bio->bi_end_io = blk_ioc_discard_endio;
 		bio->bi_bdev = bdev;
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index ddae808..a3659c1 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -636,8 +636,6 @@ static int loop_switch(struct loop_device *lo, struct file *file)
 {
 	struct switch_request w;
 	struct bio *bio = bio_alloc(GFP_KERNEL, 0);
-	if (!bio)
-		return -ENOMEM;
 	init_completion(&w.wait);
 	w.file = file;
 	bio->bi_private = &w;
diff --git a/fs/direct-io.c b/fs/direct-io.c
index da258e7..05763bb 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -307,8 +307,6 @@ dio_bio_alloc(struct dio *dio, struct block_device *bdev,
 	struct bio *bio;
 
 	bio = bio_alloc(GFP_KERNEL, nr_vecs);
-	if (bio == NULL)
-		return -ENOMEM;
 
 	bio->bi_bdev = bdev;
 	bio->bi_sector = first_sector;
diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index ba8d9fa..ee1f438 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -97,15 +97,10 @@ static int pcol_try_alloc(struct page_collect *pcol)
 {
 	int pages = min_t(unsigned, pcol->expected_pages, BIO_MAX_PAGES);
 
-	for (; pages; pages >>= 1) {
+	if (pages)
 		pcol->bio = bio_alloc(GFP_KERNEL, pages);
-		if (likely(pcol->bio))
-			return 0;
-	}
 
-	EXOFS_ERR("Failed to kcalloc expected_pages=%u\n",
-		  pcol->expected_pages);
-	return -ENOMEM;
+	return 0;
 }
 
 static void pcol_free(struct page_collect *pcol)
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 6132353..2a1cb09 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2416,8 +2416,6 @@ static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
 			len = ee_len;
 
 		bio = bio_alloc(GFP_NOIO, len);
-		if (!bio)
-			return -ENOMEM;
 		bio->bi_sector = ee_pblock;
 		bio->bi_bdev   = inode->i_sb->s_bdev;
 
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 51883b3..650a730 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -272,11 +272,6 @@ static int gfs2_read_super(struct gfs2_sbd *sdp, sector_t sector)
 	lock_page(page);
 
 	bio = bio_alloc(GFP_NOFS, 1);
-	if (unlikely(!bio)) {
-		__free_page(page);
-		return -ENOBUFS;
-	}
-
 	bio->bi_sector = sector * (sb->s_blocksize >> 9);
 	bio->bi_bdev = sb->s_bdev;
 	bio_add_page(bio, page, PAGE_SIZE, 0);
diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 7ec89fc..fb4f516 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -421,10 +421,7 @@ xfs_alloc_ioend_bio(
 	struct bio		*bio;
 	int			nvecs = bio_get_nr_vecs(bh->b_bdev);
 
-	do {
-		bio = bio_alloc(GFP_NOIO, nvecs);
-		nvecs >>= 1;
-	} while (!bio);
+	bio = bio_alloc(GFP_NOIO, nvecs);
 
 	ASSERT(bio->bi_private == NULL);
 	bio->bi_sector = bh->b_blocknr * (bh->b_size >> 9);
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 505f319..8ba052c 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -64,8 +64,6 @@ static int submit(int rw, pgoff_t page_off, struct page *page,
 	struct bio *bio;
 
 	bio = bio_alloc(__GFP_WAIT | __GFP_HIGH, 1);
-	if (!bio)
-		return -ENOMEM;
 	bio->bi_sector = page_off * (PAGE_SIZE >> 9);
 	bio->bi_bdev = resume_bdev;
 	bio->bi_end_io = end_swap_bio_read;

