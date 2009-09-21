Return-Path: <linux-kernel-owner+w=401wt.eu-S1756238AbZIUOMC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbZIUOMC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 10:12:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756214AbZIUOMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 10:12:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:63447 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204AbZIUOL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 10:11:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,424,1249282800"; 
   d="scan'208";a="189889210"
Date: Mon, 21 Sep 2009 22:11:09 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fs: Fix busyloop in wb_writeback()
Message-ID: <20090921141109.GA6479@localhost>
References: <1253121768-20673-1-git-send-email-jack@suse.cz> <20090920023528.GA13114@localhost> <20090920174356.GA16919@duck.suse.cz> <20090921010859.GA6331@localhost> <20090921134511.GG1099@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090921134511.GG1099@duck.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 09:45:11PM +0800, Jan Kara wrote:
> On Mon 21-09-09 09:08:59, Wu Fengguang wrote:
> > On Mon, Sep 21, 2009 at 01:43:56AM +0800, Jan Kara wrote:
> > > On Sun 20-09-09 10:35:28, Wu Fengguang wrote:
> > > > On Thu, Sep 17, 2009 at 01:22:48AM +0800, Jan Kara wrote:
> > > > > If all inodes are under writeback (e.g. in case when there's only one inode
> > > > > with dirty pages), wb_writeback() with WB_SYNC_NONE work basically degrades
> > > > > to busylooping until I_SYNC flags of the inode is cleared. Fix the problem by
> > > > > waiting on I_SYNC flags of an inode on b_more_io list in case we failed to
> > > > > write anything.
> > > > 
> > > > Sorry, I realized that inode_wait_for_writeback() waits for I_SYNC.
> > > > But inodes in b_more_io are not expected to have I_SYNC set. So your
> > > > patch looks like a big no-op?
> > >   Hmm, I don't think so. writeback_single_inode() does:
> > >         if (inode->i_state & I_SYNC) {
> > >                 /*
> > >                  * If this inode is locked for writeback and we are not
> > >                  * doing
> > >                  * writeback-for-data-integrity, move it to b_more_io so
> > >                  * that
> > >                  * writeback can proceed with the other inodes on s_io.
> > >                  *
> > >                  * We'll have another go at writing back this inode when we
> > >                  * completed a full scan of b_io.
> > >                  */
> > >                 if (!wait) {
> > >                         requeue_io(inode);
> > >                         return 0;
> > >                 }
> > > 
> > >   So when we see inode under writeback, we put it to b_more_io. So I think
> > > my patch really fixes the issue when two threads are racing on writing the
> > > same inode.
> > 
> > Ah OK. So it busy loops when there are more syncing threads than dirty
> > files. For example, one bdi flush thread plus one process running
> > balance_dirty_pages().
>   Yes.
> 
> > > > The busy loop does exists, when bdi is congested.
> > > > In this case, write_cache_pages() will refuse to write anything,
> > > > we used to be calling congestion_wait() to take a breath, but now
> > > > wb_writeback() purged that call and thus created a busy loop.
> > >   I don't think congestion is an issue here. The device needen't be
> > > congested for the busyloop to happen.
> > 
> > bdi congestion is a different case. When there are only one syncing
> > thread, b_more_io inodes won't have I_SYNC, so your patch is a no-op.
> > wb_writeback() or any of its sub-routines must wait/yield for a while
> > to avoid busy looping on the congestion. Where is the wait with Jens'
> > new code?
>   I agree someone must wait when we bail out due to congestion. But we bail
> out only when wbc->nonblocking is set.

Here is another problem. wbc->nonblocking used to be set for kupdate
and background writebacks, but now it's gone. So they will be blocked
in get_request_wait(). That's fine, no busy loops.

However this inverts the priority. pageout() still have nonblocking=1.
So now vmscan can easily be live locked by heavy background writebacks.

Even though pageout() is inefficient and discouraged, it could be even
more disastrous to livelock vmscan.

Jens, I'd recommend to restore the nonblocking bits for this merge
window. The per-bdi patches are such a big change, it's not a good
time to piggy back more unrelated behavior changes.. I could submit
patches to revert the nonblocking and congestion wait bits.

> So I'd feel that callers setting this flag should handle it when we
> stop the writeback due to congestion.

Hmm, but we never stop writeback and return to caller on congestion :)
Instead wb_writeback() will retry in loops. And it doesn't make sense
to add duplicate retry loops in the callers.

> > Another question is, why wbc.more_io can be ignored for kupdate syncs?
> > I guess it would lead to slow writeback of large files.
> > 
> > This patch reflects my concerns on the two problems.
> > 
> > Thanks,
> > Fengguang
> > ---
> >  fs/fs-writeback.c |    6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > --- linux.orig/fs/fs-writeback.c	2009-09-20 10:44:25.000000000 +0800
> > +++ linux/fs/fs-writeback.c	2009-09-21 08:53:09.000000000 +0800
> > @@ -818,8 +818,10 @@ static long wb_writeback(struct bdi_writ
> >  		/*
> >  		 * If we ran out of stuff to write, bail unless more_io got set
> >  		 */
> > -		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
> > -			if (wbc.more_io && !wbc.for_kupdate)
> > +		if (wbc.nr_to_write > 0) {
> > +			if (wbc.encountered_congestion)
> > +				congestion_wait(BLK_RW_ASYNC, HZ);
> > +			if (wbc.more_io)
> >  				continue;
> >  			break;
> >  		}
>   OK, this change looks reasonable but I think we'll have to revisit
> the writeback logic more in detail as we discussed in the other thread.

OK, and to check how exactly it should be combined with your patch.

Thanks,
Fengguang
