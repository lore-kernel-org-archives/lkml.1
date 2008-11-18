Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbYKRH4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbYKRH4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 02:56:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbYKRHvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 02:51:33 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:46413 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbYKRHv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 02:51:27 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62690393"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 06/16] Blackfin SPI Driver: unify duplicated code in dma read/write paths
Date: Tue, 18 Nov 2008 15:52:30 +0800
Message-Id: <1226994760-4301-7-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226994760-4301-1-git-send-email-cooloney@kernel.org>
References: <1226994760-4301-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/spi/spi_bfin5xx.c |   47 ++++++++++++++++++++------------------------
 1 files changed, 21 insertions(+), 26 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 642c402..df424a2 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -755,18 +755,19 @@ static void pump_transfers(unsigned long data)
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
@@ -801,6 +802,7 @@ static void pump_transfers(unsigned long data)
 		}
 
 		/* In dma mode, rx or tx must be NULL in one transfer */
+		dma_config = (RESTART | dma_width | DI_EN);
 		if (drv_data->rx != NULL) {
 			/* set transfer mode, and enable SPI */
 			dev_dbg(&drv_data->pdev->dev, "doing DMA in.\n");
@@ -814,19 +816,9 @@ static void pump_transfers(unsigned long data)
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
@@ -837,18 +829,21 @@ static void pump_transfers(unsigned long data)
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
