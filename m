Return-Path: <linux-kernel-owner+w=401wt.eu-S1030563AbXBFX1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030563AbXBFX1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030567AbXBFX1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:27:41 -0500
Received: from mail.suse.de ([195.135.220.2]:56472 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030563AbXBFX1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:27:40 -0500
From: Neil Brown <neilb@suse.de>
To: "Kai" <epimetreus@fastmail.fm>, Andrew Morton <akpm@linux-foundation.org>,
       stable@suse.de, org@suse.de
Date: Wed, 7 Feb 2007 10:26:56 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17865.3776.511594.763544@notabene.brown>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH] Re: Bio device too big | kernel BUG at mm/filemap.c:537!
In-Reply-To: message from Neil Brown on Tuesday February 6
References: <1170734919.15636.1173102761@webmail.messagingengine.com>
	<20070205203750.7be7f772.akpm@linux-foundation.org>
	<17864.4339.925700.626157@notabene.brown>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday February 6, neilb@suse.de wrote:
> 
> This patch should fix the worst of the offences, but I'd like to
> experiment and think a bit more before I submit it to stable.
> And probably test it too - as yet I have only compile and brain
> tested.

Ok, I've experimented and tested and now I know what was causing the
double-unlock.

The following patch is suitable for 2.6.20.1 and mainline.  There is
room for a bit more improvement, but only for performance, not
correctness.  I'll look into that later.

Thanks,
NeilBrown


------------------------------------
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

### Diffstat output
 ./drivers/md/raid5.c |   42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-02-02 14:17:55.000000000 +1100
+++ ./drivers/md/raid5.c	2007-02-06 19:19:01.000000000 +1100
@@ -2570,7 +2570,7 @@ static struct bio *remove_bio_from_retry
 	}
 	bi = conf->retry_read_aligned_list;
 	if(bi) {
-		conf->retry_read_aligned = bi->bi_next;
+		conf->retry_read_aligned_list = bi->bi_next;
 		bi->bi_next = NULL;
 		bi->bi_phys_segments = 1; /* biased count of active stripes */
 		bi->bi_hw_segments = 0; /* count of processed stripes */
@@ -2619,6 +2619,27 @@ static int raid5_align_endio(struct bio 
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
@@ -2665,6 +2686,13 @@ static int chunk_aligned_read(request_qu
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
@@ -3055,7 +3083,9 @@ static int  retry_aligned_read(raid5_con
 	last_sector = raid_bio->bi_sector + (raid_bio->bi_size>>9);
 
 	for (; logical_sector < last_sector;
-	     logical_sector += STRIPE_SECTORS, scnt++) {
+	     logical_sector += STRIPE_SECTORS,
+		     sector += STRIPE_SECTORS,
+		     scnt++) {
 
 		if (scnt < raid_bio->bi_hw_segments)
 			/* already done this stripe */
@@ -3071,7 +3101,13 @@ static int  retry_aligned_read(raid5_con
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

