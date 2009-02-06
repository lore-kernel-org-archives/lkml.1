Return-Path: <linux-kernel-owner+w=401wt.eu-S1757538AbZBFHLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbZBFHLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 02:11:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbZBFHLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 02:11:18 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:1470 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZBFHLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 02:11:17 -0500
X-IronPort-AV: E=Sophos;i="4.37,390,1231131600"; 
   d="scan'208";a="82422006"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, akpm@linux-foundation.org
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Vitja Makarov <vitja.makarov@gmail.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 01/20] Blackfin SPI Driver: ensure cache coherency before doing DMA
Date: Fri,  6 Feb 2009 15:12:49 +0800
Message-Id: <1233904388-5765-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1233904388-5765-1-git-send-email-cooloney@kernel.org>
References: <1233904388-5765-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitja Makarov <vitja.makarov@gmail.com>

flush or invalidate caches before doing DMA transfer, if needed.

[Mike Frysinger <vapier.adi@gmail.com>: add comment to address the
issue "Full duplex only works for non-DMA transfers".]

Signed-off-by: Vitja Makarov <vitja.makarov@gmail.com>
Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/spi/spi_bfin5xx.c |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 7fea3cf..590f975 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -26,6 +26,10 @@
 #include <asm/portmux.h>
 #include <asm/bfin5xx_spi.h>
 
+/* reserved_mem_dcache_on and cache friends */
+#include <asm/cplbinit.h>
+#include <asm/cacheflush.h>
+
 #define DRV_NAME	"bfin-spi"
 #define DRV_AUTHOR	"Bryan Wu, Luke Yang"
 #define DRV_DESC	"Blackfin BF5xx on-chip SPI Controller Driver"
@@ -738,9 +742,10 @@ static void pump_transfers(unsigned long data)
 		width, transfer->len);
 
 	/*
-	 * Try to map dma buffer and do a dma transfer if
-	 * successful use different way to r/w according to
-	 * drv_data->cur_chip->enable_dma
+	 * Try to map dma buffer and do a dma transfer.  If successful use,
+	 * different way to r/w according to the enable_dma settings and if
+	 * we are not doing a full duplex transfer (since the hardware does
+	 * not support full duplex DMA transfers).
 	 */
 	if (!full_duplex && drv_data->cur_chip->enable_dma
 				&& drv_data->len > 6) {
@@ -795,6 +800,12 @@ static void pump_transfers(unsigned long data)
 			/* set transfer mode, and enable SPI */
 			dev_dbg(&drv_data->pdev->dev, "doing DMA in.\n");
 
+			/* invalidate caches, if needed */
+			if (bfin_addr_dcachable((unsigned long) drv_data->rx))
+				invalidate_dcache_range((unsigned long) drv_data->rx,
+							(unsigned long) (drv_data->rx +
+							drv_data->len));
+
 			/* clear tx reg soformer data is not shifted out */
 			write_TDBR(drv_data, 0xFFFF);
 
@@ -815,6 +826,12 @@ static void pump_transfers(unsigned long data)
 		} else if (drv_data->tx != NULL) {
 			dev_dbg(&drv_data->pdev->dev, "doing DMA out.\n");
 
+			/* flush caches, if needed */
+			if (bfin_addr_dcachable((unsigned long) drv_data->tx))
+				flush_dcache_range((unsigned long) drv_data->tx,
+						(unsigned long) (drv_data->tx +
+						drv_data->len));
+
 			/* start dma */
 			dma_enable_irq(drv_data->dma_channel);
 			dma_config = (RESTART | dma_width | DI_EN);
-- 
1.5.6.3
