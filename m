Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbZBJP1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbZBJP1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 10:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbZBJP1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 10:27:38 -0500
Received: from smtp.nokia.com ([192.100.122.233]:48455 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbZBJP1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 10:27:37 -0500
Message-ID: <4991A00B.8040002@nokia.com>
Date: Tue, 10 Feb 2009 17:40:59 +0200
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mmc_core: fix data timeout for SEND_EXT_CSD
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Feb 2009 15:27:16.0156 (UTC) FILETIME=[0DE8EFC0:01C98B94]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 0d3e0460f307e84904968aad6cff97bd688583d8
"MMC: CSD and CID timeout values" inadvertently broke
the timeout for the MMC command SEND_EXT_CSD.

This patch puts it back again.

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 drivers/mmc/core/mmc_ops.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index 9c50e6f..418a270 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -248,12 +248,16 @@ mmc_send_cxd_data(struct mmc_card *card, struct mmc_host *host,
 
 	sg_init_one(&sg, data_buf, len);
 
-	/*
-	 * The spec states that CSR and CID accesses have a timeout
-	 * of 64 clock cycles.
-	 */
-	data.timeout_ns = 0;
-	data.timeout_clks = 64;
+	if (!mmc_host_is_spi(card->host) && opcode == MMC_SEND_EXT_CSD)
+		mmc_set_data_timeout(&data, card);
+	else {
+		/*
+		 * The spec states that CSR and CID accesses have a timeout
+		 * of 64 clock cycles (8 for SPI).
+		 */
+		data.timeout_ns = 0;
+		data.timeout_clks = 64;
+	}
 
 	mmc_wait_for_req(host, &mrq);
 
-- 
1.5.6.3
