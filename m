Return-Path: <linux-kernel-owner+w=401wt.eu-S1756906AbZJHBpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbZJHBpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 21:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbZJHBpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 21:45:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:30754 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828AbZJHBpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 21:45:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,522,1249282800"; 
   d="scan'208";a="196350120"
Date: Thu, 8 Oct 2009 09:44:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Staubach <staubach@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 44/45] NFS: remove NFS_INO_FLUSHING lock
Message-ID: <20091008014447.GA14224@localhost>
References: <20091007073818.318088777@intel.com> <20091007074906.867871013@intel.com> <4ACC9373.6080703@redhat.com> <20091007133235.GC20855@localhost> <4ACC9EAE.3000104@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <4ACC9EAE.3000104@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 07, 2009 at 09:59:10PM +0800, Peter Staubach wrote:
> Wu Fengguang wrote:
> > On Wed, Oct 07, 2009 at 09:11:15PM +0800, Peter Staubach wrote:
> >> Wu Fengguang wrote:
> >>> It was introduced in 72cb77f4a5ac, and the several issues have been
> >>> addressed in generic writeback:
> >>> - out of order writeback (or interleaved concurrent writeback)
> >>>   addressed by the per-bdi writeback and wait queue in balance_dirty_pages()
> >>> - sync livelocked by a fast dirtier
> >>>   addressed by throttling all to-be-synced dirty inodes
> >>>
> >> I don't think that we can just remove this support.  It is
> >> designed to reduce the effects from doing a stat(2) on a
> >> file which is being actively written to.
> > 
> > Ah OK.
> > 
> >> If we do remove it, then we will need to replace this patch
> >> with another.  Trond and I hadn't quite finished discussing
> >> some aspects of that other patch...  :-)
> > 
> > I noticed the i_mutex lock in nfs_getattr(). Do you mean that?
> > 
> 
> Well, that's part of that support as well.  That keeps a writing
> application from dirtying more pages while the application doing
> the stat is attempting to clean them.

Instead of blocking totally, we could throttle application writes.
The following two patches are the more gentle way of doing this,
however it does not guarantee to kill the livelock, since a busy
bdi-flush thread could writeback many pages to unfreeze the
application prematurely. Anyway I attach them as a demo of idea,
whether it be good or bad.

> Another approach that I suggested was to keep track of the
> number of pages which are dirty on a per-inode basis.  When

Yes a per-inode dirty count should be trivial and may be good for others.

> enough pages are dirty to fill an over the wire transfer,
> then schedule an asynchronous write to transmit that data to

This should also be trivial to support if the location ordered
writeback infrastructure is ready.

> the server.  This ties in with support to ensure that the
> server/network is not completely overwhelmed by the client
> by flow controlling the writing application to better match
> the bandwidth and latencies of the network and server.

I like that feature :)

> With this support, the NFS client tends not to fill memory
> with dirty pages and thus, does not depend upon the other
> parts of the system to flush these pages.
> 
> All of these recent pages make this current flushing happen
> in a much more orderly fashion, which is great.  However,

Thanks.

> this can still lead to the client attempting to flush
> potentially gigabytes all at once, which is more than most
> networks and servers can handle reasonably.

OK, I now see the need to keep mapping->nr_dirty under control: it
could make many NFS operations response in a more bounded fashion.
The good thing is, it can share infrastructure with the location
based writeback (http://lkml.org/lkml/2007/8/27/45 :)

Thanks,
Fengguang

--HcAYCG3uE/tztfnV
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="writeback-throttle-sync-mapping.patch"

writeback: sync livelock - throttle mapping dirties if it's being synced

The AS_SYNC_WAITER flag will be set to indicate an active sync waiter.

It's not perfect with respect to file ranges and concurrent syncs. And
do not guarantee that the application writes on this mapping can be
throttled enough to avoid livelock, especially when there are many
background writebacks.

Just my 2 cents.

CC: Jan Kara <jack@suse.cz>
CC: Peter Staubach <staubach@redhat.com>
CC: Myklebust Trond <Trond.Myklebust@netapp.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/pagemap.h |    3 +++
 mm/filemap.c            |    2 ++
 mm/page-writeback.c     |    5 +++++
 3 files changed, 10 insertions(+)

--- linux.orig/mm/page-writeback.c	2009-10-08 08:11:19.000000000 +0800
+++ linux/mm/page-writeback.c	2009-10-08 08:48:13.000000000 +0800
@@ -480,7 +480,12 @@ static void balance_dirty_pages(struct a
 	/*
 	 * If sync() is in progress, curb the to-be-synced inodes regardless
 	 * of dirty limits, so that a fast dirtier won't livelock the sync.
+	 * In perticular, NFS syncs the mapping before many file operations.
 	 */
+	if (unlikely(test_bit(AS_SYNC_WAITER, &mapping->flags))) {
+		write_chunk *= 8;
+		goto throttle;
+	}
 	if (unlikely(bdi->sync_time &&
 		     S_ISREG(mapping->host->i_mode) &&
 		     time_after_eq(bdi->sync_time,
--- linux.orig/include/linux/pagemap.h	2009-10-08 08:11:19.000000000 +0800
+++ linux/include/linux/pagemap.h	2009-10-08 08:11:20.000000000 +0800
@@ -23,6 +23,9 @@ enum mapping_flags {
 	AS_ENOSPC	= __GFP_BITS_SHIFT + 1,	/* ENOSPC on async write */
 	AS_MM_ALL_LOCKS	= __GFP_BITS_SHIFT + 2,	/* under mm_take_all_locks() */
 	AS_UNEVICTABLE	= __GFP_BITS_SHIFT + 3,	/* e.g., ramdisk, SHM_LOCK */
+	AS_SYNC_WAITER	= __GFP_BITS_SHIFT + 4,	/* sync&wait under way, page
+						 * dirtying will be throttled
+						 */
 };
 
 static inline void mapping_set_error(struct address_space *mapping, int error)
--- linux.orig/mm/filemap.c	2009-10-08 08:11:19.000000000 +0800
+++ linux/mm/filemap.c	2009-10-08 08:11:20.000000000 +0800
@@ -356,6 +356,7 @@ int filemap_write_and_wait(struct addres
 	int err = 0;
 
 	if (mapping->nrpages) {
+		set_bit(AS_SYNC_WAITER, &mapping->flags);
 		err = filemap_fdatawrite(mapping);
 		/*
 		 * Even if the above returned error, the pages may be
@@ -368,6 +369,7 @@ int filemap_write_and_wait(struct addres
 			if (!err)
 				err = err2;
 		}
+		clear_bit(AS_SYNC_WAITER, &mapping->flags);
 	}
 	return err;
 }

--HcAYCG3uE/tztfnV
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="nfs-no-i_mutex-for-livelock-prevention.patch"

nfs: don't take i_mutex on nfs_wb_nocommit()

Set the AS_SYNC_WAITER flag and let VFS throttle application writes.

CC: Peter Staubach <staubach@redhat.com>
CC: Myklebust Trond <Trond.Myklebust@netapp.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/nfs/inode.c |    9 +--------
 fs/nfs/write.c |    6 +++++-
 2 files changed, 6 insertions(+), 9 deletions(-)

--- linux.orig/fs/nfs/inode.c	2009-10-07 10:03:26.000000000 +0800
+++ linux/fs/nfs/inode.c	2009-10-08 08:18:37.000000000 +0800
@@ -513,16 +513,9 @@ int nfs_getattr(struct vfsmount *mnt, st
 
 	/*
 	 * Flush out writes to the server in order to update c/mtime.
-	 *
-	 * Hold the i_mutex to suspend application writes temporarily;
-	 * this prevents long-running writing applications from blocking
-	 * nfs_wb_nocommit.
 	 */
-	if (S_ISREG(inode->i_mode)) {
-		mutex_lock(&inode->i_mutex);
+	if (S_ISREG(inode->i_mode))
 		nfs_wb_nocommit(inode);
-		mutex_unlock(&inode->i_mutex);
-	}
 
 	/*
 	 * We may force a getattr if the user cares about atime.
--- linux.orig/fs/nfs/write.c	2009-10-08 08:21:02.000000000 +0800
+++ linux/fs/nfs/write.c	2009-10-08 08:31:01.000000000 +0800
@@ -1539,8 +1539,12 @@ static int nfs_write_mapping(struct addr
 		.range_start = 0,
 		.range_end = LLONG_MAX,
 	};
+	int ret;
 
-	return __nfs_write_mapping(mapping, &wbc, how);
+	set_bit(AS_SYNC_WAITER, &mapping->flags);
+	ret = __nfs_write_mapping(mapping, &wbc, how);
+	clear_bit(AS_SYNC_WAITER, &mapping->flags);
+	return ret;
 }
 
 /*

--HcAYCG3uE/tztfnV--
