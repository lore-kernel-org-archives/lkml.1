Return-Path: <linux-kernel-owner+w=401wt.eu-S940754AbXGaCUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940754AbXGaCUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966566AbXGaCQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:16:50 -0400
Received: from ns2.suse.de ([195.135.220.15]:35999 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966580AbXGaCQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:16:48 -0400
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 12:16:34 +1000
Message-Id: <1070731021634.25210@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Subject: [PATCH 009 of 35] Remove overloading of bi_hw_segments in raid5.
References: <20070731112539.22428.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When a read request that bypassed the cache needs to be retried
(due to device failure) we need to process it one stripe_head at a time,
and record where we were up to.
We were recording this in bi_hw_segments.  But as there is only
ever one such request that is being resubmitted, this info can
be stored in ->conf thus not misusing a field in the bio.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c         |   21 ++++++++++++---------
 ./include/linux/raid/raid5.h |    1 +
 2 files changed, 13 insertions(+), 9 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-07-31 11:20:52.000000000 +1000
+++ ./drivers/md/raid5.c	2007-07-31 11:20:53.000000000 +1000
@@ -3857,13 +3857,14 @@ static void add_bio_to_retry(struct bio 
 }
 
 
-static struct bio *remove_bio_from_retry(raid5_conf_t *conf)
+static struct bio *remove_bio_from_retry(raid5_conf_t *conf, int *already_done)
 {
 	struct bio *bi;
 
 	bi = conf->retry_read_aligned;
 	if (bi) {
 		conf->retry_read_aligned = NULL;
+		*already_done = conf->retry_read_aligned_scnt;
 		return bi;
 	}
 	bi = conf->retry_read_aligned_list;
@@ -3871,7 +3872,7 @@ static struct bio *remove_bio_from_retry
 		conf->retry_read_aligned_list = bi->bi_next;
 		bi->bi_next = NULL;
 		atomic_set(&bi->bi_iocnt, 1);
-		bi->bi_hw_segments = 0; /* count of processed stripes */
+		*already_done = 0;
 	}
 
 	return bi;
@@ -4388,14 +4389,15 @@ static inline sector_t sync_request(mdde
 	return STRIPE_SECTORS;
 }
 
-static int  retry_aligned_read(raid5_conf_t *conf, struct bio *raid_bio)
+static int  retry_aligned_read(raid5_conf_t *conf, struct bio *raid_bio,
+			       int start_scnt)
 {
 	/* We may not be able to submit a whole bio at once as there
 	 * may not be enough stripe_heads available.
 	 * We cannot pre-allocate enough stripe_heads as we may need
 	 * more than exist in the cache (if we allow ever large chunks).
 	 * So we do one stripe head at a time and record in
-	 * ->bi_hw_segments how many have been done.
+	 * conf->retry_read_aligned_scnt how many have been done.
 	 *
 	 * We *know* that this entire raid_bio is in one chunk, so
 	 * it will be only one 'dd_idx' and only need one call to raid5_compute_sector.
@@ -4423,7 +4425,7 @@ static int  retry_aligned_read(raid5_con
 		     scnt++) {
 		struct stripe_head *sh;
 
-		if (scnt < raid_bio->bi_hw_segments)
+		if (scnt < start_scnt )
 			/* already done this stripe */
 			continue;
 
@@ -4431,7 +4433,7 @@ static int  retry_aligned_read(raid5_con
 		sh = get_active_stripe(sq, disks, 1);
 		if (!(sq && sh)) {
 			/* failed to get a queue/stripe - must wait */
-			raid_bio->bi_hw_segments = scnt;
+			conf->retry_read_aligned_scnt = scnt;
 			conf->retry_read_aligned = raid_bio;
 			if (sq)
 				release_queue(sq);
@@ -4442,7 +4444,7 @@ static int  retry_aligned_read(raid5_con
 		if (!add_queue_bio(sq, raid_bio, dd_idx, 0)) {
 			release_queue(sq);
 			release_stripe(sh);
-			raid_bio->bi_hw_segments = scnt;
+			conf->retry_read_aligned_scnt = scnt;
 			conf->retry_read_aligned = raid_bio;
 			return handled;
 		}
@@ -4538,6 +4540,7 @@ static void raid5d (mddev_t *mddev)
 	while (1) {
 		struct list_head *first;
 		struct bio *bio;
+		int scnt;
 
 		if (conf->seq_flush != conf->seq_write) {
 			int seq = conf->seq_flush;
@@ -4548,10 +4551,10 @@ static void raid5d (mddev_t *mddev)
 			activate_bit_delay(conf);
 		}
 
-		while ((bio = remove_bio_from_retry(conf))) {
+		while ((bio = remove_bio_from_retry(conf, &scnt))) {
 			int ok;
 			spin_unlock_irq(&conf->device_lock);
-			ok = retry_aligned_read(conf, bio);
+			ok = retry_aligned_read(conf, bio, scnt);
 			spin_lock_irq(&conf->device_lock);
 			if (!ok)
 				break;

diff .prev/include/linux/raid/raid5.h ./include/linux/raid/raid5.h
--- .prev/include/linux/raid/raid5.h	2007-07-31 11:20:15.000000000 +1000
+++ ./include/linux/raid/raid5.h	2007-07-31 11:20:53.000000000 +1000
@@ -362,6 +362,7 @@ struct raid5_private_data {
 	char 			workqueue_name[20];
 
 	struct bio		*retry_read_aligned; /* currently retrying aligned bios   */
+	int			retry_read_aligned_scnt; /* how far through */
 	struct bio		*retry_read_aligned_list; /* aligned bios retry list  */
 	atomic_t		active_aligned_reads;
 	atomic_t		preread_active_queues; /* queues with scheduled
