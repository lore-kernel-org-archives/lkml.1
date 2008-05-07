Return-Path: <linux-kernel-owner+w=401wt.eu-S1760248AbYEGLJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248AbYEGLJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 07:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbYEGLJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 07:09:35 -0400
Received: from mailtp.via.com.tw ([61.66.243.2]:1326 "EHLO mailtp.via.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929AbYEGLJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 07:09:32 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: [Linux-fbdev-devel] [PATCH 2/9] viafb: VIA Frame Buffer Device Driver
Date: Wed, 7 May 2008 19:09:28 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F67753@exchtp03.taipei.via.com.tw>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Linux-fbdev-devel] [PATCH 2/9] viafb: VIA Frame Buffer Device Driver
Thread-Index: AciwMtF5zSbYplL7T6eU8PbdHPIqxA==
From: <JosephChan@via.com.tw>
To: <JosephChan@via.com.tw>, <akpm@linux-foundation.org>,
       <geert@linux-m68k.org>
Cc: <linux-fbdev-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 07 May 2008 11:09:30.0178 (UTC) FILETIME=[D237BA20:01C8B032]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m47B9vEB002088

Signed-off-by: Joseph Chan <josephchan@via.com.tw>

diff -Nur a/drivers/video/via/dvi.h b/drivers/video/via/dvi.h
--- a/drivers/video/via/dvi.h	1969-12-31 19:00:00.000000000 -0500
+++ b/drivers/video/via/dvi.h	2008-04-29 02:51:16.000000000 -0400
@@ -0,0 +1,69 @@
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
+#ifndef __DVI_H__
+#define __DVI_H__
+
+/*Definition TMDS Device ID register*/
+#define     VT1632_DEVICE_ID_REG        0x02
+#define     VT1632_DEVICE_ID            0x92
+
+#define     GET_DVI_SIZE_BY_SYSTEM_BIOS     0x01
+#define     GET_DVI_SIZE_BY_VGA_BIOS        0x02
+#define     GET_DVI_SZIE_BY_HW_STRAPPING    0x03
+
+/* Definition DVI Panel ID*/
+/* Resolution: 640x480,   Channel: single, Dithering: Enable */
+#define     DVI_PANEL_ID0_640X480       0x00
+/* Resolution: 800x600,   Channel: single, Dithering: Enable */
+#define     DVI_PANEL_ID1_800x600       0x01
+/* Resolution: 1024x768,  Channel: single, Dithering: Enable */
+#define     DVI_PANEL_ID1_1024x768      0x02
+/* Resolution: 1280x768,  Channel: single, Dithering: Enable */
+#define     DVI_PANEL_ID1_1280x768      0x03
+/* Resolution: 1280x1024, Channel: dual,   Dithering: Enable */
+#define     DVI_PANEL_ID1_1280x1024     0x04
+/* Resolution: 1400x1050, Channel: dual,   Dithering: Enable */
+#define     DVI_PANEL_ID1_1400x1050     0x05
+/* Resolution: 1600x1200, Channel: dual,   Dithering: Enable */
+#define     DVI_PANEL_ID1_1600x1200     0x06
+
+/* Define the version of EDID*/
+#define     EDID_VERSION_1      1
+#define     EDID_VERSION_2      2
+
+#define     DEV_CONNECT_DVI     0x01
+#define     DEV_CONNECT_HDMI    0x02
+
+int check_hdmi_connected_device(void);
+struct VideoModeTable *get_cea_mode_tbl_pointer(int Index);
+int tmds_register_read(int index);
+void tmds_register_write(int index, u8 data);
+int dvi_sense(void);
+int dvi_query_EDID(void);
+unsigned char dvi_get_panel_info(void);
+void dvi_disable(void);
+void dvi_enable(void);
+int tmds_trasmitter_identify(void);
+void init_dvi_size(void);
+void dvi_set_mode(int video_index, int mode_bpp, int set_iga);
+
+#endif /* __DVI_H__ */
diff -Nur a/drivers/video/via/global.c b/drivers/video/via/global.c
--- a/drivers/video/via/global.c	1969-12-31 19:00:00.000000000 -0500
+++ b/drivers/video/via/global.c	2008-04-30 01:38:49.000000000 -0400
@@ -0,0 +1,170 @@
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
+#include "global.h"
+int platform_epia_dvi = STATE_OFF;
+int device_lcd_dualedge = STATE_OFF;
+int via_bus_width = 12;
+int display_hardware_layout = HW_LAYOUT_LCD_DVI;
+int via_fb_memsize;
+int DeviceStatus = CRT_Device;
+int via_fb_hotplug;
+int refresh = 60;
+int lcd_dsp_method = LCD_EXPANDSION;
+int lcd_mode = LCD_OPENLDI;
+int via_fb_bpp = 32;
+int via_fb_bpp1 = 32;
+int via_fb_accel;
+int CRT_ON = 1;
+int DVI_ON ;
+int LCD_ON ;
+int LCD2_ON;
+int SAMM_ON;
+int dual_fb;
+int via_fb_hotplug_Xres = 640;
+int via_fb_hotplug_Yres = 480;
+int via_fb_hotplug_bpp = 32;
+int via_fb_hotplug_refresh = 60;
+unsigned int second_offset;
+int second_size;
+int primary_dev = None_Device;
+void __iomem *FB_MM;
+unsigned int second_xres = 640;
+unsigned int second_yres = 480;
+unsigned int second_virtual_xres;
+unsigned int second_virtual_yres;
+int lcd_panel_id = LCD_PANEL_ID_MAXIMUM + 1;
+struct fb_cursor viacursor;
+struct fb_info viafbinfo1;
+struct tmds_setting_information tmds_setting_info;
+struct crt_setting_information crt_setting_info;
+struct lvds_setting_information lvds_setting_info;
+struct lvds_setting_information lvds_setting_info2;
+struct chip_information chip_info;
+struct viafb_par parinfo;
+struct viafb_par parinfo1;
+struct fb_info viafbinfo;
+u16 red256[] = {
+	0x0, 0x0, 0x0, 0x0, 0xa800, 0xa800, 0xa800, 0xa800, 0x5400, 0x5400,
+	0x5400, 0x5400, 0xfc00, 0xfc00, 0xfc00, 0xfc00,
+	0x0, 0x1400, 0x2000, 0x2c00, 0x3800, 0x4400, 0x5000, 0x6000,
+	0x7000, 0x8000, 0x9000, 0xa000, 0xb400, 0xc800, 0xe000,
+	0xfc00, 0x0, 0x4000, 0x7c00, 0xbc00, 0xfc00, 0xfc00, 0xfc00,
+	0xfc00, 0xfc00, 0xfc00, 0xfc00, 0xfc00, 0xfc00, 0xbc00,
+	0x7c00, 0x4000, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
+	0x7c00, 0x9c00, 0xbc00, 0xdc00, 0xfc00, 0xfc00, 0xfc00,
+	0xfc00, 0xfc00, 0xfc00, 0xfc00, 0xfc00, 0xfc00, 0xdc00,
+	0xbc00, 0x9c00, 0x7c00, 0x7c00, 0x7c00, 0x7c00, 0x7c00,
+	0x7c00, 0x7c00, 0x7c00, 0xb400, 0xc400, 0xd800, 0xe800,
+	0xfc00, 0xfc00, 0xfc00, 0xfc00, 0xfc00, 0xfc00, 0xfc00,
+	0xfc00, 0xfc00, 0xe800, 0xd800, 0xc400, 0xb400, 0xb400,
+	0xb400, 0xb400, 0xb400, 0xb400, 0xb400, 0xb400, 0x0, 0x1c00,
+	0x3800, 0x5400, 0x7000, 0x7000, 0x7000, 0x7000, 0x7000,
+	0x7000, 0x7000, 0x7000, 0x7000, 0x5400, 0x3800, 0x1c00, 0x0,
+	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x3800, 0x4400, 0x5400,
+	0x6000, 0x7000, 0x7000, 0x7000, 0x7000, 0x7000, 0x7000,
+	0x7000, 0x7000, 0x7000, 0x6000, 0x5400, 0x4400, 0x3800,
+	0x3800, 0x3800, 0x3800, 0x3800, 0x3800, 0x3800, 0x3800,
+	0x5000, 0x5800, 0x6000, 0x6800, 0x7000, 0x7000, 0x7000,
+	0x7000, 0x7000, 0x7000, 0x7000, 0x7000, 0x7000, 0x6800,
+	0x6000, 0x5800, 0x5000, 0x5000, 0x5000, 0x5000, 0x5000,
+	0x5000, 0x5000, 0x5000, 0x0, 0x1000, 0x2000, 0x3000, 0x4000,
+	0x4000, 0x4000, 0x4000, 0x4000, 0x4000, 0x4000, 0x4000,
+	0x4000, 0x3000, 0x2000, 0x1000, 0x0, 0x0, 0x0, 0x0, 0x0,
+	0x0, 0x0, 0x0, 0x2000, 0x2800, 0x3000, 0x3800, 0x4000,
+	0x4000, 0x4000, 0x4000, 0x4000, 0x4000, 0x4000, 0x4000,
+	0x4000, 0x3800, 0x3000, 0x2800, 0x2000, 0x2000, 0x2000,
+	0x2000, 0x2000, 0x2000, 0x2000, 0x2000, 0x2c00, 0x3000,
+	0x3400, 0x3c00, 0x4000, 0x4000, 0x4000, 0x4000, 0x4000,
+	0x4000, 0x4000, 0x4000, 0x4000, 0x3c00, 0x3400, 0x3000,
+	0x2c00, 0x2c00, 0x2c00, 0x2c00, 0x2c00, 0x2c00, 0x2c00,
+	0x2c00, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
+};
+u16 green256[] =
+    { 0x0, 0x0, 0xa800, 0xa800, 0x0, 0x0, 0x5400, 0xa800, 0x5400, 0x5400,
+	0xfc00, 0xfc00, 0x5400, 0x5400, 0xfc00, 0xfc00,
+	0x0, 0x1400, 0x2000, 0x2c00, 0x3800, 0x4400, 0x5000, 0x6000,
+	0x7000, 0x8000, 0x9000, 0xa000, 0xb400, 0xc800, 0xe000, 0xfc00,
+	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x7c00, 0xbc00,
+	0xfc00, 0xfc00, 0xfc00, 0xfc00,
+	0xfc00, 0xfc00, 0xfc00, 0xfc00, 0xfc00, 0xbc00, 0x7c00, 0x4000,
+	0x7c00, 0x7c00, 0x7c00, 0x7c00, 0x7c00, 0x7c00, 0x7c00, 0x7c00,
+	0x7c00, 0x9c00, 0xbc00, 0xdc00, 0xfc00, 0xfc00, 0xfc00, 0xfc00,
+	0xfc00, 0xfc00, 0xfc00, 0xfc00, 0xfc00, 0xdc00, 0xbc00, 0x9c00,
+	0xb400, 0xb400, 0xb400, 0xb400, 0xb400, 0xb400, 0xb400, 0xb400,
+	0xb400, 0xc400, 0xd800, 0xe800, 0xfc00, 0xfc00, 0xfc00, 0xfc00,
+	0xfc00, 0xfc00, 0xfc00, 0xfc00, 0xfc00, 0xe800, 0xd800, 0xc400,
+	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
+	0x0, 0x1c00, 0x3800, 0x5400, 0x7000, 0x7000, 0x7000, 0x7000,
+	0x7000, 0x7000, 0x7000, 0x7000, 0x7000, 0x5400, 0x3800, 0x1c00,
+	0x3800, 0x3800, 0x3800, 0x3800, 0x3800, 0x3800, 0x3800, 0x3800,
+	0x3800, 0x4400, 0x5400, 0x6000, 0x7000, 0x7000, 0x7000, 0x7000,
+	0x7000, 0x7000, 0x7000, 0x7000, 0x7000, 0x6000, 0x5400, 0x4400,
+	0x5000, 0x5000, 0x5000, 0x5000, 0x5000, 0x5000, 0x5000, 0x5000,
+	0x5000, 0x5800, 0x6000, 0x6800, 0x7000, 0x7000, 0x7000, 0x7000,
+	0x7000, 0x7000, 0x7000, 0x7000, 0x7000, 0x6800, 0x6000, 0x5800,
+	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1000, 0x2000,
+	0x3000, 0x4000, 0x4000, 0x4000, 0x4000,
+	0x4000, 0x4000, 0x4000, 0x4000, 0x4000, 0x3000, 0x2000, 0x1000,
+	0x2000, 0x2000, 0x2000, 0x2000, 0x2000, 0x2000, 0x2000, 0x2000,
+	0x2000, 0x2800, 0x3000, 0x3800, 0x4000, 0x4000, 0x4000, 0x4000,
+	0x4000, 0x4000, 0x4000, 0x4000, 0x4000, 0x3800, 0x3000, 0x2800,
+	0x2c00, 0x2c00, 0x2c00, 0x2c00, 0x2c00, 0x2c00, 0x2c00, 0x2c00,
+	0x2c00, 0x3000, 0x3400, 0x3c00, 0x4000, 0x4000, 0x4000, 0x4000,
+	0x4000, 0x4000, 0x4000, 0x4000, 0x4000, 0x3c00, 0x3400, 0x3000,
+	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
+};
+u16 blue256[] =
+    { 0x0, 0xa800, 0x0, 0xa800, 0x0, 0xa800, 0x0, 0xa800, 0x5400, 0xfc00,
+	0x5400, 0xfc00, 0x5400, 0xfc00, 0x5400, 0xfc00,
+	0x0, 0x1400, 0x2000, 0x2c00, 0x3800, 0x4400, 0x5000, 0x6000,
+	0x7000, 0x8000, 0x9000, 0xa000, 0xb400, 0xc800, 0xe000, 0xfc00,
+	0xfc00, 0xfc00, 0xfc00, 0xfc00, 0xfc00, 0xbc00, 0x7c00, 0x4000,
+	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
+	0x0, 0x4000, 0x7c00, 0xbc00, 0xfc00, 0xfc00, 0xfc00, 0xfc00,
+	0xfc00, 0xfc00, 0xfc00, 0xfc00, 0xfc00, 0xdc00, 0xbc00, 0x9c00,
+	0x7c00, 0x7c00, 0x7c00, 0x7c00, 0x7c00, 0x7c00, 0x7c00, 0x7c00,
+	0x7c00, 0x9c00, 0xbc00, 0xdc00, 0xfc00, 0xfc00, 0xfc00, 0xfc00,
+	0xfc00, 0xfc00, 0xfc00, 0xfc00, 0xfc00, 0xe800, 0xd800, 0xc400,
+	0xb400, 0xb400, 0xb400, 0xb400, 0xb400, 0xb400, 0xb400, 0xb400,
+	0xb400, 0xc400, 0xd800, 0xe800, 0xfc00, 0xfc00, 0xfc00, 0xfc00,
+	0x7000, 0x7000, 0x7000, 0x7000, 0x7000, 0x5400, 0x3800, 0x1c00,
+	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1c00, 0x3800,
+	0x5400, 0x7000, 0x7000, 0x7000, 0x7000,
+	0x7000, 0x7000, 0x7000, 0x7000, 0x7000, 0x6000, 0x5400, 0x4400,
+	0x3800, 0x3800, 0x3800, 0x3800, 0x3800, 0x3800, 0x3800, 0x3800,
+	0x3800, 0x4400, 0x5400, 0x6000, 0x7000, 0x7000, 0x7000, 0x7000,
+	0x7000, 0x7000, 0x7000, 0x7000, 0x7000, 0x6800, 0x6000, 0x5800,
+	0x5000, 0x5000, 0x5000, 0x5000, 0x5000, 0x5000, 0x5000, 0x5000,
+	0x5000, 0x5800, 0x6000, 0x6800, 0x7000, 0x7000, 0x7000, 0x7000,
+	0x4000, 0x4000, 0x4000, 0x4000, 0x4000, 0x3000, 0x2000, 0x1000,
+	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
+	0x0, 0x1000, 0x2000, 0x3000, 0x4000, 0x4000, 0x4000, 0x4000,
+	0x4000, 0x4000, 0x4000, 0x4000, 0x4000, 0x3800, 0x3000, 0x2800,
+	0x2000, 0x2000, 0x2000, 0x2000, 0x2000, 0x2000, 0x2000, 0x2000,
+	0x2000, 0x2800, 0x3000, 0x3800, 0x4000, 0x4000, 0x4000, 0x4000,
+	0x4000, 0x4000, 0x4000, 0x4000, 0x4000, 0x3c00, 0x3400, 0x3000,
+	0x2c00, 0x2c00, 0x2c00, 0x2c00, 0x2c00, 0x2c00, 0x2c00, 0x2c00,
+	0x2c00, 0x3000, 0x3400, 0x3c00, 0x4000, 0x4000, 0x4000, 0x4000,
+	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
+};
+
+struct fb_cmap viafb_256_colors = { 0, 256, red256, green256, blue256, NULL
+};
diff -Nur a/drivers/video/via/global.h b/drivers/video/via/global.h
--- a/drivers/video/via/global.h	1969-12-31 19:00:00.000000000 -0500
+++ b/drivers/video/via/global.h	2008-05-04 07:06:30.000000000 -0400
@@ -0,0 +1,98 @@
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
+#ifndef __GLOBAL_H__
+#define __GLOBAL_H__
+
+#include <linux/fb.h>
+#include <linux/delay.h>
+#include <linux/ioport.h>
+#include <linux/pci.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+#include <linux/init.h>
+#include <linux/proc_fs.h>
+#include <linux/console.h>
+#include <linux/timer.h>
+
+#include "debug.h"
+
+#include "iface.h"
+#include "viafbdev.h"
+#include "chip.h"
+#include "debug.h"
+#include "accel.h"
+#include "share.h"
+#include "dvi.h"
+#include "viamode.h"
+#include "via_i2c.h"
+#include "hw.h"
+
+#include "lcd.h"
+#include "ioctl.h"
+#include "viamode.h"
+#include "via_utility.h"
+#include "vt1636.h"
+#include "tblDPASetting.h"
+#include "tbl1636.h"
+#include "viafbdev.h"
+
+/* External struct*/
+#define     PORT_ON_AMR       1
+#define     PORT_ON_AGP       2
+
+extern int platform_epia_dvi;
+extern int device_lcd_dualedge;
+extern int via_bus_width;
+extern int display_hardware_layout;
+extern struct tmds_setting_information tmds_setting_info;
+extern struct crt_setting_information crt_setting_info;
+extern struct lvds_setting_information lvds_setting_info;
+extern struct lvds_setting_information lvds_setting_info2;
+extern struct offset offset_reg;
+extern struct chip_information chip_info;
+extern struct viafb_par parinfo;
+extern struct viafb_par parinfo1;
+extern struct fb_info viafbinfo;
+extern int DeviceStatus;
+extern int refresh;
+extern int lcd_dsp_method;
+extern int lcd_mode;
+extern int via_fb_bpp;
+extern int via_fb_bpp1;
+
+extern int CRT_ON;
+extern int via_fb_hotplug_Xres;
+extern int via_fb_hotplug_Yres;
+extern int via_fb_hotplug_bpp;
+extern int via_fb_hotplug_refresh;
+extern int primary_dev;
+extern void __iomem *FB_MM;
+extern struct fb_cursor viacursor;
+
+extern struct fb_cmap viafb_256_colors;
+extern struct fb_info viafbinfo1;
+
+extern unsigned int second_xres;
+extern unsigned int second_yres;
+extern int lcd_panel_id;
+
+#endif /* __GLOBAL_H__ */
diff -Nur a/drivers/video/via/hw.h b/drivers/video/via/hw.h
--- a/drivers/video/via/hw.h	1969-12-31 19:00:00.000000000 -0500
+++ b/drivers/video/via/hw.h	2008-04-29 02:51:18.000000000 -0400
@@ -0,0 +1,950 @@
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
+#ifndef __HW_H__
+#define __HW_H__
+
+#include "global.h"
+
+/***************************************************
+* Definition IGA1 Design Method of CRTC Registers *
+****************************************************/
+#define IGA1_HOR_TOTAL_FORMULA(x)           ((x)/8)-5
+#define IGA1_HOR_ADDR_FORMULA(x)            ((x)/8)-1
+#define IGA1_HOR_BLANK_START_FORMULA(x)     ((x)/8)-1
+#define IGA1_HOR_BLANK_END_FORMULA(x, y)     ((x+y)/8)-1
+#define IGA1_HOR_SYNC_START_FORMULA(x)      ((x)/8)
+#define IGA1_HOR_SYNC_END_FORMULA(x, y)      ((x+y)/8)
+
+#define IGA1_VER_TOTAL_FORMULA(x)           (x)-2
+#define IGA1_VER_ADDR_FORMULA(x)            (x)-1
+#define IGA1_VER_BLANK_START_FORMULA(x)     (x)-1
+#define IGA1_VER_BLANK_END_FORMULA(x, y)     (x+y)-1
+#define IGA1_VER_SYNC_START_FORMULA(x)      (x)-1
+#define IGA1_VER_SYNC_END_FORMULA(x, y)      (x+y)-1
+
+/***************************************************
+** Definition IGA2 Design Method of CRTC Registers *
+****************************************************/
+#define IGA2_HOR_TOTAL_FORMULA(x)           (x)-1
+#define IGA2_HOR_ADDR_FORMULA(x)            (x)-1
+#define IGA2_HOR_BLANK_START_FORMULA(x)     (x)-1
+#define IGA2_HOR_BLANK_END_FORMULA(x, y)     (x+y)-1
+#define IGA2_HOR_SYNC_START_FORMULA(x)      (x)-1
+#define IGA2_HOR_SYNC_END_FORMULA(x, y)      (x+y)-1
+
+#define IGA2_VER_TOTAL_FORMULA(x)           (x)-1
+#define IGA2_VER_ADDR_FORMULA(x)            (x)-1
+#define IGA2_VER_BLANK_START_FORMULA(x)     (x)-1
+#define IGA2_VER_BLANK_END_FORMULA(x, y)     (x+y)-1
+#define IGA2_VER_SYNC_START_FORMULA(x)      (x)-1
+#define IGA2_VER_SYNC_END_FORMULA(x, y)      (x+y)-1
+
+/**********************************************************/
+/* Definition IGA2 Design Method of CRTC Shadow Registers */
+/**********************************************************/
+#define IGA2_HOR_TOTAL_SHADOW_FORMULA(x)           (x/8)-5
+#define IGA2_HOR_BLANK_END_SHADOW_FORMULA(x, y)     ((x+y)/8)-1
+#define IGA2_VER_TOTAL_SHADOW_FORMULA(x)           (x)-2
+#define IGA2_VER_ADDR_SHADOW_FORMULA(x)            (x)-1
+#define IGA2_VER_BLANK_START_SHADOW_FORMULA(x)     (x)-1
+#define IGA2_VER_BLANK_END_SHADOW_FORMULA(x, y)     (x+y)-1
+#define IGA2_VER_SYNC_START_SHADOW_FORMULA(x)      (x)
+#define IGA2_VER_SYNC_END_SHADOW_FORMULA(x, y)      (x+y)
+
+/* Define Register Number for IGA1 CRTC Timing */
+
+/* location: {CR00,0,7},{CR36,3,3} */
+#define IGA1_HOR_TOTAL_REG_NUM		2
+/* location: {CR01,0,7} */
+#define IGA1_HOR_ADDR_REG_NUM		1
+/* location: {CR02,0,7} */
+#define IGA1_HOR_BLANK_START_REG_NUM    1
+/* location: {CR03,0,4},{CR05,7,7},{CR33,5,5} */
+#define IGA1_HOR_BLANK_END_REG_NUM	3
+/* location: {CR04,0,7},{CR33,4,4} */
+#define IGA1_HOR_SYNC_START_REG_NUM	2
+/* location: {CR05,0,4} */
+#define IGA1_HOR_SYNC_END_REG_NUM       1
+/* location: {CR06,0,7},{CR07,0,0},{CR07,5,5},{CR35,0,0} */
+#define IGA1_VER_TOTAL_REG_NUM          4
+/* location: {CR12,0,7},{CR07,1,1},{CR07,6,6},{CR35,2,2} */
+#define IGA1_VER_ADDR_REG_NUM           4
+/* location: {CR15,0,7},{CR07,3,3},{CR09,5,5},{CR35,3,3} */
+#define IGA1_VER_BLANK_START_REG_NUM    4
+/* location: {CR16,0,7} */
+#define IGA1_VER_BLANK_END_REG_NUM      1
+/* location: {CR10,0,7},{CR07,2,2},{CR07,7,7},{CR35,1,1} */
+#define IGA1_VER_SYNC_START_REG_NUM     4
+/* location: {CR11,0,3} */
+#define IGA1_VER_SYNC_END_REG_NUM       1
+
+/* Define Register Number for IGA2 Shadow CRTC Timing */
+
+/* location: {CR6D,0,7},{CR71,3,3} */
+#define IGA2_SHADOW_HOR_TOTAL_REG_NUM       2
+/* location: {CR6E,0,7} */
+#define IGA2_SHADOW_HOR_BLANK_END_REG_NUM   1
+/* location: {CR6F,0,7},{CR71,0,2} */
+#define IGA2_SHADOW_VER_TOTAL_REG_NUM       2
+/* location: {CR70,0,7},{CR71,4,6} */
+#define IGA2_SHADOW_VER_ADDR_REG_NUM        2
+/* location: {CR72,0,7},{CR74,4,6} */
+#define IGA2_SHADOW_VER_BLANK_START_REG_NUM 2
+/* location: {CR73,0,7},{CR74,0,2} */
+#define IGA2_SHADOW_VER_BLANK_END_REG_NUM   2
+/* location: {CR75,0,7},{CR76,4,6} */
+#define IGA2_SHADOW_VER_SYNC_START_REG_NUM  2
+/* location: {CR76,0,3} */
+#define IGA2_SHADOW_VER_SYNC_END_REG_NUM    1
+
+/* Define Register Number for IGA2 CRTC Timing */
+
+/* location: {CR50,0,7},{CR55,0,3} */
+#define IGA2_HOR_TOTAL_REG_NUM          2
+/* location: {CR51,0,7},{CR55,4,6} */
+#define IGA2_HOR_ADDR_REG_NUM           2
+/* location: {CR52,0,7},{CR54,0,2} */
+#define IGA2_HOR_BLANK_START_REG_NUM    2
+/* location: CLE266: {CR53,0,7},{CR54,3,5} => CLE266's CR5D[6]
+is reserved, so it may have problem to set 1600x1200 on IGA2. */
+/*         	Others: {CR53,0,7},{CR54,3,5},{CR5D,6,6} */
+#define IGA2_HOR_BLANK_END_REG_NUM      3
+/* location: {CR56,0,7},{CR54,6,7},{CR5C,7,7} */
+/* VT3314 and Later: {CR56,0,7},{CR54,6,7},{CR5C,7,7}, {CR5D,7,7} */
+#define IGA2_HOR_SYNC_START_REG_NUM     4
+
+/* location: {CR57,0,7},{CR5C,6,6} */
+#define IGA2_HOR_SYNC_END_REG_NUM       2
+/* location: {CR58,0,7},{CR5D,0,2} */
+#define IGA2_VER_TOTAL_REG_NUM          2
+/* location: {CR59,0,7},{CR5D,3,5} */
+#define IGA2_VER_ADDR_REG_NUM           2
+/* location: {CR5A,0,7},{CR5C,0,2} */
+#define IGA2_VER_BLANK_START_REG_NUM    2
+/* location: {CR5E,0,7},{CR5C,3,5} */
+#define IGA2_VER_BLANK_END_REG_NUM      2
+/* location: {CR5E,0,7},{CR5F,5,7} */
+#define IGA2_VER_SYNC_START_REG_NUM     2
+/* location: {CR5F,0,4} */
+#define IGA2_VER_SYNC_END_REG_NUM       1
+
+/* Define Offset and Fetch Count Register*/
+
+/* location: {CR13,0,7},{CR35,5,7} */
+#define IGA1_OFFSET_REG_NUM             2
+/* 8 bytes alignment. */
+#define IGA1_OFFSER_ALIGN_BYTE          8
+/* x: H resolution, y: color depth */
+#define IGA1_OFFSET_FORMULA(x, y)        (x*y)/IGA1_OFFSER_ALIGN_BYTE
+/* location: {SR1C,0,7},{SR1D,0,1} */
+#define IGA1_FETCH_COUNT_REG_NUM        2
+/* 16 bytes alignment. */
+#define IGA1_FETCH_COUNT_ALIGN_BYTE     16
+/* x: H resolution, y: color depth */
+#define IGA1_FETCH_COUNT_PATCH_VALUE    4
+#define IGA1_FETCH_COUNT_FORMULA(x, y)   \
+	((x*y)/IGA1_FETCH_COUNT_ALIGN_BYTE) + IGA1_FETCH_COUNT_PATCH_VALUE
+
+/* location: {CR66,0,7},{CR67,0,1} */
+#define IGA2_OFFSET_REG_NUM             2
+#define IGA2_OFFSET_ALIGN_BYTE          8
+/* x: H resolution, y: color depth */
+#define IGA2_OFFSET_FORMULA(x, y)        (x*y)/IGA2_OFFSET_ALIGN_BYTE
+/* location: {CR65,0,7},{CR67,2,3} */
+#define IGA2_FETCH_COUNT_REG_NUM        2
+#define IGA2_FETCH_COUNT_ALIGN_BYTE     16
+#define IGA2_FETCH_COUNT_PATCH_VALUE    0
+#define IGA2_FETCH_COUNT_FORMULA(x, y)   \
+	((x*y)/IGA2_FETCH_COUNT_ALIGN_BYTE) + IGA2_FETCH_COUNT_PATCH_VALUE
+
+/* Staring Address*/
+
+/* location: {CR0C,0,7},{CR0D,0,7},{CR34,0,7},{CR48,0,1} */
+#define IGA1_STARTING_ADDR_REG_NUM      4
+/* location: {CR62,1,7},{CR63,0,7},{CR64,0,7} */
+#define IGA2_STARTING_ADDR_REG_NUM      3
+
+/* Define Display OFFSET*/
+/* These value are by HW suggested value*/
+/* location: {SR17,0,7} */
+#define K800_IGA1_FIFO_MAX_DEPTH                384
+/* location: {SR16,0,5},{SR16,7,7} */
+#define K800_IGA1_FIFO_THRESHOLD                328
+/* location: {SR18,0,5},{SR18,7,7} */
+#define K800_IGA1_FIFO_HIGH_THRESHOLD           296
+/* location: {SR22,0,4}. (128/4) =64, K800 must be set zero, */
+				/* because HW only 5 bits */
+#define K800_IGA1_DISPLAY_QUEUE_EXPIRE_NUM      0
+
+/* location: {CR68,4,7},{CR94,7,7},{CR95,7,7} */
+#define K800_IGA2_FIFO_MAX_DEPTH                384
+/* location: {CR68,0,3},{CR95,4,6} */
+#define K800_IGA2_FIFO_THRESHOLD                328
+/* location: {CR92,0,3},{CR95,0,2} */
+#define K800_IGA2_FIFO_HIGH_THRESHOLD           296
+/* location: {CR94,0,6} */
+#define K800_IGA2_DISPLAY_QUEUE_EXPIRE_NUM      128
+
+/* location: {SR17,0,7} */
+#define P880_IGA1_FIFO_MAX_DEPTH                192
+/* location: {SR16,0,5},{SR16,7,7} */
+#define P880_IGA1_FIFO_THRESHOLD                128
+/* location: {SR18,0,5},{SR18,7,7} */
+#define P880_IGA1_FIFO_HIGH_THRESHOLD           64
+/* location: {SR22,0,4}. (128/4) =64, K800 must be set zero, */
+				/* because HW only 5 bits */
+#define P880_IGA1_DISPLAY_QUEUE_EXPIRE_NUM      0
+
+/* location: {CR68,4,7},{CR94,7,7},{CR95,7,7} */
+#define P880_IGA2_FIFO_MAX_DEPTH                96
+/* location: {CR68,0,3},{CR95,4,6} */
+#define P880_IGA2_FIFO_THRESHOLD                64
+/* location: {CR92,0,3},{CR95,0,2} */
+#define P880_IGA2_FIFO_HIGH_THRESHOLD           32
+/* location: {CR94,0,6} */
+#define P880_IGA2_DISPLAY_QUEUE_EXPIRE_NUM      128
+
+/* VT3314 chipset*/
+
+/* location: {SR17,0,7} */
+#define CN700_IGA1_FIFO_MAX_DEPTH               96
+/* location: {SR16,0,5},{SR16,7,7} */
+#define CN700_IGA1_FIFO_THRESHOLD               80
+/* location: {SR18,0,5},{SR18,7,7} */
+#define CN700_IGA1_FIFO_HIGH_THRESHOLD          64
+/* location: {SR22,0,4}. (128/4) =64, P800 must be set zero,
+				because HW only 5 bits */
+#define CN700_IGA1_DISPLAY_QUEUE_EXPIRE_NUM     0
+/* location: {CR68,4,7},{CR94,7,7},{CR95,7,7} */
+#define CN700_IGA2_FIFO_MAX_DEPTH               96
+/* location: {CR68,0,3},{CR95,4,6} */
+#define CN700_IGA2_FIFO_THRESHOLD               80
+/* location: {CR92,0,3},{CR95,0,2} */
+#define CN700_IGA2_FIFO_HIGH_THRESHOLD          32
+/* location: {CR94,0,6} */
+#define CN700_IGA2_DISPLAY_QUEUE_EXPIRE_NUM     128
+
+/* For VT3324, these values are suggested by HW */
+/* location: {SR17,0,7} */
+#define CX700_IGA1_FIFO_MAX_DEPTH               192
+/* location: {SR16,0,5},{SR16,7,7} */
+#define CX700_IGA1_FIFO_THRESHOLD               128
+/* location: {SR18,0,5},{SR18,7,7} */
+#define CX700_IGA1_FIFO_HIGH_THRESHOLD          128
+/* location: {SR22,0,4} */
+#define CX700_IGA1_DISPLAY_QUEUE_EXPIRE_NUM     124
+
+/* location: {CR68,4,7},{CR94,7,7},{CR95,7,7} */
+#define CX700_IGA2_FIFO_MAX_DEPTH               96
+/* location: {CR68,0,3},{CR95,4,6} */
+#define CX700_IGA2_FIFO_THRESHOLD               64
+/* location: {CR92,0,3},{CR95,0,2} */
+#define CX700_IGA2_FIFO_HIGH_THRESHOLD          32
+/* location: {CR94,0,6} */
+#define CX700_IGA2_DISPLAY_QUEUE_EXPIRE_NUM     128
+
+/* VT3336 chipset*/
+/* location: {SR17,0,7} */
+#define K8M890_IGA1_FIFO_MAX_DEPTH               360
+/* location: {SR16,0,5},{SR16,7,7} */
+#define K8M890_IGA1_FIFO_THRESHOLD               328
+/* location: {SR18,0,5},{SR18,7,7} */
+#define K8M890_IGA1_FIFO_HIGH_THRESHOLD          296
+/* location: {SR22,0,4}. */
+#define K8M890_IGA1_DISPLAY_QUEUE_EXPIRE_NUM     124
+
+/* location: {CR68,4,7},{CR94,7,7},{CR95,7,7} */
+#define K8M890_IGA2_FIFO_MAX_DEPTH               360
+/* location: {CR68,0,3},{CR95,4,6} */
+#define K8M890_IGA2_FIFO_THRESHOLD               328
+/* location: {CR92,0,3},{CR95,0,2} */
+#define K8M890_IGA2_FIFO_HIGH_THRESHOLD          296
+/* location: {CR94,0,6} */
+#define K8M890_IGA2_DISPLAY_QUEUE_EXPIRE_NUM     124
+
+/* VT3327 chipset*/
+/* location: {SR17,0,7} */
+#define P4M890_IGA1_FIFO_MAX_DEPTH               96
+/* location: {SR16,0,5},{SR16,7,7} */
+#define P4M890_IGA1_FIFO_THRESHOLD               76
+/* location: {SR18,0,5},{SR18,7,7} */
+#define P4M890_IGA1_FIFO_HIGH_THRESHOLD          64
+/* location: {SR22,0,4}. (32/4) =8 */
+#define P4M890_IGA1_DISPLAY_QUEUE_EXPIRE_NUM     32
+/* location: {CR68,4,7},{CR94,7,7},{CR95,7,7} */
+#define P4M890_IGA2_FIFO_MAX_DEPTH               96
+/* location: {CR68,0,3},{CR95,4,6} */
+#define P4M890_IGA2_FIFO_THRESHOLD               76
+/* location: {CR92,0,3},{CR95,0,2} */
+#define P4M890_IGA2_FIFO_HIGH_THRESHOLD          64
+/* location: {CR94,0,6} */
+#define P4M890_IGA2_DISPLAY_QUEUE_EXPIRE_NUM     32
+
+/* VT3364 chipset*/
+/* location: {SR17,0,7} */
+#define P4M900_IGA1_FIFO_MAX_DEPTH               96
+/* location: {SR16,0,5},{SR16,7,7} */
+#define P4M900_IGA1_FIFO_THRESHOLD               76
+/* location: {SR18,0,5},{SR18,7,7} */
+#define P4M900_IGA1_FIFO_HIGH_THRESHOLD          76
+/* location: {SR22,0,4}. */
+#define P4M900_IGA1_DISPLAY_QUEUE_EXPIRE_NUM     32
+/* location: {CR68,4,7},{CR94,7,7},{CR95,7,7} */
+#define P4M900_IGA2_FIFO_MAX_DEPTH               96
+/* location: {CR68,0,3},{CR95,4,6} */
+#define P4M900_IGA2_FIFO_THRESHOLD               76
+/* location: {CR92,0,3},{CR95,0,2} */
+#define P4M900_IGA2_FIFO_HIGH_THRESHOLD          76
+/* location: {CR94,0,6} */
+#define P4M900_IGA2_DISPLAY_QUEUE_EXPIRE_NUM     32
+
+/* For VT3353, these values are suggested by HW */
+/* location: {SR17,0,7} */
+#define VX800_IGA1_FIFO_MAX_DEPTH               192
+/* location: {SR16,0,5},{SR16,7,7} */
+#define VX800_IGA1_FIFO_THRESHOLD               152
+/* location: {SR18,0,5},{SR18,7,7} */
+#define VX800_IGA1_FIFO_HIGH_THRESHOLD          152
+/* location: {SR22,0,4} */
+#define VX800_IGA1_DISPLAY_QUEUE_EXPIRE_NUM      64
+/* location: {CR68,4,7},{CR94,7,7},{CR95,7,7} */
+#define VX800_IGA2_FIFO_MAX_DEPTH               96
+/* location: {CR68,0,3},{CR95,4,6} */
+#define VX800_IGA2_FIFO_THRESHOLD               64
+/* location: {CR92,0,3},{CR95,0,2} */
+#define VX800_IGA2_FIFO_HIGH_THRESHOLD          32
+/* location: {CR94,0,6} */
+#define VX800_IGA2_DISPLAY_QUEUE_EXPIRE_NUM     128
+
+#define IGA1_FIFO_DEPTH_SELECT_REG_NUM          1
+#define IGA1_FIFO_THRESHOLD_REG_NUM             2
+#define IGA1_FIFO_HIGH_THRESHOLD_REG_NUM        2
+#define IGA1_DISPLAY_QUEUE_EXPIRE_NUM_REG_NUM   1
+
+#define IGA2_FIFO_DEPTH_SELECT_REG_NUM          3
+#define IGA2_FIFO_THRESHOLD_REG_NUM             2
+#define IGA2_FIFO_HIGH_THRESHOLD_REG_NUM        2
+#define IGA2_DISPLAY_QUEUE_EXPIRE_NUM_REG_NUM   1
+
+#define IGA1_FIFO_DEPTH_SELECT_FORMULA(x)                   (x/2)-1
+#define IGA1_FIFO_THRESHOLD_FORMULA(x)                      (x/4)
+#define IGA1_DISPLAY_QUEUE_EXPIRE_NUM_FORMULA(x)            (x/4)
+#define IGA1_FIFO_HIGH_THRESHOLD_FORMULA(x)                 (x/4)
+#define IGA2_FIFO_DEPTH_SELECT_FORMULA(x)                   ((x/2)/4)-1
+#define IGA2_FIFO_THRESHOLD_FORMULA(x)                      (x/4)
+#define IGA2_DISPLAY_QUEUE_EXPIRE_NUM_FORMULA(x)            (x/4)
+#define IGA2_FIFO_HIGH_THRESHOLD_FORMULA(x)                 (x/4)
+
+/************************************************************************/
+/*  LCD Timing                                                          */
+/************************************************************************/
+
+/* 500 ms = 500000 us */
+#define LCD_POWER_SEQ_TD0               500000
+/* 50 ms = 50000 us */
+#define LCD_POWER_SEQ_TD1               50000
+/* 0 us */
+#define LCD_POWER_SEQ_TD2               0
+/* 210 ms = 210000 us */
+#define LCD_POWER_SEQ_TD3               210000
+/* 2^10 * (1/14.31818M) = 71.475 us (K400.revA) */
+#define CLE266_POWER_SEQ_UNIT           71
+/* 2^11 * (1/14.31818M) = 142.95 us (K400.revB) */
+#define K800_POWER_SEQ_UNIT             142
+/* 2^13 * (1/14.31818M) = 572.1 us */
+#define P880_POWER_SEQ_UNIT             572
+
+#define CLE266_POWER_SEQ_FORMULA(x)     (x)/CLE266_POWER_SEQ_UNIT
+#define K800_POWER_SEQ_FORMULA(x)       (x)/K800_POWER_SEQ_UNIT
+#define P880_POWER_SEQ_FORMULA(x)       (x)/P880_POWER_SEQ_UNIT
+
+/* location: {CR8B,0,7},{CR8F,0,3} */
+#define LCD_POWER_SEQ_TD0_REG_NUM       2
+/* location: {CR8C,0,7},{CR8F,4,7} */
+#define LCD_POWER_SEQ_TD1_REG_NUM       2
+/* location: {CR8D,0,7},{CR90,0,3} */
+#define LCD_POWER_SEQ_TD2_REG_NUM       2
+/* location: {CR8E,0,7},{CR90,4,7} */
+#define LCD_POWER_SEQ_TD3_REG_NUM       2
+
+/* LCD Scaling factor*/
+/* x: indicate setting horizontal size*/
+/* y: indicate panel horizontal size*/
+
+/* Horizontal scaling factor 10 bits (2^10) */
+#define CLE266_LCD_HOR_SCF_FORMULA(x, y)   (((x-1)*1024)/(y-1))
+/* Vertical scaling factor 10 bits (2^10) */
+#define CLE266_LCD_VER_SCF_FORMULA(x, y)   (((x-1)*1024)/(y-1))
+/* Horizontal scaling factor 10 bits (2^12) */
+#define K800_LCD_HOR_SCF_FORMULA(x, y)     (((x-1)*4096)/(y-1))
+/* Vertical scaling factor 10 bits (2^11) */
+#define K800_LCD_VER_SCF_FORMULA(x, y)     (((x-1)*2048)/(y-1))
+
+/* location: {CR9F,0,1},{CR77,0,7},{CR79,4,5} */
+#define LCD_HOR_SCALING_FACTOR_REG_NUM  3
+/* location: {CR79,3,3},{CR78,0,7},{CR79,6,7} */
+#define LCD_VER_SCALING_FACTOR_REG_NUM  3
+/* location: {CR77,0,7},{CR79,4,5} */
+#define LCD_HOR_SCALING_FACTOR_REG_NUM_CLE  2
+/* location: {CR78,0,7},{CR79,6,7} */
+#define LCD_VER_SCALING_FACTOR_REG_NUM_CLE  2
+
+/************************************************
+ *****     Define IGA1 Display Timing       *****
+ ************************************************/
+struct io_register {
+	u8 io_addr;
+	u8 start_bit;
+	u8 end_bit;
+};
+
+/* IGA1 Horizontal Total */
+struct iga1_hor_total {
+	int reg_num;
+	struct io_register reg[IGA1_HOR_TOTAL_REG_NUM];
+};
+
+/* IGA1 Horizontal Addressable Video */
+struct iga1_hor_addr {
+	int reg_num;
+	struct io_register reg[IGA1_HOR_ADDR_REG_NUM];
+};
+
+/* IGA1 Horizontal Blank Start */
+struct iga1_hor_blank_start {
+	int reg_num;
+	struct io_register reg[IGA1_HOR_BLANK_START_REG_NUM];
+};
+
+/* IGA1 Horizontal Blank End */
+struct iga1_hor_blank_end {
+	int reg_num;
+	struct io_register reg[IGA1_HOR_BLANK_END_REG_NUM];
+};
+
+/* IGA1 Horizontal Sync Start */
+struct iga1_hor_sync_start {
+	int reg_num;
+	struct io_register reg[IGA1_HOR_SYNC_START_REG_NUM];
+};
+
+/* IGA1 Horizontal Sync End */
+struct iga1_hor_sync_end {
+	int reg_num;
+	struct io_register reg[IGA1_HOR_SYNC_END_REG_NUM];
+};
+
+/* IGA1 Vertical Total */
+struct iga1_ver_total {
+	int reg_num;
+	struct io_register reg[IGA1_VER_TOTAL_REG_NUM];
+};
+
+/* IGA1 Vertical Addressable Video */
+struct iga1_ver_addr {
+	int reg_num;
+	struct io_register reg[IGA1_VER_ADDR_REG_NUM];
+};
+
+/* IGA1 Vertical Blank Start */
+struct iga1_ver_blank_start {
+	int reg_num;
+	struct io_register reg[IGA1_VER_BLANK_START_REG_NUM];
+};
+
+/* IGA1 Vertical Blank End */
+struct iga1_ver_blank_end {
+	int reg_num;
+	struct io_register reg[IGA1_VER_BLANK_END_REG_NUM];
+};
+
+/* IGA1 Vertical Sync Start */
+struct iga1_ver_sync_start {
+	int reg_num;
+	struct io_register reg[IGA1_VER_SYNC_START_REG_NUM];
+};
+
+/* IGA1 Vertical Sync End */
+struct iga1_ver_sync_end {
+	int reg_num;
+	struct io_register reg[IGA1_VER_SYNC_END_REG_NUM];
+};
+
+/*****************************************************
+**      Define IGA2 Shadow Display Timing         ****
+*****************************************************/
+
+/* IGA2 Shadow Horizontal Total */
+struct iga2_shadow_hor_total {
+	int reg_num;
+	struct io_register reg[IGA2_SHADOW_HOR_TOTAL_REG_NUM];
+};
+
+/* IGA2 Shadow Horizontal Blank End */
+struct iga2_shadow_hor_blank_end {
+	int reg_num;
+	struct io_register reg[IGA2_SHADOW_HOR_BLANK_END_REG_NUM];
+};
+
+/* IGA2 Shadow Vertical Total */
+struct iga2_shadow_ver_total {
+	int reg_num;
+	struct io_register reg[IGA2_SHADOW_VER_TOTAL_REG_NUM];
+};
+
+/* IGA2 Shadow Vertical Addressable Video */
+struct iga2_shadow_ver_addr {
+	int reg_num;
+	struct io_register reg[IGA2_SHADOW_VER_ADDR_REG_NUM];
+};
+
+/* IGA2 Shadow Vertical Blank Start */
+struct iga2_shadow_ver_blank_start {
+	int reg_num;
+	struct io_register reg[IGA2_SHADOW_VER_BLANK_START_REG_NUM];
+};
+
+/* IGA2 Shadow Vertical Blank End */
+struct iga2_shadow_ver_blank_end {
+	int reg_num;
+	struct io_register reg[IGA2_SHADOW_VER_BLANK_END_REG_NUM];
+};
+
+/* IGA2 Shadow Vertical Sync Start */
+struct iga2_shadow_ver_sync_start {
+	int reg_num;
+	struct io_register reg[IGA2_SHADOW_VER_SYNC_START_REG_NUM];
+};
+
+/* IGA2 Shadow Vertical Sync End */
+struct iga2_shadow_ver_sync_end {
+	int reg_num;
+	struct io_register reg[IGA2_SHADOW_VER_SYNC_END_REG_NUM];
+};
+
+/*****************************************************
+**      Define IGA2 Display Timing                ****
+******************************************************/
+
+/* IGA2 Horizontal Total */
+struct iga2_hor_total {
+	int reg_num;
+	struct io_register reg[IGA2_HOR_TOTAL_REG_NUM];
+};
+
+/* IGA2 Horizontal Addressable Video */
+struct iga2_hor_addr {
+	int reg_num;
+	struct io_register reg[IGA2_HOR_ADDR_REG_NUM];
+};
+
+/* IGA2 Horizontal Blank Start */
+struct iga2_hor_blank_start {
+	int reg_num;
+	struct io_register reg[IGA2_HOR_BLANK_START_REG_NUM];
+};
+
+/* IGA2 Horizontal Blank End */
+struct iga2_hor_blank_end {
+	int reg_num;
+	struct io_register reg[IGA2_HOR_BLANK_END_REG_NUM];
+};
+
+/* IGA2 Horizontal Sync Start */
+struct iga2_hor_sync_start {
+	int reg_num;
+	struct io_register reg[IGA2_HOR_SYNC_START_REG_NUM];
+};
+
+/* IGA2 Horizontal Sync End */
+struct iga2_hor_sync_end {
+	int reg_num;
+	struct io_register reg[IGA2_HOR_SYNC_END_REG_NUM];
+};
+
+/* IGA2 Vertical Total */
+struct iga2_ver_total {
+	int reg_num;
+	struct io_register reg[IGA2_VER_TOTAL_REG_NUM];
+};
+
+/* IGA2 Vertical Addressable Video */
+struct iga2_ver_addr {
+	int reg_num;
+	struct io_register reg[IGA2_VER_ADDR_REG_NUM];
+};
+
+/* IGA2 Vertical Blank Start */
+struct iga2_ver_blank_start {
+	int reg_num;
+	struct io_register reg[IGA2_VER_BLANK_START_REG_NUM];
+};
+
+/* IGA2 Vertical Blank End */
+struct iga2_ver_blank_end {
+	int reg_num;
+	struct io_register reg[IGA2_VER_BLANK_END_REG_NUM];
+};
+
+/* IGA2 Vertical Sync Start */
+struct iga2_ver_sync_start {
+	int reg_num;
+	struct io_register reg[IGA2_VER_SYNC_START_REG_NUM];
+};
+
+/* IGA2 Vertical Sync End */
+struct iga2_ver_sync_end {
+	int reg_num;
+	struct io_register reg[IGA2_VER_SYNC_END_REG_NUM];
+};
+
+/* IGA1 Offset Register */
+struct iga1_offset {
+	int reg_num;
+	struct io_register reg[IGA1_OFFSET_REG_NUM];
+};
+
+/* IGA2 Offset Register */
+struct iga2_offset {
+	int reg_num;
+	struct io_register reg[IGA2_OFFSET_REG_NUM];
+};
+
+struct offset {
+	struct iga1_offset iga1_offset_reg;
+	struct iga2_offset iga2_offset_reg;
+};
+
+/* IGA1 Fetch Count Register */
+struct iga1_fetch_count {
+	int reg_num;
+	struct io_register reg[IGA1_FETCH_COUNT_REG_NUM];
+};
+
+/* IGA2 Fetch Count Register */
+struct iga2_fetch_count {
+	int reg_num;
+	struct io_register reg[IGA2_FETCH_COUNT_REG_NUM];
+};
+
+struct fetch_count {
+	struct iga1_fetch_count iga1_fetch_count_reg;
+	struct iga2_fetch_count iga2_fetch_count_reg;
+};
+
+/* Starting Address Register */
+struct iga1_starting_addr {
+	int reg_num;
+	struct io_register reg[IGA1_STARTING_ADDR_REG_NUM];
+};
+
+struct iga2_starting_addr {
+	int reg_num;
+	struct io_register reg[IGA2_STARTING_ADDR_REG_NUM];
+};
+
+struct starting_addr {
+	struct iga1_starting_addr iga1_starting_addr_reg;
+	struct iga2_starting_addr iga2_starting_addr_reg;
+};
+
+/* LCD Power Sequence Timer */
+struct lcd_pwd_seq_td0 {
+	int reg_num;
+	struct io_register reg[LCD_POWER_SEQ_TD0_REG_NUM];
+};
+
+struct lcd_pwd_seq_td1 {
+	int reg_num;
+	struct io_register reg[LCD_POWER_SEQ_TD1_REG_NUM];
+};
+
+struct lcd_pwd_seq_td2 {
+	int reg_num;
+	struct io_register reg[LCD_POWER_SEQ_TD2_REG_NUM];
+};
+
+struct lcd_pwd_seq_td3 {
+	int reg_num;
+	struct io_register reg[LCD_POWER_SEQ_TD3_REG_NUM];
+};
+
+struct _lcd_pwd_seq_timer {
+	struct lcd_pwd_seq_td0 td0;
+	struct lcd_pwd_seq_td1 td1;
+	struct lcd_pwd_seq_td2 td2;
+	struct lcd_pwd_seq_td3 td3;
+};
+
+/* LCD Scaling Factor */
+struct _lcd_hor_scaling_factor {
+	int reg_num;
+	struct io_register reg[LCD_HOR_SCALING_FACTOR_REG_NUM];
+};
+
+struct _lcd_ver_scaling_factor {
+	int reg_num;
+	struct io_register reg[LCD_VER_SCALING_FACTOR_REG_NUM];
+};
+
+struct _lcd_scaling_factor {
+	struct _lcd_hor_scaling_factor lcd_hor_scaling_factor;
+	struct _lcd_ver_scaling_factor lcd_ver_scaling_factor;
+};
+
+struct pll_map {
+	u32 clk;
+	u32 cle266_pll;
+	u32 k800_pll;
+	u32 cx700_pll;
+};
+
+struct rgbLUT {
+	u8 red;
+	u8 green;
+	u8 blue;
+};
+
+struct lcd_pwd_seq_timer {
+	u16 td0;
+	u16 td1;
+	u16 td2;
+	u16 td3;
+};
+
+/* Display FIFO Relation Registers*/
+struct iga1_fifo_depth_select {
+	int reg_num;
+	struct io_register reg[IGA1_FIFO_DEPTH_SELECT_REG_NUM];
+};
+
+struct iga1_fifo_threshold_select {
+	int reg_num;
+	struct io_register reg[IGA1_FIFO_THRESHOLD_REG_NUM];
+};
+
+struct iga1_fifo_high_threshold_select {
+	int reg_num;
+	struct io_register reg[IGA1_FIFO_HIGH_THRESHOLD_REG_NUM];
+};
+
+struct iga1_display_queue_expire_num {
+	int reg_num;
+	struct io_register reg[IGA1_DISPLAY_QUEUE_EXPIRE_NUM_REG_NUM];
+};
+
+struct iga2_fifo_depth_select {
+	int reg_num;
+	struct io_register reg[IGA2_FIFO_DEPTH_SELECT_REG_NUM];
+};
+
+struct iga2_fifo_threshold_select {
+	int reg_num;
+	struct io_register reg[IGA2_FIFO_THRESHOLD_REG_NUM];
+};
+
+struct iga2_fifo_high_threshold_select {
+	int reg_num;
+	struct io_register reg[IGA2_FIFO_HIGH_THRESHOLD_REG_NUM];
+};
+
+struct iga2_display_queue_expire_num {
+	int reg_num;
+	struct io_register reg[IGA2_DISPLAY_QUEUE_EXPIRE_NUM_REG_NUM];
+};
+
+struct fifo_depth_select {
+	struct iga1_fifo_depth_select iga1_fifo_depth_select_reg;
+	struct iga2_fifo_depth_select iga2_fifo_depth_select_reg;
+};
+
+struct fifo_threshold_select {
+	struct iga1_fifo_threshold_select iga1_fifo_threshold_select_reg;
+	struct iga2_fifo_threshold_select iga2_fifo_threshold_select_reg;
+};
+
+struct fifo_high_threshold_select {
+	struct iga1_fifo_high_threshold_select
+	 iga1_fifo_high_threshold_select_reg;
+	struct iga2_fifo_high_threshold_select
+	 iga2_fifo_high_threshold_select_reg;
+};
+
+struct display_queue_expire_num {
+	struct iga1_display_queue_expire_num
+	 iga1_display_queue_expire_num_reg;
+	struct iga2_display_queue_expire_num
+	 iga2_display_queue_expire_num_reg;
+};
+
+struct iga1_crtc_timing {
+	struct iga1_hor_total hor_total;
+	struct iga1_hor_addr hor_addr;
+	struct iga1_hor_blank_start hor_blank_start;
+	struct iga1_hor_blank_end hor_blank_end;
+	struct iga1_hor_sync_start hor_sync_start;
+	struct iga1_hor_sync_end hor_sync_end;
+	struct iga1_ver_total ver_total;
+	struct iga1_ver_addr ver_addr;
+	struct iga1_ver_blank_start ver_blank_start;
+	struct iga1_ver_blank_end ver_blank_end;
+	struct iga1_ver_sync_start ver_sync_start;
+	struct iga1_ver_sync_end ver_sync_end;
+};
+
+struct iga2_shadow_crtc_timing {
+	struct iga2_shadow_hor_total hor_total_shadow;
+	struct iga2_shadow_hor_blank_end hor_blank_end_shadow;
+	struct iga2_shadow_ver_total ver_total_shadow;
+	struct iga2_shadow_ver_addr ver_addr_shadow;
+	struct iga2_shadow_ver_blank_start ver_blank_start_shadow;
+	struct iga2_shadow_ver_blank_end ver_blank_end_shadow;
+	struct iga2_shadow_ver_sync_start ver_sync_start_shadow;
+	struct iga2_shadow_ver_sync_end ver_sync_end_shadow;
+};
+
+struct iga2_crtc_timing {
+	struct iga2_hor_total hor_total;
+	struct iga2_hor_addr hor_addr;
+	struct iga2_hor_blank_start hor_blank_start;
+	struct iga2_hor_blank_end hor_blank_end;
+	struct iga2_hor_sync_start hor_sync_start;
+	struct iga2_hor_sync_end hor_sync_end;
+	struct iga2_ver_total ver_total;
+	struct iga2_ver_addr ver_addr;
+	struct iga2_ver_blank_start ver_blank_start;
+	struct iga2_ver_blank_end ver_blank_end;
+	struct iga2_ver_sync_start ver_sync_start;
+	struct iga2_ver_sync_end ver_sync_end;
+};
+
+/* device ID */
+#define CLE266              0x3123
+#define KM400               0x3205
+#define CN400_FUNCTION2     0x2259
+#define CN400_FUNCTION3     0x3259
+/* support VT3314 chipset */
+#define CN700_FUNCTION2     0x2314
+#define CN700_FUNCTION3     0x3208
+/* VT3324 chipset */
+#define CX700_FUNCTION2     0x2324
+#define CX700_FUNCTION3     0x3324
+/* VT3204 chipset*/
+#define KM800_FUNCTION3      0x3204
+/* VT3336 chipset*/
+#define KM890_FUNCTION3      0x3336
+/* VT3327 chipset*/
+#define P4M890_FUNCTION3     0x3327
+/* VT3293 chipset*/
+#define CN750_FUNCTION3     0x3208
+/* VT3364 chipset*/
+#define P4M900_FUNCTION3    0x3364
+/* VT3353 chipset*/
+#define VX800_FUNCTION3     0x3353
+
+#define NUM_TOTAL_PLL_TABLE ARRAY_SIZE(pll_value)
+
+struct IODATA {
+	u8 Index;
+	u8 Mask;
+	u8 Data;
+};
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
+
+extern struct pll_map pll_value[68];
+extern struct fifo_depth_select display_fifo_depth_reg;
+extern struct fifo_threshold_select fifo_threshold_select_reg;
+extern struct fifo_high_threshold_select fifo_high_threshold_select_reg;
+extern struct display_queue_expire_num display_queue_expire_num_reg;
+extern struct fetch_count fetch_count_reg;
+extern struct iga1_crtc_timing iga1_crtc_reg;
+extern struct iga2_crtc_timing iga2_crtc_reg;
+
+void write_reg_mask(u8 index, int io_port, u8 data, u8 mask);
+void set_output_path(int device, int set_iga, int output_interface);
+void fill_crtc_timing(struct crt_mode_table *crt_table,
+		      int mode_index, int bpp_byte, int set_iga);
+
+void set_crt_output_path(int set_iga);
+void set_dvi_output_path(int set_iga, int output_interface);
+void set_lcd_output_path(int set_iga, int output_interface);
+void set_vclock(u32 CLK, int set_iga);
+void init_gfx_chip_info(void);
+void init_tmds_chip_info(void);
+void init_lvds_chip_info(void);
+void load_reg(int timing_value, int load_reg_num, struct io_register *reg,
+	      int io_type);
+void device_off(void);
+void device_on(void);
+void crt_disable(void);
+void crt_enable(void);
+void enable_second_display_channel(void);
+void disable_second_display_channel(void);
+void lcd_patch_skew(struct lvds_setting_information *plvds_setting_info,
+		    struct lvds_chip_information *plvds_chip_info);
+int get_fb_size_from_pci(void);
+void init_ad9389(void);
+int tmds_register_read(int index);
+void enable_second_display_channel(void);
+/* Access I/O Function */
+void write_reg(u8 index, u16 io_port, u8 data);
+u8 read_reg(int io_port, u8 index);
+void lock_crt(void);
+void unlock_crt(void);
+struct display_timing get_timing_value(struct crt_mode_table
+				       *crt_table, int mode_index);
+void load_offset_reg(int h_addr, int bpp_byte, int set_iga);
+void load_fetch_count_reg(int h_addr, int bpp_byte, int set_iga);
+void write_regx(struct io_reg RegTable[], int ItemNum);
+struct VideoModeTable *get_modetbl_pointer(int Index);
+int search_mode_setting(int ModeInfoIndex);
+u32 get_clk_value(int clk);
+void load_FIFO_reg(int set_iga, int hor_active, int ver_active);
+void set_color_depth(int bpp_byte, int set_iga);
+void set_dpa_gfx(int output_interface, struct GFX_DPA_SETTING\
+					*p_gfx_dpa_setting);
+
+int setmode(int vmode_index, int hor_res, int ver_res,
+	    int video_bpp, int vmode_index1, int hor_res1,
+	    int ver_res1, int video_bpp1);
+void init_chip_info(void);
+void init_dac(int set_iga);
+int get_pixclock(int hres, int vres, int vmode_refresh);
+int get_refresh(int hres, int vres, int pixclock);
+void update_device_setting(int hres, int vres, int bpp,
+			   int vmode_refresh, int flag);
+void get_mmio_info(unsigned long *mmio_base, unsigned long *mmio_len);
+
+void set_iga_path(void);
+void set_start_addr(void);
+void get_fb_info(unsigned int *fb_base, unsigned int *fb_len);
+
+#endif /* __HW_H__ */
diff -Nur a/drivers/video/via/iface.c b/drivers/video/via/iface.c
--- a/drivers/video/via/iface.c	1969-12-31 19:00:00.000000000 -0500
+++ b/drivers/video/via/iface.c	2008-04-29 02:51:18.000000000 -0400
@@ -0,0 +1,78 @@
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
+#include "global.h"
+
+/* Get frame buffer size from VGA BIOS */
+
+unsigned int get_memsize(void)
+{
+	unsigned int m;
+
+	/* If memory size provided by user */
+	if (via_fb_memsize)
+		m = via_fb_memsize * Mb;
+	else {
+		m = (unsigned int)read_reg(VIASR, SR39);
+		m = m * (4 * Mb);
+
+		if ((m < (16 * Mb)) || (m > (64 * Mb)))
+			m = 16 * Mb;
+	}
+	DEBUG_MSG(KERN_INFO "framebuffer size = %d Mb\n", m / Mb);
+	return m;
+}
+
+/* Get Video Buffer Starting Physical Address(back door)*/
+
+unsigned long get_videobuf_addr(void)
+{
+	struct pci_dev *pdev = NULL;
+	unsigned char sys_mem;
+	unsigned char video_mem;
+	unsigned long sys_mem_size;
+	unsigned long video_mem_size;
+	/*system memory = 256 MB, video memory 64 MB */
+	unsigned long vmem_starting_adr = 0x0C000000;
+
+	pdev =
+	    (struct pci_dev *)pci_get_device(VIA_K800_BRIDGE_VID,
+					     VIA_K800_BRIDGE_DID, NULL);
+	if (pdev != NULL) {
+		pci_read_config_byte(pdev, VIA_K800_SYSTEM_MEMORY_REG,
+				     &sys_mem);
+		pci_read_config_byte(pdev, VIA_K800_VIDEO_MEMORY_REG,
+				     &video_mem);
+		video_mem = (video_mem & 0x70) >> 4;
+		sys_mem_size = ((unsigned long)sys_mem) << 24;
+		if (video_mem != 0)
+			video_mem_size = (1 << (video_mem)) * 1024 * 1024;
+		else
+			video_mem_size = 0;
+
+		vmem_starting_adr = sys_mem_size - video_mem_size;
+
+	}
+
+	DEBUG_MSG(KERN_INFO "Video Memory Starting Address = %lx \n",
+		  vmem_starting_adr);
+	return vmem_starting_adr;
+}
diff -Nur a/drivers/video/via/iface.h b/drivers/video/via/iface.h
--- a/drivers/video/via/iface.h	1969-12-31 19:00:00.000000000 -0500
+++ b/drivers/video/via/iface.h	2008-04-29 02:51:18.000000000 -0400
@@ -0,0 +1,38 @@
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
+#ifndef __IFACE_H__
+#define __IFACE_H__
+
+#define Kb  (1024)
+#define Mb  (Kb*Kb)
+
+#define VIA_K800_BRIDGE_VID         0x1106
+#define VIA_K800_BRIDGE_DID         0x3204
+
+#define VIA_K800_SYSTEM_MEMORY_REG  0x47
+#define VIA_K800_VIDEO_MEMORY_REG   0xA1
+
+extern int via_fb_memsize;
+unsigned int get_memsize(void);
+unsigned long get_videobuf_addr(void);
+
+#endif /* __IFACE_H__ */
diff -Nur a/drivers/video/via/ioctl.c b/drivers/video/via/ioctl.c
--- a/drivers/video/via/ioctl.c	1969-12-31 19:00:00.000000000 -0500
+++ b/drivers/video/via/ioctl.c	2008-04-29 02:51:18.000000000 -0400
@@ -0,0 +1,111 @@
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
+#include "global.h"
+
+int ioctl_get_viafb_info(u_long arg)
+{
+	struct viafb_ioctl_info viainfo;
+
+	viainfo.viafb_id = VIAID;
+	viainfo.vendor_id = PCI_VIA_VENDOR_ID;
+
+	switch (chip_info.gfx_chip_name) {
+	case UNICHROME_CLE266:
+		viainfo.device_id = UNICHROME_CLE266_DID;
+		break;
+
+	case UNICHROME_K400:
+		viainfo.device_id = UNICHROME_K400_DID;
+		break;
+
+	case UNICHROME_K800:
+		viainfo.device_id = UNICHROME_K800_DID;
+		break;
+
+	case UNICHROME_PM800:
+		viainfo.device_id = UNICHROME_PM800_DID;
+		break;
+
+	case UNICHROME_CN700:
+		viainfo.device_id = UNICHROME_CN700_DID;
+		break;
+
+	case UNICHROME_CX700:
+		viainfo.device_id = UNICHROME_CX700_DID;
+		break;
+
+	case UNICHROME_K8M890:
+		viainfo.device_id = UNICHROME_K8M890_DID;
+		break;
+
+	case UNICHROME_P4M890:
+		viainfo.device_id = UNICHROME_P4M890_DID;
+		break;
+
+	case UNICHROME_P4M900:
+		viainfo.device_id = UNICHROME_P4M900_DID;
+		break;
+	}
+
+	viainfo.version = VERSION_MAJOR;
+	viainfo.revision = VERSION_MINOR;
+
+	if (copy_to_user((void __user *)arg, &viainfo, sizeof(viainfo)))
+		return -EFAULT;
+
+	return 0;
+}
+
+/* Hot-Plug Priority: DVI > CRT*/
+int ioctl_hotplug(int hres, int vres, int bpp)
+{
+	int DVIsense, status = 0;
+	DEBUG_MSG(KERN_INFO "ioctl_hotplug!!\n");
+
+	if (chip_info.tmds_chip_info.tmds_chip_name != NON_TMDS_TRANSMITTER) {
+		DVIsense = dvi_sense();
+
+		if (DVIsense) {
+			DEBUG_MSG(KERN_INFO "DVI Attached...\n");
+			if (DeviceStatus != DVI_Device) {
+				DVI_ON = 1;
+				CRT_ON = 0;
+				LCD_ON = 0;
+				DeviceStatus = DVI_Device;
+				return DeviceStatus;
+			}
+			status = 1;
+		} else
+			DEBUG_MSG(KERN_INFO "DVI De-attached...\n");
+	}
+
+	if ((DeviceStatus != CRT_Device) && (status == 0)) {
+		CRT_ON = 1;
+		DVI_ON = 0;
+		LCD_ON = 0;
+
+		DeviceStatus = CRT_Device;
+		return DeviceStatus;
+	}
+
+	return 0;
+}
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
