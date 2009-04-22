Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbZDVPkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbZDVPkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 11:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbZDVPkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 11:40:12 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57035 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753015AbZDVPkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 11:40:10 -0400
Date: Wed, 22 Apr 2009 11:40:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David VomLehn <dvomlehn@cisco.com>
cc: Jamie Lokier <jamie@shareable.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
In-Reply-To: <20090421230849.GA29555@cuplxvomd02.corp.sa.net>
Message-ID: <Pine.LNX.4.44L0.0904221111320.3405-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Apr 2009, David VomLehn wrote:

> The current patch already uses a waitqueue and wakes up as soon as a console
> is registered, so that's the same. I agree that the other piece is determining
> when all USB devices at boot time have been probed. For this suggestion to
> work, two conditions must be met:
> 1.	The USB hub driver becoming idle must indicate that every device has
> 	been probed.

That's not exactly right.  When a new hub is registered, the hub driver 
doesn't become idle until after all the devices plugged into that hub 
have been initialized and probed.

So the hub driver becoming idle indicates that every device attached to
any registered USB host controller has been probed, but there may still
be some unregistered controllers.  This won't be an issue if you first
wait for all the new async probing stuff to end; by then all the PCI 
devices (including USB host controllers) should be registered.

> 2.	The USB driver must become idle after every USB device has been
> 	probed.

Under normal conditions it will.  There are some abnormal conditions
which cause the hub driver never to become idle, such as a faulty
device that continually connects and disconnects itself electrically
to/from the USB bus.  (Each connection event will create more work for
the hub driver.)  I have seen reports of this sort of thing.

I guess a better criterion would be for the hub driver to maintain a
count of registered but unscanned hubs.  That wouldn't be subject to
quite the same starvation issue.  Although there is another issue which
occasionally comes up with buggy devices: The hub driver's
device-initialization procedure has so many retries and timeouts that
it can take several minutes before the driver gives up on a bad device.

> If both conditions are met, this is a superior to a timeout for determining
> that the console will not show up. It would surprise me a bit if the first
> condition was true.

Why?  Doesn't it make sense that the hub driver would remain running as 
long as there was still work for it do to?

>  Still, if it is true that the USB hub driver will be
> idle for some interval I, where I is greater than the timeout we would
> otherwise use, it is still a better approach.
> 
> There is one other possible gotcha to this approach. The code as I wrote it is
> bus-agnostic, i.e. it has no idea where the console is located. As far as
> I know, the long time to probe possible console devices only arises with
> USB. If this is not tree, we need to handle any other cases that can arise.

That is a very good objection.  For this sort of approach to work,
ultimately it would have to be implemented for every hotpluggable bus
of interest.

> > >  But a bigger
> > > drawback is that you lose the ability to chose appropriate intervals for
> > > different classes of devices.
> > 
> > Why do you need to choose any intervals at all?  Just keep waiting
> > until you know there's no point waiting any longer.  If you stop 
> > waiting before then, you run the risk of missing a device that could 
> > have worked.
> 
> The question about appropriate intervals is that I need to wait for some
> devices, like consoles and network devices, but not all devices, like printers
> and cameras. There is no telling whether any two devices require the same
> interval when I am tuning it for my particular system. And if I have a USB
> console and no USB Ethernet device, I only want to wait for the console
> probe interval.

I still don't understand.  Let's say you want the console init code to
wait for the preferred console device to be registered, and that device
could potentially be either a USB serial or a USB network device.  And
let's say that your system has a USB serial device but no USB network
devices.

The console delay routine will then wait until the USB serial device is
discovered and registered, at which point its job is done.  It won't
continue to wait until all the USB devices present at boot time have
been probed, since there's no reason to wait after the first console
device is discovered.

So not only would you not need to tune two different delay times, you 
wouldn't even need to tune one!  You wouldn't need to specify any delay 
times at all.

> I'm kinda flexible about whether all possible consoles show up; the patch
> presently only waits for a console to be identified as the "preferred" console.
> This gets the system going as soon as you have some place to write output,
> but I won't argue with anyone who says we need to wait for all possible
> consoles.

Which essentially means waiting until _all_ the devices present at boot 
time (both USB and non-USB) have been probed.  Right?  And it 
explicitly means ruling out waiting for new devices which the user 
might plug in after the system has booted, since a new console device 
could be plugged in at any time.

> > Now the only drawback I can see would crop up if some device takes a
> > very long time to probe (perhaps because of errors and retries).  If
> > there's no other console device, it could slow down the boot procedure
> > quite a lot.  But there doesn't appear to be any logical alternative,
> > given your goals as stated above.
> 
> If there is a way to guarantee that we are done with the probing, I'm
> all for using that. Will waiting for the USB hub driver to be idle do this?

I'm pretty sure something like it can be made to work, subject to the 
delays caused by bad devices.

Alan Stern

