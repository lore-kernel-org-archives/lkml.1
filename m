Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbZIUDEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbZIUDEN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 23:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966AbZIUDEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 23:04:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:63366 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889AbZIUDEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 23:04:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,421,1249282800"; 
   d="scan'208";a="189732125"
Date: Mon, 21 Sep 2009 11:04:02 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7] Per-bdi writeback flusher threads v20
Message-ID: <20090921030402.GC6331@localhost>
References: <20090911134241.GB19707@mit.edu> <20090911141659.GA3508@infradead.org> <20090911142926.GI14984@kernel.dk> <20090911143929.GA25499@localhost> <20090918175252.GF26991@mit.edu> <20090919035835.GA9921@localhost> <20090919040051.GA10245@localhost> <20090919042607.GA19752@localhost> <20090919150351.GA19880@localhost> <20090920190006.GD16919@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090920190006.GD16919@duck.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 03:00:06AM +0800, Jan Kara wrote:
> On Sat 19-09-09 23:03:51, Wu Fengguang wrote:
> > On Sat, Sep 19, 2009 at 12:26:07PM +0800, Wu Fengguang wrote:
> > > On Sat, Sep 19, 2009 at 12:00:51PM +0800, Wu Fengguang wrote:
> > > > On Sat, Sep 19, 2009 at 11:58:35AM +0800, Wu Fengguang wrote:
> > > > > On Sat, Sep 19, 2009 at 01:52:52AM +0800, Theodore Tso wrote:
> > > > > > On Fri, Sep 11, 2009 at 10:39:29PM +0800, Wu Fengguang wrote:
> > > > > > > 
> > > > > > > That would be good. Sorry for the late work. I'll allocate some time
> > > > > > > in mid next week to help review and benchmark recent writeback works,
> > > > > > > and hope to get things done in this merge window.
> > > > > > 
> > > > > > Did you have some chance to get more work done on the your writeback
> > > > > > patches?
> > > > > 
> > > > > Sorry for the delay, I'm now testing the patches with commands
> > > > > 
> > > > >  cp /dev/zero /mnt/test/zero0 &
> > > > >  dd if=/dev/zero of=/mnt/test/zero1 &
> > > > > 
> > > > > and the attached debug patch.
> > > > > 
> > > > > One problem I found with ext3/4 is, redirty_tail() is called repeatedly
> > > > > in the traces, which could slow down the inode writeback significantly.
> > > > 
> > > > FYI, it's this redirty_tail() called in writeback_single_inode():
> > > > 
> > > >                         /*
> > > >                          * Someone redirtied the inode while were writing back
> > > >                          * the pages.
> > > >                          */
> > > >                         redirty_tail(inode);
> > > 
> > > Hmm, this looks like an old fashioned problem get blew up by the
> > > 128MB MAX_WRITEBACK_PAGES.
> > > 
> > > The inode was redirtied by the busy cp/dd processes. Now it takes much
> > > more time to sync 128MB, so that a heavy dirtier can easily redirty
> > > the inode in that time window.
> > > 
> > > One single invocation of redirty_tail() could hold up the writeback of
> > > current inode for up to 30 seconds.
> > 
> > It seems that this patch helps. However I'm afraid it's too late to
> > risk merging such kind of patches now..
>   Fenguang, could we maybe write down how the logic should look like
> and then look at the code and modify it as needed to fit the logic?
> Because I couldn't find a compact description of the logic anywhere
> in the code.

Good idea. It makes sense to write something down in Documentation/
or embedded as code comments.

>   Here is how I'd imaging the writeout logic should work:
> We would have just two lists - b_dirty and b_more_io. Both would be
> ordered by dirtied_when.

Andrew has a very good description for the dirty/io/more_io queues:

http://lkml.org/lkml/2006/2/7/5

| So the protocol would be:
|
| s_io: contains expired and non-expired dirty inodes, with expired ones at
| the head.  Unexpired ones (at least) are in time order.
|
| s_more_io: contains dirty expired inodes which haven't been fully written. 
| Ordering doesn't matter (unless someone goes and changes
| dirty_expire_centisecs - but as long as we don't do anything really bad in
| response to this we'll be OK).
|
| s_dirty: contains expired and non-expired dirty inodes.  The non-expired
| ones are in time-of-dirtying order.

Since then s_io was changed to hold only _expired_ dirty inodes at the
beginning of a full scan. It serves as a bounded set of dirty inodes.
So that when finished a full scan of it, the writeback can go on to
the next superblock, and old dirty files' writeback won't be delayed
infinitely by poring in newly dirty files.

It seems that the boundary could also be provided by some
older_than_this timestamp. So removal of b_io is possible
at least on this purpose.

>   A thread doing WB_SYNC_ALL writeback will just walk the list and cleanup
> everything (we should be resistant against livelocks because we stop at
> inode which has been dirtied after the sync has started).

Yes, that would mean

- older_than_this=now     for WB_SYNC_ALL
- older_than_this=now-30s for WB_SYNC_NONE

>   A thread doing WB_SYNC_NONE writeback will start walking the list. If the
> inode has I_SYNC set, it puts it on b_more_io. Otherwise it takes I_SYNC
> and writes as much as it finds necessary from the first inode. If it
> stopped before it wrote everything, it puts the inode at the end of
> b_more_io.

Agreed. The current code is doing that, and it is reasonably easy to
reuse the code path for WB_SYNC_NONE/WB_SYNC_ALL?

> If it wrote everything (writeback_index cycled or scanned the
> whole range) but inode is dirty, it puts the inode at the end of b_dirty
> and resets dirtied_when to the current time. Then it continues with the
> next inode.

Agreed. I think it makes sense to reset dirtied_when (thus delay 30s)
if an inode still has dirty pages when we have finished a full scan of
it, in order to
- prevent pointless writeback IO of overwritten pages
- somehow throttle IO for busy inodes

>   kupdate style writeback stops scanning dirty list when dirtied_when is
> new enough. Then if b_more_io is nonempty, it splices it into the beginning
> of the dirty list and restarts.

Right.

>   Other types of writeback splice b_more_io to b_dirty when b_dirty gets
> empty. pdflush style writeback writes until we drop below background dirty
> limit. Other kinds of writeback (throttled threads, writeback submitted by
> filesystem itself) write while nr_to_write > 0.

I'd propose to always check older_than_this. For non-kupdate sync, it
still makes sense to give some priority to expired inodes (generally
it's suboptimal to sync those dirtied-just-now inodes). That is, to
sync expired inodes first if there are any.

>   If we didn't write anything during the b_dirty scan, we wait until I_SYNC
> of the first inode on b_more_io gets cleared before starting the next scan.
>   Does this look reasonably complete and cover all the cases?

What about the congested case?

Thanks,
Fengguang
