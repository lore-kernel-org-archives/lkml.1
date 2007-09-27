Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbXI0TuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbXI0TuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 15:50:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758828AbXI0Tt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 15:49:59 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:53001 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757569AbXI0Tt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 15:49:58 -0400
Date: Thu, 27 Sep 2007 20:49:39 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org
Subject: [PATCH mm 2/3] kill redundancy in rotate_reclaimable_page
In-Reply-To: <Pine.LNX.4.64.0709272045180.19737@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0709272048330.19737@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0709272045180.19737@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

a.k.a. mm-use-pagevec-to-rotate-reclaimable-page-cleanup.patch

diff -U5 shows rotate_reclaimable_page() is pointlessly testing
PageActive and PageLRU twice in a row: of course there used to be a
lock taken in between those tests; but now that pagevec_move_tail() is
making those tests under lock, there's no point to repeating them here.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
 mm/swap.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- 2.6.23-rc8-mm2/mm/swap.c	2007-09-27 17:51:11.000000000 +0100
+++ linux/mm/swap.c	2007-09-27 17:51:33.000000000 +0100
@@ -158,18 +158,17 @@ int rotate_reclaimable_page(struct page 
 	if (PageActive(page))
 		return 1;
 	if (!PageLRU(page))
 		return 1;
 
-	if (PageLRU(page) && !PageActive(page)) {
-		page_cache_get(page);
-		local_irq_save(flags);
-		pvec = &__get_cpu_var(rotate_pvecs);
-		if (!pagevec_add(pvec, page))
-			pagevec_move_tail(pvec);
-		local_irq_restore(flags);
-	}
+	page_cache_get(page);
+	local_irq_save(flags);
+	pvec = &__get_cpu_var(lru_rotate_pvecs);
+	if (!pagevec_add(pvec, page))
+		pagevec_move_tail(pvec);
+	local_irq_restore(flags);
+
 	if (!test_clear_page_writeback(page))
 		BUG();
 
 	return 0;
 }
