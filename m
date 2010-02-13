Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233Ab0BMWyM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 17:54:12 -0500
Received: from mail.gmx.net ([213.165.64.20]:41715 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757996Ab0BMWyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 17:54:09 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+cU08pvPWcQ3YQvpl1sDPNk8VlKw+qFTd6gXCK2O
	knsosm/K2oXhWf
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 1/4] viafb: rework color checking
Date: Sat, 13 Feb 2010 23:00:46 +0000
Message-Id: <1266102049-6209-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: rework color checking

This patch makes color checking a bit more tolerant in what values it
allows and more fine grained to later support 15 and 30 bits formats.
It splits the filling of the color information in var to a seperate
function and sets some color related values in var that where previously
untouched.
This could be a bug fix but at least I don't know any applications that
was fooled by not correctly setting the fields in var. At least no
regressions are expected.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/hw.c       |   30 --------------------
 drivers/video/via/viafbdev.c |   63 ++++++++++++++++++++++++++++++++++++++----
 2 files changed, 57 insertions(+), 36 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index ed8d78a..47d9024 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -2622,36 +2622,6 @@ void viafb_fill_var_timing_info(struct fb_var_screeninfo *var, int refresh,
 	}
 
 	crt_reg = crt_timing[index].crtc;
-	switch (var->bits_per_pixel) {
-	case 8:
-		var->red.offset = 0;
-		var->green.offset = 0;
-		var->blue.offset = 0;
-		var->red.length = 6;
-		var->green.length = 6;
-		var->blue.length = 6;
-		break;
-	case 16:
-		var->red.offset = 11;
-		var->green.offset = 5;
-		var->blue.offset = 0;
-		var->red.length = 5;
-		var->green.length = 6;
-		var->blue.length = 5;
-		break;
-	case 32:
-		var->red.offset = 16;
-		var->green.offset = 8;
-		var->blue.offset = 0;
-		var->red.length = 8;
-		var->green.length = 8;
-		var->blue.length = 8;
-		break;
-	default:
-		/* never happed, put here to keep consistent */
-		break;
-	}
-
 	var->pixclock = viafb_get_pixclock(var->xres, var->yres, refresh);
 	var->left_margin =
 	    crt_reg.hor_total - (crt_reg.hor_sync_start + crt_reg.hor_sync_end);
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index bb0f616..bd8db75 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -60,6 +60,47 @@ static int viafb_pan_display(struct fb_var_screeninfo *var,
 static struct fb_ops viafb_ops;
 
 
+static void viafb_fill_var_color_info(struct fb_var_screeninfo *var, u8 depth)
+{
+	var->grayscale = 0;
+	var->red.msb_right = 0;
+	var->green.msb_right = 0;
+	var->blue.msb_right = 0;
+	var->transp.offset = 0;
+	var->transp.length = 0;
+	var->transp.msb_right = 0;
+	var->nonstd = 0;
+	switch (depth) {
+	case 8:
+		var->bits_per_pixel = 8;
+		var->red.offset = 0;
+		var->green.offset = 0;
+		var->blue.offset = 0;
+		var->red.length = 6;
+		var->green.length = 6;
+		var->blue.length = 6;
+		break;
+	case 16:
+		var->bits_per_pixel = 16;
+		var->red.offset = 11;
+		var->green.offset = 5;
+		var->blue.offset = 0;
+		var->red.length = 5;
+		var->green.length = 6;
+		var->blue.length = 5;
+		break;
+	case 24:
+		var->bits_per_pixel = 32;
+		var->red.offset = 16;
+		var->green.offset = 8;
+		var->blue.offset = 0;
+		var->red.length = 8;
+		var->green.length = 8;
+		var->blue.length = 8;
+		break;
+	}
+}
+
 static void viafb_update_fix(struct fb_info *info)
 {
 	u32 bpp = info->var.bits_per_pixel;
@@ -81,6 +122,7 @@ static void viafb_setup_fixinfo(struct fb_fix_screeninfo *fix,
 
 	fix->type = FB_TYPE_PACKED_PIXELS;
 	fix->type_aux = 0;
+	fix->visual = FB_VISUAL_TRUECOLOR;
 
 	fix->xpanstep = fix->ywrapstep = 0;
 	fix->ypanstep = 1;
@@ -103,7 +145,7 @@ static int viafb_release(struct fb_info *info, int user)
 static int viafb_check_var(struct fb_var_screeninfo *var,
 	struct fb_info *info)
 {
-	int htotal, vtotal;
+	int htotal, vtotal, depth;
 	struct VideoModeTable *vmode_entry;
 	struct viafb_par *ppar = info->par;
 	u32 long_refresh;
@@ -122,13 +164,22 @@ static int viafb_check_var(struct fb_var_screeninfo *var,
 		return -EINVAL;
 	}
 
-	if (24 == var->bits_per_pixel)
-		var->bits_per_pixel = 32;
+	depth = fb_get_color_depth(var, &info->fix);
+	if (!depth)
+		depth = var->bits_per_pixel;
 
-	if (var->bits_per_pixel != 8 && var->bits_per_pixel != 16 &&
-		var->bits_per_pixel != 32)
+	if (depth < 0 || depth > 32)
 		return -EINVAL;
+	else if (!depth)
+		depth = 24;
+	else if (depth <= 8)
+		depth = 8;
+	else if (depth <= 16)
+		depth = 16;
+	else
+		depth = 24;
 
+	viafb_fill_var_color_info(var, depth);
 	if ((var->xres_virtual * (var->bits_per_pixel >> 3)) & 0x1F)
 		/*32 pixel alignment */
 		var->xres_virtual = (var->xres_virtual + 31) & ~31;
-- 
1.6.3.2

