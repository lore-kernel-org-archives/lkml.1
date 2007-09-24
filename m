Return-Path: <linux-kernel-owner+w=401wt.eu-S1757242AbXIXCU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242AbXIXCU2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 22:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbXIXCUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 22:20:21 -0400
Received: from learn.laptop.org ([18.85.46.19]:43596 "EHLO learn.laptop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736AbXIXCUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 22:20:20 -0400
From: Bernardo Innocenti <bernie@codewiz.org>
To: Jordan Crouse <jordan.crouse@amd.com>
Cc: Andres Solomon <dilinger@queued.net>, OLPC Development <devel@laptop.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Bernardo Innocenti <bernie@codewiz.org>
Subject: [PATCH] GEODE: decouple sleep/resume from powerdown/powerup (take 2)
Date: Sun, 23 Sep 2007 22:19:58 -0400
Message-Id: <11906003982852-git-send-email-bernie@codewiz.org>
X-Mailer: git-send-email 1.5.2.2
Organization: One Laptop Per Child
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch merges the fb_powerup and fb_powerdown hooks in a single
operation fb_power with an additional "state" parameter ranging
from 0 (running) to 3 (poweroff).

The geodefb uses state 2 as an intermediate low-power mode, where
the LX or GX video unit is turned off, but the GPU may still be working.
Notably, the GPU register set does not get overwritten when resuming
to state 0, so the system can safely keep using the GPU while in state 2.
The DCON driver now uses this new suspend state to let the X server draw
in the background while the screen frozen.

This fixes the rather amusing OLPC bug #3603 that made the toolbar icons
come up tinted in green when "pretty boot" was enabled.  Tested on both
B2 (GX) and B3 (LX) machines.  Both the freeze/unfreeze and suspend/resume
codepaths work as expected.

This second revision ensures the GX registers are saved in both the
suspend and powerdown cases, otherwise we restore stale register state
when we unfreeze.

Signed-off-by: Bernardo Innocenti <bernie@codewiz.org>
---
 drivers/video/fbmem.c           |   47 +++++--------------
 drivers/video/geode/geodefb.h   |   13 +++--
 drivers/video/geode/gxfb_core.c |   17 +++----
 drivers/video/geode/lxfb.h      |    3 +-
 drivers/video/geode/lxfb_core.c |   12 ++---
 drivers/video/geode/lxfb_ops.c  |   47 ++++++++++++--------
 drivers/video/geode/video_gx.c  |   94 ++++++++++++++++----------------------
 drivers/video/geode/video_gx.h  |    3 +-
 drivers/video/olpc_dcon.c       |    8 ++--
 include/linux/fb.h              |    7 +--
 10 files changed, 110 insertions(+), 141 deletions(-)

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 61d7659..51c9f79 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -736,49 +736,28 @@ static void try_to_load(int fb)
 #endif /* CONFIG_KMOD */
 
 int
-fb_powerup(struct fb_info *info)
+fb_power(struct fb_info *info, int state)
 {
 	int ret = 0;
 
-	if (!info || info->state == FBINFO_STATE_RUNNING)
-		return 0;
-
-	if (info->fbops->fb_powerup)
-		ret = info->fbops->fb_powerup(info);
-
-	if (!ret) {
-		acquire_console_sem();
-		fb_set_suspend(info, 0);
-		release_console_sem();
-	}
-
-	return ret;
-}
-
-int
-fb_powerdown(struct fb_info *info)
-{
-	int ret = 0;
-
-	if (!info || info->state == FBINFO_STATE_SUSPENDED)
-		return 0;
+	if (state < 0 || state > 3)
+		return -EINVAL;
 
-	/* Tell everybody that the fbdev is going down */
 	acquire_console_sem();
-	fb_set_suspend(info, 1);
-	release_console_sem();
+	/* Powerdown? */
+	if (state == 3 && info->state != FBINFO_STATE_SUSPENDED)
+		/* Tell everybody that the fbdev is going down */
+		fb_set_suspend(info, 1);
 
-	if (info->fbops->fb_powerdown)
-		ret = info->fbops->fb_powerdown(info);
+	if (info->fbops->fb_power)
+		ret = info->fbops->fb_power(info, state);
 
-	/* If the power down failed, then un-notify */
-
-	if (ret) {
-		acquire_console_sem();
+	/* Power down failed, or powerup succeeded? */
+	if (((state == 3 && ret) || !ret) && (info->state != FBINFO_STATE_RUNNING))
+		/* Tell everybody that the fbdev is back up */
 		fb_set_suspend(info, 0);
-		release_console_sem();
-	}
 
+	release_console_sem();
 	return ret;
 }
 
diff --git a/drivers/video/geode/geodefb.h b/drivers/video/geode/geodefb.h
index 0214d11..cd1ce6e 100644
--- a/drivers/video/geode/geodefb.h
+++ b/drivers/video/geode/geodefb.h
@@ -12,12 +12,14 @@
 #ifndef __GEODEFB_H__
 #define __GEODEFB_H__
 
-#define FB_POWER_STATE_OFF      0
-#define FB_POWER_STATE_SUSPEND  1
-#define FB_POWER_STATE_ON       2
-
 struct geodefb_info;
 
+/* For geodefb_par->power_state */
+#define FB_POWER_STATE_OFF      3
+#define FB_POWER_STATE_SUSPEND  2
+#define FB_POWER_STATE_UNUSED   1 /* Reserved */
+#define FB_POWER_STATE_ON       0
+
 struct geode_dc_ops {
 	void (*set_mode)(struct fb_info *);
 	void (*set_palette_reg)(struct fb_info *, unsigned, unsigned, unsigned, unsigned);
@@ -42,7 +44,8 @@ struct geodefb_par {
 	struct geode_dc_ops  *dc_ops;
 	struct geode_vid_ops *vid_ops;
 
-	int state;
+	/* See FB_POWER_STATE_* definitions above */
+	int power_state;
 };
 
 #endif /* !__GEODEFB_H__ */
diff --git a/drivers/video/geode/gxfb_core.c b/drivers/video/geode/gxfb_core.c
index 3eabc53..cd43c8e 100644
--- a/drivers/video/geode/gxfb_core.c
+++ b/drivers/video/geode/gxfb_core.c
@@ -383,8 +383,7 @@ static struct fb_ops gxfb_ops = {
 	.fb_fillrect	= cfb_fillrect,
 	.fb_copyarea	= cfb_copyarea,
 	.fb_imageblit	= cfb_imageblit,
-	.fb_powerdown   = gxfb_powerdown,
-	.fb_powerup     = gxfb_powerup,
+	.fb_power       = gxfb_power,
 };
 
 static struct fb_info * __init gxfb_init_fbinfo(struct device *dev)
@@ -452,13 +451,13 @@ static int gxfb_suspend(struct pci_dev *pdev,  pm_message_t state)
 		return 0;
 
 	if (state.event == PM_EVENT_SUSPEND) {
-	 
+
 		acquire_console_sem();
-		gxfb_powerdown(info);
+		gxfb_power(info, 3);
 
-		par->state = FB_POWER_STATE_OFF;
+		par->power_state = FB_POWER_STATE_OFF;
 		fb_set_suspend(info, 1);
-		
+
 		release_console_sem();
 	}
 
@@ -471,10 +470,10 @@ static int gxfb_resume(struct pci_dev *pdev)
 	struct fb_info *info = pci_get_drvdata(pdev);
 
 	acquire_console_sem();
-	
+
 	/* Turn the engine completely on */
 
-	if (gxfb_powerup(info))
+	if (gxfb_power(info, 0))
 	  printk(KERN_ERR "gxfb:  Powerup failed\n");
 
 	fb_set_suspend(info, 0);
@@ -557,7 +556,7 @@ static int __init gxfb_probe(struct pci_dev *pdev,
 	gxfb_set_par(gxfb_info);
 
 	/* We are powered up */
-	par->state = FB_POWER_STATE_ON;
+	par->power_state = FB_POWER_STATE_ON;
 
 
 	console_event_register(&gxfb_console_notifier);
diff --git a/drivers/video/geode/lxfb.h b/drivers/video/geode/lxfb.h
index 28d8ff3..f886efd 100644
--- a/drivers/video/geode/lxfb.h
+++ b/drivers/video/geode/lxfb.h
@@ -25,8 +25,7 @@ void lx_set_mode(struct fb_info *);
 void lx_get_gamma(struct fb_info *, unsigned int *, int);
 void lx_set_gamma(struct fb_info *, unsigned int *, int);
 unsigned int lx_framebuffer_size(void);
-int lx_shutdown(struct fb_info *);
-int lx_powerup(struct fb_info *);
+int lx_power(struct fb_info *, int level);
 int lx_blank_display(struct fb_info *, int);
 void lx_set_palette_reg(struct fb_info *, unsigned int, unsigned int,
 			unsigned int, unsigned int);
diff --git a/drivers/video/geode/lxfb_core.c b/drivers/video/geode/lxfb_core.c
index 29197e2..b4019d5 100644
--- a/drivers/video/geode/lxfb_core.c
+++ b/drivers/video/geode/lxfb_core.c
@@ -302,8 +302,7 @@ static struct fb_ops lxfb_ops = {
 	.fb_fillrect	= cfb_fillrect,
 	.fb_copyarea	= cfb_copyarea,
 	.fb_imageblit	= cfb_imageblit,
-	.fb_powerdown	= lx_shutdown,
-	.fb_powerup	= lx_powerup,
+	.fb_power	= lx_power,
 };
 
 static struct fb_info * __init lxfb_init_fbinfo(struct device *dev)
@@ -356,8 +355,9 @@ static int lxfb_suspend(struct pci_dev *pdev,  pm_message_t state)
 
 	if (state.event == PM_EVENT_SUSPEND) {
 
+		/* Turn the engine completely off */
 		acquire_console_sem();
-		lx_shutdown(info);
+		lx_power(info, 3);
 		fb_set_suspend(info, 1);
 		release_console_sem();
 	}
@@ -370,11 +370,9 @@ static int lxfb_resume(struct pci_dev *pdev)
 {
 	struct fb_info *info = pci_get_drvdata(pdev);
 
-	acquire_console_sem();
-
 	/* Turn the engine completely on */
-
-	lx_powerup(info);
+	acquire_console_sem();
+	lx_power(info, 0);
 	fb_set_suspend(info, 0);
 	release_console_sem();
 
diff --git a/drivers/video/geode/lxfb_ops.c b/drivers/video/geode/lxfb_ops.c
index b2ecb4d..b380238 100644
--- a/drivers/video/geode/lxfb_ops.c
+++ b/drivers/video/geode/lxfb_ops.c
@@ -829,33 +829,42 @@ static void lx_restore_regs(struct fb_info *info, struct geoderegs *regs)
 	writel(regs->dc.r.dcfg, par->dc_regs + 0x08);
 }
 
-static int lx_power_on = 1;
+/*
+ * Level can be:
+ *  0 - fully powered on
+ *  1 - reserved/undefined
+ *  2 - power save (preserving state)
+ *  3 - fully powered off
+ */
+static int lx_power_state = 0;
 
-int lx_shutdown(struct fb_info *info)
+int lx_power(struct fb_info *info, int state)
 {
 	struct lxfb_par *par = info->par;
 
-	if (lx_power_on == 0)
-		return 0;
-
-	writel(DC_UNLOCK_CODE, par->dc_regs + DC_UNLOCK);
-	lx_save_regs(info, &saved_regs);
-	lx_graphics_disable(info);
+	if (state < 0 || state > 3)
+		return -EINVAL;
 
-	lx_power_on = 0;
-	return 0;
-}
+	/* Going into power save */
+	if (state >= 2 && lx_power_state < 2)
+		lx_graphics_disable(info);
 
-int lx_powerup(struct fb_info *info)
-{
-	struct lxfb_par *par = info->par;
+	/* Powering down */
+	if (state >= 3 && lx_power_state < 3) {
+		writel(DC_UNLOCK_CODE, par->dc_regs + DC_UNLOCK);
+		lx_save_regs(info, &saved_regs);
+	}
 
-	if (lx_power_on == 1)
-		return 0;
+	/* Restoring from power save */
+	if (state < 3 && lx_power_state >= 3) {
+		lx_restore_regs(info, &saved_regs);
+		writel(0, par->dc_regs + DC_UNLOCK);
+	}
 
-	lx_restore_regs(info, &saved_regs);
-	writel(0, par->dc_regs + DC_UNLOCK);
+	/* Powering up */
+	if (state < 2 && lx_power_state >= 2)
+		lx_graphics_enable(info);
 
-	lx_power_on = 1;
+	lx_power_state = state;
 	return 0;
 }
diff --git a/drivers/video/geode/video_gx.c b/drivers/video/geode/video_gx.c
index e282e74..27c59d6 100644
--- a/drivers/video/geode/video_gx.c
+++ b/drivers/video/geode/video_gx.c
@@ -348,46 +348,39 @@ static void gx_configure_display(struct fb_info *info)
 		gx_configure_tft(info);
 }
 
-int gxfb_powerdown(struct fb_info *info) 
+int gxfb_power(struct fb_info *info, int state)
 {
 	struct geodefb_par *par = info->par;
 
-	/* We're already suspended */
-
-	if (par->state != FB_POWER_STATE_ON)
+	/* No state change */
+	if (par->power_state == state)
 		return 0;
 
-	/* Save the registers */
-	gx_save_regs(info, &gx_saved_regs);
-
-	/* Shut down the engine */
-
-	writel(gx_saved_regs.vp.r.vcfg & ~0x01, par->vid_regs + GX_VCFG);
-	writel(gx_saved_regs.vp.r.dcfg & ~0x0F, par->vid_regs + GX_DCFG);
+	/* Going into power save */
+	if (state >= FB_POWER_STATE_SUSPEND && par->power_state < FB_POWER_STATE_SUSPEND) {
+		/* Save the registers (some are used for resume from powersave) */
+		gx_save_regs(info, &gx_saved_regs);
 
-	/* Turn off the flat panel unless we are attached to a DCON */
-	if (!olpc_has_dcon())
-		writel(gx_saved_regs.fp.r.pm & ~GX_FP_PM_P, par->vid_regs + GX_FP_PM);
+		/* Shut down the engine */
+		writel(gx_saved_regs.vp.r.vcfg & ~0x01, par->vid_regs + GX_VCFG);
+		writel(gx_saved_regs.vp.r.dcfg & ~0x0F, par->vid_regs + GX_DCFG);
 
-	writel(0x4758, par->dc_regs + DC_UNLOCK);
+		/* Turn off the flat panel unless we are attached to a DCON */
+		if (!olpc_has_dcon())
+			writel(gx_saved_regs.fp.r.pm & ~GX_FP_PM_P, par->vid_regs + GX_FP_PM);
 
-	writel(gx_saved_regs.dc.r.gcfg & ~0x0F,
-	       par->dc_regs + DC_GENERAL_CFG);
+		writel(0x4758, par->dc_regs + DC_UNLOCK);
 
-	writel(gx_saved_regs.dc.r.dcfg & ~0x19,
-	       par->dc_regs + DC_DISPLAY_CFG);
-	
-	par->state = FB_POWER_STATE_SUSPEND;
+		writel(gx_saved_regs.dc.r.gcfg & ~0x0F,
+		par->dc_regs + DC_GENERAL_CFG);
 
-	return 0;
-}
-
-int gxfb_powerup(struct fb_info *info)
-{
-	struct geodefb_par *par = info->par;
-	u32 val;
+		writel(gx_saved_regs.dc.r.dcfg & ~0x19,
+		par->dc_regs + DC_DISPLAY_CFG);
+	}
 
-	if (par->state == FB_POWER_STATE_SUSPEND) {
+	/* Both powerup and restore from powersave */
+	if (state < FB_POWER_STATE_OFF && par->power_state >= FB_POWER_STATE_SUSPEND) {
+		u32 val;
 
 		writel(gx_saved_regs.dc.r.dcfg,
 		       par->dc_regs + DC_DISPLAY_CFG);
@@ -402,43 +395,36 @@ int gxfb_powerup(struct fb_info *info)
 			writel(gx_saved_regs.fp.r.pm, par->vid_regs + GX_FP_PM);
 			mdelay(64);
 		}
-	}
 
-	/* If the panel is currently on its way up, then wait up to 100ms
-	   for it */
-	
-	if (readl(par->vid_regs + GX_FP_PM) & 0x08) {
-		int i;
-		
-		for(i = 0; i < 10; i++) {
-			if (readl(par->vid_regs + GX_FP_PM) & 0x01)
-				break;
-
-			mdelay(10);
-		}
+		/* If the panel is currently on its way up, then wait up to 100ms for it */
+		if (readl(par->vid_regs + GX_FP_PM) & 0x08) {
+			int i;
+
+			for(i = 0; i < 10; i++) {
+				if (readl(par->vid_regs + GX_FP_PM) & 0x01)
+					break;
+
+				mdelay(10);
+			}
 
-		if (i == 10) 
-			printk(KERN_ERR "gxfb:  Panel power up timed out\n");
+			if (i == 10)
+				printk(KERN_ERR "gxfb:  Panel power up timed out\n");
+		}
 	}
 
-	if (par->state == FB_POWER_STATE_ON)
-		return 0;
-	
-	switch(par->state) {
-	case FB_POWER_STATE_OFF:
+	/* Powering up */
+	if (state < FB_POWER_STATE_OFF && par->power_state >= FB_POWER_STATE_OFF)
 		gx_restore_regs(info, &gx_saved_regs);
-		break;
 
-	case FB_POWER_STATE_SUSPEND:
+	if (state < FB_POWER_STATE_SUSPEND && par->power_state >= FB_POWER_STATE_SUSPEND) {
 		/* Do this because it will turn on the FIFO which will
-	   	   start the line count */
+		   start the line count */
 		writel(gx_saved_regs.dc.r.gcfg,
 		       par->dc_regs + DC_GENERAL_CFG);
 		writel(0x0, par->dc_regs + DC_UNLOCK);
-		break;
 	}
 
-	par->state = FB_POWER_STATE_ON;
+	par->power_state = state;
 	return 0;
 }
 
diff --git a/drivers/video/geode/video_gx.h b/drivers/video/geode/video_gx.h
index c57b36b..f9efaa7 100644
--- a/drivers/video/geode/video_gx.h
+++ b/drivers/video/geode/video_gx.h
@@ -81,8 +81,7 @@ extern struct geode_vid_ops gx_vid_ops;
 #  define MSR_GLCP_DOTPLL_BYPASS		(0x0000000000008000ull)
 #  define MSR_GLCP_DOTPLL_LOCK			(0x0000000002000000ull)
 
-int gxfb_powerdown(struct fb_info *info);
-int gxfb_powerup(struct fb_info *info);
+int gxfb_power(struct fb_info *info, int state);
 
 void gx_set_dclk_frequency(struct fb_info *info);
 unsigned int gx_get_dclk(struct fb_info *info);
diff --git a/drivers/video/olpc_dcon.c b/drivers/video/olpc_dcon.c
index 47ade47..bb421f0 100644
--- a/drivers/video/olpc_dcon.c
+++ b/drivers/video/olpc_dcon.c
@@ -210,13 +210,13 @@ static void dcon_source_switch(struct work_struct *work)
 
 		/*
 		 * Ideally we'd like to disable interrupts here so that the
-		 * fb_powerup and DCON turn on happen at a known time value;
+		 * fb_power() and DCON turn on happen at a known time value;
 		 * however, we can't do that right now with fb_set_suspend
 		 * messing with semaphores.
 		 *
 		 * For now, we just hope..
 		 */
-		if (fb_powerup(fbinfo)) {
+		if (fb_power(fbinfo, 0)) {
 			printk(KERN_ERR "olpc-dcon:  Failed to enter CPU mode\n");
 			dcon_pending = DCON_SOURCE_DCON;
 			return;
@@ -250,8 +250,8 @@ static void dcon_source_switch(struct work_struct *work)
 		if (!dcon_switched)
 			printk(KERN_ERR "olpc-dcon: Timeout entering DCON mode; expect a screen glitch.\n");
 
-		/* Turn off the graphics engine completely */
-		fb_powerdown(fbinfo);
+		/* Turn off the video engine only */
+		fb_power(fbinfo, 2);
 
 		printk(KERN_INFO "olpc-dcon: The DCON has control\n");
 		break;
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 5a82c83..0acbd27 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -661,11 +661,8 @@ struct fb_ops {
 	/* restore saved state */
 	void (*fb_restore_state)(struct fb_info *info);
 
-	/* Shut down the graphics engine to save power */
-	int (*fb_powerdown)(struct fb_info *info);
-
-	/* Power it back up */
-	int (*fb_powerup)(struct fb_info *info);
+	/* Change the power state of the graphics engine (0 = fully on, 3 = fully off */
+	int (*fb_power)(struct fb_info *info, int state);
 
 	/* get capability given var */
 	void (*fb_get_caps)(struct fb_info *info, struct fb_blit_caps *caps,
-- 
1.5.2.2

