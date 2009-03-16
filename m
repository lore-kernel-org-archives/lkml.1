Return-Path: <linux-kernel-owner+w=401wt.eu-S1761988AbZCPVOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761988AbZCPVOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 17:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761617AbZCPVNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 17:13:53 -0400
Received: from [213.79.90.228] ([213.79.90.228]:2015 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761478AbZCPVNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 17:13:52 -0400
Date: Tue, 17 Mar 2009 00:13:50 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 03/11] sdhci: Enable only relevant (DMA/PIO) interrupts
	during transfers
Message-ID: <20090316211350.GC9375@oksana.dev.rtsoft.ru>
References: <20090316211306.GA1736@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090316211306.GA1736@oksana.dev.rtsoft.ru>
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
index bd5acfb..6fbbc00 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -167,9 +167,7 @@ static void sdhci_init(struct sdhci_host *host)
 		SDHCI_INT_BUS_POWER | SDHCI_INT_DATA_END_BIT |
 		SDHCI_INT_DATA_CRC | SDHCI_INT_DATA_TIMEOUT | SDHCI_INT_INDEX |
 		SDHCI_INT_END_BIT | SDHCI_INT_CRC | SDHCI_INT_TIMEOUT |
-		SDHCI_INT_DATA_AVAIL | SDHCI_INT_SPACE_AVAIL |
-		SDHCI_INT_DMA_END | SDHCI_INT_DATA_END | SDHCI_INT_RESPONSE |
-		SDHCI_INT_ADMA_ERROR);
+		SDHCI_INT_DATA_END | SDHCI_INT_RESPONSE);
 }
 
 static void sdhci_reinit(struct sdhci_host *host)
@@ -603,6 +601,17 @@ static u8 sdhci_calc_timeout(struct sdhci_host *host, struct mmc_data *data)
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
@@ -751,6 +760,8 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
 		host->blocks = data->blocks;
 	}
 
+	sdhci_set_transfer_irqs(host);
+
 	/* We do not handle DMA boundaries, so set it to max (512 KiB) */
 	sdhci_writew(host, SDHCI_MAKE_BLKSZ(7, data->blksz), SDHCI_BLOCK_SIZE);
 	sdhci_writew(host, data->blocks, SDHCI_BLOCK_COUNT);
-- 
1.5.6.5

