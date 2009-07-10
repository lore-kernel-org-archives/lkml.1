Return-Path: <linux-kernel-owner+w=401wt.eu-S1756388AbZGJMnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbZGJMnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 08:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbZGJMjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 08:39:33 -0400
Received: from smtp.nokia.com ([192.100.122.230]:37192 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478AbZGJMjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 08:39:31 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Pierre Ossman <pierre@ossman.eu>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Date: Fri, 10 Jul 2009 15:41:52 +0300
Message-Id: <20090710124152.1262.35908.sendpatchset@ahunter-tower>
In-Reply-To: <20090710124004.1262.10422.sendpatchset@ahunter-tower>
References: <20090710124004.1262.10422.sendpatchset@ahunter-tower>
Subject: [PATCH 15/32] omap_hsmmc: ensure workqueues are empty before suspend
X-OriginalArrivalTime: 10 Jul 2009 12:38:17.0965 (UTC) FILETIME=[4D0A41D0:01CA015B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 697301e98721b32335caa2dc83b654c81866a97e Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Fri, 24 Apr 2009 13:13:20 +0300
Subject: [PATCH] omap_hsmmc: ensure workqueues are empty before suspend

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/host/omap_hsmmc.c |   50 +++++++++++++++++++++++++++-------------
 1 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 2e2a81c..41500ac 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -149,7 +149,6 @@ struct mmc_omap_host {
 	u32			bytesleft;
 	int			suspended;
 	int			irq;
-	int			carddetect;
 	int			use_dma, dma_ch;
 	int			dma_line_tx, dma_line_rx;
 	int			slot_id;
@@ -754,14 +753,19 @@ static void mmc_omap_detect(struct work_struct *work)
 	struct mmc_omap_host *host = container_of(work, struct mmc_omap_host,
 						mmc_carddetect_work);
 	struct omap_mmc_slot_data *slot = &mmc_slot(host);
+	int carddetect;
+
+	if (host->suspended)
+		return;
+
+	sysfs_notify(&host->mmc->class_dev.kobj, NULL, "cover_switch");
 
 	if (mmc_slot(host).card_detect)
-		host->carddetect = slot->card_detect(slot->card_detect_irq);
+		carddetect = slot->card_detect(slot->card_detect_irq);
 	else
-		host->carddetect = -ENOSYS;
+		carddetect = -ENOSYS;
 
-	sysfs_notify(&host->mmc->class_dev.kobj, NULL, "cover_switch");
-	if (host->carddetect) {
+	if (carddetect) {
 		mmc_detect_change(host->mmc, (HZ * 200) / 1000);
 	} else {
 		mmc_host_enable(host->mmc);
@@ -778,6 +782,8 @@ static irqreturn_t omap_mmc_cd_handler(int irq, void *dev_id)
 {
 	struct mmc_omap_host *host = (struct mmc_omap_host *)dev_id;
 
+	if (host->suspended)
+		return IRQ_HANDLED;
 	schedule_work(&host->mmc_carddetect_work);
 
 	return IRQ_HANDLED;
@@ -1517,30 +1523,42 @@ static int omap_mmc_suspend(struct platform_device *pdev, pm_message_t state)
 		return 0;
 
 	if (host) {
+		host->suspended = 1;
+		if (host->pdata->suspend) {
+			ret = host->pdata->suspend(&pdev->dev,
+							host->slot_id);
+			if (ret) {
+				dev_dbg(mmc_dev(host->mmc),
+					"Unable to handle MMC board"
+					" level suspend\n");
+				host->suspended = 0;
+				return ret;
+			}
+		}
+		cancel_work_sync(&host->mmc_carddetect_work);
 		mmc_host_enable(host->mmc);
 		ret = mmc_suspend_host(host->mmc, state);
 		if (ret == 0) {
-			host->suspended = 1;
-
 			OMAP_HSMMC_WRITE(host->base, ISE, 0);
 			OMAP_HSMMC_WRITE(host->base, IE, 0);
 
-			if (host->pdata->suspend) {
-				ret = host->pdata->suspend(&pdev->dev,
-								host->slot_id);
-				if (ret)
-					dev_dbg(mmc_dev(host->mmc),
-						"Unable to handle MMC board"
-						" level suspend\n");
-			}
 
 			OMAP_HSMMC_WRITE(host->base, HCTL,
 					 OMAP_HSMMC_READ(host->base, HCTL) & ~SDBP);
 			mmc_host_disable(host->mmc);
 			clk_disable(host->iclk);
 			clk_disable(host->dbclk);
-		} else
+		} else {
+			host->suspended = 0;
+			if (host->pdata->resume) {
+				ret = host->pdata->resume(&pdev->dev,
+							  host->slot_id);
+				if (ret)
+					dev_dbg(mmc_dev(host->mmc),
+						"Unmask interrupt failed\n");
+			}
 			mmc_host_disable(host->mmc);
+		}
 
 	}
 	return ret;
-- 
1.5.6.3

