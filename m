Return-Path: <linux-kernel-owner+w=401wt.eu-S2992545AbXCBP4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992545AbXCBP4z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 10:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992550AbXCBP4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 10:56:00 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:49710 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992545AbXCBPzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 10:55:25 -0500
Subject: [PATCH 8/9] mtd: Allow mtd block device drivers to have a custom
	ioctl function
From: Richard Purdie <rpurdie@openedhand.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-mtd@lists.infradead.org, dwmw2@infradead.org
Content-Type: text/plain
Date: Fri, 02 Mar 2007 15:55:02 +0000
Message-Id: <1172850902.11149.130.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Allow mtd block drivers to customise their ioctl functions. Also
allow the drivers to obtain the gendisk struct since ioctl 
functions can need this.

This also moves the mtd ioctl functions from locked to unlocked.
As far as I can see, nothing in the mtd code has locking problems.

Signed-off-by: Richard Purdie <rpurdie@openedhand.com>

---
 drivers/mtd/mtd_blkdevs.c    |   14 +++++++++++---
 include/linux/mtd/blktrans.h |    5 +++++
 2 files changed, 16 insertions(+), 3 deletions(-)

Index: linux/drivers/mtd/mtd_blkdevs.c
===================================================================
--- linux.orig/drivers/mtd/mtd_blkdevs.c	2007-03-02 14:46:29.000000000 +0000
+++ linux/drivers/mtd/mtd_blkdevs.c	2007-03-02 14:46:47.000000000 +0000
@@ -204,9 +204,10 @@ static int blktrans_getgeo(struct block_
 	return -ENOTTY;
 }
 
-static int blktrans_ioctl(struct inode *inode, struct file *file,
-			      unsigned int cmd, unsigned long arg)
+static long blktrans_unlocked_ioctl(struct file *file, unsigned cmd,
+				unsigned long arg)
 {
+	struct inode *inode = file->f_dentry->d_inode;
 	struct mtd_blktrans_dev *dev = inode->i_bdev->bd_disk->private_data;
 	struct mtd_blktrans_ops *tr = dev->tr;
 
@@ -217,6 +218,8 @@ static int blktrans_ioctl(struct inode *
 		/* The core code did the work, we had nothing to do. */
 		return 0;
 	default:
+		if (tr->ioctl)
+			return tr->ioctl(dev, cmd, arg);
 		return -ENOTTY;
 	}
 }
@@ -225,7 +228,7 @@ struct block_device_operations mtd_blktr
 	.owner		= THIS_MODULE,
 	.open		= blktrans_open,
 	.release	= blktrans_release,
-	.ioctl		= blktrans_ioctl,
+	.unlocked_ioctl = blktrans_unlocked_ioctl,
 	.getgeo		= blktrans_getgeo,
 };
 
@@ -312,6 +315,11 @@ int add_mtd_blktrans_dev(struct mtd_blkt
 	return 0;
 }
 
+struct gendisk *get_mtd_blktrans_gendisk(struct mtd_blktrans_dev *dev)
+{
+	return dev->blkcore_priv;
+}
+
 int del_mtd_blktrans_dev(struct mtd_blktrans_dev *old)
 {
 	if (!!mutex_trylock(&mtd_table_mutex)) {
Index: linux/include/linux/mtd/blktrans.h
===================================================================
--- linux.orig/include/linux/mtd/blktrans.h	2007-02-28 18:16:52.000000000 +0000
+++ linux/include/linux/mtd/blktrans.h	2007-03-02 14:46:47.000000000 +0000
@@ -11,6 +11,7 @@
 #define __MTD_TRANS_H__
 
 #include <linux/mutex.h>
+#include <linux/genhd.h>
 
 struct hd_geometry;
 struct mtd_info;
@@ -48,6 +49,9 @@ struct mtd_blktrans_ops {
 	int (*getgeo)(struct mtd_blktrans_dev *dev, struct hd_geometry *geo);
 	int (*flush)(struct mtd_blktrans_dev *dev);
 
+	/* Optional ioctl passthrough */
+	int (*ioctl)(struct mtd_blktrans_dev *dev, unsigned int cmd, unsigned long arg);
+
 	/* Called with mtd_table_mutex held; no race with add/remove */
 	int (*open)(struct mtd_blktrans_dev *dev);
 	int (*release)(struct mtd_blktrans_dev *dev);
@@ -68,6 +72,7 @@ extern int register_mtd_blktrans(struct 
 extern int deregister_mtd_blktrans(struct mtd_blktrans_ops *tr);
 extern int add_mtd_blktrans_dev(struct mtd_blktrans_dev *dev);
 extern int del_mtd_blktrans_dev(struct mtd_blktrans_dev *dev);
+extern struct gendisk *get_mtd_blktrans_gendisk(struct mtd_blktrans_dev *dev);
 
 
 #endif /* __MTD_TRANS_H__ */


