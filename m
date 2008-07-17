Return-Path: <linux-kernel-owner+w=401wt.eu-S1758149AbYGQJmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbYGQJmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 05:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbYGQJmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 05:42:12 -0400
Received: from mail.atmel.fr ([81.80.104.162]:55686 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668AbYGQJmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 05:42:12 -0400
Message-ID: <487F13E9.2060601@atmel.com>
Date: Thu, 17 Jul 2008 11:42:01 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: ARM Linux Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <linux@maxim.org.za>, Ville Syrjala <syrjala@sci.fi>,
       Marc Pignat <marc.pignat@hevs.ch>
Subject: [PATCH 3/3] at91_mci: introduce per-mci-revision conditional code
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We used to manage features and differences on a per-cpu basis. As several
cpus share the same mci revision, this patch aggregates cpus that have the
same IP revision in one defined constant.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/mmc/host/at91_mci.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index 4e3edf3..a95529c 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -80,6 +80,11 @@
 
 #define DRIVER_NAME "at91_mci"
 
+#define AT91MCI_REV2	(  cpu_is_at91sam9260() \
+			|| cpu_is_at91sam9263() \
+			|| cpu_is_at91cap9() \
+			|| cpu_is_at91sam9rl())
+
 #define FL_SENT_COMMAND	(1 << 0)
 #define FL_SENT_STOP	(1 << 1)
 
@@ -202,8 +207,8 @@ static inline void at91_mci_sg_to_dma(struct at91mci_host *host, struct mmc_data
 	size = data->blksz * data->blocks;
 	len = data->sg_len;
 
-	/* AT91SAM926[0/3] Data Write Operation and number of bytes erratum */
-	if (cpu_is_at91sam9260() || cpu_is_at91sam9263())
+	/* AT91MCI_REV2 Data Write Operation and number of bytes erratum */
+	if (AT91MCI_REV2)
 		if (host->total_length == 12)
 			memset(dmabuf, 0, 12);
 
@@ -463,7 +468,7 @@ static void at91_mci_enable(struct at91mci_host *host)
 	at91_mci_write(host, AT91_MCI_DTOR, AT91_MCI_DTOMUL_1M | AT91_MCI_DTOCYC);
 	mr = AT91_MCI_PDCMODE | 0x34a;
 
-	if (cpu_is_at91sam9260() || cpu_is_at91sam9263())
+	if (AT91MCI_REV2)
 		mr |= AT91_MCI_RDPROOF | AT91_MCI_WRPROOF;
 
 	at91_mci_write(host, AT91_MCI_MR, mr);
@@ -616,10 +621,10 @@ static void at91_mci_send_command(struct at91mci_host *host, struct mmc_command
 				 */
 				host->total_length = block_length * blocks;
 				/*
-				 * AT91SAM926[0/3] Data Write Operation and
+				 * AT91MCI_REV2 Data Write Operation and
 				 * number of bytes erratum
 				 */
-				if (cpu_is_at91sam9260 () || cpu_is_at91sam9263())
+				if (AT91MCI_REV2)
 					if (host->total_length < 12)
 						host->total_length = 12;
 				host->buffer = dma_alloc_coherent(NULL,
@@ -1010,7 +1015,7 @@ static int __init at91_mci_probe(struct platform_device *pdev)
 	host->bus_mode = 0;
 	host->board = pdev->dev.platform_data;
 	if (host->board->wire4) {
-		if (cpu_is_at91sam9260() || cpu_is_at91sam9263())
+		if (AT91MCI_REV2)
 			mmc->caps |= MMC_CAP_4_BIT_DATA;
 		else
 			dev_warn(&pdev->dev, "4 wire bus mode not supported"
@@ -1018,8 +1023,8 @@ static int __init at91_mci_probe(struct platform_device *pdev)
 	}
 
 	/* Add SDIO capability when  available */
-	if (cpu_is_at91sam9260() || cpu_is_at91sam9263()) {
-		/* AT91SAM9260/9263 erratum */
+	if (AT91MCI_REV2) {
+		/* AT91MCI_REV2 sdio interrupt erratum */
 		if (host->board->wire4 || !host->board->slot_b)
 			mmc->caps |= MMC_CAP_SDIO_IRQ;
 	}
-- 
1.5.3.7




