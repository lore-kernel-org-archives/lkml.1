Return-Path: <linux-kernel-owner+w=401wt.eu-S1422773AbXCGRxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422773AbXCGRxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422746AbXCGROO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:14:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42855 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422779AbXCGROD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:14:03 -0500
Message-Id: <20070307171212.695749800@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:10:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       "Kai" <epimetreus@fastmail.fm>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jens Axboe <jens.axboe@oracle.com>, Neil Brown <neilb@suse.de>
Subject: [patch 017/101] Fix various bugs with aligned reads in RAID5.
Content-Disposition: inline; filename=fix-various-bugs-with-aligned-reads-in-raid5.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Brown <neilb@suse.de>

Fix various bugs with aligned reads in RAID5.

It is possible for raid5 to be sent a bio that is too big
for an underlying device.  So if it is a READ that we
pass stright down to a device, it will fail and confuse
RAID5.

So in 'chunk_aligned_read' we check that the bio fits within the
parameters for the target device and if it doesn't fit, fall back
on reading through the stripe cache and making lots of one-page
requests.

Note that this is the earliest time we can check against the device
because earlier we don't have a lock on the device, so it could change
underneath us.

Also, the code for handling a retry through the cache when a read
fails has not been tested and was badly broken.  This patch fixes that
code.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid5.c |   42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

--- linux-2.6.20.1.orig/drivers/md/raid5.c
+++ linux-2.6.20.1/drivers/md/raid5.c
@@ -2620,7 +2620,7 @@ static struct bio *remove_bio_from_retry
 	}
 	bi = conf->retry_read_aligned_list;
 	if(bi) {
-		conf->retry_read_aligned = bi->bi_next;
+		conf->retry_read_aligned_list = bi->bi_next;
 		bi->bi_next = NULL;
 		bi->bi_phys_segments = 1; /* biased count of active stripes */
 		bi->bi_hw_segments = 0; /* count of processed stripes */
@@ -2669,6 +2669,27 @@ static int raid5_align_endio(struct bio 
 	return 0;
 }
 
+static int bio_fits_rdev(struct bio *bi)
+{
+	request_queue_t *q = bdev_get_queue(bi->bi_bdev);
+
+	if ((bi->bi_size>>9) > q->max_sectors)
+		return 0;
+	blk_recount_segments(q, bi);
+	if (bi->bi_phys_segments > q->max_phys_segments ||
+	    bi->bi_hw_segments > q->max_hw_segments)
+		return 0;
+
+	if (q->merge_bvec_fn)
+		/* it's too hard to apply the merge_bvec_fn at this stage,
+		 * just just give up
+		 */
+		return 0;
+
+	return 1;
+}
+
+
 static int chunk_aligned_read(request_queue_t *q, struct bio * raid_bio)
 {
 	mddev_t *mddev = q->queuedata;
@@ -2715,6 +2736,13 @@ static int chunk_aligned_read(request_qu
 		align_bi->bi_flags &= ~(1 << BIO_SEG_VALID);
 		align_bi->bi_sector += rdev->data_offset;
 
+		if (!bio_fits_rdev(align_bi)) {
+			/* too big in some way */
+			bio_put(align_bi);
+			rdev_dec_pending(rdev, mddev);
+			return 0;
+		}
+
 		spin_lock_irq(&conf->device_lock);
 		wait_event_lock_irq(conf->wait_for_stripe,
 				    conf->quiesce == 0,
@@ -3107,7 +3135,9 @@ static int  retry_aligned_read(raid5_con
 	last_sector = raid_bio->bi_sector + (raid_bio->bi_size>>9);
 
 	for (; logical_sector < last_sector;
-	     logical_sector += STRIPE_SECTORS, scnt++) {
+	     logical_sector += STRIPE_SECTORS,
+		     sector += STRIPE_SECTORS,
+		     scnt++) {
 
 		if (scnt < raid_bio->bi_hw_segments)
 			/* already done this stripe */
@@ -3123,7 +3153,13 @@ static int  retry_aligned_read(raid5_con
 		}
 
 		set_bit(R5_ReadError, &sh->dev[dd_idx].flags);
-		add_stripe_bio(sh, raid_bio, dd_idx, 0);
+		if (!add_stripe_bio(sh, raid_bio, dd_idx, 0)) {
+			release_stripe(sh);
+			raid_bio->bi_hw_segments = scnt;
+			conf->retry_read_aligned = raid_bio;
+			return handled;
+		}
+
 		handle_stripe(sh, NULL);
 		release_stripe(sh);
 		handled++;

--
