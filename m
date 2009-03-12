Return-Path: <linux-kernel-owner+w=401wt.eu-S1757849AbZCLQZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849AbZCLQZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 12:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757518AbZCLQXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 12:23:49 -0400
Received: from smtp.nokia.com ([192.100.122.233]:17361 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757527AbZCLQXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 12:23:48 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       David Brownell <david-b@pacbell.net>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, lkml <linux-kernel@vger.kernel.org>
Date: Thu, 12 Mar 2009 18:23:46 +0200
Message-Id: <20090312162346.19421.90213.sendpatchset@ahunter-laptop>
In-Reply-To: <20090312162252.19421.34019.sendpatchset@ahunter-laptop>
References: <20090312162252.19421.34019.sendpatchset@ahunter-laptop>
Subject: [PATCH 8/10] OMAP: HSMMC: Make driver support dynamic idle
X-OriginalArrivalTime: 12 Mar 2009 16:23:21.0895 (UTC) FILETIME=[DC707370:01C9A32E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 47b6de0fcfeb5948199dbed941847580bedc5315 Mon Sep 17 00:00:00 2001
From: Amit Kucheria <amit.kucheria@verdurent.com>
Date: Thu, 12 Mar 2009 15:47:39 +0200
Subject: [PATCH] OMAP: HSMMC: Make driver support dynamic idle

Add a timer that is kept active by MMC requests. FCLK is disabled on
timeout.

Signed-off-by: Amit Kucheria <amit.kucheria@verdurent.com>
Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/host/omap_hsmmc.c |   81 ++++++++++++++++++++++++++++++++++++-----
 1 files changed, 72 insertions(+), 9 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 2832651..0e47073 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -121,6 +121,9 @@
 #define OMAP_HSMMC_WRITE(base, reg, val) \
 	__raw_writel((val), (base) + OMAP_HSMMC_##reg)
 
+enum {OFF = 0, ON};
+#define IDLE_TIMEOUT (jiffies_to_msecs(10))
+
 struct mmc_omap_host {
 	struct	device		*dev;
 	struct	mmc_host	*mmc;
@@ -147,9 +150,52 @@ struct mmc_omap_host {
 	int			slot_id;
 	int			dbclk_enabled;
 	int			response_busy;
+
+	struct timer_list       idle_timer;
+	spinlock_t		clk_lock;     /* for changing enabled state */
+	unsigned int		fclk_enabled:1;
+
 	struct	omap_mmc_platform_data	*pdata;
 };
 
+static int mmc_omap_fclk_state(struct mmc_omap_host *host, unsigned int state)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&host->clk_lock, flags);
+	del_timer(&host->idle_timer);
+	if (host->fclk_enabled != state) {
+		if (state == ON) {
+			ret = clk_enable(host->fclk);
+			if (ret != 0)
+				goto err_out;
+
+			dev_dbg(mmc_dev(host->mmc), "mmc_fclk: enabled\n");
+		} else {
+			clk_disable(host->fclk);
+			dev_dbg(mmc_dev(host->mmc), "mmc_fclk: disabled\n");
+		}
+		host->fclk_enabled = state;
+	}
+
+err_out:
+	spin_unlock_irqrestore(&host->clk_lock, flags);
+	return ret;
+}
+
+static void mmc_omap_idle_timer(unsigned long data)
+{
+	struct mmc_omap_host *host = (struct mmc_omap_host *) data;
+
+	mmc_omap_fclk_state(host, OFF);
+}
+
+static void mmc_omap_fclk_lazy_disable(struct mmc_omap_host *host)
+{
+	mod_timer(&host->idle_timer, jiffies + IDLE_TIMEOUT);
+}
+
 /*
  * Stop clock to the card
  */
@@ -314,6 +360,7 @@ mmc_omap_xfer_done(struct mmc_omap_host *host, struct mmc_data *data)
 
 	if (!data->stop) {
 		host->mrq = NULL;
+		mmc_omap_fclk_lazy_disable(host);
 		mmc_request_done(host->mmc, data->mrq);
 		return;
 	}
@@ -342,6 +389,7 @@ mmc_omap_cmd_done(struct mmc_omap_host *host, struct mmc_command *cmd)
 	}
 	if ((host->data == NULL && !host->response_busy) || cmd->error) {
 		host->mrq = NULL;
+		mmc_omap_fclk_lazy_disable(host);
 		mmc_request_done(host->mmc, cmd->mrq);
 	}
 }
@@ -509,7 +557,7 @@ static int omap_mmc_switch_opcond(struct mmc_omap_host *host, int vdd)
 	int ret;
 
 	/* Disable the clocks */
-	clk_disable(host->fclk);
+	mmc_omap_fclk_state(host, OFF);
 	clk_disable(host->iclk);
 	clk_disable(host->dbclk);
 
@@ -523,7 +571,7 @@ static int omap_mmc_switch_opcond(struct mmc_omap_host *host, int vdd)
 	if (ret != 0)
 		goto err;
 
-	clk_enable(host->fclk);
+	mmc_omap_fclk_state(host, ON);
 	clk_enable(host->iclk);
 	clk_enable(host->dbclk);
 
@@ -577,12 +625,14 @@ static void mmc_omap_detect(struct work_struct *work)
 		host->carddetect = -ENOSYS;
 
 	sysfs_notify(&host->mmc->class_dev.kobj, NULL, "cover_switch");
+	mmc_omap_fclk_state(host, ON);
 	if (host->carddetect) {
 		mmc_detect_change(host->mmc, (HZ * 200) / 1000);
 	} else {
 		mmc_omap_reset_controller_fsm(host, SRD);
 		mmc_detect_change(host->mmc, (HZ * 50) / 1000);
 	}
+	mmc_omap_fclk_lazy_disable(host);
 }
 
 /*
@@ -809,6 +859,7 @@ static void omap_mmc_request(struct mmc_host *mmc, struct mmc_request *req)
 
 	WARN_ON(host->mrq != NULL);
 	host->mrq = req;
+	mmc_omap_fclk_state(host, ON);
 	mmc_omap_prepare_data(host, req);
 	mmc_omap_start_command(host, req->cmd, req->data);
 }
@@ -823,6 +874,8 @@ static void omap_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	unsigned long timeout;
 	u32 con;
 
+	mmc_omap_fclk_state(host, ON);
+
 	switch (ios->power_mode) {
 	case MMC_POWER_OFF:
 		mmc_slot(host).set_power(host->dev, host->slot_id, 0, 0);
@@ -901,6 +954,8 @@ static void omap_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	if (ios->bus_mode == MMC_BUSMODE_OPENDRAIN)
 		OMAP_HSMMC_WRITE(host->base, CON,
 				OMAP_HSMMC_READ(host->base, CON) | OD);
+
+	mmc_omap_fclk_lazy_disable(host);
 }
 
 static int omap_hsmmc_get_cd(struct mmc_host *mmc)
@@ -1029,14 +1084,18 @@ static int __init omap_mmc_probe(struct platform_device *pdev)
 		goto err1;
 	}
 
-	if (clk_enable(host->fclk) != 0) {
+	spin_lock_init(&host->clk_lock);
+	setup_timer(&host->idle_timer, mmc_omap_idle_timer,
+		    (unsigned long) host);
+
+	if (mmc_omap_fclk_state(host, ON) != 0) {
 		clk_put(host->iclk);
 		clk_put(host->fclk);
 		goto err1;
 	}
 
 	if (clk_enable(host->iclk) != 0) {
-		clk_disable(host->fclk);
+		mmc_omap_fclk_state(host, OFF);
 		clk_put(host->iclk);
 		clk_put(host->fclk);
 		goto err1;
@@ -1122,6 +1181,7 @@ static int __init omap_mmc_probe(struct platform_device *pdev)
 		if (ret < 0)
 			goto err_cover_switch;
 	}
+	mmc_omap_fclk_lazy_disable(host);
 
 	return 0;
 
@@ -1134,7 +1194,7 @@ err_irq_cd:
 err_irq_cd_init:
 	free_irq(host->irq, host);
 err_irq:
-	clk_disable(host->fclk);
+	mmc_omap_fclk_state(host, OFF);
 	clk_disable(host->iclk);
 	clk_put(host->fclk);
 	clk_put(host->iclk);
@@ -1167,7 +1227,7 @@ static int omap_mmc_remove(struct platform_device *pdev)
 			free_irq(mmc_slot(host).card_detect_irq, host);
 		flush_scheduled_work();
 
-		clk_disable(host->fclk);
+		mmc_omap_fclk_state(host, OFF);
 		clk_disable(host->iclk);
 		clk_put(host->fclk);
 		clk_put(host->iclk);
@@ -1202,6 +1262,7 @@ static int omap_mmc_suspend(struct platform_device *pdev, pm_message_t state)
 		if (ret == 0) {
 			host->suspended = 1;
 
+			mmc_omap_fclk_state(host, ON);
 			OMAP_HSMMC_WRITE(host->base, ISE, 0);
 			OMAP_HSMMC_WRITE(host->base, IE, 0);
 
@@ -1216,7 +1277,7 @@ static int omap_mmc_suspend(struct platform_device *pdev, pm_message_t state)
 
 			OMAP_HSMMC_WRITE(host->base, HCTL,
 					 OMAP_HSMMC_READ(host->base, HCTL) & ~SDBP);
-			clk_disable(host->fclk);
+			mmc_omap_fclk_state(host, OFF);
 			clk_disable(host->iclk);
 			clk_disable(host->dbclk);
 		}
@@ -1236,13 +1297,13 @@ static int omap_mmc_resume(struct platform_device *pdev)
 
 	if (host) {
 
-		ret = clk_enable(host->fclk);
+		ret = mmc_omap_fclk_state(host, ON);
 		if (ret)
 			goto clk_en_err;
 
 		ret = clk_enable(host->iclk);
 		if (ret) {
-			clk_disable(host->fclk);
+			mmc_omap_fclk_state(host, OFF);
 			clk_put(host->fclk);
 			goto clk_en_err;
 		}
@@ -1264,6 +1325,8 @@ static int omap_mmc_resume(struct platform_device *pdev)
 		ret = mmc_resume_host(host->mmc);
 		if (ret == 0)
 			host->suspended = 0;
+
+		mmc_omap_fclk_lazy_disable(host);
 	}
 
 	return ret;
-- 
1.5.6.3

