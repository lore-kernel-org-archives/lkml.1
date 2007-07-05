Return-Path: <linux-kernel-owner+w=401wt.eu-S1762737AbXGEUna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762737AbXGEUna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 16:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759890AbXGEUnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 16:43:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51456 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758967AbXGEUnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 16:43:22 -0400
Date: Thu, 5 Jul 2007 16:43:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Miklos Szeredi <miklos@szeredi.hu>
cc: paulus@samba.org, <rjw@sisk.pl>, <mjg59@srcf.ucam.org>,
       <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM
 pathway
In-Reply-To: <E1I6VLD-0001Ks-00@dorka.pomaz.szeredi.hu>
Message-ID: <Pine.LNX.4.44L0.0707051628380.2557-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jul 2007, Miklos Szeredi wrote:

> > > Alan Stern writes:
> > > 
> > > > Remember what I wrote a few minutes ago about khubd and ksuspend_usbd
> > > > wanting to resume devices during a system suspend transition?  This is
> > > > exactly what happens when those threads aren't frozen.
> > > 
> > > So, I wonder why I don't see that error on my powerbook?
> > 
> > That's a good question.  Miklos, can you please reproduce the suspend 
> > error using a kernel built with CONFIG_USB_DEBUG turned on?
> 
> Here's the full dmesg.  First there was a successful suspend/resume,
> then a couple of unsuccessful ones:

Okay, good.  It's not a coincidence that the first one worked and later 
ones didn't.  Here's what happened:

You suspended the system.  Upon resuming, the USB host controller 
drivers detected that their device sessions had been interrupted and 
consequently marked your two USB devices (the optical mouse and the 
biometric thingy) for removal.  Normally that removal would take place 
when khubd wakes up, i.e., after the resume is complete and the thread 
is taken out of the freezer.

But in this case khubd was already awake.  It resumed the two root hubs
in response to their remote wakeup requests and saw that the devices
were gone.  So it unregistered the device structures immediately --
even before the PM core tried to resume them -- and then registered new
data structures to embody the new device connections.  As far as I can
tell, the fact that these new device structures were created while the
suspend-list was in flux must have caused one of them (the biometric
coprocessor) not to be added to the appropriate list.

Thus the next time you tried to suspend, the PM core didn't call the
device's suspend method.  It was left awake, and as a result its parent 
hub refused to suspend (since it had an unsuspended child).  This 
caused the overall system suspend to fail.

This illustrates the folly of allowing other threads to perform 
driver-core-type operations in the middle of a system sleep transition.

Alan Stern

