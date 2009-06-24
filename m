Return-Path: <linux-kernel-owner+w=401wt.eu-S1761653AbZFXTN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761653AbZFXTN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 15:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754720AbZFXTNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 15:13:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46415 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633AbZFXTNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 15:13:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch update 3] PM: Introduce core framework for run-time PM of I/O devices
Date: Wed, 24 Jun 2009 21:14:09 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>, Magnus Damm <magnus.damm@gmail.com>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
References: <Pine.LNX.4.44L0.0906241014170.3199-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906241014170.3199-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906242114.10530.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 June 2009, Alan Stern wrote:
> On Wed, 24 Jun 2009, Rafael J. Wysocki wrote:
> 
> > > One question still remains: If the counter is 0 at the end of a
> > > successful pm_runtime_resume, should the core then call pm_notify_idle?  
> > > Or should we make the driver responsible for that too?
> > 
> > Good question. :-)
> > 
> > I think the core may call pm_notify_idle() in that case, but not necessarily in
> > the synchronous case.
> 
> I'm not sure; we may want to do it even for synchronous resumes.  
> Otherwise the callers would be forced to do it.

I have no strong opinion.  We can do it in the sychronous case too.

> There's also the other side of the coin.  What if the counter is 0 at
> the end of a failed pm_runtime_suspend?
> 
> For example, suppose the driver's runtime_suspend method decides that
> the device hasn't been idle for long enough, so it wants to fail the
> suspend attempt with -EBUSY and queue a new delayed autosuspend
> request.  But at this point the status is RPM_SUSPENDING, so new
> suspend requests won't be accepted (N.B., the test for this in the most
> recent patch doesn't look right).

In fact it was inversed (fixed now), thanks for spotting this!

> Even with a queued notification, there's no guarantee that the
> notification won't be sent before the status changes from
> RPM_SUSPENDING to RPM_ACTIVE.  So we really do need the notification to
> be sent by pm_runtime_suspend, after it has updated the status and
> dropped the lock.

OK

> There's another totally separate issue worth discussing here.  This 
> will affect the USB implementation of the new runtime PM framework.
> 
> The difficulty is that some USB interface drivers require remote wakeup
> to be enabled while their interfaces are suspended.  But remote wakeup
> is a global setting; it doesn't take effect until the entire physical
> device is suspended.  (To put it another way, USB has no notion of
> suspending interfaces.)  This means we must not allow these interfaces
> to be suspended before the whole device is.  But the whole device is
> the parent of the interfaces -- if we can't suspend the children before
> suspending the parent then we're stuck.

Not if we use the power.ignore_children flag on the parent.

> Clearly this is something the USB stack has to deal with; it shouldn't
> affect the general PM framework.  However the only solution I can think
> of involves subverting the framework, which isn't very nice.  The idea
> is to ignore runtime_suspend callbacks for these interface drivers;
> allow them to keep on running even though the PM core thinks they are
> suspended.  Then suspend and resume them as part of the callbacks for
> the entire device.  (For interface drivers that don't require remote
> wakeup there is no problem; it doesn't matter when they get suspended.)
> 
> This will work, but it's a hack.  Does anybody have a better idea?

Well, as I said above, you can set power.ignore_children on the device
and then it can be suspended even if the interfaces aren't.

Best,
Rafael
