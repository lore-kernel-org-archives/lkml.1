Return-Path: <linux-kernel-owner+w=401wt.eu-S1757850AbYC0ED6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850AbYC0ED6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 00:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbYC0EDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 00:03:50 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:55204 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbYC0EDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 00:03:49 -0400
X-IronPort-AV: E=Sophos;i="4.25,562,1199682000"; 
   d="scan'208";a="50841531"
From: Bryan Wu <cooloney@kernel.org>
To: geert@linux-m68k.org, linux-fbdev-devel@lists.sourceforge.net,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Bryan Wu <cooloney@kernel.org>,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 1/1] Blackfin Video Driver: Update the BF52x EZKIT video framebuffer driver according to LKML review
Date: Thu, 27 Mar 2008 12:03:45 -0700
Message-Id: <1206644625-10811-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - Allocate pseudo_palette together with fbinfo
 - Remove the cast when request irq as Geert said
 - Code cleanup

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/video/bfin-t350mcqb-fb.c |   36 ++++++++++++++----------------------
 1 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/drivers/video/bfin-t350mcqb-fb.c b/drivers/video/bfin-t350mcqb-fb.c
index a2bb2de..f36ca7f 100644
--- a/drivers/video/bfin-t350mcqb-fb.c
+++ b/drivers/video/bfin-t350mcqb-fb.c
@@ -91,6 +91,7 @@ struct bfin_t350mcqbfb_info {
 	int lq043_open_cnt;
 	int irq;
 	spinlock_t lock;	/* lock */
+	u32 pseudo_pal[16];
 };
 
 static int nocursor;
@@ -182,13 +183,13 @@ static void bfin_t350mcqb_config_dma(struct bfin_t350mcqbfb_info *fbi)
 
 }
 
-static int bfin_t350mcqb_request_ports(int action)
-{
-	u16 ppi0_req_8[] = {P_PPI0_CLK, P_PPI0_FS1, P_PPI0_FS2,
+static	u16 ppi0_req_8[] = {P_PPI0_CLK, P_PPI0_FS1, P_PPI0_FS2,
 			    P_PPI0_D0, P_PPI0_D1, P_PPI0_D2,
 			    P_PPI0_D3, P_PPI0_D4, P_PPI0_D5,
 			    P_PPI0_D6, P_PPI0_D7, 0};
 
+static int bfin_t350mcqb_request_ports(int action)
+{
 	if (action) {
 		if (peripheral_request_list(ppi0_req_8, DRIVER_NAME)) {
 			printk(KERN_ERR "Requesting Peripherals faild\n");
@@ -520,16 +521,7 @@ static int __init bfin_t350mcqb_probe(struct platform_device *pdev)
 
 	fbinfo->fbops = &bfin_t350mcqb_fb_ops;
 
-	fbinfo->pseudo_palette = kmalloc(sizeof(u32) * 16, GFP_KERNEL);
-	if (!fbinfo->pseudo_palette) {
-		printk(KERN_ERR DRIVER_NAME
-		       "Fail to allocate pseudo_palette\n");
-
-		ret = -ENOMEM;
-		goto out4;
-	}
-
-	memset(fbinfo->pseudo_palette, 0, sizeof(u32) * 16);
+	fbinfo->pseudo_palette = &info->pseudo_pal;
 
 	if (fb_alloc_cmap(&fbinfo->cmap, BFIN_LCD_NBR_PALETTE_ENTRIES, 0)
 	    < 0) {
@@ -537,7 +529,7 @@ static int __init bfin_t350mcqb_probe(struct platform_device *pdev)
 		       "Fail to allocate colormap (%d entries)\n",
 		       BFIN_LCD_NBR_PALETTE_ENTRIES);
 		ret = -EFAULT;
-		goto out5;
+		goto out4;
 	}
 
 	if (bfin_t350mcqb_request_ports(1)) {
@@ -552,11 +544,11 @@ static int __init bfin_t350mcqb_probe(struct platform_device *pdev)
 		goto out7;
 	}
 
-	if (request_irq(info->irq, (void *)bfin_t350mcqb_irq_error, IRQF_DISABLED,
-			"PPI ERROR", info) < 0) {
+	ret = request_irq(info->irq, bfin_t350mcqb_irq_error, IRQF_DISABLED,
+			"PPI ERROR", info);
+	if (ret < 0) {
 		printk(KERN_ERR DRIVER_NAME
 		       ": unable to request PPI ERROR IRQ\n");
-		ret = -EFAULT;
 		goto out7;
 	}
 
@@ -584,8 +576,6 @@ out7:
 	bfin_t350mcqb_request_ports(0);
 out6:
 	fb_dealloc_cmap(&fbinfo->cmap);
-out5:
-	kfree(fbinfo->pseudo_palette);
 out4:
 	dma_free_coherent(NULL, fbinfo->fix.smem_len, info->fb_buffer,
 			  info->dma_handle);
@@ -605,6 +595,8 @@ static int bfin_t350mcqb_remove(struct platform_device *pdev)
 	struct fb_info *fbinfo = platform_get_drvdata(pdev);
 	struct bfin_t350mcqbfb_info *info = fbinfo->par;
 
+	unregister_framebuffer(fbinfo);
+
 	free_dma(CH_PPI);
 	free_irq(info->irq, info);
 
@@ -612,7 +604,6 @@ static int bfin_t350mcqb_remove(struct platform_device *pdev)
 		dma_free_coherent(NULL, fbinfo->fix.smem_len, info->fb_buffer,
 				  info->dma_handle);
 
-	kfree(fbinfo->pseudo_palette);
 	fb_dealloc_cmap(&fbinfo->cmap);
 
 #ifndef NO_BL_SUPPORT
@@ -620,10 +611,11 @@ static int bfin_t350mcqb_remove(struct platform_device *pdev)
 	backlight_device_unregister(bl_dev);
 #endif
 
-	unregister_framebuffer(fbinfo);
-
 	bfin_t350mcqb_request_ports(0);
 
+	platform_set_drvdata(pdev, NULL);
+	framebuffer_release(fbinfo);
+
 	printk(KERN_INFO DRIVER_NAME ": Unregister LCD driver.\n");
 
 	return 0;
-- 
1.5.4.3
