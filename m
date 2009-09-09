Return-Path: <linux-kernel-owner+w=401wt.eu-S1753631AbZIIPpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbZIIPpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 11:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbZIIPpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 11:45:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:57332 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862AbZIIPpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 11:45:15 -0400
Date: Wed, 9 Sep 2009 17:45:17 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>, jack@suse.cz,
       Artem Bityutskiy <dedekind1@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/7] writeback: cleanup writeback_single_inode()
Message-ID: <20090909154517.GD7949@duck.suse.cz>
References: <20090909145141.293229693@intel.com> <20090909150600.330539880@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090909150600.330539880@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 09-09-09 22:51:42, Wu Fengguang wrote:
> Make the if-else straight in writeback_single_inode().
> No behavior change.
> 
> Cc: Michael Rubin <mrubin@google.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
  The patch looks good.
Acked-by: Jan Kara <jack@suse.cz>

> ---
>  fs/fs-writeback.c |   15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> --- linux.orig/fs/fs-writeback.c	2009-09-09 21:40:41.000000000 +0800
> +++ linux/fs/fs-writeback.c	2009-09-09 21:41:14.000000000 +0800
> @@ -417,8 +417,13 @@ writeback_single_inode(struct inode *ino
>  	spin_lock(&inode_lock);
>  	inode->i_state &= ~I_SYNC;
>  	if (!(inode->i_state & (I_FREEING | I_CLEAR))) {
> -		if (!(inode->i_state & I_DIRTY) &&
> -		    mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
> +		if (inode->i_state & I_DIRTY) {
> +			/*
> +			 * Someone redirtied the inode while were writing back
> +			 * the pages.
> +			 */
> +			redirty_tail(inode);
> +		} else if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
>  			/*
>  			 * We didn't write back all the pages.  nfs_writepages()
>  			 * sometimes bales out without doing anything. Redirty
> @@ -462,12 +467,6 @@ writeback_single_inode(struct inode *ino
>  				inode->i_state |= I_DIRTY_PAGES;
>  				redirty_tail(inode);
>  			}
> -		} else if (inode->i_state & I_DIRTY) {
> -			/*
> -			 * Someone redirtied the inode while were writing back
> -			 * the pages.
> -			 */
> -			redirty_tail(inode);
>  		} else if (atomic_read(&inode->i_count)) {
>  			/*
>  			 * The inode is clean, inuse
> 
> -- 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
