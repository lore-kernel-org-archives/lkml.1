Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbYF3H0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbYF3H0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 03:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYF3H0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 03:26:22 -0400
Received: from mailtp.via.com.tw ([61.66.243.2]:60101 "EHLO mailtp.via.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbYF3H0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 03:26:21 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: [PATCH 7/13] viafb: iface.c, iface.h, ioctl.c, ioctl.h
Date: Mon, 30 Jun 2008 15:26:18 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB8074E7804@exchtp03.taipei.via.com.tw>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 7/13] viafb: iface.c, iface.h, ioctl.c, ioctl.h
Thread-Index: AcjagpZkU7Sd89uQTmGvpUuwVjhnAQ==
From: <JosephChan@via.com.tw>
To: <JosephChan@via.com.tw>, <linux-fbdev-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
Cc: <akpm@linux-foundation.org>, <geert@linux-m68k.org>
X-OriginalArrivalTime: 30 Jun 2008 07:26:19.0376 (UTC) FILETIME=[96FBFF00:01C8DA82]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m5U7Qcfq018893

iface.c, iface.h: support getting video memory from backdoor.
ioctl.c, ioctl.h: support user mode application with additional information


Signed-off-by: Joseph Chan <josephchan@via.com.tw>

diff -Nur a/drivers/video/via/iface.c b/drivers/video/via/iface.c
--- a/drivers/video/via/iface.c	1970-01-01 08:00:00.000000000 +0800
+++ b/drivers/video/via/iface.c	2008-06-30 08:53:33.000000000 +0800
@@ -0,0 +1,78 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation;
+ * either version 2, or (at your option) any later version.
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
+		m = (unsigned int)viafb_read_reg(VIASR, SR39);
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
+		pci_dev_put(pdev);
+	}
+
+	DEBUG_MSG(KERN_INFO "Video Memory Starting Address = %lx \n",
+		  vmem_starting_adr);
+	return vmem_starting_adr;
+}
diff -Nur a/drivers/video/via/iface.h b/drivers/video/via/iface.h
--- a/drivers/video/via/iface.h	1970-01-01 08:00:00.000000000 +0800
+++ b/drivers/video/via/iface.h	2008-06-30 08:53:33.000000000 +0800
@@ -0,0 +1,38 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation;
+ * either version 2, or (at your option) any later version.
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
--- a/drivers/video/via/ioctl.c	1970-01-01 08:00:00.000000000 +0800
+++ b/drivers/video/via/ioctl.c	2008-06-30 08:53:33.000000000 +0800
@@ -0,0 +1,112 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation;
+ * either version 2, or (at your option) any later version.
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
+int viafb_ioctl_get_viafb_info(u_long arg)
+{
+	struct viafb_ioctl_info viainfo;
+
+	viainfo.viafb_id = VIAID;
+	viainfo.vendor_id = PCI_VIA_VENDOR_ID;
+
+	switch (viaparinfo->chip_info->gfx_chip_name) {
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
+int viafb_ioctl_hotplug(int hres, int vres, int bpp)
+{
+	int DVIsense, status = 0;
+	DEBUG_MSG(KERN_INFO "viafb_ioctl_hotplug!!\n");
+
+	if (viaparinfo->chip_info->tmds_chip_info.tmds_chip_name !=
+		NON_TMDS_TRANSMITTER) {
+		DVIsense = viafb_dvi_sense();
+
+		if (DVIsense) {
+			DEBUG_MSG(KERN_INFO "DVI Attached...\n");
+			if (viafb_DeviceStatus != DVI_Device) {
+				viafb_DVI_ON = 1;
+				viafb_CRT_ON = 0;
+				viafb_LCD_ON = 0;
+				viafb_DeviceStatus = DVI_Device;
+				return viafb_DeviceStatus;
+			}
+			status = 1;
+		} else
+			DEBUG_MSG(KERN_INFO "DVI De-attached...\n");
+	}
+
+	if ((viafb_DeviceStatus != CRT_Device) && (status == 0)) {
+		viafb_CRT_ON = 1;
+		viafb_DVI_ON = 0;
+		viafb_LCD_ON = 0;
+
+		viafb_DeviceStatus = CRT_Device;
+		return viafb_DeviceStatus;
+	}
+
+	return 0;
+}
diff -Nur a/drivers/video/via/ioctl.h b/drivers/video/via/ioctl.h
--- a/drivers/video/via/ioctl.h	1970-01-01 08:00:00.000000000 +0800
+++ b/drivers/video/via/ioctl.h	2008-06-30 08:53:33.000000000 +0800
@@ -0,0 +1,212 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation;
+ * either version 2, or (at your option) any later version.
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
+#ifndef __IOCTL_H__
+#define __IOCTL_H__
+
+#ifndef __user
+#define __user
+#endif
+
+/* VIAFB IOCTL definition */
+#define VIAFB_GET_INFO_SIZE		0x56494101	/* 'VIA\01' */
+#define VIAFB_GET_INFO			0x56494102	/* 'VIA\02' */
+#define VIAFB_HOTPLUG			0x56494103	/* 'VIA\03' */
+#define VIAFB_SET_HOTPLUG_FLAG		0x56494104	/* 'VIA\04' */
+#define VIAFB_GET_RESOLUTION		0x56494105	/* 'VIA\05' */
+#define VIAFB_GET_SAMM_INFO		0x56494107	/* 'VIA\07' */
+#define VIAFB_TURN_ON_OUTPUT_DEVICE     0x56494108	/* 'VIA\08' */
+#define VIAFB_TURN_OFF_OUTPUT_DEVICE    0x56494109	/* 'VIA\09' */
+#define VIAFB_SET_DEVICE		0x5649410A
+#define VIAFB_GET_DEVICE		0x5649410B
+#define VIAFB_GET_DRIVER_VERSION	0x56494112	/* 'VIA\12' */
+#define VIAFB_GET_CHIP_INFO		0x56494113	/* 'VIA\13' */
+#define VIAFB_SET_DEVICE_INFO           0x56494114
+#define VIAFB_GET_DEVICE_INFO           0x56494115
+
+#define VIAFB_GET_DEVICE_SUPPORT	0x56494118
+#define VIAFB_GET_DEVICE_CONNECT	0x56494119
+#define VIAFB_GET_PANEL_SUPPORT_EXPAND	0x5649411A
+#define VIAFB_GET_DRIVER_NAME		0x56494122
+#define VIAFB_GET_DEVICE_SUPPORT_STATE	0x56494123
+#define VIAFB_GET_GAMMA_LUT		0x56494124
+#define VIAFB_SET_GAMMA_LUT		0x56494125
+#define VIAFB_GET_GAMMA_SUPPORT_STATE	0x56494126
+#define VIAFB_SET_VIDEO_DEVICE		0x56494127
+#define VIAFB_GET_VIDEO_DEVICE		0x56494128
+#define VIAFB_SET_SECOND_MODE		0x56494129
+#define VIAFB_SYNC_SURFACE		0x56494130
+#define VIAFB_GET_DRIVER_CAPS		0x56494131
+#define VIAFB_GET_IGA_SCALING_INFO	0x56494132
+#define VIAFB_GET_PANEL_MAX_SIZE	0x56494133
+#define VIAFB_GET_PANEL_MAX_POSITION	0x56494134
+#define VIAFB_SET_PANEL_SIZE		0x56494135
+#define VIAFB_SET_PANEL_POSITION        0x56494136
+#define VIAFB_GET_PANEL_POSITION        0x56494137
+#define VIAFB_GET_PANEL_SIZE		0x56494138
+
+#define None_Device 0x00
+#define CRT_Device  0x01
+#define LCD_Device  0x02
+#define DVI_Device  0x08
+#define CRT2_Device 0x10
+#define LCD2_Device 0x40
+
+#define OP_LCD_CENTERING   0x01
+#define OP_LCD_PANEL_ID    0x02
+#define OP_LCD_MODE        0x03
+
+/*SAMM operation flag*/
+#define OP_SAMM            0x80
+
+#define LCD_PANEL_ID_MAXIMUM	22
+
+#define STATE_ON            0x1
+#define STATE_OFF           0x0
+#define STATE_DEFAULT       0xFFFF
+
+#define MAX_ACTIVE_DEV_NUM  2
+
+struct device_t {
+	unsigned short crt:1;
+	unsigned short dvi:1;
+	unsigned short lcd:1;
+	unsigned short samm:1;
+	unsigned short primary_dev;
+
+	unsigned short lcd_dsp_cent:1;
+	unsigned char lcd_panel_id;
+	unsigned char lcd_mode:1;
+
+	unsigned short xres, yres;
+	unsigned short xres1, yres1;
+	unsigned short refresh;
+	unsigned short bpp;
+	unsigned short refresh1;
+	unsigned short bpp1;
+	unsigned short sequence;
+
+	unsigned short epia_dvi:1;
+	unsigned short lcd_dual_edge:1;
+	unsigned short bus_width;
+	unsigned short lcd2:1;
+};
+
+struct viafb_ioctl_info {
+	u32 viafb_id;		/* for identifying viafb */
+#define VIAID       0x56494146	/* Identify myself with 'VIAF' */
+	u16 vendor_id;
+	u16 device_id;
+	u8 version;
+	u8 revision;
+	u8 reserved[246];	/* for future use */
+};
+
+struct viafb_ioctl_mode {
+	u32 xres;
+	u32 yres;
+	u32 refresh;
+	u32 bpp;
+	u32 xres_sec;
+	u32 yres_sec;
+	u32 virtual_xres_sec;
+	u32 virtual_yres_sec;
+	u32 refresh_sec;
+	u32 bpp_sec;
+};
+struct viafb_ioctl_samm {
+	u32 samm_status;
+	u32 size_prim;
+	u32 size_sec;
+	u32 mem_base;
+	u32 offset_sec;
+};
+
+struct viafb_driver_version {
+	int iMajorNum;
+	int iKernelNum;
+	int iOSNum;
+	int iMinorNum;
+};
+
+struct viafb_ioctl_lcd_attribute {
+	unsigned int panel_id;
+	unsigned int display_center;
+	unsigned int lcd_mode;
+};
+
+struct viafb_ioctl_setting {
+	/* Enable or disable active devices */
+	unsigned short device_flag;
+	/* Indicate which device should be turn on or turn off. */
+	unsigned short device_status;
+	unsigned int reserved;
+	/* Indicate which LCD's attribute can be changed. */
+	unsigned short lcd_operation_flag;
+	/* 1: SAMM ON  0: SAMM OFF */
+	unsigned short samm_status;
+	/* horizontal resolution of first device */
+	unsigned short first_dev_hor_res;
+	/* vertical resolution of first device */
+	unsigned short first_dev_ver_res;
+	/* horizontal resolution of second device */
+	unsigned short second_dev_hor_res;
+	/* vertical resolution of second device */
+	unsigned short second_dev_ver_res;
+	/* refresh rate of first device */
+	unsigned short first_dev_refresh;
+	/* bpp of first device */
+	unsigned short first_dev_bpp;
+	/* refresh rate of second device */
+	unsigned short second_dev_refresh;
+	/* bpp of second device */
+	unsigned short second_dev_bpp;
+	/* Indicate which device are primary display device. */
+	unsigned int primary_device;
+	/* Indicate which device will show video. only valid in duoview mode */
+	unsigned int video_device_status;
+	unsigned int struct_reserved[34];
+	struct viafb_ioctl_lcd_attribute lcd_attributes;
+};
+
+struct _UTFunctionCaps {
+	unsigned int dw3DScalingState;
+	unsigned int reserved[31];
+};
+
+struct _POSITIONVALUE {
+	unsigned int dwX;
+	unsigned int dwY;
+};
+
+struct _panel_size_pos_info {
+	unsigned int device_type;
+	int x;
+	int y;
+};
+
+extern int viafb_LCD_ON;
+extern int viafb_DVI_ON;
+
+int viafb_ioctl_get_viafb_info(u_long arg);
+int viafb_ioctl_hotplug(int hres, int vres, int bpp);
+
+#endif /* __IOCTL_H__ */
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
