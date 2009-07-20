Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbZGTW1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbZGTW1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 18:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbZGTW1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 18:27:44 -0400
Received: from mail.df.lth.se ([194.47.250.12]:63587 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753975AbZGTW1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 18:27:44 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Pierre Ossman <pierre@ossman.eu>, linux-arm-kernel@lists.arm.linux.org.uk,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 2/2] Modify MMCI/PL180 to handle agressive clocking v7
Date: Tue, 21 Jul 2009 00:27:23 +0200
Message-Id: <1248128843-2528-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a few clk_enable()/clk_disable() calls to the MMCI
driver so as to handle an set_ios() request with clock
frequency set to 0 as an instruction to gate the block clock.
This also breaks out the clock setting code into its own
function to simplify the set_ios() function a bit.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/mmc/host/mmci.c |   86 +++++++++++++++++++++++++++++++++++-----------
 drivers/mmc/host/mmci.h |    3 +-
 2 files changed, 67 insertions(+), 22 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index e1aa847..db09b69 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -37,8 +37,34 @@
 
 static unsigned int fmax = 515633;
 
+/*
+ * This must be called with host->lock held
+ */
+static void mmci_set_clkreg(struct mmci_host *host, unsigned int desired)
+{
+	u32 clk = 0;
+
+	if (desired) {
+		if (desired >= host->mclk) {
+			clk = MCI_CLK_BYPASS;
+			host->cclk = host->mclk;
+			DBG(host, "MMCI: bypass clock divider, cclk = %u Hz\n", host->cclk);
+		} else {
+			clk = host->mclk / (2 * desired) - 1;
+			if (clk >= 256)
+				clk = 255;
+			host->cclk = host->mclk / (2 * (clk + 1));
+			DBG(host, "MMCI: divide cclk to %u Hz (divide %u by %u)\n", host->cclk, host->mclk, clk);
+		}
+		if (host->hw_designer == 0x80)
+			clk |= MCI_FCEN; /* Bug fix in ST IP block */
+		clk |= MCI_CLK_ENABLE;
+	}
+	writel(clk, host->base + MMCICLOCK);
+}
+
 static void
-mmci_request_end(struct mmci_host *host, struct mmc_request *mrq)
+ mmci_request_end(struct mmci_host *host, struct mmc_request *mrq)
 {
 	writel(0, host->base + MMCICOMMAND);
 
@@ -418,22 +444,7 @@ static void mmci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 static void mmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 {
 	struct mmci_host *host = mmc_priv(mmc);
-	u32 clk = 0, pwr = 0;
-
-	if (ios->clock) {
-		if (ios->clock >= host->mclk) {
-			clk = MCI_CLK_BYPASS;
-			host->cclk = host->mclk;
-		} else {
-			clk = host->mclk / (2 * ios->clock) - 1;
-			if (clk >= 256)
-				clk = 255;
-			host->cclk = host->mclk / (2 * (clk + 1));
-		}
-		if (host->hw_designer == 0x80)
-			clk |= MCI_FCEN; /* Bug fix in ST IP block */
-		clk |= MCI_CLK_ENABLE;
-	}
+	u32 pwr = 0;
 
 	if (host->plat->translate_vdd)
 		pwr |= host->plat->translate_vdd(mmc_dev(mmc), ios->vdd);
@@ -464,12 +475,30 @@ static void mmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		}
 	}
 
-	writel(clk, host->base + MMCICLOCK);
+	spin_lock(&host->lock);
+
+	/*
+	 * Turn on clock whenever ios->clock transitions
+	 * from 0 to !=0 and gate it off whenever ios->clock
+	 * transitions from !=0 to 0.
+	 */
+	if (host->iosclock == 0 && ios->clock != 0) {
+		clk_enable(host->clk);
+		mmci_set_clkreg(host, ios->clock);
+	} else if (host->iosclock != 0 && ios->clock == 0) {
+		clk_disable(host->clk);
+	}
+	host->iosclock = ios->clock;
 
 	if (host->pwr != pwr) {
 		host->pwr = pwr;
+		/* Clock may be gated (ios->clock still 0) */
+		clk_enable(host->clk);
 		writel(pwr, host->base + MMCIPOWER);
+		clk_disable(host->clk);
 	}
+
+	spin_unlock(&host->lock);
 }
 
 static const struct mmc_host_ops mmci_ops = {
@@ -546,6 +575,7 @@ static int __devinit mmci_probe(struct amba_device *dev, struct amba_id *id)
 		host->mclk = clk_get_rate(host->clk);
 		DBG(host, "eventual mclk rate: %u Hz\n", host->mclk);
 	}
+	host->iosclock = 0;
 	host->base = ioremap(dev->res.start, resource_size(&dev->res));
 	if (!host->base) {
 		ret = -ENOMEM;
@@ -615,6 +645,8 @@ static int __devinit mmci_probe(struct amba_device *dev, struct amba_id *id)
 	host->timer.expires = jiffies + HZ;
 	add_timer(&host->timer);
 
+	/* The first IOS will turn the clock on again */
+	clk_disable(host->clk);
 	return 0;
 
  irq0_free:
@@ -646,17 +678,22 @@ static int __devexit mmci_remove(struct amba_device *dev)
 
 		mmc_remove_host(mmc);
 
+		/* framework may have gated the block clock */
+		clk_enable(host->clk);
+
 		writel(0, host->base + MMCIMASK0);
 		writel(0, host->base + MMCIMASK1);
 
 		writel(0, host->base + MMCICOMMAND);
 		writel(0, host->base + MMCIDATACTRL);
 
+		clk_disable(host->clk);
+
 		free_irq(dev->irq[0], host);
 		free_irq(dev->irq[1], host);
 
 		iounmap(host->base);
-		clk_disable(host->clk);
+
 		clk_put(host->clk);
 
 		mmc_free_host(mmc);
@@ -677,8 +714,11 @@ static int mmci_suspend(struct amba_device *dev, pm_message_t state)
 		struct mmci_host *host = mmc_priv(mmc);
 
 		ret = mmc_suspend_host(mmc, state);
-		if (ret == 0)
+		if (ret == 0) {
+			clk_enable(host->clk);
 			writel(0, host->base + MMCIMASK0);
+			clk_disable(host->clk);
+		}
 	}
 
 	return ret;
@@ -692,7 +732,11 @@ static int mmci_resume(struct amba_device *dev)
 	if (mmc) {
 		struct mmci_host *host = mmc_priv(mmc);
 
-		writel(MCI_IRQENABLE, host->base + MMCIMASK0);
+		if (ret == 0) {
+			clk_enable(host->clk);
+			writel(MCI_IRQENABLE, host->base + MMCIMASK0);
+			clk_disable(host->clk);
+		}
 
 		ret = mmc_resume_host(mmc);
 	}
diff --git a/drivers/mmc/host/mmci.h b/drivers/mmc/host/mmci.h
index 0441bac..796db94 100644
--- a/drivers/mmc/host/mmci.h
+++ b/drivers/mmc/host/mmci.h
@@ -137,7 +137,7 @@
  * The size of the FIFO in bytes.
  */
 #define MCI_FIFOSIZE	(16*4)
-	
+
 #define MCI_FIFOHALFSIZE (MCI_FIFOSIZE / 2)
 
 #define NR_SG		16
@@ -158,6 +158,7 @@ struct mmci_host {
 
 	unsigned int		mclk;
 	unsigned int		cclk;
+	unsigned int		iosclock;
 	u32			pwr;
 	struct mmc_platform_data *plat;
 
-- 
1.6.2.5

