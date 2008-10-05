Return-Path: <linux-kernel-owner+w=401wt.eu-S1759350AbYJEQat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350AbYJEQat (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759022AbYJEQWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:22:50 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:62785 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756944AbYJEQWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:22:49 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH v2 2/7] atmel-mci: Don't stop the clock between transfers
Date: Sun,  5 Oct 2008 18:21:25 +0200
Message-Id: <1223223690-2637-3-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1223223690-2637-2-git-send-email-haavard.skinnemoen@atmel.com>
References: <1223223690-2637-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1223223690-2637-2-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 05 Oct 2008 16:21:15.0119 (UTC) FILETIME=[639B77F0:01C92706]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some cards might get upset if we turn off the clock for extended periods
of time. So keep the clock running until the mmc core tells us to turn
it off.

Also, don't reset the controller between each transfer. That was an
attempt to work around earlier bugs, and it never really worked very
well.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/mmc/host/atmel-mci.c |   60 +++++++++++++++--------------------------
 1 files changed, 22 insertions(+), 38 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index d834e37..14ab28d 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -279,23 +279,6 @@ err:
 		"failed to initialize debugfs for controller\n");
 }
 
-static void atmci_enable(struct atmel_mci *host)
-{
-	clk_enable(host->mck);
-	mci_writel(host, CR, MCI_CR_MCIEN);
-	mci_writel(host, MR, host->mode_reg);
-	mci_writel(host, SDCR, host->sdc_reg);
-}
-
-static void atmci_disable(struct atmel_mci *host)
-{
-	mci_writel(host, CR, MCI_CR_SWRST);
-
-	/* Stall until write is complete, then disable the bus clock */
-	mci_readl(host, SR);
-	clk_disable(host->mck);
-}
-
 static inline unsigned int ns_to_clocks(struct atmel_mci *host,
 					unsigned int ns)
 {
@@ -408,8 +391,6 @@ static void atmci_request_end(struct mmc_host *mmc, struct mmc_request *mrq)
 	WARN_ON(host->cmd || host->data);
 	host->mrq = NULL;
 
-	atmci_disable(host);
-
 	mmc_request_done(mmc, mrq);
 }
 
@@ -476,8 +457,6 @@ static void atmci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 	host->completed_events = 0;
 	host->state = STATE_SENDING_CMD;
 
-	atmci_enable(host);
-
 	/* We don't support multiple blocks of weird lengths. */
 	data = mrq->data;
 	if (data) {
@@ -520,7 +499,6 @@ static void atmci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 	return;
 
 fail:
-	atmci_disable(host);
 	host->mrq = NULL;
 	mrq->cmd->error = -EINVAL;
 	mmc_request_done(mmc, mrq);
@@ -530,9 +508,21 @@ static void atmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 {
 	struct atmel_mci	*host = mmc_priv(mmc);
 
+	switch (ios->bus_width) {
+	case MMC_BUS_WIDTH_1:
+		host->sdc_reg = 0;
+		break;
+	case MMC_BUS_WIDTH_4:
+		host->sdc_reg = MCI_SDCBUS_4BIT;
+		break;
+	}
+
 	if (ios->clock) {
 		u32 clkdiv;
 
+		if (!host->mode_reg)
+			clk_enable(host->mck);
+
 		/* Set clock rate */
 		clkdiv = DIV_ROUND_UP(host->bus_hz, 2 * ios->clock) - 1;
 		if (clkdiv > 255) {
@@ -544,26 +534,20 @@ static void atmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 
 		host->mode_reg = MCI_MR_CLKDIV(clkdiv) | MCI_MR_WRPROOF
 					| MCI_MR_RDPROOF;
-	}
 
-	switch (ios->bus_width) {
-	case MMC_BUS_WIDTH_1:
-		host->sdc_reg = 0;
-		break;
-	case MMC_BUS_WIDTH_4:
-		host->sdc_reg = MCI_SDCBUS_4BIT;
-		break;
+		mci_writel(host, CR, MCI_CR_MCIEN);
+		mci_writel(host, MR, host->mode_reg);
+		mci_writel(host, SDCR, host->sdc_reg);
+	} else {
+		mci_writel(host, CR, MCI_CR_MCIDIS);
+		if (host->mode_reg) {
+			mci_readl(host, MR);
+			clk_disable(host->mck);
+		}
+		host->mode_reg = 0;
 	}
 
 	switch (ios->power_mode) {
-	case MMC_POWER_ON:
-		/* Send init sequence (74 clock cycles) */
-		atmci_enable(host);
-		mci_writel(host, CMDR, MCI_CMDR_SPCMD_INIT);
-		while (!(mci_readl(host, SR) & MCI_CMDRDY))
-			cpu_relax();
-		atmci_disable(host);
-		break;
 	default:
 		/*
 		 * TODO: None of the currently available AVR32-based
-- 
1.5.6.5

