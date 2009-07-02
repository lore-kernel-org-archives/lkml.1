Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbZGBPnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbZGBPnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbZGBPmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:42:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38233 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbZGBPmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:42:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC] Run-time PM framework (was: Re: [patch update] PM: Introduce core framework for run-time PM of I/O devices (rev. 6))
Date: Thu, 2 Jul 2009 17:42:51 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
References: <Pine.LNX.4.44L0.0907011039100.3066-100000@iolanthe.rowland.org> <200907020019.55645.rjw@sisk.pl>
In-Reply-To: <200907020019.55645.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907021742.57384.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 July 2009, Rafael J. Wysocki wrote:
> On Wednesday 01 July 2009, Alan Stern wrote:
> > On Wed, 1 Jul 2009, Rafael J. Wysocki wrote:
...
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
> 
> It implies that we should really introduce a timer and a timer function that
> will queue up suspend requests, instead of using struct delayed_work.
> 
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
> 
> This implies that it may be a good idea to check usage_count when submitting
> idle notification and suspend requests (where in case of suspend a request is
> submitted by the timer function, when the timer has already triggered, so
> there's no need to check the counter while setting up the timer).
> 
> The counter of unsuspended children may change after a request has been
> submitted and before its work function has a chance to run, so I don't see much
> point checking it when submitting requests.
> 
> So, if the above idea is adopted, idle notification and suspend requests
> won't be queued up when a resume request is pending (there's the question what
> the timer function attempting to queue up a suspend request is supposed to do
> in such a case) and in the other cases we can use the following rules:
>
>     Any pending request takes precedence over a new idle notification request.
> 
>     If a new request is not an idle notification request, it takes precedence
>     over the pending one, so it cancels it with the help of cancel_work().
> 
> [In the latter case, if a suspend request is canceled, we may want to set up the
> timer for another one.]  For that, we're going to need a single flag, say
> RPM_PENDING, which is set whenever a request is queued up.

After some reconsideration I'd like to change that in the following way:

     Any pending request takes precedence over a new idle notification request.

     A pending request takes precedence over a new request of the same type.

    If the new request is not an idle notification request and is not of the
    same type as the pending one, it takes precedence over the pending one, so
    it cancels the pending request with the help of cancel_work().

So, instead of a single flag, I'd like to use a 2-bit field to store
information about pending requests, where the 4 values are RPM_REQ_NONE,
RPM_REQ_IDLE, RPM_REQ_SUSPEND, RPM_REQ_RESUME.

Also, IMO it makes sense to queue up an idle notification or suspend request
regardless of the current status of the device, as long as the usage counter is
greater than 0, because the status can always change after the request has been
submitted and before its work function is executed.

So, I think we can use something like this:

struct dev_pm_info {
	pm_message_t		power_state;
	unsigned			can_wakeup:1;
	unsigned			should_wakeup:1;
	enum dpm_state		status;		/* Owned by the PM core */
#ifdef CONFIG_PM_SLEEP
	struct list_head	entry;
#endif
#ifdef CONFIG_PM_RUNTIME
	struct timer_list	suspend_timer;
	wait_queue_head_t	wait_queue;
	struct work_struct	work;
	spinlock_t		lock;
	atomic_t		usage_count;
	atomic_t		child_count;
	unsigned int		ignore_children:1;
	unsigned int		enabled:1; /* 'true' if run-time PM is enabled */
	unsigned int		idle_notification:1; /* 'true' if ->runtime_idle() is running */
	unsigned int		in_transition:1; /* 'true' if ->runtime_[suspend|resume]() is running */
	unsigned int		suspended:1; /* 'true' if current status is 'suspended' */
	unsigned int		pending_request:2; /* RPM_REQ_NONE, RPM_REQ_IDLE, etc. */
	unsigned int		runtime_error:1; /* 'ture' if the last transition failed */
	int			error_code; /* Error code returned by the last executed callback */
#endif
};

with the following rules regarding the (most important) helper functions:

  pm_schedule_suspend(dev, delay) is always successful.  It adds a new timer
  with pm_request_suspend() as the timer function, dev as the data and
  jiffies + delay as the expiration time.  If the timer is pending when this
  function is called, the timer is deactivated using del_timer() and replaced
  by the new timer.

  pm_request_suspend() checks if 'usage_count' is zero and returns -EAGAIN
  if not.  Next, it checks if 'pending_request' is RPM_REQ_SUSPEND and returns
  -EALREADY in that case.  Next, if 'pending_request' is RPM_REQ_IDLE,
  the request is cancelled.  Finally, a new suspend request is submitted.

  pm_runtime_suspend() checks if 'usage_count' is zero and returns -EAGAIN
  if not.  Next, it checks 'in_transition' and 'suspended' and returns 0 if the
  former is unset and the latter is set.  If 'in_transition' is set and 'suspended'
  is not set (the device is currently suspending), the behavior depends on
  whether or not the function was called synchronously, in which case it waits
  for the other suspend to finish.  If it was called via the workqueue,
  -EINPROGRESS is returned.  Next, 'in_transition' is set, ->runtime_suspend()
  is executed amd 'in_transition' is unset.  If ->runtime_suspend() returned 0,
  'suspended' is set and 0 is returned.  Otherwise, if the error code was
  -EAGAIN or -EBUSY, 'suspended' is not set and the error code is returned.
  Otherwise, 'runtime_error' is set and the error code is returned ('suspended'
  is not set).

  pm_request_resume() increments 'usage_count' and checks 'suspended' and
  'in_transition'.  If both 'suspended' and 'in_transition" are not set, 0 is
  returned and the caller is supposed to decrement 'usage_count', with the
  help of pm_runtime_put().  Otherwise, the function checks if
  'pending_request' is different from zero, in which case the pending request
  is canceled.  Finally, a new resume request is submitted and -EBUSY is
  returned.  In that case, 'usage_count' will be decremented by the request's
  work function (not by pm_runtime_resume(), but by the wrapper function that
  calls it).

  pm_runtime_resume() increments 'usage_count' and checks 'in_transition' and
  'suspended'.  If both are unset, 0 is returned.  If both are set (the device
  is resuming) the behavior depends on whether or not the function was called
  synchronously, in which case it waits for the concurrent resume to complete,
  while it immediately returns -EINPROGRESS in the other case.  If 'suspended'
  is not set, but 'in_transision' is set (the device is suspending), the
  function waits for the suspend to complete and starts over.  Next,
  'in_transition' is set, ->runtime_resume() is executed and 'in_transition'
  is unset.  If ->runtime_resume() returned 0, 'suspended' is unset and 0 is
  returned.  Otherwise, 'runtime_error' is set and the error code from
  ->runtime_resume() is returned ('suspended' is not unset).  'usage_count' is
  always decremented before return, regardless of the return value.

  pm_request_idle() checks 'usage_count' and returns -EAGAIN if it's greater
  than 0.  Next, it checks 'pending_request' and immediately returns -EBUSY, if
  it's different from RPM_REQ_NONE and RPM_REQ_IDLE, or -EALREADY, if it's
  equal to RPM_REQ_IDLE.  Finally, new idle notification request is submitted.

  pm_runtime_idle() checks 'usage_count' and returns -EAGAIN if it's greater
  than 0.  Next, it checks 'suspended' and 'in_transition' and returns -EBUSY
  if any of them is set.  Next, it checks 'idle_notification' and returns
  -EINPROGRESS is it's set.  Finally, 'idle_notification' is set,
  ->runtime_idle()  is executed and 'idle_notification' is unset.

Additionally, all of the helper functions return -EINVAL immediately if
'runtime_error' is set.

Best,
Rafael
