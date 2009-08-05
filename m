Return-Path: <linux-kernel-owner+w=401wt.eu-S933839AbZHEAT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933839AbZHEAT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 20:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933338AbZHEATY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 20:19:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49662 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932641AbZHEATX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 20:19:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Resend][PATCH] PM: Introduce core framework for run-time PM of I/O devices (rev. 11)
Date: Wed, 5 Aug 2009 02:19:18 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc5-rjw; KDE/4.2.4; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Magnus Damm <magnus.damm@gmail.com>, Greg KH <gregkh@suse.de>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0908041500420.3102-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0908041500420.3102-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908050219.19066.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 August 2009, Alan Stern wrote:
> On Mon, 3 Aug 2009, Rafael J. Wysocki wrote:
> 
> > Hi,
> > 
> > OK, if this is to go into 2.6.32, the last moment for putting it into
> > linux-next is now.  If you have any objections, remarks, etc. please let me
> > know or I'm going to put this one into the linux-next branch of the suspend-2.6
> > tree in the next couple of days.
> 
> I'm sorry I haven't been keeping on top of all your work on this.
> Lots of other stuff has been going on in the meantime...

No problem.

> One the whole this all looks very good.  It's basically ready to be
> merged.  There are a couple of minor issues remaining plus a bunch of
> unimportant implementation details.
> 
> pm_runtime_disable() gets used for several different purposes.  For
> the usage in pm_runtime_remove(), it's silly to carry out a pending
> resume request.  Should we add an argument saying whether or not to do
> so?

Yes, we can do that.

> In the documentation, it would be nice to have a section listing the
> default runtime PM settings and explaining what a driver should do to
> activate runtime PM on a newly-registered device.

OK, I'll try to put something like this in there.

> > +static void pm_runtime_cancel_pending(struct device *dev)
> > +{
> > +	pm_runtime_deactivate_timer(dev);
> > +	/*
> > +	 * If there's a request pending, make sure its work function will return
> > +	 * without doing anything.
> > +	 */
> > +	if (dev->power.request_pending)
> > +		dev->power.request = RPM_REQ_NONE;
> 
> No need for the "if"; you can always do the assignment.

OK

> > +static int __pm_runtime_idle(struct device *dev)
> > +{
> > +	int retval = 0;
> > +
> > +	if (dev->power.runtime_failure)
> > +		retval = -EINVAL;
> 
> Instead of assigning to retval, you could simply return these values.

I could, but I chose not to.

> > +	else if (dev->power.idle_notification)
> > +		retval = -EINPROGRESS;
> > +	else if (atomic_read(&dev->power.usage_count) > 0
> > +	    || dev->power.disable_depth > 0
> > +	    || dev->power.timer_expires > 0
> > +	    || dev->power.runtime_status == RPM_SUSPENDED
> > +	    || dev->power.runtime_status == RPM_SUSPENDING)
> > +		retval = -EAGAIN;
> 
> Do we also want to rule out RPM_RESUMING?  That is,
> 
> 	    || dev->power.runtime_status != RPM_ACTIVE

Yes, we do, thanks.

> > +	spin_unlock_irq(&dev->power.lock);
> > +
> > +	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_idle)
> > +		dev->bus->pm->runtime_idle(dev);
> > +
> > +	spin_lock_irq(&dev->power.lock);
> 
> Small optimization: Put the spin_{un}lock_irq stuff inside the "if"
> statement, so it doesn't happen if the test fails.

Well, I don't think so.  We need to take the lock here unconditionally,
because the caller is going to unlock it.

> The same thing can be done in other places.

I'm not really sure it can.

> > + * __pm_runtime_suspend - Carry out run-time suspend of given device.
> > + * @dev: Device to suspend.
> > + * @from_wq: If set, the funtion has been called via pm_wq.
> 
> Fix spelling of "function".  Likewise in __pm_runtime_resume.

Will do, thanks.
 
> > +int __pm_runtime_suspend(struct device *dev, bool from_wq)
> > +{
> ...
> > +	spin_unlock_irq(&dev->power.lock);
> > +
> > +	if (parent && !parent->power.ignore_children)
> > +		pm_request_idle(parent);
> > +
> > +	if (notify)
> > +		pm_runtime_idle(dev);
> 
> Move this up before the spin_unlock_irq and call __pm_runtime_idle instead.
> The same sort of thing can be done in __pm_runtime_resume.

OK

> > +static int __pm_request_suspend(struct device *dev)
> > +{
> > +	int retval = 0;
> > +
> > +	if (dev->power.runtime_failure)
> > +		return -EINVAL;
> > +
> > +	if (dev->power.runtime_status == RPM_SUSPENDED)
> > +		retval = 1;
> > +	else if (atomic_read(&dev->power.usage_count) > 0
> > +	    || dev->power.disable_depth > 0)
> > +		retval = -EAGAIN;
> > +	else if (dev->power.runtime_status == RPM_SUSPENDING)
> > +		retval = -EINPROGRESS;
> > +	else if (!pm_children_suspended(dev))
> > +		retval = -EBUSY;
> 
> Insert:
> 	if (retval)
> 		return retval;
> 
> Or else change the assignments to "return" statements.  Yes, we agreed
> that a suspend request should override an existing idle-notify
> request.  But if the new request fails then it shouldn't override
> anything.  (Of course, if it fails for any of the reasons here then
> there can't be a pending idle-notify request anyway.)

However, if it's going to return 1, it should override existing idle-notify
and suspend requests.  I'll add

 	if (retval < 0)
 		return retval;

> > +	pm_runtime_deactivate_timer(dev);
> > +
> > +	if (dev->power.request_pending) {
> > +		/*
> > +		 * Pending resume requests take precedence over us, but we can
> > +		 * overtake any other pending request.
> > +		 */
> > +		if (dev->power.request == RPM_REQ_RESUME)
> > +			retval = -EAGAIN;
> > +		else if (dev->power.request != RPM_REQ_SUSPEND)
> > +			dev->power.request = retval ?
> > +						RPM_REQ_NONE : RPM_REQ_SUSPEND;
> 
> Now there's no need to check retval.

It is.  If retval is 1, we cancel pending idle-notify and suspend requests.

> > +
> > +		if (dev->power.request == RPM_REQ_SUSPEND)
> > +			return 0;
> 
> Just simply:
> 		return retval;

OK, I'll change that.

> Some of these cases can't happen.  For instance, if we reach here then
> the status can't be SUSPENDED or SUSPENDING, so there can't be a
> pending resume request.
> 
> > +	}
> > +
> > +	if (retval)
> > +		return retval;
> 
> Now this isn't needed.  Similar code rearrangements can be made in
> __pm_request_resume.

OK

> > +int __pm_request_resume(struct device *dev)
> 
> Should be static.

OK

> > +int __pm_runtime_set_status(struct device *dev, unsigned int status)
> > +{
> > +	struct device *parent = dev->parent;
> > +	unsigned long flags;
> > +	int error = 0;
> > +
> > +	if (status != RPM_ACTIVE && status != RPM_SUSPENDED)
> > +		return -EINVAL;
> 
> This should go inside the spinlocked area.

Why?  'status' is a function argument, it doesn't need to be protected from
concurrent modification.

> > +	spin_lock_irqsave(&dev->power.lock, flags);
> > +
> > +	if (!dev->power.runtime_failure && !dev->power.disable_depth)
> > +		goto out;
> > +
> > +	if (dev->power.runtime_status == status)
> > +		goto out_clear;
> > +
> > +	if (status == RPM_SUSPENDED) {
> > +		/* It always is possible to set the status to 'suspended'. */
> > +		if (parent)
> > +			atomic_add_unless(&parent->power.child_count, -1, 0);
> > +		dev->power.runtime_status = status;
> > +		goto out_clear;
> > +	}
> > +
> > +	if (parent) {
> > +		spin_lock_irq(&parent->power.lock);
> > +
> > +		/*
> > +		 * It is invalid to put an active child under a parent that is
> > +		 * not active, has run-time PM enabled and the
> > +		 * 'power.ignore_children' flag unset.
> > +		 */
> > +		if (!parent->power.disable_depth
> > +		    && !parent->power.ignore_children
> > +		    && parent->power.runtime_status != RPM_ACTIVE) {
> > +			error = -EBUSY;
> > +		} else {
> > +			if (dev->power.runtime_status == RPM_SUSPENDED)
> > +				atomic_inc(&parent->power.child_count);
> > +			dev->power.runtime_status = status;
> > +		}
> > +
> > +		spin_unlock_irq(&parent->power.lock);
> > +
> > +		if (error)
> > +			goto out;
> > +	} else {
> > +		dev->power.runtime_status = status;
> > +	}
> > +
> > + out_clear:
> > +	dev->power.runtime_failure = false;
> 
> Move all those assignments to dev->power.runtime_status down here.

OK

> > +int pm_runtime_disable(struct device *dev)
> > +{
> ...
> > +	if (dev->power.disable_depth++ > 0)
> > +		goto out;
> > +
> > +	if (dev->power.runtime_failure)
> > +		goto out;
> 
> I don't see why this is needed.

If dev->power.runtime_failure, there's no need to do anything more.

> > +
> > +	pm_runtime_deactivate_timer(dev);
> > +
> > +	if (dev->power.request_pending) {
> > +		dev->power.request = RPM_REQ_NONE;
> > +
> > +		spin_unlock_irq(&dev->power.lock);
> > +
> > +		cancel_work_sync(&dev->power.work);
> > +
> > +		spin_lock_irq(&dev->power.lock);
> > +
> > +		dev->power.request_pending = false;
> 
> Remove excessive whitespace.

OK

> > +	}
> > +
> > +	if (dev->power.runtime_status == RPM_SUSPENDING
> > +	    || dev->power.runtime_status == RPM_RESUMING) {
> > +		DEFINE_WAIT(wait);
> > +
> > +		/* Suspend or wake-up in progress. */
> > +		for (;;) {
> > +			prepare_to_wait(&dev->power.wait_queue, &wait,
> > +					TASK_UNINTERRUPTIBLE);
> > +			if (dev->power.runtime_status != RPM_SUSPENDING
> > +			    && dev->power.runtime_status != RPM_RESUMING)
> > +				break;
> > +
> > +			spin_unlock_irq(&dev->power.lock);
> > +
> > +			schedule();
> > +
> > +			spin_lock_irq(&dev->power.lock);
> > +		}
> > +		finish_wait(&dev->power.wait_queue, &wait);
> > +	}
> > +
> > +	if (dev->power.runtime_failure)
> > +		goto out;
> > +
> > +	if (dev->power.idle_notification) {
> > +		DEFINE_WAIT(wait);
> > +
> > +		for (;;) {
> > +			prepare_to_wait(&dev->power.wait_queue, &wait,
> > +					TASK_UNINTERRUPTIBLE);
> > +			if (!dev->power.idle_notification)
> > +				break;
> > +
> > +			spin_unlock_irq(&dev->power.lock);
> > +
> > +			schedule();
> > +
> > +			spin_lock_irq(&dev->power.lock);
> > +		}
> > +		finish_wait(&dev->power.wait_queue, &wait);
> > +	}
> 
> This wait loop should be merged with the previous loop.

OK

> > +void pm_runtime_init(struct device *dev)
> > +{
> > +	spin_lock_init(&dev->power.lock);
> > +
> > +	dev->power.runtime_status = RPM_SUSPENDED;
> > +	dev->power.idle_notification = false;
> > +
> > +	dev->power.disable_depth = 1;
> > +	atomic_set(&dev->power.usage_count, 0);
> > +
> > +	dev->power.runtime_failure = false;
> > +	dev->power.last_error = 0;
> 
> You don't have to set values to 0; they are initialized by kzalloc.

No, I don't, but does it really hurt?

> > +	dev->power.suspend_timer.expires = jiffies;
> > +	dev->power.suspend_timer.data = (unsigned long)dev;
> > +	dev->power.suspend_timer.function = pm_suspend_timer_fn;
> 
> Use setup_timer() instead of assigning these fields directly.

OK

> > +void pm_runtime_remove(struct device *dev)
> > +{
> > +	pm_runtime_disable(dev);
> > +
> > +	if (dev->power.runtime_status == RPM_ACTIVE) {
> > +		struct device *parent = dev->parent;
> > +
> > +		/*
> > +		 * Change the status back to 'suspended' to match the initial
> > +		 * status.
> > +		 */
> > +		pm_runtime_set_suspended(dev);
> > +		if (parent && !parent->power.ignore_children)
> > +			pm_request_idle(parent);
> 
> Shouldn't these last two lines be part of __pm_runtime_set_status()?

No.  It is valid to call __pm_runtime_set_status() when runtime PM is disabled
for the device and I don't think we should kick the parent in such cases.

> > --- /dev/null
> > +++ linux-2.6/include/linux/pm_runtime.h
> 
> > +extern void pm_runtime_init(struct device *dev);
> > +extern void pm_runtime_remove(struct device *dev);
> 
> I don't like seeing these two functions included in the public header
> file.  It's enough to put them in drivers/base/power/power.h.

OK

> > --- linux-2.6.orig/drivers/base/power/main.c
> > +++ linux-2.6/drivers/base/power/main.c
> > @@ -49,6 +50,16 @@ static DEFINE_MUTEX(dpm_list_mtx);
> >  static bool transition_started;
> >  
> >  /**
> > + * device_pm_init - Initialize the PM-related part of a device object
> > + * @dev: Device object to initialize.
> > + */
> > +void device_pm_init(struct device *dev)
> > +{
> > +	dev->power.status = DPM_ON;
> > +	pm_runtime_init(dev);
> > +}
> > +
> > +/**
> >   *	device_pm_lock - lock the list of active devices used by the PM core
> >   */
> >  void device_pm_lock(void)
> > @@ -105,6 +116,8 @@ void device_pm_remove(struct device *dev
> >  	mutex_lock(&dpm_list_mtx);
> >  	list_del_init(&dev->power.entry);
> >  	mutex_unlock(&dpm_list_mtx);
> > +
> > +	pm_runtime_remove(dev);
> >  }
> 
> Calling pm_runtime_init() from device_pm_init() and
> pm_runtime_remove() from device_pm_remove() isn't good.  If
> CONFIG_PM_SLEEP isn't enabled then the calls won't be compiled, even
> if CONFIG_PM_RUNTIME is set.

Right, I shouldn't have moved device_pm_init() to main.c at all.

> > @@ -757,11 +771,15 @@ static int dpm_prepare(pm_message_t stat
> >  		dev->power.status = DPM_PREPARING;
> >  		mutex_unlock(&dpm_list_mtx);
> >  
> > -		error = device_prepare(dev, state);
> > +		if (pm_runtime_disable(dev) && device_may_wakeup(dev))
> > +			error = -EBUSY;
> 
> What's the reason for the -EBUSY error?

If this is a wake-up device and pm_runtime_disable(dev) returned 1 (it can only
return 1 or 0), which means there was a resume request pending for the device,
suspend fails with -EBUSY (wake-up event during suspend).

> > --- linux-2.6.orig/drivers/base/dd.c
> > +++ linux-2.6/drivers/base/dd.c
> > @@ -202,7 +203,9 @@ int driver_probe_device(struct device_dr
> >  	pr_debug("bus: '%s': %s: matched device %s with driver %s\n",
> >  		 drv->bus->name, __func__, dev_name(dev), drv->name);
> >  
> > +	pm_runtime_get_noresume(dev);
> >  	ret = really_probe(dev, drv);
> > +	pm_runtime_put_noidle(dev);
> 
> This is bad because it won't wait if there's a runtime-PM call in
> progress.  Also, we shouldn't use put_noidle because it might subvert
> the driver's attempt to autosuspend.

I'm not sure how that's possible, but whatever.

> Instead we should do something like this:
> 
> 	/* Wait for runtime PM calls to finish and prevent new calls
> 	 * until the probe is done.
> 	 */
> 	pm_runtime_disable(dev);
> 	pm_runtime_get_noresume(dev);
> 	pm_runtime_enable(dev):
> 	ret = really_probe(dev, drv);
> 	pm_runtime_put_sync(dev);

Fine by me.

> > --- /dev/null
> > +++ linux-2.6/Documentation/power/runtime_pm.txt
> 
> > +2. Device Run-time PM Callbacks
> 
> > +In particular, it is recommended that ->runtime_suspend() return -EBUSY if
> > +device_may_wakeup() returns 'false' for the device.
> 
> What's the point of this?  I don't understand -- we don't want to
> discourage people from suspending devices with wakeup enabled.

device_may_wakeup(dev) == false means wake-up is disabled for dev, so
suspending it might not be a good idea.

> > +Additionally, the helper functions provided by the PM core obey the following
> > +rules:
> > +
> > +  * If ->runtime_suspend() is about to be executed or the execution of it is
> > +    scheduled or there's a pending request to execute it, ->runtime_idle() will
> > +    not be executed for the same device.
> 
> Shouldn't we allow runtime_idle when a suspend is scheduled?  The idle
> handler might decide to suspend right away instead of waiting for the
> timer to expire.

Hmm.  We can.

> > +4. Run-time PM Device Helper Functions
> > +
> > +The following run-time PM helper functions are defined in
> > +drivers/base/power/runtime.c and include/linux/pm_runtime.h:
> 
> > +  int pm_schedule_suspend(struct device *dev, unsigned int delay);
> > +    - schedule the execution of ->runtime_suspend() for the device's bus type
> > +      in future, where 'delay' is the time to wait before queuing up a suspend
> > +      work item in pm_wq, in miliseconds (if 'delay' is zero, the work item is
> 
> Fix spelling of "milli".

OK

> Explain that the new delay will override the
> old one if a suspend was already scheduled and not yet expired.

OK

> > +  int pm_runtime_get_sync(struct device *dev);
> > +    - increment the device's usage counter, run pm_rutime_resume(dev) and return
> 
> Fix spelling of "runtime".  Same under pm_runtime_put_sync.

OK

Thanks a lot for the comments, I'll post an updated patch addressing them in
the next few days.

Best,
Rafael
