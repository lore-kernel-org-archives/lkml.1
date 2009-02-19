Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbZBSLRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbZBSLRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 06:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbZBSLRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 06:17:23 -0500
Received: from smtp.nokia.com ([192.100.122.233]:63374 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756913AbZBSLRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 06:17:21 -0500
From: Jorg Schummer <ext-jorg.2.schummer@nokia.com>
To: drzeus-mmc@drzeus.cx
Cc: linux-kernel@vger.kernel.org,
       Jorg Schummer <ext-jorg.2.schummer@nokia.com>
Subject: [PATCH][take 2] MMC: core/core.c: fixed: delayed_work was never cancelled
Date: Thu, 19 Feb 2009 13:17:03 +0200
Message-Id: <1235042223-25586-1-git-send-email-ext-jorg.2.schummer@nokia.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <20090218211945.669c3e95@mjolnir.ossman.eu>
References: <20090218211945.669c3e95@mjolnir.ossman.eu>
X-OriginalArrivalTime: 19 Feb 2009 11:17:04.0840 (UTC) FILETIME=[982FA480:01C99283]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The delayed work item mmc_host.detect is now cancelled before flushing
the work queue. This takes care of cases when delayed_work was scheduled
for mmc_host.detect, but not yet placed in the work queue.

Signed-off-by: Jorg Schummer <ext-jorg.2.schummer@nokia.com>
---
 drivers/mmc/core/core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index df6ce4a..b5899e3 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -815,6 +815,7 @@ void mmc_stop_host(struct mmc_host *host)
 	spin_unlock_irqrestore(&host->lock, flags);
 #endif
 
+	cancel_delayed_work(&host->detect);
 	mmc_flush_scheduled_work();
 
 	mmc_bus_get(host);
@@ -842,6 +843,7 @@ void mmc_stop_host(struct mmc_host *host)
  */
 int mmc_suspend_host(struct mmc_host *host, pm_message_t state)
 {
+	cancel_delayed_work(&host->detect);
 	mmc_flush_scheduled_work();
 
 	mmc_bus_get(host);
-- 
1.5.4.3

