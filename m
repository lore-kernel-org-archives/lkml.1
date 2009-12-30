Return-Path: <linux-kernel-owner+w=401wt.eu-S1752070AbZL3FYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbZL3FYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 00:24:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbZL3FYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 00:24:08 -0500
Received: from mga14.intel.com ([143.182.124.37]:39427 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbZL3FYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 00:24:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="227703203"
Date: Wed, 30 Dec 2009 13:24:02 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Quentin Barnes <qbarnes+nfs@yahoo-inc.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [RFC][PATCH 2/2] readahead: avoid page-by-page reads on
	POSIX_FADV_RANDOM
Message-ID: <20091230052402.GB26364@localhost>
References: <20091225000717.GA26949@yahoo-inc.com> <87aax18xms.fsf@basil.nowhere.org> <20091230051540.GA16308@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091230051540.GA16308@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

POSIX_FADV_RANDOM sets ra_pages=0, which leads to poor performance:
a 16K read will be carried out in 4 _sync_ 1-page reads.

In other places, ra_pages==0 means
- it's ramfs/tmpfs/hugetlbfs/sysfs/configfs
- some IO error happened
where multi-page read IO won't help or should be avoided.

POSIX_FADV_RANDOM actually want a different semantics: to disable the
*heuristic* readahead algorithm, and to use a dumb one which faithfully
submit read IO for whatever application requests.

So introduce a readahead flag RA_FLAG_RANDOM for POSIX_FADV_RANDOM.

Note that the random hint is not likely to help random reads performance
noticeably. And it may be too permissive on huge request size (its IO
size is not limited by read_ahead_kb).

An implementation caveat: the set of RA_FLAG_RANDOM can be lost if the
same file descriptor is being concurrent read in another thread. However
it's rare event and the possible performance hit is expected to be low.

In Quentin's report (http://lkml.org/lkml/2009/12/24/145), the overall
(NFS read) performance of the application increased by 313%!

CC: Nick Piggin <npiggin@suse.de>
CC: Andi Kleen <andi@firstfloor.org>
CC: Steven Whitehouse <swhiteho@redhat.com>
Reported-by: Quentin Barnes <qbarnes+nfs@yahoo-inc.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/fs.h |    2 ++
 mm/fadvise.c       |    4 +++-
 mm/readahead.c     |    6 ++++++
 3 files changed, 11 insertions(+), 1 deletion(-)

--- linux.orig/include/linux/fs.h	2009-12-30 13:15:53.000000000 +0800
+++ linux/include/linux/fs.h	2009-12-30 13:17:59.000000000 +0800
@@ -896,6 +896,8 @@ struct file_ra_state {
 /* low 16 bits: cache miss stat for mmap accesses */
 #define	RA_FLAG_MMAP_MISS		0x0000ffff
 
+#define	RA_FLAG_RANDOM			0x00010000	/* POSIX_FADV_RANDOM */
+
 /*
  * Don't do flags++ directly to avoid possible overflow:
  * the ra fields can be accessed concurrently in a racy way.
--- linux.orig/mm/fadvise.c	2009-12-30 13:02:03.000000000 +0800
+++ linux/mm/fadvise.c	2009-12-30 13:23:05.000000000 +0800
@@ -77,12 +77,14 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, lof
 	switch (advice) {
 	case POSIX_FADV_NORMAL:
 		file->f_ra.ra_pages = bdi->ra_pages;
+		file->f_ra.flags &= ~RA_FLAG_RANDOM;
 		break;
 	case POSIX_FADV_RANDOM:
-		file->f_ra.ra_pages = 0;
+		file->f_ra.flags |= RA_FLAG_RANDOM;
 		break;
 	case POSIX_FADV_SEQUENTIAL:
 		file->f_ra.ra_pages = bdi->ra_pages * 2;
+		file->f_ra.flags &= ~RA_FLAG_RANDOM;
 		break;
 	case POSIX_FADV_WILLNEED:
 		if (!mapping->a_ops->readpage) {
--- linux.orig/mm/readahead.c	2009-12-30 13:02:03.000000000 +0800
+++ linux/mm/readahead.c	2009-12-30 13:17:59.000000000 +0800
@@ -501,6 +501,12 @@ void page_cache_sync_readahead(struct ad
 	if (!ra->ra_pages)
 		return;
 
+	/* be dumb */
+	if (ra->flags & RA_FLAG_RANDOM) {
+		force_page_cache_readahead(mapping, filp, offset, req_size);
+		return;
+	}
+
 	/* do read-ahead */
 	ondemand_readahead(mapping, ra, filp, false, offset, req_size);
 }
