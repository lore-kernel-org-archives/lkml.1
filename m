Return-Path: <linux-kernel-owner+w=401wt.eu-S1758493AbXJKKNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758493AbXJKKNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 06:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757076AbXJKKK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 06:10:57 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:23115 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099AbXJKKKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 06:10:51 -0400
X-IronPort-AV: i="4.21,259,1188792000"; 
   d="scan'208"; a="53762412:sNHT53186651"
From: Bryan Wu <bryan.wu@analog.com>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Sonic Zhang <sonic.zhang@analog.com>, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 9/9] Blackfin SPI driver: Clean up useless wait in bfin SPI driver
Date: Thu, 11 Oct 2007 18:10:41 +0800
Message-Id: <1192097441-24962-10-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1192097441-24962-1-git-send-email-bryan.wu@analog.com>
References: <1192097441-24962-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/spi/spi_bfin5xx.c |   84 ++++++++++++++++++++++++++++-----------------
 1 files changed, 52 insertions(+), 32 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 0cdfc2b..bfeaa7c 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -276,22 +276,26 @@ static void u8_writer(struct driver_data *drv_data)
 	dev_dbg(&drv_data->pdev->dev,
 		"cr8-s is 0x%x\n", read_STAT());
 
+	/* poll for SPI completion before start */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
+
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(*(u8 *) (drv_data->tx));
 		while (read_STAT() & BIT_STAT_TXS)
 			continue;
 		++drv_data->tx;
 	}
-
-	/* poll for SPI completion before returning */
-	while (!(read_STAT() & BIT_STAT_SPIF))
-		continue;
 }
 
 static void u8_cs_chg_writer(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
+	/* poll for SPI completion before start */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
+
 	while (drv_data->tx < drv_data->tx_end) {
 		cs_active(chip);
 
@@ -304,10 +308,6 @@ static void u8_cs_chg_writer(struct driver_data *drv_data)
 			udelay(chip->cs_chg_udelay);
 		++drv_data->tx;
 	}
-
-	/* poll for SPI completion before returning */
-	while (!(read_STAT() & BIT_STAT_SPIF))
-		continue;
 }
 
 static void u8_reader(struct driver_data *drv_data)
@@ -315,6 +315,10 @@ static void u8_reader(struct driver_data *drv_data)
 	dev_dbg(&drv_data->pdev->dev,
 		"cr-8 is 0x%x\n", read_STAT());
 
+	/* poll for SPI completion before start */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
+
 	/* clear TDBR buffer before read(else it will be shifted out) */
 	write_TDBR(0xFFFF);
 
@@ -337,6 +341,10 @@ static void u8_cs_chg_reader(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
+	/* poll for SPI completion before start */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
+
 	/* clear TDBR buffer before read(else it will be shifted out) */
 	write_TDBR(0xFFFF);
 
@@ -365,6 +373,10 @@ static void u8_cs_chg_reader(struct driver_data *drv_data)
 
 static void u8_duplex(struct driver_data *drv_data)
 {
+	/* poll for SPI completion before start */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
+
 	/* in duplex mode, clk is triggered by writing of TDBR */
 	while (drv_data->rx < drv_data->rx_end) {
 		write_TDBR(*(u8 *) (drv_data->tx));
@@ -376,16 +388,16 @@ static void u8_duplex(struct driver_data *drv_data)
 		++drv_data->rx;
 		++drv_data->tx;
 	}
-
-	/* poll for SPI completion before returning */
-	while (!(read_STAT() & BIT_STAT_SPIF))
-		continue;
 }
 
 static void u8_cs_chg_duplex(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
+	/* poll for SPI completion before start */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
+
 	while (drv_data->rx < drv_data->rx_end) {
 		cs_active(chip);
 
@@ -402,10 +414,6 @@ static void u8_cs_chg_duplex(struct driver_data *drv_data)
 		++drv_data->rx;
 		++drv_data->tx;
 	}
-
-	/* poll for SPI completion before returning */
-	while (!(read_STAT() & BIT_STAT_SPIF))
-		continue;
 }
 
 static void u16_writer(struct driver_data *drv_data)
@@ -413,22 +421,26 @@ static void u16_writer(struct driver_data *drv_data)
 	dev_dbg(&drv_data->pdev->dev,
 		"cr16 is 0x%x\n", read_STAT());
 
+	/* poll for SPI completion before start */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
+
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(*(u16 *) (drv_data->tx));
 		while ((read_STAT() & BIT_STAT_TXS))
 			continue;
 		drv_data->tx += 2;
 	}
-
-	/* poll for SPI completion before returning */
-	while (!(read_STAT() & BIT_STAT_SPIF))
-		continue;
 }
 
 static void u16_cs_chg_writer(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
+	/* poll for SPI completion before start */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
+
 	while (drv_data->tx < drv_data->tx_end) {
 		cs_active(chip);
 
@@ -441,10 +453,6 @@ static void u16_cs_chg_writer(struct driver_data *drv_data)
 			udelay(chip->cs_chg_udelay);
 		drv_data->tx += 2;
 	}
-
-	/* poll for SPI completion before returning */
-	while (!(read_STAT() & BIT_STAT_SPIF))
-		continue;
 }
 
 static void u16_reader(struct driver_data *drv_data)
@@ -452,6 +460,10 @@ static void u16_reader(struct driver_data *drv_data)
 	dev_dbg(&drv_data->pdev->dev,
 		"cr-16 is 0x%x\n", read_STAT());
 
+	/* poll for SPI completion before start */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
+
 	/* clear TDBR buffer before read(else it will be shifted out) */
 	write_TDBR(0xFFFF);
 
@@ -474,6 +486,10 @@ static void u16_cs_chg_reader(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
+	/* poll for SPI completion before start */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
+
 	/* clear TDBR buffer before read(else it will be shifted out) */
 	write_TDBR(0xFFFF);
 
@@ -502,6 +518,10 @@ static void u16_cs_chg_reader(struct driver_data *drv_data)
 
 static void u16_duplex(struct driver_data *drv_data)
 {
+	/* poll for SPI completion before start */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
+
 	/* in duplex mode, clk is triggered by writing of TDBR */
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(*(u16 *) (drv_data->tx));
@@ -513,16 +533,16 @@ static void u16_duplex(struct driver_data *drv_data)
 		drv_data->rx += 2;
 		drv_data->tx += 2;
 	}
-
-	/* poll for SPI completion before returning */
-	while (!(read_STAT() & BIT_STAT_SPIF))
-		continue;
 }
 
 static void u16_cs_chg_duplex(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
+	/* poll for SPI completion before start */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
+
 	while (drv_data->tx < drv_data->tx_end) {
 		cs_active(chip);
 
@@ -539,10 +559,6 @@ static void u16_cs_chg_duplex(struct driver_data *drv_data)
 		drv_data->rx += 2;
 		drv_data->tx += 2;
 	}
-
-	/* poll for SPI completion before returning */
-	while (!(read_STAT() & BIT_STAT_SPIF))
-		continue;
 }
 
 /* test if ther is more transfer to be done */
@@ -765,6 +781,10 @@ static void pump_transfers(unsigned long data)
 			dma_width = WDSIZE_8;
 		}
 
+		/* poll for SPI completion before start */
+		while (!(read_STAT() & BIT_STAT_SPIF))
+			continue;
+
 		/* dirty hack for autobuffer DMA mode */
 		if (drv_data->tx_dma == 0xFFFF) {
 			dev_dbg(&drv_data->pdev->dev,
-- 
1.5.3.4
