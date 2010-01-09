Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636Ab0AIOB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab0AIOB0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 09:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128Ab0AIOBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 09:01:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:56620 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab0AIOBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 09:01:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,246,1262592000"; 
   d="scan'208";a="529872755"
Date: Sat, 9 Jan 2010 22:01:08 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Quentin Barnes <qbarnes+nfs@yahoo-inc.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Steven Whitehouse <swhiteho@redhat.com>,
       David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: [RFC][PATCH v2] readahead: introduce O_RANDOM_READ for
	POSIX_FADV_RANDOM
Message-ID: <20100109140108.GA24708@localhost>
References: <20091225000717.GA26949@yahoo-inc.com> <87aax18xms.fsf@basil.nowhere.org> <20091230051540.GA16308@localhost> <20091230052402.GB26364@localhost> <873a2s8hmp.fsf@basil.nowhere.org> <20091231043116.GA19397@localhost> <20100108130828.GA30480@infradead.org> <20100109135904.GA23944@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100109135904.GA23944@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 09, 2010 at 09:59:04PM +0800, Wu Fengguang wrote:
> On Fri, Jan 08, 2010 at 09:08:28PM +0800, Christoph Hellwig wrote:
> > Just thinking about this again, why don't you put the flag into
> > file->f_mode and the FMODE_* namespace given that we don't want it to be
> > settable from open?
> 
> Good idea. To do that without race I would like to add ->f_lock to 
> f_mode modifications at non-open time, like this. What do you think?
> 
> ---
> vfs: take f_lock on modifying f_mode after open time
> 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---

And the FMODE_RANDOM patch.

Thanks,
Fengguang
---

readahead: introduce FMODE_RANDOM for POSIX_FADV_RANDOM

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
