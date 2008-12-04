Return-Path: <linux-kernel-owner+w=401wt.eu-S1757930AbYLDTmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930AbYLDTmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 14:42:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbYLDTmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 14:42:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722AbYLDTml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 14:42:41 -0500
Date: Thu, 4 Dec 2008 14:37:36 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       Alasdair G Kergon <agk@redhat.com>,
       Andi Kleen <andi-suse@firstfloor.org>, Milan Broz <mbroz@redhat.com>
Subject: Re: Device loses barrier support (was: Fixed patch for simple
 barriers.)
In-Reply-To: <20081204174838.GS6703@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0812041401210.23079@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0812040009340.15169@hs20-bc2-1.build.redhat.com>
 <20081204100050.GN6703@one.firstfloor.org> <Pine.LNX.4.64.0812040836480.6118@hs20-bc2-1.build.redhat.com>
 <20081204142015.GQ6703@one.firstfloor.org> <Pine.LNX.4.64.0812040913510.6118@hs20-bc2-1.build.redhat.com>
 <20081204145810.GR6703@one.firstfloor.org> <Pine.LNX.4.64.0812041139200.2434@hs20-bc2-1.build.redhat.com>
 <20081204174838.GS6703@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Dec 2008, Andi Kleen wrote:

> On Thu, Dec 04, 2008 at 11:45:44AM -0500, Mikulas Patocka wrote:
> > > No there is nothing unordered. The file system path typically looks like
> > > 
> > > commit of a transaction
> > > 	if (i have never seen a barrier failing) 
> > > 		write block with barrier
> > > 		if (EOPNOTSUPP) {
> > > 			record failure
> > > 			submit synchronously
> > > 		}
> > > 	} else
> > > 		submit synchronously
> > > 
> > 
> > If you view this as a "right" way of using barriers, then you can drop 
> 
> It's the way the file systems do it. If you don't believe me feel
> free to read the code for yourself.
> 
> > barrier support at all and replace this code sequence with:
> > 
> >  flush disk cache
> >  submit write synchronously
> >  flush disk cache
> > 
> > --- because synchronous barriers bring you no performance advantage over 
> > the above sequence.
> 
> Remember this is done by a commit thread in a journaling file system. 
> Commits are ordered so the thread cannot really order out of order 
> anyways. And yes the barriers are essentially a way to flush the cache
> regularly for selected commits. The alternative (if you
> want to guarantee transaction order) would be to disable
> the write cache completely and do it synchronous on each IO.

Some times ago, I used barriers the asynchronous way in the spadfs 
filesystem and they helped very much. The commit logic is:

- take the transaction lock (it prevents any updates)
- write remaining dirty buffers (but don't wait)
- submit barrier write to move to new transaction (but don't wait)
- drop the transaction lock
- eventually wait for completion of writes (if this was issued by fsync or 
sync) or don't wait at all if it was issued by other things (periodic 
syncer, emergency sync to reclaim free space or so).

The advantage of this approach is that the lock is held for very small 
time, no IOs are really waited for inside the lock. So it doesn't block 
concurrent activity while someone is committing. Note, that after the lock 
is dropped, anyone can for example call mark_buffer_dirty, but writing of 
the new buffer won't be reordered with the barrier write that is already 
pending in the queue, so consistency is maintained.

I somehow got the idea that this was the reason why barriers are 
implemented the way they are and that this was their intended mode of 
operation. Note that you can't achieve the same thing (don't wait inside 
the lock) if you submit barriers synchronously or if you use non-barrier 
writes and disk cache flushes.

If you are pushing what you are pushing --- barriers allowing to return 
EOPNOTSUPP anytime --- then asynchronous barrier submits can no longer be 
used, because by the time EOPNOTSUPP is detected, the filesystem is 
already corrupted.

Also, read Documentation/block/barrier.txt and see what you are breaking 
in the document:

"all requests queued after the barrier request must be started only after 
the barrier request is finished (again, made it to the physical medium)."

"Preceding requests are processed before the barrier and
following requests after."

--- you are going to break these rules. If the barrier can return 
-EOPNOTSUPP anytime, the following request will be finished before the 
barrier write is finished. (because the barrier write must be resubmitted 
without barrier)

Basically, if you allow randomly failed barriers, you can drop barriers at 
all and replace them with blkdev_issue_flush(); write&wait_synchronous(); 
blkdev_issue_flush(). There is no more reason to maintain complicated 
logic of barriers, if you cripple them to the unusable point when they 
randomly fail.


Another thing:

I'm wondering, where in fsync() does Linux wait for hardware disk cache to 
be flushed? Isn't there a bug that fsync() will return before the cache is 
flushed? I couldn't really find it. The last thing do_fsync calls is 
filemap_fdatawait and it doesn't do cache flush (blkdev_issue_flush).

Mikulas
