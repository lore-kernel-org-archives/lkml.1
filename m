Return-Path: <linux-kernel-owner+w=401wt.eu-S1765552AbXGPOCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765552AbXGPOCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764502AbXGPOA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:00:57 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:42222 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760212AbXGPOAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:00:54 -0400
Message-Id: <20070716135950.895120000@pademelon.sonytel.be>
References: <20070716135550.010775000@pademelon.sonytel.be>
User-Agent: quilt/0.46-1
Date: Mon, 16 Jul 2007 15:55:52 +0200
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, James Simmons <jsimmons@infradead.org>,
       linux-fbdev-devel@lists.sourceforge.net, cbe-oss-dev@ozlabs.org,
       linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Geoff Levand <geoffrey.levand@am.sony.com>
Subject: [patch 2/4] fbdev: Add fb_append_extra_logo()
Content-Disposition: inline; filename=spe-logo/fb_append_extra_logo.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add fb_append_extra_logo(), to append extra lines of logos below the standard
Linux logo.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
Acked-By: James Simmons <jsimmons@infradead.org>
---
Changes since last version:
  - Introduce CONFIG_FB_LOGO_EXTRA to protect all new code
  - Move fb_prepare_logo() down to satisfy declaration dependencies

 drivers/video/fbmem.c      |  210 ++++++++++++++++++++++++++++++---------------
 drivers/video/logo/Kconfig |    4 
 include/linux/linux_logo.h |    8 +
 3 files changed, 154 insertions(+), 68 deletions(-)

--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -411,72 +411,6 @@ static void fb_do_show_logo(struct fb_in
 	}
 }
 
-int fb_prepare_logo(struct fb_info *info, int rotate)
-{
-	int depth = fb_get_color_depth(&info->var, &info->fix);
-	int yres;
-
-	memset(&fb_logo, 0, sizeof(struct logo_data));
-
-	if (info->flags & FBINFO_MISC_TILEBLITTING ||
-	    info->flags & FBINFO_MODULE)
-		return 0;
-
-	if (info->fix.visual == FB_VISUAL_DIRECTCOLOR) {
-		depth = info->var.blue.length;
-		if (info->var.red.length < depth)
-			depth = info->var.red.length;
-		if (info->var.green.length < depth)
-			depth = info->var.green.length;
-	}
-
-	if (info->fix.visual == FB_VISUAL_STATIC_PSEUDOCOLOR && depth > 4) {
-		/* assume console colormap */
-		depth = 4;
-	}
-
-	if (depth >= 8) {
-		switch (info->fix.visual) {
-		case FB_VISUAL_TRUECOLOR:
-			fb_logo.needs_truepalette = 1;
-			break;
-		case FB_VISUAL_DIRECTCOLOR:
-			fb_logo.needs_directpalette = 1;
-			fb_logo.needs_cmapreset = 1;
-			break;
-		case FB_VISUAL_PSEUDOCOLOR:
-			fb_logo.needs_cmapreset = 1;
-			break;
-		}
-	}
-
-	/* Return if no suitable logo was found */
-	fb_logo.logo = fb_find_logo(depth);
-
-	if (!fb_logo.logo) {
-		return 0;
-	}
-	
-	if (rotate == FB_ROTATE_UR || rotate == FB_ROTATE_UD)
-		yres = info->var.yres;
-	else
-		yres = info->var.xres;
-
-	if (fb_logo.logo->height > yres) {
-		fb_logo.logo = NULL;
-		return 0;
-	}
-
-	/* What depth we asked for might be different from what we get */
-	if (fb_logo.logo->type == LINUX_LOGO_CLUT224)
-		fb_logo.depth = 8;
-	else if (fb_logo.logo->type == LINUX_LOGO_VGA16)
-		fb_logo.depth = 4;
-	else
-		fb_logo.depth = 1;		
-	return fb_logo.logo->height;
-}
-
 static int fb_show_logo_line(struct fb_info *info, int rotate,
 			     const struct linux_logo *logo, int y,
 			     unsigned int n)
@@ -545,10 +479,150 @@ static int fb_show_logo_line(struct fb_i
 	return logo->height;
 }
 
+
+#ifdef CONFIG_FB_LOGO_EXTRA
+
+#define FB_LOGO_EX_NUM_MAX 10
+static struct logo_data_extra {
+	const struct linux_logo *logo;
+	unsigned int n;
+} fb_logo_ex[FB_LOGO_EX_NUM_MAX];
+static unsigned int fb_logo_ex_num;
+
+void fb_append_extra_logo(const struct linux_logo *logo, unsigned int n)
+{
+	if (!n || fb_logo_ex_num == FB_LOGO_EX_NUM_MAX)
+		return;
+
+	fb_logo_ex[fb_logo_ex_num].logo = logo;
+	fb_logo_ex[fb_logo_ex_num].n = n;
+	fb_logo_ex_num++;
+}
+
+static int fb_prepare_extra_logos(struct fb_info *info, unsigned int height,
+				  unsigned int yres)
+{
+	unsigned int i;
+
+	/* FIXME: logo_ex supports only truecolor fb. */
+	if (info->fix.visual != FB_VISUAL_TRUECOLOR)
+		fb_logo_ex_num = 0;
+
+	for (i = 0; i < fb_logo_ex_num; i++) {
+		height += fb_logo_ex[i].logo->height;
+		if (height > yres) {
+			height -= fb_logo_ex[i].logo->height;
+			fb_logo_ex_num = i;
+			break;
+		}
+	}
+	return height;
+}
+
+static int fb_show_extra_logos(struct fb_info *info, int y, int rotate)
+{
+	unsigned int i;
+
+	for (i = 0; i < fb_logo_ex_num; i++)
+		y += fb_show_logo_line(info, rotate,
+				       fb_logo_ex[i].logo, y, fb_logo_ex[i].n);
+
+	return y;
+}
+
+#else /* !CONFIG_FB_LOGO_EXTRA */
+
+static inline int fb_prepare_extra_logos(struct fb_info *info,
+					 unsigned int height,
+					 unsigned int yres)
+{
+	return height;
+}
+
+static inline int fb_show_extra_logos(struct fb_info *info, int y, int rotate)
+{
+	return y;
+}
+
+#endif /* CONFIG_FB_LOGO_EXTRA */
+
+
+int fb_prepare_logo(struct fb_info *info, int rotate)
+{
+	int depth = fb_get_color_depth(&info->var, &info->fix);
+	unsigned int yres;
+
+	memset(&fb_logo, 0, sizeof(struct logo_data));
+
+	if (info->flags & FBINFO_MISC_TILEBLITTING ||
+	    info->flags & FBINFO_MODULE)
+		return 0;
+
+	if (info->fix.visual == FB_VISUAL_DIRECTCOLOR) {
+		depth = info->var.blue.length;
+		if (info->var.red.length < depth)
+			depth = info->var.red.length;
+		if (info->var.green.length < depth)
+			depth = info->var.green.length;
+	}
+
+	if (info->fix.visual == FB_VISUAL_STATIC_PSEUDOCOLOR && depth > 4) {
+		/* assume console colormap */
+		depth = 4;
+	}
+
+	if (depth >= 8) {
+		switch (info->fix.visual) {
+		case FB_VISUAL_TRUECOLOR:
+			fb_logo.needs_truepalette = 1;
+			break;
+		case FB_VISUAL_DIRECTCOLOR:
+			fb_logo.needs_directpalette = 1;
+			fb_logo.needs_cmapreset = 1;
+			break;
+		case FB_VISUAL_PSEUDOCOLOR:
+			fb_logo.needs_cmapreset = 1;
+			break;
+		}
+	}
+
+	/* Return if no suitable logo was found */
+	fb_logo.logo = fb_find_logo(depth);
+
+	if (!fb_logo.logo) {
+		return 0;
+	}
+
+	if (rotate == FB_ROTATE_UR || rotate == FB_ROTATE_UD)
+		yres = info->var.yres;
+	else
+		yres = info->var.xres;
+
+	if (fb_logo.logo->height > yres) {
+		fb_logo.logo = NULL;
+		return 0;
+	}
+
+	/* What depth we asked for might be different from what we get */
+	if (fb_logo.logo->type == LINUX_LOGO_CLUT224)
+		fb_logo.depth = 8;
+	else if (fb_logo.logo->type == LINUX_LOGO_VGA16)
+		fb_logo.depth = 4;
+	else
+		fb_logo.depth = 1;
+
+	return fb_prepare_extra_logos(info, fb_logo.logo->height, yres);
+}
+
 int fb_show_logo(struct fb_info *info, int rotate)
 {
-	return fb_show_logo_line(info, rotate, fb_logo.logo, 0,
-				 num_online_cpus());
+	int y;
+
+	y = fb_show_logo_line(info, rotate, fb_logo.logo, 0,
+			      num_online_cpus());
+	y = fb_show_extra_logos(info, y, rotate);
+
+	return y;
 }
 #else
 int fb_prepare_logo(struct fb_info *info, int rotate) { return 0; }
--- a/drivers/video/logo/Kconfig
+++ b/drivers/video/logo/Kconfig
@@ -10,6 +10,10 @@ menuconfig LOGO
 
 if LOGO
 
+config FB_LOGO_EXTRA
+	bool
+	depends on FB
+
 config LOGO_LINUX_MONO
 	bool "Standard black and white Linux logo"
 	default y
--- a/include/linux/linux_logo.h
+++ b/include/linux/linux_logo.h
@@ -33,5 +33,13 @@ struct linux_logo {
 };
 
 extern const struct linux_logo *fb_find_logo(int depth);
+#ifdef CONFIG_FB_LOGO_EXTRA
+extern void fb_append_extra_logo(const struct linux_logo *logo,
+				 unsigned int n);
+#else
+static inline void fb_append_extra_logo(const struct linux_logo *logo,
+					unsigned int n)
+{}
+#endif
 
 #endif /* _LINUX_LINUX_LOGO_H */

-- 
With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619

