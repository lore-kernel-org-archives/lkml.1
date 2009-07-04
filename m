Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbZGDV1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbZGDV1b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 17:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbZGDV1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 17:27:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48010 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbZGDV1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 17:27:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC] Run-time PM framework (was: Re: [patch update] PM: Introduce core framework for run-time PM of I/O devices (rev. 6))
Date: Sat, 4 Jul 2009 23:27:31 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
References: <Pine.LNX.4.44L0.0907032224410.29876-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0907032224410.29876-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907042327.32073.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 July 2009, Alan Stern wrote:
> On Sat, 4 Jul 2009, Rafael J. Wysocki wrote:
> 
> > > > I don't really like the async_action idea, as you might have noticed.
> > > 
> > > Do you mean that you don't like the field, or that you don't like its name?
> > 
> > The name, actually.  That's because I'd like to use the values for something
> > that's not 'async' in substance (more on that later).
> 
> Okay.  I don't care about the name.
> 
> > It occured to me in the meantime that if we added a 'request_pending' (or
> > 'work_pending' or whatever similar) flag to the above, we could avoid using
> > cancel_work().  Namely, if 'request_pending' indicates that there's a work item
> > queued up, we could change 'request type' to NONE in case we didn't want the
> > work function to do anything.  Then, the work function would just unset
> > 'request_pending' and quit if 'request type' is NONE.
> 
> You mean use request_pending to decide whether to call cancel_work, 
> instead of looking at request_type?  That's right.
> 
> As for whether or not we should actually call cancel_work...  Which is 
> more expensive: Calling cancel_work when no work is pending, or letting 
> the work item run when it doesn't have anything to do?  Probably the 
> latter.

Agreed, but that doesn't affect functionality.  We can get the desired
functionality without the cancel_work() patch and then optimize things along
with that patch.  This way it'll be easier to demontrate the benefit of it.

> > I generally like the idea of changing 'request type' on the fly once we've
> > noticed that the currently pending request should be replaced by another one.
> 
> Me too.
> 
> > That would require us to introduce a big idle-suspend-resume function
> > choosing the callback to run based on 'request type', which would be quite
> > complicated.
> 
> It doesn't have to be very big or complicated:
> 
> 	spin_lock_irq(&dev->power.lock);

Ah, that is the detail I overlooked, we don't need to use
spin_lock_irqsave(), because these function will always be called with
interrupts enabled.

> 	switch (dev->power.request_type) {
> 	case RPM_REQ_SUSPEND:
> 		__pm_runtime_suspend(dev, false);
> 		break;
> 	case RPM_REQ_RESUME:
> 		__pm_runtime_resume(dev, false);
> 		break;
> 	case RPM_REQ_IDLE:
> 		__pm_runtime_idle(dev, false);
> 		break;
> 	default:
> 	}
> 	spin_unlock_irq(&dev->power.lock);
> 
> It would be necessary to change the __pm_runtime_* routines, since they
> would now have to be called with the lock held.
> 
> >  But that function could also be used for the 'synchronous'
> > operations, so perhaps it's worth trying?
> > 
> > Such a function can take two arguments, dev and request, where the second
> > one determines the callback to run.  It can take the same values as 'request
> > type', where NONE means "you've been called from the workqueue, use 'request
> > type' from dev to check what to do", but your ASYNC_* names are not really
> > suitable here. :-)
> 
> I don't see any advantage in that approach.  The pm_runtime_* functions
> already know what they want to do.  Why encode it in a request argument
> only to decode it again?

Well, scratch that anyway, I thought it would be necessary because of the
'irqsave' locking.

> > > > That's fine, we'd also need to wait for running callbacks to
> > > > finish too.  And I'm still not convinced if we should preserve
> > > > requests queued up before the system sleep.  Or keep the suspend
> > > > timer running for that matter.
> > > 
> > > This all does into the "to-be-determined" category.  :-)
> > 
> > Well, I'd like to choose something to start with.
> 
> Pending suspends and the suspend timer don't matter much; we can cancel
> them because they ought to get resubmitted after the system wakes up.  
> Pending resumes are more difficult; depending on how they are treated
> they could morph into immediate wakeup requests.
> 
> Perhaps even more tricky is how to handle things like the ACPI suspend
> calls when the device is already runtime-suspended.  I don't know what 
> we should do about that.

That almost entirely depends on the bus type.  For PCI and probably PNP as well
there's a notion of ACPI low power states and there are AML methods to put the
devices into these states.  Unfortunately, the ACPI low power state to put the
device into depends on the target sleep state of the system, so these devices
will probably have to be put into D0 before system suspend anyway.

I think that the bus type can handle this as long as it knows the state the
device is in before system suspend.  So, the only thing the core should do is
to block the execution of run-time PM framework functions during system
sleep and resume.  The state it leaves the device in shouldn't matter.

So, I think we can simply freeze the workqueue, set the 'disabled' bit for each
device and wait for all run-time PM operations on it in progress to complete.

In the 'disabled' state the bus type or driver can modify the run-time PM
status to whatever they like anyway.  Perhaps we can provide a helper to
change 'request type' to RPM_REQ_NONE.

> > > > pm_schedule_suspend()
> > > >   * return -EINVAL if 'disabled' is set or 'runtime_error' is set
> > > >   * return -EAGAIN if 'usage_count' > 0 or 'child_count' > 0
> > > >   * return -EALREADY if 'runtime status' is RPM_SUSPENDED
> > > >   * return -EINPROGRESS if 'runtime status' is RPM_SUSPENDING
> > > 
> > > The last two aren't right.  If the status is RPM_SUSPENDED or
> > > RPM_SUSPENDING, cancel any pending work and set the type to
> > > RPM_REQ_NONE before returning.  In other words, cancel a possible 
> > > pending resume request.
> > 
> > Wy do you think the possible pending resume request should be canceled?
> 
> It's part of the "most recent request wins" approach.
>
> > I don't really agree here.  Resume request really means there's data to
> > process, so we shouldn't cancel pending resume requests IMO.
> > 
> > The driver should be given a chance to process data in ->runtime_resume()
> > even if it doesn't use the usage counter.  Otherwise, the usage counter would
> > always have to be used along with resume requests, so having
> > pm_request_resume() that doesn't increment the usage counter would really be
> > pointless.
> 
> All right, I'll go along with this.  So instead of "most recent request 
> wins", we have something like this:
> 
> 	Resume requests (queued or in progress) override suspend and 
> 	idle requests (sync or async).
> 
> 	Suspend requests (queued or in progress, but not unexpired)
> 	override idle requests (sync or async).
> 
> But this statement might not be precise enough, and I'm too tired to
> think through all the ramifications right now.

Fair enough. :-)

> > > > pm_request_suspend()
> > > >   * return if 'disabled' is set or 'runtime_error' is set
> > > >   * return if 'usage_count' > 0 or 'child_count' > 0
> > > >   * return if 'runtime status' is RPM_SUSPENDING or RPM_SUSPENDED
> > > 
> > > First cancel a possible pending resume request.
> > 
> > I disagree.
> 
> This is the same as the above, right?

Yes.

> > > If the status is RPM_RESUMING or RPM_ACTIVE, cancel a possible pending 
> > > timer (and set time_expiration to 0).
> > 
> > We're the timer function, so either the timer is not pending, or we've been
> > executed too early.
> 
> Oh, okay.  I thought perhaps you might have wanted to export
> pm_request_suspend.  But this is really supposed to be just the timer 
> handler.

Yes, it is.

> > > > pm_request_resume()
> > > >   * return -EINVAL if 'disabled' is set or 'runtime_error' is set
> > > >   * return -EINPROGRESS if 'runtime status' is RPM_RESUMING
> > > 
> > > Or RPM_ACTIVE.
> > 
> > Maybe return 1 in that case?
> 
> Yes.
> 
> > > >   * return -EALREADY if 'request type' is RPM_REQ_RESUME
> > > 
> > > For these last two, first cancel a possible pending suspend request
> > > and a possible timer.
> > 
> > Possible timer only, I think.  if 'request type' is RESUME, there can't be
> > suspend request pending.
> 
> But there can be if the status is RPM_ACTIVE.  So okay, if the status 
> isn't RPM_RESUMING or RPM_ACTIVE and request_type is RPM_REQ_RESUME, 
> then return 0.
> 
> 
> > > Similar outlines apply for pm_runtime_suspend, pm_runtime_resume, and
> > > pm_runtime_idle.  There is an extra requirement: When a suspend or
> > > resume is over, if 'request type' is set then schedule the work item.  
> > > Doing things this way allows the workqueue thread to avoid waiting
> > > around for the suspend or resume to finish.
> > 
> > I agree except that I would like suspends to just fail when the status is
> > RPM_RESUMING.  The reason is that a sloppily written driver could enter a
> > busy-loop of suspending-resuming the device, without the possibility to process
> > data, if there's full symmetry between suspend and resume.  So, I'd like to
> > break that symmetry and make resume operations privileged with respect to
> > suspend and idle notifications.  
> 
> This follows from the new precedence rule.

Yes.

So, I guess we have the majority of things clarified and perhaps its time to
write a patch for further discussion. :-)

Best,
Rafael
