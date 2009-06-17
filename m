Return-Path: <linux-kernel-owner+w=401wt.eu-S1760752AbZFQXHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760752AbZFQXHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 19:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbZFQXH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 19:07:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34733 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696AbZFQXHZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 19:07:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch update 2 fix] PM: Introduce core framework for run-time PM of I/O devices
Date: Thu, 18 Jun 2009 01:07:33 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>, Magnus Damm <magnus.damm@gmail.com>,
       linux-pm@lists.linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
References: <Pine.LNX.4.44L0.0906171408280.2820-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906171408280.2820-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200906180107.34764.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Thanks a lot for the review!

On Wednesday 17 June 2009, Alan Stern wrote:
> On Wed, 17 Jun 2009, Rafael J. Wysocki wrote:
> 
> > Sorry for the broken patch.  My mailer started to wordwrap messages
> > automatically and I didn't notice.
> > 
> > The correct patch is appended.
> 
> > Index: linux-2.6/include/linux/pm.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/pm.h
> > +++ linux-2.6/include/linux/pm.h
> 
> > + * @runtime_suspend: Prepare the device for a condition in which it won't be
> > + *	able to communicate with the CPU(s) and RAM due to power management.
> > + *	This need not mean that the device should be put into a low power state,
> > + *	like for example when the device is behind a link, represented by a
> 
> Suggested rephrasing: For example, if the device is behind a link
> which is about to be turned off, the device may remain at full power.
> But if the device does go to low power and if device_may_wakeup(dev)
> is true, enable remote wakeup.

Done.

> > +/**
> > + * Device run-time power management state.
> > + *
> > + * These state labels are used internally by the PM core to indicate the current
> > + * status of a device with respect to the PM core operations.  They do not
> > + * reflect the actual power state of the device or its status as seen by the
> > + * driver.
> > + *
> > + * RPM_ACTIVE		Device is fully operational, no run-time PM requests are
> > + *			pending for it.
> > + *
> > + * RPM_IDLE		It has been requested that the device be suspended.
> > + *			Suspend request has been put into the run-time PM
> > + *			workqueue and it's pending execution.
> > + *
> > + * RPM_SUSPENDING	Device bus type's ->runtime_suspend() callback is being
> > + *			executed.
> > + *
> > + * RPM_SUSPENDED	Device bus type's ->runtime_suspend() callback has
> > + *			completed successfully.  The device is regarded as
> > + *			suspended.
> > + *
> > + * RPM_WAKE		It has been requested that the device be woken up.
> > + *			Resume request has been put into the run-time PM
> > + *			workqueue and it's pending execution.
> > + *
> > + * RPM_RESUMING		Device bus type's ->runtime_resume() callback is being
> > + *			executed.
> > + *
> > + * RPM_ERROR		Represents a condition from which the PM core cannot
> > + *			recover by itself.  If the device's run-time PM status
> > + *			field has this value, all of the run-time PM operations
> > + *			carried out for the device by the core will fail, until
> > + *			the status field is changed to either RPM_ACTIVE or
> > + *			RPM_SUSPENDED (it is not valid to use the other values
> > + *			in such a situation) by the device's driver or bus type.
> > + *			This happens when the device bus type's
> > + *			->runtime_suspend() or ->runtime_resume() callback
> > + *			returns error code different from -EAGAIN or -EBUSY.
> 
> What about RPM_GRACE?

Forgotten.

Well, I've already replaced it with a counter (more about it below).

> > + */
> > +
> > +#define RPM_ACTIVE	0
> > +#define RPM_IDLE	0x01
> > +#define RPM_SUSPENDING	0x02
> > +#define RPM_SUSPENDED	0x04
> > +#define RPM_WAKE	0x08
> > +#define RPM_RESUMING	0x10
> > +#define RPM_GRACE	0x20
> > +#define RPM_ERROR	(-1)
> 
> This won't work very well when assigned to an unsigned 6-bit field.

OK, I'm changing it to 0x1F (IOW, all bits set).

> > +
> > +#define RPM_IN_SUSPEND	(RPM_SUSPENDING | RPM_SUSPENDED)
> > +#define RPM_INACTIVE	(RPM_IDLE | RPM_IN_SUSPEND)
> > +#define RPM_NO_SUSPEND	(RPM_WAKE | RPM_RESUMING | RPM_GRACE)
> > +#define RPM_IN_PROGRESS	(RPM_SUSPENDING | RPM_RESUMING)
> 
> Since each of these is used only once, it would be better not to
> define them as macros.  Use the parenthesized expression instead; this
> will be easier for readers to understand.

OK

> > +/**
> > + * __pm_runtime_change_status - Change the run-time PM status of a device.
> > + * @dev: Device to handle.
> > + * @status: Expected current run-time PM status of the device.
> > + * @new_status: New value of the device's run-time PM status.
> > + *
> > + * Change the run-time PM status of the device to @new_status if its current
> > + * value is equal to @status.
> > + */
> > +void __pm_runtime_change_status(struct device *dev, unsigned int status,
> 
> If RPM_ERROR is -1 then status better not be unsigned.

That's fixed by redefining RPM_ERROR (see above).

> > +				unsigned int new_status)
> > +{
> > +	unsigned long flags;
> > +
> > +	if (atomic_read(&dev->power.depth) > 0)
> > +		return;
> 
> Return only if new_status == RPM_SUSPENDED.

Not only then.  The dev->power.depth counter was meant to be a "disable
everything" one, because there are situations in which we don't want even
resume to run (probe, release, system-wide suspend, hibernation, resume from
a system sleep state, possibly others).

That said, I overlooked some problems related to it.  So, I think to disable
the runtime PM of given device, it will be necessary to run a synchronous
runtime resume with taking a ref to block suspend.

> Is this routine ever called with status equal to anything other than
> RPM_ERROR?

Not at the moment.  OK, I'll change it.

> +/**
> + * pm_check_children - Check if all children of a device have been suspended.
> + * @dev: Device to check.
> + *
> + * Returns 0 if all children of the device have been suspended or -EBUSY
> + * otherwise.
> + */
> +static int pm_check_children(struct device *dev)
> +{
> +	return dev->power.suspend_skip_children ? 0 :
> +			device_for_each_child(dev, NULL, pm_device_suspended);
> +}
> 
> Instead of a costly device_for_each_child(), would it be better to
> maintain a counter with the number of unsuspended children?

Hmm.  How exactly are we going to count them?  The only way I see at the moment
would be to increase this number by one when running pm_runtime_init() for a
new child.  Seems doable.

> > +/**
> > + * __pm_runtime_suspend - Run a device bus type's runtime_suspend() callback.
> > + * @dev: Device to suspend.
> > + * @sync: If unset, the funtion has been called via pm_wq.
> > + *
> > + * Check if the status of the device is appropriate and run the
> > + * ->runtime_suspend() callback provided by the device's bus type driver.
> > + * Update the run-time PM flags in the device object to reflect the current
> > + * status of the device.
> > + */
> > +int __pm_runtime_suspend(struct device *dev, bool sync)
> > +{
> > +	int error = -EINVAL;
> > +
> > +	if (atomic_read(&dev->power.depth) > 0)
> > +		return -EBUSY;
> 
> Should this test be made inside the scope of the spinlock?

Yes, it should.

> For that matter, should power.depth always be set within the spinlock?
> If it is then it doesn't need to be an atomic_t.

pm_runtime_[dis|en]able() don't take the lock when changing it, but it's
going to be dropped anyway.

> > +
> > +	spin_lock(&dev->power.lock);
> 
> Should be spin_lock_irq().  Same in other places.

OK, I wasn't sure about that.

> > +
> > +	if (dev->power.runtime_status == RPM_ERROR) {
> > +		goto out;
> > +	} else if (dev->power.runtime_status & RPM_SUSPENDED) {
> > +		error = 0;
> > +		goto out;
> > +	} else if ((dev->power.runtime_status & RPM_NO_SUSPEND)
> > +	    || (!sync && dev->power.suspend_aborted)) {
> > +		/*
> > +		 * Device is resuming or in a post-resume grace period or
> > +		 * there's a resume request pending, or a pending suspend
> > +		 * request has just been cancelled and we're running as a result
> > +		 * of this request.
> > +		 */
> 
> In the sync case, it might be better to wait until the ongoing resume
> (or resume grace period) is finished and then do the suspend.
>
> Of course, this depends on the context in which the synchronous
> runtime suspend is carried out.  Right now, the only such context I
> know of is when the user tells the system to force a USB device into a
> suspended state.

>From the functionality point of view, nothing wrong happens if runtime suspend
fails as long as an error code is returned and the caller has to be prepared
for a failure anyway.  Moreover, we never know why the resume is carried out,
so it's not clear whether it will be valid to carry out the suspend after that.

> 
> > +		error = -EAGAIN;
> > +		goto out;
> > +	} else if (dev->power.runtime_status == RPM_SUSPENDING) {
> > +		spin_unlock(&dev->power.lock);
> > +
> > +		/*
> > +		 * Another suspend is running in parallel with us.  Wait for it
> > +		 * to complete and return.
> > +		 */
> > +		wait_for_completion(&dev->power.work_done);
> > +
> > +		return dev->power.runtime_error;
> > +	} else if (pm_check_children(dev)) {
> > +		/*
> > +		 * We can only suspend the device if all of its children have
> > +		 * been suspended.
> > +		 */
> > +		dev->power.runtime_status = RPM_ACTIVE;
> > +		error = -EAGAIN;
> 
> -EBUSY would be more appropriate.

OK

> > +		goto out;
> > +	}
> 
> > +/**
> > + * pm_cancel_suspend - Cancel a pending suspend request for given device.
> > + * @dev: Device to cancel the suspend request for.
> > + */
> > +static void pm_cancel_suspend(struct device *dev)
> > +{
> > +	cancel_delayed_work(&dev->power.runtime_work);
> > +	dev->power.runtime_status &= RPM_GRACE;
> 
> This looks strange.  Aren't we guaranteed at this point that the
> status is RPM_IDLE?

Yes.

> > +	dev->power.suspend_aborted = true;
> > +}
> > +
> > +/**
> > + * __pm_runtime_resume - Run a device bus type's runtime_resume() callback.
> > + * @dev: Device to resume.
> > + * @grace: If set, force a post-resume grace period.
> > + *
> > + * Check if the device is really suspended and run the ->runtime_resume()
> > + * callback provided by the device's bus type driver.  Update the run-time PM
> > + * flags in the device object to reflect the current status of the device.  If
> > + * runtime suspend is in progress while this function is being run, wait for it
> > + * to finish before resuming the device.  If runtime suspend is scheduled, but
> > + * it hasn't started yet, cancel it and we're done.
> > + */
> > +int __pm_runtime_resume(struct device *dev, bool grace)
> > +{
> > +	int error = -EINVAL;
> ...
> > +	} else if (dev->power.runtime_status == RPM_SUSPENDED && dev->parent
> > +	    && (dev->parent->power.runtime_status & ~RPM_GRACE)) {
> > +		spin_unlock(&dev->power.lock);
> 
> Here's where you want to increment the parent's depth.  Figuring out
> where to decrement it again isn't easy, given the way this routine is
> structured.

Hmm.  We can use a local bool variable to store the information that the ref
has been taken for the parent and dereference it when leaving the function.

> > +		spin_unlock(&dev->parent->power.lock);
> > +
> > +		/* The device's parent is not active.  Resume it and repeat. */
> > +		error = __pm_runtime_resume(dev->parent, false);
> > +		if (error)
> > +			return error;
> 
> Need to reset error to -EINVAL.

Why -EINVAL?

> > +/**
> > + * pm_request_resume - Schedule run-time resume of given device.
> > + * @dev: Device to resume.
> > + * @grace: If set, force a post-resume grace period.
> > + */
> > +void __pm_request_resume(struct device *dev, bool grace)
> > +{
> > +	unsigned long parent_flags = 0, flags;
> > +
> > + repeat:
> > +	if (atomic_read(&dev->power.depth) > 0)
> > +		return;
> > +
> > +	if (dev->parent)
> > +		spin_lock_irqsave(&dev->parent->power.lock, parent_flags);
> > +	spin_lock_irqsave(&dev->power.lock, flags);
> > +
> > +	if (dev->power.runtime_status == RPM_IDLE) {
> > +		/* Autosuspend request is pending, no need to resume. */
> > +		pm_cancel_suspend(dev);
> > +		if (grace)
> > +			dev->power.runtime_status |= RPM_GRACE;
> > +		goto out;
> > +	} else if (!(dev->power.runtime_status & RPM_IN_SUSPEND)) {
> > +		goto out;
> > +	} else if (dev->parent
> > +	    && (dev->parent->power.runtime_status & RPM_INACTIVE)) {
> > +		spin_unlock_irqrestore(&dev->power.lock, flags);
> > +		spin_unlock_irqrestore(&dev->parent->power.lock, parent_flags);
> > +
> > +		/* The parent is suspending, suspended or idle. Wake it up. */
> > +		__pm_request_resume(dev->parent, false);
> > +
> > +		goto repeat;
> 
> What if the parent's state is RPM_SUSPENDING?  Won't this go into a
> tight loop?  You need to test the parent's WAKEUP bit above.

Right.

> > Index: linux-2.6/Documentation/power/runtime_pm.txt
> > ===================================================================
> > --- /dev/null
> > +++ linux-2.6/Documentation/power/runtime_pm.txt
> > @@ -0,0 +1,311 @@
> > +Run-time Power Management Framework for I/O Devices
> > +
> > +(C) 2009 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
> > +
> > +1. Introduction
> > +
> > +The support for run-time power management (run-time PM) of I/O devices is
> 
> s/The support/Support/

OK

> > +provided at the power management core (PM core) level by means of:
> 
> > +pm_runtime_enable() and pm_runtime_disable() are used to enable and disable,
> > +respectively, all of the run-time PM core operations.  They do it by decreasing
> > +and increasing, respectively, the 'power.depth' field of 'struct device'.  If
> > +the value of this field is greater than 0, pm_runtime_suspend(),
> > +pm_request_suspend(), pm_runtime_resume() and so on return immediately without
> > +doing anything and -EBUSY is returned by pm_runtime_suspend(),
> > +pm_runtime_resume() and pm_runtime_resume_grace().  Therefore, if
> 
> In your code, pm_runtime_disable() doesn't actually do a resume.  So if
> a driver wants to make sure a device is at full power and stays that
> way, it has to call:
> 
> 	pm_runtime_resume(dev);
> 	pm_runtime_disable(dev);
> 
> This is a race; another thread might suspend the device in between.
> It would make more sense to have have pm_runtime_resume() function
> normally even when depth > 0.  Then the calls could be made in the
> opposite order and there wouldn't be a race.
> 
> The equivalent code in USB does this automatically.  The
> runtime-disable routine does a resume if the depth value was
> originally 0,

Yes, we should do that in general.

> and the runtime-enable routine queues a delayed autosuspend request if the
> final depth value is 0.

I don't like this.

> > +pm_runtime_suspend(), pm_request_suspend(), pm_runtime_resume(),
> > +pm_runtime_resume_grace(), pm_request_resume(), and pm_request_resume_grace()
> > +use the 'power.runtime_status' and 'power.suspend_aborted' fields of
> > +'struct device' for mutual synchronization.  The 'power.runtime_status' field,
> 
> Strictly speaking, they use those fields for mutual cooperation.  It's
> the power.lock field which provides synchronization.

OK

> > +pm_runtime_suspend() is used to carry out a run-time suspend of an active
> > +device.  It is called directly by a bus type or device driver.  An asynchronous
> > +version of it is called by the PM core, to complete a request queued up by
> > +pm_request_suspend().  The only difference between them is the handling of
> > +situations when a queued up suspend request has just been cancelled.  Apart from
> > +this, they work in the same way.
> > +* If the device is suspended (i.e. the RPM_SUSPENDED bit is set in the device's
> > +  run-time PM status field, 'power.runtime_status'), success is returned.
> 
> Blank lines surrounding the *-ed paragraphs would make this more
> readable.

OK

> > +pm_request_resume() and pm_request_resume_grace() are used to queue up a resume
> > +request for a device that is suspended, suspending or has a suspend request
> > +pending.  The difference between them is that pm_request_resume_grace() causes
> > +the RPM_GRACE bit to be set in the device's run-time PM status field, which
> > +prevents the PM core from suspending the device or queuing up a suspend request
> > +for it until the RPM_GRACE bit is cleared with the help of pm_runtime_release().
> > +Apart from this, they work in the same way.
> 
> Is RPM_GRACE really needed?  Can't we accomplish more or less the same
> thing by using the autosuspend delay combined with the depth counter?

No, it's not.  As I said above, I replaced it with a counter and then I
realized that 'disable' should in fact do 'resume and get', so we can handle
everything with just one counter.

I'll send a revised patch tomorrow.

Best,
Rafael
