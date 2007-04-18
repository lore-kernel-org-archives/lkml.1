Return-Path: <linux-kernel-owner+w=401wt.eu-S2993038AbXDRTHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993038AbXDRTHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 15:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993044AbXDRTHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 15:07:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52590 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S2993038AbXDRTH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 15:07:29 -0400
Date: Wed, 18 Apr 2007 15:07:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <htejun@gmail.com>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg K-H <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
In-Reply-To: <46263D0E.2000702@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0704181219250.12246-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007, Tejun Heo wrote:

> More afterthoughts.  If a mutex is used to protect access against
> removal.  There is no reason to hold reference to it.
> 
> kernel_thread()
> {
> 	/* wanna dereference my_obj */
> 	mutex_lock();
> 	verify my_obj is there and use it if so.
> 	mutex_unlock();
> }
> 
> remove()
> {
> 	mutex_lock();
> 	kill_it();
> 	mutex_unlock();
> }
> 
> I probably have over simplified it but using both mutex and reference
> counts doesn't make much sense.  IOW, you get an active reference when
> you grab the mutex excluding its removal and verified it's still there.
> 
> There probably are other reasons why things are done that way and we can
>  and probably will have to resort to mixed solutions in foreseeable
> future but I don't think there is any inherent problem in applying
> immediate-disconnect in the described situation.
> 
> Feel free to scream at me if I'm getting it totally wrong.  :-)

This doesn't solve a related problem: a subsystem wants to register
devices and to provide a set of mutually-exclusive services to the
devices' drivers.  The mutual exclusion has to be provided by a mutex or
something similar, and the drivers need a way to unbind even while waiting
to acquire the mutex.

The obvious answer is to introduce a different sort of synchronization 
primitive: a mutex (or semaphore or rwsem) which can be invalidated.

The semantics would be straightforward.  When mutex_invalidate() is
called, it marks the mutex so that all future lock attempts will fail with
-ENODEV.  It also wakes up all threads that are blocked trying to lock the
mutex and causes them to fail with the same error.  Once all that is done
mutex_invalidate() returns.  In particular, it doesn't wait for the
current lock to be released -- in fact, you would call it while holding
the lock.

This would solve a lot of your problems.  But it would also mean making 
extensive changes to the kernel.  For one thing, mutex_lock() would return 
int instead of void, and you would want to mark it __must_check.  Every 
place where a mutex is locked, the code would have to be changed to add an 
error pathway.  That's the sort of thing I was talking about when I said 
it was going to be a tremendous job.


I thought of something else that could also be done: There should be a way
to cancel an outstanding workqueue request.  At the moment all you can do
is call flush_workqueue(), which will hang if you are already executing in
a workqueue routine.  You should be able to delete a particular entry from
the workqueue (or wait for it to complete if it has already started
running).  This could be implemented right away.


More problems with immediate detach -- it would have to apply to char
devices.  When a char device is unregistered you can't force user
processes to close their open file handles.  Instead something like your
change to sysfs is needed -- wait for outstanding calls to complete and
fail any future calls.  This means that registering a device will use up
more than just a pointer in a table of minor device numbers.  Each entry
would require at least an rwsem, and device I/O would be slowed down by
the need to get a read-lock each time before entering the device driver.

The same idea applies to block devices, although here the problems center 
more around the block core and request queues.

Alan Stern

