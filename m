Return-Path: <linux-kernel-owner+w=401wt.eu-S1751556AbZIWNUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbZIWNUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 09:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbZIWNUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 09:20:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:36402 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbZIWNUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 09:20:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,438,1249282800"; 
   d="scan'208";a="190746447"
Date: Wed, 23 Sep 2009 21:20:08 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] writeback: don't delay inodes redirtied by a fast
	dirtier
Message-ID: <20090923132008.GB32347@localhost>
References: <20090923123337.990689487@intel.com> <20090923124028.060887241@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923124028.060887241@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 08:33:43PM +0800, Wu, Fengguang wrote:
> Debug traces show that in per-bdi writeback, the inode under writeback
> almost always get redirtied by a busy dirtier.  We used to call
> redirty_tail() in this case, which could delay inode for up to 30s.
> 
> This is unacceptable because it now happens so frequently for plain cp/dd,
> that the accumulated delays could make writeback of big files very slow.
> 
> So let's distinguish between data redirty and metadata only redirty.
> The first one is caused by a busy dirtier, while the latter one could
> happen in XFS, NFS, etc. when they are doing delalloc or updating isize.
> 
> The inode being busy dirtied will now be requeued for next io, while
> the inode being redirtied by fs will continue to be delayed to avoid
> repeated IO.

Here are some test results on XFS.  Workload is a simple

         cp /dev/zero /mnt/xfs/

I saw many repeated 

[  344.043711] mm/page-writeback.c +540 balance_dirty_pages(): comm=cp pid=3520 n=12
[  344.043711] global dirty=57051 writeback=12920 nfs=0 flags=CM towrite=0 skipped=0
[  344.043711] redirty_tail() +516: inode=128  => the directory inode
[  344.043711] redirty_tail() +516: inode=131  => the zero file being written to

and then repeated 

[  347.408629] fs/fs-writeback.c +813 wb_writeback(): comm=flush-8:0 pid=3298 n=4096
[  347.411045] global dirty=50397 writeback=18065 nfs=0 flags=CM towrite=0 skipped=0
[  347.422077] requeue_io() +468: inode=131
[  347.423809] redirty_tail() +516: inode=128

traces during copy, and repeated 


[  373.326496] redirty_tail() +516: inode=131
[  373.328209] fs/fs-writeback.c +813 wb_writeback(): comm=flush-8:0 pid=3298 n=4096
[  373.330988] global dirty=25213 writeback=20470 nfs=0 flags=CM towrite=0 skipped=0

after copy is interrupted.

I noticed that
- the write chunk size of balance_dirty_pages() is 12, which is pretty
  small and inefficient.
- during copy, the inode is sometimes redirty_tail (old behavior) and
  sometimes requeue_io (new behavior).
- during copy, the directory inode will always be synced and then
  redirty_tail.
- after copy, the inode will be redirtied after sync.

It shall not be a problem to use requeue_io for XFS, because whether
it be requeue_io or redirty_tail, write_inode() will be called once
for every 4MB.

It would be inefficient if XFS really tries to write inode and
directory inode's metadata every time it synced 4MB page. If
that write attempt is turned into _real_ IO, that would be bad
and kill performance. Increasing MAX_WRITEBACK_PAGES may help
reduce the frequency of write_inode() though.

Thanks,
Fengguang

> CC: Jan Kara <jack@suse.cz>
> CC: Theodore Ts'o <tytso@mit.edu>
> CC: Dave Chinner <david@fromorbit.com>
> CC: Jens Axboe <jens.axboe@oracle.com>
> CC: Chris Mason <chris.mason@oracle.com>
> CC: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  fs/fs-writeback.c |   17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> --- linux.orig/fs/fs-writeback.c	2009-09-23 16:13:41.000000000 +0800
> +++ linux/fs/fs-writeback.c	2009-09-23 16:21:24.000000000 +0800
> @@ -491,10 +493,15 @@ writeback_single_inode(struct inode *ino
>  	spin_lock(&inode_lock);
>  	inode->i_state &= ~I_SYNC;
>  	if (!(inode->i_state & (I_FREEING | I_CLEAR))) {
> -		if (inode->i_state & I_DIRTY) {
> +		if (inode->i_state & I_DIRTY_PAGES) {
>  			/*
> -			 * Someone redirtied the inode while were writing back
> -			 * the pages.
> +			 * More pages get dirtied by a fast dirtier.
> +			 */
> +			goto select_queue;
> +		} else if (inode->i_state & I_DIRTY) {
> +			/*
> +			 * At least XFS will redirty the inode during the
> +			 * writeback (delalloc) and on io completion (isize).
>  			 */
>  			redirty_tail(inode);
>  		} else if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
> 
