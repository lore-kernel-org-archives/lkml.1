Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377AbZFUCXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbZFUCXK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 22:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbZFUCW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 22:22:59 -0400
Received: from netrider.rowland.org ([192.131.102.5]:54709 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751382AbZFUCW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 22:22:58 -0400
Date: Sat, 20 Jun 2009 22:23:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Oliver Neukum <oliver@neukum.org>, Magnus Damm <magnus.damm@gmail.com>,
       <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: [patch update 3] PM: Introduce core framework for run-time PM
 of I/O devices
In-Reply-To: <200906210138.53682.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0906202142110.20502-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Jun 2009, Rafael J. Wysocki wrote:

> > 	pm_request_suspend should run very quickly, since it will be
> > 	called after every I/O operation.  Likewise, pm_request_resume
> > 	should run very quickly if the status is RPM_ACTIVE or 
> > 	RPM_IDLE.
> 
> Hmm.  pm_request_suspend() is really short, so it should be fast.
> pm_request_resume() is a bit more complicated, though (it takes two spinlocks,
> increases an atomic counter, possibly twice, and queues up a work item, also
> in the RPM_IDLE case).

Hmm, maybe that's a good reason for not trying to handle the parent
from within pm_request_resume().  :-)

Or maybe the routine should be optimized for the RPM_ACTIVE and 
RPM_IDLE cases, where it doesn't have to do much anyway.


> > 	In order to prevent autosuspends from occurring while I/O is
> > 	in progress, the pm_request_resume call should increment the
> > 	usage counter (if it had to queue the request) and the 
> > 	pm_request_suspend call should decrement it (maybe after
> > 	waiting for the delay).
> 
> I don't want like pm_request_suspend() to do that, because it's valid to
> call it many times in a row. (only the first request will be queued in such a
> case).

Sorry, what I meant was that in each case the counter should be
{inc,dec}remented if a new request had to be queued.  If one was
already queued then the counter should be left alone.

The reason behind this is that a bunch of pm_request_suspend calls
which all end up referring to the same workqueue item will result in a
single async call to the runtime_suspend method.  Therefore they should
cause a single decrement of the counter.  Likewise for
pm_request_resume.

> I'd prefer the caller to do pm_request_resume_get() (please see the patch
> below) to put a resume request into the queue and then pm_runtime_put_notify()
> when it's done with the I/O.  That will result in ->runtime_idle() being called
> automatically if the device may be suspended.

If anyone does pm_request_resume or pm_runtime_resume, what is there to 
prevent the device from being suspended again as soon as the resume is 
finished (and before anything useful can be accomplished)?

     1. The driver's runtime_suspend method might be smart enough to 
	return -EBUSY until the driver has completed whatever it's 
	doing.

     2. The usage counter might be > 0.

     3. The number of children might be > 0.

In case 1 there's no reason not to also increment the counter, since
the driver can decrement it again when it is finished.  In cases 2 and
3, we can assume the counter or the number of children was previously
equal to 0, since otherwise the resume call would have been vacuous.  
This implies that the resume call itself should be responsible for
incrementing either the counter or the number of children.

What I'm getting at is this: There's no real point to having separate 
pm_request_resume and pm_request_resume_get calls.  All such calls 
should increment either the usage counter or the number of children.

(In the USB stack, a single counter is used for both purposes.  It 
doesn't look like that will work here.)


> > All bus types will want to implement _some_ delay; it doesn't make
> > sense to power down a device immediately after every operation and then
> > power it back up for the next operation.
> 
> Sure.  But you can use the pm_request_resume()'s delay to achieve that
> without storing the delay in 'struct device'.  It seems.

If you do it that way then the delay has to be hard-coded or stored in
some non-standardized location.  Which will be more common: devices
where the delay is fixed by the bus type (or driver), or devices where
the user should be able to adjust the delay?  If user-adjustable is 
more common then the delay should be stored in dev_pm_info, so that it 
can be controlled by a centralized sysfs attribute defined in the 
driver core.  If not then you are right, the delay doesn't need to be 
stored in struct device.

Alan Stern

