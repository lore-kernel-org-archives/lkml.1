Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535AbXKFPhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbXKFPhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 10:37:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbXKFPgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 10:36:54 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35692 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751729AbXKFPgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 10:36:54 -0500
Date: Tue, 6 Nov 2007 10:36:51 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Peter Zijlstra <peterz@infradead.org>, Oliver Neukum <oneukum@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, apw <apw@shadowen.org>,
       Ingo Molnar <mingo@elte.hu>, <linux-usb-devel@lists.sourceforge.net>
Subject: Re: device struct bloat
In-Reply-To: <20071105224929.GA30521@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0711061021390.3883-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2007, Greg KH wrote:

> On Mon, Nov 05, 2007 at 11:57:14AM +0100, Peter Zijlstra wrote:
> > Hmm, the problem seems to be stuff like:
> > 
> > add usb driver to pci
> >   scan pci devices
> >      add usb host controller device
> >         scan usb devices
> >           add usb hub device
> >             scan usb devices
> >               add usb .....
> > 
> > This seems to be able to go on forever, as long as one can cascade usb
> > hubs.
> 
> USB hubs only work 7 deep, so there is a limit.

In fact things don't work this way.  The list above stops short after
"add usb host controller devices"; the probe routines for host
controllers do not scan for USB hubs or other USB devices.  Instead
they are detected by a completely separate thread (khubd).

> > Doesn't seem like an ideal thing to do from a stack space POV either.
> > 
> > Would it be possible to break at the second scan, that is the device
> > probe and stick that into a workqueue or something. Then we'd only ever
> > have driver->device nesting.
> 
> Alan and Oliver have done some work in this area I think, combined with
> the suspend/bind/unbind issues.  I'll let them comment on your patch :)

I gather the idea is to convert dev->sem to a mutex.  This idea had 
occurred to me a long time ago but I didn't pursue it because of the 
sheer number of places where dev->sem gets used, not to mention the 
lockdep problems.

You can't possibly solve the lockdep problems here with a simple-minded
approach like your DRIVER_NORMAL, DRIVER_PARENT, etc.  The device tree
is arbitrarily deep & wide, and there is at least one routine that
acquires the semaphores for _all_ the devices in the tree.  This fact
alone seems to preclude using lockdep for device locks.  (If there was 
a form of mutex_lock() that bypassed the lockdep checks, you could use 
it and avoid these issues.)

Deadlock is a serious consideration.  For the most part, routines 
locking devices do so along a single path in the tree.  For this simple 
case the rule is: Never acquire a parent's lock while holding the 
child's lock.

The routine that locks all the devices acquires the locks in order of 
device registration.  The idea here is that children are always 
registered _after_ their parents, so this should be compatible with the 
previous rule.  But there is a potential problem: device_move() can 
move an older child under a younger parent!

Right now we have no way to deal with this.  There has been some 
discussion of reordering the dpm_active list when a device is moved, 
but so far nothing has been done about it.

Alan Stern

