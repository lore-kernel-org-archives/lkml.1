Return-Path: <linux-kernel-owner+w=401wt.eu-S1761992AbXGDPMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761992AbXGDPMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 11:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758262AbXGDPM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 11:12:28 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4414 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757008AbXGDPM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 11:12:27 -0400
Date: Wed, 4 Jul 2007 11:12:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Paul Mackerras <paulus@samba.org>
cc: Johannes Berg <johannes@sipsolutions.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
 RAM pathway
In-Reply-To: <18059.6726.218205.104212@cargo.ozlabs.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0707041104140.25704-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jul 2007, Paul Mackerras wrote:

> Whether or not to resume a suspended device when an I/O request comes
> in is a policy decision, and there could be cases where the user wants
> I/O requests to be blocked, or to fail, or to be dropped while the
> device is suspended, even for runtime power management.  For example,
> a sound card could be suspended due to a low-battery condition, and in
> that case you would want the driver to just drop any data that
> userspace tries to write to the soundcard.

We have provisions for that (my earlier description was somewhat 
incomplete).

> > Yes, the code could be changed to keep track of the reason for a device
> > suspend.  But that just raises the old problem of what to do when
> > there's an I/O request for a suspended device during STR.
> 
> Is this actually a real problem?  I would think the policy would be
> "block" for block devices (pun not intended :), "drop" for network
> devices, etc.

It is indeed a real problem, or at least, it can be.

> > Consider a particularly troublesome case: During STR, a non-frozen task
> > writes to /sys/bus/BBB/drivers/DDD/bind.  The sysfs core grabs the
> > device semaphore and calls the driver's probe routine.  If the driver
> > isn't PM-aware it simply tries to initialize the device and fails
> > because the device is already suspended.  That's no good; it isn't
> > transparent.
> 
> How did the device get suspended if it didn't have a driver?  If it
> did have a driver, why didn't the bind attempt fail?

Bus subsystems can suspend devices with no drivers.

> Suppose the device-model core code simply blocked all bind and unbind
> requests while suspend is under way, until resume is finished.
> Wouldn't that solve the problem?

It would help.  It would help even more if the sysfs core also blocked
all I/O while suspend is under way.  (Although this might be tricky, 
considering that the suspend is initiated by a sysfs write...)

The fact remains that lots of drivers would still need to be changed.  
In the read and write methods someone would have to add code amounting
to this:

	if (suspend_is_under_way()) {
		mutex_unlock(...);
		block_until_resume();
		goto restart;
	}

Freezing userspace is a small amount of code by comparison.

Alan Stern

