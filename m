Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbZG1Kk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbZG1Kk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 06:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbZG1KkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 06:40:24 -0400
Received: from smtp.nokia.com ([192.100.122.230]:32251 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbZG1KkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 06:40:22 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       Pierre Ossman <pierre@ossman.eu>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Matt Fleming <matt@console-pimps.org>,
       lkml <linux-kernel@vger.kernel.org>
Date: Tue, 28 Jul 2009 13:40:40 +0300
Message-Id: <20090728104040.2371.85074.sendpatchset@ahunter-laptop>
In-Reply-To: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
References: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
Subject: [PATCH V2 17/32] omap_hsmmc: make use of new MMC_CAP_NONREMOVABLE host capability
X-OriginalArrivalTime: 28 Jul 2009 10:40:12.0249 (UTC) FILETIME=[C90F4C90:01CA0F6F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a5af29d59b76a8c09c3d02e46ab25754c1bb2ec6 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Mon, 11 May 2009 10:06:38 +0300
Subject: [PATCH] omap_hsmmc: make use of new MMC_CAP_NONREMOVABLE host capability

Let the board specify that a card is nonremovable e.g. eMMC

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 arch/arm/mach-omap2/mmc-twl4030.c     |    3 +++
 arch/arm/mach-omap2/mmc-twl4030.h     |    1 +
 arch/arm/plat-omap/include/mach/mmc.h |    3 +++
 drivers/mmc/host/omap_hsmmc.c         |    3 +++
 4 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/mmc-twl4030.c b/arch/arm/mach-omap2/mmc-twl4030.c
index 5be3111..67c22c6 100644
--- a/arch/arm/mach-omap2/mmc-twl4030.c
+++ b/arch/arm/mach-omap2/mmc-twl4030.c
@@ -409,6 +409,9 @@ void __init twl4030_mmc_init(struct twl4030_hsmmc_info *controllers)
 		} else
 			mmc->slots[0].gpio_wp = -EINVAL;
 
+		if (c->nonremovable)
+			mmc->slots[0].nonremovable = 1;
+
 		/* NOTE:  MMC slots should have a Vcc regulator set up.
 		 * This may be from a TWL4030-family chip, another
 		 * controllable regulator, or a fixed supply.
diff --git a/arch/arm/mach-omap2/mmc-twl4030.h b/arch/arm/mach-omap2/mmc-twl4030.h
index 3807c45..75b0c64 100644
--- a/arch/arm/mach-omap2/mmc-twl4030.h
+++ b/arch/arm/mach-omap2/mmc-twl4030.h
@@ -12,6 +12,7 @@ struct twl4030_hsmmc_info {
 	bool	transceiver;	/* MMC-2 option */
 	bool	ext_clock;	/* use external pin for input clock */
 	bool	cover_only;	/* No card detect - just cover switch */
+	bool	nonremovable;	/* Nonremovable e.g. eMMC */
 	int	gpio_cd;	/* or -EINVAL */
 	int	gpio_wp;	/* or -EINVAL */
 	char	*name;		/* or NULL for default */
diff --git a/arch/arm/plat-omap/include/mach/mmc.h b/arch/arm/plat-omap/include/mach/mmc.h
index 2f7cf31..bab486c 100644
--- a/arch/arm/plat-omap/include/mach/mmc.h
+++ b/arch/arm/plat-omap/include/mach/mmc.h
@@ -83,6 +83,9 @@ struct omap_mmc_platform_data {
 		/* use the internal clock */
 		unsigned internal_clock:1;
 
+		/* nonremovable e.g. eMMC */
+		unsigned nonremovable:1;
+
 		int switch_pin;			/* gpio (card detect) */
 		int gpio_wp;			/* gpio (write protect) */
 
diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 6222940..e618bc0 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -1383,6 +1383,9 @@ static int __init omap_mmc_probe(struct platform_device *pdev)
 	else if (pdata->slots[host->slot_id].wires >= 4)
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
 
+	if (pdata->slots[host->slot_id].nonremovable)
+		mmc->caps |= MMC_CAP_NONREMOVABLE;
+
 	mmc->caps |= MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC;
 
 	omap_hsmmc_init(host);
-- 
1.5.6.3

