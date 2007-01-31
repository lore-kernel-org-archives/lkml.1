Return-Path: <linux-kernel-owner+w=401wt.eu-S933187AbXAaMon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187AbXAaMon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 07:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933186AbXAaMoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 07:44:30 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:41253 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933174AbXAaMoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 07:44:05 -0500
Date: Wed, 31 Jan 2007 13:44:03 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: James Simmons <jsimmons@infradead.org>
cc: Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/7] fbdev: extract fb_show_logo_line()
In-Reply-To: <Pine.LNX.4.62.0701311325480.14996@pademelon.sonytel.be>
Message-ID: <Pine.LNX.4.62.0701311338480.15066@pademelon.sonytel.be>
References: <Pine.LNX.4.62.0701311325480.14996@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Extract the code to draw one line of logos into fb_show_logo_line()

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
---
 drivers/video/fbmem.c |   39 +++++++++++++++++++++++----------------
 1 files changed, 23 insertions(+), 16 deletions(-)

--- ps3-linux-2.6.20-rc7.orig/drivers/video/fbmem.c
+++ ps3-linux-2.6.20-rc7/drivers/video/fbmem.c
@@ -473,21 +473,23 @@ int fb_prepare_logo(struct fb_info *info
 	return fb_logo.logo->height;
 }
 
-int fb_show_logo(struct fb_info *info, int rotate)
+static int fb_show_logo_line(struct fb_info *info, int rotate,
+			     const struct linux_logo *logo, int y,
+			     unsigned int n)
 {
 	u32 *palette = NULL, *saved_pseudo_palette = NULL;
 	unsigned char *logo_new = NULL, *logo_rotate = NULL;
 	struct fb_image image;
 
 	/* Return if the frame buffer is not mapped or suspended */
-	if (fb_logo.logo == NULL || info->state != FBINFO_STATE_RUNNING)
+	if (logo == NULL || info->state != FBINFO_STATE_RUNNING)
 		return 0;
 
 	image.depth = 8;
-	image.data = fb_logo.logo->data;
+	image.data = logo->data;
 
 	if (fb_logo.needs_cmapreset)
-		fb_set_logocmap(info, fb_logo.logo);
+		fb_set_logocmap(info, logo);
 
 	if (fb_logo.needs_truepalette || 
 	    fb_logo.needs_directpalette) {
@@ -496,17 +498,16 @@ int fb_show_logo(struct fb_info *info, i
 			return 0;
 
 		if (fb_logo.needs_truepalette)
-			fb_set_logo_truepalette(info, fb_logo.logo, palette);
+			fb_set_logo_truepalette(info, logo, palette);
 		else
-			fb_set_logo_directpalette(info, fb_logo.logo, palette);
+			fb_set_logo_directpalette(info, logo, palette);
 
 		saved_pseudo_palette = info->pseudo_palette;
 		info->pseudo_palette = palette;
 	}
 
 	if (fb_logo.depth <= 4) {
-		logo_new = kmalloc(fb_logo.logo->width * fb_logo.logo->height, 
-				   GFP_KERNEL);
+		logo_new = kmalloc(logo->width * logo->height, GFP_KERNEL);
 		if (logo_new == NULL) {
 			kfree(palette);
 			if (saved_pseudo_palette)
@@ -514,29 +515,35 @@ int fb_show_logo(struct fb_info *info, i
 			return 0;
 		}
 		image.data = logo_new;
-		fb_set_logo(info, fb_logo.logo, logo_new, fb_logo.depth);
+		fb_set_logo(info, logo, logo_new, fb_logo.depth);
 	}
 
 	image.dx = 0;
-	image.dy = 0;
-	image.width = fb_logo.logo->width;
-	image.height = fb_logo.logo->height;
+	image.dy = y;
+	image.width = logo->width;
+	image.height = logo->height;
 
 	if (rotate) {
-		logo_rotate = kmalloc(fb_logo.logo->width *
-				      fb_logo.logo->height, GFP_KERNEL);
+		logo_rotate = kmalloc(logo->width *
+				      logo->height, GFP_KERNEL);
 		if (logo_rotate)
 			fb_rotate_logo(info, logo_rotate, &image, rotate);
 	}
 
-	fb_do_show_logo(info, &image, rotate, num_online_cpus());
+	fb_do_show_logo(info, &image, rotate, n);
 
 	kfree(palette);
 	if (saved_pseudo_palette != NULL)
 		info->pseudo_palette = saved_pseudo_palette;
 	kfree(logo_new);
 	kfree(logo_rotate);
-	return fb_logo.logo->height;
+	return logo->height;
+}
+
+int fb_show_logo(struct fb_info *info, int rotate)
+{
+	return fb_show_logo_line(info, rotate, fb_logo.logo, 0,
+				 num_online_cpus());
 }
 #else
 int fb_prepare_logo(struct fb_info *info, int rotate) { return 0; }

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
