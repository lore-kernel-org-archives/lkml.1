Return-Path: <linux-kernel-owner+w=401wt.eu-S966655AbZLHWHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966655AbZLHWHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 17:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966635AbZLHWH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 17:07:29 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56635 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S966625AbZLHWH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 17:07:26 -0500
Date: Tue, 8 Dec 2009 17:07:32 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
In-Reply-To: <alpine.LFD.2.00.0912081304070.3560@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0912081643290.3046-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Dec 2009, Linus Torvalds wrote:

> On Tue, 8 Dec 2009, Alan Stern wrote:
> > 
> > That's not the way it should be done.  Linus had children taking their
> > parents' locks during suspend, which is simple but leads to
> > difficulties.
> 
> No it doesn't. Name them.

Well, one difficulty.  It arises only because we are contemplating
having the PM core fire up the async tasks, rather than having the
drivers' suspend routines launch them (the way your original proposal
did -- the difficulty does not arise there).

Suppose A and B are unrelated devices and we need to impose the
off-tree constraint that A suspends after B.  With children taking
their parent's lock, the way to prevent A from suspending too soon is
by having B's suspend routine acquire A's lock.

But B's suspend routine runs entirely in an async task, because that
task is started by the PM core and it does the method call.  Hence by
the time B's suspend routine is called, A may already have begun
suspending -- it's too late to take A's lock.  To make the locking
work, B would have to acquire A's lock _before_ B's async task starts.  
Since the PM core is unaware of the off-tree dependency, there's no
simple way to make it work.

> > Instead, the PM core should do a down_write() on each device before
> > starting the device's async suspend routine, and an up_write() when the
> > routine finishes.
> 
> No you should NOT do that. If you do that, you serialize the suspend 
> incorrectly and much too early. IOW, think a topology like this:
> 
> 	a -> b -> c
> 	  \
> 	   > d -> e
> 
> where you'd want to suspend 'c' and 'e' asynchronously.  If we do a 
> 'down-write()' on b, then we'll delay until 'c' has suspended, an if we 
> have ordered the nodes in the obvious depth-first order, we'll walk the PM 
> device list in the order:
> 
> 	c b e d a
> 
> and now we'll serialize on 'b', waiting for 'c' to suspend. Which we do 
> _not_ want to do, because the whole point was to suspend 'c' and 'e' 
> together.

You misunderstand.  The suspend algorithm will look like this:

	dpm_suspend()
	{
		list_for_each_entry_reverse(dpm_list, dev) {
			down_write(dev->lock);
			async_schedule(device_suspend, dev);
		}
	}

	device_suspend(dev)
	{
		device_for_each_child(dev, child) {
			down_read(child->lock);
			up_read(child->lock);
		}
		dev->suspend(dev);	/* May do off-tree down+up pairs */
		up_write(dev->lock);
	}

With completions instead of rwsems, the down_write() changes to
init_completion(), the up_write() changes to complete_all(), and the
down_read()+up_read() pairs change to wait_for_completion().

So 'b' will wait for 'c' to suspend, as it must, but 'e' won't wait for 
anything.

> > Parents should, at the start of their async routine,
> > do down_read() on each of their children plus whatever other devices
> > they need to wait for.  The core can do the waiting for children part 
> > and the driver's suspend routine can handle any other waiting.
> 
> Why?
> 
> That just complicates things. Compare to my simple locking scheme I've 
> quoted several times. 

It is a little more complicated in that it involves explicitly 
iterating over children.  But it is simpler in that it can use 
completions instead of rwsems and it avoids the off-tree dependency 
problem described above.

Alan Stern

