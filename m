Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460Ab0BBPed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 10:34:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:14323 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756412Ab0BBPeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 10:34:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,390,1262592000"; 
   d="scan'208";a="489018646"
Message-Id: <20100202153317.644170708@intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 02 Feb 2010 23:28:45 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Linux Memory Management List <linux-mm@kvack.org>
cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/11] readahead: dont do start-of-file readahead after lseek()
References: <20100202152835.683907822@intel.com>
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

CC: Linus Torvalds <torvalds@linux-foundation.org> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/read_write.c    |    3 +++
 include/linux/fs.h |    1 +
 mm/readahead.c     |    5 +++++
 3 files changed, 9 insertions(+)

--- linux.orig/mm/readahead.c	2010-02-02 21:52:19.000000000 +0800
+++ linux/mm/readahead.c	2010-02-02 21:52:32.000000000 +0800
@@ -625,6 +625,11 @@ ondemand_readahead(struct address_space 
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
--- linux.orig/fs/read_write.c	2010-02-02 21:50:51.000000000 +0800
+++ linux/fs/read_write.c	2010-02-02 21:53:04.000000000 +0800
@@ -71,6 +71,9 @@ generic_file_llseek_unlocked(struct file
 		file->f_version = 0;
 	}
 
+	if (!(file->f_ra.ra_flags & READAHEAD_LSEEK))
+		file->f_ra.ra_flags |= READAHEAD_LSEEK;
+
 	return offset;
 }
 EXPORT_SYMBOL(generic_file_llseek_unlocked);
--- linux.orig/include/linux/fs.h	2010-02-02 21:52:19.000000000 +0800
+++ linux/include/linux/fs.h	2010-02-02 21:52:19.000000000 +0800
@@ -899,6 +899,7 @@ struct file_ra_state {
 #define	READAHEAD_MMAP_MISS	0x0000ffff /* cache misses for mmap access */
 #define READAHEAD_THRASHED	0x10000000
 #define	READAHEAD_MMAP		0x20000000
+#define	READAHEAD_LSEEK		0x40000000 /* be conservative after lseek() */
 
 /*
  * Which policy makes decision to do the current read-ahead IO?


