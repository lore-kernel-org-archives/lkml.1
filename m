Return-Path: <linux-kernel-owner+w=401wt.eu-S1754906AbZENJqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbZENJqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 05:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbZENJqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 05:46:40 -0400
Received: from mail09.linbit.com ([212.69.161.110]:53855 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbZENJqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 05:46:39 -0400
Date: Thu, 14 May 2009 11:46:38 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Neil Brown <neilb@suse.de>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Contrasting DRBD with md/nbd
Message-ID: <20090514094638.GA8724@soda.linbit>
References: <18955.47806.365247.808127@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <18955.47806.365247.808127@notabene.brown>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 04:31:26PM +1000, Neil Brown wrote:
> 
> [ cc: list massively trimmed compared to original posting of code and
>   subsequent discussion..]

;)

> Hi,
> 
>  Prior to giving DRBD a proper review I've been trying to make sure
>  that I understand it, so I have a valid model to compare the code
>  against (and so I can steal any bits that I like for md:-)
> 
>  The model I have been pondering is an extension of the md/raid1 + nbd
>  model.  Understanding exactly what would need to be added to that
>  model to provide identical services will help (me, at least)
>  understand DRBD.
> 
>  So I thought I would share the model with you all in case it helps
>  anyone else, and in case there are any significant error that need to
>  be corrected.
> 
>  Again, this is *not* how DRBD is implemented - it describes an
>  alternate implementation that would provide the same functionality.
> 
>  
>  In this model there is something like md/raid1, and something like
>  nbd.  The raid1 communicates with both (all) drives via the same nbd
>  interface (which in a real implementation would be optimised to
>  bypass the socket layer for a local device).  This is different to
>  current md/raid1+nbd installations which only use nbd to access the
>  remote device.
> 
>  The enhanced NBD
>  ================
> 
>  The 'nbd' server accepts connections from 2 (or more) clients and
>  co-ordinates IO. Apart from the "obvious" of servicing read and write requests, sending
>  acknowledgements and handling barriers, the particular
>  responsibilities of the nbd server are:
>    - to detect and resolve concurrent writes
>    - to maintain a bitmap recording "the blocks which have been
>       written to this device but not to (all) the other device(s).

You need not "a" bitmap, but "a number of" bitmaps.
See below.

>  Concurrent writes
>  -----------------
> 
>  To detect concurrent writes it needs a little bit of help from the
>  raid1 module.  Whenever raid1 is about to issue a write, it
>  sends a reservation request to one of the nbd devices (typically the
>  local one) to record that the write is in-flight.  Then it sends the
>  write to all devices.  Then when all devices acknowledge, the
>  reservation is released.  This 'reservation' is related to the
>  existence of an entry in DRBD's 'transfer hash table'.
> 
>  If the nbd server receives a write that conflicts with a current
>  reservation, or if it gets a reservation while it is processing a
>  conflicting write, it knows there has been a concurrent write.
>  If it does not detect a conflict, it is still possible that there
>  were concurrent writes and if so the (or an) other nbd will detect
>  it.
> 
>  When conflicting writes are detected, a simple static ordering among
>  masters determines which write wins.  To ensure it's own copy is
>  valid, the nbd either ignores or applies the second write depending
>  on the relative priorities of the masters.
>  To ensure that all other copies are also valid, nbd returns a status
>  to each writer reporting the collision and whether the write was
>  accepted or not.
> 
>  If the raid1 is told that a write collided but was successful, it
>  must write it out again to any other device that did not detect and
>  resolve the collision,
> 
>  Note that this algorithm is somewhat different to the one used by
>  DRBD.  The most obvious difference is that this algorithm sometimes
>  requires the block to be written twice.  DRBD doesn't require that.
>  DRBD manages differently because the equivalents of the nbd servers can
>  talk to each other, and see all traffic in both directions.  A key
>  simplification in my model is that they don't.  The RAID1 is the only
>  thing that communicates to an nbd, so any inter-nbd communication
>  must go through it.
>  This architectural feature of DRBD is quite possibly the
>  nail-in-the-coffin of the idea of implementing DRBD inside md/raid1.
>  I wouldn't be surprised if it is also a feature that would be very
>  hard to generalise to N nodes.
>  (Or maybe I just haven't thought hard enough about it.. that's
>  possible).

I think it is "easily" generalized.  The important part will be the
ordering of the "Acks".  But we should postpone that discussion.
 
>  Bitmap Maintenance
>  ------------------
> 
>  To maintain the bitmap the nbd again needs help from the raid1.
>  When a write request is submitted to less than the full complement of
>  targets, the write request carries a 'degraded' flag.  Whenever nbd
>  sees that degraded flag, it sets the bitmap bit for all relevant
>  sections of the device.
>  If it sees a write without the 'degraded' flag, it clears the
>  relevant bits.
>  Further, if raid1 submits a write to all drives, but some of them
>  fail, the other drives must be told that the write failed so they can
>  set the relevant bits.  So some sort of "set these bits" message from
>  the raid1 to the nbd server is needed.
> 
>  The nbd does not write bitmap updates to storage synchronously.
>  Rather, it can be told when to flush out ranges of the bitmap.   This
>  is done as part of the RAID1 maintaining it's own record of active
>  writes.
> 
>  The bitmaps could conceivably be maintained at the RAID1 end and
>  communicated to the nbd by simple reads and writes.  The nbd would
>  then merge all the bitmaps with a logical 'or'.  This would require
>  more network bandwidth and would require each master to clear bits as
>  regions were resynced.  As such it isn't really a good fit for DRBD.
>  I mention it only because it is more like the approach currently used
>  in md.

IMO, you need to distinguish between a "write intent" log (each node
would have one), and a "dirty" log (each node would have one for each
replication link).

It is a valid use case to "disconnect" different "sites" at different
times, for some hours.  If you only have one "dirty log", you cannot
track these sites independently.  This is the main reason why we do not
yet have "N > 2" support in DRBD, we still have only one dirty bitmap.

Think even "local only RAID1", if you use 4 (or more) devices.
At any time, at least two are online and in sync (to protect against
hardware failures).  One may be resyncing (based on the corresponding
tracking bitmap).  Backup concept: one is offline (and probably plugged,
and possibly stored in a safe).  You plug, let resync, unplug and store
in a safe place in round robin.
You can do so already with MD, obviously.
But you'd usually need a full sync right now.

Replace local disk with "nbd" link, unplug with "disconnect".
There you are, backup and desaster recovery concept.

>  The enhanced RAID1
>  ==================
> 
>  As mentioned, the RAID1 in this model sends IO request to 2 (or more)
>  enhanced nbd device.
>  Typically one of these will be preferred for reads (in md
>  terminology, the others are 'write-mostly').  Also the raid1 can
>  report success for a write before all the nbds have reported success
>  (write-behind in md terminology).
> 
>  The raid1 keeps a record of what areas of the device are currently
>  undergoing IO.  This is the activity log in DRBD terminology, or the
>  write-intent-bitmap in md terminology (though the md bitmap blends
>  the concepts of the RAID1 level bitmap and the nbd level bitmap).

Or the "region hash + dirty log" in device mapper terminology.

>  Before removing a region from this record, the RAID1 tells all nbds
>  to flush their bitmaps for that region.
> 
>  Note that this RAID1 level log must be replicated on at least N-1
>  nodes (where there are N nodes in the system).  For the simple case
>  of N=2, the log can be kept locally (if the local device is working).
>  For the more general case it needs to be replicated to every device.
>  In that case it is effectively an addendum to the already-local bitmap.
> 
>  Other functionality that the RAID1 must implement that has no
>  equivalent in md and that hasn't been mentioned in the context of
>  the nbd includes:
> 
>   - when in a write-behind mode, the raid1 must try to intuit
>     write-after-write dependencies and generate barrier requests
>     to enforce them on the write-behind devices.
>     To do this we have a 'writing' flag.
>     When a write request arrives, if the 'writing' flag is clear, we
>     set it and send a write barrier.  Then send the write.
>     When a write completes, we clear the 'writing' flag.

I think this is too simplistic.

Ignoring component failures for now (I think here James and Phil have
been talking at each other a bit, while missing a few important points).

Write requests are submitted in a certain order - we knew that much ;)
They may have _explicit_ write-after-write dependencies (BIO_RW_BARRIER),
they may have _implicit_ write-after-write dependencies.

The latter sepparate "reorder domains", which can be deduced by the
following: if a write C is submitted while A and B have still been
in-flight, then it cannot possibly be dependant on either A or B,
so the actual write order may as well be C,B,A.
Now, if B completes, and then D is submitted, B closes the current
reorder domain (epoch in DRBD speak), as D _may_ have dependencies on B.
You nee to close the current epoch, even if not all of its requests
have been completed. Your 'writing' flag above is too simplistic.

As long as they are "queued" to the replication links in the
exact same order as they are queued to the "top-level"
"replication core" queue, and they are not re-ordered on the receiving
end of the replication links (NBD currently does that using direct IO),
this should be fine, as the receiving end cannot possibly mix up any
ordering dependencies if it commits strictly in submission order,
one at a time.

It conceivably improves performance if one detects the implicit
write-after-write dependencies, and thus "reorder domains",
and allows the receiving end to do limitted reordering of these writes.

>     This is not needed in fully synchronous mode as any real
>     dependency will be imposed by the filesystem on to all devices.

When handling more than one device,
and intending to "guarantee" that both are identical
when no more writes are in flight (nor delayed or "behind"),
we have more challenges to deal with:
  * users modifying in-flight buffers
  * writes overlapping with in-flight writes

assuming the user (typically: file system) knows what it does,
and actually does not care wether the already submitted or the now
modified version hits the disk, this is not a problem for the user.
but on the replication (or RAID) level, we can no longer be sure
that our copies are identical.

That is why DRBD detects "local concurrent writes"
even in a "classic" Primary/Secondary setup.

For the "modify in-flight buffers" problem, we do not yet have a
(performant) solution, though.
Some of the offenders in ilnux have already been detected and fixed
during introduction of the "bio integrity" stuff, iirc.

>  Resync/recovery
>  ---------------
> 
>  Given the multi-master aspects of DRBD there are interesting
>  questions about what to do after a crash or network separation -
>  in particular which device should be treated as the primary.
>  I'm going treat these as "somebody else's problem". i.e. they are
>  policy questions that should be handled by some user-space tool.

May I suggest that we distinguish between "roles"
(Active, Primary, user visible and accessable)
and "connection states" (Sync Source, Sync Target).
I may well be Primary and Sync Target (usually by first becoming
Sync Target, and then being promoted...)

>  All I am interested in here is the implementation of the
>  policy. i.e. how to bring two divergent devices back in to sync.
> 
>  The basic process is that some thread (and it could conceivably be a
>  separate 'master') loads the bitmap for one device and then:
>   if it is the 'primary' device for the resync, it reads all the blocks
>    mentioned in the bitmap and writes them to all other devices.
>   if it is not the 'primary' device, it reads all the blocks from the
>    primary and writes them to the device which owned the bitmap
> 
>  There is room for some optimisations here to avoid network traffic. 
>   The copying process can request just a checksum from each device and
>   only copy the data if the checksum differs, or it could load the
>   checksum from the target of the copy, and then send the source "read
>   this block only if the checksum is different to X".
> 
>  The above process would involve a separate resync process for each
>  device.  It would probably be best to perform these sequentially. 
>  An alternate would be to have a single process that loaded all the
>  bitmaps, merged them and then copied from the primary to all
>  secondaries for each block in the combined bitmap.
>  If there were just two nodes and this process always ran on a
>  specific node - e.g. the non-primary, then this would probably be a
>  lot simpler than the general solution.
> 
>  With md, resync IO and normal writes each get exclusive access to the
>  devices in turn.  So writes are blocked while the resync process reads
>  a few block and writes those blocks.
> 
>  In the DRBD model where we have more intelligence in the enhanced nbd
>  this synchronisation can be more finely grained.
> 
>  The 'reserve' request mentioned above under 'concurrent writes' could
>  be used, with the resync process given the lowest possible priority
>  so its write requests always lost if there was a conflict.
>  Then the resync process would
>    - reserve an address on the destination (secondary)
>    - read the block from the primary
>    - write the block to the destination
> 
>  Providing that the primary blocked the read while there was a
>  conflicting write reservation, this should work perfectly.

Not yet convinced that the "more finegrained" based on 'reserve'
style resync is in fact useful.

Also the READ will know which of the available devices is supposed to
have "clean" data, and can just read from there, without being blocked.

If we have READ concurrently with in-flight WRITE, then that is the
users problem, as he gets undefined results even on a single device.

>  Summary
>  =======
> 
>    The list of requests that would be needed to be supported by the
>    link to the nbd daemon would be something like:
>     Each of these have sector offset and size
>      READ
>      READ_CHECKSUM
>      READ_IF_NOT_CHECKSUM
>      WRITE

not sure about the following five.
I'd like those to be implicit.

>      RESERVE
>      RELEASE_RESERVE
>      SET_BIT
>      CLEAR_BIT
>      FLUSH_BITMAP

>     These have no sector/size
>      READ_BITMAP
> 
>     RESERVE and SET_BIT could possibly be combined with a WRITE, but
>     would need to be stand-alone as well.
> 
>    The extra functionality needed in the RAID1 that has no equivalent
>    in md/raid1 would be:
>      - issues RESERVE/RELEASE around write requests
>      - detecting possible locations for write-barriers when in
>             write-behind mode
>      - separate 2-level bitmaps, and other subtleties in
>             bitmap/activity log handling.
>      - checksum based resync
>      - respond to write-conflict errors be re-writing the data block.
> 
> 
>    Looked at this way, the most complex part would be all the extra
>    requests that need to be passed to the nbd client.  I guess they
>    would be sent via an ioctl, though there would be some subtlety in
>    getting that right.

One of the main differences between current md/raid1+nbd
and DRBD is that DRBD was dedicatedly developed for replication
in an HA failover setup.
I think (of course biased) the perception of the average admin is that
DRBD is much easier to deal with in such setups, because it is
apparently more complex getting the various configurations and
interactions of md/raid1 and nbd and cluster manager right.

>    Implementing the new nbd server should be fairly straight forward.
>    Adding the md/raid1 functionality would probably not be a major
>    issue, though some more thought will be needed about bitmaps before I
>    felt completely comfortable about this.
> 
>    So the summary of the summary is the implementing similar
>    functionality to DRBD in a md/raid1+nbd style framework appears
>    to be quite possible.

Of course.
"Everything is possible" ;)

>    However for the reasons mentioned under "concurrent writes", a
>    protocol-compatible implementation is unlikely to be possible.
>    That also means that the model is not as close as I would like while
>    doing a code review, but I suspect it is close enough to help.
> 
>  Thank you for reading.  I found the exercise educational.  I hope you
>  did too.  I think I  might even be ready to review the DRBD code now :-)

Thanks, next post will follow soonish.

-- 
: Lars Ellenberg
: LINBIT | Your Way to High Availability
: DRBD/HA support and consulting http://www.linbit.com

DRBD® and LINBIT® are registered trademarks of LINBIT, Austria.
