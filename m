Return-Path: <linux-kernel-owner+w=401wt.eu-S1758083AbXJKKLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbXJKKLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 06:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755425AbXJKKKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 06:10:52 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:23115 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbXJKKKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 06:10:49 -0400
X-IronPort-AV: i="4.21,259,1188792000"; 
   d="scan'208"; a="53762406:sNHT35703269"
From: Bryan Wu <bryan.wu@analog.com>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 3/9] Blackfin SPI driver: Blackfin SPI driver does not respect the per-transfer cs_change field
Date: Thu, 11 Oct 2007 18:10:35 +0800
Message-Id: <1192097441-24962-4-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1192097441-24962-1-git-send-email-bryan.wu@analog.com>
References: <1192097441-24962-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add cs_active/cs_deactive functions and try to catch the cs_change flag.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/spi/spi_bfin5xx.c |   76 ++++++++++++++++++++++++++++++++-------------
 1 files changed, 54 insertions(+), 22 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 2f46283..7093065 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -115,6 +115,7 @@ struct driver_data {
 	size_t rx_map_len;
 	size_t tx_map_len;
 	u8 n_bytes;
+	int cs_change;
 	void (*write) (struct driver_data *);
 	void (*read) (struct driver_data *);
 	void (*duplex) (struct driver_data *);
@@ -179,6 +180,26 @@ static int flush(struct driver_data *drv_data)
 	return limit;
 }
 
+/* Chip select operation functions for cs_change flag */
+static void cs_active(struct chip_data *chip)
+{
+	u16 flag = read_FLAG();
+
+	flag |= chip->flag;
+	flag &= ~(chip->flag << 8);
+
+	write_FLAG(flag);
+}
+
+static void cs_deactive(struct chip_data *chip)
+{
+	u16 flag = read_FLAG();
+
+	flag |= (chip->flag << 8);
+
+	write_FLAG(flag);
+}
+
 #define MAX_SPI0_SSEL	7
 
 /* stop controller and re-config current chip*/
@@ -198,7 +219,7 @@ static int restore_state(struct driver_data *drv_data)
 	/* Load the registers */
 	write_CTRL(chip->ctl_reg);
 	write_BAUD(chip->baud);
-	write_FLAG(chip->flag);
+	cs_active(chip);
 
 	if (!chip->chip_select_requested) {
 		int i = chip->chip_select_num;
@@ -273,20 +294,20 @@ static void u8_cs_chg_writer(struct driver_data *drv_data)
 	struct chip_data *chip = drv_data->cur_chip;
 
 	while (drv_data->tx < drv_data->tx_end) {
-		write_FLAG(chip->flag);
+		cs_active(chip);
 
 		write_TDBR(*(u8 *) (drv_data->tx));
 		while (read_STAT() & BIT_STAT_TXS)
 			continue;
 		while (!(read_STAT() & BIT_STAT_SPIF))
 			continue;
-		write_FLAG(0xFF00 | chip->flag);
+		cs_deactive(chip);
 
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		++drv_data->tx;
 	}
-	write_FLAG(0xFF00);
+	cs_deactive(chip);
 
 }
 
@@ -318,7 +339,7 @@ static void u8_cs_chg_reader(struct driver_data *drv_data)
 	struct chip_data *chip = drv_data->cur_chip;
 
 	while (drv_data->rx < drv_data->rx_end) {
-		write_FLAG(chip->flag);
+		cs_active(chip);
 
 		read_RDBR();	/* kick off */
 		while (!(read_STAT() & BIT_STAT_RXS))
@@ -326,13 +347,13 @@ static void u8_cs_chg_reader(struct driver_data *drv_data)
 		while (!(read_STAT() & BIT_STAT_SPIF))
 			continue;
 		*(u8 *) (drv_data->rx) = read_SHAW();
-		write_FLAG(0xFF00 | chip->flag);
+		cs_deactive(chip);
 
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		++drv_data->rx;
 	}
-	write_FLAG(0xFF00);
+	cs_deactive(chip);
 
 }
 
@@ -356,7 +377,7 @@ static void u8_cs_chg_duplex(struct driver_data *drv_data)
 	struct chip_data *chip = drv_data->cur_chip;
 
 	while (drv_data->rx < drv_data->rx_end) {
-		write_FLAG(chip->flag);
+		cs_active(chip);
 
 
 		write_TDBR(*(u8 *) (drv_data->tx));
@@ -365,15 +386,14 @@ static void u8_cs_chg_duplex(struct driver_data *drv_data)
 		while (!(read_STAT() & BIT_STAT_RXS))
 			continue;
 		*(u8 *) (drv_data->rx) = read_RDBR();
-		write_FLAG(0xFF00 | chip->flag);
+		cs_deactive(chip);
 
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		++drv_data->rx;
 		++drv_data->tx;
 	}
-	write_FLAG(0xFF00);
-
+	cs_deactive(chip);
 }
 
 static void u16_writer(struct driver_data *drv_data)
@@ -398,20 +418,20 @@ static void u16_cs_chg_writer(struct driver_data *drv_data)
 	struct chip_data *chip = drv_data->cur_chip;
 
 	while (drv_data->tx < drv_data->tx_end) {
-		write_FLAG(chip->flag);
+		cs_active(chip);
 
 		write_TDBR(*(u16 *) (drv_data->tx));
 		while ((read_STAT() & BIT_STAT_TXS))
 			continue;
 		while (!(read_STAT() & BIT_STAT_SPIF))
 			continue;
-		write_FLAG(0xFF00 | chip->flag);
+		cs_deactive(chip);
 
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		drv_data->tx += 2;
 	}
-	write_FLAG(0xFF00);
+	cs_deactive(chip);
 }
 
 static void u16_reader(struct driver_data *drv_data)
@@ -438,7 +458,7 @@ static void u16_cs_chg_reader(struct driver_data *drv_data)
 	struct chip_data *chip = drv_data->cur_chip;
 
 	while (drv_data->rx < drv_data->rx_end) {
-		write_FLAG(chip->flag);
+		cs_active(chip);
 
 		read_RDBR();	/* kick off */
 		while (!(read_STAT() & BIT_STAT_RXS))
@@ -446,13 +466,13 @@ static void u16_cs_chg_reader(struct driver_data *drv_data)
 		while (!(read_STAT() & BIT_STAT_SPIF))
 			continue;
 		*(u16 *) (drv_data->rx) = read_SHAW();
-		write_FLAG(0xFF00 | chip->flag);
+		cs_deactive(chip);
 
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		drv_data->rx += 2;
 	}
-	write_FLAG(0xFF00);
+	cs_deactive(chip);
 }
 
 static void u16_duplex(struct driver_data *drv_data)
@@ -475,7 +495,7 @@ static void u16_cs_chg_duplex(struct driver_data *drv_data)
 	struct chip_data *chip = drv_data->cur_chip;
 
 	while (drv_data->tx < drv_data->tx_end) {
-		write_FLAG(chip->flag);
+		cs_active(chip);
 
 		write_TDBR(*(u16 *) (drv_data->tx));
 		while (!(read_STAT() & BIT_STAT_SPIF))
@@ -483,14 +503,14 @@ static void u16_cs_chg_duplex(struct driver_data *drv_data)
 		while (!(read_STAT() & BIT_STAT_RXS))
 			continue;
 		*(u16 *) (drv_data->rx) = read_RDBR();
-		write_FLAG(0xFF00 | chip->flag);
+		cs_deactive(chip);
 
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		drv_data->rx += 2;
 		drv_data->tx += 2;
 	}
-	write_FLAG(0xFF00);
+	cs_deactive(chip);
 }
 
 /* test if ther is more transfer to be done */
@@ -515,6 +535,7 @@ static void *next_transfer(struct driver_data *drv_data)
  */
 static void giveback(struct driver_data *drv_data)
 {
+	struct chip_data *chip = drv_data->cur_chip;
 	struct spi_transfer *last_transfer;
 	unsigned long flags;
 	struct spi_message *msg;
@@ -534,10 +555,13 @@ static void giveback(struct driver_data *drv_data)
 
 	/* disable chip select signal. And not stop spi in autobuffer mode */
 	if (drv_data->tx_dma != 0xFFFF) {
-		write_FLAG(0xFF00);
+		cs_deactive(chip);
 		bfin_spi_disable(drv_data);
 	}
 
+	if (!drv_data->cs_change)
+		cs_deactive(chip);
+
 	if (msg->complete)
 		msg->complete(msg->context);
 }
@@ -546,6 +570,7 @@ static irqreturn_t dma_irq_handler(int irq, void *dev_id)
 {
 	struct driver_data *drv_data = (struct driver_data *)dev_id;
 	struct spi_message *msg = drv_data->cur_msg;
+	struct chip_data *chip = drv_data->cur_chip;
 
 	dev_dbg(&drv_data->pdev->dev, "in dma_irq_handler\n");
 	clear_dma_irqstat(CH_SPI);
@@ -573,6 +598,9 @@ static irqreturn_t dma_irq_handler(int irq, void *dev_id)
 
 	msg->actual_length += drv_data->len_in_bytes;
 
+	if (drv_data->cs_change)
+		cs_deactive(chip);
+
 	/* Move to next transfer */
 	msg->state = next_transfer(drv_data);
 
@@ -659,6 +687,7 @@ static void pump_transfers(unsigned long data)
 	drv_data->rx_dma = transfer->rx_dma;
 	drv_data->tx_dma = transfer->tx_dma;
 	drv_data->len_in_bytes = transfer->len;
+	drv_data->cs_change = transfer->cs_change;
 
 	width = chip->width;
 	if (width == CFG_SPI_WORDSIZE16) {
@@ -683,7 +712,7 @@ static void pump_transfers(unsigned long data)
 	} else {
 		write_BAUD(chip->baud);
 	}
-	write_FLAG(chip->flag);
+	cs_active(chip);
 
 	dev_dbg(&drv_data->pdev->dev,
 		"now pumping a transfer: width is %d, len is %d\n",
@@ -834,6 +863,9 @@ static void pump_transfers(unsigned long data)
 			/* Update total byte transfered */
 			message->actual_length += drv_data->len;
 
+			if (drv_data->cs_change)
+				cs_deactive(chip);
+
 			/* Move to next transfer of this msg */
 			message->state = next_transfer(drv_data);
 		}
-- 
1.5.3.4
