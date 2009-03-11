Return-Path: <linux-kernel-owner+w=401wt.eu-S1756221AbZCKMYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbZCKMYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 08:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbZCKMYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 08:24:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:54919 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040AbZCKMYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 08:24:23 -0400
Date: Wed, 11 Mar 2009 13:24:20 +0100
From: Jan Kara <jack@suse.cz>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Jorge Boncompte [DTI2]" <jorge@dti2.net>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>, stable@kernel.org
Subject: Re: [patch] fs: avoid I_NEW inodes
Message-ID: <20090311122420.GB24590@duck.suse.cz>
References: <20090305064554.GA11916@wotan.suse.de> <20090305100000.GA29177@duck.suse.cz> <20090305101637.GB17815@wotan.suse.de> <20090305111226.GB29531@duck.suse.cz> <20090310134106.GA15977@wotan.suse.de> <20090310160321.GB1190@duck.suse.cz> <20090311032918.GE16561@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311032918.GE16561@wotan.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 11-03-09 04:29:18, Nick Piggin wrote:
> How about this?
  Looks fine to me.

> --
> To be on the safe side, it should be less fragile to exclude I_NEW inodes
> from inode list scans by default (unless there is an important reason to
> have them).
> 
> Normally they will get excluded (eg. by zero refcount or writecount etc),
> however it is a bit fragile for list walkers to know exactly what parts of
> the inode state is set up and valid to test when in I_NEW. So along these
> lines, move I_NEW checks upward as well (sometimes taking I_FREEING etc
> checks with them too -- this shouldn't be a problem should it?)
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>
  Acked-by: Jan Kara <jack@suse.cz>

									Honza

> ---
>  fs/dquot.c                  |   10 ++++++++--
>  fs/drop_caches.c            |    2 +-
>  fs/inode.c                  |    2 ++
>  fs/notify/inotify/inotify.c |   16 ++++++++--------
>  4 files changed, 19 insertions(+), 11 deletions(-)
> 
> Index: linux-2.6/fs/dquot.c
> ===================================================================
> --- linux-2.6.orig/fs/dquot.c
> +++ linux-2.6/fs/dquot.c
> @@ -789,12 +789,12 @@ static void add_dquot_ref(struct super_b
>  
>  	spin_lock(&inode_lock);
>  	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> +		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
> +			continue;
>  		if (!atomic_read(&inode->i_writecount))
>  			continue;
>  		if (!dqinit_needed(inode, type))
>  			continue;
> -		if (inode->i_state & (I_FREEING|I_WILL_FREE))
> -			continue;
>  
>  		__iget(inode);
>  		spin_unlock(&inode_lock);
> @@ -870,6 +870,12 @@ static void remove_dquot_ref(struct supe
>  
>  	spin_lock(&inode_lock);
>  	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> +		/*
> +		 *  We have to scan also I_NEW inodes because they can already
> +		 *  have quota pointer initialized. Luckily, we need to touch
> +		 *  only quota pointers and these have separate locking
> +		 *  (dqptr_sem).
> +		 */
>  		if (!IS_NOQUOTA(inode))
>  			remove_inode_dquot_ref(inode, type, tofree_head);
>  	}
> Index: linux-2.6/fs/drop_caches.c
> ===================================================================
> --- linux-2.6.orig/fs/drop_caches.c
> +++ linux-2.6/fs/drop_caches.c
> @@ -18,7 +18,7 @@ static void drop_pagecache_sb(struct sup
>  
>  	spin_lock(&inode_lock);
>  	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> -		if (inode->i_state & (I_FREEING|I_WILL_FREE))
> +		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
>  			continue;
>  		if (inode->i_mapping->nrpages == 0)
>  			continue;
> Index: linux-2.6/fs/inode.c
> ===================================================================
> --- linux-2.6.orig/fs/inode.c
> +++ linux-2.6/fs/inode.c
> @@ -356,6 +356,8 @@ static int invalidate_list(struct list_h
>  		if (tmp == head)
>  			break;
>  		inode = list_entry(tmp, struct inode, i_sb_list);
> +		if (inode->i_state & I_NEW)
> +			continue;
>  		invalidate_inode_buffers(inode);
>  		if (!atomic_read(&inode->i_count)) {
>  			list_move(&inode->i_list, dispose);
> Index: linux-2.6/fs/notify/inotify/inotify.c
> ===================================================================
> --- linux-2.6.orig/fs/notify/inotify/inotify.c
> +++ linux-2.6/fs/notify/inotify/inotify.c
> @@ -380,6 +380,14 @@ void inotify_unmount_inodes(struct list_
>  		struct list_head *watches;
>  
>  		/*
> +		 * We cannot __iget() an inode in state I_CLEAR, I_FREEING,
> +		 * I_WILL_FREE, or I_NEW which is fine because by that point
> +		 * the inode cannot have any associated watches.
> +		 */
> +		if (inode->i_state & (I_CLEAR|I_FREEING|I_WILL_FREE|I_NEW))
> +			continue;
> +
> +		/*
>  		 * If i_count is zero, the inode cannot have any watches and
>  		 * doing an __iget/iput with MS_ACTIVE clear would actually
>  		 * evict all inodes with zero i_count from icache which is
> @@ -388,14 +396,6 @@ void inotify_unmount_inodes(struct list_
>  		if (!atomic_read(&inode->i_count))
>  			continue;
>  
> -		/*
> -		 * We cannot __iget() an inode in state I_CLEAR, I_FREEING, or
> -		 * I_WILL_FREE which is fine because by that point the inode
> -		 * cannot have any associated watches.
> -		 */
> -		if (inode->i_state & (I_CLEAR | I_FREEING | I_WILL_FREE))
> -			continue;
> -
>  		need_iput_tmp = need_iput;
>  		need_iput = NULL;
>  		/* In case inotify_remove_watch_locked() drops a reference. */
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
