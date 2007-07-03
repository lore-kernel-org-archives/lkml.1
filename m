Return-Path: <linux-kernel-owner+w=401wt.eu-S1760275AbXGCPPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275AbXGCPPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 11:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758237AbXGCPO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 11:14:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45130 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758231AbXGCPO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 11:14:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Tue, 3 Jul 2007 17:22:12 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Paul Mackerras <paulus@samba.org>
References: <Pine.LNX.4.44L0.0707031026260.3720-100000@iolanthe.rowland.org> <1183474748.3722.33.camel@johannes.berg>
In-Reply-To: <1183474748.3722.33.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707031722.13165.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 3 July 2007 16:59, Johannes Berg wrote:
> On Tue, 2007-07-03 at 10:50 -0400, Alan Stern wrote:
> 
> > Time for me to jump in.
> 
> :)
> 
> > USB already implements runtime PM.  If a device is suspended at runtime
> > and a task tries to access it, the device is automatically resumed.  
> > No problem there.
> 
> Right.
> 
> > The problem comes when the system is doing a STR.  Right now the code
> > doesn't keep track of the difference between a runtime suspend and a
> > system suspend -- once the device is suspended, it's suspended, period.  
> > Consequently, a non-frozen user task trying to do I/O to a suspended
> > device during STR will cause that device to resume, thereby forcing the
> > system suspend to abort.  Something much like this has actually
> > happened and been reported as a bug on LKML (I don't have a URL handy,
> > and it was actually a non-frozen kernel thread interfering with
> > hibernate rather than a non-frozen user task interfering with STR, but
> > the principle is the same).
> 
> Yeah, I can see that happen.
> 
> > Yes, the code could be changed to keep track of the reason for a device
> > suspend.  But that just raises the old problem of what to do when
> > there's an I/O request for a suspended device during STR.
> > 
> > > I think the core of the discussion isn't appreciated by everybody here
> > > yet---we need to solve both run-time and suspend-to-ram-time device
> > > suspend, not just one of them.
> > 
> > Runtime suspend isn't a problem.  Only STR.
> 
> Ah but for all those character devices people were saying are the
> problem we haven't even solved runtime suspend as far as I can tell from
> the discussion.
> 
> > Consider a particularly troublesome case: During STR, a non-frozen task
> > writes to /sys/bus/BBB/drivers/DDD/bind.  The sysfs core grabs the
> > device semaphore and calls the driver's probe routine.  If the driver
> > isn't PM-aware it simply tries to initialize the device and fails
> > because the device is already suspended.  That's no good; it isn't
> > transparent.
> > 
> > So assume the driver is PM-aware.  It tries to resume the device, which
> > fails because STR is underway.  Now what can it do?  There's only one 
> > possibility: It must block until the resume call can succeed.  But when 
> > is that?
> > 
> > It has to be before the PM core tries to resume the device, because the 
> > core will try to acquire the device semaphore and will block waiting 
> > for the probe call to complete.  But it has to be after the PM core 
> > resumes the device's parent, because obviously the device can't resume 
> > until its parent is awake.
> > 
> > As you can see, this is a very difficult problem to solve.
> 
> Indeed. Actually, one could argue that it's impossible to solve the
> problem as long as we try to call out to userspace during suspend and
> need to wait until that's finished, like in the case of sys_sync() and
> fuse filesystems, and probably other cases. Maybe we should make *those*
> calls return a failure so that the suspend isn't transparent inside the
> kernel but is transparent to userspace.

Well, it generally needs more consideration. :-)

I think that we should introduce mechanisms that will allow us to notify all
kernel subsystems, including FUSE and similar, that the system is going to
enter a sleep state (one of those is the notifier chain introduced recently).

Then, they may react to such a notification by entering a "suspend" mode
of operation in which they will return errors from some callbacks that
otherwise should have succeeded etc.  That depends on the subsystem in
question.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
