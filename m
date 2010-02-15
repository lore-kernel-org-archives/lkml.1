Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab0BOB1o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 20:27:44 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52526 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262Ab0BOB1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 20:27:43 -0500
Date: Mon, 15 Feb 2010 12:27:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: linux-next: manual merge of the xfs tree with the vfs tree
Message-Id: <20100215122740.87c6cb5f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the xfs tree got a conflict in
fs/xfs/linux-2.6/xfs_super.c between commits
4a295406e025bb7c8241ea956ec1b84830499e96 ("make sure data is on disk
before calling ->write_inode") and
716c28c0bc8bcbdd26e819f38dfc8fdfaafc0289 ("pass writeback_control to
->write_inode") from the vfs tree and commit
07fec73625dc0db6f9aed68019918208a2ca53f5 ("xfs: log changed inodes
instead of writing them synchronously") from the xfs tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
What other file systems are doing for these conflicts is to merge in the
"write_inode" branch of Al Viro's vfs tree
(git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git) which Al
has said will not be rebased.  (Both those commits are in that branch.)
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/xfs/linux-2.6/xfs_super.c
index 1e90797,25ea240..0000000
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@@ -1042,33 -1074,59 +1074,55 @@@ xfs_fs_write_inode
  	if (XFS_FORCED_SHUTDOWN(mp))
  		return XFS_ERROR(EIO);
  
- 	/*
- 	 * Bypass inodes which have already been cleaned by
- 	 * the inode flush clustering code inside xfs_iflush
- 	 */
- 	if (xfs_inode_clean(ip))
- 		goto out;
- 
- 	/*
- 	 * We make this non-blocking if the inode is contended, return
- 	 * EAGAIN to indicate to the caller that they did not succeed.
- 	 * This prevents the flush path from blocking on inodes inside
- 	 * another operation right now, they get caught later by xfs_sync.
- 	 */
 -	if (sync) {
 -		error = xfs_wait_on_pages(ip, 0, -1);
 -		if (error)
 -			goto out;
 -
 +	if (wbc->sync_mode == WB_SYNC_ALL) {
+ 		/*
+ 		 * Make sure the inode has hit stable storage.  By using the
+ 		 * log and the fsync transactions we reduce the IOs we have
+ 		 * to do here from two (log and inode) to just the log.
+ 		 *
+ 		 * Note: We still need to do a delwri write of the inode after
+ 		 * this to flush it to the backing buffer so that bulkstat
+ 		 * works properly if this is the first time the inode has been
+ 		 * written.  Because we hold the ilock atomically over the
+ 		 * transaction commit and the inode flush we are guaranteed
+ 		 * that the inode is not pinned when it returns. If the flush
+ 		 * lock is already held, then the inode has already been
+ 		 * flushed once and we don't need to flush it again.  Hence
+ 		 * the code will only flush the inode if it isn't already
+ 		 * being flushed.
+ 		 */
  		xfs_ilock(ip, XFS_ILOCK_SHARED);
- 		xfs_iflock(ip);
- 
- 		error = xfs_iflush(ip, XFS_IFLUSH_SYNC);
+ 		if (ip->i_update_core) {
+ 			error = xfs_log_inode(ip);
+ 			if (error)
+ 				goto out_unlock;
+ 		}
  	} else {
- 		error = EAGAIN;
+ 		/*
+ 		 * We make this non-blocking if the inode is contended, return
+ 		 * EAGAIN to indicate to the caller that they did not succeed.
+ 		 * This prevents the flush path from blocking on inodes inside
+ 		 * another operation right now, they get caught later by xfs_sync.
+ 		 */
  		if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED))
  			goto out;
- 		if (xfs_ipincount(ip) || !xfs_iflock_nowait(ip))
- 			goto out_unlock;
+ 	}
  
- 		error = xfs_iflush(ip, XFS_IFLUSH_ASYNC_NOBLOCK);
+ 	if (xfs_ipincount(ip) || !xfs_iflock_nowait(ip))
+ 		goto out_unlock;
+ 
+ 	/*
+ 	 * Now we have the flush lock and the inode is not pinned, we can check
+ 	 * if the inode is really clean as we know that there are no pending
+ 	 * transaction completions, it is not waiting on the delayed write
+ 	 * queue and there is no IO in progress.
+ 	 */
+ 	if (xfs_inode_clean(ip)) {
+ 		xfs_ifunlock(ip);
+ 		error = 0;
+ 		goto out_unlock;
  	}
+ 	error = xfs_iflush(ip, 0);
  
   out_unlock:
  	xfs_iunlock(ip, XFS_ILOCK_SHARED);
