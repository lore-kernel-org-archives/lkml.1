Return-Path: <linux-kernel-owner+w=401wt.eu-S1751341AbYKRHwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341AbYKRHwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 02:52:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbYKRHvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 02:51:24 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:43724 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbYKRHvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 02:51:22 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62690392"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 05/16] Blackfin SPI Driver: pass DMA overflow error to the higher level
Date: Tue, 18 Nov 2008 15:52:29 +0800
Message-Id: <1226994760-4301-6-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226994760-4301-1-git-send-email-cooloney@kernel.org>
References: <1226994760-4301-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

If the SPI bus registers a receive overflow error,
pass the result back up to the higher levels.

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/spi/spi_bfin5xx.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index cc415e8..642c402 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -559,6 +559,7 @@ static irqreturn_t dma_irq_handler(int irq, void *dev_id)
 	struct driver_data *drv_data = dev_id;
 	struct chip_data *chip = drv_data->cur_chip;
 	struct spi_message *msg = drv_data->cur_msg;
+	u16 spistat = read_STAT(drv_data);
 
 	dev_dbg(&drv_data->pdev->dev, "in dma_irq_handler\n");
 	clear_dma_irqstat(drv_data->dma_channel);
@@ -582,13 +583,18 @@ static irqreturn_t dma_irq_handler(int irq, void *dev_id)
 	while (!(read_STAT(drv_data) & SPIF))
 		cpu_relax();
 
-	msg->actual_length += drv_data->len_in_bytes;
+	if (spistat & RBSY) {
+		msg->state = ERROR_STATE;
+		dev_err(&drv_data->pdev->dev, "dma receive: fifo/buffer overflow\n");
+	} else {
+		msg->actual_length += drv_data->len_in_bytes;
 
-	if (drv_data->cs_change)
-		cs_deactive(drv_data, chip);
+		if (drv_data->cs_change)
+			cs_deactive(drv_data, chip);
 
-	/* Move to next transfer */
-	msg->state = next_transfer(drv_data);
+		/* Move to next transfer */
+		msg->state = next_transfer(drv_data);
+	}
 
 	/* Schedule transfer tasklet */
 	tasklet_schedule(&drv_data->pump_transfers);
-- 
1.5.6.3
