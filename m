Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbZCLQ1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbZCLQ1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 12:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757722AbZCLQZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 12:25:42 -0400
Received: from smtp.nokia.com ([192.100.122.230]:25494 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757871AbZCLQZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 12:25:41 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       David Brownell <david-b@pacbell.net>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, lkml <linux-kernel@vger.kernel.org>
Date: Thu, 12 Mar 2009 18:24:00 +0200
Message-Id: <20090312162400.19421.13764.sendpatchset@ahunter-laptop>
In-Reply-To: <20090312162252.19421.34019.sendpatchset@ahunter-laptop>
References: <20090312162252.19421.34019.sendpatchset@ahunter-laptop>
Subject: [PATCH 10/10] OMAP: HSMMC: Wait for SDBP
X-OriginalArrivalTime: 12 Mar 2009 16:23:35.0488 (UTC) FILETIME=[E48A9400:01C9A32E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e543f7849ab668fa0cbabc048e37e090e7b6f167 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Thu, 12 Mar 2009 17:08:26 +0200
Subject: [PATCH] OMAP: HSMMC: Wait for SDBP

It is necessary to wait for bus power before sending
any commands.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/host/omap_hsmmc.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 91381f4..2f444c8 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -546,6 +546,19 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static void set_sd_bus_power(struct mmc_omap_host *host)
+{
+	unsigned long i;
+
+	OMAP_HSMMC_WRITE(host->base, HCTL,
+			 OMAP_HSMMC_READ(host->base, HCTL) | SDBP);
+	for (i = 0; i < loops_per_jiffy; i++) {
+		if (OMAP_HSMMC_READ(host->base, HCTL) & SDBP)
+			break;
+		cpu_relax();
+	}
+}
+
 /*
  * Switch MMC interface voltage ... only relevant for MMC1.
  *
@@ -602,9 +615,7 @@ static int omap_mmc_switch_opcond(struct mmc_omap_host *host, int vdd)
 		reg_val |= SDVS30;
 
 	OMAP_HSMMC_WRITE(host->base, HCTL, reg_val);
-
-	OMAP_HSMMC_WRITE(host->base, HCTL,
-		OMAP_HSMMC_READ(host->base, HCTL) | SDBP);
+	set_sd_bus_power(host);
 
 	return 0;
 err:
@@ -997,8 +1008,7 @@ static void omap_hsmmc_init(struct mmc_omap_host *host)
 	OMAP_HSMMC_WRITE(host->base, SYSCONFIG, value | AUTOIDLE);
 
 	/* Set SD bus power bit */
-	value = OMAP_HSMMC_READ(host->base, HCTL);
-	OMAP_HSMMC_WRITE(host->base, HCTL, value | SDBP);
+	set_sd_bus_power(host);
 }
 
 static struct mmc_host_ops mmc_omap_ops = {
-- 
1.5.6.3

