Return-Path: <linux-kernel-owner+w=401wt.eu-S934364AbZHENYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934364AbZHENYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 09:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934355AbZHENYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 09:24:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52822 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934354AbZHENYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 09:24:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Resend][PATCH] PM: Introduce core framework for run-time PM of I/O devices (rev. 11)
Date: Wed, 5 Aug 2009 15:25:02 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc5-rjw; KDE/4.2.4; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Magnus Damm <magnus.damm@gmail.com>, Greg KH <gregkh@suse.de>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0908042208460.10693-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0908042208460.10693-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908051525.03666.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 August 2009, Alan Stern wrote:
> On Wed, 5 Aug 2009, Rafael J. Wysocki wrote:
> 
> > > > +	spin_unlock_irq(&dev->power.lock);
> > > > +
> > > > +	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_idle)
> > > > +		dev->bus->pm->runtime_idle(dev);
> > > > +
> > > > +	spin_lock_irq(&dev->power.lock);
> > > 
> > > Small optimization: Put the spin_{un}lock_irq stuff inside the "if"
> > > statement, so it doesn't happen if the test fails.
> > 
> > Well, I don't think so.  We need to take the lock here unconditionally,
> > because the caller is going to unlock it.
> 
> No, I meant do this:
> 
> 	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_idle) {
> 		spin_unlock_irq(&dev->power.lock);
> 		dev->bus->pm->runtime_idle(dev);
> 		spin_lock_irq(&dev->power.lock);
> 	}
 
Ah, OK.  That makes sense.

> By the way, I don't know if anyone still pays attention to sparse-type
> annotations.  If you do,

Well, I guess I should. :-)

> you should add "__releases(&dev->power.lock)"
> and "__acquires(&dev->power.lock)" annotations to functions like this,
> which release the lock without first acquiring it, and then acquire
> the lock without releasing before returning.
> 
> > > The same thing can be done in other places.
> > 
> > I'm not really sure it can.
> 
> The other places aren't quite the same as this.  I'll leave it to your
> discretion.  :-)
> 
> 
> > > > +int __pm_runtime_set_status(struct device *dev, unsigned int status)
> > > > +{
> > > > +	struct device *parent = dev->parent;
> > > > +	unsigned long flags;
> > > > +	int error = 0;
> > > > +
> > > > +	if (status != RPM_ACTIVE && status != RPM_SUSPENDED)
> > > > +		return -EINVAL;
> > > 
> > > This should go inside the spinlocked area.
> > 
> > Why?  'status' is a function argument, it doesn't need to be protected from
> > concurrent modification.
> 
> Oops, my mistake.  Never mind...
> 
> 
> > > > +int pm_runtime_disable(struct device *dev)
> > > > +{
> > > ...
> > > > +	if (dev->power.disable_depth++ > 0)
> > > > +		goto out;
> > > > +
> > > > +	if (dev->power.runtime_failure)
> > > > +		goto out;
> > > 
> > > I don't see why this is needed.
> > 
> > If dev->power.runtime_failure, there's no need to do anything more.
> 
> Don't you still want to deactivate the timer and kill any pending
> requests?  True, they won't be able to do anything until the failure 
> state is cleared, but even so...

OK, I'll drop that if ().

> > > > +void pm_runtime_remove(struct device *dev)
> > > > +{
> > > > +	pm_runtime_disable(dev);
> > > > +
> > > > +	if (dev->power.runtime_status == RPM_ACTIVE) {
> > > > +		struct device *parent = dev->parent;
> > > > +
> > > > +		/*
> > > > +		 * Change the status back to 'suspended' to match the initial
> > > > +		 * status.
> > > > +		 */
> > > > +		pm_runtime_set_suspended(dev);
> > > > +		if (parent && !parent->power.ignore_children)
> > > > +			pm_request_idle(parent);
> > > 
> > > Shouldn't these last two lines be part of __pm_runtime_set_status()?
> > 
> > No.  It is valid to call __pm_runtime_set_status() when runtime PM is disabled
> > for the device and I don't think we should kick the parent in such cases.
> 
> Ah, an interesting point.  Suppose the device is in RPM_ACTIVE, and
> then someone calls pm_runtime_disable followed by
> pm_runtime_set_suspended.  Then the device's status would change to
> RPM_SUSPENDED and the parent's count of active children would be
> decremented, perhaps to 0.  If the count does go to 0, why wouldn't you
> want to send out an idle notification for the parent?

OK, having reconsidered that, I think you're right, it should go into
__pm_runtime_set_status().

> > > > @@ -757,11 +771,15 @@ static int dpm_prepare(pm_message_t stat
> > > >  		dev->power.status = DPM_PREPARING;
> > > >  		mutex_unlock(&dpm_list_mtx);
> > > >  
> > > > -		error = device_prepare(dev, state);
> > > > +		if (pm_runtime_disable(dev) && device_may_wakeup(dev))
> > > > +			error = -EBUSY;
> > > 
> > > What's the reason for the -EBUSY error?
> > 
> > If this is a wake-up device and pm_runtime_disable(dev) returned 1 (it can only
> > return 1 or 0), which means there was a resume request pending for the device,
> > suspend fails with -EBUSY (wake-up event during suspend).
> 
> I see.  That's a little obscure; a comment would help.  Even something
> as simple as:
> 
> 			error = -EBUSY;		/* wake-up during suspend */

OK

> > > > @@ -202,7 +203,9 @@ int driver_probe_device(struct device_dr
> > > >  	pr_debug("bus: '%s': %s: matched device %s with driver %s\n",
> > > >  		 drv->bus->name, __func__, dev_name(dev), drv->name);
> > > >  
> > > > +	pm_runtime_get_noresume(dev);
> > > >  	ret = really_probe(dev, drv);
> > > > +	pm_runtime_put_noidle(dev);
> > > 
> > > This is bad because it won't wait if there's a runtime-PM call in
> > > progress.  Also, we shouldn't use put_noidle because it might subvert
> > > the driver's attempt to autosuspend.
> > 
> > I'm not sure how that's possible, but whatever.
> 
> Suppose the probe routine does:
> 
> 	pm_runtime_get_sync(dev);
> 	/* do some work */
> 	pm_runtime_put_sync(dev);
> 
> There is a clear expectation that an idle notification will eventually
> be sent.  But if the probe is surrounded by
> 
> 	pm_runtime_get_noresume(dev);
> 	... probe ...
> 	pm_runtime_put_noidle(dev);
> 
> then there won't be any idle notifications.

Ah, OK.  So the point is that we should always idle-notify after .probe(),
because that's what .probe() would most probably want to do.  I guess that
makes sense.

> > > > +2. Device Run-time PM Callbacks
> > > 
> > > > +In particular, it is recommended that ->runtime_suspend() return -EBUSY if
> > > > +device_may_wakeup() returns 'false' for the device.
> > > 
> > > What's the point of this?  I don't understand -- we don't want to
> > > discourage people from suspending devices with wakeup enabled.
> > 
> > device_may_wakeup(dev) == false means wake-up is disabled for dev, so
> > suspending it might not be a good idea.
> 
> Okay.  This needs to be rephrased.  For example,
> 
> 	In particular, if the driver requires remote wakeup capability
> 	for proper functioning and device_may_wakeup() returns 'false'
> 	for the device, then ->runtime_suspend() should return -EBUSY.
> 
> The point is that plenty of drivers can work perfectly well without
> remote wakeup, so they have no reason to check device_may_wakeup().

OK

Thanks a lot again, I'll do my best to address the comments in the next version
of the patch.

Best,
Rafael
