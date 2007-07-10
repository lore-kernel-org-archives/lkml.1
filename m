Return-Path: <linux-kernel-owner+w=401wt.eu-S1762667AbXGJRSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762667AbXGJRSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 13:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760405AbXGJRSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 13:18:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39000 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760231AbXGJRSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 13:18:16 -0400
Date: Tue, 10 Jul 2007 13:18:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <htejun@gmail.com>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Sysfs and suicidal attributes
In-Reply-To: <4693A1A5.9070900@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0707101303320.2706-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007, Tejun Heo wrote:

> > Addition during resume is _not_ safe.  The new device can easily get
> > added to the already-processed list in the wrong position, so that the
> > next time the system is suspended the PM core tries to suspend the new
> > device's parent before suspending the new device.
> 
> When a bus device is being woken up and rescanning the bus, all
> prerequisites for the bus should have been resumed already.  As long as
> the newly added device is placed after the bus device itself, things
> should be safe.  Well, that's the theory at least.

What actually happened in practice was that a device send a wakeup
request and hence was resumed without the PM core's knowledge.  As a
result it was still on the "suspended" list when its new child was
added to the end of the "resumed" list.  Then when the PM core got
around to the parent, the parent was placed after the child.  Since the 
"resumed" list is iterated in reverse order for suspending, you see the 
problem.

If the PM core had been holding the parent's semaphore this wouldn't 
have occurred.  But it does illustrate the pitfalls of adding a device 
during resume.

> > I had envisioned using SRCU to synchronize existing device additions
> > with the beginning of a suspend.  down_read_trylock should work just as
> > well (aside from cacheline bouncing).
> 
> How high performance device addition/removal should be?  Wouldn't rwlock
> be enough?

rwlock is a type of spinlock, right?  Hence it can't sleep and can't be
used for device addition/removal.  Also rwlocks aren't fair and are
subject to livelock.

> > Device removal isn't as much of a problem as addition.  We could allow
> > it with no difficulty.  Failing it isn't really an option because
> > device_del() returns void.  And anyway, my idea was to have the PM core
> > acquire all the device semaphores at the start of the suspend -- this
> > would automatically block any attempted removal until the semaphore was
> > released.
> 
> Hmmm... locking all device mutexes sounds scary to me but I tend to be a
> chicken and lockdep is great, so it might just work.  :-)

These aren't mutexes; they are semaphores (although they are used as 
mutexes).  I speculate that part of the reason they have never been 
converted to mutexes is because of potential lockdep issues.

The order of locking isn't a problem.  The list itself defines the 
correct order.

> > What with all the sysfs changes, I wouldn't know where to begin
> > looking.  The idea occurred to me mainly because I was considering
> > blocking all access to sysfs during a suspend -- the problem being that
> > a suspend is itself triggered by a write to a sysfs attribute!  
> > Somehow that write would have to wait for all _other_ existing accesses
> > to complete and block new ones.
> 
> Why is that necessary?  What happens if there's some long-running
> read/write operation using bin attr?

That is certainly a possible problem.  I don't know if there are any 
such long-running operations.

Is it necessary?  No.  But it would make things easier if suspend 
handling could be localized in one place (the sysfs core) instead of 
spread out among a bunch of attribute methods.

Using a freezable workqueue for the callbacks would also localize the 
suspend handling.

Alan Stern

