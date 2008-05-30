Return-Path: <linux-kernel-owner+w=401wt.eu-S1752477AbYE3MTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbYE3MTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 08:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbYE3MTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 08:19:14 -0400
Received: from mail.atmel.fr ([81.80.104.162]:54248 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbYE3MTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 08:19:14 -0400
Message-ID: <483FF0B1.6010500@atmel.com>
Date: Fri, 30 May 2008 14:18:57 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>, Hans J Koch <hjk@linutronix.de>,
       Ville Syrjala <syrjala@sci.fi>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Eric BENARD <ebenard@free.fr>, Andrew Victor <linux@maxim.org.za>
Subject: [PATCH 5/7] mmc: at91_mci: update bytes_xfered value once xfer done
References: <483FE9E7.7020707@atmel.com>
In-Reply-To: <483FE9E7.7020707@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify bytes_xfered value after a write.

That will report, as accurately as possible, the amount of 
sectors that are effectively written.

This update introduces the check of the busy signal given by
the card.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/mmc/host/at91_mci.c |   40 ++++++++++++++++++++++++++++++++++------
 1 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index df975e0..b2138f9 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -340,8 +340,6 @@ static void at91_mci_post_dma_read(struct at91mci_host *host)
 
 		dma_unmap_page(NULL, sg->dma_address, sg->length, DMA_FROM_DEVICE);
 
-		data->bytes_xfered += sg->length;
-
 		if (cpu_is_at91rm9200()) {	/* AT91RM9200 errata */
 			unsigned int *buffer;
 			int index;
@@ -357,6 +355,8 @@ static void at91_mci_post_dma_read(struct at91mci_host *host)
 		}
 
 		flush_dcache_page(sg_page(sg));
+
+		data->bytes_xfered += sg->length;
 	}
 
 	/* Is there another transfer to trigger? */
@@ -397,10 +397,32 @@ static void at91_mci_handle_transmitted(struct at91mci_host *host)
 		at91_mci_write(host, AT91_MCI_IER, AT91_MCI_BLKE);
 	} else
 		at91_mci_write(host, AT91_MCI_IER, AT91_MCI_NOTBUSY);
+}
+
+/*
+ * Update bytes tranfered count during a write operation
+ */
+static void at91_mci_update_bytes_xfered(struct at91mci_host *host)
+{
+	struct mmc_data *data;
 
-	data->bytes_xfered = host->total_length;
+	/* always deal with the effective request (and not the current cmd) */
+
+	if (host->request->cmd && host->request->cmd->error != 0)
+		return;
+
+	if (host->request->data) {
+		data = host->request->data;
+		if (data->flags & MMC_DATA_WRITE) {
+			/* card is in IDLE mode now */
+			pr_debug("-> bytes_xfered %d, total_length = %d\n",
+				data->bytes_xfered, host->total_length);
+			data->bytes_xfered = host->total_length;
+		}
+	}
 }
 
+
 /*Handle after command sent ready*/
 static int at91_mci_handle_cmdrdy(struct at91mci_host *host)
 {
@@ -413,8 +435,7 @@ static int at91_mci_handle_cmdrdy(struct at91mci_host *host)
 		} else return 1;
 	} else if (host->cmd->data->flags & MMC_DATA_WRITE) {
 		/*After sendding multi-block-write command, start DMA transfer*/
-		at91_mci_write(host, AT91_MCI_IER, AT91_MCI_TXBUFE);
-		at91_mci_write(host, AT91_MCI_IER, AT91_MCI_BLKE);
+		at91_mci_write(host, AT91_MCI_IER, AT91_MCI_TXBUFE | AT91_MCI_BLKE);
 		at91_mci_write(host, ATMEL_PDC_PTCR, ATMEL_PDC_TXTEN);
 	}
 
@@ -817,6 +838,7 @@ static irqreturn_t at91_mci_irq(int irq, void *devid)
 
 		if (int_status & AT91_MCI_NOTBUSY) {
 			pr_debug("Card is ready\n");
+			at91_mci_update_bytes_xfered(host);
 			completed = 1;
 		}
 
@@ -825,7 +847,13 @@ static irqreturn_t at91_mci_irq(int irq, void *devid)
 
 		if (int_status & AT91_MCI_BLKE) {
 			pr_debug("Block transfer has ended\n");
-			completed = 1;
+			if (host->request->data && host->request->data->blocks > 1) {
+				/* multi block write : complete multi write
+				 * command and send stop */
+				completed = 1;
+			} else {
+				at91_mci_write(host, AT91_MCI_IER, AT91_MCI_NOTBUSY);
+			}
 		}
 
 		if (int_status & AT91_MCI_TXRDY)
-- 
1.5.3.7


