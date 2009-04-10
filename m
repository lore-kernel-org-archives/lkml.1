Return-Path: <linux-kernel-owner+w=401wt.eu-S937561AbZDJGTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937561AbZDJGTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 02:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934417AbZDJGQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 02:16:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:9669 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935626AbZDJGQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 02:16:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,165,1239001200"; 
   d="scan'208";a="130013477"
Message-Id: <20090410061253.763863689@intel.com>
References: <20090410060957.442203404@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 10 Apr 2009 14:09:58 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: Ying Han <yinghan@google.com>
Subject: [PATCH 1/9] readahead: move max_sane_readahead() calls into force_page_cache_readahead()
Content-Disposition: inline; filename=readahead-move-max_sane_readahead.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: code simplification.

Cc: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/fadvise.c   |    2 +-
 mm/filemap.c   |    3 +--
 mm/madvise.c   |    3 +--
 mm/readahead.c |    1 +
 4 files changed, 4 insertions(+), 5 deletions(-)

--- mm.orig/mm/fadvise.c
+++ mm/mm/fadvise.c
@@ -101,7 +101,7 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, lof
 		
 		ret = force_page_cache_readahead(mapping, file,
 				start_index,
-				max_sane_readahead(nrpages));
+				nrpages);
 		if (ret > 0)
 			ret = 0;
 		break;
--- mm.orig/mm/filemap.c
+++ mm/mm/filemap.c
@@ -1389,8 +1389,7 @@ do_readahead(struct address_space *mappi
 	if (!mapping || !mapping->a_ops || !mapping->a_ops->readpage)
 		return -EINVAL;
 
-	force_page_cache_readahead(mapping, filp, index,
-					max_sane_readahead(nr));
+	force_page_cache_readahead(mapping, filp, index, nr);
 	return 0;
 }
 
--- mm.orig/mm/madvise.c
+++ mm/mm/madvise.c
@@ -123,8 +123,7 @@ static long madvise_willneed(struct vm_a
 		end = vma->vm_end;
 	end = ((end - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 
-	force_page_cache_readahead(file->f_mapping,
-			file, start, max_sane_readahead(end - start));
+	force_page_cache_readahead(file->f_mapping, file, start, end - start);
 	return 0;
 }
 
--- mm.orig/mm/readahead.c
+++ mm/mm/readahead.c
@@ -210,6 +210,7 @@ int force_page_cache_readahead(struct ad
 	if (unlikely(!mapping->a_ops->readpage && !mapping->a_ops->readpages))
 		return -EINVAL;
 
+	nr_to_read = max_sane_readahead(nr_to_read);
 	while (nr_to_read) {
 		int err;
 

-- 

