Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbZIVLcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbZIVLcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 07:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755988AbZIVLcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 07:32:08 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:18070 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171AbZIVLcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 07:32:01 -0400
Date: Tue, 22 Sep 2009 07:30:55 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "jack@suse.cz" <jack@suse.cz>
Subject: Re: [PATCH 0/7] Per-bdi writeback flusher threads v20
Message-ID: <20090922113055.GI10825@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Wu Fengguang <fengguang.wu@intel.com>, Theodore Tso <tytso@mit.edu>,
	Jens Axboe <jens.axboe@oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"jack@suse.cz" <jack@suse.cz>
References: <20090911134241.GB19707@mit.edu>
 <20090911141659.GA3508@infradead.org>
 <20090911142926.GI14984@kernel.dk>
 <20090911143929.GA25499@localhost>
 <20090918175252.GF26991@mit.edu>
 <20090919035835.GA9921@localhost>
 <20090919040051.GA10245@localhost>
 <20090919042607.GA19752@localhost>
 <20090921135321.GD6259@think>
 <20090922101335.GA27432@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090922101335.GA27432@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt005.oracle.com [141.146.116.14]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4AB8B573.018D:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 06:13:35PM +0800, Wu Fengguang wrote:
> On Mon, Sep 21, 2009 at 09:53:21PM +0800, Chris Mason wrote:
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
> > 
> > I'm starting to rethink the 128MB MAX_WRITEBACK_PAGES.  128MB is the
> > right answer for the flusher thread on sequential IO, but definitely not
> > on random IO.  We don't want the flusher to get bogged down on random
> > writeback and start ignoring every other file.
> 
> Hmm, I'd think a larger MAX_WRITEBACK_PAGES shall never increase the
> writeback randomness.

It doesn't increase the randomness, but if we have a file full of
buffered random IO (say from bdb or rpm), the 128MB max will mean that
one file dominates the flusher thread writeback completely.

> 
> > My btrfs performance branch has long had a change to bump the
> > nr_to_write up based on the size of the delayed allocation that we're
> > doing.  It helped, but not as much as I really expected it too, and a
> > similar patch from Christoph for XFS was good but not great.
> > 
> > It turns out the problem is in write_cache_pages.  It processes a whole
> > pagevec at a time, something like this:
> > 
> > while(!done) {
> > 	for each page in the pagegvec {
> > 		writepage()
> > 		if (wbc->nr_to_write <= 0)
> > 			done = 1;
> > 	}
> > }
> > 
> > If the filesystem decides to bump nr_to_write to cover a whole
> > extent (or a max reasonable size), the new value of nr_to_write may
> > be ignored if nr_to_write had already gone done to zero.
> > 
> > I fixed btrfs to recheck nr_to_write every time, and the results are
> > much smoother.  This is what it looks like to write out all the .o files
> > in the kernel.
> > 
> > http://oss.oracle.com/~mason/seekwatcher/btrfs-nr-to-write.png
> > 
> > In this graph, Btrfs is writing the full extent or 8192 pages, whichever
> > is smaller.  The write_cache_pages change is here, but it is local to
> > the btrfs copy of write_cache_pages:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=commit;h=f85d7d6c8f2ad4a86a1f4f4e3791f36dede2fa76
> 
> It seems you tried to an upper limit of 32-64MB:
> 
> +               if (wbc->nr_to_write < delalloc_to_write) {
> +                       int thresh = 8192;
> +
> +                       if (delalloc_to_write < thresh * 2)
> +                               thresh = delalloc_to_write;
> +                       wbc->nr_to_write = min_t(u64, delalloc_to_write,
> +                                                thresh);
> +               }
> 
> However it is possible that btrfs bumps up nr_to_write for each inode, 
> so that the accumulated bump ups are too large to be acceptable for
> balance_dirty_pages().

We bump up to a limit of 64MB more than the original nr_to_write. This
is because when we do bump we know we'll write the whole amount, and
then write_cache_pages will end.

> 
> And it's not always "bump ups". nr_to_write could be decreased if it's
> already a large value.

Sorry, I don't see where it is decreased.

> 
> > I'd rather see a more formal use of hints from the FS about efficient IO
> > than a blanket increase of the writeback max.  It's more work than
> > bumping a single #define, but even with the #define at 1GB, we're going
> > to end up splitting extents and seeking when nr_to_write does finally
> > get down to zero.
> > 
> > Btrfs currently only bumps the nr_to_write when it creates the extent, I
> > need to change it to also bump it when it finds an existing extent.
> 
> Yes a more general solution would help. I'd like to propose one which
> works in the other way round. In brief,
> (1) the VFS give a large enough per-file writeback quota to btrfs;
> (2) btrfs tells VFS "here is a (seek) boundary, stop voluntarily",
>     before exhausting the quota and be force stopped.
> 
> There will be two limits (the second one is new):
> 
> - total nr to write in one wb_writeback invocation
> - _max_ nr to write per file (before switching to sync the next inode)
> 
> The per-invocation limit is useful for balance_dirty_pages().
> The per-file number can be accumulated across successive wb_writeback
> invocations and thus can be much larger (eg. 128MB) than the legacy
> per-invocation number. 
> 
> The file system will only see the per-file numbers. The "max" means
> if btrfs find the current page to be the last page in the extent,
> it could indicate this fact to VFS by setting wbc->would_seek=1. The
> VFS will then switch to write the next inode.
> 
> The benefit of early voluntarily yield is, it reduced the possibility
> to be force stopped half way in an extent. When next time VFS returns
> to sync this inode, it will again be honored the full 128MB quota,
> which should be enough to cover a big fresh extent.

This is interesting, but it gets into a problem with defining what a
seek is.  On some hardware they are very fast and don't hurt at all.  It
might be more interesting to make timeslices.

-chris

