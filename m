Return-Path: <linux-kernel-owner+w=401wt.eu-S1758747AbYDYD7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbYDYD7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 23:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbYDYD7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 23:59:09 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:26323 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbYDYD7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 23:59:08 -0400
X-IronPort-AV: E=Sophos;i="4.25,706,1199682000"; 
   d="scan'208";a="52518509"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Cc: Vitja Makarov <vitja.makarov@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] Blackfin SPI Driver: Fix bug when SPI full-duplex
Date: Fri, 25 Apr 2008 11:58:46 +0800
Message-Id: <1209095926-21279-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitja Makarov <vitja.makarov@gmail.com>

Check if full-duplex and DMA are used together, fall-back to PIO mode.

Signed-off-by: Vitja Makarov <vitja.makarov@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/spi/spi_bfin5xx.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index a9ac1fd..a94f1e9 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -608,6 +608,7 @@ static void pump_transfers(unsigned long data)
 	u8 width;
 	u16 cr, dma_width, dma_config;
 	u32 tranf_success = 1;
+	u8 full_duplex = 0;
 
 	/* Get current state information */
 	message = drv_data->cur_msg;
@@ -658,6 +659,7 @@ static void pump_transfers(unsigned long data)
 	}
 
 	if (transfer->rx_buf != NULL) {
+		full_duplex = transfer->tx_buf != NULL;
 		drv_data->rx = transfer->rx_buf;
 		drv_data->rx_end = drv_data->rx + transfer->len;
 		dev_dbg(&drv_data->pdev->dev, "rx_buf is %p, rx_end is %p\n",
@@ -740,7 +742,7 @@ static void pump_transfers(unsigned long data)
 	 * successful use different way to r/w according to
 	 * drv_data->cur_chip->enable_dma
 	 */
-	if (drv_data->cur_chip->enable_dma && drv_data->len > 6) {
+	if (!full_duplex && drv_data->cur_chip->enable_dma && drv_data->len > 6) {
 
 		disable_dma(drv_data->dma_channel);
 		clear_dma_irqstat(drv_data->dma_channel);
@@ -828,7 +830,7 @@ static void pump_transfers(unsigned long data)
 		/* IO mode write then read */
 		dev_dbg(&drv_data->pdev->dev, "doing IO transfer\n");
 
-		if (drv_data->tx != NULL && drv_data->rx != NULL) {
+		if (full_duplex) {
 			/* full duplex mode */
 			BUG_ON((drv_data->tx_end - drv_data->tx) !=
 			       (drv_data->rx_end - drv_data->rx));
-- 
1.5.5
