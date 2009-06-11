Return-Path: <linux-kernel-owner+w=401wt.eu-S1759937AbZFKTna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937AbZFKTna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 15:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756798AbZFKTnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 15:43:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53802 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305AbZFKTnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 15:43:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Thu, 11 Jun 2009 21:43:56 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0906111041020.3040-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906111041020.3040-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906112143.57361.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 June 2009, Alan Stern wrote:
> On Thu, 11 Jun 2009, Rafael J. Wysocki wrote:
> 
> > The point here is what the core is supposed to do.  Does it need to handle
> > this at all or leave it to the bus type and driver?
> > 
> > After reconsidering it for a while I think that we should define what
> > "suspended" is supposed to mean from the core point of view.  And my opinion
> > is that it should mean "device doesn't communicate with the CPUs and RAM due
> > to power management".  That need not be power management of the device itself,
> > but such that leads to the device not doing I/O.
> > 
> > Under this definition all devices behind an inactive link are suspended,
> > because they can't do any I/O.  Which appears to makes sense, because their
> > drivers have to be notified before the link is suspended and the link has to be
> > turned on for the devices to be able to communicate with the CPU and RAM.
> > 
> > If this definition is adopted, then it's quite clear that the device can only
> > be suspended if all of its children are suspended and it's always necessary
> > to resume the parent of a device in order to resume the device itself.
> 
> Okay, I'll agree to that.  It should be made clear that a device which 
> is "suspended" according to this definition is not necessarily in a 
> low-power state.  For example, before powering down the link to a disk 
> drive you might want the drive's suspend method to flush the drive's 
> cache, but it wouldn't have to spin the drive down.

Exactly.

> (But this example leaves open the question of how we would go about
> spinning down the disk.  Submitting a 15-minute (or whatever) delayed
> autosuspend request wouldn't work; the request wouldn't be accepted
> because the disk is already suspended as far as the PM core is
> concerned.  The disk's driver would have to implement its own 
> spin-down delayed_work.)

Yes, it would.

> > > > > I haven't checked the details of the code yet.  More later...
> > > 
> > > One more thought...  The autosuspend and autoresume callbacks need to 
> > > be mutually exclusive with probe and remove.  So somehow the driver 
> > > core will need to block runtime PM calls.
> > 
> > That's correct and I'm going to take care of this.
> > 
> > > It might also be nice to make sure that the driver core autoresumes a 
> > > device before probing it and autosuspends a device (after some 
> > > reasonable delay) after unbinding its driver.
> > 
> > Agreed.
> 
> This is another case where a usage counter comes in handy.  The driver
> core resumes the device and increments the counter -- thus preventing
> any unwanted autosuspends -- before making the probe and remove calls.

I like this idea.

BTW, where exactly the counter should be increased in that case?

I thought of driver_probe_device(), but is it sufficient?  Or is there a better
place?

Best,
Rafael
