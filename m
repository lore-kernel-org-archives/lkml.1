Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbZGBXFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbZGBXFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 19:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbZGBXF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 19:05:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39863 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbZGBXF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 19:05:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC] Run-time PM framework (was: Re: [patch update] PM: Introduce core framework for run-time PM of I/O devices (rev. 6))
Date: Fri, 3 Jul 2009 01:05:23 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
References: <Pine.LNX.4.44L0.0907021414480.4279-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0907021414480.4279-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907030105.23887.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 July 2009, Alan Stern wrote:
> On Thu, 2 Jul 2009, Rafael J. Wysocki wrote:
> 
> > > The RPM_IN_TRANSITION flag is unnecessary.  It would always be equal to
> > > (status == RPM_SUSPENDING || status == RPM_RESUMING).
> > 
> > I thought of replacing the old flags with RPM_IN_TRANSITION, actually.
> 
> Okay, but hopefully you won't mind if I continue to use the old state 
> names in conversation.

Sure.

> > Still, the additional flag for 'idle notification is in progress' is still
> > necessary for the following two reasons:
> > 
> > (1) Idle notifications cannot be run (synchronously) when one is already in
> >     progress, so we need a means to determine whether or not this is the case.
> > 
> > (2) If run-time PM is to be disabled, the function doing that must guarantee
> >     that ->runtime_idle() won't be running after it's returned, so it needs to
> >     know how to check that.
> 
> Agreed.
> 
> 
> > > I don't agree.  For example, suppose the device has an active child
> > > when the driver says: Suspend it in 30 seconds.  If the child is then
> > > removed after only 10 seconds, does it make sense to go ahead with
> > > suspending the parent 20 seconds later?  No -- if the parent is going
> > > to be suspended, the decision as to when should be made at the time the
> > > child is removed, not beforehand.
> > 
> > There are two functions, on that sets up the timer and the other that queues
> > up the request.  This is the second one that makes the decision if the request
> > is still worth queuing up.
> > 
> > > (Even more concretely, suppose there is a 30-second inactivity timeout
> > > for autosuspend.  Removing the child counts as activity and so should
> > > restart the timer.)
> > > 
> > > To put it another way, suppose you accept a delayed request under
> > > inappropriate conditions.  If the conditions don't change, the whole
> > > thing was a waste of effort.  And if the conditions do change, then the
> > > whole delayed request should be reconsidered anyhow.
> > 
> > The problem is, even if you always accept a delayed request under appropriate
> > conditions, you still have to reconsider it before putting it into the work
> > queue, because the conditions might have changed.  So, you'd like to do this:
> > 
> > (1) Check if the conditions are appropriate, set up a timer.
> > (2) Check if the conditions are appropriate, queue up a suspend request.
> > 
> > while I think it will be simpler to do this:
> > 
> > (1) Set up a timer.
> > (2) Check if the conditions are appropriate, queue up a suspend request.
> > 
> > In any case you can have a pm_runtime_suspend() / pm_runtime_resume() cycle
> > between (1) and (2), so I don't really see a practical difference.
> 
> A cycle like that would cancel the timer anyway.  Maybe that's what you 
> meant...

Yes.

> Hmm.  What sort of conditions are we talking about?  One possiblity is 
> that we are in the wrong state, i.e., in SUSPENDING or SUSPENDED.  It's 
> completely useless to start a timer then; if the state changes the 
> timer will be cancelled, and if it doesn't change then the request 
> won't be queued when the timer expires.

OK

> The other possiblity is that either the children or usage counter is 
> positive.  If the counter decrements to 0 so that a suspend is feasible 
> then we would send an idle notification.  At that point the driver 
> could decide what to do; the most likely response would be to 
> reschedule the suspend.  In fact, it's hard to think of a situation 
> where the driver would want to just let the timer keep on running.

OK

> > For example, suppose ->runtime_resume() has been called as
> > a result of a remote wake-up (ie. after pm_request_resume()) and it has some
> > I/O to process, but it is known beforehand that the device will most likely be
> > inactive after the I/O is done.  So, it's tempting to call
> > pm_schedule_suspend() from within ->runtime_resume(), but the conditions are
> > inappropriate (the device is not regarded as suspended).
> 
> ??  Conditions are perfectly appropriate, since suspend requests are 
> allowed in the RESUMING state.

OK

> Unless the driver also did a pm_runtime_get, of course.  But in that 
> case it would have to do a pm_runtime_put eventually, at which point it 
> could schedule the suspend.
> 
> >  However, calling
> > pm_schedule_suspend() with a long enough delay doesn't break any rules related
> > to the ->runtime_*() callbacks, so why should it be forbidden?
> 
> It isn't.
> 
> > Next, suppose pm_schedule_suspend() is called, but it fails because the
> > conditions are inappropriate.  What's the caller supposed to do?  Wait for the
> > conditions to change and repeat?
> 
> In a manner of speaking.  More precisely, whatever code is responsible 
> for changing the conditions should call pm_schedule_suspend.  Or set up 
> an idle notification, leading indirectly to pm_schedule_suspend.
> 
> >  But why should it bother if the conditions
> > may still change before ->runtime_suspend() is actually called?
> 
> It should bother because conditions might _not_ change, in which case
> the suspend would occur.  But for what you are proposing, if the
> conditions don't change then the suspend will not occur.
> 
> > IMO, it's the caller's problem whether or not what it does is useful or
> > efficient.  The core's problem is to ensure that it doesn't break things.
> 
> But what's the drawback?  The extra overhead of checking whether two
> counters are positive is minuscule compared to the effort of setting up
> a timer.  And it's even better when you consider that the mostly likely
> outcome of letting the timer run is that the timer handler would fail
> to queue a suspend request (because the counters are unchanged).
> 
> 
> > > Trying to keep track of reasons for incrementing and decrementing 
> > > usage_count is very difficult to do in the core.  What happens if 
> > > pm_request_resume increments the count but then the driver calls 
> > > pm_runtime_get, pm_runtime_resume, pm_runtime_put all before the work 
> > > routine can run?
> > 
> > Nothing wrong, as long as the increments and decrements are balanced (if they
> > aren't balanced, there is a bug in the driver anyway).
> 
> That's my point -- in this situation it's very difficult for the driver
> to balance them.  There would be no decrement to balance
> pm_request_resume's automatic increment, because the work routine would
> never run.
> 
> >  In fact, for this to
> > work we need the rule that a new request of the same type doesn't replace an
> > existing one.  Then, the submitted resume request cannot be canceled, so the
> > work function will run and drop the usage counter.
> 
> A new pm_schedule_suspend _should_ replace an existing one.  For 
> idle_notify and resume requests, this rule is more or less a no-op.
> 
> > > It's better to make the driver responsible for maintaining the counter
> > > value.  Forcing the driver to do pm_runtime_get, pm_request_resume is
> > > better than having the core automatically change the counter.
> > 
> > So the caller will do:
> > 
> > pm_runtime_get(dev);
> > error = pm_request_resume(dev);
> > if (error)
> >     goto out;
> > <process I/O>
> > pm_runtime_put();
> 
> ["error" isn't a good name.  The return value would be 0 to indicate 
> the request was accepted and queued, or 1 to indicate the device is 
> already active.  Or perhaps vice versa.]

Why do you insist on using positive values?  Also, there are other situations
possible (like run-time PM is disabled etc.).

> > but how is it supposed to ensure that pm_runtime_put() will be called after
> > executing the 'goto out' thing?
> 
> The same way it knows that the runtime_resume method has to process the
> pending I/O.  That is, the presence of I/O to process means that once
> the processing is over, the driver should call pm_runtime_put.

I overlooked the fact that if pm_request_resume() returns a value indicating
that the request has been queued up, the status is such that it won't allow any
other requests to be queued up and only pm_runtime_resume() can.  The status
will still remain this way until ->runtime_resume() has returned, so the caller
can just call pm_runtime_put() right after pm_request_resume() in that case
(unless it wants to process I/O after ->runtime_resume() has returned, but
then it can increment the usage counter in ->runtime_resume()).

> > Anyway, we don't need to use the usage counter for that (although it's cheap).
> > Instead, we can make pm_request_suspend() and pm_request_idle() check if a
> > resume request is pending and fail if that's the case.
> 
> But what about pm_runtime_suspend?  I think we need to use the counter.
> Besides, the states in which suspend requests and idle requests are 
> valid are disjoint from the states in which resume requests are valid.

That's correct.  pm_runtime_suspend() should check the counter IMO, but it
shouldn't change it.

Also, it looks like the status bits are sufficient to prevent suspend requests
or synchronous suspends from happening at wrong times, from the core's point
of view, so scratch the idea of using the usage counter to block them.

> > Let's put it another way.  What's the practical benefit to the caller if we
> > always check the counters in submissions?
> 
> It saves the overhead of setting up and running a useless timer.  It 
> avoids a race between the timer routine and pm_runtime_put.

OK

> > > >     Any pending request takes precedence over a new idle notification request.
> > > 
> > > For pending resume requests this rule is unnecessary; it's invalid to
> > > submit an idle notification request while a resume request is pending
> > > (since resume requests can be pending only in the RPM_SUSPENDING and
> > > RPM_SUSPENDED states while idle notification requests are accepted only
> > > in RPM_RESUMING and RPM_ACTIVE).
> > 
> > It is correct nevertheless. :-)
> 
> Okay, if you want.  Provided you agree that "pending request" doesn't 
> include unexpired suspend timers.

Sure.

> > Well, after some reconsideration I think it's not enough (as I wrote in my last
> > message), becuase it generally makes sense to make the following rule:
> > 
> >     A pending request always takes precedence over a new request of the same
> >     type.
> > 
> > So, for example, if pm_request_resume() is called and there's a resume request
> > pending already, the new pm_request_resume() should just let the pending
> > request alone and quit.
> 
> Do you mean we shouldn't cancel the work item and then requeue it?  I
> agree.  In fact I'd go even farther: If the timer routine find an idle
> request pending, it shouldn't cancel it -- instead it should simply
> change async_action to ASYNC_SUSPEND.  That's a simple optimization.  
> Regardless, the effect isn't visible to drivers.

I don't really like the async_action idea, as you might have noticed.

> > Thus, it seems reasonable to remember what type of a request is pending
> > (i don't think we can figure it out from the status fields in 100% of the
> > cases).
> 
> That's what the async_action field in my proposal is for.

Ah.  Why don't we just use a request type field instead?

In fact, we can use a 2-bit status field (RPM_ACTIVE, RPM_SUSPENDING,
RPM_SUSPENDED, RPM_RESUMING) and a 2-bit request type field
(RPM_REQ_NONE, RPM_REQ_IDLE, RPM_REQ_SUSPEND, RPM_REQ_RESUME).

Additionally, we'll need an "idle notification is running" flag as we've aleady
agreed, but that's independent on the status and request type (except that, I
think, it should be forbidden to set the request type to RPM_REQ_IDLE if
this flag is set).

That would pretty much suffice to represent all of the possibilities.

I'd also add a "disabled" flag indicating that run-time PM of the device is
disabled, an "error" flag indicating that one of the
->runtime_[suspend/resume]() callbacks has failed to do its job and
and an int field to store the error code returned by the failing callback (in
case the failure happened in an asynchronous routine).

> > > Yes.  But the driver might depend on something happening inside the
> > > runtime_resume method, so it would need to know if a successful
> > > pm_runtime_resume wasn't going to invoke the callback.
> > 
> > Hmm.  That would require the driver to know that the device was suspended,
> > but in that case pm_runtime_resume() returning 0 would mean that _someone_
> > ran ->runtime_resume() for it in any case.
> > 
> > If the driver doesn't know if the device was suspended beforehand, it cannot
> > depend on the execution of ->runtime_resume().
> 
> Exactly.  Therefore it needs to be told if pm_runtime_resume isn't 
> going to call the runtime_resume method, so that it can take 
> appropriate remedial action.

OK, it can return 1 if the status was already RPM_ACTIVE.

> > > > > To be determined: How runtime PM will interact with system sleep.
> > > > 
> > > > Yes.  My first idea was to disable run-time PM before entering a system sleep
> > > > state, but that would involve canceling all of the pending requests.
> > > 
> > > Or simply freezing the workqueue.
> > 
> > Well, what about the synchronous calls?  How are we going to prevent them
> > from happening after freezing the workqueue?
> 
> How about your "rpm_disabled" flag?

That's fine, we'd also need to wait for running callbacks to finish too.  And
I'm still not convinced if we should preserve requests queued up before the
system sleep.  Or keep the suspend timer running for that matter.

> > Now there's a point in which allowing to set up the suspend timer at any time
> > simplifies things quite a bit.  Namely, in that case, if pm_schedule_suspend()
> > is called and it sees a timer pending, it deactivates the timer with
> > del_timer() and sets up a new one with add_timer().  It doesn't need to worry
> > about whether the suspend request has been queued up already or
> > pm_runtime_suspend() is running or something.  Things will work themselves out
> > anyway eventually.
> > 
> > Otherwise, after calling del_timer() we'll need to check if the timer was pending
> > and if it wasn't, then if the suspend requests has been queued up already, and
> > if it has, then if pm_runtime_suspend() is running (the current status is
> > RPM_SUSPENDING) etc.  That doesn't look particularly clean.
> 
> It's not as bad as you think.  In pseudo code:
> 
> 	ret = suspend_allowed(dev);
> 	if (ret)
> 		return ret;
> 	if (dev->power.timer_expiration) {
> 		del_timer(&dev->power.timer);
> 		dev->power.timer_expiration = 0;
> 	}
> 	if (dev->power.work_pending) {
> 		cancel_work(&dev->power.work);
> 		dev->power.work_pending = 0;
> 		dev->power.async_action = 0;
> 	}
> 	dev->power.timer_expiration = max(jiffies + delay, 1UL);
> 	mod_timer(&dev->power.timer, delay);
> 
> The middle section could usefully be put in a subroutine.

Could you please remind me what timer_expiration is for?

So, at a high level, the pm_request_* and pm_schedule_* functions would work
like this (I'm omitting acquiring and releasing locks):

pm_request_idle()
  * return -EINVAL if 'disabled' is set or 'runtime_error' is set
  * return -EAGAIN if 'runtime status' is not RPM_ACTIVE or 'request type' is
    RPM_REQ_SUSPEND or 'usage_count' > 0 or 'child_count' > 0
  * return -EALREADY if 'request type' is RPM_REQ_IDLE
  * return -EINPROGRESS if 'idle notification in progress' is set
  * change 'request type' to RPM_REQ_IDLE and queue up a request to execute
    ->runtime_idle() or ->runtime_suspend() (which one will be executed depends
    on 'request type' at the time when the work function is run)
  * return 0

pm_schedule_suspend()
  * return -EINVAL if 'disabled' is set or 'runtime_error' is set
  * return -EAGAIN if 'usage_count' > 0 or 'child_count' > 0
  * return -EALREADY if 'runtime status' is RPM_SUSPENDED
  * return -EINPROGRESS if 'runtime status' is RPM_SUSPENDING
  * if suspend timer is pending, deactivate it
  * if 'request type' is not RPM_REQ_NONE, cancel the work
  * set up a timer to execute pm_request_suspend()
  * return 0

pm_request_suspend()
  * return if 'disabled' is set or 'runtime_error' is set
  * return if 'usage_count' > 0 or 'child_count' > 0
  * return if 'runtime status' is RPM_SUSPENDING or RPM_SUSPENDED
  * if 'request type' is RPM_REQ_IDLE, change it to RPM_REQ_SUSPEND and return
  * change 'request type' to RPM_REQ_SUSPEND and queue up a request to
    execute ->runtime_suspend()

pm_request_resume()
  * return -EINVAL if 'disabled' is set or 'runtime_error' is set
  * return -EINPROGRESS if 'runtime status' is RPM_RESUMING
  * return -EALREADY if 'request type' is RPM_REQ_RESUME
  * if suspend timer is pending, deactivate it
  * if 'request type' is not RPM_REQ_NONE, cancel the work
  * return 1 if 'runtime status' is RPM_ACTIVE
  * change 'request type' to RPM_REQ_RESUME and queue up a request to
    execute ->runtime_resume()
  * return 0

Or did I miss anything?

Rafael
