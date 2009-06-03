Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbZFCKpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbZFCKpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 06:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbZFCKpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 06:45:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48062 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbZFCKpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 06:45:15 -0400
Date: Wed, 3 Jun 2009 06:45:00 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] skip I_CLEAR state inodes
Message-ID: <20090603064500.3897fcdd@tlielax.poochiereds.net>
In-Reply-To: <4A259E49.4020003@sandeen.net>
References: <20090318170237.8F6C.61FB500B@jp.fujitsu.com>
	<20090323103846.GA16577@localhost>
	<20090324155655.2684.61FB500B@jp.fujitsu.com>
	<20090324074457.GA7745@localhost>
	<20090324120502.GC23439@duck.suse.cz>
	<20090324124001.GA25326@localhost>
	<4A244A5B.7070605@sandeen.net>
	<20090602085523.GC7161@localhost>
	<20090602113736.GB15010@duck.suse.cz>
	<4A259E49.4020003@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Jun 2009 16:48:57 -0500
Eric Sandeen <sandeen@sandeen.net> wrote:

> Jan Kara wrote:
> > On Tue 02-06-09 16:55:23, Wu Fengguang wrote:
> >> On Tue, Jun 02, 2009 at 05:38:35AM +0800, Eric Sandeen wrote:
> >>> Wu Fengguang wrote:
> >>>> Add I_CLEAR tests to drop_pagecache_sb(), generic_sync_sb_inodes() and
> >>>> add_dquot_ref().
> >>>>
> >>>> clear_inode() will switch inode state from I_FREEING to I_CLEAR,
> >>>> and do so _outside_ of inode_lock. So any I_FREEING testing is
> >>>> incomplete without the testing of I_CLEAR.
> >>>>
> >>>> Masayoshi MIZUMA first discovered the bug in drop_pagecache_sb() and
> >>>> Jan Kara reminds fixing the other two cases. Thanks!
> >>> Is there a reason it's not done for __sync_single_inode as well?
> >> It missed the glance because it don't have an obvious '|' in the line ;)
> >>
> >>> Jeff Layton asked the question and I'm following it up :)
> >>>
> >>> __sync_single_inode currently only tests I_FREEING, but I think we are
> >>> safe because __sync_single_inode sets I_SYNC, and clear_inode waits for
> >>> I_SYNC to be cleared before it changes I_STATE.
> >> But I_SYNC is removed just before the I_FREEING test, so we still have
> >> a small race window?
> 
> yep that's right.
> 
>         inode->i_state &= ~I_SYNC;
> 	>>> clear_inode->inode_sync_wait here and find it clear <<<
>         if (!(inode->i_state & I_FREEING)) {
> 
> ...
> 
> >> --- linux.orig/fs/fs-writeback.c
> >> +++ linux/fs/fs-writeback.c
> >> @@ -316,7 +316,7 @@ __sync_single_inode(struct inode *inode,
> >>  	spin_lock(&inode_lock);
> >>  	WARN_ON(inode->i_state & I_NEW);
> >>  	inode->i_state &= ~I_SYNC;
> >> -	if (!(inode->i_state & I_FREEING)) {
> >> +	if (!(inode->i_state & (I_FREEING | I_CLEAR))) {
> >>  		if (!(inode->i_state & I_DIRTY) &&
> >>  		    mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
> 
> >   Is the whole if needed? I had an impression that everyone calling
> > __sync_single_inode() should better take care it does not race with inode
> > freeing... So WARN_ON would be more appropriate IMHO.
> 
> Maybe both then (both a WARN on and then the test (defensive here, I
> guess)) because if we continue we may wander into a poisoned list
> pointer and explode, right?
> 

Right.

I think removing this check would be roughly equivalent to adding a
BUG_ON. It just wouldn't reliably pop since it would depend on the
timing of the race.

Keeping the check and adding a WARN seems like a reasonable thing to
do. Maybe after a few releases if no one has seen the WARN fire we can
look at removing the check (or maybe turn it into a BUG)?

-- 
Jeff Layton <jlayton@redhat.com>
