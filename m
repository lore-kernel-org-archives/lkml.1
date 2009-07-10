Return-Path: <linux-kernel-owner+w=401wt.eu-S1756285AbZGJMm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbZGJMm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 08:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbZGJMjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 08:39:09 -0400
Received: from smtp.nokia.com ([192.100.122.233]:34988 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373AbZGJMjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 08:39:05 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Pierre Ossman <pierre@ossman.eu>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>
Date: Fri, 10 Jul 2009 15:42:27 +0300
Message-Id: <20090710124227.1262.7056.sendpatchset@ahunter-tower>
In-Reply-To: <20090710124004.1262.10422.sendpatchset@ahunter-tower>
References: <20090710124004.1262.10422.sendpatchset@ahunter-tower>
Subject: [PATCH 20/32] omap_hsmmc: put MMC regulator to sleep
X-OriginalArrivalTime: 10 Jul 2009 12:38:53.0768 (UTC) FILETIME=[62615C80:01CA015B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 66c91dd04118c2e2111dade9d5a327c442912046 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Tue, 12 May 2009 20:54:51 +0300
Subject: [PATCH] omap_hsmmc: put MMC regulator to sleep

When a card is not in use, the voltage regulator can be put
to sleep.  This is an alternative to powering the card off,
when powering off is not safe because the card might be
replaced without the driver being aware of it.

That situation happens if:
	- the card is removable i.e. not eMMC
	- and there is no card detect
	- and there is a cover switch but the cover is open

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/host/omap_hsmmc.c |   59 +++++++++++++++++++++++++++++++++++++---
 1 files changed, 54 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index c69ab89..eb301c1 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -160,6 +160,7 @@ struct mmc_omap_host {
 	int			response_busy;
 	int			context_loss;
 	int			dpm_state;
+	int			vdd;
 
 	struct	omap_mmc_platform_data	*pdata;
 };
@@ -1031,10 +1032,12 @@ static void omap_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		case MMC_POWER_OFF:
 			mmc_slot(host).set_power(host->dev, host->slot_id,
 						 0, 0);
+			host->vdd = 0;
 			break;
 		case MMC_POWER_UP:
 			mmc_slot(host).set_power(host->dev, host->slot_id,
 						 1, ios->vdd);
+			host->vdd = ios->vdd;
 			break;
 		case MMC_POWER_ON:
 			do_send_init_stream = 1;
@@ -1172,19 +1175,20 @@ static void omap_hsmmc_init(struct mmc_omap_host *host)
 
 /*
  * Dynamic power saving handling, FSM:
- *   ENABLED -> DISABLED -> OFF
+ *   ENABLED -> DISABLED -> OFF / REGSLEEP
  *     ^___________|          |
  *     |______________________|
  *
  * ENABLED:   mmc host is fully functional
  * DISABLED:  fclk is off
  * OFF:       fclk is off,voltage regulator is off
+ * REGSLEEP:  fclk is off,voltage regulator is asleep
  *
  * Transition handlers return the timeout for the next state transition
  * or negative error.
  */
 
-enum {ENABLED = 0, DISABLED, OFF};
+enum {ENABLED = 0, DISABLED, REGSLEEP, OFF};
 
 /* Handler for [ENABLED -> DISABLED] transition */
 static int omap_mmc_enabled_to_disabled(struct mmc_omap_host *host)
@@ -1221,8 +1225,12 @@ static int omap_mmc_disabled_to_off(struct mmc_omap_host *host)
 	     mmc_slot(host).get_cover_state(host->dev, host->slot_id))) {
 		mmc_power_save_host(host->mmc);
 		new_state = OFF;
-	} else
-		new_state = DISABLED;
+	} else {
+		if (mmc_slot(host).set_sleep)
+			mmc_slot(host).set_sleep(host->dev, host->slot_id,
+						 1, 0, 0);
+		new_state = REGSLEEP;
+	}
 
 	OMAP_HSMMC_WRITE(host->base, ISE, 0);
 	OMAP_HSMMC_WRITE(host->base, IE, 0);
@@ -1279,6 +1287,44 @@ static int omap_mmc_off_to_enabled(struct mmc_omap_host *host)
 	return 0;
 }
 
+/* Handler for [REGSLEEP -> ENABLED] transition */
+static int omap_mmc_regsleep_to_enabled(struct mmc_omap_host *host)
+{
+	unsigned long timeout;
+
+	dev_dbg(mmc_dev(host->mmc), "REGSLEEP -> ENABLED\n");
+
+	clk_enable(host->fclk);
+	clk_enable(host->iclk);
+
+	if (clk_enable(host->dbclk))
+		dev_dbg(mmc_dev(host->mmc),
+			"Enabling debounce clk failed\n");
+
+	omap_mmc_restore_ctx(host);
+
+	/*
+	 * We turned off interrupts and bus power.  Interrupts
+	 * are turned on by 'mmc_omap_start_command()' so we
+	 * just need to turn on the bus power here.
+	 */
+	OMAP_HSMMC_WRITE(host->base, HCTL,
+			 OMAP_HSMMC_READ(host->base, HCTL) | SDBP);
+
+	timeout = jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
+	while ((OMAP_HSMMC_READ(host->base, HCTL) & SDBP) != SDBP &&
+	       time_before(jiffies, timeout))
+		;
+
+	if (mmc_slot(host).set_sleep)
+		mmc_slot(host).set_sleep(host->dev, host->slot_id,
+					 0, host->vdd, 0);
+
+	host->dpm_state = ENABLED;
+
+	return 0;
+}
+
 /*
  * Bring MMC host to ENABLED from any other PM state.
  */
@@ -1289,6 +1335,8 @@ static int omap_mmc_enable(struct mmc_host *mmc)
 	switch (host->dpm_state) {
 	case DISABLED:
 		return omap_mmc_disabled_to_enabled(host);
+	case REGSLEEP:
+		return omap_mmc_regsleep_to_enabled(host);
 	case OFF:
 		return omap_mmc_off_to_enabled(host);
 	default:
@@ -1386,7 +1434,8 @@ static int mmc_regs_show(struct seq_file *s, void *data)
 			host->dpm_state, mmc->nesting_cnt,
 			host->context_loss, context_loss);
 
-	if (host->suspended || host->dpm_state == OFF) {
+	if (host->suspended || host->dpm_state == OFF ||
+	    host->dpm_state == REGSLEEP) {
 		seq_printf(s, "host suspended, can't read registers\n");
 		return 0;
 	}
-- 
1.5.6.3

