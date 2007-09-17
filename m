Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbXIQQr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbXIQQr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 12:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbXIQQrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 12:47:20 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:38965 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbXIQQrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 12:47:19 -0400
Date: Mon, 17 Sep 2007 17:47:09 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Antonino Daplas <adaplas@pol.net>
cc: linux-fbdev-devel@lists.sourceforge.net, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/video/pmagb-b-fb.c: Improve diagnostics
Message-ID: <Pine.LNX.4.64N.0709171746030.17606@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 Add error messages to the probe call.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 While they may rarely trigger, they may be useful when something weird is 
going on.  Also this is good style.

 Checked with checkpatch.pl and at the runtime.

 Please apply; don't be worried about the old version number.

  Maciej

patch-mips-2.6.18-20060920-pmagb-b-err-1
diff -up --recursive --new-file linux-mips-2.6.18-20060920.macro/drivers/video/pmagb-b-fb.c linux-mips-2.6.18-20060920/drivers/video/pmagb-b-fb.c
--- linux-mips-2.6.18-20060920.macro/drivers/video/pmagb-b-fb.c	2006-12-16 16:44:41.000000000 +0000
+++ linux-mips-2.6.18-20060920/drivers/video/pmagb-b-fb.c	2006-12-16 16:44:52.000000000 +0000
@@ -254,16 +254,23 @@ static int __init pmagbbfb_probe(struct 
 	struct pmagbbfb_par *par;
 	char freq0[12], freq1[12];
 	u32 vid_base;
+	int err = 0;
 
 	info = framebuffer_alloc(sizeof(struct pmagbbfb_par), dev);
-	if (!info)
+	if (!info) {
+		printk(KERN_ERR "%s: Cannot allocate memory\n", dev->bus_id);
 		return -ENOMEM;
+	}
 
 	par = info->par;
 	dev_set_drvdata(dev, info);
 
-	if (fb_alloc_cmap(&info->cmap, 256, 0) < 0)
+	if (fb_alloc_cmap(&info->cmap, 256, 0) < 0) {
+		printk(KERN_ERR "%s: Cannot allocate color map\n",
+		       dev->bus_id);
+		err = -ENOMEM;
 		goto err_alloc;
+	}
 
 	info->fbops = &pmagbbfb_ops;
 	info->fix = pmagbbfb_fix;
@@ -273,22 +280,31 @@ static int __init pmagbbfb_probe(struct 
 	/* Request the I/O MEM resource.  */
 	start = tdev->resource.start;
 	len = tdev->resource.end - start + 1;
-	if (!request_mem_region(start, len, dev->bus_id))
+	if (!request_mem_region(start, len, dev->bus_id)) {
+		printk(KERN_ERR "%s: Cannot reserve FB region\n", dev->bus_id);
+		err = -EBUSY;
 		goto err_cmap;
+	}
 
 	/* MMIO mapping setup.  */
 	info->fix.mmio_start = start;
 	par->mmio = ioremap_nocache(info->fix.mmio_start, info->fix.mmio_len);
-	if (!par->mmio)
+	if (!par->mmio) {
+		printk(KERN_ERR "%s: Cannot map MMIO\n", dev->bus_id);
+		err = -ENOMEM;
 		goto err_resource;
+	}
 	par->sfb = par->mmio + PMAGB_B_SFB;
 	par->dac = par->mmio + PMAGB_B_BT459;
 
 	/* Frame buffer mapping setup.  */
 	info->fix.smem_start = start + PMAGB_B_FBMEM;
 	par->smem = ioremap_nocache(info->fix.smem_start, info->fix.smem_len);
-	if (!par->smem)
+	if (!par->smem) {
+		printk(KERN_ERR "%s: Cannot map FB\n", dev->bus_id);
+		err = -ENOMEM;
 		goto err_mmio_map;
+	}
 	vid_base = sfb_read(par, SFB_REG_VID_BASE);
 	info->screen_base = (void __iomem *)par->smem + vid_base * 0x1000;
 	info->screen_size = info->fix.smem_len - 2 * vid_base * 0x1000;
@@ -297,8 +313,12 @@ static int __init pmagbbfb_probe(struct 
 	pmagbbfb_screen_setup(info);
 	pmagbbfb_osc_setup(info);
 
-	if (register_framebuffer(info) < 0)
+	err = register_framebuffer(info);
+	if (err < 0) {
+		printk(KERN_ERR "%s: Cannot register framebuffer\n",
+		       dev->bus_id);
 		goto err_smem_map;
+	}
 
 	get_device(dev);
 
