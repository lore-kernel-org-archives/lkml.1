Return-Path: <linux-kernel-owner+w=401wt.eu-S1757630AbZAMN1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630AbZAMN1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757578AbZAMN1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:27:05 -0500
Received: from smtp.nokia.com ([192.100.105.134]:21708 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757408AbZAMN1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:27:03 -0500
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>
Date: Tue, 13 Jan 2009 15:38:34 +0200
Message-Id: <20090113133834.29474.10722.sendpatchset@ahunter-laptop>
In-Reply-To: <20090113133827.29474.92645.sendpatchset@ahunter-laptop>
References: <20090113133827.29474.92645.sendpatchset@ahunter-laptop>
Subject: [PATCH 1/2] OMAP: HSMMC: Do dma cleanup also with data CRC errors
X-OriginalArrivalTime: 13 Jan 2009 13:26:22.0746 (UTC) FILETIME=[86F967A0:01C97582]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 60c6ac58ae03cda78117aef7b0ad3dddbe4deb1a Mon Sep 17 00:00:00 2001
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Date: Fri, 5 Dec 2008 12:31:46 +0200
Subject: [PATCH] OMAP: HSMMC: Do dma cleanup also with data CRC errors

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
---
 drivers/mmc/host/omap_hsmmc.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 97150c0..115d114 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -378,9 +378,9 @@ mmc_omap_cmd_done(struct mmc_omap_host *host, struct mmc_command *cmd)
 /*
  * DMA clean up for command errors
  */
-static void mmc_dma_cleanup(struct mmc_omap_host *host)
+static void mmc_dma_cleanup(struct mmc_omap_host *host, int errno)
 {
-	host->data->error = -ETIMEDOUT;
+	host->data->error = errno;
 
 	if (host->use_dma && host->dma_ch != -1) {
 		dma_unmap_sg(mmc_dev(host->mmc), host->data->sg, host->dma_len,
@@ -465,7 +465,7 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 				end_cmd = 1;
 			}
 			if (host->data) {
-				mmc_dma_cleanup(host);
+				mmc_dma_cleanup(host, -ETIMEDOUT);
 				OMAP_HSMMC_WRITE(host->base, SYSCTL,
 					OMAP_HSMMC_READ(host->base,
 							SYSCTL) | SRD);
@@ -474,13 +474,12 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 					;
 			}
 		}
-		if ((status & DATA_TIMEOUT) ||
-			(status & DATA_CRC)) {
+		if ((status & DATA_TIMEOUT) || (status & DATA_CRC)) {
 			if (host->data) {
 				if (status & DATA_TIMEOUT)
-					mmc_dma_cleanup(host);
+					mmc_dma_cleanup(host, -ETIMEDOUT);
 				else
-					host->data->error = -EILSEQ;
+					mmc_dma_cleanup(host, -EILSEQ);
 				OMAP_HSMMC_WRITE(host->base, SYSCTL,
 					OMAP_HSMMC_READ(host->base,
 							SYSCTL) | SRD);
-- 
1.5.4.3

