Return-Path: <linux-kernel-owner+w=401wt.eu-S1757293AbXGEAYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbXGEAYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 20:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756609AbXGEAXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 20:23:44 -0400
Received: from ozlabs.org ([203.10.76.45]:46606 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756297AbXGEAXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 20:23:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18060.14856.824473.325660@cargo.ozlabs.ibm.com>
Date: Thu, 5 Jul 2007 10:23:36 +1000
From: Paul Mackerras <paulus@samba.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
 RAM pathway
In-Reply-To: <Pine.LNX.4.44L0.0707041045150.25704-100000@netrider.rowland.org>
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com>
	<Pine.LNX.4.44L0.0707041045150.25704-100000@netrider.rowland.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern writes:

> Let's agree the kernel threads and the freezer are a separate issue.  

No, I don't think they are a separate issue, because I think the
distinction the freezer makes between kernel threads and user threads
is a false and misleading distinction.

> In the most recent kernels, the freezer does not suspend kernel threads 
> by default.

And therefore doesn't guarantee that drivers won't get I/O requests
after being suspended, as far as I can see...

> I agree the kernel threads which try to do I/O during a suspend will 
> need extra attention.  However if these threads are necessary for the 
> suspend procedure, then blocking them (which is how people on this 
> thread have been saying driver should treat I/O requests during a 
> suspend) will cause additional problems.  There's no way around it; 
> these threads _will_ require more work.

There is a way around it; do the request blocking in the drivers,
where it belongs.

> > > The reasons why the PPC people dislike the whole idea aren't clear to
> > > me. 
> > 
> > Our experience is that it isn't necessary.  It's extra code that in
> > practice causes deadlocks and added maintenance burden for no
> > discernable benefit.
> 
> I have discussed the benefits elsewhere.  As for the deadlocks -- do 
> you still observe them if you use the version of the freezer which 
> doesn't freeze kernel threads?

In general the only way to guarantee there are no deadlocks is to
construct the graph of dependencies between tasks.  Those dependencies
are not in practice observable from outside the tasks, so it is
virtually impossible to construct the graph.

The "don't freeze kernel threads" thing is an attempt to make a crude
approximation to the dependency graph (by saying kernel threads only
depend on other kernel threads), but the approximation breaks down
when you have FUSE or user-level device drivers.

> Userspace cannot do I/O directly on its own, apart from some
> exceptional situations where a privileged task directly twiddles some
> I/O ports or the equivalent.

Userspace can be involved in servicing I/O requests; not just FUSE,
but also user-level nfsd and user-level PPP demonstrate that.

> There remains the problem of user tasks whose assistance is required to 
> carry out some I/O (as with FUSE).  If the I/O can be deferred until 
> after the resume, then there's no problem.  If the I/O can be carried 
> out before the suspend, then it should be.  And finally, if the I/O 
> must be done during the suspend, you're in real trouble -- how do you 
> do I/O to a suspended device?

So why doesn't that argument apply to kernel threads? :)

> > I remain convinced that the right approach is to fix the drivers to do
> > one of two things; either do something in the suspend call to block
> > further requests to the device, or use a late-suspend call to put
> > their device into a low-power state.  Of course, correctly-written
> > frameworks can do a lot to help the chipset drivers here.
> 
> The first alternative is a possibility.  My argument all along has been 
> that it is difficult and error-prone, and it adds more overhead to 
> system operation (even when not suspending!) than simply freezing 
> userspace.

It does actually provably solve the problem though, which is more than
the freezer does.

Paul.
