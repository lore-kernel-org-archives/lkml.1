Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbZGJMqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbZGJMqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 08:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbZGJMlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 08:41:46 -0400
Received: from smtp.nokia.com ([192.100.105.134]:19704 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065AbZGJMlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 08:41:44 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Pierre Ossman <pierre@ossman.eu>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Date: Fri, 10 Jul 2009 15:43:45 +0300
Message-Id: <20090710124345.1262.35414.sendpatchset@ahunter-tower>
In-Reply-To: <20090710124004.1262.10422.sendpatchset@ahunter-tower>
References: <20090710124004.1262.10422.sendpatchset@ahunter-tower>
Subject: [PATCH 31/32] omap_hsmmc: set a large data timeout for commands with busy signal
X-OriginalArrivalTime: 10 Jul 2009 12:40:11.0650 (UTC) FILETIME=[90CD3620:01CA015B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 54996066acb35e82f89715c6c59b28bc81e12239 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Fri, 26 Jun 2009 11:29:20 +0300
Subject: [PATCH] omap_hsmmc: set a large data timeout for commands with busy signal

Commands like SWITCH (CMD6) send a response and then signal busy
while the operation is completed.  These commands are expected
to always succeed (otherwise the response would have indicated an
error).

Set an arbitrarily large data timeout value (100ms) for these commands
to ensure that premature timeouts do not occur.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/host/omap_hsmmc.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 427bd49..ae8d33b 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -982,7 +982,8 @@ static int omap_hsmmc_start_dma_transfer(struct omap_hsmmc_host *host,
 }
 
 static void set_data_timeout(struct omap_hsmmc_host *host,
-			     struct mmc_request *req)
+			     unsigned int timeout_ns,
+			     unsigned int timeout_clks)
 {
 	unsigned int timeout, cycle_ns;
 	uint32_t reg, clkd, dto = 0;
@@ -993,8 +994,8 @@ static void set_data_timeout(struct omap_hsmmc_host *host,
 		clkd = 1;
 
 	cycle_ns = 1000000000 / (clk_get_rate(host->fclk) / clkd);
-	timeout = req->data->timeout_ns / cycle_ns;
-	timeout += req->data->timeout_clks;
+	timeout = timeout_ns / cycle_ns;
+	timeout += timeout_clks;
 	if (timeout) {
 		while ((timeout & 0x80000000) == 0) {
 			dto += 1;
@@ -1028,12 +1029,18 @@ omap_hsmmc_prepare_data(struct omap_hsmmc_host *host, struct mmc_request *req)
 
 	if (req->data == NULL) {
 		OMAP_HSMMC_WRITE(host->base, BLK, 0);
+		/*
+		 * Set an arbitrary 100ms data timeout for commands with
+		 * busy signal.
+		 */
+		if (req->cmd->flags & MMC_RSP_BUSY)
+			set_data_timeout(host, 100000000U, 0);
 		return 0;
 	}
 
 	OMAP_HSMMC_WRITE(host->base, BLK, (req->data->blksz)
 					| (req->data->blocks << 16));
-	set_data_timeout(host, req);
+	set_data_timeout(host, req->data->timeout_ns, req->data->timeout_clks);
 
 	if (host->use_dma) {
 		ret = omap_hsmmc_start_dma_transfer(host, req);
-- 
1.5.6.3

