Return-Path: <linux-kernel-owner+w=401wt.eu-S1753263AbZG1Kkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbZG1Kkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 06:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbZG1Kkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 06:40:35 -0400
Received: from smtp.nokia.com ([192.100.105.134]:16578 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbZG1Kkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 06:40:32 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       Pierre Ossman <pierre@ossman.eu>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Matt Fleming <matt@console-pimps.org>,
       lkml <linux-kernel@vger.kernel.org>
Date: Tue, 28 Jul 2009 13:40:55 +0300
Message-Id: <20090728104055.2371.8723.sendpatchset@ahunter-laptop>
In-Reply-To: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
References: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
Subject: [PATCH V2 19/32] ARM: OMAP: mmc-twl4030: add regulator sleep / wake function
X-OriginalArrivalTime: 28 Jul 2009 10:40:23.0703 (UTC) FILETIME=[CFE30A70:01CA0F6F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b5f863cd167b6e3a1fb06be4e51513964fa83cb4 Mon Sep 17 00:00:00 2001
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

