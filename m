Return-Path: <linux-kernel-owner+w=401wt.eu-S1752044AbZECFVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbZECFVs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 01:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbZECFVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 01:21:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47798 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbZECFVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 01:21:38 -0400
From: Neil Brown <neilb@suse.de>
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Date: Sun, 3 May 2009 15:21:41 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18941.10725.335758.894491@notabene.brown>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Philipp Reisner <philipp.reisner@linbit.com>,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 04/16] DRBD: bitmap
In-Reply-To: message from Lars Ellenberg on Saturday May 2
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com>
	<1241090812-13516-2-git-send-email-philipp.reisner@linbit.com>
	<1241090812-13516-3-git-send-email-philipp.reisner@linbit.com>
	<1241090812-13516-4-git-send-email-philipp.reisner@linbit.com>
	<1241090812-13516-5-git-send-email-philipp.reisner@linbit.com>
	<1241278918.3639.46.camel@mulgrave.int.hansenpartnership.com>
	<20090502172838.GC6466@racke>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday May 2, lars.ellenberg@linbit.com wrote:
> On Sat, May 02, 2009 at 10:41:58AM -0500, James Bottomley wrote:
> > On Thu, 2009-04-30 at 13:26 +0200, Philipp Reisner wrote:
> > > DRBD maintains a dirty bitmap in case it has to run without peer node or
> > > without local disk. Writes to the on disk dirty bitmap are minimized by the
> > > activity log (=AL). Each time an extent is evicted from the AL the part of
> > > the bitmap no longer covered by the AL is written to disk.
> > > 
> > > Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
> > > Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> > 
> > The way the bitmap and activity log work are very similar to the way the
> > md bitmap works (and are implemented for almost exactly the same
> > reason).  Is there any way we could combine them?
> 
> in principle yes.
> the DRBD bitmap has a granularity of 4 kB per bit,
> and the "activity log" covers 4 MB per what we call "al extent".
> 
> though there is a very important difference.
> 
> in MD, when the bitmap is in use, I think the approach is:
> 
>   for each write queued to the lower level devices,
>      dirty bits in memory
>      for every newly dirtied bitmap page,
> 	flush bitmap pages to disk
> 	wait for these bitmap writes to complete
>   then unplug the lowe level devices
> 
>   in background: periodically try to clean some pages,
> 	and write them to disk
> 
> the DRBD approach is:
>   if target "al extent" of this write request
>   is NOT in the in-memory "lru_cache" already,
> 	get it into the cache,
> 		if that means we have to kick an
> 		old element from the cache, and
> 		the associated bitmap is dirty
> 			write that part of the bitmap
>         write an "al transaction" (synchonous single sector write)
>   else
>   	FAST PATH, no additional "meta data" write needed.
>   
>   submit to lower level device.
> 
> 
> MD most of the time just _needs_ the additional "meta data" writes.
> DRBD most of the time does not (unless you have completely random
> writes, always requesting an extent not yet/anymore in the activity log.
> 
> I'm in the process of generalizing DRBDs approach to allow more than one
> "al extent" to change during a "prepare" step, and cover several such changes
> in one "al transaction", so the number of meta data updates can be
> reduced even further.
> 
> adopting this "activity log" approach would make MD even better, IMO.

I've been pondering this, wondering what the important difference is.
I picture the DRBD approach - abstractly - as maintaining 2 bitmaps.
One is very fine granularity (4K).  The other has much coarser
granularity (4M).
A sector of the array is considered to need resync (After unclean
shutdown or whatever) if either bitmap has the bit set for the
corresponding region of the array.

Bits are set on-disk in the coarse bitmap before any writes are
allowed to corresponding regions, and a cleared lazily when there are
no writes active in that region.
Bits are set on-disk in the fine bitmap only when the corresponding
bit of the coarse bitmap is about to be cleared on-disk.  There will
only be bits to set if the array is degraded, so writes have completed
to one half and cannot be sent to the other half.
Bits are cleared on-disk in the fine bitmap after a 'resync' - and
presumably again just before the corresponding coarse bit is cleared.

DRBD stores this coarse bitmap as an activity log which is (I think)
just a list of addresses of bits that are set.  Not unlike run-length
encoding.   The rule for lazy clearing of bits is that when the number
of bits which are set crosses a threshold, we clear the 'oldest' bit.

I could conceivably take this approach into md without changing the
on-disk layout at all.  To set a bit in the coarse bitmap, I would
simply set all the corresponding bits in the fine on-disk bitmap.
This could involve writing a whole sector of ones to just set one
bit... but as you cannot write less than a sector that isn't really
a problem.  DRBD currently writes one sector per bit set, so it should
be no worse than DRBD.


The approach that md currently takes to lazy clearing of bits is to
clear bits which have not needed to be set for n seconds, where n
defaults to 5 (I think).
It may well make sense to modify this so that we don't clear bits if
fewer than N are set.  I can imagine that this could benefit some
workloads.  However as the time it takes to update the bitmap is such
a tiny fraction of 5 seconds, I'm not certain that it would be a
noticeable benefit.

Another issue here is bitmap granularity.  DRBD uses two granularities:
4M and 4K.  md uses just one, but it is configurable.  People tend to
find larger granularities provide better performance for exactly the
same reason that DRBD uses 4M for the activity log - to minimise
updates when write activity is fairly local.
By doing so, we miss out on the advantages of fine granularity - that
being that there is less data to move around during resync.  For local
disks, that cost is not enormous as seek time is much slower that data
transfer, so copying a large block costs much the same as a few small
blocks at the same location.
For DRBD where the data is moved over the network which is slower than
a local interconnect, the data transfer time presumably becomes the
main cost, so minimising the data that needs to be transferred after a
reconnect is important.  So supporting two different granularities
certainly seems to make sense where a network transport is involved.

I would be interested in adding this sort of two-level support to md's
bitmaps.  I cannot immediately see the benefits of the activity log
format though.  I would probably just set more bits any time I had to
set any, to avoid subsequent updates.
e.g. for a 4TB filesystem with 4K bitmap chunk size, I would have 2^30 bits
in 2^18 sectors - 128Meg of bitmap altogether.
Whenever updating a bit, I'd set maybe 1/4 or 1/2 of the bits in the
sector, this covers 4MB or 8MB.  They then get cleared lazily as
discussed above.
This would need a bit of work in md/bitmap, partly because the current
implementation limits a bitmap to 2^20 bits (partly because I won't
use vmalloc).

As I said, I don't immediately see the benefits of the activity log
format, however,
 1/ I am happy to listen to its benefits being explained
 2/ If we were to agree that merging DRBD functionality into md
   (for which there isn't a concrete proposal, but the suggestion
    seems to be floating around) were a good thing, I don't have any
    problem with supporting an activity log in md in the name of
    compatibility.


NeilBrown
