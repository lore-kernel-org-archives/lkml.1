Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbZETHOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbZETHOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbZETHOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:14:43 -0400
Received: from brick.kernel.dk ([93.163.65.50]:34771 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312AbZETHOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:14:42 -0400
Date: Wed, 20 May 2009 09:14:43 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org
Subject: [GIT PULL] block bits for 2.6.30-rc6
Message-ID: <20090520071443.GH11363@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Three small fixes, that should also got to stable.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Ian Campbell (2):
      xen/blkfront: allow xenbus state transition to Closing->Closed  when not Connected
      xen/blkfront: fix warning when deleting gendisk on unplug/shutdown

Roel Kluin (1):
      cdrom: beyond ARRAY_SIZE of viocd_diskinfo

 drivers/block/xen-blkfront.c |   10 ++++++----
 drivers/cdrom/viocd.c        |    2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 8f90508..a6cbf7b 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -934,8 +934,6 @@ static void blkfront_closing(struct xenbus_device *dev)
 
 	spin_lock_irqsave(&blkif_io_lock, flags);
 
-	del_gendisk(info->gd);
-
 	/* No more blkif_request(). */
 	blk_stop_queue(info->rq);
 
@@ -949,6 +947,8 @@ static void blkfront_closing(struct xenbus_device *dev)
 	blk_cleanup_queue(info->rq);
 	info->rq = NULL;
 
+	del_gendisk(info->gd);
+
  out:
 	xenbus_frontend_closed(dev);
 }
@@ -977,8 +977,10 @@ static void backend_changed(struct xenbus_device *dev,
 		break;
 
 	case XenbusStateClosing:
-		if (info->gd == NULL)
-			xenbus_dev_fatal(dev, -ENODEV, "gd is NULL");
+		if (info->gd == NULL) {
+			xenbus_frontend_closed(dev);
+			break;
+		}
 		bd = bdget_disk(info->gd, 0);
 		if (bd == NULL)
 			xenbus_dev_fatal(dev, -ENODEV, "bdget failed");
diff --git a/drivers/cdrom/viocd.c b/drivers/cdrom/viocd.c
index 1392935..9b1624e 100644
--- a/drivers/cdrom/viocd.c
+++ b/drivers/cdrom/viocd.c
@@ -587,7 +587,7 @@ static int viocd_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	struct device_node *node = vdev->dev.archdata.of_node;
 
 	deviceno = vdev->unit_address;
-	if (deviceno > VIOCD_MAX_CD)
+	if (deviceno >= VIOCD_MAX_CD)
 		return -ENODEV;
 	if (!node)
 		return -ENODEV;

-- 
Jens Axboe

