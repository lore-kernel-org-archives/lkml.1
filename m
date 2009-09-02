Return-Path: <linux-kernel-owner+w=401wt.eu-S1753617AbZIBWSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbZIBWSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 18:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbZIBWSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 18:18:38 -0400
Received: from verein.lst.de ([213.95.11.210]:44224 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543AbZIBWSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 18:18:37 -0400
Date: Thu, 3 Sep 2009 00:18:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       hch@lst.de
Subject: [PATCH] fsync: wait for data writeout completion before calling ->fsync
Message-ID: <20090902221838.GA5311@lst.de>
References: <1251899966-7316-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251899966-7316-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think we should add this one ontop:

-- 
Subject: [PATCH] fsync: wait for data writeout completion before calling ->fsync
From: Christoph Hellwig <hch@lst.de>

Currenly vfs_fsync(_range) first calls filemap_fdatawrite to write out
the data, the calls into ->fsync to write out the metadata and then finally
calls filemap_fdatawait to wait for the data I/O to complete.  What sounds
like a clever micro-optimization actually is nast trap for many filesystems.

For many modern filesystems i_size or other inode information is only
updated on I/O completion and we need to wait for I/O to finish before
we can write out the metadata.  For old fashionen filesystems that
instanciate blocks during the actual write and also update the metadata
at that point it opens up a large window were we could expose uninitialized
blocks after a crash.  While a few filesystems that need it already wait
for the I/O to finish inside their ->fsync methods it is rather suboptimal
as it is done under the i_mutex and also always for the whole file instead
of just a part as we could do for O_SYNC handling.

Here is a small audit of all fsync instances in the tree:

 - spufs_mfc_fsync:
 - ps3flash_fsync: 
 - vol_cdev_fsync:
 - printer_fsync:
 - fb_deferred_io_fsync:
 - bad_file_fsync:
 - simple_sync_file:

	don't care - filesystems/drivers do't use the page cache or are
	purely in-memory.

 - simple_fsync:
 - file_fsync:
 - affs_file_fsync:
 - fat_file_fsync:
 - jfs_fsync:
 - ubifs_fsync:
 - reiserfs_dir_fsync:
 - reiserfs_sync_file:

	never touch pagecache themselves.  We need to wait before if we do
	not want to expose stale data after an allocation.

 - afs_fsync:
 - fuse_fsync_common:

	do the waiting writeback itself in awkward ways, would benefit from
	proper semantics

 - block_fsync:

	Does a filemap_write_and_wait on the block device inode.  Because we
	now have f_mapping that is the same inode we call it on in vfs_fsync.
	So just removing it and letting the VFS do the work in one go would
	be an improvement.

 - btrfs_sync_file:
 - cifs_fsync:
 - xfs_file_fsync:

	need the wait first and currently do it themselves. would benefit from
	doing it outside i_mutex.

 - coda_fsync:
 - ecryptfs_fsync:
 - exofs_file_fsync:
 - shm_fsync:

	only passes the fsync through to the lower layer

 - ext3_sync_file:

	doesn't seem to care, comments are confusing.

 - ext4_sync_file:

	would need the wait to work correctly for delalloc mode with late
	i_size updates.  Otherwise the ext3 comment applies.


	currently implemens it's own writeback and wait in an odd way,
	could benefit from doing it properly.

 - gfs2_fsync:

	not needed for journaled data mode, but probably harmless there.
	Currently writes back data asynchronously itself.  Needs some
	major audit.

 - hostfs_fsync:

	just calls fsync/datasync on the host FD.  Without the wait before
	data might not even be inflight yet if we're unlucky.

 - hpfs_file_fsync:
 - ncp_fsync:

	no-ops.  Dangerous before and after.

 - jffs2_fsync:

	just calls jffs2_flush_wbuf_gc, not sure how this relates to data.

 - nfs_fsync_dir:

	just increments stats, claims all directory operations are synchronous

 - nfs_file_fsync:

	only writes out data???  Looks very odd.

 - nilfs_sync_file:

	looks like it expects all data done, but not sure from the code

 - ntfs_dir_fsync:
 - ntfs_file_fsync:

	appear to do their own data writeback.  Very convoluted code.

 - ocfs2_sync_file:

	does it's own data writeback, but no wait.  probably needs the wait.

 - smb_fsync:

	according to a comment expects all pages written already, probably needs
	the wait before.


This patch only changes vfs_fsync_range, removal of the wait in the methods
that have it is left to the filesystem maintainers.  Note that most
filesystems really do need an audit for their fsync methods given the
gems found in this very brief audit.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/sync.c
===================================================================
--- linux-2.6.orig/fs/sync.c	2009-09-02 15:03:41.073271287 -0300
+++ linux-2.6/fs/sync.c	2009-09-02 15:04:34.401269249 -0300
@@ -216,7 +216,7 @@ int vfs_fsync_range(struct file *file, s
 		goto out;
 	}
 
-	ret = filemap_fdatawrite_range(mapping, start, end);
+	ret = filemap_write_and_wait_range(mapping, start, end);
 
 	/*
 	 * We need to protect against concurrent writers, which could cause
@@ -228,9 +228,6 @@ int vfs_fsync_range(struct file *file, s
 		ret = err;
 	mutex_unlock(&mapping->host->i_mutex);
 
-	err = filemap_fdatawait_range(mapping, start, end);
-	if (!ret)
-		ret = err;
 out:
 	return ret;
 }
