Return-Path: <linux-kernel-owner+w=401wt.eu-S1758860AbZBFHPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860AbZBFHPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 02:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756355AbZBFHL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 02:11:26 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:1470 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbZBFHLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 02:11:20 -0500
X-IronPort-AV: E=Sophos;i="4.37,390,1231131600"; 
   d="scan'208";a="82422017"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, akpm@linux-foundation.org
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 12/20] Blackfin SPI Driver: get dma working for SPI flashes
Date: Fri,  6 Feb 2009 15:13:00 +0800
Message-Id: <1233904388-5765-13-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1233904388-5765-1-git-send-email-cooloney@kernel.org>
References: <1233904388-5765-1-git-send-email-cooloney@kernel.org>
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
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/spi/spi_bfin5xx.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index bfb587e..83398b3 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -761,11 +761,10 @@ static void pump_transfers(unsigned long data)
 	if (!full_duplex && drv_data->cur_chip->enable_dma
 				&& drv_data->len > 6) {
 
-		unsigned long dma_start_addr;
+		unsigned long dma_start_addr, flags;
 
 		disable_dma(drv_data->dma_channel);
 		clear_dma_irqstat(drv_data->dma_channel);
-		bfin_spi_disable(drv_data);
 
 		/* config dma channel */
 		dev_dbg(&drv_data->pdev->dev, "doing dma transfer\n");
@@ -796,8 +795,7 @@ static void pump_transfers(unsigned long data)
 			enable_dma(drv_data->dma_channel);
 
 			/* start SPI transfer */
-			write_CTRL(drv_data,
-				(cr | BIT_CTL_TIMOD_DMA_TX | BIT_CTL_ENABLE));
+			write_CTRL(drv_data, cr | BIT_CTL_TIMOD_DMA_TX);
 
 			/* just return here, there can only be one transfer
 			 * in this mode
@@ -842,14 +840,22 @@ static void pump_transfers(unsigned long data)
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
