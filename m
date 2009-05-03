Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbZECHjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbZECHjr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 03:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbZECHji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 03:39:38 -0400
Received: from [212.69.161.110] ([212.69.161.110]:49168 "EHLO
	mail09.linbit.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbZECHjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 03:39:37 -0400
Date: Sun, 3 May 2009 09:38:40 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Neil Brown <neilb@suse.de>
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
Message-ID: <20090503073840.GB31340@racke>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-2-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-3-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-4-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-5-git-send-email-philipp.reisner@linbit.com> <1241278918.3639.46.camel@mulgrave.int.hansenpartnership.com> <20090502172838.GC6466@racke> <18941.10725.335758.894491@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18941.10725.335758.894491@notabene.brown>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 03:21:41PM +1000, Neil Brown wrote:
> On Saturday May 2, lars.ellenberg@linbit.com wrote:
> > On Sat, May 02, 2009 at 10:41:58AM -0500, James Bottomley wrote:
> > > On Thu, 2009-04-30 at 13:26 +0200, Philipp Reisner wrote:
> > > > DRBD maintains a dirty bitmap in case it has to run without peer node or
> > > > without local disk. Writes to the on disk dirty bitmap are minimized by the
> > > > activity log (=AL). Each time an extent is evicted from the AL the part of
> > > > the bitmap no longer covered by the AL is written to disk.
> > > > 
> > > > Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
> > > > Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> > > 
> > > The way the bitmap and activity log work are very similar to the way the
> > > md bitmap works (and are implemented for almost exactly the same
> > > reason).  Is there any way we could combine them?
> > 
> > in principle yes.
> > the DRBD bitmap has a granularity of 4 kB per bit,
> > and the "activity log" covers 4 MB per what we call "al extent".
> > 
> > though there is a very important difference.
> > 
> > in MD, when the bitmap is in use, I think the approach is:
> > 
> >   for each write queued to the lower level devices,
> >      dirty bits in memory
> >      for every newly dirtied bitmap page,
> > 	flush bitmap pages to disk
> > 	wait for these bitmap writes to complete
> >   then unplug the lowe level devices
> > 
> >   in background: periodically try to clean some pages,
> > 	and write them to disk
> > 
> > the DRBD approach is:
> >   if target "al extent" of this write request
> >   is NOT in the in-memory "lru_cache" already,
> > 	get it into the cache,
> > 		if that means we have to kick an
> > 		old element from the cache, and
> > 		the associated bitmap is dirty
> > 			write that part of the bitmap
> >         write an "al transaction" (synchonous single sector write)
> >   else
> >   	FAST PATH, no additional "meta data" write needed.
> >   
> >   submit to lower level device.
> > 
> > 
> > MD most of the time just _needs_ the additional "meta data" writes.
> > DRBD most of the time does not (unless you have completely random
> > writes, always requesting an extent not yet/anymore in the activity log.
> > 
> > I'm in the process of generalizing DRBDs approach to allow more than one
> > "al extent" to change during a "prepare" step, and cover several such changes
> > in one "al transaction", so the number of meta data updates can be
> > reduced even further.
> > 
> > adopting this "activity log" approach would make MD even better, IMO.
> 
> I've been pondering this, wondering what the important difference is.
> I picture the DRBD approach - abstractly - as maintaining 2 bitmaps.
> One is very fine granularity (4K).  The other has much coarser
> granularity (4M).
> A sector of the array is considered to need resync (After unclean
> shutdown or whatever) if either bitmap has the bit set for the
> corresponding region of the array.
> 
> Bits are set on-disk in the coarse bitmap before any writes are
> allowed to corresponding regions, and a cleared lazily when there are
> no writes active in that region.
> Bits are set on-disk in the fine bitmap only when the corresponding
> bit of the coarse bitmap is about to be cleared on-disk.  There will
> only be bits to set if the array is degraded, so writes have completed
> to one half and cannot be sent to the other half.
> Bits are cleared on-disk in the fine bitmap after a 'resync' - and
> presumably again just before the corresponding coarse bit is cleared.
> 
> DRBD stores this coarse bitmap as an activity log which is (I think)
> just a list of addresses of bits that are set.  Not unlike run-length
> encoding.   The rule for lazy clearing of bits is that when the number
> of bits which are set crosses a threshold, we clear the 'oldest' bit.
> 
> I could conceivably take this approach into md without changing the
> on-disk layout at all.  To set a bit in the coarse bitmap, I would
> simply set all the corresponding bits in the fine on-disk bitmap.
> This could involve writing a whole sector of ones to just set one
> bit... but as you cannot write less than a sector that isn't really
> a problem.  DRBD currently writes one sector per bit set, so it should
> be no worse than DRBD.


You'd set a whole sector of bits on disk,
but keep them cleared in memory - unless degraded.
On "clearing the coarse bit" (evicting from our lru_cache),
you'd write the actual in-memory bitmap.
Yes, that would be more or less functionally equivalent, probably.

> Another issue here is bitmap granularity.  DRBD uses two granularities:
> 4M and 4K.  md uses just one, but it is configurable.  People tend to
> find larger granularities provide better performance for exactly the
> same reason that DRBD uses 4M for the activity log - to minimise
> updates when write activity is fairly local.
> By doing so, we miss out on the advantages of fine granularity - that
> being that there is less data to move around during resync.  For local
> disks, that cost is not enormous as seek time is much slower that data
> transfer, so copying a large block costs much the same as a few small
> blocks at the same location.
> For DRBD where the data is moved over the network which is slower than
> a local interconnect, the data transfer time presumably becomes the
> main cost, so minimising the data that needs to be transferred after a
> reconnect is important.  So supporting two different granularities
> certainly seems to make sense where a network transport is involved.

Right.
Mid-term, we intend to make both granularities configurable, btw.

> I would be interested in adding this sort of two-level support to md's
> bitmaps.  I cannot immediately see the benefits of the activity log
> format though.  I would probably just set more bits any time I had to
> set any, to avoid subsequent updates.
> e.g. for a 4TB filesystem with 4K bitmap chunk size, I would have 2^30 bits
> in 2^18 sectors - 128Meg of bitmap altogether.

exactly.

> Whenever updating a bit, I'd set maybe 1/4 or 1/2 of the bits in the
> sector, this covers 4MB or 8MB.  They then get cleared lazily as
> discussed above.
> This would need a bit of work in md/bitmap, partly because the current
> implementation limits a bitmap to 2^20 bits (partly because I won't
> use vmalloc).

In memory bitmap implementation of DRBD uses an array of GFP_HIGHUSER
pages, and is capable of supporting (ULONG_MAX-1) bits.
The main disadvantage: it holds the bitmap in memory all the time,
which makes 512 MB mostly unused core memory for 16 TB backing store.
Conveivably the implementation can be changed to only hold "N" pages
in memory at any given time, where "N" would again be the number of
elements in our "lru_cache".

> As I said, I don't immediately see the benefits of the activity log
> format, however,
>  1/ I am happy to listen to its benefits being explained

Compared to using an explicit on-disk "coarse" bitmap,
the "activity log" format can track arbitrarily large
devices in a small, constant, on-disk area.

But as the fine bitmap is on disk anyways, there is no need for the
coarse bitmap to be present anywhere appart from using it to explain the
concept to people.

Just for the dirty bitmap, an in-memroy scheme using (somthing simliar
to) our lru_cache stuff, and instead of writing "al-transactions"
flushing in-memory (fine) bitmap to disk for "evict",
and marking quarter, half or full on-disk (fine) bitmap sectors as dirty
without touching the in-memory bitmap, should be functionally equivalent.

We had greater plans for the activity log,
using its most useful property: on crash recovery,
one knows exactly which parts of the device (may)
have been target of in-flight IO during the crash
(which, when degraded is not the same as looking
at the dirty bitmap, and when cleanly shut down
is something else again, but still may be useful).
  But none of those plans has yet been coded,
and possibly some of them are just nonsense, anyways,
so you may well ignore this paragraph.

>  2/ If we were to agree that merging DRBD functionality into md
>    (for which there isn't a concrete proposal, but the suggestion
>     seems to be floating around) were a good thing, I don't have any
>     problem with supporting an activity log in md in the name of
>     compatibility.

 ;)

The activity log would be the least.

MD currently talks only to "dumb" block devices.
DRBD uses a stateful transport.

examples:

  High Availability clustering, single "Active" node.
    For some reason you run into diverging data sets,
    result of what is usually called split-brain (communication loss
    between cluster nodes).

    If you had a SAN, you'd be screwed.

    But you have been replicating, so you now have two data sets,
    both consistent, but slightly different.

    Assume that one node was completely shut off of comunication,
    so could not be reached by clients either, and it is thus easy
    to determine the "better" data set.

    You used MD over iSCSI (or NBD or whatever).
      You are still screwed: first you need to detect this
      "after split-brain, diverging data sets" situation,
      then you need to do a full resync.
      If you only do a partial resync
      based on whatever MD bitmap there is,
      you get inconsistent mirrors.

    You used DRBD.
      which can communicate, and reliably detect the situation
      and usually refuses to destroy either consistent dataset.
      Until you tell it which changes to throw away.
      Then it will exchange dirty bitmaps, bitor them together,
      and thus revert the changes of the victim,
      and apply the changes of the chosen "better" data set.

  Clustering, "Two Primaries", both nodes active.
    You can use OCFS2 on top of DRBD,
    _without_ any shared components.
    No SAN. Shared nothing.
    Just replicating.

    However useful that is, and yes, it is a tricky setup,
    and yes we can (and will) improve on the handling of these setups.

There are more neat things possible
when not restricted to "dumb" transports.
To support this kind of stuff,
MD needs to change its architechture quite a bit,
so that would be more of a long-term project.

Please get me right:
I'm definetly in, if this turns out to be the way to go.
But don't underestimate the effort.


	Lars
