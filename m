Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164Ab0BXOEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 09:04:20 -0500
Received: from mx1.auerswald.de ([212.185.163.234]:37464 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755991Ab0BXOES convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 09:04:18 -0500
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Feb 2010 09:04:18 EST
From: Wolfgang =?iso-8859-15?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald Gesellschaft =?iso-8859-15?q?f=FCr_Datensysteme?= mbH
To: Andrew Victor <linux@maxim.org.za>
Subject: [PATCH] Bugfixing and improvement of the AT91 MCI driver
Date: Wed, 24 Feb 2010 14:53:56 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201002241453.56191.wolfgang.mues@auerswald.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

as we are working on a project regarding AT91SAM9260 and using the 
MCI interface for SD/SDHC data transfer, we are forced to make a
series of bugfixes and improvements to the AT91 MCI driver:

- Fix a buf in the dmabuf pointer calculation.
- Use a fixed DMA buffer instead of allocating a DMA buffer
  each time a data transfer is requested.
- Fix address error in kunmap_atomic().
- Use the dma buffer also for reads, because we found
  that double buffering PDC was NOT working, and we need
  a solution which allows bigger stream sizes.
- Use dmac_flush_range() because flush_dcache_page()
  was not OK if more than one page is transferred.
- Extend card timeout to 2s because some cards need it.
- Extend card detect time to 500ms (usefull if the user
  is inserting the card gentle into the slot).
- Fill in the mmc->max_ variables to allow the IO elevator
  to do the job. Without these variables filled in,
  each IO transfer is limited to 4096 bytes, which is limiting
  transfer speed and - most important - is triggering
  ACCELLERATED WEAR-OUT of the flash sectors of the card
  (because the card has to do a lot of partial sector
   erases).

We have tested this driver which a lot of SD and SDHC cards
and we think the driver is ready for production use now.

For reads, we get about 90% of the expected maximum calculated
speed (from the clock frequency). For writes, we get about 50%.

As we are using a slightly older kernel, I have ported this
patch to latest 2.6.33 by hand. So please take care to compile
and look for compile-time errors. I've done my very best.

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>

---

diff -ur linux-2.6.33-rc8-original/drivers/mmc/host/at91_mci.c linux-2.6.33-rc8-at91/drivers/mmc/host/at91_mci.c
--- linux-2.6.33-rc8-original/drivers/mmc/host/at91_mci.c	2010-02-12 20:07:45.000000000 +0100
+++ linux-2.6.33-rc8-at91/drivers/mmc/host/at91_mci.c	2010-02-24 14:21:46.838590913 +0100
@@ -88,6 +88,10 @@
 #define at91_mci_read(host, reg)	__raw_readl((host)->baseaddr + (reg))
 #define at91_mci_write(host, reg, val)	__raw_writel((val), (host)->baseaddr + (reg))
 
+#define MCI_BLKSIZE 		512
+#define MCI_MAXBLKSIZE 		4095
+#define MCI_BLKATONCE 		256
+#define MCI_BUFSIZE 		(MCI_BLKSIZE * MCI_BLKATONCE)
 
 /*
  * Low level type for this driver
@@ -227,11 +231,13 @@
 			for (index = 0; index < (amount / 4); index++)
 				*dmabuf++ = swab32(sgbuffer[index]);
 		} else {
-			memcpy(dmabuf, sgbuffer, amount);
-			dmabuf += amount;
+			char *tmpv = (char *)dmabuf;
+			memcpy(tmpv, sgbuffer, amount);
+			tmpv += amount;
+			dmabuf = (unsigned *)tmpv;
 		}
 
-		kunmap_atomic(sgbuffer, KM_BIO_SRC_IRQ);
+		kunmap_atomic(((void*)sgbuffer)-sg->offset, KM_BIO_SRC_IRQ);
 
 		if (size == 0)
 			break;
@@ -245,80 +251,14 @@
 }
 
 /*
- * Prepare a dma read
- */
-static void at91_mci_pre_dma_read(struct at91mci_host *host)
-{
-	int i;
-	struct scatterlist *sg;
-	struct mmc_command *cmd;
-	struct mmc_data *data;
-
-	pr_debug("pre dma read\n");
-
-	cmd = host->cmd;
-	if (!cmd) {
-		pr_debug("no command\n");
-		return;
-	}
-
-	data = cmd->data;
-	if (!data) {
-		pr_debug("no data\n");
-		return;
-	}
-
-	for (i = 0; i < 2; i++) {
-		/* nothing left to transfer */
-		if (host->transfer_index >= data->sg_len) {
-			pr_debug("Nothing left to transfer (index = %d)\n", host->transfer_index);
-			break;
-		}
-
-		/* Check to see if this needs filling */
-		if (i == 0) {
-			if (at91_mci_read(host, ATMEL_PDC_RCR) != 0) {
-				pr_debug("Transfer active in current\n");
-				continue;
-			}
-		}
-		else {
-			if (at91_mci_read(host, ATMEL_PDC_RNCR) != 0) {
-				pr_debug("Transfer active in next\n");
-				continue;
-			}
-		}
-
-		/* Setup the next transfer */
-		pr_debug("Using transfer index %d\n", host->transfer_index);
-
-		sg = &data->sg[host->transfer_index++];
-		pr_debug("sg = %p\n", sg);
-
-		sg->dma_address = dma_map_page(NULL, sg_page(sg), sg->offset, sg->length, DMA_FROM_DEVICE);
-
-		pr_debug("dma address = %08X, length = %d\n", sg->dma_address, sg->length);
-
-		if (i == 0) {
-			at91_mci_write(host, ATMEL_PDC_RPR, sg->dma_address);
-			at91_mci_write(host, ATMEL_PDC_RCR, (data->blksz & 0x3) ? sg->length : sg->length / 4);
-		}
-		else {
-			at91_mci_write(host, ATMEL_PDC_RNPR, sg->dma_address);
-			at91_mci_write(host, ATMEL_PDC_RNCR, (data->blksz & 0x3) ? sg->length : sg->length / 4);
-		}
-	}
-
-	pr_debug("pre dma read done\n");
-}
-
-/*
  * Handle after a dma read
  */
 static void at91_mci_post_dma_read(struct at91mci_host *host)
 {
 	struct mmc_command *cmd;
 	struct mmc_data *data;
+	unsigned int len, i, size;
+	unsigned *dmabuf = host->buffer;
 
 	pr_debug("post dma read\n");
 
@@ -334,42 +274,40 @@
 		return;
 	}
 
-	while (host->in_use_index < host->transfer_index) {
-		struct scatterlist *sg;
-
-		pr_debug("finishing index %d\n", host->in_use_index);
-
-		sg = &data->sg[host->in_use_index++];
+	size = data->blksz * data->blocks;
+	len = data->sg_len;
+ 
+	at91_mci_write(host, AT91_MCI_IDR, AT91_MCI_ENDRX);
+	at91_mci_write(host, AT91_MCI_IER, AT91_MCI_RXBUFF);
 
-		pr_debug("Unmapping page %08X\n", sg->dma_address);
+	for (i = 0; i < len; i++) {
+		struct scatterlist *sg;
+		int amount;
+		unsigned int *sgbuffer;
 
-		dma_unmap_page(NULL, sg->dma_address, sg->length, DMA_FROM_DEVICE);
+		sg = &data->sg[i];
 
+		sgbuffer = kmap_atomic(sg_page(sg), KM_BIO_SRC_IRQ) + sg->offset;
+		amount = min(size, sg->length);
+		size -= amount;
+ 
 		if (cpu_is_at91rm9200()) {	/* AT91RM9200 errata */
-			unsigned int *buffer;
-			int index;
-
-			/* Swap the contents of the buffer */
-			buffer = kmap_atomic(sg_page(sg), KM_BIO_SRC_IRQ) + sg->offset;
-			pr_debug("buffer = %p, length = %d\n", buffer, sg->length);
-
-			for (index = 0; index < (sg->length / 4); index++)
-				buffer[index] = swab32(buffer[index]);
 
-			kunmap_atomic(buffer, KM_BIO_SRC_IRQ);
+			int index;
+			for (index = 0; index < (amount / 4); index++)
+				sgbuffer[index] = swab32(*dmabuf++);
+		} else {
+			char *tmpv = (char *)dmabuf;
+			memcpy(sgbuffer, tmpv, amount);
+			tmpv += amount;
+			dmabuf = (unsigned *)tmpv;
 		}
 
-		flush_dcache_page(sg_page(sg));
-
-		data->bytes_xfered += sg->length;
-	}
-
-	/* Is there another transfer to trigger? */
-	if (host->transfer_index < data->sg_len)
-		at91_mci_pre_dma_read(host);
-	else {
-		at91_mci_write(host, AT91_MCI_IDR, AT91_MCI_ENDRX);
-		at91_mci_write(host, AT91_MCI_IER, AT91_MCI_RXBUFF);
+		kunmap_atomic(((void*)sgbuffer)-sg->offset, KM_BIO_SRC_IRQ);
+		dmac_flush_range ((void*)sgbuffer, ((void*)sgbuffer)+amount);
+		data->bytes_xfered += amount;
+		if (size == 0)
+			break;
 	}
 
 	pr_debug("post dma read done\n");
@@ -602,10 +540,14 @@
 				/*
 				 * Handle a read
 				 */
-				host->buffer = NULL;
 				host->total_length = 0;
 
-				at91_mci_pre_dma_read(host);
+				at91_mci_write(host, ATMEL_PDC_RPR, host->physical_address);
+				at91_mci_write(host, ATMEL_PDC_RCR, (data->blksz & 0x3) ? 
+					(blocks * block_length) : (blocks * block_length) / 4);
+				at91_mci_write(host, ATMEL_PDC_RNPR, 0);
+				at91_mci_write(host, ATMEL_PDC_RNCR, 0);
+
 				ier = AT91_MCI_ENDRX /* | AT91_MCI_RXBUFF */;
 			}
 			else {
@@ -621,20 +563,8 @@
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
@@ -701,14 +631,6 @@
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
@@ -754,7 +676,8 @@
 	host->request = mrq;
 	host->flags = 0;
 
-	mod_timer(&host->timer, jiffies +  HZ);
+	/* more than 1s timeout seen with takeMS sdhc cards */
+	mod_timer(&host->timer, jiffies +  2 * HZ);
 
 	at91_mci_process_next(host);
 }
@@ -942,7 +865,8 @@
 			pr_debug("****** Resetting SD-card bus width ******\n");
 			at91_mci_write(host, AT91_MCI_SDCR, at91_mci_read(host, AT91_MCI_SDCR) & ~AT91_MCI_SDCBUS);
 		}
-		mmc_detect_change(host->mmc, msecs_to_jiffies(100));
+		/* 0.5s is needed here because of early switch firing. */
+		mmc_detect_change(host->mmc, msecs_to_jiffies(500));
 	}
 	return IRQ_HANDLED;
 }
@@ -1008,12 +932,15 @@
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
 	mmc->caps = MMC_CAP_SDIO_IRQ;
 
-	mmc->max_blk_size = 4095;
-	mmc->max_blk_count = mmc->max_req_size;
+	mmc->max_blk_size  = MCI_MAXBLKSIZE; 
+	mmc->max_blk_count = MCI_BLKATONCE;
+	mmc->max_phys_segs = MCI_BLKATONCE;
+	mmc->max_hw_segs   = MCI_BLKATONCE;
+	mmc->max_req_size  = MCI_BUFSIZE;
+	mmc->max_seg_size  = MCI_BUFSIZE; 
 
 	host = mmc_priv(mmc);
 	host->mmc = mmc;
-	host->buffer = NULL;
 	host->bus_mode = 0;
 	host->board = pdev->dev.platform_data;
 	if (host->board->wire4) {
@@ -1024,6 +951,13 @@
 				" - using 1 wire\n");
 	}
 
+	host->buffer = dma_alloc_coherent(&pdev->dev, MCI_BUFSIZE, &host->physical_address, GFP_KERNEL);
+	if (!host->buffer){
+		ret = -ENOMEM;
+		dev_err(&pdev->dev, "Can't allocate transmit buffer\n");
+		goto fail5;
+	}
+
 	/*
 	 * Reserve GPIOs ... board init code makes sure these pins are set
 	 * up as GPIOs with the right direction (input, except for vcc)
@@ -1032,7 +966,7 @@
 		ret = gpio_request(host->board->det_pin, "mmc_detect");
 		if (ret < 0) {
 			dev_dbg(&pdev->dev, "couldn't claim card detect pin\n");
-			goto fail5;
+			goto fail4b;
 		}
 	}
 	if (host->board->wp_pin) {
@@ -1132,6 +1066,9 @@
 fail4:
 	if (host->board->det_pin)
 		gpio_free(host->board->det_pin);
+fail4b:
+	if (host->buffer)
+		dma_free_coherent (&pdev->dev, MCI_BUFSIZE, host->buffer, host->physical_address);
 fail5:
 	mmc_free_host(mmc);
 fail6:
@@ -1154,6 +1091,9 @@
 
 	host = mmc_priv(mmc);
 
+	if (host->buffer)
+		dma_free_coherent (&pdev->dev, MCI_BUFSIZE, host->buffer, host->physical_address);
+
 	if (host->board->det_pin) {
 		if (device_can_wakeup(&pdev->dev))
 			free_irq(gpio_to_irq(host->board->det_pin), host);

---
best regards
 
i. A. Wolfgang Mües
-- 
Auerswald Gesellschaft für Datensysteme mbH
Hardware Development
Telefon: +49 (0)5306 9219 562
Telefax: +49 (0)5306 9219 94 
E-Mail: Wolfgang.Mues@Auerswald.de
Web: http://www.auerswald.de
 
--------------------------------------------------------------
Auerswald Gesellschaft für Datensysteme mbH
Vor den Grashöfen 1, 38162 Cremlingen
Registriert beim AG Braunschweig HRB 7499
Geschäftsführer: Dipl-Ing. Gerhard Auerswald
