Return-Path: <linux-kernel-owner+w=401wt.eu-S941261AbXGaCb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941261AbXGaCb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932937AbXGaCTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:19:08 -0400
Received: from cantor.suse.de ([195.135.220.2]:52881 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940592AbXGaCTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:19:06 -0400
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 12:18:52 +1000
Message-Id: <1070731021852.25640@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Subject: [PATCH 035 of 35] Simplify bio splitting in dm.
References: <20070731112539.22428.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Use the new bio_multi_split to simplify dm bio splitting.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/dm.c |  166 ++++++------------------------------------------------
 1 file changed, 20 insertions(+), 146 deletions(-)

diff .prev/drivers/md/dm.c ./drivers/md/dm.c
--- .prev/drivers/md/dm.c	2007-07-31 11:21:22.000000000 +1000
+++ ./drivers/md/dm.c	2007-07-31 11:21:30.000000000 +1000
@@ -526,11 +526,6 @@ static void clone_endio(struct bio *bio,
 
 	dec_pending(tio->io, error);
 
-	/*
-	 * Store md for cleanup instead of tio which is about to get freed.
-	 */
-	bio->bi_private = md->bs;
-
 	bio_put(bio);
 	free_tio(md, tio);
 }
@@ -590,10 +585,6 @@ static void __map_bio(struct dm_target *
 		/* error the io and bail out, or requeue it if needed */
 		md = tio->io->md;
 		dec_pending(tio->io, r);
-		/*
-		 * Store bio_set for cleanup.
-		 */
-		clone->bi_private = md->bs;
 		bio_put(clone);
 		free_tio(md, tio);
 	} else if (r) {
@@ -607,149 +598,35 @@ struct clone_info {
 	struct dm_table *map;
 	struct bio *bio;
 	struct dm_io *io;
-	sector_t sector;
-	sector_t sector_count;
-	unsigned short idx;
 };
 
-static void dm_bio_destructor(struct bio *bio)
-{
-	struct bio_set *bs = bio->bi_private;
-
-	bio_free(bio, bs);
-}
-
-/*
- * Creates a little bio that is just does part of a bvec.
- */
-static struct bio *split_bvec(struct bio *bio, sector_t sector,
-			      unsigned short idx, unsigned int offset,
-			      unsigned int len, struct bio_set *bs)
-{
-	struct bio *clone;
-	struct bio_vec *bv = bio->bi_io_vec + idx;
-
-	clone = bio_alloc_bioset(GFP_NOIO, 1, bs);
-	clone->bi_destructor = dm_bio_destructor;
-	*clone->bi_io_vec = *bv;
-
-	clone->bi_sector = sector;
-	clone->bi_bdev = bio->bi_bdev;
-	clone->bi_rw = bio->bi_rw;
-	clone->bi_vcnt = 1;
-	clone->bi_size = to_bytes(len);
-	clone->bi_io_vec->bv_offset = offset;
-	clone->bi_io_vec->bv_len = clone->bi_size;
-
-	return clone;
-}
-
-/*
- * Creates a bio that consists of range of complete bvecs.
- */
-static struct bio *clone_bio(struct bio *bio, sector_t sector,
-			     unsigned short idx, unsigned short bv_count,
-			     unsigned int len, struct bio_set *bs)
-{
-	struct bio *clone;
-
-	clone = bio_alloc_bioset(GFP_NOIO, bio->bi_max_vecs, bs);
-	__bio_clone(clone, bio);
-	clone->bi_destructor = dm_bio_destructor;
-	clone->bi_sector = sector;
-	clone->bi_io_vec += idx;
-	clone->bi_vcnt = bv_count;
-	clone->bi_size = to_bytes(len);
-
-	return clone;
-}
-
 static void __clone_and_map(struct clone_info *ci)
 {
-	struct bio *clone, *bio = ci->bio;
-	struct dm_target *ti = dm_table_find_target(ci->map, ci->sector);
-	sector_t len = 0, max = max_io_len(ci->md, ci->sector, ti);
-	struct dm_target_io *tio;
+	struct bio *bio = ci->bio;
+	struct bio *remainder = bio;
 
-	/*
-	 * Allocate a target io object.
-	 */
-	tio = alloc_tio(ci->md);
-	tio->io = ci->io;
-	tio->ti = ti;
-	memset(&tio->info, 0, sizeof(tio->info));
+	while (remainder) {
+		struct bio *clone;
+		struct dm_target *ti =
+			dm_table_find_target(ci->map,
+					     remainder->bi_sector);
+		sector_t len = 0;
+		sector_t max = max_io_len(ci->md, remainder->bi_sector, ti);
+		struct dm_target_io *tio;
 
-	if (ci->sector_count <= max) {
 		/*
-		 * Optimise for the simple case where we can do all of
-		 * the remaining io with a single clone.
+		 * Allocate a target io object.
 		 */
-		clone = clone_bio(bio, ci->sector, ci->idx,
-				  bio->bi_vcnt - ci->idx, ci->sector_count,
-				  ci->md->bs);
-		__map_bio(ti, clone, tio);
-		ci->sector_count = 0;
-
-	} else if (to_sector(bio->bi_io_vec[ci->idx].bv_len) <= max) {
-		/*
-		 * There are some bvecs that don't span targets.
-		 * Do as many of these as possible.
-		 */
-		int i;
-		sector_t remaining = max;
-		sector_t bv_len;
-
-		for (i = ci->idx; remaining && (i < bio->bi_vcnt); i++) {
-			bv_len = to_sector(bio->bi_io_vec[i].bv_len);
+		tio = alloc_tio(ci->md);
+		tio->io = ci->io;
+		tio->ti = ti;
+		memset(&tio->info, 0, sizeof(tio->info));
 
-			if (bv_len > remaining)
-				break;
+		len = min_t(unsigned int, remainder->bi_size>>9, max);
 
-			remaining -= bv_len;
-			len += bv_len;
-		}
-
-		clone = clone_bio(bio, ci->sector, ci->idx, i - ci->idx, len,
-				  ci->md->bs);
+		clone = bio_multi_split(bio, len, &remainder);
 		__map_bio(ti, clone, tio);
-
-		ci->sector += len;
-		ci->sector_count -= len;
-		ci->idx = i;
-
-	} else {
-		/*
-		 * Handle a bvec that must be split between two or more targets.
-		 */
-		struct bio_vec *bv = bio->bi_io_vec + ci->idx;
-		sector_t remaining = to_sector(bv->bv_len);
-		unsigned int offset = 0;
-
-		do {
-			if (offset) {
-				ti = dm_table_find_target(ci->map, ci->sector);
-				max = max_io_len(ci->md, ci->sector, ti);
-
-				tio = alloc_tio(ci->md);
-				tio->io = ci->io;
-				tio->ti = ti;
-				memset(&tio->info, 0, sizeof(tio->info));
-			}
-
-			len = min(remaining, max);
-
-			clone = split_bvec(bio, ci->sector, ci->idx,
-					   bv->bv_offset + offset, len,
-					   ci->md->bs);
-
-			__map_bio(ti, clone, tio);
-
-			ci->sector += len;
-			ci->sector_count -= len;
-			offset += to_bytes(len);
-		} while (remaining -= len);
-
-		ci->idx++;
+		atomic_dec(&bio->bi_iocnt);
 	}
 }
 
@@ -773,13 +650,10 @@ static void __split_bio(struct mapped_de
 	atomic_set(&ci.io->io_count, 1);
 	ci.io->bio = bio;
 	ci.io->md = md;
-	ci.sector = bio->bi_sector;
-	ci.sector_count = bio_sectors(bio);
-	ci.idx = 0;
 
 	start_io_acct(ci.io);
-	while (ci.sector_count)
-		__clone_and_map(&ci);
+
+	__clone_and_map(&ci);
 
 	/* drop the extra reference count */
 	dec_pending(ci.io, 0);
