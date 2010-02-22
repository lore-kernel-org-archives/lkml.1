Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab0BVW0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 17:26:41 -0500
Received: from cantor.suse.de ([195.135.220.2]:52350 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687Ab0BVW0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 17:26:40 -0500
Date: Mon, 22 Feb 2010 23:26:47 +0100
From: Jan Kara <jack@suse.cz>
To: tytso@mit.edu
Cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jengelh@medozas.de,
       stable@kernel.org, gregkh@suse.de
Subject: Re: [PATCH] writeback: Fix broken sync writeback
Message-ID: <20100222222647.GC3112@quack.suse.cz>
References: <20100215141750.GC3434@quack.suse.cz>
 <alpine.LFD.2.00.1002151601360.18830@localhost.localdomain>
 <20100216230017.GJ3153@quack.suse.cz>
 <alpine.LFD.2.00.1002161524210.4141@localhost.localdomain>
 <20100217013336.GK3153@quack.suse.cz>
 <alpine.LFD.2.00.1002161848370.4141@localhost.localdomain>
 <20100217043009.GZ5337@thunk.org>
 <alpine.LFD.2.00.1002162052230.4141@localhost.localdomain>
 <20100222172938.GA2601@quack.suse.cz>
 <20100222210112.GE23832@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100222210112.GE23832@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 22-02-10 16:01:12, tytso@mit.edu wrote:
> On Mon, Feb 22, 2010 at 06:29:38PM +0100, Jan Kara wrote:
> > 
> > a) ext4_da_writepages returns after writing 32 MB even in WB_SYNC_ALL mode
> > (when 1024 is passed in nr_to_write). Writeback code kind of expects that
> > in WB_SYNC_ALL mode all dirty pages in the given range are written (the
> > same way as write_cache_pages does that).
> 
> Well, we return after writing 128MB because of the magic
  I think it's really just 32 MB because writeback code passes nr_to_write
1024 -> ext4 bumps that to 8192 pages which is 32 MB. As I've understood
128 MB is just an absolute maximum over which we never bump.

> s_max_writeback_mb_bump.  The fact that nr_to_write limits the number
> of pages which are written is something which is intentional to the
> writeback code.  I've disagreed with it, but I don't think it would be
> legit to completely ignore nr_to_write in WB_SYNC_ALL mode --- is that
> what you are saying we should do?  (If it is indeed legit to ignore
  The behavior of nr_to_write for WB_SYNC_ALL mode was always kind of
fuzzy. Until Jens rewrote the writeback code, we never passed anything
different than LONG_MAX (or similarly huge values) when doing WB_SYNC_ALL
writeback. Also write_cache_pages which is used as writepages
implementation for most filesystems (ext2, ext3, udf, ...) ignores
nr_to_write for WB_SYNC_ALL writeback. So until recently we actually never
had to decide whether write_cache_pages behavior is a bug or de-facto
standard...
  Since it's hard to avoid livelocking problems when synchronous writeback
would stop earlier than after writing the whole range, I'm leaned to
standardize on ignoring the nr_to_write limit for synchronous writeback.

> nr_to_write, I would have done it a long time ago; I introduced
> s_max_writeback_mb_bump instead as a workaround to what I consider to
> be a serious misfeature in the writeback code.)
  I agree that nr_to_write currently brings more problems than advantages.

> > b) because of delayed allocation, inode is redirtied during ->writepages
> > call and thus writeback_single_inode calls redirty_tail at it. Thus each
> > inode will be written at least twice (synchronously, which means a
> > transaction commit and a disk cache flush for each such write).
> 
> Hmm, does this happen with XFS, too?  If not, I wonder how they handle
> it?  And whether we need to push a solution into the generic layers.
  Yes, I think so. As soon as you mark inode dirty during writepages
call, the dirty flag won't be cleared even though ->write_inode will be
called after that. So a right fix would IMO be to move clearing of
I_DIRTY_SYNC and I_DIRTY_DATASYNC flag after the writepages call. Or we
could even put some dirty bit handling inside of ->write_inode because
sometimes it would be useful if a filesystem would know in its
->write_inode method what dirty bits were set...
  Another thing is that in particular in ext[34] case, we would be much
better off with submitting all the inode writes and then waiting just once.
This is actually what should usually happen because sync calls asynchronous
writeback first and only after it a synchronous one is called. But when
the machine is under a constant IO load and the livelock avoidance code
is invalidated by passing nr_to_write == 1024 to sync writeback, we end up
doing a lot of sync IO and thus this problem becomes much more visible.

> > d) ext4_writepage never succeeds to write a page with delayed-allocated
> > data. So pageout() function never succeeds in cleaning a page on ext4.
> > I think that when other problems in writeback code make writeout slow (like
> > in Jan Engelhardt's case), this can bite us and I assume this might be the
> > reason why Jan saw kswapd active doing some work during his problems.
> 
> Yeah, I've noticed this.  What it means is that if we have a massive
> memory pressure in a particular zone, pages which are subject to
> delayed allocation won't get written out by mm/vmscan.c.  Anonymous
> pages will be written out to swap, and data pages which are re-written
> via random access mmap() (and so we know where they will be written on
> disk) will get written, and that's not a problem.  So with relatively
> large zones, it happens, but most of the time I don't think it's a
> major problem.
  Yes, I also don't think it's a major problem in common scenarios.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
