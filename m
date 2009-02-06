Return-Path: <linux-kernel-owner+w=401wt.eu-S1758507AbZBFHMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507AbZBFHMm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 02:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbZBFHLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 02:11:21 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:44045 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbZBFHLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 02:11:18 -0500
X-IronPort-AV: E=Sophos;i="4.37,390,1231131600"; 
   d="scan'208";a="82422010"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, akpm@linux-foundation.org
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 05/20] Blackfin SPI Driver: pass DMA overflow error to the higher level
Date: Fri,  6 Feb 2009 15:12:53 +0800
Message-Id: <1233904388-5765-6-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1233904388-5765-1-git-send-email-cooloney@kernel.org>
References: <1233904388-5765-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

If the SPI bus registers a receive overflow error,
pass the result back up to the higher levels.

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/spi/spi_bfin5xx.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 4a67770..3945b59 100644
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
