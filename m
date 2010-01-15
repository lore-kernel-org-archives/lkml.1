Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab0AOBuc (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 20:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256Ab0AOBtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 20:49:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:36228 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910Ab0AOBtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 20:49:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,279,1262592000"; 
   d="scan'208";a="484142132"
Message-Id: <20100115014422.821851008@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 15 Jan 2010 09:39:59 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@suse.de>,
        Andi Kleen <andi@firstfloor.org>,
        Steven Whitehouse <swhiteho@redhat.com>,
        David Howells <dhowells@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
CC: Eric Paris <eparis@redhat.com>
cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 5/6] readahead: introduce FMODE_RANDOM for POSIX_FADV_RANDOM
References: <20100115013954.311049665@intel.com>
Content-Disposition: inline; filename=fadvise-random.patch
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

So introduce a flag FMODE_RANDOM for POSIX_FADV_RANDOM.

Note that the random hint is not likely to help random reads performance
noticeably. And it may be too permissive on huge request size (its IO
size is not limited by read_ahead_kb).

In Quentin's report (http://lkml.org/lkml/2009/12/24/145), the overall
(NFS read) performance of the application increased by 313%!

v6: use FMODE_RANDOM (proposed by Christoph Hellwig)
v5: use bit 0200000000; explicitly nuke the O_RANDOM bit in __dentry_open()
    (Stephen Rothwell)
v4: resolve bit conflicts with sparc and parisc;
    use bit 040000000(=FMODE_NONOTIFY), which will be masked out by
    __dentry_open(), so that open(O_RANDOM) is disabled
    (Stephen Rothwell and Christoph Hellwig)
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
 include/linux/fs.h |    3 +++
 mm/fadvise.c       |   10 +++++++++-
 mm/readahead.c     |    6 ++++++
 3 files changed, 18 insertions(+), 1 deletion(-)

--- linux.orig/mm/fadvise.c	2010-01-09 11:00:11.000000000 +0800
+++ linux/mm/fadvise.c	2010-01-09 12:25:01.000000000 +0800
@@ -77,12 +77,20 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, lof
 	switch (advice) {
 	case POSIX_FADV_NORMAL:
 		file->f_ra.ra_pages = bdi->ra_pages;
+		spin_lock(&file->f_lock);
+		file->f_flags &= ~FMODE_RANDOM;
+		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_RANDOM:
-		file->f_ra.ra_pages = 0;
+		spin_lock(&file->f_lock);
+		file->f_flags |= FMODE_RANDOM;
+		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_SEQUENTIAL:
 		file->f_ra.ra_pages = bdi->ra_pages * 2;
+		spin_lock(&file->f_lock);
+		file->f_flags &= ~FMODE_RANDOM;
+		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_WILLNEED:
 		if (!mapping->a_ops->readpage) {
--- linux.orig/mm/readahead.c	2010-01-09 11:00:11.000000000 +0800
+++ linux/mm/readahead.c	2010-01-09 12:25:01.000000000 +0800
@@ -501,6 +501,12 @@ void page_cache_sync_readahead(struct ad
 	if (!ra->ra_pages)
 		return;
 
+	/* be dumb */
+	if (filp->f_mode & FMODE_RANDOM) {
+		force_page_cache_readahead(mapping, filp, offset, req_size);
+		return;
+	}
+
 	/* do read-ahead */
 	ondemand_readahead(mapping, ra, filp, false, offset, req_size);
 }
--- linux.orig/include/linux/fs.h	2010-01-09 11:00:29.000000000 +0800
+++ linux/include/linux/fs.h	2010-01-09 12:26:33.000000000 +0800
@@ -90,6 +90,9 @@ struct inodes_stat_t {
 /* File was opened by fanotify and shouldn't generate fanotify events */
 #define FMODE_NONOTIFY		((__force fmode_t)0x1000000)
 
+/* Expect random access pattern */
+#define FMODE_RANDOM		((__force fmode_t)0x1000)
+
 /*
  * The below are the various read and write types that we support. Some of
  * them include behavioral modifiers that send information down to the


