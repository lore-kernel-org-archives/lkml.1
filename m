Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113Ab0AWAWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab0AWAWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755524Ab0AWAWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:22:10 -0500
Received: from kroah.org ([198.145.64.141]:35093 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755442Ab0AWATA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:19:00 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jan 22 16:11:13 2010
Message-Id: <20100123001113.151422771@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jan 2010 16:10:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Mike Snitzer <snitzer@redhat.com>,
       "Alasdair G. Kergon" <agk@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [23/29] DM: Fix device mapper topology stacking
In-Reply-To: <20100123001145.GA7391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Martin K. Petersen <martin.petersen@oracle.com>

commit b27d7f16d3c6c27345d4280a739809c1c2c4c0b5 upstream.

Make DM use bdev_stack_limits() function so that partition offsets get
taken into account when calculating alignment.  Clarify stacking
warnings.

Also remove obsolete clearing of final alignment_offset and misalignment
flag.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair G. Kergon <agk@redhat.com>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-table.c |   20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -499,16 +499,15 @@ int dm_set_device_limits(struct dm_targe
 		return 0;
 	}
 
-	if (blk_stack_limits(limits, &q->limits, start << 9) < 0)
-		DMWARN("%s: target device %s is misaligned: "
+	if (bdev_stack_limits(limits, bdev, start) < 0)
+		DMWARN("%s: adding target device %s caused an alignment inconsistency: "
 		       "physical_block_size=%u, logical_block_size=%u, "
 		       "alignment_offset=%u, start=%llu",
 		       dm_device_name(ti->table->md), bdevname(bdev, b),
 		       q->limits.physical_block_size,
 		       q->limits.logical_block_size,
 		       q->limits.alignment_offset,
-		       (unsigned long long) start << 9);
-
+		       (unsigned long long) start << SECTOR_SHIFT);
 
 	/*
 	 * Check if merge fn is supported.
@@ -1025,9 +1024,9 @@ combine_limits:
 		 * for the table.
 		 */
 		if (blk_stack_limits(limits, &ti_limits, 0) < 0)
-			DMWARN("%s: target device "
+			DMWARN("%s: adding target device "
 			       "(start sect %llu len %llu) "
-			       "is misaligned",
+			       "caused an alignment inconsistency",
 			       dm_device_name(table->md),
 			       (unsigned long long) ti->begin,
 			       (unsigned long long) ti->len);
@@ -1079,15 +1078,6 @@ void dm_table_set_restrictions(struct dm
 			       struct queue_limits *limits)
 {
 	/*
-	 * Each target device in the table has a data area that should normally
-	 * be aligned such that the DM device's alignment_offset is 0.
-	 * FIXME: Propagate alignment_offsets up the stack and warn of
-	 *	  sub-optimal or inconsistent settings.
-	 */
-	limits->alignment_offset = 0;
-	limits->misaligned = 0;
-
-	/*
 	 * Copy table's limits to the DM device's request_queue
 	 */
 	q->limits = *limits;


