Return-Path: <linux-kernel-owner+w=401wt.eu-S935115AbXEVSY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935115AbXEVSY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 14:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758796AbXEVSYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 14:24:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36078 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759355AbXEVSX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 14:23:59 -0400
Date: Tue, 22 May 2007 11:21:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: filesystem benchmarking fun
Message-Id: <20070522112120.4a5c6a5d.akpm@linux-foundation.org>
In-Reply-To: <20070522163511.GB6138@think.oraclecorp.com>
References: <20070516144205.GV26766@think.oraclecorp.com>
	<464B2AC2.10206@redhat.com>
	<20070516171156.GY26766@think.oraclecorp.com>
	<20070516112515.b6f247b2.akpm@linux-foundation.org>
	<20070516191339.GA26766@think.oraclecorp.com>
	<20070516123342.714a11d8.akpm@linux-foundation.org>
	<20070516195359.GE26766@think.oraclecorp.com>
	<20070516130413.1fd391bf.akpm@linux-foundation.org>
	<20070516201414.GF26766@think.oraclecorp.com>
	<20070516133726.0c68a65f.akpm@linux-foundation.org>
	<20070522163511.GB6138@think.oraclecorp.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007 12:35:11 -0400
Chris Mason <chris.mason@oracle.com> wrote:

> On Wed, May 16, 2007 at 01:37:26PM -0700, Andrew Morton wrote:
> > On Wed, 16 May 2007 16:14:14 -0400
> > Chris Mason <chris.mason@oracle.com> wrote:
> > 
> > > On Wed, May 16, 2007 at 01:04:13PM -0700, Andrew Morton wrote:
> > > > > The good news is that if you let it run long enough, the times
> > > > > stabilize.  The bad news is:
> > > > > 
> > > > > create dir kernel-86 222MB in 15.85 seconds (14.03 MB/s)
> > > > > create dir kernel-87 222MB in 28.67 seconds (7.76 MB/s)
> > > > > create dir kernel-88 222MB in 18.12 seconds (12.27 MB/s)
> > > > > create dir kernel-89 222MB in 19.77 seconds (11.25 MB/s)
> > > > 
> > > > well hang on.  Doesn't this just mean that the first few runs were writing
> > > > into pagecache and the later ones were blocking due to dirty-memory limits?
> > > > 
> > > > Or do you have a sync in there?
> > > > 
> > > There's no sync,  but if you watch vmstat you can clearly see the log
> > > flushes, even when the overall create times are 11MB/s.  vmstat goes
> > > 30MB/s -> 4MB/s or less, then back up to 30MB/s.
> > 
> > How do you know that it is a log flush rather than, say, pdflush
> > hitting the blockdev inode and doing a big seeky write?
> 
> Ok, I did some more work to split out the two cases (block device inode
> writeback and log flushing).
> 
> I patched jbd's log_do_checkpoint to put all the blocks it wanted to
> write in a radix tree, then send them all down in order at the end.

Side note: we already have all of that capability in the kernel:
sync_inode(blockdev_inode, wbc) will do an ascending-LBA write of the whole
blockdev.

It could be that as a quick diddle, running sync_inode() in
do-block-on-queue-congestion mode prior to doing the checkpoint would have
some benefit.

> The elevator should be helping here, but jbd is sending down 2,000
> to 3,000 blocks during the checkpoint and upping nr_requests alone
> didn't seem to be doing the trick.
> 
> Unpatched ext3 would break down into seeks after 8 kernel trees are
> created (222MB each).  With the radix sorting, the first 15 kernel trees
> are created quickly, and then we slow down.
> 
> So I waited until around the 25th kernel tree was created, hit ctrl-c
> and ran sync.  vmstat showed writes going at 2MB/s, and sysrq-w showed
> sync was running the block device inode for most of the 2MB/s period.
> 
> It looks as though the dirty pages on the block device inode are spread
> out far enough that we're not getting good streaming writes.  Mark
> Fasheh ran on a bigger raid array, where performance was consistently
> good for the whole run.  I'm assuming the larger write cache on the
> array was able to group the data writes with the metadata on disk, while
> my poor little sata drive wasn't.  Dave Chinner hinted that xfs is
> probably suffering a similar problem, which is usually fixed by backing
> the FS with stripes and big raid.
> 
> My vaporware FS is able to maintain speed through the run because the
> allocator tries to keep data and metadata grouped into 256mb chunks,
> and so they don't end up mingling on disk until things get full.
> 
> At any rate, it may be worth putzing with the writeback routines to try
> and find dirty pages close by in the block dev inode when doing data
> writeback.  My guess is that ext3 should be going 1.5x to 2x faster for
> this particular run, but that's a huge amount of complexity added so I'm
> not convinced it is a great idea.

Yes, this is a distinct disadvantage of the whole per-address-space
writeback scheme - we're leaving IO scheduling optimisations on the floor,
especially wrt the blockdev inode, but probably also wrt regular-file
versus regular-file.  Even if one makes the request queue tremendously
huge, that won't help if there's dirty data close-by the disk head which
hasn't even been put into the queue yet.

