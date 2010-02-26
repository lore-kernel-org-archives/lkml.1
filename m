Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965608Ab0BZRiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:38:52 -0500
Received: from mail.atmel.fr ([81.80.104.162]:39718 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965594Ab0BZRib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:38:31 -0500
X-Greylist: delayed 620 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Feb 2010 12:37:45 EST
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: akpm@linux-foundation.org, linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       wolfgang.mues@auerswald.de, avictor.za@gmail.com
Subject: [PATCH 3/7] mmc: at91_mci: use one coherent DMA buffer
Date: Fri, 26 Feb 2010 19:39:31 +0100
Message-Id: <eea8ec66963d07c87f4a50c211f7f8b7c2af1df3.1267209149.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <9535dc8dfe4476a0314b9513fb9d37862faa731d.1267209149.git.nicolas.ferre@atmel.com>
References: <9535dc8dfe4476a0314b9513fb9d37862faa731d.1267209149.git.nicolas.ferre@atmel.com>
In-Reply-To: <9535dc8dfe4476a0314b9513fb9d37862faa731d.1267209149.git.nicolas.ferre@atmel.com>
References: <9535dc8dfe4476a0314b9513fb9d37862faa731d.1267209149.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Muees <wolfgang.mues@auerswald.de>

The TX DMA buffer is allocated only once, because the allocation/deallocation
of the buffer for EACH chunk of data is time-consuming and prone to memory
fragmentation.

Using a coherent DMA buffer avoids extra data cache calls.

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>
[nicolas.ferre@atmel.com: coding style modifications]
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/mmc/host/at91_mci.c |   49 +++++++++++++++++++++----------------------
 1 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index f2cb716..fd01195 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -88,6 +88,10 @@
 #define at91_mci_read(host, reg)	__raw_readl((host)->baseaddr + (reg))
 #define at91_mci_write(host, reg, val)	__raw_writel((val), (host)->baseaddr + (reg))
 
+#define MCI_BLKSIZE 		512
+#define MCI_MAXBLKSIZE 		4095
+#define MCI_BLKATONCE 		256
+#define MCI_BUFSIZE 		(MCI_BLKSIZE * MCI_BLKATONCE)
 
 /*
  * Low level type for this driver
@@ -604,7 +608,6 @@ static void at91_mci_send_command(struct at91mci_host *host, struct mmc_command
 				/*
 				 * Handle a read
 				 */
-				host->buffer = NULL;
 				host->total_length = 0;
 
 				at91_mci_pre_dma_read(host);
@@ -623,20 +626,8 @@ static void at91_mci_send_command(struct at91mci_host *host, struct mmc_command
 					if (host->total_length < 12)
 						host->total_length = 12;
 
-				host->buffer = kmalloc(host->total_length, GFP_KERNEL);
-				if (!host->buffer) {
-					pr_debug("Can't alloc tx buffer\n");
-					cmd->error = -ENOMEM;
-					mmc_request_done(host->mmc, host->request);
-					return;
-				}
-
 				at91_mci_sg_to_dma(host, data);
 
-				host->physical_address = dma_map_single(NULL,
-						host->buffer, host->total_length,
-						DMA_TO_DEVICE);
-
 				pr_debug("Transmitting %d bytes\n", host->total_length);
 
 				at91_mci_write(host, ATMEL_PDC_TPR, host->physical_address);
@@ -703,14 +694,6 @@ static void at91_mci_completed_command(struct at91mci_host *host, unsigned int s
 	cmd->resp[2] = at91_mci_read(host, AT91_MCI_RSPR(2));
 	cmd->resp[3] = at91_mci_read(host, AT91_MCI_RSPR(3));
 
-	if (host->buffer) {
-		dma_unmap_single(NULL,
-				host->physical_address, host->total_length,
-				DMA_TO_DEVICE);
-		kfree(host->buffer);
-		host->buffer = NULL;
-	}
-
 	pr_debug("Status = %08X/%08x [%08X %08X %08X %08X]\n",
 		 status, at91_mci_read(host, AT91_MCI_SR),
 		 cmd->resp[0], cmd->resp[1], cmd->resp[2], cmd->resp[3]);
@@ -1012,12 +995,12 @@ static int __init at91_mci_probe(struct platform_device *pdev)
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
 	mmc->caps = MMC_CAP_SDIO_IRQ;
 
-	mmc->max_blk_size = 4095;
-	mmc->max_blk_count = mmc->max_req_size;
+	mmc->max_blk_size  = MCI_MAXBLKSIZE;
+	mmc->max_blk_count = MCI_BLKATONCE;
+	mmc->max_req_size  = MCI_BUFSIZE;
 
 	host = mmc_priv(mmc);
 	host->mmc = mmc;
-	host->buffer = NULL;
 	host->bus_mode = 0;
 	host->board = pdev->dev.platform_data;
 	if (host->board->wire4) {
@@ -1028,6 +1011,14 @@ static int __init at91_mci_probe(struct platform_device *pdev)
 				" - using 1 wire\n");
 	}
 
+	host->buffer = dma_alloc_coherent(&pdev->dev, MCI_BUFSIZE,
+					&host->physical_address, GFP_KERNEL);
+	if (!host->buffer) {
+		ret = -ENOMEM;
+		dev_err(&pdev->dev, "Can't allocate transmit buffer\n");
+		goto fail5;
+	}
+
 	/*
 	 * Reserve GPIOs ... board init code makes sure these pins are set
 	 * up as GPIOs with the right direction (input, except for vcc)
@@ -1036,7 +1027,7 @@ static int __init at91_mci_probe(struct platform_device *pdev)
 		ret = gpio_request(host->board->det_pin, "mmc_detect");
 		if (ret < 0) {
 			dev_dbg(&pdev->dev, "couldn't claim card detect pin\n");
-			goto fail5;
+			goto fail4b;
 		}
 	}
 	if (host->board->wp_pin) {
@@ -1136,6 +1127,10 @@ fail3:
 fail4:
 	if (host->board->det_pin)
 		gpio_free(host->board->det_pin);
+fail4b:
+	if (host->buffer)
+		dma_free_coherent(&pdev->dev, MCI_BUFSIZE,
+				host->buffer, host->physical_address);
 fail5:
 	mmc_free_host(mmc);
 fail6:
@@ -1158,6 +1153,10 @@ static int __exit at91_mci_remove(struct platform_device *pdev)
 
 	host = mmc_priv(mmc);
 
+	if (host->buffer)
+		dma_free_coherent(&pdev->dev, MCI_BUFSIZE,
+				host->buffer, host->physical_address);
+
 	if (host->board->det_pin) {
 		if (device_can_wakeup(&pdev->dev))
 			free_irq(gpio_to_irq(host->board->det_pin), host);
-- 
1.5.6.5

