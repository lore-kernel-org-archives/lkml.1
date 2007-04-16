Return-Path: <linux-kernel-owner+w=401wt.eu-S1030923AbXDPTxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030923AbXDPTxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 15:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030926AbXDPTxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 15:53:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55664 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030923AbXDPTxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 15:53:32 -0400
Date: Mon, 16 Apr 2007 15:53:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Patch -mm 3/3] RFC: Introduce kobject->owner for refcounting.
In-Reply-To: <20070416180559.GA5662@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0704161539110.2685-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2007, Greg KH wrote:

> On Mon, Apr 16, 2007 at 07:36:27PM +0200, Cornelia Huck wrote:
> > Grab and release the module kobject refcount if kobj->owner is set.
> > This prevents calls to the release function after the module has
> > been unloaded.
> 
> But doesn't this cause reference counts to be grabbed on modules that
> don't want them?  (like network drivers)?

The refcounts we are talking about will not prevent modules from being 
unloaded.  That is, they won't cause rmmod to fail -- they will simply 
cause it to wait until the refcount drops to 0.  This should happen 
naturally as a result of the unregistration calls made by the module's 
exit routine.

(That was the intention, anyway.  I haven't yet seen all the parts of 
Cornelia's patch set, but that's how we discussed it.)

> I don't understand what exactly you are trying to protect from here.
> Especially as Tejun just ripped the lifetime rules between sysfs and
> kobjects apart.

There are other ways for userspace to acquire references to kernel 
objects.  Think of procfs or debugfs, for example.  Or opening a device 
file.

Consider this example:  A user has a pcmcia card containing a USB host 
controller.  He plugs a USB flash drive into the card and mounts a 
filesystem stored on the flash drive.  The mount call increments the 
module refcount for usb-storage (the owner of the block device containing 
the filesystem), but it doesn't do anything to the module refcount for the 
pcmcia driver (I forget its name -- yenta or something like that).

So what happens if the pcmcia driver is unloaded while the filesystem is
mounted?  What happens when the filesystem is finally unmounted and a
release method belonging to the pcmcia driver is called?

The fundamental rule is that whenever you hand out a pointer to a routine
living in a module, the receiver has to increment the module's refcount.  
But the driver core violates this rule all over the place.  The most
pervasive offender is struct device -- it contains a release() method
pointer which often points into a module, but the driver core doesn't
do anything like try_module_get() in device_initialize() or module_put()
after calling dev->release().

Alan Stern

