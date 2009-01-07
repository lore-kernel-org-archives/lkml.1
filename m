Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbZAGQlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbZAGQlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 11:41:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755999AbZAGQlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 11:41:18 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:2897 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324AbZAGQlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 11:41:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=UkmwFavEV/cgtRXFteRT2cAwX2acYIY+A+vMEqbPkj/RRvFCT+SBSq8nlptpc/wiBv
         njfg9U7B4RTYqdah0TjGeKRqtZ1AzO/7iyph975d2RPiojWRexmmIrkJVlRGlC/QM4f3
         M4hzbsfhtAYTLbznAMIGX0t1s/j+Cz5EIP6lc=
From: Bryan Wu <cooloney@kernel.org>
To: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/3] Blackfin NFC Driver: do not clobber DMAC1_PERIMUX
Date: Thu,  8 Jan 2009 00:41:57 +0800
Message-Id: <1231346519-28603-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1231346519-28603-1-git-send-email-cooloney@kernel.org>
References: <1231346519-28603-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

only set DMAC1_PERIMUX once we have requested and been granted the dma
channel to prevent breaking other peripherals in the error case

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/mtd/nand/bf5xx_nand.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/nand/bf5xx_nand.c b/drivers/mtd/nand/bf5xx_nand.c
index 9af2a2c..5c6056e 100644
--- a/drivers/mtd/nand/bf5xx_nand.c
+++ b/drivers/mtd/nand/bf5xx_nand.c
@@ -552,7 +552,6 @@ static void bf5xx_nand_dma_write_buf(struct mtd_info *mtd,
 static int bf5xx_nand_dma_init(struct bf5xx_nand_info *info)
 {
 	int ret;
-	unsigned short val;
 
 	/* Do not use dma */
 	if (!hardware_ecc)
@@ -560,13 +559,6 @@ static int bf5xx_nand_dma_init(struct bf5xx_nand_info *info)
 
 	init_completion(&info->dma_completion);
 
-#ifdef CONFIG_BF54x
-	/* Setup DMAC1 channel mux for NFC which shared with SDH */
-	val = bfin_read_DMAC1_PERIMUX();
-	val &= 0xFFFE;
-	bfin_write_DMAC1_PERIMUX(val);
-	SSYNC();
-#endif
 	/* Request NFC DMA channel */
 	ret = request_dma(CH_NFC, "BF5XX NFC driver");
 	if (ret < 0) {
@@ -574,6 +566,12 @@ static int bf5xx_nand_dma_init(struct bf5xx_nand_info *info)
 		return ret;
 	}
 
+#ifdef CONFIG_BF54x
+	/* Setup DMAC1 channel mux for NFC which shared with SDH */
+	bfin_write_DMAC1_PERIMUX(bfin_read_DMAC1_PERIMUX() & ~1);
+	SSYNC();
+#endif
+
 	set_dma_callback(CH_NFC, (void *) bf5xx_nand_dma_irq, (void *) info);
 
 	/* Turn off the DMA channel first */
-- 
1.5.6

