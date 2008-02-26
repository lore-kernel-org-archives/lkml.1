Return-Path: <linux-kernel-owner+w=401wt.eu-S1764170AbYBZUmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764170AbYBZUmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754616AbYBZUmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:42:22 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:49005 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbYBZUmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:42:21 -0500
Date: Tue, 26 Feb 2008 21:42:11 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: lethal@linux-sh.org, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/9] arch/sh/drivers/dma/dma-sh.c: Correct use of ! and &
Message-ID: <Pine.LNX.4.64.0802262141450.18200@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In commit e6bafba5b4765a5a252f1b8d31cbf6d2459da337, a bug was fixed that
involved converting !x & y to !(x & y).  The code below shows the same
pattern, and thus should perhaps be fixed in the same way.

This is not tested and clearly changes the semantics, so it is only
something to consider.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@ expression E1,E2; @@
(
  !E1 & !E2
|
- !E1 & E2
+ !(E1 & E2)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/arch/sh/drivers/dma/dma-sh.c b/arch/sh/drivers/dma/dma-sh.c
--- a/arch/sh/drivers/dma/dma-sh.c 2008-02-02 16:08:46.000000000 +0100
+++ b/arch/sh/drivers/dma/dma-sh.c 2008-02-26 08:00:00.000000000 +0100
@@ -90,7 +90,7 @@ static irqreturn_t dma_tei(int irq, void
 
 static int sh_dmac_request_dma(struct dma_channel *chan)
 {
-	if (unlikely(!chan->flags & DMA_TEI_CAPABLE))
+	if (unlikely(!(chan->flags & DMA_TEI_CAPABLE)))
 		return 0;
 
 	return request_irq(get_dmte_irq(chan->chan), dma_tei,
