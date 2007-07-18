Return-Path: <linux-kernel-owner+w=401wt.eu-S1761188AbXGRLAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761188AbXGRLAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 07:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755604AbXGRK7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 06:59:55 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:26261 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355AbXGRK7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 06:59:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=K85gHsjhGIXx9PO4sQO3k9fToKIszh2sEIUSZykjVP9yoVgzqH5qc5ws8hCwwmbgjl9FkKJMOWYxL23L+hKfv5r5+x1FZQgIwhOXW3wGq5UsaDjux+G+B1CPkyZX2zjQQ7MwrYiRSddsPE86YEtHl7m2Js4ALkWn+o9Zv2I3Wbs=
Date: Wed, 18 Jul 2007 19:59:46 +0900
From: Tejun Heo <htejun@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       linux-raid@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Phillip Susi <psusi@cfl.rr.com>, Stefan Bader <Stefan.Bader@de.ibm.com>,
       Andreas Dilger <adilger@clusterfs.com>
Subject: [PATCH] block: factor out bio_check_eod()
Message-ID: <20070718105946.GC22374@htj.dyndns.org>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070530093503.GA15559@kernel.dk> <20070718105655.GB22374@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070718105655.GB22374@htj.dyndns.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

End of device check is done twice in __generic_make_request() and it's
fully inlined each time.  Factor out bio_check_eod().

This is taken from Jens' zero-length barrier patch.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/ll_rw_blk.c |   63 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 33 insertions(+), 30 deletions(-)

Index: work/block/ll_rw_blk.c
===================================================================
--- work.orig/block/ll_rw_blk.c
+++ work/block/ll_rw_blk.c
@@ -3094,6 +3094,35 @@ static inline int should_fail_request(st
 
 #endif /* CONFIG_FAIL_MAKE_REQUEST */
 
+/*
+ * Check whether this bio extends beyond the end of the device.
+ */
+static int bio_check_eod(struct bio *bio, unsigned int nr_sectors)
+{
+	sector_t maxsector;
+
+	if (!nr_sectors)
+		return 0;
+
+	/* Test device or partition size, when known. */
+	maxsector = bio->bi_bdev->bd_inode->i_size >> 9;
+	if (maxsector) {
+		sector_t sector = bio->bi_sector;
+
+		if (maxsector < nr_sectors || maxsector - nr_sectors < sector) {
+			/*
+			 * This may well happen - the kernel calls bread()
+			 * without checking the size of the device, e.g., when
+			 * mounting a device.
+			 */
+			handle_bad_sector(bio);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
 /**
  * generic_make_request: hand a buffer to its device driver for I/O
  * @bio:  The bio describing the location in memory and on the device.
@@ -3121,27 +3150,14 @@ static inline int should_fail_request(st
 static inline void __generic_make_request(struct bio *bio)
 {
 	request_queue_t *q;
-	sector_t maxsector;
 	sector_t old_sector;
 	int ret, nr_sectors = bio_sectors(bio);
 	dev_t old_dev;
 
 	might_sleep();
-	/* Test device or partition size, when known. */
-	maxsector = bio->bi_bdev->bd_inode->i_size >> 9;
-	if (maxsector) {
-		sector_t sector = bio->bi_sector;
 
-		if (maxsector < nr_sectors || maxsector - nr_sectors < sector) {
-			/*
-			 * This may well happen - the kernel calls bread()
-			 * without checking the size of the device, e.g., when
-			 * mounting a device.
-			 */
-			handle_bad_sector(bio);
-			goto end_io;
-		}
-	}
+	if (bio_check_eod(bio, nr_sectors))
+		goto end_io;
 
 	/*
 	 * Resolve the mapping until finished. (drivers are
@@ -3197,21 +3213,8 @@ end_io:
 		old_sector = bio->bi_sector;
 		old_dev = bio->bi_bdev->bd_dev;
 
-		maxsector = bio->bi_bdev->bd_inode->i_size >> 9;
-		if (maxsector) {
-			sector_t sector = bio->bi_sector;
-
-			if (maxsector < nr_sectors ||
-					maxsector - nr_sectors < sector) {
-				/*
-				 * This may well happen - partitions are not
-				 * checked to make sure they are within the size
-				 * of the whole device.
-				 */
-				handle_bad_sector(bio);
-				goto end_io;
-			}
-		}
+		if (bio_check_eod(bio, nr_sectors))
+			goto end_io;
 
 		ret = q->make_request_fn(q, bio);
 	} while (ret);
