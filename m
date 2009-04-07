Return-Path: <linux-kernel-owner+w=401wt.eu-S1756508AbZDGMDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbZDGMDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 08:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740AbZDGMBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 08:01:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:63076 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495AbZDGMAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 08:00:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,337,1235980800"; 
   d="scan'208";a="128748911"
Message-Id: <20090407115234.200152360@intel.com>
References: <20090407115039.780820496@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 07 Apr 2009 19:50:43 +0800
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
Subject: [PATCH 04/14] mm: reduce duplicate page fault code
Content-Disposition: inline; filename=filemap-fault-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Restore the simplicity of the filemap_fault():no_cached_page block.
The VM_FAULT_RETRY case is not all that different.

No readahead/readaround will be performed after no_cached_page,
because no_cached_page either means MADV_RANDOM or some error condition.

Cc: Ying Han <yinghan@google.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/filemap.c |   22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

--- mm.orig/mm/filemap.c
+++ mm/mm/filemap.c
@@ -1565,7 +1565,6 @@ int filemap_fault(struct vm_area_struct 
 retry_find:
 	page = find_lock_page(mapping, vmf->pgoff);
 
-retry_find_nopage:
 	/*
 	 * For sequential accesses, we use the generic readahead logic.
 	 */
@@ -1615,6 +1614,7 @@ retry_find_nopage:
 				start = vmf->pgoff - ra_pages / 2;
 			do_page_cache_readahead(mapping, file, start, ra_pages);
 		}
+retry_find_retry:
 		retry_ret = find_lock_page_retry(mapping, vmf->pgoff,
 				vma, &page, retry_flag);
 		if (retry_ret == VM_FAULT_RETRY)
@@ -1626,7 +1626,6 @@ retry_find_nopage:
 	if (!did_readaround)
 		ra->mmap_miss--;
 
-retry_page_update:
 	/*
 	 * We have a locked page in the page cache, now we need to check
 	 * that it's up-to-date. If not, it is going to be due to an error.
@@ -1662,23 +1661,8 @@ no_cached_page:
 	 * In the unlikely event that someone removed it in the
 	 * meantime, we'll just come back here and read it again.
 	 */
-	if (error >= 0) {
-		/*
-		 * If caller cannot tolerate a retry in the ->fault path
-		 * go back to check the page again.
-		 */
-		if (!retry_flag)
-			goto retry_find;
-
-		retry_ret = find_lock_page_retry(mapping, vmf->pgoff,
-					vma, &page, retry_flag);
-		if (retry_ret == VM_FAULT_RETRY)
-			return retry_ret;
-		if (!page)
-			goto retry_find_nopage;
-		else
-			goto retry_page_update;
-	}
+	if (error >= 0)
+		goto retry_find_retry;
 
 	/*
 	 * An error return from page_cache_read can result if the

-- 

