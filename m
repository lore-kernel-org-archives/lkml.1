Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbZCCLtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbZCCLtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 06:49:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbZCCLtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 06:49:16 -0500
Received: from smtp.nokia.com ([192.100.105.134]:55812 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbZCCLtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 06:49:15 -0500
Message-ID: <49AD1914.8030705@nokia.com>
Date: Tue, 03 Mar 2009 13:48:36 +0200
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
CC: Matt Fleming <matt@console-pimps.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc_core: fix data timeout for SEND_EXT_CSD
References: <4991A00B.8040002@nokia.com>	<20090211133004.GH478@console-pimps.org>	<4992D90E.10506@nokia.com>	<4992E597.2030404@nokia.com>	<20090218211627.7c16339a@mjolnir.ossman.eu>	<499D0B5C.4000005@nokia.com>	<20090219112243.GB25903@console-pimps.org>	<499D4CB6.3070807@nokia.com> <20090302205548.223003d5@mjolnir.ossman.eu>
In-Reply-To: <20090302205548.223003d5@mjolnir.ossman.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Mar 2009 11:48:29.0329 (UTC) FILETIME=[F862D810:01C99BF5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 58e858f20149d279368441055d8ba3ae43a1fc6d Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Tue, 10 Feb 2009 16:32:33 +0200
Subject: [PATCH] mmc_core: fix data timeout for SEND_EXT_CSD

Commit 0d3e0460f307e84904968aad6cff97bd688583d8
"MMC: CSD and CID timeout values" inadvertently broke
the timeout for the MMC command SEND_EXT_CSD.

This patch puts it back again.

Depending on the characteristics of the controller,
this bug may prevent the use of MMC cards.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/core/mmc_ops.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index 9c50e6f..34ce270 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -248,12 +248,15 @@ mmc_send_cxd_data(struct mmc_card *card, struct mmc_host *host,
 
 	sg_init_one(&sg, data_buf, len);
 
-	/*
-	 * The spec states that CSR and CID accesses have a timeout
-	 * of 64 clock cycles.
-	 */
-	data.timeout_ns = 0;
-	data.timeout_clks = 64;
+	if (opcode == MMC_SEND_CSD || opcode == MMC_SEND_CID) {
+		/*
+		 * The spec states that CSR and CID accesses have a timeout
+		 * of 64 clock cycles.
+		 */
+		data.timeout_ns = 0;
+		data.timeout_clks = 64;
+	} else
+		mmc_set_data_timeout(&data, card);
 
 	mmc_wait_for_req(host, &mrq);
 
-- 
1.5.6.3
