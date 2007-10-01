Return-Path: <linux-kernel-owner+w=401wt.eu-S1756313AbXJAP7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313AbXJAP7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 11:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755929AbXJAP6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 11:58:40 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:34857 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920AbXJAP6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 11:58:38 -0400
Date: Mon, 01 Oct 2007 09:57:49 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 4/6] xilinxfb: Split device setup from bus binding
In-reply-to: <20071001155024.6114.47993.stgit@trillian.cg.shawcable.net>
To: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       akonovalov@ru.mvista.com, linuxppc@ozlabs.org, adaplas@gmail.com
Message-id: <20071001155748.6114.39929.stgit@trillian.cg.shawcable.net>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <20071001155024.6114.47993.stgit@trillian.cg.shawcable.net>
User-Agent: StGIT/0.12.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Split the device setup code away from the platform bus binding.  This is
in preparation for adding the of_platform bus binding to this driver and
most of the setup code is common between the two busses.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/video/xilinxfb.c |  133 ++++++++++++++++++++++++++++------------------
 1 files changed, 80 insertions(+), 53 deletions(-)

diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index 9aa754a..12d9127 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -196,23 +196,17 @@ static struct fb_ops xilinxfb_ops =
 	.fb_imageblit		= cfb_imageblit,
 };
 
-/* === The device driver === */
+/* ---------------------------------------------------------------------
+ * Bus independent setup/teardown
+ */
 
-static int
-xilinxfb_drv_probe(struct device *dev)
+static int xilinxfb_assign(struct device *dev, unsigned long physaddr,
+			   int width_mm, int height_mm, int rotate)
 {
-	struct platform_device *pdev;
-	struct xilinxfb_platform_data *pdata;
 	struct xilinxfb_drvdata *drvdata;
-	struct resource *regs_res;
-	int retval;
-
-	if (!dev)
-		return -EINVAL;
-
-	pdev = to_platform_device(dev);
-	pdata = pdev->dev.platform_data;
+	int rc;
 
+	/* Allocate the driver data region */
 	drvdata = kzalloc(sizeof(*drvdata), GFP_KERNEL);
 	if (!drvdata) {
 		dev_err(dev, "Couldn't allocate device private record\n");
@@ -221,40 +215,39 @@ xilinxfb_drv_probe(struct device *dev)
 	dev_set_drvdata(dev, drvdata);
 
 	/* Map the control registers in */
-	regs_res = platform_get_resource(pdev, IORESOURCE_IO, 0);
-	if (!regs_res || (regs_res->end - regs_res->start + 1 < 8)) {
-		dev_err(dev, "Couldn't get registers resource\n");
-		retval = -EFAULT;
+	if (!request_mem_region(physaddr, 8, DRIVER_NAME)) {
+		dev_err(dev, "Couldn't lock memory region at 0x%08lX\n",
+			physaddr);
+		rc = -ENODEV;
 		goto err_region;
 	}
-
-	if (!request_mem_region(regs_res->start, 8, DRIVER_NAME)) {
-		dev_err(dev, "Couldn't lock memory region at 0x%08X\n",
-		       regs_res->start);
-		retval = -EBUSY;
-		goto err_region;
+	drvdata->regs_phys = physaddr;
+	drvdata->regs = ioremap(physaddr, 8);
+	if (!drvdata->regs) {
+		dev_err(dev, "Couldn't lock memory region at 0x%08lX\n",
+			physaddr);
+		rc = -ENODEV;
+		goto err_map;
 	}
-	drvdata->regs = (u32 __iomem*) ioremap(regs_res->start, 8);
-	drvdata->regs_phys = regs_res->start;
 
 	/* Allocate the framebuffer memory */
 	drvdata->fb_virt = dma_alloc_coherent(dev, PAGE_ALIGN(FB_SIZE),
 				&drvdata->fb_phys, GFP_KERNEL);
 	if (!drvdata->fb_virt) {
 		dev_err(dev, "Could not allocate frame buffer memory\n");
-		retval = -ENOMEM;
+		rc = -ENOMEM;
 		goto err_fbmem;
 	}
 
 	/* Clear (turn to black) the framebuffer */
-	memset_io((void *) drvdata->fb_virt, 0, FB_SIZE);
+	memset_io(drvdata->fb_virt, 0, FB_SIZE);
 
 	/* Tell the hardware where the frame buffer is */
 	xilinx_fb_out_be32(drvdata, REG_FB_ADDR, drvdata->fb_phys);
 
 	/* Turn on the display */
 	drvdata->reg_ctrl_default = REG_CTRL_ENABLE;
-	if (pdata && pdata->rotate_screen)
+	if (rotate)
 		drvdata->reg_ctrl_default |= REG_CTRL_ROTATE;
 	xilinx_fb_out_be32(drvdata, REG_CTRL, drvdata->reg_ctrl_default);
 
@@ -265,31 +258,29 @@ xilinxfb_drv_probe(struct device *dev)
 	drvdata->info.fix = xilinx_fb_fix;
 	drvdata->info.fix.smem_start = drvdata->fb_phys;
 	drvdata->info.pseudo_palette = drvdata->pseudo_palette;
+	drvdata->info.flags = FBINFO_DEFAULT;
+	drvdata->info.var = xilinx_fb_var;
+
+	xilinx_fb_var.height = height_mm;
+	xilinx_fb_var.width = width_mm;
 
-	if (fb_alloc_cmap(&drvdata->info.cmap, PALETTE_ENTRIES_NO, 0) < 0) {
+	/* Allocate a colour map */
+	rc = fb_alloc_cmap(&drvdata->info.cmap, PALETTE_ENTRIES_NO, 0);
+	if (rc) {
 		dev_err(dev, "Fail to allocate colormap (%d entries)\n",
 			PALETTE_ENTRIES_NO);
-		retval = -EFAULT;
 		goto err_cmap;
 	}
 
-	drvdata->info.flags = FBINFO_DEFAULT;
-	if (pdata) {
-		xilinx_fb_var.height = pdata->screen_height_mm;
-		xilinx_fb_var.width = pdata->screen_width_mm;
-	}
-	drvdata->info.var = xilinx_fb_var;
-
 	/* Register new frame buffer */
-	if (register_framebuffer(&drvdata->info) < 0) {
+	rc = register_framebuffer(&drvdata->info);
+	if (rc) {
 		dev_err(dev, "Could not register frame buffer\n");
-		retval = -EINVAL;
 		goto err_regfb;
 	}
 
 	/* Put a banner in the log (for DEBUG) */
-	dev_dbg(dev, "regs: phys=%x, virt=%p\n",
-		drvdata->regs_phys, drvdata->regs);
+	dev_dbg(dev, "regs: phys=%lx, virt=%p\n", physaddr, drvdata->regs);
 	dev_dbg(dev, "fb: phys=%p, virt=%p, size=%x\n",
 		(void*)drvdata->fb_phys, drvdata->fb_virt, FB_SIZE);
 	return 0;	/* success */
@@ -300,30 +291,25 @@ err_regfb:
 err_cmap:
 	dma_free_coherent(dev, PAGE_ALIGN(FB_SIZE), drvdata->fb_virt,
 		drvdata->fb_phys);
-
 	/* Turn off the display */
 	xilinx_fb_out_be32(drvdata, REG_CTRL, 0);
-	iounmap(drvdata->regs);
 
 err_fbmem:
-	release_mem_region(regs_res->start, 8);
+	iounmap(drvdata->regs);
+
+err_map:
+	release_mem_region(physaddr, 8);
 
 err_region:
 	kfree(drvdata);
 	dev_set_drvdata(dev, NULL);
 
-	return retval;
+	return rc;
 }
 
-static int
-xilinxfb_drv_remove(struct device *dev)
+static int xilinxfb_release(struct device *dev)
 {
-	struct xilinxfb_drvdata *drvdata;
-
-	if (!dev)
-		return -ENODEV;
-
-	drvdata = (struct xilinxfb_drvdata *) dev_get_drvdata(dev);
+	struct xilinxfb_drvdata *drvdata = dev_get_drvdata(dev);
 
 #if !defined(CONFIG_FRAMEBUFFER_CONSOLE) && defined(CONFIG_LOGO)
 	xilinx_fb_blank(VESA_POWERDOWN, &drvdata->info);
@@ -348,6 +334,47 @@ xilinxfb_drv_remove(struct device *dev)
 	return 0;
 }
 
+/* ---------------------------------------------------------------------
+ * Platform bus binding
+ */
+
+static int
+xilinxfb_drv_probe(struct device *dev)
+{
+	struct platform_device *pdev;
+	struct xilinxfb_platform_data *pdata;
+	struct resource *res;
+	int width_mm;
+	int height_mm;
+	int rotate;
+
+	pdev = to_platform_device(dev);
+	pdata = pdev->dev.platform_data;
+	if (!pdata) {
+		dev_err(dev, "Missing pdata structure\n");
+		return -ENODEV;
+	}
+
+	/* Find the registers address */
+	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (!res) {
+		dev_err(dev, "Couldn't get registers resource\n");
+		return -ENODEV;
+	}
+
+	height_mm = pdata->screen_height_mm;
+	width_mm = pdata->screen_width_mm;
+	rotate = pdata->rotate_screen ? 1 : 0;
+
+	return xilinxfb_assign(dev, res->start, width_mm, height_mm, rotate);
+}
+
+static int
+xilinxfb_drv_remove(struct device *dev)
+{
+	return xilinxfb_release(dev);
+}
+
 
 static struct device_driver xilinxfb_driver = {
 	.name		= DRIVER_NAME,

