Return-Path: <linux-kernel-owner+w=401wt.eu-S1761132AbXKBCjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761132AbXKBCjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 22:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756200AbXKBCil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 22:38:41 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:28878 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426AbXKBCii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 22:38:38 -0400
X-IronPort-AV: i="4.21,361,1188792000"; 
   d="scan'208"; a="55424472:sNHT48854806"
From: Bryan Wu <bryan.wu@analog.com>
To: dbrownell@users.sourceforge.net, akpm@linux-foundation.org
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 1/4] Blackfin SPI driver: use cpu_relax() to replace continue in while busywait
Date: Fri,  2 Nov 2007 10:38:29 +0800
Message-Id: <1193971112-7744-2-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1193971112-7744-1-git-send-email-bryan.wu@analog.com>
References: <1193971112-7744-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/spi/spi_bfin5xx.c |   78 ++++++++++++++++++++++----------------------
 1 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 83c866d..fc0c374 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -186,7 +186,7 @@ static int flush(struct driver_data *drv_data)
 
 	/* wait for stop and clear stat */
 	while (!(read_STAT(drv_data) & BIT_STAT_SPIF) && limit--)
-		continue;
+		cpu_relax();
 
 	write_STAT(drv_data, BIT_STAT_CLR);
 
@@ -262,7 +262,7 @@ static void null_writer(struct driver_data *drv_data)
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(drv_data, 0);
 		while ((read_STAT(drv_data) & BIT_STAT_TXS))
-			continue;
+			cpu_relax();
 		drv_data->tx += n_bytes;
 	}
 }
@@ -274,7 +274,7 @@ static void null_reader(struct driver_data *drv_data)
 
 	while (drv_data->rx < drv_data->rx_end) {
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-			continue;
+			cpu_relax();
 		dummy_read(drv_data);
 		drv_data->rx += n_bytes;
 	}
@@ -287,12 +287,12 @@ static void u8_writer(struct driver_data *drv_data)
 
 	/* poll for SPI completion before start */
 	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		continue;
+		cpu_relax();
 
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(drv_data, (*(u8 *) (drv_data->tx)));
 		while (read_STAT(drv_data) & BIT_STAT_TXS)
-			continue;
+			cpu_relax();
 		++drv_data->tx;
 	}
 }
@@ -303,14 +303,14 @@ static void u8_cs_chg_writer(struct driver_data *drv_data)
 
 	/* poll for SPI completion before start */
 	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		continue;
+		cpu_relax();
 
 	while (drv_data->tx < drv_data->tx_end) {
 		cs_active(drv_data, chip);
 
 		write_TDBR(drv_data, (*(u8 *) (drv_data->tx)));
 		while (read_STAT(drv_data) & BIT_STAT_TXS)
-			continue;
+			cpu_relax();
 
 		cs_deactive(drv_data, chip);
 
@@ -325,7 +325,7 @@ static void u8_reader(struct driver_data *drv_data)
 
 	/* poll for SPI completion before start */
 	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		continue;
+		cpu_relax();
 
 	/* clear TDBR buffer before read(else it will be shifted out) */
 	write_TDBR(drv_data, 0xFFFF);
@@ -334,13 +334,13 @@ static void u8_reader(struct driver_data *drv_data)
 
 	while (drv_data->rx < drv_data->rx_end - 1) {
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-			continue;
+			cpu_relax();
 		*(u8 *) (drv_data->rx) = read_RDBR(drv_data);
 		++drv_data->rx;
 	}
 
 	while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-		continue;
+		cpu_relax();
 	*(u8 *) (drv_data->rx) = read_SHAW(drv_data);
 	++drv_data->rx;
 }
@@ -351,7 +351,7 @@ static void u8_cs_chg_reader(struct driver_data *drv_data)
 
 	/* poll for SPI completion before start */
 	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		continue;
+		cpu_relax();
 
 	/* clear TDBR buffer before read(else it will be shifted out) */
 	write_TDBR(drv_data, 0xFFFF);
@@ -363,7 +363,7 @@ static void u8_cs_chg_reader(struct driver_data *drv_data)
 		cs_deactive(drv_data, chip);
 
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-			continue;
+			cpu_relax();
 		cs_active(drv_data, chip);
 		*(u8 *) (drv_data->rx) = read_RDBR(drv_data);
 		++drv_data->rx;
@@ -371,7 +371,7 @@ static void u8_cs_chg_reader(struct driver_data *drv_data)
 	cs_deactive(drv_data, chip);
 
 	while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-		continue;
+		cpu_relax();
 	*(u8 *) (drv_data->rx) = read_SHAW(drv_data);
 	++drv_data->rx;
 }
@@ -380,15 +380,15 @@ static void u8_duplex(struct driver_data *drv_data)
 {
 	/* poll for SPI completion before start */
 	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		continue;
+		cpu_relax();
 
 	/* in duplex mode, clk is triggered by writing of TDBR */
 	while (drv_data->rx < drv_data->rx_end) {
 		write_TDBR(drv_data, (*(u8 *) (drv_data->tx)));
 		while (read_STAT(drv_data) & BIT_STAT_TXS)
-			continue;
+			cpu_relax();
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-			continue;
+			cpu_relax();
 		*(u8 *) (drv_data->rx) = read_RDBR(drv_data);
 		++drv_data->rx;
 		++drv_data->tx;
@@ -401,16 +401,16 @@ static void u8_cs_chg_duplex(struct driver_data *drv_data)
 
 	/* poll for SPI completion before start */
 	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		continue;
+		cpu_relax();
 
 	while (drv_data->rx < drv_data->rx_end) {
 		cs_active(drv_data, chip);
 
 		write_TDBR(drv_data, (*(u8 *) (drv_data->tx)));
 		while (read_STAT(drv_data) & BIT_STAT_TXS)
-			continue;
+			cpu_relax();
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-			continue;
+			cpu_relax();
 		*(u8 *) (drv_data->rx) = read_RDBR(drv_data);
 
 		cs_deactive(drv_data, chip);
@@ -427,12 +427,12 @@ static void u16_writer(struct driver_data *drv_data)
 
 	/* poll for SPI completion before start */
 	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		continue;
+		cpu_relax();
 
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(drv_data, (*(u16 *) (drv_data->tx)));
 		while ((read_STAT(drv_data) & BIT_STAT_TXS))
-			continue;
+			cpu_relax();
 		drv_data->tx += 2;
 	}
 }
@@ -443,14 +443,14 @@ static void u16_cs_chg_writer(struct driver_data *drv_data)
 
 	/* poll for SPI completion before start */
 	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		continue;
+		cpu_relax();
 
 	while (drv_data->tx < drv_data->tx_end) {
 		cs_active(drv_data, chip);
 
 		write_TDBR(drv_data, (*(u16 *) (drv_data->tx)));
 		while ((read_STAT(drv_data) & BIT_STAT_TXS))
-			continue;
+			cpu_relax();
 
 		cs_deactive(drv_data, chip);
 
@@ -465,7 +465,7 @@ static void u16_reader(struct driver_data *drv_data)
 
 	/* poll for SPI completion before start */
 	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		continue;
+		cpu_relax();
 
 	/* clear TDBR buffer before read(else it will be shifted out) */
 	write_TDBR(drv_data, 0xFFFF);
@@ -474,13 +474,13 @@ static void u16_reader(struct driver_data *drv_data)
 
 	while (drv_data->rx < (drv_data->rx_end - 2)) {
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-			continue;
+			cpu_relax();
 		*(u16 *) (drv_data->rx) = read_RDBR(drv_data);
 		drv_data->rx += 2;
 	}
 
 	while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-		continue;
+		cpu_relax();
 	*(u16 *) (drv_data->rx) = read_SHAW(drv_data);
 	drv_data->rx += 2;
 }
@@ -491,7 +491,7 @@ static void u16_cs_chg_reader(struct driver_data *drv_data)
 
 	/* poll for SPI completion before start */
 	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		continue;
+		cpu_relax();
 
 	/* clear TDBR buffer before read(else it will be shifted out) */
 	write_TDBR(drv_data, 0xFFFF);
@@ -503,7 +503,7 @@ static void u16_cs_chg_reader(struct driver_data *drv_data)
 		cs_deactive(drv_data, chip);
 
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-			continue;
+			cpu_relax();
 		cs_active(drv_data, chip);
 		*(u16 *) (drv_data->rx) = read_RDBR(drv_data);
 		drv_data->rx += 2;
@@ -511,7 +511,7 @@ static void u16_cs_chg_reader(struct driver_data *drv_data)
 	cs_deactive(drv_data, chip);
 
 	while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-		continue;
+		cpu_relax();
 	*(u16 *) (drv_data->rx) = read_SHAW(drv_data);
 	drv_data->rx += 2;
 }
@@ -520,15 +520,15 @@ static void u16_duplex(struct driver_data *drv_data)
 {
 	/* poll for SPI completion before start */
 	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		continue;
+		cpu_relax();
 
 	/* in duplex mode, clk is triggered by writing of TDBR */
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(drv_data, (*(u16 *) (drv_data->tx)));
 		while (read_STAT(drv_data) & BIT_STAT_TXS)
-			continue;
+			cpu_relax();
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-			continue;
+			cpu_relax();
 		*(u16 *) (drv_data->rx) = read_RDBR(drv_data);
 		drv_data->rx += 2;
 		drv_data->tx += 2;
@@ -541,16 +541,16 @@ static void u16_cs_chg_duplex(struct driver_data *drv_data)
 
 	/* poll for SPI completion before start */
 	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		continue;
+		cpu_relax();
 
 	while (drv_data->tx < drv_data->tx_end) {
 		cs_active(drv_data, chip);
 
 		write_TDBR(drv_data, (*(u16 *) (drv_data->tx)));
 		while (read_STAT(drv_data) & BIT_STAT_TXS)
-			continue;
+			cpu_relax();
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-			continue;
+			cpu_relax();
 		*(u16 *) (drv_data->rx) = read_RDBR(drv_data);
 
 		cs_deactive(drv_data, chip);
@@ -624,7 +624,7 @@ static irqreturn_t dma_irq_handler(int irq, void *dev_id)
 
 	/* Wait for DMA to complete */
 	while (get_dma_curr_irqstat(drv_data->dma_channel) & DMA_RUN)
-		continue;
+		cpu_relax();
 
 	/*
 	 * wait for the last transaction shifted out.  HRM states:
@@ -635,11 +635,11 @@ static irqreturn_t dma_irq_handler(int irq, void *dev_id)
 	if (drv_data->tx != NULL) {
 		while ((read_STAT(drv_data) & TXS) ||
 		       (read_STAT(drv_data) & TXS))
-			continue;
+			cpu_relax();
 	}
 
 	while (!(read_STAT(drv_data) & SPIF))
-		continue;
+		cpu_relax();
 
 	msg->actual_length += drv_data->len_in_bytes;
 
@@ -783,7 +783,7 @@ static void pump_transfers(unsigned long data)
 
 		/* poll for SPI completion before start */
 		while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-			continue;
+			cpu_relax();
 
 		/* dirty hack for autobuffer DMA mode */
 		if (drv_data->tx_dma == 0xFFFF) {
-- 
1.5.3.4
