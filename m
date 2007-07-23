Return-Path: <linux-kernel-owner+w=401wt.eu-S935536AbXGWUYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935536AbXGWUYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935410AbXGWUWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:22:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56493 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S935315AbXGWUWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:22:31 -0400
Date: Mon, 23 Jul 2007 16:22:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: david@lang.hm
cc: Jeremy Maitin-Shepard <jbms@cmu.edu>, Milton Miller <miltonm@bga.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ying Huang <ying.huang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Re: Hibernation considerations
In-Reply-To: <Pine.LNX.4.64.0707231121220.3828@asgard.lang.hm>
Message-ID: <Pine.LNX.4.44L0.0707231605410.2556-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007 david@lang.hm wrote:

> > For one thing, checking for a suspend-in-progress at the beginning of
> > each and every system call would add overhead to a hot path in the
> > kernel, one which is already very heavily optimized.  People wouldn't
> > stand for it.
> 
> I thought that the suspend stuff did this easily,

It does not do it at all.  Do you know how the freezer works?

>  but the freezer really 
> starts running into trouble when it wants to freeze some things, but not 
> other things. this seems to be the biggest area of churn and problems.

No.  The freezer starts running into trouble when it wants to freeze a
thread but can't, because that thread is waiting for some event to
occur and the only thread which can cause the event is already frozen.  
Or is itself waiting for a third thread which is already frozen...

> > You get similar problems from system calls that wait in kernel mode
> > until something has happened.  For example, a read() call for the
> > console device will wait until somebody types on the keyboard.  At any
> > point in time, many (or even most) user threads are blocked in a system
> > call.
> 
> but are locks held while they are blocked like this?

Sometimes they are, sometimes they aren't.

> > Let's let kernel K1 be the original kernel, the one which is going into
> > hibernation.  Kernel K2 is the one started by kexec to write out the
> > memory image.
> >
> > Your question becomes: Why should K2 jumping back to K1 cause K1
> > immediately to start running user tasks?  Answer: Because K1 has been
> > running user tasks all along (except while K2 was active) and nothing
> > has told it to stop.  In fact, about the only things which _can_ cause
> > K1 to stop running user threads are the freezer (which you want to
> > eliminate) and disabling interrupts (not possible since some drivers
> > require interrupts to be enabled when putting devices in low-power
> > mode).
> 
> when you jump to a body of code you jump to a specific point in the code, 
> not to some nebulous 'everything running' state.

How is that relevant?  When K2 jumps back to K1, it jumps to some 
designated location in K1.  It might just after the place where K1 
called K2; I'm not familiar with the details of kexec.  In any event, 
K1 will still be in the same state as it was when it called K2.

> > So when K2 starts up, it will have a phase in which user threads don't
> > run.  That doesn't affect K1.  When K2 returns to K1, K1 does not go
> > through this sort of phase.  It simply picks up from where it left off.
> 
> then how can it restart drivers before the user threads need them?

It can't.  Indeed, in the absence of a freezer, user threads will need 
devices (more accurately, will submit I/O requests for devices) that 
have to be kept quiescent or low-power.  Drivers will need to delay 
those requests until the devices are returned to full operation.

That's exactly what I've been saying all along: Drivers will need to 
be changed to delay I/O requests, if there is no freezer.

> > However there still remains the problem of user tasks running after
> > devices are supposed to be quiescent and before K1 starts.  There's
> > currently nothing to stop such tasks from making I/O requests and
> > thereby causing a quiescent device to become active again.
> 
> but if the devices are in low power mode then K1 needs to get them out of 
> low power mode before user tasks try to access them.

No -- which is good because it can't.  If a user task is running
there's no way to stop it from submitting I/O requests.  K1 needs to
delay these requests until after the device has returned to full 
operation.

> > We aren't talking about drivers initializing devices.  We are talking
> > about what happens during the time when drivers are trying to quiesce
> > devices (i.e., before K1 has started up K2) or power them down (after
> > K2 has returned to K1).
> 
> or if you are doing a resume instead of a suspend to ram the drivers need 
> to initialize or otherwise move to full power on K1 before user tasks hit 
> them.

Correct.  User tasks are allowed to submit requests, but the requests 
can't be carried out until the device returns to full operation.

Alan Stern

