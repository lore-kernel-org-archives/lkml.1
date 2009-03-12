Return-Path: <linux-kernel-owner+w=401wt.eu-S1757674AbZCLQYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674AbZCLQYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 12:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757468AbZCLQXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 12:23:20 -0400
Received: from smtp.nokia.com ([192.100.122.230]:25191 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757436AbZCLQXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 12:23:14 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       David Brownell <david-b@pacbell.net>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, lkml <linux-kernel@vger.kernel.org>
Date: Thu, 12 Mar 2009 18:23:26 +0200
Message-Id: <20090312162326.19421.20582.sendpatchset@ahunter-laptop>
In-Reply-To: <20090312162252.19421.34019.sendpatchset@ahunter-laptop>
References: <20090312162252.19421.34019.sendpatchset@ahunter-laptop>
Subject: [PATCH 5/10] OMAP: HSMMC: Allow cover switch to cause rescan
X-OriginalArrivalTime: 12 Mar 2009 16:23:01.0873 (UTC) FILETIME=[D0815610:01C9A32E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 702faf54a21016777bfedf94ea709b2f05b5aee2 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Mon, 26 Jan 2009 13:17:25 +0200
Subject: [PATCH] OMAP: HSMMC: Allow cover switch to cause rescan

Allow a cover switch to be used to cause a rescan of the
MMC slot.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/host/omap_hsmmc.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index fd1657a..f3e4e0f 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -571,7 +571,10 @@ static void mmc_omap_detect(struct work_struct *work)
 						mmc_carddetect_work);
 	struct omap_mmc_slot_data *slot = &mmc_slot(host);
 
-	host->carddetect = slot->card_detect(slot->card_detect_irq);
+	if (mmc_slot(host).card_detect)
+		host->carddetect = slot->card_detect(slot->card_detect_irq);
+	else
+		host->carddetect = -ENOSYS;
 
 	sysfs_notify(&host->mmc->class_dev.kobj, NULL, "cover_switch");
 	if (host->carddetect) {
@@ -1089,7 +1092,7 @@ static int __init omap_mmc_probe(struct platform_device *pdev)
 	}
 
 	/* Request IRQ for card detect */
-	if ((mmc_slot(host).card_detect_irq) && (mmc_slot(host).card_detect)) {
+	if ((mmc_slot(host).card_detect_irq)) {
 		ret = request_irq(mmc_slot(host).card_detect_irq,
 				  omap_mmc_cd_handler,
 				  IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING
@@ -1112,8 +1115,8 @@ static int __init omap_mmc_probe(struct platform_device *pdev)
 		if (ret < 0)
 			goto err_slot_name;
 	}
-	if (mmc_slot(host).card_detect_irq && mmc_slot(host).card_detect &&
-			host->pdata->slots[host->slot_id].get_cover_state) {
+	if (mmc_slot(host).card_detect_irq &&
+	    host->pdata->slots[host->slot_id].get_cover_state) {
 		ret = device_create_file(&mmc->class_dev,
 					&dev_attr_cover_switch);
 		if (ret < 0)
-- 
1.5.6.3

