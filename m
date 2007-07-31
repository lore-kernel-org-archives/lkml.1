Return-Path: <linux-kernel-owner+w=401wt.eu-S941532AbXGaCbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941532AbXGaCbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940091AbXGaCTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:19:04 -0400
Received: from mail.suse.de ([195.135.220.2]:52876 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764299AbXGaCTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:19:00 -0400
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 12:18:47 +1000
Message-Id: <1070731021847.25620@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Subject: [PATCH 034 of 35] Simplify bio_add_page and raid1/raid10 resync which use it.
References: <20070731112539.22428.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


__bio_add_page no longer needs 'max_sectors' and can now
only fail when the bio is full.
So raid1/raid10 do not need to cope with unpredictable failure of
bio_add_page, and can be simplified.  Infact they get simplified so
much that they don't use bio_add_page at all (they we only using
before to check when the bio got too big).

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c  |   41 +++++++++++++++--------------------------
 ./drivers/md/raid10.c |   42 +++++++++++++-----------------------------
 ./fs/bio.c            |   33 +++++++++------------------------
 3 files changed, 37 insertions(+), 79 deletions(-)

diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
--- .prev/drivers/md/raid10.c	2007-07-31 11:21:27.000000000 +1000
+++ ./drivers/md/raid10.c	2007-07-31 11:21:29.000000000 +1000
@@ -129,6 +129,8 @@ static void * r10buf_pool_alloc(gfp_t gf
 			if (unlikely(!page))
 				goto out_free_pages;
 
+			bio->bi_io_vec[i].bv_offset = 0;
+			bio->bi_io_vec[i].bv_len = PAGE_SIZE;
 			bio->bi_io_vec[i].bv_page = page;
 		}
 	}
@@ -1576,7 +1578,6 @@ static sector_t sync_request(mddev_t *md
 	r10bio_t *r10_bio;
 	struct bio *biolist = NULL, *bio;
 	sector_t max_sector, nr_sectors;
-	int disk;
 	int i;
 	int max_sync;
 	int sync_blocks;
@@ -1828,51 +1829,34 @@ static sector_t sync_request(mddev_t *md
 		}
 	}
 
-	for (bio = biolist; bio ; bio=bio->bi_next) {
-
-		bio->bi_flags &= ~(BIO_POOL_MASK - 1);
-		if (bio->bi_end_io)
-			bio->bi_flags |= 1 << BIO_UPTODATE;
-		bio->bi_vcnt = 0;
-		bio->bi_size = 0;
-	}
-
 	nr_sectors = 0;
 	if (sector_nr + max_sync < max_sector)
 		max_sector = sector_nr + max_sync;
 	do {
-		struct page *page;
 		int len = PAGE_SIZE;
-		disk = 0;
+
 		if (sector_nr + (len>>9) > max_sector)
 			len = (max_sector - sector_nr) << 9;
 		if (len == 0)
 			break;
-		for (bio= biolist ; bio ; bio=bio->bi_next) {
-			page = bio->bi_io_vec[bio->bi_vcnt].bv_page;
-			if (bio_add_page(bio, page, len, 0) == 0) {
-				/* stop here */
-				struct bio *bio2;
-				bio->bi_io_vec[bio->bi_vcnt].bv_page = page;
-				for (bio2 = biolist; bio2 && bio2 != bio; bio2 = bio2->bi_next) {
-					/* remove last page from this bio */
-					bio2->bi_vcnt--;
-					bio2->bi_size -= len;
-				}
-				goto bio_full;
-			}
-			disk = i;
-		}
+
 		nr_sectors += len>>9;
 		sector_nr += len>>9;
-	} while (biolist->bi_vcnt < RESYNC_PAGES);
- bio_full:
+	} while (nr_sectors < (RESYNC_PAGES << (PAGE_SHIFT-9)));
+
 	r10_bio->sectors = nr_sectors;
 
 	while (biolist) {
 		bio = biolist;
 		biolist = biolist->bi_next;
 
+		bio->bi_flags &= ~(BIO_POOL_MASK - 1);
+		if (bio->bi_end_io)
+			bio->bi_flags |= 1 << BIO_UPTODATE;
+		bio->bi_size = nr_sectors << 9;
+		bio->bi_offset = 0;
+		bio->bi_vcnt = DIV_ROUND_UP(bio->bi_size, PAGE_SIZE);
+
 		bio->bi_next = NULL;
 		r10_bio = bio->bi_private;
 		r10_bio->sectors = nr_sectors;

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2007-07-31 11:21:27.000000000 +1000
+++ ./drivers/md/raid1.c	2007-07-31 11:21:29.000000000 +1000
@@ -119,14 +119,19 @@ static void * r1buf_pool_alloc(gfp_t gfp
 				goto out_free_pages;
 
 			bio->bi_io_vec[i].bv_page = page;
+			bio->bi_io_vec[i].bv_offset = 0;
+			bio->bi_io_vec[i].bv_len = PAGE_SIZE;
 		}
 	}
 	/* If not user-requests, copy the page pointers to all bios */
 	if (!test_bit(MD_RECOVERY_REQUESTED, &pi->mddev->recovery)) {
 		for (i=0; i<RESYNC_PAGES ; i++)
-			for (j=1; j<pi->raid_disks; j++)
+			for (j = 1; j < pi->raid_disks; j++) {
+				r1_bio->bios[j]->bi_io_vec[i].bv_offset = 0;
+				r1_bio->bios[j]->bi_io_vec[i].bv_len = PAGE_SIZE;
 				r1_bio->bios[j]->bi_io_vec[i].bv_page =
 					r1_bio->bios[0]->bi_io_vec[i].bv_page;
+			}
 	}
 
 	r1_bio->master_bio = NULL;
@@ -1780,7 +1785,6 @@ static sector_t sync_request(mddev_t *md
 	nr_sectors = 0;
 	sync_blocks = 0;
 	do {
-		struct page *page;
 		int len = PAGE_SIZE;
 		if (sector_nr + (len>>9) > max_sector)
 			len = (max_sector - sector_nr) << 9;
@@ -1796,32 +1800,18 @@ static sector_t sync_request(mddev_t *md
 			if (len > (sync_blocks<<9))
 				len = sync_blocks<<9;
 		}
-
-		for (i=0 ; i < conf->raid_disks; i++) {
-			bio = r1_bio->bios[i];
-			if (bio->bi_end_io) {
-				page = bio->bi_io_vec[bio->bi_vcnt].bv_page;
-				if (bio_add_page(bio, page, len, 0) == 0) {
-					/* stop here */
-					bio->bi_io_vec[bio->bi_vcnt].bv_page = page;
-					while (i > 0) {
-						i--;
-						bio = r1_bio->bios[i];
-						if (bio->bi_end_io==NULL)
-							continue;
-						/* remove last page from this bio */
-						bio->bi_vcnt--;
-						bio->bi_size -= len;
-					}
-					goto bio_full;
-				}
-			}
-		}
 		nr_sectors += len>>9;
 		sector_nr += len>>9;
 		sync_blocks -= (len>>9);
-	} while (r1_bio->bios[disk]->bi_vcnt < RESYNC_PAGES);
- bio_full:
+	} while (nr_sectors < (RESYNC_PAGES << (PAGE_SHIFT-9)));
+
+	for (i = 0; i < conf->raid_disks ; i++) {
+		bio = r1_bio->bios[i];
+		bio->bi_size = nr_sectors << 9;
+		bio->bi_offset = 0;
+		bio->bi_vcnt = DIV_ROUND_UP(bio->bi_size, PAGE_SIZE);
+	}
+
 	r1_bio->sectors = nr_sectors;
 
 	/* For a user-requested sync, we read all readable devices and do a
@@ -1841,7 +1831,6 @@ static sector_t sync_request(mddev_t *md
 		bio = r1_bio->bios[r1_bio->read_disk];
 		md_sync_acct(bio->bi_bdev, nr_sectors);
 		generic_make_request(bio);
-
 	}
 	return nr_sectors;
 }

diff .prev/fs/bio.c ./fs/bio.c
--- .prev/fs/bio.c	2007-07-31 11:21:27.000000000 +1000
+++ ./fs/bio.c	2007-07-31 11:21:29.000000000 +1000
@@ -290,19 +290,14 @@ int bio_get_nr_vecs(struct block_device 
 }
 
 static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
-			  *page, unsigned int len, unsigned int offset,
-			  unsigned short max_sectors)
+			  *page, unsigned int len, unsigned int offset)
 {
 	struct bio_vec *bvec;
 
 	/*
-	 * cloned bio must not modify vec list
+	 * cloned bio must never try to modify vec list
 	 */
-	if (unlikely(bio_flagged(bio, BIO_CLONED)))
-		return 0;
-
-	if (((bio->bi_size + len) >> 9) > max_sectors)
-		return 0;
+	BUG_ON(bio_flagged(bio, BIO_CLONED));
 
 	/*
 	 * For filesystems with a blocksize smaller than the pagesize
@@ -323,10 +318,6 @@ static int __bio_add_page(struct request
 	if (bio->bi_vcnt >= bio->bi_max_vecs)
 		return 0;
 
-	/*
-	 * setup the new entry, we might clear it again later if we
-	 * cannot add the page
-	 */
 	bvec = &bio->bi_io_vec[bio->bi_vcnt];
 	bvec->bv_page = page;
 	bvec->bv_len = len;
@@ -346,16 +337,13 @@ static int __bio_add_page(struct request
  *	@len: vec entry length
  *	@offset: vec entry offset
  *
- *	Attempt to add a page to the bio_vec maplist. This can fail for a
- *	number of reasons, such as the bio being full or target block
- *	device limitations. The target block device must allow bio's
- *      smaller than PAGE_SIZE, so it is always possible to add a single
- *      page to an empty bio. This should only be used by REQ_PC bios.
+ *	Attempt to add a page to the bio_vec maplist. This can fail only
+ *	if the bio is full. This should only be used by REQ_PC bios.
  */
 int bio_add_pc_page(struct request_queue *q, struct bio *bio, struct page *page,
 		    unsigned int len, unsigned int offset)
 {
-	return __bio_add_page(q, bio, page, len, offset, q->max_hw_sectors);
+	return __bio_add_page(q, bio, page, len, offset);
 }
 
 /**
@@ -365,17 +353,14 @@ int bio_add_pc_page(struct request_queue
  *	@len: vec entry length
  *	@offset: vec entry offset
  *
- *	Attempt to add a page to the bio_vec maplist. This can fail for a
- *	number of reasons, such as the bio being full or target block
- *	device limitations. The target block device must allow bio's
- *      smaller than PAGE_SIZE, so it is always possible to add a single
- *      page to an empty bio.
+ *	Attempt to add a page to the bio_vec maplist. This can fail only
+ *	if the bio is full.
  */
 int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
 		 unsigned int offset)
 {
 	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
-	return __bio_add_page(q, bio, page, len, offset, q->max_sectors);
+	return __bio_add_page(q, bio, page, len, offset);
 }
 
 struct bio_map_data {
