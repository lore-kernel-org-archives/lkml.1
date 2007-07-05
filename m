Return-Path: <linux-kernel-owner+w=401wt.eu-S1761326AbXGEOmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761326AbXGEOmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 10:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbXGEOmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 10:42:16 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33025 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752550AbXGEOmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 10:42:16 -0400
Date: Thu, 5 Jul 2007 10:42:15 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Paul Mackerras <paulus@samba.org>
cc: Johannes Berg <johannes@sipsolutions.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
 RAM pathway
In-Reply-To: <18060.15591.556676.28935@cargo.ozlabs.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0707051025500.3728-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jul 2007, Paul Mackerras wrote:

> Alan Stern writes:
> 
> > > > Yes, the code could be changed to keep track of the reason for a device
> > > > suspend.  But that just raises the old problem of what to do when
> > > > there's an I/O request for a suspended device during STR.
> > > 
> > > Is this actually a real problem?  I would think the policy would be
> > > "block" for block devices (pun not intended :), "drop" for network
> > > devices, etc.
> > 
> > It is indeed a real problem, or at least, it can be.
> 
> How so?  Can you give me an example?

The example I quoted earlier about binding during a suspend will do.  I 
agree that we can and should try to prevent it from ever occurring.

Read and write are a problem only in that fixing them would potentially
involve changing lots of drivers; I don't think they pose a serious
theoretical obstacle.  (Lord knows what will happen with async I/O!)

Any other entry points to drivers are also potential problems, but it's 
hard to say anything definite about them since they are so varied.

> > Bus subsystems can suspend devices with no drivers.
> 
> Interesting.  I assume this is for buses for which there is a
> bus-specific but device-independent suspend procedure defined.

Yes.

> It would seem sensible to me that the PM core should get the bus to
> resume such a device before calling a driver probe routine.  The
> resume should be blocked or deferred while a system suspend is
> underway.  In fact I think that all driver bind/unbind and probe
> operations should be deferred while the system is suspending (i.e. put
> on a list to be done after the system resumes).

Getting the PM core to resume a device before probing could be 
difficult; in general it doesn't know enough about specific device 
behaviors to do something like that.  But the subsystem certainly ought 
to take care of it.  USB does.

Yes, bind/unbind/etc. should be deferred during a system suspend.  But
it has to be done carefully, because these operations generally involve
locks that can't be released.  They need to be prevented at their
source, not in the driver core.  That's one reason why khubd needs to
be frozen (being part of the USB hub driver, it is the task responsible
for binding and unbinding drivers to USB devices).

Another thing to look out for is registration and unregistration of 
drivers.  These activities also cause bind/unbind operations.  Note 
that if userspace is frozen then neither insmod nor rmmod can run.  :-)

> > It would help.  It would help even more if the sysfs core also blocked
> > all I/O while suspend is under way.  (Although this might be tricky, 
> > considering that the suspend is initiated by a sysfs write...)
> 
> I didn't think sysfs got involved at all in normal read and write
> requests, so I don't know how it would block them...

All I/O to sysfs attributes passes through the routines in fs/sysfs/*.  
It could be blocked there.  (But if userspace is frozen it won't need 
to be.)

> Normally devices have some sort of queue of pending operations.

That's certainly true of block devices, whose drivers use the block 
subsystem.  It's not true for lots of other devices, though.

>  So
> all that is required on suspend is to stop processing the queue and
> wait for any currently-underway operations to complete.  The blocking
> then happens naturally using the normal I/O wait mechanisms.

In my experience, most non-block drivers do not have any queue of 
pending I/O operations.  They simply carry out requests as they arrive.

Alan Stern

