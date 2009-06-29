Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbZF2DFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbZF2DFr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 23:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbZF2DFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 23:05:39 -0400
Received: from netrider.rowland.org ([192.131.102.5]:36691 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751906AbZF2DFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 23:05:38 -0400
Date: Sun, 28 Jun 2009 23:05:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch update] PM: Introduce core framework for run-time PM of
 I/O devices (rev. 6)
In-Reply-To: <200906290215.39517.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0906282237180.11984-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009, Rafael J. Wysocki wrote:

> > The original version of __cancel_work_timer is not safe to use
> > in_interrupt.  If it is called from a handler whose IRQ interrupted
> > delayed_work_timer_fn, it can loop indefinitely.
> 
> Right, I overlooked that.
> 
> > Therefore I added a check; if it finds that the work_struct is currently
> > being enqueued and it is running in_interrupt, it gives up right away.
> 
> Hmm, it doesn't do the work_clear_pending(work) in that case, so we allow
> the work to be queued and run?

Yes.  That's better than leaving the work queued but with the "pending" 
flag cleared.  :-)

>  Out of couriosity, what the caller is supposed
> to do then?

In the case of cancel_work, this is a simple race.  The work_struct was
being submitted at the same time as the cancellation occurred.  The end
result is the same as if the submission had been slightly later: The
work is on the queue and it will run.  If the caller can guarantee that 
the work is not in the process of being submitted (as described in the 
kerneldoc) then this situation will never arise.

In the case of cancel_delayed_work, things are more complicated.  If
the cancellation had occurred a little earlier, it would have
deactivated the timer.  If it had occurred a little later, it would
have removed the item from the workqueue.  But since it arrived at
exactly the wrong time -- while the timer routine is enqueuing the work
-- there's nothing it can do.  The caller has to cope as best he can.

For runtime PM this isn't a big issue.  The only delayed work we have
is a delayed autosuspend request.  These things get cancelled when:

	pm_runtime_suspend runs synchronously.  That happens in
	process context so we're okay.

	pm_runtime_suspend_atomic (not yet written!) is called.
	If the cancellation fails, we'll have to return an error.
	The suspend will happen later, when the work item runs.
	Ultimately, the best we can do is recommend that people
	don't mix pm_request_suspend with pm_runtime_suspend_atomic.


Which reminds me...  The way you've got things set up, 
pm_runtime_put_atomic queues an idle notification, right?  That's 
a little inconsistent with the naming of the other routines.

Instead, pm_runtime_put_atomic should be a version of pm_runtime_put
that can safely be called in an atomic context -- it implies that it
will call the runtime_notify callback while holding the spinlock.  The
routine to queue an idle-notify request should be called something like
pm_request_put -- although that name isn't so great because it sounds 
like the put gets deferred instead of the notification.

Alan Stern


