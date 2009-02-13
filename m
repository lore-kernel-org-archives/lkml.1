Return-Path: <linux-kernel-owner+w=401wt.eu-S1762003AbZBMOsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762003AbZBMOsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 09:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759910AbZBMOrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 09:47:23 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:16726 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759650AbZBMOrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 09:47:22 -0500
Date: Fri, 13 Feb 2009 17:47:18 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 05/13] sdhci: Add support for card-detection polling
Message-ID: <20090213144718.GE23889@oksana.dev.rtsoft.ru>
References: <20090213144630.GA13436@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090213144630.GA13436@oksana.dev.rtsoft.ru>
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
 drivers/mmc/host/sdhci.c |   17 ++++++++++++++---
 drivers/mmc/host/sdhci.h |    2 ++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 2728e90..782fb58 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -167,6 +167,9 @@ static void sdhci_set_card_detection(struct sdhci_host *host, bool enable)
 {
 	u32 irqs = SDHCI_INT_CARD_REMOVE | SDHCI_INT_CARD_INSERT;
 
+	if (host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION)
+		return;
+
 	if (enable)
 		sdhci_unmask_irqs(host, irqs);
 	else
@@ -1110,13 +1113,18 @@ static void sdhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 
 	host->mrq = mrq;
 
+	if (host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION)
+		goto send;
+
 	if (!(sdhci_readl(host, SDHCI_PRESENT_STATE) & SDHCI_CARD_PRESENT)
 		|| (host->flags & SDHCI_DEVICE_DEAD)) {
 		host->mrq->cmd->error = -ENOMEDIUM;
 		tasklet_schedule(&host->finish_tasklet);
-	} else
-		sdhci_send_command(host, mrq->cmd);
-
+		goto out;
+	}
+send:
+	sdhci_send_command(host, mrq->cmd);
+out:
 	mmiowb();
 	spin_unlock_irqrestore(&host->lock, flags);
 }
@@ -1742,6 +1750,9 @@ int sdhci_add_host(struct sdhci_host *host)
 	mmc->f_max = host->max_clk;
 	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO_IRQ;
 
+	if (host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION)
+		mmc->caps |= MMC_CAP_NEEDS_POLL;
+
 	if ((caps & SDHCI_CAN_DO_HISPD) ||
 		(host->quirks & SDHCI_QUIRK_FORCE_HIGHSPEED))
 		mmc->caps |= MMC_CAP_SD_HIGHSPEED;
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 45c8309..b10920d 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -217,6 +217,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_FORCE_HIGHSPEED			(1<<14)
 /* Controller does not provide transfer-complete interrupt when not busy */
 #define SDHCI_QUIRK_NO_BUSY_IRQ				(1<<15)
+/* Controller has unreliable card detection */
+#define SDHCI_QUIRK_BROKEN_CARD_DETECTION		(1<<16)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
-- 
1.5.6.5

