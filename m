Return-Path: <linux-kernel-owner+w=401wt.eu-S1751932AbZJ1Su6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbZJ1Su6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 14:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbZJ1Su5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 14:50:57 -0400
Received: from brick.kernel.dk ([93.163.65.50]:40740 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbZJ1Su5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 14:50:57 -0400
Date: Wed, 28 Oct 2009 19:51:01 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block fixes for 2.6.32-rc
Message-ID: <20091028185101.GS10727@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Two important one-liners, both fixing a regression. Please pull.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Mark McLoughlin (1):
      block: silently error unsupported empty barriers too

Neil Brown (1):
      block: use after free bug in __blkdev_get

 block/blk-core.c |    2 +-
 fs/block_dev.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index ac0fa10..71da511 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1161,7 +1161,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 	const unsigned int ff = bio->bi_rw & REQ_FAILFAST_MASK;
 	int rw_flags;
 
-	if (bio_rw_flagged(bio, BIO_RW_BARRIER) && bio_has_data(bio) &&
+	if (bio_rw_flagged(bio, BIO_RW_BARRIER) &&
 	    (q->next_ordered == QUEUE_ORDERED_NONE)) {
 		bio_endio(bio, -EOPNOTSUPP);
 		return 0;
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 9cf4b92..8bed055 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1248,8 +1248,8 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 			bd_set_size(bdev, (loff_t)bdev->bd_part->nr_sects << 9);
 		}
 	} else {
-		put_disk(disk);
 		module_put(disk->fops->owner);
+		put_disk(disk);
 		disk = NULL;
 		if (bdev->bd_contains == bdev) {
 			if (bdev->bd_disk->fops->open) {

-- 
Jens Axboe

