Return-Path: <linux-kernel-owner+w=401wt.eu-S932224AbXDTPBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbXDTPBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 11:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992865AbXDTPBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 11:01:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55288 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932224AbXDTPBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 11:01:45 -0400
Date: Fri, 20 Apr 2007 11:01:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <htejun@gmail.com>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg K-H <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
In-Reply-To: <46284F2A.4000401@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0704201016260.2616-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, Tejun Heo wrote:

> Hello, Alan.
> 
> Alan Stern wrote:
> > This doesn't solve a related problem: a subsystem wants to register
> > devices and to provide a set of mutually-exclusive services to the
> > devices' drivers.  The mutual exclusion has to be provided by a mutex or
> > something similar, and the drivers need a way to unbind even while waiting
> > to acquire the mutex.
> 
> I don't really follow why the drivers need a way to unbind even while
> waiting to acquire the mutex.  Care to enlighten me?

Forget I mentioned it.  It isn't a problem if the subsystem uses its own
mutex to provide the mutual exclusion.  Things become difficult only
if the subsystem tries to use dev->sem.

> > I thought of something else that could also be done: There should be a way
> > to cancel an outstanding workqueue request.  At the moment all you can do
> > is call flush_workqueue(), which will hang if you are already executing in
> > a workqueue routine.  You should be able to delete a particular entry from
> > the workqueue (or wait for it to complete if it has already started
> > running).  This could be implemented right away.
> 
> It all depends on how a particular subsystem is shaped but having such
> thing would definitely help.

I saw something recently suggesting such a thing is already present in
Andrew Morton's queue.  Great minds think alike...  :-)


> Yeah, exactly.  My argument is that that impedance matching between
> lifetime rules must happen at some place and it's better if we can do in
> the higher layer where we can afford more effort and thus complexity.
> We're currently pushing that down to each drivers and not too many are
> getting it right.  I think it's just unrealistic to expect every and
> each driver subsystems to get it right, so some overhead at higher layer
> is acceptable and we can definitely afford much more optimization at
> higher layer.

Agreed.


You know, things may not be quite as bad as I had thought.  I was under 
the impression that the driver core did put_device(dev->parent) during 
device_release().  But that's not the case; the call is made during 
device_del().

This makes things very different.  Failure to drop references to a device
during remove() won't cause any lingering references to the device's
parent.  The effects of one badly-behaved driver won't propagate
indefinitely far up the device tree.

On the other hand, although devices behave this way, kobjects do not.  The 
call to kobject_put(kobj->parent) is in kobject_cleanup(), not in 
kobject_del() or unlink().  So this still needs to be fixed.  It may be 
related to the sysfs <-> kobject link you have been trying to break.


Dmitry, in thinking things over some more I realized there's going to be a
problem with the autosuspend support in USB.  It has to do with the way a
driver needs to prevent (or block) suspends from occurring while it is 
actively using a device.

To understand this, you need to know that USB adds a pm_mutex to the
device structure.  It gets used for synchronizing all suspend- or
resume-related activities.  In particular, the driver's suspend() method
is called with usbdev->pm_mutex held.

The next idea is that a driver needs to synchronize its remove() method
with other methods such as read() -- we mustn't allow read() to try and
refer to the device after the driver has been unbound.  Let's say the
driver has unbind_mutex embedded in its private data structure for this 
purpose.

Now consider what read() has to do.  It needs to block suspends from 
occurring while it runs, and it needs to do an autoresume if the device 
was already suspended.  So read() will look like this:

	mutex_lock(&private->unbind_mutex);
	if (private->gone) {
		ret = -ENODEV;
		goto done;
	}
	if (private->suspended)
		autoresume(private->usbdev);
	...
 done:
	mutex_unlock(&private->unbind_mutex);
	return ret;

Meanwhile, the suspend() method needs to block while read() is running.  
So it will look like this:

	private->suspended = 1;
	mutex_lock(&private->unbind_mutex);
	/* Now the driver has quiesced */
	mutex_unlock(&private->unbind_mutex);

Here's the problem:  The autoresume() call inside read() tries to acquire
usbdev->pm_mutex while holding private->unbind_mutex.  The suspend()  
method does the reverse, a locking-order violation.

So far I haven't figured out any way to make this work.  Do you have a
suggestion?  (Don't say read() should hold pm_mutex as well as
unbind_mutex; that's no good -- although the reason is rather obscure.)

Alan Stern

