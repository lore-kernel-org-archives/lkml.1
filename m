Return-Path: <linux-kernel-owner+w=401wt.eu-S1759414AbZF2OJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759414AbZF2OJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 10:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZF2OJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 10:09:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43936 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbZF2OJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 10:09:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch update] PM: Introduce core framework for run-time PM of I/O devices (rev. 6)
Date: Mon, 29 Jun 2009 16:09:23 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
References: <Pine.LNX.4.44L0.0906282237180.11984-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906282237180.11984-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906291609.24394.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 June 2009, Alan Stern wrote:
> On Mon, 29 Jun 2009, Rafael J. Wysocki wrote:
> 
> > > The original version of __cancel_work_timer is not safe to use
> > > in_interrupt.  If it is called from a handler whose IRQ interrupted
> > > delayed_work_timer_fn, it can loop indefinitely.
> > 
> > Right, I overlooked that.
> > 
> > > Therefore I added a check; if it finds that the work_struct is currently
> > > being enqueued and it is running in_interrupt, it gives up right away.
> > 
> > Hmm, it doesn't do the work_clear_pending(work) in that case, so we allow
> > the work to be queued and run?
> 
> Yes.  That's better than leaving the work queued but with the "pending" 
> flag cleared.  :-)

So there still is a problem, I'm afraid (details below).

> >  Out of couriosity, what the caller is supposed
> > to do then?
> 
> In the case of cancel_work, this is a simple race.  The work_struct was
> being submitted at the same time as the cancellation occurred.  The end
> result is the same as if the submission had been slightly later: The
> work is on the queue and it will run.  If the caller can guarantee that 
> the work is not in the process of being submitted (as described in the 
> kerneldoc) then this situation will never arise.
> 
> In the case of cancel_delayed_work, things are more complicated.  If
> the cancellation had occurred a little earlier, it would have
> deactivated the timer.  If it had occurred a little later, it would
> have removed the item from the workqueue.  But since it arrived at
> exactly the wrong time -- while the timer routine is enqueuing the work
> -- there's nothing it can do.  The caller has to cope as best he can.
> 
> For runtime PM this isn't a big issue.  The only delayed work we have
> is a delayed autosuspend request.  These things get cancelled when:
> 
> 	pm_runtime_suspend runs synchronously.  That happens in
> 	process context so we're okay.
> 
> 	pm_runtime_suspend_atomic (not yet written!) is called.

This is going to be added in a separate patch.

> 	If the cancellation fails, we'll have to return an error.
> 	The suspend will happen later, when the work item runs.
> 	Ultimately, the best we can do is recommend that people
> 	don't mix pm_request_suspend with pm_runtime_suspend_atomic.

Well, not only in that cases and in fact this is where the actual problem is.

Namely, pm_request_suspend() and pm_request_resume() have to cancel any
pending requests in a reliable way so that the work struct can be used safely
after they've returned.

Assume for example that there's a suspend request pending while
pm_request_resume() is being called.  pm_request_resume() uses
cancel_delayed_work() to kill off the request, but that's in interrupt and it
happens to return -1.  Now, there's pm_runtime_put_atomic() right after that
which attempts to queue up an idle notification request before the
delayed suspend request has a chance to run and bad things happen.

So, it seems, pm_request_resume() can't kill suspend requests by itself
and instead it has to queue up resume requests for this purpose, which
brings us right back to the problem of two requests queued up at a time
(a delayed suspend request and a resume request that is supposed to cancel it).

Nevertheless, using your workqueue patch we can still simplify things quite a
bit, so I think it's worth doing anyway.

> Which reminds me...  The way you've got things set up, 
> pm_runtime_put_atomic queues an idle notification, right?  That's 
> a little inconsistent with the naming of the other routines.
> 
> Instead, pm_runtime_put_atomic should be a version of pm_runtime_put
> that can safely be called in an atomic context -- it implies that it
> will call the runtime_notify callback while holding the spinlock.  The
> routine to queue an idle-notify request should be called something like
> pm_request_put -- although that name isn't so great because it sounds 
> like the put gets deferred instead of the notification.

There can be pm_request_put() and pm_request_put_sync(), for example.
Or pm_request_put_async() and pm_request_put(), depending on which version is
going to be used more often.

Thanks,
Rafael
