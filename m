Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab0BXDNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 22:13:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:29683 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755108Ab0BXDNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 22:13:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,529,1262592000"; 
   d="scan'208";a="495089977"
Message-Id: <20100224031055.164120692@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 24 Feb 2010 11:10:12 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
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
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/15] readahead: dont do start-of-file readahead after lseek()
References: <20100224031001.026464755@intel.com>
Content-Disposition: inline; filename=readahead-lseek.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some applications (eg. blkid, id3tool etc.) seek around the file
to get information. For example, blkid does
	     seek to	0
	     read	1024
	     seek to	1536
	     read	16384

The start-of-file readahead heuristic is wrong for them, whose 
access pattern can be identified by lseek() calls.

So test-and-set a READAHEAD_LSEEK flag on lseek() and don't
do start-of-file readahead on seeing it. Proposed by Linus.

Acked-by: Linus Torvalds <torvalds@linux-foundation.org> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/read_write.c    |    3 +++
 include/linux/fs.h |    1 +
 mm/readahead.c     |    5 +++++
 3 files changed, 9 insertions(+)

--- linux.orig/mm/readahead.c	2010-02-24 10:44:47.000000000 +0800
+++ linux/mm/readahead.c	2010-02-24 10:44:48.000000000 +0800
@@ -672,6 +672,11 @@ ondemand_readahead(struct address_space 
 	if (!offset) {
 		ra_set_pattern(ra, RA_PATTERN_INITIAL);
 		ra->start = offset;
+		if ((ra->ra_flags & READAHEAD_LSEEK) && req_size <= max) {
+			ra->size = req_size;
+			ra->async_size = 0;
+			goto readit;
+		}
 		ra->size = get_init_ra_size(req_size, max);
 		ra->async_size = ra->size > req_size ?
 				 ra->size - req_size : ra->size;
--- linux.orig/fs/read_write.c	2010-02-24 10:44:30.000000000 +0800
+++ linux/fs/read_write.c	2010-02-24 10:44:48.000000000 +0800
@@ -71,6 +71,9 @@ generic_file_llseek_unlocked(struct file
 		file->f_version = 0;
 	}
 
+	if (!(file->f_ra.ra_flags & READAHEAD_LSEEK))
+		file->f_ra.ra_flags |= READAHEAD_LSEEK;
+
 	return offset;
 }
 EXPORT_SYMBOL(generic_file_llseek_unlocked);
--- linux.orig/include/linux/fs.h	2010-02-24 10:44:45.000000000 +0800
+++ linux/include/linux/fs.h	2010-02-24 10:44:48.000000000 +0800
@@ -899,6 +899,7 @@ struct file_ra_state {
 #define	READAHEAD_MMAP_MISS	0x00000fff /* cache misses for mmap access */
 #define READAHEAD_THRASHED	0x10000000
 #define	READAHEAD_MMAP		0x20000000
+#define	READAHEAD_LSEEK		0x40000000 /* be conservative after lseek() */
 
 /*
  * Which policy makes decision to do the current read-ahead IO?


