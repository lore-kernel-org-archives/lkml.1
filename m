Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbZGBPzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbZGBPzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753210AbZGBPzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:55:22 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50620 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752095AbZGBPzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:55:21 -0400
Date: Thu, 2 Jul 2009 11:55:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC] Run-time PM framework (was: Re: [patch update] PM: Introduce
 core framework for run-time PM of I/O devices (rev. 6))
In-Reply-To: <200907020019.55645.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0907021048530.3291-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jul 2009, Rafael J. Wysocki wrote:

> > > _and_ to ensure that these callbacks will be executed when it makes sense.
> > 
> > Thus if the situation changes before the callback can be made, so that
> > it no longer makes sense, the framework should cancel the callback.
> 
> Yes, but there's one thing to consider.  Suppose a remote wake-up causes a
> resume request to be queued up and pm_runtime_resume() is called synchronously
> exactly at the time the request's work function is started.  There are two
> attempts to resume in progress, but only one of them can call
> ->runtime_resume(), so what's the other one supposed to do?  The asynchronous
> one can just return error code, but the the caller of the synchronous
> pm_runtime_resume() must know whether or not the resume was successful.
> So, perhaps, if the synchronous resume happens to lose the race, it should
> wait for the other one to complete, check the device's status and return 0 if
> it's active?  That wouldn't cause the workqueue thread to wait.

I didn't address this explicitly in the previous message, but yes.  
This is no different from the way your current version works.

Similarly, if a synchronous resume call occurs while a suspend is in 
progress, it should wait until the suspend finishes and then carry out 
a resume.

> > We can summarize these rules as follows:
> > 
> > 	Never allow more than one callback at a time, except that
> > 	runtime_suspend may be invoked while runtime_idle is running.
> 
> Caution here.  If ->runtime_idle() runs ->runtime_suspend() and immediately
> after that resume is requested by remote wake-up, ->runtime_resume() may also
> be run while ->runtime_idle() is still running.

Yes, I didn't think of that case.  We have to allow either of the other 
two to be invoked while runtime_idle is running.  But we can rule out 
calling runtime_idle recursively.

> OTOH, we need to know when ->runtime_idle() has completed, because we have to
> ensure it won't still be running after run-time PM has been disabled for the
> device.
> 
> IMO, we need two flags, one indicating that either ->runtime_suspend(), or
> ->runtime_resume() is being executed (they are mutually exclusive) and the
> the other one indicating that ->runtime_idle() is being executed.  For the
> purpose of further discussion below I'll call them RPM_IDLE_RUNNING and
> RPM_IN_TRANSITION.

The RPM_IN_TRANSITION flag is unnecessary.  It would always be equal to
(status == RPM_SUSPENDING || status == RPM_RESUMING).

> With this notation, the above rule may be translated as:
> 
>     Don't run any of the callbacks if RPM_IN_TRANSITION is set.  Don't run
>     ->runtime_idle() if RPM_IDLE_RUNNING is set.
> 
> Which implies that RPM_IDLE_RUNNING cannot be set when RPM_IN_TRANSITION is
> set, but it is valid to set RPM_IN_TRANSITION when RPM_IDLE_RUNNING is set.

That is equivalent to my conclusion above.

> There are two possible "final" states, so I'd use one flag to indicate the
> current status.  Let's call it RPM_SUSPENDED for now (which means that the
> device is suspended when it's set and active otherwise) and I think we can make
> the rule that this flag is only changed after successful execution of
> ->runtime_suspend() or ->runtime_resume().
> 
> Whether the device is suspending or resuming follows from the values of
> RPM_SUSPENDED and RPM_IN_TRANSITION.

You can use two single-bit flags (SUSPEND and IN_TRANSITION) or a 
single two-bit state value (ACTIVE, SUSPENDING, SUSPENDED, RESUMING).  
It doesn't make much difference which you choose.


> > Should the counters also be checked when the request is submitted?  
> > And should the same go for pm_schedule_suspend?  These are nontrivial
> > questions; good arguments can be made both ways.
> 
> That's the difficult part. :-)
> 
> First, I think a delayed suspend should be treated in a special way, because
> it's not really a request to suspend.  Namely, as long as the timer hasn't
> triggered yet, nothing happens and there's nothing against the rules above.
> A request to suspend is queued up after the timer has triggered and the timer
> function is where the rules come into play.  IOW, it consists of two
> operations, setting up a timer and queuing up a request to suspend when the
> timer triggers.  IMO the first of them can be done at any time, while the other
> one may be affected by the rules.

I don't agree.  For example, suppose the device has an active child
when the driver says: Suspend it in 30 seconds.  If the child is then
removed after only 10 seconds, does it make sense to go ahead with
suspending the parent 20 seconds later?  No -- if the parent is going
to be suspended, the decision as to when should be made at the time the
child is removed, not beforehand.

(Even more concretely, suppose there is a 30-second inactivity timeout
for autosuspend.  Removing the child counts as activity and so should
restart the timer.)

To put it another way, suppose you accept a delayed request under
inappropriate conditions.  If the conditions don't change, the whole
thing was a waste of effort.  And if the conditions do change, then the
whole delayed request should be reconsidered anyhow.  So why accept it?

> It implies that we should really introduce a timer and a timer function that
> will queue up suspend requests, instead of using struct delayed_work.

Yes, this was part of my proposal.

> Second, I think it may be a good idea to use the usage counter to block further
> requests while submitting a resume request.
> 
> Namely, suppose that pm_request_resume() increments usage_count and returns 0,
> if the resume was not necessary and the caller can do the I/O by itself, or
> error code, which means that it was necessary to queue up a resume request.
> If 0 is returned, the caller is supposed to do the I/O and call
> pm_runtime_put() when done.  Otherwise it just quits and ->runtime_resume() is
> supposed to take care of the I/O, in which case the request's work function
> should call pm_runtime_put() when done.  [If it was impossible to queue up a
> request, error code is returned, but the usage counter is decremented by
> pm_request_resume(), so that the caller need not handle that special case,
> hopefully rare.]

Trying to keep track of reasons for incrementing and decrementing 
usage_count is very difficult to do in the core.  What happens if 
pm_request_resume increments the count but then the driver calls 
pm_runtime_get, pm_runtime_resume, pm_runtime_put all before the work 
routine can run?

It's better to make the driver responsible for maintaining the counter
value.  Forcing the driver to do pm_runtime_get, pm_request_resume is
better than having the core automatically change the counter.

> This implies that it may be a good idea to check usage_count when submitting
> idle notification and suspend requests (where in case of suspend a request is
> submitted by the timer function, when the timer has already triggered, so
> there's no need to check the counter while setting up the timer).
> 
> The counter of unsuspended children may change after a request has been
> submitted and before its work function has a chance to run, so I don't see much
> point checking it when submitting requests.

As I said above, if the counters don't change then the submission was 
unnecessary, and if they do change then the submission should be 
reconsidered.  Therefore they _should_ be checked in submissions.

> So, if the above idea is adopted, idle notification and suspend requests
> won't be queued up when a resume request is pending (there's the question what
> the timer function attempting to queue up a suspend request is supposed to do
> in such a case) and in the other cases we can use the following rules:
> 
>     Any pending request takes precedence over a new idle notification request.

For pending resume requests this rule is unnecessary; it's invalid to
submit an idle notification request while a resume request is pending
(since resume requests can be pending only in the RPM_SUSPENDING and
RPM_SUSPENDED states while idle notification requests are accepted only
in RPM_RESUMING and RPM_ACTIVE).

For pending suspends, I think we should allow synchronous idle
notifications while the suspend is pending.  The runtime_idle callback
might then start its own suspend before the workqueue can get around to
it.  You're right about async idle requests though; that was the 
exception I noted below.

>     If a new request is not an idle notification request, it takes precedence
>     over the pending one, so it cancels it with the help of cancel_work().
> 
> [In the latter case, if a suspend request is canceled, we may want to set up the
> timer for another one.]  For that, we're going to need a single flag, say
> RPM_PENDING, which is set whenever a request is queued up.

That's what I called work_pending in my proposal.

> > The error codes you have been using seem okay to me, in general.
> > 
> > However, some of those requests would violate the rules in a trivial 
> > way.  For these we might return a positive value rather than a negative 
> > error code.  For example, calling pm_runtime_resume while the device is 
> > already active shouldn't be considered an error.  But it can't be 
> > considered a complete success either, because it won't invoke the 
> > runtime_resume method.
> 
> That need not matter from the caller's point of view, though.  In the case of
> pm_runtime_resume() the caller will probably be mostly interested whether or
> not it can do I/O after the function has returned.

Yes.  But the driver might depend on something happening inside the
runtime_resume method, so it would need to know if a successful
pm_runtime_resume wasn't going to invoke the callback.

> > To be determined: How runtime PM will interact with system sleep.
> 
> Yes.  My first idea was to disable run-time PM before entering a system sleep
> state, but that would involve canceling all of the pending requests.

Or simply freezing the workqueue.

> > About all I can add is the "New requests override previous requests"  
> > policy.  This would apply to all the non-synchronous requests, whether
> > they are delayed or added directly to the workqueue.  If a new request
> > (synchronous or not) is received before the old one has started to run,
> > the old one will be cancelled.  This holds even if the new request is
> > redundant, like a resume request received while the device is active.
> > 
> > There is one exception to this rule: An idle_notify request does not 
> > cancel a delayed or queued suspend request.
> 
> I'm not sure if such a rigid rule will be really useful.

A rigid rule is easier to understand and apply than one with a large
number of special cases.  However, in the statement of the rule above,
I forgot to mention that this applies only if the new request is valid,
i.e., if it's not forbidden by the current status or the counter
values.

> Also, as I said above, I think we shouldn't regard setting up the suspend
> timer as queuing up a request, but as a totally separate operation.

Well, there can't be any pending resume requests when the suspend timer
is set up, so we have to consider only pending idle notifications or
pending suspends.  I agree, we would want to allow an idle notification
to remain pending when the suspend timer is set up.  As for pending
suspends, we _should_ allow the new request to override the old one.  
This will come up whenever the timeout value is changed.

Alan Stern

