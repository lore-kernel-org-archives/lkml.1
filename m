Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbZHLOyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbZHLOyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 10:54:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbZHLOyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 10:54:07 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49376 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753326AbZHLOyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 10:54:06 -0400
Date: Wed, 12 Aug 2009 10:54:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
In-Reply-To: <1250085710.4000.8.camel@mulgrave.site>
Message-ID: <Pine.LNX.4.44L0.0908121034150.2955-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Aug 2009, James Bottomley wrote:

> > + * Use of this function is discouraged, as it is highly prone to deadlock.
> > + * It should never be called from within a work routine on the global
> > + * queue, and it should never be called while holding a mutex required
> > + * by one of the works on the global queue.  But the fact that keventd_wq
> > + * _is_ global means that it can contain works requiring practically any
> > + * mutex.  Hence this routine shouldn't be called while holding any mutex.
> 
> I really don't see why this should be "discouraged".  It has exactly the
> same entangled deadlock problems as a lot of other functions like
> wait_event().

In this case the problems tend to be worse, because all the items on
the workqueue are involved.  Any one of them could cause a deadlock.

With wait_event(), the interaction generally involves only one other
logical flow of control -- the one that ends up signalling the
waitqueue.  But with flush_scheduled_work() the interaction involves
everything on the workqueue, even items not at all related to event
being waited for.

In short, it's a lot easier to fall into this trap with
flush_scheduled_work() than with wait_event().  That's why using the
function is discouraged.


> > + * Consider using cancel_work_sync() or cancel_delayed_work_sync() instead.
> > + * They don't do the same thing (they cancel the work instead of waiting
> > + * for it to complete), but in most cases they will suffice.
> > + */
> 
> And this is wrong advice.  If you've violated the entangled deadlock
> rules, the cancel functions will deadlock on you as well if the work is
> still pending.

No they won't.  They will remove the work item from the workqueue right
away, without blocking, assuming it hasn't started yet (i.e., is still 
pending).  This is a large part of their raison d'etre.

>  The other problem is that cancellation is a completely
> different operation from flushing.  Flush is usually used in driver
> shutdown routines to complete all outstanding tasks before going away.

I disagree.  In practice, flush is usually used in driver shutdown
routines to insure that there are no outstanding tasks before going
away.  Whether the tasks run to completion or are cancelled doesn't
matter to the driver, so long as they don't remain outstanding.

> Cancel wouldn't really have the same effect since the tasks may never
> get done.

That's what I wrote in the kerneldoc.  You're agreeing with me!  It's a
miracle!  :-)


> The final problem with this is that it creates a dichotomy between this
> function, which is simply a wrapper for flush_workqueue() on the
> keventd_wq and flush_workqueue().  flush_workqueue() has no scary
> warnings, so are we trying to encourage driver writers all to create
> their own workqueues for everything and declaring the global kernel
> workqueue useless?

Sometimes creating a private workqueue is appropriate, but usually it
isn't.  The kerneldoc isn't meant to warn writers away from using the
global workqueue; it's meant only to warn them away from
flush_scheduled_work().  It's perfectly possible to use one without the
other -- especially if you can substitute cancel_work_sync().

>  Or are we saying flushing workqueues is always bad
> and we just haven't got around to updating the documentation on
> flush_workqueue()?

That's a good point.  It might be worthwhile bringing it up in the
kerneldoc.

With private workqueues, the writer has much more control over the work 
items added to the queue.  It's feasible to audit the code and verify 
that none of them will cause flush_workqueue() to deadlock.  With the 
global workqueue this isn't feasible.  Hence the dichotomy.

Alan Stern

