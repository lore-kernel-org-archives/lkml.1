Return-Path: <linux-kernel-owner+w=401wt.eu-S1754223AbXDSWhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbXDSWhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 18:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbXDSWhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 18:37:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47956 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754223AbXDSWhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 18:37:16 -0400
Date: Thu, 19 Apr 2007 18:37:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Tejun Heo <htejun@gmail.com>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg K-H <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
In-Reply-To: <d120d5000704191139m3caf4cfeqd95047d1c33faf64@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0704191744380.6354-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007, Dmitry Torokhov wrote:

> On 4/19/07, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Wed, 18 Apr 2007, Dmitry Torokhov wrote:
> >
> > > I am still do not understand why this is needed. Would it not be
> > > simplier just to use a reference to struct device instead of embedding
> > > it in a larger structure if their lifetimes are different and one does
> > > not have a subsystem that takes care of releasing logic.
> > >
> > >
> > > Pretty much drivers have 2 options:
> > >
> > > struct my_device {
> > >         void *private_data;
> > >         struct device dev;
> > > };
> >
> > Actually people use dev_[gs]et_drvdata() instead of a separate
> > private_data pointer.  That way there's no need for the my_device
> > container.
> >
> 
> No, drvdata belongs to driver that is bound to a device. We are
> talking about private data created and managed by driver that provides
> device.

Oh, sorry, I misunderstood.

> Again, if we are talking about driver bound to a device then devices
> ->release() is irrelevant. If we are talking about driver that created
> device then driver's ->remove() is irrelevant.

The problem is that device structures carry references to their parents.  
So even if a driver does use this option and is able to give up its own 
references immediately, it can't make any guarantees about drivers of 
child devices.  If every driver followed your scheme we'd be okay; until 
then any ancestor of a device with a non-immediate-detach driver would not 
be able to do immediate detach.

There's also another problem.  Even though all the references to
my_dev->dev may be gone, there will probably still be outstanding
references to private_data structure.  The driver's exit() routine will 
have to wait until all those references are gone.  How can it do that 
safely?  Presumably the private_data will include its own refcount and 
some release routine will run when the count drops to 0.  That routine 
will be part of the driver's module -- so how can it enable itself to be 
unloaded?


> > > With current sysfs orphaning attributes upon removal request there is
> > > no issue of accessing driver-private data through references obtained
> > > via ether embedded or referenced dev structure so everything is fine.
> >
> > Not so.  There are other pathways besides sysfs which can cause a driver
> > to access its data structures.
> >
> 
> Which ones? These needs to be identified and treated with "immediate
> disconnect" that you advocated earlier. Once active users of device's
> services are gone you can zap it.

Among the worst offenders are character devices.  None of the subsystem
providers offering char device registration performs immediate detach --
they are a lot like sysfs used to be.  (In fact, they probably _can't_
provide it since read() or write() calls can block indefinitely in the
lower-level driver; the subsystem may have no way to force them to
fail-fast.)  So every lower-level driver which registers a char device
needs to provide its own synchronization and immediate detach, and at the
moment I doubt very many of them do.  And of those which do, a large
percentage rely on the BKL for synchronization!

Here's another awkward possibility.  Suppose a workqueue routine tries to 
unregister a device.  Suppose the device's driver needs to do something in 
a process context, so it has a work item pending in the same workqueue.  
The driver's remove() method would need to flush the workqueue (in order 
to perform immediate detach), but doing so would cause a deadlock.

Alan Stern

