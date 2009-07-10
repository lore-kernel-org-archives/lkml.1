Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbZGJMjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbZGJMjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 08:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbZGJMhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 08:37:35 -0400
Received: from smtp.nokia.com ([192.100.122.233]:34864 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbZGJMh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 08:37:29 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Pierre Ossman <pierre@ossman.eu>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Date: Fri, 10 Jul 2009 15:40:54 +0300
Message-Id: <20090710124054.1262.18902.sendpatchset@ahunter-tower>
In-Reply-To: <20090710124004.1262.10422.sendpatchset@ahunter-tower>
References: <20090710124004.1262.10422.sendpatchset@ahunter-tower>
Subject: [PATCH 7/32] mmc: add host capabilities for SD only and MMC only
X-OriginalArrivalTime: 10 Jul 2009 12:37:20.0659 (UTC) FILETIME=[2AE20E30:01CA015B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 27ed1443884c0e46855485cfc2190e1d80a0f568 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Tue, 7 Jul 2009 12:20:48 +0300
Subject: [PATCH] mmc: add host capabilities for SD only and MMC only

Some hosts can accept only certain types of cards.
For example, an eMMC is MMC only and a uSD slot may
be SD only.  However the MMC card scanning logic
checks for all card types one by one.

Add host capabilities to specify which card types
cannot be used, and amend the card scanning logic
to skip scanning for those types.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/core/core.c  |   16 +++++++++++++++-
 include/linux/mmc/host.h |    7 +++++++
 2 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index c5a7857..db43a1d 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1066,7 +1066,11 @@ void mmc_rescan(struct work_struct *work)
 	mmc_power_up(host);
 	mmc_go_idle(host);
 
-	mmc_send_if_cond(host, host->ocr_avail);
+	if (!(host->caps & MMC_CAP_NOT_SDIO) || !(host->caps & MMC_CAP_NOT_SD))
+		mmc_send_if_cond(host, host->ocr_avail);
+
+	if (host->caps & MMC_CAP_NOT_SDIO)
+		goto not_sdio;
 
 	/*
 	 * First we search for SDIO...
@@ -1078,6 +1082,10 @@ void mmc_rescan(struct work_struct *work)
 		goto out;
 	}
 
+not_sdio:
+	if (host->caps & MMC_CAP_NOT_SD)
+		goto not_sd;
+
 	/*
 	 * ...then normal SD...
 	 */
@@ -1088,6 +1096,10 @@ void mmc_rescan(struct work_struct *work)
 		goto out;
 	}
 
+not_sd:
+	if (host->caps & MMC_CAP_NOT_MMC)
+		goto not_mmc;
+
 	/*
 	 * ...and finally MMC.
 	 */
@@ -1098,6 +1110,8 @@ void mmc_rescan(struct work_struct *work)
 		goto out;
 	}
 
+not_mmc:
+
 	mmc_release_host(host);
 	mmc_power_off(host);
 
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 0a60b02..e996967 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -150,6 +150,13 @@ struct mmc_host {
 #define MMC_CAP_DISABLE		(1 << 7)	/* Can the host be disabled */
 #define MMC_CAP_NONREMOVABLE	(1 << 8)	/* Nonremovable e.g. eMMC */
 #define MMC_CAP_WAIT_WHILE_BUSY	(1 << 9)	/* Waits while card is busy */
+#define MMC_CAP_NOT_SDIO	(1 << 10)	/* Card cannot be SDIO */
+#define MMC_CAP_NOT_SD		(1 << 11)	/* Card cannot be SD */
+#define MMC_CAP_NOT_MMC		(1 << 12)	/* Card cannot be MMC */
+
+#define MMC_CAP_SDIO_ONLY	(MMC_CAP_NOT_SD | MMC_CAP_NOT_MMC)
+#define MMC_CAP_SD_ONLY		(MMC_CAP_NOT_SDIO | MMC_CAP_NOT_MMC)
+#define MMC_CAP_MMC_ONLY	(MMC_CAP_NOT_SDIO | MMC_CAP_NOT_SD)
 
 	/* host specific block data */
 	unsigned int		max_seg_size;	/* see blk_queue_max_segment_size */
-- 
1.5.6.3

