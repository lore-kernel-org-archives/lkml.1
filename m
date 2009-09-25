Return-Path: <linux-kernel-owner+w=401wt.eu-S1753284AbZIYCze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbZIYCze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 22:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbZIYCze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 22:55:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:40022 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181AbZIYCzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 22:55:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,449,1249282800"; 
   d="scan'208";a="191484112"
Date: Fri, 25 Sep 2009 10:55:27 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "jack@suse.cz" <jack@suse.cz>
Subject: Re: [PATCH 0/10] Current writeback patch queue
Message-ID: <20090925025527.GA10487@localhost>
References: <1253803236-20760-1-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253803236-20760-1-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 10:40:26PM +0800, Jens Axboe wrote:
> Hi,
> 
> This is the current writeback patch queue. Most of the patches
> have already been reviewed and acked, but please take a look
> at the ones that have not (and ack/comment as necessary).
> 
> Wu, this one is still missing the 5/6 patch from your latest posting,
> Please double check and re-submit that bit. Thanks!

OK, updated patch to add the missing label and the wbc->for_kupdate
check to avoid jumping from !for_kupdate to the for_kupdate code
block.  Tested on ext2/3/4, xfs and btrfs and works as expected.

Thanks,
Fengguang
---

writeback: don't delay inodes redirtied by a fast dirtier

Debug traces show that in per-bdi writeback, the inode under writeback
almost always get redirtied by a busy dirtier.  We used to call
redirty_tail() in this case, which could delay inode for up to 30s.

This is unacceptable because it now happens so frequently for plain cp/dd,
that the accumulated delays could make writeback of big files very slow.

So let's distinguish between data redirty and metadata only redirty.
The first one is caused by a busy dirtier, while the latter one could
happen in XFS, NFS, etc. when they are doing delalloc or updating isize.

The inode being busy dirtied will now be requeued for next io, while
the inode being redirtied by fs will continue to be delayed to avoid
repeated IO.

CC: Jan Kara <jack@suse.cz>
CC: Theodore Ts'o <tytso@mit.edu>
CC: Dave Chinner <david@fromorbit.com>
CC: Jens Axboe <jens.axboe@oracle.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- linux.orig/fs/fs-writeback.c	2009-09-23 21:43:30.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-09-25 10:29:07.000000000 +0800
@@ -452,10 +452,15 @@ writeback_single_inode(struct inode *ino
 	spin_lock(&inode_lock);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & (I_FREEING | I_CLEAR))) {
-		if (inode->i_state & I_DIRTY) {
+		if ((inode->i_state & I_DIRTY_PAGES) && wbc->for_kupdate) {
 			/*
-			 * Someone redirtied the inode while were writing back
-			 * the pages.
+			 * More pages get dirtied by a fast dirtier.
+			 */
+			goto select_queue;
+		} else if (inode->i_state & I_DIRTY) {
+			/*
+			 * At least XFS will redirty the inode during the
+			 * writeback (delalloc) and on io completion (isize).
 			 */
 			redirty_tail(inode);
 		} else if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
@@ -480,6 +485,7 @@ writeback_single_inode(struct inode *ino
 				 * soon as the queue becomes uncongested.
 				 */
 				inode->i_state |= I_DIRTY_PAGES;
+select_queue:
 				if (wbc->nr_to_write <= 0) {
 					/*
 					 * slice used up: queue for next turn
