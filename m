Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbXJ3JVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbXJ3JVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755838AbXJ3JSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:18:23 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:19156 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbXJ3JSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:18:15 -0400
X-IronPort-AV: i="4.21,346,1188792000"; 
   d="scan'208"; a="55175269:sNHT54614329"
From: Bryan Wu <bryan.wu@analog.com>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 09/14] Blackfin SPI driver: Fix SPI driver to work with SPI flash ST25P16 on bf548
Date: Tue, 30 Oct 2007 17:18:00 +0800
Message-Id: <1193735885-8202-10-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1193735885-8202-1-git-send-email-bryan.wu@analog.com>
References: <1193735885-8202-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Current SPI driver enables SPI controller and set the SPI baud register
for each SPI transfer. But, they should never be changed within a SPI
message session, in which seveal SPI transfers are pumped. This patch
move move SPI setting to the begining of a message session. And never
disables SPI controller until an error occurs.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/spi/spi_bfin5xx.c |  162 ++++++++++++++++++++++++---------------------
 1 files changed, 87 insertions(+), 75 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 7f95797..e1fd197 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -222,9 +222,13 @@ static int restore_state(struct driver_data *drv_data)
 	dev_dbg(&drv_data->pdev->dev, "restoring spi ctl state\n");
 
 	/* Load the registers */
-	write_CTRL(chip->ctl_reg);
+	cs_deactive(chip);
 	write_BAUD(chip->baud);
-	cs_active(chip);
+	chip->ctl_reg &= (~BIT_CTL_TIMOD);
+	chip->ctl_reg |= (chip->width << 8);
+	write_CTRL(chip->ctl_reg);
+
+	bfin_spi_enable(drv_data);
 
 	if (ret)
 		dev_dbg(&drv_data->pdev->dev,
@@ -271,6 +275,7 @@ static void u8_writer(struct driver_data *drv_data)
 {
 	dev_dbg(&drv_data->pdev->dev,
 		"cr8-s is 0x%x\n", read_STAT());
+
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(*(u8 *) (drv_data->tx));
 		while (read_STAT() & BIT_STAT_TXS)
@@ -293,16 +298,16 @@ static void u8_cs_chg_writer(struct driver_data *drv_data)
 		write_TDBR(*(u8 *) (drv_data->tx));
 		while (read_STAT() & BIT_STAT_TXS)
 			continue;
-		while (!(read_STAT() & BIT_STAT_SPIF))
-			continue;
 		cs_deactive(chip);
 
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		++drv_data->tx;
 	}
-	cs_deactive(chip);
 
+	/* poll for SPI completion before returning */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
 }
 
 static void u8_reader(struct driver_data *drv_data)
@@ -314,6 +319,7 @@ static void u8_reader(struct driver_data *drv_data)
 	write_TDBR(0xFFFF);
 
 	dummy_read();
+
 	while (drv_data->rx < drv_data->rx_end - 1) {
 		while (!(read_STAT() & BIT_STAT_RXS))
 			continue;
@@ -331,23 +337,30 @@ static void u8_cs_chg_reader(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
-	while (drv_data->rx < drv_data->rx_end) {
-		cs_active(chip);
+	/* clear TDBR buffer before read(else it will be shifted out) */
+	write_TDBR(0xFFFF);
 
-		read_RDBR();	/* kick off */
-		while (!(read_STAT() & BIT_STAT_RXS))
-			continue;
-		while (!(read_STAT() & BIT_STAT_SPIF))
-			continue;
-		*(u8 *) (drv_data->rx) = read_SHAW();
+	cs_active(chip);
+	dummy_read();
+
+	while (drv_data->rx < drv_data->rx_end - 1) {
 		cs_deactive(chip);
 
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
+
+		while (!(read_STAT() & BIT_STAT_RXS))
+			continue;
+		cs_active(chip);
+		*(u8 *) (drv_data->rx) = read_RDBR();
 		++drv_data->rx;
 	}
 	cs_deactive(chip);
 
+	while (!(read_STAT() & BIT_STAT_RXS))
+		continue;
+	*(u8 *) (drv_data->rx) = read_SHAW();
+	++drv_data->rx;
 }
 
 static void u8_duplex(struct driver_data *drv_data)
@@ -355,7 +368,7 @@ static void u8_duplex(struct driver_data *drv_data)
 	/* in duplex mode, clk is triggered by writing of TDBR */
 	while (drv_data->rx < drv_data->rx_end) {
 		write_TDBR(*(u8 *) (drv_data->tx));
-		while (!(read_STAT() & BIT_STAT_SPIF))
+		while (read_STAT() & BIT_STAT_TXS)
 			continue;
 		while (!(read_STAT() & BIT_STAT_RXS))
 			continue;
@@ -363,6 +376,10 @@ static void u8_duplex(struct driver_data *drv_data)
 		++drv_data->rx;
 		++drv_data->tx;
 	}
+
+	/* poll for SPI completion before returning */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
 }
 
 static void u8_cs_chg_duplex(struct driver_data *drv_data)
@@ -372,9 +389,8 @@ static void u8_cs_chg_duplex(struct driver_data *drv_data)
 	while (drv_data->rx < drv_data->rx_end) {
 		cs_active(chip);
 
-
 		write_TDBR(*(u8 *) (drv_data->tx));
-		while (!(read_STAT() & BIT_STAT_SPIF))
+		while (read_STAT() & BIT_STAT_TXS)
 			continue;
 		while (!(read_STAT() & BIT_STAT_RXS))
 			continue;
@@ -386,7 +402,10 @@ static void u8_cs_chg_duplex(struct driver_data *drv_data)
 		++drv_data->rx;
 		++drv_data->tx;
 	}
-	cs_deactive(chip);
+
+	/* poll for SPI completion before returning */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
 }
 
 static void u16_writer(struct driver_data *drv_data)
@@ -416,21 +435,26 @@ static void u16_cs_chg_writer(struct driver_data *drv_data)
 		write_TDBR(*(u16 *) (drv_data->tx));
 		while ((read_STAT() & BIT_STAT_TXS))
 			continue;
-		while (!(read_STAT() & BIT_STAT_SPIF))
-			continue;
 		cs_deactive(chip);
 
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		drv_data->tx += 2;
 	}
-	cs_deactive(chip);
+
+	/* poll for SPI completion before returning */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
 }
 
 static void u16_reader(struct driver_data *drv_data)
 {
 	dev_dbg(&drv_data->pdev->dev,
 		"cr-16 is 0x%x\n", read_STAT());
+
+	/* clear TDBR buffer before read(else it will be shifted out) */
+	write_TDBR(0xFFFF);
+
 	dummy_read();
 
 	while (drv_data->rx < (drv_data->rx_end - 2)) {
@@ -450,22 +474,30 @@ static void u16_cs_chg_reader(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
-	while (drv_data->rx < drv_data->rx_end) {
-		cs_active(chip);
+	/* clear TDBR buffer before read(else it will be shifted out) */
+	write_TDBR(0xFFFF);
 
-		read_RDBR();	/* kick off */
-		while (!(read_STAT() & BIT_STAT_RXS))
-			continue;
-		while (!(read_STAT() & BIT_STAT_SPIF))
-			continue;
-		*(u16 *) (drv_data->rx) = read_SHAW();
+	cs_active(chip);
+	dummy_read();
+
+	while (drv_data->rx < drv_data->rx_end) {
 		cs_deactive(chip);
 
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
+
+		while (!(read_STAT() & BIT_STAT_RXS))
+			continue;
+		cs_active(chip);
+		*(u16 *) (drv_data->rx) = read_RDBR();
 		drv_data->rx += 2;
 	}
 	cs_deactive(chip);
+
+	while (!(read_STAT() & BIT_STAT_RXS))
+		continue;
+	*(u16 *) (drv_data->rx) = read_SHAW();
+	drv_data->rx += 2;
 }
 
 static void u16_duplex(struct driver_data *drv_data)
@@ -473,7 +505,7 @@ static void u16_duplex(struct driver_data *drv_data)
 	/* in duplex mode, clk is triggered by writing of TDBR */
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(*(u16 *) (drv_data->tx));
-		while (!(read_STAT() & BIT_STAT_SPIF))
+		while (read_STAT() & BIT_STAT_TXS)
 			continue;
 		while (!(read_STAT() & BIT_STAT_RXS))
 			continue;
@@ -481,6 +513,10 @@ static void u16_duplex(struct driver_data *drv_data)
 		drv_data->rx += 2;
 		drv_data->tx += 2;
 	}
+
+	/* poll for SPI completion before returning */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
 }
 
 static void u16_cs_chg_duplex(struct driver_data *drv_data)
@@ -491,7 +527,7 @@ static void u16_cs_chg_duplex(struct driver_data *drv_data)
 		cs_active(chip);
 
 		write_TDBR(*(u16 *) (drv_data->tx));
-		while (!(read_STAT() & BIT_STAT_SPIF))
+		while (read_STAT() & BIT_STAT_TXS)
 			continue;
 		while (!(read_STAT() & BIT_STAT_RXS))
 			continue;
@@ -503,7 +539,10 @@ static void u16_cs_chg_duplex(struct driver_data *drv_data)
 		drv_data->rx += 2;
 		drv_data->tx += 2;
 	}
-	cs_deactive(chip);
+
+	/* poll for SPI completion before returning */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
 }
 
 /* test if ther is more transfer to be done */
@@ -587,8 +626,6 @@ static irqreturn_t dma_irq_handler(int irq, void *dev_id)
 	while (!(read_STAT() & SPIF))
 		continue;
 
-	bfin_spi_disable(drv_data);
-
 	msg->actual_length += drv_data->len_in_bytes;
 
 	if (drv_data->cs_change)
@@ -698,12 +735,8 @@ static void pump_transfers(unsigned long data)
 	message->state = RUNNING_STATE;
 	dma_config = 0;
 
-	/* restore spi status for each spi transfer */
-	if (transfer->speed_hz) {
-		write_BAUD(hz_to_spi_baud(transfer->speed_hz));
-	} else {
-		write_BAUD(chip->baud);
-	}
+	write_STAT(BIT_STAT_CLR);
+	cr = (read_CTRL() & (~BIT_CTL_TIMOD));
 	cs_active(chip);
 
 	dev_dbg(&drv_data->pdev->dev,
@@ -717,10 +750,8 @@ static void pump_transfers(unsigned long data)
 	 */
 	if (drv_data->cur_chip->enable_dma && drv_data->len > 6) {
 
-		write_STAT(BIT_STAT_CLR);
 		disable_dma(spi_dma_ch);
 		clear_dma_irqstat(spi_dma_ch);
-		bfin_spi_disable(drv_data);
 
 		/* config dma channel */
 		dev_dbg(&drv_data->pdev->dev, "doing dma transfer\n");
@@ -734,14 +765,14 @@ static void pump_transfers(unsigned long data)
 			dma_width = WDSIZE_8;
 		}
 
-		/* set transfer width,direction. And enable spi */
-		cr = (read_CTRL() & (~BIT_CTL_TIMOD));
-
 		/* dirty hack for autobuffer DMA mode */
 		if (drv_data->tx_dma == 0xFFFF) {
 			dev_dbg(&drv_data->pdev->dev,
 				"doing autobuffer DMA out.\n");
 
+			/* set SPI transfer mode */
+			write_CTRL(cr | CFG_SPI_DMAWRITE);
+
 			/* no irq in autobuffer mode */
 			dma_config =
 			    (DMAFLOW_AUTO | RESTART | dma_width | DI_EN);
@@ -749,8 +780,6 @@ static void pump_transfers(unsigned long data)
 			set_dma_start_addr(spi_dma_ch,
 					(unsigned long)drv_data->tx);
 			enable_dma(spi_dma_ch);
-			write_CTRL(cr | CFG_SPI_DMAWRITE | (width << 8) |
-				   (CFG_SPI_ENABLE << 14));
 
 			/* just return here, there can only be one transfer in this mode */
 			message->status = 0;
@@ -763,11 +792,11 @@ static void pump_transfers(unsigned long data)
 			/* set transfer mode, and enable SPI */
 			dev_dbg(&drv_data->pdev->dev, "doing DMA in.\n");
 
-			/* disable SPI before write to TDBR */
-			write_CTRL(cr & ~BIT_CTL_ENABLE);
+			/* set SPI transfer mode */
+			write_CTRL(cr | CFG_SPI_DMAREAD);
 
 			/* clear tx reg soformer data is not shifted out */
-			write_TDBR(0xFF);
+			write_TDBR(0xFFFF);
 
 			set_dma_x_count(spi_dma_ch, drv_data->len);
 
@@ -779,14 +808,12 @@ static void pump_transfers(unsigned long data)
 					(unsigned long)drv_data->rx);
 			enable_dma(spi_dma_ch);
 
-			cr |=
-			    CFG_SPI_DMAREAD | (width << 8) | (CFG_SPI_ENABLE <<
-							      14);
-			/* set transfer mode, and enable SPI */
-			write_CTRL(cr);
 		} else if (drv_data->tx != NULL) {
 			dev_dbg(&drv_data->pdev->dev, "doing DMA out.\n");
 
+			/* set SPI transfer mode */
+			write_CTRL(cr | CFG_SPI_DMAWRITE);
+
 			/* start dma */
 			dma_enable_irq(spi_dma_ch);
 			dma_config = (RESTART | dma_width | DI_EN);
@@ -794,28 +821,20 @@ static void pump_transfers(unsigned long data)
 			set_dma_start_addr(spi_dma_ch,
 					(unsigned long)drv_data->tx);
 			enable_dma(spi_dma_ch);
-
-			write_CTRL(cr | CFG_SPI_DMAWRITE | (width << 8) |
-				   (CFG_SPI_ENABLE << 14));
-
 		}
 	} else {
 		/* IO mode write then read */
 		dev_dbg(&drv_data->pdev->dev, "doing IO transfer\n");
 
-		write_STAT(BIT_STAT_CLR);
-
 		if (drv_data->tx != NULL && drv_data->rx != NULL) {
 			/* full duplex mode */
 			BUG_ON((drv_data->tx_end - drv_data->tx) !=
 			       (drv_data->rx_end - drv_data->rx));
-			cr = (read_CTRL() & (~BIT_CTL_TIMOD));
-			cr |= CFG_SPI_WRITE | (width << 8) |
-				(CFG_SPI_ENABLE << 14);
 			dev_dbg(&drv_data->pdev->dev,
 				"IO duplex: cr is 0x%x\n", cr);
 
-			write_CTRL(cr);
+			/* set SPI transfer mode */
+			write_CTRL(cr | CFG_SPI_WRITE);
 
 			drv_data->duplex(drv_data);
 
@@ -823,13 +842,11 @@ static void pump_transfers(unsigned long data)
 				tranf_success = 0;
 		} else if (drv_data->tx != NULL) {
 			/* write only half duplex */
-			cr = (read_CTRL() & (~BIT_CTL_TIMOD));
-			cr |= CFG_SPI_WRITE | (width << 8) |
-				(CFG_SPI_ENABLE << 14);
 			dev_dbg(&drv_data->pdev->dev,
 				"IO write: cr is 0x%x\n", cr);
 
-			write_CTRL(cr);
+			/* set SPI transfer mode */
+			write_CTRL(cr | CFG_SPI_WRITE);
 
 			drv_data->write(drv_data);
 
@@ -837,13 +854,11 @@ static void pump_transfers(unsigned long data)
 				tranf_success = 0;
 		} else if (drv_data->rx != NULL) {
 			/* read only half duplex */
-			cr = (read_CTRL() & (~BIT_CTL_TIMOD));
-			cr |= CFG_SPI_READ | (width << 8) |
-				(CFG_SPI_ENABLE << 14);
 			dev_dbg(&drv_data->pdev->dev,
 				"IO read: cr is 0x%x\n", cr);
 
-			write_CTRL(cr);
+			/* set SPI transfer mode */
+			write_CTRL(cr | CFG_SPI_READ);
 
 			drv_data->read(drv_data);
 			if (drv_data->rx != drv_data->rx_end)
@@ -858,9 +873,6 @@ static void pump_transfers(unsigned long data)
 			/* Update total byte transfered */
 			message->actual_length += drv_data->len;
 
-			if (drv_data->cs_change)
-				cs_deactive(chip);
-
 			/* Move to next transfer of this msg */
 			message->state = next_transfer(drv_data);
 		}
-- 
1.5.3.4
