Return-Path: <linux-kernel-owner+w=401wt.eu-S1757224AbZF2SZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224AbZF2SZQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 14:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbZF2SZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 14:25:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45622 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbZF2SZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 14:25:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch update] PM: Introduce core framework for run-time PM of I/O devices (rev. 6)
Date: Mon, 29 Jun 2009 20:25:14 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
References: <Pine.LNX.4.44L0.0906291259320.17436-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906291259320.17436-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906292025.15142.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 June 2009, Alan Stern wrote:
> On Mon, 29 Jun 2009, Rafael J. Wysocki wrote:
> 
> > Theoretically, we are, but practically we want to be able to use
> > pm_runtime_put() (the asynchronous version) after a pm_runtime_resume()
> > that found the device operational, but that would result in queuing a request
> > using the same work structure that is used by the pending suspend request.
> > Don't you see a problem here?
> 
> This is a different situation.  pm_runtime_resume does have the luxury 
> of killing the suspend request, and it should do so.

I should have said pm_request_resume(), sorry.

> Let's think about it this way.  Why does a driver call
> pm_request_resume in the first place?  Because an interrupt handler or
> spinlocked region wants to do some I/O, so the device has to
> be active.

Right.

> But when will it do the I/O?  If the device is currently suspended, the
> driver can do the I/O at the end of its runtime_resume callback.  But
> if the status is RPM_ACTIVE, the callback won't be invoked, so the
> interrupt handler will have to do the I/O directly.  The same is true
> for RPM_IDLE.

I still agree.

> Except for one problem: In RPM_IDLE, a suspend might occur at any time.  
> (In theory the same thing could happen in RPM_ACTIVE.)  To prevent
> this, the driver can call pm_runtime_get before pm_request_resume.  
> When the I/O is all finished, it calls pm_request_put.

At which point pm_request_put() tries to queue up an idle notification that
uses the same work_struct as the pending suspend request.  Not good.

> If the work routine starts running before the pm_request_put, it will 
> see that the counter is positive so it will set the status back to 
> RPM_ACTIVE.  Then the put will queue an idle notification.  If the work 
> routine hasn't started running before the pm_request_put then the 
> status will remain RPM_IDLE all along.
> 
> Regardless, it's not necessary for pm_request_resume to kill the 
> suspend request.  And even if it did, the driver would still need to 
> implement both pathways for doing the I/O.

IMO one can think of pm_request_resume() as a top half of pm_runtime_resume().
Thus, it should either queue up a request to run pm_runtime_resume() or leave
the status as though pm_runtime_resume() ran.  Anything else would be
internally inconsistent.  So, if pm_runtime_resume() cancels pending suspend
requests, pm_request_resume() should do the same or the other way around.

Now, arguably, ignoring pending suspend requests is somewhat easier from
the core's point of view, but it may not be so for drivers.

> > > As long as the behavior is documented, I think it will be okay for
> > > pm_request_resume not to cancel a pending suspend request.
> > 
> > I could agree with that, but what about pm_runtime_resume() happening after
> > a suspend request has been scheduled?  Should it also ignore the pending
> > suspend request?
> 
> It could, but probably it shouldn't.

So, IMO, pm_request_resume() shouldn't as well.

> > In which case it would be consistent to allow to schedule suspends even though
> > the resume counter is greater than 0.
> 
> True enough, although I'm not sure there's a good reason for it.  You 
> certainly can increment the resume counter after scheduling a suspend 
> request -- the effect would be the same.

Yes, it would.

My point is that the core should always treat pending suspend requests in the
same way.  If they are canceled by pm_runtime_resume(), then
pm_request_resume() should also cancel them and it shouldn't be possible
to schedule a suspend request when the resume counter is greater than 0.
In turn, if they are ignored by pm_runtime_resume(), then pm_request_resume()
should also ignore them and there's no point to prevent pm_request_suspend()
from scheduling a suspend request if the resume counter is greater than 0.

Any other type of behavior has a potential to confuse driver writers.

Best,
Rafael
