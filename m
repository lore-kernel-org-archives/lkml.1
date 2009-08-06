Return-Path: <linux-kernel-owner+w=401wt.eu-S1752635AbZHFVt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbZHFVt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 17:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbZHFVtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 17:49:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33123 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbZHFVty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 17:49:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH update] PM: Introduce core framework for run-time PM of I/O devices (rev. 12)
Date: Thu, 6 Aug 2009 23:50:25 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Magnus Damm <magnus.damm@gmail.com>, Greg KH <gregkh@suse.de>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0908061257490.2937-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0908061257490.2937-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908062350.25426.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 August 2009, Alan Stern wrote:
> On Wed, 5 Aug 2009, Rafael J. Wysocki wrote:
> 
> > Hi,
> > 
> > The patch below should address all of your recent comments.
> > 
> > Additionally I changed a few bits that I thought could turn out to be
> > problematic at one point.
> 
> Looking good.  I've got a few more suggestions.
> 
> It occurred to me that there's no need for a separate
> "runtime_failure" flag.  A nonzero value of "last_error" will do just
> as well.

Yes, good catch.  I don't quite remember why I wanted the flag and a separate
error field.

> If you make this change, note that it affects the documentation as well as
> the code.

Sure.

> If we defer a resume request while a suspend is in progress, then when
> the suspend finishes should the resume be carried out immediately
> rather than queued?  I don't see any reason why not.

Well, it's not very clear what to return to the caller in such a case.  I guess
we can return -EAGAIN.

> > +/**
> > + * __pm_runtime_suspend - Carry out run-time suspend of given device.
> > + * @dev: Device to suspend.
> > + * @from_wq: If set, the function has been called via pm_wq.
> > + *
> > + * Check if the device can be suspended and run the ->runtime_suspend() callback
> > + * provided by its bus type.  If another suspend has been started earlier, wait
> > + * for it to finish.  If there's an idle notification pending, cancel it.  If
> > + * there's a suspend request scheduled while this function is running and @sync
> > + * is 'true', cancel that request.
> 
> Change the last two sentences as follows: If an idle notification or suspend
> request is pending or scheduled, cancel it.

OK

> > + *
> > + * This function must be called under dev->power.lock with interrupts disabled.
> > + */
> > +int __pm_runtime_suspend(struct device *dev, bool from_wq)
> > +	__releases(&dev->power.lock) __acquires(&dev->power.lock)
> > +{
> ...
> > +	pm_runtime_deactivate_timer(dev);
> > +
> > +	if (dev->power.request_pending) {
> > +		/* Pending resume requests take precedence over us. */
> > +		if (dev->power.request == RPM_REQ_RESUME)
> > +			return -EAGAIN;
> > +		/* Other pending requests need to be canceled. */
> > +		dev->power.request = RPM_REQ_NONE;
> > +	}
> 
> Might as well use pm_runtime_cancel_pending since we have it:
> 
> 	/* Pending resume requests take precedence over us. */
> 	if (dev->power.request_pending && dev->power.request == RPM_REQ_RESUME)
> 		return -EAGAIN;
> 
> 	/* Other pending requests need to be canceled. */
> 	pm_runtime_cancel_pending(dev);

OK

> ...
> > +	if (dev->power.deferred_resume) {
> > +		__pm_request_resume(dev);
> 
> __pm_runtime_resume instead?

In which case we shouldn't execute the code below, IMO, but return immediately
instead.

> > +/**
> > + * __pm_runtime_resume - Carry out run-time resume of given device.
> > + * @dev: Device to resume.
> > + * @from_wq: If set, the function has been called via pm_wq.
> > + *
> > + * Check if the device can be woken up and run the ->runtime_resume() callback
> > + * provided by its bus type.  If another resume has been started earlier, wait
> > + * for it to finish.  If there's a suspend running in parallel with this
> > + * function, wait for it to finish and resume the device.  If there's a suspend
> > + * request or idle notification pending, cancel it.  If there's a resume request
> > + * scheduled while this function is running, cancel that request.
> 
> Change the last two sentences as follows: Cancel any pending requests.

OK

> > + *
> > + * This function must be called under dev->power.lock with interrupts disabled.
> > + */
> > +int __pm_runtime_resume(struct device *dev, bool from_wq)
> > +	__releases(&dev->power.lock) __acquires(&dev->power.lock)
> > +{
> > +	struct device *parent = NULL;
> > +	int retval = 0;
> > +
> > + repeat:
> > +	if (dev->power.runtime_failure)
> > +		return -EINVAL;
> 
> Here and in two places below, goto out_parent instead of returning
> directly.

Ah, that was a real bug.  Thanks for catching it!

> ...
> > +	if (!parent && dev->parent) {
> > +		/*
> > +		 * Increment the parent's resume counter and resume it if
> > +		 * necessary.
> > +		 */
> > +		parent = dev->parent;
> > +		spin_unlock_irq(&dev->power.lock);
> > +
> > +		retval = pm_runtime_get_sync(parent);
> > +
> > +		spin_lock_irq(&dev->power.lock);
> > +		/* We can resume if the parent's run-time PM is disabled. */
> > +		if (retval < 0 && retval != -EAGAIN)
> > +			goto out_parent;
> 
> Instead of checking retval, how about checking the parent's PM status?

Should work.

> Also, this isn't needed if the parent is set to ignore children.

OK, I'll change that.

> > +static int __pm_request_idle(struct device *dev)
> > +{
> > +	int retval = 0;
> > +
> > +	if (dev->power.runtime_failure)
> > +		retval = -EINVAL;
> > +	else if (atomic_read(&dev->power.usage_count) > 0
> > +	    || dev->power.disable_depth > 0
> > +	    || dev->power.timer_expires > 0
> 
> This line should be removed.

Yeah, thanks!

> ...
> > +	if (dev->power.request_pending && dev->power.request != RPM_REQ_NONE) {
> > +		/* Any requests other then RPM_REQ_IDLE take precedence. */
> > +		if (dev->power.request != RPM_REQ_IDLE)
> > +			retval = -EAGAIN;
> > +		return retval;
> > +	}
> > +
> > +	dev->power.request = RPM_REQ_IDLE;
> > +	if (dev->power.request_pending)
> > +		return retval;
> > +
> > +	dev->power.request_pending = true;
> > +	queue_work(pm_wq, &dev->power.work);
> 
> This should be done consistently with the other routines.  Thus:
> 
> 	if (dev->power.request_pending) {
> 		/* All other requests take precedence. */
> 		if (dev->power.request == RPM_REQ_NONE)
> 			dev->power.request = RPM_REQ_IDLE;
> 		else if (dev->power.request != RPM_REQ_IDLE)
> 			retval = -EAGAIN;
> 		return retval;
> 	}
> 
> 	dev->power.request = RPM_REQ_IDLE;
> 	dev->power.request_pending = true;
> 	queue_work(pm_wq, &dev->power.work);

OK

> > +int __pm_runtime_set_status(struct device *dev, unsigned int status)
> > +{
> > +	struct device *parent = dev->parent;
> > +	unsigned long flags;
> > +	bool notify_parent = false;
> > +	int error = 0;
> > +
> > +	if (status != RPM_ACTIVE && status != RPM_SUSPENDED)
> > +		return -EINVAL;
> > +
> > +	spin_lock_irqsave(&dev->power.lock, flags);
> > +
> > +	if (!dev->power.runtime_failure && !dev->power.disable_depth)
> > +		goto out;
> 
> Set "error" to a negative code?

OK

> > @@ -757,11 +770,16 @@ static int dpm_prepare(pm_message_t stat
> >  		dev->power.status = DPM_PREPARING;
> >  		mutex_unlock(&dpm_list_mtx);
> >  
> > -		error = device_prepare(dev, state);
> > +		if (pm_runtime_disable(dev) && device_may_wakeup(dev))
> > +			/* Wake-up during suspend. */
> > +			error = -EBUSY;
> 
> Or maybe "Wakeup was requested during sleep transition."

Sounds better.

> > +  unsigned int deferred_resume;
> > +    - set if ->runtime_resume() is about to be run while ->runtime_suspend() is
> > +      being executed for that device and it is not practical to wait for the
> > +      suspend to complete; means "queue up a resume request as soon as you've
> > +      suspended"
> 
> "start a resume" instead of "queue up a resume request"?

OK

> > +5. Run-time PM Initialization
> ...
> > +If the defaul initial run-time PM status of the device (i.e. 'suspended')
> 
> Fix spelling of "default".

OK

> > +reflects the actual state of the device, its bus type's or its driver's
> > +->probe() callback will likely need to wake it up using one of the PM core's
> > +helper functions described in Section 4.  In that case, pm_runtime_resume()
> > +should be used.  Of course, for this purpose the device's run-time PM has to be
> > +enabled earlier by calling pm_runtime_enable().
> > +
> > +If ->probe() calls pm_runtime_suspend() or pm_runtime_idle(), or their
> > +asynchronous counterparts, they will fail returning -EAGAIN, because the
> > +device's usage counter is incremented by the core before executing ->probe().
> > +Still, it may be desirable to suspend the device as soon as ->probe() has
> > +finished, so the core uses pm_runtime_idle() to invoke the device bus type's
> > +->runtime_idle() callback at that time, which only happens even if ->probe()
> 
> s/which only happens even/but only/
> 
> > +is successful.

OK

Thanks for the comments!  In fact I've already updated the patch to address
them, so I'll send it in a little while.

Best,
Rafael
