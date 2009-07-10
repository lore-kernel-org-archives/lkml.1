Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbZGJMmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbZGJMmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 08:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbZGJMjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 08:39:07 -0400
Received: from smtp.nokia.com ([192.100.122.233]:34990 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351AbZGJMjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 08:39:05 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Pierre Ossman <pierre@ossman.eu>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Date: Fri, 10 Jul 2009 15:42:20 +0300
Message-Id: <20090710124220.1262.31428.sendpatchset@ahunter-tower>
In-Reply-To: <20090710124004.1262.10422.sendpatchset@ahunter-tower>
References: <20090710124004.1262.10422.sendpatchset@ahunter-tower>
Subject: [PATCH 19/32] ARM: OMAP: mmc-twl4030: add regulator sleep / wake function
X-OriginalArrivalTime: 10 Jul 2009 12:38:46.0378 (UTC) FILETIME=[5DF9BCA0:01CA015B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 99e5f5c1e7e4e8195cae27d2fc5be75424d5bc75 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Wed, 8 Jul 2009 13:20:30 +0300
Subject: [PATCH] ARM: OMAP: mmc-twl4030: add regulator sleep / wake function

Add the ability for the driver to put the card power
regulators to sleep and wake them up again.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 arch/arm/mach-omap2/mmc-twl4030.c     |   57 +++++++++++++++++++++++++++++++++
 arch/arm/plat-omap/include/mach/mmc.h |    2 +
 2 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/mmc-twl4030.c b/arch/arm/mach-omap2/mmc-twl4030.c
index 3678f0e..f95c702 100644
--- a/arch/arm/mach-omap2/mmc-twl4030.c
+++ b/arch/arm/mach-omap2/mmc-twl4030.c
@@ -334,6 +334,61 @@ static int twl_mmc23_set_power(struct device *dev, int slot, int power_on, int v
 	return ret;
 }
 
+static int twl_mmc1_set_sleep(struct device *dev, int slot, int sleep, int vdd,
+			      int cardsleep)
+{
+	struct twl_mmc_controller *c = &hsmmc[0];
+	int mode = sleep ? REGULATOR_MODE_STANDBY : REGULATOR_MODE_NORMAL;
+
+	return regulator_set_mode(c->vcc, mode);
+}
+
+static int twl_mmc23_set_sleep(struct device *dev, int slot, int sleep, int vdd,
+			       int cardsleep)
+{
+	struct twl_mmc_controller *c = NULL;
+	struct omap_mmc_platform_data *mmc = dev->platform_data;
+	int i, err, mode;
+
+	for (i = 1; i < ARRAY_SIZE(hsmmc); i++) {
+		if (mmc == hsmmc[i].mmc) {
+			c = &hsmmc[i];
+			break;
+		}
+	}
+
+	if (c == NULL)
+		return -ENODEV;
+
+	/*
+	 * If we don't see a Vcc regulator, assume it's a fixed
+	 * voltage always-on regulator.
+	 */
+	if (!c->vcc)
+		return 0;
+
+	mode = sleep ? REGULATOR_MODE_STANDBY : REGULATOR_MODE_NORMAL;
+
+	if (!c->vcc_aux)
+		return regulator_set_mode(c->vcc, mode);
+
+	if (cardsleep) {
+		/* VCC can be turned off if card is asleep */
+		struct regulator *vcc_aux = c->vcc_aux;
+
+		c->vcc_aux = NULL;
+		if (sleep)
+			err = twl_mmc23_set_power(dev, slot, 0, 0);
+		else
+			err = twl_mmc23_set_power(dev, slot, 1, vdd);
+		c->vcc_aux = vcc_aux;
+	} else
+		err = regulator_set_mode(c->vcc, mode);
+	if (err)
+		return err;
+	return regulator_set_mode(c->vcc_aux, mode);
+}
+
 static struct omap_mmc_platform_data *hsmmc_data[OMAP34XX_NR_MMC] __initdata;
 
 void __init twl4030_mmc_init(struct twl4030_hsmmc_info *controllers)
@@ -427,6 +482,7 @@ void __init twl4030_mmc_init(struct twl4030_hsmmc_info *controllers)
 		case 1:
 			/* on-chip level shifting via PBIAS0/PBIAS1 */
 			mmc->slots[0].set_power = twl_mmc1_set_power;
+			mmc->slots[0].set_sleep = twl_mmc1_set_sleep;
 			break;
 		case 2:
 			if (c->ext_clock)
@@ -437,6 +493,7 @@ void __init twl4030_mmc_init(struct twl4030_hsmmc_info *controllers)
 		case 3:
 			/* off-chip level shifting, or none */
 			mmc->slots[0].set_power = twl_mmc23_set_power;
+			mmc->slots[0].set_sleep = twl_mmc23_set_sleep;
 			break;
 		default:
 			pr_err("MMC%d configuration not supported!\n", c->mmc);
diff --git a/arch/arm/plat-omap/include/mach/mmc.h b/arch/arm/plat-omap/include/mach/mmc.h
index 82f1e29..9390297 100644
--- a/arch/arm/plat-omap/include/mach/mmc.h
+++ b/arch/arm/plat-omap/include/mach/mmc.h
@@ -95,6 +95,8 @@ struct omap_mmc_platform_data {
 		int (* set_bus_mode)(struct device *dev, int slot, int bus_mode);
 		int (* set_power)(struct device *dev, int slot, int power_on, int vdd);
 		int (* get_ro)(struct device *dev, int slot);
+		int (*set_sleep)(struct device *dev, int slot, int sleep,
+				 int vdd, int cardsleep);
 
 		/* return MMC cover switch state, can be NULL if not supported.
 		 *
-- 
1.5.6.3

