Return-Path: <linux-kernel-owner+w=401wt.eu-S1758808AbZGCX5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbZGCX5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 19:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbZGCX5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 19:57:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45435 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754453AbZGCX5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 19:57:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC] Run-time PM framework (was: Re: [patch update] PM: Introduce core framework for run-time PM of I/O devices (rev. 6))
Date: Sat, 4 Jul 2009 01:57:36 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
References: <Pine.LNX.4.44L0.0907031551160.25486-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0907031551160.25486-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907040157.37302.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 July 2009, Alan Stern wrote:
> On Fri, 3 Jul 2009, Rafael J. Wysocki wrote:
> 
> > > ["error" isn't a good name.  The return value would be 0 to indicate 
> > > the request was accepted and queued, or 1 to indicate the device is 
> > > already active.  Or perhaps vice versa.]
> > 
> > Why do you insist on using positive values?  Also, there are other situations
> > possible (like run-time PM is disabled etc.).
> 
> I think we should use positive values to indicate situations that
> aren't the "nominal" case but also aren't errors.  This simplifies
> error checking in drivers.  For example, you wouldn't want to print a
> debugging or warning message just because the device happened to be
> active already when you called pm_runtime_resume.

OK

> > I don't really like the async_action idea, as you might have noticed.
> 
> Do you mean that you don't like the field, or that you don't like its name?

The name, actually.  That's because I'd like to use the values for something
that's not 'async' in substance (more on that later).
 
> > > > Thus, it seems reasonable to remember what type of a request is pending
> > > > (i don't think we can figure it out from the status fields in 100% of the
> > > > cases).
> > > 
> > > That's what the async_action field in my proposal is for.
> > 
> > Ah.  Why don't we just use a request type field instead?
> 
> "A rose by any other name..."
> 
> > In fact, we can use a 2-bit status field (RPM_ACTIVE, RPM_SUSPENDING,
> > RPM_SUSPENDED, RPM_RESUMING) and a 2-bit request type field
> > (RPM_REQ_NONE, RPM_REQ_IDLE, RPM_REQ_SUSPEND, RPM_REQ_RESUME).
> 
> That's the same as my 0, ASYNC_IDLE, ASYNC_SUSPEND, ASYNC_RESUME.
> 
> > Additionally, we'll need an "idle notification is running" flag as we've aleady
> > agreed, but that's independent on the status and request type (except that, I
> > think, it should be forbidden to set the request type to RPM_REQ_IDLE if
> > this flag is set).
> 
> I don't see why; we can allow drivers to queue an idle notification
> from within their runtime_idle routine (even though it might seem
> pointless).  What we should forbid is calling pm_runtime_idle when the
> flag is set.

OK

> > That would pretty much suffice to represent all of the possibilities.
> > 
> > I'd also add a "disabled" flag indicating that run-time PM of the device is
> > disabled, an "error" flag indicating that one of the
> > ->runtime_[suspend/resume]() callbacks has failed to do its job and
> > and an int field to store the error code returned by the failing callback (in
> > case the failure happened in an asynchronous routine).
> 
> Sure -- those are all things in the current design which should remain.  
> As well as the wait_queue.

It occured to me in the meantime that if we added a 'request_pending' (or
'work_pending' or whatever similar) flag to the above, we could avoid using
cancel_work().  Namely, if 'request_pending' indicates that there's a work item
queued up, we could change 'request type' to NONE in case we didn't want the
work function to do anything.  Then, the work function would just unset
'request_pending' and quit if 'request type' is NONE.

I generally like the idea of changing 'request type' on the fly once we've
noticed that the currently pending request should be replaced by another one.
That would require us to introduce a big idle-suspend-resume function
choosing the callback to run based on 'request type', which would be quite
complicated.  But that function could also be used for the 'synchronous'
operations, so perhaps it's worth trying?

Such a function can take two arguments, dev and request, where the second
one determines the callback to run.  It can take the same values as 'request
type', where NONE means "you've been called from the workqueue, use 'request
type' from dev to check what to do", but your ASYNC_* names are not really
suitable here. :-)

> > That's fine, we'd also need to wait for running callbacks to finish too.  And
> > I'm still not convinced if we should preserve requests queued up before the
> > system sleep.  Or keep the suspend timer running for that matter.
> 
> This all does into the "to-be-determined" category.  :-)

Well, I'd like to choose something to start with.

> > Could you please remind me what timer_expiration is for?
> 
> It is the jiffies value for the next timer expiration, or 0 if the
> timer isn't pending.  Its purpose is to allow us to correctly
> reschedule suspend requests.
> 
> Suppose the timer expires at about the same time as a new
> pm_schedule_suspend call occurs.  If the timer routine hasn't queued
> the work item yet then there's nothing to cancel, so how do we prevent
> a suspend request from being added to the workqueue?  Answer: The timer
> routine checks timer_expiration.  If the value stored there is in the
> future, then the routine knows it was triggered early and it shouldn't
> submit the work item.
> 
> Also (a minor benefit), before calling del_timer we can check whether
> timer_expiration is nonzero.

OK, thanks.

> > So, at a high level, the pm_request_* and pm_schedule_* functions would work
> > like this (I'm omitting acquiring and releasing locks):
> > 
> > pm_request_idle()
> >   * return -EINVAL if 'disabled' is set or 'runtime_error' is set
> >   * return -EAGAIN if 'runtime status' is not RPM_ACTIVE or 'request type' is
> >     RPM_REQ_SUSPEND or 'usage_count' > 0 or 'child_count' > 0
> 
> We should allow the status to be RPM_RESUMING.

OK

> >   * return -EALREADY if 'request type' is RPM_REQ_IDLE
> 
> No, return 0.

OK

> >   * return -EINPROGRESS if 'idle notification in progress' is set
> 
> No, go ahead and schedule another idle notification.

OK

> >   * change 'request type' to RPM_REQ_IDLE and queue up a request to execute
> >     ->runtime_idle() or ->runtime_suspend() (which one will be executed depends
> >     on 'request type' at the time when the work function is run)
> 
> More simply, just queue the work item.
> 
> >   * return 0
> > 
> > pm_schedule_suspend()
> >   * return -EINVAL if 'disabled' is set or 'runtime_error' is set
> >   * return -EAGAIN if 'usage_count' > 0 or 'child_count' > 0
> >   * return -EALREADY if 'runtime status' is RPM_SUSPENDED
> >   * return -EINPROGRESS if 'runtime status' is RPM_SUSPENDING
> 
> The last two aren't right.  If the status is RPM_SUSPENDED or
> RPM_SUSPENDING, cancel any pending work and set the type to
> RPM_REQ_NONE before returning.  In other words, cancel a possible 
> pending resume request.

Wy do you think the possible pending resume request should be canceled?

I don't really agree here.  Resume request really means there's data to
process, so we shouldn't cancel pending resume requests IMO.

The driver should be given a chance to process data in ->runtime_resume()
even if it doesn't use the usage counter.  Otherwise, the usage counter would
always have to be used along with resume requests, so having
pm_request_resume() that doesn't increment the usage counter would really be
pointless.

> >   * if suspend timer is pending, deactivate it
> 
> This step isn't needed here, since you're going to restart the timer 
> anyway.

OK, restart the timer.

> >   * if 'request type' is not RPM_REQ_NONE, cancel the work
> 
> Set timer_expiration = jiffies + delay.

OK

> >   * set up a timer to execute pm_request_suspend()
> >   * return 0
> > 
> > pm_request_suspend()
> >   * return if 'disabled' is set or 'runtime_error' is set
> >   * return if 'usage_count' > 0 or 'child_count' > 0
> >   * return if 'runtime status' is RPM_SUSPENDING or RPM_SUSPENDED
> 
> First cancel a possible pending resume request.

I disagree.

> If the status is RPM_RESUMING or RPM_ACTIVE, cancel a possible pending 
> timer (and set time_expiration to 0).

We're the timer function, so either the timer is not pending, or we've been
executed too early.

> >   * if 'request type' is RPM_REQ_IDLE, change it to RPM_REQ_SUSPEND and return
> >   * change 'request type' to RPM_REQ_SUSPEND and queue up a request to
> >     execute ->runtime_suspend()
> > 
> > pm_request_resume()
> >   * return -EINVAL if 'disabled' is set or 'runtime_error' is set
> >   * return -EINPROGRESS if 'runtime status' is RPM_RESUMING
> 
> Or RPM_ACTIVE.

Maybe return 1 in that case?

> >   * return -EALREADY if 'request type' is RPM_REQ_RESUME
> 
> For these last two, first cancel a possible pending suspend request
> and a possible timer.

Possible timer only, I think.  if 'request type' is RESUME, there can't be
suspend request pending.

> Should we leave a pending idle request in place?  

Probably not.  It's likely going to result in a suspend request that we would
cancel.

> And return 1, not an error code.
> 
> >   * if suspend timer is pending, deactivate it
> 
> The timer can't be pending at this point.

That's if we deactivated it earlier.  OK

> >   * if 'request type' is not RPM_REQ_NONE, cancel the work
> 
> At this point, 'request type' can only be RPM_REQ_NONE or 
> RPM_REQ_RESUME.  In neither case do we want to cancel it.
> 
> >   * return 1 if 'runtime status' is RPM_ACTIVE
> 
> See above.
> 
> >   * change 'request type' to RPM_REQ_RESUME and queue up a request to
> >     execute ->runtime_resume()
> 
> Queue the request only if the state is RPM_SUSPENDED.
> 
> >   * return 0
> > 
> > Or did I miss anything?
> 
> I think this is pretty close.  It'll be necessary to go back and reread 
> the old email messages to make sure this really does everything we 
> eventually agreed on.  :-)

I think it's sufficient if we agree on the final version. :-)

> Similar outlines apply for pm_runtime_suspend, pm_runtime_resume, and
> pm_runtime_idle.  There is an extra requirement: When a suspend or
> resume is over, if 'request type' is set then schedule the work item.  
> Doing things this way allows the workqueue thread to avoid waiting
> around for the suspend or resume to finish.

I agree except that I would like suspends to just fail when the status is
RPM_RESUMING.  The reason is that a sloppily written driver could enter a
busy-loop of suspending-resuming the device, without the possibility to process
data, if there's full symmetry between suspend and resume.  So, I'd like to
break that symmetry and make resume operations privileged with respect to
suspend and idle notifications.  

> Also, when a resume is over we should schedule an idle notification 
> even if 'request type' is clear, provided the counters are 0.

Agreed.

Best,
Rafael
