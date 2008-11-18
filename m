Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbYKRHx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbYKRHx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 02:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbYKRHv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 02:51:28 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:57358 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbYKRHvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 02:51:25 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62690402"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 13/16] Blackfin SPI Driver: add timeout while waiting for SPIF in dma irq handler
Date: Tue, 18 Nov 2008 15:52:37 +0800
Message-Id: <1226994760-4301-14-git-send-email-cooloney@kernel.org>
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
 drivers/spi/spi_bfin5xx.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 5cd4873..c2fc3a9 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -557,6 +557,7 @@ static irqreturn_t dma_irq_handler(int irq, void *dev_id)
 	struct driver_data *drv_data = dev_id;
 	struct chip_data *chip = drv_data->cur_chip;
 	struct spi_message *msg = drv_data->cur_msg;
+	unsigned long timeout;
 	unsigned short dmastat = get_dma_curr_irqstat(drv_data->dma_channel);
 	u16 spistat = read_STAT(drv_data);
 
@@ -582,8 +583,17 @@ static irqreturn_t dma_irq_handler(int irq, void *dev_id)
 			cpu_relax();
 	}
 
+	dev_dbg(&drv_data->pdev->dev,
+		"in dma_irq_handler dmastat:0x%x spistat:0x%x\n",
+		dmastat, read_STAT(drv_data));
+
+	timeout = jiffies + HZ;
 	while (!(read_STAT(drv_data) & SPIF))
-		cpu_relax();
+		if (!time_before(jiffies, timeout)) {
+			dev_warn(&drv_data->pdev->dev, "timeout waiting for SPIF");
+			break;
+		} else
+			cpu_relax();
 
 	if ((dmastat & DMA_ERR) && (spistat & RBSY)) {
 		msg->state = ERROR_STATE;
-- 
1.5.6.3
