Return-Path: <linux-kernel-owner+w=401wt.eu-S1761913AbZBMOsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761913AbZBMOsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 09:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759759AbZBMOrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 09:47:23 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:16717 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759140AbZBMOrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 09:47:20 -0500
Date: Fri, 13 Feb 2009 17:47:16 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 04/13] sdhci: Enable only relevant (DMA/PIO) interrupts
	during transfers
Message-ID: <20090213144716.GD23889@oksana.dev.rtsoft.ru>
References: <20090213144630.GA13436@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090213144630.GA13436@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some hosts (that is, FSL eSDHC) throw PIO interrupts during DMA
transfers, this causes tons of unneeded interrupts, and thus highly
degraded speed.

This patch modifies the driver so that now we only enable relevant
(DMA or PIO) interrupts during transfers.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/host/sdhci.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index fadaeb8..2728e90 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -222,9 +222,7 @@ static void sdhci_init(struct sdhci_host *host)
 		SDHCI_INT_BUS_POWER | SDHCI_INT_DATA_END_BIT |
 		SDHCI_INT_DATA_CRC | SDHCI_INT_DATA_TIMEOUT | SDHCI_INT_INDEX |
 		SDHCI_INT_END_BIT | SDHCI_INT_CRC | SDHCI_INT_TIMEOUT |
-		SDHCI_INT_DATA_AVAIL | SDHCI_INT_SPACE_AVAIL |
-		SDHCI_INT_DMA_END | SDHCI_INT_DATA_END | SDHCI_INT_RESPONSE |
-		SDHCI_INT_ADMA_ERROR);
+		SDHCI_INT_DATA_END | SDHCI_INT_RESPONSE);
 }
 
 static void sdhci_reinit(struct sdhci_host *host)
@@ -658,6 +656,17 @@ static u8 sdhci_calc_timeout(struct sdhci_host *host, struct mmc_data *data)
 	return count;
 }
 
+static void sdhci_set_transfer_irqs(struct sdhci_host *host)
+{
+	u32 pio_irqs = SDHCI_INT_DATA_AVAIL | SDHCI_INT_SPACE_AVAIL;
+	u32 dma_irqs = SDHCI_INT_DMA_END | SDHCI_INT_ADMA_ERROR;
+
+	if (host->flags & SDHCI_REQ_USE_DMA)
+		sdhci_clear_set_irqs(host, pio_irqs, dma_irqs);
+	else
+		sdhci_clear_set_irqs(host, dma_irqs, pio_irqs);
+}
+
 static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
 {
 	u8 count;
@@ -806,6 +815,8 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
 		host->blocks = data->blocks;
 	}
 
+	sdhci_set_transfer_irqs(host);
+
 	/* We do not handle DMA boundaries, so set it to max (512 KiB) */
 	sdhci_writew(host, SDHCI_MAKE_BLKSZ(7, data->blksz), SDHCI_BLOCK_SIZE);
 	sdhci_writew(host, data->blocks, SDHCI_BLOCK_COUNT);
-- 
1.5.6.5

