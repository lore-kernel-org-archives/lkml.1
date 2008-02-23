Return-Path: <linux-kernel-owner+w=401wt.eu-S1761067AbYBWEjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761067AbYBWEjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 23:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbYBWEjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 23:39:17 -0500
Received: from netrider.rowland.org ([192.131.102.5]:3955 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751684AbYBWEjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 23:39:17 -0500
Date: Fri, 22 Feb 2008 23:39:15 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
In-Reply-To: <200802230230.04466.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0802222310380.4478-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Feb 2008, Rafael J. Wysocki wrote:

> Unfortunately, I missed your Bugzilla comment at
> http://bugzilla.kernel.org/show_bug.cgi?id=10030#c28

Strange...  But obviously you did see it eventually.

> Well, in the face of it, I'm considering to remove the code that
> acquires device semaphores from the suspend core for now.  Evidently, this
> change turns out to be painfully premature.

I wonder if that's really the best thing.  How would we then learn 
about drivers trying to register or unregister a device during a sleep 
transition?

Do you think it might be possible instead to somehow allow these
unregistrations to go through, while still failing or blocking
registrations?  It shouldn't be too hard to modify the driver core so
that it calls the driver's remove() method without trying to acquire
dev->sem if your in_suspend_context() test succeeds.

I have to admit, I still don't understand what's going on with the MMC 
driver.  Why is there a workqueue involved?  If the workqueue fails to 
unregister the device, why should it bother the suspend routine?  After 
all, if the suspend routine can afford to wait for the workqueue to 
finish then it could just as well afford to do the unregistration 
itself.

> Also, we have apparent problems with pm_sleep_lock()
> being take in device_add() (see
> http://bugzilla.kernel.org/show_bug.cgi?id=9874).

We'll have to get more information from the bug reporter to figure out 
what really happened there.

Ultimately it may turn out some drivers just aren't very careful about
when they try to register new devices.  Doing the registration by way
of a workqueue can be problematic if the workqueue happens to run
during a system sleep transition.  That will still be true if you
revert the acquire-all-semaphores patch.

Alan Stern

