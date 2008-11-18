Return-Path: <linux-kernel-owner+w=401wt.eu-S1753592AbYKRH4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbYKRH4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 02:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbYKRHvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 02:51:32 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:57358 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbYKRHv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 02:51:27 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62690408"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Yi Li <yi.li@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 16/16] Blackfin SPI Driver: fix bug - correct usage of struct spi_transfer.cs_change
Date: Tue, 18 Nov 2008 15:52:40 +0800
Message-Id: <1226994760-4301-17-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226994760-4301-1-git-send-email-cooloney@kernel.org>
References: <1226994760-4301-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yi Li <yi.li@analog.com>

According to comments in linux/spi/spi.h:

 * All SPI transfers start with the relevant chipselect active.  Normally
 * it stays selected until after the last transfer in a message. Drivers
 * can affect the chipselect signal using cs_change.
 *
 * (i) If the transfer isn't the last one in the message, this flag is
 * used to make the chipselect briefly go inactive in the middle of the
 * message.  Toggling chipselect in this way may be needed to terminate
 * a chip command, letting a single spi_message perform all of group of
 * chip transactions together.
 *
 * (ii) When the transfer is the last one in the message, the chip may
 * stay selected until the next transfer.  On multi-device SPI busses
 * with nothing blocking messages going to other devices, this is just
 * a performance hint; starting a message to another device deselects
 * this one.  But in other cases, this can be used to ensure correctness.
 * Some devices need protocol transactions to be built from a series of
 * spi_message submissions, where the content of one message is determined
 * by the results of previous messages and where the whole transaction
 * ends when the chipselect goes intactive.

Signed-off-by: Yi Li <yi.li@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/spi/spi_bfin5xx.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 8cf5d6e..0e3102a 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -540,15 +540,13 @@ static void giveback(struct driver_data *drv_data)
 
 	msg->state = NULL;
 
-	/* disable chip select signal. And not stop spi in autobuffer mode */
-	if (drv_data->tx_dma != 0xFFFF) {
-		cs_deactive(drv_data, chip);
-		bfin_spi_disable(drv_data);
-	}
-
 	if (!drv_data->cs_change)
 		cs_deactive(drv_data, chip);
 
+	/* Not stop spi in autobuffer mode */
+	if (drv_data->tx_dma != 0xFFFF)
+		bfin_spi_disable(drv_data);
+
 	if (msg->complete)
 		msg->complete(msg->context);
 }
@@ -757,7 +755,8 @@ static void pump_transfers(unsigned long data)
 
 	write_STAT(drv_data, BIT_STAT_CLR);
 	cr = (read_CTRL(drv_data) & (~BIT_CTL_TIMOD));
-	cs_active(drv_data, chip);
+	if (drv_data->cs_change)
+		cs_active(drv_data, chip);
 
 	dev_dbg(&drv_data->pdev->dev,
 		"now pumping a transfer: width is %d, len is %d\n",
@@ -920,6 +919,8 @@ static void pump_transfers(unsigned long data)
 			message->state = next_transfer(drv_data);
 		}
 
+		if (drv_data->cs_change)
+			cs_active(drv_data, chip);
 		/* Schedule next transfer tasklet */
 		tasklet_schedule(&drv_data->pump_transfers);
 
-- 
1.5.6.3
