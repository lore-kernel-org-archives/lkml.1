Return-Path: <linux-kernel-owner+w=401wt.eu-S1756469AbYKQMfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469AbYKQMfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 07:35:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbYKQMfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 07:35:36 -0500
Received: from smtp.nokia.com ([192.100.122.233]:42319 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbYKQMff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 07:35:35 -0500
Date: Mon, 17 Nov 2008 14:35:21 +0200
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: MMC: Add 8-bit bus width support
Message-ID: <20081117123521.GA15417@angel.research.nokia.com>
Reply-To: Jarkko Lavinen <jarkko.lavinen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: GNU/Linux angel.research.nokia.com
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 17 Nov 2008 12:35:21.0296 (UTC) FILETIME=[F4A97500:01C948B0]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre

Here is a patch which adds 8-bit bus width suport to the mmc
driver common part.  

I've tested it with a test board with 8-bit eMMC device on Omap
3420 HSMMC controller. It speeds up DMA transfer from host to the
card and most of the time is spent in busy polling for the card
to become ready.

Regards
Jarkko Lavinen

>From d038f6ebe177f3f4ae2ae1f8a9dfc648e5625909 Mon Sep 17 00:00:00 2001
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Date: Mon, 17 Nov 2008 14:30:17 +0200
Subject: [PATCH] MMC: Add 8-bit bus width support

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
---
 drivers/mmc/core/mmc.c   |   18 ++++++++++++++----
 include/linux/mmc/host.h |    2 ++
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index fdd7c76..c232d11 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -434,13 +434,24 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 	 * Activate wide bus (if supported).
 	 */
 	if ((card->csd.mmca_vsn >= CSD_SPEC_VER_4) &&
-		(host->caps & MMC_CAP_4_BIT_DATA)) {
+	    (host->caps & (MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA))) {
+		unsigned ext_csd_bit, bus_width;
+
+		if (host->caps & MMC_CAP_8_BIT_DATA) {
+			ext_csd_bit = EXT_CSD_BUS_WIDTH_8;
+			bus_width = MMC_BUS_WIDTH_8;
+		} else {
+			ext_csd_bit = EXT_CSD_BUS_WIDTH_4;
+			bus_width = MMC_BUS_WIDTH_4;
+		}
+
 		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
-			EXT_CSD_BUS_WIDTH, EXT_CSD_BUS_WIDTH_4);
+				 EXT_CSD_BUS_WIDTH, ext_csd_bit);
+
 		if (err)
 			goto free_card;
 
-		mmc_set_bus_width(card->host, MMC_BUS_WIDTH_4);
+		mmc_set_bus_width(card->host, bus_width);
 	}
 
 	if (!oldcard)
@@ -624,4 +635,3 @@ err:
 
 	return err;
 }
-
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index f842f23..4e45725 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -41,6 +41,7 @@ struct mmc_ios {
 
 #define MMC_BUS_WIDTH_1		0
 #define MMC_BUS_WIDTH_4		2
+#define MMC_BUS_WIDTH_8		3
 
 	unsigned char	timing;			/* timing specification used */
 
@@ -116,6 +117,7 @@ struct mmc_host {
 #define MMC_CAP_SDIO_IRQ	(1 << 3)	/* Can signal pending SDIO IRQs */
 #define MMC_CAP_SPI		(1 << 4)	/* Talks only SPI protocols */
 #define MMC_CAP_NEEDS_POLL	(1 << 5)	/* Needs polling for card-detection */
+#define MMC_CAP_8_BIT_DATA	(1 << 6)	/* Can the host do 8 bit transfers */
 
 	/* host specific block data */
 	unsigned int		max_seg_size;	/* see blk_queue_max_segment_size */
-- 
1.5.6.5

