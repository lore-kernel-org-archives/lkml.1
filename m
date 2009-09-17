Return-Path: <linux-kernel-owner+w=401wt.eu-S1754387AbZIQXsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbZIQXsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 19:48:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbZIQXsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 19:48:00 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:59114 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbZIQXry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 19:47:54 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: spi-devel-general@lists.sourceforge.net,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Yi Li <yi.li@analog.com>
Subject: [PATCH 5/5] Blackfin SPI: clean up error handling in client setup
Date: Thu, 17 Sep 2009 19:47:53 -0400
Message-Id: <1253231273-16423-5-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <1253231273-16423-1-git-send-email-vapier@gentoo.org>
References: <1253231273-16423-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yi Li <yi.li@analog.com>

Make sure we don't leak peripheral/gpio resources when an error occurs
during setup, and make sure we don't call kfree() twice on the same
object.  Also add/fix some error messages in the process.

Signed-off-by: Yi Li <yi.li@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/spi/spi_bfin5xx.c |   33 ++++++++++++++++++++++++++-------
 1 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index a8fc922..0dcc2ca 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -1118,8 +1118,10 @@ static int bfin_spi_setup(struct spi_device *spi)
 	chip = spi_get_ctldata(spi);
 	if (chip == NULL) {
 		chip = kzalloc(sizeof(*chip), GFP_KERNEL);
-		if (!chip)
+		if (!chip) {
+			dev_err(&spi->dev, "cannot allocate chip data\n");
 			return -ENOMEM;
+		}
 
 		chip->enable_dma = 0;
 		chip_info = spi->controller_data;
@@ -1210,7 +1212,7 @@ static int bfin_spi_setup(struct spi_device *spi)
 		/* register dma irq handler */
 		ret = request_dma(drv_data->dma_channel, "BFIN_SPI_DMA");
 		if (ret) {
-			dev_dbg(&spi->dev,
+			dev_err(&spi->dev,
 				"Unable to request BlackFin SPI DMA channel\n");
 			goto error;
 		}
@@ -1219,7 +1221,7 @@ static int bfin_spi_setup(struct spi_device *spi)
 		ret = set_dma_callback(drv_data->dma_channel,
 			bfin_spi_dma_irq_handler, drv_data);
 		if (ret) {
-			dev_dbg(&spi->dev, "Unable to set dma callback\n");
+			dev_err(&spi->dev, "Unable to set dma callback\n");
 			goto error;
 		}
 		dma_disable_irq(drv_data->dma_channel);
@@ -1229,7 +1231,7 @@ static int bfin_spi_setup(struct spi_device *spi)
 		ret = request_irq(drv_data->spi_irq, bfin_spi_pio_irq_handler,
 			IRQF_DISABLED, "BFIN_SPI", drv_data);
 		if (ret) {
-			printk(KERN_NOTICE "Unable to register spi IRQ\n");
+			dev_err(&spi->dev, "Unable to register spi IRQ\n");
 			goto error;
 		}
 		drv_data->irq_requested = 1;
@@ -1239,8 +1241,10 @@ static int bfin_spi_setup(struct spi_device *spi)
 
 	if (chip->chip_select_num == 0) {
 		ret = gpio_request(chip->cs_gpio, spi->modalias);
-		if (ret)
+		if (ret) {
+			dev_err(&spi->dev, "gpio_request() error\n");
 			goto error;
+		}
 		gpio_direction_output(chip->cs_gpio, 1);
 	}
 
@@ -1256,8 +1260,10 @@ static int bfin_spi_setup(struct spi_device *spi)
 	    chip->chip_select_num <= spi->master->num_chipselect) {
 		ret = peripheral_request(ssel[spi->master->bus_num]
 		                         [chip->chip_select_num-1], spi->modalias);
-		if (ret)
+		if (ret) {
+			dev_err(&spi->dev, "peripheral_request() error\n");
 			goto error;
+		}
 	}
 
 	bfin_spi_cs_deactive(drv_data, chip);
@@ -1265,10 +1271,21 @@ static int bfin_spi_setup(struct spi_device *spi)
 
  error:
 	if (ret) {
-		kfree(chip);
 		if (drv_data->dma_requested)
 			free_dma(drv_data->dma_channel);
 		drv_data->dma_requested = 0;
+
+		if ((chip->chip_select_num > 0)
+			&& (chip->chip_select_num <= spi->master->num_chipselect))
+			peripheral_free(ssel[spi->master->bus_num]
+						[chip->chip_select_num-1]);
+
+		if (chip->chip_select_num == 0)
+			gpio_free(chip->cs_gpio);
+
+		kfree(chip);
+		/* prevent free 'chip' twice */
+		spi_set_ctldata(spi, NULL);
 	}
 
 	return ret;
@@ -1294,6 +1311,8 @@ static void bfin_spi_cleanup(struct spi_device *spi)
 		gpio_free(chip->cs_gpio);
 
 	kfree(chip);
+	/* prevent free 'chip' twice */
+	spi_set_ctldata(spi, NULL);
 }
 
 static inline int bfin_spi_init_queue(struct driver_data *drv_data)
-- 
1.6.5.rc1

