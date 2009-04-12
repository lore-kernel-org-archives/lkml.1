Return-Path: <linux-kernel-owner+w=401wt.eu-S1757663AbZDLHWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663AbZDLHWw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 03:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756830AbZDLHW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 03:22:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:11423 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756462AbZDLHW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 03:22:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,174,1239001200"; 
   d="scan'208";a="130525062"
Message-Id: <20090412072052.570562649@intel.com>
References: <20090412071950.166891982@intel.com>
User-Agent: quilt/0.46-1
Date: Sun, 12 Apr 2009 15:19:52 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] readahead: move the random read case to bottom
Content-Disposition: inline; filename=readahead-reorder-cases.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split all readahead cases, and move the random one to bottom.

No behavior changes.

This is to prepare for the introduction of context readahead,
and make it easy for inserting accounting/tracing points for each case.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/readahead.c |   46 +++++++++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 21 deletions(-)

--- mm.orig/mm/readahead.c
+++ mm/mm/readahead.c
@@ -339,33 +339,25 @@ ondemand_readahead(struct address_space 
 		   unsigned long req_size)
 {
 	unsigned long max = max_sane_readahead(ra->ra_pages);
-	pgoff_t prev_offset;
-	int	sequential;
+
+	/*
+	 * start of file
+	 */
+	if (!offset)
+		goto initial_readahead;
 
 	/*
 	 * It's the expected callback offset, assume sequential access.
 	 * Ramp up sizes, and push forward the readahead window.
 	 */
-	if (offset && (offset == (ra->start + ra->size - ra->async_size) ||
-			offset == (ra->start + ra->size))) {
+	if ((offset == (ra->start + ra->size - ra->async_size) ||
+	     offset == (ra->start + ra->size))) {
 		ra->start += ra->size;
 		ra->size = get_next_ra_size(ra, max);
 		ra->async_size = ra->size;
 		goto readit;
 	}
 
-	prev_offset = ra->prev_pos >> PAGE_CACHE_SHIFT;
-	sequential = offset - prev_offset <= 1UL || req_size > max;
-
-	/*
-	 * Standalone, small read.
-	 * Read as is, and do not pollute the readahead state.
-	 */
-	if (!hit_readahead_marker && !sequential) {
-		return __do_page_cache_readahead(mapping, filp,
-						offset, req_size, 0);
-	}
-
 	/*
 	 * Hit a marked page without valid readahead state.
 	 * E.g. interleaved reads.
@@ -391,12 +383,24 @@ ondemand_readahead(struct address_space 
 	}
 
 	/*
-	 * It may be one of
-	 * 	- first read on start of file
-	 * 	- sequential cache miss
-	 * 	- oversize random read
-	 * Start readahead for it.
+	 * oversize read
 	 */
+	if (req_size > max)
+		goto initial_readahead;
+
+	/*
+	 * sequential cache miss
+	 */
+	if (offset - (ra->prev_pos >> PAGE_CACHE_SHIFT) <= 1UL)
+		goto initial_readahead;
+
+	/*
+	 * standalone, small random read
+	 * Read as is, and do not pollute the readahead state.
+	 */
+	return __do_page_cache_readahead(mapping, filp, offset, req_size, 0);
+
+initial_readahead:
 	ra->start = offset;
 	ra->size = get_init_ra_size(req_size, max);
 	ra->async_size = ra->size > req_size ? ra->size - req_size : ra->size;

-- 

