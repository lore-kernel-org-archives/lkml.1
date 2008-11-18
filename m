Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbYKRHym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbYKRHym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 02:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbYKRHva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 02:51:30 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:43724 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbYKRHv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 02:51:26 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62690401"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 12/16] Blackfin SPI Driver: get dma working for SPI flashes
Date: Tue, 18 Nov 2008 15:52:36 +0800
Message-Id: <1226994760-4301-13-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226994760-4301-1-git-send-email-cooloney@kernel.org>
References: <1226994760-4301-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

When using a BF533-STAMP here with a W25X10 SPI flash. It works fine when
enable_dma is disabled, but doesn't work at all when turning DMA on.
We get just 0xff bytes back when trying to read the device.

If change the code around so that it programs the SPI first and then
enables DMA, it seems to work a lot better ...

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/spi/spi_bfin5xx.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index fba77c2..5cd4873 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -760,11 +760,10 @@ static void pump_transfers(unsigned long data)
 	if (!full_duplex && drv_data->cur_chip->enable_dma
 				&& drv_data->len > 6) {
 
-		unsigned long dma_start_addr;
+		unsigned long dma_start_addr, flags;
 
 		disable_dma(drv_data->dma_channel);
 		clear_dma_irqstat(drv_data->dma_channel);
-		bfin_spi_disable(drv_data);
 
 		/* config dma channel */
 		dev_dbg(&drv_data->pdev->dev, "doing dma transfer\n");
@@ -795,8 +794,7 @@ static void pump_transfers(unsigned long data)
 			enable_dma(drv_data->dma_channel);
 
 			/* start SPI transfer */
-			write_CTRL(drv_data,
-				(cr | BIT_CTL_TIMOD_DMA_TX | BIT_CTL_ENABLE));
+			write_CTRL(drv_data, cr | BIT_CTL_TIMOD_DMA_TX);
 
 			/* just return here, there can only be one transfer
 			 * in this mode
@@ -838,14 +836,22 @@ static void pump_transfers(unsigned long data)
 		} else
 			BUG();
 
-		/* start dma */
-		dma_enable_irq(drv_data->dma_channel);
-		set_dma_config(drv_data->dma_channel, dma_config);
+		/* oh man, here there be monsters ... and i dont mean the
+		 * fluffy cute ones from pixar, i mean the kind that'll eat
+		 * your data, kick your dog, and love it all.  do *not* try
+		 * and change these lines unless you (1) heavily test DMA
+		 * with SPI flashes on a loaded system (e.g. ping floods),
+		 * (2) know just how broken the DMA engine interaction with
+		 * the SPI peripheral is, and (3) have someone else to blame
+		 * when you screw it all up anyways.
+		 */
 		set_dma_start_addr(drv_data->dma_channel, dma_start_addr);
+		set_dma_config(drv_data->dma_channel, dma_config);
+		local_irq_save(flags);
 		enable_dma(drv_data->dma_channel);
-
-		/* start SPI transfer */
-		write_CTRL(drv_data, (cr | BIT_CTL_ENABLE));
+		write_CTRL(drv_data, cr);
+		dma_enable_irq(drv_data->dma_channel);
+		local_irq_restore(flags);
 
 	} else {
 		/* IO mode write then read */
-- 
1.5.6.3
