Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253Ab0BMWyY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 17:54:24 -0500
Received: from mail.gmx.net ([213.165.64.20]:43052 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758232Ab0BMWyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 17:54:13 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18ILN4oGZgIyI7UYo8eV9JOV08i8OgdJhWHd5MOt7
	ayKYSU/mJFIXWJ
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 4/4] viafb: support color depth 15 and 30
Date: Sat, 13 Feb 2010 23:00:49 +0000
Message-Id: <1266102049-6209-4-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1266102049-6209-3-git-send-email-FlorianSchandinat@gmx.de>
References: <1266102049-6209-1-git-send-email-FlorianSchandinat@gmx.de>
 <1266102049-6209-2-git-send-email-FlorianSchandinat@gmx.de>
 <1266102049-6209-3-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48999999999999999
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: support color depth 15 and 30

This patch adds support for the color depth 15 on IGA1 and 30 on
IGA1 and IGA2. To allow the usage of those the driver now refuses
color depth that are totally off and otherwise the selection in
viafb_check_var is used. Therefore the first call to this for the
first framebuffer was delayed a bit. It only enables the new formats
if they are requested exactly (viafb_bpp=15|30).
As this is a new feature, no regressions are expected. The color
depth 15 was successfully tested. Didn't get anything usable for 30
but that might be the programs fault. I would like to get some
feedback whether it works as expected or not if somebody knows a
program/configuration where it should.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/hw.c       |    9 ++++++++
 drivers/video/via/viafbdev.c |   43 ++++++++++++++++++++++++-----------------
 2 files changed, 34 insertions(+), 18 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 1823253..f2583b1 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -694,12 +694,18 @@ void viafb_set_primary_color_depth(u8 depth)
 	case 8:
 		value = 0x00;
 		break;
+	case 15:
+		value = 0x04;
+		break;
 	case 16:
 		value = 0x14;
 		break;
 	case 24:
 		value = 0x0C;
 		break;
+	case 30:
+		value = 0x08;
+		break;
 	default:
 		printk(KERN_WARNING "viafb_set_primary_color_depth: "
 			"Unsupported depth: %d\n", depth);
@@ -724,6 +730,9 @@ void viafb_set_secondary_color_depth(u8 depth)
 	case 24:
 		value = 0xC0;
 		break;
+	case 30:
+		value = 0x80;
+		break;
 	default:
 		printk(KERN_WARNING "viafb_set_secondary_color_depth: "
 			"Unsupported depth: %d\n", depth);
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 410de33..ce7783b 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -80,6 +80,15 @@ static void viafb_fill_var_color_info(struct fb_var_screeninfo *var, u8 depth)
 		var->green.length = 8;
 		var->blue.length = 8;
 		break;
+	case 15:
+		var->bits_per_pixel = 16;
+		var->red.offset = 10;
+		var->green.offset = 5;
+		var->blue.offset = 0;
+		var->red.length = 5;
+		var->green.length = 5;
+		var->blue.length = 5;
+		break;
 	case 16:
 		var->bits_per_pixel = 16;
 		var->red.offset = 11;
@@ -98,6 +107,15 @@ static void viafb_fill_var_color_info(struct fb_var_screeninfo *var, u8 depth)
 		var->green.length = 8;
 		var->blue.length = 8;
 		break;
+	case 30:
+		var->bits_per_pixel = 32;
+		var->red.offset = 20;
+		var->green.offset = 10;
+		var->blue.offset = 0;
+		var->red.length = 10;
+		var->green.length = 10;
+		var->blue.length = 10;
+		break;
 	}
 }
 
@@ -171,6 +189,10 @@ static int viafb_check_var(struct fb_var_screeninfo *var,
 		return -EINVAL;
 	else if (!depth)
 		depth = 24;
+	else if (depth == 15 && viafb_dual_fb && ppar->iga_path == IGA1)
+		depth = 15;
+	else if (depth == 30)
+		depth = 30;
 	else if (depth <= 8)
 		depth = 8;
 	else if (depth <= 16)
@@ -1811,19 +1833,6 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
 			viafb_second_virtual_yres = viafb_second_yres;
 	}
 
-	switch (viafb_bpp) {
-	case 0 ... 8:
-		viafb_bpp = 8;
-		break;
-	case 9 ... 16:
-		viafb_bpp = 16;
-		break;
-	case 17 ... 32:
-		viafb_bpp = 32;
-		break;
-	default:
-		viafb_bpp = 8;
-	}
 	default_var.xres = default_xres;
 	default_var.yres = default_yres;
 	switch (default_xres) {
@@ -1836,8 +1845,6 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
 	}
 	default_var.yres_virtual = default_yres;
 	default_var.bits_per_pixel = viafb_bpp;
-	if (default_var.bits_per_pixel == 15)
-		default_var.bits_per_pixel = 16;
 	default_var.pixclock =
 	    viafb_get_pixclock(default_xres, default_yres, viafb_refresh);
 	default_var.left_margin = (default_xres >> 3) & 0xf8;
@@ -1847,7 +1854,6 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
 	default_var.hsync_len = default_var.left_margin;
 	default_var.vsync_len = 4;
 	viafb_setup_fixinfo(&viafbinfo->fix, viaparinfo);
-	viafb_check_var(&default_var, viafbinfo);
 	viafbinfo->var = default_var;
 
 	if (viafb_dual_fb) {
@@ -1883,8 +1889,6 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
 		default_var.yres = viafb_second_yres;
 		default_var.xres_virtual = viafb_second_virtual_xres;
 		default_var.yres_virtual = viafb_second_virtual_yres;
-		if (viafb_bpp1 != viafb_bpp)
-			viafb_bpp1 = viafb_bpp;
 		default_var.bits_per_pixel = viafb_bpp1;
 		default_var.pixclock =
 		    viafb_get_pixclock(viafb_second_xres, viafb_second_yres,
@@ -1904,6 +1908,7 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
 			&viafbinfo1->fix);
 	}
 
+	viafb_check_var(&viafbinfo->var, viafbinfo);
 	viafb_update_fix(viafbinfo);
 	viaparinfo->depth = fb_get_color_depth(&viafbinfo->var,
 		&viafbinfo->fix);
@@ -2070,6 +2075,8 @@ static int __init viafb_init(void)
 #endif
 	if (parse_mode(viafb_mode, &dummy, &dummy)
 		|| parse_mode(viafb_mode1, &dummy, &dummy)
+		|| viafb_bpp < 0 || viafb_bpp > 32
+		|| viafb_bpp1 < 0 || viafb_bpp1 > 32
 		|| parse_active_dev())
 		return -EINVAL;
 
-- 
1.6.3.2

