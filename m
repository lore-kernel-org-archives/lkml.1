Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbZFCOr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbZFCOr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 10:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbZFCOrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 10:47:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:30741 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234AbZFCOrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 10:47:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,298,1241420400"; 
   d="scan'208";a="150207797"
Date: Wed, 3 Jun 2009 22:47:11 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Eric Sandeen <sandeen@sandeen.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       Nick Piggin <npiggin@suse.de>, Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH] skip I_CLEAR state inodes
Message-ID: <20090603144711.GC5738@localhost>
References: <20090323103846.GA16577@localhost> <20090324155655.2684.61FB500B@jp.fujitsu.com> <20090324074457.GA7745@localhost> <20090324120502.GC23439@duck.suse.cz> <20090324124001.GA25326@localhost> <4A244A5B.7070605@sandeen.net> <20090602085523.GC7161@localhost> <20090602113736.GB15010@duck.suse.cz> <20090603141021.GB5738@localhost> <20090603141636.GC5650@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603141636.GC5650@duck.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03, 2009 at 10:16:36PM +0800, Jan Kara wrote:
> On Wed 03-06-09 22:10:21, Wu Fengguang wrote:
> > On Tue, Jun 02, 2009 at 07:37:36PM +0800, Jan Kara wrote:
> > > On Tue 02-06-09 16:55:23, Wu Fengguang wrote:
> > > > On Tue, Jun 02, 2009 at 05:38:35AM +0800, Eric Sandeen wrote:
> > > > > Wu Fengguang wrote:
> > > > > > Add I_CLEAR tests to drop_pagecache_sb(), generic_sync_sb_inodes() and
> > > > > > add_dquot_ref().
> > > > > > 
> > > > > > clear_inode() will switch inode state from I_FREEING to I_CLEAR,
> > > > > > and do so _outside_ of inode_lock. So any I_FREEING testing is
> > > > > > incomplete without the testing of I_CLEAR.
> > > > > > 
> > > > > > Masayoshi MIZUMA first discovered the bug in drop_pagecache_sb() and
> > > > > > Jan Kara reminds fixing the other two cases. Thanks!
> > > > > 
> > > > > Is there a reason it's not done for __sync_single_inode as well?
> > > > 
> > > > It missed the glance because it don't have an obvious '|' in the line ;)
> > > > 
> > > > > Jeff Layton asked the question and I'm following it up :)
> > > > > 
> > > > > __sync_single_inode currently only tests I_FREEING, but I think we are
> > > > > safe because __sync_single_inode sets I_SYNC, and clear_inode waits for
> > > > > I_SYNC to be cleared before it changes I_STATE.
> > > > 
> > > > But I_SYNC is removed just before the I_FREEING test, so we still have
> > > > a small race window?
> > > > 
> > > > > On the other hand, testing I_CLEAR here probably would be safe anyway,
> > > > > and it'd be bonus points for consistency?
> > > > 
> > > > So let's add the I_CLEAR test?
> > > > 
> > > > > Same basic question for generic_sync_sb_inodes, which has a
> > > > > BUG_ON(inode->i_state & I_FREEING), seems like this could check I_CLWAR
> > > > > as well?
> > > > 
> > > > Yes, we can add I_CLEAR here to catch more error condition.
> > > > 
> > > > Thanks,
> > > > Fengguang
> > > > 
> > > > ---
> > > > skip I_CLEAR state inodes in writeback routines
> > > > 
> > > > The I_FREEING test in __sync_single_inode() is racy because
> > > > clear_inode() can set i_state to I_CLEAR between the clear of I_SYNC
> > > > and the test of I_FREEING.
> > > > 
> > > > Also extend the coverage of BUG_ON(I_FREEING) to I_CLEAR.
> > > > 
> > > > Reported-by: Jeff Layton <jlayton@redhat.com>
> > > > Reported-by: Eric Sandeen <sandeen@sandeen.net>
> > > > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > > > ---
> > > >  fs/fs-writeback.c |    4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > 
> > > > --- linux.orig/fs/fs-writeback.c
> > > > +++ linux/fs/fs-writeback.c
> > > > @@ -316,7 +316,7 @@ __sync_single_inode(struct inode *inode,
> > > >  	spin_lock(&inode_lock);
> > > >  	WARN_ON(inode->i_state & I_NEW);
> > > >  	inode->i_state &= ~I_SYNC;
> > > > -	if (!(inode->i_state & I_FREEING)) {
> > > > +	if (!(inode->i_state & (I_FREEING | I_CLEAR))) {
> > > >  		if (!(inode->i_state & I_DIRTY) &&
> > > >  		    mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
> > >   Is the whole if needed? I had an impression that everyone calling
> > > __sync_single_inode() should better take care it does not race with inode
> > > freeing... So WARN_ON would be more appropriate IMHO.
> > > 
> > > >  			/*
> > > > @@ -518,7 +518,7 @@ void generic_sync_sb_inodes(struct super
> > > >  		if (current_is_pdflush() && !writeback_acquire(bdi))
> > > >  			break;
> > > >  
> > > > -		BUG_ON(inode->i_state & I_FREEING);
> > > > +		BUG_ON(inode->i_state & (I_FREEING | I_CLEAR));
> > > >  		__iget(inode);
> > > >  		pages_skipped = wbc->pages_skipped;
> > > >  		__writeback_single_inode(inode, wbc);
> > >   Looking at this code, it looks a bit suspicious. What prevents this s_io
> > > list scan to race with inode freeing? In particular generic_forget_inode()
> > 
> > Good catch.
> > 
> > > can drop inode_lock to write the inode and in the mean time
> > > generic_sync_sb_inodes() can come, get a reference to the inode and start
> > > it's writeback... Subsequent iput() would then call generic_forget_inode()
> > 
> > Another possibility:
> > 
> > generic_forget_inode
> >   inode->i_state |= I_WILL_FREE;
> >   spin_unlock(&inode_lock);
> >                                                 generic_sync_sb_inodes()
> >                                                   spin_lock(&inode_lock);
> >                                                   __iget(inode);
> >                                                   __writeback_single_inode
> >                                                     // see non zero i_count
> >                                                     WARN_ON(inode->i_state & I_WILL_FREE);
> > 
> > I'm wondering why didn't we saw reports on the last WARN_ON()?
> > Did we missed something?
>   I meant the above race in my description ;-). Anyway, the race can happen
> only if we are unmounting the filesystem (normally, we bail out on
> sb->s_flags & MS_ACTIVE check - yes, it's a bit hidden and it also took me
> a while to understand why we weren't seeing tons of warnings...).

Ah OK. Just checked that all three callers of generic_sync_sb_inodes():
- writeback_inodes(): umount prevented
- pohmelfs_kill_super(): just before umount
- ubifs calls: too complex to be obvious..
At least the first two cases are safe, so we didn't see the error report ;)

> > > on the inode again. So shouldn't we skip I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW
> > > inodes in this scan like we do for later in the function for another scan?

Yes we should do this at least for safety.  I_WILL_FREE means
generic_forget_inode() is going to writeback the inode on its own, so
generic_sync_sb_inodes() would better not to wade in.

Thanks,
Fengguang
