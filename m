Return-Path: <linux-kernel-owner+w=401wt.eu-S1758303AbYFPVqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303AbYFPVqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 17:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756213AbYFPVpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 17:45:40 -0400
Received: from gw.goop.org ([64.81.55.164]:45414 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755902AbYFPVpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 17:45:39 -0400
Message-ID: <4856DED9.8080605@goop.org>
Date: Mon, 16 Jun 2008 14:44:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christian Limpach <Christian.Limpach@eu.citrix.com>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [PATCH 2/5] xen/blkfront: Add the CDROM_GET_CAPABILITY ioctl to blkfront.
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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

===================================================================
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
 
 


