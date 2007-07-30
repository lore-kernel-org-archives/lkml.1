Return-Path: <linux-kernel-owner+w=401wt.eu-S969056AbXG3WAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969056AbXG3WAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968992AbXG3WAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:00:35 -0400
Received: from verein.lst.de ([213.95.11.210]:50978 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968964AbXG3WAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:00:34 -0400
Date: Tue, 31 Jul 2007 00:00:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sysace: HDIO_GETGEO has it's own method for ages
Message-ID: <20070730220029.GA28003@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The way this driver triesto implement HDIO_GETGEO it'll never be
called.  Then again on ppc it probably will never be called anyway
because it's utterly pointless.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/block/xsysace.c
===================================================================
--- linux-2.6.orig/drivers/block/xsysace.c	2007-07-30 22:53:11.000000000 +0200
+++ linux-2.6/drivers/block/xsysace.c	2007-07-30 22:54:43.000000000 +0200
@@ -902,26 +902,17 @@ static int ace_release(struct inode *ino
 	return 0;
 }
 
-static int ace_ioctl(struct inode *inode, struct file *filp,
-		     unsigned int cmd, unsigned long arg)
+static int ace_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 {
-	struct ace_device *ace = inode->i_bdev->bd_disk->private_data;
-	struct hd_geometry __user *geo = (struct hd_geometry __user *)arg;
-	struct hd_geometry g;
-	dev_dbg(ace->dev, "ace_ioctl()\n");
-
-	switch (cmd) {
-	case HDIO_GETGEO:
-		g.heads = ace->cf_id.heads;
-		g.sectors = ace->cf_id.sectors;
-		g.cylinders = ace->cf_id.cyls;
-		g.start = 0;
-		return copy_to_user(geo, &g, sizeof(g)) ? -EFAULT : 0;
+	struct ace_device *ace = bdev->bd_disk->private_data;
 
-	default:
-		return -ENOTTY;
-	}
-	return -ENOTTY;
+	dev_dbg(ace->dev, "ace_getgeo()\n");
+
+	geo->heads = ace->cf_id.heads;
+	geo->sectors = ace->cf_id.sectors;
+	geo->cylinders = ace->cf_id.cyls;
+
+	return 0;
 }
 
 static struct block_device_operations ace_fops = {
@@ -930,7 +921,7 @@ static struct block_device_operations ac
 	.release = ace_release,
 	.media_changed = ace_media_changed,
 	.revalidate_disk = ace_revalidate_disk,
-	.ioctl = ace_ioctl,
+	.getgeo = ace_getgeo,
 };
 
 /* --------------------------------------------------------------------
