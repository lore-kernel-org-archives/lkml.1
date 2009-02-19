Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbZBSP0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbZBSP0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 10:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbZBSP0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 10:26:38 -0500
Received: from smtp.nokia.com ([192.100.105.134]:64338 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977AbZBSP0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 10:26:37 -0500
From: Jorg Schummer <ext-jorg.2.schummer@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: drzeus-mmc@drzeus.cx, Jorg Schummer <ext-jorg.2.schummer@nokia.com>
Subject: [PATCH RFT] MMC: core/core.c: mmc_rescan detects card change in one run
Date: Thu, 19 Feb 2009 17:26:26 +0200
Message-Id: <1235057186-31714-1-git-send-email-ext-jorg.2.schummer@nokia.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
X-OriginalArrivalTime: 19 Feb 2009 15:26:28.0367 (UTC) FILETIME=[6F24A9F0:01C992A6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch, mmc_rescan can detect the removal of an mmc card and
the insertion of (possibly another) card in the same run. This means
that a card change can be detected without having to call
mmc_detect_change multiple times.

This change should generalise the core such that it can be easily used
by hosts which provide a mechanism to detect only the presence of a card
reader cover, which has to be taken off in order to insert a card. Other
hosts ("card detect" or "MMC_CAP_NEEDS_POLL") each receive an event when
a card is removed and when a card is inserted, so it is sufficient for
them if mmc_rescan handles only one event at a time. "Cover detect"
hosts, however, only receive events about the cover status. This means
that between 2 subsequent events, both a card removal and a card
insertion can occur. In this case, the current version of mmc_rescan
would only detect the removal of the previous card but not the insertion
of the new card.

This patch has been tested with the "cover detect" mechanism. If you
can, please test it with "card detect" and/or "polling" card readers.

Signed-off-by: Jorg Schummer <ext-jorg.2.schummer@nokia.com>
---
 drivers/mmc/core/core.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index df6ce4a..cd2e29f 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -740,6 +740,22 @@ void mmc_rescan(struct work_struct *work)
 
 	mmc_bus_get(host);
 
+	/* if there is a card registered */
+	if (host->bus_ops != NULL) {
+
+		if (host->bus_ops->detect && !host->bus_dead) {
+
+			/* check whether the card is still present */
+			host->bus_ops->detect(host);
+
+			/* release the bus and update bus status in case
+			   the card was removed */
+			mmc_bus_put(host);
+			mmc_bus_get(host);
+		}
+	}
+
+	/* if there is no card registered */
 	if (host->bus_ops == NULL) {
 		/*
 		 * Only we can add a new handler, so it's safe to
@@ -789,12 +805,8 @@ void mmc_rescan(struct work_struct *work)
 
 		mmc_release_host(host);
 		mmc_power_off(host);
-	} else {
-		if (host->bus_ops->detect && !host->bus_dead)
-			host->bus_ops->detect(host);
-
+	} else
 		mmc_bus_put(host);
-	}
 out:
 	if (host->caps & MMC_CAP_NEEDS_POLL)
 		mmc_schedule_delayed_work(&host->detect, HZ);
-- 
1.5.4.3

