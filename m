Return-Path: <linux-kernel-owner+w=401wt.eu-S1758777AbXGEAqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777AbXGEAqD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 20:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757489AbXGEAow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 20:44:52 -0400
Received: from ozlabs.org ([203.10.76.45]:57697 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756146AbXGEAos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 20:44:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18060.15144.986090.570992@cargo.ozlabs.ibm.com>
Date: Thu, 5 Jul 2007 10:28:24 +1000
From: Paul Mackerras <paulus@samba.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
 RAM pathway
In-Reply-To: <Pine.LNX.4.44L0.0707041057230.25704-100000@netrider.rowland.org>
References: <18059.7151.841436.329553@cargo.ozlabs.ibm.com>
	<Pine.LNX.4.44L0.0707041057230.25704-100000@netrider.rowland.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern writes:

> That's not what I'm saying.  What I'm saying is that it would be a big 
> mistake to force all drivers which implement runtime PM to do it using 
> a separate code path from system PM.

OK; I can accept that provided there is a way to change the "what to
do with an I/O request" policy from auto-resume to something else
while we're suspending the system (and presumably restore the old
policy on system resume if the device was runtime-suspended at the
point where the system was suspended).

> > The main attraction of the late-suspend call is that it really does,
> > reliably, guarantee that the driver's I/O request methods won't get
> > called between the late-suspend call and the early-resume call.
> 
> For some drivers (like USB), carrying out an actual suspend requires a
> delay.  Right now we implement those delays using wait_event(),
> wait_for_completion(), and so on.  Would you have us check at runtime
> whether or not a system suspend is underway and in each case use a
> busy-loop instead if it is?

No; the late suspend call isn't appropriate for all drivers.  It is a
simple and safe way to do the suspend for some drivers, mostly the
simpler ones.  Things that are complex enough to have a subsystem
(e.g. USB) would want to use the early suspend call.

> What happens if, in order to carry out the late-suspend, a driver needs
> to acquire a mutex which happens to be held by some other task?  That
> other task won't be able to run and release the mutex, so you will
> deadlock.

Then late-suspend is not appropriate for that driver, and it needs to
use the early-suspend call, and do something such as setting a flag
that the I/O request function tests.

Paul.
