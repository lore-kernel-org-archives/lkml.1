Return-Path: <linux-kernel-owner+w=401wt.eu-S933201AbXAaMqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201AbXAaMqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 07:46:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933198AbXAaMoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 07:44:24 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:41266 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933187AbXAaMoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 07:44:12 -0500
Date: Wed, 31 Jan 2007 13:44:11 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: James Simmons <jsimmons@infradead.org>
cc: Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/7] fbdev: Add fb_append_extra_logo()
In-Reply-To: <Pine.LNX.4.62.0701311325480.14996@pademelon.sonytel.be>
Message-ID: <Pine.LNX.4.62.0701311340310.15066@pademelon.sonytel.be>
References: <Pine.LNX.4.62.0701311325480.14996@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add fb_append_extra_logo(), to append extra lines of logos below the standard
Linux logo.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
---
 drivers/video/fbmem.c      |   50 +++++++++++++++++++++++++++++++++++++++++----
 include/linux/linux_logo.h |    8 +++++++
 2 files changed, 54 insertions(+), 4 deletions(-)

--- ps3-linux-2.6.20-rc7.orig/drivers/video/fbmem.c
+++ ps3-linux-2.6.20-rc7/drivers/video/fbmem.c
@@ -319,6 +319,13 @@ static struct logo_data {
 	const struct linux_logo *logo;
 } fb_logo __read_mostly;
 
+#define FB_LOGO_EX_NUM_MAX 10
+static struct logo_data_extra {
+	const struct linux_logo *logo;
+	unsigned int n;
+} fb_logo_ex[FB_LOGO_EX_NUM_MAX];
+static unsigned int fb_logo_ex_num = 0;
+
 static void fb_rotate_logo_ud(const u8 *in, u8 *out, u32 width, u32 height)
 {
 	u32 size = width * height, i;
@@ -408,10 +415,20 @@ static void fb_do_show_logo(struct fb_in
 	}
 }
 
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
 int fb_prepare_logo(struct fb_info *info, int rotate)
 {
 	int depth = fb_get_color_depth(&info->var, &info->fix);
-	int yres;
+	unsigned int yres, height, i;
 
 	memset(&fb_logo, 0, sizeof(struct logo_data));
 
@@ -470,7 +487,21 @@ int fb_prepare_logo(struct fb_info *info
 		fb_logo.depth = 4;
 	else
 		fb_logo.depth = 1;		
-	return fb_logo.logo->height;
+
+	/* FIXME: logo_ex supports only truecolor fb. */
+	if (info->fix.visual != FB_VISUAL_TRUECOLOR)
+		fb_logo_ex_num = 0;
+
+	height = fb_logo.logo->height;
+	for (i = 0; i < fb_logo_ex_num; i++) {
+		height += fb_logo_ex[i].logo->height;
+		if (height > yres) {
+			height -= fb_logo_ex[i].logo->height;
+			fb_logo_ex_num = i;
+			break;
+		}
+	}
+	return height;
 }
 
 static int fb_show_logo_line(struct fb_info *info, int rotate,
@@ -542,10 +573,20 @@ static int fb_show_logo_line(struct fb_i
 
 int fb_show_logo(struct fb_info *info, int rotate)
 {
-	return fb_show_logo_line(info, rotate, fb_logo.logo, 0,
-				 num_online_cpus());
+	int y, i;
+
+	y = fb_show_logo_line(info, rotate, fb_logo.logo, 0,
+			      num_online_cpus());
+
+	for (i = 0; i < fb_logo_ex_num; i++) {
+		y += fb_show_logo_line(info, rotate,
+				       fb_logo_ex[i].logo, y, fb_logo_ex[i].n);
+	}
+
+	return y;
 }
 #else
+void fb_append_extra_logo(const struct linux_logo *logo, int n) {}
 int fb_prepare_logo(struct fb_info *info, int rotate) { return 0; }
 int fb_show_logo(struct fb_info *info, int rotate) { return 0; }
 #endif /* CONFIG_LOGO */
@@ -1561,6 +1602,7 @@ EXPORT_SYMBOL(register_framebuffer);
 EXPORT_SYMBOL(unregister_framebuffer);
 EXPORT_SYMBOL(num_registered_fb);
 EXPORT_SYMBOL(registered_fb);
+EXPORT_SYMBOL(fb_append_extra_logo);
 EXPORT_SYMBOL(fb_prepare_logo);
 EXPORT_SYMBOL(fb_show_logo);
 EXPORT_SYMBOL(fb_set_var);
--- ps3-linux-2.6.20-rc7.orig/include/linux/linux_logo.h
+++ ps3-linux-2.6.20-rc7/include/linux/linux_logo.h
@@ -46,5 +46,13 @@ extern struct linux_logo logo_superh_clu
 extern struct linux_logo logo_m32r_clut224;
 
 extern const struct linux_logo *fb_find_logo(int depth);
+#ifdef CONFIG_LOGO
+extern void fb_append_extra_logo(const struct linux_logo *logo,
+				 unsigned int n);
+#else
+static inline void fb_append_extra_logo(const struct linux_logo *logo,
+					unsigned int n)
+{}
+#endif
 
 #endif /* _LINUX_LINUX_LOGO_H */

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
