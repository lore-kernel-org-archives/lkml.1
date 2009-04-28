Return-Path: <linux-kernel-owner+w=401wt.eu-S1762442AbZD1POt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762442AbZD1POt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932315AbZD1PLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:11:15 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:54223 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762132AbZD1PLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:11:12 -0400
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: linux-mips@linux-mips.org
Cc: ralf@linux-mips.org, dan.j.williams@intel.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] txx9dmac: Fix clearing of CHAR register in 32-bit kernel
Date: Wed, 29 Apr 2009 00:11:15 +0900
Message-Id: <1240931475-31326-1-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CHAR register is 64-bit width but 32-bit kernel uses its lower
part only.  Be careful of initializing it.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
This patch is against linux-mips.org linux-queue tree.
Please queue this or fold into "DMA: TXx9 Soc DMA Controller driver" patch.

 drivers/dma/txx9dmac.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/txx9dmac.c b/drivers/dma/txx9dmac.c
index c655350..9aa9ea9 100644
--- a/drivers/dma/txx9dmac.c
+++ b/drivers/dma/txx9dmac.c
@@ -72,6 +72,16 @@ static void channel64_write_CHAR(const struct txx9dmac_chan *dc, dma_addr_t val)
 		channel64_writel(dc, CHAR, val);
 }
 
+static void channel64_clear_CHAR(const struct txx9dmac_chan *dc)
+{
+#if defined(CONFIG_32BIT) && !defined(CONFIG_64BIT_PHYS_ADDR)
+	channel64_writel(dc, CHAR, 0);
+	channel64_writel(dc, __pad_CHAR, 0);
+#else
+	channel64_writeq(dc, CHAR, 0);
+#endif
+}
+
 static dma_addr_t channel_read_CHAR(const struct txx9dmac_chan *dc)
 {
 	if (is_dmac64(dc))
@@ -318,7 +328,7 @@ static void txx9dmac_reset_chan(struct txx9dmac_chan *dc)
 {
 	channel_writel(dc, CCR, TXX9_DMA_CCR_CHRST);
 	if (is_dmac64(dc)) {
-		channel_writeq(dc, CHAR, 0);
+		channel64_clear_CHAR(dc);
 		channel_writeq(dc, SAR, 0);
 		channel_writeq(dc, DAR, 0);
 	} else {
-- 
1.5.6.3

