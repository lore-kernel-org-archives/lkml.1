Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbZG1Klz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbZG1Klz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 06:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbZG1Kly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 06:41:54 -0400
Received: from smtp.nokia.com ([192.100.122.233]:47772 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbZG1Klw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 06:41:52 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       Pierre Ossman <pierre@ossman.eu>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Matt Fleming <matt@console-pimps.org>,
       lkml <linux-kernel@vger.kernel.org>
Date: Tue, 28 Jul 2009 13:41:39 +0300
Message-Id: <20090728104139.2371.70665.sendpatchset@ahunter-laptop>
In-Reply-To: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
References: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
Subject: [PATCH V2 25/32] omap_hsmmc: cater for weird CMD6 behaviour
X-OriginalArrivalTime: 28 Jul 2009 10:41:10.0796 (UTC) FILETIME=[EBF4DCC0:01CA0F6F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8520f6fd74c073a76121619403808f1e3da0f587 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Sat, 16 May 2009 10:05:40 +0300
Subject: [PATCH] omap_hsmmc: cater for weird CMD6 behaviour

Sometimes the controller unexpectedly produces a TC (transfer
complete) interrupt before the CC (command complete) interrupt for
command 6 (SWITCH).  This is a problem because the CC interrupt
can get mixed up with the next request.  Add a hack for CMD6.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/host/omap_hsmmc.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index c7a6d88..5121277 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -474,6 +474,13 @@ mmc_omap_xfer_done(struct mmc_omap_host *host, struct mmc_data *data)
 	if (!data) {
 		struct mmc_request *mrq = host->mrq;
 
+		/* TC before CC from CMD6 - don't know why, but it happens */
+		if (host->cmd && host->cmd->opcode == 6 &&
+		    host->response_busy) {
+			host->response_busy = 0;
+			return;
+		}
+
 		host->mrq = NULL;
 		mmc_request_done(host->mmc, mrq);
 		return;
-- 
1.5.6.3

