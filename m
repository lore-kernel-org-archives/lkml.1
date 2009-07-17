Return-Path: <linux-kernel-owner+w=401wt.eu-S933726AbZGQAJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933726AbZGQAJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933703AbZGQAJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:09:13 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39122 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933692AbZGQAFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:05:54 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 09/21] Blackfin: fix early_dma_memcpy() handling of busy channels
Date: Thu, 16 Jul 2009 20:05:34 -0400
Message-Id: <1247789146-18786-10-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
References: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The early logic to locate a free DMA channel and then set it up was broken
in a few ways that only manifested itself when we needed to set up more
than 2 on chip SRAM regions (most board defaults setup 1 or 2).  First, we
checked the wrong status register (the destination gets updated, not the
source) and second, we did the ssync before rather than after resetting a
DMA config register.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/bfin_dma_5xx.c |   29 ++++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/blackfin/kernel/bfin_dma_5xx.c b/arch/blackfin/kernel/bfin_dma_5xx.c
index e0bf8cc..9f9b828 100644
--- a/arch/blackfin/kernel/bfin_dma_5xx.c
+++ b/arch/blackfin/kernel/bfin_dma_5xx.c
@@ -253,32 +253,31 @@ void __init early_dma_memcpy(void *pdst, const void *psrc, size_t size)
 	BUG_ON(src % 4);
 	BUG_ON(size % 4);
 
-	/* Force a sync in case a previous config reset on this channel
-	 * occurred.  This is needed so subsequent writes to DMA registers
-	 * are not spuriously lost/corrupted.
-	 */
-	__builtin_bfin_ssync();
-
 	src_ch = 0;
 	/* Find an avalible memDMA channel */
 	while (1) {
-		if (!src_ch || src_ch == (struct dma_register *)MDMA_S1_NEXT_DESC_PTR) {
-			dst_ch = (struct dma_register *)MDMA_D0_NEXT_DESC_PTR;
-			src_ch = (struct dma_register *)MDMA_S0_NEXT_DESC_PTR;
-		} else {
+		if (src_ch == (struct dma_register *)MDMA_S0_NEXT_DESC_PTR) {
 			dst_ch = (struct dma_register *)MDMA_D1_NEXT_DESC_PTR;
 			src_ch = (struct dma_register *)MDMA_S1_NEXT_DESC_PTR;
+		} else {
+			dst_ch = (struct dma_register *)MDMA_D0_NEXT_DESC_PTR;
+			src_ch = (struct dma_register *)MDMA_S0_NEXT_DESC_PTR;
 		}
 
-		if (!bfin_read16(&src_ch->cfg)) {
+		if (!bfin_read16(&src_ch->cfg))
+			break;
+		else if (bfin_read16(&dst_ch->irq_status) & DMA_DONE) {
+			bfin_write16(&src_ch->cfg, 0);
 			break;
-		} else {
-			if (bfin_read16(&src_ch->irq_status) & DMA_DONE)
-				bfin_write16(&src_ch->cfg, 0);
 		}
-
 	}
 
+	/* Force a sync in case a previous config reset on this channel
+	 * occurred.  This is needed so subsequent writes to DMA registers
+	 * are not spuriously lost/corrupted.
+	 */
+	__builtin_bfin_ssync();
+
 	/* Destination */
 	bfin_write32(&dst_ch->start_addr, dst);
 	bfin_write16(&dst_ch->x_count, size >> 2);
-- 
1.6.3.3

