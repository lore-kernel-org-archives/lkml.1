Return-Path: <linux-kernel-owner+w=401wt.eu-S1761291AbZCaOwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761291AbZCaOwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 10:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756175AbZCaOwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 10:52:05 -0400
Received: from smtp.nokia.com ([192.100.122.233]:22710 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833AbZCaOwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 10:52:03 -0400
From: Jorg Schummer <ext-jorg.2.schummer@nokia.com>
To: drzeus-mmc@drzeus.cx
Cc: linux-kernel@vger.kernel.org,
       Jorg Schummer <ext-jorg.2.schummer@nokia.com>
Subject: [PATCH 1/1] MMC: core/core.c: mmc_rescan detects card change in one run
Date: Tue, 31 Mar 2009 17:51:21 +0300
Message-Id: <1238511081-24570-1-git-send-email-ext-jorg.2.schummer@nokia.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <20090303095530.65923117@mjolnir.ossman.eu>
References: <20090303095530.65923117@mjolnir.ossman.eu>
X-OriginalArrivalTime: 31 Mar 2009 14:51:22.0847 (UTC) FILETIME=[28ADCEF0:01C9B210]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch, mmc_rescan can detect the removal of an mmc card and
the insertion of (possibly another) card in the same run. This means
that a card change can be detected without having to call
mmc_detect_change multiple times.

This change generalises the core such that it can be easily used by
hosts which provide a mechanism to detect only the presence of a card
reader cover, which has to be taken off in order to insert a card. Other
hosts ("card detect" or "MMC_CAP_NEEDS_POLL") each receive an event when
a card is removed and when a card is inserted, so it is sufficient for
them if mmc_rescan handles only one event at a time. "Cover detect"
hosts, however, only receive events about the cover status. This means
that between 2 subsequent events, both a card removal and a card
insertion can occur. In this case, the pre-patch version of mmc_rescan
would only detect the removal of the previous card but not the insertion
of the new card.

Signed-off-by: Jorg Schummer <ext-jorg.2.schummer@nokia.com>
---
 drivers/mmc/core/core.c |   99 ++++++++++++++++++++++++++---------------------
 1 files changed, 55 insertions(+), 44 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index df6ce4a..5970719 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -740,61 +740,72 @@ void mmc_rescan(struct work_struct *work)
 
 	mmc_bus_get(host);
 
-	if (host->bus_ops == NULL) {
-		/*
-		 * Only we can add a new handler, so it's safe to
-		 * release the lock here.
-		 */
+	/* if there is a card registered, check whether it is still present */
+	if ((host->bus_ops != NULL) && host->bus_ops->detect && !host->bus_dead)
+		host->bus_ops->detect(host);
+
+	mmc_bus_put(host);
+
+
+	mmc_bus_get(host);
+
+	/* if there still is a card present, stop here */
+	if (host->bus_ops != NULL) {
 		mmc_bus_put(host);
+		goto out;
+	}
 
-		if (host->ops->get_cd && host->ops->get_cd(host) == 0)
-			goto out;
+	/* detect a newly inserted card */
 
-		mmc_claim_host(host);
+	/*
+	 * Only we can add a new handler, so it's safe to
+	 * release the lock here.
+	 */
+	mmc_bus_put(host);
 
-		mmc_power_up(host);
-		mmc_go_idle(host);
+	if (host->ops->get_cd && host->ops->get_cd(host) == 0)
+		goto out;
 
-		mmc_send_if_cond(host, host->ocr_avail);
+	mmc_claim_host(host);
 
-		/*
-		 * First we search for SDIO...
-		 */
-		err = mmc_send_io_op_cond(host, 0, &ocr);
-		if (!err) {
-			if (mmc_attach_sdio(host, ocr))
-				mmc_power_off(host);
-			goto out;
-		}
+	mmc_power_up(host);
+	mmc_go_idle(host);
 
-		/*
-		 * ...then normal SD...
-		 */
-		err = mmc_send_app_op_cond(host, 0, &ocr);
-		if (!err) {
-			if (mmc_attach_sd(host, ocr))
-				mmc_power_off(host);
-			goto out;
-		}
+	mmc_send_if_cond(host, host->ocr_avail);
 
-		/*
-		 * ...and finally MMC.
-		 */
-		err = mmc_send_op_cond(host, 0, &ocr);
-		if (!err) {
-			if (mmc_attach_mmc(host, ocr))
-				mmc_power_off(host);
-			goto out;
-		}
+	/*
+	 * First we search for SDIO...
+	 */
+	err = mmc_send_io_op_cond(host, 0, &ocr);
+	if (!err) {
+		if (mmc_attach_sdio(host, ocr))
+			mmc_power_off(host);
+		goto out;
+	}
 
-		mmc_release_host(host);
-		mmc_power_off(host);
-	} else {
-		if (host->bus_ops->detect && !host->bus_dead)
-			host->bus_ops->detect(host);
+	/*
+	 * ...then normal SD...
+	 */
+	err = mmc_send_app_op_cond(host, 0, &ocr);
+	if (!err) {
+		if (mmc_attach_sd(host, ocr))
+			mmc_power_off(host);
+		goto out;
+	}
 
-		mmc_bus_put(host);
+	/*
+	 * ...and finally MMC.
+	 */
+	err = mmc_send_op_cond(host, 0, &ocr);
+	if (!err) {
+		if (mmc_attach_mmc(host, ocr))
+			mmc_power_off(host);
+		goto out;
 	}
+
+	mmc_release_host(host);
+	mmc_power_off(host);
+
 out:
 	if (host->caps & MMC_CAP_NEEDS_POLL)
 		mmc_schedule_delayed_work(&host->detect, HZ);
-- 
1.5.4.3

