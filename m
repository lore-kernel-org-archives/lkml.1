Return-Path: <linux-kernel-owner+w=401wt.eu-S1759253AbZDLHXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbZDLHXw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 03:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757385AbZDLHWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 03:22:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:31531 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756621AbZDLHWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 03:22:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,174,1239001200"; 
   d="scan'208";a="130525056"
Date: Sun, 12 Apr 2009 15:16:05 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Chenfeng Xu <xcf@ustc.edu.cn>
Subject: [RFC][PATCH] vfs: check inode size on no_cached_page
Message-ID: <20090412071605.GA14058@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[This patch may not necessarily be merged, but at least we should
 be aware of the problem.]

When user space requests past-EOF data, do_generic_file_read() will
issue a bonus readpage call, which may be unfavorable.

do_generic_file_read:
        -> find_page:
        -> find_get_page()             = NULL
        -> page_cache_sync_readahead()
        -> find_get_page()             = NULL
        -> no_cached_page:
        -> readpage:
                -> nfs_readpage()      = error
        -> readpage_error:

Reported-by: Xu Chenfeng <xcf@ustc.edu.cn>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/filemap.c |    5 +++++
 1 file changed, 5 insertions(+)

--- mm.orig/mm/filemap.c
+++ mm/mm/filemap.c
@@ -1269,6 +1269,11 @@ readpage_error:
 		goto out;
 
 no_cached_page:
+		isize = i_size_read(inode);
+		end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
+		if (unlikely(!isize || index > end_index))
+			goto out;
+
 		/*
 		 * Ok, it wasn't cached, so we need to create a new
 		 * page..
