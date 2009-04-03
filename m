Return-Path: <linux-kernel-owner+w=401wt.eu-S1758021AbZDCIXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021AbZDCIXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 04:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbZDCIWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 04:22:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:12286 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbZDCIWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 04:22:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,318,1235980800"; 
   d="scan'208";a="127445256"
Date: Fri, 3 Apr 2009 16:22:30 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ying Han <yinghan@google.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, mikew@google.com,
       rientjes@google.com, rohitseth@google.com, hugh@veritas.com,
       a.p.zijlstra@chello.nl, hpa@zytor.com, edwintorok@gmail.com,
       lee.schermerhorn@hp.com, npiggin@suse.de
Subject: [PATCH] vfs: fix find_lock_page_retry() return value parsing
Message-ID: <20090403082230.GA6084@localhost>
References: <604427e00812051140s67b2a89dm35806c3ee3b6ed7a@mail.gmail.com> <20090331150046.16539218.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090331150046.16539218.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find_lock_page_retry() won't touch the *ppage value when returning
VM_FAULT_RETRY. This is fine except for the case

        if (VM_RandomReadHint())
                goto no_cached_page;

where the 'page' could be undefined after calling find_lock_page_retry().

Fix it by checking the VM_FAULT_RETRY case first.

Cc: Ying Han <yinghan@google.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/filemap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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
