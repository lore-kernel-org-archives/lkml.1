Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324AbZG1Kkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbZG1Kkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 06:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbZG1Kkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 06:40:46 -0400
Received: from smtp.nokia.com ([192.100.122.233]:47619 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbZG1Kkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 06:40:40 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       Pierre Ossman <pierre@ossman.eu>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Matt Fleming <matt@console-pimps.org>,
       lkml <linux-kernel@vger.kernel.org>
Date: Tue, 28 Jul 2009 13:40:48 +0300
Message-Id: <20090728104048.2371.33663.sendpatchset@ahunter-laptop>
In-Reply-To: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
References: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
Subject: [PATCH V2 18/32] omap_hsmmc: support for deeper power saving states
X-OriginalArrivalTime: 28 Jul 2009 10:40:17.0233 (UTC) FILETIME=[CC07CC10:01CA0F6F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ad38a2788cc03924eebc353159561566dc4911e5 Mon Sep 17 00:00:00 2001
From: Denis Karpov <ext-denis.2.karpov@nokia.com>
Date: Mon, 11 May 2009 14:41:30 +0300
Subject: [PATCH] omap_hsmmc: support for deeper power saving states

Support for multi-level dynamic power saving states in omap_hsmmc
(ENABLED->DISABLED->OFF).
In the "deepest" state (OFF) we switch off the voltage regulators.

Signed-off-by: Denis Karpov <ext-denis.2.karpov@nokia.com>
Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 arch/arm/mach-omap2/mmc-twl4030.c     |    3 +
 arch/arm/mach-omap2/mmc-twl4030.h     |    1 +
 arch/arm/plat-omap/include/mach/mmc.h |    3 +
 drivers/mmc/host/omap_hsmmc.c         |  245 +++++++++++++++++++++++++++++----
 4 files changed, 222 insertions(+), 30 deletions(-)

diff --git a/arch/arm/mach-omap2/mmc-twl4030.c b/arch/arm/mach-omap2/mmc-twl4030.c
index 67c22c6..3678f0e 100644
--- a/arch/arm/mach-omap2/mmc-twl4030.c
+++ b/arch/arm/mach-omap2/mmc-twl4030.c
@@ -412,6 +412,9 @@ void __init twl4030_mmc_init(struct twl4030_hsmmc_info *controllers)
 		if (c->nonremovable)
 			mmc->slots[0].nonremovable = 1;
 
+		if (c->power_saving)
+			mmc->slots[0].power_saving = 1;
+
 		/* NOTE:  MMC slots should have a Vcc regulator set up.
 		 * This may be from a TWL4030-family chip, another
 		 * controllable regulator, or a fixed supply.
diff --git a/arch/arm/mach-omap2/mmc-twl4030.h b/arch/arm/mach-omap2/mmc-twl4030.h
index 75b0c64..a47e685 100644
--- a/arch/arm/mach-omap2/mmc-twl4030.h
+++ b/arch/arm/mach-omap2/mmc-twl4030.h
@@ -13,6 +13,7 @@ struct twl4030_hsmmc_info {
 	bool	ext_clock;	/* use external pin for input clock */
 	bool	cover_only;	/* No card detect - just cover switch */
 	bool	nonremovable;	/* Nonremovable e.g. eMMC */
+	bool	power_saving;	/* Try to sleep or power off when possible */
 	int	gpio_cd;	/* or -EINVAL */
 	int	gpio_wp;	/* or -EINVAL */
 	char	*name;		/* or NULL for default */
diff --git a/arch/arm/plat-omap/include/mach/mmc.h b/arch/arm/plat-omap/include/mach/mmc.h
index bab486c..82f1e29 100644
--- a/arch/arm/plat-omap/include/mach/mmc.h
+++ b/arch/arm/plat-omap/include/mach/mmc.h
@@ -86,6 +86,9 @@ struct omap_mmc_platform_data {
 		/* nonremovable e.g. eMMC */
 		unsigned nonremovable:1;
 
+		/* Try to sleep or power off when possible */
+		unsigned power_saving:1;
+
 		int switch_pin;			/* gpio (card detect) */
 		int gpio_wp;			/* gpio (write protect) */
 
diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index e618bc0..a3418b5 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -111,6 +111,10 @@
 #define OMAP_MMC_MASTER_CLOCK	96000000
 #define DRIVER_NAME		"mmci-omap-hs"
 
+/* Timeouts for entering power saving states on inactivity, msec */
+#define OMAP_MMC_DISABLED_TIMEOUT	100
+#define OMAP_MMC_OFF_TIMEOUT		1000
+
 /*
  * One controller can have multiple slots, like on some omap boards using
  * omap.c controller driver. Luckily this is not currently done on any known
@@ -155,6 +159,7 @@ struct mmc_omap_host {
 	int			dbclk_enabled;
 	int			response_busy;
 	int			context_loss;
+	int			dpm_state;
 
 	struct	omap_mmc_platform_data	*pdata;
 };
@@ -985,29 +990,6 @@ mmc_omap_prepare_data(struct mmc_omap_host *host, struct mmc_request *req)
 	return 0;
 }
 
-static int omap_mmc_enable(struct mmc_host *mmc)
-{
-	struct mmc_omap_host *host = mmc_priv(mmc);
-	int err;
-
-	err = clk_enable(host->fclk);
-	if (err)
-		return err;
-	dev_dbg(mmc_dev(host->mmc), "mmc_fclk: enabled\n");
-	omap_mmc_restore_ctx(host);
-	return 0;
-}
-
-static int omap_mmc_disable(struct mmc_host *mmc, int lazy)
-{
-	struct mmc_omap_host *host = mmc_priv(mmc);
-
-	omap_mmc_save_ctx(host);
-	clk_disable(host->fclk);
-	dev_dbg(mmc_dev(host->mmc), "mmc_fclk: disabled\n");
-	return 0;
-}
-
 /*
  * Request function. for read/write operation
  */
@@ -1061,6 +1043,8 @@ static void omap_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		host->power_mode = ios->power_mode;
 	}
 
+	/* FIXME: set registers based only on changes to ios */
+
 	con = OMAP_HSMMC_READ(host->base, CON);
 	switch (mmc->ios.bus_width) {
 	case MMC_BUS_WIDTH_8:
@@ -1133,7 +1117,10 @@ static void omap_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	else
 		OMAP_HSMMC_WRITE(host->base, CON, con & ~OD);
 
-	mmc_host_lazy_disable(host->mmc);
+	if (host->power_mode == MMC_POWER_OFF)
+		mmc_host_disable(host->mmc);
+	else
+		mmc_host_lazy_disable(host->mmc);
 }
 
 static int omap_hsmmc_get_cd(struct mmc_host *mmc)
@@ -1183,7 +1170,191 @@ static void omap_hsmmc_init(struct mmc_omap_host *host)
 	set_sd_bus_power(host);
 }
 
-static struct mmc_host_ops mmc_omap_ops = {
+/*
+ * Dynamic power saving handling, FSM:
+ *   ENABLED -> DISABLED -> OFF
+ *     ^___________|          |
+ *     |______________________|
+ *
+ * ENABLED:   mmc host is fully functional
+ * DISABLED:  fclk is off
+ * OFF:       fclk is off,voltage regulator is off
+ *
+ * Transition handlers return the timeout for the next state transition
+ * or negative error.
+ */
+
+enum {ENABLED = 0, DISABLED, OFF};
+
+/* Handler for [ENABLED -> DISABLED] transition */
+static int omap_mmc_enabled_to_disabled(struct mmc_omap_host *host)
+{
+	omap_mmc_save_ctx(host);
+	clk_disable(host->fclk);
+	host->dpm_state = DISABLED;
+
+	dev_dbg(mmc_dev(host->mmc), "ENABLED -> DISABLED\n");
+
+	if (host->power_mode == MMC_POWER_OFF)
+		return 0;
+
+	return msecs_to_jiffies(OMAP_MMC_OFF_TIMEOUT);
+}
+
+/* Handler for [DISABLED -> OFF] transition */
+static int omap_mmc_disabled_to_off(struct mmc_omap_host *host)
+{
+	int new_state;
+
+	dev_dbg(mmc_dev(host->mmc), "DISABLED -> OFF\n");
+
+	if (!mmc_try_claim_host(host->mmc))
+		return 0;
+
+	clk_enable(host->fclk);
+
+	omap_mmc_restore_ctx(host);
+
+	if ((host->mmc->caps & MMC_CAP_NONREMOVABLE) ||
+	    mmc_slot(host).card_detect ||
+	    (mmc_slot(host).get_cover_state &&
+	     mmc_slot(host).get_cover_state(host->dev, host->slot_id))) {
+		mmc_power_save_host(host->mmc);
+		new_state = OFF;
+	} else
+		new_state = DISABLED;
+
+	OMAP_HSMMC_WRITE(host->base, ISE, 0);
+	OMAP_HSMMC_WRITE(host->base, IE, 0);
+	OMAP_HSMMC_WRITE(host->base, HCTL,
+		 OMAP_HSMMC_READ(host->base, HCTL) & ~SDBP);
+
+	clk_disable(host->fclk);
+	clk_disable(host->iclk);
+	clk_disable(host->dbclk);
+
+	host->dpm_state = new_state;
+
+	mmc_release_host(host->mmc);
+
+	return 0;
+}
+
+/* Handler for [DISABLED -> ENABLED] transition */
+static int omap_mmc_disabled_to_enabled(struct mmc_omap_host *host)
+{
+	int err;
+
+	err = clk_enable(host->fclk);
+	if (err < 0)
+		return err;
+
+	omap_mmc_restore_ctx(host);
+
+	host->dpm_state = ENABLED;
+
+	dev_dbg(mmc_dev(host->mmc), "DISABLED -> ENABLED\n");
+
+	return 0;
+}
+
+/* Handler for [OFF -> ENABLED] transition */
+static int omap_mmc_off_to_enabled(struct mmc_omap_host *host)
+{
+	clk_enable(host->fclk);
+	clk_enable(host->iclk);
+
+	if (clk_enable(host->dbclk))
+		dev_dbg(mmc_dev(host->mmc),
+			"Enabling debounce clk failed\n");
+
+	omap_mmc_restore_ctx(host);
+	omap_hsmmc_init(host);
+	mmc_power_restore_host(host->mmc);
+
+	host->dpm_state = ENABLED;
+
+	dev_dbg(mmc_dev(host->mmc), "OFF -> ENABLED\n");
+
+	return 0;
+}
+
+/*
+ * Bring MMC host to ENABLED from any other PM state.
+ */
+static int omap_mmc_enable(struct mmc_host *mmc)
+{
+	struct mmc_omap_host *host = mmc_priv(mmc);
+
+	switch (host->dpm_state) {
+	case DISABLED:
+		return omap_mmc_disabled_to_enabled(host);
+	case OFF:
+		return omap_mmc_off_to_enabled(host);
+	default:
+		dev_dbg(mmc_dev(host->mmc), "UNKNOWN state\n");
+		return -EINVAL;
+	}
+}
+
+/*
+ * Bring MMC host in PM state (one level deeper).
+ */
+static int omap_mmc_disable(struct mmc_host *mmc, int lazy)
+{
+	struct mmc_omap_host *host = mmc_priv(mmc);
+
+	switch (host->dpm_state) {
+	case ENABLED: {
+		int delay;
+
+		delay = omap_mmc_enabled_to_disabled(host);
+		if (lazy || delay < 0)
+			return delay;
+		return 0;
+	}
+	case DISABLED:
+		return omap_mmc_disabled_to_off(host);
+	default:
+		dev_dbg(mmc_dev(host->mmc), "UNKNOWN state\n");
+		return -EINVAL;
+	}
+}
+
+static int omap_mmc_enable_fclk(struct mmc_host *mmc)
+{
+	struct mmc_omap_host *host = mmc_priv(mmc);
+	int err;
+
+	err = clk_enable(host->fclk);
+	if (err)
+		return err;
+	dev_dbg(mmc_dev(host->mmc), "mmc_fclk: enabled\n");
+	omap_mmc_restore_ctx(host);
+	return 0;
+}
+
+static int omap_mmc_disable_fclk(struct mmc_host *mmc, int lazy)
+{
+	struct mmc_omap_host *host = mmc_priv(mmc);
+
+	omap_mmc_save_ctx(host);
+	clk_disable(host->fclk);
+	dev_dbg(mmc_dev(host->mmc), "mmc_fclk: disabled\n");
+	return 0;
+}
+
+static const struct mmc_host_ops mmc_omap_ops = {
+	.enable = omap_mmc_enable_fclk,
+	.disable = omap_mmc_disable_fclk,
+	.request = omap_mmc_request,
+	.set_ios = omap_mmc_set_ios,
+	.get_cd = omap_hsmmc_get_cd,
+	.get_ro = omap_hsmmc_get_ro,
+	/* NYET -- enable_sdio_irq */
+};
+
+static const struct mmc_host_ops mmc_omap_ps_ops = {
 	.enable = omap_mmc_enable,
 	.disable = omap_mmc_disable,
 	.request = omap_mmc_request,
@@ -1207,15 +1378,22 @@ static int mmc_regs_show(struct seq_file *s, void *data)
 
 	seq_printf(s, "mmc%d:\n"
 			" enabled:\t%d\n"
+			" dpm_state:\t%d\n"
 			" nesting_cnt:\t%d\n"
 			" ctx_loss:\t%d:%d\n"
 			"\nregs:\n",
-			mmc->index, mmc->enabled ? 1 : 0, mmc->nesting_cnt,
+			mmc->index, mmc->enabled ? 1 : 0,
+			host->dpm_state, mmc->nesting_cnt,
 			host->context_loss, context_loss);
 
+	if (host->suspended || host->dpm_state == OFF) {
+		seq_printf(s, "host suspended, can't read registers\n");
+		return 0;
+	}
+
 	if (clk_enable(host->fclk) != 0) {
 		seq_printf(s, "can't read the regs\n");
-		goto err;
+		return 0;
 	}
 
 	seq_printf(s, "SYSCONFIG:\t0x%08x\n",
@@ -1234,7 +1412,7 @@ static int mmc_regs_show(struct seq_file *s, void *data)
 			OMAP_HSMMC_READ(host->base, CAPA));
 
 	clk_disable(host->fclk);
-err:
+
 	return 0;
 }
 
@@ -1316,7 +1494,11 @@ static int __init omap_mmc_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, host);
 	INIT_WORK(&host->mmc_carddetect_work, mmc_omap_detect);
 
-	mmc->ops	= &mmc_omap_ops;
+	if (pdata->slots[host->slot_id].power_saving)
+		mmc->ops	= &mmc_omap_ps_ops;
+	else
+		mmc->ops	= &mmc_omap_ops;
+
 	mmc->f_min	= 400000;
 	mmc->f_max	= 52000000;
 
@@ -1339,7 +1521,10 @@ static int __init omap_mmc_probe(struct platform_device *pdev)
 	omap_mmc_save_ctx(host);
 
 	mmc->caps |= MMC_CAP_DISABLE;
-	mmc_set_disable_delay(mmc, 100);
+	mmc_set_disable_delay(mmc, OMAP_MMC_DISABLED_TIMEOUT);
+	/* we start off in DISABLED state */
+	host->dpm_state = DISABLED;
+
 	if (mmc_host_enable(host->mmc) != 0) {
 		clk_put(host->iclk);
 		clk_put(host->fclk);
-- 
1.5.6.3

