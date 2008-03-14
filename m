Return-Path: <linux-kernel-owner+w=401wt.eu-S1758149AbYCNOF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbYCNOF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 10:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757987AbYCNOFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 10:05:46 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:46907 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757980AbYCNOFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 10:05:45 -0400
Message-ID: <47DA8636.5020002@hp.com>
Date: Fri, 14 Mar 2008 10:05:42 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: Daniel Phillips <phillips@phunq.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Stacking bio support - patch 4/4 for 2.6.23.17 (stable)
References: <200803110352.41479.phillips@phunq.net> <47DA84B7.1000409@hp.com>
In-Reply-To: <47DA84B7.1000409@hp.com>
Content-Type: multipart/mixed;
 boundary="------------050100020002040606090801"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050100020002040606090801
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



--------------050100020002040606090801
Content-Type: text/x-patch;
 name="0004-Fixed-compilation-bugs.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0004-Fixed-compilation-bugs.patch"

>From 278ee2744eddfe67743ed3967bec3f9b773d9015 Mon Sep 17 00:00:00 2001
From: Alan D. Brunelle <alan.brunelle@hp.com>
Date: Fri, 14 Mar 2008 09:46:33 -0400
Subject: [PATCH] Fixed compilation bugs


---
 drivers/md/raid1.c |    4 ++--
 drivers/md/raid5.c |    6 +++---
 fs/bio.c           |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 63ffaaf..ce6b576 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -910,7 +910,7 @@ static int make_request(struct request_queue *q, struct bio * bio)
 
 		mbio->bi_sector	= r1_bio->sector + conf->mirrors[i].rdev->data_offset;
 		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
-		bio_set_endio(mbio, raid1_end_write_request;)
+		bio_set_endio(mbio, raid1_end_write_request);
 		mbio->bi_rw = WRITE | do_barriers | do_sync;
 		mbio->bi_private = r1_bio;
 
@@ -1240,7 +1240,7 @@ static void sync_request_write(mddev_t *mddev, r1bio_t *r1_bio)
 			}
 		r1_bio->read_disk = primary;
 		for (i=0; i<mddev->raid_disks; i++)
-			if (bio_set_endio(r1_bio->bios[i], end_sync_read)) {
+			if (bio_get_endio(r1_bio->bios[i]) == end_sync_read) {
 				int j;
 				int vcnt = r1_bio->sectors >> (PAGE_SHIFT- 9);
 				struct bio *pbio = r1_bio->bios[primary];
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9fe55db..f83feb8 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3608,13 +3608,13 @@ static int make_request(struct request_queue *q, struct bio * bi)
 	spin_unlock_irq(&conf->device_lock);
 	if (remaining == 0) {
 		int bytes = bi->bi_size;
+		bio_end_io_t *endio = bio_get_endio(bi);
 
 		if ( rw == WRITE )
 			md_write_end(mddev);
 		bi->bi_size = 0;
-		(bio_get_endio(bi))((bi, bytes,
-			      test_bit(BIO_UPTODATE, &bi->bi_flags)
-			        ? 0 : -EIO);
+		endio(bi, bytes,
+			test_bit(BIO_UPTODATE, &bi->bi_flags) ? 0 : -EIO);
 	}
 	return 0;
 }
diff --git a/fs/bio.c b/fs/bio.c
index d57f0f3..0ecd345 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -199,7 +199,7 @@ void bio_init(struct bio *bio)
 	bio->bi_hw_back_size = 0;
 	bio->bi_size = 0;
 	bio->bi_max_vecs = 0;
-	bio->bi_end_io = NULL;
+	bio_set_endio(bio, NULL);
 	atomic_set(&bio->bi_cnt, 1);
 	bio->bi_private = NULL;
 }
-- 
1.5.2.5


--------------050100020002040606090801--
