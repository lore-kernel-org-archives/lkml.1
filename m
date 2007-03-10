Return-Path: <linux-kernel-owner+w=401wt.eu-S932228AbXCJUoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228AbXCJUoG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 15:44:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932241AbXCJUoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 15:44:06 -0500
Received: from netrider.rowland.org ([192.131.102.5]:2502 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932228AbXCJUoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 15:44:05 -0500
Date: Sat, 10 Mar 2007 15:44:01 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Oliver Neukum <oneukum@suse.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, <gregkh@suse.de>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc suspend regression: sysfs deadlock
Message-ID: <Pine.LNX.4.44L0.0703101542160.11316-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[For the start of this thread, see 
<http://marc.theaimsgroup.com/?l=linux-kernel&m=117320893726621&w=2>.]

On Wed, 7 Mar 2007, Linus Torvalds wrote:

> So you just pointed to *another* data structure that apparently violates 
> the "you MUST use refcounting" rule.
> 
> What is it with you people? It's really simple. Data structures must be 
> refcounted if you can reach them two different ways.
> 
> If you don't use refcounting, then you'd better make sure that the data 
> can be reached only one way (for example, by *not* exposing it for sysfs).
> 
> It really *is* that simple. Read the CodingStyle rules.

Linus's analysis is correct as far as it goes, but it misses some very 
important points.  The _real_ problem here, which nobody has pointed out 
so far, is not device removal or driver unloading.  It is driver 
unbinding -- with its consequent issue of access rights.

When a driver is unbound from a device, when should the driver stop trying 
to access that device?  The obvious answer is that it must stop before its 
release() method returns.  Otherwise the device might get bound to 
another driver and we would have both drivers trying to talk to it at the 
same time.

In other words, when a driver unbinds from a device, it loses its right to
access that device.  Same goes for any device-related data structures that
weren't created by the driver itself.  When you realize this, it becomes
obvious that the driver faces a synchronization problem.  All its entry
points must be synchronized with release(), to avoid races.

So there actually are two things a driver has to worry about:

	The lifetime of its private data structures (which can be solved
	using refcounts as Linus advocated);

	The race between release() and other activities (which cannot
	be solved by refcounts but needs a true synchronization technique,
	such as a mutex).

No doubt some of this sounds familiar; the race between open() and
disconnect() for char device drivers is one we have faced many times and
not always solved perfectly.  Also note that this is a fundamental
problem, affecting many facilities in addition to sysfs.


One way to solve these problems is to put all the responsibility on the 
driver.  Make it refcount its data structures and use mutexes.  This is 
not very attractive for several reasons:

	_Lots_ of drivers are affected.  Pretty much any driver which
	registers a char device or a sysfs attribute file.

	_Lots_ of code would need to be changed, adding considerable
	bloat.  Every show()/store() method would need to acquire a mutex,
	and many would need to be passed an additional argument, requiring
	a change in the sysfs API.  (I can explain why in a follow-up 
	email if anyone is interested.)

	Most importantly, doing all the refcounting and mutual exclusion
	correctly is quite hard.  It's amazingly easy to make mistakes
	in these areas.  The chances of getting it right while changing
	multiple functions in every single driver are infinitesimal.

Another approach is to put all the responsibility on the core subsystems
that handle driver registration.  They should enforce rigidly two
principles: "No driver callbacks occur after unregistration" and its
prerequisite, "Unregistration is mutually exclusive with driver
callbacks".  (This is exactly what Oliver's original patch did for sysfs.)

	The number of core subsystems affected is much smaller than the
	total number of drivers.  Sysfs, debugfs, the char device
	subsystem, maybe a few others.

	Drivers would no longer have to worry about doing their own
	synchronization or refcounts.  It would be guaranteed that a
	private data structure would never be accessed from sysfs after
	device_remove_file() returned, so the structure could safely and
	easily be deallocated as part of release().

At the expense of complicating a few central subsystems, we could simplify
a lot of drivers.  I think this is a worthwhile tradeoff.

It does have a small disadvantage; it means that an entry point would
deadlock if it tried to unregister itself.  (The example which started
this whole thread was sdev_store_delete() in the SCSI core.  Writing to
that attribute unregisters the device to which it belongs.)  Clearly the
actual unregistration would have to performed separately in a workqueue.  
I think the number of places where this occurs is pretty small.


It's true that this approach goes against the general philosophy used
elsewhere in the kernel.  Refcounting without synchronization is the
general rule.

However unbinding is a special case.  Normally with refcounting, it
doesn't matter when a driver tries to read or write a data structure.  So
long as the driver still holds a reference, the data will be there and the
access will be okay.

But not with unbinding!  After unbinding, the data will still be there but 
it might be owned by another driver.  Even worse, instead of just 
accessing data the code might try to access the device.

The basic assumption behind the refcounting approach is that a resource 
will be used for one purpose and then discarded, so accessing it will 
always be okay.  Driver unbinding violates this assumption; the devices 
and data structures that a driver binds to can be bound, unbound, and 
rebound multiple times.  Simple refcounting isn't sufficient to handle the 
situation.


In short, I think Oliver's original patch should be reinstated.  
(sdev_store_delete() can easily be rewritten to use a workqueue.)  Not
only that, it should be exanded upon.  For instance, it handles regular
sysfs files but it ignores binary files -- a clear oversight.  Debugfs and
the char device subsystem should be modified similarly.  Maybe also
procfs, and perhaps others.

Alan Stern

