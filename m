Return-Path: <linux-kernel-owner+w=401wt.eu-S1753094AbZLaEbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbZLaEbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 23:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbZLaEbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 23:31:21 -0500
Received: from mga03.intel.com ([143.182.124.21]:33108 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739AbZLaEbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 23:31:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="228014349"
Date: Thu, 31 Dec 2009 12:31:16 +0800
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
Subject: [RFC][PATCH v2] readahead: introduce O_RANDOM_READ for
	POSIX_FADV_RANDOM
Message-ID: <20091231043116.GA19397@localhost>
References: <20091225000717.GA26949@yahoo-inc.com> <87aax18xms.fsf@basil.nowhere.org> <20091230051540.GA16308@localhost> <20091230052402.GB26364@localhost> <873a2s8hmp.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <873a2s8hmp.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[an updated patch for the previous two patches in this thread]

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

So introduce a flag O_RANDOM_READ for POSIX_FADV_RANDOM.
It will be visible to fcntl(F_GETFL).

Note that the random hint is not likely to help random reads performance
noticeably. And it may be too permissive on huge request size (its IO
size is not limited by read_ahead_kb).

In Quentin's report (http://lkml.org/lkml/2009/12/24/145), the overall
(NFS read) performance of the application increased by 313%!

CC: Nick Piggin <npiggin@suse.de>
CC: Andi Kleen <andi@firstfloor.org>
CC: Steven Whitehouse <swhiteho@redhat.com>
CC: David Howells <dhowells@redhat.com>
CC: Al Viro <viro@zeniv.linux.org.uk>
CC: Jonathan Corbet <corbet@lwn.net>
CC: Christoph Hellwig <hch@infradead.org>
Reported-by: Quentin Barnes <qbarnes+nfs@yahoo-inc.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/asm-generic/fcntl.h |    4 ++++
 mm/fadvise.c                |   10 +++++++++-
 mm/readahead.c              |    6 ++++++
 3 files changed, 19 insertions(+), 1 deletion(-)

--- linux.orig/include/asm-generic/fcntl.h	2009-12-31 11:23:33.000000000 +0800
+++ linux/include/asm-generic/fcntl.h	2009-12-31 11:24:45.000000000 +0800
@@ -80,6 +80,10 @@
 #define O_NDELAY	O_NONBLOCK
 #endif
 
+#ifndef O_RANDOM_READ
+#define O_RANDOM_READ	010000000
+#endif
+
 #define F_DUPFD		0	/* dup */
 #define F_GETFD		1	/* get close_on_exec */
 #define F_SETFD		2	/* set/clear close_on_exec */
--- linux.orig/mm/fadvise.c	2009-12-31 11:25:05.000000000 +0800
+++ linux/mm/fadvise.c	2009-12-31 12:16:20.000000000 +0800
@@ -77,12 +77,20 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, lof
 	switch (advice) {
 	case POSIX_FADV_NORMAL:
 		file->f_ra.ra_pages = bdi->ra_pages;
+		spin_lock(&file->f_lock);
+		file->f_flags &= ~O_RANDOM_READ;
+		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_RANDOM:
-		file->f_ra.ra_pages = 0;
+		spin_lock(&file->f_lock);
+		file->f_flags |= O_RANDOM_READ;
+		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_SEQUENTIAL:
 		file->f_ra.ra_pages = bdi->ra_pages * 2;
+		spin_lock(&file->f_lock);
+		file->f_flags &= ~O_RANDOM_READ;
+		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_WILLNEED:
 		if (!mapping->a_ops->readpage) {
--- linux.orig/mm/readahead.c	2009-12-31 11:27:15.000000000 +0800
+++ linux/mm/readahead.c	2009-12-31 11:28:21.000000000 +0800
@@ -501,6 +501,12 @@ void page_cache_sync_readahead(struct ad
 	if (!ra->ra_pages)
 		return;
 
+	/* be dumb */
+	if (filp->f_flags & O_RANDOM_READ) {
+		force_page_cache_readahead(mapping, filp, offset, req_size);
+		return;
+	}
+
 	/* do read-ahead */
 	ondemand_readahead(mapping, ra, filp, false, offset, req_size);
 }
