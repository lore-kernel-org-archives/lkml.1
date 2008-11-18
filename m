Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbYKRHxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbYKRHxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 02:53:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbYKRHv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 02:51:26 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:46413 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbYKRHvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 02:51:23 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62690395"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 08/16] Blackfin SPI Driver: add a few more debug messages in useful places
Date: Tue, 18 Nov 2008 15:52:32 +0800
Message-Id: <1226994760-4301-9-git-send-email-cooloney@kernel.org>
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
 drivers/spi/spi_bfin5xx.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index a7c8976..e293d19 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -559,9 +559,13 @@ static irqreturn_t dma_irq_handler(int irq, void *dev_id)
 	struct driver_data *drv_data = dev_id;
 	struct chip_data *chip = drv_data->cur_chip;
 	struct spi_message *msg = drv_data->cur_msg;
+	unsigned short dmastat = get_dma_curr_irqstat(drv_data->dma_channel);
 	u16 spistat = read_STAT(drv_data);
 
-	dev_dbg(&drv_data->pdev->dev, "in dma_irq_handler\n");
+	dev_dbg(&drv_data->pdev->dev,
+		"in dma_irq_handler dmastat:0x%x spistat:0x%x\n",
+		dmastat, spistat);
+
 	clear_dma_irqstat(drv_data->dma_channel);
 
 	/* Wait for DMA to complete */
@@ -631,6 +635,7 @@ static void pump_transfers(unsigned long data)
 
 	 /* Handle for abort */
 	if (message->state == ERROR_STATE) {
+		dev_dbg(&drv_data->pdev->dev, "transfer: we've hit an error\n");
 		message->status = -EIO;
 		giveback(drv_data);
 		return;
@@ -638,6 +643,7 @@ static void pump_transfers(unsigned long data)
 
 	/* Handle end of message */
 	if (message->state == DONE_STATE) {
+		dev_dbg(&drv_data->pdev->dev, "transfer: all done!\n");
 		message->status = 0;
 		giveback(drv_data);
 		return;
@@ -645,6 +651,7 @@ static void pump_transfers(unsigned long data)
 
 	/* Delay if requested at end of transfer */
 	if (message->state == RUNNING_STATE) {
+		dev_dbg(&drv_data->pdev->dev, "transfer: still running ...\n");
 		previous = list_entry(transfer->transfer_list.prev,
 				      struct spi_transfer, transfer_list);
 		if (previous->delay_usecs)
@@ -805,7 +812,8 @@ static void pump_transfers(unsigned long data)
 		dma_config = (RESTART | dma_width | DI_EN);
 		if (drv_data->rx != NULL) {
 			/* set transfer mode, and enable SPI */
-			dev_dbg(&drv_data->pdev->dev, "doing DMA in.\n");
+			dev_dbg(&drv_data->pdev->dev, "doing DMA in to %p (size %zx)\n",
+				drv_data->rx, drv_data->len_in_bytes);
 
 			/* invalidate caches, if needed */
 			if (bfin_addr_dcachable((unsigned long) drv_data->rx))
-- 
1.5.6.3
