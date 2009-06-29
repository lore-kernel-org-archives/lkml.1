Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbZF2O32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbZF2O32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 10:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbZF2O3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 10:29:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55759 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751899AbZF2O3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 10:29:18 -0400
Date: Mon, 29 Jun 2009 10:29:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch update] PM: Introduce core framework for run-time PM of
 I/O devices (rev. 6)
In-Reply-To: <200906291609.24394.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0906291016050.16075-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009, Rafael J. Wysocki wrote:

> Well, not only in that cases and in fact this is where the actual problem is.
> 
> Namely, pm_request_suspend() and pm_request_resume() have to cancel any
> pending requests in a reliable way so that the work struct can be used safely
> after they've returned.

Right.

> Assume for example that there's a suspend request pending while
> pm_request_resume() is being called.  pm_request_resume() uses
> cancel_delayed_work() to kill off the request, but that's in interrupt and it
> happens to return -1.  Now, there's pm_runtime_put_atomic() right after that
> which attempts to queue up an idle notification request before the
> delayed suspend request has a chance to run and bad things happen.
> 
> So, it seems, pm_request_resume() can't kill suspend requests by itself
> and instead it has to queue up resume requests for this purpose, which
> brings us right back to the problem of two requests queued up at a time
> (a delayed suspend request and a resume request that is supposed to cancel it).

No, you're trying to do too much.  If the state is RPM_IDLE (i.e., a 
suspend request is pending) then rpm_request_resume doesn't need to do 
anything.  The device is already resumed!  Sure, it can try to kill the 
request and change the state to RPM_ACTIVE, but it doesn't need to.

Think about it.  Even if the suspend request were killed off, there's 
always the possibility that someone could call rpm_runtime_suspend 
right afterward.  If the driver really wants to resume the device and 
prevent it from suspending again, then the driver should call 
pm_runtime_get before pm_request_resume.  Then it won't matter if the 
suspend request runs.

> Nevertheless, using your workqueue patch we can still simplify things quite a
> bit, so I think it's worth doing anyway.

Me too.  :-)

> > Which reminds me...  The way you've got things set up, 
> > pm_runtime_put_atomic queues an idle notification, right?  That's 
> > a little inconsistent with the naming of the other routines.
> > 
> > Instead, pm_runtime_put_atomic should be a version of pm_runtime_put
> > that can safely be called in an atomic context -- it implies that it
> > will call the runtime_notify callback while holding the spinlock.  The
> > routine to queue an idle-notify request should be called something like
> > pm_request_put -- although that name isn't so great because it sounds 
> > like the put gets deferred instead of the notification.
> 
> There can be pm_request_put() and pm_request_put_sync(), for example.
> Or pm_request_put_async() and pm_request_put(), depending on which version is
> going to be used more often.

I don't follow you.  We only need one version of pm_request_put.  Did 
you mean "pm_runtime_put" and "pm_runtime_put_async"?  That would make 
sense.

If you use that (instead of pm_request_put) then would you want to
similarly rename pm_request_resume and pm_request_suspend to
pm_runtime_resume_async and pm_runtime_suspend_async?

Alan Stern

