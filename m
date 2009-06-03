Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbZFCOAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbZFCOAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 10:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756046AbZFCOAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 10:00:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39314 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911AbZFCOAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 10:00:06 -0400
Date: Wed, 3 Jun 2009 16:00:06 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@sandeen.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] skip I_CLEAR state inodes
Message-ID: <20090603140005.GB5650@duck.suse.cz>
References: <20090318170237.8F6C.61FB500B@jp.fujitsu.com> <20090323103846.GA16577@localhost> <20090324155655.2684.61FB500B@jp.fujitsu.com> <20090324074457.GA7745@localhost> <20090324120502.GC23439@duck.suse.cz> <20090324124001.GA25326@localhost> <4A244A5B.7070605@sandeen.net> <20090602085523.GC7161@localhost> <20090602113736.GB15010@duck.suse.cz> <20090603133202.GA5738@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603133202.GA5738@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 03-06-09 21:32:02, Wu Fengguang wrote:
> [reply the easy part first]
> On Tue, Jun 02, 2009 at 07:37:36PM +0800, Jan Kara wrote:
> > On Tue 02-06-09 16:55:23, Wu Fengguang wrote:
> > > On Tue, Jun 02, 2009 at 05:38:35AM +0800, Eric Sandeen wrote:
> > > > Wu Fengguang wrote:
> > > > > Add I_CLEAR tests to drop_pagecache_sb(), generic_sync_sb_inodes() and
> > > > > add_dquot_ref().
> > > > > 
> > > > > clear_inode() will switch inode state from I_FREEING to I_CLEAR,
> > > > > and do so _outside_ of inode_lock. So any I_FREEING testing is
> > > > > incomplete without the testing of I_CLEAR.
> > > > > 
> > > > > Masayoshi MIZUMA first discovered the bug in drop_pagecache_sb() and
> > > > > Jan Kara reminds fixing the other two cases. Thanks!
> > > > 
> > > > Is there a reason it's not done for __sync_single_inode as well?
> > > 
> > > It missed the glance because it don't have an obvious '|' in the line ;)
> > > 
> > > > Jeff Layton asked the question and I'm following it up :)
> > > > 
> > > > __sync_single_inode currently only tests I_FREEING, but I think we are
> > > > safe because __sync_single_inode sets I_SYNC, and clear_inode waits for
> > > > I_SYNC to be cleared before it changes I_STATE.
> > > 
> > > But I_SYNC is removed just before the I_FREEING test, so we still have
> > > a small race window?
> > > 
> > > > On the other hand, testing I_CLEAR here probably would be safe anyway,
> > > > and it'd be bonus points for consistency?
> > > 
> > > So let's add the I_CLEAR test?
> > > 
> > > > Same basic question for generic_sync_sb_inodes, which has a
> > > > BUG_ON(inode->i_state & I_FREEING), seems like this could check I_CLWAR
> > > > as well?
> > > 
> > > Yes, we can add I_CLEAR here to catch more error condition.
> > > 
> > > Thanks,
> > > Fengguang
> > > 
> > > ---
> > > skip I_CLEAR state inodes in writeback routines
> > > 
> > > The I_FREEING test in __sync_single_inode() is racy because
> > > clear_inode() can set i_state to I_CLEAR between the clear of I_SYNC
> > > and the test of I_FREEING.
> > > 
> > > Also extend the coverage of BUG_ON(I_FREEING) to I_CLEAR.
> > > 
> > > Reported-by: Jeff Layton <jlayton@redhat.com>
> > > Reported-by: Eric Sandeen <sandeen@sandeen.net>
> > > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > > ---
> > >  fs/fs-writeback.c |    4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > --- linux.orig/fs/fs-writeback.c
> > > +++ linux/fs/fs-writeback.c
> > > @@ -316,7 +316,7 @@ __sync_single_inode(struct inode *inode,
> > >  	spin_lock(&inode_lock);
> > >  	WARN_ON(inode->i_state & I_NEW);
> > >  	inode->i_state &= ~I_SYNC;
> > > -	if (!(inode->i_state & I_FREEING)) {
> > > +	if (!(inode->i_state & (I_FREEING | I_CLEAR))) {
> > >  		if (!(inode->i_state & I_DIRTY) &&
> > >  		    mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
> >   Is the whole if needed? I had an impression that everyone calling
> > __sync_single_inode() should better take care it does not race with inode
> > freeing... So WARN_ON would be more appropriate IMHO.
> 
> The caller doesn't matter here, because we temporarily dropped inode_lock
> in __sync_single_inode() ?
  But the problem is basically what I described in the part you cut from
the email - if the caller of __sync_single_inode() does not have a
reference to the inode or some other means of protecting inode from being
released, then we have a problem because e.g. __writeback_single_inode()
can sleep and before I_SYNC is set, all the clear_inode() can finish and
we end up calling do_writepages() on invalidated mapping.
  So in my opinion everybody calling __writeback_single_inode() and thus
__sync_single_inode() should do an equivalent of igrab() or be sure inode
cannot be freed e.g. because we have a file open.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
