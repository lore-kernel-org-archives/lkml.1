Return-Path: <linux-kernel-owner+w=401wt.eu-S1752216AbXDUPTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbXDUPTc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 11:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbXDUPTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 11:19:32 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2167 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752216AbXDUPTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 11:19:31 -0400
Date: Sat, 21 Apr 2007 11:19:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Tejun Heo <htejun@gmail.com>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg K-H <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
In-Reply-To: <d120d5000704200857s6661f700ifc18084b32675db0@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0704211102270.26258-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, Dmitry Torokhov wrote:

> On 4/20/07, Alan Stern <stern@rowland.harvard.edu> wrote:
> >
> > Dmitry, in thinking things over some more I realized there's going to be a
> > problem with the autosuspend support in USB.  It has to do with the way a
> > driver needs to prevent (or block) suspends from occurring while it is
> > actively using a device.
> >
> > To understand this, you need to know that USB adds a pm_mutex to the
> > device structure.  It gets used for synchronizing all suspend- or
> > resume-related activities.  In particular, the driver's suspend() method
> > is called with usbdev->pm_mutex held.
> >
> > The next idea is that a driver needs to synchronize its remove() method
> > with other methods such as read() -- we mustn't allow read() to try and
> > refer to the device after the driver has been unbound.  Let's say the
> > driver has unbind_mutex embedded in its private data structure for this
> > purpose.
> >
> > Now consider what read() has to do.  It needs to block suspends from
> > occurring while it runs, and it needs to do an autoresume if the device
> > was already suspended.  So read() will look like this:
> >
> >        mutex_lock(&private->unbind_mutex);
> >        if (private->gone) {
> >                ret = -ENODEV;
> >                goto done;
> >        }
> >        if (private->suspended)
> >                autoresume(private->usbdev);
> >        ...
> >  done:
> >        mutex_unlock(&private->unbind_mutex);
> >        return ret;
> >
> > Meanwhile, the suspend() method needs to block while read() is running.
> > So it will look like this:
> >
> >        private->suspended = 1;
> >        mutex_lock(&private->unbind_mutex);
> >        /* Now the driver has quiesced */
> >        mutex_unlock(&private->unbind_mutex);
> >
> > Here's the problem:  The autoresume() call inside read() tries to acquire
> > usbdev->pm_mutex while holding private->unbind_mutex.  The suspend()
> > method does the reverse, a locking-order violation.
> >
> > So far I haven't figured out any way to make this work.  Do you have a
> > suggestion?  (Don't say read() should hold pm_mutex as well as
> > unbind_mutex; that's no good -- although the reason is rather obscure.)
> >
> 
> First of all I think that I would merge pm and unbind mutex into one -
> you also need to synchronize resume and suspend with bind and unbind
> so you pretty much need to always acquire both of them.

The USB core already insures that suspend and resume are mutually 
exclusive with bind and unbind, so that part doesn't matter.

Besides, there's a more important reason for not merging the pm and unbind
mutexes: The pm mutex lies in the usb_device structure but the unbind
mutex lies in the private data structure.

It has to be this way.  The pm mutex is used by the USB core, which
doesn't know anything about the private data.  Conversely, the driver has
to acquire the unbind mutex at times when it doesn't know whether or not
it has already been unbound, so that mutex must go in the private data.  
Otherwise the driver might try to acquire the mutex -- thereby touching
the usb_device -- after it was unbound, violating immediate detachment.

> Second (and I admit I have not followed USB autoresume discussions, my
> usb-devle backlog is over 5000 messages ;( ) is I am not sure why
> woudl a read block autoresume. I can see write doing that but passive
> reads should not affect device state.

I was just using read() as an example.  And it wouldn't block autoresume;
it would _do_ an autoresume, thereby preventing autosuspend.

Another possible arrangement would be to have open() do an autoresume
(preventing autosuspend during the entire time the device file is held
open) and have close() re-enable autosuspend.  But the principle remains
the same.

I don't know, perhaps adding another mutex would work.  I need to think 
about it some more.

There's always the easy solution: Don't do a complete immediate detach.  
The driver could keep a reference to the device structure for an extended
period, provided it always checks private->gone whenever it locks
usbdev->sem.  This would mean that the USB core might not be able to
release usbdev until the lower-level driver was unloaded.  But that's
okay: Since the lower-level driver contains code references to routines in
the USB core, the core would be pinned anyway.

This example does show that implementing immediate detach comes with a
price.  It makes things more complicated than they would be otherwise.

Alan Stern

