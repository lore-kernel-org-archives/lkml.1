Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbYGRGsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbYGRGsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 02:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYGRGsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 02:48:16 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108]:21471
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752812AbYGRGsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 02:48:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgAALvZf0jLrQkK/2dsb2JhbAAIrzo
X-IronPort-AV: E=Sophos;i="4.31,208,1215360000"; 
   d="scan'208";a="358913845"
Subject: [PATCH] avr32: clean up mci platform code
From: Ben Nizette <bn@niasdigital.com>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       kernel <kernel@avr32linux.org>
Content-Type: text/plain
Organization: Nias Digital
Date: Fri, 18 Jul 2008 16:48:09 +1000
Message-Id: <1216363689.4004.80.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch does a few small cleanups around the atmel mci platform code
and in the atmel-mci driver.  The platform changes simply removes an
unused variable, uses the fact that by the end we always have some form
of platform data and notes that GPIO_PIN_NONE != 0.  This last point
could cause the incorrect attempt to twice reserve pin PA0.

While we've got the hood up, add linux/err.h to the atmel-mci.c include
list.  It needs it and generally pulls it by voodoo but I did once
stumble across a config which don't build.

This is against Linus' latest git.

Signed-off-by: Ben Nizette <bn@niasdigital.com>

---
diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index 021d512..4ac38d2 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -1284,7 +1284,6 @@ at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 {
 	struct mci_platform_data	_data;
 	struct platform_device		*pdev;
-	struct dw_dma_slave		*dws;
 
 	if (id != 0)
 		return NULL;
@@ -1300,6 +1299,8 @@ at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 	if (!data) {
 		data = &_data;
 		memset(data, 0, sizeof(struct mci_platform_data));
+		data->detect_pin = GPIO_PIN_NONE;
+		data->wp_pin = GPIO_PIN_NONE;
 	}
 
 	if (platform_device_add_data(pdev, data,
@@ -1313,12 +1314,10 @@ at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 	select_peripheral(PA(14), PERIPH_A, 0);	/* DATA2 */
 	select_peripheral(PA(15), PERIPH_A, 0);	/* DATA3 */
 
-	if (data) {
-		if (data->detect_pin != GPIO_PIN_NONE)
-			at32_select_gpio(data->detect_pin, 0);
-		if (data->wp_pin != GPIO_PIN_NONE)
-			at32_select_gpio(data->wp_pin, 0);
-	}
+	if (data->detect_pin != GPIO_PIN_NONE)
+		at32_select_gpio(data->detect_pin, 0);
+	if (data->wp_pin != GPIO_PIN_NONE)
+		at32_select_gpio(data->wp_pin, 0);
 
 	atmel_mci0_pclk.dev = &pdev->dev;
 
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index cce873c..c2f8aa8 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -10,6 +10,7 @@
 #include <linux/blkdev.h>
 #include <linux/clk.h>
 #include <linux/device.h>
+#include <linux/err.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/ioport.h>

