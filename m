Return-Path: <linux-kernel-owner+w=401wt.eu-S932812AbZJGIAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812AbZJGIAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932666AbZJGIAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:00:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:9396 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932454AbZJGIAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:00:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195971142"
Message-Id: <20091007074906.867871013@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:39:02 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li Shaohua" <shaohua.li@intel.com>,
       "Myklebust Trond" <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       <linux-fsdevel@vger.kernel.org>, Peter Staubach <staubach@redhat.com>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 44/45] NFS: remove NFS_INO_FLUSHING lock
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=nfs-remove-flush-lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was introduced in 72cb77f4a5ac, and the several issues have been
addressed in generic writeback:
- out of order writeback (or interleaved concurrent writeback)
  addressed by the per-bdi writeback and wait queue in balance_dirty_pages()
- sync livelocked by a fast dirtier
  addressed by throttling all to-be-synced dirty inodes

CC: Peter Zijlstra <a.p.zijlstra@chello.nl> 
CC: Peter Staubach <staubach@redhat.com>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/nfs/file.c          |    9 ---------
 fs/nfs/write.c         |   11 -----------
 include/linux/nfs_fs.h |    1 -
 3 files changed, 21 deletions(-)

--- linux.orig/fs/nfs/file.c	2009-10-07 14:31:45.000000000 +0800
+++ linux/fs/nfs/file.c	2009-10-07 14:32:54.000000000 +0800
@@ -386,15 +386,6 @@ static int nfs_write_begin(struct file *
 		mapping->host->i_ino, len, (long long) pos);
 
 start:
-	/*
-	 * Prevent starvation issues if someone is doing a consistency
-	 * sync-to-disk
-	 */
-	ret = wait_on_bit(&NFS_I(mapping->host)->flags, NFS_INO_FLUSHING,
-			nfs_wait_bit_killable, TASK_KILLABLE);
-	if (ret)
-		return ret;
-
 	page = grab_cache_page_write_begin(mapping, index, flags);
 	if (!page)
 		return -ENOMEM;
--- linux.orig/fs/nfs/write.c	2009-10-07 14:31:45.000000000 +0800
+++ linux/fs/nfs/write.c	2009-10-07 14:32:54.000000000 +0800
@@ -387,26 +387,15 @@ static int nfs_writepages_callback(struc
 int nfs_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
 	struct inode *inode = mapping->host;
-	unsigned long *bitlock = &NFS_I(inode)->flags;
 	struct nfs_pageio_descriptor pgio;
 	int err;
 
-	/* Stop dirtying of new pages while we sync */
-	err = wait_on_bit_lock(bitlock, NFS_INO_FLUSHING,
-			nfs_wait_bit_killable, TASK_KILLABLE);
-	if (err)
-		goto out_err;
-
 	nfs_inc_stats(inode, NFSIOS_VFSWRITEPAGES);
 
 	nfs_pageio_init_write(&pgio, inode, wb_priority(wbc));
 	err = write_cache_pages(mapping, wbc, nfs_writepages_callback, &pgio);
 	nfs_pageio_complete(&pgio);
 
-	clear_bit_unlock(NFS_INO_FLUSHING, bitlock);
-	smp_mb__after_clear_bit();
-	wake_up_bit(bitlock, NFS_INO_FLUSHING);
-
 	if (err < 0)
 		goto out_err;
 	err = pgio.pg_error;
--- linux.orig/include/linux/nfs_fs.h	2009-10-07 14:31:45.000000000 +0800
+++ linux/include/linux/nfs_fs.h	2009-10-07 14:32:54.000000000 +0800
@@ -208,7 +208,6 @@ struct nfs_inode {
 #define NFS_INO_STALE		(1)		/* possible stale inode */
 #define NFS_INO_ACL_LRU_SET	(2)		/* Inode is on the LRU list */
 #define NFS_INO_MOUNTPOINT	(3)		/* inode is remote mountpoint */
-#define NFS_INO_FLUSHING	(4)		/* inode is flushing out data */
 #define NFS_INO_FSCACHE		(5)		/* inode can be cached by FS-Cache */
 #define NFS_INO_FSCACHE_LOCK	(6)		/* FS-Cache cookie management lock */
 


