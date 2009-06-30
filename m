Return-Path: <linux-kernel-owner+w=401wt.eu-S1757272AbZF3PLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbZF3PLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 11:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbZF3PKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 11:10:53 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38191 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752829AbZF3PKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 11:10:52 -0400
Date: Tue, 30 Jun 2009 11:10:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch update] PM: Introduce core framework for run-time PM of
 I/O devices (rev. 6)
In-Reply-To: <200906300050.56304.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0906301027540.3049-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009, Rafael J. Wysocki wrote:

> > There are three natural policies:
> > 
> > 	The first request takes precedence over the second;
> > 
> > 	The second request takes precedence over the first;
> > 
> > 	Resumes take precedence over suspends.
> > 
> > Any one of those would be acceptable.
> 
> IMO resumes should take precedence over suspends, because resume usually means
> "there's I/O to process" and we usually we want the I/O to be processed as soon
> as possible (deferred wake-up will usually mean deferred I/O and that would
> hurt user experience).

I don't know.  I gave this a lot of thought last night, and it seems
that the best approach would be to always obey the most recent request.  
(In the case of delayed suspend requests, this is ambiguous because
there are two times involved: when the request was originally submitted
and when the delay expires.  We should use the time of original
submission.)  The only exception is pm_request_put; it shouldn't
override an existing suspend request just to send an idle notification.

If this seems difficult to implement, it's an indication that the
overall design needs to be reworked.  Here's what I came up with:

The possible statuses are reduced to: RPM_ACTIVE, RPM_SUSPENDING, 
RPM_SUSPENDED, RPM_RESUMING, and RPM_ERROR.  These most directly 
correspond to the core's view of the device state.  Transitions are:

	RPM_ACTIVE <-> RPM_SUSPENDING -> RPM_SUSPENDED ->
		RPM_RESUMING -> RPM_ACTIVE ...

Failure of a suspend causes the backward transition from RPM_SUSPENDING 
to RPM_ACTIVE, and errors cause a transition to RPM_ERROR.  Otherwise 
we always go forward.

Instead of a delayed_work_struct, we'll have a regular work_struct plus 
a separate timer_list structure.  That way we get more control over 
what happens when the timer expires.  The timer callback routine will 
submit the work_struct, but it will do so under the spinlock and only 
after making the proper checks.

There will be only one work callback routine.  It decides what to do
based on the status and a new field: async_action.  The possible values
for async_action are 0 (do nothing), ASYNC_SUSPEND, ASYNC_RESUME, and
ASYNC_NOTIFY.

There will be a few extra fields: a work_pending flag, the timer 
expiration value (which doubles as a timer_pending flag by being set
to 0 when the timer isn't pending), and maybe some others.

There are restrictions on what can happen in each state.  The timer is
allowed to run only in RPM_RESUMING and RPM_ACTIVE, and ASYNC_NOTIFY is
allowed only in those states.  ASYNC_RESUME isn't allowed in
RPM_RESUMING or RPM_ACTIVE, and ASYNC_SUSPEND isn't allowed in
RPM_SUSPENDING or RPM_SUSPENDED.  Pending work isn't allowed in
RPM_RESUMING or RPM_SUSPENDING; if a request is submitted at such times
is merely sets async_action, and the work will be scheduled when the
resume or suspend finishes.  This is to avoid forcing the workqueue
thread to wait unnecessarily.

__pm_runtime_suspend and __pm_runtime_resume start out by cancelling 
the timer and the work_struct (if they are pending) and by setting 
async_action to 0.  The cancellations don't have to wait; if a callback 
routine is already running then when it gets the spinlock it will see 
that it has nothing to do.

If __pm_runtime_suspend was called asynchronously and the status is
already RPM_SUSPENDING, it can return after taking these actions.  If
the status is already RPM_RESUMING, it should set async_action to
ASYNC_SUSPEND and then return.  __pm_runtime_resume behaves similarly.

The pm_request_* routines similarly cancel a pending timer and clear
async_action.  They should cancel any pending work unless they're going
to submit new work anyway.

That's enough to give you the general idea.  I think this design is 
a lot cleaner than the current one.

Alan Stern

