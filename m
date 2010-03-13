Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936251Ab0CMBKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:10:20 -0500
Received: from kroah.org ([198.145.64.141]:46729 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935369Ab0CMAa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:30:58 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:07 2010
Message-Id: <20100313002707.603808455@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Wu Fengguang <fengguang.wu@intel.com>, Nick Piggin <npiggin@suse.de>,
       Andi Kleen <andi@firstfloor.org>,
       Steven Whitehouse <swhiteho@redhat.com>,
       David Howells <dhowells@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Chuck Lever <chuck.lever@oracle.com>, <qbarnes+nfs@yahoo-inc.com>
Subject: [027/145] readahead: introduce FMODE_RANDOM for POSIX_FADV_RANDOM
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Wu Fengguang <fengguang.wu@intel.com>

commit 0141450f66c3c12a3aaa869748caa64241885cdf upstream.

This fixes inefficient page-by-page reads on POSIX_FADV_RANDOM.

POSIX_FADV_RANDOM used to set ra_pages=0, which leads to poor performance:
a 16K read will be carried out in 4 _sync_ 1-page reads.

In other places, ra_pages==0 means
- it's ramfs/tmpfs/hugetlbfs/sysfs/configfs
- some IO error happened
where multi-page read IO won't help or should be avoided.

POSIX_FADV_RANDOM actually want a different semantics: to disable the
*heuristic* readahead algorithm, and to use a dumb one which faithfully
submit read IO for whatever application requests.

So introduce a flag FMODE_RANDOM for POSIX_FADV_RANDOM.

Note that the random hint is not likely to help random reads performance
noticeably.  And it may be too permissive on huge request size (its IO
size is not limited by read_ahead_kb).

In Quentin's report (http://lkml.org/lkml/2009/12/24/145), the overall
(NFS read) performance of the application increased by 313%!

Tested-by: Quentin Barnes <qbarnes+nfs@yahoo-inc.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: <qbarnes+nfs@yahoo-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/fs.h |    3 +++
 mm/fadvise.c       |   10 +++++++++-
 mm/readahead.c     |    6 ++++++
 3 files changed, 18 insertions(+), 1 deletion(-)

--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -87,6 +87,9 @@ struct inodes_stat_t {
  */
 #define FMODE_NOCMTIME		((__force fmode_t)2048)
 
+/* Expect random access pattern */
+#define FMODE_RANDOM		((__force fmode_t)4096)
+
 /*
  * The below are the various read and write types that we support. Some of
  * them include behavioral modifiers that send information down to the
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -77,12 +77,20 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, lof
 	switch (advice) {
 	case POSIX_FADV_NORMAL:
 		file->f_ra.ra_pages = bdi->ra_pages;
+		spin_lock(&file->f_lock);
+		file->f_mode &= ~FMODE_RANDOM;
+		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_RANDOM:
-		file->f_ra.ra_pages = 0;
+		spin_lock(&file->f_lock);
+		file->f_mode |= FMODE_RANDOM;
+		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_SEQUENTIAL:
 		file->f_ra.ra_pages = bdi->ra_pages * 2;
+		spin_lock(&file->f_lock);
+		file->f_mode &= ~FMODE_RANDOM;
+		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_WILLNEED:
 		if (!mapping->a_ops->readpage) {
--- a/mm/readahead.c
+++ b/mm/readahead.c
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


