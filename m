Return-Path: <linux-kernel-owner+w=401wt.eu-S932844AbXBTGfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844AbXBTGfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 01:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932845AbXBTGff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 01:35:35 -0500
Received: from ns.suse.de ([195.135.220.2]:56157 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932844AbXBTGfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 01:35:34 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 20 Feb 2007 17:34:47 +1100
Message-Id: <1070220063447.16129@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: stable@kernel.org
Subject: [PATCH 001 of 6] md: Fix raid10 recovery problem.
References: <20070220172544.15678.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


There are two errors that can lead to recovery problems with raid10
when used in 'far' more (not the default).

Due to a '>' instead of '>=' the wrong block is located which would
result in garbage being written to some random location, quite
possible outside the range of the device, causing the newly
reconstructed device to fail.

The device size calculation had some rounding errors (it didn't round
when it should) and so recovery would go a few blocks too far which
would again cause a write to a random block address and probably
a device error.

The code for working with device sizes was fairly confused and spread
out, so this has been tided up a bit.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid10.c |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
--- .prev/drivers/md/raid10.c	2007-02-20 17:10:15.000000000 +1100
+++ ./drivers/md/raid10.c	2007-02-20 17:11:41.000000000 +1100
@@ -429,7 +429,7 @@ static sector_t raid10_find_virt(conf_t 
 		if (dev < 0)
 			dev += conf->raid_disks;
 	} else {
-		while (sector > conf->stride) {
+		while (sector >= conf->stride) {
 			sector -= conf->stride;
 			if (dev < conf->near_copies)
 				dev += conf->raid_disks - conf->near_copies;
@@ -1801,6 +1801,7 @@ static sector_t sync_request(mddev_t *md
 						for (k=0; k<conf->copies; k++)
 							if (r10_bio->devs[k].devnum == i)
 								break;
+						BUG_ON(k == conf->copies);
 						bio = r10_bio->devs[1].bio;
 						bio->bi_next = biolist;
 						biolist = bio;
@@ -2021,19 +2022,30 @@ static int run(mddev_t *mddev)
 	if (!conf->tmppage)
 		goto out_free_conf;
 
+	conf->mddev = mddev;
+	conf->raid_disks = mddev->raid_disks;
 	conf->near_copies = nc;
 	conf->far_copies = fc;
 	conf->copies = nc*fc;
 	conf->far_offset = fo;
 	conf->chunk_mask = (sector_t)(mddev->chunk_size>>9)-1;
 	conf->chunk_shift = ffz(~mddev->chunk_size) - 9;
+	size = mddev->size >> (conf->chunk_shift-1);
+	sector_div(size, fc);
+	size = size * conf->raid_disks;
+	sector_div(size, nc);
+	/* 'size' is now the number of chunks in the array */
+	/* calculate "used chunks per device" in 'stride' */
+	stride = size * conf->copies;
+	sector_div(stride, conf->raid_disks);
+	mddev->size = stride  << (conf->chunk_shift-1);
+
 	if (fo)
-		conf->stride = 1 << conf->chunk_shift;
-	else {
-		stride = mddev->size >> (conf->chunk_shift-1);
+		stride = 1;
+	else
 		sector_div(stride, fc);
-		conf->stride = stride << conf->chunk_shift;
-	}
+	conf->stride = stride << conf->chunk_shift;
+
 	conf->r10bio_pool = mempool_create(NR_RAID10_BIOS, r10bio_pool_alloc,
 						r10bio_pool_free, conf);
 	if (!conf->r10bio_pool) {
@@ -2063,8 +2075,6 @@ static int run(mddev_t *mddev)
 
 		disk->head_position = 0;
 	}
-	conf->raid_disks = mddev->raid_disks;
-	conf->mddev = mddev;
 	spin_lock_init(&conf->device_lock);
 	INIT_LIST_HEAD(&conf->retry_list);
 
@@ -2106,16 +2116,8 @@ static int run(mddev_t *mddev)
 	/*
 	 * Ok, everything is just fine now
 	 */
-	if (conf->far_offset) {
-		size = mddev->size >> (conf->chunk_shift-1);
-		size *= conf->raid_disks;
-		size <<= conf->chunk_shift;
-		sector_div(size, conf->far_copies);
-	} else
-		size = conf->stride * conf->raid_disks;
-	sector_div(size, conf->near_copies);
-	mddev->array_size = size/2;
-	mddev->resync_max_sectors = size;
+	mddev->array_size = size << (conf->chunk_shift-1);
+	mddev->resync_max_sectors = size << conf->chunk_shift;
 
 	mddev->queue->unplug_fn = raid10_unplug;
 	mddev->queue->issue_flush_fn = raid10_issue_flush;
