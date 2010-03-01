Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab0CAFjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 00:39:05 -0500
Received: from mga03.intel.com ([143.182.124.21]:19911 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861Ab0CAFh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 00:37:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,557,1262592000"; 
   d="scan'208";a="249208731"
Message-Id: <20100301053620.966418452@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 01 Mar 2010 13:26:56 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jens Axboe <jens.axboe@oracle.com>, Matt Mackall <mpm@selenic.com>,
       Rik van Riel <riel@redhat.com>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Clemens Ladisch <clemens@ladisch.de>
CC: Olivier Galibert <galibert@pobox.com>
cc: Vivek Goyal <vgoyal@redhat.com>
CC: Nick Piggin <npiggin@suse.de>
cc: Linux Memory Management List <linux-mm@kvack.org>
CC: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/16] readahead: limit read-ahead size for small memory systems
References: <20100301052651.857984880@intel.com>
Content-Disposition: inline; filename=readahead-small-memory-limit-readaround.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When lifting the default readahead size from 128KB to 512KB,
make sure it won't add memory pressure to small memory systems.

For read-ahead, the memory pressure is mainly readahead buffers consumed
by too many concurrent streams. The context readahead can adapt
readahead size to thrashing threshold well.  So in principle we don't
need to adapt the default _max_ read-ahead size to memory pressure.

For read-around, the memory pressure is mainly read-around misses on
executables/libraries. Which could be reduced by scaling down
read-around size on fast "reclaim passes".

This patch presents a straightforward solution: to limit default
read-ahead size proportional to available system memory, ie.

                512MB mem => 512KB read-around size limit
                128MB mem => 128KB read-around size limit
                 32MB mem =>  32KB read-around size limit

This will allow power users to adjust read-ahead/read-around size at
once, while saving the low end from unnecessary memory pressure, under
the assumption that low end users have no need to request a large
read-around size.

CC: Matt Mackall <mpm@selenic.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/filemap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux.orig/mm/filemap.c	2010-02-26 10:11:41.000000000 +0800
+++ linux/mm/filemap.c	2010-02-27 13:05:16.000000000 +0800
@@ -1431,7 +1431,9 @@ static void do_sync_mmap_readahead(struc
 	/*
 	 * mmap read-around
 	 */
-	ra_pages = max_sane_readahead(ra->ra_pages);
+	ra_pages = min_t(unsigned long,
+			 ra->ra_pages,
+			 roundup_pow_of_two(totalram_pages / 1024));
 	if (ra_pages) {
 		ra->start = max_t(long, 0, offset - ra_pages/2);
 		ra->size = ra_pages;


