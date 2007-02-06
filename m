Return-Path: <linux-kernel-owner+w=401wt.eu-S1752769AbXBFFYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbXBFFYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 00:24:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbXBFFYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 00:24:37 -0500
Received: from mail.suse.de ([195.135.220.2]:50194 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbXBFFYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 00:24:36 -0500
From: Neil Brown <neilb@suse.de>
To: "Kai" <epimetreus@fastmail.fm>
Date: Tue, 6 Feb 2007 16:24:03 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17864.4339.925700.626157@notabene.brown>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Bio device too big | kernel BUG at mm/filemap.c:537!
In-Reply-To: message from Andrew Morton on Monday February 5
References: <1170734919.15636.1173102761@webmail.messagingengine.com>
	<20070205203750.7be7f772.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday February 5, akpm@linux-foundation.org wrote:
> On Mon, 05 Feb 2007 20:08:39 -0800 "Kai" <epimetreus@fastmail.fm> wrote:
> 
> You hit two bugs.  It seems that raid5 is submitting BIOs which are larger
> than the device can accept.  In response someone (probably the block layer)
> caused a page to come unlocked twice, possibly by running bi_end_io twice
> against the same BIO.

At least two bugs... there should be a prize for that :-)

Raid5 was definitely submitting a bio that was too big for the device,
and then when it got an error and went to try it the old-fashioned way
(lots of little Bi's through the stripe-cache) it messed up.
Whether that is what trigger the double-unlock I'm not yet sure.

This patch should fix the worst of the offences, but I'd like to
experiment and think a bit more before I submit it to stable.
And probably test it too - as yet I have only compile and brain
tested.

What is the chunk-size on your raid5?  Presumably at least 128k ?

NeilBrown



### Diffstat output
 ./drivers/md/raid5.c |   40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-02-06 16:16:39.000000000 +1100
+++ ./drivers/md/raid5.c	2007-02-06 16:20:57.000000000 +1100
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
