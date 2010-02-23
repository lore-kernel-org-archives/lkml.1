Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab0BWP6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 10:58:09 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:44410 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164Ab0BWP6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 10:58:07 -0500
Date: Tue, 23 Feb 2010 16:58:03 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while
	userspace is frozen?
Message-ID: <20100223155803.GN1025@kernel.dk>
References: <20100223123321.GA1025@kernel.dk> <Pine.LNX.4.44L0.1002231016500.1507-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1002231016500.1507-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23 2010, Alan Stern wrote:
> > > This is a matter for Jens.  Is the bdi writeback task freezable?  If it
> > > is, should it be made unfreezable?
> > 
> > I'm not a big expect on what tasks should be freezable or not. As it
> > stands, the writeback tasks will attempt to freeze and thaw with the
> > system. I guess that screws the sync from resume call, since it's not
> > running and the sync will wait for it to retrieve and finish that work
> > item.
> > 
> > To the suspend experts - can we safely mark the writeback tasks as
> > non-freezable?
> 
> The reason for freezing those tasks is to avoid writebacks at random
> times during a system sleep transition, when the underlying device may
> already be suspended, right?

Right, or at least it would seem pointless to have them running while
the device is suspended. But my point was that if it's easier (and
feasible) to just leave them running, perhaps that was easier.

> In principle, a device's writeback task could be unfrozen immediately
> after the device is resumed.  In practice this might not solve the
> problem, since the del_gendisk() call occurs _within_ the device's
> resume routine.  I suppose del_gendisk() could be made responsible for 
> unfreezing the writeback task.

And that's back to the question of whether or not that is a nice thing to
do. It seems a bit dirty, but otoh where else to do it. Perhaps just
using the kblockd to postpone the del_gendisk() to out-of-resume context
would be the best approach.

> The best solution would be to have del_gendisk() avoid waiting for the 
> writeback task in cases where the underlying device has been removed.  
> I don't know if that is feasible, however.

kblockd?

> P.S.: Jens, given a pointer to a struct gendisk or to a struct
> request_queue, is there a good way to tell whether there any dirty
> buffers for that device waiting to be written out?  This is for
> purposes of runtime power management -- in the initial implementation,
> I want to avoid powering-down a block device if it is open or has any
> dirty buffers.  In other words, only completely idle devices should be
> powered down (a good example would be a card reader with no memory card 
> inserted).

There's no fool proof way. For most file systems I think you could get
away with checking the q->bdi dirty lists to see if there's anything
pending. But that wont work always, if the fs uses a different backing
dev info than then queue itself.

-- 
Jens Axboe

