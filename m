Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbZLDVgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbZLDVgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 16:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757347AbZLDVgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 16:36:17 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:48836 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757266AbZLDVgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 16:36:16 -0500
Date: Fri, 4 Dec 2009 16:36:22 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Greg KH <gregkh@suse.de>, <stable@kernel.org>,
       Rickard Bellini <rickard.bellini@ericsson.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       Torgny Johansson <torgny.johansson@ericsson.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Driver core: fix race in dev_driver_string
In-Reply-To: <200912042218.11410.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0912041625360.3070-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Dec 2009, Oliver Neukum wrote:

> Am Freitag, 4. Dezember 2009 21:57:50 schrieb Alan Stern:
> > On Fri, 4 Dec 2009, Oliver Neukum wrote:
> > > > > 1. am I supposed to get a reference just so that I can use dev_err?
> > > >
> > > > No, you should already have a reference on the device when doing the
> > > > call, right?
> > >
> > > No, why? Consider this:
> > >
> > > int write(...)
> > > {
> > > 	...
> > > 	mutex_lock(&instance->lock);
> > > 	if (instance->disconnected) {
> > > 		dev_dbg(instance->dev,"writing to disconnected device");
> > > 		rv = -ENODEV;
> > > 	} else {
> > > 		res = usb_submit_urb(...);
> > > 		rv = res < 0 ? -EIO : count;
> > > 	}
> > > 	mutex_unlock(&instance->lock);
> > > 	return rv;
> > > }
> > >
> > > void disconnect(...)
> > > {
> > > 	...
> > > 	mutex_lock(&instance->lock);
> > > 	instance->disconnected = 1;
> > > 	usb_kill_urb(...);
> > > 	usb_kill_urb(...);
> > > 	mutex_unlock(&instance->lock);
> > > }
> > >
> > > This would be perfectly valid code without any references taken save
> > > for the pesky dev_dbg()
> > 
> > Whoever calls write() must possess a valid reference.  Otherwise
> > instance might already be deallocated when write() starts, causing an
> > oops well before the call to dev_dbg().
> 
> He needs a valid reference to "instance", not to the device. In fact
> he may do IO to the device only if he knows it hasn't been disconnected.

Okay, yes.  In fact, that is what your write() routine does -- it
checks the disconnected flag.

> > Typically the driver would take a reference during open() and drop it
> > during close().
> 
> You can do that but then you must not do IO prior to open() or after
> close(). That is you must actually wait for IO to finish in close() and
> cannot prefill your buffers before open().

If open() or close() is called before disconnect() then you don't have 
to worry.

If close() is called after disconnect() there's nothing to wait for, 
because disconnect() should call usb_kill_urb() on all outstanding 
transfers (actually usbcore will do that for you).  Likewise with 
open().

The problem in this example stems from the fact that you are using
instance->dev at a time when you don't know that it is valid -- in
fact, you have good reason to believe it _isn't_ valid because
instance->disconnected is set.

One approach is to set instance->dev to NULL in disconnect().  That
wouldn't do much good for your dev_dbg(), though.  A better solution is
to refcount the instance->dev pointer: Take a reference to the device
when setting instance->dev and drop it when clearing instance->dev (or
when instance is freed).

Alan Stern

