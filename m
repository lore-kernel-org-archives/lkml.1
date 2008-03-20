Return-Path: <linux-kernel-owner+w=401wt.eu-S1759273AbYCTW5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273AbYCTW5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 18:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbYCTW5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 18:57:07 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4505 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753188AbYCTW5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 18:57:06 -0400
Date: Thu, 20 Mar 2008 18:57:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [RFC][PATCH 1/3] PM: Introduce new top level suspend and
 hibernation callbacks
In-Reply-To: <1206052477.8420.26.camel@pasglop>
Message-ID: <Pine.LNX.4.44L0.0803201841520.8453-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Benjamin Herrenschmidt wrote:

> 
> On Thu, 2008-03-20 at 14:26 -0400, Alan Stern wrote:
> > 
> > One of the things we don't want to do is bind a new driver to a device
> > after it has gone through the prepare() stage.  Doing so would involve
> > calling the driver's probe() routine, which is likely to want to
> > register new children and who knows what else.  The probe routine might 
> > even end up running after the device was suspended!  Clearly this 
> > should be avoided.
> > 
> > But the user can force a binding to occur by writing the device's path
> > to the driver's "bind" attribute in sysfs.  This means that
> > driver_bind() in drivers/base/bus.c will need to know whether or not
> > the device has gone through the prepare() stage, which means the device
> > structure will need to have a flag set before prepare() is called (more 
> > precisely, the flag must be set before dev->sem is released following 
> > the call to prepare).
> > 
> > Either that or else driver_bind() must always block whenever a system
> > sleep is in progress.  That would be easier -- but it's a lot like what 
> > the freezer would do.  Which would you prefer?
> 
> I don't fully understand what you are saying here.
> 
> You say "bind a new driver to a device after it has gone through the
> prepare() stage"
> 
> So either there was already a driver bound to that device, which got a
> prepare() callback, and in which case bind() doesn't mean much. Or there
> was not, in which case there was no prepare() call involved.

That's why I said "gone through the prepare() stage" instead of saying 
"after prepare() was called".  Yes, if there's no driver bound then 
there's no method to call.  But the PM core will still pass the device 
to a subroutine whose job is to call the corresponding method, if one 
exists.

> I suppose if you prepare(), then unbind(), then something tries to
> bind()... But wouldn't the core flag set after prepare() be plenty
> enough to shield against that ?
> 
> I fail to see the race you are talking about here.

Let's say Task 0 is starting a sleep transition when Task 1 calls
driver_bind():

	Task 0				Task 1
	------				------
	down(&dev->sem) succeeds	down(&dev->sem) blocks
	Sees that dev has no driver
	  so there is no prepare
	  method to call
	up(&dev->sem)
					down() succeeds
					Sees that dev->power.prepared
					  flag isn't set
					Calls (drv->probe)(dev)
	Sets dev->power.prepared
	  flag
					drv tries to register a child
					  device and fails for no good
					  reason

One way to fix this is to set dev->power.prepared before releasing
dev->sem.  Another way to fix it is to have driver_bind() block
(as though it were frozen) whenever a system sleep is underway.

Which do you prefer?

Alan Stern

