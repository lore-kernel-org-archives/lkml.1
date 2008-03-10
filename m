Return-Path: <linux-kernel-owner+w=401wt.eu-S1752166AbYCJO0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbYCJO0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 10:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbYCJO0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 10:26:34 -0400
Received: from mail.atmel.fr ([81.80.104.162]:48298 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbYCJO0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 10:26:33 -0400
Message-ID: <47D5450A.40500@atmel.com>
Date: Mon, 10 Mar 2008 15:26:18 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: linux-fbdev-devel@lists.sourceforge.net,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>
CC: ARM Linux Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Sedji GAOUAOU <sedji.gaouaou@atmel.com>,
       Patrice VILCHEZ <patrice.vilchez@atmel.com>,
       Andrew Victor <linux@maxim.org.za>
Subject: [PATCH] atmel_lcdfb: wiring BGR to RGB color mode
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds different wiring mode for the LCD screen.

The legacy atmel LCDC IP uses a non standard color mode,
"BGR-555.1" instead "RGB-565". The major part of graphic stacks 
for embedded systems uses only "RGB-565". It is possible to swap 
LCD IOs instead of doing this bit swapping by software (See 
application note AT91SAM9 LCD Controller
http://www.atmel.com/dyn/resources/prod_documents/doc6300.pdf)

This wire swapping is done on the at91sam9rl-ek board (board code 
using this patch will come later).
---
 drivers/video/atmel_lcdfb.c |   27 ++++++++++++++++++++++-----
 include/video/atmel_lcdc.h  |   10 ++++++++++
 2 files changed, 32 insertions(+), 5 deletions(-)

--- linux-2.6.x-rc.orig/drivers/video/atmel_lcdfb.c
+++ linux-2.6.x-rc/drivers/video/atmel_lcdfb.c
@@ -338,19 +338,35 @@ static int atmel_lcdfb_check_var(struct 
 		break;
 	case 15:
 	case 16:
-		var->red.offset = 0;
+		if (sinfo->lcd_wiring_mode == ATMEL_LCDC_WIRING_RGB) {
+			/* RGB:565 mode */
+			var->red.offset = 11;
+			var->blue.offset = 0;
+			var->green.length = 6;
+		} else {
+			/* BGR:555 mode */
+			var->red.offset = 0;
+			var->blue.offset = 10;
+			var->green.length = 5;
+		}
 		var->green.offset = 5;
-		var->blue.offset = 10;
-		var->red.length = var->green.length = var->blue.length = 5;
+		var->red.length = var->blue.length = 5;
 		break;
 	case 32:
 		var->transp.offset = 24;
 		var->transp.length = 8;
 		/* fall through */
 	case 24:
-		var->red.offset = 0;
+		if (sinfo->lcd_wiring_mode == ATMEL_LCDC_WIRING_RGB) {
+			/* RGB:888 mode */
+			var->red.offset = 16;
+			var->blue.offset = 0;
+		} else {
+			/* BGR:888 mode */
+			var->red.offset = 0;
+			var->blue.offset = 16;
+		}
 		var->green.offset = 8;
-		var->blue.offset = 16;
 		var->red.length = var->green.length = var->blue.length = 8;
 		break;
 	default:
@@ -697,6 +713,7 @@ static int __init atmel_lcdfb_probe(stru
 		sinfo->atmel_lcdfb_power_control = pdata_sinfo->atmel_lcdfb_power_control;
 		sinfo->guard_time = pdata_sinfo->guard_time;
 		sinfo->lcdcon_is_backlight = pdata_sinfo->lcdcon_is_backlight;
+		sinfo->lcd_wiring_mode = pdata_sinfo->lcd_wiring_mode;
 	} else {
 		dev_err(dev, "cannot get default configuration\n");
 		goto free_info;
--- linux-2.6.x-rc.orig/include/video/atmel_lcdc.h
+++ linux-2.6.x-rc/include/video/atmel_lcdc.h
@@ -22,6 +22,15 @@
 #ifndef __ATMEL_LCDC_H__
 #define __ATMEL_LCDC_H__
 
+
+/* Way LCD wires are connected to the chip:
+ * Some Atmel chips use BGR color mode (instead of standard RGB)
+ * A swapped wiring onboard can bring to RGB mode.
+ */
+#define ATMEL_LCDC_WIRING_BGR	0
+#define ATMEL_LCDC_WIRING_RGB	1
+
+
  /* LCD Controller info data structure, stored in device platform_data */
 struct atmel_lcdfb_info {
 	spinlock_t		lock;
@@ -42,6 +51,7 @@ struct atmel_lcdfb_info {
 	u8			saved_lcdcon;
 
 	u8			default_bpp;
+	u8			lcd_wiring_mode;
 	unsigned int		default_lcdcon2;
 	unsigned int		default_dmacon;
 	void (*atmel_lcdfb_power_control)(int on);

