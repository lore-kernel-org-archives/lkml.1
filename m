Return-Path: <linux-kernel-owner+w=401wt.eu-S1752634AbZIXN3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbZIXN3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 09:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbZIXN3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 09:29:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:36440 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbZIXN3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 09:29:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,445,1249282800"; 
   d="scan'208";a="191204845"
Date: Thu, 24 Sep 2009 21:29:38 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Li, Shaohua" <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>, Jan Kara <jack@suse.cz>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC] page-writeback: move indoes from one superblock together
Message-ID: <20090924132938.GB696@localhost>
References: <1253775260.10618.10.camel@sli10-desk.sh.intel.com> <20090924071415.GA20808@localhost> <20090924074431.GA22396@sli10-desk.sh.intel.com> <20090924131738.GG23126@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090924131738.GG23126@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 09:17:39PM +0800, Jens Axboe wrote:
> > > Could just reuse inode.
> > oops, forgot to remove it when moveing inode to global.
> 
> This is the one I merged. I added the below as wel, we don't need to
> reiterate the list if we only moved inodes from a single super block.

Looks good to me.

> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index b27406d..225c731 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -336,17 +336,27 @@ static void move_expired_inodes(struct list_head *delaying_queue,
>  {
>  	LIST_HEAD(tmp);
>  	struct list_head *pos, *node;
> -	struct super_block *sb;
> +	struct super_block *sb = NULL;
>  	struct inode *inode;
> +	int do_sb_sort = 0;
>  
>  	while (!list_empty(delaying_queue)) {
>  		inode = list_entry(delaying_queue->prev, struct inode, i_list);
>  		if (older_than_this &&
>  		    inode_dirtied_after(inode, *older_than_this))
>  			break;
> +		if (sb && sb != inode->i_sb)
> +			do_sb_sort = 1;
> +		sb = inode->i_sb;
>  		list_move(&inode->i_list, &tmp);
>  	}
>  
> +	/* just one sb in list, splice to dispatch_queue and we're done */
> +	if (!do_sb_sort) {
> +		list_splice(&tmp, dispatch_queue);
> +		return;
> +	}
> +
>  	/* Move inodes from one superblock together */
>  	while (!list_empty(&tmp)) {
>  		inode = list_entry(tmp.prev, struct inode, i_list);
> 
> -- 
> Jens Axboe
