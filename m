Return-Path: <linux-kernel-owner+w=401wt.eu-S1760429AbYIDUfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760429AbYIDUfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758124AbYIDU1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:27:43 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:24531 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321AbYIDU1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:27:41 -0400
From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH 5/6] Added flush_disk to factor out common buffer cache
	flushing code.
To: linux-scsi@vger.kernel.org
Cc: andrew.patterson@hp.com, James.Bottomley@HansenPartnership.com,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
       andmike@linux.vnet.ibm.com, mike.miller@hp.com, genanr@emsphone.com,
       jmoyer@redhat.com
Date: Thu, 04 Sep 2008 14:27:40 -0600
Message-ID: <20080904202740.10456.20170.stgit@bob.kio>
In-Reply-To: <20080904202714.10456.88061.stgit@bob.kio>
References: <20080904202714.10456.88061.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added flush_disk to factor out common buffer cache flushing code.

We need to be able to flush the buffer cache for for more than
just when a disk is changed, so we factor out common cache flush code
in check_disk_change() to an internal flush_disk() routine.  This
routine will then be used for both disk changes and disk resizes (in a
later patch).

Include the disk name in the text indicating that there are busy
inodes on the device and increase the KERN severity of the message.

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
---

 fs/block_dev.c |   32 +++++++++++++++++++++++++++-----
 1 files changed, 27 insertions(+), 5 deletions(-)


diff --git a/fs/block_dev.c b/fs/block_dev.c
index b721955..33650fc 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -853,6 +853,32 @@ struct block_device *open_by_devnum(dev_t dev, unsigned mode)
 EXPORT_SYMBOL(open_by_devnum);
 
 /**
+ * flush_disk - invalidates all buffer-cache entries on a disk
+ *
+ * @bdev:      struct block device to be flushed
+ *
+ * Invalidates all buffer-cache entries on a disk. It should be called
+ * when a disk has been changed -- either by a media change or online
+ * resize.
+ */
+static void flush_disk(struct block_device *bdev)
+{
+	if (__invalidate_device(bdev)) {
+		char name[BDEVNAME_SIZE] = "";
+
+		if (bdev->bd_disk)
+			disk_name(bdev->bd_disk, 0, name);
+		printk(KERN_WARNING "VFS: busy inodes on changed media or "
+		       "resized disk %s\n", name);
+	}
+
+	if (!bdev->bd_disk)
+		return;
+	if (disk_partitionable(bdev->bd_disk))
+		bdev->bd_invalidated = 1;
+}
+
+/**
  * check_disk_size_change - checks for disk size change and adjusts
  *                          bdev size.
  *
@@ -929,13 +955,9 @@ int check_disk_change(struct block_device *bdev)
 	if (!bdops->media_changed(bdev->bd_disk))
 		return 0;
 
-	if (__invalidate_device(bdev))
-		printk("VFS: busy inodes on changed media.\n");
-
+	flush_disk(bdev);
 	if (bdops->revalidate_disk)
 		bdops->revalidate_disk(bdev->bd_disk);
-	if (disk_partitionable(bdev->bd_disk))
-		bdev->bd_invalidated = 1;
 	return 1;
 }
 

