Return-Path: <linux-kernel-owner+w=401wt.eu-S1031043AbXDQBJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031043AbXDQBJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 21:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031048AbXDQBJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 21:09:57 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50673 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031043AbXDQBJ5 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 21:09:57 -0400
Date: Tue, 17 Apr 2007 11:09:32 +1000
From: David Chinner <dgc@sgi.com>
To: Valerie Henson <val_henson@linux.intel.com>
Cc: David Chinner <dgc@sgi.com>, Rik van Riel <riel@redhat.com>,
       "David R. Litwin" <presently42@gmail.com>, linux-kernel@vger.kernel.org,
       bnaujok@sgi.com
Subject: Re: Repair-driven file system design (was Re: ZFS with Linux: An Open Plea)
Message-ID: <20070417010932.GQ48531920@melbourne.sgi.com>
References: <op.tqthonq5ftfxs2@localhost.localdomain> <4622C851.2030509@redhat.com> <20070416030705.GY32602149@melbourne.sgi.com> <20070416223440.GA18590@nifty>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070416223440.GA18590@nifty>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 03:34:42PM -0700, Valerie Henson wrote:
> On Mon, Apr 16, 2007 at 01:07:05PM +1000, David Chinner wrote:
> > On Sun, Apr 15, 2007 at 08:50:25PM -0400, Rik van Riel wrote:
> >
> > > IMHO chunkfs could provide a much more promising approach.
> > 
> > Agreed, that's one method of compartmentalising the problem.....
> 
> Agreed, the chunkfs design is only one way to implement repair-driven
> file system design - designing your file system to make file system
> check and repair fast and easy.  I've written a paper on this idea,
> which includes some interesting projections estimating that fsck will
> take 10 times as long on the 2013 equivalent of a 2006 file system,
> due entirely to changes in disk hardware.

That's assuming that repair doesn't get any more efficient. ;)

> So if your server currently
> takes 2 hours to fsck, an equivalent server in 2013 will take about 20
> hours.  Eek!  Paper here:
> 
> http://infohost.nmt.edu/~val/review/repair.pdf
> 
> While I'm working on chunkfs, I also think that all file systems
> should strive for repair-driven design.  XFS has already made big
> strides in this area (multi-threading fsck for multi-disk file
> systems, for example) and I'm excited to see what comes next.

Two steps forward, one step back.

We found that our original approach to multithreading doesn't always
work, and doesn't work at all for single disks. Under some test cases,
it goes *much* slower due to increased seeking of the disks.

This patch from the folk at Agami:

http://oss.sgi.com/archives/xfs/2007-01/msg00135.html

used a different threading approach to speeding up the repair
process - it basically did object path walking in separate threads
to prime the block device page cache so that when the real
repair thread needed the block it came from the blockdev cache
rather than from disk.

This sped up several phases of the repair process because of
re-reads needed in the different phases. What we found interesting
about this approach is that it showed that prefetching gave as good
or better results than simple parallelisation with a rudimentary
caching system. In most cases it was superior (lower runtime) to
the existing multithreaded xfs_repair.

However, the Agami object based prefetch does not speed up phase 3
on a single disk - like strided AG parallelism it increases disk
seeks and, as we discovered, causes lots of little backwards seeks
to occur. It also performs very poorly when there is not enough
memory to cache sufficient objects in the block dev cache (whose
size cannot be controlled). It sped things up by using prefetch to
speed up (repeated) I/O, not by using intelligent caching.....

However, this patch has been very instructive on how we could
further improve the threading of xfs_repair - intelligent prefetch
is better than simple parallelism (from the Agami patch), caching is
far better than rereading (from the SGI repair level caching) and
that prefetching complements simple parallelism on volumes that can
take advantage of it.

We've ended up combining a threaded, two phase object walking
prefetch with spatial analysis of the inode and object layouts
and integration into a smarter internal cache. This cache is now
similar to the xfs_buf cache in the kernel and uses direct I/O
so if you have enough memory you only need to read objects from
disk once.

Spatial analysis of the metadata is used to determine the relative
density of the metadata in an area of disk before we read it. Using
a density function, we determine if we want to do lots of small I/Os
or one large I/O to read the entire region in one go and then split
it up in memory. Hence as metadata density increases, the number of
I/Os decrease and we pull enough data in to (hopefully) keep the
CPUs busy.

We still walk objects, but any blocks behind where we are currently
reading go into a secondary I/O queue to be issued later. Hence we
keep moving in one direction across the disk. Once the first pass is
complete, we then do the same analysis on the secondary list and run
that I/O all in a single pass across the disk.

This is effectively a result of observing that repair is typically seek
bound and only using 2-3MB/s of the bandwidth a disk has to offer.
Where metadata density is high, we are now seeing luns max out on
bandwidth rather than being seek bound. Effectively we are hiding
latency by using more bandwidth and that is a good tradeoff to
make for a seek bound app....

The result of this is that even on single disks the reading of all
the metadata goes faster with this multithreaded prefetch model.  A
full 250GB SATA disk with a clean filesystem containing ~1.6 million
inodes is now taking less than 5 minutes to repair. A 5.5TB RAID5
volume with 30 million inodes is now taking about 4.5 minutes to
repair instead of 20 minutes. We're currently creating a
multi-hundred million inode filesystem to determine scalability to
the current bleeding edge.

One thing this makes me consider is changing the way inodes and
metadata get laid out in XFS - clumping metadata together will lead
to better scan times for repair because of the density increase.
Dualfs has already proven that this can be good for performance when
done correctly; I think it also has merit for improving repair times
substantially as well.

FWIW, I've already told Barry he's going to have to write a
white paper about all this once he's finished.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
