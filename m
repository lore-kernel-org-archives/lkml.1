Return-Path: <linux-kernel-owner+w=401wt.eu-S1751422AbZJCGLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbZJCGLW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 02:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750756AbZJCGLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 02:11:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:23979 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbZJCGLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 02:11:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,499,1249282800"; 
   d="scan'208";a="194672781"
Date: Sat, 3 Oct 2009 14:10:44 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: regression in page writeback
Message-ID: <20091003061044.GA3791@localhost>
References: <20090928071507.GA20068@localhost> <20090928130804.GA25880@infradead.org> <20090928140756.GC17514@mit.edu> <20090930052657.GA17268@localhost> <20090930141158.GG24383@mit.edu> <20091001151429.GB9469@localhost> <20091001215438.GY24383@mit.edu> <20091002025502.GA14246@localhost> <20091002081953.GA14529@localhost> <20091002172620.GB8161@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091002172620.GB8161@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 03, 2009 at 01:26:20AM +0800, Theodore Ts'o wrote:
> On Fri, Oct 02, 2009 at 04:19:53PM +0800, Wu Fengguang wrote:
> > > > The big writes, if they are contiguous, could take 1-2 seconds
> > > > on a very slow, ancient laptop disk, and that will hold up any kind of 
> > > > small synchornous activities --- such as either a disk read or a firefox-
> > > > triggered fsync().
> > > 
> > > Yes, that's a problem. The SYNC/ASYNC elevator queues can help here.
> 
> The SYNC/ASYNC queues will partially help, up to the whatever the
> largest I/O that can issued as a single chunk times the queue depth
> for those disks that support NCQ. 
> 
> > > There's still the problem of IO submission time != IO completion time,
> > > due to fluctuations of randomness and more. However that's a general
> > > and unavoidable problem.  Both the wbc.timeout scheme and the
> > > "wbc.nr_to_write based on estimated throughput" scheme are based on
> > > _past_ requests and it's simply impossible to have a 100% accurate
> > > scheme. In principle, wbc.timeout will only be inferior at IO startup
> > > time. In the steady state of 100% full queue, it is actually estimating
> > > the IO throughput implicitly :)
> > 
> > Another difference between wbc.timeout and adaptive wbc.nr_to_write
> > is, when there comes many _read_ requests or fsync, these SYNC rw
> > requests will significant lower the ASYNC writeback throughput, if
> > it's not completely stalled. So with timeout, the inode will be
> > aborted with few pages written; with nr_to_write, the inode will be
> > written a good number of pages, at the cost of taking up long time.
> > 
> > IMHO the nr_to_write behavior seems more efficient. What do you think?
> 
> I agree, adaptively changing nr_to_write seems like the right thing to

I'd like to estimate the writeback throughput in bdi_writeback_wakeup(),
where the queue is not starved and the estimation would reflect the max
device capability (unless there are busy reads, in which case we need
lower nr_to_write anyway).

> do.  For bonus points, we could also monitor how often synchronous I/O
> operations are happening, allow nr_to_write to go up by some amount if
> there aren't many synchronous operations happening at the moment.  So
> that might be another opportunity to do auto-tuning, although this
> might be a hueristic that might need to be configurable for certain
> specialized workloads.  For many other workloads, the it should be
> possible to detect regular pattern of reads and/or synchronous writes,
> and if so, use a lower nr_to_write versus if there isn't many
> synchronous I/O operations happening on that particular block device.

It's not easy to get state of the art SYNC read/write busyness.
However it is possible to "feel" them through the progress of ASYNC
writes.

- setup a per-file timeout=3*HZ
- check this in write_cache_pages:

        if (half nr_to_write pages written && timeout)
                break;

In this way we back off to nr_to_write/2 if the writeback is blocked
by some busy READs.

I'd choose to implement this advanced feature some time later :)

Thanks,
Fengguang
