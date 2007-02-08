Return-Path: <linux-kernel-owner+w=401wt.eu-S1161511AbXBHBAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161511AbXBHBAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 20:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161512AbXBHBAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 20:00:16 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:49726 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161511AbXBHBAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 20:00:13 -0500
Message-id: <135662331710109923@wsc.cz>
Subject: [PATCH 1/2] Video: fb, add true ref_count atomicity
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <adaplas@pol.net>
Cc: <dok@directfb.org>
Cc: <ajoshi@shell.unixbox.com>
Cc: <pfaffben@debian.org>
Cc: <VANDROVE@vc.cvut.cz>
Date: Thu,  8 Feb 2007 02:00:12 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

video/fb, add true ref_count atomicity

Some of fb drivers uses atomic_t in bad manner, since there are still some
race-prone gaps. Use mutexes to protect open/close code sections with
ref_count testing and finally use simple uint.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit fd6de4a65b2d83db766a9ad3c137c44e361d6e0d
tree a4573d343d20988b931313c5fa35d9c370f36a05
parent e8d5617886087b5c8eee9df2c73381495672e23c
author Jiri Slaby <jirislaby@gmail.com> Thu, 08 Feb 2007 01:39:50 +0100
committer Jiri Slaby <jirislaby@gmail.com> Thu, 08 Feb 2007 01:39:50 +0100

 drivers/video/i810/i810.h      |    3 ++-
 drivers/video/i810/i810_main.c |   25 +++++++++++++++----------
 drivers/video/neofb.c          |   21 ++++++++++++++-------
 drivers/video/riva/fbdev.c     |   19 ++++++++++++-------
 drivers/video/riva/rivafb.h    |    3 ++-
 drivers/video/vga16fb.c        |   23 +++++++++++++++--------
 include/video/neomagic.h       |    3 ++-
 7 files changed, 62 insertions(+), 35 deletions(-)

diff --git a/drivers/video/i810/i810.h b/drivers/video/i810/i810.h
index 579195c..aa65ffc 100644
--- a/drivers/video/i810/i810.h
+++ b/drivers/video/i810/i810.h
@@ -264,7 +264,8 @@ struct i810fb_par {
 	struct heap_data         cursor_heap;
 	struct vgastate          state;
 	struct i810fb_i2c_chan   chan[3];
-	atomic_t                 use_count;
+	struct mutex		 open_lock;
+	unsigned int		 use_count;
 	u32 pseudo_palette[17];
 	unsigned long mmio_start_phys;
 	u8 __iomem *mmio_start_virtual;
diff --git a/drivers/video/i810/i810_main.c b/drivers/video/i810/i810_main.c
index b55a12d..e343c0d 100644
--- a/drivers/video/i810/i810_main.c
+++ b/drivers/video/i810/i810_main.c
@@ -1235,9 +1235,9 @@ static int i810fb_getcolreg(u8 regno, u8 *red, u8 *green, u8 *blue,
 static int i810fb_open(struct fb_info *info, int user)
 {
 	struct i810fb_par *par = info->par;
-	u32 count = atomic_read(&par->use_count);
-	
-	if (count == 0) {
+
+	mutex_lock(&par->open_lock);
+	if (par->use_count == 0) {
 		memset(&par->state, 0, sizeof(struct vgastate));
 		par->state.flags = VGA_SAVE_CMAP;
 		par->state.vgabase = par->mmio_start_virtual;
@@ -1246,7 +1246,8 @@ static int i810fb_open(struct fb_info *info, int user)
 		i810_save_vga_state(par);
 	}
 
-	atomic_inc(&par->use_count);
+	par->use_count++;
+	mutex_unlock(&par->open_lock);
 	
 	return 0;
 }
@@ -1254,18 +1255,20 @@ static int i810fb_open(struct fb_info *info, int user)
 static int i810fb_release(struct fb_info *info, int user)
 {
 	struct i810fb_par *par = info->par;
-	u32 count;
-	
-	count = atomic_read(&par->use_count);
-	if (count == 0)
+
+	mutex_lock(&par->open_lock);
+	if (par->use_count == 0) {
+		mutex_unlock(&par->open_lock);
 		return -EINVAL;
+	}
 
-	if (count == 1) {
+	if (par->use_count == 1) {
 		i810_restore_vga_state(par);
 		restore_vga(&par->state);
 	}
 
-	atomic_dec(&par->use_count);
+	par->use_count--;
+	mutex_unlock(&par->open_lock);
 	
 	return 0;
 }
@@ -1752,6 +1755,8 @@ static void __devinit i810_init_monspecs(struct fb_info *info)
 static void __devinit i810_init_defaults(struct i810fb_par *par, 
 				      struct fb_info *info)
 {
+	mutex_init(&par->open_lock);
+
 	if (voffset) 
 		v_offset_default = voffset;
 	else if (par->aperture.size > 32 * 1024 * 1024)
diff --git a/drivers/video/neofb.c b/drivers/video/neofb.c
index 459ca55..395cced 100644
--- a/drivers/video/neofb.c
+++ b/drivers/video/neofb.c
@@ -556,14 +556,16 @@ static int
 neofb_open(struct fb_info *info, int user)
 {
 	struct neofb_par *par = info->par;
-	int cnt = atomic_read(&par->ref_count);
 
-	if (!cnt) {
+	mutex_lock(&par->open_lock);
+	if (!par->ref_count) {
 		memset(&par->state, 0, sizeof(struct vgastate));
 		par->state.flags = VGA_SAVE_MODE | VGA_SAVE_FONTS;
 		save_vga(&par->state);
 	}
-	atomic_inc(&par->ref_count);
+	par->ref_count++;
+	mutex_unlock(&par->open_lock);
+
 	return 0;
 }
 
@@ -571,14 +573,18 @@ static int
 neofb_release(struct fb_info *info, int user)
 {
 	struct neofb_par *par = info->par;
-	int cnt = atomic_read(&par->ref_count);
 
-	if (!cnt)
+	mutex_lock(&par->open_lock);
+	if (!par->ref_count) {
+		mutex_unlock(&par->open_lock);
 		return -EINVAL;
-	if (cnt == 1) {
+	}
+	if (par->ref_count == 1) {
 		restore_vga(&par->state);
 	}
-	atomic_dec(&par->ref_count);
+	par->ref_count--;
+	mutex_unlock(&par->open_lock);
+
 	return 0;
 }
 
@@ -2047,6 +2053,7 @@ static struct fb_info *__devinit neo_alloc_fb_info(struct pci_dev *dev, const st
 
 	info->fix.accel = id->driver_data;
 
+	mutex_init(&par->open_lock);
 	par->pci_burst = !nopciburst;
 	par->lcd_stretch = !nostretch;
 	par->libretto = libretto;
diff --git a/drivers/video/riva/fbdev.c b/drivers/video/riva/fbdev.c
index 1a13966..7c19b5c 100644
--- a/drivers/video/riva/fbdev.c
+++ b/drivers/video/riva/fbdev.c
@@ -1101,10 +1101,10 @@ static int riva_get_cmap_len(const struct fb_var_screeninfo *var)
 static int rivafb_open(struct fb_info *info, int user)
 {
 	struct riva_par *par = info->par;
-	int cnt = atomic_read(&par->ref_count);
 
 	NVTRACE_ENTER();
-	if (!cnt) {
+	mutex_lock(&par->open_lock);
+	if (!par->ref_count) {
 #ifdef CONFIG_X86
 		memset(&par->state, 0, sizeof(struct vgastate));
 		par->state.flags = VGA_SAVE_MODE  | VGA_SAVE_FONTS;
@@ -1119,7 +1119,8 @@ static int rivafb_open(struct fb_info *info, int user)
 	
 		riva_save_state(par, &par->initial_state);
 	}
-	atomic_inc(&par->ref_count);
+	par->ref_count++;
+	mutex_unlock(&par->open_lock);
 	NVTRACE_LEAVE();
 	return 0;
 }
@@ -1127,12 +1128,14 @@ static int rivafb_open(struct fb_info *info, int user)
 static int rivafb_release(struct fb_info *info, int user)
 {
 	struct riva_par *par = info->par;
-	int cnt = atomic_read(&par->ref_count);
 
 	NVTRACE_ENTER();
-	if (!cnt)
+	mutex_lock(&par->open_lock);
+	if (!par->ref_count) {
+		mutex_unlock(&par->open_lock);
 		return -EINVAL;
-	if (cnt == 1) {
+	}
+	if (par->ref_count == 1) {
 		par->riva.LockUnlock(&par->riva, 0);
 		par->riva.LoadStateExt(&par->riva, &par->initial_state.ext);
 		riva_load_state(par, &par->initial_state);
@@ -1141,7 +1144,8 @@ static int rivafb_release(struct fb_info *info, int user)
 #endif
 		par->riva.LockUnlock(&par->riva, 1);
 	}
-	atomic_dec(&par->ref_count);
+	par->ref_count--;
+	mutex_unlock(&par->open_lock);
 	NVTRACE_LEAVE();
 	return 0;
 }
@@ -1999,6 +2003,7 @@ static int __devinit rivafb_probe(struct pci_dev *pd,
 		goto err_disable_device;
 	}
 
+	mutex_init(&default_par->open_lock);
 	default_par->riva.Architecture = riva_get_arch(pd);
 
 	default_par->Chipset = (pd->vendor << 16) | pd->device;
diff --git a/drivers/video/riva/rivafb.h b/drivers/video/riva/rivafb.h
index 7fa13fc..48ead6d 100644
--- a/drivers/video/riva/rivafb.h
+++ b/drivers/video/riva/rivafb.h
@@ -53,7 +53,8 @@ struct riva_par {
 #ifdef CONFIG_X86
 	struct vgastate state;
 #endif
-	atomic_t ref_count;
+	struct mutex open_lock;
+	unsigned int ref_count;
 	unsigned char *EDID;
 	unsigned int Chipset;
 	int forceCRTC;
diff --git a/drivers/video/vga16fb.c b/drivers/video/vga16fb.c
index 6aff63d..ec4c7dc 100644
--- a/drivers/video/vga16fb.c
+++ b/drivers/video/vga16fb.c
@@ -70,7 +70,8 @@ struct vga16fb_par {
 		unsigned char	ClockingMode;	  /* Seq-Controller:01h */
 	} vga_state;
 	struct vgastate state;
-	atomic_t ref_count;
+	struct mutex open_lock;
+	unsigned int ref_count;
 	int palette_blanked, vesa_blanked, mode, isVGA;
 	u8 misc, pel_msk, vss, clkdiv;
 	u8 crtc[VGA_CRT_C];
@@ -300,28 +301,33 @@ static void vga16fb_clock_chip(struct vga16fb_par *par,
 static int vga16fb_open(struct fb_info *info, int user)
 {
 	struct vga16fb_par *par = info->par;
-	int cnt = atomic_read(&par->ref_count);
 
-	if (!cnt) {
+	mutex_lock(&par->open_lock);
+	if (!par->ref_count) {
 		memset(&par->state, 0, sizeof(struct vgastate));
 		par->state.flags = VGA_SAVE_FONTS | VGA_SAVE_MODE |
 			VGA_SAVE_CMAP;
 		save_vga(&par->state);
 	}
-	atomic_inc(&par->ref_count);
+	par->ref_count++;
+	mutex_unlock(&par->open_lock);
+
 	return 0;
 }
 
 static int vga16fb_release(struct fb_info *info, int user)
 {
 	struct vga16fb_par *par = info->par;
-	int cnt = atomic_read(&par->ref_count);
 
-	if (!cnt)
+	mutex_lock(&par->open_lock);
+	if (!par->ref_count) {
+		mutex_unlock(&par->open_lock);
 		return -EINVAL;
-	if (cnt == 1)
+	}
+	if (par->ref_count == 1)
 		restore_vga(&par->state);
-	atomic_dec(&par->ref_count);
+	par->ref_count--;
+	mutex_unlock(&par->open_lock);
 
 	return 0;
 }
@@ -1357,6 +1363,7 @@ static int __init vga16fb_probe(struct platform_device *dev)
 	printk(KERN_INFO "vga16fb: mapped to 0x%p\n", info->screen_base);
 	par = info->par;
 
+	mutex_init(&par->open_lock);
 	par->isVGA = ORIG_VIDEO_ISVGA;
 	par->palette_blanked = 0;
 	par->vesa_blanked = 0;
diff --git a/include/video/neomagic.h b/include/video/neomagic.h
index 78b1f15..a9e118a 100644
--- a/include/video/neomagic.h
+++ b/include/video/neomagic.h
@@ -140,7 +140,8 @@ typedef volatile struct {
 
 struct neofb_par {
 	struct vgastate state;
-	atomic_t ref_count;
+	struct mutex open_lock;
+	unsigned int ref_count;
 
 	unsigned char MiscOutReg;	/* Misc */
 	unsigned char CRTC[25];		/* Crtc Controller */
