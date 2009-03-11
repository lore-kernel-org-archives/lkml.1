Return-Path: <linux-kernel-owner+w=401wt.eu-S1755802AbZCKCeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802AbZCKCeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 22:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbZCKCee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 22:34:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:42884 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160AbZCKCed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 22:34:33 -0400
Date: Wed, 11 Mar 2009 03:34:30 +0100
From: Nick Piggin <npiggin@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Jorge Boncompte [DTI2]" <jorge@dti2.net>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>, stable@kernel.org
Subject: Re: [patch] fs: avoid I_NEW inodes
Message-ID: <20090311023429.GC16561@wotan.suse.de>
References: <20090305064554.GA11916@wotan.suse.de> <20090305100000.GA29177@duck.suse.cz> <20090305101637.GB17815@wotan.suse.de> <20090305111226.GB29531@duck.suse.cz> <20090310134106.GA15977@wotan.suse.de> <20090310160321.GB1190@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310160321.GB1190@duck.suse.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 05:03:21PM +0100, Jan Kara wrote:
> > OK, sorry for the delay, what do you think of the following patch on top
> > of the last?
>   Thanks for the patch. I have a few comments. See below.
> 
> > ---
> > 
> > To be on the safe side, it should be less fragile to exclude I_NEW inodes
> > from inode list scans by default (unless there is an important reason to
> > have them).
> > 
> > Normally they will get excluded (eg. by zero refcount or writecount etc),
> > however it is a bit fragile for list walkers to know exactly what parts of
> > the inode state is set up and valid to test when in I_NEW. So along these
> > lines, move I_NEW checks upward as well (sometimes taking I_FREEING etc
> > checks with them too -- this shouldn't be a problem should it?)
> > 
> > Signed-off-by: Nick Piggin <npiggin@suse.de>
> > 
> > ---
> >  fs/dquot.c                  |    6 ++++--
> >  fs/drop_caches.c            |    2 +-
> >  fs/inode.c                  |    2 ++
> >  fs/notify/inotify/inotify.c |   16 ++++++++--------
> >  4 files changed, 15 insertions(+), 11 deletions(-)
> > 
> > Index: linux-2.6/fs/dquot.c
> > ===================================================================
> > --- linux-2.6.orig/fs/dquot.c
> > +++ linux-2.6/fs/dquot.c
> > @@ -789,12 +789,12 @@ static void add_dquot_ref(struct super_b
> >  
> >  	spin_lock(&inode_lock);
> >  	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> > +		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
> > +			continue;
> >  		if (!atomic_read(&inode->i_writecount))
> >  			continue;
> >  		if (!dqinit_needed(inode, type))
> >  			continue;
> > -		if (inode->i_state & (I_FREEING|I_WILL_FREE))
> > -			continue;
> >  
> >  		__iget(inode);
> >  		spin_unlock(&inode_lock);
> > @@ -870,6 +870,8 @@ static void remove_dquot_ref(struct supe
> >  
> >  	spin_lock(&inode_lock);
> >  	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> > +		if (inode->i_state & I_NEW)
> > +			continue;
> >  		if (!IS_NOQUOTA(inode))
> >  			remove_inode_dquot_ref(inode, type, tofree_head);
> >  	}
>   Hmm, in this scan, we have to scan also I_NEW inodes because they can
> already have quota pointers initialized and so we could leave some dangling
> quota references if we skipped I_NEW inodes. Nasty. So just add a comment
> here like this one here:
> /*
>  *  We have to scan also I_NEW inodes because they can already have quota
>  *  pointer initialized. Luckily, we need to touch only quota pointers and
>  *  these have separate locking (dqptr_sem).
>  */

OK, thanks. This is what I was unsure of.

 
> > Index: linux-2.6/fs/drop_caches.c
> > ===================================================================
> > --- linux-2.6.orig/fs/drop_caches.c
> > +++ linux-2.6/fs/drop_caches.c
> > @@ -18,7 +18,7 @@ static void drop_pagecache_sb(struct sup
> >  
> >  	spin_lock(&inode_lock);
> >  	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> > -		if (inode->i_state & (I_FREEING|I_WILL_FREE))
> > +		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
> >  			continue;
> >  		if (inode->i_mapping->nrpages == 0)
> >  			continue;
> > Index: linux-2.6/fs/inode.c
> > ===================================================================
> > --- linux-2.6.orig/fs/inode.c
> > +++ linux-2.6/fs/inode.c
> > @@ -356,6 +356,8 @@ static int invalidate_list(struct list_h
> >  		if (tmp == head)
> >  			break;
> >  		inode = list_entry(tmp, struct inode, i_sb_list);
> > +		if (inode->i_state & I_NEW)
> > +			continue;
>   If somebody is setting up inodes at this point, we are in serious
> trouble I think. So WARN_ON would be more appropriate I think.

Really? Hmm, this is also called via flush_disk which seems like it
can operate under a mounted filesystem?

 
> >  		invalidate_inode_buffers(inode);
> >  		if (!atomic_read(&inode->i_count)) {
> >  			list_move(&inode->i_list, dispose);
> > Index: linux-2.6/fs/notify/inotify/inotify.c
> > ===================================================================
> > --- linux-2.6.orig/fs/notify/inotify/inotify.c
> > +++ linux-2.6/fs/notify/inotify/inotify.c
> > @@ -380,6 +380,14 @@ void inotify_unmount_inodes(struct list_
> >  		struct list_head *watches;
> >  
> >  		/*
> > +		 * We cannot __iget() an inode in state I_CLEAR, I_FREEING, or
> > +		 * I_WILL_FREE which is fine because by that point the inode
> > +		 * cannot have any associated watches.
> > +		 */
>   Update the comment?

Will do.

Thanks,
Nick
