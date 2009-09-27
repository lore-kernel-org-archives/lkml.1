Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbZI0CCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbZI0CCo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 22:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbZI0CCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 22:02:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:9094 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160AbZI0CCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 22:02:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,459,1249282800"; 
   d="scan'208";a="192082681"
Date: Sun, 27 Sep 2009 10:02:34 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jan Kara <jack@suse.cz>,
       Theodore Tso <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] writeback: don't delay inodes redirtied by a fast
	dirtier
Message-ID: <20090927020233.GA10318@localhost>
References: <20090923123337.990689487@intel.com> <20090923124028.060887241@intel.com> <20090926194747.GA1593@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090926194747.GA1593@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 03:47:47AM +0800, Christoph Hellwig wrote:
> On Wed, Sep 23, 2009 at 08:33:43PM +0800, Wu Fengguang wrote:
> > So let's distinguish between data redirty and metadata only redirty.
> > The first one is caused by a busy dirtier, while the latter one could
> > happen in XFS, NFS, etc. when they are doing delalloc or updating isize.
> 
> Btw, I'm not sure the existing and preserved behaviour for that case
> is good.  In the worst case the inode writeout gets delayed by another
> 30 seconds, doubling the window until a file is on disk if it was
> extended.

Yes, the preserved behaviour is not optimal for XFS, but safe.

We could try redirty_tail when there are no remaining
dirty pages, and only metadata dirtiness. Like this:

---
 fs/fs-writeback.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

--- linux.orig/fs/fs-writeback.c	2009-09-27 09:52:15.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-09-27 09:54:23.000000000 +0800
@@ -477,18 +477,7 @@ writeback_single_inode(struct inode *ino
 	spin_lock(&inode_lock);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & (I_FREEING | I_CLEAR))) {
-		if ((inode->i_state & I_DIRTY_PAGES) && wbc->for_kupdate) {
-			/*
-			 * More pages get dirtied by a fast dirtier.
-			 */
-			goto select_queue;
-		} else if (inode->i_state & I_DIRTY) {
-			/*
-			 * At least XFS will redirty the inode during the
-			 * writeback (delalloc) and on io completion (isize).
-			 */
-			redirty_tail(inode);
-		} else if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
+		if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
 			/*
 			 * We didn't write back all the pages.  nfs_writepages()
 			 * sometimes bales out without doing anything. Redirty
@@ -510,7 +499,6 @@ writeback_single_inode(struct inode *ino
 				 * soon as the queue becomes uncongested.
 				 */
 				inode->i_state |= I_DIRTY_PAGES;
-select_queue:
 				if (wbc->nr_to_write <= 0) {
 					/*
 					 * slice used up: queue for next turn
@@ -533,6 +521,12 @@ select_queue:
 				inode->i_state |= I_DIRTY_PAGES;
 				redirty_tail(inode);
 			}
+		} else if (inode->i_state & I_DIRTY) {
+			/*
+			 * At least XFS will redirty the inode during the
+			 * writeback (delalloc) and on io completion (isize).
+			 */
+			redirty_tail(inode);
 		} else if (atomic_read(&inode->i_count)) {
 			/*
 			 * The inode is clean, inuse
