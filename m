Return-Path: <linux-kernel-owner+w=401wt.eu-S1759665AbZF2Oyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759665AbZF2Oyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 10:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbZF2Oyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 10:54:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44333 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972AbZF2Oyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 10:54:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch update] PM: Introduce core framework for run-time PM of I/O devices (rev. 6)
Date: Mon, 29 Jun 2009 16:54:55 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
References: <Pine.LNX.4.44L0.0906291016050.16075-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906291016050.16075-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906291654.56500.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 June 2009, Alan Stern wrote:
> On Mon, 29 Jun 2009, Rafael J. Wysocki wrote:
> 
> > Well, not only in that cases and in fact this is where the actual problem is.
> > 
> > Namely, pm_request_suspend() and pm_request_resume() have to cancel any
> > pending requests in a reliable way so that the work struct can be used safely
> > after they've returned.
> 
> Right.
> 
> > Assume for example that there's a suspend request pending while
> > pm_request_resume() is being called.  pm_request_resume() uses
> > cancel_delayed_work() to kill off the request, but that's in interrupt and it
> > happens to return -1.  Now, there's pm_runtime_put_atomic() right after that
> > which attempts to queue up an idle notification request before the
> > delayed suspend request has a chance to run and bad things happen.
> > 
> > So, it seems, pm_request_resume() can't kill suspend requests by itself
> > and instead it has to queue up resume requests for this purpose, which
> > brings us right back to the problem of two requests queued up at a time
> > (a delayed suspend request and a resume request that is supposed to cancel it).
> 
> No, you're trying to do too much.  If the state is RPM_IDLE (i.e., a 
> suspend request is pending) then rpm_request_resume doesn't need to do 
> anything.  The device is already resumed!  Sure, it can try to kill the 
> request and change the state to RPM_ACTIVE, but it doesn't need to.

I think it does need to do that, because the reuqest may be scheduled way
in the future and we can't preserve its work structure until it runs.
pm_request_resume() doesn't know in advance when the suspend work function is
going to be queued up and run.

> Think about it.  Even if the suspend request were killed off, there's 
> always the possibility that someone could call rpm_runtime_suspend 
> right afterward.  If the driver really wants to resume the device and 
> prevent it from suspending again, then the driver should call 
> pm_runtime_get before pm_request_resume.  Then it won't matter if the 
> suspend request runs.

No, it doesn't matter if the request runs, but it does matter if the work
structure used for queuing it up may be used for another purpose. :-)

> > Nevertheless, using your workqueue patch we can still simplify things quite a
> > bit, so I think it's worth doing anyway.
> 
> Me too.  :-)
> 
> > > Which reminds me...  The way you've got things set up, 
> > > pm_runtime_put_atomic queues an idle notification, right?  That's 
> > > a little inconsistent with the naming of the other routines.
> > > 
> > > Instead, pm_runtime_put_atomic should be a version of pm_runtime_put
> > > that can safely be called in an atomic context -- it implies that it
> > > will call the runtime_notify callback while holding the spinlock.  The
> > > routine to queue an idle-notify request should be called something like
> > > pm_request_put -- although that name isn't so great because it sounds 
> > > like the put gets deferred instead of the notification.
> > 
> > There can be pm_request_put() and pm_request_put_sync(), for example.
> > Or pm_request_put_async() and pm_request_put(), depending on which version is
> > going to be used more often.
> 
> I don't follow you.  We only need one version of pm_request_put.  Did 
> you mean "pm_runtime_put" and "pm_runtime_put_async"?  That would make 
> sense.

Yes, I did, sorry.

> If you use that (instead of pm_request_put) then would you want to
> similarly rename pm_request_resume and pm_request_suspend to
> pm_runtime_resume_async and pm_runtime_suspend_async?

Well, I think the pm_request_[suspend|resume] names are better. :-)

The problem with pm_<something>_put is that it does two things at a time,
decrements the resume counter and runs or queues up an idle notification.
Perhaps it's a good idea to call it after the second thing and change
pm_runtime_get() to pm_runtime_inuse(), so that we have:

* pm_runtime_inuse() - increment the resume counter
* pm_runtime_idle() - decrement the resume counter and run idle notification
* pm_request_idle()  - decrement the resume counter and queue idle notification

and __pm_runtime_idle() as the "bare" idle notification function?

Thanks,
Rafael
