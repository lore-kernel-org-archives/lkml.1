Return-Path: <linux-kernel-owner+w=401wt.eu-S1751490AbZL1M2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbZL1M2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 07:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbZL1M2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 07:28:30 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:56804 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbZL1M2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 07:28:30 -0500
From: Vipin Bhandari <vipin.bhandari@ti.com>
To: linux-kernel@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com, drzeus-mmc@drzeus.cx,
       david-b@pacbell.net, akpm@linux-foundation.org,
       Vipin Bhandari <vipin.bhandari@ti.com>
Subject: [PATCH] davinci: MMC: Adding support for 8bit MMC cards
Date: Mon, 28 Dec 2009 17:34:25 +0530
Message-Id: <1262001865-4373-1-git-send-email-vipin.bhandari@ti.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the support for 8bit MMC cards. The controller
data width is configurable depending on the wires setting in the
platform data structure.

MMC 8bit is tested on OMAPL137 and MMC 4bit is tested on OMAPL138 EVM.

Signed-off-by: Vipin Bhandari <vipin.bhandari@ti.com>
---

 This patch has been generated against latest Linus's kernel.

 drivers/mmc/host/davinci_mmc.c |   45 +++++++++++++++++++++++++++++++--------
 1 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index dd45e7c..3bd0ba2 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -73,6 +73,7 @@
 /* DAVINCI_MMCCTL definitions */
 #define MMCCTL_DATRST         (1 << 0)
 #define MMCCTL_CMDRST         (1 << 1)
+#define MMCCTL_WIDTH_8_BIT    (1 << 8)
 #define MMCCTL_WIDTH_4_BIT    (1 << 2)
 #define MMCCTL_DATEG_DISABLED (0 << 6)
 #define MMCCTL_DATEG_RISING   (1 << 6)
@@ -791,22 +792,42 @@ static void calculate_clk_divider(struct mmc_host *mmc, struct mmc_ios *ios)
 
 static void mmc_davinci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 {
-	unsigned int mmc_pclk = 0;
 	struct mmc_davinci_host *host = mmc_priv(mmc);
 
-	mmc_pclk = host->mmc_input_clk;
 	dev_dbg(mmc_dev(host->mmc),
 		"clock %dHz busmode %d powermode %d Vdd %04x\n",
 		ios->clock, ios->bus_mode, ios->power_mode,
 		ios->vdd);
-	if (ios->bus_width == MMC_BUS_WIDTH_4) {
-		dev_dbg(mmc_dev(host->mmc), "Enabling 4 bit mode\n");
-		writel(readl(host->base + DAVINCI_MMCCTL) | MMCCTL_WIDTH_4_BIT,
-			host->base + DAVINCI_MMCCTL);
-	} else {
-		dev_dbg(mmc_dev(host->mmc), "Disabling 4 bit mode\n");
-		writel(readl(host->base + DAVINCI_MMCCTL) & ~MMCCTL_WIDTH_4_BIT,
+
+	switch (ios->bus_width) {
+	case MMC_BUS_WIDTH_8:
+		dev_dbg(mmc_dev(host->mmc), "Enabling 8 bit mode\n");
+		writel((readl(host->base + DAVINCI_MMCCTL) &
+			~MMCCTL_WIDTH_4_BIT) | MMCCTL_WIDTH_8_BIT,
 			host->base + DAVINCI_MMCCTL);
+		break;
+	case MMC_BUS_WIDTH_4:
+		dev_dbg(mmc_dev(host->mmc), "Enabling 4 bit mode\n");
+		if (host->version == MMC_CTLR_VERSION_2)
+			writel((readl(host->base + DAVINCI_MMCCTL) &
+				~MMCCTL_WIDTH_8_BIT) | MMCCTL_WIDTH_4_BIT,
+				host->base + DAVINCI_MMCCTL);
+		else
+			writel(readl(host->base + DAVINCI_MMCCTL) |
+				MMCCTL_WIDTH_4_BIT,
+				host->base + DAVINCI_MMCCTL);
+		break;
+	case MMC_BUS_WIDTH_1:
+		dev_dbg(mmc_dev(host->mmc), "Enabling 1 bit mode\n");
+		if (host->version == MMC_CTLR_VERSION_2)
+			writel(readl(host->base + DAVINCI_MMCCTL) &
+				~(MMCCTL_WIDTH_8_BIT | MMCCTL_WIDTH_4_BIT),
+				host->base + DAVINCI_MMCCTL);
+		else
+			writel(readl(host->base + DAVINCI_MMCCTL) &
+				~MMCCTL_WIDTH_4_BIT,
+				host->base + DAVINCI_MMCCTL);
+		break;
 	}
 
 	calculate_clk_divider(mmc, ios);
@@ -1189,10 +1210,14 @@ static int __init davinci_mmcsd_probe(struct platform_device *pdev)
 
 	/* REVISIT:  someday, support IRQ-driven card detection.  */
 	mmc->caps |= MMC_CAP_NEEDS_POLL;
+	mmc->caps |= MMC_CAP_WAIT_WHILE_BUSY;
 
-	if (!pdata || pdata->wires == 4 || pdata->wires == 0)
+	if (pdata && (pdata->wires == 4 || pdata->wires == 0))
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
 
+	if (pdata && (pdata->wires == 8))
+		mmc->caps |= (MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA);
+
 	host->version = pdata->version;
 
 	mmc->ops = &mmc_davinci_ops;
-- 
1.5.6

