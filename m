Return-Path: <linux-kernel-owner+w=401wt.eu-S1752152AbYBWGJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbYBWGJZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 01:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754745AbYBWGIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 01:08:47 -0500
Received: from mail.queued.net ([207.210.101.209]:1137 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444AbYBWGIQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 01:08:16 -0500
Date: Sat, 23 Feb 2008 01:10:54 -0500
From: Andres Salomon <dilinger@queued.net>
To: adaplas@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       info-linux@geode.amd.com, Jordan Crouse <jordan.crouse@amd.com>
Subject: [PATCH 3/4] gxfb: Don't enable the CRT DACs when we are in
 flatpanel mode
Message-ID: <20080223011054.0c7529e7@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one's also from Jordan.

>From dea8d19f689706985b30be745ef1151082866374 Mon Sep 17 00:00:00 2001
From: Jordan Crouse <jordan.crouse@amd.com>
Date: Fri, 22 Feb 2008 19:55:09 -0500
Subject: [PATCH] gxfb: Don't enable the CRT DACs when we are in flatpanel mode

When the FP strap is enabled, don't turn on the CRT DACs - that will save
about 35 mA of power.

Updated/cleaned up by Andres Salomon.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Jordan Crouse <jordan.crouse@amd.com>
---
 drivers/video/geode/video_gx.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/video/geode/video_gx.c b/drivers/video/geode/video_gx.c
index a53936f..b436155 100644
--- a/drivers/video/geode/video_gx.c
+++ b/drivers/video/geode/video_gx.c
@@ -238,18 +238,6 @@ static void gx_configure_display(struct fb_info *info)
 	struct geodefb_par *par = info->par;
 	u32 dcfg, misc;
 
-	/* Set up the MISC register */
-
-	misc = readl(par->vid_regs + GX_MISC);
-
-	/* Power up the DAC */
-	misc &= ~(GX_MISC_A_PWRDN | GX_MISC_DAC_PWRDN);
-
-	/* Disable gamma correction */
-	misc |= GX_MISC_GAM_EN;
-
-	writel(misc, par->vid_regs + GX_MISC);
-
 	/* Write the display configuration */
 	dcfg = readl(par->vid_regs + GX_DCFG);
 
@@ -268,14 +256,28 @@ static void gx_configure_display(struct fb_info *info)
 	/* Enable hsync and vsync. */
 	dcfg |= GX_DCFG_HSYNC_EN | GX_DCFG_VSYNC_EN;
 
-	/* Only change the sync polarities if we are running
-	 * in CRT mode.  The FP polarities will be handled in
-	 * gxfb_configure_tft */
+	misc = readl(par->vid_regs + GX_MISC);
+
+	/* Disable gamma correction */
+	misc |= GX_MISC_GAM_EN;
+
 	if (par->enable_crt) {
+
+		/* Power up the CRT DACs */
+		misc &= ~(GX_MISC_A_PWRDN | GX_MISC_DAC_PWRDN);
+		writel(misc, par->vid_regs + GX_MISC);
+
+		/* Only change the sync polarities if we are running
+		 * in CRT mode.  The FP polarities will be handled in
+		 * gxfb_configure_tft */
 		if (!(info->var.sync & FB_SYNC_HOR_HIGH_ACT))
 			dcfg |= GX_DCFG_CRT_HSYNC_POL;
 		if (!(info->var.sync & FB_SYNC_VERT_HIGH_ACT))
 			dcfg |= GX_DCFG_CRT_VSYNC_POL;
+	} else {
+		/* Power down the CRT DACs if in FP mode */
+		misc |= (GX_MISC_A_PWRDN | GX_MISC_DAC_PWRDN);
+		writel(misc, par->vid_regs + GX_MISC);
 	}
 
 	/* Enable the display logic */
-- 
1.5.3.7

