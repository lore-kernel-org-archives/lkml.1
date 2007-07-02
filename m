Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbXGBMSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbXGBMSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 08:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbXGBMSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 08:18:32 -0400
Received: from mail.atmel.fr ([81.80.104.162]:37202 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbXGBMSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 08:18:30 -0400
Message-ID: <4688EC94.1090901@rfo.atmel.com>
Date: Mon, 02 Jul 2007 14:16:20 +0200
From: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Organization: atmel
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <andrew@sanpeople.com>, Andreas Beier <mughat@gmail.com>,
       Hamish Guthrie <hamish@prodigi.ch>, Marc Pignat <marc.pignat@hevs.ch>,
       wux@landicorp.com, Patrice Vilchez <patrice.vilchez@rfo.atmel.com>
Subject: [PATCH] mmc: at91_mci: fix hanging and rework to match flowcharts
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-ESAFE-STATUS: Mail clean
X-ESAFE-DETAILS: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes hanging using multi block operations (seen during CMD25).
Follows closely the datasheet flowcharts.

This piece of code handles better big file writing. I had to take 
care of the notbusy signal during write (at91_mci_handle_cmdrdy 
function) and to rearrange the AT91_MCI_ENDRX and AT91_MCI_RXBUFF 
flag usage.

Signed-off-by: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
---
This patch is applied on top of the "typo" one :
http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/broken-out/mmc-at91_mci-typo.patch

It is cooked with the help of Wu Xuan and Marc Pignat. Big thanks to 
them.

It has been tested on several systems and reported to work ok :
at91rm9200 ok w/ 1 wire
at91sam9261 ok w/ 1 wire
at91sam926[03] ok w/ 4 wires
The code takes care of those specificities.

 drivers/mmc/host/at91_mci.c |  213 ++++++++++++++++++----------------
 1 file changed, 118 insertions(+), 95 deletions(-)

Index: b/drivers/mmc/host/at91_mci.c
===================================================================
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -80,8 +78,6 @@
 
 #define DRIVER_NAME "at91_mci"
 
-#undef	SUPPORT_4WIRE
-
 #define FL_SENT_COMMAND	(1 << 0)
 #define FL_SENT_STOP	(1 << 1)
 
@@ -250,28 +246,27 @@ static void at91_mci_pre_dma_read(struct
 /*
  * Handle after a dma read
  */
-static void at91_mci_post_dma_read(struct at91mci_host *host)
+static int at91_mci_post_dma_read(struct at91mci_host *host)
 {
 	struct mmc_command *cmd;
 	struct mmc_data *data;
+	int completed = 0;
 
 	pr_debug("post dma read\n");
 
 	cmd = host->cmd;
 	if (!cmd) {
 		pr_debug("no command\n");
-		return;
+		return 1;
 	}
 
 	data = cmd->data;
 	if (!data) {
 		pr_debug("no data\n");
-		return;
+		return 1;
 	}
 
 	while (host->in_use_index < host->transfer_index) {
-		unsigned int *buffer;
-
 		struct scatterlist *sg;
 
 		pr_debug("finishing index %d\n", host->in_use_index);
@@ -282,20 +277,22 @@ static void at91_mci_post_dma_read(struc
 
 		dma_unmap_page(NULL, sg->dma_address, sg->length, DMA_FROM_DEVICE);
 
-		/* Swap the contents of the buffer */
-		buffer = kmap_atomic(sg->page, KM_BIO_SRC_IRQ) + sg->offset;
-		pr_debug("buffer = %p, length = %d\n", buffer, sg->length);
-
 		data->bytes_xfered += sg->length;
 
 		if (cpu_is_at91rm9200()) {	/* AT91RM9200 errata */
+			unsigned int *buffer;
 			int index;
 
+			/* Swap the contents of the buffer */
+			buffer = kmap_atomic(sg->page, KM_BIO_SRC_IRQ) + sg->offset;
+			pr_debug("buffer = %p, length = %d\n", buffer, sg->length);
+
 			for (index = 0; index < (sg->length / 4); index++)
 				buffer[index] = swab32(buffer[index]);
+
+			kunmap_atomic(buffer, KM_BIO_SRC_IRQ);
 		}
 
-		kunmap_atomic(buffer, KM_BIO_SRC_IRQ);
 		flush_dcache_page(sg->page);
 	}
 
@@ -303,11 +300,12 @@ static void at91_mci_post_dma_read(struc
 	if (host->transfer_index < data->sg_len)
 		at91_mci_pre_dma_read(host);
 	else {
+		at91_mci_write(host, AT91_MCI_IDR, AT91_MCI_ENDRX);
 		at91_mci_write(host, AT91_MCI_IER, AT91_MCI_RXBUFF);
-		at91_mci_write(host, ATMEL_PDC_PTCR, ATMEL_PDC_RXTDIS | ATMEL_PDC_TXTDIS);
 	}
 
 	pr_debug("post dma read done\n");
+	return completed;
 }
 
 /*
@@ -325,7 +323,6 @@ static void at91_mci_handle_transmitted(
 
 	/* Now wait for cmd ready */
 	at91_mci_write(host, AT91_MCI_IDR, AT91_MCI_TXBUFE);
-	at91_mci_write(host, AT91_MCI_IER, AT91_MCI_NOTBUSY);
 
 	cmd = host->cmd;
 	if (!cmd) return;
@@ -333,18 +330,53 @@ static void at91_mci_handle_transmitted(
 	data = cmd->data;
 	if (!data) return;
 
+	if (cmd->data->flags & MMC_DATA_MULTI) {
+		pr_debug("multiple write : wait for BLKE...\n");
+		at91_mci_write(host, AT91_MCI_IER, AT91_MCI_BLKE);
+	} else
+		at91_mci_write(host, AT91_MCI_IER, AT91_MCI_NOTBUSY);
+
 	data->bytes_xfered = host->total_length;
 }
 
+/*Handle after command sent ready*/
+static int at91_mci_handle_cmdrdy(struct at91mci_host *host)
+{
+	if (!host->cmd)
+		return 1;
+	else if (!host->cmd->data) {
+		if (host->flags & FL_SENT_STOP) {
+			/*After multi block write, we must wait for NOTBUSY*/
+			at91_mci_write(host, AT91_MCI_IER, AT91_MCI_NOTBUSY);
+		} else return 1;
+	} else if (host->cmd->data->flags & MMC_DATA_WRITE) {
+		/*After sendding multi-block-write command, start DMA transfer*/
+		at91_mci_write(host, AT91_MCI_IER, AT91_MCI_TXBUFE);
+		at91_mci_write(host, AT91_MCI_IER, AT91_MCI_BLKE);
+		at91_mci_write(host, ATMEL_PDC_PTCR, ATMEL_PDC_TXTEN);
+	}
+
+	/* command not completed, have to wait */
+	return 0;
+}
+
+
 /*
  * Enable the controller
  */
 static void at91_mci_enable(struct at91mci_host *host)
 {
+	unsigned int mr;
+
 	at91_mci_write(host, AT91_MCI_CR, AT91_MCI_MCIEN);
 	at91_mci_write(host, AT91_MCI_IDR, 0xffffffff);
 	at91_mci_write(host, AT91_MCI_DTOR, AT91_MCI_DTOMUL_1M | AT91_MCI_DTOCYC);
-	at91_mci_write(host, AT91_MCI_MR, AT91_MCI_PDCMODE | 0x34a);
+	mr = AT91_MCI_PDCMODE | 0x34a;
+
+	if (cpu_is_at91sam9260() || cpu_is_at91sam9263())
+		mr |= AT91_MCI_RDPROOF | AT91_MCI_WRPROOF;
+
+	at91_mci_write(host, AT91_MCI_MR, mr);
 
 	/* use Slot A or B (only one at same time) */
 	at91_mci_write(host, AT91_MCI_SDCR, host->board->slot_b);
@@ -360,9 +392,8 @@ static void at91_mci_disable(struct at91
 
 /*
  * Send a command
- * return the interrupts to enable
  */
-static unsigned int at91_mci_send_command(struct at91mci_host *host, struct mmc_command *cmd)
+static void at91_mci_send_command(struct at91mci_host *host, struct mmc_command *cmd)
 {
 	unsigned int cmdr, mr;
 	unsigned int block_length;
@@ -373,8 +404,7 @@ static unsigned int at91_mci_send_comman
 
 	host->cmd = cmd;
 
-	/* Not sure if this is needed */
-#if 0
+	/* Needed for leaving busy state before CMD1 */
 	if ((at91_mci_read(host, AT91_MCI_SR) & AT91_MCI_RTOE) && (cmd->opcode == 1)) {
 		pr_debug("Clearing timeout\n");
 		at91_mci_write(host, AT91_MCI_ARGR, 0);
@@ -384,7 +414,7 @@ static unsigned int at91_mci_send_comman
 			pr_debug("Clearing: SR = %08X\n", at91_mci_read(host, AT91_MCI_SR));
 		}
 	}
-#endif
+
 	cmdr = cmd->opcode;
 
 	if (mmc_resp_type(cmd) == MMC_RSP_NONE)
@@ -441,50 +471,48 @@ static unsigned int at91_mci_send_comman
 		at91_mci_write(host, ATMEL_PDC_TCR, 0);
 		at91_mci_write(host, ATMEL_PDC_TNPR, 0);
 		at91_mci_write(host, ATMEL_PDC_TNCR, 0);
+		ier = AT91_MCI_CMDRDY;
+	} else {
+		/* zero block length and PDC mode */
+		mr = at91_mci_read(host, AT91_MCI_MR) & 0x7fff;
+		at91_mci_write(host, AT91_MCI_MR, mr | (block_length << 16) | AT91_MCI_PDCMODE);
+
+		/*
+		 * Disable the PDC controller
+		 */
+		at91_mci_write(host, ATMEL_PDC_PTCR, ATMEL_PDC_RXTDIS | ATMEL_PDC_TXTDIS);
 
-		at91_mci_write(host, AT91_MCI_ARGR, cmd->arg);
-		at91_mci_write(host, AT91_MCI_CMDR, cmdr);
-		return AT91_MCI_CMDRDY;
-	}
-
-	mr = at91_mci_read(host, AT91_MCI_MR) & 0x7fff;	/* zero block length and PDC mode */
-	at91_mci_write(host, AT91_MCI_MR, mr | (block_length << 16) | AT91_MCI_PDCMODE);
-
-	/*
-	 * Disable the PDC controller
-	 */
-	at91_mci_write(host, ATMEL_PDC_PTCR, ATMEL_PDC_RXTDIS | ATMEL_PDC_TXTDIS);
-
-	if (cmdr & AT91_MCI_TRCMD_START) {
-		data->bytes_xfered = 0;
-		host->transfer_index = 0;
-		host->in_use_index = 0;
-		if (cmdr & AT91_MCI_TRDIR) {
-			/*
-			 * Handle a read
-			 */
-			host->buffer = NULL;
-			host->total_length = 0;
+		if (cmdr & AT91_MCI_TRCMD_START) {
+			data->bytes_xfered = 0;
+			host->transfer_index = 0;
+			host->in_use_index = 0;
+			if (cmdr & AT91_MCI_TRDIR) {
+				/*
+				 * Handle a read
+				 */
+				host->buffer = NULL;
+				host->total_length = 0;
 
-			at91_mci_pre_dma_read(host);
-			ier = AT91_MCI_ENDRX /* | AT91_MCI_RXBUFF */;
-		}
-		else {
-			/*
-			 * Handle a write
-			 */
-			host->total_length = block_length * blocks;
-			host->buffer = dma_alloc_coherent(NULL,
-						  host->total_length,
-						  &host->physical_address, GFP_KERNEL);
-
-			at91_mci_sg_to_dma(host, data);
-
-			pr_debug("Transmitting %d bytes\n", host->total_length);
-
-			at91_mci_write(host, ATMEL_PDC_TPR, host->physical_address);
-			at91_mci_write(host, ATMEL_PDC_TCR, host->total_length / 4);
-			ier = AT91_MCI_TXBUFE;
+				at91_mci_pre_dma_read(host);
+				ier = AT91_MCI_ENDRX /* | AT91_MCI_RXBUFF */;
+			}
+			else {
+				/*
+				 * Handle a write
+				 */
+				host->total_length = block_length * blocks;
+				host->buffer = dma_alloc_coherent(NULL,
+						host->total_length,
+						&host->physical_address, GFP_KERNEL);
+
+				at91_mci_sg_to_dma(host, data);
+
+				pr_debug("Transmitting %d bytes\n", host->total_length);
+
+				at91_mci_write(host, ATMEL_PDC_TPR, host->physical_address);
+				at91_mci_write(host, ATMEL_PDC_TCR, host->total_length / 4);
+				ier = AT91_MCI_CMDRDY;
+			}
 		}
 	}
 
@@ -499,24 +527,9 @@ static unsigned int at91_mci_send_comman
 	if (cmdr & AT91_MCI_TRCMD_START) {
 		if (cmdr & AT91_MCI_TRDIR)
 			at91_mci_write(host, ATMEL_PDC_PTCR, ATMEL_PDC_RXTEN);
-		else
-			at91_mci_write(host, ATMEL_PDC_PTCR, ATMEL_PDC_TXTEN);
 	}
-	return ier;
-}
 
-/*
- * Wait for a command to complete
- */
-static void at91_mci_process_command(struct at91mci_host *host, struct mmc_command *cmd)
-{
-	unsigned int ier;
-
-	ier = at91_mci_send_command(host, cmd);
-
-	pr_debug("setting ier to %08X\n", ier);
-
-	/* Stop on errors or the required value */
+	/* Enable selected interrupts */
 	at91_mci_write(host, AT91_MCI_IER, AT91_MCI_ERRORS | ier);
 }
 
@@ -527,11 +540,11 @@ static void at91_mci_process_next(struct
 {
 	if (!(host->flags & FL_SENT_COMMAND)) {
 		host->flags |= FL_SENT_COMMAND;
-		at91_mci_process_command(host, host->request->cmd);
+		at91_mci_send_command(host, host->request->cmd);
 	}
 	else if ((!(host->flags & FL_SENT_STOP)) && host->request->stop) {
 		host->flags |= FL_SENT_STOP;
-		at91_mci_process_command(host, host->request->stop);
+		at91_mci_send_command(host, host->request->stop);
 	}
 	else
 		mmc_request_done(host->mmc, host->request);
@@ -698,29 +711,33 @@ static irqreturn_t at91_mci_irq(int irq,
 			at91_mci_handle_transmitted(host);
 		}
 
+		if (int_status & AT91_MCI_ENDRX) {
+			pr_debug("ENDRX\n");
+			at91_mci_post_dma_read(host);
+		}
+
 		if (int_status & AT91_MCI_RXBUFF) {
 			pr_debug("RX buffer full\n");
-			at91_mci_write(host, AT91_MCI_IER, AT91_MCI_CMDRDY);
+			at91_mci_write(host, ATMEL_PDC_PTCR, ATMEL_PDC_RXTDIS | ATMEL_PDC_TXTDIS);
+			at91_mci_write(host, AT91_MCI_IDR, AT91_MCI_RXBUFF | AT91_MCI_ENDRX);
+			completed = 1;
 		}
 
 		if (int_status & AT91_MCI_ENDTX)
 			pr_debug("Transmit has ended\n");
 
-		if (int_status & AT91_MCI_ENDRX) {
-			pr_debug("Receive has ended\n");
-			at91_mci_post_dma_read(host);
-		}
-
 		if (int_status & AT91_MCI_NOTBUSY) {
 			pr_debug("Card is ready\n");
-			at91_mci_write(host, AT91_MCI_IER, AT91_MCI_CMDRDY);
+			completed = 1;
 		}
 
 		if (int_status & AT91_MCI_DTIP)
 			pr_debug("Data transfer in progress\n");
 
-		if (int_status & AT91_MCI_BLKE)
+		if (int_status & AT91_MCI_BLKE) {
 			pr_debug("Block transfer has ended\n");
+			completed = 1;
+		}
 
 		if (int_status & AT91_MCI_TXRDY)
 			pr_debug("Ready to transmit\n");
@@ -730,7 +747,7 @@ static irqreturn_t at91_mci_irq(int irq,
 
 		if (int_status & AT91_MCI_CMDRDY) {
 			pr_debug("Command ready\n");
-			completed = 1;
+			completed = at91_mci_handle_cmdrdy(host);
 		}
 	}
 
@@ -817,7 +834,11 @@ static int __init at91_mci_probe(struct 
 
 	mmc->ops = &at91_mci_ops;
 	mmc->f_min = 375000;
-	mmc->f_max = 25000000;
+	if (cpu_is_at91sam9263())
+		mmc->f_max = 50000000;
+	else
+		mmc->f_max = 25000000;
+
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
 	mmc->caps = MMC_CAP_BYTEBLOCK | MMC_CAP_MULTIWRITE;
 
@@ -830,11 +851,11 @@ static int __init at91_mci_probe(struct 
 	host->bus_mode = 0;
 	host->board = pdev->dev.platform_data;
 	if (host->board->wire4) {
-#ifdef SUPPORT_4WIRE
-		mmc->caps |= MMC_CAP_4_BIT_DATA;
-#else
-		printk("AT91 MMC: 4 wire bus mode not supported by this driver - using 1 wire\n");
-#endif
+		if (cpu_is_at91sam9260() || cpu_is_at91sam9263())
+			mmc->caps |= MMC_CAP_4_BIT_DATA;
+		else
+			printk("AT91 MMC: 4 wire bus mode not supported"
+				" - using 1 wire\n");
 	}
 
 	/*




