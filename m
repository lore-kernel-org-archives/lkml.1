Return-Path: <linux-kernel-owner+w=401wt.eu-S937740AbZDJGUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937740AbZDJGUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 02:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935677AbZDJGQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 02:16:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:9669 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935739AbZDJGQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 02:16:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,165,1239001200"; 
   d="scan'208";a="130013482"
Message-Id: <20090410061254.719205499@intel.com>
References: <20090410060957.442203404@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 10 Apr 2009 14:10:04 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: Ying Han <yinghan@google.com>
Subject: [PATCH 7/9] readahead: sequential mmap readahead
Content-Disposition: inline; filename=readahead-mmap-sequential-readahead.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Auto-detect sequential mmap reads and do readahead for them.

The sequential mmap readahead will be triggered when
- sync readahead: it's a major fault and (prev_offset == offset-1);
- async readahead: minor fault on PG_readahead page with valid readahead state.

The benefits of doing readahead instead of read-around:
- less I/O wait thanks to async readahead
- double real I/O size and no more cache hits

The single stream case is improved a little.
For 100,000 sequential mmap reads:

                                    user       system    cpu        total
(1-1)  plain -mm, 128KB readaround: 3.224      2.554     48.40%     11.838
(1-2)  plain -mm, 256KB readaround: 3.170      2.392     46.20%     11.976
(2)  patched -mm, 128KB readahead:  3.117      2.448     47.33%     11.607

The patched (2) has smallest total time, since it has no cache hit overheads
and less I/O block time(thanks to async readahead). Here the I/O size
makes no much difference, since there's only one single stream.

Note that (1-1)'s real I/O size is 64KB and (1-2)'s real I/O size is 128KB,
since the half of the read-around pages will be readahead cache hits.

This is going to make _real_ differences for _concurrent_ IO streams.

Cc: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/filemap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- mm.orig/mm/filemap.c
+++ mm/mm/filemap.c
@@ -1471,7 +1471,8 @@ static void do_sync_mmap_readahead(struc
 	if (VM_RandomReadHint(vma))
 		return;
 
-	if (VM_SequentialReadHint(vma)) {
+	if (VM_SequentialReadHint(vma) ||
+			offset - 1 == (ra->prev_pos >> PAGE_CACHE_SHIFT)) {
 		page_cache_sync_readahead(mapping, ra, file, offset, 1);
 		return;
 	}

-- 

