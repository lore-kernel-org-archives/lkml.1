Return-Path: <linux-kernel-owner+w=401wt.eu-S933207AbZHDSQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207AbZHDSQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 14:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933193AbZHDSQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 14:16:47 -0400
Received: from mail.gmx.net ([213.165.64.20]:38523 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933031AbZHDSQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 14:16:46 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/pGYY9ELTpXXDZYxVKYLrJUVEpkvW7W6uH1e4u7j
	AUqjETstaYIe/0
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 1/2] viafb: merge viafb_update_viafb_par in viafb_update_fix
Date: Tue,  4 Aug 2009 18:18:28 +0000
Message-Id: <1249409909-3500-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: merge viafb_update_viafb_par in viafb_update_fix

Shrink and merge viafb_update_viafb_par. This removes a lot of
duplicated data in viafb_par. Use the relevant data of fb_info instead.
On the way it removes an inconsistency in handling a second framebuffer which
only worked because viafbinfo1->par is modified to point to the same viafb_par
as viafbinfo->par.
Code cleanup only, no runtime change expected.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 accel.c    |   13 +++++--------
 viafbdev.c |   44 ++++++++++----------------------------------
 viafbdev.h |    7 -------
 3 files changed, 15 insertions(+), 49 deletions(-)

diff --git a/drivers/video/via/accel.c b/drivers/video/via/accel.c
index 45c54bf..b3e7e82 100644
--- a/drivers/video/via/accel.c
+++ b/drivers/video/via/accel.c
@@ -34,7 +34,7 @@ void viafb_init_accel(void)
 
 void viafb_init_2d_engine(void)
 {
-	u32 dwVQStartAddr, dwVQEndAddr;
+	u32 dwVQStartAddr, dwVQEndAddr, linesize;
 	u32 dwVQLen, dwVQStartL, dwVQEndL, dwVQStartEndH;
 
 	/* init 2D engine regs to reset 2D engine */
@@ -191,17 +191,14 @@ void viafb_init_2d_engine(void)
 		}
 	}
 
-	viafb_set_2d_color_depth(viaparinfo->bpp);
+	viafb_set_2d_color_depth(viafbinfo->var.bits_per_pixel);
 
 	writel(0x0, viaparinfo->io_virt + VIA_REG_SRCBASE);
 	writel(0x0, viaparinfo->io_virt + VIA_REG_DSTBASE);
 
-	writel(VIA_PITCH_ENABLE |
-		   (((viaparinfo->hres *
-		      viaparinfo->bpp >> 3) >> 3) | (((viaparinfo->hres *
-						   viaparinfo->
-						   bpp >> 3) >> 3) << 16)),
-					viaparinfo->io_virt + VIA_REG_PITCH);
+	linesize = viafbinfo->var.xres * viafbinfo->var.bits_per_pixel >> 3;
+	writel(VIA_PITCH_ENABLE | (linesize >> 3) | ((linesize >> 3) << 16),
+		viaparinfo->io_virt + VIA_REG_PITCH);
 }
 
 void viafb_set_2d_color_depth(int bpp)
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 72833f3..6612ddc 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -100,21 +100,17 @@ static const struct viafb_modeinfo viafb_modentry[] = {
 
 static struct fb_ops viafb_ops;
 
-static int viafb_update_fix(struct fb_fix_screeninfo *fix, struct fb_info *info)
-{
-	struct viafb_par *ppar;
-	ppar = info->par;
-
-	DEBUG_MSG(KERN_INFO "viafb_update_fix!\n");
 
-	fix->visual =
-	    ppar->bpp == 8 ? FB_VISUAL_PSEUDOCOLOR : FB_VISUAL_TRUECOLOR;
-	fix->line_length = ppar->linelength;
+static void viafb_update_fix(struct fb_info *info)
+{
+	u32 bpp = info->var.bits_per_pixel;
 
-	return 0;
+	info->fix.visual =
+		bpp == 8 ? FB_VISUAL_PSEUDOCOLOR : FB_VISUAL_TRUECOLOR;
+	info->fix.line_length =
+		((info->var.xres_virtual + 7) & ~7) * bpp / 8;
 }
 
-
 static void viafb_setup_fixinfo(struct fb_fix_screeninfo *fix,
 	struct viafb_par *viaparinfo)
 {
@@ -147,19 +143,6 @@ static int viafb_release(struct fb_info *info, int user)
 	return 0;
 }
 
-static void viafb_update_viafb_par(struct fb_info *info)
-{
-	struct viafb_par *ppar;
-
-	ppar = info->par;
-	ppar->bpp = info->var.bits_per_pixel;
-	ppar->linelength = ((info->var.xres_virtual + 7) & ~7) * ppar->bpp / 8;
-	ppar->hres = info->var.xres;
-	ppar->vres = info->var.yres;
-	ppar->xoffset = info->var.xoffset;
-	ppar->yoffset = info->var.yoffset;
-}
-
 static int viafb_check_var(struct fb_var_screeninfo *var,
 	struct fb_info *info)
 {
@@ -255,12 +238,7 @@ static int viafb_set_par(struct fb_info *info)
 		/*We should set memory offset according virtual_x */
 		/*Fix me:put this function into viafb_setmode */
 		viafb_memory_pitch_patch(info);
-
-		/* Update ***fb_par information */
-		viafb_update_viafb_par(info);
-
-		/* Update other fixed information */
-		viafb_update_fix(&info->fix, info);
+		viafb_update_fix(info);
 		viafb_bpp = info->var.bits_per_pixel;
 		/* Update viafb_accel, it is necessary to our 2D accelerate */
 		viafb_accel = info->var.accel_flags;
@@ -2323,15 +2301,13 @@ static int __devinit via_pci_probe(void)
 		viafb_setup_fixinfo(&viafbinfo1->fix, viaparinfo1);
 		viafb_check_var(&default_var, viafbinfo1);
 		viafbinfo1->var = default_var;
-		viafb_update_viafb_par(viafbinfo);
-		viafb_update_fix(&viafbinfo1->fix, viafbinfo1);
+		viafb_update_fix(viafbinfo1);
 	}
 
 	viafb_setup_fixinfo(&viafbinfo->fix, viaparinfo);
 	viafb_check_var(&default_var, viafbinfo);
 	viafbinfo->var = default_var;
-	viafb_update_viafb_par(viafbinfo);
-	viafb_update_fix(&viafbinfo->fix, viafbinfo);
+	viafb_update_fix(viafbinfo);
 	default_var.activate = FB_ACTIVATE_NOW;
 	fb_alloc_cmap(&viafbinfo->cmap, 256, 0);
 
diff --git a/drivers/video/via/viafbdev.h b/drivers/video/via/viafbdev.h
index 227b000..ea0df4f 100644
--- a/drivers/video/via/viafbdev.h
+++ b/drivers/video/via/viafbdev.h
@@ -38,13 +38,6 @@
 #define VERSION_MINOR       4
 
 struct viafb_par {
-	int bpp;
-	int hres;
-	int vres;
-	int linelength;
-	u32 xoffset;
-	u32 yoffset;
-
 	void __iomem *fbmem_virt;	/*framebuffer virtual memory address */
 	void __iomem *io_virt;	/*iospace virtual memory address */
 	unsigned int fbmem;	/*framebuffer physical memory address */
-- 
1.6.3.2

