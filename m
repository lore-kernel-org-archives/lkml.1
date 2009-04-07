Return-Path: <linux-kernel-owner+w=401wt.eu-S1756475AbZDGMCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475AbZDGMCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 08:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754747AbZDGMA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 08:00:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:23410 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384AbZDGMAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 08:00:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,337,1235980800"; 
   d="scan'208";a="128748908"
Message-Id: <20090407115234.313061952@intel.com>
References: <20090407115039.780820496@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 07 Apr 2009 19:50:44 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Wu Fengguang <fengguang.wu@intel.com>
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
Cc: Ying Han <yinghan@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Cc: <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 05/14] readahead: account mmap_miss for VM_FAULT_RETRY
Content-Disposition: inline; filename=readahead-mmap_miss-retry.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VM_FAULT_RETRY case introduced a performance bug that leads to
excessive/unconditional mmap readarounds for wild random mmap reads.

A retried page fault means a mmap readahead miss(mmap_miss++) followed by
a hit(mmap_miss--) on the same page. This sticks mmap_miss, and thus stops
mmap readaround from being turned off for wild random reads. Fix it by an
extra mmap_miss increament in order to counteract the followed mmap hit.

Also make mmap_miss a more robust 'unsigned int', so that if ever mmap_miss
goes out of range, it only create _temporary_ performance impacts.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/fs.h |    2 +-
 mm/filemap.c       |    8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

--- mm.orig/mm/filemap.c
+++ mm/mm/filemap.c
@@ -1574,8 +1574,10 @@ retry_find:
 							   vmf->pgoff, 1);
 			retry_ret = find_lock_page_retry(mapping, vmf->pgoff,
 						vma, &page, retry_flag);
-			if (retry_ret == VM_FAULT_RETRY)
+			if (retry_ret == VM_FAULT_RETRY) {
+				ra->mmap_miss++; /* counteract the followed retry hit */
 				return retry_ret;
+			}
 			if (!page)
 				goto no_cached_page;
 		}
@@ -1617,8 +1619,10 @@ retry_find:
 retry_find_retry:
 		retry_ret = find_lock_page_retry(mapping, vmf->pgoff,
 				vma, &page, retry_flag);
-		if (retry_ret == VM_FAULT_RETRY)
+		if (retry_ret == VM_FAULT_RETRY) {
+			ra->mmap_miss++; /* counteract the followed retry hit */
 			return retry_ret;
+		}
 		if (!page)
 			goto no_cached_page;
 	}
--- mm.orig/include/linux/fs.h
+++ mm/include/linux/fs.h
@@ -824,7 +824,7 @@ struct file_ra_state {
 					   there are only # of pages ahead */
 
 	unsigned int ra_pages;		/* Maximum readahead window */
-	int mmap_miss;			/* Cache miss stat for mmap accesses */
+	unsigned int mmap_miss;		/* Cache miss stat for mmap accesses */
 	loff_t prev_pos;		/* Cache last read() position */
 };
 

-- 

