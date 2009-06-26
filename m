Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbZFZJjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbZFZJjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 05:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbZFZJjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 05:39:43 -0400
Received: from mail.atmel.fr ([81.80.104.162]:52136 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862AbZFZJjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 05:39:42 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: dan.j.williams@intel.com, maciej.sosnowski@intel.com, avictor.za@gmail.com,
       linux-arm-kernel@lists.arm.linux.org.uk
Cc: patrice.vilchez@atmel.com, linux-kernel@vger.kernel.org,
       nicolas.ferre@atmel.com
Subject: [PATCH 2/2 v2] at91/dmaengine: integration of at_hdmac driver in at91sam9rl
Date: Fri, 26 Jun 2009 12:42:16 +0200
Message-Id: <1246012936-10812-2-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1246012936-10812-1-git-send-email-nicolas.ferre@atmel.com>
References: <1246012936-10812-1-git-send-email-nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the integration of DMA engine driver into at91sam9rl device file. The
associated driver is at_hdmac.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
This patch is based on async_tx.git/next and may need modification for
inclusion in the at91 patch submission flow.

 arch/arm/mach-at91/at91sam9rl_devices.c |   49 ++++++++++++++++++++++++++++++-
 1 files changed, 48 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
index 7281865..65a4997 100644
--- a/arch/arm/mach-at91/at91sam9rl_devices.c
+++ b/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -21,11 +21,57 @@
 #include <mach/at91sam9rl.h>
 #include <mach/at91sam9rl_matrix.h>
 #include <mach/at91sam9_smc.h>
+#include <mach/at_hdmac.h>
 
 #include "generic.h"
 
 
 /* --------------------------------------------------------------------
+ *  HDMAC - AHB DMA Controller
+ * -------------------------------------------------------------------- */
+
+#if defined(CONFIG_AT_HDMAC) || defined(CONFIG_AT_HDMAC_MODULE)
+static u64 hdmac_dmamask = DMA_BIT_MASK(32);
+
+static struct at_dma_platform_data atdma_pdata = {
+	.nr_channels	= 2,
+};
+
+static struct resource hdmac_resources[] = {
+	[0] = {
+		.start	= AT91_BASE_SYS + AT91_DMA,
+		.end	= AT91_BASE_SYS + AT91_DMA + SZ_512 - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[2] = {
+		.start	= AT91SAM9RL_ID_DMA,
+		.end	= AT91SAM9RL_ID_DMA,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device at_hdmac_device = {
+	.name		= "at_hdmac",
+	.id		= -1,
+	.dev		= {
+				.dma_mask		= &hdmac_dmamask,
+				.coherent_dma_mask	= DMA_BIT_MASK(32),
+				.platform_data		= &atdma_pdata,
+	},
+	.resource	= hdmac_resources,
+	.num_resources	= ARRAY_SIZE(hdmac_resources),
+};
+
+void __init at91_add_device_hdmac(void)
+{
+	dma_cap_set(DMA_MEMCPY, atdma_pdata.cap_mask);
+	platform_device_register(&at_hdmac_device);
+}
+#else
+void __init at91_add_device_hdmac(void) {}
+#endif
+
+/* --------------------------------------------------------------------
  *  USB HS Device (Gadget)
  * -------------------------------------------------------------------- */
 
@@ -823,7 +869,7 @@ static struct resource dbgu_resources[] = {
 };
 
 static struct atmel_uart_data dbgu_data = {
-	.use_dma_tx	= 0,
+	.use_dma_tx	= 1,
 	.use_dma_rx	= 0,		/* DBGU not capable of receive DMA */
 	.regs		= (void __iomem *)(AT91_VA_BASE_SYS + AT91_DBGU),
 };
@@ -1103,6 +1149,7 @@ void __init at91_add_device_serial(void) {}
  */
 static int __init at91_add_standard_devices(void)
 {
+	at91_add_device_hdmac();
 	at91_add_device_rtc();
 	at91_add_device_rtt();
 	at91_add_device_watchdog();
-- 
1.5.3.7

