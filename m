Return-Path: <linux-kernel-owner+w=401wt.eu-S1757761AbYGaTQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761AbYGaTQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 15:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbYGaTQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 15:16:36 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50400 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752173AbYGaTQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 15:16:36 -0400
Date: Thu, 31 Jul 2008 15:16:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Simon Arlott <simon@fire.lp0.eu>
cc: Rene Herman <rene.herman@keyaccess.nl>,
       Arjan van de Ven <arjan@infradead.org>, <linux-kernel@vger.kernel.org>,
       <mingo@elte.hu>, Daniel Walker <dwalker@mvista.com>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [patch 5/3] fastboot: sync the async execution before     
 late_initcall and move level 6s (sync) first
In-Reply-To: <48920481.7010702@simon.arlott.org.uk>
Message-ID: <Pine.LNX.4.44L0.0807311510220.5019-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008, Simon Arlott wrote:

> > If it were a module then it would block in a separate thread and 
> > wouldn't hold up the main init process.
> 
> Right, but I want to compile all of this into the kernel.

Okay, that explains things.  But this means that changes which are 
helpful on your system might not be so helpful (or might even be 
detrimental) on other people's systems.

> > It's not entirely clear why usblp is blocking at all.  Probably because
> > it is waiting on the device semaphores for devices that are currently
> > being probed -- the driver core won't allow two threads to probe the
> > same device concurrently.
> 
> Ok - so there could be some big improvements to be had by making the hcd 
> init happen as early as possible and the device initcalls later?

Maybe.  Perhaps a better approach would be to make the device driver 
initcalls before there are any devices for their probe routines to 
block on.

> > Driver probing is always going to be a bottleneck, even for
> > non-matching device/driver pairs.  That's because the driver core
> > acquires the device semaphore even before calling the bus's match
> > routine.  When a new driver is registered, the driver core just goes
> > down the list of all devices registered on the bus, locking each one in
> > turn and trying to match & probe it.
> 
> So could HCD init be moved higher in the initcall order so that the devices 
> have been initialised enough by khubd that device driver initcalls take 
> much less time?
> 
> I'm not really sure how to do that, except by doing usb/core/ usb/host/ 
> and then usb/class/ usb/storage/ etc....

Try doing this instead: Put a 5-second delay at the start of 
hub_thread().  That will give the in-kernel device drivers time to 
initialize before any USB devices -- other than root hubs -- are 
discovered.  That should speed up the init timings.

For everyone else, it will slow down USB device discovery by 5 seconds.  
I don't know how important that is, considering how much other stuff is 
going on at boot time.  You may find that 5 seconds is more than you 
need; perhaps 1 second will be enough.

Alan Stern

