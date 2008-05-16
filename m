Return-Path: <linux-kernel-owner+w=401wt.eu-S1756268AbYEPMef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268AbYEPMef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 08:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYEPMe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 08:34:26 -0400
Received: from mail.atmel.fr ([81.80.104.162]:33467 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbYEPMeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 08:34:24 -0400
Message-ID: <482D7F44.7040404@atmel.com>
Date: Fri, 16 May 2008 14:34:12 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: linux-fbdev-devel@lists.sourceforge.net,
       "Antonino A. Daplas" <adaplas@gmail.com>
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <linux@maxim.org.za>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] atmel_lcdfb: FIFO underflow management
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manage atmel_lcdfb FIFO underflow

Resetting the LCD and DMA allows to fix screen shifting after a 
FIFO underflow. It follows reset sequence from errata 
"LCD Screen Shifting After a Reset".

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/video/atmel_lcdfb.c |   50 +++++++++++++++++++++++++++++++++-
 include/video/atmel_lcdc.h  |    1 
 2 files changed, 50 insertions(+), 1 deletion(-)

Index: include/video/atmel_lcdc.h
===================================================================
--- a/include/video/atmel_lcdc.h
+++ b/include/video/atmel_lcdc.h
@@ -37,6 +37,7 @@ struct atmel_lcdfb_info {
 	struct fb_info		*info;
 	void __iomem		*mmio;
 	unsigned long		irq_base;
+	struct work_struct	task;
 
 	unsigned int		guard_time;
 	struct platform_device	*pdev;
Index: drivers/video/atmel_lcdfb.c
===================================================================
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -356,6 +356,33 @@ static int atmel_lcdfb_check_var(struct 
 	return 0;
 }
 
+/*
+ * LCD reset sequence
+ */
+static void atmel_lcdfb_reset(struct atmel_lcdfb_info *sinfo)
+{
+	/* LCD power off */
+	lcdc_writel(sinfo, ATMEL_LCDC_PWRCON, sinfo->guard_time << ATMEL_LCDC_GUARDT_OFFSET);
+
+	/* wait for the LCDC core to become idle */
+	while (lcdc_readl(sinfo, ATMEL_LCDC_PWRCON) & ATMEL_LCDC_BUSY)
+		msleep(10);
+
+	/* DMA disable */
+	lcdc_writel(sinfo, ATMEL_LCDC_DMACON, 0);
+
+	/* wait for DMA engine to become idle */
+	while (lcdc_readl(sinfo, ATMEL_LCDC_DMACON) & ATMEL_LCDC_DMABUSY)
+		msleep(10);
+
+	/* LCD power on */
+	lcdc_writel(sinfo, ATMEL_LCDC_PWRCON,
+		(sinfo->guard_time << ATMEL_LCDC_GUARDT_OFFSET) | ATMEL_LCDC_PWR);
+
+	/* DMA enable */
+	lcdc_writel(sinfo, ATMEL_LCDC_DMACON, sinfo->default_dmacon);
+}
+
 /**
  *      atmel_lcdfb_set_par - Alters the hardware state.
  *      @info: frame buffer structure that represents a single frame buffer
@@ -486,6 +513,8 @@ static int atmel_lcdfb_set_par(struct fb
 
 	/* Disable all interrupts */
 	lcdc_writel(sinfo, ATMEL_LCDC_IDR, ~0UL);
+	/* Enable FIFO & DMA errors */
+	lcdc_writel(sinfo, ATMEL_LCDC_IER, ATMEL_LCDC_UFLWI | ATMEL_LCDC_OWRI | ATMEL_LCDC_MERI);
 
 	/* ...wait for DMA engine to become idle... */
 	while (lcdc_readl(sinfo, ATMEL_LCDC_DMACON) & ATMEL_LCDC_DMABUSY)
@@ -620,10 +649,26 @@ static irqreturn_t atmel_lcdfb_interrupt
 	u32 status;
 
 	status = lcdc_readl(sinfo, ATMEL_LCDC_ISR);
-	lcdc_writel(sinfo, ATMEL_LCDC_IDR, status);
+	if (status & ATMEL_LCDC_UFLWI) {
+		dev_warn(info->device, "FIFO underflow %#x\n", status);
+		/* reset DMA and FIFO to avoid screen shifting */
+		schedule_work(&sinfo->task);
+	}
+	lcdc_writel(sinfo, ATMEL_LCDC_ICR, status);
 	return IRQ_HANDLED;
 }
 
+/*
+ * LCD controller task (to reset the LCD)
+ */
+static void atmel_lcdfb_task(struct work_struct *work)
+{
+	struct atmel_lcdfb_info *sinfo =
+		container_of(work, struct atmel_lcdfb_info, task);
+
+	atmel_lcdfb_reset(sinfo);
+}
+
 static int __init atmel_lcdfb_init_fbinfo(struct atmel_lcdfb_info *sinfo)
 {
 	struct fb_info *info = sinfo->info;
@@ -795,6 +840,9 @@ static int __init atmel_lcdfb_probe(stru
 		goto unmap_mmio;
 	}
 
+	/* Initialize bottom half workqueue */
+	INIT_WORK(&sinfo->task, atmel_lcdfb_task);
+
 	ret = atmel_lcdfb_init_fbinfo(sinfo);
 	if (ret < 0) {
 		dev_err(dev, "init fbinfo failed: %d\n", ret);



