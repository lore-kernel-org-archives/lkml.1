Return-Path: <linux-kernel-owner+w=401wt.eu-S1762778AbZEHOE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762778AbZEHOE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 10:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756616AbZEHOBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 10:01:33 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:58241 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758197AbZEHOBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 10:01:32 -0400
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: cbe-oss-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH 06/15] ps3fb: Inline functions in ps3fb_probe(), to ease cleanup in the error path
Date: Fri,  8 May 2009 16:01:15 +0200
Message-Id: <1241791284-11490-7-git-send-email-Geert.Uytterhoeven@sonycom.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241791284-11490-6-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1241791284-11490-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-6-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 drivers/video/ps3fb.c |  192 ++++++++++++++++++++++---------------------------
 1 files changed, 86 insertions(+), 106 deletions(-)

diff --git a/drivers/video/ps3fb.c b/drivers/video/ps3fb.c
index ce0f873..a745018 100644
--- a/drivers/video/ps3fb.c
+++ b/drivers/video/ps3fb.c
@@ -956,73 +956,6 @@ static irqreturn_t ps3fb_vsync_interrupt(int irq, void *ptr)
 }
 
 
-static int ps3fb_vsync_settings(struct gpu_driver_info *dinfo,
-				struct device *dev)
-{
-	int error;
-
-	dev_dbg(dev, "version_driver:%x\n", dinfo->version_driver);
-	dev_dbg(dev, "irq outlet:%x\n", dinfo->irq.irq_outlet);
-	dev_dbg(dev,
-		"version_gpu: %x memory_size: %x ch: %x core_freq: %d "
-		"mem_freq:%d\n",
-		dinfo->version_gpu, dinfo->memory_size, dinfo->hardware_channel,
-		dinfo->nvcore_frequency/1000000, dinfo->memory_frequency/1000000);
-
-	if (dinfo->version_driver != GPU_DRIVER_INFO_VERSION) {
-		dev_err(dev, "%s: version_driver err:%x\n", __func__,
-			dinfo->version_driver);
-		return -EINVAL;
-	}
-
-	error = ps3_irq_plug_setup(PS3_BINDING_CPU_ANY, dinfo->irq.irq_outlet,
-				   &ps3fb.irq_no);
-	if (error) {
-		dev_err(dev, "%s: ps3_alloc_irq failed %d\n", __func__, error);
-		return error;
-	}
-
-	error = request_irq(ps3fb.irq_no, ps3fb_vsync_interrupt, IRQF_DISABLED,
-			    DEVICE_NAME, dev);
-	if (error) {
-		dev_err(dev, "%s: request_irq failed %d\n", __func__, error);
-		ps3_irq_plug_destroy(ps3fb.irq_no);
-		return error;
-	}
-
-	dinfo->irq.mask = (1 << GPU_INTR_STATUS_VSYNC_1) |
-			  (1 << GPU_INTR_STATUS_FLIP_1);
-	return 0;
-}
-
-static int ps3fb_xdr_settings(u64 xdr_lpar, struct device *dev)
-{
-	int status;
-
-	status = lv1_gpu_context_iomap(ps3fb.context_handle, GPU_IOIF,
-				       xdr_lpar, ps3fb_videomemory.size, 0);
-	if (status) {
-		dev_err(dev, "%s: lv1_gpu_context_iomap failed: %d\n",
-			__func__, status);
-		return -ENXIO;
-	}
-	dev_dbg(dev, "video:%p ioif:%lx lpar:%llx size:%lx\n",
-		ps3fb_videomemory.address, GPU_IOIF, xdr_lpar,
-		ps3fb_videomemory.size);
-
-	status = lv1_gpu_context_attribute(ps3fb.context_handle,
-					   L1GPU_CONTEXT_ATTRIBUTE_FB_SETUP,
-					   xdr_lpar, GPU_CMD_BUF_SIZE,
-					   GPU_IOIF, 0);
-	if (status) {
-		dev_err(dev,
-			"%s: lv1_gpu_context_attribute FB_SETUP failed: %d\n",
-			__func__, status);
-		return -ENXIO;
-	}
-	return 0;
-}
-
 static struct fb_ops ps3fb_ops = {
 	.fb_open	= ps3fb_open,
 	.fb_release	= ps3fb_release,
@@ -1048,38 +981,6 @@ static struct fb_fix_screeninfo ps3fb_fix __initdata = {
 	.accel =	FB_ACCEL_NONE,
 };
 
-static int ps3fb_set_sync(struct device *dev)
-{
-	int status;
-
-#ifdef HEAD_A
-	status = lv1_gpu_context_attribute(0x0,
-					   L1GPU_CONTEXT_ATTRIBUTE_DISPLAY_SYNC,
-					   0, L1GPU_DISPLAY_SYNC_VSYNC, 0, 0);
-	if (status) {
-		dev_err(dev,
-			"%s: lv1_gpu_context_attribute DISPLAY_SYNC failed: "
-			"%d\n",
-			__func__, status);
-		return -1;
-	}
-#endif
-#ifdef HEAD_B
-	status = lv1_gpu_context_attribute(0x0,
-					   L1GPU_CONTEXT_ATTRIBUTE_DISPLAY_SYNC,
-					   1, L1GPU_DISPLAY_SYNC_VSYNC, 0, 0);
-
-	if (status) {
-		dev_err(dev,
-			"%s: lv1_gpu_context_attribute DISPLAY_SYNC failed: "
-			"%d\n",
-			__func__, status);
-		return -1;
-	}
-#endif
-	return 0;
-}
-
 static int __devinit ps3fb_probe(struct ps3_system_bus_device *dev)
 {
 	struct fb_info *info;
@@ -1091,6 +992,7 @@ static int __devinit ps3fb_probe(struct ps3_system_bus_device *dev)
 	u64 lpar_reports = 0;
 	u64 lpar_reports_size = 0;
 	u64 xdr_lpar;
+	struct gpu_driver_info *dinfo;
 	void *fb_start;
 	int status;
 	struct task_struct *task;
@@ -1116,7 +1018,31 @@ static int __devinit ps3fb_probe(struct ps3_system_bus_device *dev)
 	atomic_set(&ps3fb.ext_flip, 0);	/* for flip with vsync */
 	init_waitqueue_head(&ps3fb.wait_vsync);
 
-	ps3fb_set_sync(&dev->core);
+#ifdef HEAD_A
+	status = lv1_gpu_context_attribute(0x0,
+					   L1GPU_CONTEXT_ATTRIBUTE_DISPLAY_SYNC,
+					   0, L1GPU_DISPLAY_SYNC_VSYNC, 0, 0);
+	if (status) {
+		dev_err(&dev->core,
+			"%s: lv1_gpu_context_attribute DISPLAY_SYNC failed: "
+			"%d\n",
+			__func__, status);
+		goto err;
+	}
+#endif
+#ifdef HEAD_B
+	status = lv1_gpu_context_attribute(0x0,
+					   L1GPU_CONTEXT_ATTRIBUTE_DISPLAY_SYNC,
+					   1, L1GPU_DISPLAY_SYNC_VSYNC, 0, 0);
+
+	if (status) {
+		dev_err(&dev->core,
+			"%s: lv1_gpu_context_attribute DISPLAY_SYNC failed: "
+			"%d\n",
+			__func__, status);
+		goto err;
+	}
+#endif
 
 	max_ps3fb_size = _ALIGN_UP(GPU_IOIF, 256*1024*1024) - GPU_IOIF;
 	if (ps3fb_videomemory.size > max_ps3fb_size) {
@@ -1147,23 +1073,76 @@ static int __devinit ps3fb_probe(struct ps3_system_bus_device *dev)
 	}
 
 	/* vsync interrupt */
-	ps3fb.dinfo = (void __force *)ioremap(lpar_driver_info, 128 * 1024);
-	if (!ps3fb.dinfo) {
+	dinfo = (void __force *)ioremap(lpar_driver_info, 128 * 1024);
+	if (!dinfo) {
 		dev_err(&dev->core, "%s: ioremap failed\n", __func__);
 		goto err_gpu_context_free;
 	}
 
-	retval = ps3fb_vsync_settings(ps3fb.dinfo, &dev->core);
-	if (retval)
+	ps3fb.dinfo = dinfo;
+	dev_dbg(&dev->core, "version_driver:%x\n", dinfo->version_driver);
+	dev_dbg(&dev->core, "irq outlet:%x\n", dinfo->irq.irq_outlet);
+	dev_dbg(&dev->core, "version_gpu: %x memory_size: %x ch: %x "
+		"core_freq: %d mem_freq:%d\n", dinfo->version_gpu,
+		dinfo->memory_size, dinfo->hardware_channel,
+		dinfo->nvcore_frequency/1000000,
+		dinfo->memory_frequency/1000000);
+
+	if (dinfo->version_driver != GPU_DRIVER_INFO_VERSION) {
+		dev_err(&dev->core, "%s: version_driver err:%x\n", __func__,
+			dinfo->version_driver);
+		retval = -EINVAL;
 		goto err_iounmap_dinfo;
+	}
+
+	retval = ps3_irq_plug_setup(PS3_BINDING_CPU_ANY, dinfo->irq.irq_outlet,
+				    &ps3fb.irq_no);
+	if (retval) {
+		dev_err(&dev->core, "%s: ps3_alloc_irq failed %d\n", __func__,
+			retval);
+		goto err_iounmap_dinfo;
+	}
+
+	retval = request_irq(ps3fb.irq_no, ps3fb_vsync_interrupt,
+			     IRQF_DISABLED, DEVICE_NAME, &dev->core);
+	if (retval) {
+		dev_err(&dev->core, "%s: request_irq failed %d\n", __func__,
+			retval);
+		goto err_destroy_plug;
+	}
+
+	dinfo->irq.mask = (1 << GPU_INTR_STATUS_VSYNC_1) |
+			  (1 << GPU_INTR_STATUS_FLIP_1);
 
 	/* Clear memory to prevent kernel info leakage into userspace */
 	memset(ps3fb_videomemory.address, 0, ps3fb_videomemory.size);
 
 	xdr_lpar = ps3_mm_phys_to_lpar(__pa(ps3fb_videomemory.address));
-	retval = ps3fb_xdr_settings(xdr_lpar, &dev->core);
-	if (retval)
+
+	status = lv1_gpu_context_iomap(ps3fb.context_handle, GPU_IOIF,
+				       xdr_lpar, ps3fb_videomemory.size, 0);
+	if (status) {
+		dev_err(&dev->core, "%s: lv1_gpu_context_iomap failed: %d\n",
+			__func__, status);
+		retval =  -ENXIO;
+		goto err_free_irq;
+	}
+
+	dev_dbg(&dev->core, "video:%p ioif:%lx lpar:%llx size:%lx\n",
+		ps3fb_videomemory.address, GPU_IOIF, xdr_lpar,
+		ps3fb_videomemory.size);
+
+	status = lv1_gpu_context_attribute(ps3fb.context_handle,
+					   L1GPU_CONTEXT_ATTRIBUTE_FB_SETUP,
+					   xdr_lpar, GPU_CMD_BUF_SIZE,
+					   GPU_IOIF, 0);
+	if (status) {
+		dev_err(&dev->core,
+			"%s: lv1_gpu_context_attribute FB_SETUP failed: %d\n",
+			__func__, status);
+		retval = -ENXIO;
 		goto err_free_irq;
+	}
 
 	info = framebuffer_alloc(sizeof(struct ps3fb_par), &dev->core);
 	if (!info)
@@ -1234,6 +1213,7 @@ err_framebuffer_release:
 	framebuffer_release(info);
 err_free_irq:
 	free_irq(ps3fb.irq_no, &dev->core);
+err_destroy_plug:
 	ps3_irq_plug_destroy(ps3fb.irq_no);
 err_iounmap_dinfo:
 	iounmap((u8 __force __iomem *)ps3fb.dinfo);
-- 
1.6.2.4

