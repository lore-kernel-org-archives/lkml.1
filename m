Return-Path: <linux-kernel-owner+w=401wt.eu-S1761776AbZCaQPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761776AbZCaQPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 12:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755902AbZCaQPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 12:15:38 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:52239 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755856AbZCaQPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 12:15:37 -0400
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: Grant Grundler <grundler@google.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tx4939ide: remove wmb()
Date: Wed,  1 Apr 2009 01:15:36 +0900
Message-Id: <1238516136-15852-1-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* define CHECK_DMA_MASK
* remove use of wmb()

Suggested-by: Grant Grundler <grundler@google.com>
Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
This patch is against linux-next 20090331.

 drivers/ide/tx4939ide.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ide/tx4939ide.c b/drivers/ide/tx4939ide.c
index cc269c0..48186ae 100644
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -327,15 +327,15 @@ static int tx4939ide_dma_end(ide_drive_t *drive)
 	/* read and clear the INTR & ERROR bits */
 	dma_stat = tx4939ide_clear_dma_status(base);
 
-	wmb();
+#define CHECK_DMA_MASK (ATA_DMA_ACTIVE | ATA_DMA_ERR | ATA_DMA_INTR)
 
 	/* verify good DMA status */
-	if ((dma_stat & (ATA_DMA_INTR | ATA_DMA_ERR | ATA_DMA_ACTIVE)) == 0 &&
+	if ((dma_stat & CHECK_DMA_MASK) == 0 &&
 	    (ctl & (TX4939IDE_INT_XFEREND | TX4939IDE_INT_HOST)) ==
 	    (TX4939IDE_INT_XFEREND | TX4939IDE_INT_HOST))
 		/* INT_IDE lost... bug? */
 		return 0;
-	return ((dma_stat & (ATA_DMA_INTR | ATA_DMA_ERR | ATA_DMA_ACTIVE)) !=
+	return ((dma_stat & CHECK_DMA_MASK) !=
 		ATA_DMA_INTR) ? 0x10 | dma_stat : 0;
 }
 
-- 
1.5.6.3

