Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbZIUMmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbZIUMmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 08:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbZIUMmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 08:42:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47443 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbZIUMmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 08:42:49 -0400
Date: Mon, 21 Sep 2009 14:42:51 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7] Per-bdi writeback flusher threads v20
Message-ID: <20090921124251.GD1099@duck.suse.cz>
References: <20090911141659.GA3508@infradead.org> <20090911142926.GI14984@kernel.dk> <20090911143929.GA25499@localhost> <20090918175252.GF26991@mit.edu> <20090919035835.GA9921@localhost> <20090919040051.GA10245@localhost> <20090919042607.GA19752@localhost> <20090919150351.GA19880@localhost> <20090920190006.GD16919@duck.suse.cz> <20090921030402.GC6331@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090921030402.GC6331@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 21-09-09 11:04:02, Wu Fengguang wrote:
> On Mon, Sep 21, 2009 at 03:00:06AM +0800, Jan Kara wrote:
> > On Sat 19-09-09 23:03:51, Wu Fengguang wrote:
...
> >   Fenguang, could we maybe write down how the logic should look like
> > and then look at the code and modify it as needed to fit the logic?
> > Because I couldn't find a compact description of the logic anywhere
> > in the code.
> 
> Good idea. It makes sense to write something down in Documentation/
> or embedded as code comments.
  Yes, that would be useful. I'd probably vote for comments in the code.

> >   Here is how I'd imaging the writeout logic should work:
> > We would have just two lists - b_dirty and b_more_io. Both would be
> > ordered by dirtied_when.
> 
> Andrew has a very good description for the dirty/io/more_io queues:
> 
> http://lkml.org/lkml/2006/2/7/5
> 
> | So the protocol would be:
> |
> | s_io: contains expired and non-expired dirty inodes, with expired ones at
> | the head.  Unexpired ones (at least) are in time order.
> |
> | s_more_io: contains dirty expired inodes which haven't been fully written. 
> | Ordering doesn't matter (unless someone goes and changes
> | dirty_expire_centisecs - but as long as we don't do anything really bad in
> | response to this we'll be OK).
> |
> | s_dirty: contains expired and non-expired dirty inodes.  The non-expired
> | ones are in time-of-dirtying order.
> 
> Since then s_io was changed to hold only _expired_ dirty inodes at the
> beginning of a full scan. It serves as a bounded set of dirty inodes.
> So that when finished a full scan of it, the writeback can go on to
> the next superblock, and old dirty files' writeback won't be delayed
> infinitely by poring in newly dirty files.
> 
> It seems that the boundary could also be provided by some
> older_than_this timestamp. So removal of b_io is possible
> at least on this purpose.
> 
> >   A thread doing WB_SYNC_ALL writeback will just walk the list and cleanup
> > everything (we should be resistant against livelocks because we stop at
> > inode which has been dirtied after the sync has started).
> 
> Yes, that would mean
> 
> - older_than_this=now     for WB_SYNC_ALL
> - older_than_this=now-30s for WB_SYNC_NONE
  Exactly.

> >   A thread doing WB_SYNC_NONE writeback will start walking the list. If the
> > inode has I_SYNC set, it puts it on b_more_io. Otherwise it takes I_SYNC
> > and writes as much as it finds necessary from the first inode. If it
> > stopped before it wrote everything, it puts the inode at the end of
> > b_more_io.
> 
> Agreed. The current code is doing that, and it is reasonably easy to
> reuse the code path for WB_SYNC_NONE/WB_SYNC_ALL?
  I'm not sure we do exactly that. The I_SYNC part is fine. But looking at
the code in writeback_single_inode(), we put inode at b_more_io only if
wbc->for_kupdate is true and wbc->nr_to_write is <= 0. Otherwise we put the
inode at the tail of dirty list.

> > If it wrote everything (writeback_index cycled or scanned the
> > whole range) but inode is dirty, it puts the inode at the end of b_dirty
> > and resets dirtied_when to the current time. Then it continues with the
> > next inode.
> 
> Agreed. I think it makes sense to reset dirtied_when (thus delay 30s)
> if an inode still has dirty pages when we have finished a full scan of
> it, in order to
> - prevent pointless writeback IO of overwritten pages
> - somehow throttle IO for busy inodes
  OK, but currently the logic is subtly different. It does:
If the inode wasn't redirtied during writeback and still has dirty pages,
queue somewhere (requeue_io or redirty_tail depending on other things).
If the inode was redirtied, do redirty_tail.
  Probably, the current logic is safer in the sence that kupdate-style
writeback cannot take forever when inode is permanently redirtied. In my
proposed logic, kupdate writeback would run forever (which makes some
sence as well but probably isn't really convenient).
  Also if we skip some pages (call redirty_page_for_writepage()) the inode
will get redirtied as well and hence we'll put the inode at the back of
dirty list and thus delaying further writeback by 30s. Again, this makes
some sence (prevents busyloop waiting for a page to get prepared for a
proper writeback) although I'm not sure it's always desirable. For now
we should probably just document this somewhere.

> >   kupdate style writeback stops scanning dirty list when dirtied_when is
> > new enough. Then if b_more_io is nonempty, it splices it into the beginning
> > of the dirty list and restarts.
> 
> Right.
  But currently, we don't do the splicing. We just set more_io and return
from writeback_inodes_wb(). Should that be changed?

> >   Other types of writeback splice b_more_io to b_dirty when b_dirty gets
> > empty. pdflush style writeback writes until we drop below background dirty
> > limit. Other kinds of writeback (throttled threads, writeback submitted by
> > filesystem itself) write while nr_to_write > 0.
> 
> I'd propose to always check older_than_this. For non-kupdate sync, it
> still makes sense to give some priority to expired inodes (generally
> it's suboptimal to sync those dirtied-just-now inodes). That is, to
> sync expired inodes first if there are any.
  Well, the expired inodes are handled with priority because they are at
the beginning of the list. So we write them first and only if writing them
was not enough, we proceed with inodes that were dirtied later. You are
right that we can get to later dirtied inodes even if there are still dirty
data in the old ones because we just refuse to write too much from a single
inode. So maybe it would be good to splice b_more_io to b_dirty already
when we get to unexpired inode in b_dirty list. The good thing is it won't
livelock on a few expired inodes even in the case new data are written to
one of them while we work on the others - the other inodes on s_dirty list
will eventually expire and from that moment on, we include them in a fair
pdflush writeback.

> >   If we didn't write anything during the b_dirty scan, we wait until I_SYNC
> > of the first inode on b_more_io gets cleared before starting the next scan.
> >   Does this look reasonably complete and cover all the cases?
> 
> What about the congested case?
  With per-bdi threads, we just have to make sure we don't busyloop when
the device is congested. Just blocking is perfectly fine since the thread
has nothing to do anyway. The question is how normal processes that are
forced to do writeback or page allocation doing writeback should behave.
There probably it makes sence to bail out from the writeback and let the
caller decide. That seems to be implemented by the current code just fine
but you are right I forgot about it. Probably, we should just splice
b_more_io to b_dirty list before bailing out because of congestion...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
