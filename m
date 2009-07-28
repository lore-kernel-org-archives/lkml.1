Return-Path: <linux-kernel-owner+w=401wt.eu-S1752585AbZG1Kis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbZG1Kis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 06:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbZG1Kis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 06:38:48 -0400
Received: from smtp.nokia.com ([192.100.105.134]:16391 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbZG1Kip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 06:38:45 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       Pierre Ossman <pierre@ossman.eu>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Matt Fleming <matt@console-pimps.org>,
       lkml <linux-kernel@vger.kernel.org>
Date: Tue, 28 Jul 2009 13:38:56 +0300
Message-Id: <20090728103856.2371.60598.sendpatchset@ahunter-laptop>
In-Reply-To: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
References: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
Subject: [PATCH V2 3/32] mmc: add MMC_CAP_NONREMOVABLE host capability
X-OriginalArrivalTime: 28 Jul 2009 10:38:28.0452 (UTC) FILETIME=[8B312240:01CA0F6F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 447937e379db91975b4e834f19dfb1805d813fc4 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Mon, 11 May 2009 10:03:41 +0300
Subject: [PATCH] mmc: add MMC_CAP_NONREMOVABLE host capability

eMMC's are not removable, so unsafe resume is OK always.

To permit this a new host capability MMC_CAP_NONREMOVABLE
has been added and suspend / resume updated accordingly.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/core/mmc.c   |   41 ++++++++++++++++++++++++++++++++++-------
 drivers/mmc/core/sd.c    |   41 ++++++++++++++++++++++++++++++++++-------
 include/linux/mmc/host.h |    1 +
 3 files changed, 69 insertions(+), 14 deletions(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 06084db..3e35075 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -507,8 +507,6 @@ static void mmc_detect(struct mmc_host *host)
 	}
 }
 
-#ifdef CONFIG_MMC_UNSAFE_RESUME
-
 /*
  * Suspend callback from host.
  */
@@ -551,20 +549,49 @@ static void mmc_resume(struct mmc_host *host)
 
 }
 
-#else
+#ifdef CONFIG_MMC_UNSAFE_RESUME
 
-#define mmc_suspend NULL
-#define mmc_resume NULL
+static const struct mmc_bus_ops mmc_ops = {
+	.remove = mmc_remove,
+	.detect = mmc_detect,
+	.suspend = mmc_suspend,
+	.resume = mmc_resume,
+};
 
-#endif
+static void mmc_attach_bus_ops(struct mmc_host *host)
+{
+	mmc_attach_bus(host, &mmc_ops);
+}
+
+#else
 
 static const struct mmc_bus_ops mmc_ops = {
 	.remove = mmc_remove,
 	.detect = mmc_detect,
+	.suspend = NULL,
+	.resume = NULL,
+};
+
+static const struct mmc_bus_ops mmc_ops_unsafe = {
+	.remove = mmc_remove,
+	.detect = mmc_detect,
 	.suspend = mmc_suspend,
 	.resume = mmc_resume,
 };
 
+static void mmc_attach_bus_ops(struct mmc_host *host)
+{
+	const struct mmc_bus_ops *bus_ops;
+
+	if (host->caps & MMC_CAP_NONREMOVABLE)
+		bus_ops = &mmc_ops_unsafe;
+	else
+		bus_ops = &mmc_ops;
+	mmc_attach_bus(host, bus_ops);
+}
+
+#endif
+
 /*
  * Starting point for MMC card init.
  */
@@ -575,7 +602,7 @@ int mmc_attach_mmc(struct mmc_host *host, u32 ocr)
 	BUG_ON(!host);
 	WARN_ON(!host->claimed);
 
-	mmc_attach_bus(host, &mmc_ops);
+	mmc_attach_bus_ops(host);
 
 	/*
 	 * We need to get OCR a different way for SPI.
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index cd81c39..80cccd2 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -561,8 +561,6 @@ static void mmc_sd_detect(struct mmc_host *host)
 	}
 }
 
-#ifdef CONFIG_MMC_UNSAFE_RESUME
-
 /*
  * Suspend callback from host.
  */
@@ -605,20 +603,49 @@ static void mmc_sd_resume(struct mmc_host *host)
 
 }
 
-#else
+#ifdef CONFIG_MMC_UNSAFE_RESUME
 
-#define mmc_sd_suspend NULL
-#define mmc_sd_resume NULL
+static const struct mmc_bus_ops mmc_sd_ops = {
+	.remove = mmc_sd_remove,
+	.detect = mmc_sd_detect,
+	.suspend = mmc_sd_suspend,
+	.resume = mmc_sd_resume,
+};
 
-#endif
+static void mmc_sd_attach_bus_ops(struct mmc_host *host)
+{
+	mmc_attach_bus(host, &mmc_sd_ops);
+}
+
+#else
 
 static const struct mmc_bus_ops mmc_sd_ops = {
 	.remove = mmc_sd_remove,
 	.detect = mmc_sd_detect,
+	.suspend = NULL,
+	.resume = NULL,
+};
+
+static const struct mmc_bus_ops mmc_sd_ops_unsafe = {
+	.remove = mmc_sd_remove,
+	.detect = mmc_sd_detect,
 	.suspend = mmc_sd_suspend,
 	.resume = mmc_sd_resume,
 };
 
+static void mmc_sd_attach_bus_ops(struct mmc_host *host)
+{
+	const struct mmc_bus_ops *bus_ops;
+
+	if (host->caps & MMC_CAP_NONREMOVABLE)
+		bus_ops = &mmc_sd_ops_unsafe;
+	else
+		bus_ops = &mmc_sd_ops;
+	mmc_attach_bus(host, bus_ops);
+}
+
+#endif
+
 /*
  * Starting point for SD card init.
  */
@@ -629,7 +656,7 @@ int mmc_attach_sd(struct mmc_host *host, u32 ocr)
 	BUG_ON(!host);
 	WARN_ON(!host->claimed);
 
-	mmc_attach_bus(host, &mmc_sd_ops);
+	mmc_sd_attach_bus_ops(host);
 
 	/*
 	 * We need to get OCR a different way for SPI.
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 631a2fe..bb867d2 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -148,6 +148,7 @@ struct mmc_host {
 #define MMC_CAP_NEEDS_POLL	(1 << 5)	/* Needs polling for card-detection */
 #define MMC_CAP_8_BIT_DATA	(1 << 6)	/* Can the host do 8 bit transfers */
 #define MMC_CAP_DISABLE		(1 << 7)	/* Can the host be disabled */
+#define MMC_CAP_NONREMOVABLE	(1 << 8)	/* Nonremovable e.g. eMMC */
 
 	/* host specific block data */
 	unsigned int		max_seg_size;	/* see blk_queue_max_segment_size */
-- 
1.5.6.3

