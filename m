Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560AbZFUMqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbZFUMqX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 08:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbZFUMqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 08:46:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51669 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbZFUMqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 08:46:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch update 3] PM: Introduce core framework for run-time PM of I/O devices
Date: Sun, 21 Jun 2009 14:46:25 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>, Magnus Damm <magnus.damm@gmail.com>,
       linux-pm@lists.linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
References: <Pine.LNX.4.44L0.0906202142110.20502-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906202142110.20502-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906211446.26019.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 June 2009, Alan Stern wrote:
> On Sun, 21 Jun 2009, Rafael J. Wysocki wrote:
> 
> > > 	pm_request_suspend should run very quickly, since it will be
> > > 	called after every I/O operation.  Likewise, pm_request_resume
> > > 	should run very quickly if the status is RPM_ACTIVE or 
> > > 	RPM_IDLE.
> > 
> > Hmm.  pm_request_suspend() is really short, so it should be fast.
> > pm_request_resume() is a bit more complicated, though (it takes two spinlocks,
> > increases an atomic counter, possibly twice, and queues up a work item, also
> > in the RPM_IDLE case).
> 
> Hmm, maybe that's a good reason for not trying to handle the parent
> from within pm_request_resume().  :-)
>
> Or maybe the routine should be optimized for the RPM_ACTIVE and 
> RPM_IDLE cases, where it doesn't have to do much anyway.

Yes, I think that's the way to go.

> > > 	In order to prevent autosuspends from occurring while I/O is
> > > 	in progress, the pm_request_resume call should increment the
> > > 	usage counter (if it had to queue the request) and the 
> > > 	pm_request_suspend call should decrement it (maybe after
> > > 	waiting for the delay).
> > 
> > I don't want like pm_request_suspend() to do that, because it's valid to
> > call it many times in a row. (only the first request will be queued in such a
> > case).
> 
> Sorry, what I meant was that in each case the counter should be
> {inc,dec}remented if a new request had to be queued.  If one was
> already queued then the counter should be left alone.
> 
> The reason behind this is that a bunch of pm_request_suspend calls
> which all end up referring to the same workqueue item will result in a
> single async call to the runtime_suspend method.

Yes, that's why only the first one results in queuing up a request.

There is a problem with that if the later calls are supposed to use shorter
delays, but I have no real idea to handle this cleanly.

> Therefore they should cause a single decrement of the counter.  Likewise for
> pm_request_resume.

Hmm.  Why exactly do you think it's necessary to decrease the usage counter
in suspend functions?  You can't suspend a device more than once and you have
to resume it at the first request anyway.

I think it makes sense to increase the usage counter on every attempt to
resume, even if the device is not woken up as a result, because that means the
caller wants the device not to be suspended until the counter is decreased.
This way, even if the device is already active, multiple callers can prevent it
from suspending by calling pm_request_resume_get() or pm_runtime_resume_get()
and then dropping the references.

Now, we can also make pm_request_suspend() and pm_runtime_suspend() drop
the usage counter (if it's greater than zero), but that implies a usage model
in which a resume function called when I/O is started should be balanced with a
suspend function called after the I/O has been finished.

However, I'd prefer a usage model in which ->runtime_idle() is called when the
I/O is finished and the usage counter is zero and it decides whether to call a
suspend function.

So, perhaps I should make resume functions increase the usage counter
unconditionally and introduce pm_runtime_idle() to be called when the I/O is
done?  That is, pm_runtime_idle() will decrement the usage counter, check if
it's zero and call ->runtime_idle() when that's the case (well, this is what
pm_runtime_put_notify() does right now, but maybe the name is wrong).

Also, there should be a function to use when it's only necessary to drop the
usage counter, without calling ->runtime_idle() (for example, if another code
path is supposed to call a suspend function directly).

> > I'd prefer the caller to do pm_request_resume_get() (please see the patch
> > below) to put a resume request into the queue and then pm_runtime_put_notify()
> > when it's done with the I/O.  That will result in ->runtime_idle() being called
> > automatically if the device may be suspended.
> 
> If anyone does pm_request_resume or pm_runtime_resume, what is there to 
> prevent the device from being suspended again as soon as the resume is 
> finished (and before anything useful can be accomplished)?
> 
>      1. The driver's runtime_suspend method might be smart enough to 
> 	return -EBUSY until the driver has completed whatever it's 
> 	doing.
> 
>      2. The usage counter might be > 0.
> 
>      3. The number of children might be > 0.
> 
> In case 1 there's no reason not to also increment the counter, since
> the driver can decrement it again when it is finished.  In cases 2 and
> 3, we can assume the counter or the number of children was previously
> equal to 0, since otherwise the resume call would have been vacuous.  
> This implies that the resume call itself should be responsible for
> incrementing either the counter or the number of children.
> 
> What I'm getting at is this: There's no real point to having separate 
> pm_request_resume and pm_request_resume_get calls.  All such calls 
> should increment either the usage counter or the number of children.

OK

But there are devices with no children, so I think it's necessary to increment
the usage counter in all cases.

> (In the USB stack, a single counter is used for both purposes.  It 
> doesn't look like that will work here.)
> 
> 
> > > All bus types will want to implement _some_ delay; it doesn't make
> > > sense to power down a device immediately after every operation and then
> > > power it back up for the next operation.
> > 
> > Sure.  But you can use the pm_request_resume()'s delay to achieve that
> > without storing the delay in 'struct device'.  It seems.
> 
> If you do it that way then the delay has to be hard-coded or stored in
> some non-standardized location.  Which will be more common: devices
> where the delay is fixed by the bus type (or driver), or devices where
> the user should be able to adjust the delay?  If user-adjustable is 
> more common then the delay should be stored in dev_pm_info, so that it 
> can be controlled by a centralized sysfs attribute defined in the 
> driver core.  If not then you are right, the delay doesn't need to be 
> stored in struct device.

I agree, but I'd prefer not to add the delay and timestamp fields to the
picture in a future patch.

Best,
Rafael
