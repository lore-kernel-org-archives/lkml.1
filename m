Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbZBFHSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbZBFHSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 02:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757118AbZBFHLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 02:11:35 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:44045 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893AbZBFHLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 02:11:23 -0500
X-IronPort-AV: E=Sophos;i="4.37,390,1231131600"; 
   d="scan'208";a="82422026"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, akpm@linux-foundation.org
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Wolfgang Muees <wolfgang.mues@auerswald.de>, Yi Li <yi.li@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 20/20] Blackfin SPI Driver: Make mmc_spi driver work on Blackfin
Date: Fri,  6 Feb 2009 15:13:08 +0800
Message-Id: <1233904388-5765-21-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1233904388-5765-1-git-send-email-cooloney@kernel.org>
References: <1233904388-5765-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Muees <wolfgang.mues@auerswald.de>

1. Rewrite of the non-dma data transfer functions to use only ONE
mode of TIMOD (TIMOD=0x1). With TIMOD=0, it was not possible to set
the TX bit pattern. So the TDBR = 0xFFFF inside the read calls won't
work.

2. Clear SPI_RDBR before reading and before duplex transfer. Otherwise
the garbage data in RDBR will get read. Since mmc_spi uses a lot of
duplex transfers, this is the main cause of mmc_spi failure.

3. Poll RXS for transfer completion. Polling SPIF or TXS cannot
guarantee transfer completion. This may interrupt a transfer before
it is finished. Also this may leave garbage data in buffer and
affect next transfer.

[Yi Li <yi.li@analog.com>: add a field "u16 idle_tx_val" in "struct
bfin5xx_spi_chip" to specify the value to transmit if no TX value
is supplied.]

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>
Signed-off-by: Yi Li <yi.li@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 arch/blackfin/include/asm/bfin5xx_spi.h |    2 +
 drivers/spi/spi_bfin5xx.c               |  250 +++++++++++++-----------------
 2 files changed, 110 insertions(+), 142 deletions(-)

diff --git a/arch/blackfin/include/asm/bfin5xx_spi.h b/arch/blackfin/include/asm/bfin5xx_spi.h
index da8b9ca..2202b9d 100644
--- a/arch/blackfin/include/asm/bfin5xx_spi.h
+++ b/arch/blackfin/include/asm/bfin5xx_spi.h
@@ -125,6 +125,8 @@ struct bfin5xx_spi_chip {
 	u8 cs_change_per_word;
 	u16 cs_chg_udelay; /* Some devices require 16-bit delays */
 	u32 cs_gpio;
+	/* Value to send if no TX value is supplied, usually 0x0 or 0xFFFF */
+	u16 idle_tx_val;
 };
 
 #endif /* _SPI_CHANNEL_H_ */
diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 3e63a5d..a69c396 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -45,6 +45,9 @@ MODULE_LICENSE("GPL");
 #define QUEUE_RUNNING	0
 #define QUEUE_STOPPED	1
 
+/* Value to send if no TX value is supplied */
+#define SPI_IDLE_TXVAL 0x0000
+
 struct driver_data {
 	/* Driver model hookup */
 	struct platform_device *pdev;
@@ -112,6 +115,7 @@ struct chip_data {
 	u8 cs_change_per_word;
 	u16 cs_chg_udelay;	/* Some devices require > 255usec delay */
 	u32 cs_gpio;
+	u16 idle_tx_val;
 	void (*write) (struct driver_data *);
 	void (*read) (struct driver_data *);
 	void (*duplex) (struct driver_data *);
@@ -226,134 +230,126 @@ static void bfin_spi_restore_state(struct driver_data *drv_data)
 	bfin_spi_cs_active(drv_data, chip);
 }
 
-/* used to kick off transfer in rx mode */
-static unsigned short bfin_spi_dummy_read(struct driver_data *drv_data)
+/* used to kick off transfer in rx mode and read unwanted RX data */
+static inline void bfin_spi_dummy_read(struct driver_data *drv_data)
 {
-	unsigned short tmp;
-	tmp = read_RDBR(drv_data);
-	return tmp;
+	(void) read_RDBR(drv_data);
 }
 
 static void bfin_spi_null_writer(struct driver_data *drv_data)
 {
 	u8 n_bytes = drv_data->n_bytes;
+	u16 tx_val = drv_data->cur_chip->idle_tx_val;
+
+	/* clear RXS (we check for RXS inside the loop) */
+	bfin_spi_dummy_read(drv_data);
 
 	while (drv_data->tx < drv_data->tx_end) {
-		write_TDBR(drv_data, 0);
-		while ((read_STAT(drv_data) & BIT_STAT_TXS))
-			cpu_relax();
+		write_TDBR(drv_data, tx_val);
 		drv_data->tx += n_bytes;
+		/* wait until transfer finished.
+		   checking SPIF or TXS may not guarantee transfer completion */
+		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
+			cpu_relax();
+		/* discard RX data and clear RXS */
+		bfin_spi_dummy_read(drv_data);
 	}
 }
 
 static void bfin_spi_null_reader(struct driver_data *drv_data)
 {
 	u8 n_bytes = drv_data->n_bytes;
+	u16 tx_val = drv_data->cur_chip->idle_tx_val;
+
+	/* discard old RX data and clear RXS */
 	bfin_spi_dummy_read(drv_data);
 
 	while (drv_data->rx < drv_data->rx_end) {
+		write_TDBR(drv_data, tx_val);
+		drv_data->rx += n_bytes;
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			cpu_relax();
 		bfin_spi_dummy_read(drv_data);
-		drv_data->rx += n_bytes;
 	}
 }
 
 static void bfin_spi_u8_writer(struct driver_data *drv_data)
 {
-	dev_dbg(&drv_data->pdev->dev,
-		"cr8-s is 0x%x\n", read_STAT(drv_data));
+	/* clear RXS (we check for RXS inside the loop) */
+	bfin_spi_dummy_read(drv_data);
 
 	while (drv_data->tx < drv_data->tx_end) {
-		write_TDBR(drv_data, (*(u8 *) (drv_data->tx)));
-		while (read_STAT(drv_data) & BIT_STAT_TXS)
+		write_TDBR(drv_data, (*(u8 *) (drv_data->tx++)));
+		/* wait until transfer finished.
+		   checking SPIF or TXS may not guarantee transfer completion */
+		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			cpu_relax();
-		++drv_data->tx;
+		/* discard RX data and clear RXS */
+		bfin_spi_dummy_read(drv_data);
 	}
-
-	/* poll for SPI completion before return */
-	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		cpu_relax();
 }
 
 static void bfin_spi_u8_cs_chg_writer(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
+	/* clear RXS (we check for RXS inside the loop) */
+	bfin_spi_dummy_read(drv_data);
+
 	while (drv_data->tx < drv_data->tx_end) {
 		bfin_spi_cs_active(drv_data, chip);
-
-		write_TDBR(drv_data, (*(u8 *) (drv_data->tx)));
-		while (read_STAT(drv_data) & BIT_STAT_TXS)
-			cpu_relax();
-		while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
+		write_TDBR(drv_data, (*(u8 *) (drv_data->tx++)));
+		/* make sure transfer finished before deactiving CS */
+		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			cpu_relax();
-
+		bfin_spi_dummy_read(drv_data);
 		bfin_spi_cs_deactive(drv_data, chip);
-
-		++drv_data->tx;
 	}
 }
 
 static void bfin_spi_u8_reader(struct driver_data *drv_data)
 {
-	dev_dbg(&drv_data->pdev->dev,
-		"cr-8 is 0x%x\n", read_STAT(drv_data));
-
-	/* poll for SPI completion before start */
-	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		cpu_relax();
-
-	/* clear TDBR buffer before read(else it will be shifted out) */
-	write_TDBR(drv_data, 0xFFFF);
+	u16 tx_val = drv_data->cur_chip->idle_tx_val;
 
+	/* discard old RX data and clear RXS */
 	bfin_spi_dummy_read(drv_data);
 
-	while (drv_data->rx < drv_data->rx_end - 1) {
+	while (drv_data->rx < drv_data->rx_end) {
+		write_TDBR(drv_data, tx_val);
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			cpu_relax();
-		*(u8 *) (drv_data->rx) = read_RDBR(drv_data);
-		++drv_data->rx;
+		*(u8 *) (drv_data->rx++) = read_RDBR(drv_data);
 	}
-
-	while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-		cpu_relax();
-	*(u8 *) (drv_data->rx) = read_SHAW(drv_data);
-	++drv_data->rx;
 }
 
 static void bfin_spi_u8_cs_chg_reader(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
+	u16 tx_val = chip->idle_tx_val;
+
+	/* discard old RX data and clear RXS */
+	bfin_spi_dummy_read(drv_data);
 
 	while (drv_data->rx < drv_data->rx_end) {
 		bfin_spi_cs_active(drv_data, chip);
-		read_RDBR(drv_data);	/* kick off */
-
+		write_TDBR(drv_data, tx_val);
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			cpu_relax();
-		while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-			cpu_relax();
-
-		*(u8 *) (drv_data->rx) = read_SHAW(drv_data);
+		*(u8 *) (drv_data->rx++) = read_RDBR(drv_data);
 		bfin_spi_cs_deactive(drv_data, chip);
-
-		++drv_data->rx;
 	}
 }
 
 static void bfin_spi_u8_duplex(struct driver_data *drv_data)
 {
-	/* in duplex mode, clk is triggered by writing of TDBR */
+	/* discard old RX data and clear RXS */
+	bfin_spi_dummy_read(drv_data);
+
 	while (drv_data->rx < drv_data->rx_end) {
-		write_TDBR(drv_data, (*(u8 *) (drv_data->tx)));
-		while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-			cpu_relax();
+		write_TDBR(drv_data, (*(u8 *) (drv_data->tx++)));
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			cpu_relax();
-		*(u8 *) (drv_data->rx) = read_RDBR(drv_data);
-		++drv_data->rx;
-		++drv_data->tx;
+		*(u8 *) (drv_data->rx++) = read_RDBR(drv_data);
 	}
 }
 
@@ -361,130 +357,102 @@ static void bfin_spi_u8_cs_chg_duplex(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
+	/* discard old RX data and clear RXS */
+	bfin_spi_dummy_read(drv_data);
+
 	while (drv_data->rx < drv_data->rx_end) {
 		bfin_spi_cs_active(drv_data, chip);
-
-		write_TDBR(drv_data, (*(u8 *) (drv_data->tx)));
-
-		while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-			cpu_relax();
+		write_TDBR(drv_data, (*(u8 *) (drv_data->tx++)));
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			cpu_relax();
-		*(u8 *) (drv_data->rx) = read_RDBR(drv_data);
-
+		*(u8 *) (drv_data->rx++) = read_RDBR(drv_data);
 		bfin_spi_cs_deactive(drv_data, chip);
-
-		++drv_data->rx;
-		++drv_data->tx;
 	}
 }
 
 static void bfin_spi_u16_writer(struct driver_data *drv_data)
 {
-	dev_dbg(&drv_data->pdev->dev,
-		"cr16 is 0x%x\n", read_STAT(drv_data));
+	/* clear RXS (we check for RXS inside the loop) */
+	bfin_spi_dummy_read(drv_data);
 
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(drv_data, (*(u16 *) (drv_data->tx)));
-		while ((read_STAT(drv_data) & BIT_STAT_TXS))
-			cpu_relax();
 		drv_data->tx += 2;
+		/* wait until transfer finished.
+		   checking SPIF or TXS may not guarantee transfer completion */
+		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
+			cpu_relax();
+		/* discard RX data and clear RXS */
+		bfin_spi_dummy_read(drv_data);
 	}
-
-	/* poll for SPI completion before return */
-	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		cpu_relax();
 }
 
 static void bfin_spi_u16_cs_chg_writer(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
+	/* clear RXS (we check for RXS inside the loop) */
+	bfin_spi_dummy_read(drv_data);
+
 	while (drv_data->tx < drv_data->tx_end) {
 		bfin_spi_cs_active(drv_data, chip);
-
 		write_TDBR(drv_data, (*(u16 *) (drv_data->tx)));
-		while ((read_STAT(drv_data) & BIT_STAT_TXS))
-			cpu_relax();
-		while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
+		drv_data->tx += 2;
+		/* make sure transfer finished before deactiving CS */
+		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			cpu_relax();
-
+		bfin_spi_dummy_read(drv_data);
 		bfin_spi_cs_deactive(drv_data, chip);
-
-		drv_data->tx += 2;
 	}
 }
 
 static void bfin_spi_u16_reader(struct driver_data *drv_data)
 {
-	dev_dbg(&drv_data->pdev->dev,
-		"cr-16 is 0x%x\n", read_STAT(drv_data));
-
-	/* poll for SPI completion before start */
-	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		cpu_relax();
-
-	/* clear TDBR buffer before read(else it will be shifted out) */
-	write_TDBR(drv_data, 0xFFFF);
+	u16 tx_val = drv_data->cur_chip->idle_tx_val;
 
+	/* discard old RX data and clear RXS */
 	bfin_spi_dummy_read(drv_data);
 
-	while (drv_data->rx < (drv_data->rx_end - 2)) {
+	while (drv_data->rx < drv_data->rx_end) {
+		write_TDBR(drv_data, tx_val);
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			cpu_relax();
 		*(u16 *) (drv_data->rx) = read_RDBR(drv_data);
 		drv_data->rx += 2;
 	}
-
-	while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-		cpu_relax();
-	*(u16 *) (drv_data->rx) = read_SHAW(drv_data);
-	drv_data->rx += 2;
 }
 
 static void bfin_spi_u16_cs_chg_reader(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
+	u16 tx_val = chip->idle_tx_val;
 
-	/* poll for SPI completion before start */
-	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		cpu_relax();
-
-	/* clear TDBR buffer before read(else it will be shifted out) */
-	write_TDBR(drv_data, 0xFFFF);
-
-	bfin_spi_cs_active(drv_data, chip);
+	/* discard old RX data and clear RXS */
 	bfin_spi_dummy_read(drv_data);
 
-	while (drv_data->rx < drv_data->rx_end - 2) {
-		bfin_spi_cs_deactive(drv_data, chip);
-
+	while (drv_data->rx < drv_data->rx_end) {
+		bfin_spi_cs_active(drv_data, chip);
+		write_TDBR(drv_data, tx_val);
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			cpu_relax();
-		bfin_spi_cs_active(drv_data, chip);
 		*(u16 *) (drv_data->rx) = read_RDBR(drv_data);
 		drv_data->rx += 2;
+		bfin_spi_cs_deactive(drv_data, chip);
 	}
-	bfin_spi_cs_deactive(drv_data, chip);
-
-	while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-		cpu_relax();
-	*(u16 *) (drv_data->rx) = read_SHAW(drv_data);
-	drv_data->rx += 2;
 }
 
 static void bfin_spi_u16_duplex(struct driver_data *drv_data)
 {
-	/* in duplex mode, clk is triggered by writing of TDBR */
-	while (drv_data->tx < drv_data->tx_end) {
+	/* discard old RX data and clear RXS */
+	bfin_spi_dummy_read(drv_data);
+
+	while (drv_data->rx < drv_data->rx_end) {
 		write_TDBR(drv_data, (*(u16 *) (drv_data->tx)));
-		while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-			cpu_relax();
+		drv_data->tx += 2;
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			cpu_relax();
 		*(u16 *) (drv_data->rx) = read_RDBR(drv_data);
 		drv_data->rx += 2;
-		drv_data->tx += 2;
 	}
 }
 
@@ -492,20 +460,18 @@ static void bfin_spi_u16_cs_chg_duplex(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
-	while (drv_data->tx < drv_data->tx_end) {
-		bfin_spi_cs_active(drv_data, chip);
+	/* discard old RX data and clear RXS */
+	bfin_spi_dummy_read(drv_data);
 
+	while (drv_data->rx < drv_data->rx_end) {
+		bfin_spi_cs_active(drv_data, chip);
 		write_TDBR(drv_data, (*(u16 *) (drv_data->tx)));
-		while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-			cpu_relax();
+		drv_data->tx += 2;
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			cpu_relax();
 		*(u16 *) (drv_data->rx) = read_RDBR(drv_data);
-
-		bfin_spi_cs_deactive(drv_data, chip);
-
 		drv_data->rx += 2;
-		drv_data->tx += 2;
+		bfin_spi_cs_deactive(drv_data, chip);
 	}
 }
 
@@ -682,6 +648,13 @@ static void bfin_spi_pump_transfers(unsigned long data)
 		return;
 	}
 
+	if (transfer->len == 0) {
+		/* Move to next transfer of this msg */
+		message->state = bfin_spi_next_transfer(drv_data);
+		/* Schedule next transfer tasklet */
+		tasklet_schedule(&drv_data->pump_transfers);
+	}
+
 	if (transfer->tx_buf != NULL) {
 		drv_data->tx = (void *)transfer->tx_buf;
 		drv_data->tx_end = drv_data->tx + transfer->len;
@@ -837,9 +810,6 @@ static void bfin_spi_pump_transfers(unsigned long data)
 							(unsigned long) (drv_data->rx +
 							drv_data->len_in_bytes));
 
-			/* clear tx reg soformer data is not shifted out */
-			write_TDBR(drv_data, 0xFFFF);
-
 			dma_config |= WNR;
 			dma_start_addr = (unsigned long)drv_data->rx;
 			cr |= BIT_CTL_TIMOD_DMA_RX | BIT_CTL_SENDOPT;
@@ -881,6 +851,11 @@ static void bfin_spi_pump_transfers(unsigned long data)
 		/* IO mode write then read */
 		dev_dbg(&drv_data->pdev->dev, "doing IO transfer\n");
 
+		/* we always use SPI_WRITE mode. SPI_READ mode
+		   seems to have problems with setting up the
+		   output value in TDBR prior to the transfer. */
+		write_CTRL(drv_data, (cr | CFG_SPI_WRITE));
+
 		if (full_duplex) {
 			/* full duplex mode */
 			BUG_ON((drv_data->tx_end - drv_data->tx) !=
@@ -888,9 +863,6 @@ static void bfin_spi_pump_transfers(unsigned long data)
 			dev_dbg(&drv_data->pdev->dev,
 				"IO duplex: cr is 0x%x\n", cr);
 
-			/* set SPI transfer mode */
-			write_CTRL(drv_data, (cr | CFG_SPI_WRITE));
-
 			drv_data->duplex(drv_data);
 
 			if (drv_data->tx != drv_data->tx_end)
@@ -900,9 +872,6 @@ static void bfin_spi_pump_transfers(unsigned long data)
 			dev_dbg(&drv_data->pdev->dev,
 				"IO write: cr is 0x%x\n", cr);
 
-			/* set SPI transfer mode */
-			write_CTRL(drv_data, (cr | CFG_SPI_WRITE));
-
 			drv_data->write(drv_data);
 
 			if (drv_data->tx != drv_data->tx_end)
@@ -912,9 +881,6 @@ static void bfin_spi_pump_transfers(unsigned long data)
 			dev_dbg(&drv_data->pdev->dev,
 				"IO read: cr is 0x%x\n", cr);
 
-			/* set SPI transfer mode */
-			write_CTRL(drv_data, (cr | CFG_SPI_READ));
-
 			drv_data->read(drv_data);
 			if (drv_data->rx != drv_data->rx_end)
 				tranf_success = 0;
@@ -934,7 +900,6 @@ static void bfin_spi_pump_transfers(unsigned long data)
 		}
 		/* Schedule next transfer tasklet */
 		tasklet_schedule(&drv_data->pump_transfers);
-
 	}
 }
 
@@ -1092,6 +1057,7 @@ static int bfin_spi_setup(struct spi_device *spi)
 		chip->cs_change_per_word = chip_info->cs_change_per_word;
 		chip->cs_chg_udelay = chip_info->cs_chg_udelay;
 		chip->cs_gpio = chip_info->cs_gpio;
+		chip->idle_tx_val = chip_info->idle_tx_val;
 	}
 
 	/* translate common spi framework into our register */
-- 
1.5.6.3
