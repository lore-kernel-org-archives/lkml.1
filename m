Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbZGBRul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbZGBRul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 13:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbZGBRub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 13:50:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38774 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbZGBRua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 13:50:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC] Run-time PM framework (was: Re: [patch update] PM: Introduce core framework for run-time PM of I/O devices (rev. 6))
Date: Thu, 2 Jul 2009 19:50:28 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
References: <Pine.LNX.4.44L0.0907021048530.3291-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0907021048530.3291-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907021950.29227.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 July 2009, Alan Stern wrote:
> On Thu, 2 Jul 2009, Rafael J. Wysocki wrote:
> 
> > > > _and_ to ensure that these callbacks will be executed when it makes sense.
> > > 
> > > Thus if the situation changes before the callback can be made, so that
> > > it no longer makes sense, the framework should cancel the callback.
> > 
> > Yes, but there's one thing to consider.  Suppose a remote wake-up causes a
> > resume request to be queued up and pm_runtime_resume() is called synchronously
> > exactly at the time the request's work function is started.  There are two
> > attempts to resume in progress, but only one of them can call
> > ->runtime_resume(), so what's the other one supposed to do?  The asynchronous
> > one can just return error code, but the the caller of the synchronous
> > pm_runtime_resume() must know whether or not the resume was successful.
> > So, perhaps, if the synchronous resume happens to lose the race, it should
> > wait for the other one to complete, check the device's status and return 0 if
> > it's active?  That wouldn't cause the workqueue thread to wait.
> 
> I didn't address this explicitly in the previous message, but yes.  
> This is no different from the way your current version works.
> 
> Similarly, if a synchronous resume call occurs while a suspend is in 
> progress, it should wait until the suspend finishes and then carry out 
> a resume.

Agreed.

> > > We can summarize these rules as follows:
> > > 
> > > 	Never allow more than one callback at a time, except that
> > > 	runtime_suspend may be invoked while runtime_idle is running.
> > 
> > Caution here.  If ->runtime_idle() runs ->runtime_suspend() and immediately
> > after that resume is requested by remote wake-up, ->runtime_resume() may also
> > be run while ->runtime_idle() is still running.
> 
> Yes, I didn't think of that case.  We have to allow either of the other 
> two to be invoked while runtime_idle is running.  But we can rule out 
> calling runtime_idle recursively.
> 
> > OTOH, we need to know when ->runtime_idle() has completed, because we have to
> > ensure it won't still be running after run-time PM has been disabled for the
> > device.
> > 
> > IMO, we need two flags, one indicating that either ->runtime_suspend(), or
> > ->runtime_resume() is being executed (they are mutually exclusive) and the
> > the other one indicating that ->runtime_idle() is being executed.  For the
> > purpose of further discussion below I'll call them RPM_IDLE_RUNNING and
> > RPM_IN_TRANSITION.
> 
> The RPM_IN_TRANSITION flag is unnecessary.  It would always be equal to
> (status == RPM_SUSPENDING || status == RPM_RESUMING).

I thought of replacing the old flags with RPM_IN_TRANSITION, actually.

> > With this notation, the above rule may be translated as:
> > 
> >     Don't run any of the callbacks if RPM_IN_TRANSITION is set.  Don't run
> >     ->runtime_idle() if RPM_IDLE_RUNNING is set.
> > 
> > Which implies that RPM_IDLE_RUNNING cannot be set when RPM_IN_TRANSITION is
> > set, but it is valid to set RPM_IN_TRANSITION when RPM_IDLE_RUNNING is set.
> 
> That is equivalent to my conclusion above.
> 
> > There are two possible "final" states, so I'd use one flag to indicate the
> > current status.  Let's call it RPM_SUSPENDED for now (which means that the
> > device is suspended when it's set and active otherwise) and I think we can make
> > the rule that this flag is only changed after successful execution of
> > ->runtime_suspend() or ->runtime_resume().
> > 
> > Whether the device is suspending or resuming follows from the values of
> > RPM_SUSPENDED and RPM_IN_TRANSITION.
> 
> You can use two single-bit flags (SUSPEND and IN_TRANSITION) or a 
> single two-bit state value (ACTIVE, SUSPENDING, SUSPENDED, RESUMING).  
> It doesn't make much difference which you choose.

No, it doesn't.

Still, the additional flag for 'idle notification is in progress' is still
necessary for the following two reasons:

(1) Idle notifications cannot be run (synchronously) when one is already in
    progress, so we need a means to determine whether or not this is the case.

(2) If run-time PM is to be disabled, the function doing that must guarantee
    that ->runtime_idle() won't be running after it's returned, so it needs to
    know how to check that.

> > > Should the counters also be checked when the request is submitted?  
> > > And should the same go for pm_schedule_suspend?  These are nontrivial
> > > questions; good arguments can be made both ways.
> > 
> > That's the difficult part. :-)
> > 
> > First, I think a delayed suspend should be treated in a special way, because
> > it's not really a request to suspend.  Namely, as long as the timer hasn't
> > triggered yet, nothing happens and there's nothing against the rules above.
> > A request to suspend is queued up after the timer has triggered and the timer
> > function is where the rules come into play.  IOW, it consists of two
> > operations, setting up a timer and queuing up a request to suspend when the
> > timer triggers.  IMO the first of them can be done at any time, while the other
> > one may be affected by the rules.
> 
> I don't agree.  For example, suppose the device has an active child
> when the driver says: Suspend it in 30 seconds.  If the child is then
> removed after only 10 seconds, does it make sense to go ahead with
> suspending the parent 20 seconds later?  No -- if the parent is going
> to be suspended, the decision as to when should be made at the time the
> child is removed, not beforehand.

There are two functions, on that sets up the timer and the other that queues
up the request.  This is the second one that makes the decision if the request
is still worth queuing up.

> (Even more concretely, suppose there is a 30-second inactivity timeout
> for autosuspend.  Removing the child counts as activity and so should
> restart the timer.)
> 
> To put it another way, suppose you accept a delayed request under
> inappropriate conditions.  If the conditions don't change, the whole
> thing was a waste of effort.  And if the conditions do change, then the
> whole delayed request should be reconsidered anyhow.

The problem is, even if you always accept a delayed request under appropriate
conditions, you still have to reconsider it before putting it into the work
queue, because the conditions might have changed.  So, you'd like to do this:

(1) Check if the conditions are appropriate, set up a timer.
(2) Check if the conditions are appropriate, queue up a suspend request.

while I think it will be simpler to do this:

(1) Set up a timer.
(2) Check if the conditions are appropriate, queue up a suspend request.

In any case you can have a pm_runtime_suspend() / pm_runtime_resume() cycle
between (1) and (2), so I don't really see a practical difference.

> So why accept it?

Beacuse that simplifies things?

For example, suppose ->runtime_resume() has been called as
a result of a remote wake-up (ie. after pm_request_resume()) and it has some
I/O to process, but it is known beforehand that the device will most likely be
inactive after the I/O is done.  So, it's tempting to call
pm_schedule_suspend() from within ->runtime_resume(), but the conditions are
inappropriate (the device is not regarded as suspended).  However, calling
pm_schedule_suspend() with a long enough delay doesn't break any rules related
to the ->runtime_*() callbacks, so why should it be forbidden?

Next, suppose pm_schedule_suspend() is called, but it fails because the
conditions are inappropriate.  What's the caller supposed to do?  Wait for the
conditions to change and repeat?  But why should it bother if the conditions
may still change before ->runtime_suspend() is actually called?

IMO, it's the caller's problem whether or not what it does is useful or
efficient.  The core's problem is to ensure that it doesn't break things.

> > It implies that we should really introduce a timer and a timer function that
> > will queue up suspend requests, instead of using struct delayed_work.
> 
> Yes, this was part of my proposal.
> 
> > Second, I think it may be a good idea to use the usage counter to block further
> > requests while submitting a resume request.
> > 
> > Namely, suppose that pm_request_resume() increments usage_count and returns 0,
> > if the resume was not necessary and the caller can do the I/O by itself, or
> > error code, which means that it was necessary to queue up a resume request.
> > If 0 is returned, the caller is supposed to do the I/O and call
> > pm_runtime_put() when done.  Otherwise it just quits and ->runtime_resume() is
> > supposed to take care of the I/O, in which case the request's work function
> > should call pm_runtime_put() when done.  [If it was impossible to queue up a
> > request, error code is returned, but the usage counter is decremented by
> > pm_request_resume(), so that the caller need not handle that special case,
> > hopefully rare.]
> 
> Trying to keep track of reasons for incrementing and decrementing 
> usage_count is very difficult to do in the core.  What happens if 
> pm_request_resume increments the count but then the driver calls 
> pm_runtime_get, pm_runtime_resume, pm_runtime_put all before the work 
> routine can run?

Nothing wrong, as long as the increments and decrements are balanced (if they
aren't balanced, there is a bug in the driver anyway).  In fact, for this to
work we need the rule that a new request of the same type doesn't replace an
existing one.  Then, the submitted resume request cannot be canceled, so the
work function will run and drop the usage counter.

> It's better to make the driver responsible for maintaining the counter
> value.  Forcing the driver to do pm_runtime_get, pm_request_resume is
> better than having the core automatically change the counter.

So the caller will do:

pm_runtime_get(dev);
error = pm_request_resume(dev);
if (error)
    goto out;
<process I/O>
pm_runtime_put();

but how is it supposed to ensure that pm_runtime_put() will be called after
executing the 'goto out' thing?

Anyway, we don't need to use the usage counter for that (although it's cheap).
Instead, we can make pm_request_suspend() and pm_request_idle() check if a
resume request is pending and fail if that's the case.

> > This implies that it may be a good idea to check usage_count when submitting
> > idle notification and suspend requests (where in case of suspend a request is
> > submitted by the timer function, when the timer has already triggered, so
> > there's no need to check the counter while setting up the timer).
> > 
> > The counter of unsuspended children may change after a request has been
> > submitted and before its work function has a chance to run, so I don't see much
> > point checking it when submitting requests.
> 
> As I said above, if the counters don't change then the submission was 
> unnecessary, and if they do change then the submission should be 
> reconsidered.  Therefore they _should_ be checked in submissions.

Let's put it another way.  What's the practical benefit to the caller if we
always check the counters in submissions?

> > So, if the above idea is adopted, idle notification and suspend requests
> > won't be queued up when a resume request is pending (there's the question what
> > the timer function attempting to queue up a suspend request is supposed to do
> > in such a case) and in the other cases we can use the following rules:
> > 
> >     Any pending request takes precedence over a new idle notification request.
> 
> For pending resume requests this rule is unnecessary; it's invalid to
> submit an idle notification request while a resume request is pending
> (since resume requests can be pending only in the RPM_SUSPENDING and
> RPM_SUSPENDED states while idle notification requests are accepted only
> in RPM_RESUMING and RPM_ACTIVE).

It is correct nevertheless. :-)

> For pending suspends, I think we should allow synchronous idle
> notifications while the suspend is pending.

Sure, I was talking only about requests here, where by 'request' I understood
a work item put into the workqueue.

> The runtime_idle callback might then start its own suspend before the
> workqueue can get around to it.  You're right about async idle requests
> though; that was the exception I noted below.
> 
> >     If a new request is not an idle notification request, it takes precedence
> >     over the pending one, so it cancels it with the help of cancel_work().
> > 
> > [In the latter case, if a suspend request is canceled, we may want to set up the
> > timer for another one.]  For that, we're going to need a single flag, say
> > RPM_PENDING, which is set whenever a request is queued up.
> 
> That's what I called work_pending in my proposal.

Well, after some reconsideration I think it's not enough (as I wrote in my last
message), becuase it generally makes sense to make the following rule:

    A pending request always takes precedence over a new request of the same
    type.

So, for example, if pm_request_resume() is called and there's a resume request
pending already, the new pm_request_resume() should just let the pending
request alone and quit.

Thus, it seems reasonable to remember what type of a request is pending
(i don't think we can figure it out from the status fields in 100% of the
cases).

> > > The error codes you have been using seem okay to me, in general.
> > > 
> > > However, some of those requests would violate the rules in a trivial 
> > > way.  For these we might return a positive value rather than a negative 
> > > error code.  For example, calling pm_runtime_resume while the device is 
> > > already active shouldn't be considered an error.  But it can't be 
> > > considered a complete success either, because it won't invoke the 
> > > runtime_resume method.
> > 
> > That need not matter from the caller's point of view, though.  In the case of
> > pm_runtime_resume() the caller will probably be mostly interested whether or
> > not it can do I/O after the function has returned.
> 
> Yes.  But the driver might depend on something happening inside the
> runtime_resume method, so it would need to know if a successful
> pm_runtime_resume wasn't going to invoke the callback.

Hmm.  That would require the driver to know that the device was suspended,
but in that case pm_runtime_resume() returning 0 would mean that _someone_
ran ->runtime_resume() for it in any case.

If the driver doesn't know if the device was suspended beforehand, it cannot
depend on the execution of ->runtime_resume().

> > > To be determined: How runtime PM will interact with system sleep.
> > 
> > Yes.  My first idea was to disable run-time PM before entering a system sleep
> > state, but that would involve canceling all of the pending requests.
> 
> Or simply freezing the workqueue.

Well, what about the synchronous calls?  How are we going to prevent them
from happening after freezing the workqueue?

> > > About all I can add is the "New requests override previous requests"  
> > > policy.  This would apply to all the non-synchronous requests, whether
> > > they are delayed or added directly to the workqueue.  If a new request
> > > (synchronous or not) is received before the old one has started to run,
> > > the old one will be cancelled.  This holds even if the new request is
> > > redundant, like a resume request received while the device is active.
> > > 
> > > There is one exception to this rule: An idle_notify request does not 
> > > cancel a delayed or queued suspend request.
> > 
> > I'm not sure if such a rigid rule will be really useful.
> 
> A rigid rule is easier to understand and apply than one with a large
> number of special cases.  However, in the statement of the rule above,
> I forgot to mention that this applies only if the new request is valid,
> i.e., if it's not forbidden by the current status or the counter
> values.

Ah, OK.  I'd also like to add the rule about requests of the same type
(if there's one pending already, the new one is discareded).

> > Also, as I said above, I think we shouldn't regard setting up the suspend
> > timer as queuing up a request, but as a totally separate operation.
> 
> Well, there can't be any pending resume requests when the suspend timer
> is set up, so we have to consider only pending idle notifications or
> pending suspends.  I agree, we would want to allow an idle notification
> to remain pending when the suspend timer is set up.  As for pending
> suspends, we _should_ allow the new request to override the old one.  
> This will come up whenever the timeout value is changed.

Now there's a point in which allowing to set up the suspend timer at any time
simplifies things quite a bit.  Namely, in that case, if pm_schedule_suspend()
is called and it sees a timer pending, it deactivates the timer with
del_timer() and sets up a new one with add_timer().  It doesn't need to worry
about whether the suspend request has been queued up already or
pm_runtime_suspend() is running or something.  Things will work themselves out
anyway eventually.

Otherwise, after calling del_timer() we'll need to check if the timer was pending
and if it wasn't, then if the suspend requests has been queued up already, and
if it has, then if pm_runtime_suspend() is running (the current status is
RPM_SUSPENDING) etc.  That doesn't look particularly clean.

Best,
Rafael
