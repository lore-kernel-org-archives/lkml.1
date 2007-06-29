Return-Path: <linux-kernel-owner+w=401wt.eu-S933507AbXF2OPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933507AbXF2OPL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 10:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933073AbXF2ON3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 10:13:29 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:8728 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766002AbXF2ON0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 10:13:26 -0400
Message-Id: <20070629141528.511942868@de.ibm.com>
References: <20070629135530.912094590@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 29 Jun 2007 15:55:35 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 5/5] Optimize page_mkclean_one
Content-Disposition: inline; filename=006-page-mkclean.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

page_mkclean_one is used to clear the dirty bit and to set the write
protect bit of a pte. In additions it returns true if the pte either
has been dirty or if it has been writable. As far as I can see the
function should return true only if the pte has been dirty, or page
writeback will needlessly write a clean page.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 mm/rmap.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -urpN linux-2.6/mm/rmap.c linux-2.6-patched/mm/rmap.c
--- linux-2.6/mm/rmap.c	2007-06-29 09:58:33.000000000 +0200
+++ linux-2.6-patched/mm/rmap.c	2007-06-29 15:44:58.000000000 +0200
@@ -433,11 +433,12 @@ static int page_mkclean_one(struct page 
 
 		flush_cache_page(vma, address, pte_pfn(*pte));
 		entry = ptep_clear_flush(vma, address, pte);
+		if (pte_dirty(entry))
+			ret = 1;
 		entry = pte_wrprotect(entry);
 		entry = pte_mkclean(entry);
 		set_pte_at(mm, address, pte, entry);
 		lazy_mmu_prot_update(entry);
-		ret = 1;
 	}
 
 	pte_unmap_unlock(pte, ptl);

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

