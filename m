Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbXKFP6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbXKFP6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 10:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbXKFP6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 10:58:13 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41612 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbXKFP6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 10:58:12 -0500
Subject: Re: device struct bloat
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, Oliver Neukum <oneukum@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, apw <apw@shadowen.org>,
       Ingo Molnar <mingo@elte.hu>, linux-usb-devel@lists.sourceforge.net
In-Reply-To: <Pine.LNX.4.44L0.0711061021390.3883-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0711061021390.3883-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Tue, 06 Nov 2007 16:58:04 +0100
Message-Id: <1194364684.6289.40.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-06 at 10:36 -0500, Alan Stern wrote:

> > > Would it be possible to break at the second scan, that is the device
> > > probe and stick that into a workqueue or something. Then we'd only ever
> > > have driver->device nesting.
> > 
> > Alan and Oliver have done some work in this area I think, combined with
> > the suspend/bind/unbind issues.  I'll let them comment on your patch :)
> 
> I gather the idea is to convert dev->sem to a mutex.  This idea had 
> occurred to me a long time ago but I didn't pursue it because of the 
> sheer number of places where dev->sem gets used

That should never stop us from doing the right thing :-), also dev->sem
isn't used nearly as much as for example work_struct which was changed.

> , not to mention the lockdep problems.

Right, that is the only sort-of valid reason this has not been done yet.

> You can't possibly solve the lockdep problems here with a simple-minded
> approach like your DRIVER_NORMAL, DRIVER_PARENT, etc.  The device tree
> is arbitrarily deep & wide, and there is at least one routine that
> acquires the semaphores for _all_ the devices in the tree. 

*blink* someone needs to take all locks - why?

>  This fact
> alone seems to preclude using lockdep for device locks.  (If there was 
> a form of mutex_lock() that bypassed the lockdep checks, you could use 
> it and avoid these issues.)

I'm sceptical of this, since its a simple tree (as opposed to a balanced
tree) a simple lock-coupling approach should be enough to guarantee
consistency.

> Deadlock is a serious consideration.  For the most part, routines 
> locking devices do so along a single path in the tree.  For this simple 
> case the rule is: Never acquire a parent's lock while holding the 
> child's lock.

Sure, but once you have a parent's lock, you could unlock your
grandparent, no? (it having a locked child, your parent, should be
enough to guarantee its continued existence)

> The routine that locks all the devices acquires the locks in order of 
> device registration.  The idea here is that children are always 
> registered _after_ their parents, so this should be compatible with the 
> previous rule.  But there is a potential problem: device_move() can 
> move an older child under a younger parent!

Seems like a weird rule, a typical tree locking rule would be to lock
them top-down - such a rule can easily cope with moves: lock old parent,
lock child, lock new parent, move child, unlock all in reverse order.

> Right now we have no way to deal with this.  There has been some 
> discussion of reordering the dpm_active list when a device is moved, 
> but so far nothing has been done about it.

Like said, I think the tree locking model should be revisited. A
top-down locking model with lock-coupling should, from my ignorant
perspective, solve your problems.


