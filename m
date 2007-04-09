Return-Path: <linux-kernel-owner+w=401wt.eu-S1753009AbXDIVoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbXDIVoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965913AbXDIVnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:43:20 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:32205 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965996AbXDIVaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:30:04 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 10/14] ARM: OMAP: osk+mistral backlight, power, board specific
Date: Mon,  9 Apr 2007 17:28:35 -0400
Message-Id: <1176154169578-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761541643961-git-send-email-tony@atomide.com>
References: <1176154119123-git-send-email-tony@atomide.com> <11761541231278-git-send-email-tony@atomide.com> <11761541282179-git-send-email-tony@atomide.com> <1176154139299-git-send-email-tony@atomide.com> <117615414325-git-send-email-tony@atomide.com> <1176154146826-git-send-email-tony@atomide.com> <11761541501423-git-send-email-tony@atomide.com> <1176154157419-git-send-email-tony@atomide.com> <117615416178-git-send-email-tony@atomide.com> <11761541643961-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Mistral-specific:

  - Add PWL-driven LCD backlight device

  - Apply power to the board even when the LCD isn't configured; things
    like EEPROM, temperature sensor, and wakeup switch depend on it.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/board-osk.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

Index: linux-2.6/arch/arm/mach-omap1/board-osk.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/board-osk.c	2007-04-09 16:40:23.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap1/board-osk.c	2007-04-09 16:40:29.000000000 -0400
@@ -293,6 +293,18 @@ static struct platform_device osk5912_kp
 	.resource	= osk5912_kp_resources,
 };
 
+static struct omap_backlight_config mistral_bl_data = {
+	.default_intensity	= 0xa0,
+};
+
+static struct platform_device mistral_bl_device = {
+	.name		= "omap-bl",
+	.id		= -1,
+	.dev		= {
+		.platform_data = &mistral_bl_data,
+	},
+};
+
 static struct platform_device osk5912_lcd_device = {
 	.name		= "lcd_osk",
 	.id		= -1,
@@ -300,6 +312,7 @@ static struct platform_device osk5912_lc
 
 static struct platform_device *mistral_devices[] __initdata = {
 	&osk5912_kp_device,
+	&mistral_bl_device,
 	&osk5912_lcd_device,
 };
 
@@ -405,6 +418,15 @@ static void __init osk_mistral_init(void
 	} else
 		printk(KERN_ERR "OSK+Mistral: wakeup button is awol\n");
 
+	/* LCD:  backlight, and power; power controls other devices on the
+	 * board, like the touchscreen, EEPROM, and wakeup (!) switch.
+	 */
+	omap_cfg_reg(PWL);
+	if (omap_request_gpio(2) == 0) {
+		omap_set_gpio_direction(2, 0 /* out */);
+		omap_set_gpio_dataout(2, 1 /* on */);
+	}
+
 	platform_add_devices(mistral_devices, ARRAY_SIZE(mistral_devices));
 }
 #else
