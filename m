Return-Path: <linux-kernel-owner+w=401wt.eu-S1759146AbZBFHN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759146AbZBFHN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 02:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755377AbZBFHLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 02:11:24 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:44045 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZBFHLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 02:11:19 -0500
X-IronPort-AV: E=Sophos;i="4.37,390,1231131600"; 
   d="scan'208";a="82422013"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, akpm@linux-foundation.org
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 08/20] Blackfin SPI Driver: add a few more DMA debug messages
Date: Fri,  6 Feb 2009 15:12:56 +0800
Message-Id: <1233904388-5765-9-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1233904388-5765-1-git-send-email-cooloney@kernel.org>
References: <1233904388-5765-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Because of DMA hardware issue, we were trying to use software workaround.
This patch add some useful debug messages to help us debugging the DMA
code.

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/spi/spi_bfin5xx.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 459ec36..7652da8 100644
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
@@ -806,7 +813,8 @@ static void pump_transfers(unsigned long data)
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
