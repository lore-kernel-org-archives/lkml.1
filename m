Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab0BXDNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 22:13:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:29678 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062Ab0BXDNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 22:13:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,529,1262592000"; 
   d="scan'208";a="598621447"
Message-Id: <20100224031001.026464755@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 24 Feb 2010 11:10:01 +0800
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
Subject: [PATCH 00/15] 512K readahead size with thrashing safe readahead v2 
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


[PATCH 01/15] readahead: limit readahead size for small devices
[PATCH 02/15] readahead: retain inactive lru pages to be accessed soon
[PATCH 03/15] readahead: bump up the default readahead size
[PATCH 04/15] readahead: make default readahead size a kernel parameter
[PATCH 05/15] readahead: limit readahead size for small memory systems
[PATCH 06/15] readahead: replace ra->mmap_miss with ra->ra_flags
[PATCH 07/15] readahead: thrashing safe context readahead
[PATCH 08/15] readahead: record readahead patterns
[PATCH 09/15] readahead: add tracing event
[PATCH 10/15] readahead: add /debug/readahead/stats
[PATCH 11/15] readahead: dont do start-of-file readahead after lseek()
[PATCH 12/15] radixtree: introduce radix_tree_lookup_leaf_node()
[PATCH 13/15] radixtree: speed up the search for hole
[PATCH 14/15] readahead: reduce MMAP_LOTSAMISS for mmap read-around
[PATCH 15/15] readahead: pagecache context based mmap read-around

 Documentation/kernel-parameters.txt |    4 
 block/blk-core.c                    |    3 
 block/genhd.c                       |   24 +
 fs/fuse/inode.c                     |    2 
 fs/read_write.c                     |    3 
 include/linux/fs.h                  |   64 +++
 include/linux/mm.h                  |    8 
 include/linux/radix-tree.h          |    2 
 include/trace/events/readahead.h    |   78 ++++
 lib/radix-tree.c                    |   94 ++++-
 mm/Kconfig                          |   13 
 mm/filemap.c                        |   30 +
 mm/readahead.c                      |  459 ++++++++++++++++++++++----
 13 files changed, 680 insertions(+), 104 deletions(-)

