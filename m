Return-Path: <linux-kernel-owner+w=401wt.eu-S1761694AbYBTXhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761694AbYBTXhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 18:37:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757707AbYBTXgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 18:36:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33055 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238AbYBTXgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 18:36:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Date: Thu, 21 Feb 2008 00:35:12 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jesse Barnes <jesse.barnes@intel.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>,
       linux-acpi@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Greg KH <gregkh@suse.de>, Alexey Starikovskiy <aystarik@gmail.com>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802202336.45492.rjw@sisk.pl> <alpine.LFD.1.00.0802201455430.7833@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802201455430.7833@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802210035.14058.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 21 of February 2008, Linus Torvalds wrote:
> 
> On Wed, 20 Feb 2008, Rafael J. Wysocki wrote:
> > > >
> > > > which may have four entry-points that can be illogically mapped to the
> > > > suspend/resume ones like we do now, but they really have nothing to do
> > > > with suspending/resuming.
> > 
> > Apart from putting devices into the right low power states, that is.
> 
> And by "right low power states" you mean "wrong low-power states", right?

No, I don't.

> The thing is, they really *are* the wrong states for 99% of all hardware.
> 
> If you really have a piece of hardware that you want to have the 
> "->poweroff()" thing do the same as "->suspend()", then hey, just use the 
> same function (or better yet, use two different functions with a call to a
> shared part).
> 
> Because IT IS NOT TRUE that ->suspend() puts the devices in the "right 
> power state". The power states are likely to be totally different for S3 
> and for poweroff, and they are going to differ in different ways depending 
> on the device type.

In fact we have acpi_pci_choose_state() that tells the driver which power
state to put the device into in ->suspend().  If that is used, the device ends
up in the state expected by to BIOS for S4.

> One example would be the one that started this version of the whole 
> discussion (shock horror! We're on subject!) ie when you do a system 
> shutdown, you generally do not even *want* to put individual devices into 
> low-power states at all, because the actual "power off the system" thing 
> will take care of it for you much better.

No.  Again, if there are devices that wake us up from S4, but not from S5,
they need to be handled differently in the *enter S4* case (hibernation) and
in the *enter S5* case (powering off the system).
 
> So to take just something as simple as VGA as an example: you really do 
> not want to suspend that device, because you want to see the poweroff 
> messages until the very end. 
> 
> So that final device ->poweroff function really has absolutely *nothing* 
> in common with the device ->suspend[_late] functions, simply because 
> almost any sane driver would decide to do different things.

Yes, it would.  Still, the common thing is, it (ie. ->poweroff) _may_ want to
put the device into a low power state different from D3.

> Of course, we can continue to do the insane thing and just continue to use 
> inappropriate and misleadign function callback names, and then encodign 
> what the *real* action should be in the argument and/or in magic 
> system-wide state parameters.

To clarify, I agree that we should use different callbacks for hibernation.
I'm only saying that _in_ _general_ we may need the ->poweroff callback.

> So in that sense, it's certainly totally the same thing whether we call it 
> ->shutdown or ->poweroff or ->eat_a_banana, since you could always just 
> look at the argument and other clues, and decide that *this* time, for 
> *this* kind of device, the "eat a banana" callback actually means that we 
> should power it off, but wouldn't it be a lot more logical to just make it 
> clear in the first place that they aren't called for the same reason at 
> all?
> 
> I'd claim that it's much easier for everybody (and _especially_ for device 
> driver writers) to have
> 
> 	static int my_shutdown(struct pci_device *dev, int state)
> 	{
> 		.. do something ..
> 	}
> 
> 	static int my_suspend(struct pci_device *dev, int state)
> 	{
> 		.. do something ..
> 	}
> 
> 	...
> 	.shutdown = my_shutdown,
> 	.suspend = my_suspend,
> 	...	
> 
> than to have
> 
> 	static int my_suspend(struct pci_device *dev, state)
> 	{
> 		.. common code ..
> 		if (state == XYZZY)
> 			..special code..
> 		else
> 			..other case code..
> 	}
> 
> 	...
> 	.suspend = my_suspend
> 	...
> 
> even if the latter might be fewer lines. It doesn't really matter if it's 
> fewer, does it, if the alternate version is more obvious about what it 
> does?
> 
> The other issue is that I've long wanted to make sure that when people fix 
> suspend-to-ram, they don't screw up suspend-to-disk by mistake and vice 
> versa. When a driver writer makes changes, he shouldn't have the kind of 
> illogical "oops, unintended consequences" issues in general. It should be 
> pretty damn obvious when he changes suspend code vs when he changes 
> snapshot/restore code.
> 
> We've somewhat untangled that on the "core kernel" layer, but we've left 
> the driver confusion alone.

Well, I agree with that.

As I said before, that's mainly because I've been busy with other stuff
recently.  Now, with the Alex's help, I'm hoping to take care of it soon.

Thanks,
Rafael
