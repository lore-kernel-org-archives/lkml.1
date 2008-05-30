Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbYEaAAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbYEaAAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 20:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbYE3X7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 19:59:08 -0400
Received: from host217-43-228-68.range217-43.btcentralplus.com ([217.43.228.68]:37131
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753461AbYE3X6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 19:58:34 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2 of 5] xn/blkfront: Add the CDROM_GET_CAPABILITY ioctl to
	blkfront
X-Mercurial-Node: 84dc2b8e1677cbc6f5ece6aa6a9be09291f2bbb5
Message-Id: <84dc2b8e1677cbc6f5ec.1212191402@localhost>
In-Reply-To: <patchbomb.1212191400@localhost>
Date: Sat, 31 May 2008 00:50:02 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Jeff Garzik <jgarzik.pobox.com@goop.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Limpach <Christian.Limpach@xensource.com>

Return 0 instead of -EINVAL if the blkfront device is a cdrom,
i.e. had the VDISK_CDROM attribute.  This allows udev's cdrom_id
to correctly detect the device as a cdrom device.

[ Add blkif_ioctl, and CDROMMULTISESSION ]

[ linux-2.6.18-xen changeset d2bd9af846b5 ]

Signed-off-by: Christian Limpach <Christian.Limpach@xensource.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/block/xen-blkfront.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -38,6 +38,7 @@
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
 #include <linux/hdreg.h>
+#include <linux/cdrom.h>
 #include <linux/module.h>
 
 #include <xen/xenbus.h>
@@ -150,6 +151,40 @@
 	hg->cylinders = cylinders;
 	if ((sector_t)(hg->cylinders + 1) * hg->heads * hg->sectors < nsect)
 		hg->cylinders = 0xffff;
+	return 0;
+}
+
+int blkif_ioctl(struct inode *inode, struct file *filep,
+		unsigned command, unsigned long argument)
+{
+	struct blkfront_info *info =
+		inode->i_bdev->bd_disk->private_data;
+	int i;
+
+	dev_dbg(&info->xbdev->dev, "command: 0x%x, argument: 0x%lx\n",
+		command, (long)argument);
+
+	switch (command) {
+	case CDROMMULTISESSION:
+		dev_dbg(&info->xbdev->dev, "FIXME: support multisession CDs later\n");
+		for (i = 0; i < sizeof(struct cdrom_multisession); i++)
+			if (put_user(0, (char __user *)(argument + i)))
+				return -EFAULT;
+		return 0;
+
+	case CDROM_GET_CAPABILITY: {
+		struct gendisk *gd = info->gd;
+		if (gd->flags & GENHD_FL_CD)
+			return 0;
+		return -EINVAL;
+	}
+
+	default:
+		/*printk(KERN_ALERT "ioctl %08x not supported by Xen blkdev\n",
+		  command);*/
+		return -EINVAL; /* same return as native Linux */
+	}
+
 	return 0;
 }
 
@@ -974,6 +1009,7 @@
 	.open = blkif_open,
 	.release = blkif_release,
 	.getgeo = blkif_getgeo,
+	.ioctl = blkif_ioctl,
 };
 
 


