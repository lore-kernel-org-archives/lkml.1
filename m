Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbYLVSdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbYLVSdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 13:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492AbYLVScE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 13:32:04 -0500
Received: from mail.gmx.net ([213.165.64.20]:42960 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755920AbYLVSby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 13:31:54 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18Tr4wyIl0Tlzr5v861FUL7c0dJeFVPCgs9WKiwqJ
	5oanEmMxxgI7r0
Date: Mon, 22 Dec 2008 19:32:04 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       Sascha Hauer <s.hauer@pengutronix.de>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 4/4 v5] i.MX31: platform bindings and initialisation for IPU
 and framebuffer drivers
In-Reply-To: <Pine.LNX.4.64.0812221922200.5241@axis700.grange>
Message-ID: <Pine.LNX.4.64.0812221930250.5241@axis700.grange>
References: <Pine.LNX.4.64.0812221922200.5241@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

This patch includes platform device data for IPU and framebuffer devices
and pin initialisation for the pcm037 platform.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---
 arch/arm/mach-mx3/devices.c |   89 +++++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-mx3/pcm037.c  |   75 +++++++++++++++++++++++++++++++++++-
 2 files changed, 163 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-mx3/devices.c b/arch/arm/mach-mx3/devices.c
index a6bdcc0..5bc4ec1 100644
--- a/arch/arm/mach-mx3/devices.c
+++ b/arch/arm/mach-mx3/devices.c
@@ -21,8 +21,11 @@
 #include <linux/platform_device.h>
 #include <linux/serial.h>
 #include <linux/gpio.h>
+
 #include <mach/hardware.h>
 #include <mach/imx-uart.h>
+#include <mach/ipu.h>
+#include <mach/mx3fb.h>
 
 static struct resource uart0[] = {
 	{
@@ -145,3 +148,89 @@ int __init mxc_register_gpios(void)
 {
 	return mxc_gpio_init(imx_gpio_ports, ARRAY_SIZE(imx_gpio_ports));
 }
+
+/* i.MX31 Image Processing Unit */
+
+/* The resource order is important! */
+static struct resource mx3_ipu_rsrc[] = {
+	{
+		.start = IPU_CTRL_BASE_ADDR,
+		.end = IPU_CTRL_BASE_ADDR + 0x5F,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = IPU_CTRL_BASE_ADDR + 0x88,
+		.end = IPU_CTRL_BASE_ADDR + 0xB3,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = MXC_INT_IPU_SYN,
+		.end = MXC_INT_IPU_SYN,
+		.flags = IORESOURCE_IRQ,
+	}, {
+		.start = MXC_INT_IPU_ERR,
+		.end = MXC_INT_IPU_ERR,
+		.flags = IORESOURCE_IRQ,
+	}
+};
+
+static struct ipu_platform_data mx3_ipu_data = {
+	.irq_base = MXC_MAX_INT_LINES + MXC_MAX_GPIO_LINES,
+};
+
+static struct platform_device mx3_ipu = {
+	.name = "ipu-core",
+	.id = -1,
+	.resource = mx3_ipu_rsrc,
+	.num_resources = ARRAY_SIZE(mx3_ipu_rsrc),
+	.dev = {
+		.platform_data = &mx3_ipu_data,
+	},
+};
+
+static bool ipu_registered = false;
+
+static struct resource fb_resources[] = {
+	{
+		.start		= IPU_CTRL_BASE_ADDR + 0xB4,
+		.end		= IPU_CTRL_BASE_ADDR + 0x1BF,
+		.flags		= IORESOURCE_MEM,
+	}, {
+		.start		= IPU_IRQ_SDC_BG_EOF,
+		.end		= IPU_IRQ_SDC_BG_EOF,
+		.flags		= IORESOURCE_IRQ,
+	}, {
+		.start		= IPU_IRQ_SDC_FG_EOF,
+		.end		= IPU_IRQ_SDC_FG_EOF,
+		.flags		= IORESOURCE_IRQ,
+	},
+};
+
+static struct mx3fb_platform_data mx3fb_data = {
+	.dma_dev	= &mx3_ipu.dev,
+};
+
+static struct platform_device mx3_fb = {
+	.name		= "mx3_sdc_fb",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(fb_resources),
+	.resource	= fb_resources,
+	.dev		= {
+		.platform_data = &mx3fb_data,
+		.coherent_dma_mask = 0xffffffff,
+	},
+};
+
+int __init mx3_register_fb(const char *name, const struct fb_videomode *modes,
+			   int num_modes)
+{
+	if (!ipu_registered) {
+		int ret = platform_device_register(&mx3_ipu);
+		if (ret < 0)
+			return ret;
+		ipu_registered = true;
+	}
+
+	mx3fb_data.name = name;
+	mx3fb_data.mode = modes;
+	mx3fb_data.num_modes = num_modes;
+	return platform_device_register(&mx3_fb);
+}
diff --git a/arch/arm/mach-mx3/pcm037.c b/arch/arm/mach-mx3/pcm037.c
index 4ebfceb..07ff9f7 100644
--- a/arch/arm/mach-mx3/pcm037.c
+++ b/arch/arm/mach-mx3/pcm037.c
@@ -26,15 +26,17 @@
 #include <linux/gpio.h>
 #include <linux/smc911x.h>
 
-#include <mach/hardware.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/time.h>
 #include <asm/mach/map.h>
+
+#include <mach/hardware.h>
 #include <mach/common.h>
 #include <mach/imx-uart.h>
 #include <mach/iomux-mx3.h>
 #include <mach/board-pcm037.h>
+#include <mach/mx3fb.h>
 
 #include "devices.h"
 
@@ -95,6 +97,47 @@ static struct platform_device *devices[] __initdata = {
 	&pcm037_eth,
 };
 
+static const struct fb_videomode fb_modedb[] = {
+	{
+		/* 320x240 @ 60 Hz */
+		.name		= "CMEL-OLED QVGA",
+		.refresh	= 60,
+		.xres		= 240,
+		.yres		= 320,
+		.pixclock	= /*217014*//*868056*/185925,
+		.left_margin	= 9,
+		.right_margin	= 16,
+		.upper_margin	= 7,
+		.lower_margin	= 9,
+		.hsync_len	= 1,
+		.vsync_len	= 1,
+		.sync		= /*FB_SYNC_HOR_HIGH_ACT | */
+				  /*FB_SYNC_OE_ACT_HIGH | S6E63D6 datasheet p.92 - active low. */
+				  /*FB_SYNC_VERT_HIGH_ACT |*/
+				  FB_SYNC_CLK_INVERT |
+				  FB_SYNC_CLK_IDLE_EN | FB_SYNC_CLK_SEL_EN,
+		.vmode		= FB_VMODE_NONINTERLACED,
+		.flag		= 0,
+	}, {
+		/* 240x320 @ 60 Hz */
+		.name		= "Sharp-LQ035Q7DH06-QVGA",
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
+				  FB_SYNC_CLK_INVERT | FB_SYNC_CLK_IDLE_EN,
+		.vmode		= FB_VMODE_NONINTERLACED,
+		.flag		= 0,
+	},
+};
+
 /*
  * Board specific initialization.
  */
@@ -118,6 +161,36 @@ static void __init mxc_board_init(void)
 	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_GPIO3_1, IOMUX_CONFIG_GPIO));
 	if (!gpio_request(MX31_PIN_GPIO3_1, "pcm037-eth"))
 		gpio_direction_input(MX31_PIN_GPIO3_1);
+
+	/* Display Interface #3 */
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_LD0, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_LD1, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_LD2, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_LD3, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_LD4, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_LD5, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_LD6, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_LD7, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_LD8, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_LD9, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_LD10, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_LD11, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_LD12, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_LD13, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_LD14, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_LD15, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_LD16, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_LD17, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_VSYNC3, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_HSYNC, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_FPSHIFT, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_DRDY0, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_D3_REV, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_CONTRAST, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_D3_SPL, IOMUX_CONFIG_FUNC));
+	mxc_iomux_mode(IOMUX_MODE(MX31_PIN_D3_CLS, IOMUX_CONFIG_FUNC));
+
+	mx3_register_fb(fb_modedb[1].name, fb_modedb, ARRAY_SIZE(fb_modedb));
 }
 
 /*
-- 
1.5.4
