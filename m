Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbZGEOvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbZGEOvL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 10:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbZGEOuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 10:50:55 -0400
Received: from netrider.rowland.org ([192.131.102.5]:55166 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752837AbZGEOuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 10:50:55 -0400
Date: Sun, 5 Jul 2009 10:50:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC] Run-time PM framework (was: Re: [patch update] PM: Introduce
 core framework for run-time PM of I/O devices (rev. 6))
In-Reply-To: <200907042327.32073.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0907041938580.10275-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Jul 2009, Rafael J. Wysocki wrote:

> > As for whether or not we should actually call cancel_work...  Which is 
> > more expensive: Calling cancel_work when no work is pending, or letting 
> > the work item run when it doesn't have anything to do?  Probably the 
> > latter.
> 
> Agreed, but that doesn't affect functionality.  We can get the desired
> functionality without the cancel_work() patch and then optimize things along
> with that patch.  This way it'll be easier to demontrate the benefit of it.

Good idea.

> That almost entirely depends on the bus type.  For PCI and probably PNP as well
> there's a notion of ACPI low power states and there are AML methods to put the
> devices into these states.  Unfortunately, the ACPI low power state to put the
> device into depends on the target sleep state of the system, so these devices
> will probably have to be put into D0 before system suspend anyway.
> 
> I think that the bus type can handle this as long as it knows the state the
> device is in before system suspend.  So, the only thing the core should do is
> to block the execution of run-time PM framework functions during system
> sleep and resume.  The state it leaves the device in shouldn't matter.
> 
> So, I think we can simply freeze the workqueue, set the 'disabled' bit for each
> device and wait for all run-time PM operations on it in progress to complete.
> 
> In the 'disabled' state the bus type or driver can modify the run-time PM
> status to whatever they like anyway.  Perhaps we can provide a helper to
> change 'request type' to RPM_REQ_NONE.

The only modification that really makes sense is like you said, going
back to full power in preparation for the platform suspend operation.  
Therefore perhaps we should allow pm_runtime_resume to work even when
rpm_disabled is set.  And if we're going to cancel pending suspend and
idle requests, then rpm_request would normally be RPM_REQ_NONE anyway.

Which leaves only the question of what to do when a resume request is 
pending...

> So, I guess we have the majority of things clarified and perhaps its time to
> write a patch for further discussion. :-)

Go ahead!

Alan Stern

