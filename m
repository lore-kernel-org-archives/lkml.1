Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbZDGMEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbZDGMEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 08:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755506AbZDGMBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 08:01:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:5914 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694AbZDGMA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 08:00:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,337,1235980800"; 
   d="scan'208";a="128748926"
Message-Id: <20090407115235.116255177@intel.com>
References: <20090407115039.780820496@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 07 Apr 2009 19:50:51 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mike Waychison <mikew@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rohit Seth <rohitseth@google.com>
Cc: Edwin <edwintorok@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ying Han <yinghan@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Cc: <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 12/14] readahead: sequential mmap readahead
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
@@ -1540,7 +1540,8 @@ static void do_sync_mmap_readahead(struc
 	if (VM_RandomReadHint(vma))
 		return;
 
-	if (VM_SequentialReadHint(vma)) {
+	if (VM_SequentialReadHint(vma) ||
+			offset - 1 == (ra->prev_pos >> PAGE_CACHE_SHIFT)) {
 		page_cache_sync_readahead(mapping, ra, file, offset, 1);
 		return;
 	}

-- 

