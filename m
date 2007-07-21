Return-Path: <linux-kernel-owner+w=401wt.eu-S937694AbXGUOKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937694AbXGUOKu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 10:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757843AbXGUOKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 10:10:40 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3454 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1763707AbXGUOKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 10:10:39 -0400
Date: Sat, 21 Jul 2007 10:10:38 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: david@lang.hm
cc: Jeremy Maitin-Shepard <jbms@cmu.edu>, Milton Miller <miltonm@bga.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ying Huang <ying.huang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Re: Hibernation considerations
In-Reply-To: <Pine.LNX.4.64.0707201540260.5166@asgard.lang.hm>
Message-ID: <Pine.LNX.4.44L0.0707210956320.8201-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007 david@lang.hm wrote:

> > How would you prevent tasks from being scheduled?  How would you
> > prevent drivers from deadlocking because in order to put their device
> > in a low-power state they need to acquire a lock which is held by a
> > user task?
> 
> you give up on the suspend becouse you have no way of getting the user 
> task to give up the lock.

Once the deadlock has occurred it's too late.  You can't give up; in 
fact you can't do anything at all.  The system has hung.

> however, kernel locks should not be held by user tasks, user tasks are not 
> expected to behave in rational ways, allowing them to compete with kernel 
> tasks for locks is a sure way to get a deadlock or indefinate stall.

What on Earth are you talking about?  "Kernel locks should not be held 
by user tasks"?  Then who _should_ hold them?  You are aware, I hope, 
that down() and mutex_lock() can be called only in process context?

> what locks are accessed this way?

Lots of them.  For example, most drivers won't want a suspend to occur
right in the middle of an I/O transfer.  To prevent this, the driver
might use a mutex.  The task doing the I/O (which will be a user task)
acquires the mutex during a transfer and the suspend routine acquires
the mutex while quiescing the device.

> >> Does it really (fundamentally) require scheduling tasks, particularly in
> >> the case that the devices have already been put in the "quiesced" state?
> >
> > I can't say for sure.  That's the way we have been doing it.  It
> > wouldn't be easy to change, because the driver would have to busy-wait
> > during delays -- which would mean it would need to use different code
> > for system-wide suspend and runtime suspend.
> 
> please define terms so that we are all on the same page

Please read Documentation/power/devices.txt.

> what do you mean by
> system-wide suspend

That's what you would call standby, suspend-to-RAM, or hibernate.  The
entire system goes to sleep.

> runtime suspend

That's when an individual device is placed in a low-power state to 
save energy while it isn't being used.  The system as a whole remains 
awake and the device will be resumed the next time it is needed for 
anything.

Alan Stern

