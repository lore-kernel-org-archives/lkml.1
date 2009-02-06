Return-Path: <linux-kernel-owner+w=401wt.eu-S1758901AbZBFSIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901AbZBFSIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 13:08:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758392AbZBFSGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 13:06:52 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:3202 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758239AbZBFSGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 13:06:51 -0500
Date: Fri, 6 Feb 2009 21:06:50 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 04/11] sdhci: Add support for card-detection polling
Message-ID: <20090206180650.GD11548@oksana.dev.rtsoft.ru>
References: <20090206180520.GA16123@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090206180520.GA16123@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds SDHCI_QUIRK_BROKEN_CARD_DETECTION quirk. When specified,
sdhci driver will set MMC_CAP_NEEDS_POLL MMC host capability, and won't
enable card insert/remove interrupts.

This is needed for hosts with unreliable card detection, such as FSL
eSDHC. The original eSDHC driver was tring to "debounce" card-detection
IRQs by reading present state and disabling particular interrupts. But
with this debouncing scheme I noticed that sometimes we miss card
insertion/removal events.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/host/sdhci.c |    6 ++++++
 drivers/mmc/host/sdhci.h |    2 ++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index b7a79a0..45c5f1f 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -162,6 +162,9 @@ static void sdhci_init(struct sdhci_host *host)
 		SDHCI_INT_DMA_END | SDHCI_INT_DATA_END | SDHCI_INT_RESPONSE |
 		SDHCI_INT_ADMA_ERROR;
 
+	if (host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION)
+		intmask &= ~(SDHCI_INT_CARD_REMOVE | SDHCI_INT_CARD_INSERT);
+
 	sdhci_writel(host, intmask, SDHCI_INT_ENABLE);
 	sdhci_writel(host, intmask, SDHCI_SIGNAL_ENABLE);
 }
@@ -1684,6 +1687,9 @@ int sdhci_add_host(struct sdhci_host *host)
 	mmc->f_max = host->max_clk;
 	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO_IRQ;
 
+	if (host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION)
+		mmc->caps |= MMC_CAP_NEEDS_POLL;
+
 	if ((caps & SDHCI_CAN_DO_HISPD) ||
 		(host->quirks & SDHCI_QUIRK_FORCE_HIGHSPEED))
 		mmc->caps |= MMC_CAP_SD_HIGHSPEED;
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 5a5c119..03f035e 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -227,6 +227,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_FORCE_HIGHSPEED			(1<<14)
 /* Controller does not provide transfer-complete interrupt when not busy */
 #define SDHCI_QUIRK_NO_BUSY_IRQ				(1<<15)
+/* Controller has unreliable card detection */
+#define SDHCI_QUIRK_BROKEN_CARD_DETECTION		(1<<16)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
-- 
1.5.6.5

