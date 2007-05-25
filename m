Return-Path: <linux-kernel-owner+w=401wt.eu-S1755485AbXEYHRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbXEYHRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 03:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbXEYHRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 03:17:18 -0400
Received: from brick.kernel.dk ([80.160.20.94]:25285 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbXEYHRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 03:17:17 -0400
Date: Fri, 25 May 2007 09:14:20 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: filesystem benchmarking fun
Message-ID: <20070525071420.GL7653@kernel.dk>
References: <20070516112515.b6f247b2.akpm@linux-foundation.org> <20070516191339.GA26766@think.oraclecorp.com> <20070516123342.714a11d8.akpm@linux-foundation.org> <20070516195359.GE26766@think.oraclecorp.com> <20070516130413.1fd391bf.akpm@linux-foundation.org> <20070516201414.GF26766@think.oraclecorp.com> <20070516133726.0c68a65f.akpm@linux-foundation.org> <20070522163511.GB6138@think.oraclecorp.com> <20070522112120.4a5c6a5d.akpm@linux-foundation.org> <20070522212524.GD11166@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070522212524.GD11166@waste.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22 2007, Matt Mackall wrote:
> On Tue, May 22, 2007 at 11:21:20AM -0700, Andrew Morton wrote:
> > On Tue, 22 May 2007 12:35:11 -0400
> > Chris Mason <chris.mason@oracle.com> wrote:
> > 
> > > On Wed, May 16, 2007 at 01:37:26PM -0700, Andrew Morton wrote:
> > > > On Wed, 16 May 2007 16:14:14 -0400
> > > > Chris Mason <chris.mason@oracle.com> wrote:
> > > > 
> > > > > On Wed, May 16, 2007 at 01:04:13PM -0700, Andrew Morton wrote:
> > > > > > > The good news is that if you let it run long enough, the times
> > > > > > > stabilize.  The bad news is:
> > > > > > > 
> > > > > > > create dir kernel-86 222MB in 15.85 seconds (14.03 MB/s)
> > > > > > > create dir kernel-87 222MB in 28.67 seconds (7.76 MB/s)
> > > > > > > create dir kernel-88 222MB in 18.12 seconds (12.27 MB/s)
> > > > > > > create dir kernel-89 222MB in 19.77 seconds (11.25 MB/s)
> > > > > > 
> > > > > > well hang on.  Doesn't this just mean that the first few runs were writing
> > > > > > into pagecache and the later ones were blocking due to dirty-memory limits?
> > > > > > 
> > > > > > Or do you have a sync in there?
> > > > > > 
> > > > > There's no sync,  but if you watch vmstat you can clearly see the log
> > > > > flushes, even when the overall create times are 11MB/s.  vmstat goes
> > > > > 30MB/s -> 4MB/s or less, then back up to 30MB/s.
> > > > 
> > > > How do you know that it is a log flush rather than, say, pdflush
> > > > hitting the blockdev inode and doing a big seeky write?
> > > 
> > > Ok, I did some more work to split out the two cases (block device inode
> > > writeback and log flushing).
> > > 
> > > I patched jbd's log_do_checkpoint to put all the blocks it wanted to
> > > write in a radix tree, then send them all down in order at the end.
> > 
> > Side note: we already have all of that capability in the kernel:
> > sync_inode(blockdev_inode, wbc) will do an ascending-LBA write of the whole
> > blockdev.
> 
> Why don't we simply plug the queue, do all the writes, and let the I/O
> scheduler sort it out instead?

The data set is too huge for that to work, even if you increased
nr_requests to some huuuge number.

-- 
Jens Axboe

