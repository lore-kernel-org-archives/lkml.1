Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbZFVPBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbZFVPBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbZFVPBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:01:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44852 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753108AbZFVPBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:01:33 -0400
Date: Mon, 22 Jun 2009 11:01:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Oliver Neukum <oliver@neukum.org>, Magnus Damm <magnus.damm@gmail.com>,
       <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: [patch update 3] PM: Introduce core framework for run-time PM
 of I/O devices
In-Reply-To: <200906211446.26019.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0906221017420.3081-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Jun 2009, Rafael J. Wysocki wrote:

> > Sorry, what I meant was that in each case the counter should be
> > {inc,dec}remented if a new request had to be queued.  If one was
> > already queued then the counter should be left alone.
> > 
> > The reason behind this is that a bunch of pm_request_suspend calls
> > which all end up referring to the same workqueue item will result in a
> > single async call to the runtime_suspend method.
> 
> Yes, that's why only the first one results in queuing up a request.
> 
> There is a problem with that if the later calls are supposed to use shorter
> delays, but I have no real idea to handle this cleanly.

Nor do I.  When the time-of-last-use and delay fields are implemented, 
this should never arise.

> > Therefore they should cause a single decrement of the counter.  Likewise for
> > pm_request_resume.
> 
> Hmm.  Why exactly do you think it's necessary to decrease the usage counter
> in suspend functions?  You can't suspend a device more than once and you have
> to resume it at the first request anyway.
> 
> I think it makes sense to increase the usage counter on every attempt to
> resume, even if the device is not woken up as a result, because that means the
> caller wants the device not to be suspended until the counter is decreased.
> This way, even if the device is already active, multiple callers can prevent it
> from suspending by calling pm_request_resume_get() or pm_runtime_resume_get()
> and then dropping the references.

Again, this boils down to how drivers decide to use the async 
interface.  I can see justifications for both pm_request_resume_get 
(which would always increment the counter) and pm_request_resume (which 
would increment the counter only if a work item had to be queued).  And 
of course, synchronous pm_runtime_resume should always increment the 
counter.

> Now, we can also make pm_request_suspend() and pm_runtime_suspend() drop
> the usage counter (if it's greater than zero), but that implies a usage model
> in which a resume function called when I/O is started should be balanced with a
> suspend function called after the I/O has been finished.
> 
> However, I'd prefer a usage model in which ->runtime_idle() is called when the
> I/O is finished and the usage counter is zero and it decides whether to call a
> suspend function.
> 
> So, perhaps I should make resume functions increase the usage counter
> unconditionally and introduce pm_runtime_idle() to be called when the I/O is
> done?  That is, pm_runtime_idle() will decrement the usage counter, check if
> it's zero and call ->runtime_idle() when that's the case (well, this is what
> pm_runtime_put_notify() does right now, but maybe the name is wrong).

Maybe it should just be called pm_runtime_put.  There could be a
separate pm_runtime_idle that doesn't decrement the counter but invokes
the callback if the counter is already 0.  (This could be useful after
a runtime_resume method returned -EBUSY.)

> Also, there should be a function to use when it's only necessary to drop the
> usage counter, without calling ->runtime_idle() (for example, if another code
> path is supposed to call a suspend function directly).

I don't see any reason for that.  It says: "The device isn't in use any
more, but even though we support autosuspend we aren't going to try to
suspend it now."  What's the point?  And as for the other code path, if
the device is already suspended when it calls the suspend function
directly, there's no harm done.

Alan Stern

