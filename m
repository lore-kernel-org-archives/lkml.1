Return-Path: <linux-kernel-owner+w=401wt.eu-S1761431AbXGDO5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761431AbXGDO5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 10:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbXGDO5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 10:57:15 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4213 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753816AbXGDO5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 10:57:15 -0400
Date: Wed, 4 Jul 2007 10:57:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Paul Mackerras <paulus@samba.org>
cc: Johannes Berg <johannes@sipsolutions.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
 RAM pathway
In-Reply-To: <18059.10554.955290.148535@cargo.ozlabs.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0707041045150.25704-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jul 2007, Paul Mackerras wrote:

> Alan Stern writes:
> 
> > I disagree.  The problem isn't the kernel calling userspace; it's
> > userspace trying to do I/O at a time when everything is supposed to be
> > quiescing.  Detecting that and blocking it in drivers is hard and
> > error-prone; preventing it by freezing userspace is easy and cheap.
> 
> And unreliable, and prone to deadlocks, and invasive - requiring
> changes to kernel threads that have nothing to do with drivers or
> suspend/resume.

Let's agree the kernel threads and the freezer are a separate issue.  
In the most recent kernels, the freezer does not suspend kernel threads 
by default.

I agree the kernel threads which try to do I/O during a suspend will 
need extra attention.  However if these threads are necessary for the 
suspend procedure, then blocking them (which is how people on this 
thread have been saying driver should treat I/O requests during a 
suspend) will cause additional problems.  There's no way around it; 
these threads _will_ require more work.

> > The reasons why the PPC people dislike the whole idea aren't clear to
> > me. 
> 
> Our experience is that it isn't necessary.  It's extra code that in
> practice causes deadlocks and added maintenance burden for no
> discernable benefit.

I have discussed the benefits elsewhere.  As for the deadlocks -- do 
you still observe them if you use the version of the freezer which 
doesn't freeze kernel threads?

> The freezer doesn't achieve its stated goal of preventing drivers from
> getting I/O requests after suspend, since kernel threads can (and do)
> initiate I/O.  So then we say that some kernel threads need to be
> frozen and others don't, but making that decision is difficult and
> error-prone.

No -- we say that the kernel threads which generate I/O requests during 
suspend need to be changed.

> In fact I believe that making a distinction between user and kernel
> threads is wrong and likely to lead to problems, since userspace can
> be involved in doing I/O (e.g. FUSE or the user-space driver
> framework).  So the argument of the previous paragraph also applies to
> some userspace processes.

Userspace cannot do I/O directly on its own, apart from some
exceptional situations where a privileged task directly twiddles some
I/O ports or the equivalent.

There remains the problem of user tasks whose assistance is required to 
carry out some I/O (as with FUSE).  If the I/O can be deferred until 
after the resume, then there's no problem.  If the I/O can be carried 
out before the suspend, then it should be.  And finally, if the I/O 
must be done during the suspend, you're in real trouble -- how do you 
do I/O to a suspended device?

> I remain convinced that the right approach is to fix the drivers to do
> one of two things; either do something in the suspend call to block
> further requests to the device, or use a late-suspend call to put
> their device into a low-power state.  Of course, correctly-written
> frameworks can do a lot to help the chipset drivers here.

The first alternative is a possibility.  My argument all along has been 
that it is difficult and error-prone, and it adds more overhead to 
system operation (even when not suspending!) than simply freezing 
userspace.

Alan Stern

