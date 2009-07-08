Return-Path: <linux-kernel-owner+w=401wt.eu-S1758381AbZGHCyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381AbZGHCyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 22:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756942AbZGHCyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 22:54:43 -0400
Received: from netrider.rowland.org ([192.131.102.5]:44049 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756449AbZGHCym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 22:54:42 -0400
Date: Tue, 7 Jul 2009 22:54:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Magnus Damm <magnus.damm@gmail.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC][PATCH] PM: Introduce core framework for run-time PM of
 I/O devices (rev. 8)
In-Reply-To: <200907080007.38595.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0907072222210.13052-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jul 2009, Rafael J. Wysocki wrote:

> > I've now jumped from v5 to v8 and I feel that the code is getting
> > cleaner and cleaner. Very nice.
> 
> That's mostly thanks to Alan.

I haven't had time yet to look through the new code.  Things have been 
very busy.

> > Issue 1:
> > ------------
> > Device drivers which do not perform any hardware access in probe()
> > work fine. During software setup in probe() the runtime pm code is
> > initialized with the following:
> > 
> > +	pm_suspend_ignore_children(&dev->dev, true);
> > +	pm_runtime_set_suspended(&dev->dev);
> > +	pm_runtime_enable(&dev->dev);
> > 
> > Before accessing hardware I perform:
> > +	pm_runtime_resume(pd->dev);
> > 
> > When done with the hardware I do:
> > +	pm_runtime_suspend(pd->dev);
> > 
> > Not so complicated. Am I supposed to initialize something else as well?

No, that's all you need.

> > All good with the code above, but there seem to be some issue with how
> > usage_count is counted up and down and when runtime_disabled is set:
> > 
> > 1. pm_runtime_init(): usage_count = 1, runtime_disabled = true
> > 2. driver_probe_device(): pm_runtime_get_sync()
> > 3. pm_runtime_get_sync(): usage_count = 2
> > 4. device driver probe(): pm_runtime_enable()
> > 5. pm_runtime_enable(): usage_count = 1
> > 6. driver_probe_device(): pm_runtime_put()
> > 7. pm_runtime_put(): usage_count = 0
> > 
> > I expect runtime_disabled = false in 7.

Wasn't it?  It should have been set to false in step 4 and remained 
that way.

> >  Modifying the get/put calls to
> > do enable/disable may work around the issue, but that's probably not
> > what you guys want.
> 
> Sure, that's my mistake.  I should have used a separate counter for
> disable/enable, but I thought usage_counter would be sufficient.  Will fix.

Presumably there won't be much nesting of disable/enable.  The counter 
will need only a few bits.

> > Issue 2:
> > ------------
> > I cannot get any bus ->runtime_resume() callbacks from probe(). This
> > also seems related to usage_count and pm_runtime_get_sync() in
> > driver_probe_device(). Basically, from probe(), calling
> > pm_runtime_resume() after pm_runtime_set_suspended() results in error
> > and not in a ->runtime_resume() callback. Some device drives access
> > hardware in probe(), so the ->runtime_resume() callback is needed at
> > that point to turn on clocks before the hardware can be accessed.
> 
> I think the problem is that pm_runtime_get_sync() in driver_probe_device()
> calls ->runtime_resume(), so the device is active from the core's point of
> view when you call pm_runtime_resume() from probe().

Yes.  Maybe devices should be initialized with runtime PM enabled.  Or 
perhaps it should be enabled when device_add runs (before the probe).

> Hmm.  OK, perhaps we should just increment usage_count in
> driver_device_probe() to prevent suspends from happening at that time, without
> calling ->runtime_resume() so that the driver can do it by itself.  I'll do
> that in the next version.

Not necessary if you enable runtime PM first.  Or maybe 
pm_runtime_enable should compare the state and the counters, calling 
pm_runtime_resume or pm_runtime_idle as needed.

> > Random thought:
> > -------------------------
> > The runtime_pm_get() and runtime_pm_put() look very nice. I assume
> > that inteface is supposed to be used by bus code. I wonder if it would
> > be cleaner to use a similar counter based interface from the driver
> > instead of the pm_runtime_idle()/suspend()/resume()...
> > 
> > Let me know what you think!
> 
> In fact I thought drivers could also use pm_runtime_[get|put]() and the 'sync'
> versions.  At least, I don't see why not at the moment (well, I'm a bit tired
> right now ...).
> 
> However, I'm now thinking it should work like this:
> 
> * pm_runtime_get() increments usage_count and if it was zero before the
>   incrementation, it calls pm_request_resume() (pm_runtime_resume() is called
>   by the 'sync' version).
> 
> * pm_runtime_put() decrements usage_count and if it's zero after the
>   decrementation, it calls pm_request_idle() (pm_runtime_idle() is called by
>   the 'sync' version).
> 
> * The 'suspend' callbacks won't succeed for usage_count > 0.

I agree.

I wonder if there should be a way for drivers to increment usage_count
without forcing a resume.  For example, if a driver stores up pending
I/O for its own work routine to handle then it would want to prevent
suspends before the work routine runs, but it would also want the work
routine to call pm_runtime_resume directly.  Hence it would be
pointless to have _get queue an extra resume request.

> This way we would avoid calling the 'suspend' and 'idle' functions each time
> unnecessarily, but then usage_count would have to be modified under the
> spinlock only.

Why?  That is, why would it have to be any different from the way it is 
now?  All you really need is that the test for zero should be part of 
the atomic operation.

Alan Stern

