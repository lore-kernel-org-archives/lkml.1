Return-Path: <linux-kernel-owner+w=401wt.eu-S1758162AbYHHKUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162AbYHHKUY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 06:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754340AbYHHKUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 06:20:08 -0400
Received: from mailtp.via.com.tw ([61.66.243.2]:16266 "EHLO mailtp.via.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbYHHKUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 06:20:05 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: [PATCH 13/13 v2] viafb: via_utility.c, via_utility.h, vt1636.c, vt1636.h
Date: Fri, 8 Aug 2008 18:20:02 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB8078B69AF@exchtp03.taipei.via.com.tw>
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB8074E78BE@exchtp03.taipei.via.com.tw>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 13/13 v2] viafb: via_utility.c, via_utility.h, vt1636.c, vt1636.h
Thread-Index: AcjahnUJcHNN7Iq7SWeBnJ3ezl+jFwesa8Qg
From: <JosephChan@via.com.tw>
To: <JosephChan@via.com.tw>, <linux-fbdev-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
Cc: <akpm@linux-foundation.org>, <geert@linux-m68k.org>
X-OriginalArrivalTime: 08 Aug 2008 10:20:03.0619 (UTC) FILETIME=[526D7F30:01C8F940]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m78AKSdq019771

via_utility.c, via_utility.h: support user mode application with additional information vt1636.c, vt1636.h: setting for chip vt1636


Signed-off-by: Joseph Chan <josephchan@via.com.tw>

diff -Nurp a/drivers/video/via/via_utility.c b/drivers/video/via/via_utility.c
--- a/drivers/video/via/via_utility.c	1970-01-01 08:00:00.000000000 +0800
+++ b/drivers/video/via/via_utility.c	2008-07-22 02:07:29.000000000 +0800
@@ -0,0 +1,253 @@
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
+void viafb_get_device_support_state(u32 *support_state)
+{
+	*support_state = CRT_Device;
+
+	if (viaparinfo->chip_info->tmds_chip_info.tmds_chip_name == VT1632_TMDS)
+		*support_state |= DVI_Device;
+
+	if (viaparinfo->chip_info->lvds_chip_info.lvds_chip_name == VT1631_LVDS)
+		*support_state |= LCD_Device;
+}
+
+void viafb_get_device_connect_state(u32 *connect_state)
+{
+	bool mobile = false;
+
+	*connect_state = CRT_Device;
+
+	if (viafb_dvi_sense())
+		*connect_state |= DVI_Device;
+
+	viafb_lcd_get_mobile_state(&mobile);
+	if (mobile)
+		*connect_state |= LCD_Device;
+}
+
+bool viafb_lcd_get_support_expand_state(u32 xres, u32 yres)
+{
+	unsigned int support_state = 0;
+
+	switch (viafb_lcd_panel_id) {
+	case LCD_PANEL_ID0_640X480:
+		if ((xres < 640) && (yres < 480))
+			support_state = true;
+		break;
+
+	case LCD_PANEL_ID1_800X600:
+		if ((xres < 800) && (yres < 600))
+			support_state = true;
+		break;
+
+	case LCD_PANEL_ID2_1024X768:
+		if ((xres < 1024) && (yres < 768))
+			support_state = true;
+		break;
+
+	case LCD_PANEL_ID3_1280X768:
+		if ((xres < 1280) && (yres < 768))
+			support_state = true;
+		break;
+
+	case LCD_PANEL_ID4_1280X1024:
+		if ((xres < 1280) && (yres < 1024))
+			support_state = true;
+		break;
+
+	case LCD_PANEL_ID5_1400X1050:
+		if ((xres < 1400) && (yres < 1050))
+			support_state = true;
+		break;
+
+	case LCD_PANEL_ID6_1600X1200:
+		if ((xres < 1600) && (yres < 1200))
+			support_state = true;
+		break;
+
+	case LCD_PANEL_ID7_1366X768:
+		if ((xres < 1366) && (yres < 768))
+			support_state = true;
+		break;
+
+	case LCD_PANEL_ID8_1024X600:
+		if ((xres < 1024) && (yres < 600))
+			support_state = true;
+		break;
+
+	case LCD_PANEL_ID9_1280X800:
+		if ((xres < 1280) && (yres < 800))
+			support_state = true;
+		break;
+
+	case LCD_PANEL_IDA_800X480:
+		if ((xres < 800) && (yres < 480))
+			support_state = true;
+		break;
+
+	case LCD_PANEL_IDB_1360X768:
+		if ((xres < 1360) && (yres < 768))
+			support_state = true;
+		break;
+
+	case LCD_PANEL_IDC_480X640:
+		if ((xres < 480) && (yres < 640))
+			support_state = true;
+		break;
+
+	default:
+		support_state = false;
+		break;
+	}
+
+	return support_state;
+}
+
+/*====================================================================*/
+/*                      Gamma Function Implementation*/
+/*====================================================================*/
+
+void viafb_set_gamma_table(int bpp, unsigned int *gamma_table)
+{
+	int i, sr1a;
+	int active_device_amount = 0;
+	int device_status = viafb_DeviceStatus;
+
+	for (i = 0; i < sizeof(viafb_DeviceStatus) * 8; i++) {
+		if (device_status & 1)
+			active_device_amount++;
+		device_status >>= 1;
+	}
+
+	/* 8 bpp mode can't adjust gamma */
+	if (bpp == 8)
+		return ;
+
+	/* Enable Gamma */
+	switch (viaparinfo->chip_info->gfx_chip_name) {
+	case UNICHROME_CLE266:
+	case UNICHROME_K400:
+		viafb_write_reg_mask(SR16, VIASR, 0x80, BIT7);
+		break;
+
+	case UNICHROME_K800:
+	case UNICHROME_PM800:
+	case UNICHROME_CN700:
+	case UNICHROME_CX700:
+	case UNICHROME_K8M890:
+	case UNICHROME_P4M890:
+	case UNICHROME_P4M900:
+		viafb_write_reg_mask(CR33, VIACR, 0x80, BIT7);
+		break;
+	}
+	sr1a = (unsigned int)viafb_read_reg(VIASR, SR1A);
+	viafb_write_reg_mask(SR1A, VIASR, 0x0, BIT0);
+
+	/* Fill IGA1 Gamma Table */
+	outb(0, LUT_INDEX_WRITE);
+	for (i = 0; i < 256; i++) {
+		outb(gamma_table[i] >> 16, LUT_DATA);
+		outb(gamma_table[i] >> 8 & 0xFF, LUT_DATA);
+		outb(gamma_table[i] & 0xFF, LUT_DATA);
+	}
+
+	/* If adjust Gamma value in SAMM, fill IGA1,
+	   IGA2 Gamma table simultanous. */
+	/* Switch to IGA2 Gamma Table */
+	if ((active_device_amount > 1) &&
+		!((viaparinfo->chip_info->gfx_chip_name ==
+		UNICHROME_CLE266) &&
+		(viaparinfo->chip_info->gfx_chip_revision < 15))) {
+		viafb_write_reg_mask(SR1A, VIASR, 0x01, BIT0);
+		viafb_write_reg_mask(CR6A, VIACR, 0x02, BIT1);
+
+		/* Fill IGA2 Gamma Table */
+		outb(0, LUT_INDEX_WRITE);
+		for (i = 0; i < 256; i++) {
+			outb(gamma_table[i] >> 16, LUT_DATA);
+			outb(gamma_table[i] >> 8 & 0xFF, LUT_DATA);
+			outb(gamma_table[i] & 0xFF, LUT_DATA);
+		}
+	}
+	viafb_write_reg(SR1A, VIASR, sr1a);
+}
+
+void viafb_get_gamma_table(unsigned int *gamma_table)
+{
+	unsigned char color_r, color_g, color_b;
+	unsigned char sr1a = 0;
+	int i;
+
+	/* Enable Gamma */
+	switch (viaparinfo->chip_info->gfx_chip_name) {
+	case UNICHROME_CLE266:
+	case UNICHROME_K400:
+		viafb_write_reg_mask(SR16, VIASR, 0x80, BIT7);
+		break;
+
+	case UNICHROME_K800:
+	case UNICHROME_PM800:
+	case UNICHROME_CN700:
+	case UNICHROME_CX700:
+	case UNICHROME_K8M890:
+	case UNICHROME_P4M890:
+	case UNICHROME_P4M900:
+		viafb_write_reg_mask(CR33, VIACR, 0x80, BIT7);
+		break;
+	}
+	sr1a = viafb_read_reg(VIASR, SR1A);
+	viafb_write_reg_mask(SR1A, VIASR, 0x0, BIT0);
+
+	/* Reading gamma table to get color value */
+	outb(0, LUT_INDEX_READ);
+	for (i = 0; i < 256; i++) {
+		color_r = inb(LUT_DATA);
+		color_g = inb(LUT_DATA);
+		color_b = inb(LUT_DATA);
+		gamma_table[i] =
+		    ((((u32) color_r) << 16) |
+		     (((u16) color_g) << 8)) | color_b;
+	}
+	viafb_write_reg(SR1A, VIASR, sr1a);
+}
+
+void viafb_get_gamma_support_state(int bpp, unsigned int *support_state)
+{
+	if (bpp == 8)
+		*support_state = None_Device;
+	else
+		*support_state = CRT_Device | DVI_Device | LCD_Device;
+}
+
+int viafb_input_parameter_converter(int parameter_value)
+{
+	int result;
+
+	if (parameter_value >= 1 && parameter_value <= 9)
+		result = 1 << (parameter_value - 1);
+	else
+		result = 1;
+
+	return result;
+}
diff -Nurp a/drivers/video/via/via_utility.h b/drivers/video/via/via_utility.h
--- a/drivers/video/via/via_utility.h	1970-01-01 08:00:00.000000000 +0800
+++ b/drivers/video/via/via_utility.h	2008-07-22 02:07:29.000000000 +0800
@@ -0,0 +1,35 @@
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
+#ifndef __VIAUTILITY_H__
+#define __VIAUTILITY_H__
+
+/* These functions are used to get infomation about device's state */
+void viafb_get_device_support_state(u32 *support_state);
+void viafb_get_device_connect_state(u32 *connect_state);
+bool viafb_lcd_get_support_expand_state(u32 xres, u32 yres);
+
+/* These function are used to access gamma table */
+void viafb_set_gamma_table(int bpp, unsigned int *gamma_table);
+void viafb_get_gamma_table(unsigned int *gamma_table);
+void viafb_get_gamma_support_state(int bpp, unsigned int *support_state);
+int viafb_input_parameter_converter(int parameter_value);
+
+#endif /* __VIAUTILITY_H__ */
diff -Nurp a/drivers/video/via/vt1636.c b/drivers/video/via/vt1636.c
--- a/drivers/video/via/vt1636.c	1970-01-01 08:00:00.000000000 +0800
+++ b/drivers/video/via/vt1636.c	2008-07-22 02:07:29.000000000 +0800
@@ -0,0 +1,306 @@
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
+u8 viafb_gpio_i2c_read_lvds(struct lvds_setting_information
+	*plvds_setting_info, struct lvds_chip_information *plvds_chip_info,
+	u8 index)
+{
+	u8 data;
+
+	viaparinfo->i2c_stuff.i2c_port = plvds_chip_info->i2c_port;
+	viafb_i2c_readbyte(plvds_chip_info->lvds_chip_slave_addr, index, &data);
+
+	return data;
+}
+
+void viafb_gpio_i2c_write_mask_lvds(struct lvds_setting_information
+			      *plvds_setting_info, struct lvds_chip_information
+			      *plvds_chip_info, struct IODATA io_data)
+{
+	int index, data;
+
+	viaparinfo->i2c_stuff.i2c_port = plvds_chip_info->i2c_port;
+
+	index = io_data.Index;
+	data = viafb_gpio_i2c_read_lvds(plvds_setting_info, plvds_chip_info,
+		index);
+	data = (data & (~io_data.Mask)) | io_data.Data;
+
+	viafb_i2c_writebyte(plvds_chip_info->lvds_chip_slave_addr, index, data);
+}
+
+void viafb_init_lvds_vt1636(struct lvds_setting_information
+	*plvds_setting_info, struct lvds_chip_information *plvds_chip_info)
+{
+	int reg_num, i;
+
+	/* Common settings: */
+	reg_num = ARRAY_SIZE(COMMON_INIT_TBL_VT1636);
+
+	for (i = 0; i < reg_num; i++) {
+		viafb_gpio_i2c_write_mask_lvds(plvds_setting_info,
+					 plvds_chip_info,
+					 COMMON_INIT_TBL_VT1636[i]);
+	}
+
+	/* Input Data Mode Select */
+	if (plvds_setting_info->device_lcd_dualedge) {
+		viafb_gpio_i2c_write_mask_lvds(plvds_setting_info,
+					 plvds_chip_info,
+					 DUAL_CHANNEL_ENABLE_TBL_VT1636[0]);
+	} else {
+		viafb_gpio_i2c_write_mask_lvds(plvds_setting_info,
+					 plvds_chip_info,
+					 SINGLE_CHANNEL_ENABLE_TBL_VT1636[0]);
+	}
+
+	if (plvds_setting_info->LCDDithering) {
+		viafb_gpio_i2c_write_mask_lvds(plvds_setting_info,
+					 plvds_chip_info,
+					 DITHERING_ENABLE_TBL_VT1636[0]);
+	} else {
+		viafb_gpio_i2c_write_mask_lvds(plvds_setting_info,
+					 plvds_chip_info,
+					 DITHERING_DISABLE_TBL_VT1636[0]);
+	}
+}
+
+void viafb_enable_lvds_vt1636(struct lvds_setting_information
+			*plvds_setting_info,
+			struct lvds_chip_information *plvds_chip_info)
+{
+
+	viafb_gpio_i2c_write_mask_lvds(plvds_setting_info, plvds_chip_info,
+				 VDD_ON_TBL_VT1636[0]);
+
+	/* Pad on: */
+	switch (plvds_chip_info->output_interface) {
+	case INTERFACE_DVP0:
+		{
+			viafb_write_reg_mask(SR1E, VIASR, 0xC0, 0xC0);
+			break;
+		}
+
+	case INTERFACE_DVP1:
+		{
+			viafb_write_reg_mask(SR1E, VIASR, 0x30, 0x30);
+			break;
+		}
+
+	case INTERFACE_DFP_LOW:
+		{
+			viafb_write_reg_mask(SR2A, VIASR, 0x03, 0x03);
+			break;
+		}
+
+	case INTERFACE_DFP_HIGH:
+		{
+			viafb_write_reg_mask(SR2A, VIASR, 0x03, 0x0C);
+			break;
+		}
+
+	}
+}
+
+void viafb_disable_lvds_vt1636(struct lvds_setting_information
+			 *plvds_setting_info,
+			 struct lvds_chip_information *plvds_chip_info)
+{
+
+	viafb_gpio_i2c_write_mask_lvds(plvds_setting_info, plvds_chip_info,
+				 VDD_OFF_TBL_VT1636[0]);
+
+	/* Pad off: */
+	switch (plvds_chip_info->output_interface) {
+	case INTERFACE_DVP0:
+		{
+			viafb_write_reg_mask(SR1E, VIASR, 0x00, 0xC0);
+			break;
+		}
+
+	case INTERFACE_DVP1:
+		{
+			viafb_write_reg_mask(SR1E, VIASR, 0x00, 0x30);
+			break;
+		}
+
+	case INTERFACE_DFP_LOW:
+		{
+			viafb_write_reg_mask(SR2A, VIASR, 0x00, 0x03);
+			break;
+		}
+
+	case INTERFACE_DFP_HIGH:
+		{
+			viafb_write_reg_mask(SR2A, VIASR, 0x00, 0x0C);
+			break;
+		}
+
+	}
+}
+
+bool viafb_lvds_identify_vt1636(void)
+{
+	u8 Buffer[2];
+
+	DEBUG_MSG(KERN_INFO "viafb_lvds_identify_vt1636.\n");
+
+	/* Sense VT1636 LVDS Transmiter */
+	viaparinfo->chip_info->lvds_chip_info.lvds_chip_slave_addr =
+	VT1636_LVDS_I2C_ADDR;
+
+	/* Check vendor ID first: */
+	viafb_i2c_readbyte((u8) viaparinfo->chip_info->lvds_chip_info.
+	lvds_chip_slave_addr,
+		    0x00, &Buffer[0]);
+	viafb_i2c_readbyte((u8) viaparinfo->chip_info->lvds_chip_info.
+		lvds_chip_slave_addr,
+		    0x01, &Buffer[1]);
+
+	if (!((Buffer[0] == 0x06) && (Buffer[1] == 0x11)))
+		return false;
+
+	/* Check Chip ID: */
+	viafb_i2c_readbyte((u8) viaparinfo->chip_info->lvds_chip_info.
+	lvds_chip_slave_addr,
+		    0x02, &Buffer[0]);
+	viafb_i2c_readbyte((u8) viaparinfo->chip_info->lvds_chip_info.
+		lvds_chip_slave_addr,
+		    0x03, &Buffer[1]);
+	if ((Buffer[0] == 0x45) && (Buffer[1] == 0x33)) {
+		viaparinfo->chip_info->lvds_chip_info.lvds_chip_name =
+			VT1636_LVDS;
+		return true;
+	}
+
+	return false;
+}
+
+static int get_clk_range_index(u32 Clk)
+{
+	if (Clk < DPA_CLK_30M)
+		return DPA_CLK_RANGE_30M;
+	else if (Clk < DPA_CLK_50M)
+		return DPA_CLK_RANGE_30_50M;
+	else if (Clk < DPA_CLK_70M)
+		return DPA_CLK_RANGE_50_70M;
+	else if (Clk < DPA_CLK_100M)
+		return DPA_CLK_RANGE_70_100M;
+	else if (Clk < DPA_CLK_150M)
+		return DPA_CLK_RANGE_100_150M;
+	else
+		return DPA_CLK_RANGE_150M;
+}
+
+static int get_lvds_dpa_setting_index(int panel_size_id,
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
+static void set_dpa_vt1636(struct lvds_setting_information
+	*plvds_setting_info, struct lvds_chip_information *plvds_chip_info,
+		    struct VT1636_DPA_SETTING *p_vt1636_dpa_setting)
+{
+	struct IODATA io_data;
+
+	io_data.Index = 0x09;
+	io_data.Mask = 0x1F;
+	io_data.Data = p_vt1636_dpa_setting->CLK_SEL_ST1;
+	viafb_gpio_i2c_write_mask_lvds(plvds_setting_info,
+		plvds_chip_info, io_data);
+
+	io_data.Index = 0x08;
+	io_data.Mask = 0x0F;
+	io_data.Data = p_vt1636_dpa_setting->CLK_SEL_ST2;
+	viafb_gpio_i2c_write_mask_lvds(plvds_setting_info, plvds_chip_info,
+		io_data);
+}
+
+void viafb_vt1636_patch_skew_on_vt3324(
+	struct lvds_setting_information *plvds_setting_info,
+	struct lvds_chip_information *plvds_chip_info)
+{
+	int index, size;
+
+	DEBUG_MSG(KERN_INFO "viafb_vt1636_patch_skew_on_vt3324.\n");
+
+	/* Graphics DPA settings: */
+	index = get_clk_range_index(plvds_setting_info->vclk);
+	viafb_set_dpa_gfx(plvds_chip_info->output_interface,
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
+void viafb_vt1636_patch_skew_on_vt3327(
+	struct lvds_setting_information *plvds_setting_info,
+	struct lvds_chip_information *plvds_chip_info)
+{
+	int index, size;
+
+	DEBUG_MSG(KERN_INFO "viafb_vt1636_patch_skew_on_vt3327.\n");
+
+	/* Graphics DPA settings: */
+	index = get_clk_range_index(plvds_setting_info->vclk);
+	viafb_set_dpa_gfx(plvds_chip_info->output_interface,
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
+void viafb_vt1636_patch_skew_on_vt3364(
+	struct lvds_setting_information *plvds_setting_info,
+	struct lvds_chip_information *plvds_chip_info)
+{
+	int index;
+
+	DEBUG_MSG(KERN_INFO "viafb_vt1636_patch_skew_on_vt3364.\n");
+
+	/* Graphics DPA settings: */
+	index = get_clk_range_index(plvds_setting_info->vclk);
+	viafb_set_dpa_gfx(plvds_chip_info->output_interface,
+		    &GFX_DPA_SETTING_TBL_VT3364[index]);
+}
diff -Nurp a/drivers/video/via/vt1636.h b/drivers/video/via/vt1636.h
--- a/drivers/video/via/vt1636.h	1970-01-01 08:00:00.000000000 +0800
+++ b/drivers/video/via/vt1636.h	2008-07-22 02:07:29.000000000 +0800
@@ -0,0 +1,44 @@
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
+#ifndef _VT1636_H_
+#define _VT1636_H_
+#include "chip.h"
+bool viafb_lvds_identify_vt1636(void);
+void viafb_init_lvds_vt1636(struct lvds_setting_information
+	*plvds_setting_info, struct lvds_chip_information *plvds_chip_info);
+void viafb_enable_lvds_vt1636(struct lvds_setting_information
+			*plvds_setting_info,
+			struct lvds_chip_information *plvds_chip_info);
+void viafb_disable_lvds_vt1636(struct lvds_setting_information
+			 *plvds_setting_info,
+			 struct lvds_chip_information *plvds_chip_info);
+void viafb_vt1636_patch_skew_on_vt3324(
+	struct lvds_setting_information *plvds_setting_info,
+	struct lvds_chip_information *plvds_chip_info);
+void viafb_vt1636_patch_skew_on_vt3327(
+	struct lvds_setting_information *plvds_setting_info,
+	struct lvds_chip_information *plvds_chip_info);
+void viafb_vt1636_patch_skew_on_vt3364(
+	struct lvds_setting_information *plvds_setting_info,
+	struct lvds_chip_information *plvds_chip_info);
+
+#endif
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
