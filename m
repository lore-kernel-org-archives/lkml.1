Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbXJLDGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbXJLDGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 23:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756048AbXJLDFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 23:05:15 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:38749 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815AbXJLDFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 23:05:11 -0400
X-IronPort-AV: i="4.21,263,1188792000"; 
   d="scan'208"; a="53831996:sNHT35845817"
From: Bryan Wu <bryan.wu@analog.com>
To: david-b@pacbell.net, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Bryan Wu <bryan.wu@analog.com>,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 03/10] Blackfin SPI driver: add error handing
Date: Fri, 12 Oct 2007 11:04:57 +0800
Message-Id: <1192158304-8277-4-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1192158304-8277-1-git-send-email-bryan.wu@analog.com>
References: <1192158304-8277-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 - add error handling in SPI bus driver with selecting clients
 - use proper defines to access Blackfin MMRs
 - remove useless SSYNCs

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/spi/spi_bfin5xx.c |  107 +++++++++++++++++++--------------------------
 1 files changed, 45 insertions(+), 62 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 8041b89..2f46283 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -59,10 +59,9 @@ MODULE_LICENSE("GPL");
 
 #define DEFINE_SPI_REG(reg, off) \
 static inline u16 read_##reg(void) \
-            { return *(volatile unsigned short*)(SPI0_REGBASE + off); } \
+	{ return bfin_read16(SPI0_REGBASE + off); } \
 static inline void write_##reg(u16 v) \
-            {*(volatile unsigned short*)(SPI0_REGBASE + off) = v;\
-             SSYNC();}
+	{bfin_write16(SPI0_REGBASE + off, v); }
 
 DEFINE_SPI_REG(CTRL, 0x00)
 DEFINE_SPI_REG(FLAG, 0x04)
@@ -145,7 +144,6 @@ static void bfin_spi_enable(struct driver_data *drv_data)
 
 	cr = read_CTRL();
 	write_CTRL(cr | BIT_CTL_ENABLE);
-	SSYNC();
 }
 
 static void bfin_spi_disable(struct driver_data *drv_data)
@@ -154,7 +152,6 @@ static void bfin_spi_disable(struct driver_data *drv_data)
 
 	cr = read_CTRL();
 	write_CTRL(cr & (~BIT_CTL_ENABLE));
-	SSYNC();
 }
 
 /* Caculate the SPI_BAUD register value based on input HZ */
@@ -182,52 +179,44 @@ static int flush(struct driver_data *drv_data)
 	return limit;
 }
 
+#define MAX_SPI0_SSEL	7
+
 /* stop controller and re-config current chip*/
-static void restore_state(struct driver_data *drv_data)
+static int restore_state(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
+	int ret = 0;
+	u16 ssel[MAX_SPI0_SSEL] = {P_SPI0_SSEL1, P_SPI0_SSEL2, P_SPI0_SSEL3,
+					P_SPI0_SSEL4, P_SPI0_SSEL5,
+					P_SPI0_SSEL6, P_SPI0_SSEL7,};
 
 	/* Clear status and disable clock */
 	write_STAT(BIT_STAT_CLR);
 	bfin_spi_disable(drv_data);
 	dev_dbg(&drv_data->pdev->dev, "restoring spi ctl state\n");
 
+	/* Load the registers */
+	write_CTRL(chip->ctl_reg);
+	write_BAUD(chip->baud);
+	write_FLAG(chip->flag);
+
 	if (!chip->chip_select_requested) {
+		int i = chip->chip_select_num;
 
-		dev_dbg(&drv_data->pdev->dev,
-		"chip select number is %d\n", chip->chip_select_num);
-
-		switch (chip->chip_select_num) {
-		case 1:
-			peripheral_request(P_SPI0_SSEL1, DRV_NAME);
-			break;
-		case 2:
-			peripheral_request(P_SPI0_SSEL2, DRV_NAME);
-			break;
-		case 3:
-			peripheral_request(P_SPI0_SSEL3, DRV_NAME);
-			break;
-		case 4:
-			peripheral_request(P_SPI0_SSEL4, DRV_NAME);
-			break;
-		case 5:
-			peripheral_request(P_SPI0_SSEL5, DRV_NAME);
-			break;
-		case 6:
-			peripheral_request(P_SPI0_SSEL6, DRV_NAME);
-			break;
-		case 7:
-			peripheral_request(P_SPI0_SSEL7, DRV_NAME);
-			break;
-		}
+		dev_dbg(&drv_data->pdev->dev, "chip select number is %d\n", i);
+
+		if ((i > 0) && (i <= MAX_SPI0_SSEL))
+			ret = peripheral_request(ssel[i-1], DRV_NAME);
 
 		chip->chip_select_requested = 1;
 	}
 
-	/* Load the registers */
-	write_CTRL(chip->ctl_reg);
-	write_BAUD(chip->baud);
-	write_FLAG(chip->flag);
+	if (ret)
+		dev_dbg(&drv_data->pdev->dev,
+			": request chip select number %d failed\n",
+			chip->chip_select_num);
+
+	return ret;
 }
 
 /* used to kick off transfer in rx mode */
@@ -285,7 +274,6 @@ static void u8_cs_chg_writer(struct driver_data *drv_data)
 
 	while (drv_data->tx < drv_data->tx_end) {
 		write_FLAG(chip->flag);
-		SSYNC();
 
 		write_TDBR(*(u8 *) (drv_data->tx));
 		while (read_STAT() & BIT_STAT_TXS)
@@ -293,13 +281,13 @@ static void u8_cs_chg_writer(struct driver_data *drv_data)
 		while (!(read_STAT() & BIT_STAT_SPIF))
 			continue;
 		write_FLAG(0xFF00 | chip->flag);
-		SSYNC();
+
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		++drv_data->tx;
 	}
 	write_FLAG(0xFF00);
-	SSYNC();
+
 }
 
 static void u8_reader(struct driver_data *drv_data)
@@ -331,7 +319,6 @@ static void u8_cs_chg_reader(struct driver_data *drv_data)
 
 	while (drv_data->rx < drv_data->rx_end) {
 		write_FLAG(chip->flag);
-		SSYNC();
 
 		read_RDBR();	/* kick off */
 		while (!(read_STAT() & BIT_STAT_RXS))
@@ -340,13 +327,13 @@ static void u8_cs_chg_reader(struct driver_data *drv_data)
 			continue;
 		*(u8 *) (drv_data->rx) = read_SHAW();
 		write_FLAG(0xFF00 | chip->flag);
-		SSYNC();
+
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		++drv_data->rx;
 	}
 	write_FLAG(0xFF00);
-	SSYNC();
+
 }
 
 static void u8_duplex(struct driver_data *drv_data)
@@ -370,7 +357,7 @@ static void u8_cs_chg_duplex(struct driver_data *drv_data)
 
 	while (drv_data->rx < drv_data->rx_end) {
 		write_FLAG(chip->flag);
-		SSYNC();
+
 
 		write_TDBR(*(u8 *) (drv_data->tx));
 		while (!(read_STAT() & BIT_STAT_SPIF))
@@ -379,14 +366,14 @@ static void u8_cs_chg_duplex(struct driver_data *drv_data)
 			continue;
 		*(u8 *) (drv_data->rx) = read_RDBR();
 		write_FLAG(0xFF00 | chip->flag);
-		SSYNC();
+
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		++drv_data->rx;
 		++drv_data->tx;
 	}
 	write_FLAG(0xFF00);
-	SSYNC();
+
 }
 
 static void u16_writer(struct driver_data *drv_data)
@@ -412,7 +399,6 @@ static void u16_cs_chg_writer(struct driver_data *drv_data)
 
 	while (drv_data->tx < drv_data->tx_end) {
 		write_FLAG(chip->flag);
-		SSYNC();
 
 		write_TDBR(*(u16 *) (drv_data->tx));
 		while ((read_STAT() & BIT_STAT_TXS))
@@ -420,13 +406,12 @@ static void u16_cs_chg_writer(struct driver_data *drv_data)
 		while (!(read_STAT() & BIT_STAT_SPIF))
 			continue;
 		write_FLAG(0xFF00 | chip->flag);
-		SSYNC();
+
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		drv_data->tx += 2;
 	}
 	write_FLAG(0xFF00);
-	SSYNC();
 }
 
 static void u16_reader(struct driver_data *drv_data)
@@ -454,7 +439,6 @@ static void u16_cs_chg_reader(struct driver_data *drv_data)
 
 	while (drv_data->rx < drv_data->rx_end) {
 		write_FLAG(chip->flag);
-		SSYNC();
 
 		read_RDBR();	/* kick off */
 		while (!(read_STAT() & BIT_STAT_RXS))
@@ -463,13 +447,12 @@ static void u16_cs_chg_reader(struct driver_data *drv_data)
 			continue;
 		*(u16 *) (drv_data->rx) = read_SHAW();
 		write_FLAG(0xFF00 | chip->flag);
-		SSYNC();
+
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		drv_data->rx += 2;
 	}
 	write_FLAG(0xFF00);
-	SSYNC();
 }
 
 static void u16_duplex(struct driver_data *drv_data)
@@ -493,7 +476,6 @@ static void u16_cs_chg_duplex(struct driver_data *drv_data)
 
 	while (drv_data->tx < drv_data->tx_end) {
 		write_FLAG(chip->flag);
-		SSYNC();
 
 		write_TDBR(*(u16 *) (drv_data->tx));
 		while (!(read_STAT() & BIT_STAT_SPIF))
@@ -502,14 +484,13 @@ static void u16_cs_chg_duplex(struct driver_data *drv_data)
 			continue;
 		*(u16 *) (drv_data->rx) = read_RDBR();
 		write_FLAG(0xFF00 | chip->flag);
-		SSYNC();
+
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		drv_data->rx += 2;
 		drv_data->tx += 2;
 	}
 	write_FLAG(0xFF00);
-	SSYNC();
 }
 
 /* test if ther is more transfer to be done */
@@ -811,7 +792,6 @@ static void pump_transfers(unsigned long data)
 				"IO duplex: cr is 0x%x\n", cr);
 
 			write_CTRL(cr);
-			SSYNC();
 
 			drv_data->duplex(drv_data);
 
@@ -826,7 +806,6 @@ static void pump_transfers(unsigned long data)
 				"IO write: cr is 0x%x\n", cr);
 
 			write_CTRL(cr);
-			SSYNC();
 
 			drv_data->write(drv_data);
 
@@ -841,7 +820,6 @@ static void pump_transfers(unsigned long data)
 				"IO read: cr is 0x%x\n", cr);
 
 			write_CTRL(cr);
-			SSYNC();
 
 			drv_data->read(drv_data);
 			if (drv_data->rx != drv_data->rx_end)
@@ -890,6 +868,14 @@ static void pump_messages(struct work_struct *work)
 	/* Extract head of queue */
 	drv_data->cur_msg = list_entry(drv_data->queue.next,
 				       struct spi_message, queue);
+
+	/* Setup the SSP using the per chip configuration */
+	drv_data->cur_chip = spi_get_ctldata(drv_data->cur_msg->spi);
+	if (restore_state(drv_data)) {
+		spin_unlock_irqrestore(&drv_data->lock, flags);
+		return;
+	};
+
 	list_del_init(&drv_data->cur_msg->queue);
 
 	/* Initial message state */
@@ -897,13 +883,10 @@ static void pump_messages(struct work_struct *work)
 	drv_data->cur_transfer = list_entry(drv_data->cur_msg->transfers.next,
 					    struct spi_transfer, transfer_list);
 
-	/* Setup the SSP using the per chip configuration */
-	drv_data->cur_chip = spi_get_ctldata(drv_data->cur_msg->spi);
-	restore_state(drv_data);
 	dev_dbg(&drv_data->pdev->dev,
 		"got a message to pump, state is set to: baud %d, flag 0x%x, ctl 0x%x\n",
-   		drv_data->cur_chip->baud, drv_data->cur_chip->flag,
-   		drv_data->cur_chip->ctl_reg);
+		drv_data->cur_chip->baud, drv_data->cur_chip->flag,
+		drv_data->cur_chip->ctl_reg);
 
 	dev_dbg(&drv_data->pdev->dev,
 		"the first transfer len is %d\n",
-- 
1.5.3.4
