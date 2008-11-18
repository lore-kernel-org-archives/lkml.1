Return-Path: <linux-kernel-owner+w=401wt.eu-S1752914AbYKRHx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbYKRHx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 02:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbYKRHv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 02:51:27 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:57358 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbYKRHvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 02:51:23 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62690388"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Vitja Makarov <vitja.makarov@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 01/16] Blackfin SPI Driver: ensure cache coherency before doing DMA
Date: Tue, 18 Nov 2008 15:52:25 +0800
Message-Id: <1226994760-4301-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226994760-4301-1-git-send-email-cooloney@kernel.org>
References: <1226994760-4301-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitja Makarov <vitja.makarov@gmail.com>

flush or invalidate caches before doing DMA transfer, if needed.

Signed-off-by: Vitja Makarov <vitja.makarov@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/spi/spi_bfin5xx.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 7fea3cf..e9b7366 100644
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
@@ -795,6 +799,12 @@ static void pump_transfers(unsigned long data)
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
 
@@ -815,6 +825,12 @@ static void pump_transfers(unsigned long data)
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
