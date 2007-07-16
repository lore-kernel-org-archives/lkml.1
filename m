Return-Path: <linux-kernel-owner+w=401wt.eu-S1765493AbXGPOB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765493AbXGPOB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760640AbXGPOAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:00:54 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:42197 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760121AbXGPOAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:00:53 -0400
Message-Id: <20070716135950.796801000@pademelon.sonytel.be>
References: <20070716135550.010775000@pademelon.sonytel.be>
User-Agent: quilt/0.46-1
Date: Mon, 16 Jul 2007 15:55:51 +0200
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, James Simmons <jsimmons@infradead.org>,
       linux-fbdev-devel@lists.sourceforge.net, cbe-oss-dev@ozlabs.org,
       linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Geoff Levand <geoffrey.levand@am.sony.com>
Subject: [patch 1/4] fbdev: extract fb_show_logo_line()
Content-Disposition: inline; filename=spe-logo/fb_show_logo_line.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Extract the code to draw one line of logos into fb_show_logo_line()

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
Acked-By: James Simmons <jsimmons@infradead.org>
---
 drivers/video/fbmem.c |   39 +++++++++++++++++++++++----------------
 1 files changed, 23 insertions(+), 16 deletions(-)

--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -477,22 +477,24 @@ int fb_prepare_logo(struct fb_info *info
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
-	if (fb_logo.logo == NULL || info->state != FBINFO_STATE_RUNNING ||
+	if (logo == NULL || info->state != FBINFO_STATE_RUNNING ||
 	    info->flags & FBINFO_MODULE)
 		return 0;
 
 	image.depth = 8;
-	image.data = fb_logo.logo->data;
+	image.data = logo->data;
 
 	if (fb_logo.needs_cmapreset)
-		fb_set_logocmap(info, fb_logo.logo);
+		fb_set_logocmap(info, logo);
 
 	if (fb_logo.needs_truepalette || 
 	    fb_logo.needs_directpalette) {
@@ -501,17 +503,16 @@ int fb_show_logo(struct fb_info *info, i
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
@@ -519,29 +520,35 @@ int fb_show_logo(struct fb_info *info, i
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

