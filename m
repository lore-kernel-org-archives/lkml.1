Return-Path: <linux-kernel-owner+w=401wt.eu-S1757568AbZDGMGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbZDGMGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 08:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755756AbZDGMBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 08:01:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:22009 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755396AbZDGMAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 08:00:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,337,1235980800"; 
   d="scan'208";a="128748915"
Message-Id: <20090407115233.866162134@intel.com>
References: <20090407115039.780820496@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 07 Apr 2009 19:50:40 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ying Han <yinghan@google.com>, Wu Fengguang <fengguang.wu@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mike Waychison <mikew@google.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rohit Seth <rohitseth@google.com>
Cc: Edwin <edwintorok@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Cc: <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 01/14] mm: fix find_lock_page_retry() return value parsing
Content-Disposition: inline; filename=filemap-fault-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find_lock_page_retry() won't touch the *ppage value when returning
VM_FAULT_RETRY. So in the case of filemap_fault():no_cached_page,
the 'page' could be undefined after calling find_lock_page_retry().

Fix it by checking the VM_FAULT_RETRY case first.

Cc: Ying Han <yinghan@google.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/filemap.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- mm.orig/mm/filemap.c
+++ mm/mm/filemap.c
@@ -759,7 +759,7 @@ EXPORT_SYMBOL(find_lock_page);
  * @retry: 1 indicate caller tolerate a retry.
  *
  * If retry flag is on, and page is already locked by someone else, return
- * a hint of retry.
+ * a hint of retry and leave *ppage untouched.
  *
  * Return *ppage==NULL if page is not in pagecache. Otherwise return *ppage
  * points to the page in the pagecache with ret=VM_FAULT_RETRY indicate a
@@ -1575,10 +1575,10 @@ retry_find_nopage:
 							   vmf->pgoff, 1);
 			retry_ret = find_lock_page_retry(mapping, vmf->pgoff,
 						vma, &page, retry_flag);
-			if (!page)
-				goto no_cached_page;
 			if (retry_ret == VM_FAULT_RETRY)
 				return retry_ret;
+			if (!page)
+				goto no_cached_page;
 		}
 		if (PageReadahead(page)) {
 			page_cache_async_readahead(mapping, ra, file, page,
@@ -1617,10 +1617,10 @@ retry_find_nopage:
 		}
 		retry_ret = find_lock_page_retry(mapping, vmf->pgoff,
 				vma, &page, retry_flag);
-		if (!page)
-			goto no_cached_page;
 		if (retry_ret == VM_FAULT_RETRY)
 			return retry_ret;
+		if (!page)
+			goto no_cached_page;
 	}
 
 	if (!did_readaround)
@@ -1672,10 +1672,10 @@ no_cached_page:
 
 		retry_ret = find_lock_page_retry(mapping, vmf->pgoff,
 					vma, &page, retry_flag);
+		if (retry_ret == VM_FAULT_RETRY)
+			return retry_ret;
 		if (!page)
 			goto retry_find_nopage;
-		else if (retry_ret == VM_FAULT_RETRY)
-			return retry_ret;
 		else
 			goto retry_page_update;
 	}

-- 

