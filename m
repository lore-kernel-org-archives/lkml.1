Return-Path: <linux-kernel-owner+w=401wt.eu-S1758435AbZADLrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435AbZADLrl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 06:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbZADLrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 06:47:10 -0500
Received: from edna.telenet-ops.be ([195.130.132.58]:46509 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbZADLrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 06:47:08 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>,
       linux-fbdev-devel@lists.sourceforge.net
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/7] fbdev: atafb - Fix 16 bpp console
Date: Sun,  4 Jan 2009 12:46:59 +0100
Message-Id: <1231069624-13362-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1231069624-13362-2-git-send-email-geert@linux-m68k.org>
References: <1231069624-13362-1-git-send-email-geert@linux-m68k.org>
 <1231069624-13362-2-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  - 16 bpp must use the cfb_*() ops
  - 16 bpp needs to set up info->pseudo_palette[] (was fbcon_cfb16_cmap[] in
    2.4.x)
  - Kill commented out 2.4.x fbcon remnants

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/video/atafb.c |   74 ++++++++++++++++++++-----------------------------
 1 files changed, 30 insertions(+), 44 deletions(-)

diff --git a/drivers/video/atafb.c b/drivers/video/atafb.c
index b7646ad..f932c13 100644
--- a/drivers/video/atafb.c
+++ b/drivers/video/atafb.c
@@ -149,6 +149,7 @@ static struct atafb_par {
 			short mono;
 			short ste_mode;
 			short bpp;
+			u32 pseudo_palette[16];
 		} falcon;
 #endif
 		/* Nothing needed for external mode */
@@ -885,10 +886,6 @@ static int vdl_prescale[4][3] = {
 /* Default hsync timing [mon_type] in picoseconds */
 static long h_syncs[4] = { 3000000, 4875000, 4000000, 4875000 };
 
-#ifdef FBCON_HAS_CFB16
-static u16 fbcon_cfb16_cmap[16];
-#endif
-
 static inline int hxx_prescale(struct falcon_hw *hw)
 {
 	return hw->ste_mode ? 16
@@ -1736,10 +1733,10 @@ static int falcon_setcolreg(unsigned int regno, unsigned int red,
 			(((red & 0xe000) >> 13) | ((red & 0x1000) >> 12) << 8) |
 			(((green & 0xe000) >> 13) | ((green & 0x1000) >> 12) << 4) |
 			((blue & 0xe000) >> 13) | ((blue & 0x1000) >> 12);
-#ifdef FBCON_HAS_CFB16
-		fbcon_cfb16_cmap[regno] = ((red & 0xf800) |
-					   ((green & 0xfc00) >> 5) |
-					   ((blue & 0xf800) >> 11));
+#ifdef ATAFB_FALCON
+		((u32 *)info->pseudo_palette)[regno] = ((red & 0xf800) |
+						       ((green & 0xfc00) >> 5) |
+						       ((blue & 0xf800) >> 11));
 #endif
 	}
 	return 0;
@@ -2447,42 +2444,6 @@ static void atafb_set_disp(struct fb_info *info)
 	atafb_get_fix(&info->fix, info);
 
 	info->screen_base = (void *)info->fix.smem_start;
-
-	switch (info->fix.type) {
-	case FB_TYPE_INTERLEAVED_PLANES:
-		switch (info->var.bits_per_pixel) {
-		case 2:
-			// display->dispsw = &fbcon_iplan2p2;
-			break;
-		case 4:
-			// display->dispsw = &fbcon_iplan2p4;
-			break;
-		case 8:
-			// display->dispsw = &fbcon_iplan2p8;
-			break;
-		}
-		break;
-	case FB_TYPE_PACKED_PIXELS:
-		switch (info->var.bits_per_pixel) {
-#ifdef FBCON_HAS_MFB
-		case 1:
-			// display->dispsw = &fbcon_mfb;
-			break;
-#endif
-#ifdef FBCON_HAS_CFB8
-		case 8:
-			// display->dispsw = &fbcon_cfb8;
-			break;
-#endif
-#ifdef FBCON_HAS_CFB16
-		case 16:
-			// display->dispsw = &fbcon_cfb16;
-			// display->dispsw_data = fbcon_cfb16_cmap;
-			break;
-#endif
-		}
-		break;
-	}
 }
 
 static int atafb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
@@ -2553,6 +2514,13 @@ static void atafb_fillrect(struct fb_info *info, const struct fb_fillrect *rect)
 	if (!rect->width || !rect->height)
 		return;
 
+#ifdef ATAFB_FALCON
+	if (info->var.bits_per_pixel == 16) {
+		cfb_fillrect(info, rect);
+		return;
+	}
+#endif
+
 	/*
 	 * We could use hardware clipping but on many cards you get around
 	 * hardware clipping by writing to framebuffer directly.
@@ -2587,6 +2555,13 @@ static void atafb_copyarea(struct fb_info *info, const struct fb_copyarea *area)
 	u32 dx, dy, sx, sy, width, height;
 	int rev_copy = 0;
 
+#ifdef ATAFB_FALCON
+	if (info->var.bits_per_pixel == 16) {
+		cfb_copyarea(info, area);
+		return;
+	}
+#endif
+
 	/* clip the destination */
 	x2 = area->dx + area->width;
 	y2 = area->dy + area->height;
@@ -2636,6 +2611,13 @@ static void atafb_imageblit(struct fb_info *info, const struct fb_image *image)
 	const char *src;
 	u32 dx, dy, width, height, pitch;
 
+#ifdef ATAFB_FALCON
+	if (info->var.bits_per_pixel == 16) {
+		cfb_imageblit(info, image);
+		return;
+	}
+#endif
+
 	/*
 	 * We could use hardware clipping but on many cards you get around
 	 * hardware clipping by writing to framebuffer directly like we are
@@ -3229,6 +3211,10 @@ int __init atafb_init(void)
 	// tries to read from HW which may not be initialized yet
 	// so set sane var first, then call atafb_set_par
 	atafb_get_var(&fb_info.var, &fb_info);
+
+#ifdef ATAFB_FALCON
+	fb_info.pseudo_palette = current_par.hw.falcon.pseudo_palette;
+#endif
 	fb_info.flags = FBINFO_FLAG_DEFAULT;
 
 	if (!fb_find_mode(&fb_info.var, &fb_info, mode_option, atafb_modedb,
-- 
1.5.6.5

