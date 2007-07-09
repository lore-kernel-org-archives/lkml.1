Return-Path: <linux-kernel-owner+w=401wt.eu-S1757898AbXGIQD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbXGIQD3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbXGIQDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:03:22 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42014 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753707AbXGIQDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:03:21 -0400
Date: Mon, 9 Jul 2007 12:03:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, <linux-kernel@vger.kernel.org>,
       <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
In-Reply-To: <1183929611.3388.303.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0707091143350.4007-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007, Benjamin Herrenschmidt wrote:

> > This will be up to the people responsible for the subsystems.  I can 
> > take care of USB.
> 
> USB is not that much of a problem in the sense that for most "leaf"
> drivers, USB is a provider (ie, the bus they sit on), not the client
> (like the network stack is to network drivers).

That's why I thought I would be able to handle it!  :-)

> There is still the race of:
> 
> 	drivers_sysfs_write()
> 		try_to_icebox()
> 		<---- <sleep request gets here>
> 		hit hardware
> 
> Those are akin, in some ways, to the freezer races. Some kind of RCU
> might take care of them if we enable the icebox, then wait for all tasks
> to hit an explicit schedule point once (or return to userland). That
> would mean that drivers need to try_to_icebox() again if they do
> something that may schedule (such as __get_user). So it's not a magic
> solution, it has issues, but it can handle a lot of the simplest cases. 

It depends on what kind of race you're worried about.  In general a 
sysfs access that causes I/O isn't much different from a char device's 
read or write.  For such cases the driver would have to do something 
like this:

	drivers_sysfs_write()
	{
	 restart:
		mutex_lock(private_io_mutex);
		if (device is suspended) {
			mutex_unlock(private_io_mutex);
			icebox();
			goto restart;
		}
		... hit hardware ...
		mutex_unlock(private_io_mutex);
	}

And of course the suspend method would have to acquire the
private_io_mutex.  Some drivers might be able to use the device
semaphore instead of adding a new mutex.

I'm more concerned about races involving device registration.  The best 
solution I can come up with is to use an rwsem:

	drivers_sysfs_write()
	{
		down_read(private_rwsem);
		... register/unregister devices ...
		up_read(private_rwsem);
	}

where the suspend notifer callout would do down_write() and the resume
callout would do up_write().  Can you suggest anything better?

> > Drivers are already prepared for device registration to fail (or they
> > ought to be), so this change shouldn't knock the bottom out of things.  
> > device_add() isn't on a hot path, so adding an extra check and
> > srcu_read_lock() won't hurt.
> 
> True. Also, bus drivers could just flag the port with something saying
> "try registering again later". Don't underestimate the power of "try
> later" constructs :-)

-ESUSPENDING would naturally imply that the caller should retry after 
the resume.

Alan Stern

