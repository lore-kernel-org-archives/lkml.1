Return-Path: <linux-kernel-owner+w=401wt.eu-S1759644AbZFXLka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759644AbZFXLka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 07:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757802AbZFXLgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 07:36:43 -0400
Received: from smtp.nokia.com ([192.100.105.134]:58190 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757616AbZFXLgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 07:36:40 -0400
From: Imre Deak <imre.deak@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Antonino Daplas <adaplas@gmail.com>, Tony Lindgren <tony@atomide.com>,
       Tomi Valkeinen <Tomi.Valkeinen@nokia.com>
Subject: [PATCH 11/20] omapfb: Add support for rotation on the Blizzard LCD ctrl
Date: Wed, 24 Jun 2009 14:33:36 +0300
Message-Id: <279625bb9ea911185e017cdf8d18a46f263fbb5c.1245842329.git.imre.deak@nokia.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <742d96c9c8d6826eddd49a913b6adaa8f176edbe.1245842329.git.imre.deak@nokia.com>
References: <1245843225-1036-1-git-send-email-imre.deak@nokia.com>
 <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
 <5cf7e298c3b70ad6e07d34034cc901689445e978.1245842329.git.imre.deak@nokia.com>
 <f2b49525146391a3d01b944bf4ebce045cb503d4.1245842329.git.imre.deak@nokia.com>
 <9cecdc5077b72042551eb8e3dc96911e9f4fa3fd.1245842329.git.imre.deak@nokia.com>
 <a3b6ef17cc694c350bc3a585a1697cf57cb0b1c1.1245842329.git.imre.deak@nokia.com>
 <0e2b7b0555c657a8eab00df0091b9828fb292f4c.1245842329.git.imre.deak@nokia.com>
 <af3d1e0dff22f0bb72f6ccee57dfa9a1e5f31abb.1245842329.git.imre.deak@nokia.com>
 <6881ca5b34fcf36c3f39b13de85857dcc20f568d.1245842329.git.imre.deak@nokia.com>
 <726d4af0547b42ec8a9af7c6f0079cf9b7fadf5c.1245842329.git.imre.deak@nokia.com>
 <742d96c9c8d6826eddd49a913b6adaa8f176edbe.1245842329.git.imre.deak@nokia.com>
In-Reply-To: <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
References: <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
X-OriginalArrivalTime: 24 Jun 2009 11:36:08.0169 (UTC) FILETIME=[F74C8D90:01C9F4BF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rodrigo Vivi <rodrigo.vivi@openbossa.org>

The LCD controller (EPSON S1D13744) supports rotation (0, 90, 180
and 270 degrees) on hardware just setting the bits 0 and 1 of 0x28
register (LCD Panel Configuration Register). Now it is possible to
use this caps only setting the angle degree on var rotate of
fb_var_screeninfo using the FBIOPUT_VSCREENINFO ioctl.

Fixed-by: Siarhei Siamashka <siarhei.siamashka@nokia.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@openbossa.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Imre Deak <imre.deak@nokia.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
---
 drivers/video/omap/blizzard.c    |   91 +++++++++++++++++++++++++++++++++++--
 drivers/video/omap/omapfb_main.c |   52 ++++++++++++++++------
 2 files changed, 124 insertions(+), 19 deletions(-)

diff --git a/drivers/video/omap/blizzard.c b/drivers/video/omap/blizzard.c
index 9dfcf39..d5e5955 100644
--- a/drivers/video/omap/blizzard.c
+++ b/drivers/video/omap/blizzard.c
@@ -44,6 +44,7 @@
 #define BLIZZARD_CLK_SRC			0x0e
 #define BLIZZARD_MEM_BANK0_ACTIVATE		0x10
 #define BLIZZARD_MEM_BANK0_STATUS		0x14
+#define BLIZZARD_PANEL_CONFIGURATION		0x28
 #define BLIZZARD_HDISP				0x2a
 #define BLIZZARD_HNDP				0x2c
 #define BLIZZARD_VDISP0				0x2e
@@ -162,6 +163,10 @@ struct blizzard_struct {
 	int			vid_scaled;
 	int			last_color_mode;
 	int			zoom_on;
+	int			zoom_area_gx1;
+	int			zoom_area_gx2;
+	int			zoom_area_gy1;
+	int			zoom_area_gy2;
 	int			screen_width;
 	int			screen_height;
 	unsigned		te_connected:1;
@@ -513,6 +518,13 @@ static int do_full_screen_update(struct blizzard_request *req)
 	return REQ_PENDING;
 }
 
+static int check_1d_intersect(int a1, int a2, int b1, int b2)
+{
+	if (a2 <= b1 || b2 <= a1)
+		return 0;
+	return 1;
+}
+
 /* Setup all planes with an overlapping area with the update window. */
 static int do_partial_update(struct blizzard_request *req, int plane,
 			     int x, int y, int w, int h,
@@ -525,6 +537,7 @@ static int do_partial_update(struct blizzard_request *req, int plane,
 	int color_mode;
 	int flags;
 	int zoom_off;
+	int have_zoom_for_this_update = 0;
 
 	/* Global coordinates, relative to pixel 0,0 of the LCD */
 	gx1 = x + blizzard.plane[plane].pos_x;
@@ -544,10 +557,6 @@ static int do_partial_update(struct blizzard_request *req, int plane,
 		gx2_out = gx1_out + w_out;
 		gy2_out = gy1_out + h_out;
 	}
-	zoom_off = blizzard.zoom_on && gx1 == 0 && gy1 == 0 &&
-		w == blizzard.screen_width && h == blizzard.screen_height;
-	blizzard.zoom_on = (!zoom_off && blizzard.zoom_on) ||
-			   (w < w_out || h < h_out);
 
 	for (i = 0; i < OMAPFB_PLANE_NUM; i++) {
 		struct plane_info *p = &blizzard.plane[i];
@@ -653,8 +662,49 @@ static int do_partial_update(struct blizzard_request *req, int plane,
 	else
 		disable_tearsync();
 
+	if ((gx2_out - gx1_out) != (gx2 - gx1) ||
+	    (gy2_out - gy1_out) != (gy2 - gy1))
+		have_zoom_for_this_update = 1;
+
+	/* 'background' type of screen update (as opposed to 'destructive')
+	   can be used to disable scaling if scaling is active */
+	zoom_off = blizzard.zoom_on && !have_zoom_for_this_update &&
+	    (gx1_out == 0) && (gx2_out == blizzard.screen_width) &&
+	    (gy1_out == 0) && (gy2_out == blizzard.screen_height) &&
+	    (gx1 == 0) && (gy1 == 0);
+
+	if (blizzard.zoom_on && !have_zoom_for_this_update && !zoom_off &&
+	    check_1d_intersect(blizzard.zoom_area_gx1, blizzard.zoom_area_gx2,
+			       gx1_out, gx2_out) &&
+	    check_1d_intersect(blizzard.zoom_area_gy1, blizzard.zoom_area_gy2,
+			       gy1_out, gy2_out)) {
+		/* Previous screen update was using scaling, current update
+		 * is not using it. Additionally, current screen update is
+		 * going to overlap with the scaled area. Scaling needs to be
+		 * disabled in order to avoid 'magnifying glass' effect.
+		 * Dummy setup of background window can be used for this.
+		 */
+		set_window_regs(0, 0, blizzard.screen_width,
+				blizzard.screen_height,
+				0, 0, blizzard.screen_width,
+				blizzard.screen_height,
+				BLIZZARD_COLOR_RGB565, 1, flags);
+		blizzard.zoom_on = 0;
+	}
+
+	/* remember scaling settings if we have scaled update */
+	if (have_zoom_for_this_update) {
+		blizzard.zoom_on = 1;
+		blizzard.zoom_area_gx1 = gx1_out;
+		blizzard.zoom_area_gx2 = gx2_out;
+		blizzard.zoom_area_gy1 = gy1_out;
+		blizzard.zoom_area_gy2 = gy2_out;
+	}
+
 	set_window_regs(gx1, gy1, gx2, gy2, gx1_out, gy1_out, gx2_out, gy2_out,
 			color_mode, zoom_off, flags);
+	if (zoom_off)
+		blizzard.zoom_on = 0;
 
 	blizzard.extif->set_bits_per_cycle(16);
 	/* set_window_regs has left the register index at the right
@@ -908,6 +958,35 @@ static int blizzard_set_scale(int plane, int orig_w, int orig_h,
 	return 0;
 }
 
+static int blizzard_set_rotate(int angle)
+{
+	u32 l;
+
+	l = blizzard_read_reg(BLIZZARD_PANEL_CONFIGURATION);
+	l &= ~0x03;
+
+	switch (angle) {
+	case 0:
+		l = l | 0x00;
+		break;
+	case 90:
+		l = l | 0x03;
+		break;
+	case 180:
+		l = l | 0x02;
+		break;
+	case 270:
+		l = l | 0x01;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	blizzard_write_reg(BLIZZARD_PANEL_CONFIGURATION, l);
+
+	return 0;
+}
+
 static int blizzard_enable_plane(int plane, int enable)
 {
 	if (enable)
@@ -1285,7 +1364,8 @@ static void blizzard_get_caps(int plane, struct omapfb_caps *caps)
 	caps->ctrl |= OMAPFB_CAPS_MANUAL_UPDATE |
 		OMAPFB_CAPS_WINDOW_PIXEL_DOUBLE |
 		OMAPFB_CAPS_WINDOW_SCALE |
-		OMAPFB_CAPS_WINDOW_OVERLAY;
+		OMAPFB_CAPS_WINDOW_OVERLAY |
+		OMAPFB_CAPS_WINDOW_ROTATE;
 	if (blizzard.te_connected)
 		caps->ctrl |= OMAPFB_CAPS_TEARSYNC;
 	caps->wnd_color |= (1 << OMAPFB_COLOR_RGB565) |
@@ -1560,6 +1640,7 @@ struct lcd_ctrl blizzard_ctrl = {
 	.setup_plane		= blizzard_setup_plane,
 	.set_scale		= blizzard_set_scale,
 	.enable_plane		= blizzard_enable_plane,
+	.set_rotate		= blizzard_set_rotate,
 	.update_window		= blizzard_update_window_async,
 	.sync			= blizzard_sync,
 	.suspend		= blizzard_suspend,
diff --git a/drivers/video/omap/omapfb_main.c b/drivers/video/omap/omapfb_main.c
index 060d72f..5b04b9c 100644
--- a/drivers/video/omap/omapfb_main.c
+++ b/drivers/video/omap/omapfb_main.c
@@ -67,6 +67,7 @@ static struct caps_table_struct ctrl_caps[] = {
 	{ OMAPFB_CAPS_WINDOW_PIXEL_DOUBLE, "pixel double window" },
 	{ OMAPFB_CAPS_WINDOW_SCALE,   "scale window" },
 	{ OMAPFB_CAPS_WINDOW_OVERLAY, "overlay window" },
+	{ OMAPFB_CAPS_WINDOW_ROTATE,  "rotate window" },
 	{ OMAPFB_CAPS_SET_BACKLIGHT,  "backlight setting" },
 };
 
@@ -215,6 +216,15 @@ static int ctrl_change_mode(struct fb_info *fbi)
 				 offset, var->xres_virtual,
 				 plane->info.pos_x, plane->info.pos_y,
 				 var->xres, var->yres, plane->color_mode);
+	if (r < 0)
+		return r;
+
+	if (fbdev->ctrl->set_rotate != NULL) {
+		r = fbdev->ctrl->set_rotate(var->rotate);
+		if (r < 0)
+			return r;
+	}
+
 	if (fbdev->ctrl->set_scale != NULL)
 		r = fbdev->ctrl->set_scale(plane->idx,
 				   var->xres, var->yres,
@@ -598,7 +608,7 @@ static void omapfb_rotate(struct fb_info *fbi, int rotate)
 	struct omapfb_device *fbdev = plane->fbdev;
 
 	omapfb_rqueue_lock(fbdev);
-	if (cpu_is_omap15xx() && rotate != fbi->var.rotate) {
+	if (rotate != fbi->var.rotate) {
 		struct fb_var_screeninfo *new_var = &fbdev->new_var;
 
 		memcpy(new_var, &fbi->var, sizeof(*new_var));
@@ -705,28 +715,42 @@ int omapfb_update_window_async(struct fb_info *fbi,
 				void (*callback)(void *),
 				void *callback_data)
 {
+	int xres, yres;
 	struct omapfb_plane_struct *plane = fbi->par;
 	struct omapfb_device *fbdev = plane->fbdev;
-	struct fb_var_screeninfo *var;
+	struct fb_var_screeninfo *var = &fbi->var;
+
+	switch (var->rotate) {
+	case 0:
+	case 180:
+		xres = fbdev->panel->x_res;
+		yres = fbdev->panel->y_res;
+		break;
+	case 90:
+	case 270:
+		xres = fbdev->panel->y_res;
+		yres = fbdev->panel->x_res;
+		break;
+	default:
+		return -EINVAL;
+	}
 
-	var = &fbi->var;
-	if (win->x >= var->xres || win->y >= var->yres ||
-	    win->out_x > var->xres || win->out_y >= var->yres)
+	if (win->x >= xres || win->y >= yres ||
+	    win->out_x > xres || win->out_y > yres)
 		return -EINVAL;
 
 	if (!fbdev->ctrl->update_window ||
 	    fbdev->ctrl->get_update_mode() != OMAPFB_MANUAL_UPDATE)
 		return -ENODEV;
 
-	if (win->x + win->width >= var->xres)
-		win->width = var->xres - win->x;
-	if (win->y + win->height >= var->yres)
-		win->height = var->yres - win->y;
-	/* The out sizes should be cropped to the LCD size */
-	if (win->out_x + win->out_width > fbdev->panel->x_res)
-		win->out_width = fbdev->panel->x_res - win->out_x;
-	if (win->out_y + win->out_height > fbdev->panel->y_res)
-		win->out_height = fbdev->panel->y_res - win->out_y;
+	if (win->x + win->width > xres)
+		win->width = xres - win->x;
+	if (win->y + win->height > yres)
+		win->height = yres - win->y;
+	if (win->out_x + win->out_width > xres)
+		win->out_width = xres - win->out_x;
+	if (win->out_y + win->out_height > yres)
+		win->out_height = yres - win->out_y;
 	if (!win->width || !win->height || !win->out_width || !win->out_height)
 		return 0;
 
-- 
1.6.3.2

