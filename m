Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbXGGCr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbXGGCr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 22:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbXGGCrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 22:47:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:52324 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492AbXGGCrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 22:47:48 -0400
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
	RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Miklos Szeredi <miklos@szeredi.hu>, pavel@ucw.cz, paulus@samba.org,
       johannes@sipsolutions.net, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org
In-Reply-To: <200707061131.08475.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0707051713440.2753-100000@iolanthe.rowland.org>
	 <200707060913.24131.rjw@sisk.pl>
	 <1183712354.3388.126.camel@localhost.localdomain>
	 <200707061131.08475.oliver@neukum.org>
Content-Type: text/plain
Date: Sat, 07 Jul 2007 12:44:45 +1000
Message-Id: <1183776285.3388.201.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-06 at 11:31 +0200, Oliver Neukum wrote:
> Am Freitag, 6. Juli 2007 schrieb Benjamin Herrenschmidt:
> > On Fri, 2007-07-06 at 09:13 +0200, Rafael J. Wysocki wrote:
> > > 
> > > The only reason (I know of) why we don't handle uninterruptible tasks in the
> > > freezer is that we're afraid of the suspend process deadlocking with an
> > > uninterruptible task holding a lock, but AFAICS the probability of such an
> > > event is extremely small.
> > 
> > What would deadlock specifically ? One of the drivers trying to acquire
> > that lock ? It would be a driver bug then.
> 
> Your driver's write method looks like:
> 
> mutex_lock();
> poke_some_hardware();
> wait_event_uninterruptible(); //for result
> res = evaluate_result();
> mutex_unlock();
> return res;
> 
> If you put a task into the refrigerator at wait_event_interruptible()
> you will deadlock if you need this lock for the driver to go to suspend.
> The suspend method then must not take the lock _and_ it must be
> aware that there may be an ongoing operation.

Well... 2 things here. Either you have a freezer in which case the
chances of the above scenario are increased, or you don't, in which case
your suspend method will just sleep on the lock until outstanding HW
accesses that have that lock are completed, and everything is fine.

You need to be careful with one thing though, whether you have a freezer
or not. If you driver, in some code path, whatever it is (ioctl, kernel
thread, workqueue, ...) does something like:

mutex_lock
kmalloc(...,GFP_KERNEL);
mutex_unlock

And it's suspend callback then does:

mutex_lock

The problem here is that the disks might already have been suspended
prior to your driver being called. Thus, any attempt at pushing things
out to swap or dirty mmap'ings back to storage will hang, thus kmalloc
can potentially hang (afaik), and you will deadlock.

That's what I've been talking about earlier when I said that we should
have some security in SLAB/SLUB/Buddy allocators, to silently turn
GFP_KERNEL to at least GFP_NOIO or even ATOMIC before we start
suspending drivers.

Now, another way to deal with that would have to use
pre-suspend/post-resume notifications, and have drivers avoid doing the
above between those, but that's much harder. (Essentially, drivers would
have to either make sure they don't do things like blocking allocations,
even implicitely, or possibly fall back to a degraded synchronous mode
or that sort of thing).

I think it's much simpler to tweak slab/slub/buddy instead :-)

Note that the above issue is orthogonal to our freezer discussion, it's
just one of the potential deadlock cause we have with suspend that needs
to be fixed.

Cheers,
Ben.


