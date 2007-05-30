Return-Path: <linux-kernel-owner+w=401wt.eu-S1752736AbXE3IEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbXE3IEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 04:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbXE3IDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 04:03:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbXE3IDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 04:03:51 -0400
Date: Wed, 30 May 2007 04:01:59 -0400
From: Bill Nottingham <notting@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH] drivers/video: Fix comparisons between negative and
	unsigned
Message-ID: <20070530080159.GA29146@nostromo.devel.redhat.com>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	linux-fbdev-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Recent gcc versions emit warnings when unsigned variables are compared < 0 or >= 0.

Signed-off-by: Bill Nottingham <notting@redhat.com>

---
 aty/aty128fb.c       |    3 ---
 aty/radeon_base.c    |    5 -----
 cirrusfb.c           |    5 -----
 fbmem.c              |    8 ++++----
 intelfb/intelfbdrv.c |    5 -----
 riva/fbdev.c         |    5 -----
 vga16fb.c            |    2 +-
 7 files changed, 5 insertions(+), 28 deletions(-)

diff -ru linux-2.6.21-old/drivers/video/aty/aty128fb.c linux-2.6.21/drivers/video/aty/aty128fb.c
--- linux-2.6.21-old/drivers/video/aty/aty128fb.c	2007-05-30 02:53:00.000000000 -0400
+++ linux-2.6.21/drivers/video/aty/aty128fb.c	2007-05-30 02:28:35.000000000 -0400
@@ -1350,9 +1350,6 @@
 		}
 	}
 
-	if (pll->post_divider < 0)
-		return -EINVAL;
-
 	/* calculate feedback divider */
 	n = c.ref_divider * output_freq;
 	d = c.ref_clk;
diff -ru linux-2.6.21-old/drivers/video/aty/radeon_base.c linux-2.6.21/drivers/video/aty/radeon_base.c
--- linux-2.6.21-old/drivers/video/aty/radeon_base.c	2007-05-30 02:53:00.000000000 -0400
+++ linux-2.6.21/drivers/video/aty/radeon_base.c	2007-05-30 02:28:13.000000000 -0400
@@ -813,11 +813,6 @@
 	if (v.xres_virtual < v.xres)
 		v.xres = v.xres_virtual;
 
-	if (v.xoffset < 0)
-                v.xoffset = 0;
-        if (v.yoffset < 0)
-                v.yoffset = 0;
-         
         if (v.xoffset > v.xres_virtual - v.xres)
                 v.xoffset = v.xres_virtual - v.xres - 1;
                         
diff -ru linux-2.6.21-old/drivers/video/cirrusfb.c linux-2.6.21/drivers/video/cirrusfb.c
--- linux-2.6.21-old/drivers/video/cirrusfb.c	2007-05-30 02:53:00.000000000 -0400
+++ linux-2.6.21/drivers/video/cirrusfb.c	2007-05-30 02:29:21.000000000 -0400
@@ -729,11 +729,6 @@
 	if (var->yres_virtual < var->yres)
 		var->yres_virtual = var->yres;
 
-	if (var->xoffset < 0)
-		var->xoffset = 0;
-	if (var->yoffset < 0)
-		var->yoffset = 0;
-
 	/* truncate xoffset and yoffset to maximum if too high */
 	if (var->xoffset > var->xres_virtual - var->xres)
 		var->xoffset = var->xres_virtual - var->xres - 1;
diff -ru linux-2.6.21-old/drivers/video/fbmem.c linux-2.6.21/drivers/video/fbmem.c
--- linux-2.6.21-old/drivers/video/fbmem.c	2007-05-30 02:53:00.000000000 -0400
+++ linux-2.6.21/drivers/video/fbmem.c	2007-05-30 02:27:25.000000000 -0400
@@ -392,7 +392,7 @@
 			image->dx += image->width + 8;
 		}
 	} else if (rotate == FB_ROTATE_UD) {
-		for (x = 0; x < num && image->dx >= 0; x++) {
+		for (x = 0; x < num; x++) {
 			info->fbops->fb_imageblit(info, image);
 			image->dx -= image->width + 8;
 		}
@@ -404,7 +404,7 @@
 			image->dy += image->height + 8;
 		}
 	} else if (rotate == FB_ROTATE_CCW) {
-		for (x = 0; x < num && image->dy >= 0; x++) {
+		for (x = 0; x < num; x++) {
 			info->fbops->fb_imageblit(info, image);
 			image->dy -= image->height + 8;
 		}
@@ -973,9 +973,9 @@
 	case FBIOPUT_CON2FBMAP:
 		if (copy_from_user(&con2fb, argp, sizeof(con2fb)))
 			return - EFAULT;
-		if (con2fb.console < 0 || con2fb.console > MAX_NR_CONSOLES)
+		if (con2fb.console > MAX_NR_CONSOLES)
 		    return -EINVAL;
-		if (con2fb.framebuffer < 0 || con2fb.framebuffer >= FB_MAX)
+		if (con2fb.framebuffer >= FB_MAX)
 		    return -EINVAL;
 #ifdef CONFIG_KMOD
 		if (!registered_fb[con2fb.framebuffer])
diff -ru linux-2.6.21-old/drivers/video/intelfb/intelfbdrv.c linux-2.6.21/drivers/video/intelfb/intelfbdrv.c
--- linux-2.6.21-old/drivers/video/intelfb/intelfbdrv.c	2007-05-30 02:53:13.000000000 -0400
+++ linux-2.6.21/drivers/video/intelfb/intelfbdrv.c	2007-05-30 02:30:32.000000000 -0400
@@ -1343,11 +1343,6 @@
 		break;
 	}
 
-	if (v.xoffset < 0)
-		v.xoffset = 0;
-	if (v.yoffset < 0)
-		v.yoffset = 0;
-
 	if (v.xoffset > v.xres_virtual - v.xres)
 		v.xoffset = v.xres_virtual - v.xres;
 	if (v.yoffset > v.yres_virtual - v.yres)
diff -ru linux-2.6.21-old/drivers/video/riva/fbdev.c linux-2.6.21/drivers/video/riva/fbdev.c
--- linux-2.6.21-old/drivers/video/riva/fbdev.c	2007-05-30 02:53:00.000000000 -0400
+++ linux-2.6.21/drivers/video/riva/fbdev.c	2007-05-30 02:29:05.000000000 -0400
@@ -1185,11 +1185,6 @@
 	if (rivafb_do_maximize(info, var, nom, den) < 0)
 		return -EINVAL;
 
-	if (var->xoffset < 0)
-		var->xoffset = 0;
-	if (var->yoffset < 0)
-		var->yoffset = 0;
-
 	/* truncate xoffset and yoffset to maximum if too high */
 	if (var->xoffset > var->xres_virtual - var->xres)
 		var->xoffset = var->xres_virtual - var->xres - 1;
diff -ru linux-2.6.21-old/drivers/video/vga16fb.c linux-2.6.21/drivers/video/vga16fb.c
--- linux-2.6.21-old/drivers/video/vga16fb.c	2007-05-30 02:53:01.000000000 -0400
+++ linux-2.6.21/drivers/video/vga16fb.c	2007-05-30 02:30:08.000000000 -0400
@@ -1092,7 +1092,7 @@
 	sy += (dy - old_dy);
 
 	/* the source must be completely inside the virtual screen */
-	if (sx < 0 || sy < 0 || (sx + width) > vxres || (sy + height) > vyres)
+	if ((sx + width) > vxres || (sy + height) > vyres)
 		return;
 
 	switch (info->fix.type) {
