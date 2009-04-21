Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbZDUHjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbZDUHjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 03:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbZDUHji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 03:39:38 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51982 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194AbZDUHjg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 03:39:36 -0400
From: "Gadiyar, Anand" <gadiyar@ti.com>
To: "pierre@ossman.eu" <pierre@ossman.eu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Tue, 21 Apr 2009 13:09:22 +0530
Subject: [PATCH] OMAP: HSMMC: Do not enable buffer ready interrupt if using
 DMA
Thread-Topic: [PATCH] OMAP: HSMMC: Do not enable buffer ready interrupt if
 using DMA
Thread-Index: AcnCVEmec9k162NiTVm93Q6WrBtuLA==
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB02FB2F2A90@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anand Gadiyar <gadiyar@ti.com>

OMAP: HSMMC: Do not enable buffer ready interrupt if using DMA

This considerably reduces the number of interrupts during a transfer
and ought to result in some power saving.

Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Kishore Kadiyala <kishore.kadiyala@ti.com>
---
diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index e62a22a..2d83807 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -70,6 +70,8 @@
 #define DTO_MASK		0x000F0000
 #define DTO_SHIFT		16
 #define INT_EN_MASK		0x307F0033
+#define BWR_ENABLE		(1 << 4)
+#define BRR_ENABLE		(1 << 5)
 #define INIT_STREAM		(1 << 1)
 #define DP_SELECT		(1 << 21)
 #define DDIR			(1 << 4)
@@ -241,7 +243,12 @@ mmc_omap_start_command(struct mmc_omap_host *host, struct mmc_command *cmd,
 	 */
 	OMAP_HSMMC_WRITE(host->base, STAT, STAT_CLEAR);
 	OMAP_HSMMC_WRITE(host->base, ISE, INT_EN_MASK);
-	OMAP_HSMMC_WRITE(host->base, IE, INT_EN_MASK);
+
+	if (host->use_dma)
+		OMAP_HSMMC_WRITE(host->base, IE,
+				 INT_EN_MASK & ~(BRR_ENABLE | BWR_ENABLE));
+	else
+		OMAP_HSMMC_WRITE(host->base, IE, INT_EN_MASK);
 
 	host->response_busy = 0;
 	if (cmd->flags & MMC_RSP_PRESENT) {
