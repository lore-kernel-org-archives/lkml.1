Return-Path: <linux-kernel-owner+w=401wt.eu-S1753229AbZHSQl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbZHSQl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbZHSQlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:41:55 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47928 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617AbZHSQly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:41:54 -0400
Message-ID: <52236.192.168.10.88.1250700055.squirrel@dbdmail.itg.ti.com>
Date: Wed, 19 Aug 2009 22:10:55 +0530 (IST)
Subject: [PATCH V2] omap_hsmmc: Fix for the db clock failure message
From: "Madhusudhan Chikkature" <madhu.cr@ti.com>
To: akpm@linux-foundation.org, linux-mmc@vger.kernel.org
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The patch applies on top of the series "[PATCH V2 0/32] mmc and omap_hsmmc
patches" posted by Adrian Hunter.

Regards,
Madhu
----


This patch removes the error message "Failed to get debounce clock.." printed
out by the MMC driver on OMAP3430. The debounce clock needs to be handled only
for OMAP2430.

Signed-off-by: Madhusudhan Chikkature <madhu.cr@ti.com>
---
 drivers/mmc/host/omap_hsmmc.c |   46 ++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 21 deletions(-)

Index: linux-2.6/drivers/mmc/host/omap_hsmmc.c
===================================================================
--- linux-2.6.orig/drivers/mmc/host/omap_hsmmc.c
+++ linux-2.6/drivers/mmc/host/omap_hsmmc.c
@@ -160,7 +160,7 @@ struct omap_hsmmc_host {
 	int			use_dma, dma_ch;
 	int			dma_line_tx, dma_line_rx;
 	int			slot_id;
-	int			dbclk_enabled;
+	int			got_dbclk;
 	int			response_busy;
 	int			context_loss;
 	int			dpm_state;
@@ -735,7 +735,7 @@ static int omap_hsmmc_switch_opcond(stru
 	/* Disable the clocks */
 	clk_disable(host->fclk);
 	clk_disable(host->iclk);
-	if (host->dbclk_enabled)
+	if (host->got_dbclk)
 		clk_disable(host->dbclk);

 	/* Turn the power off */
@@ -746,9 +746,9 @@ static int omap_hsmmc_switch_opcond(stru
 		ret = mmc_slot(host).set_power(host->dev, host->slot_id, 1,
 					       vdd);
 	clk_enable(host->iclk);
-	if (host->dbclk_enabled)
-		clk_enable(host->dbclk);
 	clk_enable(host->fclk);
+	if (host->got_dbclk)
+		clk_enable(host->dbclk);

 	if (ret != 0)
 		goto err;
@@ -1697,18 +1697,22 @@ static int __init omap_hsmmc_probe(struc
 		goto err1;
 	}

-	host->dbclk = clk_get(&pdev->dev, "mmchsdb_fck");
-	/*
-	 * MMC can still work without debounce clock.
-	 */
-	if (IS_ERR(host->dbclk))
-		dev_warn(mmc_dev(host->mmc), "Failed to get debounce clock\n");
-	else
-		if (clk_enable(host->dbclk) != 0)
-			dev_dbg(mmc_dev(host->mmc), "Enabling debounce"
-							" clk failed\n");
+	if (cpu_is_omap2430()) {
+		host->dbclk = clk_get(&pdev->dev, "mmchsdb_fck");
+		/*
+		 * MMC can still work without debounce clock.
+		 */
+		if (IS_ERR(host->dbclk))
+			dev_warn(mmc_dev(host->mmc),
+				"Failed to get debounce clock\n");
 		else
-			host->dbclk_enabled = 1;
+			host->got_dbclk = 1;
+
+		if (host->got_dbclk)
+			if (clk_enable(host->dbclk) != 0)
+				dev_dbg(mmc_dev(host->mmc), "Enabling debounce"
+							" clk failed\n");
+	}

 	/* Since we do only SG emulation, we can have as many segs
 	 * as we want. */
@@ -1825,7 +1829,7 @@ err_irq:
 	clk_disable(host->iclk);
 	clk_put(host->fclk);
 	clk_put(host->iclk);
-	if (host->dbclk_enabled) {
+	if (host->got_dbclk) {
 		clk_disable(host->dbclk);
 		clk_put(host->dbclk);
 	}
@@ -1859,7 +1863,7 @@ static int omap_hsmmc_remove(struct plat
 		clk_disable(host->iclk);
 		clk_put(host->fclk);
 		clk_put(host->iclk);
-		if (host->dbclk_enabled) {
+		if (host->got_dbclk) {
 			clk_disable(host->dbclk);
 			clk_put(host->dbclk);
 		}
@@ -1910,7 +1914,7 @@ static int omap_hsmmc_suspend(struct pla
 				OMAP_HSMMC_READ(host->base, HCTL) & ~SDBP);
 			mmc_host_disable(host->mmc);
 			clk_disable(host->iclk);
-			if (host->dbclk_enabled)
+			if (host->got_dbclk)
 				clk_disable(host->dbclk);
 		} else {
 			host->suspended = 0;
@@ -1942,14 +1946,14 @@ static int omap_hsmmc_resume(struct plat
 		if (ret)
 			goto clk_en_err;

-		if (host->dbclk_enabled)
-			clk_enable(host->dbclk);
-
 		if (mmc_host_enable(host->mmc) != 0) {
 			clk_disable(host->iclk);
 			goto clk_en_err;
 		}

+		if (host->got_dbclk)
+			clk_enable(host->dbclk);
+
 		omap_hsmmc_conf_bus_power(host);

 		if (host->pdata->resume) {


