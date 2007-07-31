Return-Path: <linux-kernel-owner+w=401wt.eu-S941397AbXGaC3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941397AbXGaC3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940205AbXGaCSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:18:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36140 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940553AbXGaCSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:18:44 -0400
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 12:18:31 +1000
Message-Id: <1070731021831.25576@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Subject: [PATCH 031 of 35] Use bio_multi_split to fully split bios for pktcdvd.
References: <20070731112539.22428.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


pktcdvd now accepts arbitrarily large bios and will split as necessary.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/block/pktcdvd.c |   44 ++++++++++++--------------------------------
 1 file changed, 12 insertions(+), 32 deletions(-)

diff .prev/drivers/block/pktcdvd.c ./drivers/block/pktcdvd.c
--- .prev/drivers/block/pktcdvd.c	2007-07-31 11:21:13.000000000 +1000
+++ ./drivers/block/pktcdvd.c	2007-07-31 11:21:26.000000000 +1000
@@ -2515,21 +2515,23 @@ static int pkt_make_request(struct reque
 
 	/* Check if we have to split the bio */
 	{
-		struct bio_pair *bp;
+		struct bio *remainder = bio;
 		sector_t last_zone;
 		int first_sectors;
 
 		last_zone = ZONE(bio->bi_sector + bio_sectors(bio) - 1, pd);
-		if (last_zone != zone) {
-			BUG_ON(last_zone != zone + pd->settings.size);
-			first_sectors = last_zone - bio->bi_sector;
-			bp = bio_split(bio, bio_split_pool, first_sectors);
-			BUG_ON(!bp);
-			pkt_make_request(q, &bp->bio1);
-			pkt_make_request(q, &bp->bio2);
-			bio_pair_release(bp);
-			return 0;
+		while (last_zone != zone) {
+			struct bio *new;
+			first_sectors = zone + pd->settings.size
+				- remainder->bi_sector;
+
+			new = bio_multi_split(bio, first_sectors, &remainder);
+
+			pkt_make_request(q, new);
+			last_zone = ZONE(remainder->bi_sector +
+					 bio_sectors(remainder) - 1, pd);
 		}
+		bio = remainder;
 	}
 
 	/*
@@ -2610,27 +2612,6 @@ end_io:
 	return 0;
 }
 
-
-
-static int pkt_merge_bvec(struct request_queue *q, struct bio *bio, struct bio_vec *bvec)
-{
-	struct pktcdvd_device *pd = q->queuedata;
-	sector_t zone = ZONE(bio->bi_sector, pd);
-	int used = ((bio->bi_sector - zone) << 9) + bio->bi_size;
-	int remaining = (pd->settings.size << 9) - used;
-	int remaining2;
-
-	/*
-	 * A bio <= PAGE_SIZE must be allowed. If it crosses a packet
-	 * boundary, pkt_make_request() will split the bio.
-	 */
-	remaining2 = PAGE_SIZE - bio->bi_size;
-	remaining = max(remaining, remaining2);
-
-	BUG_ON(remaining < 0);
-	return remaining;
-}
-
 static void pkt_init_queue(struct pktcdvd_device *pd)
 {
 	struct request_queue *q = pd->disk->queue;
@@ -2638,7 +2619,6 @@ static void pkt_init_queue(struct pktcdv
 	blk_queue_make_request(q, pkt_make_request);
 	blk_queue_hardsect_size(q, CD_FRAMESIZE);
 	blk_queue_max_sectors(q, PACKET_MAX_SECTORS);
-	blk_queue_merge_bvec(q, pkt_merge_bvec);
 	q->queuedata = pd;
 }
 
