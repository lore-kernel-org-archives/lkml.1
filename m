Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab0BWWQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 17:16:38 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:45319 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341Ab0BWWQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 17:16:36 -0500
Date: Tue, 23 Feb 2010 23:16:35 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while
	userspace is frozen?
Message-ID: <20100223221635.GP1025@kernel.dk>
References: <20100223155803.GN1025@kernel.dk> <Pine.LNX.4.44L0.1002231115510.1308-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1002231115510.1308-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23 2010, Alan Stern wrote:
> On Tue, 23 Feb 2010, Jens Axboe wrote:
> 
> > On Tue, Feb 23 2010, Alan Stern wrote:
> > > > > This is a matter for Jens.  Is the bdi writeback task freezable?  If it
> > > > > is, should it be made unfreezable?
> > > > 
> > > > I'm not a big expect on what tasks should be freezable or not. As it
> > > > stands, the writeback tasks will attempt to freeze and thaw with the
> > > > system. I guess that screws the sync from resume call, since it's not
> > > > running and the sync will wait for it to retrieve and finish that work
> > > > item.
> > > > 
> > > > To the suspend experts - can we safely mark the writeback tasks as
> > > > non-freezable?
> > > 
> > > The reason for freezing those tasks is to avoid writebacks at random
> > > times during a system sleep transition, when the underlying device may
> > > already be suspended, right?
> > 
> > Right, or at least it would seem pointless to have them running while
> > the device is suspended. But my point was that if it's easier (and
> > feasible) to just leave them running, perhaps that was easier.
> 
> I don't have a clear picture of how the block layer operates.  For 
> example, what is the reason for this comment in the definition of 
> struct genhd?
> 
> 	struct device *driverfs_dev;  // FIXME: remove
> 
> Isn't that crucial for making a disk show up in sysfs?  Is the comment 
> out of date?

Don't ask me, I'd suggest using git blame for finding out who wrote that
and ping them.

> A possible approach is to add suspend and resume methods for this 
> driverfs_dev, and make them be responsible for stopping and restarting 
> the writeback task instead of relying on the freezer.  Then 
> del_gendisk() could cleanly restart the task when necessary.

That sounds over engineered to me.

> > > In principle, a device's writeback task could be unfrozen immediately
> > > after the device is resumed.  In practice this might not solve the
> > > problem, since the del_gendisk() call occurs _within_ the device's
> > > resume routine.  I suppose del_gendisk() could be made responsible for 
> > > unfreezing the writeback task.
> > 
> > And that's back to the question of whether or not that is a nice thing to
> > do. It seems a bit dirty, but otoh where else to do it. Perhaps just
> > using the kblockd to postpone the del_gendisk() to out-of-resume context
> > would be the best approach.
> 
> That would involve a layering violation, wouldn't it?  Either the 
> driver would have to interface with kblockd directly, or else 
> del_gendisk() would need to know whether the writeback task was frozen.
> 
> On the whole, I think it's best for the block layer to retain full
> control over its own tasks and requirements.

You would export such functionality - del_gendisk_deferred(), or
something like that. The kblockd suggestion was implementation detail,
not something the driver would concern itself with. It's not exactly
picture perfect, but it could be used from eg resume context where the
device isn't fully live yet.

-- 
Jens Axboe

