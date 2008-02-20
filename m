Return-Path: <linux-kernel-owner+w=401wt.eu-S1754280AbYBTXNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbYBTXNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 18:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759790AbYBTXN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 18:13:29 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43983 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756416AbYBTXN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 18:13:27 -0500
Date: Wed, 20 Feb 2008 15:13:07 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Jesse Barnes <jesse.barnes@intel.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>,
       linux-acpi@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Greg KH <gregkh@suse.de>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk.
 Screen becomes green.
In-Reply-To: <200802202336.45492.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.00.0802201455430.7833@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <alpine.LFD.1.00.0802201256040.7833@woody.linux-foundation.org> <200802201344.11643.jesse.barnes@intel.com> <200802202336.45492.rjw@sisk.pl>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 20 Feb 2008, Rafael J. Wysocki wrote:
> > >
> > > which may have four entry-points that can be illogically mapped to the
> > > suspend/resume ones like we do now, but they really have nothing to do
> > > with suspending/resuming.
> 
> Apart from putting devices into the right low power states, that is.

And by "right low power states" you mean "wrong low-power states", right?

The thing is, they really *are* the wrong states for 99% of all hardware.

If you really have a piece of hardware that you want to have the 
"->poweroff()" thing do the same as "->suspend()", then hey, just use the 
same function (or better yet, use two different functions with a call to a
shared part).

Because IT IS NOT TRUE that ->suspend() puts the devices in the "right 
power state". The power states are likely to be totally different for S3 
and for poweroff, and they are going to differ in different ways depending 
on the device type.

One example would be the one that started this version of the whole 
discussion (shock horror! We're on subject!) ie when you do a system 
shutdown, you generally do not even *want* to put individual devices into 
low-power states at all, because the actual "power off the system" thing 
will take care of it for you much better.

So to take just something as simple as VGA as an example: you really do 
not want to suspend that device, because you want to see the poweroff 
messages until the very end. 

So that final device ->poweroff function really has absolutely *nothing* 
in common with the device ->suspend[_late] functions, simply because 
almost any sane driver would decide to do different things.

Of course, we can continue to do the insane thing and just continue to use 
inappropriate and misleadign function callback names, and then encodign 
what the *real* action should be in the argument and/or in magic 
system-wide state parameters.

So in that sense, it's certainly totally the same thing whether we call it 
->shutdown or ->poweroff or ->eat_a_banana, since you could always just 
look at the argument and other clues, and decide that *this* time, for 
*this* kind of device, the "eat a banana" callback actually means that we 
should power it off, but wouldn't it be a lot more logical to just make it 
clear in the first place that they aren't called for the same reason at 
all?

I'd claim that it's much easier for everybody (and _especially_ for device 
driver writers) to have

	static int my_shutdown(struct pci_device *dev, int state)
	{
		.. do something ..
	}

	static int my_suspend(struct pci_device *dev, int state)
	{
		.. do something ..
	}

	...
	.shutdown = my_shutdown,
	.suspend = my_suspend,
	...	

than to have

	static int my_suspend(struct pci_device *dev, state)
	{
		.. common code ..
		if (state == XYZZY)
			..special code..
		else
			..other case code..
	}

	...
	.suspend = my_suspend
	...

even if the latter might be fewer lines. It doesn't really matter if it's 
fewer, does it, if the alternate version is more obvious about what it 
does?

The other issue is that I've long wanted to make sure that when people fix 
suspend-to-ram, they don't screw up suspend-to-disk by mistake and vice 
versa. When a driver writer makes changes, he shouldn't have the kind of 
illogical "oops, unintended consequences" issues in general. It should be 
pretty damn obvious when he changes suspend code vs when he changes 
snapshot/restore code.

We've somewhat untangled that on the "core kernel" layer, but we've left 
the driver confusion alone.

		Linus
