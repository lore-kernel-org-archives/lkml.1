Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143Ab0AEDSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab0AEDSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 22:18:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961Ab0AEDSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 22:18:09 -0500
Received: from mga14.intel.com ([143.182.124.37]:47756 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855Ab0AEDSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 22:18:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="229209758"
Date: Tue, 5 Jan 2010 11:18:01 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Quentin Barnes <qbarnes+nfs@yahoo-inc.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Steven Whitehouse <swhiteho@redhat.com>,
       David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Jonathan Corbet <corbet@lwn.net>, Eric Paris <eparis@redhat.com>
Subject: [RFC][PATCH v5] readahead: introduce O_RANDOM for POSIX_FADV_RANDOM
Message-ID: <20100105031801.GA591@localhost>
References: <20091230051540.GA16308@localhost> <20091230052402.GB26364@localhost> <873a2s8hmp.fsf@basil.nowhere.org> <20100104045020.GA21021@localhost> <20100104161719.a0bb35ad.sfr@canb.auug.org.au> <20100104073328.GA3422@infradead.org> <20100104125620.GB12266@localhost> <20100105130322.006c03ee.sfr@canb.auug.org.au> <20100105022650.GB29428@localhost> <20100105132824.e6c0fb7f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105132824.e6c0fb7f.sfr@canb.auug.org.au>
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

So introduce a flag O_RANDOM for POSIX_FADV_RANDOM.  It will be
visible to fcntl(F_GETFL), but open(O_RANDOM) is disabled for now.

Note that the random hint is not likely to help random reads performance
noticeably. And it may be too permissive on huge request size (its IO
size is not limited by read_ahead_kb).

In Quentin's report (http://lkml.org/lkml/2009/12/24/145), the overall
(NFS read) performance of the application increased by 313%!

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
 fs/open.c                   |    2 +-
 include/asm-generic/fcntl.h |    7 +++++++
 mm/fadvise.c                |   10 +++++++++-
 mm/readahead.c              |    6 ++++++
 4 files changed, 23 insertions(+), 2 deletions(-)

--- linux.orig/include/asm-generic/fcntl.h	2010-01-04 12:39:29.000000000 +0800
+++ linux/include/asm-generic/fcntl.h	2010-01-05 11:13:17.000000000 +0800
@@ -80,6 +80,13 @@
 #define O_NDELAY	O_NONBLOCK
 #endif
 
+/*
+ * usage of open(O_RANDOM) is disabled: __dentry_open() will nuke this bit
+ */
+#ifndef O_RANDOM
+#define O_RANDOM	0200000000	/* random access pattern hint */
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
+++ linux/mm/readahead.c	2010-01-05 10:20:29.000000000 +0800
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
--- linux.orig/fs/open.c	2010-01-05 09:41:50.000000000 +0800
+++ linux/fs/open.c	2010-01-05 10:34:40.000000000 +0800
@@ -862,7 +862,7 @@ static struct file *__dentry_open(struct
 	}
 	ima_counts_get(f);
 
-	f->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);
+	f->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC | O_RANDOM);
 
 	file_ra_state_init(&f->f_ra, f->f_mapping->host->i_mapping);
 
