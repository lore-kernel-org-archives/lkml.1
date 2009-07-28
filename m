Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbZG1KkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbZG1KkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 06:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbZG1KkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 06:40:07 -0400
Received: from smtp.nokia.com ([192.100.105.134]:16539 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbZG1KkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 06:40:03 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       Pierre Ossman <pierre@ossman.eu>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Matt Fleming <matt@console-pimps.org>,
       lkml <linux-kernel@vger.kernel.org>
Date: Tue, 28 Jul 2009 13:39:48 +0300
Message-Id: <20090728103948.2371.97902.sendpatchset@ahunter-laptop>
In-Reply-To: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
References: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
Subject: [PATCH V2 10/32] omap_hsmmc: make use of new enable/disable interface
X-OriginalArrivalTime: 28 Jul 2009 10:39:20.0314 (UTC) FILETIME=[AA1AA5A0:01CA0F6F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4ce5c79ed1c42938ee1d42d7cf172e6d1265106d Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Thu, 23 Apr 2009 10:01:29 +0300
Subject: [PATCH] omap_hsmmc: make use of new enable/disable interface

For the moment enable / disable just turns the fclk
on and off.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/host/omap_hsmmc.c |   68 +++++++++++++++++++++++++++++++++++------
 1 files changed, 58 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 0444de1..f9b7cfe 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -598,7 +598,9 @@ static void mmc_omap_detect(struct work_struct *work)
 	if (host->carddetect) {
 		mmc_detect_change(host->mmc, (HZ * 200) / 1000);
 	} else {
+		mmc_host_enable(host->mmc);
 		mmc_omap_reset_controller_fsm(host, SRD);
+		mmc_host_lazy_disable(host->mmc);
 		mmc_detect_change(host->mmc, (HZ * 50) / 1000);
 	}
 }
@@ -811,6 +813,27 @@ mmc_omap_prepare_data(struct mmc_omap_host *host, struct mmc_request *req)
 	return 0;
 }
 
+static int omap_mmc_enable(struct mmc_host *mmc)
+{
+	struct mmc_omap_host *host = mmc_priv(mmc);
+	int err;
+
+	err = clk_enable(host->fclk);
+	if (err)
+		return err;
+	dev_dbg(mmc_dev(host->mmc), "mmc_fclk: enabled\n");
+	return 0;
+}
+
+static int omap_mmc_disable(struct mmc_host *mmc, int lazy)
+{
+	struct mmc_omap_host *host = mmc_priv(mmc);
+
+	clk_disable(host->fclk);
+	dev_dbg(mmc_dev(host->mmc), "mmc_fclk: disabled\n");
+	return 0;
+}
+
 /*
  * Request function. for read/write operation
  */
@@ -834,6 +857,8 @@ static void omap_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	unsigned long timeout;
 	u32 con;
 
+	mmc_host_enable(host->mmc);
+
 	switch (ios->power_mode) {
 	case MMC_POWER_OFF:
 		mmc_slot(host).set_power(host->dev, host->slot_id, 0, 0);
@@ -912,6 +937,8 @@ static void omap_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	if (ios->bus_mode == MMC_BUSMODE_OPENDRAIN)
 		OMAP_HSMMC_WRITE(host->base, CON,
 				OMAP_HSMMC_READ(host->base, CON) | OD);
+
+	mmc_host_lazy_disable(host->mmc);
 }
 
 static int omap_hsmmc_get_cd(struct mmc_host *mmc)
@@ -962,6 +989,8 @@ static void omap_hsmmc_init(struct mmc_omap_host *host)
 }
 
 static struct mmc_host_ops mmc_omap_ops = {
+	.enable = omap_mmc_enable,
+	.disable = omap_mmc_disable,
 	.request = omap_mmc_request,
 	.set_ios = omap_mmc_set_ios,
 	.get_cd = omap_hsmmc_get_cd,
@@ -976,7 +1005,16 @@ static int mmc_regs_show(struct seq_file *s, void *data)
 	struct mmc_host *mmc = s->private;
 	struct mmc_omap_host *host = mmc_priv(mmc);
 
-	seq_printf(s, "mmc%d regs:\n", mmc->index);
+	seq_printf(s, "mmc%d:\n"
+			" enabled:\t%d\n"
+			" nesting_cnt:\t%d\n"
+			"\nregs:\n",
+			mmc->index, mmc->enabled ? 1 : 0, mmc->nesting_cnt);
+
+	if (clk_enable(host->fclk) != 0) {
+		seq_printf(s, "can't read the regs\n");
+		goto err;
+	}
 
 	seq_printf(s, "SYSCONFIG:\t0x%08x\n",
 			OMAP_HSMMC_READ(host->base, SYSCONFIG));
@@ -992,6 +1030,9 @@ static int mmc_regs_show(struct seq_file *s, void *data)
 			OMAP_HSMMC_READ(host->base, ISE));
 	seq_printf(s, "CAPA:\t\t0x%08x\n",
 			OMAP_HSMMC_READ(host->base, CAPA));
+
+	clk_disable(host->fclk);
+err:
 	return 0;
 }
 
@@ -1092,14 +1133,16 @@ static int __init omap_mmc_probe(struct platform_device *pdev)
 		goto err1;
 	}
 
-	if (clk_enable(host->fclk) != 0) {
+	mmc->caps |= MMC_CAP_DISABLE;
+	mmc_set_disable_delay(mmc, 100);
+	if (mmc_host_enable(host->mmc) != 0) {
 		clk_put(host->iclk);
 		clk_put(host->fclk);
 		goto err1;
 	}
 
 	if (clk_enable(host->iclk) != 0) {
-		clk_disable(host->fclk);
+		mmc_host_disable(host->mmc);
 		clk_put(host->iclk);
 		clk_put(host->fclk);
 		goto err1;
@@ -1192,6 +1235,8 @@ static int __init omap_mmc_probe(struct platform_device *pdev)
 	OMAP_HSMMC_WRITE(host->base, ISE, INT_EN_MASK);
 	OMAP_HSMMC_WRITE(host->base, IE, INT_EN_MASK);
 
+	mmc_host_lazy_disable(host->mmc);
+
 	mmc_add_host(mmc);
 
 	if (host->pdata->slots[host->slot_id].name != NULL) {
@@ -1220,7 +1265,7 @@ err_irq_cd:
 err_irq_cd_init:
 	free_irq(host->irq, host);
 err_irq:
-	clk_disable(host->fclk);
+	mmc_host_disable(host->mmc);
 	clk_disable(host->iclk);
 	clk_put(host->fclk);
 	clk_put(host->iclk);
@@ -1245,6 +1290,7 @@ static int omap_mmc_remove(struct platform_device *pdev)
 	struct resource *res;
 
 	if (host) {
+		mmc_host_enable(host->mmc);
 		mmc_remove_host(host->mmc);
 		if (host->pdata->cleanup)
 			host->pdata->cleanup(&pdev->dev);
@@ -1253,7 +1299,7 @@ static int omap_mmc_remove(struct platform_device *pdev)
 			free_irq(mmc_slot(host).card_detect_irq, host);
 		flush_scheduled_work();
 
-		clk_disable(host->fclk);
+		mmc_host_disable(host->mmc);
 		clk_disable(host->iclk);
 		clk_put(host->fclk);
 		clk_put(host->iclk);
@@ -1284,6 +1330,7 @@ static int omap_mmc_suspend(struct platform_device *pdev, pm_message_t state)
 		return 0;
 
 	if (host) {
+		mmc_host_enable(host->mmc);
 		ret = mmc_suspend_host(host->mmc, state);
 		if (ret == 0) {
 			host->suspended = 1;
@@ -1302,10 +1349,11 @@ static int omap_mmc_suspend(struct platform_device *pdev, pm_message_t state)
 
 			OMAP_HSMMC_WRITE(host->base, HCTL,
 					 OMAP_HSMMC_READ(host->base, HCTL) & ~SDBP);
-			clk_disable(host->fclk);
+			mmc_host_disable(host->mmc);
 			clk_disable(host->iclk);
 			clk_disable(host->dbclk);
-		}
+		} else
+			mmc_host_disable(host->mmc);
 
 	}
 	return ret;
@@ -1322,13 +1370,12 @@ static int omap_mmc_resume(struct platform_device *pdev)
 
 	if (host) {
 
-		ret = clk_enable(host->fclk);
-		if (ret)
+		if (mmc_host_enable(host->mmc) != 0)
 			goto clk_en_err;
 
 		ret = clk_enable(host->iclk);
 		if (ret) {
-			clk_disable(host->fclk);
+			mmc_host_disable(host->mmc);
 			clk_put(host->fclk);
 			goto clk_en_err;
 		}
@@ -1350,6 +1397,7 @@ static int omap_mmc_resume(struct platform_device *pdev)
 		ret = mmc_resume_host(host->mmc);
 		if (ret == 0)
 			host->suspended = 0;
+		mmc_host_lazy_disable(host->mmc);
 	}
 
 	return ret;
-- 
1.5.6.3

