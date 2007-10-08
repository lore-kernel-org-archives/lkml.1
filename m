Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbXJHXcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbXJHXcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 19:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbXJHXb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 19:31:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbXJHXbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 19:31:55 -0400
Message-ID: <470ABDE5.30200@ce.jp.nec.com>
Date: Mon, 08 Oct 2007 19:31:49 -0400
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] device-mapper: fix bd_mount_sem corruption
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch fixes a bd_mount_sem counter corruption bug in device-mapper.

thaw_bdev() should be called only when freeze_bdev() was called for the
device.
Otherwise, thaw_bdev() will up bd_mount_sem and corrupt the semaphore counter.
struct block_device with the corrupted semaphore may remain in slab cache
and be reused later.

Attached patch will fix it by calling unlock_fs() instead.
unlock_fs() will determine whether it should call thaw_bdev()
by checking the device is frozen or not.

Easy reproducer is:
  #!/bin/sh
  while [ 1 ]; do
     dmsetup --notable create a
     dmsetup --nolockfs suspend a
     dmsetup remove a
  done

It's not easy to see the effect of corrupted semaphore.
So I have tested with putting printk below in bdev_alloc_inode():
        if (atomic_read(&ei->bdev.bd_mount_sem.count) != 1)
                printk(KERN_DEBUG "Incorrect semaphore count = %d (%p)\n",
                        atomic_read(&ei->bdev.bd_mount_sem.count),
                        &ei->bdev);

Without the patch, I saw something like:
 Incorrect semaphore count = 17 (f2ab91c0)

With the patch, the message didn't appear.


Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2120155..998d450 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1064,12 +1064,14 @@ static struct mapped_device *alloc_dev(int minor)
 	return NULL;
 }
 
+static void unlock_fs(struct mapped_device *md);
+
 static void free_dev(struct mapped_device *md)
 {
 	int minor = md->disk->first_minor;
 
 	if (md->suspended_bdev) {
-		thaw_bdev(md->suspended_bdev, NULL);
+		unlock_fs(md);
 		bdput(md->suspended_bdev);
 	}
 	mempool_destroy(md->tio_pool);
