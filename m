Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbXDMPZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbXDMPZF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 11:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbXDMPZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 11:25:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51220 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754043AbXDMPZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 11:25:03 -0400
Date: Fri, 13 Apr 2007 11:24:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Cornelia Huck <cornelia.huck@de.ibm.com>
cc: Tejun Heo <htejun@gmail.com>,
       Markus Rechberger <markus.rechberger@amd.com>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: How should an exit routine wait for release() callbacks?
In-Reply-To: <20070413162701.4e7342a9@gondolin.boeblingen.de.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0704131049380.3407-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun, it just occurred to me that you would be interested in this email 
thread.  Just to bring you up to speed, here's the original question:

> I've got a module which registers a struct device.  (It represents a
> virtual device, not a real one, but that doesn't matter.)  Obviously the
> module's exit routine has to wait until the release() routine for that
> device has been invoked -- if it returned too early then the release()
> call would oops.
> 
> How should it wait?
> 
> The most straightforward approach is to use a struct completion, like 
> this:
> 
> 	static struct {
> 		struct device dev;
> 		...
> 	} my_dev;
> 
> 	static DECLARE_COMPLETION(my_completion);
> 
> 	static void my_release(struct device *dev)
> 	{
> 		complete(&my_completion);
> 	}
> 
> 	static void __exit my_exit(void)
> 	{
> 		device_unregister(&my_dev.dev);
> 		wait_for_completion(&my_completion);
> 	}
> 
> The problem is that there is no guarantee a context switch won't take
> place after my_release() has called complete() and before my_release()  
> returns.  If that happens and my_exit() finishes running, then the module
> will be unloaded and the next context switch back to finish off
> my_release() will oops.


On Fri, 13 Apr 2007, Cornelia Huck wrote:

> In this case the race is not a user space vs. kernel object one (where
> you can track users). Basically the problem is as follows:
> 
> - A module registers a device. The device's release function is defined
> in the module.
> - Since the device can now be looked up in the device tree, someone can
> obtain a reference to it (e. g. by walking the tree).
> - The module is unloaded. In its exit function, it deregisters the
> device. The module has now given up any reference to the device it
> held, however the someone from above still holds a reference. While no
> new reference to the device can be obtained, the device still exists.
> - After the module is unloaded, the device's release function goes away.
> - The last reference to the device is given up. The driver core now
> tries to call the device's release function, which was in the deleted
> module. Oops.
> 
> The completion approach unfortunately still leaves a race window, as
> Alan explained in his original mail.

After thinking about it some more, I realized the conventional answer 
would be to give out a module reference.  When the device is registered, a 
reference to it and its release routine gets passed to the driver core.  
Hence a module reference to the owner of the release routine must be 
passed as well.

Unforunately that won't work very well in this case, because it would 
create circular module references preventing the driver from ever being 
unloaded at all!  Here's what I mean:

	my_device is registered with some core subsystem.  The subsystem
	acquires a module reference to my module and registers a child
	of my_device.  It can't drop the module reference until the
	child is gone and it has finished using my_device.  So my driver
	can't be unloaded until it deregisters my_device or the subsystem
	itself is unloaded (and unregisters the child).

	But the module containing my driver depends on the subsystem,
	because it calls the subsystem's registration routine.  So the
	subsystem can't be unloaded without unloading my driver first.

What's needed is a way to force my driver to unregister itself without
actually unloading it from memory.  One way to accomplish this would be to
tell rmmod that it should call the module's exit routine but then wait
for the module's refcount to drop to 0 before unloading it.  Like doing 
rmmod -w.

However even this would have a problem.  Let's say my_exit() unregisters 
my_device.  Eventually the child's release routine runs, and it does a 
put_module() on my module.  At that point my module can be unloaded.  But 
my_release() still hasn't been called!  The subsystem's release routine 
runs first, because children are released before their parents.

I have to admit, this is a puzzler.  I'm beginning to think there should 
be two types of module references: Those which (like module dependency) 
will prevent rmmod from running, and those which (like the one here) would 
automatically be dropped by deregistration.  Then every kobject could have 
an owner and could hold a reference of the second type to its owner until 
its release routine returns.

Alan Stern

