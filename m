Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbZFKORk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbZFKORk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 10:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbZFKOR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 10:17:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52925 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbZFKOR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 10:17:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Thu, 11 Jun 2009 16:17:34 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0906101933220.29717-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906101933220.29717-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906111617.34635.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 June 2009, Alan Stern wrote:
> On Wed, 10 Jun 2009, Rafael J. Wysocki wrote:
> 
> > > You know, it doesn't make any sense to have a suspend and a resume 
> > > both pending at the same time.
> > >
> > > So you could add only a delayed_work structure and use its embedded
> > > work_struct for resume requests.
> > 
> > I thought so too, but I was wrong. ;-)
> > 
> > If resume is requested while the suspend hasn't completed yet, we should
> > queue it (it's totally valid to request a suspending device to resume IMO), but
> > the delayed work is still being used by the workqueue code, so we can't modify
> > it.
> 
> Where is the delayed work still being used?  There's even a comment in 
> run_workqueue() that says a work_struct can be freed by the function it 
> calls.

You are right, I overlooked the comment and it wasn't clear to me from looking
at the code.

> > > We might want to do a runtime suspend even if the device's children
> > > aren't already suspended.  For example, you could suspend a link while
> > > leaving the device on the other end of the link at full power --
> > > especially if powering down the device is slow but changing the link's
> > > power level is fast.
> > 
> > Well, this means that the dependencies between devices in the device tree are
> > pretty much useless for the run-time PM as far as the core is concerned.  In
> > which case, why did you mention them at all?
> 
> The dependencies aren't totally useless.  It's still true that before
> you resume a device, you have to autoresume its parent.

Well, in fact if we don't have the requirement that the children of a device
have to be suspended for it to be able to suspend too, we have to check
all parents up the device tree up to the one that doesn't have a parent
and autoresume the ones that aren't active.

> And it's still true that when you suspend a device, the parent should be
> given a chance to autosuspend.
> 
> I guess the real point is that the decision about whether all children
> must be suspended should be made by the driver, not the PM core.

The point here is what the core is supposed to do.  Does it need to handle
this at all or leave it to the bus type and driver?

After reconsidering it for a while I think that we should define what
"suspended" is supposed to mean from the core point of view.  And my opinion
is that it should mean "device doesn't communicate with the CPUs and RAM due
to power management".  That need not be power management of the device itself,
but such that leads to the device not doing I/O.

Under this definition all devices behind an inactive link are suspended,
because they can't do any I/O.  Which appears to makes sense, because their
drivers have to be notified before the link is suspended and the link has to be
turned on for the devices to be able to communicate with the CPU and RAM.

If this definition is adopted, then it's quite clear that the device can only
be suspended if all of its children are suspended and it's always necessary
to resume the parent of a device in order to resume the device itself.

> > > I haven't checked the details of the code yet.  More later...
> 
> One more thought...  The autosuspend and autoresume callbacks need to 
> be mutually exclusive with probe and remove.  So somehow the driver 
> core will need to block runtime PM calls.

That's correct and I'm going to take care of this.

> It might also be nice to make sure that the driver core autoresumes a 
> device before probing it and autosuspends a device (after some 
> reasonable delay) after unbinding its driver.

Agreed.

Best,
Rafael
