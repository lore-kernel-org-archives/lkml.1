Return-Path: <linux-kernel-owner+w=401wt.eu-S1757919AbYEPOVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919AbYEPOVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 10:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533AbYEPOVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:21:05 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1952 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757289AbYEPOVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:21:00 -0400
Date: Fri, 16 May 2008 10:20:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <nigel@nigel.suspend2.net>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-pm@lists.linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [linux-pm] [PATCH -mm] kexec jump -v9
In-Reply-To: <m163tfi5sq.fsf@frodo.ebiederm.org>
Message-ID: <Pine.LNX.4.44L0.0805160955320.25035-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008, Eric W. Biederman wrote:

> I just can't get past the fact in that the only reason hibernation can
> not use the widely implemented and tested probe/remove is because of
> filesystems on block devices, and that you are proposing to add 4
> methods for each and every driver to handle that case, when they
> don't need ANYTHING!

You are mixing together several distinct concepts: powering-down
devices, quiescing devices, blocking request queues, and so on.

> The more I look at this the more I get the impression that
> hibernation and suspend should be solved in separate patches.  I'm
> not at all convinced that is what is good for the goose is good for
> the gander for things like your prepare method.

Isn't that exactly what Rafael has been doing?  Why do you think the 
new PM framework has different methods for suspend and hibernate?

> Hibernation seems to be an extreme case of hotplug.

?  I don't follow this at all.

> Suspend seems to be just an extreme case of putting unused
> devices in low power state.

To a large extent that is true.  But there is more to it.

Normally, when a device is put in a low-power state while the system is 
running, it's expected that an I/O request will cause the device to 
return to full power.  But during suspend things don't work that way; 
instead I/O requests are supposed to be blocked and the device is 
supposed to remain at low power.

There are other requirements too.  While the system is running, more or
less arbitrary devices can go to low power at more or less arbitrary
times (as appropriate, of course).  But during suspend, the PM core has
to arrange that _all_ devices go to low power.  This means, among other
things, that drivers have to be prevented from registering new devices
while the transition is taking place.  (Not to mention the races 
involved in registering a new child device at the same time as its 
parent is being powered down.)

> + * @prepare: Prepare the device for the upcoming transition, but do NOT change
> + *	its hardware state.  Prevent new children of the device from being
> + *	registered after @prepare() returns (the driver's subsystem and
...
> + * @complete: Undo the changes made by @prepare().  This method is executed for
...

> The names above are terrible.  Perhaps: @pause/@unpause.

I think you have missed the point of these methods.  What they do is
unrelated to pausing or unpausing; their main purpose is to prevent and
to allow new children from being registered.

> @pause Stop all device driver user space facing activities, and prepare
>        for a possible power state transition.
> 
> Essentially these should be very much like bringing an ethernet
> interface down.  The device is still there but we can't do anything
> with it.  The only difference is that this may not be user visible.

Why do we need this?  Why can't user-space-facing activities be stopped 
when the power-level change occurs?

> + * @freeze: Hibernation-specific, executed before creating a hibernation image.
> + *	Quiesce operations so that a consistent image can be created, but do NOT
> + *	otherwise put the device into a low power device state and do NOT emit
> + *	system wakeup events.  Save in main memory the device settings to be
> + *	used by @restore() during the subsequent resume from hibernation or by
> + *	the subsequent @thaw(), if the creation of the image or the restoration
> + *	of main memory contents from it fails.
> + *
> + * @thaw: Hibernation-specific, executed after creating a hibernation image OR
> + *	if the creation of the image fails.  Also executed after a failing
> + *	attempt to restore the contents of main memory from such an image.
> + *	Undo the changes made by the preceding @freeze(), so the device can be
> + *	operated in the same way as immediately before the call to @freeze().
> 
> Just @detach/@reattach.
> 
> @detach Detach the driver from the hardware, while keeping the driver
>         instance for the hardware alive.

This isn't the same thing at all.  @freeze doesn't detach the driver 
from anything.  It merely tells the driver to quiesce the device.

> If we have events we care about we just need to do:
> reattach(); suspend();  It is all the same from the point of view of
> the device.  Not the system but the device.

?  Why are you worried about what the device sees?  The device can't 
even tell the difference between a detach and a period of time with no 
I/O.

Alan Stern

