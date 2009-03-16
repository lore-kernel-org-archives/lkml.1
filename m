Return-Path: <linux-kernel-owner+w=401wt.eu-S1762018AbZCPVOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762018AbZCPVOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 17:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761229AbZCPVNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 17:13:55 -0400
Received: from [213.79.90.228] ([213.79.90.228]:2023 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761627AbZCPVNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 17:13:54 -0400
Date: Tue, 17 Mar 2009 00:13:52 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 04/11] sdhci: Add support for card-detection polling
Message-ID: <20090316211352.GD9375@oksana.dev.rtsoft.ru>
References: <20090316211306.GA1736@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090316211306.GA1736@oksana.dev.rtsoft.ru>
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
 drivers/mmc/host/sdhci.c |   17 +++++++++++++++--
 drivers/mmc/host/sdhci.h |    2 ++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 6fbbc00..fc7cb48 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -112,6 +112,9 @@ static void sdhci_set_card_detection(struct sdhci_host *host, bool enable)
 {
 	u32 irqs = SDHCI_INT_CARD_REMOVE | SDHCI_INT_CARD_INSERT;
 
+	if (host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION)
+		return;
+
 	if (enable)
 		sdhci_unmask_irqs(host, irqs);
 	else
@@ -1041,6 +1044,7 @@ out:
 static void sdhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 {
 	struct sdhci_host *host;
+	bool present;
 	unsigned long flags;
 
 	host = mmc_priv(mmc);
@@ -1055,8 +1059,14 @@ static void sdhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 
 	host->mrq = mrq;
 
-	if (!(sdhci_readl(host, SDHCI_PRESENT_STATE) & SDHCI_CARD_PRESENT)
-		|| (host->flags & SDHCI_DEVICE_DEAD)) {
+	/* If polling, assume that the card is always present. */
+	if (host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION)
+		present = true;
+	else
+		present = sdhci_readl(host, SDHCI_PRESENT_STATE) &
+				SDHCI_CARD_PRESENT;
+
+	if (!present || host->flags & SDHCI_DEVICE_DEAD) {
 		host->mrq->cmd->error = -ENOMEDIUM;
 		tasklet_schedule(&host->finish_tasklet);
 	} else
@@ -1690,6 +1700,9 @@ int sdhci_add_host(struct sdhci_host *host)
 	if (caps & SDHCI_CAN_DO_HISPD)
 		mmc->caps |= MMC_CAP_SD_HIGHSPEED;
 
+	if (host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION)
+		mmc->caps |= MMC_CAP_NEEDS_POLL;
+
 	mmc->ocr_avail = 0;
 	if (caps & SDHCI_CAN_VDD_330)
 		mmc->ocr_avail |= MMC_VDD_32_33|MMC_VDD_33_34;
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index a9e25c6..968d713 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -214,6 +214,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_BROKEN_SMALL_PIO			(1<<13)
 /* Controller does not provide transfer-complete interrupt when not busy */
 #define SDHCI_QUIRK_NO_BUSY_IRQ				(1<<14)
+/* Controller has unreliable card detection */
+#define SDHCI_QUIRK_BROKEN_CARD_DETECTION		(1<<15)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
-- 
1.5.6.5

