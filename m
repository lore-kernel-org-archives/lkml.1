Return-Path: <linux-kernel-owner+w=401wt.eu-S1756452AbZGEVrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452AbZGEVrr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 17:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbZGEVrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 17:47:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51031 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbZGEVrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 17:47:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC] Run-time PM framework (was: Re: [patch update] PM: Introduce core framework for run-time PM of I/O devices (rev. 6))
Date: Sun, 5 Jul 2009 23:47:54 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
References: <Pine.LNX.4.44L0.0907041938580.10275-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0907041938580.10275-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907052347.55717.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 July 2009, Alan Stern wrote:
> On Sat, 4 Jul 2009, Rafael J. Wysocki wrote:
> 
> > > As for whether or not we should actually call cancel_work...  Which is 
> > > more expensive: Calling cancel_work when no work is pending, or letting 
> > > the work item run when it doesn't have anything to do?  Probably the 
> > > latter.
> > 
> > Agreed, but that doesn't affect functionality.  We can get the desired
> > functionality without the cancel_work() patch and then optimize things along
> > with that patch.  This way it'll be easier to demontrate the benefit of it.
> 
> Good idea.
> 
> > That almost entirely depends on the bus type.  For PCI and probably PNP as well
> > there's a notion of ACPI low power states and there are AML methods to put the
> > devices into these states.  Unfortunately, the ACPI low power state to put the
> > device into depends on the target sleep state of the system, so these devices
> > will probably have to be put into D0 before system suspend anyway.
> > 
> > I think that the bus type can handle this as long as it knows the state the
> > device is in before system suspend.  So, the only thing the core should do is
> > to block the execution of run-time PM framework functions during system
> > sleep and resume.  The state it leaves the device in shouldn't matter.
> > 
> > So, I think we can simply freeze the workqueue, set the 'disabled' bit for each
> > device and wait for all run-time PM operations on it in progress to complete.
> > 
> > In the 'disabled' state the bus type or driver can modify the run-time PM
> > status to whatever they like anyway.  Perhaps we can provide a helper to
> > change 'request type' to RPM_REQ_NONE.
> 
> The only modification that really makes sense is like you said, going
> back to full power in preparation for the platform suspend operation.  
> Therefore perhaps we should allow pm_runtime_resume to work even when
> rpm_disabled is set.  And if we're going to cancel pending suspend and
> idle requests, then rpm_request would normally be RPM_REQ_NONE anyway.

After we've disabled run-time PM with pm_runtime_disable(), the bus type
and driver can do whatever they like with the device, we don't care.  However,
they need to make sure that the state of the device will match its run-time PM
status when its run-time PM is enabled again.

> Which leaves only the question of what to do when a resume request is 
> pending...

I think the pm_runtime_disable() can carry out a synchronous wake-up if it
sees a pending resume request.  That would make sense in general, IMO, becuase
having a resume request pending usually means there's I/O to process and it's
better to allow the device to process that I/O before disabling the run-time
PM of it.

To put it differently, if there's a resume request pending, the run-time PM of
the device should be disabled while in the 'active' state rather than while in
the 'suspended' state.

Now, if we do that, the problem of run-time resume requests pending while
entering a system sleep state can be solved.  Namely, we can make
pm_runtime_disable() return a result that will be -EBUSY if a pending resume
request is found by it and 0 otherwise.  Then, that result can be used by
dpm_prepare() to decide whether to continue suspend or to terminate it if
the device is a wake-up one.

> > So, I guess we have the majority of things clarified and perhaps its time to
> > write a patch for further discussion. :-)
> 
> Go ahead!

In fact I've already done that, but I need to have a final look at it to check
if there are no obvious mistakes in there.

Best,
Rafael
