Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab0BWP3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 10:29:46 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:46230 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752178Ab0BWP3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 10:29:45 -0500
Date: Tue, 23 Feb 2010 10:29:44 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jens Axboe <jens.axboe@oracle.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while
 userspace is frozen?
In-Reply-To: <20100223123321.GA1025@kernel.dk>
Message-ID: <Pine.LNX.4.44L0.1002231016500.1507-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Feb 2010, Jens Axboe wrote:

> On Tue, Feb 16 2010, Alan Stern wrote:
> > On Mon, 15 Feb 2010, Rafael J. Wysocki wrote:
> > 
> > > On Monday 15 February 2010, Maxim Levitsky wrote:
> > > > On Sat, 2010-02-13 at 15:29 +0200, Maxim Levitsky wrote: 
> > > > > I noticed that currently calling del_gendisk leads to sure deadlock if
> > > > > attemped from .suspend or .resume functions.
> > > 
> > > Well, it shouldn't be called from there, then.
> > 
> > Even if drivers avoid calling it from within suspend methods, they have
> > to be able to call it from within resume methods.  After all, the
> > resume method may find that the disk's device has vanished.
> 
> del_gendisk() needs process context at least, since it'll sleep (not
> just for sync/invalidate, but other parts of the destruction as well).

That's not a problem; suspend and resume run in process context.

> > This is a matter for Jens.  Is the bdi writeback task freezable?  If it
> > is, should it be made unfreezable?
> 
> I'm not a big expect on what tasks should be freezable or not. As it
> stands, the writeback tasks will attempt to freeze and thaw with the
> system. I guess that screws the sync from resume call, since it's not
> running and the sync will wait for it to retrieve and finish that work
> item.
> 
> To the suspend experts - can we safely mark the writeback tasks as
> non-freezable?

The reason for freezing those tasks is to avoid writebacks at random
times during a system sleep transition, when the underlying device may
already be suspended, right?

In principle, a device's writeback task could be unfrozen immediately
after the device is resumed.  In practice this might not solve the
problem, since the del_gendisk() call occurs _within_ the device's
resume routine.  I suppose del_gendisk() could be made responsible for 
unfreezing the writeback task.

The best solution would be to have del_gendisk() avoid waiting for the 
writeback task in cases where the underlying device has been removed.  
I don't know if that is feasible, however.

Alan Stern

P.S.: Jens, given a pointer to a struct gendisk or to a struct
request_queue, is there a good way to tell whether there any dirty
buffers for that device waiting to be written out?  This is for
purposes of runtime power management -- in the initial implementation,
I want to avoid powering-down a block device if it is open or has any
dirty buffers.  In other words, only completely idle devices should be
powered down (a good example would be a card reader with no memory card 
inserted).

