Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbZGJMkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbZGJMkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 08:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbZGJMh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 08:37:59 -0400
Received: from smtp.nokia.com ([192.100.122.230]:36831 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652AbZGJMh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 08:37:58 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Pierre Ossman <pierre@ossman.eu>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Date: Fri, 10 Jul 2009 15:41:23 +0300
Message-Id: <20090710124123.1262.89652.sendpatchset@ahunter-tower>
In-Reply-To: <20090710124004.1262.10422.sendpatchset@ahunter-tower>
References: <20090710124004.1262.10422.sendpatchset@ahunter-tower>
Subject: [PATCH 11/32] ARM: OMAP: mmc-twl4030: add context loss counter support
X-OriginalArrivalTime: 10 Jul 2009 12:37:47.0012 (UTC) FILETIME=[3A973440:01CA015B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 57e1d1301b974e57f65a8f7b1287629b3c97a3b8 Mon Sep 17 00:00:00 2001
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

