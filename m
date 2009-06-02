Return-Path: <linux-kernel-owner+w=401wt.eu-S1757979AbZFBK2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbZFBK2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 06:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbZFBK1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 06:27:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55636 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbZFBK1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 06:27:54 -0400
Date: Tue, 2 Jun 2009 06:27:29 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Eric Sandeen <sandeen@sandeen.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
       Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] skip I_CLEAR state inodes
Message-ID: <20090602062729.03bdbe99@tupile.poochiereds.net>
In-Reply-To: <20090602085523.GC7161@localhost>
References: <20090318170237.8F6C.61FB500B@jp.fujitsu.com>
	<20090323103846.GA16577@localhost>
	<20090324155655.2684.61FB500B@jp.fujitsu.com>
	<20090324074457.GA7745@localhost>
	<20090324120502.GC23439@duck.suse.cz>
	<20090324124001.GA25326@localhost>
	<4A244A5B.7070605@sandeen.net>
	<20090602085523.GC7161@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jun 2009 16:55:23 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> On Tue, Jun 02, 2009 at 05:38:35AM +0800, Eric Sandeen wrote:
> > Wu Fengguang wrote:
> > > Add I_CLEAR tests to drop_pagecache_sb(), generic_sync_sb_inodes() and
> > > add_dquot_ref().
> > > 
> > > clear_inode() will switch inode state from I_FREEING to I_CLEAR,
> > > and do so _outside_ of inode_lock. So any I_FREEING testing is
> > > incomplete without the testing of I_CLEAR.
> > > 
> > > Masayoshi MIZUMA first discovered the bug in drop_pagecache_sb() and
> > > Jan Kara reminds fixing the other two cases. Thanks!
> > 
> > Is there a reason it's not done for __sync_single_inode as well?
> 
> It missed the glance because it don't have an obvious '|' in the line ;)
> 
> > Jeff Layton asked the question and I'm following it up :)
> > 
> > __sync_single_inode currently only tests I_FREEING, but I think we are
> > safe because __sync_single_inode sets I_SYNC, and clear_inode waits for
> > I_SYNC to be cleared before it changes I_STATE.
> 
> But I_SYNC is removed just before the I_FREEING test, so we still have
> a small race window?
> 

Yes, I think so. __sync_single_inode clears I_SYNC but doesn't wake up
the wait queue until the end of the function. So I think it's possible
(though unlikely) that another thread can race in and change the state
to I_CLEAR before the I_FREEING check.

> > On the other hand, testing I_CLEAR here probably would be safe anyway,
> > and it'd be bonus points for consistency?
> 
> So let's add the I_CLEAR test?
> 
> > Same basic question for generic_sync_sb_inodes, which has a
> > BUG_ON(inode->i_state & I_FREEING), seems like this could check I_CLWAR
> > as well?
> 
> Yes, we can add I_CLEAR here to catch more error condition.
> 
> Thanks,
> Fengguang
> 
> ---
> skip I_CLEAR state inodes in writeback routines
> 
> The I_FREEING test in __sync_single_inode() is racy because
> clear_inode() can set i_state to I_CLEAR between the clear of I_SYNC
> and the test of I_FREEING.
> 
> Also extend the coverage of BUG_ON(I_FREEING) to I_CLEAR.
> 
> Reported-by: Jeff Layton <jlayton@redhat.com>
> Reported-by: Eric Sandeen <sandeen@sandeen.net>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  fs/fs-writeback.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux.orig/fs/fs-writeback.c
> +++ linux/fs/fs-writeback.c
> @@ -316,7 +316,7 @@ __sync_single_inode(struct inode *inode,
>  	spin_lock(&inode_lock);
>  	WARN_ON(inode->i_state & I_NEW);
>  	inode->i_state &= ~I_SYNC;
> -	if (!(inode->i_state & I_FREEING)) {
> +	if (!(inode->i_state & (I_FREEING | I_CLEAR))) {
>  		if (!(inode->i_state & I_DIRTY) &&
>  		    mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
>  			/*
> @@ -518,7 +518,7 @@ void generic_sync_sb_inodes(struct super
>  		if (current_is_pdflush() && !writeback_acquire(bdi))
>  			break;
>  
> -		BUG_ON(inode->i_state & I_FREEING);
> +		BUG_ON(inode->i_state & (I_FREEING | I_CLEAR));
>  		__iget(inode);
>  		pages_skipped = wbc->pages_skipped;
>  		__writeback_single_inode(inode, wbc);

Acked-by: Jeff Layton <jlayton@redhat.com>
