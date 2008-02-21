Return-Path: <linux-kernel-owner+w=401wt.eu-S932426AbYBUVGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426AbYBUVGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 16:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759740AbYBUVGC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 16:06:02 -0500
Received: from gw.goop.org ([64.81.55.164]:34640 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756875AbYBUVGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 16:06:00 -0500
Message-ID: <47BDE731.60801@goop.org>
Date: Thu, 21 Feb 2008 13:03:45 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen: Implement getgeo for Xen virtual block device.
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below implements the getgeo hook for Xen block devices. Extracted
from the xen-unstable tree where it has been used for ages.

It is useful to have because it allows things like grub2 (used by the
Debian installer images) to work in a guest domain without having to
sprinkle Xen specific hacks around the place.

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
From: Ian Campbell <ijc@hellion.org.uk>
Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 drivers/block/xen-blkfront.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

===================================================================
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -37,6 +37,7 @@
 
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
+#include <linux/hdreg.h>
 #include <linux/module.h>
 
 #include <xen/xenbus.h>
@@ -134,6 +135,22 @@ static void blkif_restart_queue_callback
 {
 	struct blkfront_info *info = (struct blkfront_info *)arg;
 	schedule_work(&info->work);
+}
+
+int blkif_getgeo(struct block_device *bd, struct hd_geometry *hg)
+{
+	/* We don't have real geometry info, but let's at least return
+	   values consistent with the size of the device */
+	sector_t nsect = get_capacity(bd->bd_disk);
+	sector_t cylinders = nsect;
+
+	hg->heads = 0xff;
+	hg->sectors = 0x3f;
+	sector_div(cylinders, hg->heads * hg->sectors);
+	hg->cylinders = cylinders;
+	if ((sector_t)(hg->cylinders + 1) * hg->heads * hg->sectors < nsect)
+		hg->cylinders = 0xffff;
+	return 0;
 }
 
 /*
@@ -946,6 +963,7 @@ static struct block_device_operations xl
 	.owner = THIS_MODULE,
 	.open = blkif_open,
 	.release = blkif_release,
+	.getgeo = blkif_getgeo,
 };
 
 

