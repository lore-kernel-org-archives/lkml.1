Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638AbZEYEfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbZEYEfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 00:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750852AbZEYEfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 00:35:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38735 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbZEYEfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 00:35:14 -0400
Date: Mon, 25 May 2009 14:35:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Mikulas Patocka <mpatocka@redhat.com>,
       Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: linux-next: block tree build failure
Message-Id: <20090525143511.f9e76bdc.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Today's linux-next build (powerpc ppc64_defconfig) failed like this:

drivers/md/dm.c: In function 'dm_merge_bvec':
drivers/md/dm.c:976: error: 'struct request_queue' has no member named 'max_hw_sectors'

Caused by commit 025146e13b63483add912706c101fb0fb6f015cc ("block: Move
queue limits to an embedded struct") from the block tree interacting with
commit c8f4b88baca86491a6125cf9373a75e04b22ff8b
("dm-avoid-unsupported-spanning-of-md-stripe-boundaries") from the
device-mapper tree.

Another sudden API change ...

The correct way:
	add new accessor implemented in terms of old API that is a noop
	push that to Linus
	fixup all the references to the old API (telling the users)
	wait for other users (if any) to use new accessor
	remove old API

We have done this several times ...  Linus is will to take the "add new
accessor" patches basically any time.

So I added this patch:

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7b939fa..ea9a9e6 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -973,7 +973,7 @@ static int dm_merge_bvec(struct request_queue *q,
 	 * entries.  So always set max_size to 0, and the code below allows
 	 * just one page.
 	 */
-	else if (q->max_hw_sectors <= PAGE_SIZE >> 9)
+	else if (queue_max_hw_sectors(q) <= PAGE_SIZE >> 9)
 		max_size = 0;
 
 out_table:

But now I get:

drivers/md/dm-table.c: In function 'device_area_is_valid':
drivers/md/dm-table.c:390: error: 'struct io_restrictions' has no member named 'hardsect_size'
drivers/md/dm-table.c:414: error: 'struct io_restrictions' has no member named 'hardsect_size'
drivers/md/dm-table.c: In function 'validate_hardsect_alignment':
drivers/md/dm-table.c:738: error: 'struct io_restrictions' has no member named 'hardsect_size'
drivers/md/dm-table.c:765: error: 'struct io_restrictions' has no member named 'hardsect_size'
drivers/md/dm-table.c:777: error: 'struct io_restrictions' has no member named 'hardsect_size'

This is caused by commit e1defc4ff0cf57aca6c5e3ff99fa503f5943c1f1
("block: Do away with the notion of hardsect_size") from the block tree
interacting with commits cc1018ae8a413b595a1f0f822928dd9e81a75e59
("dm-table-ensure-targets-are-aligned-to-hardsect_size") and
64b184139ca6cd3d53dc45d7782c8be50b3e0331
("dm-table-validate-device-hardsect_size") from the device-mapper tree.

So I added the following patch as well.

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index d38b911..8f734ad 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -387,7 +387,7 @@ static int device_area_is_valid(struct dm_target *ti, struct block_device *bdev,
 			     sector_t start, sector_t len)
 {
 	sector_t dev_size = bdev->bd_inode->i_size >> SECTOR_SHIFT;
-	unsigned short hardsect_size_sectors = ti->limits.hardsect_size >>
+	unsigned short hardsect_size_sectors = ti->limits.logical_block_size >>
 					       SECTOR_SHIFT;
 	char b[BDEVNAME_SIZE];
 
@@ -414,7 +414,7 @@ static int device_area_is_valid(struct dm_target *ti, struct block_device *bdev,
 		DMWARN("%s: len=%llu not aligned to h/w sector size %hu of %s",
 		       dm_device_name(ti->table->md),
 		       (unsigned long long)len,
-		       ti->limits.hardsect_size, bdevname(bdev, b));
+		       ti->limits.logical_block_size, bdevname(bdev, b));
 		return 0;
 	}
 
@@ -735,7 +735,7 @@ static int validate_hardsect_alignment(struct dm_table *table)
 	 * (in units of 512-byte sectors).
 	 */
 	unsigned short device_hardsect_size_sects =
-			    table->limits.hardsect_size >> SECTOR_SHIFT;
+			    table->limits.logical_block_size >> SECTOR_SHIFT;
 
 	/*
 	 * Offset of the start of the next table entry, mod hardsect_size.
@@ -762,7 +762,7 @@ static int validate_hardsect_alignment(struct dm_table *table)
 		 * table entry are they compatible with its hardsect_size?
 		 */
 		if (remaining < ti->len &&
-		    remaining & ((ti->limits.hardsect_size >>
+		    remaining & ((ti->limits.logical_block_size >>
 				  SECTOR_SHIFT) - 1))
 			break;	/* Error */
 
@@ -779,7 +779,7 @@ static int validate_hardsect_alignment(struct dm_table *table)
 		       dm_device_name(table->md), i,
 		       (unsigned long long) ti->begin,
 		       (unsigned long long) ti->len,
-		       table->limits.hardsect_size);
+		       table->limits.logical_block_size);
 		return -EINVAL;
 	}
 

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
