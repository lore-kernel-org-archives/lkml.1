Return-Path: <linux-kernel-owner+w=401wt.eu-S936602AbZDJGVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936602AbZDJGVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 02:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932490AbZDJGQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 02:16:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:8091 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763210AbZDJGQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 02:16:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,165,1239001200"; 
   d="scan'208";a="130013490"
Message-Id: <20090410061254.405181450@intel.com>
References: <20090410060957.442203404@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 10 Apr 2009 14:10:02 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: Ying Han <yinghan@google.com>
Subject: [PATCH 5/9] readahead: remove sync/async readahead call dependency
Content-Disposition: inline; filename=readahead-remove-call-dependancy.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The readahead call scheme is error-prone in that it expects on the call sites
to check for async readahead after doing any sync one. I.e. 

			if (!page)
				page_cache_sync_readahead();
			page = find_get_page();
			if (page && PageReadahead(page))
				page_cache_async_readahead();

This is because PG_readahead could be set by a sync readahead for the _current_
newly faulted in page, and the readahead code simply expects one more callback
on the same page to start the async readahead. If the caller fails to do so, it
will miss the PG_readahead bits and never able to start an async readahead.

Eliminate this insane constraint by piggy-backing the async part into the
current readahead window.

Now if an async readahead should be started immediately after a sync one,
the readahead logic itself will do it. So the following code becomes valid:
(the 'else' in particular)

			if (!page)
				page_cache_sync_readahead();
			else if (PageReadahead(page))
				page_cache_async_readahead();

Cc: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/readahead.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- mm.orig/mm/readahead.c
+++ mm/mm/readahead.c
@@ -421,6 +421,16 @@ ondemand_readahead(struct address_space 
 	ra->async_size = ra->size > req_size ? ra->size - req_size : ra->size;
 
 readit:
+	/*
+	 * Will this read hit the readahead marker made by itself?
+	 * If so, trigger the readahead marker hit now, and merge
+	 * the resulted next readahead window into the current one.
+	 */
+	if (offset == ra->start && ra->size == ra->async_size) {
+		ra->async_size = get_next_ra_size(ra, max);
+		ra->size += ra->async_size;
+	}
+
 	return ra_submit(ra, mapping, filp);
 }
 

-- 

