Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbYDJCaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbYDJCaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 22:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbYDJCaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 22:30:05 -0400
Received: from mail.queued.net ([207.210.101.209]:2467 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008AbYDJCaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 22:30:03 -0400
Date: Wed, 9 Apr 2008 22:31:32 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: adaplas@gmail.com, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net, info-linux@geode.amd.com,
       jordan.crouse@amd.com
Subject: [PATCH 1/3] lxfb/gxfb: when blanking with FB_BLANK_POWERDOWN, also
 turn off the CRT
Message-ID: <20080409223132.7ee8e13d@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The Display Control's CRT_EN can be shut off when we enter
FB_BLANK_POWERDOWN in an attempt to save additional power.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/video/geode/lxfb_ops.c |   17 ++++++++++-------
 drivers/video/geode/video_gx.c |   18 ++++++++++--------
 2 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/video/geode/lxfb_ops.c b/drivers/video/geode/lxfb_ops.c
index cf8007c..c0413ea 100644
--- a/drivers/video/geode/lxfb_ops.c
+++ b/drivers/video/geode/lxfb_ops.c
@@ -474,37 +474,40 @@ int lx_blank_display(struct fb_info *info, int blank_mode)
 {
 	struct lxfb_par *par = info->par;
 	u32 dcfg, fp_pm;
-	int blank, hsync, vsync;
+	int blank, hsync, vsync, crt;
 
 	/* CRT power saving modes. */
 	switch (blank_mode) {
 	case FB_BLANK_UNBLANK:
-		blank = 0; hsync = 1; vsync = 1;
+		blank = 0; hsync = 1; vsync = 1; crt = 1;
 		break;
 	case FB_BLANK_NORMAL:
-		blank = 1; hsync = 1; vsync = 1;
+		blank = 1; hsync = 1; vsync = 1; crt = 1;
 		break;
 	case FB_BLANK_VSYNC_SUSPEND:
-		blank = 1; hsync = 1; vsync = 0;
+		blank = 1; hsync = 1; vsync = 0; crt = 1;
 		break;
 	case FB_BLANK_HSYNC_SUSPEND:
-		blank = 1; hsync = 0; vsync = 1;
+		blank = 1; hsync = 0; vsync = 1; crt = 1;
 		break;
 	case FB_BLANK_POWERDOWN:
-		blank = 1; hsync = 0; vsync = 0;
+		blank = 1; hsync = 0; vsync = 0; crt = 0;
 		break;
 	default:
 		return -EINVAL;
 	}
 
 	dcfg = read_vp(par, VP_DCFG);
-	dcfg &= ~(VP_DCFG_DAC_BL_EN | VP_DCFG_HSYNC_EN | VP_DCFG_VSYNC_EN);
+	dcfg &= ~(VP_DCFG_DAC_BL_EN | VP_DCFG_HSYNC_EN | VP_DCFG_VSYNC_EN |
+			VP_DCFG_CRT_EN);
 	if (!blank)
 		dcfg |= VP_DCFG_DAC_BL_EN;
 	if (hsync)
 		dcfg |= VP_DCFG_HSYNC_EN;
 	if (vsync)
 		dcfg |= VP_DCFG_VSYNC_EN;
+	if (crt)
+		dcfg |= VP_DCFG_CRT_EN;
 	write_vp(par, VP_DCFG, dcfg);
 
 	/* Power on/off flat panel */
diff --git a/drivers/video/geode/video_gx.c b/drivers/video/geode/video_gx.c
index 0072d9e..b8d52a8 100644
--- a/drivers/video/geode/video_gx.c
+++ b/drivers/video/geode/video_gx.c
@@ -299,37 +299,39 @@ int gx_blank_display(struct fb_info *info, int blank_mode)
 {
 	struct gxfb_par *par = info->par;
 	u32 dcfg, fp_pm;
-	int blank, hsync, vsync;
+	int blank, hsync, vsync, crt;
 
 	/* CRT power saving modes. */
 	switch (blank_mode) {
 	case FB_BLANK_UNBLANK:
-		blank = 0; hsync = 1; vsync = 1;
+		blank = 0; hsync = 1; vsync = 1; crt = 1;
 		break;
 	case FB_BLANK_NORMAL:
-		blank = 1; hsync = 1; vsync = 1;
+		blank = 1; hsync = 1; vsync = 1; crt = 1;
 		break;
 	case FB_BLANK_VSYNC_SUSPEND:
-		blank = 1; hsync = 1; vsync = 0;
+		blank = 1; hsync = 1; vsync = 0; crt = 1;
 		break;
 	case FB_BLANK_HSYNC_SUSPEND:
-		blank = 1; hsync = 0; vsync = 1;
+		blank = 1; hsync = 0; vsync = 1; crt = 1;
 		break;
 	case FB_BLANK_POWERDOWN:
-		blank = 1; hsync = 0; vsync = 0;
+		blank = 1; hsync = 0; vsync = 0; crt = 0;
 		break;
 	default:
 		return -EINVAL;
 	}
 	dcfg = read_vp(par, VP_DCFG);
-	dcfg &= ~(VP_DCFG_DAC_BL_EN
-		  | VP_DCFG_HSYNC_EN | VP_DCFG_VSYNC_EN);
+	dcfg &= ~(VP_DCFG_DAC_BL_EN | VP_DCFG_HSYNC_EN | VP_DCFG_VSYNC_EN |
+			VP_DCFG_CRT_EN);
 	if (!blank)
 		dcfg |= VP_DCFG_DAC_BL_EN;
 	if (hsync)
 		dcfg |= VP_DCFG_HSYNC_EN;
 	if (vsync)
 		dcfg |= VP_DCFG_VSYNC_EN;
+	if (crt)
+		dcfg |= VP_DCFG_CRT_EN;
 	write_vp(par, VP_DCFG, dcfg);
 
 	/* Power on/off flat panel. */
-- 
1.5.4.2

