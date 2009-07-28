Return-Path: <linux-kernel-owner+w=401wt.eu-S1753789AbZG1Kmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbZG1Kmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 06:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbZG1Kmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 06:42:44 -0400
Received: from smtp.nokia.com ([192.100.122.233]:47848 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbZG1Kmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 06:42:42 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       Pierre Ossman <pierre@ossman.eu>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Matt Fleming <matt@console-pimps.org>,
       lkml <linux-kernel@vger.kernel.org>
Date: Tue, 28 Jul 2009 13:42:23 +0300
Message-Id: <20090728104223.2371.92338.sendpatchset@ahunter-laptop>
In-Reply-To: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
References: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
Subject: [PATCH V2 31/32] omap_hsmmc: set a large data timeout for commands with busy signal
X-OriginalArrivalTime: 28 Jul 2009 10:41:51.0452 (UTC) FILETIME=[043079C0:01CA0F70]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d9cb1021a2d64c89bbc5763dbbcece68bcc0147c Mon Sep 17 00:00:00 2001
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
index abe1fa1..f5f207d 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -990,7 +990,8 @@ static int omap_hsmmc_start_dma_transfer(struct omap_hsmmc_host *host,
 }
 
 static void set_data_timeout(struct omap_hsmmc_host *host,
-			     struct mmc_request *req)
+			     unsigned int timeout_ns,
+			     unsigned int timeout_clks)
 {
 	unsigned int timeout, cycle_ns;
 	uint32_t reg, clkd, dto = 0;
@@ -1001,8 +1002,8 @@ static void set_data_timeout(struct omap_hsmmc_host *host,
 		clkd = 1;
 
 	cycle_ns = 1000000000 / (clk_get_rate(host->fclk) / clkd);
-	timeout = req->data->timeout_ns / cycle_ns;
-	timeout += req->data->timeout_clks;
+	timeout = timeout_ns / cycle_ns;
+	timeout += timeout_clks;
 	if (timeout) {
 		while ((timeout & 0x80000000) == 0) {
 			dto += 1;
@@ -1036,12 +1037,18 @@ omap_hsmmc_prepare_data(struct omap_hsmmc_host *host, struct mmc_request *req)
 
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

