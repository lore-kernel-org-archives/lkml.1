Return-Path: <linux-kernel-owner+w=401wt.eu-S1758592AbZGHTzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592AbZGHTzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 15:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756455AbZGHTzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 15:55:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42217 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755910AbZGHTzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 15:55:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM: Introduce core framework for run-time PM of I/O devices (rev. 8)
Date: Wed, 8 Jul 2009 21:55:39 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc2-rjw; KDE/4.2.4; x86_64; ; )
Cc: Magnus Damm <magnus.damm@gmail.com>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
References: <Pine.LNX.4.44L0.0907081530120.22105-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0907081530120.22105-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907082155.40903.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 July 2009, Alan Stern wrote:
> On Wed, 8 Jul 2009, Rafael J. Wysocki wrote:
> 
> > > So I'd like to tie in two levels of power management in our runtime PM
> > > implementation. The most simple level is clock stopping, and I can do
> > > that using the bus callbacks ->runtime_suspend() and
> > > ->runtime_resume() with v8. The driver runtime callbacks are never
> > > invoked for clock stopping.
> > > 
> > > On top of the clock stopping I'd like to turn off power to the domain.
> 
> I take it the devices in a single power domain don't all share a common 
> parent.
> 
> > > So if all clocks are stopped to the devices within a domain, then I'd
> > > like to call the per-device ->runtime_suspend() callbacks provided by
> > > the drivers.
> 
> Why?  That is, why not tell the driver as soon as the device's own 
> clock is stopped?  What point is there in waiting for all the other 
> clocks to be stopped as well?
> 
> > > I wonder how to fit these two levels of power management into the
> > > runtime PM in a nice way. My first attempts simply made use of
> > > pm_runtime_resume() and pm_runtime_suspend(), but I'd like to move to
> > > get()/put() if possible. But for that to work I need to implement
> > > ->runtime_idle() in my bus code, and I wonder if the current runtime
> > > PM idle behaviour is a good fit.
> > > 
> > > Below is how I'd like to make use of the runtime PM code. I'm not sure
> > > if it's compatible with your view. =)
> > > 
> > > Drivers call pm_runtime_get_sync() and pm_runtime_put() before and
> > > after using the hardware. The runtime PM code invokes the bus
> > > ->runtime_idle() callback ASAP (of course depending on put() or
> > > put_sync(), but no timer). The bus->runtime_idle() callback stops the
> > > clock and decreases the power domain usage count. If the power domain
> > > is unused, then the pm_schedule_suspend() is called for each of the
> > > devices in the power domain. This in turn will invoke the
> > > ->runtime_suspend() callback which starts the clock, calls the driver
> > > ->runtime_suspend() and stops the clock again. When all devices are
> > > runtime suspended the power domain is turned off.
> 
> Instead, you should call pm_runtime_suspend from within the
> runtime_idle method.  When the runtime_suspend method runs, have it
> decrement the power domain's usage count.  Is the power domain
> represented by a single struct device?  If it is then that device's
> power.usage_count field would naturally be the thing to use; otherwise
> you'd have to set up your own counter.
> 
> Then depending on how things are organized, when the power-domain
> device's usage_count goes to 0 you'll get a runtime_idle callback.  
> Call pm_runtime_resume for the power-domain device, and have that
> routine shut off the power.  Or if you set up your own private counter
> for the power domain, shut off the power when the counter goes to 0.

Yes, I think the approach with a private counter should work in the Magnus'
case.

> > I think you'd need a separate bus type callback for that, call it
> > ->runtime_deepen() for now, which could be executed for a _suspended_
> > (from the core's point of view) device and the role of which would be to put
> > the (already suspended) device into a deeper low power state.
> > 
> > Something like this might also be used for PCI and it's worth discussing IMO.
> 
> I thought you wanted to avoid this sort of complication.

I did, but there might be some benefits.  For example, the timer and the work
structure provided by dev.power can be used for scheduling such operations
if they are defined at the core level.

Suppose your device has 3 low power states D1 - D3 (like PCI) and you want it
to go into D1 first, then, after a delay, to D2 and finally, again after a
delay, to D3.  Of course, if there's a resume in the meantime, it should cancel
whichever transition is in progress.

pm_runtime_suspend() can be used for the first transition, but the bus type or
driver will have to provide its own mechanics for going down to D2 and D3,
which must be synchronized with its ->runtime_resume().  That might be tricky
and the core already has what's necessary (well, almost).

Best,
Rafael
