Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbZIVMr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbZIVMr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 08:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756092AbZIVMrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 08:47:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:30636 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755994AbZIVMrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 08:47:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,431,1249282800"; 
   d="scan'208";a="190291702"
Date: Tue, 22 Sep 2009 20:47:14 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Chris Mason <chris.mason@oracle.com>, Theodore Tso <tytso@mit.edu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7] Per-bdi writeback flusher threads v20
Message-ID: <20090922124714.GA7675@localhost>
References: <20090911142926.GI14984@kernel.dk> <20090911143929.GA25499@localhost> <20090918175252.GF26991@mit.edu> <20090919035835.GA9921@localhost> <20090919040051.GA10245@localhost> <20090919042607.GA19752@localhost> <20090921135321.GD6259@think> <20090922101335.GA27432@localhost> <20090922113055.GI10825@think> <20090922114537.GB13887@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090922114537.GB13887@duck.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 07:45:37PM +0800, Jan Kara wrote:
> On Tue 22-09-09 07:30:55, Chris Mason wrote:
> > > Yes a more general solution would help. I'd like to propose one which
> > > works in the other way round. In brief,
> > > (1) the VFS give a large enough per-file writeback quota to btrfs;
> > > (2) btrfs tells VFS "here is a (seek) boundary, stop voluntarily",
> > >     before exhausting the quota and be force stopped.
> > > 
> > > There will be two limits (the second one is new):
> > > 
> > > - total nr to write in one wb_writeback invocation
> > > - _max_ nr to write per file (before switching to sync the next inode)
> > > 
> > > The per-invocation limit is useful for balance_dirty_pages().
> > > The per-file number can be accumulated across successive wb_writeback
> > > invocations and thus can be much larger (eg. 128MB) than the legacy
> > > per-invocation number. 
> > > 
> > > The file system will only see the per-file numbers. The "max" means
> > > if btrfs find the current page to be the last page in the extent,
> > > it could indicate this fact to VFS by setting wbc->would_seek=1. The
> > > VFS will then switch to write the next inode.
> > > 
> > > The benefit of early voluntarily yield is, it reduced the possibility
> > > to be force stopped half way in an extent. When next time VFS returns
> > > to sync this inode, it will again be honored the full 128MB quota,
> > > which should be enough to cover a big fresh extent.
> > 
> > This is interesting, but it gets into a problem with defining what a
> > seek is.  On some hardware they are very fast and don't hurt at all.  It

The hardware capability could be reported in the bdi?

> > might be more interesting to make timeslices.
>   With simple timeslices there's a problem that the time it takes to submit
> an IO isn't really related to the time it takes to complete the IO.  During
> submission we are limited just by availablity of free requests and sizes of
> request queues (which might be filled by another thread or by us writing
> different inode).

Right. When queue is congested, the submission time will be correlated
with (someone else's) completion time. So it is still necessary to
have a quota of submission time to prevent one single inode takes too
much sync (submission) time.

>   But as I described in my other email, we could probably estimate time it
> takes to complete the IO. At least CFQ keeps statistics needed for that. If
> we somehow generalized them and put them into BDI, we could probably use
> them during writeback...

As for randomness, I think write_cache_pages() could get a good
estimation by counting the number of page segments it put to io
for a single inode, without going for the block layer. 

Thanks,
Fengguang
