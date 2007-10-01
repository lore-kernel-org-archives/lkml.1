Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbXJAP5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbXJAP5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 11:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbXJAP5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 11:57:43 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:32988 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbXJAP5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 11:57:42 -0400
Date: Mon, 01 Oct 2007 09:57:38 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 2/6] Xilinxfb: Replace calls to printk with dev_dbg, dev_err,
	etc.
In-reply-to: <20071001155024.6114.47993.stgit@trillian.cg.shawcable.net>
To: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       akonovalov@ru.mvista.com, linuxppc@ozlabs.org, adaplas@gmail.com
Message-id: <20071001155738.6114.51384.stgit@trillian.cg.shawcable.net>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <20071001155024.6114.47993.stgit@trillian.cg.shawcable.net>
User-Agent: StGIT/0.12.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

The dev_dbg, dev_err, etc functions provide more context that plain
vanilla printk which is useful for debugging.  Where appropriate,
change printk calls to the appropriate dev_*() call.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/video/xilinxfb.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index 1a5f1e4..e63cbd1 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -18,6 +18,7 @@
  * Geert Uytterhoeven.
  */
 
+#include <linux/device.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/version.h>
@@ -214,7 +215,7 @@ xilinxfb_drv_probe(struct device *dev)
 
 	drvdata = kzalloc(sizeof(*drvdata), GFP_KERNEL);
 	if (!drvdata) {
-		printk(KERN_ERR "Couldn't allocate device private record\n");
+		dev_err(dev, "Couldn't allocate device private record\n");
 		return -ENOMEM;
 	}
 	dev_set_drvdata(dev, drvdata);
@@ -222,14 +223,13 @@ xilinxfb_drv_probe(struct device *dev)
 	/* Map the control registers in */
 	regs_res = platform_get_resource(pdev, IORESOURCE_IO, 0);
 	if (!regs_res || (regs_res->end - regs_res->start + 1 < 8)) {
-		printk(KERN_ERR "Couldn't get registers resource\n");
+		dev_err(dev, "Couldn't get registers resource\n");
 		retval = -EFAULT;
 		goto failed1;
 	}
 
 	if (!request_mem_region(regs_res->start, 8, DRIVER_NAME)) {
-		printk(KERN_ERR
-		       "Couldn't lock memory region at 0x%08X\n",
+		dev_err(dev, "Couldn't lock memory region at 0x%08X\n",
 		       regs_res->start);
 		retval = -EBUSY;
 		goto failed1;
@@ -241,7 +241,7 @@ xilinxfb_drv_probe(struct device *dev)
 	drvdata->fb_virt = dma_alloc_coherent(dev, PAGE_ALIGN(FB_SIZE),
 				&drvdata->fb_phys, GFP_KERNEL);
 	if (!drvdata->fb_virt) {
-		printk(KERN_ERR "Could not allocate frame buffer memory\n");
+		dev_err(dev, "Could not allocate frame buffer memory\n");
 		retval = -ENOMEM;
 		goto failed2;
 	}
@@ -267,7 +267,7 @@ xilinxfb_drv_probe(struct device *dev)
 	drvdata->info.pseudo_palette = drvdata->pseudo_palette;
 
 	if (fb_alloc_cmap(&drvdata->info.cmap, PALETTE_ENTRIES_NO, 0) < 0) {
-		printk(KERN_ERR "Fail to allocate colormap (%d entries)\n",
+		dev_err(dev, "Fail to allocate colormap (%d entries)\n",
 			PALETTE_ENTRIES_NO);
 		retval = -EFAULT;
 		goto failed3;
@@ -282,7 +282,7 @@ xilinxfb_drv_probe(struct device *dev)
 
 	/* Register new frame buffer */
 	if (register_framebuffer(&drvdata->info) < 0) {
-		printk(KERN_ERR "Could not register frame buffer\n");
+		dev_err(dev, "Could not register frame buffer\n");
 		retval = -EINVAL;
 		goto failed4;
 	}

