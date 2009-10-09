Return-Path: <linux-kernel-owner+w=401wt.eu-S1760843AbZJIPpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760843AbZJIPpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 11:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756153AbZJIPpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 11:45:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55819 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062AbZJIPpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 11:45:51 -0400
Date: Fri, 9 Oct 2009 17:45:10 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Li Shaohua <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/45] writeback: dont redirty tail an inode with dirty
	pages
Message-ID: <20091009154510.GI7654@duck.suse.cz>
References: <20091007073818.318088777@intel.com> <20091007074902.029561941@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007074902.029561941@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 07-10-09 15:38:25, Wu Fengguang wrote:
> This avoids delaying writeback for an expired (XFS) inode with lots of
> dirty pages, but no active dirtier at the moment.
  OK, looks good.
Acked-by: Jan Kara <jack@suse.cz>

								Honza
> 
> CC: Dave Chinner <david@fromorbit.com> 
> CC: Christoph Hellwig <hch@infradead.org> 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  fs/fs-writeback.c |   20 +++++++-------------
>  1 file changed, 7 insertions(+), 13 deletions(-)
> 
> --- linux.orig/fs/fs-writeback.c	2009-10-06 23:37:57.000000000 +0800
> +++ linux/fs/fs-writeback.c	2009-10-06 23:38:28.000000000 +0800
> @@ -479,18 +479,7 @@ writeback_single_inode(struct inode *ino
>  	spin_lock(&inode_lock);
>  	inode->i_state &= ~I_SYNC;
>  	if (!(inode->i_state & (I_FREEING | I_CLEAR))) {
> -		if ((inode->i_state & I_DIRTY_PAGES) && wbc->for_kupdate) {
> -			/*
> -			 * More pages get dirtied by a fast dirtier.
> -			 */
> -			goto select_queue;
> -		} else if (inode->i_state & I_DIRTY) {
> -			/*
> -			 * At least XFS will redirty the inode during the
> -			 * writeback (delalloc) and on io completion (isize).
> -			 */
> -			redirty_tail(inode);
> -		} else if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
> +		if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
>  			/*
>  			 * We didn't write back all the pages.  nfs_writepages()
>  			 * sometimes bales out without doing anything. Redirty
> @@ -512,7 +501,6 @@ writeback_single_inode(struct inode *ino
>  				 * soon as the queue becomes uncongested.
>  				 */
>  				inode->i_state |= I_DIRTY_PAGES;
> -select_queue:
>  				if (wbc->nr_to_write <= 0) {
>  					/*
>  					 * slice used up: queue for next turn
> @@ -535,6 +523,12 @@ select_queue:
>  				inode->i_state |= I_DIRTY_PAGES;
>  				redirty_tail(inode);
>  			}
> +		} else if (inode->i_state & I_DIRTY) {
> +			/*
> +			 * At least XFS will redirty the inode during the
> +			 * writeback (delalloc) and on io completion (isize).
> +			 */
> +			redirty_tail(inode);
>  		} else if (atomic_read(&inode->i_count)) {
>  			/*
>  			 * The inode is clean, inuse
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
