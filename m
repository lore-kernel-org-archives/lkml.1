Return-Path: <linux-kernel-owner+w=401wt.eu-S1757460AbYCNOE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460AbYCNOE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 10:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbYCNOEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 10:04:49 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:36352 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbYCNOEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 10:04:46 -0400
Message-ID: <47DA85F7.8010407@hp.com>
Date: Fri, 14 Mar 2008 10:04:39 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: Daniel Phillips <phillips@phunq.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Stacking bio support
References: <200803110352.41479.phillips@phunq.net> <47DA84B7.1000409@hp.com>
In-Reply-To: <47DA84B7.1000409@hp.com>
Content-Type: multipart/mixed;
 boundary="------------000807090508060505080406"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000807090508060505080406
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



--------------000807090508060505080406
Content-Type: text/x-patch;
 name="0002-Hide-endio.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0002-Hide-endio.patch"

>From afe047bdd4707a1013400f88b50b323d031ae95f Mon Sep 17 00:00:00 2001
From: Alan D. Brunelle <alan.brunelle@hp.com>
Date: Fri, 14 Mar 2008 07:52:38 -0400
Subject: [PATCH] Hide endio


---
 block/ll_rw_blk.c            |    6 ++--
 drivers/block/floppy.c       |    2 +-
 drivers/block/pktcdvd.c      |    8 +++---
 drivers/md/dm-crypt.c        |    2 +-
 drivers/md/dm-emc.c          |    2 +-
 drivers/md/dm-io.c           |    2 +-
 drivers/md/dm.c              |    2 +-
 drivers/md/faulty.c          |    4 +-
 drivers/md/md.c              |    6 ++--
 drivers/md/multipath.c       |    4 +-
 drivers/md/raid1.c           |   44 +++++++++++++++++++++---------------------
 drivers/md/raid10.c          |   24 +++++++++++-----------
 drivers/md/raid5.c           |   18 ++++++++--------
 drivers/s390/block/xpram.c   |    2 +-
 drivers/scsi/scsi_lib.c      |    2 +-
 fs/bio.c                     |   12 +++++-----
 fs/block_dev.c               |    2 +-
 fs/buffer.c                  |    2 +-
 fs/direct-io.c               |    4 +-
 fs/gfs2/super.c              |    3 +-
 fs/jfs/jfs_logmgr.c          |    4 +-
 fs/jfs/jfs_metapage.c        |    4 +-
 fs/mpage.c                   |    4 +-
 fs/ocfs2/cluster/heartbeat.c |    2 +-
 fs/xfs/linux-2.6/xfs_aops.c  |    6 ++--
 fs/xfs/linux-2.6/xfs_buf.c   |    4 +-
 include/linux/bio.h          |   12 ++++++++++-
 kernel/power/swap.c          |    2 +-
 mm/bounce.c                  |    8 +++---
 mm/page_io.c                 |    2 +-
 30 files changed, 104 insertions(+), 95 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 026cf24..b6c9ff7 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -564,14 +564,14 @@ static int ordered_bio_endio(struct request *rq, struct bio *bio,
 	if (error && !q->orderr)
 		q->orderr = error;
 
-	endio = bio->bi_end_io;
+	endio = bio_get_endio(bio);
 	private = bio->bi_private;
-	bio->bi_end_io = flush_dry_bio_endio;
+	bio_set_endio(bio, flush_dry_bio_endio);
 	bio->bi_private = q;
 
 	bio_endio(bio, nbytes, error);
 
-	bio->bi_end_io = endio;
+	bio_set_endio(bio, endio);
 	bio->bi_private = private;
 
 	return 1;
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 085b779..ac378cd 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3855,7 +3855,7 @@ static int __floppy_read_block_0(struct block_device *bdev)
 	bio.bi_sector = 0;
 	init_completion(&complete);
 	bio.bi_private = &complete;
-	bio.bi_end_io = floppy_rb0_complete;
+	bio_set_endio(&bio, floppy_rb0_complete);
 
 	submit_bio(READ, &bio);
 	generic_unplug_device(bdev_get_queue(bdev));
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index fadbfd8..51431a0 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -1150,7 +1150,7 @@ static void pkt_gather_data(struct pktcdvd_device *pd, struct packet_data *pkt)
 		bio->bi_max_vecs = 1;
 		bio->bi_sector = pkt->sector + f * (CD_FRAMESIZE >> 9);
 		bio->bi_bdev = pd->bdev;
-		bio->bi_end_io = pkt_end_io_read;
+		bio_set_endio(bio, pkt_end_io_read);
 		bio->bi_private = pkt;
 
 		p = (f * CD_FRAMESIZE) / PAGE_SIZE;
@@ -1250,7 +1250,7 @@ static int pkt_start_recovery(struct packet_data *pkt)
 	BUG_ON(pkt->bio->bi_rw != (1 << BIO_RW));
 	BUG_ON(pkt->bio->bi_vcnt != pkt->frames);
 	BUG_ON(pkt->bio->bi_size != pkt->frames * CD_FRAMESIZE);
-	BUG_ON(pkt->bio->bi_end_io != pkt_end_io_packet_write);
+	BUG_ON(bio_get_endio(pkt->bio) != pkt_end_io_packet_write);
 	BUG_ON(pkt->bio->bi_private != pkt);
 
 	drop_super(sb);
@@ -1446,7 +1446,7 @@ static void pkt_start_write(struct pktcdvd_device *pd, struct packet_data *pkt)
 	pkt->w_bio->bi_max_vecs = PACKET_MAX_SIZE;
 	pkt->w_bio->bi_sector = pkt->sector;
 	pkt->w_bio->bi_bdev = pd->bdev;
-	pkt->w_bio->bi_end_io = pkt_end_io_packet_write;
+	bio_set_endio(pkt->w_bio, pkt_end_io_packet_write);
 	pkt->w_bio->bi_private = pkt;
 	for (f = 0; f < pkt->frames; f++)
 		if (!bio_add_page(pkt->w_bio, bvec[f].bv_page, CD_FRAMESIZE, bvec[f].bv_offset))
@@ -2503,7 +2503,7 @@ static int pkt_make_request(struct request_queue *q, struct bio *bio)
 		psd->bio = bio;
 		cloned_bio->bi_bdev = pd->bdev;
 		cloned_bio->bi_private = psd;
-		cloned_bio->bi_end_io = pkt_end_io_read_cloned;
+		bio_set_endio(cloned_bio, pkt_end_io_read_cloned);
 		pd->stats.secs_r += bio->bi_size >> 9;
 		pkt_queue_bio(pd, cloned_bio);
 		return 0;
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index ba2e135..f99cc94 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -549,7 +549,7 @@ static void clone_init(struct dm_crypt_io *io, struct bio *clone)
 	struct crypt_config *cc = io->target->private;
 
 	clone->bi_private = io;
-	clone->bi_end_io  = crypt_endio;
+	bio_set_endio(clone, crypt_endio);
 	clone->bi_bdev    = cc->dev->bdev;
 	clone->bi_rw      = io->base_bio->bi_rw;
 	clone->bi_destructor = dm_crypt_bio_destructor;
diff --git a/drivers/md/dm-emc.c b/drivers/md/dm-emc.c
index 265c467..ef78699 100644
--- a/drivers/md/dm-emc.c
+++ b/drivers/md/dm-emc.c
@@ -76,7 +76,7 @@ static struct bio *get_failover_bio(struct dm_path *path, unsigned data_size)
 	bio->bi_bdev = path->dev->bdev;
 	bio->bi_sector = 0;
 	bio->bi_private = path;
-	bio->bi_end_io = emc_endio;
+	bio_set_endio(bio, emc_endio);
 
 	page = alloc_page(GFP_ATOMIC);
 	if (!page) {
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index f3a7724..14be510 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -300,7 +300,7 @@ static void do_region(int rw, unsigned int region, struct io_region *where,
 		bio = bio_alloc_bioset(GFP_NOIO, num_bvecs, io->client->bios);
 		bio->bi_sector = where->sector + (where->count - remaining);
 		bio->bi_bdev = where->bdev;
-		bio->bi_end_io = endio;
+		bio_set_endio(bio, endio);
 		bio->bi_private = io;
 		bio->bi_destructor = dm_bio_destructor;
 		bio->bi_max_vecs--;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 02173df..fcdcf51 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -573,7 +573,7 @@ static void __map_bio(struct dm_target *ti, struct bio *clone, struct dm_target_
 	 */
 	BUG_ON(!clone->bi_size);
 
-	clone->bi_end_io = clone_endio;
+	bio_set_endio(clone, clone_endio);
 	clone->bi_private = tio;
 
 	/*
diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
index cb059cf..15a34f1 100644
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -76,7 +76,7 @@ static int faulty_fail(struct bio *bio, unsigned int bytes_done, int error)
 		bio_put(bio);
 
 	clear_bit(BIO_UPTODATE, &b->bi_flags);
-	return (b->bi_end_io)(b, bytes_done, -EIO);
+	return (bio_get_endio(b))(b, bytes_done, -EIO);
 }
 
 typedef struct faulty_conf {
@@ -212,7 +212,7 @@ static int make_request(struct request_queue *q, struct bio *bio)
 		struct bio *b = bio_clone(bio, GFP_NOIO);
 		b->bi_bdev = conf->rdev->bdev;
 		b->bi_private = bio;
-		b->bi_end_io = faulty_fail;
+		bio_set_endio(b, faulty_fail);
 		generic_make_request(b);
 		return 0;
 	} else {
diff --git a/drivers/md/md.c b/drivers/md/md.c
index f883b7e..e0901c5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -450,7 +450,7 @@ void md_super_write(mddev_t *mddev, mdk_rdev_t *rdev,
 	bio->bi_sector = sector;
 	bio_add_page(bio, page, size, 0);
 	bio->bi_private = rdev;
-	bio->bi_end_io = super_written;
+	bio_set_endio(bio, super_written);
 	bio->bi_rw = rw;
 
 	atomic_inc(&mddev->pending_writes);
@@ -459,7 +459,7 @@ void md_super_write(mddev_t *mddev, mdk_rdev_t *rdev,
 		rw |= (1<<BIO_RW_BARRIER);
 		rbio = bio_clone(bio, GFP_NOIO);
 		rbio->bi_private = bio;
-		rbio->bi_end_io = super_written_barrier;
+		bio_set_endio(rbio, super_written_barrier);
 		submit_bio(rw, rbio);
 	} else
 		submit_bio(rw, bio);
@@ -512,7 +512,7 @@ int sync_page_io(struct block_device *bdev, sector_t sector, int size,
 	bio_add_page(bio, page, size, 0);
 	init_completion(&event);
 	bio->bi_private = &event;
-	bio->bi_end_io = bi_complete;
+	bio_set_endio(bio, bi_complete);
 	submit_bio(rw, bio);
 	wait_for_completion(&event);
 
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 1e2af43..7b3953e 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -179,7 +179,7 @@ static int multipath_make_request (struct request_queue *q, struct bio * bio)
 	mp_bh->bio.bi_sector += multipath->rdev->data_offset;
 	mp_bh->bio.bi_bdev = multipath->rdev->bdev;
 	mp_bh->bio.bi_rw |= (1 << BIO_RW_FAILFAST);
-	mp_bh->bio.bi_end_io = multipath_end_request;
+	bio_set_endio(&mp_bh->bio, multipath_end_request);
 	mp_bh->bio.bi_private = mp_bh;
 	generic_make_request(&mp_bh->bio);
 	return 0;
@@ -425,7 +425,7 @@ static void multipathd (mddev_t *mddev)
 			bio->bi_sector += conf->multipaths[mp_bh->path].rdev->data_offset;
 			bio->bi_bdev = conf->multipaths[mp_bh->path].rdev->bdev;
 			bio->bi_rw |= (1 << BIO_RW_FAILFAST);
-			bio->bi_end_io = multipath_end_request;
+			bio_set_endio(bio, multipath_end_request);
 			bio->bi_private = mp_bh;
 			generic_make_request(bio);
 		}
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f33a729..63ffaaf 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -197,7 +197,7 @@ static void put_buf(r1bio_t *r1_bio)
 
 	for (i=0; i<conf->raid_disks; i++) {
 		struct bio *bio = r1_bio->bios[i];
-		if (bio->bi_end_io)
+		if (bio_get_endio(bio))
 			rdev_dec_pending(conf->mirrors[i].rdev, r1_bio->mddev);
 	}
 
@@ -839,7 +839,7 @@ static int make_request(struct request_queue *q, struct bio * bio)
 
 		read_bio->bi_sector = r1_bio->sector + mirror->rdev->data_offset;
 		read_bio->bi_bdev = mirror->rdev->bdev;
-		read_bio->bi_end_io = raid1_end_read_request;
+		bio_set_endio(read_bio, raid1_end_read_request);
 		read_bio->bi_rw = READ | do_sync;
 		read_bio->bi_private = r1_bio;
 
@@ -910,7 +910,7 @@ static int make_request(struct request_queue *q, struct bio * bio)
 
 		mbio->bi_sector	= r1_bio->sector + conf->mirrors[i].rdev->data_offset;
 		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
-		mbio->bi_end_io	= raid1_end_write_request;
+		bio_set_endio(mbio, raid1_end_write_request;)
 		mbio->bi_rw = WRITE | do_barriers | do_sync;
 		mbio->bi_private = r1_bio;
 
@@ -1224,7 +1224,7 @@ static void sync_request_write(mddev_t *mddev, r1bio_t *r1_bio)
 		int primary;
 		if (!test_bit(R1BIO_Uptodate, &r1_bio->state)) {
 			for (i=0; i<mddev->raid_disks; i++)
-				if (r1_bio->bios[i]->bi_end_io == end_sync_read)
+				if (bio_get_endio(r1_bio->bios[i]) == end_sync_read)
 					md_error(mddev, conf->mirrors[i].rdev);
 
 			md_done_sync(mddev, r1_bio->sectors, 1);
@@ -1232,15 +1232,15 @@ static void sync_request_write(mddev_t *mddev, r1bio_t *r1_bio)
 			return;
 		}
 		for (primary=0; primary<mddev->raid_disks; primary++)
-			if (r1_bio->bios[primary]->bi_end_io == end_sync_read &&
+			if (bio_get_endio(r1_bio->bios[primary]) == end_sync_read &&
 			    test_bit(BIO_UPTODATE, &r1_bio->bios[primary]->bi_flags)) {
-				r1_bio->bios[primary]->bi_end_io = NULL;
+				bio_set_endio(r1_bio->bios[primary], NULL);
 				rdev_dec_pending(conf->mirrors[primary].rdev, mddev);
 				break;
 			}
 		r1_bio->read_disk = primary;
 		for (i=0; i<mddev->raid_disks; i++)
-			if (r1_bio->bios[i]->bi_end_io == end_sync_read) {
+			if (bio_set_endio(r1_bio->bios[i], end_sync_read)) {
 				int j;
 				int vcnt = r1_bio->sectors >> (PAGE_SHIFT- 9);
 				struct bio *pbio = r1_bio->bios[primary];
@@ -1261,7 +1261,7 @@ static void sync_request_write(mddev_t *mddev, r1bio_t *r1_bio)
 				if (j >= 0)
 					mddev->resync_mismatches += r1_bio->sectors;
 				if (j < 0 || test_bit(MD_RECOVERY_CHECK, &mddev->recovery)) {
-					sbio->bi_end_io = NULL;
+					bio_set_endio(sbio, NULL);
 					rdev_dec_pending(conf->mirrors[i].rdev, mddev);
 				} else {
 					/* fixup the bio for reuse */
@@ -1309,7 +1309,7 @@ static void sync_request_write(mddev_t *mddev, r1bio_t *r1_bio)
 			if (s > (PAGE_SIZE>>9))
 				s = PAGE_SIZE >> 9;
 			do {
-				if (r1_bio->bios[d]->bi_end_io == end_sync_read) {
+				if (bio_get_endio(r1_bio->bios[d]) == end_sync_read) {
 					/* No rcu protection needed here devices
 					 * can only be removed when no resync is
 					 * active, and resync is currently active
@@ -1337,7 +1337,7 @@ static void sync_request_write(mddev_t *mddev, r1bio_t *r1_bio)
 					if (d == 0)
 						d = conf->raid_disks;
 					d--;
-					if (r1_bio->bios[d]->bi_end_io != end_sync_read)
+					if (bio_get_endio(r1_bio->bios[d]) != end_sync_read)
 						continue;
 					rdev = conf->mirrors[d].rdev;
 					atomic_add(s, &rdev->corrected_errors);
@@ -1353,7 +1353,7 @@ static void sync_request_write(mddev_t *mddev, r1bio_t *r1_bio)
 					if (d == 0)
 						d = conf->raid_disks;
 					d--;
-					if (r1_bio->bios[d]->bi_end_io != end_sync_read)
+					if (bio_get_endio(r1_bio->bios[d]) != end_sync_read)
 						continue;
 					rdev = conf->mirrors[d].rdev;
 					if (sync_page_io(rdev->bdev,
@@ -1387,14 +1387,14 @@ static void sync_request_write(mddev_t *mddev, r1bio_t *r1_bio)
 	atomic_set(&r1_bio->remaining, 1);
 	for (i = 0; i < disks ; i++) {
 		wbio = r1_bio->bios[i];
-		if (wbio->bi_end_io == NULL ||
-		    (wbio->bi_end_io == end_sync_read &&
+		if (bio_get_endio(wbio) == NULL ||
+		    (bio_get_endio(wbio) == end_sync_read &&
 		     (i == r1_bio->read_disk ||
 		      !test_bit(MD_RECOVERY_SYNC, &mddev->recovery))))
 			continue;
 
 		wbio->bi_rw = WRITE;
-		wbio->bi_end_io = end_sync_write;
+		bio_set_endio(wbio, end_sync_write);
 		atomic_inc(&r1_bio->remaining);
 		md_sync_acct(conf->mirrors[i].rdev->bdev, wbio->bi_size >> 9);
 
@@ -1580,7 +1580,7 @@ static void raid1d(mddev_t *mddev)
 					bio->bi_sector = r1_bio->sector +
 						conf->mirrors[i].rdev->data_offset;
 					bio->bi_bdev = conf->mirrors[i].rdev->bdev;
-					bio->bi_end_io = raid1_end_write_request;
+					bio_set_endio(bio, raid1_end_write_request);
 					bio->bi_rw = WRITE | do_sync;
 					bio->bi_private = r1_bio;
 					r1_bio->bios[i] = bio;
@@ -1628,7 +1628,7 @@ static void raid1d(mddev_t *mddev)
 					       (unsigned long long)r1_bio->sector);
 				bio->bi_sector = r1_bio->sector + rdev->data_offset;
 				bio->bi_bdev = rdev->bdev;
-				bio->bi_end_io = raid1_end_read_request;
+				bio_set_endio(bio, raid1_end_read_request);
 				bio->bi_rw = READ | do_sync;
 				bio->bi_private = r1_bio;
 				unplug = 1;
@@ -1763,7 +1763,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 		bio->bi_phys_segments = 0;
 		bio->bi_hw_segments = 0;
 		bio->bi_size = 0;
-		bio->bi_end_io = NULL;
+		bio_set_endio(bio, NULL);
 		bio->bi_private = NULL;
 
 		rdev = rcu_dereference(conf->mirrors[i].rdev);
@@ -1773,12 +1773,12 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 			continue;
 		} else if (!test_bit(In_sync, &rdev->flags)) {
 			bio->bi_rw = WRITE;
-			bio->bi_end_io = end_sync_write;
+			bio_set_endio(bio, end_sync_write);
 			write_targets ++;
 		} else {
 			/* may need to read from here */
 			bio->bi_rw = READ;
-			bio->bi_end_io = end_sync_read;
+			bio_set_endio(bio, end_sync_read);
 			if (test_bit(WriteMostly, &rdev->flags)) {
 				if (wonly < 0)
 					wonly = i;
@@ -1834,7 +1834,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 
 		for (i=0 ; i < conf->raid_disks; i++) {
 			bio = r1_bio->bios[i];
-			if (bio->bi_end_io) {
+			if (bio_get_endio(bio)) {
 				page = bio->bi_io_vec[bio->bi_vcnt].bv_page;
 				if (bio_add_page(bio, page, len, 0) == 0) {
 					/* stop here */
@@ -1842,7 +1842,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 					while (i > 0) {
 						i--;
 						bio = r1_bio->bios[i];
-						if (bio->bi_end_io==NULL)
+						if (bio_get_endio(bio) == NULL)
 							continue;
 						/* remove last page from this bio */
 						bio->bi_vcnt--;
@@ -1867,7 +1867,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 		atomic_set(&r1_bio->remaining, read_targets);
 		for (i=0; i<conf->raid_disks; i++) {
 			bio = r1_bio->bios[i];
-			if (bio->bi_end_io == end_sync_read) {
+			if (bio_get_endio(bio) == end_sync_read) {
 				md_sync_acct(bio->bi_bdev, nr_sectors);
 				generic_make_request(bio);
 			}
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 4e53792..1d1aee0 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -863,7 +863,7 @@ static int make_request(struct request_queue *q, struct bio * bio)
 		read_bio->bi_sector = r10_bio->devs[slot].addr +
 			mirror->rdev->data_offset;
 		read_bio->bi_bdev = mirror->rdev->bdev;
-		read_bio->bi_end_io = raid10_end_read_request;
+		bio_set_endio(read_bio, raid10_end_read_request);
 		read_bio->bi_rw = READ | do_sync;
 		read_bio->bi_private = r10_bio;
 
@@ -909,7 +909,7 @@ static int make_request(struct request_queue *q, struct bio * bio)
 		mbio->bi_sector	= r10_bio->devs[i].addr+
 			conf->mirrors[d].rdev->data_offset;
 		mbio->bi_bdev = conf->mirrors[d].rdev->bdev;
-		mbio->bi_end_io	= raid10_end_write_request;
+		bio_set_endio(mbio, raid10_end_write_request);
 		mbio->bi_rw = WRITE | do_sync;
 		mbio->bi_private = r10_bio;
 
@@ -1273,7 +1273,7 @@ static void sync_request_write(mddev_t *mddev, r10bio_t *r10_bio)
 
 		tbio = r10_bio->devs[i].bio;
 
-		if (tbio->bi_end_io != end_sync_read)
+		if (bio_get_endio(tbio) != end_sync_read)
 			continue;
 		if (i == first)
 			continue;
@@ -1320,7 +1320,7 @@ static void sync_request_write(mddev_t *mddev, r10bio_t *r10_bio)
 			       page_address(fbio->bi_io_vec[j].bv_page),
 			       PAGE_SIZE);
 		}
-		tbio->bi_end_io = end_sync_write;
+		bio_set_endio(tbio, end_sync_write);
 
 		d = r10_bio->devs[i].devnum;
 		atomic_inc(&conf->mirrors[d].rdev->nr_pending);
@@ -1588,7 +1588,7 @@ static void raid10d(mddev_t *mddev)
 				bio->bi_bdev = rdev->bdev;
 				bio->bi_rw = READ | do_sync;
 				bio->bi_private = r10_bio;
-				bio->bi_end_io = raid10_end_read_request;
+				bio_set_endio(bio, raid10_end_read_request);
 				unplug = 1;
 				generic_make_request(bio);
 			}
@@ -1796,7 +1796,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 						bio->bi_next = biolist;
 						biolist = bio;
 						bio->bi_private = r10_bio;
-						bio->bi_end_io = end_sync_read;
+						bio_set_endio(bio, end_sync_read);
 						bio->bi_rw = READ;
 						bio->bi_sector = r10_bio->devs[j].addr +
 							conf->mirrors[d].rdev->data_offset;
@@ -1813,7 +1813,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 						bio->bi_next = biolist;
 						biolist = bio;
 						bio->bi_private = r10_bio;
-						bio->bi_end_io = end_sync_write;
+						bio_set_endio(bio, end_sync_write);
 						bio->bi_rw = WRITE;
 						bio->bi_sector = r10_bio->devs[k].addr +
 							conf->mirrors[i].rdev->data_offset;
@@ -1873,7 +1873,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 		for (i=0; i<conf->copies; i++) {
 			int d = r10_bio->devs[i].devnum;
 			bio = r10_bio->devs[i].bio;
-			bio->bi_end_io = NULL;
+			bio_set_endio(bio, NULL);
 			clear_bit(BIO_UPTODATE, &bio->bi_flags);
 			if (conf->mirrors[d].rdev == NULL ||
 			    test_bit(Faulty, &conf->mirrors[d].rdev->flags))
@@ -1883,7 +1883,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 			bio->bi_next = biolist;
 			biolist = bio;
 			bio->bi_private = r10_bio;
-			bio->bi_end_io = end_sync_read;
+			bio_set_endio(bio, end_sync_read);
 			bio->bi_rw = READ;
 			bio->bi_sector = r10_bio->devs[i].addr +
 				conf->mirrors[d].rdev->data_offset;
@@ -1894,7 +1894,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 		if (count < 2) {
 			for (i=0; i<conf->copies; i++) {
 				int d = r10_bio->devs[i].devnum;
-				if (r10_bio->devs[i].bio->bi_end_io)
+				if (bio_get_endio(&r10_bio->devs[i].bio))
 					rdev_dec_pending(conf->mirrors[d].rdev, mddev);
 			}
 			put_buf(r10_bio);
@@ -1906,7 +1906,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 	for (bio = biolist; bio ; bio=bio->bi_next) {
 
 		bio->bi_flags &= ~(BIO_POOL_MASK - 1);
-		if (bio->bi_end_io)
+		if (bio_get_endio(bio))
 			bio->bi_flags |= 1 << BIO_UPTODATE;
 		bio->bi_vcnt = 0;
 		bio->bi_idx = 0;
@@ -1956,7 +1956,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 		r10_bio = bio->bi_private;
 		r10_bio->sectors = nr_sectors;
 
-		if (bio->bi_end_io == end_sync_read) {
+		if (bio_get_endio(bio) == end_sync_read) {
 			md_sync_acct(bio->bi_bdev, nr_sectors);
 			generic_make_request(bio);
 		}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3085228..9fe55db 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -113,9 +113,9 @@ static void return_io(struct bio *return_bi)
 		return_bi = bi->bi_next;
 		bi->bi_next = NULL;
 		bi->bi_size = 0;
-		bi->bi_end_io(bi, bytes,
+		(bio_get_endio(bi))(bi, bytes,
 			      test_bit(BIO_UPTODATE, &bi->bi_flags)
-			        ? 0 : -EIO);
+			        ? 0 : -EIO); // use bio_endio!
 		bi = return_bi;
 	}
 }
@@ -414,9 +414,9 @@ static void ops_run_io(struct stripe_head *sh)
 
 		bi->bi_rw = rw;
 		if (rw == WRITE)
-			bi->bi_end_io = raid5_end_write_request;
+			bio_set_endio(bi, raid5_end_write_request);
 		else
-			bi->bi_end_io = raid5_end_read_request;
+			bio_set_endio(bi, raid5_end_read_request);
 
 		rcu_read_lock();
 		rdev = rcu_dereference(conf->disks[i].rdev);
@@ -3101,9 +3101,9 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 
 		bi->bi_rw = rw;
 		if (rw == WRITE)
-			bi->bi_end_io = raid5_end_write_request;
+			bio_set_endio(bi, raid5_end_write_request);
 		else
-			bi->bi_end_io = raid5_end_read_request;
+			bio_set_endio(bi, raid5_end_read_request);
 
 		rcu_read_lock();
 		rdev = rcu_dereference(conf->disks[i].rdev);
@@ -3433,7 +3433,7 @@ static int chunk_aligned_read(struct request_queue *q, struct bio * raid_bio)
 	 *   set bi_end_io to a new function, and set bi_private to the
 	 *     original bio.
 	 */
-	align_bi->bi_end_io  = raid5_align_endio;
+	bio_set_endio(align_bi, raid5_align_endio);
 	align_bi->bi_private = raid_bio;
 	/*
 	 *	compute position
@@ -3612,7 +3612,7 @@ static int make_request(struct request_queue *q, struct bio * bi)
 		if ( rw == WRITE )
 			md_write_end(mddev);
 		bi->bi_size = 0;
-		bi->bi_end_io(bi, bytes,
+		(bio_get_endio(bi))((bi, bytes,
 			      test_bit(BIO_UPTODATE, &bi->bi_flags)
 			        ? 0 : -EIO);
 	}
@@ -3893,7 +3893,7 @@ static int  retry_aligned_read(raid5_conf_t *conf, struct bio *raid_bio)
 		int bytes = raid_bio->bi_size;
 
 		raid_bio->bi_size = 0;
-		raid_bio->bi_end_io(raid_bio, bytes,
+		(bio_get_endio(raid_bio))(raid_bio, bytes,
 			      test_bit(BIO_UPTODATE, &raid_bio->bi_flags)
 			        ? 0 : -EIO);
 	}
diff --git a/drivers/s390/block/xpram.c b/drivers/s390/block/xpram.c
index 354a060..c7a3c82 100644
--- a/drivers/s390/block/xpram.c
+++ b/drivers/s390/block/xpram.c
@@ -232,7 +232,7 @@ static int xpram_make_request(struct request_queue *q, struct bio *bio)
 	set_bit(BIO_UPTODATE, &bio->bi_flags);
 	bytes = bio->bi_size;
 	bio->bi_size = 0;
-	bio->bi_end_io(bio, bytes, 0);
+	(bio_get_endio(bio))(bio, bytes, 0); // use bio_endio!
 	return 0;
 fail:
 	bio_io_error(bio, bio->bi_size);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a417a6f..1c841a5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -324,7 +324,7 @@ static int scsi_req_map_sg(struct request *rq, struct scatterlist *sgl,
 					err = -ENOMEM;
 					goto free_bios;
 				}
-				bio->bi_end_io = scsi_bi_endio;
+				bio_set_endio(bio, scsi_bi_endio);
 			}
 
 			if (bio_add_pc_page(q, bio, page, bytes, off) !=
diff --git a/fs/bio.c b/fs/bio.c
index 29a44c1..29cdd8b 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -841,7 +841,7 @@ static struct bio *__bio_map_kern(struct request_queue *q, void *data,
 		offset = 0;
 	}
 
-	bio->bi_end_io = bio_map_kern_endio;
+	bio_set_endio(bio, bio_map_kern_endio);
 	return bio;
 }
 
@@ -1011,7 +1011,7 @@ void bio_check_pages_dirty(struct bio *bio)
  *   is the preferred way to end I/O on a bio, it takes care of decrementing
  *   bi_size and clearing BIO_UPTODATE on error. @error is 0 on success, and
  *   and one of the established -Exxxx (-EIO, for instance) error values in
- *   case something went wrong. Noone should call bi_end_io() directly on
+ *   case something went wrong. Noone should call bi_endio() directly on
  *   a bio unless they own it and thus know that it has an end_io function.
  **/
 void bio_endio(struct bio *bio, unsigned int bytes_done, int error)
@@ -1028,8 +1028,8 @@ void bio_endio(struct bio *bio, unsigned int bytes_done, int error)
 	bio->bi_size -= bytes_done;
 	bio->bi_sector += (bytes_done >> 9);
 
-	if (bio->bi_end_io)
-		bio->bi_end_io(bio, bytes_done, error);
+	if (bio_get_endio(bio))
+		(bio_get_endio(bio))(bio, bytes_done, error);
 }
 
 void bio_pair_release(struct bio_pair *bp)
@@ -1106,8 +1106,8 @@ struct bio_pair *bio_split(struct bio *bi, mempool_t *pool, int first_sectors)
 	bp->bio1.bi_max_vecs = 1;
 	bp->bio2.bi_max_vecs = 1;
 
-	bp->bio1.bi_end_io = bio_pair_end_1;
-	bp->bio2.bi_end_io = bio_pair_end_2;
+	bio_set_endio(&bp->bio1, bio_pair_end_1);
+	bio_set_endio(&bp->bio2, bio_pair_end_2);
 
 	bp->bio1.bi_private = bi;
 	bp->bio2.bi_private = pool;
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 2980eab..62c0711 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -293,7 +293,7 @@ blkdev_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 		/* bio_alloc should not fail with GFP_KERNEL flag */
 		bio = bio_alloc(GFP_KERNEL, nvec);
 		bio->bi_bdev = I_BDEV(inode);
-		bio->bi_end_io = blk_end_aio;
+		bio_set_endio(bio, blk_end_aio);
 		bio->bi_private = iocb;
 		bio->bi_sector = pos >> blkbits;
 same_bio:
diff --git a/fs/buffer.c b/fs/buffer.c
index 0e5ec37..e4f8738 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2686,7 +2686,7 @@ int submit_bh(int rw, struct buffer_head * bh)
 	bio->bi_idx = 0;
 	bio->bi_size = bh->b_size;
 
-	bio->bi_end_io = end_bio_bh_io_sync;
+	bio_set_endio(bio, end_bio_bh_io_sync);
 	bio->bi_private = bh;
 
 	bio_get(bio);
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 901dc55..43c5b76 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -328,9 +328,9 @@ dio_bio_alloc(struct dio *dio, struct block_device *bdev,
 	bio->bi_bdev = bdev;
 	bio->bi_sector = first_sector;
 	if (dio->is_async)
-		bio->bi_end_io = dio_bio_end_aio;
+		bio_set_endio(bio, dio_bio_end_aio);
 	else
-		bio->bi_end_io = dio_bio_end_io;
+		bio_set_endio(bio, dio_bio_end_io);
 
 	dio->bio = bio;
 	return 0;
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index f916b97..e32f69a 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -237,8 +237,7 @@ int gfs2_read_super(struct gfs2_sbd *sdp, sector_t sector)
 	bio->bi_sector = sector * (sb->s_blocksize >> 9);
 	bio->bi_bdev = sb->s_bdev;
 	bio_add_page(bio, page, PAGE_SIZE, 0);
-
-	bio->bi_end_io = end_bio_io_page;
+	bio_set_endio(bio, end_bio_io_page);
 	bio->bi_private = page;
 	submit_bio(READ_SYNC | (1 << BIO_RW_META), bio);
 	wait_on_page_locked(page);
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index de3e4a5..d8e947a 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -2015,7 +2015,7 @@ static int lbmRead(struct jfs_log * log, int pn, struct lbuf ** bpp)
 	bio->bi_idx = 0;
 	bio->bi_size = LOGPSIZE;
 
-	bio->bi_end_io = lbmIODone;
+	bio_set_endio(bio, lbmIODone);
 	bio->bi_private = bp;
 	submit_bio(READ_SYNC, bio);
 
@@ -2156,7 +2156,7 @@ static void lbmStartIO(struct lbuf * bp)
 	bio->bi_idx = 0;
 	bio->bi_size = LOGPSIZE;
 
-	bio->bi_end_io = lbmIODone;
+	bio_set_endio(bio, lbmIODone);
 	bio->bi_private = bp;
 
 	/* check if journaling to disk has been disabled */
diff --git a/fs/jfs/jfs_metapage.c b/fs/jfs/jfs_metapage.c
index 62e96be..6924c4c 100644
--- a/fs/jfs/jfs_metapage.c
+++ b/fs/jfs/jfs_metapage.c
@@ -443,7 +443,7 @@ static int metapage_writepage(struct page *page, struct writeback_control *wbc)
 		bio = bio_alloc(GFP_NOFS, 1);
 		bio->bi_bdev = inode->i_sb->s_bdev;
 		bio->bi_sector = pblock << (inode->i_blkbits - 9);
-		bio->bi_end_io = metapage_write_end_io;
+		bio_set_endio(bio, metapage_write_end_io);
 		bio->bi_private = page;
 
 		/* Don't call bio_add_page yet, we may add to this vec */
@@ -513,7 +513,7 @@ static int metapage_readpage(struct file *fp, struct page *page)
 			bio = bio_alloc(GFP_NOFS, 1);
 			bio->bi_bdev = inode->i_sb->s_bdev;
 			bio->bi_sector = pblock << (inode->i_blkbits - 9);
-			bio->bi_end_io = metapage_read_end_io;
+			bio_set_endio(bio, metapage_read_end_io);
 			bio->bi_private = page;
 			len = xlen << inode->i_blkbits;
 			offset = block_offset << inode->i_blkbits;
diff --git a/fs/mpage.c b/fs/mpage.c
index c1698f2..b04ea49 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -92,9 +92,9 @@ static int mpage_end_io_write(struct bio *bio, unsigned int bytes_done, int err)
 
 static struct bio *mpage_bio_submit(int rw, struct bio *bio)
 {
-	bio->bi_end_io = mpage_end_io_read;
+	bio_set_endio(bio, mpage_end_io_read);
 	if (rw == WRITE)
-		bio->bi_end_io = mpage_end_io_write;
+		bio_set_endio(bio, mpage_end_io_write);
 	submit_bio(rw, bio);
 	return NULL;
 }
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 2bd7f78..1ea9ea3 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -265,7 +265,7 @@ static struct bio *o2hb_setup_one_bio(struct o2hb_region *reg,
 	bio->bi_sector = (reg->hr_start_block + cs) << (bits - 9);
 	bio->bi_bdev = reg->hr_bdev;
 	bio->bi_private = wc;
-	bio->bi_end_io = o2hb_bio_end_io;
+	bio_set_endio(bio, o2hb_bio_end_io);
 
 	vec_start = (cs << bits) % PAGE_CACHE_SIZE;
 	while(cs < max_slots) {
diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 5f152f6..fcb5b09 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -338,8 +338,8 @@ xfs_end_bio(
 	ioend->io_error = test_bit(BIO_UPTODATE, &bio->bi_flags) ? 0 : error;
 
 	/* Toss bio and pass work off to an xfsdatad thread */
-	bio->bi_private = NULL;
-	bio->bi_end_io = NULL;
+	bio->bi_private = NULL; // why?
+	bio_set_endio(bio, NULL); // why?
 	bio_put(bio);
 
 	xfs_finish_ioend(ioend, 0);
@@ -354,7 +354,7 @@ xfs_submit_ioend_bio(
 	atomic_inc(&ioend->io_remaining);
 
 	bio->bi_private = ioend;
-	bio->bi_end_io = xfs_end_bio;
+	bio_set_endio(bio, xfs_end_bio);
 
 	submit_bio(WRITE, bio);
 	ASSERT(!bio_flagged(bio, BIO_EOPNOTSUPP));
diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 386fbff..2f5f9fd 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1198,7 +1198,7 @@ _xfs_buf_ioapply(
 
 		bio->bi_bdev = bp->b_target->bt_bdev;
 		bio->bi_sector = sector - (offset >> BBSHIFT);
-		bio->bi_end_io = xfs_buf_bio_end_io;
+		bio_set_endio(bio, xfs_buf_bio_end_io);
 		bio->bi_private = bp;
 
 		bio_add_page(bio, bp->b_pages[0], PAGE_CACHE_SIZE, 0);
@@ -1236,7 +1236,7 @@ next_chunk:
 	bio = bio_alloc(GFP_NOIO, nr_pages);
 	bio->bi_bdev = bp->b_target->bt_bdev;
 	bio->bi_sector = sector;
-	bio->bi_end_io = xfs_buf_bio_end_io;
+	bio_set_endio(bio, xfs_buf_bio_end_io);
 	bio->bi_private = bp;
 
 	for (; size && nr_pages; nr_pages--, map_i++) {
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 1ddef34..4c8d7a0 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -108,7 +108,7 @@ struct bio {
 
 	struct bio_vec		*bi_io_vec;	/* the actual vec list */
 
-	bio_end_io_t		*bi_end_io;
+	bio_end_io_t		*bi_endio;
 	atomic_t		bi_cnt;		/* pin count */
 
 	void			*bi_private;
@@ -184,6 +184,16 @@ struct bio {
 #define bio_rw_ahead(bio)	((bio)->bi_rw & (1 << BIO_RW_AHEAD))
 #define bio_rw_meta(bio)	((bio)->bi_rw & (1 << BIO_RW_META))
 
+static inline void bio_set_endio(struct bio *bio, bio_end_io_t *endio)
+{
+	bio->bi_endio = endio;
+}
+
+static inline bio_end_io_t *bio_get_endio(struct bio *bio)
+{
+	return bio->bi_endio;
+}
+
 /*
  * will die
  */
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 917aba1..5b2f33a 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -70,7 +70,7 @@ static int submit(int rw, pgoff_t page_off, struct page *page,
 		return -ENOMEM;
 	bio->bi_sector = page_off * (PAGE_SIZE >> 9);
 	bio->bi_bdev = resume_bdev;
-	bio->bi_end_io = end_swap_bio_read;
+	bio_set_endio(bio, end_swap_bio_read);
 
 	if (bio_add_page(bio, page, PAGE_SIZE, 0) < PAGE_SIZE) {
 		printk("swsusp: ERROR: adding page to bio at %ld\n", page_off);
diff --git a/mm/bounce.c b/mm/bounce.c
index 179fe38..3c0fbfc 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -262,13 +262,13 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 	bio->bi_size = (*bio_orig)->bi_size;
 
 	if (pool == page_pool) {
-		bio->bi_end_io = bounce_end_io_write;
+		bio_set_endio(bio, bounce_end_io_write);
 		if (rw == READ)
-			bio->bi_end_io = bounce_end_io_read;
+			bio_set_endio(bio, bounce_end_io_read);
 	} else {
-		bio->bi_end_io = bounce_end_io_write_isa;
+		bio_set_endio(bio, bounce_end_io_write_isa);
 		if (rw == READ)
-			bio->bi_end_io = bounce_end_io_read_isa;
+			bio_set_endio(bio, bounce_end_io_read_isa);
 	}
 
 	bio->bi_private = *bio_orig;
diff --git a/mm/page_io.c b/mm/page_io.c
index dbffec0..f1aaee0 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -39,7 +39,7 @@ static struct bio *get_swap_bio(gfp_t gfp_flags, pgoff_t index,
 		bio->bi_vcnt = 1;
 		bio->bi_idx = 0;
 		bio->bi_size = PAGE_SIZE;
-		bio->bi_end_io = end_io;
+		bio_set_endio(bio, end_io);
 	}
 	return bio;
 }
-- 
1.5.2.5


--------------000807090508060505080406--
