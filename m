Return-Path: <linux-kernel-owner+w=401wt.eu-S1753085AbZG1Kjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbZG1Kjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 06:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbZG1Kjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 06:39:42 -0400
Received: from smtp.nokia.com ([192.100.105.134]:16481 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbZG1Kjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 06:39:40 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       Pierre Ossman <pierre@ossman.eu>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Matt Fleming <matt@console-pimps.org>,
       lkml <linux-kernel@vger.kernel.org>
Date: Tue, 28 Jul 2009 13:39:57 +0300
Message-Id: <20090728103957.2371.82161.sendpatchset@ahunter-laptop>
In-Reply-To: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
References: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
Subject: [PATCH V2 11/32] ARM: OMAP: mmc-twl4030: add context loss counter support
X-OriginalArrivalTime: 28 Jul 2009 10:39:25.0327 (UTC) FILETIME=[AD1791F0:01CA0F6F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 53270a4f00a21cdf90bc6d93fa4cfc229096cc15 Mon Sep 17 00:00:00 2001
From: Denis Karpov <ext-denis.2.karpov@nokia.com>
Date: Tue, 7 Jul 2009 15:54:44 +0300
Subject: [PATCH] ARM: OMAP: mmc-twl4030: add context loss counter support

PM dynamic OFF state results in context loss.  That is, the host
controller has been powered off at some point, which means the
registers have been reset.  The driver must detect when this
happens, and restore the context.  This patch adds the means
to detect context loss.

Note, the PM side is not yet implemented.

Signed-off-by: Denis Karpov <ext-denis.2.karpov@nokia.com>
Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 arch/arm/mach-omap2/mmc-twl4030.c     |   15 +++++++++++++++
 arch/arm/plat-omap/include/mach/mmc.h |    3 +++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/mmc-twl4030.c b/arch/arm/mach-omap2/mmc-twl4030.c
index 1541fd4..5be3111 100644
--- a/arch/arm/mach-omap2/mmc-twl4030.c
+++ b/arch/arm/mach-omap2/mmc-twl4030.c
@@ -192,6 +192,18 @@ static int twl_mmc_resume(struct device *dev, int slot)
 #define twl_mmc_resume	NULL
 #endif
 
+#if defined(CONFIG_ARCH_OMAP3) && defined(CONFIG_PM)
+
+static int twl4030_mmc_get_context_loss(struct device *dev)
+{
+	/* FIXME: PM DPS not implemented yet */
+	return 0;
+}
+
+#else
+#define twl4030_mmc_get_context_loss NULL
+#endif
+
 static int twl_mmc1_set_power(struct device *dev, int slot, int power_on,
 				int vdd)
 {
@@ -384,6 +396,9 @@ void __init twl4030_mmc_init(struct twl4030_hsmmc_info *controllers)
 		} else
 			mmc->slots[0].switch_pin = -EINVAL;
 
+		mmc->get_context_loss_count =
+				twl4030_mmc_get_context_loss;
+
 		/* write protect normally uses an OMAP gpio */
 		if (gpio_is_valid(c->gpio_wp)) {
 			gpio_request(c->gpio_wp, "mmc_wp");
diff --git a/arch/arm/plat-omap/include/mach/mmc.h b/arch/arm/plat-omap/include/mach/mmc.h
index 81d5b36..2f7cf31 100644
--- a/arch/arm/plat-omap/include/mach/mmc.h
+++ b/arch/arm/plat-omap/include/mach/mmc.h
@@ -59,6 +59,9 @@ struct omap_mmc_platform_data {
 	int (*suspend)(struct device *dev, int slot);
 	int (*resume)(struct device *dev, int slot);
 
+	/* Return context loss count due to PM states changing */
+	int (*get_context_loss_count)(struct device *dev);
+
 	u64 dma_mask;
 
 	struct omap_mmc_slot_data {
-- 
1.5.6.3

