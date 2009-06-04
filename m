Return-Path: <linux-kernel-owner+w=401wt.eu-S1753263AbZFDSBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbZFDSBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 14:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbZFDSAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 14:00:53 -0400
Received: from adelie.canonical.com ([91.189.90.139]:45860 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbZFDSAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 14:00:52 -0400
Message-ID: <4A280BD4.9080908@canonical.com>
Date: Thu, 04 Jun 2009 20:00:52 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: pierre@ossman.eu
CC: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Subject: [PATCH] mmc: prevent dangling block device from accessing stale queues
Content-Type: multipart/mixed;
 boundary="------------060807030900020201040907"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060807030900020201040907
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Kernel: 2.6.30-rc7 based
Worked in 2.6.28 (probably only because things went at a different speed)

Testcase: Use ext3/ext4 on a SD card partitioned with one primary DOS partition 
and leave it mounted while suspend/resume.

Result: After resume the partition table of the SD card has been erased.

The detailed description can be found at:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/383668

In essence the mmc block device frees the generic request queue before the last 
user of the gendisk has stopped using it leaving an invalid queue pointer which 
get unfortunately re-used before more requests come in for the old device.

The bugfix will cause more I/O error messages and might not be the ultimate way 
things should work, but it prevents data from getting lost.

Stefan


--------------060807030900020201040907
Content-Type: text/x-diff;
 name="0001-UBUNTU-Upstream-mmc-prevent-dangling-block-device-fr.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-UBUNTU-Upstream-mmc-prevent-dangling-block-device-fr.pa";
 filename*1="tch"

>From 3f8fa799dea815654381af2b12b0983e440c6c6e Mon Sep 17 00:00:00 2001
From: Stefan Bader <stefan.bader@canonical.com>
Date: Wed, 3 Jun 2009 18:17:31 +0000
Subject: [PATCH] UBUNTU: [Upstream] mmc: prevent dangling block device from accessing stale queues

BugLink: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/383668

When the mmc subsytem removes the block device (e.g. for suspend), it will
call mmc_cleanup_queue to release the block device request queue.
However the gendisk struct still has a pointer to that queue which is not
accounted for. If the block device is still open, the gendisk struct will
not get freed and might still use the stale pointer.
This gets even worse for the fact that (in this case) on resume, a new block
device is created which gets the same request queue object from the cache.
Now any stray access to that old block device end up on the new one.
As the functions to get and put the blk queue are not exported, the fix will
delay the actual call to blk_cleanup_queue until the last user of the mmc
block device drops its reference. Until then the blk queue is present but
will reject any I/O.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/mmc/card/block.c |    6 ++++++
 drivers/mmc/card/queue.c |    7 ++++++-
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 014b271..69d7cec 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -88,6 +88,12 @@ static void mmc_blk_put(struct mmc_blk_data *md)
 		int devidx = MINOR(disk_devt(md->disk)) >> MMC_SHIFT;
 		__clear_bit(devidx, dev_use);
 
+		/*
+		 * We are about to drop the last reference to the disk object.
+		 * Nothing else should now be looking at the queue pointer, so
+		 * now it won't hurt if we release it.
+		 */
+		blk_cleanup_queue(md->disk->queue);
 		put_disk(md->disk);
 		kfree(md);
 	}
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 4978562..163cc28 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -256,7 +256,12 @@ void mmc_cleanup_queue(struct mmc_queue *mq)
 		kfree(mq->bounce_buf);
 	mq->bounce_buf = NULL;
 
-	blk_cleanup_queue(mq->queue);
+	/*
+	 * Calling blk_cleanup_queue() would be too soon here. As long as
+	 * the gendisk has a reference to it and is not released we should
+	 * keep the queue. It has been shutdown and will not accept any new
+	 * requests, so that should be safe.
+	 */
 
 	mq->card = NULL;
 }
-- 
1.6.3.1


--------------060807030900020201040907--
