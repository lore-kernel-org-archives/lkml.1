Return-Path: <linux-kernel-owner+w=401wt.eu-S1751146Ab0ADFFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146Ab0ADFFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 00:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750742Ab0ADFFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 00:05:54 -0500
Received: from mga03.intel.com ([143.182.124.21]:50159 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab0ADFFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 00:05:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="228821708"
Date: Mon, 4 Jan 2010 12:50:20 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Quentin Barnes <qbarnes+nfs@yahoo-inc.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Steven Whitehouse <swhiteho@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, David Howells <dhowells@redhat.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>,
       Christoph Hellwig <hch@infradead.org>
Subject: [RFC][PATCH v3] readahead: introduce O_RANDOM for POSIX_FADV_RANDOM
Message-ID: <20100104045020.GA21021@localhost>
References: <20091225000717.GA26949@yahoo-inc.com> <87aax18xms.fsf@basil.nowhere.org> <20091230051540.GA16308@localhost> <20091230052402.GB26364@localhost> <873a2s8hmp.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <873a2s8hmp.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes inefficient page-by-page reads on POSIX_FADV_RANDOM.

POSIX_FADV_RANDOM used to set ra_pages=0, which leads to poor
performance: a 16K read will be carried out in 4 _sync_ 1-page reads.

In other places, ra_pages==0 means
- it's ramfs/tmpfs/hugetlbfs/sysfs/configfs
- some IO error happened
where multi-page read IO won't help or should be avoided.

POSIX_FADV_RANDOM actually want a different semantics: to disable the
*heuristic* readahead algorithm, and to use a dumb one which faithfully
submit read IO for whatever application requests.

So introduce a flag O_RANDOM for POSIX_FADV_RANDOM.
It will be visible to fcntl(F_GETFL).

Note that the random hint is not likely to help random reads performance
noticeably. And it may be too permissive on huge request size (its IO
size is not limited by read_ahead_kb).

In Quentin's report (http://lkml.org/lkml/2009/12/24/145), the overall
(NFS read) performance of the application increased by 313%!

v3: use O_RANDOM to indicate both read/write access pattern as in
    posix_fadvise(), although it only takes effect for read() now
    (proposed by Quentin)
v2: use O_RANDOM_READ to avoid race conditions (pointed out by Andi)

CC: Nick Piggin <npiggin@suse.de>
CC: Andi Kleen <andi@firstfloor.org>
CC: Steven Whitehouse <swhiteho@redhat.com>
CC: David Howells <dhowells@redhat.com>
CC: Al Viro <viro@zeniv.linux.org.uk>
CC: Jonathan Corbet <corbet@lwn.net>
CC: Christoph Hellwig <hch@infradead.org>
Tested-by: Quentin Barnes <qbarnes+nfs@yahoo-inc.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/asm-generic/fcntl.h |    4 ++++
 mm/fadvise.c                |   10 +++++++++-
 mm/readahead.c              |    6 ++++++
 3 files changed, 19 insertions(+), 1 deletion(-)

--- linux.orig/include/asm-generic/fcntl.h	2010-01-04 12:39:29.000000000 +0800
+++ linux/include/asm-generic/fcntl.h	2010-01-04 12:40:11.000000000 +0800
@@ -80,6 +80,10 @@
 #define O_NDELAY	O_NONBLOCK
 #endif
 
+#ifndef O_RANDOM
+#define O_RANDOM	010000000	/* random access pattern hint */
+#endif
+
 #define F_DUPFD		0	/* dup */
 #define F_GETFD		1	/* get close_on_exec */
 #define F_SETFD		2	/* set/clear close_on_exec */
--- linux.orig/mm/fadvise.c	2010-01-04 12:39:29.000000000 +0800
+++ linux/mm/fadvise.c	2010-01-04 12:39:30.000000000 +0800
@@ -77,12 +77,20 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, lof
 	switch (advice) {
 	case POSIX_FADV_NORMAL:
 		file->f_ra.ra_pages = bdi->ra_pages;
+		spin_lock(&file->f_lock);
+		file->f_flags &= ~O_RANDOM;
+		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_RANDOM:
-		file->f_ra.ra_pages = 0;
+		spin_lock(&file->f_lock);
+		file->f_flags |= O_RANDOM;
+		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_SEQUENTIAL:
 		file->f_ra.ra_pages = bdi->ra_pages * 2;
+		spin_lock(&file->f_lock);
+		file->f_flags &= ~O_RANDOM;
+		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_WILLNEED:
 		if (!mapping->a_ops->readpage) {
--- linux.orig/mm/readahead.c	2010-01-04 12:39:29.000000000 +0800
+++ linux/mm/readahead.c	2010-01-04 12:39:30.000000000 +0800
@@ -501,6 +501,12 @@ void page_cache_sync_readahead(struct ad
 	if (!ra->ra_pages)
 		return;
 
+	/* be dumb */
+	if (filp->f_flags & O_RANDOM) {
+		force_page_cache_readahead(mapping, filp, offset, req_size);
+		return;
+	}
+
 	/* do read-ahead */
 	ondemand_readahead(mapping, ra, filp, false, offset, req_size);
 }
