Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbZIIMLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbZIIMLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 08:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbZIIMLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 08:11:44 -0400
Received: from brick.kernel.dk ([93.163.65.50]:47287 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbZIIMLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 08:11:43 -0400
Date: Wed, 9 Sep 2009 14:11:46 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] aoe fix for 2.6.31
Message-ID: <20090909121146.GZ18599@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull this single fix for 2.6.31, which fixes a problem with the
way that aoe handles the request queue. It used to embed the queue
inside another structure, but this breaks for a variety of reasons.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Ed L. Cashin (1):
      aoe: allocate unused request_queue for sysfs

 drivers/block/aoe/aoe.h    |    2 +-
 drivers/block/aoe/aoeblk.c |   12 +++++++++---
 drivers/block/aoe/aoedev.c |    1 +
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index 5e41e6d..db195ab 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -155,7 +155,7 @@ struct aoedev {
 	u16 fw_ver;		/* version of blade's firmware */
 	struct work_struct work;/* disk create work struct */
 	struct gendisk *gd;
-	struct request_queue blkq;
+	struct request_queue *blkq;
 	struct hd_geometry geo; 
 	sector_t ssize;
 	struct timer_list timer;
diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index 2307a27..1e15889 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -264,9 +264,12 @@ aoeblk_gdalloc(void *vp)
 		goto err_disk;
 	}
 
-	blk_queue_make_request(&d->blkq, aoeblk_make_request);
-	if (bdi_init(&d->blkq.backing_dev_info))
+	d->blkq = blk_alloc_queue(GFP_KERNEL);
+	if (!d->blkq)
 		goto err_mempool;
+	blk_queue_make_request(d->blkq, aoeblk_make_request);
+	if (bdi_init(&d->blkq->backing_dev_info))
+		goto err_blkq;
 	spin_lock_irqsave(&d->lock, flags);
 	gd->major = AOE_MAJOR;
 	gd->first_minor = d->sysminor * AOE_PARTITIONS;
@@ -276,7 +279,7 @@ aoeblk_gdalloc(void *vp)
 	snprintf(gd->disk_name, sizeof gd->disk_name, "etherd/e%ld.%d",
 		d->aoemajor, d->aoeminor);
 
-	gd->queue = &d->blkq;
+	gd->queue = d->blkq;
 	d->gd = gd;
 	d->flags &= ~DEVFL_GDALLOC;
 	d->flags |= DEVFL_UP;
@@ -287,6 +290,9 @@ aoeblk_gdalloc(void *vp)
 	aoedisk_add_sysfs(d);
 	return;
 
+err_blkq:
+	blk_cleanup_queue(d->blkq);
+	d->blkq = NULL;
 err_mempool:
 	mempool_destroy(d->bufpool);
 err_disk:
diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index eeea477..fa67027 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -113,6 +113,7 @@ aoedev_freedev(struct aoedev *d)
 	if (d->bufpool)
 		mempool_destroy(d->bufpool);
 	skbpoolfree(d);
+	blk_cleanup_queue(d->blkq);
 	kfree(d);
 }
 

-- 
Jens Axboe

