Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbZIQXsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbZIQXsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 19:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbZIQXsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 19:48:03 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:59109 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995AbZIQXry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 19:47:54 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: spi-devel-general@lists.sourceforge.net,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Yi Li <yi.li@analog.com>
Subject: [PATCH 4/5] Blackfin SPI: utilize the SPI interrupt in PIO mode
Date: Thu, 17 Sep 2009 19:47:52 -0400
Message-Id: <1253231273-16423-4-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <1253231273-16423-1-git-send-email-vapier@gentoo.org>
References: <1253231273-16423-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yi Li <yi.li@analog.com>

The current behavior in PIO mode is to poll the SPI status registers which
can obviously lead to higher latencies when doing a lot of SPI traffic.
There is a SPI interrupt which can be used instead to signal individual
completion of transactions.

Signed-off-by: Yi Li <yi.li@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/spi/spi_bfin5xx.c |  235 +++++++++++++++++++++++++++++++++++----------
 1 files changed, 185 insertions(+), 50 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 3249c5d..a8fc922 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -91,6 +91,9 @@ struct driver_data {
 	dma_addr_t rx_dma;
 	dma_addr_t tx_dma;
 
+	int irq_requested;
+	int spi_irq;
+
 	size_t rx_map_len;
 	size_t tx_map_len;
 	u8 n_bytes;
@@ -114,6 +117,7 @@ struct chip_data {
 	u16 cs_chg_udelay;	/* Some devices require > 255usec delay */
 	u32 cs_gpio;
 	u16 idle_tx_val;
+	u8 pio_interrupt;	/* use spi data irq */
 	void (*write) (struct driver_data *);
 	void (*read) (struct driver_data *);
 	void (*duplex) (struct driver_data *);
@@ -524,6 +528,79 @@ static void bfin_spi_giveback(struct driver_data *drv_data)
 		msg->complete(msg->context);
 }
 
+/* spi data irq handler */
+static irqreturn_t bfin_spi_pio_irq_handler(int irq, void *dev_id)
+{
+	struct driver_data *drv_data = dev_id;
+	struct chip_data *chip = drv_data->cur_chip;
+	struct spi_message *msg = drv_data->cur_msg;
+	int n_bytes = drv_data->n_bytes;
+
+	/* wait until transfer finished. */
+	while (!(read_STAT(drv_data) & BIT_STAT_RXS))
+		cpu_relax();
+
+	if ((drv_data->tx && drv_data->tx >= drv_data->tx_end) ||
+		(drv_data->rx && drv_data->rx >= (drv_data->rx_end - n_bytes))) {
+		/* last read */
+		if (drv_data->rx) {
+			dev_dbg(&drv_data->pdev->dev, "last read\n");
+			if (n_bytes == 2)
+				*(u16 *) (drv_data->rx) = read_RDBR(drv_data);
+			else if (n_bytes == 1)
+				*(u8 *) (drv_data->rx) = read_RDBR(drv_data);
+			drv_data->rx += n_bytes;
+		}
+
+		msg->actual_length += drv_data->len_in_bytes;
+		if (drv_data->cs_change)
+			bfin_spi_cs_deactive(drv_data, chip);
+		/* Move to next transfer */
+		msg->state = bfin_spi_next_transfer(drv_data);
+
+		disable_irq(drv_data->spi_irq);
+
+		/* Schedule transfer tasklet */
+		tasklet_schedule(&drv_data->pump_transfers);
+		return IRQ_HANDLED;
+	}
+
+	if (drv_data->rx && drv_data->tx) {
+		/* duplex */
+		dev_dbg(&drv_data->pdev->dev, "duplex: write_TDBR\n");
+		if (drv_data->n_bytes == 2) {
+			*(u16 *) (drv_data->rx) = read_RDBR(drv_data);
+			write_TDBR(drv_data, (*(u16 *) (drv_data->tx)));
+		} else if (drv_data->n_bytes == 1) {
+			*(u8 *) (drv_data->rx) = read_RDBR(drv_data);
+			write_TDBR(drv_data, (*(u8 *) (drv_data->tx)));
+		}
+	} else if (drv_data->rx) {
+		/* read */
+		dev_dbg(&drv_data->pdev->dev, "read: write_TDBR\n");
+		if (drv_data->n_bytes == 2)
+			*(u16 *) (drv_data->rx) = read_RDBR(drv_data);
+		else if (drv_data->n_bytes == 1)
+			*(u8 *) (drv_data->rx) = read_RDBR(drv_data);
+		write_TDBR(drv_data, chip->idle_tx_val);
+	} else if (drv_data->tx) {
+		/* write */
+		dev_dbg(&drv_data->pdev->dev, "write: write_TDBR\n");
+		bfin_spi_dummy_read(drv_data);
+		if (drv_data->n_bytes == 2)
+			write_TDBR(drv_data, (*(u16 *) (drv_data->tx)));
+		else if (drv_data->n_bytes == 1)
+			write_TDBR(drv_data, (*(u8 *) (drv_data->tx)));
+	}
+
+	if (drv_data->tx)
+		drv_data->tx += n_bytes;
+	if (drv_data->rx)
+		drv_data->rx += n_bytes;
+
+	return IRQ_HANDLED;
+}
+
 static irqreturn_t bfin_spi_dma_irq_handler(int irq, void *dev_id)
 {
 	struct driver_data *drv_data = dev_id;
@@ -699,6 +776,7 @@ static void bfin_spi_pump_transfers(unsigned long data)
 
 	default:
 		/* No change, the same as default setting */
+		transfer->bits_per_word = chip->bits_per_word;
 		drv_data->n_bytes = chip->n_bytes;
 		width = chip->width;
 		drv_data->write = drv_data->tx ? chip->write : bfin_spi_null_writer;
@@ -841,60 +919,86 @@ static void bfin_spi_pump_transfers(unsigned long data)
 		dma_enable_irq(drv_data->dma_channel);
 		local_irq_restore(flags);
 
-	} else {
-		/* IO mode write then read */
-		dev_dbg(&drv_data->pdev->dev, "doing IO transfer\n");
+		return;
+	}
 
-		/* we always use SPI_WRITE mode. SPI_READ mode
-		   seems to have problems with setting up the
-		   output value in TDBR prior to the transfer. */
+	if (chip->pio_interrupt) {
+		/* use write mode. spi irq should have been disabled */
+		cr = (read_CTRL(drv_data) & (~BIT_CTL_TIMOD));
 		write_CTRL(drv_data, (cr | CFG_SPI_WRITE));
 
-		if (full_duplex) {
-			/* full duplex mode */
-			BUG_ON((drv_data->tx_end - drv_data->tx) !=
-			       (drv_data->rx_end - drv_data->rx));
-			dev_dbg(&drv_data->pdev->dev,
-				"IO duplex: cr is 0x%x\n", cr);
-
-			drv_data->duplex(drv_data);
-
-			if (drv_data->tx != drv_data->tx_end)
-				tranf_success = 0;
-		} else if (drv_data->tx != NULL) {
-			/* write only half duplex */
-			dev_dbg(&drv_data->pdev->dev,
-				"IO write: cr is 0x%x\n", cr);
+		/* discard old RX data and clear RXS */
+		bfin_spi_dummy_read(drv_data);
 
-			drv_data->write(drv_data);
+		/* start transfer */
+		if (drv_data->tx == NULL)
+			write_TDBR(drv_data, chip->idle_tx_val);
+		else {
+			if (transfer->bits_per_word == 8)
+				write_TDBR(drv_data, (*(u8 *) (drv_data->tx)));
+			else if (transfer->bits_per_word == 16)
+				write_TDBR(drv_data, (*(u16 *) (drv_data->tx)));
+			drv_data->tx += drv_data->n_bytes;
+		}
 
-			if (drv_data->tx != drv_data->tx_end)
-				tranf_success = 0;
-		} else if (drv_data->rx != NULL) {
-			/* read only half duplex */
-			dev_dbg(&drv_data->pdev->dev,
-				"IO read: cr is 0x%x\n", cr);
+		/* once TDBR is empty, interrupt is triggered */
+		enable_irq(drv_data->spi_irq);
+		return;
+	}
 
-			drv_data->read(drv_data);
-			if (drv_data->rx != drv_data->rx_end)
-				tranf_success = 0;
-		}
+	/* IO mode */
+	dev_dbg(&drv_data->pdev->dev, "doing IO transfer\n");
+
+	/* we always use SPI_WRITE mode. SPI_READ mode
+	   seems to have problems with setting up the
+	   output value in TDBR prior to the transfer. */
+	write_CTRL(drv_data, (cr | CFG_SPI_WRITE));
+
+	if (full_duplex) {
+		/* full duplex mode */
+		BUG_ON((drv_data->tx_end - drv_data->tx) !=
+		       (drv_data->rx_end - drv_data->rx));
+		dev_dbg(&drv_data->pdev->dev,
+			"IO duplex: cr is 0x%x\n", cr);
+
+		drv_data->duplex(drv_data);
+
+		if (drv_data->tx != drv_data->tx_end)
+			tranf_success = 0;
+	} else if (drv_data->tx != NULL) {
+		/* write only half duplex */
+		dev_dbg(&drv_data->pdev->dev,
+			"IO write: cr is 0x%x\n", cr);
+
+		drv_data->write(drv_data);
+
+		if (drv_data->tx != drv_data->tx_end)
+			tranf_success = 0;
+	} else if (drv_data->rx != NULL) {
+		/* read only half duplex */
+		dev_dbg(&drv_data->pdev->dev,
+			"IO read: cr is 0x%x\n", cr);
+
+		drv_data->read(drv_data);
+		if (drv_data->rx != drv_data->rx_end)
+			tranf_success = 0;
+	}
 
-		if (!tranf_success) {
-			dev_dbg(&drv_data->pdev->dev,
-				"IO write error!\n");
-			message->state = ERROR_STATE;
-		} else {
-			/* Update total byte transfered */
-			message->actual_length += drv_data->len_in_bytes;
-			/* Move to next transfer of this msg */
-			message->state = bfin_spi_next_transfer(drv_data);
-			if (drv_data->cs_change)
-				bfin_spi_cs_deactive(drv_data, chip);
-		}
-		/* Schedule next transfer tasklet */
-		tasklet_schedule(&drv_data->pump_transfers);
+	if (!tranf_success) {
+		dev_dbg(&drv_data->pdev->dev,
+			"IO write error!\n");
+		message->state = ERROR_STATE;
+	} else {
+		/* Update total byte transfered */
+		message->actual_length += drv_data->len_in_bytes;
+		/* Move to next transfer of this msg */
+		message->state = bfin_spi_next_transfer(drv_data);
+		if (drv_data->cs_change)
+			bfin_spi_cs_deactive(drv_data, chip);
 	}
+
+	/* Schedule next transfer tasklet */
+	tasklet_schedule(&drv_data->pump_transfers);
 }
 
 /* pop a msg from queue and kick off real transfer */
@@ -1043,6 +1147,7 @@ static int bfin_spi_setup(struct spi_device *spi)
 		chip->cs_chg_udelay = chip_info->cs_chg_udelay;
 		chip->cs_gpio = chip_info->cs_gpio;
 		chip->idle_tx_val = chip_info->idle_tx_val;
+		chip->pio_interrupt = chip_info->pio_interrupt;
 	}
 
 	/* translate common spi framework into our register */
@@ -1092,6 +1197,11 @@ static int bfin_spi_setup(struct spi_device *spi)
 		goto error;
 	}
 
+	if (chip->enable_dma && chip->pio_interrupt) {
+		dev_err(&spi->dev, "enable_dma is set, "
+				"do not set pio_interrupt\n");
+		goto error;
+	}
 	/*
 	 * if any one SPI chip is registered and wants DMA, request the
 	 * DMA channel for it
@@ -1115,6 +1225,18 @@ static int bfin_spi_setup(struct spi_device *spi)
 		dma_disable_irq(drv_data->dma_channel);
 	}
 
+	if (chip->pio_interrupt && !drv_data->irq_requested) {
+		ret = request_irq(drv_data->spi_irq, bfin_spi_pio_irq_handler,
+			IRQF_DISABLED, "BFIN_SPI", drv_data);
+		if (ret) {
+			printk(KERN_NOTICE "Unable to register spi IRQ\n");
+			goto error;
+		}
+		drv_data->irq_requested = 1;
+		/* we use write mode, spi irq has to be disabled here */
+		disable_irq(drv_data->spi_irq);
+	}
+
 	if (chip->chip_select_num == 0) {
 		ret = gpio_request(chip->cs_gpio, spi->modalias);
 		if (ret)
@@ -1308,11 +1430,19 @@ static int __init bfin_spi_probe(struct platform_device *pdev)
 		goto out_error_ioremap;
 	}
 
-	drv_data->dma_channel = platform_get_irq(pdev, 0);
-	if (drv_data->dma_channel < 0) {
+	res = platform_get_resource(pdev, IORESOURCE_DMA, 0);
+	if (res == NULL) {
 		dev_err(dev, "No DMA channel specified\n");
 		status = -ENOENT;
-		goto out_error_no_dma_ch;
+		goto out_error_free_io;
+	}
+	drv_data->dma_channel = res->start;
+
+	drv_data->spi_irq = platform_get_irq(pdev, 0);
+	if (drv_data->spi_irq < 0) {
+		dev_err(dev, "No spi pio irq specified\n");
+		status = -ENOENT;
+		goto out_error_free_io;
 	}
 
 	/* Initial and start queue */
@@ -1355,7 +1485,7 @@ static int __init bfin_spi_probe(struct platform_device *pdev)
 
 out_error_queue_alloc:
 	bfin_spi_destroy_queue(drv_data);
-out_error_no_dma_ch:
+out_error_free_io:
 	iounmap((void *) drv_data->regs_base);
 out_error_ioremap:
 out_error_get_res:
@@ -1387,6 +1517,11 @@ static int __devexit bfin_spi_remove(struct platform_device *pdev)
 			free_dma(drv_data->dma_channel);
 	}
 
+	if (drv_data->irq_requested) {
+		free_irq(drv_data->spi_irq, drv_data);
+		drv_data->irq_requested = 0;
+	}
+
 	/* Disconnect from the SPI framework */
 	spi_unregister_master(drv_data->master);
 
-- 
1.6.5.rc1

