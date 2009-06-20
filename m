Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbZFTCeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbZFTCeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 22:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbZFTCeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 22:34:07 -0400
Received: from netrider.rowland.org ([192.131.102.5]:56235 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750838AbZFTCeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 22:34:06 -0400
Date: Fri, 19 Jun 2009 22:34:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Oliver Neukum <oliver@neukum.org>, Magnus Damm <magnus.damm@gmail.com>,
       <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: [patch update 2 fix] PM: Introduce core framework for run-time
 PM of I/O devices
In-Reply-To: <200906200042.10696.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0906192141380.4003-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Jun 2009, Rafael J. Wysocki wrote:

> I think we can grab a reference when queuing up a resume request and drop
> it on the completion of it.  This way, suspend will be locked while we're
> waiting for the resume to run, which I think is what we want.

But suspend is already blocked from the time a resume request is queued 
until the resume completes, unless the suspend was underway when the 
request was made.  So that doesn't seem to make sense.

This really all depends on how drivers use async autoresume.  Here's 
one possible way they could be written:

irq_handler() {
	status = pm_request_resume();
	if (status indicates the device is currently resumed)
		handle_the_IO();
	else
		save_the_IO();
}

runtime_resume_method() {
	handle_saved_IO();
	pm_request_suspend();	/* Could call pm_notify_idle instead */
}

The implications of this design are:

	pm_request_resume should return one code if the status already
	is RPM_WAKE and a different code if the resume request had to
	be queued (or one was already queued).

	pm_request_suspend should run very quickly, since it will be
	called after every I/O operation.  Likewise, pm_request_resume
	should run very quickly if the status is RPM_ACTIVE or 
	RPM_IDLE.

	In order to prevent autosuspends from occurring while I/O is
	in progress, the pm_request_resume call should increment the
	usage counter (if it had to queue the request) and the 
	pm_request_suspend call should decrement it (maybe after
	waiting for the delay).


> OK, I think I'll try to do the counting, although it may be difficult to handle
> all of the corner cases.

No, I agree it's not worth worrying about for now.  It can always be 
added later.


> > > > There might be some obscure other reason, but in general depth going
> > > > to 0 means a delayed autosuspend request should be queued.
> > > 
> > > OK there, but pm_runtime_disable() is called by the core in some places where
> > > we'd rather not want the device to be suspended (like during a system-wide
> > > power transitions).
> > 
> > I'm not sure what you mean.  I was talking about pm_runtime_enable
> > (which decrements depth), not pm_runtime_disable (which increments it).  
> > When pm_runtime_enable finds that depth has gone to 0, it should queue
> > a delayed autosuspend request.
> 
> OK, but I don't think that queuing a request without notifying the bus type is
> the right thing to do.  IMO it's better to use ->runtime_idle() in that case
> (in analogy with the situation in which the last child of a device has been
> suspended).

Agreed.


> > Autosuspend is disallowed if:
> > 
> > 	the driver doesn't support autosuspend;
> > 
> > 	the usage counter is > 0;
> > 
> > 	autosuspend has been disabled for this device;
> > 
> > 	the driver requires remote wakeup during autosuspend
> > 	but the user has disallowed wakeup.
> 
> That's probably universal for all bus types and devices.

Probably.  But you haven't provided a way for the driver to indicate 
that it requires wakeup.  It's not a big deal, since the 
runtime_suspend method can do its own checking.

> > If everything else is okay but not enough time has elapsed since the
> > device was last used, another delayed autosuspend request is queued and
> > the current one fails with -EAGAIN.
> 
> I wouldn't like to do the automatic queuing at the core level, simply because
> the core may not have enough information to make a correct decision.

Calling the notify_idle method would be good enough.

> > The model for asynchronous operation is that the usage counter remains
> > always at 0, and the driver updates the time-of-last-use field whenever
> > an I/O operation starts or completes.  The core keeps a delayed
> > autosuspend request queued; each time the request runs it checks
> > whether the device has been idle sufficiently long.  If not it
> > requeues itself; otherwise it carries out an autosuspend.
> 
> Again, I think it's a bus type's decision whether or not to use such a
> "permanent" suspend request.

Ironically, this model is different from the one I outlined above.  
There's more than one way to do this, it's not clear which is best, and 
AFAIK none of them have been implemented in a real driver yet.

> I think it probably is a good idea to store the time of last use in 'struct
> device', so that bus types don't need to duplicate that field (all of them will
> likely use it).  I'm not sure about the delay, though.  Well, I need some time
> to think about it. :-)

All bus types will want to implement _some_ delay; it doesn't make
sense to power down a device immediately after every operation and then
power it back up for the next operation.

But the time scales of the delays may vary widely.  Some devices might 
be able to power up in a millisecond or less; others will require 
seconds.  The delays should be set accordingly.

Alan Stern

