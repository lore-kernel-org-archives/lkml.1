Return-Path: <linux-kernel-owner+w=401wt.eu-S1759035AbXJXV0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035AbXJXV0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 17:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759181AbXJXVZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 17:25:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759122AbXJXVZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 17:25:58 -0400
Message-ID: <471FB85C.5080707@ce.jp.nec.com>
Date: Wed, 24 Oct 2007 17:25:48 -0400
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] dm: noflush resizing (2/3) Use bdlookup() on noflush suspend
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes device-mapper to use bdlookup to allow resizing
of noflush-suspended device.

With this patch, by using bdlookup() instead of bdget(),
resizing will no longer wait for I_LOCK.

There is a race between bdlookup() and bdget().
However, it's benign because the only use of bdev obtained by
bdlookup() is to modify i_size and bdget() will anyway see the
updated disk size.
(See below)

Case 1:
    CPU 0                         CPU 1
    ------------------------------------------------------------------
    set_capacity()
      disk size is updated
    bdlookup() -> NULL
                                   bdget()
                                     bdget reads updated disk size
                                     and set it to bdev inode's i_size

Case 2:
    CPU 0                         CPU 1
    ------------------------------------------------------------------
    set_capacity()
      disk size is updated
                                   bdget()
                                     bdget reads updated disk size
                                     and set it to bdev inode's i_size
    bdlookup()
      wait for the bdget completion (I_NEW)
      and get the bdev inode with updated disk size

Case 3:
    CPU 0                         CPU 1
    ------------------------------------------------------------------
                                   bdget()
                                     bdget reads old disk size
    set_capacity()
      disk size is updated
    bdlookup()
      get the existing bdev inode
      update the i_size

To change i_size of bdev inode, the new code uses bd_mutex
instead of inode->i_mutex. According to a comment in
include/linux/fs.h, mutex is necessary here only to serialize
i_size_write().
bd_inode->i_size is set via bd_set_size() and bd_set_size()
is protected by bd_mutex.
So I think bd_mutex is the lock we should use.


Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

---
 dm.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

Index: linux-2.6.23.work/drivers/md/dm.c
===================================================================
--- linux-2.6.23.work.orig/drivers/md/dm.c
+++ linux-2.6.23.work/drivers/md/dm.c
@@ -1101,11 +1101,29 @@ static void event_callback(void *context
 
 static void __set_size(struct mapped_device *md, sector_t size)
 {
+	struct block_device *bdev;
+
 	set_capacity(md->disk, size);
 
-	mutex_lock(&md->suspended_bdev->bd_inode->i_mutex);
-	i_size_write(md->suspended_bdev->bd_inode, (loff_t)size << SECTOR_SHIFT);
-	mutex_unlock(&md->suspended_bdev->bd_inode->i_mutex);
+	/*
+	 * Updated disk size should be visible to bdget() possibly
+	 * called in parallel to bdlookup()
+	 */
+	smp_mb();
+
+	if (md->suspended_bdev)
+		bdev = md->suspended_bdev;
+	else
+		bdev = bdlookup_disk(md->disk, 0);
+
+	if (bdev) {
+		mutex_lock(&bdev->bd_mutex);
+		i_size_write(bdev->bd_inode, (loff_t)size << SECTOR_SHIFT);
+		mutex_unlock(&bdev->bd_mutex);
+	}
+
+	if (!md->suspended_bdev)
+		bdput(bdev);
 }
 
 static int __bind(struct mapped_device *md, struct dm_table *t)
@@ -1121,8 +1139,7 @@ static int __bind(struct mapped_device *
 	if (size != get_capacity(md->disk))
 		memset(&md->geometry, 0, sizeof(md->geometry));
 
-	if (md->suspended_bdev)
-		__set_size(md, size);
+	__set_size(md, size);
 	if (size == 0)
 		return 0;
 
