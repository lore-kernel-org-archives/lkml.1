Return-Path: <linux-kernel-owner+w=401wt.eu-S1752584AbZBQNoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbZBQNoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 08:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbZBQNoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 08:44:01 -0500
Received: from smtp.nokia.com ([192.100.122.233]:26484 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbZBQNoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 08:44:00 -0500
From: Jorg Schummer <ext-jorg.2.schummer@nokia.com>
To: drzeus-mmc@drzeus.cx
Cc: linux-kernel@vger.kernel.org,
       Jorg Schummer <ext-jorg.2.schummer@nokia.com>
Subject: [PATCH] MMC: core/core.c: fixed: delayed_work was never cancelled
Date: Tue, 17 Feb 2009 15:32:10 +0200
Message-Id: <1234877530-28490-1-git-send-email-ext-jorg.2.schummer@nokia.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
X-OriginalArrivalTime: 17 Feb 2009 13:32:12.0002 (UTC) FILETIME=[239AE420:01C99104]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The delayed work item mmc_host.detect is now cancelled before flushing
the work queue. This takes care of cases when delayed_work was scheduled
for mmc_host.detect, but not yet placed in the work queue.

Signed-off-by: Jorg Schummer <ext-jorg.2.schummer@nokia.com>
---
 drivers/mmc/core/core.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index f7284b9..2ffae3d 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -57,8 +57,9 @@ static int mmc_schedule_delayed_work(struct delayed_work *work,
 /*
  * Internal function. Flush all scheduled work from the MMC work queue.
  */
-static void mmc_flush_scheduled_work(void)
+static void mmc_flush_scheduled_work(struct mmc_host *host)
 {
+	cancel_delayed_work(&host->detect);
 	flush_workqueue(workqueue);
 }
 
@@ -738,7 +739,7 @@ void mmc_stop_host(struct mmc_host *host)
 	spin_unlock_irqrestore(&host->lock, flags);
 #endif
 
-	mmc_flush_scheduled_work();
+	mmc_flush_scheduled_work(host);
 
 	mmc_bus_get(host);
 	if (host->bus_ops && !host->bus_dead) {
@@ -765,7 +766,7 @@ void mmc_stop_host(struct mmc_host *host)
  */
 int mmc_suspend_host(struct mmc_host *host, pm_message_t state)
 {
-	mmc_flush_scheduled_work();
+	mmc_flush_scheduled_work(host);
 
 	mmc_bus_get(host);
 	if (host->bus_ops && !host->bus_dead) {
-- 
1.5.4.3

