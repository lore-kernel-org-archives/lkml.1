Return-Path: <linux-kernel-owner+w=401wt.eu-S1423093AbXDXUrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423093AbXDXUrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423089AbXDXUqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:46:46 -0400
Received: from smtp.nokia.com ([131.228.20.173]:22718 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423049AbXDXUqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:46:45 -0400
Message-ID: <462E6ABB.6010701@indt.org.br>
Date: Tue, 24 Apr 2007 16:38:19 -0400
From: Carlos Aguiar <carlos.aguiar@indt.org.br>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>, linux-kernel@vger.kernel.org,
       "Anderson F. Briglia" <anderson.briglia@indt.org.br>
Subject: [PATCH 3/3] MMC: OMAP: Clean up omap set_ios and make MMC_POWER_ON
 work
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------040005080908040008080607"
X-OriginalArrivalTime: 24 Apr 2007 20:44:36.0656 (UTC) FILETIME=[5F1F2B00:01C786B1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040005080908040008080607
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



--------------040005080908040008080607
Content-Type: text/plain;
 name*0="003-MMC-OMAP-Clean-up-omap-set_ios-and-make-MMC_POWER_ON-work.di";
 name*1="ff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="003-MMC-OMAP-Clean-up-omap-set_ios-and-make-MMC_POWER_ON-wor";
 filename*1="k.diff"

Move divisor calculation into a separate function and
re-arrange the init order to make MMC_POWER_ON work.

Signed-off-by: Tony Lindgren <tony@atomide.com>

Index: linux-2.6.20/drivers/mmc/omap.c
===================================================================
--- linux-2.6.20.orig/drivers/mmc/omap.c	2007-04-24 15:22:25.000000000 -0400
+++ linux-2.6.20/drivers/mmc/omap.c	2007-04-24 15:22:28.000000000 -0400
@@ -937,33 +937,41 @@ static void mmc_omap_power(struct mmc_om
 	}
 }
 
-static void mmc_omap_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
+static int mmc_omap_calc_divisor(struct mmc_host *mmc, struct mmc_ios *ios)
 {
 	struct mmc_omap_host *host = mmc_priv(mmc);
+	int func_clk_rate = clk_get_rate(host->fclk);
 	int dsor;
-	int realclock, i;
-
-	realclock = ios->clock;
 
 	if (ios->clock == 0)
-		dsor = 0;
-	else {
-		int func_clk_rate = clk_get_rate(host->fclk);
-
-		dsor = func_clk_rate / realclock;
-		if (dsor < 1)
-			dsor = 1;
+		return 0;
 
-		if (func_clk_rate / dsor > realclock)
-			dsor++;
+	dsor = func_clk_rate / ios->clock;
+	if (dsor < 1)
+		dsor = 1;
 
-		if (dsor > 250)
-			dsor = 250;
+	if (func_clk_rate / dsor > ios->clock)
 		dsor++;
 
-		if (ios->bus_width == MMC_BUS_WIDTH_4)
-			dsor |= 1 << 15;
-	}
+	if (dsor > 250)
+		dsor = 250;
+	dsor++;
+
+	if (ios->bus_width == MMC_BUS_WIDTH_4)
+		dsor |= 1 << 15;
+
+	return dsor;
+}
+
+static void mmc_omap_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
+{
+	struct mmc_omap_host *host = mmc_priv(mmc);
+	int dsor;
+	int i;
+
+	dsor = mmc_omap_calc_divisor(mmc, ios);
+	host->bus_mode = ios->bus_mode;
+	host->hw_bus_mode = host->bus_mode;
 
 	switch (ios->power_mode) {
 	case MMC_POWER_OFF:
@@ -978,9 +986,6 @@ static void mmc_omap_set_ios(struct mmc_
 		break;
 	}
 
-	host->bus_mode = ios->bus_mode;
-	host->hw_bus_mode = host->bus_mode;
-
 	clk_enable(host->fclk);
 
 	/* On insanely high arm_per frequencies something sometimes

--------------040005080908040008080607--
