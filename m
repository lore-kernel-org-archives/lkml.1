Return-Path: <linux-kernel-owner+w=401wt.eu-S1760939AbYBYW0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760939AbYBYW0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760511AbYBYW0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:26:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60822 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760302AbYBYW0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:26:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Fundamental flaw in system suspend, exposed by freezer removal
Date: Mon, 25 Feb 2008 23:25:09 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0802251439030.5536-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802251439030.5536-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802252325.09439.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 25 of February 2008, Alan Stern wrote:
> On Mon, 25 Feb 2008, Alan Stern wrote:
> 
> > The only possible solution is to have the drivers themselves be
> > responsible for preventing calls to device_add() or device_register()  
> > during a system sleep.  (It's also necessary to prevent driver binding,
> > but this isn't a major issue.)  The most straightforward approach is to
> > add a new pair of driver methods: one to disable adding children and
> > one to re-enable it.  Of course this would represent a significant
> > addition to the Power Management driver interface.
> > 
> > (Note that the existing suspend and resume methods cannot be used for 
> > this purpose.  Drivers assume that when the suspend method is called, 
> > it has already been called for all the child devices.  This wouldn't be 
> > true if one of the purposes of the method was to prevent addition of 
> > new children.)
> 
> On further thought maybe the existing methods can be used, with care.  
> Drivers would have to assume the responsibility of synchronizing with
> their helper threads and stopping addition of new children (something
> they should already be doing), and they would also have to check that
> all the existing children are already suspended.  They should not make
> the assumption that the PM core has already suspended all the children.

IMO the device driver should assure that no new children will be registered
concurrently with the ->suspend() method (IOW, ->suspend() should wait for
all such registrations to complete and should prevent any new ones from
being started) and it should make it impossible to register any new children
after ->suspend() has run.  It's the driver's problem how to achieve that.

> The PM core could help detect errors here.  If it tries to suspend a 
> device and sees that the device's parent is already suspended, then the 
> parent's driver has a bug.

Yes, I think we ought to fail the suspend in such cases.  Still, that's not
sufficient to prevent a child from being registered after we've run
dpm_suspend().  For this reason, we could also leave dpm_suspend() with
dpm_list_mtx held and not release it until the next dpm_resume() is run.

That will potentially cause some trouble to CPU hotplug cotifiers, but we can
handle that, for example, by using the in_suspend_context() test.

Thanks,
Rafael
