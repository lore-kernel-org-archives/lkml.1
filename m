Return-Path: <linux-kernel-owner+w=401wt.eu-S1756513AbZGHTBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbZGHTBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 15:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbZGHTBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 15:01:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41919 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302AbZGHTBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 15:01:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [RFC][PATCH] PM: Introduce core framework for run-time PM of I/O devices (rev. 8)
Date: Wed, 8 Jul 2009 21:01:28 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc2-rjw; KDE/4.2.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
References: <200907060252.12755.rjw@sisk.pl> <200907080007.38595.rjw@sisk.pl> <aec7e5c30907072245i63b632f4r9a2b7ae0d819b446@mail.gmail.com>
In-Reply-To: <aec7e5c30907072245i63b632f4r9a2b7ae0d819b446@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907082101.29387.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 July 2009, Magnus Damm wrote:
> On Wed, Jul 8, 2009 at 7:07 AM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> > On Tuesday 07 July 2009, Magnus Damm wrote:
> >> On Mon, Jul 6, 2009 at 9:52 AM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> >> > Hi,
> >> >
> >> > There's a rev. 8 of the run-time PM framework patch.
> 
> >> All good with the code above, but there seem to be some issue with how
> >> usage_count is counted up and down and when runtime_disabled is set:
> >>
> >> 1. pm_runtime_init(): usage_count = 1, runtime_disabled = true
> >> 2. driver_probe_device(): pm_runtime_get_sync()
> >> 3. pm_runtime_get_sync(): usage_count = 2
> >> 4. device driver probe(): pm_runtime_enable()
> >> 5. pm_runtime_enable(): usage_count = 1
> >> 6. driver_probe_device(): pm_runtime_put()
> >> 7. pm_runtime_put(): usage_count = 0
> >>
> >> I expect runtime_disabled = false in 7. Modifying the get/put calls to
> >> do enable/disable may work around the issue, but that's probably not
> >> what you guys want.
> >
> > Sure, that's my mistake.  I should have used a separate counter for
> > disable/enable, but I thought usage_counter would be sufficient.  Will fix.
> 
> Thank you. No problem.
> 
> >> Issue 2:
> >> ------------
> >> I cannot get any bus ->runtime_resume() callbacks from probe(). This
> >> also seems related to usage_count and pm_runtime_get_sync() in
> >> driver_probe_device(). Basically, from probe(), calling
> >> pm_runtime_resume() after pm_runtime_set_suspended() results in error
> >> and not in a ->runtime_resume() callback. Some device drives access
> >> hardware in probe(), so the ->runtime_resume() callback is needed at
> >> that point to turn on clocks before the hardware can be accessed.
> >
> > I think the problem is that pm_runtime_get_sync() in driver_probe_device()
> > calls ->runtime_resume(), so the device is active from the core's point of
> > view when you call pm_runtime_resume() from probe().
> >
> > Hmm.  OK, perhaps we should just increment usage_count in
> > driver_device_probe() to prevent suspends from happening at that time, without
> > calling ->runtime_resume() so that the driver can do it by itself.  I'll do
> > that in the next version.
> 
> Sounds good.
> 
> >> Random thought:
> >> -------------------------
> >> The runtime_pm_get() and runtime_pm_put() look very nice. I assume
> >> that inteface is supposed to be used by bus code. I wonder if it would
> >> be cleaner to use a similar counter based interface from the driver
> >> instead of the pm_runtime_idle()/suspend()/resume()...
> >>
> >> Let me know what you think!
> >
> > In fact I thought drivers could also use pm_runtime_[get|put]() and the 'sync'
> > versions.  At least, I don't see why not at the moment (well, I'm a bit tired
> > right now ...).
> 
> I think that's a nicer interface, but I must figure out how to use
> ->runtime_idle before I can switch to that...
> 
> > However, I'm now thinking it should work like this:
> >
> > * pm_runtime_get() increments usage_count and if it was zero before the
> >  incrementation, it calls pm_request_resume() (pm_runtime_resume() is called
> >  by the 'sync' version).
> >
> > * pm_runtime_put() decrements usage_count and if it's zero after the
> >  decrementation, it calls pm_request_idle() (pm_runtime_idle() is called by
> >  the 'sync' version).
> >
> > * The 'suspend' callbacks won't succeed for usage_count > 0.
> >
> > This way we would avoid calling the 'suspend' and 'idle' functions each time
> > unnecessarily, but then usage_count would have to be modified under the
> > spinlock only.
> 
> If all usage_count users are moved under the spinlock then there would
> be no need for atomic operations, right?
> 
> This get()/put() interface is interesting.
> 
> So I'd like to tie in two levels of power management in our runtime PM
> implementation. The most simple level is clock stopping, and I can do
> that using the bus callbacks ->runtime_suspend() and
> ->runtime_resume() with v8. The driver runtime callbacks are never
> invoked for clock stopping.
> 
> On top of the clock stopping I'd like to turn off power to the domain.
> So if all clocks are stopped to the devices within a domain, then I'd
> like to call the per-device ->runtime_suspend() callbacks provided by
> the drivers.
>
> I wonder how to fit these two levels of power management into the
> runtime PM in a nice way. My first attempts simply made use of
> pm_runtime_resume() and pm_runtime_suspend(), but I'd like to move to
> get()/put() if possible. But for that to work I need to implement
> ->runtime_idle() in my bus code, and I wonder if the current runtime
> PM idle behaviour is a good fit.
> 
> Below is how I'd like to make use of the runtime PM code. I'm not sure
> if it's compatible with your view. =)
> 
> Drivers call pm_runtime_get_sync() and pm_runtime_put() before and
> after using the hardware. The runtime PM code invokes the bus
> ->runtime_idle() callback ASAP (of course depending on put() or
> put_sync(), but no timer). The bus->runtime_idle() callback stops the
> clock and decreases the power domain usage count. If the power domain
> is unused, then the pm_schedule_suspend() is called for each of the
> devices in the power domain. This in turn will invoke the
> ->runtime_suspend() callback which starts the clock, calls the driver
> ->runtime_suspend() and stops the clock again. When all devices are
> runtime suspended the power domain is turned off.
> 
> I can't get the above to work with v8 though. This is because after
> the clock is stopped with ->runtime_idle() the runtime_status of the
> device is still RPM_ACTIVE, so when pm_runtime_get_sync() gets called
> the ->runtime_resume() never gets invoked and the clock is never
> started...
> 
> So I don't know if you think the ->runtime_idle usage above is a good
> plan. I guess no, it's probably quite different from the USB case. I
> can of course always skip using ->runtime_idle() and just use
> suspend()/resume().
> 
> Any thoughts?

I think you'd need a separate bus type callback for that, call it
->runtime_deepen() for now, which could be executed for a _suspended_
(from the core's point of view) device and the role of which would be to put
the (already suspended) device into a deeper low power state.

Something like this might also be used for PCI and it's worth discussing IMO.

So, if we had such a callback, your scenario would be the following.

Drivers call pm_runtime_get_sync() and pm_runtime_put() before and
after using the hardware. The runtime PM code invokes the bus
->runtime_idle() callback that in turn calls pm_runtime_suspend() or
pm_schedule_suspend() and the ->runtime_suspend() executed as a result
stops the clock and decreases the power domain usage count.  If the
domain usage count happens to be zero, pm_runtime_deepen() or
pm_schedule_deepen() is called for each device in the power domain.
Consequently, the bus type's ->runtime_deepen() is invoked and that can
call the device's ->runtime_suspend(), for example.  If there's
pm_runtime_get_sync() any time when this is happening, it will cancel the
pending requests and run ->runtime_resume().

Does it make sense?

Rafael
