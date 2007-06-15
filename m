Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbXFOJDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbXFOJDW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 05:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbXFOJDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 05:03:14 -0400
Received: from mail.atmel.fr ([81.80.104.162]:65019 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbXFOJDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 05:03:13 -0400
Message-ID: <467255A3.4040701@rfo.atmel.com>
Date: Fri, 15 Jun 2007 11:02:27 +0200
From: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Organization: atmel
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Andrew Victor <andrew@sanpeople.com>,
       linux-fbdev-devel@lists.sourceforge.net
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Jan Altenberg <jan.altenberg@linutronix.de>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>
Subject: [RFC] AT91: atmel_lcdfb: at91sam9261ek support for STN b/w display
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-ESAFE-STATUS: Mail clean
X-ESAFE-DETAILS: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>

Adds STN LCD support on at91sam9261ek. Uses a black and 
white screen from Hitachi : SP06Q002.

Signed-off-by: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
---
Submitted in linux-fbdev for a RFC but will make its way 
through the AT91 maintainer.

Relies on the CONFIG_FB_ATMEL_STN switch to choose the TFT or 
STN display (switch in drivers/video/Kconfig).

arch/arm/mach-at91/at91sam9261_devices.c |   15 ++++
arch/arm/mach-at91/board-sam9261ek.c     |   74 +++++++++++++++++++--
2 files changed, 83 insertions(+), 6 deletions(-)

Index: b/arch/arm/mach-at91/board-sam9261ek.c
===================================================================
--- a/arch/arm/mach-at91/board-sam9261ek.c
+++ b/arch/arm/mach-at91/board-sam9261ek.c
@@ -281,6 +281,8 @@
  * LCD Controller
  */
 #if defined(CONFIG_FB_ATMEL) || defined(CONFIG_FB_ATMEL_MODULE)
+
+/* TFT */
 static struct fb_videomode at91_tft_vga_modes[] = {
 	{
 	        .name           = "TX09D50VM1CCA @ 60",
@@ -297,7 +299,7 @@
 	},
 };
 
-static struct fb_monspecs at91fb_default_monspecs = {
+static struct fb_monspecs at91fb_default_tft_monspecs = {
 	.manufacturer	= "HIT",
 	.monitor        = "TX09D50VM1CCA",
 
@@ -309,11 +311,11 @@
 	.vfmax		= 150,
 };
 
-#define AT91SAM9261_DEFAULT_LCDCON2 	(ATMEL_LCDC_MEMOR_LITTLE \
+#define AT91SAM9261_DEFAULT_TFT_LCDCON2	(ATMEL_LCDC_MEMOR_LITTLE \
 					| ATMEL_LCDC_DISTYPE_TFT    \
 					| ATMEL_LCDC_CLKMOD_ALWAYSACTIVE)
 
-static void at91_lcdc_power_control(int on)
+static void at91_lcdc_tft_power_control(int on)
 {
 	if (on)
 		at91_set_gpio_value(AT91_PIN_PA12, 0);	/* power up */
@@ -321,15 +323,75 @@
 		at91_set_gpio_value(AT91_PIN_PA12, 1);	/* power down */
 }
 
+/* STN */
+static struct fb_videomode at91_stn_modes[] = {
+        {
+		.name           = "SP06Q002 @ 75",
+		.refresh        = 75,
+		.xres           = 320,          .yres           = 240,
+		.pixclock       = KHZ2PICOS(1440),
+
+		.left_margin    = 1,            .right_margin   = 1,
+		.upper_margin   = 0,            .lower_margin   = 0,
+		.hsync_len      = 1,            .vsync_len      = 1,
+
+		.sync		= FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+		.vmode          = FB_VMODE_NONINTERLACED,
+        },
+};
+
+static struct fb_monspecs at91fb_default_stn_monspecs = {
+        .manufacturer   = "HIT",
+        .monitor        = "SP06Q002",
+
+        .modedb         = at91_stn_modes,
+        .modedb_len     = ARRAY_SIZE(at91_stn_modes),
+        .hfmin          = 15000,
+        .hfmax          = 64000,
+        .vfmin          = 50,
+        .vfmax          = 150,
+};
+
+#define AT91SAM9261_DEFAULT_STN_LCDCON2	(ATMEL_LCDC_MEMOR_LITTLE \
+					| ATMEL_LCDC_DISTYPE_STNMONO \
+					| ATMEL_LCDC_CLKMOD_ALWAYSACTIVE \
+					| ATMEL_LCDC_IFWIDTH_4 \
+					| ATMEL_LCDC_SCANMOD_SINGLE)
+
+static void at91_lcdc_stn_power_control(int on)
+{
+	/* backlight */
+	if (on) {
+		/* power up */
+		at91_set_gpio_value(AT91_PIN_PC14, 0);
+		at91_set_gpio_value(AT91_PIN_PC15, 0);
+	} else {
+		/* power down */
+		at91_set_gpio_value(AT91_PIN_PC14, 1);
+		at91_set_gpio_value(AT91_PIN_PC15, 1);
+	}
+}
+
 /* Driver datas */
+#if defined(CONFIG_FB_ATMEL_STN)
+static struct atmel_lcdfb_info __initdata ek_lcdc_data = {
+	.default_bpp			= 1,
+	.default_dmacon			= ATMEL_LCDC_DMAEN,
+	.default_lcdcon2		= AT91SAM9261_DEFAULT_STN_LCDCON2,
+	.default_monspecs		= &at91fb_default_stn_monspecs,
+	.atmel_lcdfb_power_control	= at91_lcdc_stn_power_control,
+	.guard_time			= 1,
+};
+#else
 static struct atmel_lcdfb_info __initdata ek_lcdc_data = {
 	.default_bpp			= 16,
 	.default_dmacon			= ATMEL_LCDC_DMAEN,
-	.default_lcdcon2		= AT91SAM9261_DEFAULT_LCDCON2,
-	.default_monspecs		= &at91fb_default_monspecs,
-	.atmel_lcdfb_power_control	= at91_lcdc_power_control,
+	.default_lcdcon2		= AT91SAM9261_DEFAULT_TFT_LCDCON2,
+	.default_monspecs		= &at91fb_default_tft_monspecs,
+	.atmel_lcdfb_power_control	= at91_lcdc_tft_power_control,
 	.guard_time			= 1,
 };
+#endif
 
 #else
 static struct atmel_lcdfb_info __initdata ek_lcdc_data;
Index: b/arch/arm/mach-at91/at91sam9261_devices.c
===================================================================
--- a/arch/arm/mach-at91/at91sam9261_devices.c
+++ b/arch/arm/mach-at91/at91sam9261_devices.c
@@ -475,6 +475,20 @@
 		return;
 	}
 
+#if defined(CONFIG_FB_ATMEL_STN)
+	at91_set_A_periph(AT91_PIN_PB0, 0);     /* LCDVSYNC */
+	at91_set_A_periph(AT91_PIN_PB1, 0);     /* LCDHSYNC */
+	at91_set_A_periph(AT91_PIN_PB2, 0);     /* LCDDOTCK */
+	at91_set_A_periph(AT91_PIN_PB3, 0);     /* LCDDEN */
+	at91_set_A_periph(AT91_PIN_PB4, 0);     /* LCDCC */
+	at91_set_A_periph(AT91_PIN_PB5, 0);     /* LCDD0 */
+	at91_set_A_periph(AT91_PIN_PB6, 0);     /* LCDD1 */
+	at91_set_A_periph(AT91_PIN_PB7, 0);     /* LCDD2 */
+	at91_set_A_periph(AT91_PIN_PB8, 0);     /* LCDD3 */
+
+	at91_set_gpio_output(AT91_PIN_PC14, 1);  /* backlight off */
+	at91_set_gpio_output(AT91_PIN_PC15, 1);  /* backlight off */
+#else
 	at91_set_A_periph(AT91_PIN_PB1, 0);	/* LCDHSYNC */
 	at91_set_A_periph(AT91_PIN_PB2, 0);	/* LCDDOTCK */
 	at91_set_A_periph(AT91_PIN_PB3, 0);	/* LCDDEN */
@@ -497,6 +511,7 @@
 	at91_set_B_periph(AT91_PIN_PB26, 0);	/* LCDD21 */
 	at91_set_B_periph(AT91_PIN_PB27, 0);	/* LCDD22 */
 	at91_set_B_periph(AT91_PIN_PB28, 0);	/* LCDD23 */
+#endif
 
 	lcdc_data = *data;
 	platform_device_register(&at91_lcdc_device);




