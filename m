Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbYLGVqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbYLGVqm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 16:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbYLGVqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 16:46:34 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:59252 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbYLGVqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 16:46:32 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.40.92
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19dtmZQaMvjVb3Fn0J6kIEN
Subject: [PATCH 1/5] omap mmc: Remove broken MMC init code
To: drzeus-mmc@drzeus.cx, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
From: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org
Date: Sun, 07 Dec 2008 13:46:30 -0800
Message-ID: <20081207214630.10456.28574.stgit@localhost>
In-Reply-To: <20081207213617.10456.43951.stgit@localhost>
References: <20081207213617.10456.43951.stgit@localhost>
User-Agent: Whatever/0.14.3.285.g62874
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the omap1 MMC boards got broken by an earlier patch
138ab9f8321f67c71984ca43222efa71b0a0a0a9. If you look closely,
the MMC init funtions are pretty much just stubs.

Remove broken init code to make room for cleaner MMC init code.

Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/board-h2-mmc.c    |   86 --------------------------------
 arch/arm/mach-omap1/board-h2.c        |   10 ----
 arch/arm/mach-omap1/board-h3-mmc.c    |   90 ---------------------------------
 arch/arm/mach-omap1/board-h3.c        |   10 ----
 arch/arm/mach-omap1/board-palmte.c    |    1 
 arch/arm/mach-omap1/board-palmz71.c   |   11 ----
 arch/arm/mach-omap1/board-sx1-mmc.c   |   49 ------------------
 arch/arm/mach-omap1/board-sx1.c       |   10 ----
 arch/arm/mach-omap1/board-voiceblue.c |   10 ----
 arch/arm/mach-omap2/board-apollon.c   |   11 ----
 arch/arm/mach-omap2/board-generic.c   |   11 ----
 arch/arm/mach-omap2/board-h4.c        |   11 ----
 12 files changed, 1 insertions(+), 309 deletions(-)

diff --git a/arch/arm/mach-omap1/board-h2-mmc.c b/arch/arm/mach-omap1/board-h2-mmc.c
index ab9ee58..504ae88 100644
--- a/arch/arm/mach-omap1/board-h2-mmc.c
+++ b/arch/arm/mach-omap1/board-h2-mmc.c
@@ -15,91 +15,6 @@
 #include <mach/mmc.h>
 #include <mach/gpio.h>
 
-#ifdef CONFIG_MMC_OMAP
-static int slot_cover_open;
-static struct device *mmc_device;
-
-static int h2_mmc_set_power(struct device *dev, int slot, int power_on,
-				int vdd)
-{
-#ifdef CONFIG_MMC_DEBUG
-	dev_dbg(dev, "Set slot %d power: %s (vdd %d)\n", slot + 1,
-		power_on ? "on" : "off", vdd);
-#endif
-	if (slot != 0) {
-		dev_err(dev, "No such slot %d\n", slot + 1);
-		return -ENODEV;
-	}
-
-	return 0;
-}
-
-static int h2_mmc_set_bus_mode(struct device *dev, int slot, int bus_mode)
-{
-#ifdef CONFIG_MMC_DEBUG
-	dev_dbg(dev, "Set slot %d bus_mode %s\n", slot + 1,
-		bus_mode == MMC_BUSMODE_OPENDRAIN ? "open-drain" : "push-pull");
-#endif
-	if (slot != 0) {
-		dev_err(dev, "No such slot %d\n", slot + 1);
-		return -ENODEV;
-	}
-
-	return 0;
-}
-
-static int h2_mmc_get_cover_state(struct device *dev, int slot)
-{
-	BUG_ON(slot != 0);
-
-	return slot_cover_open;
-}
-
-void h2_mmc_slot_cover_handler(void *arg, int state)
-{
-	if (mmc_device == NULL)
-		return;
-
-	slot_cover_open = state;
-	omap_mmc_notify_cover_event(mmc_device, 0, state);
-}
-
-static int h2_mmc_late_init(struct device *dev)
-{
-	int ret = 0;
-
-	mmc_device = dev;
-
-	return ret;
-}
-
-static void h2_mmc_cleanup(struct device *dev)
-{
-}
-
-static struct omap_mmc_platform_data h2_mmc_data = {
-	.nr_slots                       = 1,
-	.switch_slot                    = NULL,
-	.init                           = h2_mmc_late_init,
-	.cleanup                        = h2_mmc_cleanup,
-	.slots[0]       = {
-		.set_power              = h2_mmc_set_power,
-		.set_bus_mode           = h2_mmc_set_bus_mode,
-		.get_ro                 = NULL,
-		.get_cover_state        = h2_mmc_get_cover_state,
-		.ocr_mask               = MMC_VDD_28_29 | MMC_VDD_30_31 |
-					  MMC_VDD_32_33 | MMC_VDD_33_34,
-		.name                   = "mmcblk",
-	},
-};
-
-void __init h2_mmc_init(void)
-{
-	omap_set_mmc_info(1, &h2_mmc_data);
-}
-
-#else
-
 void __init h2_mmc_init(void)
 {
 }
@@ -107,4 +22,3 @@ void __init h2_mmc_init(void)
 void h2_mmc_slot_cover_handler(void *arg, int state)
 {
 }
-#endif
diff --git a/arch/arm/mach-omap1/board-h2.c b/arch/arm/mach-omap1/board-h2.c
index c5b4a3b..125d8e2 100644
--- a/arch/arm/mach-omap1/board-h2.c
+++ b/arch/arm/mach-omap1/board-h2.c
@@ -378,15 +378,6 @@ static struct omap_usb_config h2_usb_config __initdata = {
 	.pins[1]	= 3,
 };
 
-static struct omap_mmc_config h2_mmc_config __initdata = {
-	.mmc[0] = {
-		.enabled	= 1,
-		.wire4		= 1,
-	},
-};
-
-extern struct omap_mmc_platform_data h2_mmc_data;
-
 static struct omap_uart_config h2_uart_config __initdata = {
 	.enabled_uarts = ((1 << 0) | (1 << 1) | (1 << 2)),
 };
@@ -397,7 +388,6 @@ static struct omap_lcd_config h2_lcd_config __initdata = {
 
 static struct omap_board_config_kernel h2_config[] __initdata = {
 	{ OMAP_TAG_USB,		&h2_usb_config },
-	{ OMAP_TAG_MMC,		&h2_mmc_config },
 	{ OMAP_TAG_UART,	&h2_uart_config },
 	{ OMAP_TAG_LCD,		&h2_lcd_config },
 };
diff --git a/arch/arm/mach-omap1/board-h3-mmc.c b/arch/arm/mach-omap1/board-h3-mmc.c
index 3608581..0baba1c 100644
--- a/arch/arm/mach-omap1/board-h3-mmc.c
+++ b/arch/arm/mach-omap1/board-h3-mmc.c
@@ -15,95 +15,6 @@
 #include <mach/mmc.h>
 #include <mach/gpio.h>
 
-#ifdef CONFIG_MMC_OMAP
-static int slot_cover_open;
-static struct device *mmc_device;
-
-static int h3_mmc_set_power(struct device *dev, int slot, int power_on,
-				int vdd)
-{
-#ifdef CONFIG_MMC_DEBUG
-	dev_dbg(dev, "Set slot %d power: %s (vdd %d)\n", slot + 1,
-		power_on ? "on" : "off", vdd);
-#endif
-	if (slot != 0) {
-		dev_err(dev, "No such slot %d\n", slot + 1);
-		return -ENODEV;
-	}
-
-	return 0;
-}
-
-static int h3_mmc_set_bus_mode(struct device *dev, int slot, int bus_mode)
-{
-	int ret = 0;
-
-#ifdef CONFIG_MMC_DEBUG
-	dev_dbg(dev, "Set slot %d bus_mode %s\n", slot + 1,
-		bus_mode == MMC_BUSMODE_OPENDRAIN ? "open-drain" : "push-pull");
-#endif
-	if (slot != 0) {
-		dev_err(dev, "No such slot %d\n", slot + 1);
-		return -ENODEV;
-	}
-
-	/* Treated on upper level */
-
-	return bus_mode;
-}
-
-static int h3_mmc_get_cover_state(struct device *dev, int slot)
-{
-	BUG_ON(slot != 0);
-
-	return slot_cover_open;
-}
-
-void h3_mmc_slot_cover_handler(void *arg, int state)
-{
-	if (mmc_device == NULL)
-		return;
-
-	slot_cover_open = state;
-	omap_mmc_notify_cover_event(mmc_device, 0, state);
-}
-
-static int h3_mmc_late_init(struct device *dev)
-{
-	int ret = 0;
-
-	mmc_device = dev;
-
-	return ret;
-}
-
-static void h3_mmc_cleanup(struct device *dev)
-{
-}
-
-static struct omap_mmc_platform_data h3_mmc_data = {
-	.nr_slots                       = 1,
-	.switch_slot                    = NULL,
-	.init                           = h3_mmc_late_init,
-	.cleanup                        = h3_mmc_cleanup,
-	.slots[0]       = {
-		.set_power              = h3_mmc_set_power,
-		.set_bus_mode           = h3_mmc_set_bus_mode,
-		.get_ro                 = NULL,
-		.get_cover_state        = h3_mmc_get_cover_state,
-		.ocr_mask               = MMC_VDD_28_29 | MMC_VDD_30_31 |
-					  MMC_VDD_32_33 | MMC_VDD_33_34,
-		.name                   = "mmcblk",
-	},
-};
-
-void __init h3_mmc_init(void)
-{
-	omap_set_mmc_info(1, &h3_mmc_data);
-}
-
-#else
-
 void __init h3_mmc_init(void)
 {
 }
@@ -111,4 +22,3 @@ void __init h3_mmc_init(void)
 void h3_mmc_slot_cover_handler(void *arg, int state)
 {
 }
-#endif
diff --git a/arch/arm/mach-omap1/board-h3.c b/arch/arm/mach-omap1/board-h3.c
index 0332203..5157eea 100644
--- a/arch/arm/mach-omap1/board-h3.c
+++ b/arch/arm/mach-omap1/board-h3.c
@@ -447,15 +447,6 @@ static struct omap_usb_config h3_usb_config __initdata = {
 	.pins[1]	= 3,
 };
 
-static struct omap_mmc_config h3_mmc_config __initdata = {
-	.mmc[0] = {
-		.enabled	= 1,
-		.wire4		= 1,
-       },
-};
-
-extern struct omap_mmc_platform_data h3_mmc_data;
-
 static struct omap_uart_config h3_uart_config __initdata = {
 	.enabled_uarts = ((1 << 0) | (1 << 1) | (1 << 2)),
 };
@@ -466,7 +457,6 @@ static struct omap_lcd_config h3_lcd_config __initdata = {
 
 static struct omap_board_config_kernel h3_config[] __initdata = {
 	{ OMAP_TAG_USB,		&h3_usb_config },
-	{ OMAP_TAG_MMC,		&h3_mmc_config },
 	{ OMAP_TAG_UART,	&h3_uart_config },
 	{ OMAP_TAG_LCD,		&h3_lcd_config },
 };
diff --git a/arch/arm/mach-omap1/board-palmte.c b/arch/arm/mach-omap1/board-palmte.c
index 4141e39..75e32d3 100644
--- a/arch/arm/mach-omap1/board-palmte.c
+++ b/arch/arm/mach-omap1/board-palmte.c
@@ -316,7 +316,6 @@ static void palmte_get_power_status(struct apm_power_info *info, int *battery)
 
 static struct omap_board_config_kernel palmte_config[] __initdata = {
 	{ OMAP_TAG_USB,		&palmte_usb_config },
-	{ OMAP_TAG_MMC,		&palmte_mmc_config },
 	{ OMAP_TAG_LCD,		&palmte_lcd_config },
 	{ OMAP_TAG_UART,	&palmte_uart_config },
 };
diff --git a/arch/arm/mach-omap1/board-palmz71.c b/arch/arm/mach-omap1/board-palmz71.c
index 801fb5f..cc05257 100644
--- a/arch/arm/mach-omap1/board-palmz71.c
+++ b/arch/arm/mach-omap1/board-palmz71.c
@@ -267,16 +267,6 @@ static struct omap_usb_config palmz71_usb_config __initdata = {
 	.pins[0]	= 2,
 };
 
-static struct omap_mmc_config palmz71_mmc_config __initdata = {
-	.mmc[0] = {
-		.enabled	= 1,
-		.wire4		= 0,
-		.wp_pin		= PALMZ71_MMC_WP_GPIO,
-		.power_pin	= -1,
-		.switch_pin	= PALMZ71_MMC_IN_GPIO,
-	},
-};
-
 static struct omap_lcd_config palmz71_lcd_config __initdata = {
 	.ctrl_name = "internal",
 };
@@ -287,7 +277,6 @@ static struct omap_uart_config palmz71_uart_config __initdata = {
 
 static struct omap_board_config_kernel palmz71_config[] __initdata = {
 	{OMAP_TAG_USB,	&palmz71_usb_config},
-	{OMAP_TAG_MMC,	&palmz71_mmc_config},
 	{OMAP_TAG_LCD,	&palmz71_lcd_config},
 	{OMAP_TAG_UART,	&palmz71_uart_config},
 };
diff --git a/arch/arm/mach-omap1/board-sx1-mmc.c b/arch/arm/mach-omap1/board-sx1-mmc.c
index 0be4eba..0ece109 100644
--- a/arch/arm/mach-omap1/board-sx1-mmc.c
+++ b/arch/arm/mach-omap1/board-sx1-mmc.c
@@ -48,59 +48,10 @@ static int sx1_mmc_set_power(struct device *dev, int slot, int power_on,
 	return sx1_i2c_write_byte(SOFIA_I2C_ADDR, SOFIA_POWER1_REG, dat);
 }
 
-static int sx1_mmc_set_bus_mode(struct device *dev, int slot, int bus_mode)
-{
-#ifdef CONFIG_MMC_DEBUG
-	dev_dbg(dev, "Set slot %d bus_mode %s\n", slot + 1,
-		bus_mode == MMC_BUSMODE_OPENDRAIN ? "open-drain" : "push-pull");
-#endif
-	if (slot != 0) {
-		dev_err(dev, "No such slot %d\n", slot + 1);
-		return -ENODEV;
-	}
-
-	return 0;
-}
-
-static int sx1_mmc_get_cover_state(struct device *dev, int slot)
-{
-	BUG_ON(slot != 0);
-
-	return slot_cover_open;
-}
-
-void sx1_mmc_slot_cover_handler(void *arg, int state)
-{
-	if (mmc_device == NULL)
-		return;
-
-	slot_cover_open = state;
-	omap_mmc_notify_cover_event(mmc_device, 0, state);
-}
-
-static int sx1_mmc_late_init(struct device *dev)
-{
-	int ret = 0;
-
-	mmc_device = dev;
-
-	return ret;
-}
-
-static void sx1_mmc_cleanup(struct device *dev)
-{
-}
-
 static struct omap_mmc_platform_data sx1_mmc_data = {
 	.nr_slots                       = 1,
-	.switch_slot                    = NULL,
-	.init                           = sx1_mmc_late_init,
-	.cleanup                        = sx1_mmc_cleanup,
 	.slots[0]       = {
 		.set_power              = sx1_mmc_set_power,
-		.set_bus_mode           = sx1_mmc_set_bus_mode,
-		.get_ro                 = NULL,
-		.get_cover_state        = sx1_mmc_get_cover_state,
 		.ocr_mask               = MMC_VDD_28_29 | MMC_VDD_30_31 |
 					  MMC_VDD_32_33 | MMC_VDD_33_34,
 		.name                   = "mmcblk",
diff --git a/arch/arm/mach-omap1/board-sx1.c b/arch/arm/mach-omap1/board-sx1.c
index 93bd395..8171fe0 100644
--- a/arch/arm/mach-omap1/board-sx1.c
+++ b/arch/arm/mach-omap1/board-sx1.c
@@ -378,15 +378,6 @@ static struct omap_usb_config sx1_usb_config __initdata = {
 	.pins[2]	= 0,
 };
 
-/*----------- MMC -------------------------*/
-
-static struct omap_mmc_config sx1_mmc_config __initdata = {
-	.mmc [0] = {
-		.enabled	= 1,
-		.wire4		= 0,
-	},
-};
-
 /*----------- LCD -------------------------*/
 
 static struct platform_device sx1_lcd_device = {
@@ -414,7 +405,6 @@ static struct omap_uart_config sx1_uart_config __initdata = {
 
 static struct omap_board_config_kernel sx1_config[] __initdata = {
 	{ OMAP_TAG_USB,	&sx1_usb_config },
-	{ OMAP_TAG_MMC,	&sx1_mmc_config },
 	{ OMAP_TAG_LCD,	&sx1_lcd_config },
 	{ OMAP_TAG_UART,	&sx1_uart_config },
 };
diff --git a/arch/arm/mach-omap1/board-voiceblue.c b/arch/arm/mach-omap1/board-voiceblue.c
index 92c9de1..c224f3c 100644
--- a/arch/arm/mach-omap1/board-voiceblue.c
+++ b/arch/arm/mach-omap1/board-voiceblue.c
@@ -15,6 +15,7 @@
 #include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/notifier.h>
@@ -140,21 +141,12 @@ static struct omap_usb_config voiceblue_usb_config __initdata = {
 	.pins[2]	= 6,
 };
 
-static struct omap_mmc_config voiceblue_mmc_config __initdata = {
-	.mmc[0] = {
-		.enabled	= 1,
-		.power_pin	= 2,
-		.switch_pin	= -1,
-	},
-};
-
 static struct omap_uart_config voiceblue_uart_config __initdata = {
 	.enabled_uarts = ((1 << 0) | (1 << 1) | (1 << 2)),
 };
 
 static struct omap_board_config_kernel voiceblue_config[] = {
 	{ OMAP_TAG_USB,  &voiceblue_usb_config },
-	{ OMAP_TAG_MMC,  &voiceblue_mmc_config },
 	{ OMAP_TAG_UART, &voiceblue_uart_config },
 };
 
diff --git a/arch/arm/mach-omap2/board-apollon.c b/arch/arm/mach-omap2/board-apollon.c
index d83035b..bf1e5d3 100644
--- a/arch/arm/mach-omap2/board-apollon.c
+++ b/arch/arm/mach-omap2/board-apollon.c
@@ -261,16 +261,6 @@ static struct omap_uart_config apollon_uart_config __initdata = {
 	.enabled_uarts = (1 << 0) | (0 << 1) | (0 << 2),
 };
 
-static struct omap_mmc_config apollon_mmc_config __initdata = {
-	.mmc [0] = {
-		.enabled 	= 1,
-		.wire4		= 1,
-		.wp_pin		= -1,
-		.power_pin	= -1,
-		.switch_pin	= -1,
-	},
-};
-
 static struct omap_usb_config apollon_usb_config __initdata = {
 	.register_dev	= 1,
 	.hmc_mode	= 0x14,	/* 0:dev 1:host1 2:disable */
@@ -284,7 +274,6 @@ static struct omap_lcd_config apollon_lcd_config __initdata = {
 
 static struct omap_board_config_kernel apollon_config[] = {
 	{ OMAP_TAG_UART,	&apollon_uart_config },
-	{ OMAP_TAG_MMC,		&apollon_mmc_config },
 	{ OMAP_TAG_USB,		&apollon_usb_config },
 	{ OMAP_TAG_LCD,		&apollon_lcd_config },
 };
diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
index 9ba0978..3b34c20 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -41,19 +41,8 @@ static struct omap_uart_config generic_uart_config __initdata = {
 	.enabled_uarts = ((1 << 0) | (1 << 1) | (1 << 2)),
 };
 
-static struct omap_mmc_config generic_mmc_config __initdata = {
-	.mmc [0] = {
-		.enabled 	= 0,
-		.wire4		= 0,
-		.wp_pin		= -1,
-		.power_pin	= -1,
-		.switch_pin	= -1,
-	},
-};
-
 static struct omap_board_config_kernel generic_config[] = {
 	{ OMAP_TAG_UART,	&generic_uart_config },
-	{ OMAP_TAG_MMC,		&generic_mmc_config },
 };
 
 static void __init omap_generic_init(void)
diff --git a/arch/arm/mach-omap2/board-h4.c b/arch/arm/mach-omap2/board-h4.c
index 7de0506..5e9b146 100644
--- a/arch/arm/mach-omap2/board-h4.c
+++ b/arch/arm/mach-omap2/board-h4.c
@@ -373,23 +373,12 @@ static struct omap_uart_config h4_uart_config __initdata = {
 	.enabled_uarts = ((1 << 0) | (1 << 1) | (1 << 2)),
 };
 
-static struct omap_mmc_config h4_mmc_config __initdata = {
-	.mmc [0] = {
-		.enabled	= 1,
-		.wire4		= 1,
-		.wp_pin		= -1,
-		.power_pin	= -1,
-		.switch_pin	= -1,
-	},
-};
-
 static struct omap_lcd_config h4_lcd_config __initdata = {
 	.ctrl_name	= "internal",
 };
 
 static struct omap_board_config_kernel h4_config[] = {
 	{ OMAP_TAG_UART,	&h4_uart_config },
-	{ OMAP_TAG_MMC,		&h4_mmc_config },
 	{ OMAP_TAG_LCD,		&h4_lcd_config },
 };
 

