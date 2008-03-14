Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbYCNOEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbYCNOEb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 10:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbYCNOEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 10:04:23 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:1936 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbYCNOEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 10:04:22 -0400
Message-ID: <47DA85E0.2080501@hp.com>
Date: Fri, 14 Mar 2008 10:04:16 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: Daniel Phillips <phillips@phunq.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Stacking bio support - patch 1/4 for 2.6.23.17 (stable)
References: <200803110352.41479.phillips@phunq.net> <47DA84B7.1000409@hp.com>
In-Reply-To: <47DA84B7.1000409@hp.com>
Content-Type: multipart/mixed;
 boundary="------------080509010107060608090700"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080509010107060608090700
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



--------------080509010107060608090700
Content-Type: text/x-patch;
 name="0001-BIO-single-alloc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-BIO-single-alloc.patch"

>From 7a91a074d4442d37ec43830c58ac94d39d17bd3d Mon Sep 17 00:00:00 2001
From: Alan D. Brunelle <alan.brunelle@hp.com>
Date: Fri, 14 Mar 2008 07:52:09 -0400
Subject: [PATCH] BIO single alloc


---
 drivers/md/dm.c |   76 ++++++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 58 insertions(+), 18 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index fac09d5..02173df 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -491,11 +491,9 @@ static void dec_pending(struct dm_io *io, int error)
 	}
 }
 
-static int clone_endio(struct bio *bio, unsigned int done, int error)
+static int dm_endio(struct bio *bio, unsigned int done, int error, struct dm_target_io *tio)
 {
 	int r = 0;
-	struct dm_target_io *tio = bio->bi_private;
-	struct mapped_device *md = tio->io->md;
 	dm_endio_fn endio = tio->ti->type->end_io;
 
 	if (bio->bi_size)
@@ -522,17 +520,28 @@ static int clone_endio(struct bio *bio, unsigned int done, int error)
 	}
 
 	dec_pending(tio->io, error);
+	return r;
+}
 
+static int clone_endio(struct bio *bio, unsigned int done, int error)
+{
+	struct dm_target_io *tio = bio->bi_private;
+	struct mapped_device *md = tio->io->md;
+	int r = dm_endio(bio, done, error, tio);
 	/*
 	 * Store md for cleanup instead of tio which is about to get freed.
 	 */
 	bio->bi_private = md->bs;
-
 	bio_put(bio);
 	free_tio(md, tio);
 	return r;
 }
 
+static int dm_endio_pop(struct bio *bio, unsigned int done, int error)
+{
+	return dm_endio(bio, done, error, bio_pop(bio));
+}
+
 static sector_t max_io_len(struct mapped_device *md,
 			   sector_t sector, struct dm_target *ti)
 {
@@ -553,8 +562,7 @@ static sector_t max_io_len(struct mapped_device *md,
 	return len;
 }
 
-static void __map_bio(struct dm_target *ti, struct bio *clone,
-		      struct dm_target_io *tio)
+static void __map_bio(struct dm_target *ti, struct bio *clone, struct dm_target_io *tio)
 {
 	int r;
 	sector_t sector;
@@ -600,6 +608,37 @@ static void __map_bio(struct dm_target *ti, struct bio *clone,
 	}
 }
 
+static void dm_map(struct bio *bio, struct dm_target *ti, struct dm_target_io *tio)
+{
+	int r;
+	sector_t sector;
+
+	/*
+	 * Map the bio.  If r == 0 we don't need to do
+	 * anything, the target has assumed ownership of
+	 * this io.
+	 */
+	atomic_inc(&tio->io->io_count);
+	sector = bio->bi_sector;
+	r = ti->type->map(ti, bio, &tio->info);
+	if (r == DM_MAPIO_REMAPPED) {
+		/* the bio has been remapped so dispatch it */
+
+		blk_add_trace_remap(bdev_get_queue(bio->bi_bdev), bio,
+				    tio->io->bio->bi_bdev->bd_dev,
+				    bio->bi_sector, sector);
+
+		generic_make_request(bio);
+	} else if (r < 0 || r == DM_MAPIO_REQUEUE) {
+		/* error the io and bail out, or requeue it if needed */
+		bio_pop(bio);
+		dec_pending(tio->io, r);
+	} else if (r) {
+		DMWARN("unimplemented target map return value: %d", r);
+		BUG();
+	}
+}
+
 struct clone_info {
 	struct mapped_device *md;
 	struct dm_table *map;
@@ -676,23 +715,18 @@ static int __clone_and_map(struct clone_info *ci)
 
 	max = max_io_len(ci->md, ci->sector, ti);
 
-	/*
-	 * Allocate a target io object.
-	 */
-	tio = alloc_tio(ci->md);
-	tio->io = ci->io;
-	tio->ti = ti;
-	memset(&tio->info, 0, sizeof(tio->info));
-
 	if (ci->sector_count <= max) {
 		/*
 		 * Optimise for the simple case where we can do all of
 		 * the remaining io with a single clone.
 		 */
-		clone = clone_bio(bio, ci->sector, ci->idx,
-				  bio->bi_vcnt - ci->idx, ci->sector_count,
-				  ci->md->bs);
-		__map_bio(ti, clone, tio);
+		tio = bio_push(bio, sizeof(*tio), dm_endio_pop);
+		*tio = (typeof(*tio)){ .io = ci->io, .ti = ti };
+		bio->bi_sector = ci->sector;
+		bio->bi_idx = ci->idx;
+		bio->bi_size = to_bytes(ci->sector_count);
+		bio->bi_flags &= ~(1 << BIO_SEG_VALID);
+		dm_map(bio, ti, tio);
 		ci->sector_count = 0;
 
 	} else if (to_sector(bio->bi_io_vec[ci->idx].bv_len) <= max) {
@@ -704,6 +738,9 @@ static int __clone_and_map(struct clone_info *ci)
 		sector_t remaining = max;
 		sector_t bv_len;
 
+		tio = alloc_tio(ci->md);
+		*tio = (typeof(*tio)){ .io = ci->io, .ti = ti };
+
 		for (i = ci->idx; remaining && (i < bio->bi_vcnt); i++) {
 			bv_len = to_sector(bio->bi_io_vec[i].bv_len);
 
@@ -730,6 +767,9 @@ static int __clone_and_map(struct clone_info *ci)
 		sector_t remaining = to_sector(bv->bv_len);
 		unsigned int offset = 0;
 
+		tio = alloc_tio(ci->md);
+		*tio = (typeof(*tio)){ .io = ci->io, .ti = ti };
+
 		do {
 			if (offset) {
 				ti = dm_table_find_target(ci->map, ci->sector);
-- 
1.5.2.5


--------------080509010107060608090700--
