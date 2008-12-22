Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbYLVScv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbYLVScv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 13:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755422AbYLVSbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 13:31:55 -0500
Received: from mail.gmx.net ([213.165.64.20]:56877 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755902AbYLVSbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 13:31:47 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+suSh6W0GsEZQY1gyytZnsydxqPqT2etdPUlu55R
	rpfr183OpYgI/u
Date: Mon, 22 Dec 2008 19:31:55 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       Sascha Hauer <s.hauer@pengutronix.de>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2/4 v5] i.MX31: Image Processing Unit DMA and IRQ drivers
In-Reply-To: <Pine.LNX.4.64.0812221922200.5241@axis700.grange>
Message-ID: <Pine.LNX.4.64.0812221928410.5241@axis700.grange>
References: <Pine.LNX.4.64.0812221922200.5241@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guennadi Liakhovetski <lg@denx.de>

i.MX3x SoCs contain an Image Processing Unit, consisting of a Control
Module (CM), Display Interface (DI), Synchronous Display Controller (SDC),
Asynchronous Display Controller (ADC), Image Converter (IC), Post-Filter
(PF), Camera Sensor Interface (CSI), and an Image DMA Controller (IDMAC).
CM contains, among other blocks, an Interrupt Generator (IG) and a Clock
and Reset Control Unit (CRCU). This driver serves IDMAC and IG. They are
supported over dmaengine and irq-chip APIs respectively.

IDMAC is a specialised DMA controller, its DMA channels cannot be used for
general-purpose operations, even though it might be possible to configure
a memory-to-memory channel for memcpy operation. This driver will not work
with generic dmaengine clients, clients, wishing to use it must use
respective wrapper structures, they also must specify which channels they
require, as channels are hard-wired to specific IPU functions.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---
 arch/arm/plat-mxc/include/mach/ipu.h  |  180 ++++
 arch/arm/plat-mxc/include/mach/mx31.h |  139 +++-
 drivers/dma/Kconfig                   |    9 +
 drivers/dma/Makefile                  |    1 +
 drivers/dma/ipu/Makefile              |    1 +
 drivers/dma/ipu/ipu_idmac.c           | 1741 +++++++++++++++++++++++++++++++++
 drivers/dma/ipu/ipu_intern.h          |  174 ++++
 drivers/dma/ipu/ipu_irq.c             |  276 ++++++
 8 files changed, 2520 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/plat-mxc/include/mach/ipu.h
 create mode 100644 drivers/dma/ipu/Makefile
 create mode 100644 drivers/dma/ipu/ipu_idmac.c
 create mode 100644 drivers/dma/ipu/ipu_intern.h
 create mode 100644 drivers/dma/ipu/ipu_irq.c

diff --git a/arch/arm/plat-mxc/include/mach/ipu.h b/arch/arm/plat-mxc/include/mach/ipu.h
new file mode 100644
index 0000000..19b3a7c
--- /dev/null
+++ b/arch/arm/plat-mxc/include/mach/ipu.h
@@ -0,0 +1,180 @@
+/*
+ * Copyright (C) 2008
+ * Guennadi Liakhovetski, DENX Software Engineering, <lg@denx.de>
+ *
+ * Copyright (C) 2005-2007 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _IPU_H_
+#define _IPU_H_
+
+#include <linux/types.h>
+#include <linux/dmaengine.h>
+
+/* IPU DMA Controller channel definitions. */
+enum ipu_channel {
+	IDMAC_IC_0 = 0,		/* IC (encoding task) to memory */
+	IDMAC_IC_1 = 1,		/* IC (viewfinder task) to memory */
+	IDMAC_ADC_0 = 1,
+	IDMAC_IC_2 = 2,
+	IDMAC_ADC_1 = 2,
+	IDMAC_IC_3 = 3,
+	IDMAC_IC_4 = 4,
+	IDMAC_IC_5 = 5,
+	IDMAC_IC_6 = 6,
+	IDMAC_IC_7 = 7,		/* IC (sensor data) to memory */
+	IDMAC_IC_8 = 8,
+	IDMAC_IC_9 = 9,
+	IDMAC_IC_10 = 10,
+	IDMAC_IC_11 = 11,
+	IDMAC_IC_12 = 12,
+	IDMAC_IC_13 = 13,
+	IDMAC_SDC_0 = 14,	/* Background synchronous display data */
+	IDMAC_SDC_1 = 15,	/* Foreground data (overlay) */
+	IDMAC_SDC_2 = 16,
+	IDMAC_SDC_3 = 17,
+	IDMAC_ADC_2 = 18,
+	IDMAC_ADC_3 = 19,
+	IDMAC_ADC_4 = 20,
+	IDMAC_ADC_5 = 21,
+	IDMAC_ADC_6 = 22,
+	IDMAC_ADC_7 = 23,
+	IDMAC_PF_0 = 24,
+	IDMAC_PF_1 = 25,
+	IDMAC_PF_2 = 26,
+	IDMAC_PF_3 = 27,
+	IDMAC_PF_4 = 28,
+	IDMAC_PF_5 = 29,
+	IDMAC_PF_6 = 30,
+	IDMAC_PF_7 = 31,
+};
+
+/* Order significant! */
+enum ipu_channel_status {
+	IPU_CHANNEL_FREE,
+	IPU_CHANNEL_INITIALIZED,
+	IPU_CHANNEL_READY,
+	IPU_CHANNEL_ENABLED,
+};
+
+#define IPU_CHANNELS_NUM 32
+
+enum pixel_fmt {
+	/* 1 byte */
+	IPU_PIX_FMT_GENERIC,
+	IPU_PIX_FMT_RGB332,
+	IPU_PIX_FMT_YUV420P,
+	IPU_PIX_FMT_YUV422P,
+	IPU_PIX_FMT_YUV420P2,
+	IPU_PIX_FMT_YVU422P,
+	/* 2 bytes */
+	IPU_PIX_FMT_RGB565,
+	IPU_PIX_FMT_RGB666,
+	IPU_PIX_FMT_BGR666,
+	IPU_PIX_FMT_YUYV,
+	IPU_PIX_FMT_UYVY,
+	/* 3 bytes */
+	IPU_PIX_FMT_RGB24,
+	IPU_PIX_FMT_BGR24,
+	/* 4 bytes */
+	IPU_PIX_FMT_GENERIC_32,
+	IPU_PIX_FMT_RGB32,
+	IPU_PIX_FMT_BGR32,
+	IPU_PIX_FMT_ABGR32,
+	IPU_PIX_FMT_BGRA32,
+	IPU_PIX_FMT_RGBA32,
+};
+
+enum ipu_color_space {
+	IPU_COLORSPACE_RGB,
+	IPU_COLORSPACE_YCBCR,
+	IPU_COLORSPACE_YUV
+};
+
+/*
+ * Enumeration of IPU rotation modes
+ */
+enum ipu_rotate_mode {
+	/* Note the enum values correspond to BAM value */
+	IPU_ROTATE_NONE = 0,
+	IPU_ROTATE_VERT_FLIP = 1,
+	IPU_ROTATE_HORIZ_FLIP = 2,
+	IPU_ROTATE_180 = 3,
+	IPU_ROTATE_90_RIGHT = 4,
+	IPU_ROTATE_90_RIGHT_VFLIP = 5,
+	IPU_ROTATE_90_RIGHT_HFLIP = 6,
+	IPU_ROTATE_90_LEFT = 7,
+};
+
+struct ipu_platform_data {
+	unsigned int	irq_base;
+};
+
+/*
+ * Enumeration of DI ports for ADC.
+ */
+enum display_port {
+	DISP0,
+	DISP1,
+	DISP2,
+	DISP3
+};
+
+struct idmac_video_param {
+	unsigned short		in_width;
+	unsigned short		in_height;
+	uint32_t		in_pixel_fmt;
+	unsigned short		out_width;
+	unsigned short		out_height;
+	uint32_t		out_pixel_fmt;
+	unsigned short		out_stride;
+	bool			graphics_combine_en;
+	bool			global_alpha_en;
+	bool			key_color_en;
+	enum display_port	disp;
+	unsigned short		out_left;
+	unsigned short		out_top;
+};
+
+/*
+ * Union of initialization parameters for a logical channel. So far only video
+ * parameters are used.
+ */
+union ipu_channel_param {
+	struct idmac_video_param video;
+};
+
+struct idmac_tx_desc {
+	struct dma_async_tx_descriptor	txd;
+	struct scatterlist		*sg;	/* scatterlist for this */
+	unsigned int			sg_len;	/* tx-descriptor. */
+	struct list_head		list;
+};
+
+struct idmac_channel {
+	struct dma_chan		dma_chan;
+	dma_cookie_t		completed;	/* last completed cookie	   */
+	union ipu_channel_param	params;
+	enum ipu_channel	link;	/* input channel, linked to the output	   */
+	enum ipu_channel_status	status;
+	void			*client;	/* Only one client per channel	   */
+	unsigned int		n_tx_desc;
+	struct idmac_tx_desc	*desc;		/* allocated tx-descriptors	   */
+	struct scatterlist	*sg[2];	/* scatterlist elements in buffer-0 and -1 */
+	struct list_head	free_list;	/* free tx-descriptors		   */
+	struct list_head	queue;		/* queued tx-descriptors	   */
+	spinlock_t		lock;		/* protects sg[0,1], queue	   */
+	struct mutex		chan_mutex; /* protects status, cookie, free_list  */
+	unsigned int		eof_irq;
+	bool			sec_chan_en;
+	int			active_buffer;
+};
+
+#define to_tx_desc(tx) container_of(tx, struct idmac_tx_desc, txd)
+#define to_idmac_chan(c) container_of(c, struct idmac_channel, dma_chan)
+
+#endif
diff --git a/arch/arm/plat-mxc/include/mach/mx31.h b/arch/arm/plat-mxc/include/mach/mx31.h
index 0536f89..a47f862 100644
--- a/arch/arm/plat-mxc/include/mach/mx31.h
+++ b/arch/arm/plat-mxc/include/mach/mx31.h
@@ -319,9 +319,146 @@
 
 #define MXC_GPIO_INT_BASE	MXC_MAX_INT_LINES
 #define MXC_MAX_GPIO_LINES      (GPIO_NUM_PIN * GPIO_PORT_NUM)
+
+#define MXC_IPU_INT_BASE	(MXC_MAX_INT_LINES + MXC_MAX_GPIO_LINES)
+
+#define IPU_IRQ_PRP_ENC_OUT_EOF			(MXC_IPU_INT_BASE + 0)
+#define IPU_IRQ_PRP_VF_OUT_EOF			(MXC_IPU_INT_BASE + 1)
+#define IPU_IRQ_PP_OUT_EOF			(MXC_IPU_INT_BASE + 2)
+#define IPU_IRQ_PRP_GRAPH_IN_EOF		(MXC_IPU_INT_BASE + 3)
+#define IPU_IRQ_PP_GRAPH_IN_EOF			(MXC_IPU_INT_BASE + 4)
+#define IPU_IRQ_PP_IN_EOF			(MXC_IPU_INT_BASE + 5)
+#define IPU_IRQ_PRP_IN_EOF			(MXC_IPU_INT_BASE + 6)
+#define IPU_IRQ_SENSOR_OUT_EOF			(MXC_IPU_INT_BASE + 7)
+#define IPU_IRQ_PRP_ENC_ROT_OUT_EOF		(MXC_IPU_INT_BASE + 8)
+#define IPU_IRQ_PRP_VF_ROT_OUT_EOF		(MXC_IPU_INT_BASE + 9)
+#define IPU_IRQ_PRP_ENC_ROT_IN_EOF		(MXC_IPU_INT_BASE + 10)
+#define IPU_IRQ_PRP_VF_ROT_IN_EOF		(MXC_IPU_INT_BASE + 11)
+#define IPU_IRQ_PP_ROT_OUT_EOF			(MXC_IPU_INT_BASE + 12)
+#define IPU_IRQ_PP_ROT_IN_EOF			(MXC_IPU_INT_BASE + 13)
+#define IPU_IRQ_SDC_BG_EOF			(MXC_IPU_INT_BASE + 14)
+#define IPU_IRQ_SDC_FG_EOF			(MXC_IPU_INT_BASE + 15)
+#define IPU_IRQ_SDC_MASK_EOF			(MXC_IPU_INT_BASE + 16)
+#define IPU_IRQ_SDC_BG_PART_EOF			(MXC_IPU_INT_BASE + 17)
+#define IPU_IRQ_ADC_SYS1_WR_EOF			(MXC_IPU_INT_BASE + 18)
+#define IPU_IRQ_ADC_SYS2_WR_EOF			(MXC_IPU_INT_BASE + 19)
+#define IPU_IRQ_ADC_SYS1_CMD_EOF		(MXC_IPU_INT_BASE + 20)
+#define IPU_IRQ_ADC_SYS2_CMD_EOF		(MXC_IPU_INT_BASE + 21)
+#define IPU_IRQ_ADC_SYS1_RD_EOF			(MXC_IPU_INT_BASE + 22)
+#define IPU_IRQ_ADC_SYS2_RD_EOF			(MXC_IPU_INT_BASE + 23)
+#define IPU_IRQ_PF_QP_IN_EOF			(MXC_IPU_INT_BASE + 24)
+#define IPU_IRQ_PF_BSP_IN_EOF			(MXC_IPU_INT_BASE + 25)
+#define IPU_IRQ_PF_Y_IN_EOF			(MXC_IPU_INT_BASE + 26)
+#define IPU_IRQ_PF_U_IN_EOF			(MXC_IPU_INT_BASE + 27)
+#define IPU_IRQ_PF_V_IN_EOF			(MXC_IPU_INT_BASE + 28)
+#define IPU_IRQ_PF_Y_OUT_EOF			(MXC_IPU_INT_BASE + 29)
+#define IPU_IRQ_PF_U_OUT_EOF			(MXC_IPU_INT_BASE + 30)
+#define IPU_IRQ_PF_V_OUT_EOF			(MXC_IPU_INT_BASE + 31)
+
+#define IPU_IRQ_PRP_ENC_OUT_NF			(MXC_IPU_INT_BASE + 32)
+#define IPU_IRQ_PRP_VF_OUT_NF			(MXC_IPU_INT_BASE + 33)
+#define IPU_IRQ_PP_OUT_NF			(MXC_IPU_INT_BASE + 34)
+#define IPU_IRQ_PRP_GRAPH_IN_NF			(MXC_IPU_INT_BASE + 35)
+#define IPU_IRQ_PP_GRAPH_IN_NF			(MXC_IPU_INT_BASE + 36)
+#define IPU_IRQ_PP_IN_NF			(MXC_IPU_INT_BASE + 37)
+#define IPU_IRQ_PRP_IN_NF			(MXC_IPU_INT_BASE + 38)
+#define IPU_IRQ_SENSOR_OUT_NF			(MXC_IPU_INT_BASE + 39)
+#define IPU_IRQ_PRP_ENC_ROT_OUT_NF		(MXC_IPU_INT_BASE + 40)
+#define IPU_IRQ_PRP_VF_ROT_OUT_NF		(MXC_IPU_INT_BASE + 41)
+#define IPU_IRQ_PRP_ENC_ROT_IN_NF		(MXC_IPU_INT_BASE + 42)
+#define IPU_IRQ_PRP_VF_ROT_IN_NF		(MXC_IPU_INT_BASE + 43)
+#define IPU_IRQ_PP_ROT_OUT_NF			(MXC_IPU_INT_BASE + 44)
+#define IPU_IRQ_PP_ROT_IN_NF			(MXC_IPU_INT_BASE + 45)
+#define IPU_IRQ_SDC_FG_NF			(MXC_IPU_INT_BASE + 46)
+#define IPU_IRQ_SDC_BG_NF			(MXC_IPU_INT_BASE + 47)
+#define IPU_IRQ_SDC_MASK_NF			(MXC_IPU_INT_BASE + 48)
+#define IPU_IRQ_SDC_BG_PART_NF			(MXC_IPU_INT_BASE + 49)
+#define IPU_IRQ_ADC_SYS1_WR_NF			(MXC_IPU_INT_BASE + 50)
+#define IPU_IRQ_ADC_SYS2_WR_NF			(MXC_IPU_INT_BASE + 51)
+#define IPU_IRQ_ADC_SYS1_CMD_NF			(MXC_IPU_INT_BASE + 52)
+#define IPU_IRQ_ADC_SYS2_CMD_NF			(MXC_IPU_INT_BASE + 53)
+#define IPU_IRQ_ADC_SYS1_RD_NF			(MXC_IPU_INT_BASE + 54)
+#define IPU_IRQ_ADC_SYS2_RD_NF			(MXC_IPU_INT_BASE + 55)
+#define IPU_IRQ_PF_QP_IN_NF			(MXC_IPU_INT_BASE + 56)
+#define IPU_IRQ_PF_BSP_IN_NF			(MXC_IPU_INT_BASE + 57)
+#define IPU_IRQ_PF_Y_IN_NF			(MXC_IPU_INT_BASE + 58)
+#define IPU_IRQ_PF_U_IN_NF			(MXC_IPU_INT_BASE + 59)
+#define IPU_IRQ_PF_V_IN_NF			(MXC_IPU_INT_BASE + 60)
+#define IPU_IRQ_PF_Y_OUT_NF			(MXC_IPU_INT_BASE + 61)
+#define IPU_IRQ_PF_U_OUT_NF			(MXC_IPU_INT_BASE + 62)
+#define IPU_IRQ_PF_V_OUT_NF			(MXC_IPU_INT_BASE + 63)
+
+#define IPU_IRQ_BREAKRQ				(MXC_IPU_INT_BASE + 64)
+#define IPU_IRQ_SDC_BG_OUT_EOF			(MXC_IPU_INT_BASE + 65)
+#define IPU_IRQ_SDC_FG_OUT_EOF			(MXC_IPU_INT_BASE + 66)
+#define IPU_IRQ_SDC_MASK_OUT_EOF		(MXC_IPU_INT_BASE + 67)
+#define IPU_IRQ_ADC_SERIAL_DATA_OUT		(MXC_IPU_INT_BASE + 68)
+#define IPU_IRQ_SENSOR_NF			(MXC_IPU_INT_BASE + 69)
+#define IPU_IRQ_SENSOR_EOF			(MXC_IPU_INT_BASE + 70)
+#define IPU_IRQ_SDC_DISP3_VSYNC			(MXC_IPU_INT_BASE + 80)
+#define IPU_IRQ_ADC_DISP0_VSYNC			(MXC_IPU_INT_BASE + 81)
+#define IPU_IRQ_ADC_DISP12_VSYNC		(MXC_IPU_INT_BASE + 82)
+#define IPU_IRQ_ADC_PRP_EOF			(MXC_IPU_INT_BASE + 83)
+#define IPU_IRQ_ADC_PP_EOF			(MXC_IPU_INT_BASE + 84)
+#define IPU_IRQ_ADC_SYS1_EOF			(MXC_IPU_INT_BASE + 85)
+#define IPU_IRQ_ADC_SYS2_EOF			(MXC_IPU_INT_BASE + 86)
+
+#define IPU_IRQ_PRP_ENC_OUT_NFB4EOF_ERR		(MXC_IPU_INT_BASE + 96)
+#define IPU_IRQ_PRP_VF_OUT_NFB4EOF_ERR		(MXC_IPU_INT_BASE + 97)
+#define IPU_IRQ_PP_OUT_NFB4EOF_ERR		(MXC_IPU_INT_BASE + 98)
+#define IPU_IRQ_PRP_GRAPH_IN_NFB4EOF_ERR	(MXC_IPU_INT_BASE + 99)
+#define IPU_IRQ_PP_GRAPH_IN_NFB4EOF_ERR		(MXC_IPU_INT_BASE + 100)
+#define IPU_IRQ_PP_IN_NFB4EOF_ERR		(MXC_IPU_INT_BASE + 101)
+#define IPU_IRQ_PRP_IN_NFB4EOF_ERR		(MXC_IPU_INT_BASE + 102)
+#define IPU_IRQ_SENSOR_OUT_NFB4EOF_ERR		(MXC_IPU_INT_BASE + 103)
+#define IPU_IRQ_PRP_ENC_ROT_OUT_NFB4EOF_ERR	(MXC_IPU_INT_BASE + 104)
+#define IPU_IRQ_PRP_VF_ROT_OUT_NFB4EOF_ERR	(MXC_IPU_INT_BASE + 105)
+#define IPU_IRQ_PRP_ENC_ROT_IN_NFB4EOF_ERR	(MXC_IPU_INT_BASE + 106)
+#define IPU_IRQ_PRP_VF_ROT_IN_NFB4EOF_ERR	(MXC_IPU_INT_BASE + 107)
+#define IPU_IRQ_PP_ROT_OUT_NFB4EOF_ERR		(MXC_IPU_INT_BASE + 108)
+#define IPU_IRQ_PP_ROT_IN_NFB4EOF_ERR		(MXC_IPU_INT_BASE + 109)
+#define IPU_IRQ_SDC_FG_NFB4EOF_ERR		(MXC_IPU_INT_BASE + 110)
+#define IPU_IRQ_SDC_BG_NFB4EOF_ERR		(MXC_IPU_INT_BASE + 111)
+#define IPU_IRQ_SDC_MASK_NFB4EOF_ERR		(MXC_IPU_INT_BASE + 112)
+#define IPU_IRQ_SDC_BG_PART_NFB4EOF_ERR		(MXC_IPU_INT_BASE + 113)
+#define IPU_IRQ_ADC_SYS1_WR_NFB4EOF_ERR		(MXC_IPU_INT_BASE + 114)
+#define IPU_IRQ_ADC_SYS2_WR_NFB4EOF_ERR		(MXC_IPU_INT_BASE + 115)
+#define IPU_IRQ_ADC_SYS1_CMD_NFB4EOF_ERR	(MXC_IPU_INT_BASE + 116)
+#define IPU_IRQ_ADC_SYS2_CMD_NFB4EOF_ERR	(MXC_IPU_INT_BASE + 117)
+#define IPU_IRQ_ADC_SYS1_RD_NFB4EOF_ERR		(MXC_IPU_INT_BASE + 118)
+#define IPU_IRQ_ADC_SYS2_RD_NFB4EOF_ERR		(MXC_IPU_INT_BASE + 119)
+#define IPU_IRQ_PF_QP_IN_NFB4EOF_ERR		(MXC_IPU_INT_BASE + 120)
+#define IPU_IRQ_PF_BSP_IN_NFB4EOF_ERR		(MXC_IPU_INT_BASE + 121)
+#define IPU_IRQ_PF_Y_IN_NFB4EOF_ERR		(MXC_IPU_INT_BASE + 122)
+#define IPU_IRQ_PF_U_IN_NFB4EOF_ERR		(MXC_IPU_INT_BASE + 123)
+#define IPU_IRQ_PF_V_IN_NFB4EOF_ERR		(MXC_IPU_INT_BASE + 124)
+#define IPU_IRQ_PF_Y_OUT_NFB4EOF_ERR		(MXC_IPU_INT_BASE + 125)
+#define IPU_IRQ_PF_U_OUT_NFB4EOF_ERR		(MXC_IPU_INT_BASE + 126)
+#define IPU_IRQ_PF_V_OUT_NFB4EOF_ERR		(MXC_IPU_INT_BASE + 127)
+
+#define IPU_IRQ_BAYER_BUFOVF_ERR		(MXC_IPU_INT_BASE + 128)
+#define IPU_IRQ_ENC_BUFOVF_ERR			(MXC_IPU_INT_BASE + 129)
+#define IPU_IRQ_VF_BUFOVF_ERR			(MXC_IPU_INT_BASE + 130)
+#define IPU_IRQ_ADC_PP_TEAR_ERR			(MXC_IPU_INT_BASE + 131)
+#define IPU_IRQ_ADC_SYS1_TEAR_ERR		(MXC_IPU_INT_BASE + 132)
+#define IPU_IRQ_ADC_SYS2_TEAR_ERR		(MXC_IPU_INT_BASE + 133)
+#define IPU_IRQ_SDC_BGD_ERR			(MXC_IPU_INT_BASE + 134)
+#define IPU_IRQ_SDC_FGD_ERR			(MXC_IPU_INT_BASE + 135)
+#define IPU_IRQ_SDC_MASKD_ERR			(MXC_IPU_INT_BASE + 136)
+#define IPU_IRQ_BAYER_FRM_LOST_ERR		(MXC_IPU_INT_BASE + 137)
+#define IPU_IRQ_ENC_FRM_LOST_ERR		(MXC_IPU_INT_BASE + 138)
+#define IPU_IRQ_VF_FRM_LOST_ERR			(MXC_IPU_INT_BASE + 139)
+#define IPU_IRQ_ADC_LOCK_ERR			(MXC_IPU_INT_BASE + 140)
+#define IPU_IRQ_DI_LLA_LOCK_ERR			(MXC_IPU_INT_BASE + 141)
+#define IPU_IRQ_AHB_M1_ERR			(MXC_IPU_INT_BASE + 142)
+#define IPU_IRQ_AHB_M12_ERR			(MXC_IPU_INT_BASE + 143)
+
+#define MXC_MAX_IPU_INTS	144
+
 #define MXC_MAX_VIRTUAL_INTS	16
 
-#define NR_IRQS (MXC_MAX_INT_LINES + MXC_MAX_GPIO_LINES + MXC_MAX_VIRTUAL_INTS)
+#define NR_IRQS (MXC_MAX_INT_LINES + MXC_MAX_GPIO_LINES + MXC_MAX_IPU_INTS + \
+		MXC_MAX_VIRTUAL_INTS)
 
 /*!
  * Number of GPIO port as defined in the IC Spec
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index e34b064..ffb9f54 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -62,6 +62,15 @@ config MV_XOR
 	---help---
 	  Enable support for the Marvell XOR engine.
 
+config MX3_IPU
+	bool "MX3x Image Processing Unit support"
+	depends on ARCH_MX3
+	select DMA_ENGINE
+	default y
+	help
+	  If you plan to use the Image Processing unit in the i.MX3x, say
+	  Y here. If unsure, select Y.
+
 config DMA_ENGINE
 	bool
 
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index 14f5952..2e5dc96 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_INTEL_IOP_ADMA) += iop-adma.o
 obj-$(CONFIG_FSL_DMA) += fsldma.o
 obj-$(CONFIG_MV_XOR) += mv_xor.o
 obj-$(CONFIG_DW_DMAC) += dw_dmac.o
+obj-$(CONFIG_MX3_IPU) += ipu/
diff --git a/drivers/dma/ipu/Makefile b/drivers/dma/ipu/Makefile
new file mode 100644
index 0000000..6704cf4
--- /dev/null
+++ b/drivers/dma/ipu/Makefile
@@ -0,0 +1 @@
+obj-y	+= ipu_irq.o ipu_idmac.o
diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
new file mode 100644
index 0000000..babc86f
--- /dev/null
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -0,0 +1,1741 @@
+/*
+ * Copyright (C) 2008
+ * Guennadi Liakhovetski, DENX Software Engineering, <lg@denx.de>
+ *
+ * Copyright (C) 2005-2007 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/err.h>
+#include <linux/spinlock.h>
+#include <linux/delay.h>
+#include <linux/list.h>
+#include <linux/clk.h>
+#include <linux/vmalloc.h>
+#include <linux/string.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+
+#include <mach/ipu.h>
+
+#include "ipu_intern.h"
+
+#define FS_VF_IN_VALID	0x00000002
+#define FS_ENC_IN_VALID	0x00000001
+
+/*
+ * There can be only one, we could allocate it dynamically, but then we'd have
+ * to add an extra parameter to some functions, and use something as ugly as
+ *	struct ipu *ipu = to_ipu(to_idmac(ichan->dma_chan.device));
+ * in the ISR
+ */
+static struct ipu ipu_data;
+
+#define to_ipu(id) container_of(id, struct ipu, idmac)
+
+static u32 __idmac_read_icreg(struct ipu *ipu, unsigned long reg)
+{
+	return __raw_readl(ipu->reg_ic + reg);
+}
+
+#define idmac_read_icreg(ipu, reg) __idmac_read_icreg(ipu, reg - IC_CONF)
+
+static void __idmac_write_icreg(struct ipu *ipu, u32 value, unsigned long reg)
+{
+	__raw_writel(value, ipu->reg_ic + reg);
+}
+
+#define idmac_write_icreg(ipu, v, reg) __idmac_write_icreg(ipu, v, reg - IC_CONF)
+
+static u32 idmac_read_ipureg(struct ipu *ipu, unsigned long reg)
+{
+	return __raw_readl(ipu->reg_ipu + reg);
+}
+
+static void idmac_write_ipureg(struct ipu *ipu, u32 value, unsigned long reg)
+{
+	__raw_writel(value, ipu->reg_ipu + reg);
+}
+
+/*****************************************************************************
+ * IPU / IC common functions
+ */
+static void dump_idmac_reg(struct ipu *ipu)
+{
+	dev_dbg(ipu->dev, "IDMAC_CONF 0x%x, IC_CONF 0x%x, IDMAC_CHA_EN 0x%x, "
+		"IDMAC_CHA_PRI 0x%x, IDMAC_CHA_BUSY 0x%x\n",
+		idmac_read_icreg(ipu, IDMAC_CONF),
+		idmac_read_icreg(ipu, IC_CONF),
+		idmac_read_icreg(ipu, IDMAC_CHA_EN),
+		idmac_read_icreg(ipu, IDMAC_CHA_PRI),
+		idmac_read_icreg(ipu, IDMAC_CHA_BUSY));
+	dev_dbg(ipu->dev, "BUF0_RDY 0x%x, BUF1_RDY 0x%x, CUR_BUF 0x%x, "
+		"DB_MODE 0x%x, TASKS_STAT 0x%x\n",
+		idmac_read_ipureg(ipu, IPU_CHA_BUF0_RDY),
+		idmac_read_ipureg(ipu, IPU_CHA_BUF1_RDY),
+		idmac_read_ipureg(ipu, IPU_CHA_CUR_BUF),
+		idmac_read_ipureg(ipu, IPU_CHA_DB_MODE_SEL),
+		idmac_read_ipureg(ipu, IPU_TASKS_STAT));
+}
+
+static uint32_t bytes_per_pixel(enum pixel_fmt fmt)
+{
+	switch (fmt) {
+	case IPU_PIX_FMT_GENERIC:	/* generic data */
+	case IPU_PIX_FMT_RGB332:
+	case IPU_PIX_FMT_YUV420P:
+	case IPU_PIX_FMT_YUV422P:
+	default:
+		return 1;
+	case IPU_PIX_FMT_RGB565:
+	case IPU_PIX_FMT_YUYV:
+	case IPU_PIX_FMT_UYVY:
+		return 2;
+	case IPU_PIX_FMT_BGR24:
+	case IPU_PIX_FMT_RGB24:
+		return 3;
+	case IPU_PIX_FMT_GENERIC_32:	/* generic data */
+	case IPU_PIX_FMT_BGR32:
+	case IPU_PIX_FMT_RGB32:
+	case IPU_PIX_FMT_ABGR32:
+		return 4;
+	}
+}
+
+/* Enable / disable direct write to memory by the Camera Sensor Interface */
+static void ipu_ic_enable_task(struct ipu *ipu, enum ipu_channel channel)
+{
+	uint32_t ic_conf, mask;
+
+	switch (channel) {
+	case IDMAC_IC_0:
+		mask = IC_CONF_PRPENC_EN;
+		break;
+	case IDMAC_IC_7:
+		mask = IC_CONF_RWS_EN | IC_CONF_PRPENC_EN;
+		break;
+	default:
+		return;
+	}
+	ic_conf = idmac_read_icreg(ipu, IC_CONF) | mask;
+	idmac_write_icreg(ipu, ic_conf, IC_CONF);
+}
+
+static void ipu_ic_disable_task(struct ipu *ipu, enum ipu_channel channel)
+{
+	uint32_t ic_conf, mask;
+
+	switch (channel) {
+	case IDMAC_IC_0:
+		mask = IC_CONF_PRPENC_EN;
+		break;
+	case IDMAC_IC_7:
+		mask = IC_CONF_RWS_EN | IC_CONF_PRPENC_EN;
+		break;
+	default:
+		return;
+	}
+	ic_conf = idmac_read_icreg(ipu, IC_CONF) & ~mask;
+	idmac_write_icreg(ipu, ic_conf, IC_CONF);
+}
+
+static uint32_t ipu_channel_status(struct ipu *ipu, enum ipu_channel channel)
+{
+	uint32_t stat = TASK_STAT_IDLE;
+	uint32_t task_stat_reg = idmac_read_ipureg(ipu, IPU_TASKS_STAT);
+
+	switch (channel) {
+	case IDMAC_IC_7:
+		stat = (task_stat_reg & TSTAT_CSI2MEM_MASK) >>
+			TSTAT_CSI2MEM_OFFSET;
+		break;
+	case IDMAC_IC_0:
+	case IDMAC_SDC_0:
+	case IDMAC_SDC_1:
+	default:
+		break;
+	}
+	return stat;
+}
+
+struct chan_param_mem_planar {
+	/* Word 0 */
+	u32	xv:10;
+	u32	yv:10;
+	u32	xb:12;
+
+	u32	yb:12;
+	u32	res1:2;
+	u32	nsb:1;
+	u32	lnpb:6;
+	u32	ubo_l:11;
+
+	u32	ubo_h:15;
+	u32	vbo_l:17;
+
+	u32	vbo_h:9;
+	u32	res2:3;
+	u32	fw:12;
+	u32	fh_l:8;
+
+	u32	fh_h:4;
+	u32	res3:28;
+
+	/* Word 1 */
+	u32	eba0;
+
+	u32	eba1;
+
+	u32	bpp:3;
+	u32	sl:14;
+	u32	pfs:3;
+	u32	bam:3;
+	u32	res4:2;
+	u32	npb:6;
+	u32	res5:1;
+
+	u32	sat:2;
+	u32	res6:30;
+} __attribute__ ((packed));
+
+struct chan_param_mem_interleaved {
+	/* Word 0 */
+	u32	xv:10;
+	u32	yv:10;
+	u32	xb:12;
+
+	u32	yb:12;
+	u32	sce:1;
+	u32	res1:1;
+	u32	nsb:1;
+	u32	lnpb:6;
+	u32	sx:10;
+	u32	sy_l:1;
+
+	u32	sy_h:9;
+	u32	ns:10;
+	u32	sm:10;
+	u32	sdx_l:3;
+
+	u32	sdx_h:2;
+	u32	sdy:5;
+	u32	sdrx:1;
+	u32	sdry:1;
+	u32	sdr1:1;
+	u32	res2:2;
+	u32	fw:12;
+	u32	fh_l:8;
+
+	u32	fh_h:4;
+	u32	res3:28;
+
+	/* Word 1 */
+	u32	eba0;
+
+	u32	eba1;
+
+	u32	bpp:3;
+	u32	sl:14;
+	u32	pfs:3;
+	u32	bam:3;
+	u32	res4:2;
+	u32	npb:6;
+	u32	res5:1;
+
+	u32	sat:2;
+	u32	scc:1;
+	u32	ofs0:5;
+	u32	ofs1:5;
+	u32	ofs2:5;
+	u32	ofs3:5;
+	u32	wid0:3;
+	u32	wid1:3;
+	u32	wid2:3;
+
+	u32	wid3:3;
+	u32	dec_sel:1;
+	u32	res6:28;
+} __attribute__ ((packed));
+
+union chan_param_mem {
+	struct chan_param_mem_planar		pp;
+	struct chan_param_mem_interleaved	ip;
+};
+
+static void ipu_ch_param_set_plane_offset(union chan_param_mem *params,
+					  u32 u_offset, u32 v_offset)
+{
+	params->pp.ubo_l = u_offset & 0x7ff;
+	params->pp.ubo_h = u_offset >> 11;
+	params->pp.vbo_l = v_offset & 0x1ffff;
+	params->pp.vbo_h = v_offset >> 17;
+}
+
+static void ipu_ch_param_set_size(union chan_param_mem *params,
+				  uint32_t pixel_fmt, uint16_t width,
+				  uint16_t height, uint16_t stride)
+{
+	u32 u_offset;
+	u32 v_offset;
+
+	params->pp.fw		= width - 1;
+	params->pp.fh_l		= height - 1;
+	params->pp.fh_h		= (height - 1) >> 8;
+	params->pp.sl		= stride - 1;
+
+	switch (pixel_fmt) {
+	case IPU_PIX_FMT_GENERIC:
+		/*Represents 8-bit Generic data */
+		params->pp.bpp	= 3;
+		params->pp.pfs	= 7;
+		params->pp.npb	= 31;
+		params->pp.sat	= 2;		/* SAT = use 32-bit access */
+		break;
+	case IPU_PIX_FMT_GENERIC_32:
+		/*Represents 32-bit Generic data */
+		params->pp.bpp	= 0;
+		params->pp.pfs	= 7;
+		params->pp.npb	= 7;
+		params->pp.sat	= 2;		/* SAT = use 32-bit access */
+		break;
+	case IPU_PIX_FMT_RGB565:
+		params->ip.bpp	= 2;
+		params->ip.pfs	= 4;
+		params->ip.npb	= 7;
+		params->ip.sat	= 2;		/* SAT = 32-bit access */
+		params->ip.ofs0	= 0;		/* Red bit offset */
+		params->ip.ofs1	= 5;		/* Green bit offset */
+		params->ip.ofs2	= 11;		/* Blue bit offset */
+		params->ip.ofs3	= 16;		/* Alpha bit offset */
+		params->ip.wid0	= 4;		/* Red bit width - 1 */
+		params->ip.wid1	= 5;		/* Green bit width - 1 */
+		params->ip.wid2	= 4;		/* Blue bit width - 1 */
+		break;
+	case IPU_PIX_FMT_BGR24:
+		params->ip.bpp	= 1;		/* 24 BPP & RGB PFS */
+		params->ip.pfs	= 4;
+		params->ip.npb	= 7;
+		params->ip.sat	= 2;		/* SAT = 32-bit access */
+		params->ip.ofs0	= 0;		/* Red bit offset */
+		params->ip.ofs1	= 8;		/* Green bit offset */
+		params->ip.ofs2	= 16;		/* Blue bit offset */
+		params->ip.ofs3	= 24;		/* Alpha bit offset */
+		params->ip.wid0	= 7;		/* Red bit width - 1 */
+		params->ip.wid1	= 7;		/* Green bit width - 1 */
+		params->ip.wid2	= 7;		/* Blue bit width - 1 */
+		break;
+	case IPU_PIX_FMT_RGB24:
+		params->ip.bpp	= 1;		/* 24 BPP & RGB PFS */
+		params->ip.pfs	= 4;
+		params->ip.npb	= 7;
+		params->ip.sat	= 2;		/* SAT = 32-bit access */
+		params->ip.ofs0	= 16;		/* Red bit offset */
+		params->ip.ofs1	= 8;		/* Green bit offset */
+		params->ip.ofs2	= 0;		/* Blue bit offset */
+		params->ip.ofs3	= 24;		/* Alpha bit offset */
+		params->ip.wid0	= 7;		/* Red bit width - 1 */
+		params->ip.wid1	= 7;		/* Green bit width - 1 */
+		params->ip.wid2	= 7;		/* Blue bit width - 1 */
+		break;
+	case IPU_PIX_FMT_BGRA32:
+	case IPU_PIX_FMT_BGR32:
+		params->ip.bpp	= 0;
+		params->ip.pfs	= 4;
+		params->ip.npb	= 7;
+		params->ip.sat	= 2;		/* SAT = 32-bit access */
+		params->ip.ofs0	= 8;		/* Red bit offset */
+		params->ip.ofs1	= 16;		/* Green bit offset */
+		params->ip.ofs2	= 24;		/* Blue bit offset */
+		params->ip.ofs3	= 0;		/* Alpha bit offset */
+		params->ip.wid0	= 7;		/* Red bit width - 1 */
+		params->ip.wid1	= 7;		/* Green bit width - 1 */
+		params->ip.wid2	= 7;		/* Blue bit width - 1 */
+		params->ip.wid3	= 7;		/* Alpha bit width - 1 */
+		break;
+	case IPU_PIX_FMT_RGBA32:
+	case IPU_PIX_FMT_RGB32:
+		params->ip.bpp	= 0;
+		params->ip.pfs	= 4;
+		params->ip.npb	= 7;
+		params->ip.sat	= 2;		/* SAT = 32-bit access */
+		params->ip.ofs0	= 24;		/* Red bit offset */
+		params->ip.ofs1	= 16;		/* Green bit offset */
+		params->ip.ofs2	= 8;		/* Blue bit offset */
+		params->ip.ofs3	= 0;		/* Alpha bit offset */
+		params->ip.wid0	= 7;		/* Red bit width - 1 */
+		params->ip.wid1	= 7;		/* Green bit width - 1 */
+		params->ip.wid2	= 7;		/* Blue bit width - 1 */
+		params->ip.wid3	= 7;		/* Alpha bit width - 1 */
+		break;
+	case IPU_PIX_FMT_ABGR32:
+		params->ip.bpp	= 0;
+		params->ip.pfs	= 4;
+		params->ip.npb	= 7;
+		params->ip.sat	= 2;		/* SAT = 32-bit access */
+		params->ip.ofs0	= 8;		/* Red bit offset */
+		params->ip.ofs1	= 16;		/* Green bit offset */
+		params->ip.ofs2	= 24;		/* Blue bit offset */
+		params->ip.ofs3	= 0;		/* Alpha bit offset */
+		params->ip.wid0	= 7;		/* Red bit width - 1 */
+		params->ip.wid1	= 7;		/* Green bit width - 1 */
+		params->ip.wid2	= 7;		/* Blue bit width - 1 */
+		params->ip.wid3	= 7;		/* Alpha bit width - 1 */
+		break;
+	case IPU_PIX_FMT_UYVY:
+		params->ip.bpp	= 2;
+		params->ip.pfs	= 6;
+		params->ip.npb	= 7;
+		params->ip.sat	= 2;		/* SAT = 32-bit access */
+		break;
+	case IPU_PIX_FMT_YUV420P2:
+	case IPU_PIX_FMT_YUV420P:
+		params->ip.bpp	= 3;
+		params->ip.pfs	= 3;
+		params->ip.npb	= 7;
+		params->ip.sat	= 2;		/* SAT = 32-bit access */
+		u_offset = stride * height;
+		v_offset = u_offset + u_offset / 4;
+		ipu_ch_param_set_plane_offset(params, u_offset, v_offset);
+		break;
+	case IPU_PIX_FMT_YVU422P:
+		params->ip.bpp	= 3;
+		params->ip.pfs	= 2;
+		params->ip.npb	= 7;
+		params->ip.sat	= 2;		/* SAT = 32-bit access */
+		v_offset = stride * height;
+		u_offset = v_offset + v_offset / 2;
+		ipu_ch_param_set_plane_offset(params, u_offset, v_offset);
+		break;
+	case IPU_PIX_FMT_YUV422P:
+		params->ip.bpp	= 3;
+		params->ip.pfs	= 2;
+		params->ip.npb	= 7;
+		params->ip.sat	= 2;		/* SAT = 32-bit access */
+		u_offset = stride * height;
+		v_offset = u_offset + u_offset / 2;
+		ipu_ch_param_set_plane_offset(params, u_offset, v_offset);
+		break;
+	default:
+		dev_err(ipu_data.dev,
+			"mxc ipu: unimplemented pixel format %d\n", pixel_fmt);
+		break;
+	}
+
+	params->pp.nsb = 1;
+}
+
+static void ipu_ch_param_set_burst_size(union chan_param_mem *params,
+					uint16_t burst_pixels)
+{
+	params->pp.npb = burst_pixels - 1;
+};
+
+static void ipu_ch_param_set_buffer(union chan_param_mem *params,
+				    dma_addr_t buf0, dma_addr_t buf1)
+{
+	params->pp.eba0 = buf0;
+	params->pp.eba1 = buf1;
+};
+
+static void ipu_ch_param_set_rotation(union chan_param_mem *params,
+				      enum ipu_rotate_mode rotate)
+{
+	params->pp.bam = rotate;
+};
+
+static void ipu_write_param_mem(uint32_t addr, uint32_t *data,
+				uint32_t num_words)
+{
+	for (; num_words > 0; num_words--) {
+		dev_dbg(ipu_data.dev,
+			"write param mem - addr = 0x%08X, data = 0x%08X\n",
+			addr, *data);
+		idmac_write_ipureg(&ipu_data, addr, IPU_IMA_ADDR);
+		idmac_write_ipureg(&ipu_data, *data++, IPU_IMA_DATA);
+		addr++;
+		if ((addr & 0x7) == 5) {
+			addr &= ~0x7;	/* set to word 0 */
+			addr += 8;	/* increment to next row */
+		}
+	}
+}
+
+static int calc_resize_coeffs(uint32_t in_size, uint32_t out_size,
+			      uint32_t *resize_coeff,
+			      uint32_t *downsize_coeff)
+{
+	uint32_t temp_size;
+	uint32_t temp_downsize;
+
+	*resize_coeff	= 1 << 13;
+	*downsize_coeff	= 1 << 13;
+
+	/* Cannot downsize more than 8:1 */
+	if (out_size << 3 < in_size)
+		return -EINVAL;
+
+	/* compute downsizing coefficient */
+	temp_downsize = 0;
+	temp_size = in_size;
+	while (temp_size >= out_size * 2 && temp_downsize < 2) {
+		temp_size >>= 1;
+		temp_downsize++;
+	}
+	*downsize_coeff = temp_downsize;
+
+	/*
+	 * compute resizing coefficient using the following formula:
+	 * resize_coeff = M*(SI -1)/(SO - 1)
+	 * where M = 2^13, SI - input size, SO - output size
+	 */
+	*resize_coeff = (8192L * (temp_size - 1)) / (out_size - 1);
+	if (*resize_coeff >= 16384L) {
+		dev_err(ipu_data.dev, "Warning! Overflow on resize coeff.\n");
+		*resize_coeff = 0x3FFF;
+	}
+
+	dev_dbg(ipu_data.dev, "resizing from %u -> %u pixels, "
+		"downsize=%u, resize=%u.%lu (reg=%u)\n", in_size, out_size,
+		*downsize_coeff, *resize_coeff >= 8192L ? 1 : 0,
+		((*resize_coeff & 0x1FFF) * 10000L) / 8192L, *resize_coeff);
+
+	return 0;
+}
+
+static enum ipu_color_space format_to_colorspace(enum pixel_fmt fmt)
+{
+	switch (fmt) {
+	case IPU_PIX_FMT_RGB565:
+	case IPU_PIX_FMT_BGR24:
+	case IPU_PIX_FMT_RGB24:
+	case IPU_PIX_FMT_BGR32:
+	case IPU_PIX_FMT_RGB32:
+		return IPU_COLORSPACE_RGB;
+	default:
+		return IPU_COLORSPACE_YCBCR;
+	}
+}
+
+static int ipu_ic_init_prpenc(struct ipu *ipu,
+			      union ipu_channel_param *params, bool src_is_csi)
+{
+	uint32_t reg, ic_conf;
+	uint32_t downsize_coeff, resize_coeff;
+	enum ipu_color_space in_fmt, out_fmt;
+
+	/* Setup vertical resizing */
+	calc_resize_coeffs(params->video.in_height,
+			    params->video.out_height,
+			    &resize_coeff, &downsize_coeff);
+	reg = (downsize_coeff << 30) | (resize_coeff << 16);
+
+	/* Setup horizontal resizing */
+	calc_resize_coeffs(params->video.in_width,
+			    params->video.out_width,
+			    &resize_coeff, &downsize_coeff);
+	reg |= (downsize_coeff << 14) | resize_coeff;
+
+	/* Setup color space conversion */
+	in_fmt = format_to_colorspace(params->video.in_pixel_fmt);
+	out_fmt = format_to_colorspace(params->video.out_pixel_fmt);
+
+	/*
+	 * Colourspace conversion unsupported yet - see _init_csc() in
+	 * Freescale sources
+	 */
+	if (in_fmt != out_fmt) {
+		dev_err(ipu->dev, "Colourspace conversion unsupported!\n");
+		return -EOPNOTSUPP;
+	}
+
+	idmac_write_icreg(ipu, reg, IC_PRP_ENC_RSC);
+
+	ic_conf = idmac_read_icreg(ipu, IC_CONF);
+
+	if (src_is_csi)
+		ic_conf &= ~IC_CONF_RWS_EN;
+	else
+		ic_conf |= IC_CONF_RWS_EN;
+
+	idmac_write_icreg(ipu, ic_conf, IC_CONF);
+
+	return 0;
+}
+
+static uint32_t dma_param_addr(uint32_t dma_ch)
+{
+	/* Channel Parameter Memory */
+	return 0x10000 | (dma_ch << 4);
+};
+
+static void ipu_channel_set_priority(struct ipu *ipu, enum ipu_channel channel,
+				     bool prio)
+{
+	u32 reg = idmac_read_icreg(ipu, IDMAC_CHA_PRI);
+
+	if (prio)
+		reg |= 1UL << channel;
+	else
+		reg &= ~(1UL << channel);
+
+	idmac_write_icreg(ipu, reg, IDMAC_CHA_PRI);
+
+	dump_idmac_reg(ipu);
+}
+
+static uint32_t ipu_channel_conf_mask(enum ipu_channel channel)
+{
+	uint32_t mask;
+
+	switch (channel) {
+	case IDMAC_IC_0:
+	case IDMAC_IC_7:
+		mask = IPU_CONF_CSI_EN | IPU_CONF_IC_EN;
+		break;
+	case IDMAC_SDC_0:
+	case IDMAC_SDC_1:
+		mask = IPU_CONF_SDC_EN | IPU_CONF_DI_EN;
+		break;
+	default:
+		mask = 0;
+		break;
+	}
+
+	return mask;
+}
+
+/**
+ * ipu_enable_channel() - enable an IPU channel.
+ *
+ * @channel:	channel ID.
+ * @return:	0 on success or negative error code on failure.
+ */
+static int ipu_enable_channel(struct idmac *idmac, struct idmac_channel *ichan)
+{
+	struct ipu *ipu = to_ipu(idmac);
+	enum ipu_channel channel = ichan->dma_chan.chan_id;
+	uint32_t reg;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ipu->lock, flags);
+
+	/* Reset to buffer 0 */
+	idmac_write_ipureg(ipu, 1UL << channel, IPU_CHA_CUR_BUF);
+	ichan->active_buffer = 0;
+	ichan->status = IPU_CHANNEL_ENABLED;
+
+	switch (channel) {
+	case IDMAC_SDC_0:
+	case IDMAC_SDC_1:
+	case IDMAC_IC_7:
+		ipu_channel_set_priority(ipu, channel, true);
+	default:
+		break;
+	}
+
+	reg = idmac_read_icreg(ipu, IDMAC_CHA_EN);
+
+	idmac_write_icreg(ipu, reg | (1UL << channel), IDMAC_CHA_EN);
+
+	ipu_ic_enable_task(ipu, channel);
+
+	spin_unlock_irqrestore(&ipu->lock, flags);
+	return 0;
+}
+
+/**
+ * ipu_init_channel_buffer() - initialize a buffer for logical IPU channel.
+ *
+ * @channel:	channel ID.
+ * @pixel_fmt:	pixel format of buffer. Pixel format is a FOURCC ASCII code.
+ * @width:	width of buffer in pixels.
+ * @height:	height of buffer in pixels.
+ * @stride:	stride length of buffer in pixels.
+ * @rot_mode:	rotation mode of buffer. A rotation setting other than
+ *		IPU_ROTATE_VERT_FLIP should only be used for input buffers of
+ *		rotation channels.
+ * @phyaddr_0:	buffer 0 physical address.
+ * @phyaddr_1:	buffer 1 physical address. Setting this to a value other than
+ *		NULL enables double buffering mode.
+ * @return:	0 on success or negative error code on failure.
+ */
+static int ipu_init_channel_buffer(struct idmac_channel *ichan,
+				   enum pixel_fmt pixel_fmt,
+				   uint16_t width, uint16_t height,
+				   uint32_t stride,
+				   enum ipu_rotate_mode rot_mode,
+				   dma_addr_t phyaddr_0, dma_addr_t phyaddr_1)
+{
+	enum ipu_channel channel = ichan->dma_chan.chan_id;
+	struct idmac *idmac = to_idmac(ichan->dma_chan.device);
+	struct ipu *ipu = to_ipu(idmac);
+	union chan_param_mem params = {};
+	unsigned long flags;
+	uint32_t reg;
+	uint32_t stride_bytes;
+
+	stride_bytes = stride * bytes_per_pixel(pixel_fmt);
+
+	if (stride_bytes % 4) {
+		dev_err(ipu->dev,
+			"Stride length must be 32-bit aligned, stride = %d, bytes = %d\n",
+			stride, stride_bytes);
+		return -EINVAL;
+	}
+
+	/* IC channel's stride must be a multiple of 8 pixels */
+	if ((channel <= 13) && (stride % 8)) {
+		dev_err(ipu->dev, "Stride must be 8 pixel multiple\n");
+		return -EINVAL;
+	}
+
+	/* Build parameter memory data for DMA channel */
+	ipu_ch_param_set_size(&params, pixel_fmt, width, height, stride_bytes);
+	ipu_ch_param_set_buffer(&params, phyaddr_0, phyaddr_1);
+	ipu_ch_param_set_rotation(&params, rot_mode);
+	/* Some channels (rotation) have restriction on burst length */
+	switch (channel) {
+	case IDMAC_IC_7:	/* Hangs with burst 8, 16, other values
+				   invalid - Table 44-30 */
+/*
+		ipu_ch_param_set_burst_size(&params, 8);
+ */
+		break;
+	case IDMAC_SDC_0:
+	case IDMAC_SDC_1:
+		/* In original code only IPU_PIX_FMT_RGB565 was setting burst */
+		ipu_ch_param_set_burst_size(&params, 16);
+		break;
+	case IDMAC_IC_0:
+	default:
+		break;
+	}
+
+	spin_lock_irqsave(&ipu->lock, flags);
+
+	ipu_write_param_mem(dma_param_addr(channel), (uint32_t *)&params, 10);
+
+	reg = idmac_read_ipureg(ipu, IPU_CHA_DB_MODE_SEL);
+
+	if (phyaddr_1)
+		reg |= 1UL << channel;
+	else
+		reg &= ~(1UL << channel);
+
+	idmac_write_ipureg(ipu, reg, IPU_CHA_DB_MODE_SEL);
+
+	ichan->status = IPU_CHANNEL_READY;
+
+	spin_unlock_irqrestore(ipu->lock, flags);
+
+	return 0;
+}
+
+/**
+ * ipu_select_buffer() - mark a channel's buffer as ready.
+ *
+ * @channel:	channel ID.
+ * @buffer_n:	buffer number to mark ready.
+ */
+static void ipu_select_buffer(enum ipu_channel channel, int buffer_n)
+{
+	/* No locking - this is a write-one-to-set register, cleared by IPU */
+	if (buffer_n == 0)
+		/* Mark buffer 0 as ready. */
+		idmac_write_ipureg(&ipu_data, 1UL << channel, IPU_CHA_BUF0_RDY);
+	else
+		/* Mark buffer 1 as ready. */
+		idmac_write_ipureg(&ipu_data, 1UL << channel, IPU_CHA_BUF1_RDY);
+}
+
+/**
+ * ipu_update_channel_buffer() - update physical address of a channel buffer.
+ *
+ * @channel:	channel ID.
+ * @buffer_n:	buffer number to update.
+ *		0 or 1 are the only valid values.
+ * @phyaddr:	buffer physical address.
+ * @return:	Returns 0 on success or negative error code on failure. This
+ *              function will fail if the buffer is set to ready.
+ */
+/* Called under spin_lock(_irqsave)(&ichan->lock) */
+static int ipu_update_channel_buffer(enum ipu_channel channel,
+				     int buffer_n, dma_addr_t phyaddr)
+{
+	uint32_t reg;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ipu_data.lock, flags);
+
+	if (buffer_n == 0) {
+		reg = idmac_read_ipureg(&ipu_data, IPU_CHA_BUF0_RDY);
+		if (reg & (1UL << channel)) {
+			spin_unlock_irqrestore(&ipu_data.lock, flags);
+			return -EACCES;
+		}
+
+		/* 44.3.3.1.9 - Row Number 1 (WORD1, offset 0) */
+		idmac_write_ipureg(&ipu_data, dma_param_addr(channel) +
+				   0x0008UL, IPU_IMA_ADDR);
+		idmac_write_ipureg(&ipu_data, phyaddr, IPU_IMA_DATA);
+	} else {
+		reg = idmac_read_ipureg(&ipu_data, IPU_CHA_BUF1_RDY);
+		if (reg & (1UL << channel)) {
+			spin_unlock_irqrestore(&ipu_data.lock, flags);
+			return -EACCES;
+		}
+
+		/* Check if double-buffering is already enabled */
+		reg = idmac_read_ipureg(&ipu_data, IPU_CHA_DB_MODE_SEL);
+
+		if (!(reg & (1UL << channel)))
+			idmac_write_ipureg(&ipu_data, reg | (1UL << channel),
+					   IPU_CHA_DB_MODE_SEL);
+
+		/* 44.3.3.1.9 - Row Number 1 (WORD1, offset 1) */
+		idmac_write_ipureg(&ipu_data, dma_param_addr(channel) +
+				   0x0009UL, IPU_IMA_ADDR);
+		idmac_write_ipureg(&ipu_data, phyaddr, IPU_IMA_DATA);
+	}
+
+	spin_unlock_irqrestore(&ipu_data.lock, flags);
+
+	return 0;
+}
+
+/* Called under spin_lock_irqsave(&ichan->lock) */
+static int ipu_submit_channel_buffers(struct idmac_channel *ichan,
+				      struct idmac_tx_desc *desc)
+{
+	struct scatterlist *sg;
+	int i, ret = 0;
+
+	for (i = 0, sg = desc->sg; i < 2 && sg; i++) {
+		if (!ichan->sg[i]) {
+			ichan->sg[i] = sg;
+
+			/*
+			 * On first invocation this shouldn't be necessary, the
+			 * call to ipu_init_channel_buffer() above will set
+			 * addresses for us, so we could make it conditional
+			 * on status >= IPU_CHANNEL_ENABLED, but doing it again
+			 * shouldn't hurt either.
+			 */
+			ret = ipu_update_channel_buffer(ichan->dma_chan.chan_id, i,
+							sg_dma_address(sg));
+			if (ret < 0)
+				return ret;
+
+			ipu_select_buffer(ichan->dma_chan.chan_id, i);
+
+			sg = sg_next(sg);
+		}
+	}
+
+	return ret;
+}
+
+static dma_cookie_t idmac_tx_submit(struct dma_async_tx_descriptor *tx)
+{
+	struct idmac_tx_desc *desc = to_tx_desc(tx);
+	struct idmac_channel *ichan = to_idmac_chan(tx->chan);
+	struct idmac *idmac = to_idmac(tx->chan->device);
+	struct ipu *ipu = to_ipu(idmac);
+	dma_cookie_t cookie;
+	unsigned long flags;
+
+	/* Sanity check */
+	if (!list_empty(&desc->list)) {
+		/* The descriptor doesn't belong to client */
+		dev_err(&ichan->dma_chan.dev->device,
+			"Descriptor %p not prepared!\n", tx);
+		return -EBUSY;
+	}
+
+	mutex_lock(&ichan->chan_mutex);
+
+	if (ichan->status < IPU_CHANNEL_READY) {
+		struct idmac_video_param *video = &ichan->params.video;
+		/*
+		 * Initial buffer assignment - the first two sg-entries from
+		 * the descriptor will end up in the IDMAC buffers
+		 */
+		dma_addr_t dma_1 = sg_is_last(desc->sg) ? 0 :
+			sg_dma_address(&desc->sg[1]);
+
+		WARN_ON(ichan->sg[0] || ichan->sg[1]);
+
+		cookie = ipu_init_channel_buffer(ichan,
+						 video->out_pixel_fmt,
+						 video->out_width,
+						 video->out_height,
+						 video->out_stride,
+						 IPU_ROTATE_NONE,
+						 sg_dma_address(&desc->sg[0]),
+						 dma_1);
+		if (cookie < 0)
+			goto out;
+	}
+
+	/* ipu->lock can be taken under ichan->lock, but not v.v. */
+	spin_lock_irqsave(&ichan->lock, flags);
+
+	/* submit_buffers() atomically verifies and fills empty sg slots */
+	cookie = ipu_submit_channel_buffers(ichan, desc);
+
+	spin_unlock_irqrestore(&ichan->lock, flags);
+
+	if (cookie < 0)
+		goto out;
+
+	cookie = ichan->dma_chan.cookie;
+
+	if (++cookie < 0)
+		cookie = 1;
+
+	/* from dmaengine.h: "last cookie value returned to client" */
+	ichan->dma_chan.cookie = cookie;
+	tx->cookie = cookie;
+	spin_lock_irqsave(&ichan->lock, flags);
+	list_add_tail(&desc->list, &ichan->queue);
+	spin_unlock_irqrestore(&ichan->lock, flags);
+
+	if (ichan->status < IPU_CHANNEL_ENABLED) {
+		int ret = ipu_enable_channel(idmac, ichan);
+		if (ret < 0) {
+			cookie = ret;
+			spin_lock_irqsave(&ichan->lock, flags);
+			list_del_init(&desc->list);
+			spin_unlock_irqrestore(&ichan->lock, flags);
+			tx->cookie = cookie;
+			ichan->dma_chan.cookie = cookie;
+		}
+	}
+
+	dump_idmac_reg(ipu);
+
+out:
+	mutex_unlock(&ichan->chan_mutex);
+
+	return cookie;
+}
+
+/* Called with ichan->chan_mutex held */
+static int idmac_desc_alloc(struct idmac_channel *ichan, int n)
+{
+	struct idmac_tx_desc *desc = vmalloc(n * sizeof(struct idmac_tx_desc));
+	struct idmac *idmac = to_idmac(ichan->dma_chan.device);
+
+	if (!desc)
+		return -ENOMEM;
+
+	/* No interrupts, just disable the tasklet for a moment */
+	tasklet_disable(&to_ipu(idmac)->tasklet);
+
+	ichan->n_tx_desc = n;
+	ichan->desc = desc;
+	INIT_LIST_HEAD(&ichan->queue);
+	INIT_LIST_HEAD(&ichan->free_list);
+
+	while (n--) {
+		struct dma_async_tx_descriptor *txd = &desc->txd;
+
+		memset(txd, 0, sizeof(*txd));
+		dma_async_tx_descriptor_init(txd, &ichan->dma_chan);
+		txd->tx_submit		= idmac_tx_submit;
+		txd->chan		= &ichan->dma_chan;
+		INIT_LIST_HEAD(&txd->tx_list);
+
+		list_add(&desc->list, &ichan->free_list);
+
+		desc++;
+	}
+
+	tasklet_enable(&to_ipu(idmac)->tasklet);
+
+	return 0;
+}
+
+/**
+ * ipu_init_channel() - initialize an IPU channel.
+ *
+ * @idmac:	IPU DMAC context.
+ * @ichan:	pointer to the channel object.
+ * @return      0 on success or negative error code on failure.
+ */
+static int ipu_init_channel(struct idmac *idmac, struct idmac_channel *ichan)
+{
+	union ipu_channel_param *params = &ichan->params;
+	uint32_t ipu_conf;
+	enum ipu_channel channel = ichan->dma_chan.chan_id;
+	unsigned long flags;
+	uint32_t reg;
+	struct ipu *ipu = to_ipu(idmac);
+	int ret = 0, n_desc = 0;
+
+	dev_dbg(ipu->dev, "init channel = %d\n", channel);
+
+	if (channel != IDMAC_SDC_0 && channel != IDMAC_SDC_1 &&
+	    channel != IDMAC_IC_7)
+		return -EINVAL;
+
+	spin_lock_irqsave(&ipu->lock, flags);
+
+	switch (channel) {
+	case IDMAC_IC_7:
+		n_desc = 16;
+		reg = idmac_read_icreg(ipu, IC_CONF);
+		idmac_write_icreg(ipu, reg & ~IC_CONF_CSI_MEM_WR_EN, IC_CONF);
+		break;
+	case IDMAC_IC_0:
+		n_desc = 16;
+		reg = idmac_read_ipureg(ipu, IPU_FS_PROC_FLOW);
+		idmac_write_ipureg(ipu, reg & ~FS_ENC_IN_VALID, IPU_FS_PROC_FLOW);
+		ret = ipu_ic_init_prpenc(ipu, params, true);
+		break;
+	case IDMAC_SDC_0:
+	case IDMAC_SDC_1:
+		n_desc = 4;
+	default:
+		break;
+	}
+
+	ipu->channel_init_mask |= 1L << channel;
+
+	/* Enable IPU sub module */
+	ipu_conf = idmac_read_ipureg(ipu, IPU_CONF) |
+		ipu_channel_conf_mask(channel);
+	idmac_write_ipureg(ipu, ipu_conf, IPU_CONF);
+
+	spin_unlock_irqrestore(&ipu->lock, flags);
+
+	if (n_desc && !ichan->desc)
+		ret = idmac_desc_alloc(ichan, n_desc);
+
+	dump_idmac_reg(ipu);
+
+	return ret;
+}
+
+/**
+ * ipu_uninit_channel() - uninitialize an IPU channel.
+ *
+ * @idmac:	IPU DMAC context.
+ * @ichan:	pointer to the channel object.
+ */
+static void ipu_uninit_channel(struct idmac *idmac, struct idmac_channel *ichan)
+{
+	enum ipu_channel channel = ichan->dma_chan.chan_id;
+	unsigned long flags;
+	uint32_t reg;
+	unsigned long chan_mask = 1UL << channel;
+	uint32_t ipu_conf;
+	struct ipu *ipu = to_ipu(idmac);
+
+	spin_lock_irqsave(&ipu->lock, flags);
+
+	if (!(ipu->channel_init_mask & chan_mask)) {
+		dev_err(ipu->dev, "Channel already uninitialized %d\n",
+			channel);
+		spin_unlock_irqrestore(&ipu->lock, flags);
+		return;
+	}
+
+	/* Reset the double buffer */
+	reg = idmac_read_ipureg(ipu, IPU_CHA_DB_MODE_SEL);
+	idmac_write_ipureg(ipu, reg & ~chan_mask, IPU_CHA_DB_MODE_SEL);
+
+	ichan->sec_chan_en = false;
+
+	switch (channel) {
+	case IDMAC_IC_7:
+		reg = idmac_read_icreg(ipu, IC_CONF);
+		idmac_write_icreg(ipu, reg & ~(IC_CONF_RWS_EN | IC_CONF_PRPENC_EN),
+			     IC_CONF);
+		break;
+	case IDMAC_IC_0:
+		reg = idmac_read_icreg(ipu, IC_CONF);
+		idmac_write_icreg(ipu, reg & ~(IC_CONF_PRPENC_EN | IC_CONF_PRPENC_CSC1),
+				  IC_CONF);
+		break;
+	case IDMAC_SDC_0:
+	case IDMAC_SDC_1:
+	default:
+		break;
+	}
+
+	ipu->channel_init_mask &= ~(1L << channel);
+
+	ipu_conf = idmac_read_ipureg(ipu, IPU_CONF) &
+		~ipu_channel_conf_mask(channel);
+	idmac_write_ipureg(ipu, ipu_conf, IPU_CONF);
+
+	spin_unlock_irqrestore(&ipu->lock, flags);
+
+	ichan->n_tx_desc = 0;
+	vfree(ichan->desc);
+	ichan->desc = NULL;
+}
+
+/**
+ * ipu_disable_channel() - disable an IPU channel.
+ *
+ * @idmac:		IPU DMAC context.
+ * @channel:		channel ID.
+ * @wait_for_stop:	flag to set whether to wait for channel end of frame or
+ *			return immediately.
+ * @return:		0 on success or negative error code on failure.
+ */
+static int ipu_disable_channel(struct idmac *idmac, enum ipu_channel channel,
+			       bool wait_for_stop)
+{
+	struct ipu *ipu = to_ipu(idmac);
+	uint32_t reg;
+	unsigned long flags;
+	unsigned long chan_mask = 1UL << channel;
+	uint32_t timeout;
+	uint32_t eof_intr;
+
+	if (wait_for_stop && channel != IDMAC_SDC_1 && channel != IDMAC_SDC_0) {
+		timeout = 40;
+		/* This waiting always fails. Related to spurious irq problem */
+		while ((idmac_read_icreg(ipu, IDMAC_CHA_BUSY) & chan_mask) ||
+		       (ipu_channel_status(ipu, channel) == TASK_STAT_ACTIVE)) {
+			timeout--;
+			msleep(10);
+
+			if (!timeout) {
+				dev_dbg(ipu->dev,
+					"Warning: timeout waiting for channel %u to "
+					"stop: buf0_rdy = 0x%08X, buf1_rdy = 0x%08X, "
+					"busy = 0x%08X, tstat = 0x%08X\n", channel,
+					idmac_read_ipureg(ipu, IPU_CHA_BUF0_RDY),
+					idmac_read_ipureg(ipu, IPU_CHA_BUF1_RDY),
+					idmac_read_icreg(ipu, IDMAC_CHA_BUSY),
+					idmac_read_ipureg(ipu, IPU_TASKS_STAT));
+				break;
+			}
+		}
+		dev_dbg(ipu->dev, "timeout = %d * 10ms\n", 40 - timeout);
+	}
+	/* SDC BG and FG must be disabled before DMA is disabled */
+	if (wait_for_stop && (channel == IDMAC_SDC_0 ||
+			      channel == IDMAC_SDC_1)) {
+		if (channel == IDMAC_SDC_0)
+			eof_intr = IPU_IRQ_SDC_BG_EOF;
+		else
+			eof_intr = IPU_IRQ_SDC_FG_EOF;
+
+		for (timeout = 5;
+		     timeout && !ipu_irq_status(eof_intr); timeout--)
+			msleep(5);
+	}
+
+	spin_lock_irqsave(&ipu->lock, flags);
+
+	/* Disable IC task */
+	ipu_ic_disable_task(ipu, channel);
+
+	/* Disable DMA channel(s) */
+	reg = idmac_read_icreg(ipu, IDMAC_CHA_EN);
+	idmac_write_icreg(ipu, reg & ~chan_mask, IDMAC_CHA_EN);
+
+	/*
+	 * Problem (observed with channel DMAIC_7): after enabling the channel
+	 * and initialising buffers, there comes an interrupt with current still
+	 * pointing at buffer 0, whereas it should use buffer 0 first and only
+	 * generate an interrupt when it is done, then current should already
+	 * point to buffer 1. This spurious interrupt also comes on channel
+	 * DMASDC_0. With DMAIC_7 normally, is we just leave the ISR after the
+	 * first interrupt, there comes the second with current correctly
+	 * pointing to buffer 1 this time. But sometimes this second interrupt
+	 * doesn't come and the channel hangs. Clearing BUFx_RDY when disabling
+	 * the channel seems to prevent the channel from hanging, but it doesn't
+	 * prevent the spurious interrupt. This might also be unsafe. Think
+	 * about the IDMAC controller trying to switch to a buffer, when we
+	 * clear the ready bit, and re-enable it a moment later.
+	 */
+	reg = idmac_read_ipureg(ipu, IPU_CHA_BUF0_RDY);
+	idmac_write_ipureg(ipu, 0, IPU_CHA_BUF0_RDY);
+	idmac_write_ipureg(ipu, reg & ~(1UL << channel), IPU_CHA_BUF0_RDY);
+
+	reg = idmac_read_ipureg(ipu, IPU_CHA_BUF1_RDY);
+	idmac_write_ipureg(ipu, 0, IPU_CHA_BUF1_RDY);
+	idmac_write_ipureg(ipu, reg & ~(1UL << channel), IPU_CHA_BUF1_RDY);
+
+	spin_unlock_irqrestore(&ipu->lock, flags);
+
+	return 0;
+}
+
+/*
+ * We have several possibilities here:
+ * current BUF		next BUF
+ *
+ * not last sg		next not last sg
+ * not last sg		next last sg
+ * last sg		first sg from next descriptor
+ * last sg		NULL
+ *
+ * Besides, the descriptor queue might be empty or not. We process all these
+ * cases carefully.
+ */
+static irqreturn_t idmac_interrupt(int irq, void *dev_id)
+{
+	struct idmac_channel *ichan = dev_id;
+	unsigned int chan_id = ichan->dma_chan.chan_id;
+	struct scatterlist **sg, *sgnext, *sgnew = NULL;
+	/* Next transfer descriptor */
+	struct idmac_tx_desc *desc = NULL, *descnew;
+	dma_async_tx_callback callback;
+	void *callback_param;
+	bool done = false;
+	u32	ready0 = idmac_read_ipureg(&ipu_data, IPU_CHA_BUF0_RDY),
+		ready1 = idmac_read_ipureg(&ipu_data, IPU_CHA_BUF1_RDY),
+		curbuf = idmac_read_ipureg(&ipu_data, IPU_CHA_CUR_BUF);
+
+	/* IDMAC has cleared the respective BUFx_RDY bit, we manage the buffer */
+
+	pr_debug("IDMAC irq %d\n", irq);
+	/* Other interrupts do not interfere with this channel */
+	spin_lock(&ichan->lock);
+
+	if (unlikely(chan_id != IDMAC_SDC_0 && chan_id != IDMAC_SDC_1 &&
+		     ((curbuf >> chan_id) & 1) == ichan->active_buffer)) {
+		int i = 100;
+
+		/* This doesn't help. See comment in ipu_disable_channel() */
+		while (--i) {
+			curbuf = idmac_read_ipureg(&ipu_data, IPU_CHA_CUR_BUF);
+			if (((curbuf >> chan_id) & 1) != ichan->active_buffer)
+				break;
+			cpu_relax();
+		}
+
+		if (!i) {
+			spin_unlock(&ichan->lock);
+			dev_dbg(ichan->dma_chan.device->dev,
+				"IRQ on active buffer on channel %x, active "
+				"%d, ready %x, %x, current %x!\n", chan_id,
+				ichan->active_buffer, ready0, ready1, curbuf);
+			return IRQ_NONE;
+		}
+	}
+
+	if (unlikely((ichan->active_buffer && (ready1 >> chan_id) & 1) ||
+		     (!ichan->active_buffer && (ready0 >> chan_id) & 1)
+		     )) {
+		spin_unlock(&ichan->lock);
+		dev_dbg(ichan->dma_chan.device->dev,
+			"IRQ with active buffer still ready on channel %x, "
+			"active %d, ready %x, %x!\n", chan_id,
+			ichan->active_buffer, ready0, ready1);
+		return IRQ_NONE;
+	}
+
+	if (unlikely(list_empty(&ichan->queue))) {
+		spin_unlock(&ichan->lock);
+		dev_err(ichan->dma_chan.device->dev,
+			"IRQ without queued buffers on channel %x, active %d, "
+			"ready %x, %x!\n", chan_id,
+			ichan->active_buffer, ready0, ready1);
+		return IRQ_NONE;
+	}
+
+	/*
+	 * active_buffer is a software flag, it shows which buffer we are
+	 * currently expecting back from the hardware, IDMAC should be
+	 * processing the other buffer already
+	 */
+	sg = &ichan->sg[ichan->active_buffer];
+	sgnext = ichan->sg[!ichan->active_buffer];
+
+	/*
+	 * if sgnext == NULL sg must be the last element in a scatterlist and
+	 * queue must be empty
+	 */
+	if (unlikely(!sgnext)) {
+		if (unlikely(sg_next(*sg))) {
+			dev_err(ichan->dma_chan.device->dev,
+				"Broken buffer-update locking on channel %x!\n",
+				chan_id);
+			/* We'll let the user catch up */
+		} else {
+			/* Underrun */
+			ipu_ic_disable_task(&ipu_data, chan_id);
+			dev_dbg(ichan->dma_chan.device->dev,
+				"Underrun on channel %x\n", chan_id);
+			ichan->status = IPU_CHANNEL_READY;
+			/* Continue to check for complete descriptor */
+		}
+	}
+
+	desc = list_entry(ichan->queue.next, struct idmac_tx_desc, list);
+
+	/* First calculate and submit the next sg element */
+	if (likely(sgnext))
+		sgnew = sg_next(sgnext);
+
+	if (unlikely(!sgnew)) {
+		/* Start a new scatterlist, if any queued */
+		if (likely(desc->list.next != &ichan->queue)) {
+			descnew = list_entry(desc->list.next,
+					     struct idmac_tx_desc, list);
+			sgnew = &descnew->sg[0];
+		}
+	}
+
+	if (unlikely(!sg_next(*sg)) || !sgnext) {
+		/*
+		 * Last element in scatterlist done, remove from the queue,
+		 * _init for debugging
+		 */
+		list_del_init(&desc->list);
+		done = true;
+	}
+
+	*sg = sgnew;
+
+	if (likely(sgnew)) {
+		int ret;
+
+		ret = ipu_update_channel_buffer(chan_id, ichan->active_buffer,
+						sg_dma_address(*sg));
+		if (ret < 0)
+			dev_err(ichan->dma_chan.device->dev,
+				"Failed to update buffer on channel %x buffer %d!\n",
+				chan_id, ichan->active_buffer);
+		else
+			ipu_select_buffer(chan_id, ichan->active_buffer);
+	}
+
+	/* Flip the active buffer - even if update above failed */
+	ichan->active_buffer = !ichan->active_buffer;
+	if (done)
+		ichan->completed = desc->txd.cookie;
+
+	callback = desc->txd.callback;
+	callback_param = desc->txd.callback_param;
+
+	spin_unlock(&ichan->lock);
+
+	if (done && (desc->txd.flags & DMA_PREP_INTERRUPT) && callback)
+		callback(callback_param);
+
+	return IRQ_HANDLED;
+}
+
+static void ipu_gc_tasklet(unsigned long arg)
+{
+	struct ipu *ipu = (struct ipu *)arg;
+	int i;
+
+	for (i = 0; i < IPU_CHANNELS_NUM; i++) {
+		struct idmac_channel *ichan = ipu->channel + i;
+		struct idmac_tx_desc *desc;
+		unsigned long flags;
+		int j;
+
+		for (j = 0; j < ichan->n_tx_desc; j++) {
+			desc = ichan->desc + j;
+			spin_lock_irqsave(&ichan->lock, flags);
+			if (async_tx_test_ack(&desc->txd)) {
+				list_move(&desc->list, &ichan->free_list);
+				async_tx_clear_ack(&desc->txd);
+			}
+			spin_unlock_irqrestore(&ichan->lock, flags);
+		}
+	}
+}
+
+/*
+ * At the time .device_alloc_chan_resources() method is called, we cannot know,
+ * whether the client will accept the channel. Thus we must only check, if we
+ * can satisfy client's request but the only real criterion to verify, whether
+ * the client has accepted our offer is the client_count. That's why we have to
+ * perform the rest of our allocation tasks on the first call to this function.
+ */
+static struct dma_async_tx_descriptor *idmac_prep_slave_sg(struct dma_chan *chan,
+		struct scatterlist *sgl, unsigned int sg_len,
+		enum dma_data_direction direction, unsigned long tx_flags)
+{
+	struct idmac_channel *ichan = to_idmac_chan(chan);
+	struct idmac_tx_desc *desc = NULL;
+	struct dma_async_tx_descriptor *txd = NULL;
+	unsigned long flags;
+
+	/* We only can handle these three channels so far */
+	if (ichan->dma_chan.chan_id != IDMAC_SDC_0 && ichan->dma_chan.chan_id != IDMAC_SDC_1 &&
+	    ichan->dma_chan.chan_id != IDMAC_IC_7)
+		return NULL;
+
+	if (direction != DMA_FROM_DEVICE && direction != DMA_TO_DEVICE) {
+		dev_err(chan->device->dev, "Invalid DMA direction %d!\n", direction);
+		return NULL;
+	}
+
+	mutex_lock(&ichan->chan_mutex);
+
+	spin_lock_irqsave(&ichan->lock, flags);
+	if (!list_empty(&ichan->free_list)) {
+		desc = list_entry(ichan->free_list.next,
+				  struct idmac_tx_desc, list);
+
+		list_del_init(&desc->list);
+
+		desc->sg_len	= sg_len;
+		desc->sg	= sgl;
+		txd		= &desc->txd;
+		txd->flags	= tx_flags;
+	}
+	spin_unlock_irqrestore(&ichan->lock, flags);
+
+	mutex_unlock(&ichan->chan_mutex);
+
+	tasklet_schedule(&to_ipu(to_idmac(chan->device))->tasklet);
+
+	return txd;
+}
+
+/* Re-select the current buffer and re-activate the channel */
+static void idmac_issue_pending(struct dma_chan *chan)
+{
+	struct idmac_channel *ichan = to_idmac_chan(chan);
+	struct idmac *idmac = to_idmac(chan->device);
+	struct ipu *ipu = to_ipu(idmac);
+	unsigned long flags;
+
+	/* This is not always needed, but doesn't hurt either */
+	spin_lock_irqsave(&ipu->lock, flags);
+	ipu_select_buffer(ichan->dma_chan.chan_id, ichan->active_buffer);
+	spin_unlock_irqrestore(&ipu->lock, flags);
+
+	/*
+	 * Might need to perform some parts of initialisation from
+	 * ipu_enable_channel(), but not all, we do not want to reset to buffer
+	 * 0, don't need to set priority again either, but re-enabling the task
+	 * and the channel might be a good idea.
+	 */
+}
+
+static void __idmac_terminate_all(struct dma_chan *chan)
+{
+	struct idmac_channel *ichan = to_idmac_chan(chan);
+	struct idmac *idmac = to_idmac(chan->device);
+	unsigned long flags;
+	int i;
+
+	ipu_disable_channel(idmac, chan->chan_id,
+			    ichan->status >= IPU_CHANNEL_ENABLED);
+
+	tasklet_disable(&to_ipu(idmac)->tasklet);
+
+	/* ichan->queue is modified in ISR, have to spinlock */
+	spin_lock_irqsave(&ichan->lock, flags);
+	list_splice_init(&ichan->queue, &ichan->free_list);
+
+	if (ichan->desc)
+		for (i = 0; i < ichan->n_tx_desc; i++) {
+			struct idmac_tx_desc *desc = ichan->desc + i;
+			if (list_empty(&desc->list))
+				/* Descriptor was prepared, but not submitted */
+				list_add(&desc->list,
+					 &ichan->free_list);
+
+			async_tx_clear_ack(&desc->txd);
+		}
+
+	ichan->sg[0] = NULL;
+	ichan->sg[1] = NULL;
+	spin_unlock_irqrestore(&ichan->lock, flags);
+
+	tasklet_enable(&to_ipu(idmac)->tasklet);
+
+	ichan->status = IPU_CHANNEL_INITIALIZED;
+}
+
+static void idmac_terminate_all(struct dma_chan *chan)
+{
+	struct idmac_channel *ichan = to_idmac_chan(chan);
+
+	mutex_lock(&ichan->chan_mutex);
+
+	__idmac_terminate_all(chan);
+
+	mutex_unlock(&ichan->chan_mutex);
+}
+
+static int idmac_alloc_chan_resources(struct dma_chan *chan)
+{
+	struct idmac_channel *ichan = to_idmac_chan(chan);
+	struct idmac *idmac = to_idmac(chan->device);
+	int ret;
+
+	/* dmaengine.c now guarantees to only offer free channels */
+	BUG_ON(chan->client_count > 1);
+	WARN_ON(ichan->status != IPU_CHANNEL_FREE);
+
+	chan->cookie		= 1;
+	ichan->completed	= -ENXIO;
+
+	ret = request_irq(ichan->eof_irq, idmac_interrupt, 0,
+			  "idmac", ichan);
+	if (ret < 0)
+		goto out;
+
+	ret = ipu_init_channel(idmac, ichan);
+	if (ret < 0) {
+		free_irq(ichan->eof_irq, ichan);
+		goto out;
+	}
+
+	ichan->status = IPU_CHANNEL_INITIALIZED;
+
+	dev_dbg(&ichan->dma_chan.dev->device, "Found channel 0x%x, irq %d\n",
+		ichan->dma_chan.chan_id, ichan->eof_irq);
+
+out:
+	return ret;
+}
+
+static void idmac_free_chan_resources(struct dma_chan *chan)
+{
+	struct idmac_channel *ichan = to_idmac_chan(chan);
+	struct idmac *idmac = to_idmac(chan->device);
+
+	mutex_lock(&ichan->chan_mutex);
+
+	__idmac_terminate_all(chan);
+
+	if (ichan->status > IPU_CHANNEL_FREE)
+		free_irq(ichan->eof_irq, ichan);
+
+	ichan->status = IPU_CHANNEL_FREE;
+
+	ipu_uninit_channel(idmac, ichan);
+
+	mutex_unlock(&ichan->chan_mutex);
+
+	tasklet_schedule(&to_ipu(idmac)->tasklet);
+}
+
+static enum dma_status idmac_is_tx_complete(struct dma_chan *chan,
+		dma_cookie_t cookie, dma_cookie_t *done, dma_cookie_t *used)
+{
+	struct idmac_channel *ichan = to_idmac_chan(chan);
+
+	if (done)
+		*done = ichan->completed;
+	if (used)
+		*used = chan->cookie;
+	if (cookie != chan->cookie)
+		return DMA_ERROR;
+	return DMA_SUCCESS;
+}
+
+static int __init ipu_idmac_init(struct ipu *ipu)
+{
+	struct idmac *idmac = &ipu->idmac;
+	struct dma_device *dma = &idmac->dma;
+	int i;
+
+	dma_cap_set(DMA_SLAVE, dma->cap_mask);
+	dma_cap_set(DMA_PRIVATE, dma->cap_mask);
+
+	/* Compulsory common fields */
+	dma->dev				= ipu->dev;
+	dma->device_alloc_chan_resources	= idmac_alloc_chan_resources;
+	dma->device_free_chan_resources		= idmac_free_chan_resources;
+	dma->device_is_tx_complete		= idmac_is_tx_complete;
+	dma->device_issue_pending		= idmac_issue_pending;
+
+	/* Compulsory for DMA_SLAVE fields */
+	dma->device_prep_slave_sg		= idmac_prep_slave_sg;
+	dma->device_terminate_all		= idmac_terminate_all;
+
+	INIT_LIST_HEAD(&dma->channels);
+	for (i = 0; i < IPU_CHANNELS_NUM; i++) {
+		struct idmac_channel *ichan = ipu->channel + i;
+		struct dma_chan *dma_chan = &ichan->dma_chan;
+
+		spin_lock_init(&ichan->lock);
+		mutex_init(&ichan->chan_mutex);
+
+		ichan->eof_irq		= MXC_IPU_INT_BASE + i;
+		ichan->status		= IPU_CHANNEL_FREE;
+		ichan->sec_chan_en	= false;
+		ichan->completed	= -ENXIO;
+
+		dma_chan->device	= &idmac->dma;
+		dma_chan->cookie	= 1;
+		dma_chan->chan_id	= i;
+		list_add_tail(&ichan->dma_chan.device_node, &dma->channels);
+	}
+
+	idmac_write_icreg(ipu, 0x00000070, IDMAC_CONF);
+
+	return dma_async_device_register(&idmac->dma);
+}
+
+static void ipu_idmac_exit(struct ipu *ipu)
+{
+	int i;
+	struct idmac *idmac = &ipu->idmac;
+
+	for (i = 0; i < IPU_CHANNELS_NUM; i++) {
+		struct idmac_channel *ichan = ipu->channel + i;
+
+		idmac_terminate_all(&ichan->dma_chan);
+		idmac_prep_slave_sg(&ichan->dma_chan, NULL, 0, DMA_NONE, 0);
+	}
+
+	dma_async_device_unregister(&idmac->dma);
+}
+
+/*****************************************************************************
+ * IPU common probe / remove
+ */
+
+static int ipu_probe(struct platform_device *pdev)
+{
+	struct ipu_platform_data *pdata = pdev->dev.platform_data;
+	struct resource *mem_ipu, *mem_ic;
+	int ret;
+
+	spin_lock_init(&ipu_data.lock);
+
+	mem_ipu	= platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	mem_ic	= platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (!pdata || !mem_ipu || !mem_ic)
+		return -EINVAL;
+
+	ipu_data.dev = &pdev->dev;
+
+	platform_set_drvdata(pdev, &ipu_data);
+
+	ret = platform_get_irq(pdev, 0);
+	if (ret < 0)
+		goto err_noirq;
+
+	ipu_data.irq_fn = ret;
+	ret = platform_get_irq(pdev, 1);
+	if (ret < 0)
+		goto err_noirq;
+
+	ipu_data.irq_err = ret;
+	ipu_data.irq_base = pdata->irq_base;
+
+	dev_dbg(&pdev->dev, "fn irq %u, err irq %u, irq-base %u\n",
+		ipu_data.irq_fn, ipu_data.irq_err, ipu_data.irq_base);
+
+	/* Remap IPU common registers */
+	ipu_data.reg_ipu = ioremap(mem_ipu->start,
+				   mem_ipu->end - mem_ipu->start + 1);
+	if (!ipu_data.reg_ipu) {
+		ret = -ENOMEM;
+		goto err_ioremap_ipu;
+	}
+
+	/* Remap Image Converter and Image DMA Controller registers */
+	ipu_data.reg_ic = ioremap(mem_ic->start,
+				  mem_ic->end - mem_ic->start + 1);
+	if (!ipu_data.reg_ic) {
+		ret = -ENOMEM;
+		goto err_ioremap_ic;
+	}
+
+	/* Get IPU clock */
+	ipu_data.ipu_clk = clk_get(&pdev->dev, "ipu_clk");
+	if (IS_ERR(ipu_data.ipu_clk)) {
+		ret = PTR_ERR(ipu_data.ipu_clk);
+		goto err_clk_get;
+	}
+
+	/* Make sure IPU HSP clock is running */
+	clk_enable(ipu_data.ipu_clk);
+
+	/* Disable all interrupts */
+	idmac_write_ipureg(&ipu_data, 0, IPU_INT_CTRL_1);
+	idmac_write_ipureg(&ipu_data, 0, IPU_INT_CTRL_2);
+	idmac_write_ipureg(&ipu_data, 0, IPU_INT_CTRL_3);
+	idmac_write_ipureg(&ipu_data, 0, IPU_INT_CTRL_4);
+	idmac_write_ipureg(&ipu_data, 0, IPU_INT_CTRL_5);
+
+	dev_dbg(&pdev->dev, "%s @ 0x%08lx, fn irq %u, err irq %u\n", pdev->name,
+		(unsigned long)mem_ipu->start, ipu_data.irq_fn, ipu_data.irq_err);
+
+	ret = ipu_irq_attach_irq(&ipu_data, pdev);
+	if (ret < 0)
+		goto err_attach_irq;
+
+	/* Initialize DMA engine */
+	ret = ipu_idmac_init(&ipu_data);
+	if (ret < 0)
+		goto err_idmac_init;
+
+	tasklet_init(&ipu_data.tasklet, ipu_gc_tasklet, (unsigned long)&ipu_data);
+
+	ipu_data.dev = &pdev->dev;
+
+	dev_dbg(ipu_data.dev, "IPU initialized\n");
+
+	return 0;
+
+err_idmac_init:
+err_attach_irq:
+	ipu_irq_detach_irq(&ipu_data, pdev);
+	clk_disable(ipu_data.ipu_clk);
+	clk_put(ipu_data.ipu_clk);
+err_clk_get:
+	iounmap(ipu_data.reg_ic);
+err_ioremap_ic:
+	iounmap(ipu_data.reg_ipu);
+err_ioremap_ipu:
+err_noirq:
+	dev_err(&pdev->dev, "Failed to probe IPU: %d\n", ret);
+	return ret;
+}
+
+static int ipu_remove(struct platform_device *pdev)
+{
+	struct ipu *ipu = platform_get_drvdata(pdev);
+
+	ipu_idmac_exit(ipu);
+	ipu_irq_detach_irq(ipu, pdev);
+	clk_disable(ipu->ipu_clk);
+	clk_put(ipu->ipu_clk);
+	iounmap(ipu->reg_ic);
+	iounmap(ipu->reg_ipu);
+	tasklet_kill(&ipu->tasklet);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+/*
+ * We need two MEM resources - with IPU-common and Image Converter registers,
+ * including PF_CONF and IDMAC_* registers, and two IRQs - function and error
+ */
+static struct platform_driver ipu_platform_driver = {
+	.driver = {
+		.name	= "ipu-core",
+		.owner	= THIS_MODULE,
+	},
+	.remove		= ipu_remove,
+};
+
+static int __init ipu_init(void)
+{
+	return platform_driver_probe(&ipu_platform_driver, ipu_probe);
+}
+subsys_initcall(ipu_init);
+
+MODULE_DESCRIPTION("IPU core driver");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Guennadi Liakhovetski <lg@denx.de>");
+MODULE_ALIAS("platform:ipu-core");
diff --git a/drivers/dma/ipu/ipu_intern.h b/drivers/dma/ipu/ipu_intern.h
new file mode 100644
index 0000000..740e7ee
--- /dev/null
+++ b/drivers/dma/ipu/ipu_intern.h
@@ -0,0 +1,174 @@
+/*
+ * Copyright (C) 2008
+ * Guennadi Liakhovetski, DENX Software Engineering, <lg@denx.de>
+ *
+ * Copyright (C) 2005-2007 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _IPU_INTERN_H_
+#define _IPU_INTERN_H_
+
+#include <linux/dmaengine.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+
+/* IPU Common registers */
+#define IPU_CONF		0x00
+#define IPU_CHA_BUF0_RDY	0x04
+#define IPU_CHA_BUF1_RDY	0x08
+#define IPU_CHA_DB_MODE_SEL	0x0C
+#define IPU_CHA_CUR_BUF		0x10
+#define IPU_FS_PROC_FLOW	0x14
+#define IPU_FS_DISP_FLOW	0x18
+#define IPU_TASKS_STAT		0x1C
+#define IPU_IMA_ADDR		0x20
+#define IPU_IMA_DATA		0x24
+#define IPU_INT_CTRL_1		0x28
+#define IPU_INT_CTRL_2		0x2C
+#define IPU_INT_CTRL_3		0x30
+#define IPU_INT_CTRL_4		0x34
+#define IPU_INT_CTRL_5		0x38
+#define IPU_INT_STAT_1		0x3C
+#define IPU_INT_STAT_2		0x40
+#define IPU_INT_STAT_3		0x44
+#define IPU_INT_STAT_4		0x48
+#define IPU_INT_STAT_5		0x4C
+#define IPU_BRK_CTRL_1		0x50
+#define IPU_BRK_CTRL_2		0x54
+#define IPU_BRK_STAT		0x58
+#define IPU_DIAGB_CTRL		0x5C
+
+/* IPU_CONF Register bits */
+#define IPU_CONF_CSI_EN		0x00000001
+#define IPU_CONF_IC_EN		0x00000002
+#define IPU_CONF_ROT_EN		0x00000004
+#define IPU_CONF_PF_EN		0x00000008
+#define IPU_CONF_SDC_EN		0x00000010
+#define IPU_CONF_ADC_EN		0x00000020
+#define IPU_CONF_DI_EN		0x00000040
+#define IPU_CONF_DU_EN		0x00000080
+#define IPU_CONF_PXL_ENDIAN	0x00000100
+
+/* Image Converter Registers */
+#define IC_CONF			0x88
+#define IC_PRP_ENC_RSC		0x8C
+#define IC_PRP_VF_RSC		0x90
+#define IC_PP_RSC		0x94
+#define IC_CMBP_1		0x98
+#define IC_CMBP_2		0x9C
+#define PF_CONF			0xA0
+#define IDMAC_CONF		0xA4
+#define IDMAC_CHA_EN		0xA8
+#define IDMAC_CHA_PRI		0xAC
+#define IDMAC_CHA_BUSY		0xB0
+
+/* Image Converter Register bits */
+#define IC_CONF_PRPENC_EN	0x00000001
+#define IC_CONF_PRPENC_CSC1	0x00000002
+#define IC_CONF_PRPENC_ROT_EN	0x00000004
+#define IC_CONF_PRPVF_EN	0x00000100
+#define IC_CONF_PRPVF_CSC1	0x00000200
+#define IC_CONF_PRPVF_CSC2	0x00000400
+#define IC_CONF_PRPVF_CMB	0x00000800
+#define IC_CONF_PRPVF_ROT_EN	0x00001000
+#define IC_CONF_PP_EN		0x00010000
+#define IC_CONF_PP_CSC1		0x00020000
+#define IC_CONF_PP_CSC2		0x00040000
+#define IC_CONF_PP_CMB		0x00080000
+#define IC_CONF_PP_ROT_EN	0x00100000
+#define IC_CONF_IC_GLB_LOC_A	0x10000000
+#define IC_CONF_KEY_COLOR_EN	0x20000000
+#define IC_CONF_RWS_EN		0x40000000
+#define IC_CONF_CSI_MEM_WR_EN	0x80000000
+
+#define IDMA_CHAN_INVALID	0x000000FF
+#define IDMA_IC_0		0x00000001
+#define IDMA_IC_1		0x00000002
+#define IDMA_IC_2		0x00000004
+#define IDMA_IC_3		0x00000008
+#define IDMA_IC_4		0x00000010
+#define IDMA_IC_5		0x00000020
+#define IDMA_IC_6		0x00000040
+#define IDMA_IC_7		0x00000080
+#define IDMA_IC_8		0x00000100
+#define IDMA_IC_9		0x00000200
+#define IDMA_IC_10		0x00000400
+#define IDMA_IC_11		0x00000800
+#define IDMA_IC_12		0x00001000
+#define IDMA_IC_13		0x00002000
+#define IDMA_SDC_BG		0x00004000
+#define IDMA_SDC_FG		0x00008000
+#define IDMA_SDC_MASK		0x00010000
+#define IDMA_SDC_PARTIAL	0x00020000
+#define IDMA_ADC_SYS1_WR	0x00040000
+#define IDMA_ADC_SYS2_WR	0x00080000
+#define IDMA_ADC_SYS1_CMD	0x00100000
+#define IDMA_ADC_SYS2_CMD	0x00200000
+#define IDMA_ADC_SYS1_RD	0x00400000
+#define IDMA_ADC_SYS2_RD	0x00800000
+#define IDMA_PF_QP		0x01000000
+#define IDMA_PF_BSP		0x02000000
+#define IDMA_PF_Y_IN		0x04000000
+#define IDMA_PF_U_IN		0x08000000
+#define IDMA_PF_V_IN		0x10000000
+#define IDMA_PF_Y_OUT		0x20000000
+#define IDMA_PF_U_OUT		0x40000000
+#define IDMA_PF_V_OUT		0x80000000
+
+#define TSTAT_PF_H264_PAUSE	0x00000001
+#define TSTAT_CSI2MEM_MASK	0x0000000C
+#define TSTAT_CSI2MEM_OFFSET	2
+#define TSTAT_VF_MASK		0x00000600
+#define TSTAT_VF_OFFSET		9
+#define TSTAT_VF_ROT_MASK	0x000C0000
+#define TSTAT_VF_ROT_OFFSET	18
+#define TSTAT_ENC_MASK		0x00000180
+#define TSTAT_ENC_OFFSET	7
+#define TSTAT_ENC_ROT_MASK	0x00030000
+#define TSTAT_ENC_ROT_OFFSET	16
+#define TSTAT_PP_MASK		0x00001800
+#define TSTAT_PP_OFFSET		11
+#define TSTAT_PP_ROT_MASK	0x00300000
+#define TSTAT_PP_ROT_OFFSET	20
+#define TSTAT_PF_MASK		0x00C00000
+#define TSTAT_PF_OFFSET		22
+#define TSTAT_ADCSYS1_MASK	0x03000000
+#define TSTAT_ADCSYS1_OFFSET	24
+#define TSTAT_ADCSYS2_MASK	0x0C000000
+#define TSTAT_ADCSYS2_OFFSET	26
+
+#define TASK_STAT_IDLE		0
+#define TASK_STAT_ACTIVE	1
+#define TASK_STAT_WAIT4READY	2
+
+struct idmac {
+	struct dma_device	dma;
+};
+
+struct ipu {
+	void __iomem		*reg_ipu;
+	void __iomem		*reg_ic;
+	unsigned int		irq_fn;		/* IPU Function IRQ to the CPU */
+	unsigned int		irq_err;	/* IPU Error IRQ to the CPU */
+	unsigned int		irq_base;	/* Beginning of the IPU IRQ range */
+	unsigned long		channel_init_mask;
+	spinlock_t		lock;
+	struct clk		*ipu_clk;
+	struct device		*dev;
+	struct idmac		idmac;
+	struct idmac_channel	channel[IPU_CHANNELS_NUM];
+	struct tasklet_struct	tasklet;
+};
+
+#define to_idmac(d) container_of(d, struct idmac, dma)
+
+extern int ipu_irq_attach_irq(struct ipu *ipu, struct platform_device *dev);
+extern void ipu_irq_detach_irq(struct ipu *ipu, struct platform_device *dev);
+
+extern bool ipu_irq_status(uint32_t irq);
+
+#endif
diff --git a/drivers/dma/ipu/ipu_irq.c b/drivers/dma/ipu/ipu_irq.c
new file mode 100644
index 0000000..5a5547e
--- /dev/null
+++ b/drivers/dma/ipu/ipu_irq.c
@@ -0,0 +1,276 @@
+/*
+ * Copyright (C) 2008
+ * Guennadi Liakhovetski, DENX Software Engineering, <lg@denx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/spinlock.h>
+#include <linux/delay.h>
+#include <linux/clk.h>
+#include <linux/irq.h>
+#include <linux/io.h>
+
+#include <mach/ipu.h>
+
+#include "ipu_intern.h"
+
+/*
+ * Register read / write - shall be inlined by the compiler
+ */
+static u32 ipu_read_reg(struct ipu *ipu, unsigned long reg)
+{
+	return __raw_readl(ipu->reg_ipu + reg);
+}
+
+static void ipu_write_reg(struct ipu *ipu, u32 value, unsigned long reg)
+{
+	__raw_writel(value, ipu->reg_ipu + reg);
+}
+
+
+/*
+ * IPU IRQ chip driver
+ */
+
+#define IPU_IRQ_NR_FN_BANKS 3
+#define IPU_IRQ_NR_ERR_BANKS 2
+
+struct ipu_irq_bank {
+	int		nr_irqs;
+	unsigned int	control;
+	unsigned int	status;
+	unsigned int	irq_base;
+	spinlock_t	lock;
+	struct ipu	*ipu;
+};
+
+static struct ipu_irq_bank irq_bank_fn[IPU_IRQ_NR_FN_BANKS] = {
+	/* 3 groups of functional interrupts */
+	{
+		.nr_irqs	= 32,
+		.control	= IPU_INT_CTRL_1,
+		.status		= IPU_INT_STAT_1,
+	}, {
+		.nr_irqs	= 32,
+		.control	= IPU_INT_CTRL_2,
+		.status		= IPU_INT_STAT_2,
+	}, {
+		.nr_irqs	= 24,
+		.control	= IPU_INT_CTRL_3,
+		.status		= IPU_INT_STAT_3,
+	},
+};
+
+static struct ipu_irq_bank irq_bank_err[IPU_IRQ_NR_ERR_BANKS] = {
+	/* 2 groups of error interrupts */
+	{
+		.nr_irqs	= 32,
+		.control	= IPU_INT_CTRL_4,
+		.status		= IPU_INT_STAT_4,
+	}, {
+		.nr_irqs	= 17,
+		.control	= IPU_INT_CTRL_5,
+		.status		= IPU_INT_STAT_5,
+	},
+};
+
+#define IPU_IRQ_NR_FN_IRQS (32 + 32 + 24)
+#define IPU_IRQ_NR_ERR_IRQS (32 + 17)
+#define IPU_IRQ_NR_IRQS (IPU_IRQ_NR_ERR_IRQS + IPU_IRQ_NR_FN_IRQS)
+
+static void ipu_irq_unmask(unsigned int irq)
+{
+	struct ipu_irq_bank *bank = get_irq_chip_data(irq);
+	uint32_t reg;
+	unsigned long lock_flags;
+
+	spin_lock_irqsave(&bank->lock, lock_flags);
+
+	reg = ipu_read_reg(bank->ipu, bank->control);
+	reg |= (1UL << (irq - bank->irq_base));
+	ipu_write_reg(bank->ipu, reg, bank->control);
+
+	spin_unlock_irqrestore(&bank->lock, lock_flags);
+}
+
+static void ipu_irq_mask(unsigned int irq)
+{
+	struct ipu_irq_bank *bank = get_irq_chip_data(irq);
+	uint32_t reg;
+	unsigned long lock_flags;
+
+	spin_lock_irqsave(&bank->lock, lock_flags);
+
+	reg = ipu_read_reg(bank->ipu, bank->control);
+	reg &= ~(1UL << (irq - bank->irq_base));
+	ipu_write_reg(bank->ipu, reg, bank->control);
+
+	spin_unlock_irqrestore(&bank->lock, lock_flags);
+}
+
+static void ipu_irq_ack(unsigned int irq)
+{
+	struct ipu_irq_bank *bank = get_irq_chip_data(irq);
+
+	ipu_write_reg(bank->ipu, 1UL << (irq - bank->irq_base), bank->status);
+}
+
+/**
+ * Returns the current interrupt status for the specified IRQ.
+ *
+ * @param       irq             Interrupt line to get status for.
+ *
+ * @return      Returns true if the interrupt is pending/asserted or false if
+ *              the interrupt is not pending.
+ */
+bool ipu_irq_status(uint32_t irq)
+{
+	struct ipu_irq_bank *bank = get_irq_chip_data(irq);
+
+	if (ipu_read_reg(bank->ipu, bank->status) &
+	    (1UL << (irq - bank->irq_base)))
+		return true;
+	else
+		return false;
+}
+
+/* Chained IRQ handler for IPU error interrupt */
+static void ipu_irq_err(unsigned int irq, struct irq_desc *desc)
+{
+	struct ipu *ipu = get_irq_data(irq);
+	u32 status;
+	int i, line;
+
+	for (i = 0; i < IPU_IRQ_NR_ERR_BANKS; i++) {
+		status = ipu_read_reg(ipu, irq_bank_err[i].status);
+		/*
+		 * Don't think we have to clear all interrupts here, thy will
+		 * be acked by ->handle_irq() (handle_level_irq). However, we
+		 * might want to clear unhandled interrupts after the loop...
+		 */
+		status &= ipu_read_reg(ipu, irq_bank_err[i].control);
+		while ((line = ffs(status))) {
+			status &= ~(1UL << (line - 1));
+			generic_handle_irq(irq_bank_err[i].irq_base + line - 1);
+		}
+	}
+}
+
+/* Chained IRQ handler for IPU function interrupt */
+static void ipu_irq_fn(unsigned int irq, struct irq_desc *desc)
+{
+	struct ipu *ipu = get_irq_data(irq);
+	u32 status;
+	int i, line;
+
+	for (i = 0; i < IPU_IRQ_NR_FN_BANKS; i++) {
+		status = ipu_read_reg(ipu, irq_bank_fn[i].status);
+		/* Not clearing all interrupts, see above */
+		status &= ipu_read_reg(ipu, irq_bank_fn[i].control);
+		while ((line = ffs(status))) {
+			status &= ~(1UL << (line - 1));
+			generic_handle_irq(irq_bank_fn[i].irq_base + line - 1);
+		}
+	}
+}
+
+static struct irq_chip ipu_irq_chip = {
+	.name	= "ipu_irq",
+	.ack	= ipu_irq_ack,
+	.mask	= ipu_irq_mask,
+	.unmask	= ipu_irq_unmask,
+};
+
+/* Install the IRQ handler */
+int ipu_irq_attach_irq(struct ipu *ipu, struct platform_device *dev)
+{
+	struct ipu_platform_data *pdata = dev->dev.platform_data;
+	unsigned int irq, irq_base, i;
+
+	irq_base = pdata->irq_base;
+
+	for (i = 0; i < IPU_IRQ_NR_FN_BANKS; i++) {
+		irq_bank_fn[i].ipu		= ipu;
+		irq_bank_fn[i].irq_base		= irq_base;
+		spin_lock_init(&irq_bank_fn[i].lock);
+
+		dev_dbg(&dev->dev, "IPU-IRQ: Setting up %d function irqs bank "
+			"%d at %u\n", irq_bank_fn[i].nr_irqs, i, irq_base);
+
+		for (irq = irq_base; irq < irq_base + irq_bank_fn[i].nr_irqs;
+		     irq++) {
+			int ret = set_irq_chip(irq, &ipu_irq_chip);
+			if (ret < 0)
+				return ret;
+			ret = set_irq_chip_data(irq, irq_bank_fn + i);
+			if (ret < 0)
+				return ret;
+			set_irq_handler(irq, handle_level_irq);
+#ifdef CONFIG_ARM
+			set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
+#endif
+		}
+		spin_lock_init(&irq_bank_fn[i].lock);
+		irq_base += irq_bank_fn[i].nr_irqs;
+	}
+
+	for (i = 0; i < IPU_IRQ_NR_ERR_BANKS; i++) {
+		irq_bank_err[i].ipu		= ipu;
+		irq_bank_err[i].irq_base	= irq_base;
+		spin_lock_init(&irq_bank_fn[i].lock);
+
+		dev_dbg(&dev->dev, "IPU-IRQ: Setting up %d error irqs bank "
+			"%d at %u\n", irq_bank_err[i].nr_irqs, i, irq_base);
+
+		for (irq = irq_base; irq < irq_base + irq_bank_err[i].nr_irqs;
+		     irq++) {
+			int ret = set_irq_chip(irq, &ipu_irq_chip);
+			if (ret < 0)
+				return ret;
+			ret = set_irq_chip_data(irq, irq_bank_err + i);
+			if (ret < 0)
+				return ret;
+			set_irq_handler(irq, handle_level_irq);
+#ifdef CONFIG_ARM
+			set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
+#endif
+		}
+		spin_lock_init(&irq_bank_err[i].lock);
+		irq_base += irq_bank_err[i].nr_irqs;
+	}
+
+	set_irq_data(ipu->irq_fn, ipu);
+	set_irq_chained_handler(ipu->irq_fn, ipu_irq_fn);
+
+	set_irq_data(ipu->irq_err, ipu);
+	set_irq_chained_handler(ipu->irq_err, ipu_irq_err);
+
+	return 0;
+}
+
+void ipu_irq_detach_irq(struct ipu *ipu, struct platform_device *dev)
+{
+	struct ipu_platform_data *pdata = dev->dev.platform_data;
+	unsigned int irq, irq_base;
+
+	irq_base = pdata->irq_base;
+
+	set_irq_chained_handler(ipu->irq_fn, NULL);
+	set_irq_data(ipu->irq_fn, NULL);
+
+	set_irq_chained_handler(ipu->irq_err, NULL);
+	set_irq_data(ipu->irq_err, NULL);
+
+	for (irq = irq_base; irq < irq_base + IPU_IRQ_NR_IRQS; irq++) {
+#ifdef CONFIG_ARM
+		set_irq_flags(irq, 0);
+#endif
+		set_irq_chip(irq, NULL);
+		set_irq_chip_data(irq, NULL);
+	}
+}
-- 
1.5.4

