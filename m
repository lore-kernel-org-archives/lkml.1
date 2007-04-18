Return-Path: <linux-kernel-owner+w=401wt.eu-S2992782AbXDRQLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992782AbXDRQLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 12:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992783AbXDRQLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 12:11:41 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43123 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S2992782AbXDRQLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 12:11:40 -0400
Date: Wed, 18 Apr 2007 12:11:38 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <htejun@gmail.com>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg K-H <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
In-Reply-To: <46263A82.1030703@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0704181149280.12246-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007, Tejun Heo wrote:

> The goal of immediate-disconnect is to remove such lingering reference
> counts so that device_unregister() or driver detach puts the last
> reference count.

Yes, I understand.  If you had immediate-disconnect then you wouldn't need 
device_unregister_wait().  In fact, you wouldn't need any reference counts 
at all.  It would be guaranteed that when the unregister call returned, 
all references would be gone.

> You tell a higher layer that a device is going away, on return from the
> function, that layer isn't gonna access the device anymore.

No, no.  You tell somebody (it might be a higher layer, it might be a 
lower layer, or it might be a same-height layer -- doesn't matter) that a 
device is going away.  On return from the function, that layer isn't going 
to access the device any more, _nor_ will anyone else who has obtained a 
reference from that layer.  This last clause is very important.

> I don't think this is gonna be too difficult to do.  I think I can
> convert block layer and IDE/SCSI drivers without too much problem.
> Dunno much about other layers tho.

You have to convert more than layers (or core subsystems).  You also have 
to audit and convert drivers.  It will be tremendously difficult to do.

> Dunno if I understood the problem right but can't we do the following?
> 
> remove()
> {
> 	acquire sem;
> 	device_del();
> 	release sem;
> 	device_put_wait();
> }

You did misunderstand.  Here's what I was talking about:

Driver A:
---------
	unregister_device(dev);

		/* inside the driver core */
		down(&dev->sem);
		if (dev->driver)
			dev->driver->remove(dev);
		up(&dev->sem);
		device_put(dev);	/* or device_put_wait */


Driver B:
---------
void remove(struct device *dev)
{
	struct my_device *mydev = dev_get_drvdata(dev);

	mydev->gone = 1;
	kref_put(&mydev->kref, my_device_release);
}


Driver B's kernel thread:
-------------------------
	kref_get(&mydev->kref);
	down(&mydev->dev.sem);
	if (mydev->gone)
		goto finished;
	...
 finished:
	up(&mydev->dev.sem);
	kref_put(&mydev->kref, my_device_release);

Consider what happens if the kernel thread blocks on its down() while the
remove() method is running.  It will be impossible for Driver B to
eliminate the reference to dev held by mydev and by the down() routine.

In short, Driver B _can't_ provide an immediate detach.  Not unless 
someone figures out a way to cancel a blocked down().  And do the same 
thing for other blocking primitives.

Alan Stern

