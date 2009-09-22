Return-Path: <linux-kernel-owner+w=401wt.eu-S1756999AbZIVRmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbZIVRmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 13:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751050AbZIVRmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 13:42:47 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:59994 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195AbZIVRmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 13:42:24 -0400
Date: Tue, 22 Sep 2009 13:41:28 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Theodore Tso <tytso@mit.edu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7] Per-bdi writeback flusher threads v20
Message-ID: <20090922174128.GO10825@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>,
	Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>
References: <20090911142926.GI14984@kernel.dk>
 <20090911143929.GA25499@localhost>
 <20090918175252.GF26991@mit.edu>
 <20090919035835.GA9921@localhost>
 <20090919040051.GA10245@localhost>
 <20090919042607.GA19752@localhost>
 <20090921135321.GD6259@think>
 <20090922101335.GA27432@localhost>
 <20090922113055.GI10825@think>
 <20090922114537.GB13887@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090922114537.GB13887@duck.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt012.oracle.com [141.146.116.21]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4AB90C4C.0022:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 01:45:37PM +0200, Jan Kara wrote:
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
> > might be more interesting to make timeslices.
>   With simple timeslices there's a problem that the time it takes to submit
> an IO isn't really related to the time it takes to complete the IO.  During
> submission we are limited just by availablity of free requests and sizes of
> request queues (which might be filled by another thread or by us writing
> different inode).

Well, what we have right now works like this:

A process writes N pages out (effectively only waiting for requests).
If those N pages were all from the same file, we move to a different
file because we don't want all the other files to get too old.

If that process is in balance_dirty_pages(), after it writes N pages, it
immediately goes back to making dirty pages.  If it wasn't able to write
N pages, it sleeps for a bit and starts over.

This is a long way of saying the time it takes to complete the IO isn't
currently factored in at all.  The only place we check for this is the
code to prevent balance_dirty_pages() from emptying the dirty list.

I think what we need for the bdi threads is a way to say: only service
this file for a given duration, then move on to the others.  The
filesystem should have a way to extend the duration slightly so that we
write big chunks of big extents.

What we need for balance_dirty_pages is a way to say: just wait for the
writeback to make progress (you had ideas on this already in the past).

Jens had ideas on all of this too, but I'd hope we can do it without
trying it to cfq.

-chris

