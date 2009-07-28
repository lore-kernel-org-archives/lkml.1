Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567AbZG1KmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbZG1KmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 06:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbZG1KmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 06:42:09 -0400
Received: from smtp.nokia.com ([192.100.122.230]:32600 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbZG1KmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 06:42:07 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       Pierre Ossman <pierre@ossman.eu>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Matt Fleming <matt@console-pimps.org>,
       lkml <linux-kernel@vger.kernel.org>
Date: Tue, 28 Jul 2009 13:41:54 +0300
Message-Id: <20090728104154.2371.57900.sendpatchset@ahunter-laptop>
In-Reply-To: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
References: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
Subject: [PATCH V2 27/32] omap_hsmmc: pass host capabilities for SD only and MMC only
X-OriginalArrivalTime: 28 Jul 2009 10:41:25.0390 (UTC) FILETIME=[F4A7BAE0:01CA0F6F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6ed0f09877e25af46579c1e7754600d31356e302 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Mon, 18 May 2009 11:33:26 +0300
Subject: [PATCH] omap_hsmmc: pass host capabilities for SD only and MMC only

Some hosts can accept only certain types of cards.
For example, an eMMC is MMC only and a uSD slot may
be SD only.  Pass host capabilities from the board
through to the driver.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 arch/arm/mach-omap2/mmc-twl4030.c     |    5 ++---
 arch/arm/mach-omap2/mmc-twl4030.h     |    2 +-
 arch/arm/plat-omap/include/mach/mmc.h |    6 +++---
 drivers/mmc/host/omap_hsmmc.c         |    7 ++++---
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-omap2/mmc-twl4030.c b/arch/arm/mach-omap2/mmc-twl4030.c
index f95c702..48765bf 100644
--- a/arch/arm/mach-omap2/mmc-twl4030.c
+++ b/arch/arm/mach-omap2/mmc-twl4030.c
@@ -464,12 +464,11 @@ void __init twl4030_mmc_init(struct twl4030_hsmmc_info *controllers)
 		} else
 			mmc->slots[0].gpio_wp = -EINVAL;
 
-		if (c->nonremovable)
-			mmc->slots[0].nonremovable = 1;
-
 		if (c->power_saving)
 			mmc->slots[0].power_saving = 1;
 
+		mmc->slots[0].caps = c->caps;
+
 		/* NOTE:  MMC slots should have a Vcc regulator set up.
 		 * This may be from a TWL4030-family chip, another
 		 * controllable regulator, or a fixed supply.
diff --git a/arch/arm/mach-omap2/mmc-twl4030.h b/arch/arm/mach-omap2/mmc-twl4030.h
index a47e685..cb43f52 100644
--- a/arch/arm/mach-omap2/mmc-twl4030.h
+++ b/arch/arm/mach-omap2/mmc-twl4030.h
@@ -12,8 +12,8 @@ struct twl4030_hsmmc_info {
 	bool	transceiver;	/* MMC-2 option */
 	bool	ext_clock;	/* use external pin for input clock */
 	bool	cover_only;	/* No card detect - just cover switch */
-	bool	nonremovable;	/* Nonremovable e.g. eMMC */
 	bool	power_saving;	/* Try to sleep or power off when possible */
+	unsigned long caps;	/* MMC host capabilities */
 	int	gpio_cd;	/* or -EINVAL */
 	int	gpio_wp;	/* or -EINVAL */
 	char	*name;		/* or NULL for default */
diff --git a/arch/arm/plat-omap/include/mach/mmc.h b/arch/arm/plat-omap/include/mach/mmc.h
index 9390297..48cf2de 100644
--- a/arch/arm/plat-omap/include/mach/mmc.h
+++ b/arch/arm/plat-omap/include/mach/mmc.h
@@ -83,12 +83,12 @@ struct omap_mmc_platform_data {
 		/* use the internal clock */
 		unsigned internal_clock:1;
 
-		/* nonremovable e.g. eMMC */
-		unsigned nonremovable:1;
-
 		/* Try to sleep or power off when possible */
 		unsigned power_saving:1;
 
+		/* MMC host capabilities */
+		unsigned long caps;
+
 		int switch_pin;			/* gpio (card detect) */
 		int gpio_wp;			/* gpio (write protect) */
 
diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 5213d87..42dfc49 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -1664,10 +1664,11 @@ static int __init omap_mmc_probe(struct platform_device *pdev)
 	else if (mmc_slot(host).wires >= 4)
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
 
-	if (mmc_slot(host).nonremovable)
-		mmc->caps |= MMC_CAP_NONREMOVABLE;
+	mmc->caps |= mmc_slot(host).caps;
 
-	mmc->caps |= MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC;
+	/* If no card caps specified then assume them all */
+	if (!(mmc->caps & (MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC)))
+		mmc->caps |= MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC;
 
 	omap_hsmmc_init(host);
 
-- 
1.5.6.3

