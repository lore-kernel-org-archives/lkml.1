Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbXJAP6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbXJAP6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 11:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755684AbXJAP6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 11:58:09 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:46722 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694AbXJAP6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 11:58:06 -0400
Date: Mon, 01 Oct 2007 09:57:43 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 3/6] Xilinxfb: rename failout labels to reflect failure
In-reply-to: <20071001155024.6114.47993.stgit@trillian.cg.shawcable.net>
To: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       akonovalov@ru.mvista.com, linuxppc@ozlabs.org, adaplas@gmail.com
Message-id: <20071001155743.6114.558.stgit@trillian.cg.shawcable.net>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <20071001155024.6114.47993.stgit@trillian.cg.shawcable.net>
User-Agent: StGIT/0.12.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Labels and gotos are used in xilinxfb_assign to unwind allocations
on device registration failures.  Rename the labels to reflect the
error which occured.  This change is being made to make it easier
to add new failout paths (which occurs in a subsuquent patch) and
to make reviewing the failout path easier.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/video/xilinxfb.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index e63cbd1..9aa754a 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -225,14 +225,14 @@ xilinxfb_drv_probe(struct device *dev)
 	if (!regs_res || (regs_res->end - regs_res->start + 1 < 8)) {
 		dev_err(dev, "Couldn't get registers resource\n");
 		retval = -EFAULT;
-		goto failed1;
+		goto err_region;
 	}
 
 	if (!request_mem_region(regs_res->start, 8, DRIVER_NAME)) {
 		dev_err(dev, "Couldn't lock memory region at 0x%08X\n",
 		       regs_res->start);
 		retval = -EBUSY;
-		goto failed1;
+		goto err_region;
 	}
 	drvdata->regs = (u32 __iomem*) ioremap(regs_res->start, 8);
 	drvdata->regs_phys = regs_res->start;
@@ -243,7 +243,7 @@ xilinxfb_drv_probe(struct device *dev)
 	if (!drvdata->fb_virt) {
 		dev_err(dev, "Could not allocate frame buffer memory\n");
 		retval = -ENOMEM;
-		goto failed2;
+		goto err_fbmem;
 	}
 
 	/* Clear (turn to black) the framebuffer */
@@ -270,7 +270,7 @@ xilinxfb_drv_probe(struct device *dev)
 		dev_err(dev, "Fail to allocate colormap (%d entries)\n",
 			PALETTE_ENTRIES_NO);
 		retval = -EFAULT;
-		goto failed3;
+		goto err_cmap;
 	}
 
 	drvdata->info.flags = FBINFO_DEFAULT;
@@ -284,7 +284,7 @@ xilinxfb_drv_probe(struct device *dev)
 	if (register_framebuffer(&drvdata->info) < 0) {
 		dev_err(dev, "Could not register frame buffer\n");
 		retval = -EINVAL;
-		goto failed4;
+		goto err_regfb;
 	}
 
 	/* Put a banner in the log (for DEBUG) */
@@ -294,10 +294,10 @@ xilinxfb_drv_probe(struct device *dev)
 		(void*)drvdata->fb_phys, drvdata->fb_virt, FB_SIZE);
 	return 0;	/* success */
 
-failed4:
+err_regfb:
 	fb_dealloc_cmap(&drvdata->info.cmap);
 
-failed3:
+err_cmap:
 	dma_free_coherent(dev, PAGE_ALIGN(FB_SIZE), drvdata->fb_virt,
 		drvdata->fb_phys);
 
@@ -305,10 +305,10 @@ failed3:
 	xilinx_fb_out_be32(drvdata, REG_CTRL, 0);
 	iounmap(drvdata->regs);
 
-failed2:
+err_fbmem:
 	release_mem_region(regs_res->start, 8);
 
-failed1:
+err_region:
 	kfree(drvdata);
 	dev_set_drvdata(dev, NULL);
 

