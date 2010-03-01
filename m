Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447Ab0CAFh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 00:37:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:11799 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab0CAFh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 00:37:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,557,1262592000"; 
   d="scan'208";a="544789717"
Message-Id: <20100301052651.857984880@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 01 Mar 2010 13:26:51 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jens Axboe <jens.axboe@oracle.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Clemens Ladisch <clemens@ladisch.de>
CC: Olivier Galibert <galibert@pobox.com>
cc: Vivek Goyal <vgoyal@redhat.com>
cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
cc: Matt Mackall <mpm@selenic.com>
CC: Nick Piggin <npiggin@suse.de>
cc: Linux Memory Management List <linux-mm@kvack.org>
CC: <linux-fsdevel@vger.kernel.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/16] [PATCH 00/15] 512K readahead size with thrashing safe readahead v3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

This enlarges the default readahead size from 128K to 512K.
To avoid possible regressions, also do
- scale down readahead size on small device and small memory
- thrashing safe context readahead
- add readahead tracing/stats support to help expose possible problems

Besides, the patchset also includes several algorithm updates:
- no start-of-file readahead after lseek
- faster radix_tree_next_hole()/radix_tree_prev_hole()
- pagecache context based mmap read-around


Changes since v2:
- add notes on readahead size
- limit read-around size for small memory system, but don't limit readahead size
- bug fix: allow context readahead async size grow to its full size
- bug fix: let radix_tree_lookup_leaf_node() handle the height=1 case

Changes since v1:
- update mmap read-around heuristics (Thanks to Nick Piggin)
- radix_tree_lookup_leaf_node() for the pagecache based mmap read-around
- use __print_symbolic() to show readahead pattern names
  (Thanks to Steven Rostedt)
- scale down readahead size proportional to system memory
  (Thanks to Matt Mackall)
- add readahead size kernel parameter (by Nikanth Karthikesan)
- add comments from Christian Ehrhardt

Changes since RFC:
- move the lenthy intro text to individual patch changelogs
- treat get_capacity()==0 as uninitilized value (Thanks to Vivek Goyal)
- increase readahead size limit for small devices (Thanks to Jens Axboe)
- add fio test results by Vivek Goyal


[PATCH 01/16] readahead: limit readahead size for small devices
[PATCH 02/16] readahead: retain inactive lru pages to be accessed soon
[PATCH 03/16] readahead: bump up the default readahead size
[PATCH 04/16] readahead: make default readahead size a kernel parameter
[PATCH 05/16] readahead: limit read-ahead size for small memory systems
[PATCH 06/16] readahead: add notes on readahead size
[PATCH 07/16] readahead: replace ra->mmap_miss with ra->ra_flags
[PATCH 08/16] readahead: thrashing safe context readahead
[PATCH 09/16] readahead: record readahead patterns
[PATCH 10/16] readahead: add tracing event
[PATCH 11/16] readahead: add /debug/readahead/stats
[PATCH 12/16] readahead: dont do start-of-file readahead after lseek()
[PATCH 13/16] radixtree: introduce radix_tree_lookup_leaf_node()
[PATCH 14/16] radixtree: speed up the search for hole
[PATCH 15/16] readahead: reduce MMAP_LOTSAMISS for mmap read-around
[PATCH 16/16] readahead: pagecache context based mmap read-around

 Documentation/kernel-parameters.txt |    4 
 block/blk-core.c                    |    3 
 block/genhd.c                       |   24 +
 fs/fuse/inode.c                     |    2 
 fs/read_write.c                     |    3 
 include/linux/fs.h                  |   64 +++
 include/linux/mm.h                  |    8 
 include/linux/radix-tree.h          |    2 
 include/trace/events/readahead.h    |   78 ++++
 lib/radix-tree.c                    |  104 ++++-
 mm/Kconfig                          |   13 
 mm/filemap.c                        |   34 +
 mm/readahead.c                      |  458 ++++++++++++++++++++++----
 13 files changed, 688 insertions(+), 109 deletions(-)

Thanks,
Fengguang

