Return-Path: <linux-kernel-owner+w=401wt.eu-S1753737AbZG1KoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbZG1KoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 06:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbZG1KoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 06:44:16 -0400
Received: from smtp.nokia.com ([192.100.105.134]:16644 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbZG1Klf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 06:41:35 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       Pierre Ossman <pierre@ossman.eu>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Matt Fleming <matt@console-pimps.org>,
       lkml <linux-kernel@vger.kernel.org>
Date: Tue, 28 Jul 2009 13:41:08 +0300
Message-Id: <20090728104108.2371.1450.sendpatchset@ahunter-laptop>
In-Reply-To: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
References: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
Subject: [PATCH V2 21/32] omap_hsmmc: add mmc card sleep and awake support
X-OriginalArrivalTime: 28 Jul 2009 10:40:40.0498 (UTC) FILETIME=[D9E5C120:01CA0F6F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 372d05a33f04d6a664ad1d3a80bed3d9ae80e495 Mon Sep 17 00:00:00 2001
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Date: Tue, 12 May 2009 19:46:14 +0300
Subject: [PATCH] omap_hsmmc: add mmc card sleep and awake support

After 1 second of inactivity, put card and/or regulator
to sleep.  After 8 seconds of inactivity, turn off the
power.

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/host/omap_hsmmc.c |  162 ++++++++++++++++++++++-------------------
 1 files changed, 88 insertions(+), 74 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 7a17901..d5fb066 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -27,6 +27,7 @@
 #include <linux/timer.h>
 #include <linux/clk.h>
 #include <linux/mmc/host.h>
+#include <linux/mmc/core.h>
 #include <linux/io.h>
 #include <linux/semaphore.h>
 #include <mach/dma.h>
@@ -113,7 +114,8 @@
 
 /* Timeouts for entering power saving states on inactivity, msec */
 #define OMAP_MMC_DISABLED_TIMEOUT	100
-#define OMAP_MMC_OFF_TIMEOUT		1000
+#define OMAP_MMC_SLEEP_TIMEOUT		1000
+#define OMAP_MMC_OFF_TIMEOUT		8000
 
 /*
  * One controller can have multiple slots, like on some omap boards using
@@ -1175,20 +1177,21 @@ static void omap_hsmmc_init(struct mmc_omap_host *host)
 
 /*
  * Dynamic power saving handling, FSM:
- *   ENABLED -> DISABLED -> OFF / REGSLEEP
- *     ^___________|          |
- *     |______________________|
+ *   ENABLED -> DISABLED -> CARDSLEEP / REGSLEEP -> OFF
+ *     ^___________|          |                      |
+ *     |______________________|______________________|
  *
  * ENABLED:   mmc host is fully functional
  * DISABLED:  fclk is off
- * OFF:       fclk is off,voltage regulator is off
- * REGSLEEP:  fclk is off,voltage regulator is asleep
+ * CARDSLEEP: fclk is off, card is asleep, voltage regulator is asleep
+ * REGSLEEP:  fclk is off, voltage regulator is asleep
+ * OFF:       fclk is off, voltage regulator is off
  *
  * Transition handlers return the timeout for the next state transition
  * or negative error.
  */
 
-enum {ENABLED = 0, DISABLED, REGSLEEP, OFF};
+enum {ENABLED = 0, DISABLED, CARDSLEEP, REGSLEEP, OFF};
 
 /* Handler for [ENABLED -> DISABLED] transition */
 static int omap_mmc_enabled_to_disabled(struct mmc_omap_host *host)
@@ -1202,46 +1205,72 @@ static int omap_mmc_enabled_to_disabled(struct mmc_omap_host *host)
 	if (host->power_mode == MMC_POWER_OFF)
 		return 0;
 
-	return msecs_to_jiffies(OMAP_MMC_OFF_TIMEOUT);
+	return msecs_to_jiffies(OMAP_MMC_SLEEP_TIMEOUT);
 }
 
-/* Handler for [DISABLED -> OFF] transition */
-static int omap_mmc_disabled_to_off(struct mmc_omap_host *host)
+/* Handler for [DISABLED -> REGSLEEP / CARDSLEEP] transition */
+static int omap_mmc_disabled_to_sleep(struct mmc_omap_host *host)
 {
-	int new_state;
-
-	dev_dbg(mmc_dev(host->mmc), "DISABLED -> OFF\n");
+	int err, new_state;
 
 	if (!mmc_try_claim_host(host->mmc))
 		return 0;
 
 	clk_enable(host->fclk);
-
 	omap_mmc_restore_ctx(host);
+	if (mmc_card_can_sleep(host->mmc)) {
+		err = mmc_card_sleep(host->mmc);
+		if (err < 0) {
+			clk_disable(host->fclk);
+			mmc_release_host(host->mmc);
+			return err;
+		}
+		new_state = CARDSLEEP;
+	} else
+		new_state = REGSLEEP;
+	if (mmc_slot(host).set_sleep)
+		mmc_slot(host).set_sleep(host->dev, host->slot_id, 1, 0,
+					 new_state == CARDSLEEP);
+	/* FIXME: turn off bus power and perhaps interrupts too */
+	clk_disable(host->fclk);
+	host->dpm_state = new_state;
+
+	mmc_release_host(host->mmc);
+
+	dev_dbg(mmc_dev(host->mmc), "DISABLED -> %s\n",
+		host->dpm_state == CARDSLEEP ? "CARDSLEEP" : "REGSLEEP");
 
 	if ((host->mmc->caps & MMC_CAP_NONREMOVABLE) ||
 	    mmc_slot(host).card_detect ||
 	    (mmc_slot(host).get_cover_state &&
-	     mmc_slot(host).get_cover_state(host->dev, host->slot_id))) {
-		mmc_power_save_host(host->mmc);
-		new_state = OFF;
-	} else {
-		if (mmc_slot(host).set_sleep)
-			mmc_slot(host).set_sleep(host->dev, host->slot_id,
-						 1, 0, 0);
-		new_state = REGSLEEP;
+	     mmc_slot(host).get_cover_state(host->dev, host->slot_id)))
+		return msecs_to_jiffies(OMAP_MMC_OFF_TIMEOUT);
+
+	return 0;
+}
+
+/* Handler for [REGSLEEP / CARDSLEEP -> OFF] transition */
+static int omap_mmc_sleep_to_off(struct mmc_omap_host *host)
+{
+	if (!mmc_try_claim_host(host->mmc))
+		return 0;
+
+	if (!((host->mmc->caps & MMC_CAP_NONREMOVABLE) ||
+	      mmc_slot(host).card_detect ||
+	      (mmc_slot(host).get_cover_state &&
+	       mmc_slot(host).get_cover_state(host->dev, host->slot_id)))) {
+		mmc_release_host(host->mmc);
+		return 0;
 	}
 
-	OMAP_HSMMC_WRITE(host->base, ISE, 0);
-	OMAP_HSMMC_WRITE(host->base, IE, 0);
-	OMAP_HSMMC_WRITE(host->base, HCTL,
-		 OMAP_HSMMC_READ(host->base, HCTL) & ~SDBP);
+	mmc_slot(host).set_power(host->dev, host->slot_id, 0, 0);
+	host->vdd = 0;
+	host->power_mode = MMC_POWER_OFF;
 
-	clk_disable(host->fclk);
-	clk_disable(host->iclk);
-	clk_disable(host->dbclk);
+	dev_dbg(mmc_dev(host->mmc), "%s -> OFF\n",
+		host->dpm_state == CARDSLEEP ? "CARDSLEEP" : "REGSLEEP");
 
-	host->dpm_state = new_state;
+	host->dpm_state = OFF;
 
 	mmc_release_host(host->mmc);
 
@@ -1266,62 +1295,43 @@ static int omap_mmc_disabled_to_enabled(struct mmc_omap_host *host)
 	return 0;
 }
 
-/* Handler for [OFF -> ENABLED] transition */
-static int omap_mmc_off_to_enabled(struct mmc_omap_host *host)
+/* Handler for [SLEEP -> ENABLED] transition */
+static int omap_mmc_sleep_to_enabled(struct mmc_omap_host *host)
 {
-	clk_enable(host->fclk);
-	clk_enable(host->iclk);
-
-	if (clk_enable(host->dbclk))
-		dev_dbg(mmc_dev(host->mmc),
-			"Enabling debounce clk failed\n");
+	if (!mmc_try_claim_host(host->mmc))
+		return 0;
 
+	clk_enable(host->fclk);
 	omap_mmc_restore_ctx(host);
-	omap_hsmmc_init(host);
-	mmc_power_restore_host(host->mmc);
+	if (mmc_slot(host).set_sleep)
+		mmc_slot(host).set_sleep(host->dev, host->slot_id, 0,
+			 host->vdd, host->dpm_state == CARDSLEEP);
+	if (mmc_card_can_sleep(host->mmc))
+		mmc_card_awake(host->mmc);
+
+	dev_dbg(mmc_dev(host->mmc), "%s -> ENABLED\n",
+		host->dpm_state == CARDSLEEP ? "CARDSLEEP" : "REGSLEEP");
 
 	host->dpm_state = ENABLED;
 
-	dev_dbg(mmc_dev(host->mmc), "OFF -> ENABLED\n");
+	mmc_release_host(host->mmc);
 
 	return 0;
 }
 
-/* Handler for [REGSLEEP -> ENABLED] transition */
-static int omap_mmc_regsleep_to_enabled(struct mmc_omap_host *host)
+/* Handler for [OFF -> ENABLED] transition */
+static int omap_mmc_off_to_enabled(struct mmc_omap_host *host)
 {
-	unsigned long timeout;
-
-	dev_dbg(mmc_dev(host->mmc), "REGSLEEP -> ENABLED\n");
-
 	clk_enable(host->fclk);
-	clk_enable(host->iclk);
-
-	if (clk_enable(host->dbclk))
-		dev_dbg(mmc_dev(host->mmc),
-			"Enabling debounce clk failed\n");
 
 	omap_mmc_restore_ctx(host);
-
-	/*
-	 * We turned off interrupts and bus power.  Interrupts
-	 * are turned on by 'mmc_omap_start_command()' so we
-	 * just need to turn on the bus power here.
-	 */
-	OMAP_HSMMC_WRITE(host->base, HCTL,
-			 OMAP_HSMMC_READ(host->base, HCTL) | SDBP);
-
-	timeout = jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
-	while ((OMAP_HSMMC_READ(host->base, HCTL) & SDBP) != SDBP &&
-	       time_before(jiffies, timeout))
-		;
-
-	if (mmc_slot(host).set_sleep)
-		mmc_slot(host).set_sleep(host->dev, host->slot_id,
-					 0, host->vdd, 0);
+	omap_hsmmc_init(host);
+	mmc_power_restore_host(host->mmc);
 
 	host->dpm_state = ENABLED;
 
+	dev_dbg(mmc_dev(host->mmc), "OFF -> ENABLED\n");
+
 	return 0;
 }
 
@@ -1335,8 +1345,9 @@ static int omap_mmc_enable(struct mmc_host *mmc)
 	switch (host->dpm_state) {
 	case DISABLED:
 		return omap_mmc_disabled_to_enabled(host);
+	case CARDSLEEP:
 	case REGSLEEP:
-		return omap_mmc_regsleep_to_enabled(host);
+		return omap_mmc_sleep_to_enabled(host);
 	case OFF:
 		return omap_mmc_off_to_enabled(host);
 	default:
@@ -1362,7 +1373,10 @@ static int omap_mmc_disable(struct mmc_host *mmc, int lazy)
 		return 0;
 	}
 	case DISABLED:
-		return omap_mmc_disabled_to_off(host);
+		return omap_mmc_disabled_to_sleep(host);
+	case CARDSLEEP:
+	case REGSLEEP:
+		return omap_mmc_sleep_to_off(host);
 	default:
 		dev_dbg(mmc_dev(host->mmc), "UNKNOWN state\n");
 		return -EINVAL;
@@ -1434,8 +1448,7 @@ static int mmc_regs_show(struct seq_file *s, void *data)
 			host->dpm_state, mmc->nesting_cnt,
 			host->context_loss, context_loss);
 
-	if (host->suspended || host->dpm_state == OFF ||
-	    host->dpm_state == REGSLEEP) {
+	if (host->suspended || host->dpm_state == OFF) {
 		seq_printf(s, "host suspended, can't read registers\n");
 		return 0;
 	}
@@ -1610,7 +1623,8 @@ static int __init omap_mmc_probe(struct platform_device *pdev)
 	mmc->max_req_size = mmc->max_blk_size * mmc->max_blk_count;
 	mmc->max_seg_size = mmc->max_req_size;
 
-	mmc->caps |= MMC_CAP_MMC_HIGHSPEED | MMC_CAP_SD_HIGHSPEED;
+	mmc->caps |= MMC_CAP_MMC_HIGHSPEED | MMC_CAP_SD_HIGHSPEED |
+		     MMC_CAP_WAIT_WHILE_BUSY;
 
 	if (pdata->slots[host->slot_id].wires >= 8)
 		mmc->caps |= MMC_CAP_8_BIT_DATA;
-- 
1.5.6.3

