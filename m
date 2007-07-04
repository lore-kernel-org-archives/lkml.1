Return-Path: <linux-kernel-owner+w=401wt.eu-S1755592AbXGDFED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbXGDFED (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 01:04:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756481AbXGDFDC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 01:03:02 -0400
Received: from ozlabs.org ([203.10.76.45]:37492 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbXGDFC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 01:02:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18059.6726.218205.104212@cargo.ozlabs.ibm.com>
Date: Wed, 4 Jul 2007 13:55:50 +1000
From: Paul Mackerras <paulus@samba.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
 RAM pathway
In-Reply-To: <Pine.LNX.4.44L0.0707031026260.3720-100000@iolanthe.rowland.org>
References: <1183472474.3722.13.camel@johannes.berg>
	<Pine.LNX.4.44L0.0707031026260.3720-100000@iolanthe.rowland.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern writes:

> USB already implements runtime PM.  If a device is suspended at runtime
> and a task tries to access it, the device is automatically resumed.  
> No problem there.
> 
> The problem comes when the system is doing a STR.  Right now the code
> doesn't keep track of the difference between a runtime suspend and a
> system suspend -- once the device is suspended, it's suspended, period.  

Whether or not to resume a suspended device when an I/O request comes
in is a policy decision, and there could be cases where the user wants
I/O requests to be blocked, or to fail, or to be dropped while the
device is suspended, even for runtime power management.  For example,
a sound card could be suspended due to a low-battery condition, and in
that case you would want the driver to just drop any data that
userspace tries to write to the soundcard.

> Yes, the code could be changed to keep track of the reason for a device
> suspend.  But that just raises the old problem of what to do when
> there's an I/O request for a suspended device during STR.

Is this actually a real problem?  I would think the policy would be
"block" for block devices (pun not intended :), "drop" for network
devices, etc.

> Consider a particularly troublesome case: During STR, a non-frozen task
> writes to /sys/bus/BBB/drivers/DDD/bind.  The sysfs core grabs the
> device semaphore and calls the driver's probe routine.  If the driver
> isn't PM-aware it simply tries to initialize the device and fails
> because the device is already suspended.  That's no good; it isn't
> transparent.

How did the device get suspended if it didn't have a driver?  If it
did have a driver, why didn't the bind attempt fail?

> So assume the driver is PM-aware.  It tries to resume the device, which
> fails because STR is underway.  Now what can it do?  There's only one 
> possibility: It must block until the resume call can succeed.  But when 
> is that?
> 
> It has to be before the PM core tries to resume the device, because the 
> core will try to acquire the device semaphore and will block waiting 
> for the probe call to complete.  But it has to be after the PM core 
> resumes the device's parent, because obviously the device can't resume 
> until its parent is awake.

Suppose the device-model core code simply blocked all bind and unbind
requests while suspend is under way, until resume is finished.
Wouldn't that solve the problem?

Paul.
