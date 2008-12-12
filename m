Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbYLLQuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbYLLQuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 11:50:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759381AbYLLQtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 11:49:17 -0500
Received: from mail.gmx.net ([213.165.64.20]:55844 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759356AbYLLQtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 11:49:07 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19EihQ4dbxElghh1o+iv8haEFHgz7F1t6EnUyfzJn
	dptRdM3cBJMLH0
Date: Fri, 12 Dec 2008 17:49:16 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       Sascha Hauer <s.hauer@pengutronix.de>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 3/4 v3] i.MX31: framebuffer driver
In-Reply-To: <Pine.LNX.4.64.0812121740240.6411@axis700.grange>
Message-ID: <Pine.LNX.4.64.0812121746200.6411@axis700.grange>
References: <Pine.LNX.4.64.0812121740240.6411@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guennadi Liakhovetski <lg@denx.de>

This is a framebuffer driver for i.MX31 SoCs. It only supports synchronous
displays, overlay support is included but has never been tested, similarly
panning hasn't been tested.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---
 arch/arm/plat-mxc/include/mach/mx3fb.h |   38 +
 drivers/video/Kconfig                  |   12 +
 drivers/video/Makefile                 |    1 +
 drivers/video/mx3fb.c                  | 1843 ++++++++++++++++++++++++++++++++
 4 files changed, 1894 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/plat-mxc/include/mach/mx3fb.h
 create mode 100644 drivers/video/mx3fb.c

diff --git a/arch/arm/plat-mxc/include/mach/mx3fb.h b/arch/arm/plat-mxc/include/mach/mx3fb.h
new file mode 100644
index 0000000..91f03a4
--- /dev/null
+++ b/arch/arm/plat-mxc/include/mach/mx3fb.h
@@ -0,0 +1,38 @@
+/*
+ * Copyright (C) 2008
+ * Guennadi Liakhovetski, DENX Software Engineering, <lg@denx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_ARCH_MX3FB_H__
+#define __ASM_ARCH_MX3FB_H__
+
+#include <linux/device.h>
+#include <linux/fb.h>
+
+/* Proprietary FB_SYNC_ flags */
+#define FB_SYNC_OE_ACT_HIGH	0x80000000
+#define FB_SYNC_CLK_INVERT	0x40000000
+#define FB_SYNC_DATA_INVERT	0x20000000
+#define FB_SYNC_CLK_IDLE_EN	0x10000000
+#define FB_SYNC_SHARP_MODE	0x08000000
+#define FB_SYNC_SWAP_RGB	0x04000000
+#define FB_SYNC_CLK_SEL_EN	0x02000000
+
+/**
+ * @dma_dev	pointer to the dma-device, used for dma-slave connection
+ * @mode	pointer to a platform-provided per mxc_register_fb() videomode
+ */
+struct mx3fb_platform_data {
+	struct device			*dma_dev;
+	const char			*name;
+	const struct fb_videomode	*mode;
+	int				num_modes;
+};
+
+extern int mx3_register_fb(const char *, const struct fb_videomode *, int);
+
+#endif
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 5611a4f..cd9a8c2 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -2117,6 +2117,18 @@ config FB_PRE_INIT_FB
 	  Select this option if display contents should be inherited as set by
 	  the bootloader.
 
+config FB_MX3
+	tristate "MX3 Framebuffer support"
+	depends on FB && MX3_IPU
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	default y
+	help
+	  This is a framebuffer device for the i.MX31 LCD Controller. So
+	  far only synchronous displays are supported. If you plan to use
+	  an LCD display with your i.MX31 system, say Y here.
+
 source "drivers/video/omap/Kconfig"
 
 source "drivers/video/backlight/Kconfig"
diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index e39e33e..8953190 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -132,6 +132,7 @@ obj-$(CONFIG_FB_VGA16)            += vga16fb.o
 obj-$(CONFIG_FB_OF)               += offb.o
 obj-$(CONFIG_FB_BF54X_LQ043)	  += bf54x-lq043fb.o
 obj-$(CONFIG_FB_BFIN_T350MCQB)	  += bfin-t350mcqb-fb.o
+obj-$(CONFIG_FB_MX3)		  += mx3fb.o
 
 # the test framebuffer is last
 obj-$(CONFIG_FB_VIRTUAL)          += vfb.o
diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
new file mode 100644
index 0000000..e8084ae
--- /dev/null
+++ b/drivers/video/mx3fb.c
@@ -0,0 +1,1843 @@
+/*
+ * Copyright (C) 2008
+ * Guennadi Liakhovetski, DENX Software Engineering, <lg@denx.de>
+ *
+ * Copyright 2004-2007 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/interrupt.h>
+#include <linux/slab.h>
+#include <linux/fb.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/dma-mapping.h>
+#include <linux/dmaengine.h>
+#include <linux/console.h>
+#include <linux/clk.h>
+#include <linux/mutex.h>
+
+#include <mach/hardware.h>
+#include <mach/ipu.h>
+#include <mach/mx3fb.h>
+
+#include <asm/io.h>
+#include <asm/uaccess.h>
+
+#define MX3FB_NAME      "mx3_sdc_fb"
+
+#define MX3FB_REG_OFFSET	0xB4
+
+/* SDC Registers */
+#define SDC_COM_CONF		(0xB4 - MX3FB_REG_OFFSET)
+#define SDC_GW_CTRL		(0xB8 - MX3FB_REG_OFFSET)
+#define SDC_FG_POS		(0xBC - MX3FB_REG_OFFSET)
+#define SDC_BG_POS		(0xC0 - MX3FB_REG_OFFSET)
+#define SDC_CUR_POS		(0xC4 - MX3FB_REG_OFFSET)
+#define SDC_PWM_CTRL		(0xC8 - MX3FB_REG_OFFSET)
+#define SDC_CUR_MAP		(0xCC - MX3FB_REG_OFFSET)
+#define SDC_HOR_CONF		(0xD0 - MX3FB_REG_OFFSET)
+#define SDC_VER_CONF		(0xD4 - MX3FB_REG_OFFSET)
+#define SDC_SHARP_CONF_1	(0xD8 - MX3FB_REG_OFFSET)
+#define SDC_SHARP_CONF_2	(0xDC - MX3FB_REG_OFFSET)
+
+/* Register bits */
+#define SDC_COM_TFT_COLOR	0x00000001UL
+#define SDC_COM_FG_EN		0x00000010UL
+#define SDC_COM_GWSEL		0x00000020UL
+#define SDC_COM_GLB_A		0x00000040UL
+#define SDC_COM_KEY_COLOR_G	0x00000080UL
+#define SDC_COM_BG_EN		0x00000200UL
+#define SDC_COM_SHARP		0x00001000UL
+
+#define SDC_V_SYNC_WIDTH_L	0x00000001UL
+
+/* Display Interface registers */
+#define DI_DISP_IF_CONF		(0x0124 - MX3FB_REG_OFFSET)
+#define DI_DISP_SIG_POL		(0x0128 - MX3FB_REG_OFFSET)
+#define DI_SER_DISP1_CONF	(0x012C - MX3FB_REG_OFFSET)
+#define DI_SER_DISP2_CONF	(0x0130 - MX3FB_REG_OFFSET)
+#define DI_HSP_CLK_PER		(0x0134 - MX3FB_REG_OFFSET)
+#define DI_DISP0_TIME_CONF_1	(0x0138 - MX3FB_REG_OFFSET)
+#define DI_DISP0_TIME_CONF_2	(0x013C - MX3FB_REG_OFFSET)
+#define DI_DISP0_TIME_CONF_3	(0x0140 - MX3FB_REG_OFFSET)
+#define DI_DISP1_TIME_CONF_1	(0x0144 - MX3FB_REG_OFFSET)
+#define DI_DISP1_TIME_CONF_2	(0x0148 - MX3FB_REG_OFFSET)
+#define DI_DISP1_TIME_CONF_3	(0x014C - MX3FB_REG_OFFSET)
+#define DI_DISP2_TIME_CONF_1	(0x0150 - MX3FB_REG_OFFSET)
+#define DI_DISP2_TIME_CONF_2	(0x0154 - MX3FB_REG_OFFSET)
+#define DI_DISP2_TIME_CONF_3	(0x0158 - MX3FB_REG_OFFSET)
+#define DI_DISP3_TIME_CONF	(0x015C - MX3FB_REG_OFFSET)
+#define DI_DISP0_DB0_MAP	(0x0160 - MX3FB_REG_OFFSET)
+#define DI_DISP0_DB1_MAP	(0x0164 - MX3FB_REG_OFFSET)
+#define DI_DISP0_DB2_MAP	(0x0168 - MX3FB_REG_OFFSET)
+#define DI_DISP0_CB0_MAP	(0x016C - MX3FB_REG_OFFSET)
+#define DI_DISP0_CB1_MAP	(0x0170 - MX3FB_REG_OFFSET)
+#define DI_DISP0_CB2_MAP	(0x0174 - MX3FB_REG_OFFSET)
+#define DI_DISP1_DB0_MAP	(0x0178 - MX3FB_REG_OFFSET)
+#define DI_DISP1_DB1_MAP	(0x017C - MX3FB_REG_OFFSET)
+#define DI_DISP1_DB2_MAP	(0x0180 - MX3FB_REG_OFFSET)
+#define DI_DISP1_CB0_MAP	(0x0184 - MX3FB_REG_OFFSET)
+#define DI_DISP1_CB1_MAP	(0x0188 - MX3FB_REG_OFFSET)
+#define DI_DISP1_CB2_MAP	(0x018C - MX3FB_REG_OFFSET)
+#define DI_DISP2_DB0_MAP	(0x0190 - MX3FB_REG_OFFSET)
+#define DI_DISP2_DB1_MAP	(0x0194 - MX3FB_REG_OFFSET)
+#define DI_DISP2_DB2_MAP	(0x0198 - MX3FB_REG_OFFSET)
+#define DI_DISP2_CB0_MAP	(0x019C - MX3FB_REG_OFFSET)
+#define DI_DISP2_CB1_MAP	(0x01A0 - MX3FB_REG_OFFSET)
+#define DI_DISP2_CB2_MAP	(0x01A4 - MX3FB_REG_OFFSET)
+#define DI_DISP3_B0_MAP		(0x01A8 - MX3FB_REG_OFFSET)
+#define DI_DISP3_B1_MAP		(0x01AC - MX3FB_REG_OFFSET)
+#define DI_DISP3_B2_MAP		(0x01B0 - MX3FB_REG_OFFSET)
+#define DI_DISP_ACC_CC		(0x01B4 - MX3FB_REG_OFFSET)
+#define DI_DISP_LLA_CONF	(0x01B8 - MX3FB_REG_OFFSET)
+#define DI_DISP_LLA_DATA	(0x01BC - MX3FB_REG_OFFSET)
+
+/* DI_DISP_SIG_POL bits */
+#define DI_D3_VSYNC_POL_SHIFT		28
+#define DI_D3_HSYNC_POL_SHIFT		27
+#define DI_D3_DRDY_SHARP_POL_SHIFT	26
+#define DI_D3_CLK_POL_SHIFT		25
+#define DI_D3_DATA_POL_SHIFT		24
+
+/* DI_DISP_IF_CONF bits */
+#define DI_D3_CLK_IDLE_SHIFT		26
+#define DI_D3_CLK_SEL_SHIFT		25
+#define DI_D3_DATAMSK_SHIFT		24
+
+enum ipu_panel {
+	IPU_PANEL_SHARP_TFT,
+	IPU_PANEL_TFT,
+};
+
+struct ipu_di_signal_cfg {
+	unsigned datamask_en:1;
+	unsigned clksel_en:1;
+	unsigned clkidle_en:1;
+	unsigned data_pol:1;	/* true = inverted */
+	unsigned clk_pol:1;	/* true = rising edge */
+	unsigned enable_pol:1;
+	unsigned Hsync_pol:1;	/* true = active high */
+	unsigned Vsync_pol:1;
+};
+
+static const struct fb_videomode mx3fb_modedb[] = {
+	{
+		/* 240x320 @ 60 Hz */
+		.name		= "Sharp-QVGA",
+		.refresh	= 60,
+		.xres		= 240,
+		.yres		= 320,
+		.pixclock	= 185925,
+		.left_margin	= 9,
+		.right_margin	= 16,
+		.upper_margin	= 7,
+		.lower_margin	= 9,
+		.hsync_len	= 1,
+		.vsync_len	= 1,
+		.sync		= FB_SYNC_HOR_HIGH_ACT | FB_SYNC_SHARP_MODE |
+				  FB_SYNC_CLK_INVERT | FB_SYNC_DATA_INVERT |
+				  FB_SYNC_CLK_IDLE_EN,
+		.vmode		= FB_VMODE_NONINTERLACED,
+		.flag		= 0,
+	}, {
+		/* 240x33 @ 60 Hz */
+		.name		= "Sharp-CLI",
+		.refresh	= 60,
+		.xres		= 240,
+		.yres		= 33,
+		.pixclock	= 185925,
+		.left_margin	= 9,
+		.right_margin	= 16,
+		.upper_margin	= 7,
+		.lower_margin	= 9 + 287,
+		.hsync_len	= 1,
+		.vsync_len	= 1,
+		.sync		= FB_SYNC_HOR_HIGH_ACT | FB_SYNC_SHARP_MODE |
+				  FB_SYNC_CLK_INVERT | FB_SYNC_DATA_INVERT |
+				  FB_SYNC_CLK_IDLE_EN,
+		.vmode		= FB_VMODE_NONINTERLACED,
+		.flag		= 0,
+	}, {
+		/* 640x480 @ 60 Hz */
+		.name		= "NEC-VGA",
+		.refresh	= 60,
+		.xres		= 640,
+		.yres		= 480,
+		.pixclock	= 38255,
+		.left_margin	= 144,
+		.right_margin	= 0,
+		.upper_margin	= 34,
+		.lower_margin	= 40,
+		.hsync_len	= 1,
+		.vsync_len	= 1,
+		.sync		= FB_SYNC_VERT_HIGH_ACT | FB_SYNC_OE_ACT_HIGH,
+		.vmode		= FB_VMODE_NONINTERLACED,
+		.flag		= 0,
+	}, {
+		/* NTSC TV output */
+		.name		= "TV-NTSC",
+		.refresh	= 60,
+		.xres		= 640,
+		.yres		= 480,
+		.pixclock	= 37538,
+		.left_margin	= 38,
+		.right_margin	= 858 - 640 - 38 - 3,
+		.upper_margin	= 36,
+		.lower_margin	= 518 - 480 - 36 - 1,
+		.hsync_len	= 3,
+		.vsync_len	= 1,
+		.sync		= 0,
+		.vmode		= FB_VMODE_NONINTERLACED,
+		.flag		= 0,
+	}, {
+		/* PAL TV output */
+		.name		= "TV-PAL",
+		.refresh	= 50,
+		.xres		= 640,
+		.yres		= 480,
+		.pixclock	= 37538,
+		.left_margin	= 38,
+		.right_margin	= 960 - 640 - 38 - 32,
+		.upper_margin	= 32,
+		.lower_margin	= 555 - 480 - 32 - 3,
+		.hsync_len	= 32,
+		.vsync_len	= 3,
+		.sync		= 0,
+		.vmode		= FB_VMODE_NONINTERLACED,
+		.flag		= 0,
+	}, {
+		/* TV output VGA mode, 640x480 @ 65 Hz */
+		.name		= "TV-VGA",
+		.refresh	= 60,
+		.xres		= 640,
+		.yres		= 480,
+		.pixclock	= 40574,
+		.left_margin	= 35,
+		.right_margin	= 45,
+		.upper_margin	= 9,
+		.lower_margin	= 1,
+		.hsync_len	= 46,
+		.vsync_len	= 5,
+		.sync		= 0,
+		.vmode		= FB_VMODE_NONINTERLACED,
+		.flag		= 0,
+	},
+};
+
+struct mx3fb_data {
+	struct fb_info		*fbi;
+	struct fb_info		*fbi_ovl;
+	int			backlight_level;
+	void __iomem		*reg_base;
+	spinlock_t		lock;
+	struct device		*dev;
+
+	uint32_t		h_start_width;
+	uint32_t		v_start_width;
+
+	/* IDMAC / dmaengine interface */
+	struct idmac_channel	*idmac_channel[2];	/* We need 2 channels */
+};
+
+struct dma_chan_request {
+	struct mx3fb_data	*mx3fb;
+	enum ipu_channel	id;
+};
+
+/* MX3 specific framebuffer information. */
+struct mx3fb_info {
+	int				blank;
+	enum ipu_channel		ipu_ch;
+	uint32_t			cur_ipu_buf;
+
+	u32				pseudo_palette[16];
+
+	struct completion		flip_cmpl;
+	struct mutex			mutex;		/* Protects fb-ops */
+	struct mx3fb_data		*mx3fb;
+	struct idmac_channel		*idmac_channel;
+	struct dma_async_tx_descriptor	*txd;
+	dma_cookie_t			cookie;
+	struct scatterlist		sg[2];
+};
+
+/* Allocated overlay buffer */
+struct mx3fb_alloc_list {
+	struct list_head	list;
+	dma_addr_t		phy_addr;
+	void			*cpu_addr;
+	size_t			size;
+};
+
+/* A list of overlay buffers */
+static LIST_HEAD(fb_alloc_list);
+
+/* Used fb-mode and bpp. Can be set on kernel command line, therefore file-static. */
+static const char *fb_mode;
+static unsigned long default_bpp = 16;
+
+static u32 mx3fb_read_reg(struct mx3fb_data *mx3fb, unsigned long reg)
+{
+	return __raw_readl(mx3fb->reg_base + reg);
+}
+
+static void mx3fb_write_reg(struct mx3fb_data *mx3fb, u32 value, unsigned long reg)
+{
+	__raw_writel(value, mx3fb->reg_base + reg);
+}
+
+static const uint32_t di_mappings[] = {
+	0x1600AAAA, 0x00E05555, 0x00070000, 3,	/* RGB888 */
+	0x0005000F, 0x000B000F, 0x0011000F, 1,	/* RGB666 */
+	0x0011000F, 0x000B000F, 0x0005000F, 1,	/* BGR666 */
+	0x0004003F, 0x000A000F, 0x000F003F, 1	/* RGB565 */
+};
+
+static void sdc_fb_init(struct mx3fb_info *fbi)
+{
+	struct mx3fb_data *mx3fb = fbi->mx3fb;
+	uint32_t reg;
+
+	reg = mx3fb_read_reg(mx3fb, SDC_COM_CONF);
+
+	/* Also enable foreground for overlay */
+	if (mx3fb->fbi_ovl && fbi == mx3fb->fbi_ovl->par)
+		reg |= SDC_COM_FG_EN;
+
+	mx3fb_write_reg(mx3fb, reg | SDC_COM_BG_EN, SDC_COM_CONF);
+}
+
+/* Returns enabled flag before uninit */
+static uint32_t sdc_fb_uninit(struct mx3fb_info *fbi)
+{
+	struct mx3fb_data *mx3fb = fbi->mx3fb;
+	uint32_t reg, chan_mask;
+
+	reg = mx3fb_read_reg(mx3fb, SDC_COM_CONF);
+
+	/*
+	 * Don't we have to automatically disable overlay when disabling
+	 * background? Attention: cannot test mx3fb->fbi_ovl->par, must
+	 * test mx3fb->fbi->par, because at the time this function is
+	 * called for the first time fbi_ovl is not assigned yet.
+	 */
+	if (fbi == mx3fb->fbi->par)
+		chan_mask = SDC_COM_BG_EN;
+	else
+		chan_mask = SDC_COM_FG_EN;
+
+	mx3fb_write_reg(mx3fb, reg & ~chan_mask, SDC_COM_CONF);
+
+	return reg & chan_mask;
+}
+
+static void sdc_enable_channel(struct mx3fb_info *mxc_fbi)
+{
+	struct mx3fb_data *mx3fb = mxc_fbi->mx3fb;
+	struct idmac_channel *ichan = mxc_fbi->idmac_channel;
+	struct dma_chan *dma_chan = &ichan->dma_chan;
+	unsigned long flags;
+	dma_cookie_t cookie;
+
+	if (!mxc_fbi->txd || !mxc_fbi->txd->tx_submit)
+		return;
+
+	dev_dbg(mx3fb->dev, "mx3fbi %p, desc %p, sg %p\n", mxc_fbi,
+		to_tx_desc(mxc_fbi->txd), to_tx_desc(mxc_fbi->txd)->sg);
+
+	/* This enables the channel */
+	if (mxc_fbi->cookie < 0) {
+		cookie = mxc_fbi->txd->tx_submit(mxc_fbi->txd);
+	} else {
+		/* Just re-activate the same buffer */
+		dma_async_issue_pending(dma_chan);
+		cookie = mxc_fbi->cookie;
+	}
+
+	if (cookie >= 0) {
+		spin_lock_irqsave(&mx3fb->lock, flags);
+		sdc_fb_init(mxc_fbi);
+		mxc_fbi->cookie = cookie;
+		spin_unlock_irqrestore(&mx3fb->lock, flags);
+	}
+
+	/*
+	 * Attention! Without this msleep the channel keeps generating
+	 * interrupts. Next sdc_set_brightness() is going to be called
+	 * from mx3fb_blank().
+	 */
+	msleep(2);
+}
+
+static void sdc_disable_channel(struct mx3fb_info *mxc_fbi)
+{
+	struct mx3fb_data *mx3fb = mxc_fbi->mx3fb;
+	uint32_t enabled;
+	unsigned long flags;
+
+	spin_lock_irqsave(&mx3fb->lock, flags);
+
+	enabled = sdc_fb_uninit(mxc_fbi);
+
+	spin_unlock_irqrestore(&mx3fb->lock, flags);
+
+	mxc_fbi->txd->chan->device->device_terminate_all(mxc_fbi->txd->chan);
+}
+
+/**
+ * Set the window position of the foreground or background plane modes.
+ *
+ * @param       channel         Input parameter for the logical channel ID.
+ * @param       x_pos           The X coordinate position to place window at.
+ *                              The position is relative to the top left corner.
+ * @param       y_pos           The Y coordinate position to place window at.
+ *                              The position is relative to the top left corner.
+ * @return      This function returns 0 on success or negative error code on fail
+ */
+static int sdc_set_window_pos(struct mx3fb_data *mx3fb, enum ipu_channel channel,
+			      int16_t x_pos, int16_t y_pos)
+{
+	x_pos += mx3fb->h_start_width;
+	y_pos += mx3fb->v_start_width;
+
+	switch (channel) {
+	case IDMAC_SDC_0:
+		mx3fb_write_reg(mx3fb, (x_pos << 16) | y_pos, SDC_BG_POS);
+		break;
+	case IDMAC_SDC_1:
+		mx3fb_write_reg(mx3fb, (x_pos << 16) | y_pos, SDC_FG_POS);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/**
+ * Initialize a synchronous LCD panel.
+ *
+ * @param       panel           The type of panel.
+ * @param       pixel_clk       Desired pixel clock frequency in Hz.
+ * @param       pixel_fmt       Input parameter for pixel format of buffer. Pixel
+ *                              format is a FOURCC ASCII code.
+ * @param       width           The width of panel in pixels.
+ * @param       height          The height of panel in pixels.
+ * @param       hStartWidth     The number of pixel clocks between the HSYNC
+ *                              signal pulse and the start of valid data.
+ * @param       hSyncWidth      The width of the HSYNC signal in units of pixel
+ *                              clocks.
+ * @param       hEndWidth       The number of pixel clocks between the end of
+ *                              valid data and the HSYNC signal for next line.
+ * @param       vStartWidth     The number of lines between the VSYNC
+ *                              signal pulse and the start of valid data.
+ * @param       vSyncWidth      The width of the VSYNC signal in units of lines
+ * @param       vEndWidth       The number of lines between the end of valid
+ *                              data and the VSYNC signal for next frame.
+ * @param       sig             Bitfield of signal polarities for LCD interface.
+ * @return      This function returns 0 on success or negative error code on
+ *              fail.
+ */
+static int sdc_init_panel(struct mx3fb_data *mx3fb, enum ipu_panel panel,
+			  uint32_t pixel_clk,
+			  uint16_t width, uint16_t height,
+			  enum pixel_fmt pixel_fmt,
+			  uint16_t h_start_width, uint16_t h_sync_width,
+			  uint16_t h_end_width, uint16_t v_start_width,
+			  uint16_t v_sync_width, uint16_t v_end_width,
+			  struct ipu_di_signal_cfg sig)
+{
+	unsigned long lock_flags;
+	uint32_t reg;
+	uint32_t old_conf;
+	uint32_t div;
+	struct clk *ipu_clk;
+
+	dev_dbg(mx3fb->dev, "panel size = %d x %d", width, height);
+
+	if (v_sync_width == 0 || h_sync_width == 0)
+		return -EINVAL;
+
+	/* Init panel size and blanking periods */
+	reg = ((uint32_t) (h_sync_width - 1) << 26) |
+		((uint32_t) (width + h_start_width + h_end_width - 1) << 16);
+	mx3fb_write_reg(mx3fb, reg, SDC_HOR_CONF);
+
+	printk(" hor_conf %x,", reg);
+
+	reg = ((uint32_t) (v_sync_width - 1) << 26) | SDC_V_SYNC_WIDTH_L |
+	    ((uint32_t) (height + v_start_width + v_end_width - 1) << 16);
+	mx3fb_write_reg(mx3fb, reg, SDC_VER_CONF);
+
+	printk(" ver_conf %x\n", reg);
+
+	mx3fb->h_start_width = h_start_width;
+	mx3fb->v_start_width = v_start_width;
+
+	switch (panel) {
+	case IPU_PANEL_SHARP_TFT:
+		mx3fb_write_reg(mx3fb, 0x00FD0102L, SDC_SHARP_CONF_1);
+		mx3fb_write_reg(mx3fb, 0x00F500F4L, SDC_SHARP_CONF_2);
+		mx3fb_write_reg(mx3fb, SDC_COM_SHARP | SDC_COM_TFT_COLOR, SDC_COM_CONF);
+		break;
+	case IPU_PANEL_TFT:
+		mx3fb_write_reg(mx3fb, SDC_COM_TFT_COLOR, SDC_COM_CONF);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* Init clocking */
+
+	/*
+	 * Calculate divider: fractional part is 4 bits so simply multiple by
+	 * 2^4 to get fractional part, as long as we stay under ~250MHz and on
+	 * i.MX31 it (HSP_CLK) is <= 178MHz. Currently 128.267MHz
+	 */
+	dev_dbg(mx3fb->dev, "pixel clk = %d\n", pixel_clk);
+
+	ipu_clk = clk_get(mx3fb->dev, "ipu_clk");
+	div = clk_get_rate(ipu_clk) * 16 / pixel_clk;
+	clk_put(ipu_clk);
+
+	if (div < 0x40) {	/* Divider less than 4 */
+		dev_dbg(mx3fb->dev,
+			"InitPanel() - Pixel clock divider less than 4\n");
+		div = 0x40;
+	}
+
+	spin_lock_irqsave(&mx3fb->lock, lock_flags);
+
+	/*
+	 * DISP3_IF_CLK_DOWN_WR is half the divider value and 2 fraction bits
+	 * fewer. Subtract 1 extra from DISP3_IF_CLK_DOWN_WR based on timing
+	 * debug. DISP3_IF_CLK_UP_WR is 0
+	 */
+	mx3fb_write_reg(mx3fb, (((div / 8) - 1) << 22) | div, DI_DISP3_TIME_CONF);
+
+	/* DI settings */
+	old_conf = mx3fb_read_reg(mx3fb, DI_DISP_IF_CONF) & 0x78FFFFFF;
+	old_conf |= sig.datamask_en << DI_D3_DATAMSK_SHIFT |
+	    sig.clksel_en << DI_D3_CLK_SEL_SHIFT |
+	    sig.clkidle_en << DI_D3_CLK_IDLE_SHIFT;
+	mx3fb_write_reg(mx3fb, old_conf, DI_DISP_IF_CONF);
+
+	old_conf = mx3fb_read_reg(mx3fb, DI_DISP_SIG_POL) & 0xE0FFFFFF;
+	old_conf |= sig.data_pol << DI_D3_DATA_POL_SHIFT |
+	    sig.clk_pol << DI_D3_CLK_POL_SHIFT |
+	    sig.enable_pol << DI_D3_DRDY_SHARP_POL_SHIFT |
+	    sig.Hsync_pol << DI_D3_HSYNC_POL_SHIFT |
+	    sig.Vsync_pol << DI_D3_VSYNC_POL_SHIFT;
+	mx3fb_write_reg(mx3fb, old_conf, DI_DISP_SIG_POL);
+
+	switch (pixel_fmt) {
+	case IPU_PIX_FMT_RGB24:
+		mx3fb_write_reg(mx3fb, di_mappings[0], DI_DISP3_B0_MAP);
+		mx3fb_write_reg(mx3fb, di_mappings[1], DI_DISP3_B1_MAP);
+		mx3fb_write_reg(mx3fb, di_mappings[2], DI_DISP3_B2_MAP);
+		mx3fb_write_reg(mx3fb, mx3fb_read_reg(mx3fb, DI_DISP_ACC_CC) |
+			     ((di_mappings[3] - 1) << 12), DI_DISP_ACC_CC);
+		break;
+	case IPU_PIX_FMT_RGB666:
+		mx3fb_write_reg(mx3fb, di_mappings[4], DI_DISP3_B0_MAP);
+		mx3fb_write_reg(mx3fb, di_mappings[5], DI_DISP3_B1_MAP);
+		mx3fb_write_reg(mx3fb, di_mappings[6], DI_DISP3_B2_MAP);
+		mx3fb_write_reg(mx3fb, mx3fb_read_reg(mx3fb, DI_DISP_ACC_CC) |
+			     ((di_mappings[7] - 1) << 12), DI_DISP_ACC_CC);
+		break;
+	case IPU_PIX_FMT_BGR666:
+		mx3fb_write_reg(mx3fb, di_mappings[8], DI_DISP3_B0_MAP);
+		mx3fb_write_reg(mx3fb, di_mappings[9], DI_DISP3_B1_MAP);
+		mx3fb_write_reg(mx3fb, di_mappings[10], DI_DISP3_B2_MAP);
+		mx3fb_write_reg(mx3fb, mx3fb_read_reg(mx3fb, DI_DISP_ACC_CC) |
+			     ((di_mappings[11] - 1) << 12), DI_DISP_ACC_CC);
+		break;
+	default:
+		mx3fb_write_reg(mx3fb, di_mappings[12], DI_DISP3_B0_MAP);
+		mx3fb_write_reg(mx3fb, di_mappings[13], DI_DISP3_B1_MAP);
+		mx3fb_write_reg(mx3fb, di_mappings[14], DI_DISP3_B2_MAP);
+		mx3fb_write_reg(mx3fb, mx3fb_read_reg(mx3fb, DI_DISP_ACC_CC) |
+			     ((di_mappings[15] - 1) << 12), DI_DISP_ACC_CC);
+		break;
+	}
+
+	spin_unlock_irqrestore(&mx3fb->lock, lock_flags);
+
+	dev_dbg(mx3fb->dev, "DI_DISP_IF_CONF = 0x%08X\n",
+		mx3fb_read_reg(mx3fb, DI_DISP_IF_CONF));
+	dev_dbg(mx3fb->dev, "DI_DISP_SIG_POL = 0x%08X\n",
+		mx3fb_read_reg(mx3fb, DI_DISP_SIG_POL));
+	dev_dbg(mx3fb->dev, "DI_DISP3_TIME_CONF = 0x%08X\n",
+		mx3fb_read_reg(mx3fb, DI_DISP3_TIME_CONF));
+
+	return 0;
+}
+
+/**
+ * Set the transparent color key for SDC graphic plane.
+ *
+ * @param       channel         Input parameter for the logical channel ID.
+ * @param       enable          Boolean to enable or disable color key
+ * @param       colorKey        24-bit RGB color to use as transparent color key.
+ * @return      This function returns 0 on success or negative error code on fail
+ */
+static int sdc_set_color_key(struct mx3fb_data *mx3fb, enum ipu_channel channel,
+			     bool enable, uint32_t color_key)
+{
+	uint32_t reg, sdc_conf;
+	unsigned long lock_flags;
+
+	spin_lock_irqsave(&mx3fb->lock, lock_flags);
+
+	sdc_conf = mx3fb_read_reg(mx3fb, SDC_COM_CONF);
+	if (channel == IDMAC_SDC_0)
+		sdc_conf &= ~SDC_COM_GWSEL;
+	else
+		sdc_conf |= SDC_COM_GWSEL;
+
+	if (enable) {
+		reg = mx3fb_read_reg(mx3fb, SDC_GW_CTRL) & 0xFF000000L;
+		mx3fb_write_reg(mx3fb, reg | (color_key & 0x00FFFFFFL),
+			     SDC_GW_CTRL);
+
+		sdc_conf |= SDC_COM_KEY_COLOR_G;
+	} else {
+		sdc_conf &= ~SDC_COM_KEY_COLOR_G;
+	}
+	mx3fb_write_reg(mx3fb, sdc_conf, SDC_COM_CONF);
+
+	spin_unlock_irqrestore(&mx3fb->lock, lock_flags);
+
+	return 0;
+}
+
+/**
+ * Set the foreground and background plane global alpha blending modes.
+ *
+ * @param       enable          Boolean to enable or disable global alpha
+ *                              blending. If disabled, per pixel blending is used.
+ * @param       alpha           Global alpha value.
+ * @return      This function returns 0 on success or negative error code on fail
+ */
+static int sdc_set_global_alpha(struct mx3fb_data *mx3fb, bool enable, uint8_t alpha)
+{
+	uint32_t reg;
+	unsigned long lock_flags;
+
+	spin_lock_irqsave(&mx3fb->lock, lock_flags);
+
+	if (enable) {
+		reg = mx3fb_read_reg(mx3fb, SDC_GW_CTRL) & 0x00FFFFFFL;
+		mx3fb_write_reg(mx3fb, reg | ((uint32_t) alpha << 24), SDC_GW_CTRL);
+
+		reg = mx3fb_read_reg(mx3fb, SDC_COM_CONF);
+		mx3fb_write_reg(mx3fb, reg | SDC_COM_GLB_A, SDC_COM_CONF);
+	} else {
+		reg = mx3fb_read_reg(mx3fb, SDC_COM_CONF);
+		mx3fb_write_reg(mx3fb, reg & ~SDC_COM_GLB_A, SDC_COM_CONF);
+	}
+
+	spin_unlock_irqrestore(&mx3fb->lock, lock_flags);
+
+	return 0;
+}
+
+static void sdc_set_brightness(struct mx3fb_data *mx3fb, uint8_t value)
+{
+	/* This might be board-specific */
+	mx3fb_write_reg(mx3fb, 0x03000000UL | value << 16, SDC_PWM_CTRL);
+	return;
+}
+
+static uint32_t bpp_to_pixfmt(int bpp)
+{
+	uint32_t pixfmt = 0;
+	switch (bpp) {
+	case 24:
+		pixfmt = IPU_PIX_FMT_BGR24;
+		break;
+	case 32:
+		pixfmt = IPU_PIX_FMT_BGR32;
+		break;
+	case 16:
+		pixfmt = IPU_PIX_FMT_RGB565;
+		break;
+	}
+	return pixfmt;
+}
+
+static int mx3fb_blank(int blank, struct fb_info *fbi);
+static int mx3fb_map_video_memory(struct fb_info *fbi);
+static int mx3fb_unmap_video_memory(struct fb_info *fbi);
+
+/*
+ * Set fixed framebuffer parameters based on variable settings.
+ *
+ * @param       info     framebuffer information pointer
+ */
+static int mx3fb_set_fix(struct fb_info *fbi)
+{
+	struct fb_fix_screeninfo *fix = &fbi->fix;
+	struct fb_var_screeninfo *var = &fbi->var;
+	struct mx3fb_info *mxc_fbi = fbi->par;
+
+	if (mxc_fbi->ipu_ch == IDMAC_SDC_1)
+		strncpy(fix->id, "DISP3 FG", 8);
+	else
+		strncpy(fix->id, "DISP3 BG", 8);
+
+	fix->line_length = var->xres_virtual * var->bits_per_pixel / 8;
+
+	fix->type = FB_TYPE_PACKED_PIXELS;
+	fix->accel = FB_ACCEL_NONE;
+	fix->visual = FB_VISUAL_TRUECOLOR;
+	fix->xpanstep = 1;
+	fix->ypanstep = 1;
+
+	return 0;
+}
+
+static void mx3fb_dma_done(void *arg)
+{
+	struct idmac_tx_desc *tx_desc = to_tx_desc(arg);
+	struct dma_chan *chan = tx_desc->txd.chan;
+	struct idmac_channel *ichannel = to_idmac_chan(chan);
+	struct mx3fb_data *mx3fb = ichannel->client;
+	struct mx3fb_info *mxc_fbi = mx3fb->fbi->par;
+	struct mx3fb_info *mxc_fbi_ovl = mx3fb->fbi_ovl ? mx3fb->fbi_ovl->par :
+		NULL;
+	struct mx3fb_info *mxc_fbi_cur;
+
+	if (ichannel == mxc_fbi->idmac_channel) {
+		mxc_fbi_cur = mxc_fbi;
+	} else if (mxc_fbi_ovl && ichannel == mxc_fbi_ovl->idmac_channel) {
+		mxc_fbi_cur = mxc_fbi_ovl;
+	} else {
+		WARN(1, "Cannot identify channel!\n");
+		return;
+	}
+
+	/* We only need one interrupt, it will be re-enabled as needed */
+	disable_irq(ichannel->eof_irq);
+
+	complete(&mxc_fbi_cur->flip_cmpl);
+}
+
+/*
+ * Set framebuffer parameters and change the operating mode. This function is
+ * either called at the very beginning when setting things up, or it cleans up
+ * any existing buffer settings itself
+ *
+ * @param       fbi     framebuffer information pointer
+ */
+static int mx3fb_set_par(struct fb_info *fbi)
+{
+	u32 mem_len;
+	struct ipu_di_signal_cfg sig_cfg;
+	enum ipu_panel mode = IPU_PANEL_TFT;
+	struct mx3fb_info *mxc_fbi = fbi->par;
+	struct mx3fb_data *mx3fb = mxc_fbi->mx3fb;
+	struct idmac_channel *ichan = mxc_fbi->idmac_channel;
+	struct idmac_video_param *video = &ichan->params.video;
+	struct dma_chan *dma_chan = &ichan->dma_chan;
+	struct scatterlist *sg = mxc_fbi->sg;
+	size_t screen_size;
+
+	mutex_lock(&mxc_fbi->mutex);
+
+	/* Total cleanup */
+	if (mxc_fbi->txd)
+		sdc_disable_channel(mxc_fbi);
+
+	mx3fb_set_fix(fbi);
+
+	mem_len = fbi->var.yres_virtual * fbi->fix.line_length;
+	if (mem_len > fbi->fix.smem_len) {
+		if (fbi->fix.smem_start)
+			mx3fb_unmap_video_memory(fbi);
+
+		fbi->fix.smem_len = mem_len;
+		if (mx3fb_map_video_memory(fbi) < 0) {
+			mutex_unlock(&mxc_fbi->mutex);
+			return -ENOMEM;
+		}
+	}
+
+	screen_size = fbi->fix.line_length * fbi->var.yres;
+
+	sg_init_table(&sg[0], 1);
+	sg_init_table(&sg[1], 1);
+
+	sg_dma_address(&sg[0])	= fbi->fix.smem_start;
+	sg_set_page(&sg[0], virt_to_page(fbi->screen_base),
+		    fbi->fix.smem_len,
+		    offset_in_page(fbi->screen_base));
+
+	mxc_fbi->txd = dma_chan->device->device_prep_slave_sg(dma_chan, &sg[0],
+					1, DMA_TO_DEVICE, DMA_PREP_INTERRUPT);
+	if (!mxc_fbi->txd) {
+		mutex_unlock(&mxc_fbi->mutex);
+		return -EIO;
+	}
+
+	mxc_fbi->txd->callback_param	= mxc_fbi->txd;
+	mxc_fbi->txd->callback		= mx3fb_dma_done;
+
+	if (mxc_fbi->ipu_ch == IDMAC_SDC_0) {
+		memset(&sig_cfg, 0, sizeof(sig_cfg));
+		if (fbi->var.sync & FB_SYNC_HOR_HIGH_ACT)
+			sig_cfg.Hsync_pol = true;
+		if (fbi->var.sync & FB_SYNC_VERT_HIGH_ACT)
+			sig_cfg.Vsync_pol = true;
+		if (fbi->var.sync & FB_SYNC_CLK_INVERT)
+			sig_cfg.clk_pol = true;
+		if (fbi->var.sync & FB_SYNC_DATA_INVERT)
+			sig_cfg.data_pol = true;
+		if (fbi->var.sync & FB_SYNC_OE_ACT_HIGH)
+			sig_cfg.enable_pol = true;
+		if (fbi->var.sync & FB_SYNC_CLK_IDLE_EN)
+			sig_cfg.clkidle_en = true;
+		if (fbi->var.sync & FB_SYNC_CLK_SEL_EN)
+			sig_cfg.clksel_en = true;
+		if (fbi->var.sync & FB_SYNC_SHARP_MODE)
+			mode = IPU_PANEL_SHARP_TFT;
+
+		dev_dbg(fbi->device, "pixclock = %ul Hz\n",
+			(u32) (PICOS2KHZ(fbi->var.pixclock) * 1000UL));
+
+		if (sdc_init_panel(mx3fb, mode,
+				   (PICOS2KHZ(fbi->var.pixclock)) * 1000UL,
+				   fbi->var.xres, fbi->var.yres,
+				   (fbi->var.sync & FB_SYNC_SWAP_RGB) ?
+				   IPU_PIX_FMT_BGR666 : IPU_PIX_FMT_RGB666,
+				   fbi->var.left_margin,
+				   fbi->var.hsync_len,
+				   fbi->var.right_margin +
+				   fbi->var.hsync_len,
+				   fbi->var.upper_margin,
+				   fbi->var.vsync_len,
+				   fbi->var.lower_margin +
+				   fbi->var.vsync_len, sig_cfg) != 0) {
+			mutex_unlock(&mxc_fbi->mutex);
+			dev_err(fbi->device,
+				"mx3fb: Error initializing panel.\n");
+			return -EINVAL;
+		}
+	}
+
+	sdc_set_window_pos(mx3fb, mxc_fbi->ipu_ch, 0, 0);
+
+	mxc_fbi->cur_ipu_buf	= 0;
+
+	video->out_pixel_fmt	= bpp_to_pixfmt(fbi->var.bits_per_pixel);
+	video->out_width	= fbi->var.xres;
+	video->out_height	= fbi->var.yres;
+	video->out_stride	= fbi->var.xres_virtual;
+
+	if (mxc_fbi->blank == FB_BLANK_UNBLANK)
+		sdc_enable_channel(mxc_fbi);
+
+	mutex_unlock(&mxc_fbi->mutex);
+
+	return 0;
+}
+
+/*
+ * Check framebuffer variable parameters and adjust to valid values.
+ *
+ * @param       var      framebuffer variable parameters
+ *
+ * @param       info     framebuffer information pointer
+ */
+static int mx3fb_check_var(struct fb_var_screeninfo *var, struct fb_info *fbi)
+{
+	u32 vtotal;
+	u32 htotal;
+
+	if (var->xres_virtual < var->xres)
+		var->xres_virtual = var->xres;
+	if (var->yres_virtual < var->yres)
+		var->yres_virtual = var->yres;
+
+	if ((var->bits_per_pixel != 32) && (var->bits_per_pixel != 24) &&
+	    (var->bits_per_pixel != 16))
+		var->bits_per_pixel = default_bpp;
+
+	switch (var->bits_per_pixel) {
+	case 16:
+		var->red.length = 5;
+		var->red.offset = 11;
+		var->red.msb_right = 0;
+
+		var->green.length = 6;
+		var->green.offset = 5;
+		var->green.msb_right = 0;
+
+		var->blue.length = 5;
+		var->blue.offset = 0;
+		var->blue.msb_right = 0;
+
+		var->transp.length = 0;
+		var->transp.offset = 0;
+		var->transp.msb_right = 0;
+		break;
+	case 24:
+		var->red.length = 8;
+		var->red.offset = 16;
+		var->red.msb_right = 0;
+
+		var->green.length = 8;
+		var->green.offset = 8;
+		var->green.msb_right = 0;
+
+		var->blue.length = 8;
+		var->blue.offset = 0;
+		var->blue.msb_right = 0;
+
+		var->transp.length = 0;
+		var->transp.offset = 0;
+		var->transp.msb_right = 0;
+		break;
+	case 32:
+		var->red.length = 8;
+		var->red.offset = 16;
+		var->red.msb_right = 0;
+
+		var->green.length = 8;
+		var->green.offset = 8;
+		var->green.msb_right = 0;
+
+		var->blue.length = 8;
+		var->blue.offset = 0;
+		var->blue.msb_right = 0;
+
+		var->transp.length = 8;
+		var->transp.offset = 24;
+		var->transp.msb_right = 0;
+		break;
+	}
+
+	if (var->pixclock < 1000) {
+		htotal = var->xres + var->right_margin + var->hsync_len +
+		    var->left_margin;
+		vtotal = var->yres + var->lower_margin + var->vsync_len +
+		    var->upper_margin;
+		var->pixclock = (vtotal * htotal * 6UL) / 100UL;
+		var->pixclock = KHZ2PICOS(var->pixclock);
+		dev_dbg(fbi->device, "pixclock set for 60Hz refresh = %u ps\n",
+			var->pixclock);
+	}
+
+	var->height = -1;
+	var->width = -1;
+	var->grayscale = 0;
+
+	/* Copy nonstd field to/from sync for fbset usage */
+	var->sync |= var->nonstd;
+	var->nonstd |= var->sync;
+
+	return 0;
+}
+
+static u_int _chan_to_field(u_int chan, struct fb_bitfield *bf)
+{
+	chan &= 0xffff;
+	chan >>= 16 - bf->length;
+	return chan << bf->offset;
+}
+
+static int mx3fb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
+			   u_int trans, struct fb_info *fbi)
+{
+	struct mx3fb_info *mxc_fbi = fbi->par;
+	unsigned int val;
+	int ret = 1;
+
+	mutex_lock(&mxc_fbi->mutex);
+	/*
+	 * If greyscale is true, then we convert the RGB value
+	 * to greyscale no matter what visual we are using.
+	 */
+	if (fbi->var.grayscale)
+		red = green = blue = (19595 * red + 38470 * green +
+				      7471 * blue) >> 16;
+	switch (fbi->fix.visual) {
+	case FB_VISUAL_TRUECOLOR:
+		/*
+		 * 16-bit True Colour.  We encode the RGB value
+		 * according to the RGB bitfield information.
+		 */
+		if (regno < 16) {
+			u32 *pal = fbi->pseudo_palette;
+
+			val = _chan_to_field(red, &fbi->var.red);
+			val |= _chan_to_field(green, &fbi->var.green);
+			val |= _chan_to_field(blue, &fbi->var.blue);
+
+			pal[regno] = val;
+
+			ret = 0;
+		}
+		break;
+
+	case FB_VISUAL_STATIC_PSEUDOCOLOR:
+	case FB_VISUAL_PSEUDOCOLOR:
+		break;
+	}
+	mutex_unlock(&mxc_fbi->mutex);
+
+	return ret;
+}
+
+/*
+ * Function to handle custom ioctls for MXC framebuffer.
+ *
+ * @param       inode   inode struct
+ *
+ * @param       file    file struct
+ *
+ * @param       cmd     Ioctl command to handle
+ *
+ * @param       arg     User pointer to command arguments
+ *
+ * @param       fbi     framebuffer information pointer
+ */
+static int mx3fb_ioctl_ovl(struct fb_info *fbi, unsigned int cmd,
+			   unsigned long arg)
+{
+	struct mx3fb_info *mxc_fbi = fbi->par;
+	int retval = 0;
+	int __user *argp = (void __user *)arg;
+	struct mx3fb_alloc_list *mem;
+	int size;
+	unsigned long offset;
+
+	switch (cmd) {
+	case FBIO_ALLOC:
+		if (get_user(size, argp))
+			return -EFAULT;
+
+		mem = kzalloc(sizeof(*mem), GFP_KERNEL);
+		if (mem == NULL)
+			return -ENOMEM;
+
+		mem->size = PAGE_ALIGN(size);
+
+		mem->cpu_addr = dma_alloc_coherent(fbi->device, size,
+						   &mem->phy_addr,
+						   GFP_DMA);
+		if (mem->cpu_addr == NULL) {
+			kfree(mem);
+			return -ENOMEM;
+		}
+
+		mutex_lock(&mxc_fbi->mutex);
+		list_add(&mem->list, &fb_alloc_list);
+		mutex_unlock(&mxc_fbi->mutex);
+
+		dev_dbg(fbi->device, "allocated %d bytes @ 0x%08X\n",
+			mem->size, mem->phy_addr);
+
+		if (put_user(mem->phy_addr, argp))
+			return -EFAULT;
+
+		break;
+	case FBIO_FREE:
+		if (get_user(offset, argp))
+			return -EFAULT;
+
+		retval = -EINVAL;
+		mutex_lock(&mxc_fbi->mutex);
+		list_for_each_entry(mem, &fb_alloc_list, list) {
+			if (mem->phy_addr == offset) {
+				list_del(&mem->list);
+				dma_free_coherent(fbi->device,
+						  mem->size,
+						  mem->cpu_addr,
+						  mem->phy_addr);
+				kfree(mem);
+				retval = 0;
+				break;
+			}
+		}
+		mutex_unlock(&mxc_fbi->mutex);
+
+		break;
+	default:
+		retval = -EINVAL;
+	}
+
+	return retval;
+}
+
+/*
+ * mx3fb_blank():
+ *      Blank the display.
+ */
+static int mx3fb_blank(int blank, struct fb_info *fbi)
+{
+	struct mx3fb_info *mxc_fbi = fbi->par;
+	struct mx3fb_data *mx3fb = mxc_fbi->mx3fb;
+
+	dev_dbg(fbi->device, "blank = %d\n", blank);
+
+	if (mxc_fbi->blank == blank)
+		return 0;
+
+	mutex_lock(&mxc_fbi->mutex);
+	mxc_fbi->blank = blank;
+
+	switch (blank) {
+	case FB_BLANK_POWERDOWN:
+	case FB_BLANK_VSYNC_SUSPEND:
+	case FB_BLANK_HSYNC_SUSPEND:
+	case FB_BLANK_NORMAL:
+		sdc_disable_channel(mxc_fbi);
+		sdc_set_brightness(mx3fb, 0);
+		break;
+	case FB_BLANK_UNBLANK:
+		sdc_enable_channel(mxc_fbi);
+		sdc_set_brightness(mx3fb, mx3fb->backlight_level);
+		break;
+	}
+	mutex_unlock(&mxc_fbi->mutex);
+
+	return 0;
+}
+
+/*
+ * mx3fb_blank_ovl():
+ *      Blank the display.
+ */
+static int mx3fb_blank_ovl(int blank, struct fb_info *fbi)
+{
+	struct mx3fb_info *mxc_fbi = fbi->par;
+
+	dev_dbg(fbi->device, "ovl blank = %d\n", blank);
+
+	if (mxc_fbi->blank == blank)
+		return 0;
+
+	mutex_lock(&mxc_fbi->mutex);
+	mxc_fbi->blank = blank;
+
+	switch (blank) {
+	case FB_BLANK_POWERDOWN:
+	case FB_BLANK_VSYNC_SUSPEND:
+	case FB_BLANK_HSYNC_SUSPEND:
+	case FB_BLANK_NORMAL:
+		sdc_disable_channel(mxc_fbi);
+		break;
+	case FB_BLANK_UNBLANK:
+		sdc_enable_channel(mxc_fbi);
+		break;
+	}
+	mutex_unlock(&mxc_fbi->mutex);
+
+	return 0;
+}
+
+/*
+ * Pan or Wrap the Display
+ *
+ * This call looks only at xoffset, yoffset and the FB_VMODE_YWRAP flag
+ *
+ * @param               var     Variable screen buffer information
+ * @param               info    Framebuffer information pointer
+ */
+static int mx3fb_pan_display(struct fb_var_screeninfo *var,
+			     struct fb_info *fbi)
+{
+	struct mx3fb_info *mxc_fbi = fbi->par;
+	u32 y_bottom;
+	unsigned long base;
+	off_t offset;
+	dma_cookie_t cookie;
+	struct idmac_tx_desc *desc = to_tx_desc(mxc_fbi->txd);
+	struct scatterlist *sg = desc->sg;
+	struct dma_chan *dma_chan = &mxc_fbi->idmac_channel->dma_chan;
+	struct dma_async_tx_descriptor *txd;
+	int ret;
+
+	if (var->xoffset > 0) {
+		dev_dbg(fbi->device, "x panning not supported\n");
+		return -EINVAL;
+	}
+
+	if (fbi->var.xoffset == var->xoffset &&
+	    fbi->var.yoffset == var->yoffset)
+		return 0;	/* No change, do nothing */
+
+	y_bottom = var->yoffset;
+
+	if (!(var->vmode & FB_VMODE_YWRAP))
+		y_bottom += var->yres;
+
+	if (y_bottom > fbi->var.yres_virtual)
+		return -EINVAL;
+
+	mutex_lock(&mxc_fbi->mutex);
+
+	offset = (var->yoffset * var->xres_virtual + var->xoffset) *
+		(var->bits_per_pixel / 8);
+	base = fbi->fix.smem_start + offset;
+
+	dev_dbg(fbi->device, "Updating SDC BG buf %d address=0x%08lX\n",
+		mxc_fbi->cur_ipu_buf, base);
+
+	/*
+	 * We enable the End of Frame interrupt, which will free a tx-descriptor,
+	 * which we will need for the next device_prep_slave_sg(). The
+	 * IRQ-handler will disable the IRQ again.
+	 */
+	init_completion(&mxc_fbi->flip_cmpl);
+	enable_irq(mxc_fbi->idmac_channel->eof_irq);
+
+	ret = wait_for_completion_timeout(&mxc_fbi->flip_cmpl, HZ / 10);
+	if (ret <= 0) {
+		mutex_unlock(&mxc_fbi->mutex);
+		dev_info(fbi->device, "Panning failed due to %s\n", ret < 0 ?
+			 "user interrupt" : "timeout");
+		return ret ? : -ETIMEDOUT;
+	}
+
+	mxc_fbi->cur_ipu_buf = !mxc_fbi->cur_ipu_buf;
+
+	sg_dma_address(&sg[mxc_fbi->cur_ipu_buf]) = base;
+	sg_set_page(&sg[mxc_fbi->cur_ipu_buf],
+		    virt_to_page(fbi->screen_base + offset), fbi->fix.smem_len,
+		    offset_in_page(fbi->screen_base + offset));
+
+	txd = dma_chan->device->device_prep_slave_sg(dma_chan, sg +
+		mxc_fbi->cur_ipu_buf, 1, DMA_TO_DEVICE, DMA_PREP_INTERRUPT);
+	if (!txd) {
+		dev_err(fbi->device,
+			"Error preparing a DMA transaction descriptor.\n");
+		mutex_unlock(&mxc_fbi->mutex);
+		return -EIO;
+	}
+
+	/*
+	 * Emulate original mx3fb behaviour: each new call to idmac_tx_submit()
+	 * should switch to another buffer
+	 */
+	cookie = txd->tx_submit(txd);
+	if (cookie < 0) {
+		dev_err(fbi->device,
+			"Error updating SDC buf %d to address=0x%08lX\n",
+			mxc_fbi->cur_ipu_buf, base);
+		mutex_unlock(&mxc_fbi->mutex);
+		return -EIO;
+	}
+
+	mxc_fbi->txd = txd;
+
+	fbi->var.xoffset = var->xoffset;
+	fbi->var.yoffset = var->yoffset;
+
+	if (var->vmode & FB_VMODE_YWRAP)
+		fbi->var.vmode |= FB_VMODE_YWRAP;
+	else
+		fbi->var.vmode &= ~FB_VMODE_YWRAP;
+
+	mutex_unlock(&mxc_fbi->mutex);
+
+	dev_dbg(fbi->device, "Update complete\n");
+
+	return 0;
+}
+
+/*
+ * Function to handle custom mmap for MXC overlay framebuffer.
+ *
+ * @param       fbi     framebuffer information pointer
+ *
+ * @param       vma     Pointer to vm_area_struct
+ */
+static int mx3fb_mmap(struct fb_info *fbi, struct vm_area_struct *vma)
+{
+	struct mx3fb_info *mxc_fbi = fbi->par;
+	bool found = false;
+	size_t len;
+	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
+	struct mx3fb_alloc_list *mem;
+
+	mutex_lock(&mxc_fbi->mutex);
+
+	if (offset < fbi->fix.smem_len) {
+		/* mapping framebuffer memory */
+		len = fbi->fix.smem_len - offset;
+		vma->vm_pgoff = (fbi->fix.smem_start + offset) >> PAGE_SHIFT;
+	} else {
+		list_for_each_entry(mem, &fb_alloc_list, list) {
+			if (offset == mem->phy_addr) {
+				found = true;
+				len = mem->size;
+				break;
+			}
+		}
+		if (!found) {
+			mutex_unlock(&mxc_fbi->mutex);
+			return -EINVAL;
+		}
+	}
+
+	len = PAGE_ALIGN(len);
+	if (vma->vm_end - vma->vm_start > len) {
+		mutex_unlock(&mxc_fbi->mutex);
+		return -EINVAL;
+	}
+
+	/* make buffers write-thru cacheable */
+	vma->vm_page_prot = __pgprot(pgprot_val(vma->vm_page_prot) &
+				     ~L_PTE_BUFFERABLE);
+
+	vma->vm_flags |= VM_IO | VM_RESERVED;
+
+	if (remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+			    vma->vm_end - vma->vm_start, vma->vm_page_prot)) {
+		mutex_unlock(&mxc_fbi->mutex);
+		dev_dbg(fbi->device, "mmap remap_pfn_range failed\n");
+		return -ENOBUFS;
+
+	}
+
+	mutex_unlock(&mxc_fbi->mutex);
+
+	return 0;
+}
+
+/**
+ * This structure contains the pointers to the control functions that are
+ * invoked by the core framebuffer driver to perform operations like
+ * blitting, rectangle filling, copy regions and cursor definition.
+ */
+static struct fb_ops mx3fb_ops = {
+	.owner = THIS_MODULE,
+	.fb_set_par = mx3fb_set_par,
+	.fb_check_var = mx3fb_check_var,
+	.fb_setcolreg = mx3fb_setcolreg,
+	.fb_pan_display = mx3fb_pan_display,
+	.fb_fillrect = cfb_fillrect,
+	.fb_copyarea = cfb_copyarea,
+	.fb_imageblit = cfb_imageblit,
+	.fb_blank = mx3fb_blank,
+};
+
+static struct fb_ops mx3fb_ovl_ops = {
+	.owner = THIS_MODULE,
+	.fb_set_par = mx3fb_set_par,
+	.fb_check_var = mx3fb_check_var,
+	.fb_setcolreg = mx3fb_setcolreg,
+	.fb_pan_display = mx3fb_pan_display,
+	.fb_ioctl = mx3fb_ioctl_ovl,
+	.fb_mmap = mx3fb_mmap,
+	.fb_fillrect = cfb_fillrect,
+	.fb_copyarea = cfb_copyarea,
+	.fb_imageblit = cfb_imageblit,
+	.fb_blank = mx3fb_blank_ovl,
+};
+
+#ifdef CONFIG_PM
+/*
+ * Power management hooks.      Note that we won't be called from IRQ context,
+ * unlike the blank functions above, so we may sleep.
+ */
+
+/*
+ * Suspends the framebuffer and blanks the screen. Power management support
+ */
+static int mx3fb_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct mx3fb_data *drv_data = platform_get_drvdata(pdev);
+	struct mx3fb_info *mxc_fbi = drv_data->fbi->par;
+	struct mx3fb_info *mxc_fbi_ovl = drv_data->fbi_ovl->par;
+
+	acquire_console_sem();
+	fb_set_suspend(drv_data->fbi, 1);
+	fb_set_suspend(drv_data->fbi_ovl, 1);
+	release_console_sem();
+
+	if (mxc_fbi_ovl->blank == FB_BLANK_UNBLANK)
+		sdc_disable_channel(mxc_fbi_ovl);
+
+	if (mxc_fbi->blank == FB_BLANK_UNBLANK) {
+		sdc_disable_channel(mxc_fbi);
+		sdc_set_brightness(mx3fb, 0);
+
+	}
+	return 0;
+}
+
+/*
+ * Resumes the framebuffer and unblanks the screen. Power management support
+ */
+static int mx3fb_resume(struct platform_device *pdev)
+{
+	struct mx3fb_data *drv_data = platform_get_drvdata(pdev);
+	struct mx3fb_info *mxc_fbi = drv_data->fbi->par;
+	struct mx3fb_info *mxc_fbi_ovl = drv_data->fbi_ovl->par;
+
+	if (mxc_fbi->blank == FB_BLANK_UNBLANK) {
+		sdc_enable_channel(mxc_fbi);
+		sdc_set_brightness(mx3fb, drv_data->backlight_level);
+	}
+
+	if (mxc_fbi_ovl->blank == FB_BLANK_UNBLANK)
+		sdc_enable_channel(mxc_fbi_ovl);
+
+	acquire_console_sem();
+	fb_set_suspend(drv_data->fbi, 0);
+	fb_set_suspend(drv_data->fbi_ovl, 0);
+	release_console_sem();
+
+	return 0;
+}
+#else
+#define mx3fb_suspend   NULL
+#define mx3fb_resume    NULL
+#endif
+
+/*
+ * Main framebuffer functions
+ */
+
+/**
+ * Allocates the DRAM memory for the frame buffer.      This buffer is remapped
+ * into a non-cached, non-buffered, memory region to allow palette and pixel
+ * writes to occur without flushing the cache.  Once this area is remapped,
+ * all virtual memory access to the video memory should occur at the new region.
+ *
+ * @param       fbi     framebuffer information pointer
+ *
+ * @return      Error code indicating success or failure
+ */
+static int mx3fb_map_video_memory(struct fb_info *fbi)
+{
+	int retval = 0;
+	dma_addr_t addr;
+
+	fbi->screen_base = dma_alloc_writecombine(fbi->device,
+						  fbi->fix.smem_len,
+						  &addr, GFP_DMA);
+
+	if (!fbi->screen_base) {
+		dev_err(fbi->device, "Cannot allocate %u bytes framebuffer memory\n",
+			fbi->fix.smem_len);
+		retval = -EBUSY;
+		goto err0;
+	}
+
+	fbi->fix.smem_start = addr;
+
+	dev_dbg(fbi->device, "allocated fb @ p=0x%08x, v=0x%p, size=%d.\n",
+		(uint32_t) fbi->fix.smem_start, fbi->screen_base, fbi->fix.smem_len);
+
+	fbi->screen_size = fbi->fix.smem_len;
+
+	/* Clear the screen */
+	memset((char *)fbi->screen_base, 0, fbi->fix.smem_len);
+
+	return 0;
+
+err0:
+	fbi->fix.smem_len = 0;
+	fbi->fix.smem_start = 0;
+	fbi->screen_base = NULL;
+	return retval;
+}
+
+/**
+ * De-allocates the DRAM memory for the frame buffer.
+ *
+ * @param       fbi     framebuffer information pointer
+ *
+ * @return      Error code indicating success or failure
+ */
+static int mx3fb_unmap_video_memory(struct fb_info *fbi)
+{
+	dma_free_writecombine(fbi->device, fbi->fix.smem_len,
+			      fbi->screen_base, fbi->fix.smem_start);
+
+	fbi->screen_base = 0;
+	fbi->fix.smem_start = 0;
+	fbi->fix.smem_len = 0;
+	return 0;
+}
+
+/**
+ * Initializes the framebuffer information pointer. After allocating
+ * sufficient memory for the framebuffer structure, the fields are
+ * filled with custom information passed in from the configurable
+ * structures.  This includes information such as bits per pixel,
+ * color maps, screen width/height and RGBA offsets.
+ *
+ * @return      Framebuffer structure initialized with our information
+ */
+static struct fb_info *mx3fb_init_fbinfo(struct device *dev, struct fb_ops *ops)
+{
+	struct fb_info *fbi;
+	struct mx3fb_info *mx3fbi;
+	int ret;
+
+	/*
+	 * Allocate sufficient memory for the fb structure
+	 */
+	fbi = framebuffer_alloc(sizeof(struct mx3fb_info), dev);
+	if (!fbi)
+		return NULL;
+
+	mx3fbi			= fbi->par;
+	mx3fbi->cookie		= -EINVAL;
+	mx3fbi->cur_ipu_buf	= 0;
+
+	fbi->var.activate	= FB_ACTIVATE_NOW;
+
+	fbi->fbops		= ops;
+	fbi->flags		= FBINFO_FLAG_DEFAULT;
+	fbi->pseudo_palette	= mx3fbi->pseudo_palette;
+
+	mutex_init(&mx3fbi->mutex);
+
+	/*
+	 * Allocate colormap
+	 */
+	ret = fb_alloc_cmap(&fbi->cmap, 16, 0);
+	if (ret < 0) {
+		framebuffer_release(fbi);
+		return NULL;
+	}
+
+	return fbi;
+}
+
+static int init_fb_chan(struct mx3fb_data *mx3fb, struct idmac_channel *ichan)
+{
+	struct device *dev = mx3fb->dev;
+	struct mx3fb_platform_data *mx3fb_pdata = dev->platform_data;
+	const char *name = mx3fb_pdata->name;
+	unsigned int irq;
+	struct fb_info *fbi;
+	struct mx3fb_info *mx3fbi;
+	const struct fb_videomode *mode;
+	int ret, num_modes;
+
+	irq = ichan->eof_irq;
+
+	switch (ichan->dma_chan.chan_id) {
+	case IDMAC_SDC_0:
+		fbi = mx3fb_init_fbinfo(dev, &mx3fb_ops);
+		if (!fbi)
+			return -ENOMEM;
+
+		if (!fb_mode)
+			fb_mode = name;
+
+		if (!fb_mode) {
+			ret = -EINVAL;
+			goto emode;
+		}
+
+		if (mx3fb_pdata->mode && mx3fb_pdata->num_modes) {
+			mode = mx3fb_pdata->mode;
+			num_modes = mx3fb_pdata->num_modes;
+		} else {
+			mode = mx3fb_modedb;
+			num_modes = ARRAY_SIZE(mx3fb_modedb);
+		}
+
+		if (!fb_find_mode(&fbi->var, fbi, fb_mode, mode,
+				  num_modes, NULL, default_bpp)) {
+			ret = -EBUSY;
+			goto emode;
+		}
+
+		fb_videomode_to_modelist(mode, num_modes, &fbi->modelist);
+
+		/* Default Y virtual size is 2x panel size */
+		fbi->var.yres_virtual = fbi->var.yres * 2;
+
+		mx3fb->fbi = fbi;
+
+		/* set Display Interface clock period */
+		mx3fb_write_reg(mx3fb, 0x00100010L, DI_HSP_CLK_PER);
+		/* Might need to trigger HSP clock change - see 44.3.3.8.5 */
+
+		sdc_set_brightness(mx3fb, 255);
+		sdc_set_global_alpha(mx3fb, true, 0xFF);
+		sdc_set_color_key(mx3fb, IDMAC_SDC_0, false, 0);
+
+		break;
+	case IDMAC_SDC_1:
+		/* We know, that background has been allocated already! */
+		fbi = mx3fb_init_fbinfo(dev, &mx3fb_ovl_ops);
+		if (!fbi)
+			return -ENOMEM;
+
+		/* Default Y virtual size is 2x panel size */
+		fbi->var = mx3fb->fbi->var;
+		/* This shouldn't be necessary, it is already set up above */
+		fbi->var.yres_virtual = mx3fb->fbi->var.yres * 2;
+
+		mx3fb->fbi_ovl = fbi;
+
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	mx3fbi			= fbi->par;
+	mx3fbi->idmac_channel	= ichan;
+	mx3fbi->ipu_ch		= ichan->dma_chan.chan_id;
+	mx3fbi->mx3fb		= mx3fb;
+	mx3fbi->blank		= FB_BLANK_NORMAL;
+
+	init_completion(&mx3fbi->flip_cmpl);
+	ret = mx3fb_set_par(fbi);
+	if (ret < 0)
+		goto esetpar;
+
+	/* Overlay stays blanked by default */
+	if (ichan->dma_chan.chan_id == IDMAC_SDC_0) {
+		mx3fb_blank(FB_BLANK_UNBLANK, fbi);
+
+		dev_info(dev, "mx3fb: fb registered, using mode %s\n", fb_mode);
+	}
+
+
+	ret = register_framebuffer(fbi);
+	if (ret < 0)
+		goto erfb;
+
+	return 0;
+
+erfb:
+esetpar:
+emode:
+	fb_dealloc_cmap(&fbi->cmap);
+	framebuffer_release(fbi);
+
+	return ret;
+}
+
+static bool chan_filter(struct dma_chan *chan, void *arg)
+{
+	struct dma_chan_request *rq = arg;
+	struct device *dev;
+	struct mx3fb_platform_data *mx3fb_pdata;
+
+	if (!rq)
+		return false;
+
+	dev = rq->mx3fb->dev;
+	mx3fb_pdata = dev->platform_data;
+
+	return rq->id == chan->chan_id &&
+		mx3fb_pdata->dma_dev == chan->device->dev;
+}
+
+static void release_fbi(struct fb_info *fbi)
+{
+	mx3fb_unmap_video_memory(fbi);
+
+	fb_dealloc_cmap(&fbi->cmap);
+
+	unregister_framebuffer(fbi);
+	framebuffer_release(fbi);
+}
+
+/**
+ * Probe routine for the framebuffer driver. It is called during the
+ * driver binding process.      The following functions are performed in
+ * this routine: Framebuffer initialization, Memory allocation and
+ * mapping, Framebuffer registration, IPU initialization.
+ *
+ * @return      Appropriate error code to the kernel common code
+ */
+static int mx3fb_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	int ret;
+	struct resource *sdc_reg;
+	struct mx3fb_data *mx3fb;
+	dma_cap_mask_t mask;
+	struct dma_chan *chan;
+	struct dma_chan_request rq;
+
+	/*
+	 * Display Interface (DI) and Synchronous Display Controller (SDC)
+	 * registers
+	 */
+	sdc_reg = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!sdc_reg)
+		return -EINVAL;
+
+	mx3fb = kzalloc(sizeof(*mx3fb), GFP_KERNEL);
+	if (!mx3fb)
+		return -ENOMEM;
+
+	spin_lock_init(&mx3fb->lock);
+
+	mx3fb->reg_base = ioremap(sdc_reg->start, resource_size(sdc_reg));
+	if (!mx3fb->reg_base) {
+		ret = -ENOMEM;
+		goto eremap;
+	}
+
+	pr_debug("Remapped %x to %x at %p\n", sdc_reg->start, sdc_reg->end,
+		 mx3fb->reg_base);
+
+	/* IDMAC interface */
+	dmaengine_get();
+
+	mx3fb->dev = dev;
+	platform_set_drvdata(pdev, mx3fb);
+
+	rq.mx3fb = mx3fb;
+
+	/*
+	 * Request background - it must be the first to guarantee channel
+	 * requesting order. If background allocation fails, there is no
+	 * reason to allocate overlay, however, if overlay fails, we still
+	 * can use background.
+	 */
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+	dma_cap_set(DMA_PRIVATE, mask);
+	rq.id = IDMAC_SDC_0;
+	chan = dma_request_channel(mask, chan_filter, &rq);
+	if (!chan) {
+		ret = -EBUSY;
+		goto ersdc0;
+	}
+	mx3fb->idmac_channel[0] = to_idmac_chan(chan);
+	mx3fb->idmac_channel[0]->client = mx3fb;
+
+	ret = init_fb_chan(mx3fb, to_idmac_chan(chan));
+	if (ret < 0)
+		goto eisdc0;
+
+	/* ...and foreground channels */
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+	dma_cap_set(DMA_PRIVATE, mask);
+	rq.id = IDMAC_SDC_1;
+	chan = dma_request_channel(mask, chan_filter, &rq);
+	if (!chan) {
+		ret = -EBUSY;
+		goto ersdc1;
+	}
+	mx3fb->idmac_channel[1] = to_idmac_chan(chan);
+	mx3fb->idmac_channel[1]->client = mx3fb;
+
+	ret = init_fb_chan(mx3fb, to_idmac_chan(chan));
+	if (ret < 0)
+		goto eisdc1;
+
+	mx3fb->backlight_level = 255;
+
+	return 0;
+
+eisdc1:
+	dma_release_channel(&mx3fb->idmac_channel[1]->dma_chan);
+ersdc1:
+	release_fbi(mx3fb->fbi);
+eisdc0:
+	dma_release_channel(&mx3fb->idmac_channel[0]->dma_chan);
+ersdc0:
+	dmaengine_put();
+	iounmap(mx3fb->reg_base);
+eremap:
+	kfree(mx3fb);
+	dev_err(dev, "mx3fb: failed to register fb\n");
+	return ret;
+}
+
+static int mx3fb_remove(struct platform_device *dev)
+{
+	struct mx3fb_data *mx3fb = platform_get_drvdata(dev);
+	struct fb_info *fbi = mx3fb->fbi;
+
+	if (fbi)
+		release_fbi(fbi);
+
+	fbi = mx3fb->fbi_ovl;
+	if (fbi)
+		release_fbi(fbi);
+
+	dma_release_channel(&mx3fb->idmac_channel[1]->dma_chan);
+	dma_release_channel(&mx3fb->idmac_channel[0]->dma_chan);
+	dmaengine_put();
+
+	iounmap(mx3fb->reg_base);
+	kfree(mx3fb);
+	return 0;
+}
+
+static struct platform_driver mx3fb_driver = {
+	.driver = {
+		   .name = MX3FB_NAME,
+	},
+	.probe = mx3fb_probe,
+	.remove = mx3fb_remove,
+	.suspend = mx3fb_suspend,
+	.resume = mx3fb_resume,
+};
+
+/*
+ * Parse user specified options (`video=mx3fb:')
+ * example:
+ * 	video=mx3fb:bpp=16
+ */
+static int mx3fb_setup(char *options)
+{
+	char *opt;
+	if (!options || !*options)
+		return 0;
+	while ((opt = strsep(&options, ",")) != NULL) {
+		if (!*opt)
+			continue;
+		if (!strncmp(opt, "bpp=", 4))
+			default_bpp = simple_strtoul(opt + 4, NULL, 0);
+		else
+			fb_mode = opt;
+	}
+	return 0;
+}
+
+static int __init mx3fb_init(void)
+{
+	int ret = 0;
+#ifndef MODULE
+	char *option = NULL;
+
+	if (fb_get_options("mx3fb", &option))
+		return -ENODEV;
+	mx3fb_setup(option);
+#endif
+
+	ret = platform_driver_register(&mx3fb_driver);
+	return ret;
+}
+
+static void __exit mx3fb_exit(void)
+{
+	platform_driver_unregister(&mx3fb_driver);
+}
+
+module_init(mx3fb_init);
+module_exit(mx3fb_exit);
+
+MODULE_AUTHOR("Freescale Semiconductor, Inc.");
+MODULE_DESCRIPTION("MX3 framebuffer driver");
+MODULE_ALIAS("platform:" MX3FB_NAME);
-- 
1.5.4

