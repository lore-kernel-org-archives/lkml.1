Return-Path: <linux-kernel-owner+w=401wt.eu-S1760112AbXEUKeD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760112AbXEUKeD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:34:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762241AbXEUKdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:33:51 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:45807 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761167AbXEUKdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:33:50 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="30507384:sNHT28091210"
Subject: [PATCH 32/32] Blackfin SPI: cleanup according to David Brownell's
	review
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, bryan.wu@analog.com
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Mon, 21 May 2007 18:32:16 +0800
Message-Id: <1179743536.20898.3.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bryan Wu <bryan.wu@analog.com>

a) platorm_driver_probe(...) instead of platform_driver_register(&driver);
b) set bfin_spi_enable and bfin_spi_disable static
c) Why is the width flag a u32?
d) maybe use dev_dbg() instead of pr_debug()

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/spi/spi_bfin5xx.c |  152 ++++++++++++++++++++++++---------------------
 1 files changed, 80 insertions(+), 72 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index ce3c0ce..7d2d9ec 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -126,7 +126,7 @@ struct chip_data {
 
 	u8 chip_select_num;
 	u8 n_bytes;
-	u32 width;		/* 0 or 1 */
+	u8 width;		/* 0 or 1 */
 	u8 enable_dma;
 	u8 bits_per_word;	/* 8 or 16 */
 	u8 cs_change_per_word;
@@ -136,7 +136,7 @@ struct chip_data {
 	void (*duplex) (struct driver_data *);
 };
 
-void bfin_spi_enable(struct driver_data *drv_data)
+static void bfin_spi_enable(struct driver_data *drv_data)
 {
 	u16 cr;
 
@@ -145,7 +145,7 @@ void bfin_spi_enable(struct driver_data *drv_data)
 	SSYNC();
 }
 
-void bfin_spi_disable(struct driver_data *drv_data)
+static void bfin_spi_disable(struct driver_data *drv_data)
 {
 	u16 cr;
 
@@ -163,9 +163,6 @@ static u16 hz_to_spi_baud(u32 speed_hz)
 	if ((sclk % (2 * speed_hz)) > 0)
 		spi_baud++;
 
-	pr_debug("sclk = %ld, speed_hz = %d, spi_baud = %d\n", sclk, speed_hz,
-		 spi_baud);
-
 	return spi_baud;
 }
 
@@ -190,11 +187,12 @@ static void restore_state(struct driver_data *drv_data)
 	/* Clear status and disable clock */
 	write_STAT(BIT_STAT_CLR);
 	bfin_spi_disable(drv_data);
-	pr_debug("restoring spi ctl state\n");
+	dev_dbg(&drv_data->pdev->dev, "restoring spi ctl state\n");
 
 #if defined(CONFIG_BF534) || defined(CONFIG_BF536) || defined(CONFIG_BF537)
-	pr_debug("chip select number is %d\n", chip->chip_select_num);
-
+	dev_dbg(&drv_data->pdev->dev, 
+		"chip select number is %d\n", chip->chip_select_num);
+	
 	switch (chip->chip_select_num) {
 	case 1:
 		bfin_write_PORTF_FER(bfin_read_PORTF_FER() | 0x3c00);
@@ -280,7 +278,8 @@ static void null_reader(struct driver_data *drv_data)
 
 static void u8_writer(struct driver_data *drv_data)
 {
-	pr_debug("cr8-s is 0x%x\n", read_STAT());
+	dev_dbg(&drv_data->pdev->dev, 
+		"cr8-s is 0x%x\n", read_STAT());
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(*(u8 *) (drv_data->tx));
 		while (read_STAT() & BIT_STAT_TXS)
@@ -318,7 +317,8 @@ static void u8_cs_chg_writer(struct driver_data *drv_data)
 
 static void u8_reader(struct driver_data *drv_data)
 {
-	pr_debug("cr-8 is 0x%x\n", read_STAT());
+	dev_dbg(&drv_data->pdev->dev, 
+		"cr-8 is 0x%x\n", read_STAT());
 
 	/* clear TDBR buffer before read(else it will be shifted out) */
 	write_TDBR(0xFFFF);
@@ -404,7 +404,9 @@ static void u8_cs_chg_duplex(struct driver_data *drv_data)
 
 static void u16_writer(struct driver_data *drv_data)
 {
-	pr_debug("cr16 is 0x%x\n", read_STAT());
+	dev_dbg(&drv_data->pdev->dev, 
+		"cr16 is 0x%x\n", read_STAT());
+
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(*(u16 *) (drv_data->tx));
 		while ((read_STAT() & BIT_STAT_TXS))
@@ -442,7 +444,8 @@ static void u16_cs_chg_writer(struct driver_data *drv_data)
 
 static void u16_reader(struct driver_data *drv_data)
 {
-	pr_debug("cr-16 is 0x%x\n", read_STAT());
+	dev_dbg(&drv_data->pdev->dev,
+		"cr-16 is 0x%x\n", read_STAT());
 	dummy_read();
 
 	while (drv_data->rx < (drv_data->rx_end - 2)) {
@@ -571,12 +574,12 @@ static void giveback(struct driver_data *drv_data)
 		msg->complete(msg->context);
 }
 
-static irqreturn_t dma_irq_handler(int irq, void *dev_id, struct pt_regs *regs)
+static irqreturn_t dma_irq_handler(int irq, void *dev_id)
 {
 	struct driver_data *drv_data = (struct driver_data *)dev_id;
 	struct spi_message *msg = drv_data->cur_msg;
 
-	pr_debug("in dma_irq_handler\n");
+	dev_dbg(&drv_data->pdev->dev, "in dma_irq_handler\n");
 	clear_dma_irqstat(CH_SPI);
 
 	/*
@@ -604,7 +607,9 @@ static irqreturn_t dma_irq_handler(int irq, void *dev_id, struct pt_regs *regs)
 	tasklet_schedule(&drv_data->pump_transfers);
 
 	/* free the irq handler before next transfer */
-	pr_debug("disable dma channel irq%d\n", CH_SPI);
+	dev_dbg(&drv_data->pdev->dev,
+		"disable dma channel irq%d\n",
+		CH_SPI);
 	dma_disable_irq(CH_SPI);
 
 	return IRQ_HANDLED;
@@ -617,7 +622,8 @@ static void pump_transfers(unsigned long data)
 	struct spi_transfer *transfer = NULL;
 	struct spi_transfer *previous = NULL;
 	struct chip_data *chip = NULL;
-	u16 cr, width, dma_width, dma_config;
+	u8 width;
+	u16 cr, dma_width, dma_config;
 	u32 tranf_success = 1;
 
 	/* Get current state information */
@@ -662,8 +668,8 @@ static void pump_transfers(unsigned long data)
 	if (transfer->tx_buf != NULL) {
 		drv_data->tx = (void *)transfer->tx_buf;
 		drv_data->tx_end = drv_data->tx + transfer->len;
-		pr_debug("tx_buf is %p, tx_end is %p\n", transfer->tx_buf,
-			 drv_data->tx_end);
+		dev_dbg(&drv_data->pdev->dev, "tx_buf is %p, tx_end is %p\n",
+			transfer->tx_buf, drv_data->tx_end);
 	} else {
 		drv_data->tx = NULL;
 	}
@@ -671,8 +677,8 @@ static void pump_transfers(unsigned long data)
 	if (transfer->rx_buf != NULL) {
 		drv_data->rx = transfer->rx_buf;
 		drv_data->rx_end = drv_data->rx + transfer->len;
-		pr_debug("rx_buf is %p, rx_end is %p\n", transfer->rx_buf,
-			 drv_data->rx_end);
+		dev_dbg(&drv_data->pdev->dev, "rx_buf is %p, rx_end is %p\n",
+			transfer->rx_buf, drv_data->rx_end);
 	} else {
 		drv_data->rx = NULL;
 	}
@@ -690,9 +696,9 @@ static void pump_transfers(unsigned long data)
 	drv_data->write = drv_data->tx ? chip->write : null_writer;
 	drv_data->read = drv_data->rx ? chip->read : null_reader;
 	drv_data->duplex = chip->duplex ? chip->duplex : null_writer;
-	pr_debug
-	    ("transfer: drv_data->write is %p, chip->write is %p, null_wr is %p\n",
-	     drv_data->write, chip->write, null_writer);
+	dev_dbg(&drv_data->pdev->dev,
+		"transfer: drv_data->write is %p, chip->write is %p, null_wr is %p\n",
+   		drv_data->write, chip->write, null_writer);
 
 	/* speed and width has been set on per message */
 	message->state = RUNNING_STATE;
@@ -706,8 +712,9 @@ static void pump_transfers(unsigned long data)
 	}
 	write_FLAG(chip->flag);
 
-	pr_debug("now pumping a transfer: width is %d, len is %d\n", width,
-		 transfer->len);
+	dev_dbg(&drv_data->pdev->dev,
+		"now pumping a transfer: width is %d, len is %d\n",
+		width, transfer->len);
 
 	/*
 	 * Try to map dma buffer and do a dma transfer if
@@ -722,7 +729,7 @@ static void pump_transfers(unsigned long data)
 		bfin_spi_disable(drv_data);
 
 		/* config dma channel */
-		pr_debug("doing dma transfer\n");
+		dev_dbg(&drv_data->pdev->dev, "doing dma transfer\n");
 		if (width == CFG_SPI_WORDSIZE16) {
 			set_dma_x_count(CH_SPI, drv_data->len);
 			set_dma_x_modify(CH_SPI, 2);
@@ -738,7 +745,8 @@ static void pump_transfers(unsigned long data)
 
 		/* dirty hack for autobuffer DMA mode */
 		if (drv_data->tx_dma == 0xFFFF) {
-			pr_debug("doing autobuffer DMA out.\n");
+			dev_dbg(&drv_data->pdev->dev,
+				"doing autobuffer DMA out.\n");
 
 			/* no irq in autobuffer mode */
 			dma_config =
@@ -758,7 +766,7 @@ static void pump_transfers(unsigned long data)
 		/* In dma mode, rx or tx must be NULL in one transfer */
 		if (drv_data->rx != NULL) {
 			/* set transfer mode, and enable SPI */
-			pr_debug("doing DMA in.\n");
+			dev_dbg(&drv_data->pdev->dev, "doing DMA in.\n");
 
 			/* disable SPI before write to TDBR */
 			write_CTRL(cr & ~BIT_CTL_ENABLE);
@@ -781,7 +789,7 @@ static void pump_transfers(unsigned long data)
 			/* set transfer mode, and enable SPI */
 			write_CTRL(cr);
 		} else if (drv_data->tx != NULL) {
-			pr_debug("doing DMA out.\n");
+			dev_dbg(&drv_data->pdev->dev, "doing DMA out.\n");
 
 			/* start dma */
 			dma_enable_irq(CH_SPI);
@@ -796,7 +804,7 @@ static void pump_transfers(unsigned long data)
 		}
 	} else {
 		/* IO mode write then read */
-		pr_debug("doing IO transfer\n");
+		dev_dbg(&drv_data->pdev->dev, "doing IO transfer\n");
 
 		write_STAT(BIT_STAT_CLR);
 
@@ -804,11 +812,11 @@ static void pump_transfers(unsigned long data)
 			/* full duplex mode */
 			BUG_ON((drv_data->tx_end - drv_data->tx) !=
 			       (drv_data->rx_end - drv_data->rx));
-			cr = (read_CTRL() & (~BIT_CTL_TIMOD));	/* clear the TIMOD bits */
-			cr |=
-			    CFG_SPI_WRITE | (width << 8) | (CFG_SPI_ENABLE <<
-							    14);
-			pr_debug("IO duplex: cr is 0x%x\n", cr);
+			cr = (read_CTRL() & (~BIT_CTL_TIMOD));	
+			cr |= CFG_SPI_WRITE | (width << 8) |
+				(CFG_SPI_ENABLE << 14);
+			dev_dbg(&drv_data->pdev->dev,
+				"IO duplex: cr is 0x%x\n", cr);
 
 			write_CTRL(cr);
 			SSYNC();
@@ -819,11 +827,11 @@ static void pump_transfers(unsigned long data)
 				tranf_success = 0;
 		} else if (drv_data->tx != NULL) {
 			/* write only half duplex */
-			cr = (read_CTRL() & (~BIT_CTL_TIMOD));	/* clear the TIMOD bits */
-			cr |=
-			    CFG_SPI_WRITE | (width << 8) | (CFG_SPI_ENABLE <<
-							    14);
-			pr_debug("IO write: cr is 0x%x\n", cr);
+			cr = (read_CTRL() & (~BIT_CTL_TIMOD));
+			cr |= CFG_SPI_WRITE | (width << 8) |
+				(CFG_SPI_ENABLE << 14);
+			dev_dbg(&drv_data->pdev->dev, 
+				"IO write: cr is 0x%x\n", cr);
 
 			write_CTRL(cr);
 			SSYNC();
@@ -834,11 +842,11 @@ static void pump_transfers(unsigned long data)
 				tranf_success = 0;
 		} else if (drv_data->rx != NULL) {
 			/* read only half duplex */
-			cr = (read_CTRL() & (~BIT_CTL_TIMOD));	/* cleare the TIMOD bits */
-			cr |=
-			    CFG_SPI_READ | (width << 8) | (CFG_SPI_ENABLE <<
-							   14);
-			pr_debug("IO read: cr is 0x%x\n", cr);
+			cr = (read_CTRL() & (~BIT_CTL_TIMOD));
+			cr |= CFG_SPI_READ | (width << 8) |
+				(CFG_SPI_ENABLE << 14);
+			dev_dbg(&drv_data->pdev->dev, 
+				"IO read: cr is 0x%x\n", cr);
 
 			write_CTRL(cr);
 			SSYNC();
@@ -849,7 +857,8 @@ static void pump_transfers(unsigned long data)
 		}
 
 		if (!tranf_success) {
-			pr_debug("IO write error!\n");
+			dev_dbg(&drv_data->pdev->dev, 
+				"IO write error!\n");
 			message->state = ERROR_STATE;
 		} else {
 			/* Update total byte transfered */
@@ -899,11 +908,14 @@ static void pump_messages(struct work_struct *work)
 	/* Setup the SSP using the per chip configuration */
 	drv_data->cur_chip = spi_get_ctldata(drv_data->cur_msg->spi);
 	restore_state(drv_data);
-	pr_debug
-	    ("got a message to pump, state is set to: baud %d, flag 0x%x, ctl 0x%x\n",
-	     drv_data->cur_chip->baud, drv_data->cur_chip->flag,
-	     drv_data->cur_chip->ctl_reg);
-	pr_debug("the first transfer len is %d\n", drv_data->cur_transfer->len);
+	dev_dbg(&drv_data->pdev->dev,
+		"got a message to pump, state is set to: baud %d, flag 0x%x, ctl 0x%x\n",
+   		drv_data->cur_chip->baud, drv_data->cur_chip->flag,
+   		drv_data->cur_chip->ctl_reg);
+	
+	dev_dbg(&drv_data->pdev->dev, 
+		"the first transfer len is %d\n",
+		drv_data->cur_transfer->len);
 
 	/* Mark as busy and launch transfers */
 	tasklet_schedule(&drv_data->pump_transfers);
@@ -932,7 +944,7 @@ static int transfer(struct spi_device *spi, struct spi_message *msg)
 	msg->status = -EINPROGRESS;
 	msg->state = START_STATE;
 
-	pr_debug("adding an msg in transfer() \n");
+	dev_dbg(&spi->dev, "adding an msg in transfer() \n");
 	list_add_tail(&msg->queue, &drv_data->queue);
 
 	if (drv_data->run == QUEUE_RUNNING && !drv_data->busy)
@@ -1002,13 +1014,13 @@ static int setup(struct spi_device *spi)
 	if (chip->enable_dma && !dma_requested) {
 		/* register dma irq handler */
 		if (request_dma(CH_SPI, "BF53x_SPI_DMA") < 0) {
-			pr_debug
-			    ("Unable to request BlackFin SPI DMA channel\n");
+			dev_dbg(&spi->dev,
+				"Unable to request BlackFin SPI DMA channel\n");
 			return -ENODEV;
 		}
 		if (set_dma_callback(CH_SPI, (void *)dma_irq_handler, drv_data)
 		    < 0) {
-			pr_debug("Unable to set dma callback\n");
+			dev_dbg(&spi->dev, "Unable to set dma callback\n");
 			return -EPERM;
 		}
 		dma_disable_irq(CH_SPI);
@@ -1054,9 +1066,9 @@ static int setup(struct spi_device *spi)
 		return -ENODEV;
 	}
 
-	pr_debug("setup spi chip %s, width is %d, dma is %d,",
+	dev_dbg(&spi->dev, "setup spi chip %s, width is %d, dma is %d,",
 			spi->modalias, chip->width, chip->enable_dma);
-	pr_debug("ctl_reg is 0x%x, flag_reg is 0x%x\n",
+	dev_dbg(&spi->dev, "ctl_reg is 0x%x, flag_reg is 0x%x\n",
 			chip->ctl_reg, chip->flag);
 
 	spi_set_ctldata(spi, chip);
@@ -1068,7 +1080,7 @@ static int setup(struct spi_device *spi)
  * callback for spi framework.
  * clean driver specific data
  */
-static void cleanup(const struct spi_device *spi)
+static void cleanup(struct spi_device *spi)
 {
 	struct chip_data *chip = spi_get_ctldata((struct spi_device *)spi);
 
@@ -1207,7 +1219,7 @@ static int __init bfin5xx_spi_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "problem registering spi master\n");
 		goto out_error_queue_alloc;
 	}
-	pr_debug("controller probe successfully\n");
+	dev_dbg(&pdev->dev, "controller probe successfully\n");
 	return status;
 
       out_error_queue_alloc:
@@ -1287,27 +1299,23 @@ static int bfin5xx_spi_resume(struct platform_device *pdev)
 #endif				/* CONFIG_PM */
 
 static struct platform_driver bfin5xx_spi_driver = {
-	.driver = {
-		   .name = "bfin-spi-master",
-		   .bus = &platform_bus_type,
-		   .owner = THIS_MODULE,
-		   },
-	.probe = bfin5xx_spi_probe,
-	.remove = __devexit_p(bfin5xx_spi_remove),
-	.suspend = bfin5xx_spi_suspend,
-	.resume = bfin5xx_spi_resume,
+	.driver 	= {
+		.name	= "bfin-spi-master",
+		.owner	= THIS_MODULE,
+	},
+	.suspend	= bfin5xx_spi_suspend,
+	.resume		= bfin5xx_spi_resume,
+	.remove		= __devexit_p(bfin5xx_spi_remove),
 };
 
 static int __init bfin5xx_spi_init(void)
 {
-	return platform_driver_register(&bfin5xx_spi_driver);
+	return platform_driver_probe(&bfin5xx_spi_driver, bfin5xx_spi_probe);
 }
-
 module_init(bfin5xx_spi_init);
 
 static void __exit bfin5xx_spi_exit(void)
 {
 	platform_driver_unregister(&bfin5xx_spi_driver);
 }
-
 module_exit(bfin5xx_spi_exit);
-- 
1.5.1.2

