Return-Path: <linux-kernel-owner+w=401wt.eu-S1757812AbZBFHNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812AbZBFHNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 02:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754920AbZBFHLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 02:11:22 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:1470 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbZBFHLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 02:11:19 -0500
X-IronPort-AV: E=Sophos;i="4.37,390,1231131600"; 
   d="scan'208";a="82422011"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, akpm@linux-foundation.org
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 06/20] Blackfin SPI Driver: unify duplicated code in dma read/write paths
Date: Fri,  6 Feb 2009 15:12:54 +0800
Message-Id: <1233904388-5765-7-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1233904388-5765-1-git-send-email-cooloney@kernel.org>
References: <1233904388-5765-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

For DMA TX/RX operation in pump_transfers, DMA contriguration code
in TX and RX paths are almost the same. This patch unify the duplicated
DMA code to make it more readable.

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/spi/spi_bfin5xx.c |   47 ++++++++++++++++++++------------------------
 1 files changed, 21 insertions(+), 26 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 3945b59..acb9739 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -756,18 +756,19 @@ static void pump_transfers(unsigned long data)
 	if (!full_duplex && drv_data->cur_chip->enable_dma
 				&& drv_data->len > 6) {
 
+		unsigned long dma_start_addr;
+
 		disable_dma(drv_data->dma_channel);
 		clear_dma_irqstat(drv_data->dma_channel);
 		bfin_spi_disable(drv_data);
 
 		/* config dma channel */
 		dev_dbg(&drv_data->pdev->dev, "doing dma transfer\n");
+		set_dma_x_count(drv_data->dma_channel, drv_data->len);
 		if (width == CFG_SPI_WORDSIZE16) {
-			set_dma_x_count(drv_data->dma_channel, drv_data->len);
 			set_dma_x_modify(drv_data->dma_channel, 2);
 			dma_width = WDSIZE_16;
 		} else {
-			set_dma_x_count(drv_data->dma_channel, drv_data->len);
 			set_dma_x_modify(drv_data->dma_channel, 1);
 			dma_width = WDSIZE_8;
 		}
@@ -802,6 +803,7 @@ static void pump_transfers(unsigned long data)
 		}
 
 		/* In dma mode, rx or tx must be NULL in one transfer */
+		dma_config = (RESTART | dma_width | DI_EN);
 		if (drv_data->rx != NULL) {
 			/* set transfer mode, and enable SPI */
 			dev_dbg(&drv_data->pdev->dev, "doing DMA in.\n");
@@ -815,19 +817,9 @@ static void pump_transfers(unsigned long data)
 			/* clear tx reg soformer data is not shifted out */
 			write_TDBR(drv_data, 0xFFFF);
 
-			set_dma_x_count(drv_data->dma_channel, drv_data->len);
-
-			/* start dma */
-			dma_enable_irq(drv_data->dma_channel);
-			dma_config = (WNR | RESTART | dma_width | DI_EN);
-			set_dma_config(drv_data->dma_channel, dma_config);
-			set_dma_start_addr(drv_data->dma_channel,
-					(unsigned long)drv_data->rx);
-			enable_dma(drv_data->dma_channel);
-
-			/* start SPI transfer */
-			write_CTRL(drv_data,
-				(cr | CFG_SPI_DMAREAD | BIT_CTL_ENABLE));
+			dma_config |= WNR;
+			dma_start_addr = (unsigned long)drv_data->rx;
+			cr |= CFG_SPI_DMAREAD;
 
 		} else if (drv_data->tx != NULL) {
 			dev_dbg(&drv_data->pdev->dev, "doing DMA out.\n");
@@ -838,18 +830,21 @@ static void pump_transfers(unsigned long data)
 						(unsigned long) (drv_data->tx +
 						drv_data->len_in_bytes));
 
-			/* start dma */
-			dma_enable_irq(drv_data->dma_channel);
-			dma_config = (RESTART | dma_width | DI_EN);
-			set_dma_config(drv_data->dma_channel, dma_config);
-			set_dma_start_addr(drv_data->dma_channel,
-					(unsigned long)drv_data->tx);
-			enable_dma(drv_data->dma_channel);
+			dma_start_addr = (unsigned long)drv_data->tx;
+			cr |= CFG_SPI_DMAWRITE;
+
+		} else
+			BUG();
+
+		/* start dma */
+		dma_enable_irq(drv_data->dma_channel);
+		set_dma_config(drv_data->dma_channel, dma_config);
+		set_dma_start_addr(drv_data->dma_channel, dma_start_addr);
+		enable_dma(drv_data->dma_channel);
+
+		/* start SPI transfer */
+		write_CTRL(drv_data, (cr | BIT_CTL_ENABLE));
 
-			/* start SPI transfer */
-			write_CTRL(drv_data,
-				(cr | CFG_SPI_DMAWRITE | BIT_CTL_ENABLE));
-		}
 	} else {
 		/* IO mode write then read */
 		dev_dbg(&drv_data->pdev->dev, "doing IO transfer\n");
-- 
1.5.6.3
