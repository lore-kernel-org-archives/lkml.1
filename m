Return-Path: <linux-kernel-owner+w=401wt.eu-S1761783AbZBMOsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761783AbZBMOsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 09:48:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758825AbZBMOrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 09:47:22 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:16709 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758667AbZBMOrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 09:47:18 -0500
Date: Fri, 13 Feb 2009 17:47:15 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 03/13] sdhci: Split card-detection IRQs management from
	sdhci_init()
Message-ID: <20090213144715.GC23889@oksana.dev.rtsoft.ru>
References: <20090213144630.GA13436@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090213144630.GA13436@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Card detection interrupts should be handled separately as they should
not be enabled before mmc_add_host() returns and should be disabled
before calling mmc_remove_host(). The same is for suspend and resume
routines.

sdhci_init() no longer enables card-detection irqs. Instead, two new
functions implemented: sdhci_enable_card_detection() and
sdhci_disable_card_detection().

New sdhci_reinit() call implemented to behave the same way as the old
sdhci_init().

Also, this patch implements and uses few new helpers to manage IRQs in
a more conveinient way, that is:

- sdhci_clear_set_irqs()
- sdhci_unmask_irqs()
- sdhci_mask_irqs()
- SDHCI_INT_ALL_MASK constant

sdhci_enable_sdio_irq() converted to these new helpers, plus the
helpers will be used by the subsequent patches.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/host/sdhci.c |   78 ++++++++++++++++++++++++++++++++++++----------
 drivers/mmc/host/sdhci.h |    4 ++
 2 files changed, 65 insertions(+), 17 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 8682f7f..fadaeb8 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -142,6 +142,47 @@ u8 sdhci_readb(struct sdhci_host *host, int reg)
 }
 EXPORT_SYMBOL_GPL(sdhci_readb);
 
+static void sdhci_clear_set_irqs(struct sdhci_host *host, u32 clear, u32 set)
+{
+	u32 ier;
+
+	ier = sdhci_readl(host, SDHCI_INT_ENABLE);
+	ier &= ~clear;
+	ier |= set;
+	sdhci_writel(host, ier, SDHCI_INT_ENABLE);
+	sdhci_writel(host, ier, SDHCI_SIGNAL_ENABLE);
+}
+
+static void sdhci_unmask_irqs(struct sdhci_host *host, u32 irqs)
+{
+	sdhci_clear_set_irqs(host, 0, irqs);
+}
+
+static void sdhci_mask_irqs(struct sdhci_host *host, u32 irqs)
+{
+	sdhci_clear_set_irqs(host, irqs, 0);
+}
+
+static void sdhci_set_card_detection(struct sdhci_host *host, bool enable)
+{
+	u32 irqs = SDHCI_INT_CARD_REMOVE | SDHCI_INT_CARD_INSERT;
+
+	if (enable)
+		sdhci_unmask_irqs(host, irqs);
+	else
+		sdhci_mask_irqs(host, irqs);
+}
+
+static void sdhci_enable_card_detection(struct sdhci_host *host)
+{
+	sdhci_set_card_detection(host, true);
+}
+
+static void sdhci_disable_card_detection(struct sdhci_host *host)
+{
+	sdhci_set_card_detection(host, false);
+}
+
 static void sdhci_reset(struct sdhci_host *host, u8 mask)
 {
 	unsigned long timeout;
@@ -175,20 +216,21 @@ static void sdhci_reset(struct sdhci_host *host, u8 mask)
 
 static void sdhci_init(struct sdhci_host *host)
 {
-	u32 intmask;
-
 	sdhci_reset(host, SDHCI_RESET_ALL);
 
-	intmask = SDHCI_INT_BUS_POWER | SDHCI_INT_DATA_END_BIT |
+	sdhci_clear_set_irqs(host, SDHCI_INT_ALL_MASK,
+		SDHCI_INT_BUS_POWER | SDHCI_INT_DATA_END_BIT |
 		SDHCI_INT_DATA_CRC | SDHCI_INT_DATA_TIMEOUT | SDHCI_INT_INDEX |
 		SDHCI_INT_END_BIT | SDHCI_INT_CRC | SDHCI_INT_TIMEOUT |
-		SDHCI_INT_CARD_REMOVE | SDHCI_INT_CARD_INSERT |
 		SDHCI_INT_DATA_AVAIL | SDHCI_INT_SPACE_AVAIL |
 		SDHCI_INT_DMA_END | SDHCI_INT_DATA_END | SDHCI_INT_RESPONSE |
-		SDHCI_INT_ADMA_ERROR;
+		SDHCI_INT_ADMA_ERROR);
+}
 
-	sdhci_writel(host, intmask, SDHCI_INT_ENABLE);
-	sdhci_writel(host, intmask, SDHCI_SIGNAL_ENABLE);
+static void sdhci_reinit(struct sdhci_host *host)
+{
+	sdhci_init(host);
+	sdhci_enable_card_detection(host);
 }
 
 static void sdhci_activate_led(struct sdhci_host *host)
@@ -1087,7 +1129,7 @@ static void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	 */
 	if (ios->power_mode == MMC_POWER_OFF) {
 		sdhci_writel(host, 0, SDHCI_SIGNAL_ENABLE);
-		sdhci_init(host);
+		sdhci_reinit(host);
 	}
 
 	sdhci_set_clock(host, ios->clock);
@@ -1148,7 +1190,6 @@ static void sdhci_enable_sdio_irq(struct mmc_host *mmc, int enable)
 {
 	struct sdhci_host *host;
 	unsigned long flags;
-	u32 ier;
 
 	host = mmc_priv(mmc);
 
@@ -1157,15 +1198,10 @@ static void sdhci_enable_sdio_irq(struct mmc_host *mmc, int enable)
 	if (host->flags & SDHCI_DEVICE_DEAD)
 		goto out;
 
-	ier = sdhci_readl(host, SDHCI_INT_ENABLE);
-
-	ier &= ~SDHCI_INT_CARD_INT;
 	if (enable)
-		ier |= SDHCI_INT_CARD_INT;
-
-	sdhci_writel(host, ier, SDHCI_INT_ENABLE);
-	sdhci_writel(host, ier, SDHCI_SIGNAL_ENABLE);
-
+		sdhci_unmask_irqs(host, SDHCI_INT_CARD_INT);
+	else
+		sdhci_mask_irqs(host, SDHCI_INT_CARD_INT);
 out:
 	mmiowb();
 
@@ -1507,6 +1543,8 @@ int sdhci_suspend_host(struct sdhci_host *host, pm_message_t state)
 {
 	int ret;
 
+	sdhci_disable_card_detection(host);
+
 	ret = mmc_suspend_host(host->mmc, state);
 	if (ret)
 		return ret;
@@ -1539,6 +1577,8 @@ int sdhci_resume_host(struct sdhci_host *host)
 	if (ret)
 		return ret;
 
+	sdhci_enable_card_detection(host);
+
 	return 0;
 }
 
@@ -1792,6 +1832,8 @@ int sdhci_add_host(struct sdhci_host *host)
 
 	mmc_add_host(mmc);
 
+	sdhci_enable_card_detection(host);
+
 	printk(KERN_INFO "%s: SDHCI controller on %s [%s] using %s%s\n",
 		mmc_hostname(mmc), host->hw_name, dev_name(mmc_dev(mmc)),
 		(host->flags & SDHCI_USE_ADMA)?"A":"",
@@ -1833,6 +1875,8 @@ void sdhci_remove_host(struct sdhci_host *host, int dead)
 		spin_unlock_irqrestore(&host->lock, flags);
 	}
 
+	sdhci_disable_card_detection(host);
+
 	mmc_remove_host(host->mmc);
 
 #ifdef SDHCI_USE_LEDS_CLASS
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index e907441..45c8309 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -124,6 +124,10 @@
 		SDHCI_INT_DATA_AVAIL | SDHCI_INT_SPACE_AVAIL | \
 		SDHCI_INT_DATA_TIMEOUT | SDHCI_INT_DATA_CRC | \
 		SDHCI_INT_DATA_END_BIT)
+#define SDHCI_INT_ALL_MASK	(SDHCI_INT_CMD_MASK | SDHCI_INT_DATA_MASK | \
+		SDHCI_INT_CARD_INSERT | SDHCI_INT_CARD_REMOVE | \
+		SDHCI_INT_CARD_INT | SDHCI_INT_ERROR | SDHCI_INT_BUS_POWER | \
+		SDHCI_INT_ACMD12ERR | SDHCI_INT_ADMA_ERROR)
 
 #define SDHCI_ACMD12_ERR	0x3C
 
-- 
1.5.6.5

