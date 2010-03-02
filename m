Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab0CBUNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 15:13:08 -0500
Received: from mail.df.lth.se ([194.47.250.12]:59648 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755937Ab0CBUNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 15:13:00 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 5/5] DMAENGINE: COH 901 318 lli sg offset fix
Date: Tue,  2 Mar 2010 21:12:56 +0100
Message-Id: <1267560776-18092-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the COH 901 318 respect the scatter offset field by using
the sg_phys() rather than the sg_dma_address() so we get a pointer
to the actual data we want to send rather than the beginning of the
buffer. Also initialize the lli:s a bit more thoroughly.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/coh901318_lli.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/coh901318_lli.c b/drivers/dma/coh901318_lli.c
index 5f9af19..71d58c1 100644
--- a/drivers/dma/coh901318_lli.c
+++ b/drivers/dma/coh901318_lli.c
@@ -74,6 +74,8 @@ coh901318_lli_alloc(struct coh901318_pool *pool, unsigned int len)
 
 	lli = head;
 	lli->phy_this = phy;
+	lli->link_addr = 0x00000000;
+	lli->virt_link_addr = 0x00000000U;
 
 	for (i = 1; i < len; i++) {
 		lli_prev = lli;
@@ -85,13 +87,13 @@ coh901318_lli_alloc(struct coh901318_pool *pool, unsigned int len)
 
 		DEBUGFS_POOL_COUNTER_ADD(pool, 1);
 		lli->phy_this = phy;
+		lli->link_addr = 0x00000000;
+		lli->virt_link_addr = 0x00000000U;
 
 		lli_prev->link_addr = phy;
 		lli_prev->virt_link_addr = lli;
 	}
 
-	lli->link_addr = 0x00000000U;
-
 	spin_unlock(&pool->lock);
 
 	return head;
@@ -268,10 +270,10 @@ coh901318_lli_fill_sg(struct coh901318_pool *pool,
 
 		if (dir == DMA_TO_DEVICE)
 			/* increment source address */
-			src = sg_dma_address(sg);
+			src = sg_phys(sg);
 		else
 			/* increment destination address */
-			dst =  sg_dma_address(sg);
+			dst =  sg_phys(sg);
 
 		bytes_to_transfer = sg_dma_len(sg);
 
-- 
1.6.3.3

