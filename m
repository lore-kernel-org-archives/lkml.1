Return-Path: <linux-kernel-owner+w=401wt.eu-S1764494AbYEGLNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764494AbYEGLNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 07:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761406AbYEGLKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 07:10:10 -0400
Received: from mailtp.via.com.tw ([61.66.243.2]:1331 "EHLO mailtp.via.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761312AbYEGLJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 07:09:58 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: [Linux-fbdev-devel] [PATCH 9/9] viafb: VIA Frame Buffer Device Driver
Date: Wed, 7 May 2008 19:09:52 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F6775C@exchtp03.taipei.via.com.tw>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Linux-fbdev-devel] [PATCH 9/9] viafb: VIA Frame Buffer Device Driver
Thread-Index: AcivqWbF3qyu30s5RguMHG+BNihXBgAhNGrAAAA1T2AAABOmsAAARPQw
From: <JosephChan@via.com.tw>
To: <JosephChan@via.com.tw>, <akpm@linux-foundation.org>,
       <geert@linux-m68k.org>
Cc: <linux-fbdev-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 07 May 2008 11:09:55.0131 (UTC) FILETIME=[E11740B0:01C8B032]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m47BDsEB002170

Signed-off-by: Joseph Chan <josephchan@via.com.tw>

diff -Nur a/drivers/video/via/via_utility.h b/drivers/video/via/via_utility.h
--- a/drivers/video/via/via_utility.h	1969-12-31 19:00:00.000000000 -0500
+++ b/drivers/video/via/via_utility.h	2008-04-29 02:51:32.000000000 -0400
@@ -0,0 +1,35 @@
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
+#ifndef __VIAUTILITY_H__
+#define __VIAUTILITY_H__
+
+/* These functions are used to get infomation about device's state */
+void get_device_support_state(u32 *support_state);
+void get_device_connect_state(u32 *connect_state);
+bool lcd_get_support_expand_state(u32 xres, u32 yres);
+
+/* These function are used to access gamma table */
+void set_gamma_table(int bpp, unsigned int *gamma_table);
+void get_gamma_table(unsigned int *gamma_table);
+void get_gamma_support_state(int bpp, unsigned int *support_state);
+int input_parameter_converter(int parameter_value);
+
+#endif /* __VIAUTILITY_H__ */
diff -Nur a/drivers/video/via/vt1636.c b/drivers/video/via/vt1636.c
--- a/drivers/video/via/vt1636.c	1969-12-31 19:00:00.000000000 -0500
+++ b/drivers/video/via/vt1636.c	2008-05-04 07:20:00.000000000 -0400
@@ -0,0 +1,317 @@
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
+u8 gpio_i2c_read_lvds(struct lvds_setting_information *plvds_setting_info,
+		      struct lvds_chip_information *plvds_chip_info, u8 index)
+{
+	u8 data;
+	int tmp;
+	tmp = chip_info.chip_on_slot;
+	switch (plvds_chip_info->i2c_port) {
+	case I2CPORTINDEX:
+		chip_info.chip_on_slot = PORT_ON_AMR;
+		break;
+	case GPIOPORTINDEX:
+	default:
+		chip_info.chip_on_slot = PORT_ON_AGP;
+		break;
+	}
+	i2cReadByte(plvds_chip_info->lvds_chip_slave_addr, index, &data);
+	chip_info.chip_on_slot = tmp;
+	return data;
+}
+
+void gpio_i2c_write_mask_lvds(struct lvds_setting_information
+			      *plvds_setting_info, struct lvds_chip_information
+			      *plvds_chip_info, struct IODATA io_data)
+{
+	int index, data, tmp;
+	tmp = chip_info.chip_on_slot;
+	switch (plvds_chip_info->i2c_port) {
+	case I2CPORTINDEX:
+		chip_info.chip_on_slot = PORT_ON_AMR;
+		break;
+	case GPIOPORTINDEX:
+	default:
+		chip_info.chip_on_slot = PORT_ON_AGP;
+		break;
+	}
+
+	index = io_data.Index;
+	data = gpio_i2c_read_lvds(plvds_setting_info, plvds_chip_info, index);
+	data = (data & (~io_data.Mask)) | io_data.Data;
+
+	i2cWriteByte(plvds_chip_info->lvds_chip_slave_addr, index, data);
+	chip_info.chip_on_slot = tmp;
+}
+
+void init_lvds_vt1636(struct lvds_setting_information *plvds_setting_info,
+		      struct lvds_chip_information *plvds_chip_info)
+{
+	int reg_num, i;
+
+	/* Common settings: */
+	reg_num = ARRAY_SIZE(COMMON_INIT_TBL_VT1636);
+
+	for (i = 0; i < reg_num; i++) {
+		gpio_i2c_write_mask_lvds(plvds_setting_info,
+					 plvds_chip_info,
+					 COMMON_INIT_TBL_VT1636[i]);
+	}
+
+	/* Input Data Mode Select */
+	if (plvds_setting_info->device_lcd_dualedge) {
+		gpio_i2c_write_mask_lvds(plvds_setting_info,
+					 plvds_chip_info,
+					 DUAL_CHANNEL_ENABLE_TBL_VT1636[0]);
+	} else {
+		gpio_i2c_write_mask_lvds(plvds_setting_info,
+					 plvds_chip_info,
+					 SINGLE_CHANNEL_ENABLE_TBL_VT1636[0]);
+	}
+
+	if (plvds_setting_info->LCDDithering) {
+		gpio_i2c_write_mask_lvds(plvds_setting_info,
+					 plvds_chip_info,
+					 DITHERING_ENABLE_TBL_VT1636[0]);
+	} else {
+		gpio_i2c_write_mask_lvds(plvds_setting_info,
+					 plvds_chip_info,
+					 DITHERING_DISABLE_TBL_VT1636[0]);
+	}
+}
+
+void enable_lvds_vt1636(struct lvds_setting_information
+			*plvds_setting_info,
+			struct lvds_chip_information *plvds_chip_info)
+{
+
+	gpio_i2c_write_mask_lvds(plvds_setting_info, plvds_chip_info,
+				 VDD_ON_TBL_VT1636[0]);
+
+	/* Pad on: */
+	switch (plvds_chip_info->output_interface) {
+	case INTERFACE_DVP0:
+		{
+			write_reg_mask(SR1E, VIASR, 0xC0, 0xC0);
+			break;
+		}
+
+	case INTERFACE_DVP1:
+		{
+			write_reg_mask(SR1E, VIASR, 0x30, 0x30);
+			break;
+		}
+
+	case INTERFACE_DFP_LOW:
+		{
+			write_reg_mask(SR2A, VIASR, 0x03, 0x03);
+			break;
+		}
+
+	case INTERFACE_DFP_HIGH:
+		{
+			write_reg_mask(SR2A, VIASR, 0x03, 0x0C);
+			break;
+		}
+
+	}
+}
+
+void disable_lvds_vt1636(struct lvds_setting_information
+			 *plvds_setting_info,
+			 struct lvds_chip_information *plvds_chip_info)
+{
+
+	gpio_i2c_write_mask_lvds(plvds_setting_info, plvds_chip_info,
+				 VDD_OFF_TBL_VT1636[0]);
+
+	/* Pad off: */
+	switch (plvds_chip_info->output_interface) {
+	case INTERFACE_DVP0:
+		{
+			write_reg_mask(SR1E, VIASR, 0x00, 0xC0);
+			break;
+		}
+
+	case INTERFACE_DVP1:
+		{
+			write_reg_mask(SR1E, VIASR, 0x00, 0x30);
+			break;
+		}
+
+	case INTERFACE_DFP_LOW:
+		{
+			write_reg_mask(SR2A, VIASR, 0x00, 0x03);
+			break;
+		}
+
+	case INTERFACE_DFP_HIGH:
+		{
+			write_reg_mask(SR2A, VIASR, 0x00, 0x0C);
+			break;
+		}
+
+	}
+}
+
+bool lvds_identify_vt1636(void)
+{
+	u8 Buffer[2];
+
+	DEBUG_MSG(KERN_INFO "lvds_identify_vt1636.\n");
+
+	/* Sense VT1636 LVDS Transmiter */
+	chip_info.lvds_chip_info.lvds_chip_slave_addr = VT1636_LVDS_I2C_ADDR;
+
+	/* Check vendor ID first: */
+	i2cReadByte((u8) chip_info.lvds_chip_info.lvds_chip_slave_addr,
+		    0x00, &Buffer[0]);
+	i2cReadByte((u8) chip_info.lvds_chip_info.lvds_chip_slave_addr,
+		    0x01, &Buffer[1]);
+
+	if (!((Buffer[0] == 0x06) && (Buffer[1] == 0x11)))
+		return FALSE;
+
+	/* Check Chip ID: */
+	i2cReadByte((u8) chip_info.lvds_chip_info.lvds_chip_slave_addr,
+		    0x02, &Buffer[0]);
+	i2cReadByte((u8) chip_info.lvds_chip_info.lvds_chip_slave_addr,
+		    0x03, &Buffer[1]);
+	if ((Buffer[0] == 0x45) && (Buffer[1] == 0x33)) {
+		chip_info.lvds_chip_info.lvds_chip_name = VT1636_LVDS;
+		return TRUE;
+	}
+
+	return FALSE;
+}
+
+int get_clk_range_index(u32 Clk)
+{
+	if (Clk < DPA_CLK_30M)
+		return DPA_CLK_RANGE_30M;
+	else if ((DPA_CLK_30M < Clk) && (Clk < DPA_CLK_50M))
+		return DPA_CLK_RANGE_30_50M;
+	else if ((DPA_CLK_50M < Clk) && (Clk < DPA_CLK_70M))
+		return DPA_CLK_RANGE_50_70M;
+	else if ((DPA_CLK_70M < Clk) && (Clk < DPA_CLK_100M))
+		return DPA_CLK_RANGE_70_100M;
+	else if ((DPA_CLK_100M < Clk) && (Clk < DPA_CLK_150M))
+		return DPA_CLK_RANGE_100_150M;
+	else
+		return DPA_CLK_RANGE_150M;
+}
+
+int get_lvds_dpa_setting_index(int panel_size_id,
+			     struct VT1636_DPA_SETTING *p_vt1636_dpasetting_tbl,
+			       int tbl_size)
+{
+	int i;
+
+	for (i = 0; i < tbl_size; i++) {
+		if (panel_size_id == p_vt1636_dpasetting_tbl->PanelSizeID)
+			return i;
+
+		p_vt1636_dpasetting_tbl++;
+	}
+
+	return 0;
+}
+
+void set_dpa_vt1636(struct lvds_setting_information *plvds_setting_info,
+		    struct lvds_chip_information *plvds_chip_info,
+		    struct VT1636_DPA_SETTING *p_vt1636_dpa_setting)
+{
+	struct IODATA io_data;
+
+	io_data.Index = 0x09;
+	io_data.Mask = 0x1F;
+	io_data.Data = p_vt1636_dpa_setting->CLK_SEL_ST1;
+	gpio_i2c_write_mask_lvds(plvds_setting_info, plvds_chip_info, io_data);
+
+	io_data.Index = 0x08;
+	io_data.Mask = 0x0F;
+	io_data.Data = p_vt1636_dpa_setting->CLK_SEL_ST2;
+	gpio_i2c_write_mask_lvds(plvds_setting_info, plvds_chip_info, io_data);
+}
+
+void vt1636_patch_skew_on_vt3324(struct lvds_setting_information
+				 *plvds_setting_info,
+				 struct lvds_chip_information
+				 *plvds_chip_info)
+{
+	int index, size;
+
+	DEBUG_MSG(KERN_INFO "vt1636_patch_skew_on_vt3324.\n");
+
+	/* Graphics DPA settings: */
+	index = get_clk_range_index(plvds_setting_info->vclk);
+	set_dpa_gfx(plvds_chip_info->output_interface,
+		    &GFX_DPA_SETTING_TBL_VT3324[index]);
+
+	/* LVDS Transmitter DPA settings: */
+	size = ARRAY_SIZE(VT1636_DPA_SETTING_TBL_VT3324);
+	index =
+	    get_lvds_dpa_setting_index(plvds_setting_info->lcd_panel_id,
+				       VT1636_DPA_SETTING_TBL_VT3324, size);
+	set_dpa_vt1636(plvds_setting_info, plvds_chip_info,
+		       &VT1636_DPA_SETTING_TBL_VT3324[index]);
+}
+
+void vt1636_patch_skew_on_vt3327(struct lvds_setting_information
+				 *plvds_setting_info,
+				 struct lvds_chip_information
+				 *plvds_chip_info)
+{
+	int index, size;
+
+	DEBUG_MSG(KERN_INFO "vt1636_patch_skew_on_vt3327.\n");
+
+	/* Graphics DPA settings: */
+	index = get_clk_range_index(plvds_setting_info->vclk);
+	set_dpa_gfx(plvds_chip_info->output_interface,
+		    &GFX_DPA_SETTING_TBL_VT3327[index]);
+
+	/* LVDS Transmitter DPA settings: */
+	size = ARRAY_SIZE(VT1636_DPA_SETTING_TBL_VT3327);
+	index =
+	    get_lvds_dpa_setting_index(plvds_setting_info->lcd_panel_id,
+				       VT1636_DPA_SETTING_TBL_VT3327, size);
+	set_dpa_vt1636(plvds_setting_info, plvds_chip_info,
+		       &VT1636_DPA_SETTING_TBL_VT3327[index]);
+}
+
+void vt1636_patch_skew_on_vt3364(struct lvds_setting_information
+				 *plvds_setting_info,
+				 struct lvds_chip_information
+				 *plvds_chip_info)
+{
+	int index;
+
+	DEBUG_MSG(KERN_INFO "vt1636_patch_skew_on_vt3364.\n");
+
+	/* Graphics DPA settings: */
+	index = get_clk_range_index(plvds_setting_info->vclk);
+	set_dpa_gfx(plvds_chip_info->output_interface,
+		    &GFX_DPA_SETTING_TBL_VT3364[index]);
+}
diff -Nur a/drivers/video/via/vt1636.h b/drivers/video/via/vt1636.h
--- a/drivers/video/via/vt1636.h	1969-12-31 19:00:00.000000000 -0500
+++ b/drivers/video/via/vt1636.h	2008-04-29 02:51:33.000000000 -0400
@@ -0,0 +1,47 @@
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
+#ifndef _VT1636_H_
+#define _VT1636_H_
+#include "chip.h"
+bool lvds_identify_vt1636(void);
+void init_lvds_vt1636(struct lvds_setting_information *plvds_setting_info,
+		      struct lvds_chip_information *plvds_chip_info);
+void enable_lvds_vt1636(struct lvds_setting_information
+			*plvds_setting_info,
+			struct lvds_chip_information *plvds_chip_info);
+void disable_lvds_vt1636(struct lvds_setting_information
+			 *plvds_setting_info,
+			 struct lvds_chip_information *plvds_chip_info);
+void vt1636_patch_skew_on_vt3324(struct lvds_setting_information
+				 *plvds_setting_info,
+				 struct lvds_chip_information
+				 *plvds_chip_info);
+void vt1636_patch_skew_on_vt3327(struct lvds_setting_information
+				 *plvds_setting_info,
+				 struct lvds_chip_information
+				 *plvds_chip_info);
+void vt1636_patch_skew_on_vt3364(struct lvds_setting_information
+				 *plvds_setting_info,
+				 struct lvds_chip_information
+				 *plvds_chip_info);
+
+#endif
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
