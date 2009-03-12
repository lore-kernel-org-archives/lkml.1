Return-Path: <linux-kernel-owner+w=401wt.eu-S1757737AbZCLQZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737AbZCLQZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 12:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757317AbZCLQXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 12:23:36 -0400
Received: from smtp.nokia.com ([192.100.122.230]:25233 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757492AbZCLQX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 12:23:28 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       David Brownell <david-b@pacbell.net>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, lkml <linux-kernel@vger.kernel.org>
Date: Thu, 12 Mar 2009 18:23:19 +0200
Message-Id: <20090312162319.19421.94489.sendpatchset@ahunter-laptop>
In-Reply-To: <20090312162252.19421.34019.sendpatchset@ahunter-laptop>
References: <20090312162252.19421.34019.sendpatchset@ahunter-laptop>
Subject: [PATCH 4/10] OMAP: HSMMC: Add 8-bit bus width mode support
X-OriginalArrivalTime: 12 Mar 2009 16:22:55.0176 (UTC) FILETIME=[CC837480:01C9A32E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7961505a57b8a9dff7b6fc8bbee654165a1b05b2 Mon Sep 17 00:00:00 2001
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Date: Fri, 21 Nov 2008 16:49:54 +0200
Subject: [PATCH] OMAP: HSMMC: Add 8-bit bus width mode support

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
---
 drivers/mmc/host/omap_hsmmc.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 483e591..fd1657a 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -77,6 +77,7 @@
 #define MSBS			(1 << 5)
 #define BCE			(1 << 1)
 #define FOUR_BIT		(1 << 1)
+#define DW8			(1 << 5)
 #define CC			0x1
 #define TC			0x02
 #define OD			0x1
@@ -817,6 +818,7 @@ static void omap_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	u16 dsor = 0;
 	unsigned long regval;
 	unsigned long timeout;
+	u32 con;
 
 	switch (ios->power_mode) {
 	case MMC_POWER_OFF:
@@ -827,12 +829,18 @@ static void omap_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		break;
 	}
 
+	con = OMAP_HSMMC_READ(host->base, CON);
 	switch (mmc->ios.bus_width) {
+	case MMC_BUS_WIDTH_8:
+		OMAP_HSMMC_WRITE(host->base, CON, con | DW8);
+		break;
 	case MMC_BUS_WIDTH_4:
+		OMAP_HSMMC_WRITE(host->base, CON, con & ~DW8);
 		OMAP_HSMMC_WRITE(host->base, HCTL,
 			OMAP_HSMMC_READ(host->base, HCTL) | FOUR_BIT);
 		break;
 	case MMC_BUS_WIDTH_1:
+		OMAP_HSMMC_WRITE(host->base, CON, con & ~DW8);
 		OMAP_HSMMC_WRITE(host->base, HCTL,
 			OMAP_HSMMC_READ(host->base, HCTL) & ~FOUR_BIT);
 		break;
@@ -1057,7 +1065,9 @@ static int __init omap_mmc_probe(struct platform_device *pdev)
 	mmc->ocr_avail = mmc_slot(host).ocr_mask;
 	mmc->caps |= MMC_CAP_MMC_HIGHSPEED | MMC_CAP_SD_HIGHSPEED;
 
-	if (pdata->slots[host->slot_id].wires >= 4)
+	if (pdata->slots[host->slot_id].wires >= 8)
+		mmc->caps |= MMC_CAP_8_BIT_DATA;
+	else if (pdata->slots[host->slot_id].wires >= 4)
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
 
 	omap_hsmmc_init(host);
-- 
1.5.6.3

