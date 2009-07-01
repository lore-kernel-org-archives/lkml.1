Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbZGAPfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbZGAPfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 11:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbZGAPfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 11:35:20 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36128 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751555AbZGAPfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 11:35:18 -0400
Date: Wed, 1 Jul 2009 11:35:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC] Run-time PM framework (was: Re: [patch update] PM: Introduce
 core framework for run-time PM of I/O devices (rev. 6))
In-Reply-To: <200907010030.13775.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0907011039100.3066-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009, Rafael J. Wysocki wrote:

> On Tuesday 30 June 2009, Alan Stern wrote:
> ... 
> > That's enough to give you the general idea.  I think this design is 
> > a lot cleaner than the current one.
> 
> Well, I'm not really happy with starting over, but if you think we should do
> that, then let's do it.

It's not a complete restart.  Much of the existing interface and quite
a bit of code would remain the same.

> I think we both agree that the callbacks, ->runtime_idle(), ->runtime_suspend()
> and ->runtime_resume() make sense.  Now, the role of the framework, IMO, is to
> provide a mechanism by which it is possible:
> (1) to schedule a delayed execution of ->runtime_suspend(), possibly from
>     interrupt context,
> (2) to schedule execution of ->runtime_resume() or ->runtime_idle(), possibly
>     from interrupt context,
> (3) to execute ->runtime_suspend() or ->runtime_resume() directly in a
>     synchronous way (I'm not sure about ->runtime_idle())

Yes, runtime_idle also, for drivers that require minimal overhead.

> _and_ to ensure that these callbacks will be executed when it makes sense.

Thus if the situation changes before the callback can be made, so that
it no longer makes sense, the framework should cancel the callback.

> There's no other point, because the core has no information to make choices,
> it can only prevent wrong things from happening, if possible.

Exactly.

> I think you will agree that the users of the framework should be able to
> prevent ->runtime_suspend() from being called and that's what the usage counter
> is for.  Also, IMO it should be impossible to execute ->runtime_idle(), via the
> framework, when the usage counter is nonzero.

Right, because then by definition the device is in use so it can't be 
idle.

> BTW, I don't think resume_count is the best name; it used to be in the version
> of my patch where it was automatically incremented when ->runtime_resume() was
> about to called.  usage_count is probably better.

Fine.

> Next, I think that the framework should refuse to call ->runtime_suspend() and
> ->runtime_idle() if the children of the device are not suspended and the
> "ignore children" flag is unset.

Yes; this is part of the "makes sense" requirement.

>  The counter of unsuspended children is used
> for that.  I think the rule should be that it is decremented for the parent
> whenever ->runtime_suspend() is called for a child and it is incremented
> for the parent whenever ->runtime_resume() is called for a child.

Of course.  (Minor change: decremented when runtime_suspend _succeeds_ 
for a child.)

> Now, the question is what rules should apply to the ordering and possible
> simultaneous execution of ->runtime_idle(), ->runtime_suspend() and
> ->runtime_resume().  I think the following rules make sense:

Oh dear.  I wouldn't attempt to make a complete list of all possible 
interactions.  It's too hard to know whether you have really covered 
all the cases.

>   * It is forbidden to run ->runtime_suspend() twice in a row.
> 
>   * It is forbidden to run ->runtime_suspend() in parallel with another instance
>     of ->runtime_suspend().
> 
>   * It is forbidden to run ->runtime_resume() twice in a row.
> 
>   * It is forbidden to run ->runtime_resume() in parallel with another instance
>     of ->runtime_resume().
> 
>   * It is allowed to run ->runtime_suspend() after ->runtime_resume() or after
>     ->runtime_idle(), but the latter case is preferred. 
> 
>   * It is allowed to run ->runtime_resume() after ->runtime_suspend().
> 
>   * It is forbidden to run ->runtime_resume() after ->runtime_idle().
> 
>   * It is forbidden to run ->runtime_suspend() and ->runtime_resume() in
>     parallel with each other.
> 
>   * It is forbidden to run ->runtime_idle() twice in a row.
> 
>   * It is forbidden to run ->runtime_idle() in parallel with another instance
>     of ->runtime_idle().
> 
>   * It is forbidden to run ->runtime_idle() after ->runtime_suspend().
> 
>   * It is allowed to run ->runtime_idle() after ->runtime_resume().
> 
>   * It is allowed to execute ->runtime_suspend() or ->runtime_resume() when
>     ->runtime_idle() is running.  In particular, it is allowed to (indirectly)
>     call ->runtime_suspend() from within ->runtime_idle().
> 
>   * It is forbidden to execute ->runtime_idle() when ->runtime_resume() or
>     ->runtime_suspend() is running.

We can summarize these rules as follows:

	Never allow more than one callback at a time, except that
	runtime_suspend may be invoked while runtime_idle is running.

	Don't call runtime_resume while the device is active.

	Don't call runtime_suspend or runtime_idle while the device
	is suspended.

	Don't invoke any callbacks if the device state is unknown
	(RPM_ERROR).

Implicit is the notion that the device is suspended when 
runtime_suspend returns successfully, it is active when runtime_resume 
returns successfully, and it is unknown when either returns an error.

>   * If ->runtime_resume() is about to be called immediately after
>     ->runtime_suspend(), the execution of ->runtime_suspend() should be
>     prevented from happening, if possible, in which case the execution of
>     ->runtime_resume() shouldn't happen.
> 
>   * If ->runtime_suspend() is about to be called immediately after
>     ->runtime_resume(), the execution of ->runtime_resume() should be
>     prevented from happening, if possible, in which case the execution of
>     ->runtime_suspend() shouldn't happen.

These could be considered optional optimizations.  Or if you prefer, 
they could be covered by a "New requests override previous requests" 
rule.

> [Are there any more rules related to these callbacks we should take into
> account?]

	Runtime PM callbacks are mutually exclusive with other driver
	core callbacks (probe, remove, dev_pm_ops, etc.).

	If a callback occurs asynchronously then it will be invoked
	in process context.  If it occurs as part of a synchronous
	request then it is invoked in the caller's context.

Related to this is the requirement that pm_runtime_idle,
pm_runtime_suspend, and pm_runtime_resume must always be called in
process context whereas pm_runtime_idle_atomic,
pm_runtime_suspend_atomic, and pm_runtime_resume_atomic may be called
in any context.

> Next, if we agree about the rules above, the question is what helper functions
> should be provided by the core allowing these rules to be followed
> automatically and what error codes should be returned by them in case it
> wasn't possible to proceed without breaking the rules.
> 
> IMO, it is reasonable to provide:
> 
>   * pm_schedule_suspend(dev, delay) - schedule the execution of
>     ->runtime_suspend(dev) after delay.
> 
>   * pm_runtime_suspend(dev) - execute ->runtime_suspend(dev) right now.
> 
>   * pm_runtime_resume(dev) - execute ->runtime_resume(dev) right now.
> 
>   * pm_request_resume(dev) - put a request to execute ->runtime_resume(dev)
>     into the run-time PM workqueue.
> 
>   * pm_runtime_get(dev) - increment the device's usage counter.
> 
>   * pm_runtime_put(dev) - decrement the device's usage counter.
> 
>   * pm_runtime_idle(dev) - execute ->runtime_idle(dev) right now if the usage
>     counter is zero and all of the device's children are suspended (or the
>     "ignore children" flag is set).
> 
>   * pm_request_idle(dev) - put a request to execute ->runtime_idle(dev)
>     into the run-time PM workqueue.  The usage counter and children will be
>     checked immediately before executing ->runtime_idle(dev).

Should the counters also be checked when the request is submitted?  
And should the same go for pm_schedule_suspend?  These are nontrivial
questions; good arguments can be made both ways.

> I'm not sure if it is really necessary to combine pm_runtime_idle() or
> pm_request_idle() with pm_runtime_put().  At least right now I don't see any
> real value of that.

Likewise combining pm_runtime_get with pm_runtime_resume.  The only
value is to make things easier for drivers, because these will be very
common idioms.

> I also am not sure what error codes should be returned by the above helper
> functions and in what conditions.

The error codes you have been using seem okay to me, in general.

However, some of those requests would violate the rules in a trivial 
way.  For these we might return a positive value rather than a negative 
error code.  For example, calling pm_runtime_resume while the device is 
already active shouldn't be considered an error.  But it can't be 
considered a complete success either, because it won't invoke the 
runtime_resume method.

To be determined: How runtime PM will interact with system sleep.


About all I can add is the "New requests override previous requests"  
policy.  This would apply to all the non-synchronous requests, whether
they are delayed or added directly to the workqueue.  If a new request
(synchronous or not) is received before the old one has started to run,
the old one will be cancelled.  This holds even if the new request is
redundant, like a resume request received while the device is active.

There is one exception to this rule: An idle_notify request does not 
cancel a delayed or queued suspend request.

Alan Stern

