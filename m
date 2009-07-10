Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbZGJMlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbZGJMlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 08:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbZGJMih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 08:38:37 -0400
Received: from smtp.nokia.com ([192.100.122.233]:34951 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155AbZGJMig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 08:38:36 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Pierre Ossman <pierre@ossman.eu>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>
Date: Fri, 10 Jul 2009 15:41:59 +0300
Message-Id: <20090710124159.1262.22531.sendpatchset@ahunter-tower>
In-Reply-To: <20090710124004.1262.10422.sendpatchset@ahunter-tower>
References: <20090710124004.1262.10422.sendpatchset@ahunter-tower>
Subject: [PATCH 16/32] omap_hsmmc: fix scatter-gather list sanity checking
X-OriginalArrivalTime: 10 Jul 2009 12:38:22.0800 (UTC) FILETIME=[4FEC0500:01CA015B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 85020821e459904d381684dde45a2a500e02cadb Mon Sep 17 00:00:00 2001
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Date: Fri, 24 Apr 2009 14:20:43 +0300
Subject: [PATCH] omap_hsmmc: fix scatter-gather list sanity checking

Do not use host->dma_len when it is uninitialzed.
Finish the request with an error if the mmc_omap_prepare_data()
fails.

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/host/omap_hsmmc.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 41500ac..15f1a9a 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -871,7 +871,7 @@ mmc_omap_start_dma_transfer(struct mmc_omap_host *host, struct mmc_request *req)
 	struct mmc_data *data = req->data;
 
 	/* Sanity check: all the SG entries must be aligned by block size. */
-	for (i = 0; i < host->dma_len; i++) {
+	for (i = 0; i < data->sg_len; i++) {
 		struct scatterlist *sgl;
 
 		sgl = data->sg + i;
@@ -1014,10 +1014,20 @@ static int omap_mmc_disable(struct mmc_host *mmc, int lazy)
 static void omap_mmc_request(struct mmc_host *mmc, struct mmc_request *req)
 {
 	struct mmc_omap_host *host = mmc_priv(mmc);
+	int err;
 
 	WARN_ON(host->mrq != NULL);
 	host->mrq = req;
-	mmc_omap_prepare_data(host, req);
+	err = mmc_omap_prepare_data(host, req);
+	if (err) {
+		req->cmd->error = err;
+		if (req->data)
+			req->data->error = err;
+		host->mrq = NULL;
+		mmc_request_done(mmc, req);
+		return;
+	}
+
 	mmc_omap_start_command(host, req->cmd, req->data);
 }
 
-- 
1.5.6.3

