Return-Path: <linux-kernel-owner+w=401wt.eu-S1755709AbZGAWT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbZGAWT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 18:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbZGAWTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 18:19:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33740 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520AbZGAWTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 18:19:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC] Run-time PM framework (was: Re: [patch update] PM: Introduce core framework for run-time PM of I/O devices (rev. 6))
Date: Thu, 2 Jul 2009 00:19:54 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
References: <Pine.LNX.4.44L0.0907011039100.3066-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0907011039100.3066-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907020019.55645.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 July 2009, Alan Stern wrote:
> On Wed, 1 Jul 2009, Rafael J. Wysocki wrote:
> 
> > On Tuesday 30 June 2009, Alan Stern wrote:
> > ... 
> > > That's enough to give you the general idea.  I think this design is 
> > > a lot cleaner than the current one.
> > 
> > Well, I'm not really happy with starting over, but if you think we should do
> > that, then let's do it.
> 
> It's not a complete restart.  Much of the existing interface and quite
> a bit of code would remain the same.
> 
> > I think we both agree that the callbacks, ->runtime_idle(), ->runtime_suspend()
> > and ->runtime_resume() make sense.  Now, the role of the framework, IMO, is to
> > provide a mechanism by which it is possible:
> > (1) to schedule a delayed execution of ->runtime_suspend(), possibly from
> >     interrupt context,
> > (2) to schedule execution of ->runtime_resume() or ->runtime_idle(), possibly
> >     from interrupt context,
> > (3) to execute ->runtime_suspend() or ->runtime_resume() directly in a
> >     synchronous way (I'm not sure about ->runtime_idle())
> 
> Yes, runtime_idle also, for drivers that require minimal overhead.
> 
> > _and_ to ensure that these callbacks will be executed when it makes sense.
> 
> Thus if the situation changes before the callback can be made, so that
> it no longer makes sense, the framework should cancel the callback.

Yes, but there's one thing to consider.  Suppose a remote wake-up causes a
resume request to be queued up and pm_runtime_resume() is called synchronously
exactly at the time the request's work function is started.  There are two
attempts to resume in progress, but only one of them can call
->runtime_resume(), so what's the other one supposed to do?  The asynchronous
one can just return error code, but the the caller of the synchronous
pm_runtime_resume() must know whether or not the resume was successful.
So, perhaps, if the synchronous resume happens to lose the race, it should
wait for the other one to complete, check the device's status and return 0 if
it's active?  That wouldn't cause the workqueue thread to wait.

> > There's no other point, because the core has no information to make choices,
> > it can only prevent wrong things from happening, if possible.
> 
> Exactly.
> 
> > I think you will agree that the users of the framework should be able to
> > prevent ->runtime_suspend() from being called and that's what the usage counter
> > is for.  Also, IMO it should be impossible to execute ->runtime_idle(), via the
> > framework, when the usage counter is nonzero.
> 
> Right, because then by definition the device is in use so it can't be 
> idle.
> 
> > BTW, I don't think resume_count is the best name; it used to be in the version
> > of my patch where it was automatically incremented when ->runtime_resume() was
> > about to called.  usage_count is probably better.
> 
> Fine.
> 
> > Next, I think that the framework should refuse to call ->runtime_suspend() and
> > ->runtime_idle() if the children of the device are not suspended and the
> > "ignore children" flag is unset.
> 
> Yes; this is part of the "makes sense" requirement.
> 
> >  The counter of unsuspended children is used
> > for that.  I think the rule should be that it is decremented for the parent
> > whenever ->runtime_suspend() is called for a child and it is incremented
> > for the parent whenever ->runtime_resume() is called for a child.
> 
> Of course.  (Minor change: decremented when runtime_suspend _succeeds_ 
> for a child.)
> 
> > Now, the question is what rules should apply to the ordering and possible
> > simultaneous execution of ->runtime_idle(), ->runtime_suspend() and
> > ->runtime_resume().  I think the following rules make sense:
> 
> Oh dear.  I wouldn't attempt to make a complete list of all possible 
> interactions.  It's too hard to know whether you have really covered 
> all the cases.
> 
> >   * It is forbidden to run ->runtime_suspend() twice in a row.
> > 
> >   * It is forbidden to run ->runtime_suspend() in parallel with another instance
> >     of ->runtime_suspend().
> > 
> >   * It is forbidden to run ->runtime_resume() twice in a row.
> > 
> >   * It is forbidden to run ->runtime_resume() in parallel with another instance
> >     of ->runtime_resume().
> > 
> >   * It is allowed to run ->runtime_suspend() after ->runtime_resume() or after
> >     ->runtime_idle(), but the latter case is preferred. 
> > 
> >   * It is allowed to run ->runtime_resume() after ->runtime_suspend().
> > 
> >   * It is forbidden to run ->runtime_resume() after ->runtime_idle().
> > 
> >   * It is forbidden to run ->runtime_suspend() and ->runtime_resume() in
> >     parallel with each other.
> > 
> >   * It is forbidden to run ->runtime_idle() twice in a row.
> > 
> >   * It is forbidden to run ->runtime_idle() in parallel with another instance
> >     of ->runtime_idle().
> > 
> >   * It is forbidden to run ->runtime_idle() after ->runtime_suspend().
> > 
> >   * It is allowed to run ->runtime_idle() after ->runtime_resume().
> > 
> >   * It is allowed to execute ->runtime_suspend() or ->runtime_resume() when
> >     ->runtime_idle() is running.  In particular, it is allowed to (indirectly)
> >     call ->runtime_suspend() from within ->runtime_idle().
> > 
> >   * It is forbidden to execute ->runtime_idle() when ->runtime_resume() or
> >     ->runtime_suspend() is running.
> 
> We can summarize these rules as follows:
> 
> 	Never allow more than one callback at a time, except that
> 	runtime_suspend may be invoked while runtime_idle is running.

Caution here.  If ->runtime_idle() runs ->runtime_suspend() and immediately
after that resume is requested by remote wake-up, ->runtime_resume() may also
be run while ->runtime_idle() is still running.

OTOH, we need to know when ->runtime_idle() has completed, because we have to
ensure it won't still be running after run-time PM has been disabled for the
device.

IMO, we need two flags, one indicating that either ->runtime_suspend(), or
->runtime_resume() is being executed (they are mutually exclusive) and the
the other one indicating that ->runtime_idle() is being executed.  For the
purpose of further discussion below I'll call them RPM_IDLE_RUNNING and
RPM_IN_TRANSITION.

With this notation, the above rule may be translated as:

    Don't run any of the callbacks if RPM_IN_TRANSITION is set.  Don't run
    ->runtime_idle() if RPM_IDLE_RUNNING is set.

Which implies that RPM_IDLE_RUNNING cannot be set when RPM_IN_TRANSITION is
set, but it is valid to set RPM_IN_TRANSITION when RPM_IDLE_RUNNING is set.

> 	Don't call runtime_resume while the device is active.
> 
> 	Don't call runtime_suspend or runtime_idle while the device
> 	is suspended.
> 
> 	Don't invoke any callbacks if the device state is unknown
> 	(RPM_ERROR).
> 
> Implicit is the notion that the device is suspended when 
> runtime_suspend returns successfully, it is active when runtime_resume 
> returns successfully, and it is unknown when either returns an error.

Yes.

There are two possible "final" states, so I'd use one flag to indicate the
current status.  Let's call it RPM_SUSPENDED for now (which means that the
device is suspended when it's set and active otherwise) and I think we can make
the rule that this flag is only changed after successful execution of
->runtime_suspend() or ->runtime_resume().

Whether the device is suspending or resuming follows from the values of
RPM_SUSPENDED and RPM_IN_TRANSITION.

> >   * If ->runtime_resume() is about to be called immediately after
> >     ->runtime_suspend(), the execution of ->runtime_suspend() should be
> >     prevented from happening, if possible, in which case the execution of
> >     ->runtime_resume() shouldn't happen.
> > 
> >   * If ->runtime_suspend() is about to be called immediately after
> >     ->runtime_resume(), the execution of ->runtime_resume() should be
> >     prevented from happening, if possible, in which case the execution of
> >     ->runtime_suspend() shouldn't happen.
> 
> These could be considered optional optimizations.  Or if you prefer, 
> they could be covered by a "New requests override previous requests" 
> rule.

I'm not sure if I agree with this rule yet.

> > [Are there any more rules related to these callbacks we should take into
> > account?]
> 
> 	Runtime PM callbacks are mutually exclusive with other driver
> 	core callbacks (probe, remove, dev_pm_ops, etc.).

OK
 
> 	If a callback occurs asynchronously then it will be invoked
> 	in process context.  If it occurs as part of a synchronous
> 	request then it is invoked in the caller's context.
> 
> Related to this is the requirement that pm_runtime_idle,
> pm_runtime_suspend, and pm_runtime_resume must always be called in
> process context whereas pm_runtime_idle_atomic,
> pm_runtime_suspend_atomic, and pm_runtime_resume_atomic may be called
> in any context.

OK

> > Next, if we agree about the rules above, the question is what helper functions
> > should be provided by the core allowing these rules to be followed
> > automatically and what error codes should be returned by them in case it
> > wasn't possible to proceed without breaking the rules.
> > 
> > IMO, it is reasonable to provide:
> > 
> >   * pm_schedule_suspend(dev, delay) - schedule the execution of
> >     ->runtime_suspend(dev) after delay.
> > 
> >   * pm_runtime_suspend(dev) - execute ->runtime_suspend(dev) right now.
> > 
> >   * pm_runtime_resume(dev) - execute ->runtime_resume(dev) right now.
> > 
> >   * pm_request_resume(dev) - put a request to execute ->runtime_resume(dev)
> >     into the run-time PM workqueue.
> > 
> >   * pm_runtime_get(dev) - increment the device's usage counter.
> > 
> >   * pm_runtime_put(dev) - decrement the device's usage counter.
> > 
> >   * pm_runtime_idle(dev) - execute ->runtime_idle(dev) right now if the usage
> >     counter is zero and all of the device's children are suspended (or the
> >     "ignore children" flag is set).
> > 
> >   * pm_request_idle(dev) - put a request to execute ->runtime_idle(dev)
> >     into the run-time PM workqueue.  The usage counter and children will be
> >     checked immediately before executing ->runtime_idle(dev).
> 
> Should the counters also be checked when the request is submitted?  
> And should the same go for pm_schedule_suspend?  These are nontrivial
> questions; good arguments can be made both ways.

That's the difficult part. :-)

First, I think a delayed suspend should be treated in a special way, because
it's not really a request to suspend.  Namely, as long as the timer hasn't
triggered yet, nothing happens and there's nothing against the rules above.
A request to suspend is queued up after the timer has triggered and the timer
function is where the rules come into play.  IOW, it consists of two
operations, setting up a timer and queuing up a request to suspend when the
timer triggers.  IMO the first of them can be done at any time, while the other
one may be affected by the rules.

It implies that we should really introduce a timer and a timer function that
will queue up suspend requests, instead of using struct delayed_work.

Second, I think it may be a good idea to use the usage counter to block further
requests while submitting a resume request.

Namely, suppose that pm_request_resume() increments usage_count and returns 0,
if the resume was not necessary and the caller can do the I/O by itself, or
error code, which means that it was necessary to queue up a resume request.
If 0 is returned, the caller is supposed to do the I/O and call
pm_runtime_put() when done.  Otherwise it just quits and ->runtime_resume() is
supposed to take care of the I/O, in which case the request's work function
should call pm_runtime_put() when done.  [If it was impossible to queue up a
request, error code is returned, but the usage counter is decremented by
pm_request_resume(), so that the caller need not handle that special case,
hopefully rare.]

This implies that it may be a good idea to check usage_count when submitting
idle notification and suspend requests (where in case of suspend a request is
submitted by the timer function, when the timer has already triggered, so
there's no need to check the counter while setting up the timer).

The counter of unsuspended children may change after a request has been
submitted and before its work function has a chance to run, so I don't see much
point checking it when submitting requests.

So, if the above idea is adopted, idle notification and suspend requests
won't be queued up when a resume request is pending (there's the question what
the timer function attempting to queue up a suspend request is supposed to do
in such a case) and in the other cases we can use the following rules:

    Any pending request takes precedence over a new idle notification request.

    If a new request is not an idle notification request, it takes precedence
    over the pending one, so it cancels it with the help of cancel_work().

[In the latter case, if a suspend request is canceled, we may want to set up the
timer for another one.]  For that, we're going to need a single flag, say
RPM_PENDING, which is set whenever a request is queued up.

> > I'm not sure if it is really necessary to combine pm_runtime_idle() or
> > pm_request_idle() with pm_runtime_put().  At least right now I don't see any
> > real value of that.
> 
> Likewise combining pm_runtime_get with pm_runtime_resume.  The only
> value is to make things easier for drivers, because these will be very
> common idioms.
> 
> > I also am not sure what error codes should be returned by the above helper
> > functions and in what conditions.
> 
> The error codes you have been using seem okay to me, in general.
> 
> However, some of those requests would violate the rules in a trivial 
> way.  For these we might return a positive value rather than a negative 
> error code.  For example, calling pm_runtime_resume while the device is 
> already active shouldn't be considered an error.  But it can't be 
> considered a complete success either, because it won't invoke the 
> runtime_resume method.

That need not matter from the caller's point of view, though.  In the case of
pm_runtime_resume() the caller will probably be mostly interested whether or
not it can do I/O after the function has returned.

> To be determined: How runtime PM will interact with system sleep.

Yes.  My first idea was to disable run-time PM before entering a system sleep
state, but that would involve canceling all of the pending requests.

> About all I can add is the "New requests override previous requests"  
> policy.  This would apply to all the non-synchronous requests, whether
> they are delayed or added directly to the workqueue.  If a new request
> (synchronous or not) is received before the old one has started to run,
> the old one will be cancelled.  This holds even if the new request is
> redundant, like a resume request received while the device is active.
> 
> There is one exception to this rule: An idle_notify request does not 
> cancel a delayed or queued suspend request.

I'm not sure if such a rigid rule will be really useful.

Also, as I said above, I think we shouldn't regard setting up the suspend
timer as queuing up a request, but as a totally separate operation.

Best,
Rafael
