Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbZG1Kn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbZG1Kn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 06:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbZG1Knz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 06:43:55 -0400
Received: from smtp.nokia.com ([192.100.122.233]:47736 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbZG1Klk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 06:41:40 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       Pierre Ossman <pierre@ossman.eu>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Matt Fleming <matt@console-pimps.org>,
       lkml <linux-kernel@vger.kernel.org>
Date: Tue, 28 Jul 2009 13:41:25 +0300
Message-Id: <20090728104125.2371.14266.sendpatchset@ahunter-laptop>
In-Reply-To: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
References: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
Subject: [PATCH V2 23/32] omap_hsmmc: cleanup macro usage
X-OriginalArrivalTime: 28 Jul 2009 10:40:53.0078 (UTC) FILETIME=[E1654F60:01CA0F6F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6a8acf9de3b12869c76ff2819e61c54c81b2c753 Mon Sep 17 00:00:00 2001
From: Denis Karpov <ext-denis.2.karpov@nokia.com>
Date: Thu, 14 May 2009 09:11:38 +0200
Subject: [PATCH] omap_hsmmc: cleanup macro usage

Use macro mmc_slot() in omap_hsmmc.

Signed-off-by: Denis Karpov <ext-denis.2.karpov@nokia.com>
Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/host/omap_hsmmc.c |   42 ++++++++++++++++++----------------------
 1 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 4309031..0373bdd 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -366,9 +366,8 @@ int mmc_omap_cover_is_closed(struct mmc_omap_host *host)
 {
 	int r = 1;
 
-	if (host->pdata->slots[host->slot_id].get_cover_state)
-		r = host->pdata->slots[host->slot_id].get_cover_state(host->dev,
-			host->slot_id);
+	if (mmc_slot(host).get_cover_state)
+		r = mmc_slot(host).get_cover_state(host->dev, host->slot_id);
 	return r;
 }
 
@@ -391,9 +390,8 @@ mmc_omap_show_slot_name(struct device *dev, struct device_attribute *attr,
 {
 	struct mmc_host *mmc = container_of(dev, struct mmc_host, class_dev);
 	struct mmc_omap_host *host = mmc_priv(mmc);
-	struct omap_mmc_slot_data slot = host->pdata->slots[host->slot_id];
 
-	return sprintf(buf, "%s\n", slot.name);
+	return sprintf(buf, "%s\n", mmc_slot(host).name);
 }
 
 static DEVICE_ATTR(slot_name, S_IRUGO, mmc_omap_show_slot_name, NULL);
@@ -625,7 +623,8 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 			(status & CMD_CRC)) {
 			if (host->cmd) {
 				if (status & CMD_TIMEOUT) {
-					mmc_omap_reset_controller_fsm(host, SRC);
+					mmc_omap_reset_controller_fsm(host,
+								      SRC);
 					host->cmd->error = -ETIMEDOUT;
 				} else {
 					host->cmd->error = -EILSEQ;
@@ -768,7 +767,7 @@ static void mmc_omap_detect(struct work_struct *work)
 
 	sysfs_notify(&host->mmc->class_dev.kobj, NULL, "cover_switch");
 
-	if (mmc_slot(host).card_detect)
+	if (slot->card_detect)
 		carddetect = slot->card_detect(slot->card_detect_irq);
 	else
 		carddetect = -ENOSYS;
@@ -823,7 +822,7 @@ static void mmc_omap_config_dma_params(struct mmc_omap_host *host,
 			sg_dma_address(sgl), 0, 0);
 	} else {
 		omap_set_dma_src_params(dma_ch, 0, OMAP_DMA_AMODE_CONSTANT,
-					(host->mapbase + OMAP_HSMMC_DATA), 0, 0);
+			(host->mapbase + OMAP_HSMMC_DATA), 0, 0);
 		omap_set_dma_dest_params(dma_ch, 0, OMAP_DMA_AMODE_POST_INC,
 			sg_dma_address(sgl), 0, 0);
 	}
@@ -911,7 +910,7 @@ mmc_omap_start_dma_transfer(struct mmc_omap_host *host, struct mmc_request *req)
 	}
 
 	ret = omap_request_dma(mmc_omap_get_dma_sync_dev(host, data), "MMC/SD",
-			       mmc_omap_dma_cb,host, &dma_ch);
+			       mmc_omap_dma_cb, host, &dma_ch);
 	if (ret != 0) {
 		dev_err(mmc_dev(host->mmc),
 			"%s: omap_request_dma() failed with %d\n",
@@ -1131,21 +1130,19 @@ static void omap_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 static int omap_hsmmc_get_cd(struct mmc_host *mmc)
 {
 	struct mmc_omap_host *host = mmc_priv(mmc);
-	struct omap_mmc_platform_data *pdata = host->pdata;
 
-	if (!pdata->slots[0].card_detect)
+	if (!mmc_slot(host).card_detect)
 		return -ENOSYS;
-	return pdata->slots[0].card_detect(pdata->slots[0].card_detect_irq);
+	return mmc_slot(host).card_detect(mmc_slot(host).card_detect_irq);
 }
 
 static int omap_hsmmc_get_ro(struct mmc_host *mmc)
 {
 	struct mmc_omap_host *host = mmc_priv(mmc);
-	struct omap_mmc_platform_data *pdata = host->pdata;
 
-	if (!pdata->slots[0].get_ro)
+	if (!mmc_slot(host).get_ro)
 		return -ENOSYS;
-	return pdata->slots[0].get_ro(host->dev, 0);
+	return mmc_slot(host).get_ro(host->dev, 0);
 }
 
 static void omap_hsmmc_init(struct mmc_omap_host *host)
@@ -1556,7 +1553,7 @@ static int __init omap_mmc_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, host);
 	INIT_WORK(&host->mmc_carddetect_work, mmc_omap_detect);
 
-	if (pdata->slots[host->slot_id].power_saving)
+	if (mmc_slot(host).power_saving)
 		mmc->ops	= &mmc_omap_ps_ops;
 	else
 		mmc->ops	= &mmc_omap_ops;
@@ -1626,12 +1623,12 @@ static int __init omap_mmc_probe(struct platform_device *pdev)
 	mmc->caps |= MMC_CAP_MMC_HIGHSPEED | MMC_CAP_SD_HIGHSPEED |
 		     MMC_CAP_WAIT_WHILE_BUSY;
 
-	if (pdata->slots[host->slot_id].wires >= 8)
+	if (mmc_slot(host).wires >= 8)
 		mmc->caps |= MMC_CAP_8_BIT_DATA;
-	else if (pdata->slots[host->slot_id].wires >= 4)
+	else if (mmc_slot(host).wires >= 4)
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
 
-	if (pdata->slots[host->slot_id].nonremovable)
+	if (mmc_slot(host).nonremovable)
 		mmc->caps |= MMC_CAP_NONREMOVABLE;
 
 	mmc->caps |= MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC;
@@ -1695,13 +1692,12 @@ static int __init omap_mmc_probe(struct platform_device *pdev)
 
 	mmc_add_host(mmc);
 
-	if (host->pdata->slots[host->slot_id].name != NULL) {
+	if (mmc_slot(host).name != NULL) {
 		ret = device_create_file(&mmc->class_dev, &dev_attr_slot_name);
 		if (ret < 0)
 			goto err_slot_name;
 	}
-	if (mmc_slot(host).card_detect_irq &&
-	    host->pdata->slots[host->slot_id].get_cover_state) {
+	if (mmc_slot(host).card_detect_irq && mmc_slot(host).get_cover_state) {
 		ret = device_create_file(&mmc->class_dev,
 					&dev_attr_cover_switch);
 		if (ret < 0)
@@ -1807,7 +1803,7 @@ static int omap_mmc_suspend(struct platform_device *pdev, pm_message_t state)
 
 
 			OMAP_HSMMC_WRITE(host->base, HCTL,
-					 OMAP_HSMMC_READ(host->base, HCTL) & ~SDBP);
+				OMAP_HSMMC_READ(host->base, HCTL) & ~SDBP);
 			mmc_host_disable(host->mmc);
 			clk_disable(host->iclk);
 			clk_disable(host->dbclk);
-- 
1.5.6.3

