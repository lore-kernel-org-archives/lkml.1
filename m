Return-Path: <linux-kernel-owner+w=401wt.eu-S1764477AbYEGLMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764477AbYEGLMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 07:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508AbYEGLJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 07:09:57 -0400
Received: from mailtp.via.com.tw ([61.66.243.2]:1331 "EHLO mailtp.via.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758691AbYEGLJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 07:09:50 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: [Linux-fbdev-devel] [PATCH 7/9] viafb: VIA Frame Buffer Device Driver
Date: Wed, 7 May 2008 19:09:44 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F6775A@exchtp03.taipei.via.com.tw>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Linux-fbdev-devel] [PATCH 7/9] viafb: VIA Frame Buffer Device Driver
Thread-Index: AcivqWbF3qyu30s5RguMHG+BNihXBgAhNGrAAAA1T2AAABOmsAAAH3FwAAAG77A=
From: <JosephChan@via.com.tw>
To: <JosephChan@via.com.tw>, <akpm@linux-foundation.org>,
       <geert@linux-m68k.org>
Cc: <linux-fbdev-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 07 May 2008 11:09:46.0037 (UTC) FILETIME=[DBAB9E50:01C8B032]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m47BCqEB002155

Signed-off-by: Joseph Chan <josephchan@via.com.tw>

diff -Nur a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c	1969-12-31 19:00:00.000000000 -0500
+++ b/drivers/video/via/viafbdev.c	2008-05-04 07:30:05.000000000 -0400
@@ -0,0 +1,2768 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+
+ * This program is free software; you can redistribute it and/or modify
+ * it under  the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
+ * the implied warranty of MERCHANTABILITY or FITNESS FOR
+ * A PARTICULAR PURPOSE.See the GNU General Public License
+ * for more details.
+
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#ifdef MODULE
+#include <linux/module.h>
+#endif
+#define _MASTER_FILE
+
+#include "global.h"
+
+static int MAX_CURS = 32;
+static struct fb_var_screeninfo default_var;
+static char *viafb_name = "Via";
+static u32 pseudo_pal[17];
+
+/* video mode */
+static char *mode = "640x480";
+static char *mode1 = "640x480";
+static int resMode = VIA_RES_640X480;
+
+int video_on_crt;
+int video_on_dvi;
+int video_on_lcd;
+
+/* Added for specifying active devices.*/
+char *active_dev = "";
+
+/* Added for specifying video on devices.*/
+char *video_dev = "";
+
+/*Added for specify lcd output port*/
+char *lcd_port = "";
+char *dvi_port = "";
+
+/* Display Mode Information */
+int refresh1 = 60;
+static int timer_on;
+struct timer_list timer_for3D;
+
+static struct fb_ops viafb_ops;
+void init_global_var(void)
+{
+	second_virtual_yres = 0;
+	second_virtual_xres = 0;
+	second_offset = 0;
+	second_size = 0;
+	SAMM_ON = 0;
+	dual_fb = 0;
+	LCD2_ON = 0;
+	LCD_ON = 0;
+	DVI_ON = 0;
+	via_fb_accel = 0;
+	via_fb_hotplug = 0;
+	via_fb_memsize = 0;
+	video_on_crt = 0;
+	video_on_dvi = 0;
+	video_on_lcd = 0;
+	timer_on = 0;
+}
+
+void get_panel_max_scal_size(struct _panel_size_pos_info *p_max_size)
+{
+	switch (p_max_size->device_type) {
+	case DVI_Device:
+		p_max_size->x = p_max_size->y = 0;
+		break;
+	default:
+		p_max_size->x = p_max_size->y = 0;
+	}
+}
+void get_panel_max_scal_pos(struct _panel_size_pos_info *p_para)
+{
+	switch (p_para->device_type) {
+	case DVI_Device:
+		p_para->x = p_para->y = 0;
+		break;
+	default:
+		p_para->x = p_para->y = 0;
+	}
+}
+
+void get_panel_scal_pos(struct _panel_size_pos_info *p_para)
+{
+	switch (p_para->device_type) {
+	case DVI_Device:
+		p_para->x = p_para->y = 0;
+		break;
+	default:
+		p_para->x = p_para->y = 0;
+	}
+}
+void get_panel_scal_size(struct _panel_size_pos_info *p_para)
+{
+	switch (p_para->device_type) {
+	case DVI_Device:
+		p_para->x = p_para->y = 0;
+		break;
+	default:
+		p_para->x = p_para->y = 0;
+	}
+}
+
+void set_panel_scal_pos(struct _panel_size_pos_info *p_para)
+{
+	switch (p_para->device_type) {
+	case DVI_Device:
+		break;
+	default:
+		;
+	}
+}
+
+void set_panel_scal_size(struct _panel_size_pos_info *p_para)
+{
+	switch (p_para->device_type) {
+	case DVI_Device:
+		break;
+	default:
+		;
+	}
+}
+
+static int viafb_get_fix(struct fb_fix_screeninfo *fix, struct fb_info *info)
+{
+	struct viafb_par *ppar;
+	ppar = info->par;
+
+	DEBUG_MSG(KERN_INFO "viafb_get_fix!\n");
+
+	memset(fix, 0, sizeof(struct fb_fix_screeninfo));
+	strcpy(fix->id, viafb_name);
+
+	fix->smem_start = ppar->fbmem;
+	fix->smem_len = ppar->fbmem_free;
+
+	fix->type = FB_TYPE_PACKED_PIXELS;
+	fix->type_aux = 0;
+
+	fix->visual =
+	    ppar->bpp == 8 ? FB_VISUAL_PSEUDOCOLOR : FB_VISUAL_TRUECOLOR;
+
+	fix->xpanstep = fix->ywrapstep = 0;
+	fix->ypanstep = 1;
+	fix->line_length = ppar->linelength;
+
+	fix->mmio_start = ppar->mmio_base;
+	fix->mmio_len = ppar->mmio_len;
+
+	if (via_fb_accel)
+		fix->accel = FB_ACCEL_VIA_UNICHROME;
+	else
+		fix->accel = FB_ACCEL_NONE;
+
+	return 0;
+}
+
+static int viafb_open(struct fb_info *info, int user)
+{
+	DEBUG_MSG(KERN_INFO "viafb_open!\n");
+	return 0;
+}
+
+static int viafb_release(struct fb_info *info, int user)
+{
+	DEBUG_MSG(KERN_INFO "viafb_release!\n");
+	return 0;
+}
+
+static int viafb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
+{
+	int vres, vfront, vback, vsync;
+	int vmode_index;
+	struct viafb_par *ppar;
+	ppar = info->par;
+
+	DEBUG_MSG(KERN_INFO "viafb_check_var!\n");
+	vmode_index = get_mode_index(var->xres, var->yres, 0);
+	if (vmode_index == VIA_RES_INVALID) {
+		DEBUG_MSG(KERN_INFO
+			  "viafb: Mode %dx%dx%d not supported!!\n",
+			  var->xres, var->yres, var->bits_per_pixel);
+		return -EINVAL;
+	}
+	/* convert from picoseconds to MHz */
+	refresh = get_refresh(var->xres, var->yres, var->pixclock);
+	if (24 == var->bits_per_pixel)
+		var->bits_per_pixel = 32;
+	if ((var->xres_virtual * (var->bits_per_pixel >> 3)) & 0x1F)
+		/*32 pixel alignment */
+		var->xres_virtual = (var->xres_virtual + 31) & ~31;
+
+	/*Fill var's time information according our table,
+	   or fbset will show wrong information */
+	fill_var_timing_info(var, refresh, vmode_index);
+
+	ppar->var = *var;
+	ppar->bpp = var->bits_per_pixel;
+
+	if (ppar->bpp == 24)
+		ppar->bpp = 32;
+
+	/*It seems that it is not possible, because it is 32 byte align now */
+	ppar->linelength = ((var->xres_virtual + 7) & ~7) * ppar->bpp / 8;
+
+	switch (ppar->bpp) {
+	case 8:
+		ppar->var.red.offset = 0;
+		ppar->var.green.offset = 0;
+		ppar->var.blue.offset = 0;
+		ppar->var.red.length = 6;
+		ppar->var.green.length = 6;
+		ppar->var.blue.length = 6;
+		break;
+	case 16:
+		ppar->var.red.offset = 11;
+		ppar->var.green.offset = 5;
+		ppar->var.blue.offset = 0;
+		ppar->var.red.length = 5;
+		ppar->var.green.length = 6;
+		ppar->var.blue.length = 5;
+		break;
+	case 32:
+		ppar->var.red.offset = 16;
+		ppar->var.green.offset = 8;
+		ppar->var.blue.offset = 0;
+		ppar->var.red.length = 8;
+		ppar->var.green.length = 8;
+		ppar->var.blue.length = 8;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ppar->vclk = 1000000 / var->pixclock;
+
+	if (ppar->bpp == 32)
+		ppar->vclk *= 2;
+
+	ppar->hres = var->xres;
+	vres = ppar->vres = var->yres;
+
+	/* See if requested resolution fits in available memory */
+	if (ppar->hres * ppar->vres * ppar->bpp / 8 > ppar->memsize)
+		return -EINVAL;
+
+	vfront = var->upper_margin;
+	vback = var->lower_margin;
+	vsync = var->vsync_len;
+
+	/* Compute horizontal and vertical VGA CRTC timing values */
+	if (var->vmode & FB_VMODE_INTERLACED) {
+		vres /= 2;
+		vfront /= 2;
+		vback /= 2;
+		vsync /= 2;
+	}
+
+	if (var->vmode & FB_VMODE_DOUBLE) {
+		vres *= 2;
+		vfront *= 2;
+		vback *= 2;
+		vsync *= 2;
+	}
+
+	ppar->htotal =
+	    (ppar->hres + var->left_margin + var->right_margin +
+	     var->hsync_len) / 8 - 10;
+	ppar->hdispend = ppar->hres / 8 - 1;
+	ppar->hsyncstart = (ppar->hres + var->right_margin) / 8;
+	ppar->hsyncend = var->hsync_len / 8;
+	ppar->hblankstart = ppar->hdispend + 1;
+	ppar->hblankend = ppar->htotal + 5;
+
+	ppar->vtotal = vres + vfront + vback + vsync - 2;
+	ppar->vdispend = vres - 1;
+	ppar->vsyncstart = vres + vback;
+	ppar->vsyncend = vsync;
+	ppar->vblankstart = vres;
+	ppar->vblankend = ppar->vtotal + 2;
+	info->var = ppar->var;
+	return 0;
+}
+
+static int viafb_set_par(struct fb_info *info)
+{
+	int vmode_index;
+	int vmode_index1 = 0;
+	DEBUG_MSG(KERN_INFO "viafb_set_par!\n");
+
+	refresh =
+	    get_refresh(info->var.xres, info->var.yres, info->var.pixclock);
+
+	update_device_setting(info->var.xres, info->var.yres,
+			      info->var.bits_per_pixel, refresh, 0);
+
+	vmode_index = get_mode_index(info->var.xres, info->var.yres, 0);
+
+	if (SAMM_ON == 1) {
+		DEBUG_MSG(KERN_INFO
+			  "second_xres=%d, second_yres=%d, bpp=%d\n",
+			  second_xres, second_yres, via_fb_bpp1);
+		vmode_index1 = get_mode_index(second_xres, second_yres, 1);
+		DEBUG_MSG(KERN_INFO "->SAMM_ON: index=%d\n", vmode_index1);
+
+		update_device_setting(second_xres, second_yres, via_fb_bpp1,
+				      refresh1, 1);
+	}
+
+	if (vmode_index != VIA_RES_INVALID) {
+		setmode(vmode_index, info->var.xres, info->var.yres,
+			info->var.bits_per_pixel, vmode_index1,
+			second_xres, second_yres, via_fb_bpp1);
+
+		/*We should set memory offset according virtual_x */
+		/*Fix me:put this function into setmode */
+		memory_pitch_patch(info);
+
+		viafb_check_var(&info->var, info);
+		viafb_get_fix(&info->fix, info);
+
+		via_fb_bpp = info->var.bits_per_pixel;
+
+		if (via_fb_accel)
+			set_2d_color_depth(info->var.bits_per_pixel);
+	}
+
+	return 0;
+}
+
+static int viafb_get_cmap_len(struct fb_var_screeninfo *var)
+{
+	DEBUG_MSG(KERN_INFO "viafb_get_cmap_len!\n");
+
+	return (var->bits_per_pixel == 8) ? 256 : 16;
+}
+
+/* Set one color register */
+static int viafb_setcolreg(unsigned regno, unsigned red, unsigned green,
+			   unsigned blue, unsigned transp, struct fb_info *info)
+{
+	u8 sr1a, sr1b, cr67, cr6a, rev = 0, shift = 10;
+	DEBUG_MSG(KERN_INFO "viafb_setcolreg!\n");
+	if (regno >= viafb_get_cmap_len(&info->var))
+		return 1;
+	if (UNICHROME_CLE266 == chip_info.gfx_chip_name) {
+	/* Read PCI bus 0,dev 0,function 0,index 0xF6 to get chip rev. */
+		outl(0x80000000 | (0xf6 & ~3), (unsigned long)0xCF8);
+		rev = (inl((unsigned long)0xCFC) >> ((0xf6 & 3) * 8)) & 0xff;
+	}
+	switch (info->var.bits_per_pixel) {
+	case 8:
+		outb(0x1A, 0x3C4);
+		sr1a = inb(0x3C5);
+		outb(0x1B, 0x3C4);
+		sr1b = inb(0x3C5);
+		outb(0x67, 0x3D4);
+		cr67 = inb(0x3D5);
+		outb(0x6A, 0x3D4);
+		cr6a = inb(0x3D5);
+
+		/* Map the 3C6/7/8/9 to the IGA2 */
+		outb(0x1A, 0x3C4);
+		outb(sr1a | 0x01, 0x3C5);
+		/* Second Display Engine colck always on */
+		outb(0x1B, 0x3C4);
+		outb(sr1b | 0x80, 0x3C5);
+		/* Second Display Color Depth 8 */
+		outb(0x67, 0x3D4);
+		outb(cr67 & 0x3F, 0x3D5);
+		outb(0x6A, 0x3D4);
+		/* Second Display Channel Reset CR6A[6]) */
+		outb(cr6a & 0xBF, 0x3D5);
+		/* Second Display Channel Enable CR6A[7] */
+		outb(cr6a | 0x80, 0x3D5);
+		/* Second Display Channel stop reset) */
+		outb(cr6a | 0x40, 0x3D5);
+
+		/* Bit mask of palette */
+		outb(0xFF, 0x3c6);
+		/* Write one register of IGA2 */
+		outb(regno, 0x3C8);
+		if (UNICHROME_CLE266 == chip_info.gfx_chip_name && rev >= 15) {
+			shift = 8;
+			write_reg_mask(CR6A, VIACR, BIT5, BIT5);
+			write_reg_mask(SR15, VIASR, BIT7, BIT7);
+		} else {
+			shift = 10;
+			write_reg_mask(CR6A, VIACR, 0, BIT5);
+			write_reg_mask(SR15, VIASR, 0, BIT7);
+		}
+		outb(red >> shift, 0x3C9);
+		outb(green >> shift, 0x3C9);
+		outb(blue >> shift, 0x3C9);
+
+		/* Map the 3C6/7/8/9 to the IGA1 */
+		outb(0x1A, 0x3C4);
+		outb(sr1a & 0xFE, 0x3C5);
+		/* Bit mask of palette */
+		outb(0xFF, 0x3c6);
+		/* Write one register of IGA1 */
+		outb(regno, 0x3C8);
+		outb(red >> shift, 0x3C9);
+		outb(green >> shift, 0x3C9);
+		outb(blue >> shift, 0x3C9);
+
+		outb(0x1A, 0x3C4);
+		outb(sr1a, 0x3C5);
+		outb(0x1B, 0x3C4);
+		outb(sr1b, 0x3C5);
+		outb(0x67, 0x3D4);
+		outb(cr67, 0x3D5);
+		outb(0x6A, 0x3D4);
+		outb(cr6a, 0x3D5);
+		break;
+	case 16:
+		((u32 *) info->pseudo_palette)[regno] = (red & 0xF800) |
+		    ((green & 0xFC00) >> 5) | ((blue & 0xF800) >> 11);
+		break;
+	case 32:
+		((u32 *) info->pseudo_palette)[regno] =
+		    ((transp & 0xFF00) << 16) |
+		    ((red & 0xFF00) << 8) |
+		    ((green & 0xFF00)) | ((blue & 0xFF00) >> 8);
+		break;
+	}
+
+	return 0;
+
+}
+
+/*CALLED BY: fb_set_cmap */
+/*           fb_set_var, pass 256 colors */
+/*CALLED BY: fb_set_cmap */
+/*           fbcon_set_palette, pass 16 colors */
+static int viafb_setcmap(struct fb_cmap *cmap, struct fb_info *info)
+{
+	u32 len = cmap->len;
+	u32 i;
+	u16 *pred = cmap->red;
+	u16 *pgreen = cmap->green;
+	u16 *pblue = cmap->blue;
+	u16 *ptransp = cmap->transp;
+	u8 sr1a, sr1b, cr67, cr6a, rev = 0, shift = 10;
+	if (len > 256)
+		return 1;
+	if (UNICHROME_CLE266 == chip_info.gfx_chip_name) {
+	/* Read PCI bus 0, dev 0, function 0, index 0xF6 to get chip rev. */
+		outl(0x80000000 | (0xf6 & ~3), (unsigned long)0xCF8);
+		rev = (inl((unsigned long)0xCFC) >> ((0xf6 & 3) * 8)) & 0xff;
+	}
+	switch (info->var.bits_per_pixel) {
+	case 8:
+		outb(0x1A, 0x3C4);
+		sr1a = inb(0x3C5);
+		outb(0x1B, 0x3C4);
+		sr1b = inb(0x3C5);
+		outb(0x67, 0x3D4);
+		cr67 = inb(0x3D5);
+		outb(0x6A, 0x3D4);
+		cr6a = inb(0x3D5);
+		/* Map the 3C6/7/8/9 to the IGA2 */
+		outb(0x1A, 0x3C4);
+		outb(sr1a | 0x01, 0x3C5);
+		outb(0x1B, 0x3C4);
+		/* Second Display Engine colck always on */
+		outb(sr1b | 0x80, 0x3C5);
+		outb(0x67, 0x3D4);
+		/* Second Display Color Depth 8 */
+		outb(cr67 & 0x3F, 0x3D5);
+		outb(0x6A, 0x3D4);
+		/* Second Display Channel Reset CR6A[6]) */
+		outb(cr6a & 0xBF, 0x3D5);
+		/* Second Display Channel Enable CR6A[7] */
+		outb(cr6a | 0x80, 0x3D5);
+		/* Second Display Channel stop reset) */
+		outb(cr6a | 0xC0, 0x3D5);
+
+		/* Bit mask of palette */
+		outb(0xFF, 0x3c6);
+		outb(0x00, 0x3C8);
+		if (UNICHROME_CLE266 == chip_info.gfx_chip_name && rev >= 15) {
+			shift = 8;
+			write_reg_mask(CR6A, VIACR, BIT5, BIT5);
+			write_reg_mask(SR15, VIASR, BIT7, BIT7);
+		} else {
+			shift = 10;
+			write_reg_mask(CR6A, VIACR, 0, BIT5);
+			write_reg_mask(SR15, VIASR, 0, BIT7);
+		}
+		for (i = 0; i < len; i++) {
+			outb((*(pred + i)) >> shift, 0x3C9);
+			outb((*(pgreen + i)) >> shift, 0x3C9);
+			outb((*(pblue + i)) >> shift, 0x3C9);
+		}
+
+		outb(0x1A, 0x3C4);
+		/* Map the 3C6/7/8/9 to the IGA1 */
+		outb(sr1a & 0xFE, 0x3C5);
+		/* Bit mask of palette */
+		outb(0xFF, 0x3c6);
+		outb(0x00, 0x3C8);
+		for (i = 0; i < len; i++) {
+			outb((*(pred + i)) >> shift, 0x3C9);
+			outb((*(pgreen + i)) >> shift, 0x3C9);
+			outb((*(pblue + i)) >> shift, 0x3C9);
+		}
+
+		outb(0x1A, 0x3C4);
+		outb(sr1a, 0x3C5);
+		outb(0x1B, 0x3C4);
+		outb(sr1b, 0x3C5);
+		outb(0x67, 0x3D4);
+		outb(cr67, 0x3D5);
+		outb(0x6A, 0x3D4);
+		outb(cr6a, 0x3D5);
+		break;
+	case 16:
+		if (len > 17)
+			return 0;	/* Because static u32 pseudo_pal[17]; */
+		for (i = 0; i < len; i++)
+			((u32 *) info->pseudo_palette)[i] =
+			    (*(pred + i) & 0xF800) |
+			    ((*(pgreen + i) & 0xFC00) >> 5) |
+			    ((*(pblue + i) & 0xF800) >> 11);
+		break;
+	case 32:
+		if (len > 17)
+			return 0;
+		if (ptransp) {
+			for (i = 0; i < len; i++)
+				((u32 *) info->pseudo_palette)[i] =
+				    ((*(ptransp + i) & 0xFF00) << 16) |
+				    ((*(pred + i) & 0xFF00) << 8) |
+				    ((*(pgreen + i) & 0xFF00)) |
+				    ((*(pblue + i) & 0xFF00) >> 8);
+		} else {
+			for (i = 0; i < len; i++)
+				((u32 *) info->pseudo_palette)[i] =
+				    0x00000000 |
+				    ((*(pred + i) & 0xFF00) << 8) |
+				    ((*(pgreen + i) & 0xFF00)) |
+				    ((*(pblue + i) & 0xFF00) >> 8);
+		}
+		break;
+	}
+	return 0;
+}
+
+static int viafb_pan_display(struct fb_var_screeninfo *var,
+			     struct fb_info *info)
+{
+	unsigned int offset = 0;
+
+	DEBUG_MSG(KERN_INFO "viafb_pan_display!\n");
+
+	offset = (var->xoffset + (var->yoffset * var->xres)) *
+	    var->bits_per_pixel / 16;
+
+	DEBUG_MSG(KERN_INFO "\nviafb_pan_display,offset =%d ", offset);
+
+	write_reg_mask(0x48, 0x3d4, ((offset >> 24) & 0x3), 0x3);
+	write_reg_mask(0x34, 0x3d4, ((offset >> 16) & 0xff), 0xff);
+	write_reg_mask(0x0c, 0x3d4, ((offset >> 8) & 0xff), 0xff);
+	write_reg_mask(0x0d, 0x3d4, (offset & 0xff), 0xff);
+
+	((struct viafb_par *)(info->par))->var.xoffset = var->xoffset;
+	((struct viafb_par *)(info->par))->var.yoffset = var->yoffset;
+	return 0;
+}
+
+static int viafb_blank(int blank_mode, struct fb_info *info)
+{
+	DEBUG_MSG(KERN_INFO "viafb_blank!\n");
+	/* clear DPMS setting */
+
+	switch (blank_mode) {
+	case FB_BLANK_UNBLANK:
+		/* Screen: On, HSync: On, VSync: On */
+		/* control CRT monitor power management */
+		write_reg_mask(CR36, VIACR, 0x00, BIT4 + BIT5);
+		break;
+	case FB_BLANK_HSYNC_SUSPEND:
+		/* Screen: Off, HSync: Off, VSync: On */
+		/* control CRT monitor power management */
+		write_reg_mask(CR36, VIACR, 0x10, BIT4 + BIT5);
+		break;
+	case FB_BLANK_VSYNC_SUSPEND:
+		/* Screen: Off, HSync: On, VSync: Off */
+		/* control CRT monitor power management */
+		write_reg_mask(CR36, VIACR, 0x20, BIT4 + BIT5);
+		break;
+	case FB_BLANK_POWERDOWN:
+		/* Screen: Off, HSync: Off, VSync: Off */
+		/* control CRT monitor power management */
+		write_reg_mask(CR36, VIACR, 0x30, BIT4 + BIT5);
+		break;
+	}
+
+	return 0;
+}
+
+static int viafb_ioctl(struct fb_info *info, u_int cmd, u_long arg)
+{
+	struct viafb_ioctl_info viainfo;
+	struct viafb_ioctl_mode viamode;
+	struct viafb_ioctl_samm viasamm;
+	struct viafb_driver_version driver_version;
+	struct fb_var_screeninfo sec_var;
+	struct _panel_size_pos_info panel_pos_size_para;
+	u32 state_info = 0;
+	u32 viafb_gamma_table[256];
+	char driver_name[10] = "viafb\0";
+
+	u32 __user *argp = (u32 __user *) arg;
+	u32 gpu32 = 0, ss;
+	u32 video_dev_info = 0;
+	struct viafb_ioctl_setting viafb_setting;
+	struct device_t active_dev;
+	ss = sizeof(active_dev);
+	memset(&active_dev, 0, ss);
+	memset(&viafb_setting, 0, sizeof(viafb_setting));
+
+	DEBUG_MSG(KERN_INFO "viafb_ioctl: 0x%X !!\n", cmd);
+
+	switch (cmd) {
+	case VIAFB_GET_CHIP_INFO:	/*struct chip_information chip_info ; */
+	if (copy_to_user((void __user *)arg, &chip_info, sizeof(chip_info)))
+		return -EFAULT;
+		break;
+	case VIAFB_GET_INFO_SIZE:
+		return put_user(sizeof(viainfo), argp);
+	case VIAFB_GET_INFO:
+		return ioctl_get_viafb_info(arg);
+	case VIAFB_HOTPLUG:
+		return put_user((u32)
+				ioctl_hotplug(info->var.xres,
+					      info->var.yres,
+					      info->var.bits_per_pixel), argp);
+		break;
+	case VIAFB_SET_HOTPLUG_FLAG:
+		if (copy_from_user(&gpu32, argp, sizeof(gpu32)))
+			return -EFAULT;
+		via_fb_hotplug = (gpu32) ? 1 : 0;
+		break;
+	case VIAFB_GET_RESOLUTION:
+		viamode.xres = (u32) via_fb_hotplug_Xres;
+		viamode.yres = (u32) via_fb_hotplug_Yres;
+		viamode.refresh = (u32) via_fb_hotplug_refresh;
+		viamode.bpp = (u32) via_fb_hotplug_bpp;
+		if (SAMM_ON == 1) {
+			viamode.xres_sec = second_xres;
+			viamode.yres_sec = second_yres;
+			viamode.virtual_xres_sec = second_virtual_xres;
+			viamode.virtual_yres_sec = second_virtual_yres;
+			viamode.refresh_sec = refresh1;
+			viamode.bpp_sec = via_fb_bpp1;
+		} else {
+			viamode.xres_sec = 0;
+			viamode.yres_sec = 0;
+			viamode.virtual_xres_sec = 0;
+			viamode.virtual_yres_sec = 0;
+			viamode.refresh_sec = 0;
+			viamode.bpp_sec = 0;
+		}
+		if (copy_to_user((void __user *)arg, &viamode, sizeof(viamode)))
+			return -EFAULT;
+		break;
+	case VIAFB_GET_SAMM_INFO:
+		viasamm.samm_status = SAMM_ON;
+
+		if (SAMM_ON == 1) {
+			if (dual_fb) {
+				viasamm.size_prim = parinfo.fbmem_free;
+				viasamm.size_sec = parinfo1.fbmem_free;
+			} else {
+				if (second_size) {
+					viasamm.size_prim =
+					    parinfo.fbmem_free -
+					    second_size * 1024 * 1024;
+					viasamm.size_sec =
+					    second_size * 1024 * 1024;
+				} else {
+					viasamm.size_prim =
+					    parinfo.fbmem_free >> 1;
+					viasamm.size_sec =
+					    (parinfo.fbmem_free >> 1);
+				}
+			}
+			viasamm.mem_base = parinfo.fbmem;
+			viasamm.offset_sec = second_offset;
+		} else {
+			viasamm.size_prim =
+			    parinfo.memsize - parinfo.fbmem_used;
+			viasamm.size_sec = 0;
+			viasamm.mem_base = parinfo.fbmem;
+			viasamm.offset_sec = 0;
+		}
+
+		if (copy_to_user((void __user *)arg, &viasamm, sizeof(viasamm)))
+			return -EFAULT;
+
+		break;
+	case VIAFB_TURN_ON_OUTPUT_DEVICE:
+		if (copy_from_user(&gpu32, argp, sizeof(gpu32)))
+			return -EFAULT;
+		if (gpu32 & CRT_Device)
+			crt_enable();
+		if (gpu32 & DVI_Device)
+			dvi_enable();
+		if (gpu32 & LCD_Device)
+			lcd_enable();
+		break;
+	case VIAFB_TURN_OFF_OUTPUT_DEVICE:
+		if (copy_from_user(&gpu32, argp, sizeof(gpu32)))
+			return -EFAULT;
+		if (gpu32 & CRT_Device)
+			crt_disable();
+		if (gpu32 & DVI_Device)
+			dvi_disable();
+		if (gpu32 & LCD_Device)
+			lcd_disable();
+		break;
+	case VIAFB_SET_DEVICE:
+		if (copy_from_user(&active_dev, (void *)argp, ss))
+			return -EFAULT;
+		viafb_set_device(active_dev);
+		viafb_set_par(info);
+		break;
+	case VIAFB_GET_DEVICE:
+		active_dev.crt = CRT_ON;
+		active_dev.dvi = DVI_ON;
+		active_dev.lcd = LCD_ON;
+		active_dev.samm = SAMM_ON;
+		active_dev.primary_dev = primary_dev;
+
+		active_dev.lcd_dsp_cent = lcd_dsp_method;
+		active_dev.lcd_panel_id = lcd_panel_id;
+		active_dev.lcd_mode = lcd_mode;
+
+		active_dev.xres = via_fb_hotplug_Xres;
+		active_dev.yres = via_fb_hotplug_Yres;
+
+		active_dev.xres1 = second_xres;
+		active_dev.yres1 = second_yres;
+
+		active_dev.bpp = via_fb_bpp;
+		active_dev.bpp1 = via_fb_bpp1;
+		active_dev.refresh = refresh;
+		active_dev.refresh1 = refresh1;
+
+		active_dev.epia_dvi = platform_epia_dvi;
+		active_dev.lcd_dual_edge = device_lcd_dualedge;
+		active_dev.bus_width = via_bus_width;
+
+		if (copy_to_user((void __user *)arg, &active_dev, ss))
+			return -EFAULT;
+		break;
+
+	case VIAFB_GET_DRIVER_VERSION:
+		driver_version.iMajorNum = VERSION_MAJOR;
+		driver_version.iKernelNum = VERSION_KERNEL;
+		driver_version.iOSNum = VERSION_OS;
+		driver_version.iMinorNum = VERSION_MINOR;
+
+		if (copy_to_user
+		    ((void __user *)arg, &driver_version,
+		     sizeof(driver_version)))
+			return -EFAULT;
+
+		break;
+
+	case VIAFB_SET_DEVICE_INFO:
+		if (copy_from_user
+		    (&viafb_setting, (void *)argp, sizeof(viafb_setting)))
+			return -EFAULT;
+		if (apply_device_setting(viafb_setting, info) < 0)
+			return -EINVAL;
+
+		break;
+
+	case VIAFB_SET_SECOND_MODE:
+		if (copy_from_user(&sec_var, (void *)argp, sizeof(sec_var)))
+			return -EFAULT;
+		apply_second_mode_setting(&sec_var);
+		break;
+
+	case VIAFB_GET_DEVICE_INFO:
+
+		retrieve_device_setting(&viafb_setting);
+
+		if (copy_to_user
+		    ((void __user *)arg, &viafb_setting,
+		     sizeof(viafb_setting)))
+			return -EFAULT;
+
+		break;
+
+	case VIAFB_GET_DEVICE_SUPPORT:
+		get_device_support_state(&state_info);
+		if (put_user(state_info, argp))
+			return -EFAULT;
+		break;
+
+	case VIAFB_GET_DEVICE_CONNECT:
+		get_device_connect_state(&state_info);
+		if (put_user(state_info, argp))
+			return -EFAULT;
+		break;
+
+	case VIAFB_GET_PANEL_SUPPORT_EXPAND:
+		state_info =
+		    lcd_get_support_expand_state(info->var.xres,
+						 info->var.yres);
+		if (put_user(state_info, argp))
+			return -EFAULT;
+		break;
+
+	case VIAFB_GET_DRIVER_NAME:
+		if (copy_to_user
+		    ((void __user *)arg, driver_name, sizeof(driver_name)))
+			return -EFAULT;
+		break;
+
+	case VIAFB_SET_GAMMA_LUT:
+		if (copy_from_user
+		    (viafb_gamma_table, argp, sizeof(viafb_gamma_table)))
+			return -EFAULT;
+		set_gamma_table(via_fb_bpp, viafb_gamma_table);
+		break;
+
+	case VIAFB_GET_GAMMA_LUT:
+		get_gamma_table(viafb_gamma_table);
+		if (copy_to_user
+		    ((void __user *)arg, viafb_gamma_table,
+		     sizeof(viafb_gamma_table)))
+			return -EFAULT;
+		break;
+
+	case VIAFB_GET_GAMMA_SUPPORT_STATE:
+		get_gamma_support_state(via_fb_bpp, &state_info);
+		if (put_user(state_info, argp))
+			return -EFAULT;
+		break;
+	case VIAFB_SET_VIDEO_DEVICE:
+		get_user(video_dev_info, argp);
+		viafb_set_video_device(video_dev_info);
+		break;
+	case VIAFB_GET_VIDEO_DEVICE:
+		viafb_get_video_device(&video_dev_info);
+		if (put_user(video_dev_info, argp))
+			return -EFAULT;
+		break;
+	case VIAFB_SYNC_SURFACE:
+		DEBUG_MSG(KERN_INFO "lobo VIAFB_SYNC_SURFACE\n");
+		break;
+	case VIAFB_GET_DRIVER_CAPS:
+		break;
+
+	case VIAFB_GET_PANEL_MAX_SIZE:
+		if (copy_from_user
+		    (&panel_pos_size_para, argp, sizeof(panel_pos_size_para)))
+			return -EFAULT;
+		get_panel_max_scal_size(&panel_pos_size_para);
+		if (copy_to_user
+		    ((void __user *)arg, &panel_pos_size_para,
+		     sizeof(panel_pos_size_para)))
+			return -EFAULT;
+		break;
+	case VIAFB_GET_PANEL_MAX_POSITION:
+		if (copy_from_user
+		    (&panel_pos_size_para, argp, sizeof(panel_pos_size_para)))
+			return -EFAULT;
+		get_panel_max_scal_pos(&panel_pos_size_para);
+		if (copy_to_user
+		    ((void __user *)arg, &panel_pos_size_para,
+		     sizeof(panel_pos_size_para)))
+			return -EFAULT;
+		break;
+
+	case VIAFB_GET_PANEL_POSITION:
+		if (copy_from_user
+		    (&panel_pos_size_para, argp, sizeof(panel_pos_size_para)))
+			return -EFAULT;
+		get_panel_scal_pos(&panel_pos_size_para);
+		if (copy_to_user
+		    ((void __user *)arg, &panel_pos_size_para,
+		     sizeof(panel_pos_size_para)))
+			return -EFAULT;
+		break;
+	case VIAFB_GET_PANEL_SIZE:
+		if (copy_from_user
+		    (&panel_pos_size_para, argp, sizeof(panel_pos_size_para)))
+			return -EFAULT;
+		get_panel_scal_size(&panel_pos_size_para);
+		if (copy_to_user
+		    ((void __user *)arg, &panel_pos_size_para,
+		     sizeof(panel_pos_size_para)))
+			return -EFAULT;
+		break;
+
+	case VIAFB_SET_PANEL_POSITION:
+		if (copy_from_user
+		    (&panel_pos_size_para, argp, sizeof(panel_pos_size_para)))
+			return -EFAULT;
+		set_panel_scal_pos(&panel_pos_size_para);
+		break;
+	case VIAFB_SET_PANEL_SIZE:
+		if (copy_from_user
+		    (&panel_pos_size_para, argp, sizeof(panel_pos_size_para)))
+			return -EFAULT;
+		set_panel_scal_size(&panel_pos_size_para);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void viafb_fillrect(struct fb_info *info, const struct fb_fillrect *rect)
+{
+	u32 col = 0, rop = 0;
+	int pitch;
+
+	if (!via_fb_accel)
+		return cfb_fillrect(info, rect);
+
+	if (!rect->width || !rect->height)
+		return;
+
+	switch (rect->rop) {
+	case ROP_XOR:
+		rop = 0x5A;
+		break;
+	case ROP_COPY:
+	default:
+		rop = 0xF0;
+		break;
+	}
+
+	switch (info->var.bits_per_pixel) {
+	case 8:
+		col = rect->color;
+		break;
+	case 16:
+		col = ((u32 *) (info->pseudo_palette))[rect->color];
+		break;
+	case 32:
+		col = ((u32 *) (info->pseudo_palette))[rect->color];
+		break;
+	}
+
+	/* BitBlt Source Address */
+	MMIO_OUT32(VIA_REG_SRCPOS, 0x0);
+	/* Source Base Address */
+	MMIO_OUT32(VIA_REG_SRCBASE, 0x0);
+	/* Destination Base Address */
+	/*MMIO_OUT32(VIA_REG_DSTBASE, 0x0); */
+	MMIO_OUT32(VIA_REG_DSTBASE,
+		   ((u32) (info->screen_base) - (u32) FB_MM) >> 3);
+	/* Pitch */
+	pitch = (info->var.xres_virtual + 7) & ~7;
+	MMIO_OUT32(VIA_REG_PITCH,
+		   VIA_PITCH_ENABLE |
+		   (((pitch *
+		      info->var.bits_per_pixel >> 3) >> 3) | (((pitch *
+								info->var.
+								bits_per_pixel
+								>> 3) >> 3)
+							      << 16)));
+	/* BitBlt Destination Address */
+	MMIO_OUT32(VIA_REG_DSTPOS, ((rect->dy << 16) | rect->dx));
+	/* Dimension: width & height */
+	MMIO_OUT32(VIA_REG_DIMENSION,
+		   (((rect->height - 1) << 16) | (rect->width - 1)));
+	/* Forground color or Destination color */
+	MMIO_OUT32(VIA_REG_FGCOLOR, col);
+	/* GE Command */
+	MMIO_OUT32(VIA_REG_GECMD, (0x01 | 0x2000 | (rop << 24)));
+
+}
+
+static void viafb_copyarea(struct fb_info *info, const struct fb_copyarea *area)
+{
+	u32 dy = area->dy, sy = area->sy, direction = 0x0;
+	u32 sx = area->sx, dx = area->dx, width = area->width;
+	int pitch;
+
+	DEBUG_MSG(KERN_INFO "viafb_copyarea!!\n");
+
+	if (!via_fb_accel)
+		return cfb_copyarea(info, area);
+
+	if (!area->width || !area->height)
+		return;
+
+	if (sy < dy) {
+		dy += area->height - 1;
+		sy += area->height - 1;
+		direction |= 0x4000;
+	}
+
+	if (sx < dx) {
+		dx += width - 1;
+		sx += width - 1;
+		direction |= 0x8000;
+	}
+
+	/* Source Base Address */
+	/*MMIO_OUT32(VIA_REG_SRCBASE, 0x0); */
+	MMIO_OUT32(VIA_REG_SRCBASE,
+		   ((u32) (info->screen_base) - (u32) FB_MM) >> 3);
+	/* Destination Base Address */
+	/*MMIO_OUT32(VIA_REG_DSTBASE, 0x0); */
+	MMIO_OUT32(VIA_REG_DSTBASE,
+		   ((u32) (info->screen_base) - (u32) FB_MM) >> 3);
+	/* Pitch */
+	pitch = (info->var.xres_virtual + 7) & ~7;
+	/* VIA_PITCH_ENABLE can be omitted now. */
+	MMIO_OUT32(VIA_REG_PITCH,
+		   VIA_PITCH_ENABLE |
+		   (((pitch *
+		      info->var.bits_per_pixel >> 3) >> 3) | (((pitch *
+								info->var.
+								bits_per_pixel
+								>> 3) >> 3)
+							      << 16)));
+	/* BitBlt Source Address */
+	MMIO_OUT32(VIA_REG_SRCPOS, ((sy << 16) | sx));
+	/* BitBlt Destination Address */
+	MMIO_OUT32(VIA_REG_DSTPOS, ((dy << 16) | dx));
+	/* Dimension: width & height */
+	MMIO_OUT32(VIA_REG_DIMENSION,
+		   (((area->height - 1) << 16) | (area->width - 1)));
+	/* GE Command */
+	MMIO_OUT32(VIA_REG_GECMD, (0x01 | direction | (0xCC << 24)));
+
+}
+
+static void viafb_imageblit(struct fb_info *info, const struct fb_image *image)
+{
+	u32 size, bg_col = 0, fg_col = 0, *udata;
+	int i;
+	int pitch;
+
+	if (!via_fb_accel)
+		return cfb_imageblit(info, image);
+
+	udata = (u32 *) image->data;
+
+	switch (info->var.bits_per_pixel) {
+	case 8:
+		bg_col = image->bg_color;
+		fg_col = image->fg_color;
+		break;
+	case 16:
+		bg_col = ((u32 *) (info->pseudo_palette))[image->bg_color];
+		fg_col = ((u32 *) (info->pseudo_palette))[image->fg_color];
+		break;
+	case 32:
+		bg_col = ((u32 *) (info->pseudo_palette))[image->bg_color];
+		fg_col = ((u32 *) (info->pseudo_palette))[image->fg_color];
+		break;
+	}
+	size = image->width * image->height;
+
+	/* Source Base Address */
+	MMIO_OUT32(VIA_REG_SRCBASE, 0x0);
+	/* Destination Base Address */
+	/*MMIO_OUT32(VIA_REG_DSTBASE, 0x0); */
+	MMIO_OUT32(VIA_REG_DSTBASE,
+		   ((u32) (info->screen_base) - (u32) FB_MM) >> 3);
+	/* Pitch */
+	pitch = (info->var.xres_virtual + 7) & ~7;
+	MMIO_OUT32(VIA_REG_PITCH,
+		   VIA_PITCH_ENABLE |
+		   (((pitch *
+		      info->var.bits_per_pixel >> 3) >> 3) | (((pitch *
+								info->var.
+								bits_per_pixel
+								>> 3) >> 3)
+							      << 16)));
+	/* BitBlt Source Address */
+	MMIO_OUT32(VIA_REG_SRCPOS, 0x0);
+	/* BitBlt Destination Address */
+	MMIO_OUT32(VIA_REG_DSTPOS, ((image->dy << 16) | image->dx));
+	/* Dimension: width & height */
+	MMIO_OUT32(VIA_REG_DIMENSION,
+		   (((image->height - 1) << 16) | (image->width - 1)));
+	/* fb color */
+	MMIO_OUT32(VIA_REG_FGCOLOR, fg_col);
+	/* bg color */
+	MMIO_OUT32(VIA_REG_BGCOLOR, bg_col);
+	/* GE Command */
+	MMIO_OUT32(VIA_REG_GECMD, 0xCC020142);
+
+	for (i = 0; i < size / 4; i++) {
+		MMIO_OUT32(VIA_MMIO_BLTBASE, *udata);
+		udata++;
+	}
+
+}
+
+static int viafb_cursor(struct fb_info *info, struct fb_cursor *cursor)
+{
+	u8 data[CURSOR_SIZE / 8];
+	u32 data_bak[CURSOR_SIZE / 32];
+	u32 temp, xx, yy, bg_col = 0, fg_col = 0;
+	int size, i, j = 0;
+
+	if (!via_fb_accel)
+		return soft_cursor(info, cursor);
+
+	if ((((struct viafb_par *)(info->par))->iga_path == IGA2)
+	    && (chip_info.gfx_chip_name == UNICHROME_CLE266))
+		return soft_cursor(info, cursor);
+
+	/*When duoview and using lcd , use soft cursor */
+	if (LCD_ON || ((struct viafb_par *)(info->par))->duoview)
+		return soft_cursor(info, cursor);
+
+	show_hw_cursor(info, HW_Cursor_OFF);
+	viacursor = *cursor;
+
+	if (cursor->set & FB_CUR_SETHOT) {
+		viacursor.hot = cursor->hot;
+		temp = ((viacursor.hot.x) << 16) + viacursor.hot.y;
+		MMIO_OUT32(VIA_REG_CURSOR_ORG, temp);
+	}
+
+	if (cursor->set & FB_CUR_SETPOS) {
+		viacursor.image.dx = cursor->image.dx;
+		viacursor.image.dy = cursor->image.dy;
+		yy = cursor->image.dy - info->var.yoffset;
+		xx = cursor->image.dx - info->var.xoffset;
+		temp = yy & 0xFFFF;
+		temp |= (xx << 16);
+		MMIO_OUT32(VIA_REG_CURSOR_POS, temp);
+	}
+
+	if (cursor->set & FB_CUR_SETSIZE) {
+		temp = MMIO_IN32(VIA_REG_CURSOR_MODE);
+
+		if ((cursor->image.width <= 32)
+		    && (cursor->image.height <= 32)) {
+			MAX_CURS = 32;
+			temp |= 0x2;
+		} else if ((cursor->image.width <= 64)
+			   && (cursor->image.height <= 64)) {
+			MAX_CURS = 64;
+			temp &= 0xFFFFFFFD;
+		} else {
+			DEBUG_MSG(KERN_INFO
+			"The cursor image is biger than 64x64 bits...\n");
+			return -ENXIO;
+		}
+		MMIO_OUT32(VIA_REG_CURSOR_MODE, temp);
+
+		viacursor.image.height = cursor->image.height;
+		viacursor.image.width = cursor->image.width;
+	}
+
+	if (cursor->set & FB_CUR_SETCMAP) {
+		viacursor.image.fg_color = cursor->image.fg_color;
+		viacursor.image.bg_color = cursor->image.bg_color;
+
+		switch (info->var.bits_per_pixel) {
+		case 8:
+			/*FIX ME:It seems that hardware cursor
+			   always work in true color mode */
+			bg_col =
+			    (viafb_256_colors.
+			     red[viacursor.image.bg_color] >> 8 << 16);
+			bg_col =
+			    bg_col | (viafb_256_colors.
+				      green[viacursor.image.
+					    bg_color] >> 8 << 8);
+			bg_col =
+			    bg_col | (viafb_256_colors.
+				      blue[viacursor.image.bg_color] >> 8);
+			fg_col =
+			    (viafb_256_colors.
+			     red[viacursor.image.fg_color] >> 8 << 16);
+			fg_col =
+			    fg_col | (viafb_256_colors.
+				      green[viacursor.image.
+					    fg_color] >> 8 << 8);
+			fg_col =
+			    fg_col | (viafb_256_colors.
+				      blue[viacursor.image.fg_color] >> 8);
+			break;
+		case 16:
+			bg_col =
+			    ((u32 *) (info->pseudo_palette))[viacursor.
+							     image.bg_color];
+			bg_col =
+			    (0xFF << 24) | ((bg_col & 0xF800) << 8) |
+			    ((bg_col & 0x7E0) << 5) | ((bg_col & 0x1F) << 3);
+			fg_col =
+			    ((u32 *) (info->pseudo_palette))[viacursor.
+							     image.fg_color];
+			fg_col =
+			    (0xFF << 24) | ((fg_col & 0xF800) << 8) |
+			    ((fg_col & 0x7E0) << 5) | ((fg_col & 0x1F) << 3);
+			break;
+		case 32:
+			bg_col =
+			    ((u32 *) (info->pseudo_palette))[viacursor.
+							     image.bg_color];
+			fg_col =
+			    ((u32 *) (info->pseudo_palette))[viacursor.
+							     image.fg_color];
+			break;
+		}
+
+		MMIO_OUT32(VIA_REG_CURSOR_BG, bg_col);
+		MMIO_OUT32(VIA_REG_CURSOR_FG, fg_col);
+	}
+
+	if (cursor->set & FB_CUR_SETSHAPE) {
+		size =
+		    ((viacursor.image.width + 7) >> 3) * viacursor.image.height;
+
+		if (MAX_CURS == 32) {
+			for (i = 0; i < (CURSOR_SIZE / 32); i++) {
+				data_bak[i] = 0x0;
+				data_bak[i + 1] = 0xFFFFFFFF;
+				i += 1;
+			}
+		} else if (MAX_CURS == 64) {
+			for (i = 0; i < (CURSOR_SIZE / 32); i++) {
+				data_bak[i] = 0x0;
+				data_bak[i + 1] = 0x0;
+				data_bak[i + 2] = 0xFFFFFFFF;
+				data_bak[i + 3] = 0xFFFFFFFF;
+				i += 3;
+			}
+		}
+
+		switch (viacursor.rop) {
+		case ROP_XOR:
+			for (i = 0; i < size; i++)
+				data[i] = viacursor.mask[i];
+			break;
+		case ROP_COPY:
+
+			for (i = 0; i < size; i++)
+				data[i] = viacursor.mask[i];
+			break;
+		default:
+			break;
+		}
+
+		if (MAX_CURS == 32) {
+			for (i = 0; i < size; i++) {
+				data_bak[j] = (u32) data[i];
+				data_bak[j + 1] = ~data_bak[j];
+				j += 2;
+			}
+		} else if (MAX_CURS == 64) {
+			for (i = 0; i < size; i++) {
+				data_bak[j] = (u32) data[i];
+				data_bak[j + 1] = 0x0;
+				data_bak[j + 2] = ~data_bak[j];
+				data_bak[j + 3] = ~data_bak[j + 1];
+				j += 4;
+			}
+		}
+
+		memcpy(((struct viafb_par *)(info->par))->fbmem_virt +
+		       ((struct viafb_par *)(info->par))->cursor_start,
+		       data_bak, CURSOR_SIZE);
+	}
+
+	if (viacursor.enable)
+		show_hw_cursor(info, HW_Cursor_ON);
+
+	return 0;
+}
+
+static int viafb_sync(struct fb_info *info)
+{
+	if (via_fb_accel)
+		wait_engine_idle();
+	return 0;
+}
+
+int get_mode_index(int hres, int vres, int flag)
+{
+	DEBUG_MSG(KERN_INFO "get_mode_index!\n");
+
+	if (flag == 0) {
+		if (hres == 480 && vres == 640) {
+			resMode = VIA_RES_480X640;
+			mode = "480x640";
+		} else if (hres == 640 && vres == 480) {
+			resMode = VIA_RES_640X480;
+			mode = "640x480";
+		} else if (hres == 800 && vres == 480) {
+			resMode = VIA_RES_800X480;
+			mode = "800x480";
+		} else if (hres == 800 && vres == 600) {
+			resMode = VIA_RES_800X600;
+			mode = "800x600";
+		} else if (hres == 1024 && vres == 768) {
+			resMode = VIA_RES_1024X768;
+			mode = "1024x768";
+		} else if (hres == 1152 && vres == 864) {
+			resMode = VIA_RES_1152X864;
+			mode = "1152x864";
+		} else if (hres == 1280 && vres == 1024) {
+			resMode = VIA_RES_1280X1024;
+			mode = "1280x1024";
+		} else if (hres == 1600 && vres == 1200) {
+			resMode = VIA_RES_1600X1200;
+			mode = "1600x1200";
+		} else if (hres == 1440 && vres == 1050) {
+			resMode = VIA_RES_1440X1050;
+			mode = "1440x1050";
+		} else if (hres == 1280 && vres == 768) {
+			resMode = VIA_RES_1280X768;
+			mode = "1280x768";
+		} else if (hres == 1280 && vres == 800) {
+			resMode = VIA_RES_1280X800;
+			mode = "1280x800";
+		} else if (hres == 1280 && vres == 960) {
+			resMode = VIA_RES_1280X960;
+			mode = "1280x960";
+		} else if (hres == 1920 && vres == 1440) {
+			resMode = VIA_RES_1920X1440;
+			mode = "1920x1440";
+		} else if (hres == 848 && vres == 480) {
+			resMode = VIA_RES_848X480;
+			mode = "848x480";
+		} else if (hres == 1400 && vres == 1050) {
+			resMode = VIA_RES_1400X1050;
+			mode = "1400x1050";
+		} else if (hres == 720 && vres == 480) {
+			resMode = VIA_RES_720X480;
+			mode = "720x480";
+		} else if (hres == 720 && vres == 576) {
+			resMode = VIA_RES_720X576;
+			mode = "720x576";
+		} else if (hres == 1024 && vres == 512) {
+			resMode = VIA_RES_1024X512;
+			mode = "1024x512";
+		} else if (hres == 856 && vres == 480) {
+			resMode = VIA_RES_856X480;
+			mode = "856x480";
+		} else if (hres == 1024 && vres == 576) {
+			resMode = VIA_RES_1024X576;
+			mode = "1024x576";
+		} else if (hres == 1024 && vres == 600) {
+			resMode = VIA_RES_1024X600;
+			mode = "1024x600";
+		} else if (hres == 1280 && vres == 720) {
+			resMode = VIA_RES_1280X720;
+			mode = "1280x720";
+		} else if (hres == 1920 && vres == 1080) {
+			resMode = VIA_RES_1920X1080;
+			mode = "1920x1080";
+		} else if (hres == 1366 && vres == 768) {
+			resMode = VIA_RES_1368X768;
+			mode = "1368x768";
+		} else if (hres == 1680 && vres == 1050) {
+			resMode = VIA_RES_1680X1050;
+			mode = "1680x1050";
+		} else if (hres == 960 && vres == 600) {
+			resMode = VIA_RES_960X600;
+			mode = "960x600";
+		} else if (hres == 1000 && vres == 600) {
+			resMode = VIA_RES_1000X600;
+			mode = "1000x600";
+		} else if (hres == 1024 && vres == 576) {
+			resMode = VIA_RES_1024X576;
+			mode = "1024x576";
+		} else if (hres == 1024 && vres == 600) {
+			resMode = VIA_RES_1024X600;
+			mode = "1024x600";
+		} else if (hres == 1088 && vres == 612) {
+			resMode = VIA_RES_1088X612;
+			mode = "1088x612";
+		} else if (hres == 1152 && vres == 720) {
+			resMode = VIA_RES_1152X720;
+			mode = "1152x720";
+		} else if (hres == 1200 && vres == 720) {
+			resMode = VIA_RES_1200X720;
+			mode = "1200x720";
+		} else if (hres == 1280 && vres == 600) {
+			resMode = VIA_RES_1280X600;
+			mode = "1280x600";
+		} else if (hres == 1360 && vres == 768) {
+			resMode = VIA_RES_1360X768;
+			mode = "1360x768";
+		} else if (hres == 1366 && vres == 768) {
+			resMode = VIA_RES_1366X768;
+			mode = "1366x768";
+		} else if (hres == 1440 && vres == 900) {
+			resMode = VIA_RES_1440X900;
+			mode = "1440x900";
+		} else if (hres == 1600 && vres == 900) {
+			resMode = VIA_RES_1600X900;
+			mode = "1600x900";
+		} else if (hres == 1600 && vres == 1024) {
+			resMode = VIA_RES_1600X1024;
+			mode = "1600x1024";
+		} else if (hres == 1792 && vres == 1344) {
+			resMode = VIA_RES_1792X1344;
+			mode = "1792x1344";
+		} else if (hres == 1856 && vres == 1392) {
+			resMode = VIA_RES_1856X1392;
+			mode = "1856x1392";
+		} else if (hres == 1920 && vres == 1200) {
+			resMode = VIA_RES_1920X1200;
+			mode = "1920x1200";
+		} else if (hres == 2048 && vres == 1536) {
+			resMode = VIA_RES_2048X1536;
+			mode = "2048x1536";
+		} else {
+			resMode = VIA_RES_INVALID;
+			mode = "640x480";
+		}
+	} else {
+		if (hres == 480 && vres == 640) {
+			resMode = VIA_RES_480X640;
+			mode1 = "480x640";
+		} else if (hres == 640 && vres == 480) {
+			resMode = VIA_RES_640X480;
+			mode1 = "640x480";
+		} else if (hres == 800 && vres == 480) {
+			resMode = VIA_RES_800X480;
+			mode1 = "800x480";
+		} else if (hres == 800 && vres == 600) {
+			resMode = VIA_RES_800X600;
+			mode1 = "800x600";
+		} else if (hres == 1024 && vres == 768) {
+			resMode = VIA_RES_1024X768;
+			mode1 = "1024x768";
+		} else if (hres == 1152 && vres == 864) {
+			resMode = VIA_RES_1152X864;
+			mode1 = "1152x864";
+		} else if (hres == 1280 && vres == 1024) {
+			resMode = VIA_RES_1280X1024;
+			mode1 = "1280x1024";
+		} else if (hres == 1600 && vres == 1200) {
+			resMode = VIA_RES_1600X1200;
+			mode = "1600x1200";
+		} else if (hres == 1440 && vres == 1050) {
+			resMode = VIA_RES_1440X1050;
+			mode1 = "1440x1050";
+		} else if (hres == 1280 && vres == 768) {
+			resMode = VIA_RES_1280X768;
+			mode1 = "1280x768";
+		} else if (hres == 1280 && vres == 800) {
+			resMode = VIA_RES_1280X800;
+			mode1 = "1280x800";
+		} else if (hres == 1280 && vres == 960) {
+			resMode = VIA_RES_1280X960;
+			mode1 = "1280x960";
+		} else if (hres == 1920 && vres == 1440) {
+			resMode = VIA_RES_1920X1440;
+			mode1 = "1920x1440";
+		} else if (hres == 848 && vres == 480) {
+			resMode = VIA_RES_848X480;
+			mode1 = "848x480";
+		} else if (hres == 1400 && vres == 1050) {
+			resMode = VIA_RES_1400X1050;
+			mode1 = "1400x1050";
+		} else if (hres == 720 && vres == 480) {
+			resMode = VIA_RES_720X480;
+			mode1 = "720x480";
+		} else if (hres == 720 && vres == 576) {
+			resMode = VIA_RES_720X576;
+			mode1 = "720x576";
+		} else if (hres == 1024 && vres == 512) {
+			resMode = VIA_RES_1024X512;
+			mode1 = "1024x512";
+		} else if (hres == 856 && vres == 480) {
+			resMode = VIA_RES_856X480;
+			mode1 = "856x480";
+		} else if (hres == 1024 && vres == 576) {
+			resMode = VIA_RES_1024X576;
+			mode1 = "1024x576";
+		} else if (hres == 1024 && vres == 600) {
+			resMode = VIA_RES_1024X600;
+			mode1 = "1024x600";
+		} else if (hres == 1280 && vres == 720) {
+			resMode = VIA_RES_1280X720;
+			mode1 = "1280x720";
+		} else if (hres == 1920 && vres == 1080) {
+			resMode = VIA_RES_1920X1080;
+			mode1 = "1920x1080";
+		} else if (hres == 1366 && vres == 768) {
+			resMode = VIA_RES_1368X768;
+			mode1 = "1368x768";
+		} else if (hres == 1680 && vres == 1050) {
+			resMode = VIA_RES_1680X1050;
+			mode1 = "1680x1050";
+		} else if (hres == 960 && vres == 600) {
+			resMode = VIA_RES_960X600;
+			mode1 = "960x600";
+		} else if (hres == 1000 && vres == 600) {
+			resMode = VIA_RES_1000X600;
+			mode1 = "1000x600";
+		} else if (hres == 1024 && vres == 576) {
+			resMode = VIA_RES_1024X576;
+			mode1 = "1024x576";
+		} else if (hres == 1024 && vres == 600) {
+			resMode = VIA_RES_1024X600;
+			mode1 = "1024x600";
+		} else if (hres == 1088 && vres == 612) {
+			resMode = VIA_RES_1088X612;
+			mode1 = "1088x612";
+		} else if (hres == 1152 && vres == 720) {
+			resMode = VIA_RES_1152X720;
+			mode1 = "1152x720";
+		} else if (hres == 1200 && vres == 720) {
+			resMode = VIA_RES_1200X720;
+			mode1 = "1200x720";
+		} else if (hres == 1280 && vres == 600) {
+			resMode = VIA_RES_1280X600;
+			mode1 = "1280x600";
+		} else if (hres == 1360 && vres == 768) {
+			resMode = VIA_RES_1360X768;
+			mode1 = "1360x768";
+		} else if (hres == 1366 && vres == 768) {
+			resMode = VIA_RES_1366X768;
+			mode1 = "1366x768";
+		} else if (hres == 1440 && vres == 900) {
+			resMode = VIA_RES_1440X900;
+			mode1 = "1440x900";
+		} else if (hres == 1600 && vres == 900) {
+			resMode = VIA_RES_1600X900;
+			mode1 = "1600x900";
+		} else if (hres == 1600 && vres == 1024) {
+			resMode = VIA_RES_1600X1024;
+			mode1 = "1600x1024";
+		} else if (hres == 1792 && vres == 1344) {
+			resMode = VIA_RES_1792X1344;
+			mode1 = "1792x1344";
+		} else if (hres == 1856 && vres == 1392) {
+			resMode = VIA_RES_1856X1392;
+			mode1 = "1856x1392";
+		} else if (hres == 1920 && vres == 1200) {
+			resMode = VIA_RES_1920X1200;
+			mode1 = "1920x1200";
+		} else if (hres == 2048 && vres == 1536) {
+			resMode = VIA_RES_2048X1536;
+			mode1 = "2048x1536";
+		} else {
+			resMode = VIA_RES_INVALID;
+			mode1 = "640x480";
+		}
+	}
+	return (resMode);
+}
+
+void check_available_device_to_enable(int device_id)
+{
+	int device_num = 0;
+
+	/* Initialize: */
+	CRT_ON = STATE_OFF;
+	DVI_ON = STATE_OFF;
+	LCD_ON = STATE_OFF;
+	LCD2_ON = STATE_OFF;
+	DeviceStatus = None_Device;
+
+	if ((device_id & CRT_Device) && (device_num < MAX_ACTIVE_DEV_NUM)) {
+		CRT_ON = STATE_ON;
+		device_num++;
+		DeviceStatus |= CRT_Device;
+	}
+
+	if ((device_id & DVI_Device) && (device_num < MAX_ACTIVE_DEV_NUM)) {
+		DVI_ON = STATE_ON;
+		device_num++;
+		DeviceStatus |= DVI_Device;
+	}
+
+	if ((device_id & LCD_Device) && (device_num < MAX_ACTIVE_DEV_NUM)) {
+		LCD_ON = STATE_ON;
+		device_num++;
+		DeviceStatus |= LCD_Device;
+	}
+
+	if ((device_id & LCD2_Device) && (device_num < MAX_ACTIVE_DEV_NUM)) {
+		LCD2_ON = STATE_ON;
+		device_num++;
+		DeviceStatus |= LCD2_Device;
+	}
+
+	if (DeviceStatus == None_Device) {
+		/* Use CRT as default active device: */
+		CRT_ON = STATE_ON;
+		DeviceStatus = CRT_Device;
+	}
+	DEBUG_MSG(KERN_INFO "Device Status:%x", DeviceStatus);
+}
+
+void viafb_set_device(struct device_t active_dev)
+{
+	/* Check available device to enable: */
+	int device_id = None_Device;
+	if (active_dev.crt)
+		device_id |= CRT_Device;
+	if (active_dev.dvi)
+		device_id |= DVI_Device;
+	if (active_dev.lcd)
+		device_id |= LCD_Device;
+
+	check_available_device_to_enable(device_id);
+
+	/* Check property of LCD: */
+	if (LCD_ON) {
+		if (active_dev.lcd_dsp_cent) {
+			lvds_setting_info.display_method = lcd_dsp_method =
+			    LCD_CENTERING;
+		} else {
+			lvds_setting_info.display_method = lcd_dsp_method =
+			    LCD_EXPANDSION;
+		}
+
+		if (active_dev.lcd_mode == LCD_SPWG)
+			lvds_setting_info.lcd_mode = lcd_mode = LCD_SPWG;
+		else
+			lvds_setting_info.lcd_mode = lcd_mode = LCD_OPENLDI;
+
+		if (active_dev.lcd_panel_id <= LCD_PANEL_ID_MAXIMUM) {
+			lcd_panel_id = active_dev.lcd_panel_id;
+			init_lcd_size();
+		}
+	}
+
+	/* Check property of mode: */
+	if (!active_dev.xres1)
+		second_xres = 640;
+	else
+		second_xres = active_dev.xres1;
+
+	if (!active_dev.yres1)
+		second_yres = 480;
+	else
+		second_yres = active_dev.yres1;
+
+	if (active_dev.bpp != 0)
+		via_fb_bpp = active_dev.bpp;
+	if (active_dev.bpp1 != 0)
+		via_fb_bpp1 = active_dev.bpp1;
+	if (active_dev.refresh != 0)
+		refresh = active_dev.refresh;
+	if (active_dev.refresh1 != 0)
+		refresh1 = active_dev.refresh1;
+	if ((active_dev.samm == STATE_OFF)
+	    || (active_dev.samm == STATE_ON))
+	    SAMM_ON = active_dev.samm;
+	primary_dev = active_dev.primary_dev;
+
+	set_start_addr();
+	set_iga_path();
+}
+
+void viafb_set_video_device(u32 video_dev_info)
+{
+	video_on_crt = STATE_OFF;
+	video_on_dvi = STATE_OFF;
+	video_on_lcd = STATE_OFF;
+
+	/* Check available device to enable: */
+	if ((video_dev_info & CRT_Device) == CRT_Device)
+		video_on_crt = STATE_ON;
+	else if ((video_dev_info & DVI_Device) == DVI_Device)
+		video_on_dvi = STATE_ON;
+	else if ((video_dev_info & LCD_Device) == LCD_Device)
+		video_on_lcd = STATE_ON;
+}
+void viafb_get_video_device(u32 *video_dev_info)
+{
+	*video_dev_info = None_Device;
+	if (video_on_crt == STATE_ON)
+		*video_dev_info |= CRT_Device;
+	else if (video_on_dvi == STATE_ON)
+		*video_dev_info |= DVI_Device;
+	else if (video_on_lcd == STATE_ON)
+		*video_dev_info |= LCD_Device;
+}
+
+/*
+*   S.T.Chen [2006.01.17]:
+*       Purpose: to get the current primary display device type.
+*       Return: an integer which indicates the current primary device type.
+*/
+int get_primary_device()
+{
+	int primary_device = 0;
+	/* Rule: device on iga1 path are the primary device. */
+	if (SAMM_ON) {
+		if (CRT_ON) {
+			if (crt_setting_info.iga_path == IGA1) {
+				DEBUG_MSG(KERN_INFO "CRT IGA Path:%d\n",
+					  crt_setting_info.iga_path);
+				primary_device = CRT_Device;
+			}
+		}
+		if (DVI_ON) {
+			if (tmds_setting_info.iga_path == IGA1) {
+				DEBUG_MSG(KERN_INFO "DVI IGA Path:%d\n",
+					  tmds_setting_info.iga_path);
+				primary_device = DVI_Device;
+			}
+		}
+		if (LCD_ON) {
+			if (lvds_setting_info.iga_path == IGA1) {
+				DEBUG_MSG(KERN_INFO "LCD IGA Path:%d\n",
+					  lvds_setting_info.iga_path);
+				primary_device = LCD_Device;
+			}
+		}
+		if (LCD2_ON) {
+			if (lvds_setting_info2.iga_path == IGA1) {
+				DEBUG_MSG(KERN_INFO "LCD2 IGA Path:%d\n",
+					  lvds_setting_info2.iga_path);
+				primary_device = LCD2_Device;
+			}
+		}
+	}
+	return primary_device;
+}
+
+u8 is_duoview(void)
+{
+	if (0 == SAMM_ON) {
+		if (LCD_ON + LCD2_ON + DVI_ON + CRT_ON == 2)
+			return TRUE;
+		return FALSE;
+	} else {
+		return FALSE;
+	}
+}
+
+void apply_second_mode_setting(struct fb_var_screeninfo *sec_var)
+{
+	if ((sec_var->xres_virtual * (sec_var->bits_per_pixel >> 3)) & 0x1F) {
+		/*Is 32 bytes alignment? */
+		/*32 pixel alignment */
+		sec_var->xres_virtual = (sec_var->xres_virtual + 31) & ~31;
+	}
+	second_xres = sec_var->xres;
+	second_yres = sec_var->yres;
+	second_virtual_xres = sec_var->xres_virtual;
+	second_virtual_yres = sec_var->yres_virtual;
+	via_fb_bpp1 = sec_var->bits_per_pixel;
+	refresh1 = get_refresh(sec_var->xres, sec_var->yres, sec_var->pixclock);
+}
+
+int apply_device_setting(struct viafb_ioctl_setting setting_info,
+			 struct fb_info *info)
+{
+	int need_set_mode = 0;
+	DEBUG_MSG(KERN_INFO "apply_device_setting\n");
+
+	if (setting_info.device_flag) {
+		need_set_mode = 1;
+		check_available_device_to_enable(setting_info.device_status);
+	}
+
+	/* Unlock LCD's operation according to LCD flag
+	   and check if the setting value is valid. */
+	/* If the value is valid, apply the new setting value to the device. */
+	if (LCD_ON) {
+		if (setting_info.lcd_operation_flag & OP_LCD_CENTERING) {
+			need_set_mode = 1;
+			if (setting_info.lcd_attributes.display_center) {
+				/* Centering */
+				lvds_setting_info.display_method =
+				    LCD_CENTERING;
+				lcd_dsp_method = LCD_CENTERING;
+				lvds_setting_info2.display_method =
+				    lcd_dsp_method = LCD_CENTERING;
+			} else {
+				/* expandsion */
+				lvds_setting_info.display_method =
+				    LCD_EXPANDSION;
+				lcd_dsp_method = LCD_EXPANDSION;
+				lvds_setting_info2.display_method =
+				    LCD_EXPANDSION;
+				lcd_dsp_method = LCD_EXPANDSION;
+			}
+		}
+
+		if (setting_info.lcd_operation_flag & OP_LCD_MODE) {
+			need_set_mode = 1;
+			if (setting_info.lcd_attributes.lcd_mode == LCD_SPWG) {
+				lvds_setting_info.lcd_mode = lcd_mode =
+				    LCD_SPWG;
+			} else {
+				lvds_setting_info.lcd_mode = lcd_mode =
+				    LCD_OPENLDI;
+			}
+			lvds_setting_info2.lcd_mode =
+			    lvds_setting_info.lcd_mode;
+		}
+
+		if (setting_info.lcd_operation_flag & OP_LCD_PANEL_ID) {
+			need_set_mode = 1;
+			if (setting_info.lcd_attributes.panel_id <=
+			    LCD_PANEL_ID_MAXIMUM) {
+				lcd_panel_id =
+				    setting_info.lcd_attributes.panel_id;
+				init_lcd_size();
+			}
+		}
+	}
+
+	if (0 != (setting_info.samm_status & OP_SAMM)) {
+		setting_info.samm_status =
+		    setting_info.samm_status & (~OP_SAMM);
+		if (setting_info.samm_status == 0
+		    || setting_info.samm_status == 1) {
+			SAMM_ON = setting_info.samm_status;
+
+			if (SAMM_ON)
+				primary_dev = setting_info.primary_device;
+
+			set_start_addr();
+			set_iga_path();
+		}
+		need_set_mode = 1;
+	}
+
+	parinfo.duoview = is_duoview();
+
+	if (!need_set_mode) {
+		;
+	} else {
+		set_iga_path();
+		viafb_set_par(info);
+	}
+	return (TRUE);
+}
+
+void retrieve_device_setting(struct viafb_ioctl_setting *setting_info)
+{
+
+	/* get device status */
+	if (CRT_ON == 1)
+		setting_info->device_status = CRT_Device;
+	if (DVI_ON == 1)
+		setting_info->device_status |= DVI_Device;
+	if (LCD_ON == 1)
+		setting_info->device_status |= LCD_Device;
+	if (LCD2_ON == 1)
+		setting_info->device_status |= LCD2_Device;
+	if ((video_on_crt == 1) && (CRT_ON == 1))
+		setting_info->video_device_status = crt_setting_info.iga_path;
+	else if ((video_on_dvi == 1) && (DVI_ON == 1))
+		setting_info->video_device_status = tmds_setting_info.iga_path;
+	else if ((video_on_lcd == 1) && (LCD_ON == 1))
+		setting_info->video_device_status = lvds_setting_info.iga_path;
+	else
+		setting_info->video_device_status = 0;
+
+	setting_info->samm_status = SAMM_ON;
+	setting_info->primary_device = get_primary_device();
+
+	setting_info->first_dev_bpp = via_fb_bpp;
+	setting_info->second_dev_bpp = via_fb_bpp1;
+
+	setting_info->first_dev_refresh = refresh;
+	setting_info->second_dev_refresh = refresh1;
+
+	setting_info->first_dev_hor_res = via_fb_hotplug_Xres;
+	setting_info->first_dev_ver_res = via_fb_hotplug_Yres;
+	setting_info->second_dev_hor_res = second_xres;
+	setting_info->second_dev_ver_res = second_yres;
+
+	/* Get lcd attributes */
+	setting_info->lcd_attributes.display_center = lcd_dsp_method;
+	setting_info->lcd_attributes.panel_id = lcd_panel_id;
+	setting_info->lcd_attributes.lcd_mode = lcd_mode;
+}
+
+void parse_active_dev(void)
+{
+	CRT_ON = STATE_OFF;
+	DVI_ON = STATE_OFF;
+	LCD_ON = STATE_OFF;
+	LCD2_ON = STATE_OFF;
+	/* 1. Modify the active status of devices. */
+	/* 2. Keep the order of devices, so we can set corresponding
+	   IGA path to devices in SAMM case. */
+	/*    Note: The previous of active_dev is primary device,
+	   and the following is secondary device. */
+	if (!strncmp(active_dev, "CRT+DVI", 7)) {
+		/* CRT+DVI */
+		CRT_ON = STATE_ON;
+		DVI_ON = STATE_ON;
+		primary_dev = CRT_Device;
+	} else if (!strncmp(active_dev, "DVI+CRT", 7)) {
+		/* DVI+CRT */
+		CRT_ON = STATE_ON;
+		DVI_ON = STATE_ON;
+		primary_dev = DVI_Device;
+	} else if (!strncmp(active_dev, "CRT+LCD", 7)) {
+		/* CRT+LCD */
+		CRT_ON = STATE_ON;
+		LCD_ON = STATE_ON;
+		primary_dev = CRT_Device;
+	} else if (!strncmp(active_dev, "LCD+CRT", 7)) {
+		/* LCD+CRT */
+		CRT_ON = STATE_ON;
+		LCD_ON = STATE_ON;
+		primary_dev = LCD_Device;
+	} else if (!strncmp(active_dev, "DVI+LCD", 7)) {
+		/* DVI+LCD */
+		DVI_ON = STATE_ON;
+		LCD_ON = STATE_ON;
+		primary_dev = DVI_Device;
+	} else if (!strncmp(active_dev, "LCD+DVI", 7)) {
+		/* LCD+DVI */
+		DVI_ON = STATE_ON;
+		LCD_ON = STATE_ON;
+		primary_dev = LCD_Device;
+	} else if (!strncmp(active_dev, "LCD+LCD2", 8)) {
+		LCD_ON = STATE_ON;
+		LCD2_ON = STATE_ON;
+		primary_dev = LCD_Device;
+	} else if (!strncmp(active_dev, "LCD2+LCD", 8)) {
+		LCD_ON = STATE_ON;
+		LCD2_ON = STATE_ON;
+		primary_dev = LCD2_Device;
+	} else if (!strncmp(active_dev, "CRT", 3)) {
+		/* CRT only */
+		CRT_ON = STATE_ON;
+		SAMM_ON = STATE_OFF;
+	} else if (!strncmp(active_dev, "DVI", 3)) {
+		/* DVI only */
+		DVI_ON = STATE_ON;
+		SAMM_ON = STATE_OFF;
+	} else if (!strncmp(active_dev, "LCD", 3)) {
+		/* LCD only */
+		LCD_ON = STATE_ON;
+		SAMM_ON = STATE_OFF;
+	} else {
+		CRT_ON = STATE_ON;
+		SAMM_ON = STATE_OFF;
+	}
+	parinfo.duoview = is_duoview();
+}
+
+void parse_video_dev(void)
+{
+	video_on_crt = STATE_OFF;
+	video_on_dvi = STATE_OFF;
+	video_on_lcd = STATE_OFF;
+
+	if (!strncmp(video_dev, "CRT", 3)) {
+		/* Video on CRT */
+		video_on_crt = STATE_ON;
+	} else if (!strncmp(video_dev, "DVI", 3)) {
+		/* Video on DVI */
+		video_on_dvi = STATE_ON;
+	} else if (!strncmp(video_dev, "LCD", 3)) {
+		/* Video on LCD */
+		video_on_lcd = STATE_ON;
+	}
+}
+
+int parse_port(char *opt_str, int *output_interface)
+{
+	if (!strncmp(opt_str, "DVP0", 4))
+		*output_interface = INTERFACE_DVP0;
+	else if (!strncmp(opt_str, "DVP1", 4))
+		*output_interface = INTERFACE_DVP1;
+	else if (!strncmp(opt_str, "DFP_HIGHLOW", 11))
+		*output_interface = INTERFACE_DFP;
+	else if (!strncmp(opt_str, "DFP_HIGH", 8))
+		*output_interface = INTERFACE_DFP_HIGH;
+	else if (!strncmp(opt_str, "DFP_LOW", 8))
+		*output_interface = INTERFACE_DFP_LOW;
+	else
+		*output_interface = INTERFACE_NONE;
+	return 0;
+}
+void parse_lcd_port(void)
+{
+	parse_port(lcd_port, &chip_info.lvds_chip_info.output_interface);
+	/*Initialize to avoid unexpected behavior */
+	chip_info.lvds_chip_info2.output_interface = INTERFACE_NONE;
+
+	DEBUG_MSG(KERN_INFO "parse_lcd_port: lcd_port:%s,interface:%d\n",
+		  lcd_port, chip_info.lvds_chip_info.output_interface);
+}
+
+void parse_dvi_port(void)
+{
+	parse_port(dvi_port, &chip_info.tmds_chip_info.output_interface);
+
+	DEBUG_MSG(KERN_INFO "parse_dvi_port: dvi_port:%s,interface:%d\n",
+		  dvi_port, chip_info.tmds_chip_info.output_interface);
+}
+
+/*
+ * The proc filesystem read/write function, a simple proc implement to
+ * get/set the value of DPA  DVP0,   DVP0DataDriving,  DVP0ClockDriving, DVP1,
+ * DVP1Driving, DFPHigh, DFPLow CR96,   SR2A[5], SR1B[1], SR2A[4], SR1E[2],
+ * CR9B,    SR65,    CR97,    CR99
+ */
+static int viafb_dvp0_proc_read(char *buf, char **start, off_t offset,
+				int count, int *eof, void *data)
+{
+	int len = 0;
+	u8 dvp0_data_dri = 0, dvp0_clk_dri = 0, dvp0 = 0;
+	dvp0_data_dri =
+	    (read_reg(VIASR, SR2A) & BIT5) >> 4 | (read_reg(VIASR, SR1B) &
+						   BIT1) >> 1;
+	dvp0_clk_dri =
+	    (read_reg(VIASR, SR2A) & BIT4) >> 3 | (read_reg(VIASR, SR1E) &
+						   BIT2) >> 2;
+	dvp0 = read_reg(VIACR, CR96) & 0x0f;
+	len +=
+	    sprintf(buf + len, "%x %x %x\n", dvp0, dvp0_data_dri, dvp0_clk_dri);
+	*eof = 1;		/*Inform kernel end of data */
+	return len;
+}
+static int viafb_dvp0_proc_write(struct file *file,
+				 const char __user *buffer,
+				 unsigned long count, void *data)
+{
+	char buf[20], *value, *pbuf;
+	u8 reg_val = 0;
+	unsigned long length, i;
+	if (count < 1)
+		return -EINVAL;
+	length = count > 20 ? 20 : count;
+	if (copy_from_user(&buf[0], buffer, length))
+		return -EFAULT;
+	buf[length - 1] = '\0';	/*Ensure end string */
+	pbuf = &buf[0];
+	for (i = 0; i < 3; i++) {
+		value = strsep(&pbuf, " ");
+		if (value != NULL) {
+			reg_val = simple_strtoul(value, NULL, 0);
+			DEBUG_MSG(KERN_INFO "DVP0:reg_val[%d]=:%x\n", i,
+				  reg_val);
+			switch (i) {
+			case 0:
+				write_reg_mask(CR96, VIACR, reg_val, 0x0f);
+				break;
+			case 1:
+				write_reg_mask(SR2A, VIASR, reg_val << 4, BIT5);
+				write_reg_mask(SR1B, VIASR, reg_val << 1, BIT1);
+				break;
+			case 2:
+				write_reg_mask(SR2A, VIASR, reg_val << 3, BIT4);
+				write_reg_mask(SR1E, VIASR, reg_val << 2, BIT2);
+				break;
+			default:
+				break;
+			}
+		} else {
+			break;
+		}
+	}
+	return count;
+}
+static int viafb_dvp1_proc_read(char *buf, char **start, off_t offset,
+				int count, int *eof, void *data)
+{
+	int len = 0;
+	u8 dvp1 = 0, dvp1_data_dri = 0, dvp1_clk_dri = 0;
+	dvp1 = read_reg(VIACR, CR9B) & 0x0f;
+	dvp1_data_dri = (read_reg(VIASR, SR65) & 0x0c) >> 2;
+	dvp1_clk_dri = read_reg(VIASR, SR65) & 0x03;
+	len +=
+	    sprintf(buf + len, "%x %x %x\n", dvp1, dvp1_data_dri, dvp1_clk_dri);
+	*eof = 1;		/*Inform kernel end of data */
+	return len;
+}
+static int viafb_dvp1_proc_write(struct file *file,
+				 const char __user *buffer,
+				 unsigned long count, void *data)
+{
+	char buf[20], *value, *pbuf;
+	u8 reg_val = 0;
+	unsigned long length, i;
+	if (count < 1)
+		return -EINVAL;
+	length = count > 20 ? 20 : count;
+	if (copy_from_user(&buf[0], buffer, length))
+		return -EFAULT;
+	buf[length - 1] = '\0';	/*Ensure end string */
+	pbuf = &buf[0];
+	for (i = 0; i < 3; i++) {
+		value = strsep(&pbuf, " ");
+		if (value != NULL) {
+			reg_val = simple_strtoul(value, NULL, 0);
+			switch (i) {
+			case 0:
+				write_reg_mask(CR9B, VIACR, reg_val, 0x0f);
+				break;
+			case 1:
+				write_reg_mask(SR65, VIASR, reg_val << 2, 0x0c);
+				break;
+			case 2:
+				write_reg_mask(SR65, VIASR, reg_val, 0x03);
+				break;
+			default:
+				break;
+			}
+		} else {
+			break;
+		}
+	}
+	return count;
+}
+
+static int viafb_dfph_proc_read(char *buf, char **start, off_t offset,
+				int count, int *eof, void *data)
+{
+	int len = 0;
+	u8 dfp_high = 0;
+	dfp_high = read_reg(VIACR, CR97) & 0x0f;
+	len += sprintf(buf + len, "%x\n", dfp_high);
+	*eof = 1;		/*Inform kernel end of data */
+	return len;
+}
+static int viafb_dfph_proc_write(struct file *file,
+				 const char __user *buffer,
+				 unsigned long count, void *data)
+{
+	char buf[20];
+	u8 reg_val = 0;
+	unsigned long length;
+	if (count < 1)
+		return -EINVAL;
+	length = count > 20 ? 20 : count;
+	if (copy_from_user(&buf[0], buffer, length))
+		return -EFAULT;
+	buf[length - 1] = '\0';	/*Ensure end string */
+	reg_val = simple_strtoul(&buf[0], NULL, 0);
+	write_reg_mask(CR97, VIACR, reg_val, 0x0f);
+	return count;
+}
+static int viafb_dfpl_proc_read(char *buf, char **start, off_t offset,
+				int count, int *eof, void *data)
+{
+	int len = 0;
+	u8 dfp_low = 0;
+	dfp_low = read_reg(VIACR, CR99) & 0x0f;
+	len += sprintf(buf + len, "%x\n", dfp_low);
+	*eof = 1;		/*Inform kernel end of data */
+	return len;
+}
+static int viafb_dfpl_proc_write(struct file *file,
+				 const char __user *buffer,
+				 unsigned long count, void *data)
+{
+	char buf[20];
+	u8 reg_val = 0;
+	unsigned long length;
+	if (count < 1)
+		return -EINVAL;
+	length = count > 20 ? 20 : count;
+	if (copy_from_user(&buf[0], buffer, length))
+		return -EFAULT;
+	buf[length - 1] = '\0';	/*Ensure end string */
+	reg_val = simple_strtoul(&buf[0], NULL, 0);
+	write_reg_mask(CR99, VIACR, reg_val, 0x0f);
+	return count;
+}
+static int viafb_vt1636_proc_read(char *buf, char **start, off_t offset,
+				  int count, int *eof, void *data)
+{
+	int len = 0;
+	u8 vt1636_08 = 0, vt1636_09 = 0;
+	switch (chip_info.lvds_chip_info.lvds_chip_name) {
+	case VT1636_LVDS:
+		vt1636_08 =
+		    gpio_i2c_read_lvds(&lvds_setting_info,
+				       &chip_info.lvds_chip_info, 0x08) & 0x0f;
+		vt1636_09 =
+		    gpio_i2c_read_lvds(&lvds_setting_info,
+				       &chip_info.lvds_chip_info, 0x09) & 0x1f;
+		len += sprintf(buf + len, "%x %x\n", vt1636_08, vt1636_09);
+		break;
+	default:
+		break;
+	}
+	switch (chip_info.lvds_chip_info2.lvds_chip_name) {
+	case VT1636_LVDS:
+		vt1636_08 =
+		    gpio_i2c_read_lvds(&lvds_setting_info2,
+				       &chip_info.lvds_chip_info2, 0x08) & 0x0f;
+		vt1636_09 =
+		    gpio_i2c_read_lvds(&lvds_setting_info2,
+				       &chip_info.lvds_chip_info2, 0x09) & 0x1f;
+		len += sprintf(buf + len, " %x %x\n", vt1636_08, vt1636_09);
+		break;
+	default:
+		break;
+	}
+	*eof = 1;		/*Inform kernel end of data */
+	return len;
+}
+static int viafb_vt1636_proc_write(struct file *file,
+				   const char __user *buffer,
+				   unsigned long count, void *data)
+{
+	char buf[30], *value, *pbuf;
+	struct IODATA reg_val;
+	unsigned long length, i;
+	if (count < 1)
+		return -EINVAL;
+	length = count > 30 ? 30 : count;
+	if (copy_from_user(&buf[0], buffer, length))
+		return -EFAULT;
+	buf[length - 1] = '\0';	/*Ensure end string */
+	pbuf = &buf[0];
+	switch (chip_info.lvds_chip_info.lvds_chip_name) {
+	case VT1636_LVDS:
+		for (i = 0; i < 2; i++) {
+			value = strsep(&pbuf, " ");
+			if (value != NULL) {
+				reg_val.Data = simple_strtoul(value, NULL, 0);
+				switch (i) {
+				case 0:
+					reg_val.Index = 0x08;
+					reg_val.Mask = 0x0f;
+					gpio_i2c_write_mask_lvds
+					    (&lvds_setting_info,
+					     &chip_info.lvds_chip_info,
+					     reg_val);
+					break;
+				case 1:
+					reg_val.Index = 0x09;
+					reg_val.Mask = 0x1f;
+					gpio_i2c_write_mask_lvds
+					    (&lvds_setting_info,
+					     &chip_info.lvds_chip_info,
+					     reg_val);
+					break;
+				default:
+					break;
+				}
+			} else {
+				break;
+			}
+		}
+		break;
+	default:
+		break;
+	}
+	switch (chip_info.lvds_chip_info2.lvds_chip_name) {
+	case VT1636_LVDS:
+		for (i = 0; i < 2; i++) {
+			value = strsep(&pbuf, " ");
+			if (value != NULL) {
+				reg_val.Data = simple_strtoul(value, NULL, 0);
+				switch (i) {
+				case 0:
+					reg_val.Index = 0x08;
+					reg_val.Mask = 0x0f;
+					gpio_i2c_write_mask_lvds
+					    (&lvds_setting_info2,
+					     &chip_info.lvds_chip_info2,
+					     reg_val);
+					break;
+				case 1:
+					reg_val.Index = 0x09;
+					reg_val.Mask = 0x1f;
+					gpio_i2c_write_mask_lvds
+					    (&lvds_setting_info2,
+					     &chip_info.lvds_chip_info2,
+					     reg_val);
+					break;
+				default:
+					break;
+				}
+			} else {
+				break;
+			}
+		}
+		break;
+	default:
+		break;
+	}
+	return count;
+}
+
+static void viafb_init_proc(struct proc_dir_entry *viafb_entry)
+{
+	struct proc_dir_entry *entry;
+	viafb_entry = proc_mkdir("viafb", NULL);
+	if (viafb_entry) {
+		entry = create_proc_entry("dvp0", 0, viafb_entry);
+		if (entry) {
+			entry->owner = THIS_MODULE;
+			entry->read_proc = viafb_dvp0_proc_read;
+			entry->write_proc = viafb_dvp0_proc_write;
+		}
+		entry = create_proc_entry("dvp1", 0, viafb_entry);
+		if (entry) {
+			entry->owner = THIS_MODULE;
+			entry->read_proc = viafb_dvp1_proc_read;
+			entry->write_proc = viafb_dvp1_proc_write;
+		}
+		entry = create_proc_entry("dfph", 0, viafb_entry);
+		if (entry) {
+			entry->owner = THIS_MODULE;
+			entry->read_proc = viafb_dfph_proc_read;
+			entry->write_proc = viafb_dfph_proc_write;
+		}
+		entry = create_proc_entry("dfpl", 0, viafb_entry);
+		if (entry) {
+			entry->owner = THIS_MODULE;
+			entry->read_proc = viafb_dfpl_proc_read;
+			entry->write_proc = viafb_dfpl_proc_write;
+		}
+		if (VT1636_LVDS == chip_info.lvds_chip_info.lvds_chip_name
+		    || VT1636_LVDS ==
+		    chip_info.lvds_chip_info2.lvds_chip_name) {
+			entry = create_proc_entry("vt1636", 0, viafb_entry);
+			if (entry) {
+				entry->owner = THIS_MODULE;
+				entry->read_proc = viafb_vt1636_proc_read;
+				entry->write_proc = viafb_vt1636_proc_write;
+			}
+		}
+
+	}
+}
+static void viafb_remove_proc(struct proc_dir_entry *viafb_entry)
+{
+	/* no problem if it was not registered */
+	remove_proc_entry("dvp0", viafb_entry);/* parent dir */
+	remove_proc_entry("dvp1", viafb_entry);
+	remove_proc_entry("dfph", viafb_entry);
+	remove_proc_entry("dfpl", viafb_entry);
+	remove_proc_entry("vt1636", viafb_entry);
+	remove_proc_entry("vt1625", viafb_entry);
+}
+
+static int __devinit via_pci_probe(void)
+{
+
+	/*unsigned char revision; */
+	unsigned int default_xres, default_yres;
+	char *tmpc, *tmpm;
+	char *tmpc_sec, *tmpm_sec;
+	int vmode_index;
+
+	DEBUG_MSG(KERN_INFO "VIAFB PCI Probe!!\n");
+	init_global_var();
+	if (dual_fb)
+		SAMM_ON = 1;
+	parse_active_dev();
+	parse_video_dev();
+	parse_lcd_port();
+	parse_dvi_port();
+
+	/* for dual-fb must SAMM_ON=1 and dual_fb=1 */
+	if (!SAMM_ON)
+		dual_fb = 0;
+
+	init_chip_info();
+	get_fb_info(&parinfo.fbmem, &parinfo.memsize);
+	parinfo.fbmem_free = parinfo.memsize;
+	parinfo.fbmem_used = 0;
+	parinfo.fbmem_virt = ioremap_nocache(parinfo.fbmem, parinfo.memsize);
+	viafbinfo.screen_base = (char *)parinfo.fbmem_virt;
+
+	if (!parinfo.fbmem_virt) {
+		printk(KERN_INFO "ioremap failed\n");
+		return -1;
+	}
+
+	get_mmio_info(&parinfo.mmio_base, &parinfo.mmio_len);
+	parinfo.io_virt = ioremap_nocache(parinfo.mmio_base, parinfo.mmio_len);
+
+	viafbinfo.par = &parinfo;
+	viafbinfo.node = 0;
+	viafbinfo.fbops = &viafb_ops;
+	viafbinfo.flags = FBINFO_DEFAULT | FBINFO_HWACCEL_YPAN;
+
+	viafbinfo.pseudo_palette = pseudo_pal;
+	if (via_fb_accel) {
+		init_accel();
+		parinfo.accel = 1;
+		init_2d_engine();
+		hw_cursor_init();
+	}
+
+	if (second_size && (second_size < 8)) {
+		second_offset = parinfo.fbmem_free - second_size * 1024 * 1024;
+	} else {
+		second_size = 8;
+		second_offset = parinfo.fbmem_free - second_size * 1024 * 1024;
+	}
+
+	FB_MM = parinfo.fbmem_virt;
+	tmpm = mode;
+	tmpc = strsep(&tmpm, "x");
+	default_xres = simple_strtoul(tmpc, NULL, 0);
+	default_yres = simple_strtoul(tmpm, NULL, 0);
+
+	vmode_index = get_mode_index(default_xres, default_yres, 0);
+	DEBUG_MSG(KERN_INFO "0->index=%d\n", vmode_index);
+
+	if (SAMM_ON == 1) {
+		if (strcmp(mode, mode1)) {
+			tmpm_sec = mode1;
+			tmpc_sec = strsep(&tmpm_sec, "x");
+			second_xres = simple_strtoul(tmpc_sec, NULL, 0);
+			second_yres = simple_strtoul(tmpm_sec, NULL, 0);
+		} else {
+			second_xres = default_xres;
+			second_yres = default_yres;
+		}
+		if (0 == second_virtual_xres) {
+			switch (second_xres) {
+			case 1400:
+				second_virtual_xres = 1408;
+				break;
+			default:
+				second_virtual_xres = second_xres;
+				break;
+			}
+		}
+		if (0 == second_virtual_yres)
+			second_virtual_yres = second_yres;
+	}
+
+	switch (via_fb_bpp) {
+	case 0 ... 8:
+		via_fb_bpp = 8;
+		break;
+	case 9 ... 16:
+		via_fb_bpp = 16;
+		break;
+	case 17 ... 32:
+		via_fb_bpp = 32;
+		break;
+	default:
+		via_fb_bpp = 8;
+	}
+	default_var.xres = default_xres;
+	default_var.yres = default_yres;
+	switch (default_xres) {
+	case 1400:
+		default_var.xres_virtual = 1408;
+		break;
+	default:
+		default_var.xres_virtual = default_xres;
+		break;
+	}
+	default_var.yres_virtual = default_yres;
+	default_var.bits_per_pixel = via_fb_bpp;
+	if (default_var.bits_per_pixel == 15)
+		default_var.bits_per_pixel = 16;
+	default_var.pixclock =
+	    get_pixclock(default_xres, default_yres, refresh);
+	default_var.left_margin = (default_xres >> 3) & 0xf8;
+	default_var.right_margin = 32;
+	default_var.upper_margin = 16;
+	default_var.lower_margin = 4;
+	default_var.hsync_len = default_var.left_margin;
+	default_var.vsync_len = 4;
+	default_var.accel_flags = 0;
+
+	viafbinfo.fix.accel = via_fb_accel;
+	parinfo.accel = via_fb_accel;
+	if (via_fb_accel)
+		viafbinfo.flags |=
+		    (FBINFO_HWACCEL_COPYAREA | FBINFO_HWACCEL_FILLRECT |
+		     FBINFO_HWACCEL_IMAGEBLIT);
+	else
+		viafbinfo.flags |= FBINFO_HWACCEL_DISABLED;
+
+	if (dual_fb) {
+		parinfo1 = parinfo;
+		parinfo1.memsize = parinfo.memsize - second_offset;
+		parinfo.memsize = second_offset;
+		parinfo1.fbmem_virt = parinfo.fbmem_virt + second_offset;
+		parinfo1.fbmem = parinfo.fbmem + second_offset;
+
+		parinfo1.fbmem_used = parinfo.fbmem_used;
+		parinfo1.fbmem_free = parinfo1.memsize - parinfo1.fbmem_used;
+		parinfo.fbmem_free = parinfo.memsize;
+		parinfo.fbmem_used = 0;
+		if (via_fb_accel) {
+			parinfo1.cursor_start =
+			    parinfo.cursor_start - second_offset;
+			parinfo1.VQ_start = parinfo.VQ_start - second_offset;
+			parinfo1.VQ_end = parinfo.VQ_end - second_offset;
+		}
+
+		viafbinfo1 = viafbinfo;
+		viafbinfo1.screen_base = viafbinfo.screen_base + second_offset;
+		viafbinfo1.fix.smem_start = parinfo1.fbmem;
+		viafbinfo1.fix.smem_len = parinfo1.fbmem_free;
+		viafbinfo1.par = &parinfo1;
+
+		default_var.xres = second_xres;
+		default_var.yres = second_yres;
+		default_var.xres_virtual = second_virtual_xres;
+		default_var.yres_virtual = second_virtual_yres;
+		if (via_fb_bpp1 != via_fb_bpp)
+			via_fb_bpp1 = via_fb_bpp;
+		default_var.bits_per_pixel = via_fb_bpp1;
+		default_var.pixclock =
+		    get_pixclock(second_xres, second_yres, refresh);
+		default_var.left_margin = (second_xres >> 3) & 0xf8;
+		default_var.right_margin = 32;
+		default_var.upper_margin = 16;
+		default_var.lower_margin = 4;
+		default_var.hsync_len = default_var.left_margin;
+		default_var.vsync_len = 4;
+
+		viafb_check_var(&default_var, &viafbinfo1);
+		parinfo1.var = default_var;
+		viafbinfo1.var = parinfo1.var;
+		viafb_get_fix(&viafbinfo1.fix, &viafbinfo1);
+	}
+
+	viafbinfo.fix.smem_start = parinfo.fbmem;
+	viafbinfo.fix.smem_len = parinfo.fbmem_free;
+	viafb_check_var(&default_var, &viafbinfo);
+	parinfo.var = default_var;
+	viafbinfo.var = parinfo.var;
+	viafb_get_fix(&viafbinfo.fix, &viafbinfo);
+	default_var.activate = FB_ACTIVATE_NOW;
+	viafbinfo.cmap = viafb_256_colors;
+
+	if (dual_fb && (primary_dev == LCD_Device)
+	    && (chip_info.gfx_chip_name == UNICHROME_CLE266)) {
+		if (register_framebuffer(&viafbinfo1) < 0)
+			return -EINVAL;
+	}
+	if (register_framebuffer(&viafbinfo) < 0)
+		return -EINVAL;
+
+	if (dual_fb && ((primary_dev != LCD_Device)
+			|| (chip_info.gfx_chip_name != UNICHROME_CLE266))) {
+		if (register_framebuffer(&viafbinfo1) < 0)
+			return -EINVAL;
+	}
+	DEBUG_MSG(KERN_INFO "fb%d: %s frame buffer device %dx%d-%dbpp\n",
+		  viafbinfo.node, viafbinfo.fix.id, default_var.xres,
+		  default_var.yres, default_var.bits_per_pixel);
+
+	viafb_init_proc(parinfo.proc_entry);
+	init_dac(IGA2);
+	return 0;
+}
+
+static void __devexit via_pci_remove(void)
+{
+	DEBUG_MSG(KERN_INFO "via_pci_remove!\n");
+	unregister_framebuffer(&viafbinfo);
+	if (dual_fb)
+		unregister_framebuffer(&viafbinfo1);
+	iounmap((void *)parinfo.fbmem_virt);
+
+	viafb_remove_proc(parinfo.proc_entry);
+}
+
+int __init viafb_init(void)
+{
+	DEBUG_MSG(KERN_INFO "viafb_init!\n");
+	printk(KERN_INFO
+       "VIA Graphics Intergration Chipset framebuffer %d.%d initializing\n",
+	       VERSION_MAJOR, VERSION_MINOR);
+#ifndef MODULE
+	char *option = NULL;
+	if (fb_get_options("viafb", &option))
+		return -ENODEV;
+	viafb_setup(option);
+#endif
+	return via_pci_probe();
+}
+
+void __exit viafb_exit(void)
+{
+	DEBUG_MSG(KERN_INFO "viafb_exit!\n");
+	if (timer_on) {
+		del_timer(&timer_for3D);
+		timer_on = 0;
+	}
+	via_pci_remove();
+}
+
+int __init viafb_setup(char *options)
+{
+	char *this_opt;
+	DEBUG_MSG(KERN_INFO "viafb_setup!\n");
+
+	if (!options || !*options)
+		return 0;
+
+	while ((this_opt = strsep(&options, ",")) != NULL) {
+		if (!*this_opt)
+			continue;
+
+		if (!strncmp(this_opt, "mode=", 5)) {
+			mode = kmalloc(strlen(this_opt + 4), GFP_KERNEL);
+			strcpy(mode, this_opt + 5);
+		} else if (!strncmp(this_opt, "mode1=", 6)) {
+			mode1 = kmalloc(strlen(this_opt + 5), GFP_KERNEL);
+			strcpy(mode1, this_opt + 6);
+		} else if (!strncmp(this_opt, "bpp=", 4)) {
+			via_fb_bpp = simple_strtoul(this_opt + 4, NULL, 0);
+		} else if (!strncmp(this_opt, "bpp1=", 5)) {
+			via_fb_bpp1 = simple_strtoul(this_opt + 5, NULL, 0);
+		} else if (!strncmp(this_opt, "refresh=", 8)) {
+			refresh = simple_strtoul(this_opt + 8, NULL, 0);
+		} else if (!strncmp(this_opt, "refresh1=", 9)) {
+			refresh1 = simple_strtoul(this_opt + 9, NULL, 0);
+		} else if (!strncmp(this_opt, "lcd_dsp_method=", 15)) {
+			lcd_dsp_method = simple_strtoul(this_opt + 15, NULL, 0);
+		} else if (!strncmp(this_opt, "lcd_panel_id=", 13)) {
+			lcd_panel_id = simple_strtoul(this_opt + 13, NULL, 0);
+		} else if (!strncmp(this_opt, "via_fb_accel=", 6)) {
+			via_fb_accel = simple_strtoul(this_opt + 6, NULL, 0);
+		} else if (!strncmp(this_opt, "SAMM_ON=", 8)) {
+			SAMM_ON = simple_strtoul(this_opt + 8, NULL, 0);
+		} else if (!strncmp(this_opt, "active_dev=", 11)) {
+			active_dev = kmalloc(strlen(this_opt + 10), GFP_KERNEL);
+			strcpy(active_dev, this_opt + 11);
+		} else if (!strncmp(this_opt, "display_hardware_layout=", 24)) {
+			display_hardware_layout =
+			    simple_strtoul(this_opt + 24, NULL, 0);
+		} else if (!strncmp(this_opt, "second_size=", 12)) {
+			second_size = simple_strtoul(this_opt + 12, NULL, 0);
+		} else if (!strncmp(this_opt, "platform_epia_dvi=", 9)) {
+			platform_epia_dvi =
+			    simple_strtoul(this_opt + 9, NULL, 0);
+		} else if (!strncmp(this_opt, "device_lcd_dualedge =", 12)) {
+			device_lcd_dualedge =
+			    simple_strtoul(this_opt + 12, NULL, 0);
+		} else if (!strncmp(this_opt, "via_bus_width=", 9)) {
+			via_bus_width = simple_strtoul(this_opt + 9, NULL, 0);
+		} else if (!strncmp(this_opt, "lcd_mode=", 9)) {
+			lcd_mode = simple_strtoul(this_opt + 9, NULL, 0);
+		} else if (!strncmp(this_opt, "video_dev=", 10)) {
+			video_dev = kmalloc(strlen(this_opt + 9), GFP_KERNEL);
+			strcpy(video_dev, this_opt + 10);
+		} else if (!strncmp(this_opt, "lcd_port=", 9)) {
+			lcd_port = kmalloc(strlen(this_opt + 8), GFP_KERNEL);
+			strcpy(lcd_port, this_opt + 9);
+		}
+	}
+	return 0;
+}
+
+static struct fb_ops viafb_ops = {
+	.owner = THIS_MODULE,
+	.fb_open = viafb_open,
+	.fb_release = viafb_release,
+	.fb_check_var = viafb_check_var,
+	.fb_set_par = viafb_set_par,
+	.fb_setcolreg = viafb_setcolreg,
+	.fb_pan_display = viafb_pan_display,
+	.fb_blank = viafb_blank,
+	.fb_fillrect = viafb_fillrect,
+	.fb_copyarea = viafb_copyarea,
+	.fb_imageblit = viafb_imageblit,
+	.fb_cursor = viafb_cursor,
+	.fb_ioctl = viafb_ioctl,
+	.fb_sync = viafb_sync,
+	.fb_setcmap = viafb_setcmap,
+};
+
+module_init(viafb_init);
+module_exit(viafb_exit);
+
+#ifdef MODULE
+module_param(via_fb_memsize, int, 0);
+
+module_param(mode, charp, 0);
+MODULE_PARM_DESC(mode, "Set resolution (default=640x480)");
+
+module_param(mode1, charp, 0);
+MODULE_PARM_DESC(mode1, "Set resolution (default=640x480)");
+
+module_param(via_fb_bpp, int, 0);
+MODULE_PARM_DESC(via_fb_bpp, "Set color depth (default=32bpp)");
+
+module_param(via_fb_bpp1, int, 0);
+MODULE_PARM_DESC(via_fb_bpp1, "Set color depth (default=32bpp)");
+
+module_param(refresh, int, 0);
+MODULE_PARM_DESC(refresh, "Set CRT refresh rate (default = 60)");
+
+module_param(refresh1, int, 0);
+MODULE_PARM_DESC(refresh1, "Set CRT refresh rate (default = 60)");
+
+module_param(lcd_panel_id, int, 0);
+MODULE_PARM_DESC(lcd_panel_id, "Set Flat Panel type(Default=1024x768)");
+
+module_param(lcd_dsp_method, int, 0);
+MODULE_PARM_DESC(lcd_dsp_method,
+		 "Set Flat Panel display scaling method.(Default=Expandsion)");
+
+module_param(SAMM_ON, int, 0);
+MODULE_PARM_DESC(SAMM_ON, "Turn on/off flag of SAMM(Default=OFF)");
+
+module_param(via_fb_accel, int, 0);
+MODULE_PARM_DESC(via_fb_accel, "Set 2D Hardware Acceleration.(Default = OFF)");
+
+module_param(active_dev, charp, 0);
+MODULE_PARM_DESC(active_dev, "Specify active devices.");
+
+module_param(display_hardware_layout, int, 0);
+MODULE_PARM_DESC(display_hardware_layout,
+		 "Display Hardware Layout (LCD Only, DVI Only...,etc)");
+
+module_param(second_size, int, 0);
+MODULE_PARM_DESC(second_size, "Set secondary device memory size");
+
+module_param(dual_fb, int, 0);
+MODULE_PARM_DESC(dual_fb,
+	"Turn on/off flag of dual framebuffer devices.(Default = OFF)");
+
+module_param(platform_epia_dvi, int, 0);
+MODULE_PARM_DESC(platform_epia_dvi,
+	"Turn on/off flag of DVI devices on EPIA board.(Default = OFF)");
+
+module_param(device_lcd_dualedge, int, 0);
+MODULE_PARM_DESC(device_lcd_dualedge,
+		 "Turn on/off flag of dual edge panel.(Default = OFF)");
+
+module_param(via_bus_width, int, 0);
+MODULE_PARM_DESC(via_bus_width, "Set bus width of panel.(Default = 12)");
+
+module_param(lcd_mode, int, 0);
+MODULE_PARM_DESC(lcd_mode, "Set Flat Panel mode(Default=OPENLDI)");
+
+module_param(video_dev, charp, 0);
+MODULE_PARM_DESC(video_dev, "Specify video devices.");
+
+module_param(lcd_port, charp, 0);
+MODULE_PARM_DESC(lcd_port, "Specify LCD output port.");
+
+module_param(dvi_port, charp, 0);
+MODULE_PARM_DESC(dvi_port, "Specify DVI output port.");
+
+MODULE_LICENSE("GPL");
+#endif
diff -Nur a/drivers/video/via/viafbdev.h b/drivers/video/via/viafbdev.h
--- a/drivers/video/via/viafbdev.h	1969-12-31 19:00:00.000000000 -0500
+++ b/drivers/video/via/viafbdev.h	2008-04-29 04:27:46.000000000 -0400
@@ -0,0 +1,114 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+
+ * This program is free software; you can redistribute it and/or modify
+ * it under  the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
+ * the implied warranty of MERCHANTABILITY or FITNESS FOR
+ * A PARTICULAR PURPOSE.See the GNU General Public License
+ * for more details.
+
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#ifndef __VIAFBDEV_H__
+#define __VIAFBDEV_H__
+
+#include <linux/proc_fs.h>
+#include <linux/fb.h>
+#include "ioctl.h"
+#include "share.h"
+#include "chip.h"
+#include "hw.h"
+
+#define VERSION_MAJOR       2
+#define VERSION_KERNEL      6	/* For kernel 2.6 */
+
+#define VERSION_OS          0	/* 0: for 32 bits OS, 1: for 64 bits OS */
+#define VERSION_MINOR       4
+
+struct viafb_par {
+	struct fb_var_screeninfo var;
+	int bpp;
+	int hres;
+	int vres;
+	int linelength;
+	int vclk;		/*in MHz */
+
+	int vtotal;
+	int vdispend;
+	int vsyncstart;
+	int vsyncend;
+	int vblankstart;
+	int vblankend;
+
+	int htotal;
+	int hdispend;
+	int hsyncstart;
+	int hsyncend;
+	int hblankstart;
+	int hblankend;
+
+	int accel;		/* Acceleration Flags */
+
+	void __iomem *fbmem_virt;	/*framebuffer virtual memory address */
+	void __iomem *io_virt;	/*iospace virtual memory address */
+	unsigned int fbmem;	/*framebuffer physical memory address */
+	unsigned int memsize;	/*size of fbmem */
+	unsigned int io;	/*io space address */
+	unsigned long mmio_base;	/*mmio base address */
+	unsigned long mmio_len;	/*mmio base length */
+	u32 fbmem_free;		/* Free FB memory */
+	u32 fbmem_used;		/* Use FB memory size */
+	u32 cursor_start;	/* Cursor Start Address */
+	u32 VQ_start;		/* Virtual Queue Start Address */
+	u32 VQ_end;		/* Virtual Queue End Address */
+	u32 iga_path;
+	struct proc_dir_entry *proc_entry;	/*viafb proc entry */
+	u8 duoview;		/*Is working in duoview mode? */
+};
+extern unsigned int second_virtual_yres;
+extern unsigned int second_virtual_xres;
+extern unsigned int second_offset;
+extern int second_size;
+extern int SAMM_ON;
+extern int dual_fb;
+extern int LCD2_ON;
+extern int LCD_ON;
+extern int DVI_ON;
+extern int via_fb_accel;
+extern int via_fb_hotplug;
+extern int via_fb_memsize;
+
+extern int soft_cursor(struct fb_info *info, struct fb_cursor *cursor);
+
+void memory_pitch_patch(struct fb_info *info);
+void fill_var_timing_info(struct fb_var_screeninfo *var, int refresh,
+			  int mode_index);
+int apply_device_setting(struct viafb_ioctl_setting ViaSetting,
+			 struct fb_info *info);
+void retrieve_device_setting(struct viafb_ioctl_setting *ViaSetting);
+
+int get_primary_device(void);
+int get_mode_index(int hres, int vres, int flag);
+void viafb_set_device(struct device_t active_dev);
+
+int __init viafb_setup(char *options);
+u8 gpio_i2c_read_lvds(struct lvds_setting_information *plvds_setting_info,
+		      struct lvds_chip_information *plvds_chip_info, u8 index);
+void gpio_i2c_write_mask_lvds(struct lvds_setting_information
+			      *plvds_setting_info, struct lvds_chip_information
+			      *plvds_chip_info, struct IODATA io_data);
+void viafb_set_video_device(u32 video_dev_info);
+void viafb_get_video_device(u32 *video_dev_info);
+void apply_second_mode_setting(struct fb_var_screeninfo *sec_var);
+void init_global_var(void);
+#endif /* __VIAFBDEV_H__ */
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
