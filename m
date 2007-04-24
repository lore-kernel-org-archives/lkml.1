Return-Path: <linux-kernel-owner+w=401wt.eu-S1423067AbXDXTiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423067AbXDXTiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 15:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423072AbXDXTiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 15:38:15 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39399 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1423067AbXDXTiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 15:38:14 -0400
Date: Tue, 24 Apr 2007 15:38:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Tejun Heo <htejun@gmail.com>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
In-Reply-To: <20070422174051.GA21680@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0704241501170.2647-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Apr 2007, Greg KH wrote:

> > Looking some more, kobject_get_path() is used for kobject renaming,
> > uevent handling, and a little bit in the input core.  None of these things 
> > should try to access a kobject after it has been del()ed.  After all, it's 
> > no longer present in the filesystem so it doesn't _have_ a path.
> 
> But we _have_ to have a full path at that time to tell userspace what
> just went away.  That is the main reason we enforce this (there were
> tons of issues with scsi devices and this in the past which is what
> caused us to enforce this.)

The SCSI subsystem has undergone many, many changes since 2.6.0.  In 
particular, it has implemented a full-fledged device-state model, complete 
with spinlock-protected state transitions.

I'll have to check with James Bottomley, but I bet that SCSI now always 
unregisters all the children of a device before unregistering the device 
itself.


For everyone:

We ought to make it explicitly clear that _all_ subsystems should behave
this way.  Maybe it isn't necessary to go as far as having device_del()
call itself recursively; doing that would open up lots of possible races.  
But I think it would be a good idea to add a WARN_ON in device_del, right
after the call to bus_remove_device(), that would be triggered if the
device still had any children.

It would also be good to document (but where?) some lifetime rules for 
device drivers.  Something like this:

	When a driver's remove() method returns, the driver must no
	longer try to use the device it was just unbound from.  The
	device may be physically gone, or a different driver may be
	bound to it.  Most importantly, remove() should unregister
	all child devices created by the driver.

	To accomplish all this safely, the driver should allocate a
	private data structure containing at least a "gone" flag and 
	a mutex or spinlock for synchronization.  Each time the driver
	needs to use the device, it should first lock the mutex or 
	spinlock and check the "gone" flag.

	Ideally remove() should release all of the driver's references
	to the device, in accord with the "Immediate Detach" principle.
	However it is acceptable for the driver to retain a reference,
	provided it meets the following conditions:

		The reference must be dropped in a timely manner,
		such as when the release() methods for all child
		devices have run.

		The driver must also retain a module reference to
		the owner of the device.  In practice this means the
		driver must contain static code references to the
		subsystem which created the device, since struct
		device doesn't have an "owner" field.

		The driver must restrict itself to reading (not
		writing!) the fields in the device structure.  The
		only exception is that the driver may lock/unlock
		dev->sem.

How does that sound?

Alan Stern

