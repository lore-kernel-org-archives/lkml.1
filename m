Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbZH3Q1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbZH3Q1b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 12:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbZH3Q1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 12:27:30 -0400
Received: from netrider.rowland.org ([192.131.102.5]:36420 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753662AbZH3Q1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 12:27:30 -0400
Date: Sun, 30 Aug 2009 12:27:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Linus Walleij <linus.ml.walleij@gmail.com>, <linux-kernel@vger.kernel.org>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Russell King <linux@arm.linux.org.uk>,
       <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH] AB3100 regulator support v1
In-Reply-To: <20090830103448.GD4334@sirena.org.uk>
Message-ID: <Pine.LNX.4.44L0.0908301217410.10608-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Aug 2009, Mark Brown wrote:

> On Sun, Aug 30, 2009 at 01:03:38AM +0200, Linus Walleij wrote:
> 
> [While setting up a child platform device from a platform driver
> probe...]
> 
> > >> +     /* This would seem logical but makes everything break... */
> > >> +     /* pdev->dev.parent = parent; */
> 
> > > Err...  it does?  In what way?
> 
> > The sub-platform devices are added, but when I add a platform driver for
> > them, the probing does not commence, because they hang in
> > driver base/dd.c: __driver_attach() trying to take the parent semaphore,
> > i.e. this line:
> 
> > 	if (dev->parent)	/* Needed for USB */
> > 		down(&dev->parent->sem);
> 
> > In this case the parent is ab3100-regulators, the platform device for
> > the set of regulators.
> 
> On the face of it (and without having actually looked at a running
> system or anything yet) I'm rather surprised that platform based MFD
> drivers aren't running into this issue more often.  CCing in Alan who
> made the change.

I'm not at all familiar with the detailed issues involved here.  
Perhaps because of this, I don't see why there's any reason for
deadlocking.  __driver_attach() is invoked when a new driver is
registered; to avoid problems all you have to do is make sure you
aren't holding any device locks when you register a driver.

In general, drivers are registered as part of a module initialization
routine, which is quite separate from device probing.  Hence the code
doing the registration doesn't hold any locks.

Is the problem that the probe routine for a platform device is 
registering some child devices and then registering a driver for them?  
If that's the case, the problem can be solved by doing thing in the 
opposite order: Register the driver _before_ registering the devices it 
is supposed to manage.  Then __driver_attach() won't run -- 
device_attach() will instead -- so the problem won't arise.

Alan Stern

