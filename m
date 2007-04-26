Return-Path: <linux-kernel-owner+w=401wt.eu-S1423409AbXDZAQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423409AbXDZAQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 20:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422996AbXDZAQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 20:16:18 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:59700 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423001AbXDZAQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 20:16:17 -0400
Date: Wed, 25 Apr 2007 18:16:15 -0600
From: Mike Stroyan <mike.stroyan@hp.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ia64: race flushing icache in do_no_page path
Message-ID: <20070426001615.GA8908@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This is a very similar problem to a copy-on-write cache flushing problem
that Tony Luck fixed in July 2006.  In this case the do_no_page function
handles a fault in an executable or library that is mmapped from an
NFS file system.  The code is copied into a newly reallocated page.
The lazy_mmu_prot_update() function should be used to flush old entries
from the icache for that page on ia64 processors.  But that call is made
after a set_pte_at call that makes the page accessible to other threads
executing the same code.  This was seen to cause application crashes
when an OpenMP application ran many threads calling same functions at
the same time.  The first thread to reach a page starts to fault in the
new code.  One of the other threads overtakes the first and executes old
data from the icache.  That could result in bad instructions.  It is more
obvious when an old cache line contains prefetched non-instruction bits
that result in an illegal instruction trap.

  The problem has only been seen on montecito processors which have
separate level 2 icache and dcache.  This dcache to icache coherency
problem is more likely to occur there because of the much larger level
2 icache.  I suspect that the non-NFS case is working because direct
DMA into the new page is making the instruction cache coherent.  Any
file system that uses a non-DMA copy into the text page could show the
same problem.

Signed-off-by: Mike Stroyan <mike.stroyan@hp.com>

diff --git a/mm/memory.c b/mm/memory.c
index e7066e7..50c8848 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2291,6 +2291,7 @@ retry:
 		entry = mk_pte(new_page, vma->vm_page_prot);
 		if (write_access)
 			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
+		lazy_mmu_prot_update(entry);
 		set_pte_at(mm, address, page_table, entry);
 		if (anon) {
 			inc_mm_counter(mm, anon_rss);
@@ -2312,7 +2313,6 @@ retry:
 
 	/* no need to invalidate: a not-present page shouldn't be cached */
 	update_mmu_cache(vma, address, entry);
-	lazy_mmu_prot_update(entry);
 unlock:
 	pte_unmap_unlock(page_table, ptl);
 	if (dirty_page) {

-- 
Mike Stroyan, mike.stroyan@hp.com
