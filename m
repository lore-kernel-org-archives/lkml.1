Return-Path: <linux-kernel-owner+w=401wt.eu-S1761332AbZDCIgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761332AbZDCIgc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 04:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbZDCIgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 04:36:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:59630 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbZDCIgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 04:36:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,318,1235980800"; 
   d="scan'208";a="127448339"
Date: Fri, 3 Apr 2009 16:35:59 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ying Han <yinghan@google.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, mikew@google.com,
       rientjes@google.com, rohitseth@google.com, hugh@veritas.com,
       a.p.zijlstra@chello.nl, hpa@zytor.com, edwintorok@gmail.com,
       lee.schermerhorn@hp.com, npiggin@suse.de
Subject: [PATCH v2] vfs: fix find_lock_page_retry() return value parsing
Message-ID: <20090403083559.GB6084@localhost>
References: <604427e00812051140s67b2a89dm35806c3ee3b6ed7a@mail.gmail.com> <20090331150046.16539218.akpm@linux-foundation.org> <20090403082230.GA6084@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403082230.GA6084@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find_lock_page_retry() won't touch the *ppage value when returning
VM_FAULT_RETRY. This is fine except for the case

        if (VM_RandomReadHint())
                goto no_cached_page;

where the 'page' could be undefined after calling find_lock_page_retry().

Fix it by checking the VM_FAULT_RETRY case first. Also do this for the
other two find_lock_page_retry() invocations for the sake of consistency.

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
